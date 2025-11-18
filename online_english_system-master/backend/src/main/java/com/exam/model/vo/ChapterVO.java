package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@ApiModel(value = "章节视图对象")
public class ChapterVO implements Serializable {

    @ApiModelProperty(value = "章节ID")
    private Long id;

    @ApiModelProperty(value = "所属课程ID")
    private CourseVO courseVO;

    @ApiModelProperty(value = "章节标题")
    private String title;

    @ApiModelProperty(value = "章节内容")
    private String content;

    @ApiModelProperty(value = "章节封面图片")
    private String coverImage;

    @ApiModelProperty(value = "视频链接")
    private String videoUrl;

    @ApiModelProperty(value = "视频时长（秒）")
    private Integer duration;

    @ApiModelProperty(value = "创建时间")
    private Date createTime;

    @ApiModelProperty(value = "修改时间")
    private Date updateTime;

    private static final long serialVersionUID = 1L;
} 