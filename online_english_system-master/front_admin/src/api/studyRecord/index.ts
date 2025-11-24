import request from '@/utils/request'
import type { StudyRecord, CreateStudyRecordParams } from './type'

// API路径枚举定义
enum API {
  STUDY_RECORD_LIST = '/study_record/list/page',
  STUDY_RECORD_DELETE = '/study_record/delete',
  STUDY_RECORD_ADD = '/study_record/add'
}

// 获取学习记录列表
const getStudyRecordList = (params: {
  current: number
  pageSize: number
}) => {
  return request({
    url: API.STUDY_RECORD_LIST,
    method: 'get',
    params
  })
}

// 删除学习记录
const deleteStudyRecord = (id: string | number) => {
  return request({
    url: API.STUDY_RECORD_DELETE,
    method: 'post',
    data: { id }
  })
}

// 创建学习记录
const createStudyRecord = (data: CreateStudyRecordParams) => {
  return request({
    url: API.STUDY_RECORD_ADD,
    method: 'post',
    data
  })
}

export {
  getStudyRecordList,
  deleteStudyRecord,
  createStudyRecord
}