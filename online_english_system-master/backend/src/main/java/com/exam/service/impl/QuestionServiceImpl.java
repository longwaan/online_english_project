package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.QuestionMapper;
import com.exam.model.entity.Question;
import com.exam.model.vo.QuestionVO;
import com.exam.service.QuestionService;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

@Service
public class QuestionServiceImpl extends ServiceImpl<QuestionMapper, Question> implements QuestionService {
    
    @Override
    public void validQuestion(Question question, boolean add) {
        if (question == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String questionText = question.getQuestionText();
        Long examId = question.getExamId();
        
        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(StringUtils.isBlank(questionText), ErrorCode.PARAMS_ERROR, "题目内容不能为空");
            ThrowUtils.throwIf(examId == null || examId <= 0, ErrorCode.PARAMS_ERROR, "试卷ID不能为空");
        }
    }
    
    @Override
    public QuestionVO getQuestionVO(Question question) {
        if (question == null) {
            return null;
        }
        QuestionVO questionVO = new QuestionVO();
        BeanUtils.copyProperties(question, questionVO);
        return questionVO;
    }

    @Override
    public boolean checkAnswer(Question question, String userAnswer) {
        if (question == null || userAnswer == null) {
            return false;
        }
        
        // 根据题目类型进行不同的答案比对
        switch (question.getQuestionType()) {
            case "单选":
            case "判断":
                // 直接比较答案
                return question.getCorrectAnswer().equalsIgnoreCase(userAnswer.trim());
                
            case "多选":
                // 将答案转换为集合进行比较
                Set<String> correctAnswers = new HashSet<>(Arrays.asList(question.getCorrectAnswer().split(",")));
                Set<String> userAnswers = new HashSet<>(Arrays.asList(userAnswer.split(",")));
                return correctAnswers.equals(userAnswers);
                
            case "填空":
                // 填空题可能有多个答案，用|分隔
                String[] possibleAnswers = question.getCorrectAnswer().split("\\|");
                return Arrays.stream(possibleAnswers)
                        .anyMatch(answer -> answer.trim().equalsIgnoreCase(userAnswer.trim()));
                
            case "简答题":
                // 简答题使用关键词匹配
                String[] keywords = question.getCorrectAnswer().split(",");
                String userAnswerLower = userAnswer.toLowerCase();
                // 检查是否包含所有关键词
                return Arrays.stream(keywords)
                        .allMatch(keyword -> userAnswerLower.contains(keyword.trim().toLowerCase()));
                
            default:
                return false;
        }
    }
} 