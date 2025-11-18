package com.exam.model.dto.useranswer;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class UserAnswerAddRequest implements Serializable {
    
    @NotNull(message = "试卷ID不能为空")
    private Long examId;
    
    @NotNull(message = "题目ID不能为空")
    private Long questionId;
    
    @NotNull(message = "作答内容不能为空")
    private String userAnswer;
    
    private String userNote;
    
    private static final long serialVersionUID = 1L;
} 