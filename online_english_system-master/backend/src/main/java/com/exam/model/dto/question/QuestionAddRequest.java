package com.exam.model.dto.question;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class QuestionAddRequest implements Serializable {

    @NotNull(message = "试卷ID不能为空")
    private Long examId;

    @NotBlank(message = "题目类型不能为空")
    private String questionType;

    @NotBlank(message = "题目内容不能为空")
    private String questionText;

    private String options;

    @NotBlank(message = "正确答案不能为空")
    private String correctAnswer;

    private Integer score;

    private String difficultyLevel;

    private String explanation;

    private static final long serialVersionUID = 1L;
} 