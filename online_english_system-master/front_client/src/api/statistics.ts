import request from '@/utils/request'
import type { BaseResponse } from '@/types'

// 考试得分统计
export interface ScoreStatistics {
  minScore: number
  avgScore: number
  passRate: number
  maxScore: number
  examCount: string
}

// 学习时长统计
export interface StudyTimeStatistics {
  maxTime: string
  avgTime: number
  todayTime: number
  totalTime: number
}

// 词汇频率统计
export interface VocabularyFrequency {
  vocabularyId: string
  meaning: string
  difficultyLevel: string
  word: string
  frequency: string
}

// 学习进度统计
export interface ProgressStatistics {
  avgProgress: number
  completionRate: number
  totalCount: string
  completedCount: string
}

// 学习记录
export interface StudyRecordVO {
  id: string
  userId: string
  courseId: string
  examId: string
  progress: number
  score: number
  status: string
  studyTime: number
  createTime: string
  updateTime: string
}

// 学习概况统计
export interface StudyOverview {
  totalStudyTime: number    // 总学习时长(分钟)
  avgProgress: number       // 平均学习进度
  masteredVocabulary: number // 已掌握词汇数
  studyDays: number        // 学习天数
}

// 学习详细统计
export interface StudyDetail {
  courseCount: number      // 学习课程数
  totalCourseTime: number // 课程总时长(分钟)
  vocabularyCount: number // 词汇个数
  vocabularyTimes: number // 词汇学习次数
  examCount: number       // 测验次数
  examAvgScore: number    // 测验平均分
}

// API函数
export function getScoreStatistics() {
  return request.get<BaseResponse<ScoreStatistics>>('/study_record/statistics/score')
}

export function getStudyTimeStatistics() {
  return request.get<BaseResponse<StudyTimeStatistics>>('/study_record/statistics/study-time')
}

export function getVocabularyFrequency(userId: string) {
  return request.get<BaseResponse<VocabularyFrequency[]>>(`/study_record/vocabulary/frequency/${userId}`)
}

export function getProgressStatistics() {
  return request.get<BaseResponse<ProgressStatistics>>('/study_record/statistics/progress')
}

// 获取课程学习记录
export function getCourseStudyRecord(courseId: string) {
  return request.get<BaseResponse<StudyRecordVO>>(`/study_record/check/course/${courseId}`)
}

// 获取学习概况统计
export function getStudyOverview() {
  return request.get<BaseResponse<StudyOverview>>('/study_record/statistics/overview')
}

// 获取学习详细统计
export function getStudyDetail() {
  return request.get<BaseResponse<StudyDetail>>('/study_record/statistics/detail')
} 