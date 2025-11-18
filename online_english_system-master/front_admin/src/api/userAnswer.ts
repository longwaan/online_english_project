import request from '@/utils/request'

// 用户作答类型定义
export interface UserAnswer {
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
    questionList: any | null
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

// 获取用户作答列表
export function getUserAnswerList(params: {
  current: number
  pageSize: number
  examId: string | number
  isCorrect?: number
  questionType?: string
}) {
  return request({
    url: `/user_answer/exam/${params.examId}/answers`,
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
export function getUserAnswerDetail(id: string | number) {
  return request({
    url: '/user_answer/get/vo',
    method: 'get',
    params: { id }
  })
}

// 获取作答统计
export function getExamAnswerSummary(examId: string | number) {
  return request({
    url: `/user_answer/exam/${examId}/summary`,
    method: 'get'
  })
}

// 获取正确率统计
export function getAccuracyStatistics() {
  return request({
    url: '/user_answer/statistics/accuracy',
    method: 'get'
  })
}

// 删除用户作答记录
export function deleteUserAnswer(id: string | number) {
  return request({
    url: '/user_answer/delete',
    method: 'post',
    data: { id }
  })
} 