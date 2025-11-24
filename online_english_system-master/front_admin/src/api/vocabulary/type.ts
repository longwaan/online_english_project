// 词汇类型定义
export interface Vocabulary {
  id: string
  word: string
  phonetic: string  // 添加音标字段
  meaning: string
  example: string
  difficultyLevel: '初级' | '中级' | '高级'
  isPhrase: '单词' | '词组'
  createTime: string
}

// 词汇信息接口
export interface VocabularyInfo {
  id: string
  word: string
  meaning: string
  example: string
  courseId: string
  chapterId: string
}

// 分页参数接口
export interface VocabularyPageParams {
  current: number
  pageSize: number
  difficultyLevel?: string
  isPhrase?: string
}