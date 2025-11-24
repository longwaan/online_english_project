import axios from 'axios'
import type { DictListParams, TranslationParams, DictVoiceParams } from './type'

// API路径枚举定义
enum API {
  DICT_SUGGEST = '/dict/suggest',
  DICT_JSONAPI = '/dict/jsonapi',
  DICT_DICTVOICE = '/dict/dictvoice'
}

// 搜单词和推荐词
const getDictList = (params: DictListParams) => {
  return axios.get(`${API.DICT_SUGGEST}?q=${params.q}&num=10&doctype=json`).then(res => res.data)
}

// 翻译
const getTranslation = (params: TranslationParams) => {
  return axios.get(`${API.DICT_JSONAPI}?q=${params.q}`).then(res => res.data)
}

// 获取单词发音
const getDictVoice = (params: DictVoiceParams) => {
  return axios.get(`${API.DICT_DICTVOICE}?type=0&audio=${params.audio}`)
}

export {
  getDictList,
  getTranslation,
  getDictVoice
}