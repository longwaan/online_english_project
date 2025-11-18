package com.exam.model.dto.chapter;

import lombok.Data;

import java.io.Serializable;

@Data
public class ChapterAddRequest implements Serializable {
    private Long courseId;
    private String title;
    private String content;
    private String coverImage;
    private String videoUrl;
    private Integer duration;
    
    private static final long serialVersionUID = 1L;
} 