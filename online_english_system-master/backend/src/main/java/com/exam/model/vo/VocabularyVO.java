package com.exam.model.vo;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@ApiModel(value = "词汇视图对象")
public class VocabularyVO implements Serializable {
    
    @ApiModelProperty(value = "词汇ID")
    private Long id;
    
    @ApiModelProperty(value = "单词")
    private String word;
    
    @ApiModelProperty(value = "音标")
    private String phonetic;
    
    @ApiModelProperty(value = "词义")
    private String meaning;
    
    @ApiModelProperty(value = "例句")
    private String example;
    
    @ApiModelProperty(value = "难度级别")
    private String difficultyLevel;
    
    @ApiModelProperty(value = "是否词组")
    private String isPhrase;
    
    @ApiModelProperty(value = "创建时间")
    private Date createTime;
    
    private static final long serialVersionUID = 1L;
} 