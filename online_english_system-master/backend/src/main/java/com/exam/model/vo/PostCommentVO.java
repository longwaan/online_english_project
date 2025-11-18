package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@ApiModel(value = "帖子评论视图对象")
public class PostCommentVO implements Serializable {
    
    @ApiModelProperty(value = "评论ID")
    private Long id;
    
    @ApiModelProperty(value = "帖子ID")
    private Long postId;
    
    @ApiModelProperty(value = "评论用户ID")
    private Long userId;
    
    @ApiModelProperty(value = "评论用户信息")
    private UserVO userVO;
    
    @ApiModelProperty(value = "评论内容")
    private String content;
    
    @ApiModelProperty(value = "回复的评论ID")
    private Long replyTo;
    
    @ApiModelProperty(value = "回复的评论信息")
    private PostCommentVO replyComment;
    
    @ApiModelProperty(value = "点赞数")
    private Integer likes;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    private static final long serialVersionUID = 1L;
} 