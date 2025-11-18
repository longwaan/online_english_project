package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.Exam;
import com.exam.model.vo.ExamVO;

import javax.servlet.http.HttpServletRequest;

public interface ExamService extends IService<Exam> {
    
    /**
     * 校验试卷信息
     */
    void validExam(Exam exam, boolean add);
    
    /**
     * 获取试卷VO
     */
    ExamVO getExamVO(Exam exam);

    /**
     * 获取试卷基本信息(不包含题目列表)
     */
    ExamVO getBasicExamVO(Exam exam);
} 