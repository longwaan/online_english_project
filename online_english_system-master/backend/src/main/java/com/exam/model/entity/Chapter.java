package com.exam.model.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;

import java.io.Serializable;
import java.util.Date;

@TableName(value = "chapter")
@Data
public class Chapter implements Serializable {
    
    @TableId(type = IdType.AUTO)
    private Long id;
    
    private Long courseId;
    
    private String title;
    
    private String content;
    
    private Date createTime;
    
    private Date updateTime;
    
    private String coverImage;
    
    private String videoUrl;
    
    private Integer duration;
    
    @TableLogic
    private Integer isDelete;

    @TableField(exist = false)
    private static final long serialVersionUID = 1L;
} 