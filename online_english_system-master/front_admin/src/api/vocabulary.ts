import request from '@/utils/request'

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
interface VocabularyPageParams {
  current: number
  pageSize: number
  difficultyLevel?: string
  isPhrase?: string
}

// 获取词汇列表
export function getVocabularyList(params: VocabularyPageParams) {
  return request({
    url: '/vocabulary/list/page',
    method: 'get',
    params
  })
}

// 搜索词汇
export function searchVocabulary(keyword: string) {
  return request({
    url: '/vocabulary/search',
    method: 'get',
    params: { keyword }
  })
}

// 获取词汇详情
export function getVocabularyDetail(id: string) {
  return request({
    url: '/vocabulary/get',
    method: 'get',
    params: { id }
  })
}

// 添加词汇
export function addVocabulary(data: Partial<Vocabulary>) {
  return request({
    url: '/vocabulary/add',
    method: 'post',
    data: {
      word: data.word,
      phonetic: data.phonetic,
      meaning: data.meaning,
      example: data.example,
      difficultyLevel: data.difficultyLevel,
      isPhrase: data.isPhrase
    }
  })
}

// 更新词汇
export function updateVocabulary(data: Vocabulary) {
  return request({
    url: '/vocabulary/update',
    method: 'post',
    data: {
      id: data.id,
      word: data.word,
      phonetic: data.phonetic,
      meaning: data.meaning,
      example: data.example,
      difficultyLevel: data.difficultyLevel,
      isPhrase: data.isPhrase
    }
  })
}

// 删除词汇
export function deleteVocabulary(id: string) {
  return request({
    url: '/vocabulary/delete',
    method: 'post',
    data: { id }
  })
} 