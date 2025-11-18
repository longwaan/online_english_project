package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
@ApiModel(value = "试卷视图对象")
public class ExamVO implements Serializable {
    
    @ApiModelProperty(value = "试卷ID")
    private Long id;
    
    @ApiModelProperty(value = "试卷标题")
    private String title;
    
    @ApiModelProperty(value = "试卷描述")
    private String description;
    
    @ApiModelProperty(value = "总分")
    private Integer totalScore;
    
    @ApiModelProperty(value = "开始时间")
    private Date startTime;
    
    @ApiModelProperty(value = "结束时间")
    private Date endTime;
    
    @ApiModelProperty(value = "题目列表")
    private List<QuestionVO> questionList;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    private static final long serialVersionUID = 1L;
} 