import request from '@/utils/request'
import type {
  StudyRecordAddRequest,
  StudyRecordVO,
  CheckVocabularyRecordResponse,
  AddStudyRecordResponse,
  GetStudyRecordByIdResponse,
  UpdateStudyRecordTimeResponse,
  UpdateStudyRecordProgressResponse
} from '@/api/studyRecord/type'

// API路径枚举定义
enum API {
  CHECK_VOCABULARY_RECORD = '/study_record/check/vocabulary',
  ADD_STUDY_RECORD = '/study_record/add',
  GET_STUDY_RECORD_BY_ID = '/study_record/get',
  UPDATE_STUDY_RECORD_TIME = '/study_record/time',
  UPDATE_STUDY_RECORD_PROGRESS = '/study_record/progress'
}

/**
 * 获取词汇最近的学习记录ID
 * @param vocabularyId 词汇ID
 * @returns 最近的学习记录ID，如果不存在则返回null
 */
const checkVocabularyRecord = (vocabularyId: number) => {
  return request.get<any, CheckVocabularyRecordResponse>(`${API.CHECK_VOCABULARY_RECORD}/${vocabularyId}`)
}

/**
 * 添加学习记录
 */
const addStudyRecord = (data: StudyRecordAddRequest) => {
  return request.post<any, AddStudyRecordResponse>(API.ADD_STUDY_RECORD, data)
}

/**
 * 获取学习记录详情
 */
const getStudyRecordById = (id: number) => {
  return request.get<any, GetStudyRecordByIdResponse>(`${API.GET_STUDY_RECORD_BY_ID}?id=${id}`)
}

/**
 * 更新学习时长
 */
const updateStudyRecordTime = (id: string | number, studyTime: number) => {
  return request.post<any, UpdateStudyRecordTimeResponse>(`${API.UPDATE_STUDY_RECORD_TIME}/${id}?studyTime=${studyTime}`)
}

/**
 * 更新学习进度
 */
const updateStudyRecordProgress = (id: string | number, progress: number) => {
  return request.post<any, UpdateStudyRecordProgressResponse>(`${API.UPDATE_STUDY_RECORD_PROGRESS}/${id}?progress=${progress}`)
}

export { checkVocabularyRecord, addStudyRecord, getStudyRecordById, updateStudyRecordTime, updateStudyRecordProgress }