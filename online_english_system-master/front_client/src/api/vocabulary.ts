import request from '@/utils/request'

// 词汇难度级别
export type DifficultyLevel = '初级' | '中级' | '高级'

// 词汇类型
export type VocabularyType = '单词' | '词组'

// 词汇查询参数
export interface VocabularyQueryParams {
  current: number
  pageSize: number
  difficultyLevel?: DifficultyLevel
  isPhrase?: VocabularyType
}

// 词汇信息
export interface VocabularyVO {
  id: string
  word: string
  translation: string
  pronunciation: string
  example: string
  exampleTranslation: string
  difficultyLevel: DifficultyLevel
  isPhrase: VocabularyType
  createTime: string
  updateTime: string
}

// 词汇详情
export interface VocabularyDetailVO {
  id: string
  word: string
  phonetic: string      // 音标
  meaning: string       // 中文含义
  example: string       // 例句
  difficultyLevel: DifficultyLevel
  isPhrase: VocabularyType
  createTime: string
}

// 获取词汇列表
export function getVocabularyList(params: VocabularyQueryParams) {
  return request({
    url: '/vocabulary/list/page',
    method: 'get',
    params
  })
}

// 获取词汇详情
export function getVocabularyDetail(id: string) {
  return request({
    url: `/vocabulary/get?id=${id}`,
    method: 'get'
  })
} 