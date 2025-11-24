import request from '@/utils/request'
import type { Vocabulary, VocabularyPageParams } from './type'

// API路径枚举定义
enum API {
  VOCABULARY_LIST_PAGE = '/vocabulary/list/page',
  VOCABULARY_SEARCH = '/vocabulary/search',
  VOCABULARY_GET = '/vocabulary/get',
  VOCABULARY_ADD = '/vocabulary/add',
  VOCABULARY_UPDATE = '/vocabulary/update',
  VOCABULARY_DELETE = '/vocabulary/delete'
}

// 获取词汇列表
const getVocabularyList = (params: VocabularyPageParams) => {
  return request({
    url: API.VOCABULARY_LIST_PAGE,
    method: 'get',
    params
  })
}

// 搜索词汇
const searchVocabulary = (keyword: string) => {
  return request({
    url: API.VOCABULARY_SEARCH,
    method: 'get',
    params: { keyword }
  })
}

// 获取词汇详情
const getVocabularyDetail = (id: string) => {
  return request({
    url: API.VOCABULARY_GET,
    method: 'get',
    params: { id }
  })
}

// 添加词汇
const addVocabulary = (data: Partial<Vocabulary>) => {
  return request({
    url: API.VOCABULARY_ADD,
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
const updateVocabulary = (data: Vocabulary) => {
  return request({
    url: API.VOCABULARY_UPDATE,
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
const deleteVocabulary = (id: string) => {
  return request({
    url: API.VOCABULARY_DELETE,
    method: 'post',
    data: { id }
  })
}

export {
  getVocabularyList,
  searchVocabulary,
  getVocabularyDetail,
  addVocabulary,
  updateVocabulary,
  deleteVocabulary
}