import request from '@/utils/request'
import type { BaseResponse } from '@/types/index'
import type {
  Exam,
  Question,
  PageResult,
  UserAnswer,
  BatchAnswerRequest,
  UserAnswerVO
} from './type'

// API函数
export function getExamList(params: { current: number; pageSize: number }) {
  return request.get<BaseResponse<PageResult<Exam>>>('/exam/list/page', { params })
}

export function getExamById(id: string) {
  return request.get<BaseResponse<Exam>>(`/exam/get?id=${id}`)
}

export function getQuestionList(params: { current: number; pageSize: number; examId: string }) {
  return request.get<BaseResponse<PageResult<Question>>>('/question/list/page', { params })
}

export function getExamQuestions(examId: string) {
  return request.get<BaseResponse<Question[]>>(`/question/list/exam/${examId}`)
}

// 单题提交
export function addUserAnswer(data: UserAnswer & { examId: number | string }) {
  return request.post<BaseResponse<void>>('/user_answer/add', data)
}

// 批量提交
export function batchAddUserAnswers(data: BatchAnswerRequest) {
  return request.post<BaseResponse<void>>('/user_answer/batch', data)
}

// 获取答案详情
export function getUserAnswerDetail(id: string) {
  return request.get<BaseResponse<UserAnswerVO>>(`/user_answer/get/vo?id=${id}`)
}

// 获取试卷作答记录
export function getExamAnswers(examId: string, params: { current: number; pageSize: number }) {
  return request.get<BaseResponse<PageResult<UserAnswerVO>>>(`/user_answer/exam/${examId}/answers`, { params })
}