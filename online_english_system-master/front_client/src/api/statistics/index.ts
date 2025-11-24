import request from '@/utils/request'
import type { BaseResponse } from '@/types/index'
import type {
  ScoreStatistics,
  StudyTimeStatistics,
  VocabularyFrequency,
  ProgressStatistics,
  StudyRecordVO,
  StudyOverview,
  StudyDetail
} from './type'

enum API {
  SCORE_STATISTICS = '/study_record/statistics/score',
  STUDY_TIME_STATISTICS = '/study_record/statistics/study-time',
  VOCABULARY_FREQUENCY = '/study_record/vocabulary/frequency/',
  PROGRESS_STATISTICS = '/study_record/statistics/progress',
  COURSE_STUDY_RECORD = '/study_record/check/course/',
  STUDY_OVERVIEW = '/study_record/statistics/overview',
  STUDY_DETAIL = '/study_record/statistics/detail'
}

// 获取成绩统计
const getScoreStatistics = () =>
  request.get<BaseResponse<ScoreStatistics>>(API.SCORE_STATISTICS)

// 获取学习时长统计
const getStudyTimeStatistics = () =>
  request.get<BaseResponse<StudyTimeStatistics>>(API.STUDY_TIME_STATISTICS)

// 获取词汇频率统计
const getVocabularyFrequency = (userId: string) =>
  request.get<BaseResponse<VocabularyFrequency[]>>(`${API.VOCABULARY_FREQUENCY}${userId}`)

// 获取进度统计
const getProgressStatistics = () =>
  request.get<BaseResponse<ProgressStatistics>>(API.PROGRESS_STATISTICS)

// 获取课程学习记录
const getCourseStudyRecord = (courseId: string) =>
  request.get<BaseResponse<StudyRecordVO>>(`${API.COURSE_STUDY_RECORD}${courseId}`)

// 获取学习概况统计
const getStudyOverview = () =>
  request.get<BaseResponse<StudyOverview>>(API.STUDY_OVERVIEW)

// 获取学习详细统计
const getStudyDetail = () =>
  request.get<BaseResponse<StudyDetail>>(API.STUDY_DETAIL)

export {
  getScoreStatistics,
  getStudyTimeStatistics,
  getVocabularyFrequency,
  getProgressStatistics,
  getCourseStudyRecord,
  getStudyOverview,
  getStudyDetail
}