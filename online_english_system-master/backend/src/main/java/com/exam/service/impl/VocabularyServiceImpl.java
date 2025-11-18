package com.exam.service.impl;

import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.VocabularyMapper;
import com.exam.model.entity.Vocabulary;
import com.exam.model.vo.VocabularyVO;
import com.exam.service.VocabularyService;
import org.springframework.beans.BeanUtils;
import org.springframework.stereotype.Service;

@Service
public class VocabularyServiceImpl extends ServiceImpl<VocabularyMapper, Vocabulary> implements VocabularyService {
    
    @Override
    public void validVocabulary(Vocabulary vocabulary, boolean add) {
        if (vocabulary == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String word = vocabulary.getWord();
        String meaning = vocabulary.getMeaning();
        
        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(StringUtils.isBlank(word), ErrorCode.PARAMS_ERROR, "单词不能为空");
            ThrowUtils.throwIf(StringUtils.isBlank(meaning), ErrorCode.PARAMS_ERROR, "词义不能为空");
        }
        // 有参数则校验
        if (StringUtils.isNotBlank(word) && word.length() > 256) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "单词过长");
        }
    }
    
    @Override
    public VocabularyVO getVocabularyVO(Vocabulary vocabulary) {
        if (vocabulary == null) {
            return null;
        }
        VocabularyVO vocabularyVO = new VocabularyVO();
        BeanUtils.copyProperties(vocabulary, vocabularyVO);
        return vocabularyVO;
    }
} 