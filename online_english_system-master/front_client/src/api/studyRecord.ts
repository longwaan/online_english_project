import request from '@/utils/request'
import type { BaseResponse } from '@/types'

// 学习记录请求参数
export interface StudyRecordAddRequest {
  courseId: number
  examId?: number
  vocabularyId?: number
  progress: number
  score: number
  status: string
  studyTime: number
  userId: number
}

export interface StudyRecordVO {
  id: number
  userId: number
  vocabularyId: number
  courseId: number
  examId: number
  progress: number
  score: number
  status: string
  studyTime: number
  createTime: string
  updateTime: string
}

/**
 * 获取词汇最近的学习记录ID
 * @param vocabularyId 词汇ID
 * @returns 最近的学习记录ID，如果不存在则返回null
 */
export function checkVocabularyRecord(vocabularyId: number) {
  return request.get<BaseResponse<number | null>>(`/study_record/check/vocabulary/${vocabularyId}`);
}

// 添加学习记录
export function addStudyRecord(data: StudyRecordAddRequest) {
  return request.post<BaseResponse<number>>('/study_record/add', data)
}

/**
 * 获取学习记录详情
 */
export function getStudyRecordById(id: number) {
  return request.get<BaseResponse<StudyRecordVO>>(`/study_record/get?id=${id}`)
}

// 更新学习时长
export function updateStudyRecordTime(id: string | number, studyTime: number) {
  return request.post<BaseResponse<boolean>>(`/study_record/time/${id}?studyTime=${studyTime}`)
}

// 更新学习进度
export function updateStudyRecordProgress(id: string | number, progress: number) {
  return request.post<BaseResponse<boolean>>(`/study_record/progress/${id}?progress=${progress}`)
} 