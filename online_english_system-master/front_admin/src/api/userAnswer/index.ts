import request from '@/utils/request'
import type { UserAnswer } from './type'

// API路径枚举定义
enum API {
  USER_ANSWER_EXAM = '/user_answer/exam',
  USER_ANSWER_GET = '/user_answer/get/vo',
  USER_ANSWER_SUMMARY = '/user_answer/exam',
  USER_ANSWER_STATISTICS = '/user_answer/statistics/accuracy',
  USER_ANSWER_DELETE = '/user_answer/delete'
}

// 获取用户作答列表
const getUserAnswerList = (params: {
  current: number
  pageSize: number
  examId: string | number
  isCorrect?: number
  questionType?: string
}) => {
  return request({
    url: `${API.USER_ANSWER_EXAM}/${params.examId}/answers`,
    method: 'get',
    params: {
      current: params.current,
      pageSize: params.pageSize,
      isCorrect: params.isCorrect,
      questionType: params.questionType
    }
  })
}

// 获取作答详情
const getUserAnswerDetail = (id: string | number) => {
  return request({
    url: API.USER_ANSWER_GET,
    method: 'get',
    params: { id }
  })
}

// 获取作答统计
const getExamAnswerSummary = (examId: string | number) => {
  return request({
    url: `${API.USER_ANSWER_SUMMARY}/${examId}/summary`,
    method: 'get'
  })
}

// 获取正确率统计
const getAccuracyStatistics = () => {
  return request({
    url: API.USER_ANSWER_STATISTICS,
    method: 'get'
  })
}

// 删除用户作答记录
const deleteUserAnswer = (id: string | number) => {
  return request({
    url: API.USER_ANSWER_DELETE,
    method: 'post',
    data: { id }
  })
}

export {
  getUserAnswerList,
  getUserAnswerDetail,
  getExamAnswerSummary,
  getAccuracyStatistics,
  deleteUserAnswer
}