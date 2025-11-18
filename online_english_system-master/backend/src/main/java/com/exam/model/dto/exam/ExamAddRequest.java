package com.exam.model.dto.exam;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;
import java.util.Date;

@Data
public class ExamAddRequest implements Serializable {

    @NotBlank(message = "试卷标题不能为空")
    private String title;

    private String description;

    private Integer totalScore;

    private Date startTime;

    private Date endTime;

    private static final long serialVersionUID = 1L;
} 