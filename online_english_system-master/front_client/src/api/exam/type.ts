
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