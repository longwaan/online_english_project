package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.mapper.StudyRecordMapper;
import com.exam.mapper.UserAnswerMapper;
import com.exam.model.dto.studyrecord.StudyRecordAddRequest;
import com.exam.model.dto.useranswer.UserAnswerBatchRequest;
import com.exam.model.entity.Question;
import com.exam.model.entity.StudyRecord;
import com.exam.model.entity.UserAnswer;
import com.exam.model.vo.UserAnswerVO;
import com.exam.service.*;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.*;
import java.util.stream.Collectors;

@Service
public class UserAnswerServiceImpl extends ServiceImpl<UserAnswerMapper, UserAnswer> implements UserAnswerService {

    @Resource
    private UserService userService;

    @Resource
    private ExamService examService;

    @Resource
    private QuestionService questionService;
    @Autowired
    private StudyRecordService studyRecordService;

    @Override
    public void validUserAnswer(UserAnswer userAnswer, boolean add) {
        if (userAnswer == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        if (add) {
            if (userAnswer.getExamId() == null || userAnswer.getExamId() <= 0) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "试卷ID不能为空");
            }
            if (userAnswer.getQuestionId() == null || userAnswer.getQuestionId() <= 0) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "题目ID不能为空");
            }
            if (userAnswer.getUserAnswer() == null) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "作答内容不能为空");
            }
        }
    }

    @Override
    public UserAnswerVO getUserAnswerVO(UserAnswer userAnswer) {
        if (userAnswer == null) {
            return null;
        }
        UserAnswerVO userAnswerVO = new UserAnswerVO();
        BeanUtils.copyProperties(userAnswer, userAnswerVO);

        // 只获取当前作答对应的题目信息
        Question question = questionService.getById(userAnswer.getQuestionId());
        if (question != null) {
            userAnswerVO.setQuestionVO(questionService.getQuestionVO(question));
        }

        // 获取试卷基本信息(不包含题目列表)
        userAnswerVO.setExamVO(examService.getBasicExamVO(examService.getById(userAnswer.getExamId())));

        // 获取用户基本信息
        userAnswerVO.setUserVO(userService.getBasicUserVO(userService.getById(userAnswer.getUserId())));

        return userAnswerVO;
    }

    @Override
    public boolean gradeAnswer(Long answerId) {
        UserAnswer userAnswer = this.getById(answerId);
        if (userAnswer == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }

        Question question = questionService.getById(userAnswer.getQuestionId());
        if (question == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }

        // 判断答案是否正确
        boolean isCorrect = questionService.checkAnswer(question, userAnswer.getUserAnswer());
        userAnswer.setIsCorrect(isCorrect ? 1 : 0);

        // 计算得分
        if (isCorrect) {
            userAnswer.setScore(question.getScore());
        } else {
            userAnswer.setScore(0);
        }

        return this.updateById(userAnswer);
    }

    @Override
    public List<UserAnswerVO> getUserExamAnswers(Long userId, Long examId) {
        QueryWrapper<UserAnswer> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .eq("examId", examId)
                .orderByAsc("questionId");

        return this.list(queryWrapper).stream()
                .map(this::getUserAnswerVO)
                .collect(Collectors.toList());
    }

    @Override
    public Map<String, Object> getWrongAnswerStatistics(Long userId) {
        QueryWrapper<UserAnswer> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .select("COUNT(*) as totalCount",
                        "SUM(CASE WHEN isCorrect = 0 THEN 1 ELSE 0 END) as wrongCount",
                        "AVG(CASE WHEN isCorrect = 1 THEN 1 ELSE 0 END) * 100 as accuracy");

        return this.baseMapper.selectMaps(queryWrapper).get(0);
    }

    @Override
    public List<Map<String, Object>> getQuestionTypeAccuracy(Long userId) {
        return this.baseMapper.getQuestionTypeAccuracy(userId);
    }

    @Override
    public Map<String, Object> getExamSummary(Long userId, Long examId) {
        // 获取基本统计信息
        QueryWrapper<UserAnswer> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", userId)
                .eq("examId", examId)
                .select("COUNT(*) as totalQuestions",
                        "SUM(CASE WHEN isCorrect = 1 THEN 1 ELSE 0 END) as correctCount",
                        "SUM(score) as totalScore");

        Map<String, Object> summary = this.baseMapper.selectMaps(queryWrapper).get(0);

// 获取题目总数和正确数，并进行 null 判断
        Number totalQuestionsNum = (Number) summary.get("totalQuestions");
        Number correctCountNum = (Number) summary.get("correctCount");

        long totalQuestions = (totalQuestionsNum != null) ? totalQuestionsNum.longValue() : 0;
        long correctCount = (correctCountNum != null) ? correctCountNum.longValue() : 0;

// 计算正确率，防止除数为零
        double accuracy = (totalQuestions > 0) ? (double) correctCount / totalQuestions * 100 : 0;


        // 获取题型统计
        List<Map<String, Object>> typeStats = this.baseMapper.getExamTypeStats(userId, examId);

        // 组装返回数据
        Map<String, Object> result = new HashMap<>();
        result.put("examId", examId);
        result.put("totalQuestions", totalQuestions);
        result.put("correctCount", correctCount);
        result.put("accuracy", accuracy);
        result.put("totalScore", summary.get("totalScore"));
        result.put("typeStats", typeStats);

        return result;
    }

    @Override
    public Page<UserAnswerVO> pageUserAnswers(Page<UserAnswer> page, QueryWrapper<UserAnswer> queryWrapper) {
        // 分页查询
        Page<UserAnswer> userAnswerPage = this.page(page, queryWrapper);

        // 转换为VO
        Page<UserAnswerVO> voPage = new Page<>(page.getCurrent(), page.getSize(), userAnswerPage.getTotal());
        List<UserAnswerVO> voList = userAnswerPage.getRecords().stream()
                .map(this::getUserAnswerVO)
                .collect(Collectors.toList());
        voPage.setRecords(voList);

        return voPage;
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public Map<String, Object> batchSaveAndGrade(UserAnswerBatchRequest batchRequest, Long userId) {
        Long examId = batchRequest.getExamId();
        List<UserAnswerBatchRequest.AnswerItem> answers = batchRequest.getAnswers();

        // 批量保存答案
        List<UserAnswer> userAnswers = answers.stream().map(item -> {
            UserAnswer userAnswer = new UserAnswer();
            userAnswer.setUserId(userId);
            userAnswer.setExamId(examId);
            userAnswer.setQuestionId(item.getQuestionId());
            userAnswer.setUserAnswer(item.getUserAnswer());
            userAnswer.setUserNote(item.getUserNote());
            return userAnswer;
        }).collect(Collectors.toList());

        boolean saveResult = this.saveBatch(userAnswers);
        if (!saveResult) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "保存答案失败");
        }

        // 批量批改
        int totalScore = 0;
        int correctCount = 0;

        for (UserAnswer answer : userAnswers) {
            Question question = questionService.getById(answer.getQuestionId());
            if (question == null) {
                continue;
            }

            // 判断答案是否正确
            boolean isCorrect = questionService.checkAnswer(question, answer.getUserAnswer());
            answer.setIsCorrect(isCorrect ? 1 : 0);

            // 计算得分
            int score = isCorrect ? question.getScore() : 0;
            answer.setScore(score);

            if (isCorrect) {
                correctCount++;
                totalScore += score;
            }
        }

        // 批量更新批改结果
        this.updateBatchById(userAnswers);

        // 返回统计结果
        Map<String, Object> result = new HashMap<>();
        result.put("examId", examId);
        result.put("totalQuestions", answers.size());
        result.put("correctCount", correctCount);
        result.put("accuracy", answers.size() > 0 ? correctCount * 100.0 / answers.size() : 0);
        result.put("totalScore", totalScore);
        result.put("answers", userAnswers.stream()
                .map(this::getUserAnswerVO)
                .collect(Collectors.toList()));
        StudyRecord recordAddRequest = new StudyRecord();
        recordAddRequest.setUserId(userId);
        recordAddRequest.setExamId(examId);
        recordAddRequest.setScore((float) totalScore);
        recordAddRequest.setStatus("已完成");
        studyRecordService.save(recordAddRequest);
        return result;
    }
} 