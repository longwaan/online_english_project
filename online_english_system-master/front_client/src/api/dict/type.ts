// 定义dict模块相关的类型

// 搜索单词参数类型
export interface DictListParams {
  q: string
}

// 翻译参数类型
export interface TranslationParams {
  q: string
}

// 获取单词发音参数类型
export interface DictVoiceParams {
  audio: string
}

// 搜索结果响应类型
export interface DictListResponse {
  // 根据实际API响应结构定义
  [key: string]: any
}

// 翻译响应类型
export interface TranslationResponse {
  // 根据实际API响应结构定义
  [key: string]: any
}

// 单词发音响应类型
export interface DictVoiceResponse {
  // 根据实际API响应结构定义
  [key: string]: any
}

// 每日一句响应类型
export interface DailyQuoteResponse {
  // 根据实际API响应结构定义
  [key: string]: any
}