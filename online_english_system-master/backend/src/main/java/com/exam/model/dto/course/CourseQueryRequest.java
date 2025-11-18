package com.exam.model.dto.course;

import com.exam.common.PageRequest;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.io.Serializable;

@EqualsAndHashCode(callSuper = true)
@Data
public class CourseQueryRequest extends PageRequest implements Serializable {
    /**
     * 课程标题
     */
    private String title;

    /**
     * 课程描述
     */
    private String description;

    /**
     * 课程等级
     */
    private String level;

    /**
     * 课程状态
     */
    private Integer status;

    private static final long serialVersionUID = 1L;
} 