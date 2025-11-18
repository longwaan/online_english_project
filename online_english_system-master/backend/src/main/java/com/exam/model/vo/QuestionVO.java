package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

@Data
@ApiModel(value = "题目视图对象")
public class QuestionVO implements Serializable {
    
    @ApiModelProperty(value = "题目ID")
    private Long id;
    
    @ApiModelProperty(value = "所属试卷ID")
    private Long examId;
    
    @ApiModelProperty(value = "题目类型")
    private String questionType;
    
    @ApiModelProperty(value = "题目内容")
    private String questionText;
    
    @ApiModelProperty(value = "选项")
    private String options;
    
    @ApiModelProperty(value = "分值")
    private Integer score;
    
    @ApiModelProperty(value = "难度级别")
    private String difficultyLevel;

    @ApiModelProperty(value = "正确答案")
    private String correctAnswer;
    
    @ApiModelProperty(value = "题目解析")
    private String explanation;
    
    private static final long serialVersionUID = 1L;
} 