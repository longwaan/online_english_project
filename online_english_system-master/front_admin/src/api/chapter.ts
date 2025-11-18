import request from '@/utils/request'

// 章节类型定义
export interface Chapter {
  id: string
  title: string
  content: string
  coverImage: string
  videoUrl: string
  duration: number
  createTime: string
  updateTime: string
  courseVO?: Course // 添加课程信息
}

// 课程类型定义
export interface Course {
  id: string
  title: string
  description: string
  coverImage: string
  level: string
  status: number
  createTime: string
  updateTime: string
  chapterCount: number | null
  chapterList: Chapter[] | null
}

// 分页响应类型
export interface PageResponse<T> {
  records: T[]
  total: number
  size: number
  current: number
}

// 章节信息接口
export interface ChapterInfo {
  id?: number | string
  title: string
  content: string
  courseId: number | string
  coverImage: string
  videoUrl: string
  duration: number
  createTime?: string
  updateTime?: string
  isDelete?: number
}

// 章节提交类型
interface ChapterSubmit {
  id?: number | string
  content: string
  courseId: number | string
  coverImage: string
  createTime?: string
  duration: number
  isDelete?: number
  title: string
  updateTime?: string
  videoUrl: string
}

// 分页获取章节列表
export const getChapterList = (params: {
  current: number
  pageSize: number
  courseId: string | number
}) => {
  return request<PageResponse<Chapter>>({
    url: '/chapter/list/page',
    method: 'get',
    params
  })
}

// 根据课程ID获取章节列表
export const getChaptersByCourseId = (courseId: string | number) => {
  return request<Chapter[]>({
    url: `/chapter/list/course/${courseId}`,
    method: 'get'
  })
}

// 获取章节详情
export const getChapterDetail = (id: string | number) => {
  return request<Chapter>({
    url: '/chapter/get',
    method: 'get',
    params: { id }
  })
}

// 添加章节
export function addChapter(chapterInfo: ChapterInfo) {
  const formData = new FormData()
  
  // 添加章节基本信息
  const submitData = {
    title: chapterInfo.title,
    content: chapterInfo.content,
    courseId: chapterInfo.courseId,
    coverImage: chapterInfo.coverImage,
    videoUrl: chapterInfo.videoUrl,
    duration: chapterInfo.duration,
    isDelete: 0
  }
  
  // 将对象转换为Blob，并添加到FormData
  const chapterInfoBlob = new Blob([JSON.stringify(submitData)], {
    type: 'application/json'
  })
  formData.append('chapterInfo', chapterInfoBlob)

  return request({
    url: '/chapter/add',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 更新章节
export function updateChapter(chapterInfo: ChapterInfo, coverFile?: File, videoFile?: File, duration?: number) {
  const formData = new FormData()
  
  // 添加章节基本信息
  const submitData = {
    id: chapterInfo.id,
    title: chapterInfo.title,
    content: chapterInfo.content,
    courseId: chapterInfo.courseId,
    coverImage: chapterInfo.coverImage,
    videoUrl: chapterInfo.videoUrl,
    duration: chapterInfo.duration,
    isDelete: chapterInfo.isDelete ?? 0
  }
  
  // 将对象转换为Blob，并添加到FormData
  const chapterInfoBlob = new Blob([JSON.stringify(submitData)], {
    type: 'application/json'
  })
  formData.append('chapterInfo', chapterInfoBlob)
  
  // 添加封面文件
  if (coverFile) {
    formData.append('coverFile', coverFile)
  }
  
  // 添加视频文件和时长
  if (videoFile) {
    formData.append('videoFile', videoFile)
    if (duration) {
      formData.append('duration', duration.toString())
    }
  }

  return request({
    url: '/chapter/update',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除章节
export function deleteChapter(id: string | number) {
  return request({
    url: '/chapter/delete',
    method: 'post',
    data: { id }
  })
}

// 上传章节封面
export function uploadChapterCover(chapterId: string | number, file: File) {
  const formData = new FormData()
  formData.append('chapterId', chapterId.toString())
  formData.append('file', file)
  return request({
    url: '/chapter/upload/cover',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 上传章节视频
export function uploadChapterVideo(chapterId: string | number, file: File, duration: number) {
  const formData = new FormData()
  formData.append('chapterId', chapterId.toString())
  formData.append('file', file)
  formData.append('duration', duration.toString())
  return request({
    url: '/chapter/upload/video',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
} 