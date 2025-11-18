package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.Exam;
import org.apache.ibatis.annotations.Mapper;

/**
 * 试卷数据库操作
 */
@Mapper
public interface ExamMapper extends BaseMapper<Exam> {
} 