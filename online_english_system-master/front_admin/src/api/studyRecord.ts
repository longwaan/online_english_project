import request from '@/utils/request'

// 学习记录类型定义
export interface StudyRecord {
  id: string
  userId: string
  userVO: {
    id: string
    userName: string
    userAvatar: string
    userProfile: string | null
    userRole: string
    createTime: string | null
  }
  courseId: string | null
  courseVO: {
    id: string
    title: string
    description: string
    coverImage: string
    level: string
    status: number
    chapterCount: number
    chapterList: Array<{
      id: string
      courseVO: any
      title: string
      content: string
      coverImage: string
      videoUrl: string
      duration: number
      createTime: string
      updateTime: string
    }>
    createTime: string
    updateTime: string
  } | null
  examId: string | null
  examVO: {
    id: string
    title: string
    description: string
    totalScore: number
    startTime: string
    endTime: string
    questionList: any | null
    createTime: string
  } | null
  vocabularyId: string | null
  vocabularyVO: any | null
  progress: number
  status: string
  studyTime: number
  score: number | null
  createTime: string
}

// 获取学习记录列表
export function getStudyRecordList(params: {
  current: number
  pageSize: number
}) {
  return request({
    url: '/study_record/list/page',
    method: 'get',
    params
  })
}

// 删除学习记录
export function deleteStudyRecord(id: string | number) {
  return request({
    url: '/study_record/delete',
    method: 'post',
    data: { id }
  })
}

// 创建学习记录
export interface CreateStudyRecordParams {
  userId: number
  courseId?: number
  examId?: number
  vocabularyId?: number
  progress: number
  status: string
  studyTime: number
  score?: number
}

export function createStudyRecord(data: CreateStudyRecordParams) {
  return request({
    url: '/study_record/add',
    method: 'post',
    data
  })
} 