package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.StudyRecord;
import org.apache.ibatis.annotations.Mapper;

/**
 * 学习记录数据库操作
 */
@Mapper
public interface StudyRecordMapper extends BaseMapper<StudyRecord> {
} 