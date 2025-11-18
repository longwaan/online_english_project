package com.exam.model.dto.course;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;

@Data
@ApiModel(value = "课程封面上传请求")
public class CourseUploadCoverRequest implements Serializable {
    
    @ApiModelProperty(value = "课程ID")
    private Long courseId;
    
    private static final long serialVersionUID = 1L;
} 