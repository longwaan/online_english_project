package com.exam.model.dto.studyrecord;

import lombok.Data;

import javax.validation.constraints.NotNull;
import java.io.Serializable;

@Data
public class StudyRecordAddRequest implements Serializable {
    
    @NotNull(message = "用户ID不能为空")
    private Long userId;
    
    private Long courseId;
    
    private Long examId;
    
    private Long vocabularyId;
    
    private Integer progress;
    
    private String status;
    
    private Integer studyTime;
    
    private Float score;
    
    private static final long serialVersionUID = 1L;
} 