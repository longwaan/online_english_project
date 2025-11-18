package com.exam.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.constant.UserConstant;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.model.dto.exam.ExamAddRequest;
import com.exam.model.entity.Exam;
import com.exam.model.vo.ExamVO;
import com.exam.service.ExamService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/exam")
@Api(tags = "试卷管理接口")
@Slf4j
public class ExamController {

    @Resource
    private ExamService examService;

    /**
     * 创建试卷
     */
    @PostMapping("/add")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "创建试卷", notes = "创建新的试卷")
    public BaseResponse<Long> addExam(@RequestBody @Valid ExamAddRequest examAddRequest) {
        if (examAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Exam exam = new Exam();
        BeanUtils.copyProperties(examAddRequest, exam);
        examService.validExam(exam, true);
        boolean result = examService.save(exam);
        ThrowUtils.throwIf(!result, ErrorCode.OPERATION_ERROR);
        return ResultUtils.success(exam.getId());
    }

    /**
     * 删除试卷
     */
    @PostMapping("/delete")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "删除试卷", notes = "根据试卷ID删除试卷")
    public BaseResponse<Boolean> deleteExam(@RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        boolean result = examService.removeById(deleteRequest.getId());
        return ResultUtils.success(result);
    }

    /**
     * 更新试卷
     */
    @PostMapping("/update")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "更新试卷", notes = "更新试卷信息")
    public BaseResponse<Boolean> updateExam(@RequestBody Exam exam) {
        if (exam == null || exam.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        examService.validExam(exam, false);
        boolean result = examService.updateById(exam);
        return ResultUtils.success(result);
    }

    /**
     * 根据ID获取试卷
     */
    @GetMapping("/get")
    @ApiOperation(value = "获取试卷", notes = "根据试卷ID获取试卷详情")
    public BaseResponse<ExamVO> getExamById(@RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Exam exam = examService.getById(id);
        if (exam == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        ExamVO examVO = examService.getExamVO(exam);
        return ResultUtils.success(examVO);
    }

    /**
     * 分页获取试卷列表
     */
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取试卷", notes = "分页获取试卷列表")
    public BaseResponse<Page<ExamVO>> listExamByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Page<Exam> examPage = examService.page(new Page<>(current, pageSize));

        // 转换为VO
        Page<ExamVO> examVOPage = new Page<>(current, pageSize, examPage.getTotal());
        List<ExamVO> examVOList = examPage.getRecords().stream()
                .map(examService::getExamVO)
                .collect(Collectors.toList());
        examVOPage.setRecords(examVOList);

        return ResultUtils.success(examVOPage);
    }
} 