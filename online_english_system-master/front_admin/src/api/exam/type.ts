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
export interface PageParams {
  current: number
  pageSize: number
  searchQuery?: string
}

// 试卷表单接口
export interface ExamForm {
  title: string
  description: string
  startTime: string
  endTime: string
  totalScore: number
}