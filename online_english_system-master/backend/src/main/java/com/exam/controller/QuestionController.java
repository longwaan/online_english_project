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
import com.exam.model.dto.question.QuestionAddRequest;
import com.exam.model.entity.Question;
import com.exam.model.vo.QuestionVO;
import com.exam.service.QuestionService;
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
@RequestMapping("/question")
@Api(tags = "试题管理接口")
@Slf4j
public class QuestionController {

    @Resource
    private QuestionService questionService;

    /**
     * 创建题目
     */
    @PostMapping("/add")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "创建题目", notes = "创建新的试题")
    public BaseResponse<Long> addQuestion(@RequestBody @Valid QuestionAddRequest questionAddRequest) {
        if (questionAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Question question = new Question();
        BeanUtils.copyProperties(questionAddRequest, question);
        questionService.validQuestion(question, true);
        boolean result = questionService.save(question);
        ThrowUtils.throwIf(!result, ErrorCode.OPERATION_ERROR);
        return ResultUtils.success(question.getId());
    }

    /**
     * 删除题目
     */
    @PostMapping("/delete")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "删除题目", notes = "根据题目ID删除题目")
    public BaseResponse<Boolean> deleteQuestion(@RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        boolean result = questionService.removeById(deleteRequest.getId());
        return ResultUtils.success(result);
    }

    /**
     * 更新题目
     */
    @PostMapping("/update")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "更新题目", notes = "更新题目信息")
    public BaseResponse<Boolean> updateQuestion(@RequestBody Question question) {
        if (question == null || question.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        questionService.validQuestion(question, false);
        boolean result = questionService.updateById(question);
        return ResultUtils.success(result);
    }

    /**
     * 根据ID获取题目
     */
    @GetMapping("/get")
    @ApiOperation(value = "获取题目", notes = "根据题目ID获取题目详情")
    public BaseResponse<QuestionVO> getQuestionById(@RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Question question = questionService.getById(id);
        if (question == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        QuestionVO questionVO = questionService.getQuestionVO(question);
        return ResultUtils.success(questionVO);
    }

    /**
     * 分页获取题目列表
     */
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取题目", notes = "分页获取题目列表")
    public BaseResponse<Page<QuestionVO>> listQuestionByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize,
            @ApiParam(value = "试卷ID") @RequestParam(required = false) Long examId) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        QueryWrapper<Question> queryWrapper = new QueryWrapper<>();
        if (examId != null && examId > 0) {
            queryWrapper.eq("examId", examId);
        }
        
        Page<Question> questionPage = questionService.page(new Page<>(current, pageSize), queryWrapper);
        
        // 转换为VO
        Page<QuestionVO> questionVOPage = new Page<>(current, pageSize, questionPage.getTotal());
        List<QuestionVO> questionVOList = questionPage.getRecords().stream()
                .map(questionService::getQuestionVO)
                .collect(Collectors.toList());
        questionVOPage.setRecords(questionVOList);
        
        return ResultUtils.success(questionVOPage);
    }

    /**
     * 获取试卷下的所有题目
     */
    @GetMapping("/list/exam/{examId}")
    @ApiOperation(value = "获取试卷题目", notes = "获取指定试卷下的所有题目")
    public BaseResponse<List<QuestionVO>> listQuestionsByExamId(
            @ApiParam(value = "试卷ID", required = true) @PathVariable Long examId) {
        if (examId == null || examId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        QueryWrapper<Question> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("examId", examId);
        List<Question> questionList = questionService.list(queryWrapper);
        
        List<QuestionVO> questionVOList = questionList.stream()
                .map(questionService::getQuestionVO)
                .collect(Collectors.toList());
        
        return ResultUtils.success(questionVOList);
    }
} 