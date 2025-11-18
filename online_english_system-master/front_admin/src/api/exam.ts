import request from '@/utils/request'

// 试卷类型定义
export interface Question {
  id: string
  examId: string
  questionType: '单选' | '多选' | '判断' | '简答'
  questionText: string
  options: string // JSON字符串
  score: number
  difficultyLevel: '简单' | '中等' | '困难'
  correctAnswer: string
  explanation: string
}

export interface Exam {
  id: string
  title: string
  description: string
  totalScore: number
  startTime: string
  endTime: string
  questionList: Question[]
  createTime: string
  updateTime: string
}

// 分页参数接口
interface PageParams {
  current: number
  pageSize: number
  searchQuery?: string
}

// 获取试卷分页列表
export function getExamList(params: PageParams) {
  return request({
    url: '/exam/list/page',
    method: 'get',
    params
  })
}

// 获取试卷详情
export function getExamDetail(id: string) {
  return request({
    url: '/exam/get',
    method: 'get',
    params: { id }
  })
}

// 添加新的接口定义
export interface ExamForm {
  title: string
  description: string
  startTime: string
  endTime: string
  totalScore: number
}

// 添加试卷
export function addExam(data: ExamForm) {
  return request({
    url: '/exam/add',
    method: 'post',
    data
  })
}

// 更新试卷
export function updateExam(data: Exam) {
  return request({
    url: '/exam/update',
    method: 'post',
    data
  })
}

// 删除试卷
export function deleteExam(id: string) {
  return request({
    url: '/exam/delete',
    method: 'post',
    data: { id }
  })
}

// 修改题目相关接口
// 添加题目
export function addQuestion(data: Partial<Question>) {
  return request({
    url: '/question/add',
    method: 'post',
    data
  })
}

// 更新题目
export function updateQuestion(data: Question) {
  return request({
    url: '/question/update',
    method: 'post',
    data
  })
}

// 删除题目
export function deleteQuestion(id: string) {
  return request({
    url: '/question/delete',
    method: 'post',
    data: { id }
  })
}

// 获取试题详情
export function getQuestionDetail(id: string) {
  return request({
    url: `/exam/question/${id}`,
    method: 'get'
  })
} 