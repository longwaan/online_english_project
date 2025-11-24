import request from '@/utils/request'
import type { Exam, Question, PageParams, ExamForm } from './type'

// API路径枚举定义
enum API {
  EXAM_LIST_PAGE = '/exam/list/page',
  EXAM_GET = '/exam/get',
  EXAM_ADD = '/exam/add',
  EXAM_UPDATE = '/exam/update',
  EXAM_DELETE = '/exam/delete',
  QUESTION_ADD = '/question/add',
  QUESTION_UPDATE = '/question/update',
  QUESTION_DELETE = '/question/delete',
  EXAM_QUESTION = '/exam/question'
}

// 获取试卷分页列表
const getExamList = (params: PageParams) => {
  return request({
    url: API.EXAM_LIST_PAGE,
    method: 'get',
    params
  })
}

// 获取试卷详情
const getExamDetail = (id: string) => {
  return request({
    url: API.EXAM_GET,
    method: 'get',
    params: { id }
  })
}

// 添加试卷
const addExam = (data: ExamForm) => {
  return request({
    url: API.EXAM_ADD,
    method: 'post',
    data
  })
}

// 更新试卷
const updateExam = (data: Exam) => {
  return request({
    url: API.EXAM_UPDATE,
    method: 'post',
    data
  })
}

// 删除试卷
const deleteExam = (id: string) => {
  return request({
    url: API.EXAM_DELETE,
    method: 'post',
    data: { id }
  })
}

// 添加题目
const addQuestion = (data: Partial<Question>) => {
  return request({
    url: API.QUESTION_ADD,
    method: 'post',
    data
  })
}

// 更新题目
const updateQuestion = (data: Question) => {
  return request({
    url: API.QUESTION_UPDATE,
    method: 'post',
    data
  })
}

// 删除题目
const deleteQuestion = (id: string) => {
  return request({
    url: API.QUESTION_DELETE,
    method: 'post',
    data: { id }
  })
}

// 获取试题详情
const getQuestionDetail = (id: string) => {
  return request({
    url: `${API.EXAM_QUESTION}/${id}`,
    method: 'get'
  })
}

export {
  getExamList,
  getExamDetail,
  addExam,
  updateExam,
  deleteExam,
  addQuestion,
  updateQuestion,
  deleteQuestion,
  getQuestionDetail
}