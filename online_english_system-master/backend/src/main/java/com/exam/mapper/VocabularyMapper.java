package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.Vocabulary;
import org.apache.ibatis.annotations.Mapper;

/**
 * 词汇数据库操作
 */
@Mapper
public interface VocabularyMapper extends BaseMapper<Vocabulary> {
} 