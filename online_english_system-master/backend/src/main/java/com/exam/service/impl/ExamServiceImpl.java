package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.ExamMapper;
import com.exam.model.entity.Exam;
import com.exam.model.entity.Question;
import com.exam.model.vo.ExamVO;
import com.exam.model.vo.QuestionVO;
import com.exam.service.ExamService;
import com.exam.service.QuestionService;
import com.exam.service.UserService;
import org.springframework.beans.BeanUtils;

import org.springframework.stereotype.Service;


import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class ExamServiceImpl extends ServiceImpl<ExamMapper, Exam> implements ExamService {

    @Resource
    private QuestionService questionService;

    @Resource
    private UserService userService;

    @Override
    public void validExam(Exam exam, boolean add) {
        if (exam == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String title = exam.getTitle();

        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(StringUtils.isBlank(title), ErrorCode.PARAMS_ERROR, "试卷标题不能为空");
        }
        // 有参数则校验
        if (StringUtils.isNotBlank(title) && title.length() > 512) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "试卷标题过长");
        }
    }

    @Override
    public ExamVO getExamVO(Exam exam) {
        if (exam == null) {
            return null;
        }
        ExamVO examVO = new ExamVO();
        BeanUtils.copyProperties(exam, examVO);

        // 关联查询题目信息
        QueryWrapper<Question> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("examId", exam.getId());
        List<Question> questionList = questionService.list(queryWrapper);
        List<QuestionVO> questionVOList = questionList.stream()
                .map(questionService::getQuestionVO)
                .collect(Collectors.toList());
        examVO.setQuestionList(questionVOList);

        return examVO;
    }

    @Override
    public ExamVO getBasicExamVO(Exam exam) {
        if (exam == null) {
            return null;
        }
        ExamVO examVO = new ExamVO();
        BeanUtils.copyProperties(exam, examVO);
        // 不查询题目列表
        return examVO;
    }
} 