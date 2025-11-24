
// 考试得分统计
export interface ScoreStatistics {
  minScore: number
  avgScore: number
  passRate: number
  maxScore: number
  examCount: string
}

// 学习时长统计
export interface StudyTimeStatistics {
  maxTime: string
  avgTime: number
  todayTime: number
  totalTime: number
}

// 词汇频率统计
export interface VocabularyFrequency {
  vocabularyId: string
  meaning: string
  difficultyLevel: string
  word: string
  frequency: string
}

// 学习进度统计
export interface ProgressStatistics {
  avgProgress: number
  completionRate: number
  totalCount: string
  completedCount: string
}

// 学习记录
export interface StudyRecordVO {
  id: string
  userId: string
  courseId: string
  examId: string
  progress: number
  score: number
  status: string
  studyTime: number
  createTime: string
  updateTime: string
}

// 学习概况统计
export interface StudyOverview {
  totalStudyTime: number    // 总学习时长(分钟)
  avgProgress: number       // 平均学习进度
  masteredVocabulary: number // 已掌握词汇数
  studyDays: number        // 学习天数
}

// 学习详细统计
export interface StudyDetail {
  courseCount: number      // 学习课程数
  totalCourseTime: number // 课程总时长(分钟)
  vocabularyCount: number // 词汇个数
  vocabularyTimes: number // 词汇学习次数
  examCount: number       // 测验次数
  examAvgScore: number    // 测验平均分
}

// 导出包含所有类型的集合（可选，方便批量导入）
export type StatisticsTypes = {
  ScoreStatistics: ScoreStatistics
  StudyTimeStatistics: StudyTimeStatistics
  VocabularyFrequency: VocabularyFrequency
  ProgressStatistics: ProgressStatistics
  StudyRecordVO: StudyRecordVO
  StudyOverview: StudyOverview
  StudyDetail: StudyDetail
}