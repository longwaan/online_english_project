package com.exam.service;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.UserAnswer;
import com.exam.model.vo.UserAnswerVO;
import com.exam.model.dto.useranswer.UserAnswerBatchRequest;

import java.util.List;
import java.util.Map;

public interface UserAnswerService extends IService<UserAnswer> {
    
    /**
     * 校验作答记录
     */
    void validUserAnswer(UserAnswer userAnswer, boolean add);
    
    /**
     * 获取作答记录VO
     */
    UserAnswerVO getUserAnswerVO(UserAnswer userAnswer);
    
    /**
     * 批改答案
     */
    boolean gradeAnswer(Long answerId);
    
    /**
     * 获取用户在某次考试的所有作答
     */
    List<UserAnswerVO> getUserExamAnswers(Long userId, Long examId);
    
    /**
     * 获取错题统计
     */
    Map<String, Object> getWrongAnswerStatistics(Long userId);
    
    /**
     * 获取题型正确率统计
     */
    List<Map<String, Object>> getQuestionTypeAccuracy(Long userId);

    Map<String, Object> getExamSummary(Long userId, Long examId);

    Page<UserAnswerVO> pageUserAnswers(Page<UserAnswer> page, QueryWrapper<UserAnswer> queryWrapper);

    /**
     * 批量保存和批改答案
     * @param batchRequest 批量请求
     * @param userId 用户ID
     * @return 批改结果
     */
    Map<String, Object> batchSaveAndGrade(UserAnswerBatchRequest batchRequest, Long userId);

}