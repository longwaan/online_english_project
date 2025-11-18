package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@ApiModel(value = "用户作答视图对象")
public class UserAnswerVO implements Serializable {
    
    @ApiModelProperty(value = "作答记录ID")
    private Long id;
    
    @ApiModelProperty(value = "用户ID")
    private Long userId;
    
    @ApiModelProperty(value = "用户信息")
    private UserVO userVO;
    
    @ApiModelProperty(value = "试卷ID")
    private Long examId;
    
    @ApiModelProperty(value = "试卷信息")
    private ExamVO examVO;
    
    @ApiModelProperty(value = "题目ID")
    private Long questionId;
    
    @ApiModelProperty(value = "题目信息")
    private QuestionVO questionVO;
    
    @ApiModelProperty(value = "用户作答")
    private String userAnswer;
    
    @ApiModelProperty(value = "是否正确")
    private Integer isCorrect;
    
    @ApiModelProperty(value = "得分")
    private Integer score;
    
    @ApiModelProperty(value = "用户笔记")
    private String userNote;
    
    @ApiModelProperty(value = "作答时间")
    private Date createTime;
    
    private static final long serialVersionUID = 1L;
} 