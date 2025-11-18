package com.exam.model.dto.postcomment;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class PostCommentAddRequest implements Serializable {
    
    @NotNull(message = "帖子ID不能为空")
    private Long postId;
    
    @NotBlank(message = "评论内容不能为空")
    private String content;
    
    private Long replyTo;
    
    private static final long serialVersionUID = 1L;
} 