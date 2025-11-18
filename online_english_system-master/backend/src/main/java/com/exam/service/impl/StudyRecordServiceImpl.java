package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.StudyRecordMapper;
import com.exam.model.entity.Course;
import com.exam.model.entity.Exam;
import com.exam.model.entity.StudyRecord;
import com.exam.model.entity.User;
import com.exam.model.entity.Vocabulary;
import com.exam.model.vo.CourseVO;
import com.exam.model.vo.ExamVO;
import com.exam.model.vo.StudyRecordVO;
import com.exam.model.vo.UserVO;
import com.exam.model.vo.VocabularyVO;
import com.exam.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.List;
import java.util.Map;

@Service
public class StudyRecordServiceImpl extends ServiceImpl<StudyRecordMapper, StudyRecord> implements StudyRecordService {
    
    @Resource
    private UserService userService;
    
    @Resource
    private CourseService courseService;
    
    @Resource
    private ExamService examService;
    
    @Resource
    private VocabularyService vocabularyService;
    
    @Override
    public void validStudyRecord(StudyRecord studyRecord, boolean add) {
        if (studyRecord == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Long userId = studyRecord.getUserId();
        Integer progress = studyRecord.getProgress();
        
        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(userId == null || userId <= 0, ErrorCode.PARAMS_ERROR, "用户ID不能为空");
            ThrowUtils.throwIf(progress == null || progress < 0 || progress > 100, 
                    ErrorCode.PARAMS_ERROR, "进度必须在0-100之间");
        }
        // 有参数则校验
        if (progress != null && (progress < 0 || progress > 100)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "进度必须在0-100之间");
        }
    }
    
    @Override
    public StudyRecordVO getStudyRecordVO(StudyRecord studyRecord) {
        if (studyRecord == null) {
            return null;
        }
        StudyRecordVO studyRecordVO = new StudyRecordVO();
        BeanUtils.copyProperties(studyRecord, studyRecordVO);
        
        // 关联查询用户信息
        Long userId = studyRecord.getUserId();
        if (userId != null && userId > 0) {
            User user = userService.getById(userId);
            UserVO userVO = userService.getUserVO(user);
            studyRecordVO.setUserVO(userVO);
        }
        
        // 关联查询课程信息
        Long courseId = studyRecord.getCourseId();
        if (courseId != null && courseId > 0) {
            Course course = courseService.getById(courseId);
            CourseVO courseVO = courseService.getCourseVO(course);
            studyRecordVO.setCourseVO(courseVO);
        }
        
        // 关联查询试卷信息
        Long examId = studyRecord.getExamId();
        if (examId != null && examId > 0) {
            Exam exam = examService.getById(examId);
            ExamVO examVO = examService.getExamVO(exam);
            studyRecordVO.setExamVO(examVO);
        }
        
        // 关联查询词汇信息
        Long vocabularyId = studyRecord.getVocabularyId();
        if (vocabularyId != null && vocabularyId > 0) {
            Vocabulary vocabulary = vocabularyService.getById(vocabularyId);
            VocabularyVO vocabularyVO = vocabularyService.getVocabularyVO(vocabulary);
            studyRecordVO.setVocabularyVO(vocabularyVO);
        }
        
        return studyRecordVO;
    }
    
    @Override
    @Transactional
    public boolean updateProgress(long recordId, int progress) {
        if (progress < 0 || progress > 100) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "进度必须在0-100之间");
        }
        StudyRecord record = this.getById(recordId);
        if (record == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        record.setProgress(progress);
        if (progress == 100) {
            record.setStatus("已完成");
        }
        return this.updateById(record);
    }
    
    @Override
    @Transactional
    public boolean updateStudyTime(long recordId, int studyTime) {
        if (studyTime < 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "学习时长不能为负数");
        }
        StudyRecord record = this.getById(recordId);
        if (record == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        record.setStudyTime(studyTime);
        return this.updateById(record);
    }
    
    @Override
    @Transactional
    public boolean updateScore(long recordId, float score) {
        if (score < 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "得分不能为负数");
        }
        StudyRecord record = this.getById(recordId);
        if (record == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        record.setScore(score);
        return this.updateById(record);
    }
    
    @Override
    public List<Map<String, Object>> getVocabularyFrequency(Long userId) {
        // 创建查询条件
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.select("vocabularyId", "COUNT(*) as frequency")
                .eq("userId", userId)
                .isNotNull("vocabularyId")
                .groupBy("vocabularyId")
                .orderByDesc("frequency");
        
        // 执行查询
        List<Map<String, Object>> result = this.baseMapper.selectMaps(queryWrapper);
        
        // 关联查询词汇信息
        result.forEach(map -> {
            Long vocabularyId = ((Number) map.get("vocabularyId")).longValue();
            Vocabulary vocabulary = vocabularyService.getById(vocabularyId);
            if (vocabulary != null) {
                map.put("word", vocabulary.getWord());
                map.put("meaning", vocabulary.getMeaning());
                map.put("difficultyLevel", vocabulary.getDifficultyLevel());
            }
        });
        
        return result;
    }

    @Override
    public Map<String, Object> getStudyTimeStatistics(Long userId) {
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .select("IFNULL(SUM(studyTime), 0) as totalTime", 
                        "IFNULL(AVG(studyTime), 0) as avgTime",
                        "IFNULL(MAX(studyTime), 0) as maxTime");
        
        Map<String, Object> result = this.baseMapper.selectMaps(queryWrapper).get(0);
        
        // 计算今日学习时长
        queryWrapper.clear();
        queryWrapper.eq("userId", userId)
                .apply("DATE(createTime) = CURDATE()")
                .select("IFNULL(SUM(studyTime), 0) as todayTime");
        
        result.putAll(this.baseMapper.selectMaps(queryWrapper).get(0));
        
        return result;
    }

    @Override
    public Map<String, Object> getProgressStatistics(Long userId) {
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .select("COUNT(*) as totalCount",
                        "IFNULL(SUM(CASE WHEN status = '已完成' THEN 1 ELSE 0 END), 0) as completedCount",
                        "IFNULL(AVG(progress), 0) as avgProgress");
        
        Map<String, Object> result = this.baseMapper.selectMaps(queryWrapper).get(0);
        
        // 安全地获取数值并计算完成率
        long totalCount = result.get("totalCount") != null ? 
                ((Number) result.get("totalCount")).longValue() : 0;
        long completedCount = result.get("completedCount") != null ? 
                ((Number) result.get("completedCount")).longValue() : 0;
        double avgProgress = result.get("avgProgress") != null ? 
                ((Number) result.get("avgProgress")).doubleValue() : 0.0;
        
        // 计算完成率
        double completionRate = totalCount > 0 ? (double) completedCount / totalCount * 100 : 0;
        
        // 更新结果
        result.put("totalCount", totalCount);
        result.put("completedCount", completedCount);
        result.put("avgProgress", Double.parseDouble(String.format("%.2f", avgProgress)));
        result.put("completionRate", Double.parseDouble(String.format("%.2f", completionRate)));
        
        return result;
    }

    @Override
    public Map<String, Object> getScoreStatistics(Long userId) {
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .isNotNull("score")
                .select("COUNT(*) as examCount",
                        "IFNULL(AVG(score), 0) as avgScore",
                        "IFNULL(MAX(score), 0) as maxScore",
                        "IFNULL(MIN(score), 0) as minScore");
        
        Map<String, Object> result = this.baseMapper.selectMaps(queryWrapper).get(0);
        Double avgScore = (Double) result.get("avgScore");
        if (avgScore != null) {
            result.put("avgScore", Double.parseDouble(String.format("%.2f", avgScore)));
        }
        // 计算及格率
        queryWrapper.clear();
        queryWrapper.eq("userId", userId)
                .isNotNull("score")
                .ge("score", 60)
                .select("COUNT(*) as passCount");
        
        long passCount = ((Number) this.baseMapper.selectMaps(queryWrapper).get(0).get("passCount")).longValue();
        long examCount = ((Number) result.get("examCount")).longValue();
        double passRate = examCount > 0 ? (double) passCount / examCount * 100 : 0;
        result.put("passRate", Double.parseDouble(String.format("%.2f", passRate)));
        
        return result;
    }

    @Override
    public List<Map<String, Object>> getStudyTrend(Long userId, String type) {
        String dateFormat;
        String groupBy;
        String dateColumn;
        
        // 根据类型确定日期格式和分组方式
        switch (type) {
            case "weekly":
                dateFormat = "%Y-%u";
                dateColumn = "YEARWEEK(createTime)";
                groupBy = dateColumn;
                break;
            case "monthly":
                dateFormat = "%Y-%m";
                dateColumn = "DATE_FORMAT(createTime, '%Y-%m')";
                groupBy = dateColumn;
                break;
            default:
                dateFormat = "%Y-%m-%d";
                dateColumn = "DATE(createTime)";
                groupBy = dateColumn;
        }
        
        QueryWrapper<StudyRecord> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .select(dateColumn + " as timeKey",
                        "DATE_FORMAT(MIN(createTime), '" + dateFormat + "') as date",
                        "COUNT(*) as count",
                        "IFNULL(SUM(studyTime), 0) as totalTime",
                        "IFNULL(AVG(progress), 0) as avgProgress",
                        "IFNULL(AVG(score), 0) as avgScore")
                .groupBy(groupBy)
                .orderByAsc("timeKey")
                .last("LIMIT 30");  // 最近30个时间单位的数据
        
        return this.baseMapper.selectMaps(queryWrapper);
    }
} 