package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@ApiModel(value = "学习记录视图对象")
public class StudyRecordVO implements Serializable {
    
    @ApiModelProperty(value = "记录ID")
    private Long id;
    
    @ApiModelProperty(value = "用户ID")
    private Long userId;
    
    @ApiModelProperty(value = "用户信息")
    private UserVO userVO;
    
    @ApiModelProperty(value = "课程ID")
    private Long courseId;
    
    @ApiModelProperty(value = "课程信息")
    private CourseVO courseVO;
    
    @ApiModelProperty(value = "试卷ID")
    private Long examId;
    
    @ApiModelProperty(value = "试卷信息")
    private ExamVO examVO;
    
    @ApiModelProperty(value = "词汇ID")
    private Long vocabularyId;
    
    @ApiModelProperty(value = "词汇信息")
    private VocabularyVO vocabularyVO;
    
    @ApiModelProperty(value = "学习进度")
    private Integer progress;
    
    @ApiModelProperty(value = "状态")
    private String status;
    
    @ApiModelProperty(value = "学习时长(分钟)")
    private Integer studyTime;
    
    @ApiModelProperty(value = "得分")
    private Float score;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    private static final long serialVersionUID = 1L;
} 