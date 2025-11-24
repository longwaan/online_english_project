import request from '@/utils/request'
import type {
  VocabularyQueryParams,
  VocabularyVO,
  VocabularyDetailVO,
  DifficultyLevel,
  VocabularyType
} from './type'

enum API {
  VOCABULARY_LIST_PAGE = '/vocabulary/list/page',
  VOCABULARY_DETAIL = '/vocabulary/get'
}

// 获取词汇列表
const getVocabularyList = (params: VocabularyQueryParams) =>
  request.get<any, any>(API.VOCABULARY_LIST_PAGE, { params });

// 获取词汇详情
const getVocabularyDetail = (id: string) =>
  request.get<any, any>(`${API.VOCABULARY_DETAIL}?id=${id}`);

export {
  getVocabularyList,
  getVocabularyDetail
};