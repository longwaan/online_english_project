package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.PostComment;
import org.apache.ibatis.annotations.Mapper;

/**
 * 帖子评论数据库操作
 */
@Mapper
public interface PostCommentMapper extends BaseMapper<PostComment> {
} 