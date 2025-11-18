package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.Chapter;
import com.exam.model.vo.ChapterVO;

public interface ChapterService extends IService<Chapter> {
    /**
     * 校验章节信息
     */
    void validChapter(Chapter chapter, boolean add);

    /**
     * 获取章节VO
     */
    ChapterVO getChapterVO(Chapter chapter);
} 