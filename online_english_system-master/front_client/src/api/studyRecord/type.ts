import type { BaseResponse } from '@/types/index'

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

// 导出涉及的响应类型（如果需要单独使用）
export type CheckVocabularyRecordResponse = BaseResponse<number | null>
export type AddStudyRecordResponse = BaseResponse<number>
export type GetStudyRecordByIdResponse = BaseResponse<StudyRecordVO>
export type UpdateStudyRecordTimeResponse = BaseResponse<boolean>
export type UpdateStudyRecordProgressResponse = BaseResponse<boolean>