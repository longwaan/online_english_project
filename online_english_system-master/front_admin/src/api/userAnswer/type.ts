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