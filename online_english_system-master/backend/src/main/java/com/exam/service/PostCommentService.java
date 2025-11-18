package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.PostComment;
import com.exam.model.vo.PostCommentVO;

public interface PostCommentService extends IService<PostComment> {
    
    /**
     * 校验评论信息
     */
    void validPostComment(PostComment postComment, boolean add);
    
    /**
     * 获取评论VO
     */
    PostCommentVO getPostCommentVO(PostComment postComment);
    
    /**
     * 点赞评论
     */
    boolean likeComment(long commentId, long userId);
    
    /**
     * 取消点赞评论
     */
    boolean unlikeComment(long commentId, long userId);
} 