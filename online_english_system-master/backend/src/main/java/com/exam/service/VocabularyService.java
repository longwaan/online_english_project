package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.Vocabulary;
import com.exam.model.vo.VocabularyVO;

public interface VocabularyService extends IService<Vocabulary> {
    
    /**
     * 校验词汇信息
     */
    void validVocabulary(Vocabulary vocabulary, boolean add);
    
    /**
     * 获取词汇VO
     */
    VocabularyVO getVocabularyVO(Vocabulary vocabulary);
} 