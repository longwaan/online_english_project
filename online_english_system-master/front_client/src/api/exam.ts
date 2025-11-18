import request from '@/utils/request'
import type { BaseResponse } from '@/types'

// 试题类型定义
export interface Question {
  id: string
  examId: string
  questionType: '单选' | '多选'
  questionText: string
  options: string  // JSON字符串
  score: number
  difficultyLevel: string
  correctAnswer: string
  explanation: string
}

// 试卷类型定义
export interface Exam {
  id: string
  title: string
  description: string
  totalScore: number
  startTime: string
  endTime: string
  questionList: Question[]
  createTime: string
}

// 分页响应类型
export interface PageResult<T> {
  records: T[]
  total: string
  size: string
  current: string
  pages: string
}

// 添加答案提交相关接口
export interface UserAnswer {
  questionId: number | string
  userAnswer: string
  userNote: string
}

export interface BatchAnswerRequest {
  answers: UserAnswer[]
  examId: number | string
}

// 添加用户答案详情接口
export interface UserAnswerVO {
  id: string
  userId: string
  userVO: {
    id: string
    userName: string
    userAvatar: string
    userProfile: string | null
    userRole: string
    createTime: string | null
  }
  examId: string
  examVO: {
    id: string
    title: string
    description: string
    totalScore: number
    startTime: string
    endTime: string
    questionList: null
    createTime: string
  }
  questionId: string
  questionVO: {
    id: string
    examId: string
    questionType: string
    questionText: string
    options: string
    score: number
    difficultyLevel: string
    correctAnswer: string
    explanation: string
  }
  userAnswer: string
  isCorrect: number
  score: number
  userNote: string
  createTime: string
}

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