package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.PostCommentMapper;
import com.exam.model.entity.PostComment;
import com.exam.model.entity.User;
import com.exam.model.vo.PostCommentVO;
import com.exam.model.vo.UserVO;
import com.exam.service.PostCommentService;
import com.exam.service.UserService;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;

@Service
public class PostCommentServiceImpl extends ServiceImpl<PostCommentMapper, PostComment> implements PostCommentService {
    
    @Resource
    private UserService userService;
    
    @Override
    public void validPostComment(PostComment postComment, boolean add) {
        if (postComment == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String content = postComment.getContent();
        Long postId = postComment.getPostId();
        
        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(StringUtils.isBlank(content), ErrorCode.PARAMS_ERROR, "评论内容不能为空");
            ThrowUtils.throwIf(postId == null || postId <= 0, ErrorCode.PARAMS_ERROR, "帖子ID不能为空");
        }
        // 有参数则校验
        if (StringUtils.isNotBlank(content) && content.length() > 1000) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "评论内容过长");
        }
    }
    
    @Override
    public PostCommentVO getPostCommentVO(PostComment postComment) {
        if (postComment == null) {
            return null;
        }
        PostCommentVO postCommentVO = new PostCommentVO();
        BeanUtils.copyProperties(postComment, postCommentVO);
        
        // 关联查询用户信息
        Long userId = postComment.getUserId();
        if (userId != null && userId > 0) {
            User user = userService.getById(userId);
            UserVO userVO = userService.getUserVO(user);
            postCommentVO.setUserVO(userVO);
        }
        
        // 关联查询回复的评论
        Long replyTo = postComment.getReplyTo();
        if (replyTo != null && replyTo > 0) {
            PostComment replyComment = this.getById(replyTo);
            PostCommentVO replyCommentVO = this.getPostCommentVO(replyComment);
            postCommentVO.setReplyComment(replyCommentVO);
        }
        
        return postCommentVO;
    }
    
    @Override
    @Transactional
    public boolean likeComment(long commentId, long userId) {
        PostComment comment = this.getById(commentId);
        if (comment == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        // 更新点赞数
        comment.setLikes(comment.getLikes() + 1);
        return this.updateById(comment);
    }
    
    @Override
    @Transactional
    public boolean unlikeComment(long commentId, long userId) {
        PostComment comment = this.getById(commentId);
        if (comment == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        // 更新点赞数
        if (comment.getLikes() > 0) {
            comment.setLikes(comment.getLikes() - 1);
            return this.updateById(comment);
        }
        return true;
    }
} 