package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.Question;
import org.apache.ibatis.annotations.Mapper;

/**
 * 试题数据库操作
 */
@Mapper
public interface QuestionMapper extends BaseMapper<Question> {
} 