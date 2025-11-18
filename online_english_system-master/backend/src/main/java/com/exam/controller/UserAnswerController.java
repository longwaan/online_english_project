package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.exception.BusinessException;
import com.exam.model.dto.useranswer.UserAnswerAddRequest;
import com.exam.model.dto.useranswer.UserAnswerBatchRequest;
import com.exam.model.entity.UserAnswer;
import com.exam.model.entity.User;
import com.exam.model.vo.UserAnswerVO;
import com.exam.service.UserAnswerService;
import com.exam.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/user_answer")
@Api(tags = "用户作答接口")
@Slf4j
public class UserAnswerController {

    @Resource
    private UserAnswerService userAnswerService;
    
    @Resource
    private UserService userService;

    @PostMapping("/add")
    @ApiOperation(value = "提交答案", notes = "提交用户作答")
    public BaseResponse<Long> addUserAnswer(@RequestBody @Valid UserAnswerAddRequest userAnswerAddRequest,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        UserAnswer userAnswer = new UserAnswer();
        BeanUtils.copyProperties(userAnswerAddRequest, userAnswer);
        userAnswer.setUserId(loginUser.getId());
        
        userAnswerService.validUserAnswer(userAnswer, true);
        boolean result = userAnswerService.save(userAnswer);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR);
        }
        
        // 自动批改
        userAnswerService.gradeAnswer(userAnswer.getId());
        
        return ResultUtils.success(userAnswer.getId());
    }

    @PostMapping("/delete")
    @ApiOperation(value = "删除作答", notes = "删除用户作答记录")
    public BaseResponse<Boolean> deleteUserAnswer(@RequestBody DeleteRequest deleteRequest,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Long answerId = deleteRequest.getId();
        UserAnswer userAnswer = userAnswerService.getById(answerId);
        if (!userAnswer.getUserId().equals(loginUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = userAnswerService.removeById(answerId);
        return ResultUtils.success(result);
    }

    @GetMapping("/get/vo")
    @ApiOperation(value = "获取作答详情", notes = "获取单个题目的作答记录详细信息")
    public BaseResponse<UserAnswerVO> getUserAnswerVOById(@RequestParam Long id,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        UserAnswer userAnswer = userAnswerService.getById(id);
        if (userAnswer == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        if (!userAnswer.getUserId().equals(loginUser.getId())) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        UserAnswerVO userAnswerVO = userAnswerService.getUserAnswerVO(userAnswer);
        return ResultUtils.success(userAnswerVO);
    }

    @GetMapping("/exam/{examId}/summary")
    @ApiOperation(value = "获取试卷作答统计", notes = "获取用户在某次考试的作答统计信息")
    public BaseResponse<Map<String, Object>> getExamSummary(@PathVariable Long examId,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        
        // 获取统计信息
        Map<String, Object> summary = userAnswerService.getExamSummary(loginUser.getId(), examId);
        
        return ResultUtils.success(summary);
    }

    @GetMapping("/exam/{examId}/answers")
    @ApiOperation(value = "获取试卷作答列表", notes = "分页获取用户在某次考试的作答记录")
    public BaseResponse<Page<UserAnswerVO>> getExamAnswers(
            @PathVariable Long examId,
            @RequestParam(defaultValue = "1") long current,
            @RequestParam(defaultValue = "10") long pageSize,
            @RequestParam(required = false) Integer isCorrect,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        
        // 构建查询条件
        QueryWrapper<UserAnswer> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("userId", loginUser.getId())
                .eq("examId", examId)
                .orderByAsc("questionId");
        
        
        // 按正确性筛选
        if (isCorrect != null) {
            queryWrapper.eq("isCorrect", isCorrect);
        }
        
        // 分页查询
        Page<UserAnswerVO> answerPage = userAnswerService.pageUserAnswers(
                new Page<>(current, pageSize),
                queryWrapper
        );
        
        return ResultUtils.success(answerPage);
    }

    @GetMapping("/statistics/wrong")
    @ApiOperation(value = "错题统计", notes = "获取用户的错题统计信息")
    public BaseResponse<Map<String, Object>> getWrongAnswerStatistics(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        Map<String, Object> statistics = userAnswerService.getWrongAnswerStatistics(loginUser.getId());
        return ResultUtils.success(statistics);
    }

    @GetMapping("/statistics/accuracy")
    @ApiOperation(value = "题型正确率", notes = "获取用户各题型的正确率统计")
    public BaseResponse<List<Map<String, Object>>> getQuestionTypeAccuracy(HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        List<Map<String, Object>> accuracy = userAnswerService.getQuestionTypeAccuracy(loginUser.getId());
        return ResultUtils.success(accuracy);
    }

    @PostMapping("/batch")
    @ApiOperation(value = "批量提交答案", notes = "一次提交多道题的答案")
    public BaseResponse<Map<String, Object>> batchAddUserAnswers(
            @RequestBody @Valid UserAnswerBatchRequest batchRequest,
            HttpServletRequest request) {
        User loginUser = userService.getLoginUser(request);
        
        // 批量保存和批改
        Map<String, Object> result = userAnswerService.batchSaveAndGrade(batchRequest, loginUser.getId());
        
        return ResultUtils.success(result);
    }
} 