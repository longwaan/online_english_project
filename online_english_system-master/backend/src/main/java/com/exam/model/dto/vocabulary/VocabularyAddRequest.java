package com.exam.model.dto.vocabulary;

import lombok.Data;

import javax.validation.constraints.NotBlank;
import java.io.Serializable;

@Data
public class VocabularyAddRequest implements Serializable {
    
    @NotBlank(message = "单词不能为空")
    private String word;
    
    private String phonetic;
    
    @NotBlank(message = "词义不能为空")
    private String meaning;
    
    private String example;
    
    private String difficultyLevel;
    
    private String isPhrase;
    
    private static final long serialVersionUID = 1L;
} 