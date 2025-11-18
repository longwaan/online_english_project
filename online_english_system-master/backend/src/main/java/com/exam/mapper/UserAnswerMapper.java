package com.exam.mapper;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.exam.model.entity.UserAnswer;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import java.util.List;
import java.util.Map;

@Mapper
public interface UserAnswerMapper extends BaseMapper<UserAnswer> {

    @Select("SELECT q.questionType as questionType, " +
            "COUNT(*) as totalCount, " +
            "SUM(CASE WHEN ua.isCorrect = 1 THEN 1 ELSE 0 END) as correctCount, " +
            "AVG(CASE WHEN ua.isCorrect = 1 THEN 1 ELSE 0 END) * 100 as accuracy " +
            "FROM user_answer ua " +
            "JOIN question q ON ua.questionId = q.id " +
            "WHERE ua.userId = #{userId} AND ua.isDelete = 0 " +
            "GROUP BY q.questionType")
    List<Map<String, Object>> getQuestionTypeAccuracy(Long userId);

    @Select("SELECT q.questionType, " +
            "COUNT(*) as count, " +
            "SUM(CASE WHEN ua.isCorrect = 1 THEN 1 ELSE 0 END) as correctCount, " +
            "AVG(CASE WHEN ua.isCorrect = 1 THEN 1 ELSE 0 END) * 100 as accuracy, " +
            "SUM(ua.score) as totalScore " +
            "FROM user_answer ua " +
            "JOIN question q ON ua.questionId = q.id " +
            "WHERE ua.userId = #{userId} AND ua.examId = #{examId} " +
            "GROUP BY q.questionType")
    List<Map<String, Object>> getExamTypeStats(Long userId, Long examId);
} 