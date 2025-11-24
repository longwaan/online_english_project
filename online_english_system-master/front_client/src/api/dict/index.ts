import axios from 'axios'
import type {
  DictListParams,
  TranslationParams,
  DictVoiceParams,
  DictListResponse,
  TranslationResponse,
  DictVoiceResponse,
  DailyQuoteResponse
} from './type'

// API路径枚举定义
enum API {
  DICT_SUGGEST = '/dict/suggest',
  DICT_JSONAPI = '/dict/jsonapi',
  DICT_VOICE = '/dict/dictvoice',
  DAILY_QUOTE = '/daily/weapps/dailyquote/quote/'
}

/**
 * 搜单词和推荐词
 */
const getDictList = (params: DictListParams) => {
  return axios.get<any, DictListResponse>(`${API.DICT_SUGGEST}?q=${params.q}&num=10&doctype=json`)
}

/**
 * 翻译
 */
const getTranslation = (params: TranslationParams) => {
  return axios.get<any, TranslationResponse>(`${API.DICT_JSONAPI}?q=${params.q}`)
}

/**
 * 获取单词发音
 */
const getDictVoice = (params: DictVoiceParams) => {
  return axios.get<any, DictVoiceResponse>(`${API.DICT_VOICE}?type=0&audio=${params.audio}`)
}

/**
 * 扇贝每日一句
 */
const getDailyQuote = () => {
  return axios.get<any, DailyQuoteResponse>(API.DAILY_QUOTE)
}

export { getDictList, getTranslation, getDictVoice, getDailyQuote }