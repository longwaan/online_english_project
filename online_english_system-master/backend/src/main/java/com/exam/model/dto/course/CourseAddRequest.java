package com.exam.model.dto.course;

import lombok.Data;

import java.io.Serializable;

@Data
public class CourseAddRequest implements Serializable {

    /**
     * 课程标题
     */
    private String title;

    /**
     * 课程描述
     */
    private String description;

    /**
     * 课程封面
     */
    private String coverImage;

    /**
     * 课程等级
     */
    private String level;

    /**
     * 课程状态：0-未上线 1-上线
     */
    private Integer status;

    private static final long serialVersionUID = 1L;
} 