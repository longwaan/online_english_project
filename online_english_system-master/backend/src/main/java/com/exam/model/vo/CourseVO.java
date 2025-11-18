package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

@Data
@ApiModel(value = "课程视图对象")
public class CourseVO implements Serializable {
    
    @ApiModelProperty(value = "课程ID")
    private Long id;
    
    @ApiModelProperty(value = "课程标题")
    private String title;
    
    @ApiModelProperty(value = "课程描述")
    private String description;
    
    @ApiModelProperty(value = "课程封面图片")
    private String coverImage;
    
    @ApiModelProperty(value = "课程等级")
    private String level;
    
    @ApiModelProperty(value = "课程状态：0-未上线 1-上线")
    private Integer status;
    
    @ApiModelProperty(value = "章节数量")
    private Integer chapterCount;
    
    @ApiModelProperty(value = "章节列表")
    private List<ChapterVO> chapterList;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "修改时间")
    private Date updateTime;

    private static final long serialVersionUID = 1L;
} 