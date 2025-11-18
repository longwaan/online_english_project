package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.constant.UserConstant;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.model.dto.studyrecord.StudyRecordAddRequest;
import com.exam.model.entity.StudyRecord;
import com.exam.model.entity.User;
import com.exam.model.vo.StudyRecordVO;
import com.exam.service.StudyRecordService;
import com.exam.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.HashMap;
import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

@RestController
@RequestMapping("/study_record")
@Api(tags = "学习记录接口")
@Slf4j
public class StudyRecordController {

    @Resource
    private StudyRecordService studyRecordService;

    @Resource
    private UserService userService;

    /**
     * 创建学习记录
     */
    @PostMapping("/add")
    @ApiOperation(value = "创建记录", notes = "创建新的学习记录")
    public BaseResponse<Long> addStudyRecord(@RequestBody @Valid StudyRecordAddRequest studyRecordAddRequest,
                                             HttpServletRequest request) {
        if (studyRecordAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        StudyRecord studyRecord = new StudyRecord();
        BeanUtils.copyProperties(studyRecordAddRequest, studyRecord);

        // 获取登录用户
        User loginUser = userService.getLoginUser(request);
        studyRecord.setUserId(loginUser.getId());

        studyRecordService.validStudyRecord(studyRecord, true);
        boolean result = studyRecordService.save(studyRecord);
        ThrowUtils.throwIf(!result, ErrorCode.OPERATION_ERROR);
        return ResultUtils.success(studyRecord.getId());
    }

    /**
     * 删除学习记录
     */
    @PostMapping("/delete")
    @ApiOperation(value = "删除记录", notes = "根据记录ID删除学习记录")
    public BaseResponse<Boolean> deleteStudyRecord(@RequestBody DeleteRequest deleteRequest,
                                                   HttpServletRequest request) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        long id = deleteRequest.getId();
        // 判断是否存在
        StudyRecord studyRecord = studyRecordService.getById(id);
        ThrowUtils.throwIf(studyRecord == null, ErrorCode.NOT_FOUND_ERROR);
        // 仅本人或管理员可删除
        if (!studyRecord.getUserId().equals(loginUser.getId()) && !userService.isAdmin(loginUser)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = studyRecordService.removeById(id);
        return ResultUtils.success(result);
    }

    /**
     * 更新学习进度
     */
    @PostMapping("/progress/{id}")
    @ApiOperation(value = "更新进度", notes = "更新学习进度")
    public BaseResponse<Boolean> updateProgress(@PathVariable long id, @RequestParam int progress,
                                                HttpServletRequest request) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        StudyRecord studyRecord = studyRecordService.getById(id);
        ThrowUtils.throwIf(studyRecord == null, ErrorCode.NOT_FOUND_ERROR);
        // 仅本人可更新
        if (!studyRecord.getUserId().equals(loginUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = studyRecordService.updateProgress(id, progress);
        return ResultUtils.success(result);
    }

    /**
     * 更新学习时长
     */
    @PostMapping("/time/{id}")
    @ApiOperation(value = "更新时长", notes = "更新学习时长")
    public BaseResponse<Boolean> updateStudyTime(@PathVariable long id, @RequestParam int studyTime,
                                                 HttpServletRequest request) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        StudyRecord studyRecord = studyRecordService.getById(id);
        ThrowUtils.throwIf(studyRecord == null, ErrorCode.NOT_FOUND_ERROR);
        // 仅本人可更新
        if (!studyRecord.getUserId().equals(loginUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = studyRecordService.updateStudyTime(id, studyTime);
        return ResultUtils.success(result);
    }

    /**
     * 更新考试得分
     */
    @PostMapping("/score/{id}")
    @ApiOperation(value = "更新得分", notes = "更新考试得分")
    public BaseResponse<Boolean> updateScore(@PathVariable long id, @RequestParam float score,
                                             HttpServletRequest request) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        StudyRecord studyRecord = studyRecordService.getById(id);
        ThrowUtils.throwIf(studyRecord == null, ErrorCode.NOT_FOUND_ERROR);
        // 仅本人可更新
        if (!studyRecord.getUserId().equals(loginUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = studyRecordService.updateScore(id, score);
        return ResultUtils.success(result);
    }

    /**
     * 根据ID获取学习记录
     */
    @GetMapping("/get")
    @ApiOperation(value = "获取记录", notes = "根据记录ID获取学习记录详情")
    public BaseResponse<StudyRecordVO> getStudyRecordById(@RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        StudyRecord studyRecord = studyRecordService.getById(id);
        if (studyRecord == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        StudyRecordVO studyRecordVO = studyRecordService.getStudyRecordVO(studyRecord);
        return ResultUtils.success(studyRecordVO);
    }

    /**
     * 分页获取当前用户的学习记录列表
     */
    @GetMapping("/my/list/page")
    @ApiOperation(value = "获取我的记录", notes = "分页获取当前用户的学习记录")
    public BaseResponse<Page<StudyRecordVO>> listMyStudyRecordByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize,
            HttpServletRequest request) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);

        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId());
        queryWrapper.orderByDesc("createTime");

        Page<StudyRecord> studyRecordPage = studyRecordService.page(new Page<>(current, pageSize), queryWrapper);

        // 转换为VO
        Page<StudyRecordVO> studyRecordVOPage = new Page<>(current, pageSize, studyRecordPage.getTotal());
        List<StudyRecordVO> studyRecordVOList = studyRecordPage.getRecords().stream()
                .map(studyRecordService::getStudyRecordVO)
                .collect(Collectors.toList());
        studyRecordVOPage.setRecords(studyRecordVOList);

        return ResultUtils.success(studyRecordVOPage);
    }

    /**
     * 分页获取学习记录列表（仅管理员）
     */
    @GetMapping("/list/page")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "获取记录列表", notes = "分页获取所有学习记录")
    public BaseResponse<Page<StudyRecordVO>> listStudyRecordByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.orderByDesc("createTime");

        Page<StudyRecord> studyRecordPage = studyRecordService.page(new Page<>(current, pageSize), queryWrapper);

        // 转换为VO
        Page<StudyRecordVO> studyRecordVOPage = new Page<>(current, pageSize, studyRecordPage.getTotal());
        List<StudyRecordVO> studyRecordVOList = studyRecordPage.getRecords().stream()
                .map(studyRecordService::getStudyRecordVO)
                .collect(Collectors.toList());
        studyRecordVOPage.setRecords(studyRecordVOList);

        return ResultUtils.success(studyRecordVOPage);
    }

    /**
     * 获取用户的词汇学习频率统计
     */
    @GetMapping("/vocabulary/frequency")
    @ApiOperation(value = "词汇频率", notes = "获取用户的词汇学习频率统计")
    public BaseResponse<List<Map<String, Object>>> getVocabularyFrequency(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        List<Map<String, Object>> result = studyRecordService.getVocabularyFrequency(loginUser.getId());
        return ResultUtils.success(result);
    }

    /**
     * 获取指定用户的词汇学习频率统计（仅管理员）
     */
    @GetMapping("/vocabulary/frequency/{userId}")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "用户词汇频率", notes = "获取指定用户的词汇学习频率统计")
    public BaseResponse<List<Map<String, Object>>> getVocabularyFrequencyByUserId(@PathVariable Long userId) {
        if (userId == null || userId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        List<Map<String, Object>> result = studyRecordService.getVocabularyFrequency(userId);
        return ResultUtils.success(result);
    }

    /**
     * 获取用户的学习时长统计
     */
    @GetMapping("/statistics/study-time")
    @ApiOperation(value = "学习时长统计", notes = "获取用户的学习时长统计信息")
    public BaseResponse<Map<String, Object>> getStudyTimeStatistics(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Map<String, Object> statistics = studyRecordService.getStudyTimeStatistics(loginUser.getId());
        return ResultUtils.success(statistics);
    }

    /**
     * 获取用户的学习进度统计
     */
    @GetMapping("/statistics/progress")
    @ApiOperation(value = "学习进度统计", notes = "获取用户的学习进度统计信息")
    public BaseResponse<Map<String, Object>> getProgressStatistics(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Map<String, Object> statistics = studyRecordService.getProgressStatistics(loginUser.getId());
        return ResultUtils.success(statistics);
    }

    /**
     * 获取用户的考试得分统计
     */
    @GetMapping("/statistics/score")
    @ApiOperation(value = "考试得分统计", notes = "获取用户的考试得分统计信息")
    public BaseResponse<Map<String, Object>> getScoreStatistics(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Map<String, Object> statistics = studyRecordService.getScoreStatistics(loginUser.getId());
        return ResultUtils.success(statistics);
    }

    /**
     * 获取用户的学习趋势（按时间）
     */
    @GetMapping("/statistics/trend")
    @ApiOperation(value = "学习趋势", notes = "获取用户的学习趋势统计信息")
    public BaseResponse<List<Map<String, Object>>> getStudyTrend(
            @RequestParam(required = false) String type,  // daily, weekly, monthly
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        List<Map<String, Object>> trend = studyRecordService.getStudyTrend(loginUser.getId(), type);
        return ResultUtils.success(trend);
    }

    /**
     * 按课程ID分页获取学习记录
     */
    @GetMapping("/list/course/{courseId}")
    @ApiOperation(value = "课程学习记录", notes = "获取指定课程的学习记录")
    public BaseResponse<Page<StudyRecordVO>> listStudyRecordByCourse(
            @PathVariable Long courseId,
            @RequestParam long current,
            @RequestParam long pageSize,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId())
                .eq("courseId", courseId)
                .orderByDesc("createTime");

        // 获取分页数据
        Page<StudyRecord> recordPage = studyRecordService.page(new Page<>(current, pageSize), queryWrapper);

        // 转换为VO
        Page<StudyRecordVO> recordVOPage = new Page<>(current, pageSize, recordPage.getTotal());
        List<StudyRecordVO> recordVOList = recordPage.getRecords().stream()
                .map(studyRecordService::getStudyRecordVO)
                .collect(Collectors.toList());
        recordVOPage.setRecords(recordVOList);

        return ResultUtils.success(recordVOPage);
    }

    /**
     * 按完成状态分页获取学习记录
     */
    @GetMapping("/list/status")
    @ApiOperation(value = "按状态获取记录", notes = "按完成状态分页获取学习记录")
    public BaseResponse<Page<StudyRecordVO>> listStudyRecordByStatus(
            @RequestParam String status,
            @RequestParam long current,
            @RequestParam long pageSize,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId())
                .eq("status", status)
                .orderByDesc("createTime");

        // 获取分页数据
        Page<StudyRecord> recordPage = studyRecordService.page(new Page<>(current, pageSize), queryWrapper);

        // 转换为VO
        Page<StudyRecordVO> recordVOPage = new Page<>(current, pageSize, recordPage.getTotal());
        List<StudyRecordVO> recordVOList = recordPage.getRecords().stream()
                .map(studyRecordService::getStudyRecordVO)
                .collect(Collectors.toList());
        recordVOPage.setRecords(recordVOList);

        return ResultUtils.success(recordVOPage);
    }

    /**
     * 获取词汇最近的学习记录ID
     */
    @GetMapping("/check/vocabulary/{vocabularyId}")
    @ApiOperation(value = "检查词汇记录", notes = "获取指定词汇最近的学习记录ID")
    public BaseResponse<Long> checkVocabularyRecord(
            @PathVariable Long vocabularyId,
            HttpServletRequest request) {
        if (vocabularyId == null || vocabularyId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        // 获取登录用户
        User loginUser = userService.getLoginUser(request);

        // 构建查询条件
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId())
                .eq("vocabularyId", vocabularyId)
                .eq("status", "进行中")
                .orderByDesc("createTime")  // 按创建时间降序
                .last("LIMIT 1");  // 只获取最新的一条记录

        // 获取最新的记录
        StudyRecord record = studyRecordService.getOne(queryWrapper);

        // 如果存在记录返回记录ID，否则返回null
        return ResultUtils.success(record != null ? record.getId() : null);
    }

    /**
     * 获取课程最近的学习记录ID
     */
    @GetMapping("/check/course/{courseId}")
    @ApiOperation(value = "检查课程记录", notes = "获取指定课程最近的学习记录")
    public BaseResponse<StudyRecord> checkCourseRecord(
            @PathVariable Long courseId,
            HttpServletRequest request) {
        if (courseId == null || courseId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }

        // 获取登录用户
        User loginUser = userService.getLoginUser(request);

        // 构建查询条件
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId())
                .eq("courseId", courseId)
                .orderByDesc("createTime")  // 按创建时间降序
                .last("LIMIT 1");  // 只获取最新的一条记录

        // 获取最新的记录
        StudyRecord record = studyRecordService.getOne(queryWrapper);

        return ResultUtils.success(record);
    }

    /**
     * 获取用户学习概况统计
     */
    @GetMapping("/statistics/overview")
    @ApiOperation(value = "学习概况", notes = "获取用户的学习概况统计信息")
    public BaseResponse<Map<String, Object>> getStudyOverview(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);

        // 构建查询条件
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId());

        // 获取所有学习记录
        List<StudyRecord> records = studyRecordService.list(queryWrapper);

        // 统计数据
        Map<String, Object> overview = new HashMap<>();

        // 如果没有记录，返回默认值
        if (records == null || records.isEmpty()) {
            overview.put("totalStudyTime", 0);
            overview.put("avgProgress", 0.0);
            overview.put("masteredVocabulary", 0);
            overview.put("studyDays", 0);
            return ResultUtils.success(overview);
        }

        // 1. 总学习时长(分钟)
        int totalStudyTime = records.stream()
                .filter(record -> record != null)
                .mapToInt(record -> record.getStudyTime() != null ? record.getStudyTime() : 0)
                .sum();

        // 2. 平均学习进度
        double avgProgress = records.stream()
                .filter(record -> record != null)
                .mapToInt(record -> record.getProgress() != null ? record.getProgress() : 0)
                .average()
                .orElse(0.0);

        // 3. 已掌握词汇数量(去重)
        long masteredVocabulary = records.stream()
                .filter(record -> record != null)
                .filter(r -> r.getVocabularyId() != null && r.getStatus() != null && "已完成" .equals(r.getStatus()))
                .map(StudyRecord::getVocabularyId)
                .distinct()
                .count();

        // 4. 学习天数(根据createTime去重计算)
        long studyDays = records.stream()
                .filter(record -> record != null)
                .map(r -> {
                    try {
                        Date createTime = r.getCreateTime();
                        if (createTime == null) {
                            return null;
                        }
                        return createTime.toInstant()
                                .atZone(ZoneId.systemDefault())
                                .toLocalDate();
                    } catch (Exception e) {
                        log.error("日期转换异常", e);
                        return null;
                    }
                })
                .filter(date -> date != null)
                .distinct()
                .count();

        // 封装结果
        overview.put("totalStudyTime", totalStudyTime);
        overview.put("avgProgress", Double.parseDouble(String.format("%.2f", avgProgress)));
        overview.put("masteredVocabulary", masteredVocabulary);
        overview.put("studyDays", studyDays);

        return ResultUtils.success(overview);
    }

    /**
     * 获取用户学习详细统计
     */
    @GetMapping("/statistics/detail")
    @ApiOperation(value = "学习详细统计", notes = "获取用户的详细学习统计信息")
    public BaseResponse<Map<String, Object>> getStudyDetail(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);

        // 构建查询条件
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId());

        // 获取所有学习记录
        List<StudyRecord> records = studyRecordService.list(queryWrapper);

        // 统计数据
        Map<String, Object> detail = new HashMap<>();

        // 如果没有记录，返回默认值
        if (records == null || records.isEmpty()) {
            detail.put("courseCount", 0);        // 学习课程数
            detail.put("totalCourseTime", 0);    // 课程总时长(分钟)
            detail.put("vocabularyCount", 0);    // 词汇个数
            detail.put("vocabularyTimes", 0);    // 词汇学习次数
            detail.put("examCount", 0);          // 测验次数
            detail.put("examAvgScore", 0.0);     // 测验平均分
            return ResultUtils.success(detail);
        }

        try {
            // 1. 统计课程相关
            long courseCount = records.stream()
                    .filter(r -> r.getCourseId() != null)
                    .map(StudyRecord::getCourseId)
                    .distinct()
                    .count();

            int totalCourseTime = records.stream()
                    .filter(r -> r.getCourseId() != null && r.getStudyTime() != null)
                    .mapToInt(StudyRecord::getStudyTime)
                    .sum();

            // 2. 统计词汇相关
            long vocabularyCount = records.stream()
                    .filter(r -> r.getVocabularyId() != null)
                    .map(StudyRecord::getVocabularyId)
                    .distinct()
                    .count();

            long vocabularyTimes = records.stream()
                    .filter(r -> r.getVocabularyId() != null)
                    .count();

            // 3. 统计测验相关
            long examCount = records.stream()
                    .filter(r -> r.getExamId() != null)
                    .count();

            double examAvgScore = records.stream()
                    .filter(r -> r.getExamId() != null && r.getScore() != null)
                    .mapToDouble(StudyRecord::getScore)
                    .average()
                    .orElse(0.0);

            // 封装结果
            detail.put("courseCount", courseCount);
            detail.put("totalCourseTime", totalCourseTime);
            detail.put("vocabularyCount", vocabularyCount);
            detail.put("vocabularyTimes", vocabularyTimes);
            detail.put("examCount", examCount);
            detail.put("examAvgScore", Double.parseDouble(String.format("%.2f", examAvgScore)));

        } catch (Exception e) {
            log.error("统计学习详情异常", e);
            throw new BusinessException(ErrorCode.SYSTEM_ERROR, "统计学习详情失败");
        }

        return ResultUtils.success(detail);
    }
} 