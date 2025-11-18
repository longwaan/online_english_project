package com.exam.model.entity;

import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableLogic;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@Data
@TableName(value = "question")
public class Question implements Serializable {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long examId;
    
    private String questionType;
    
    private String questionText;
    
    private String options;
    
    private String correctAnswer;
    
    private Integer score;
    
    private String difficultyLevel;
    
    private String explanation;
    
    private Date createTime;
    
    private Date updateTime;
    
    @TableLogic
    private Integer isDelete;
    
    private static final long serialVersionUID = 1L;
} 