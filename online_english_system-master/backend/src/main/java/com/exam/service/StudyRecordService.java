package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.StudyRecord;
import com.exam.model.vo.StudyRecordVO;

import java.util.List;
import java.util.Map;

public interface StudyRecordService extends IService<StudyRecord> {
    
    /**
     * 校验学习记录信息
     */
    void validStudyRecord(StudyRecord studyRecord, boolean add);
    
    /**
     * 获取学习记录VO
     */
    StudyRecordVO getStudyRecordVO(StudyRecord studyRecord);
    
    /**
     * 更新学习进度
     */
    boolean updateProgress(long recordId, int progress);
    
    /**
     * 更新学习时长
     */
    boolean updateStudyTime(long recordId, int studyTime);
    
    /**
     * 更新考试得分
     */
    boolean updateScore(long recordId, float score);

    /**
     * 获取用户的词汇学习频率统计
     */
    List<Map<String, Object>> getVocabularyFrequency(Long userId);

    /**
     * 获取学习时长统计
     */
    Map<String, Object> getStudyTimeStatistics(Long userId);

    /**
     * 获取学习进度统计
     */
    Map<String, Object> getProgressStatistics(Long userId);

    /**
     * 获取考试得分统计
     */
    Map<String, Object> getScoreStatistics(Long userId);

    /**
     * 获取学习趋势
     */
    List<Map<String, Object>> getStudyTrend(Long userId, String type);
} 