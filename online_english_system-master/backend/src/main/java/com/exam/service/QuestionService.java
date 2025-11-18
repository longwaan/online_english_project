package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.Question;
import com.exam.model.vo.QuestionVO;

public interface QuestionService extends IService<Question> {
    
    /**
     * 校验题目信息
     */
    void validQuestion(Question question, boolean add);
    
    /**
     * 获取题目VO
     */
    QuestionVO getQuestionVO(Question question);

    /**
     * 检查答案是否正确
     * @param question 题目
     * @param userAnswer 用户答案
     * @return 是否正确
     */
    boolean checkAnswer(Question question, String userAnswer);
} 