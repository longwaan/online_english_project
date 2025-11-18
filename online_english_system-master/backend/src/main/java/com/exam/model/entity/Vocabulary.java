package com.exam.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@TableName(value = "vocabulary")
public class Vocabulary implements Serializable {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private String word;
    
    private String phonetic;
    
    private String meaning;
    
    private String example;
    
    private String difficultyLevel;
    
    private String isPhrase;
    
    private Date createTime;
    
    private Date updateTime;
    
    @TableLogic
    private Integer isDelete;
    
    private static final long serialVersionUID = 1L;
} 