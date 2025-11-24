import request from '@/utils/request'
import type { Chapter, ChapterInfo, PageResponse } from './type'

// API路径枚举定义
enum API {
  CHAPTER_LIST_PAGE = '/chapter/list/page',
  CHAPTER_LIST_BY_COURSE = '/chapter/list/course',
  CHAPTER_GET = '/chapter/get',
  CHAPTER_ADD = '/chapter/add',
  CHAPTER_UPDATE = '/chapter/update',
  CHAPTER_DELETE = '/chapter/delete',
  CHAPTER_UPLOAD_COVER = '/chapter/upload/cover',
  CHAPTER_UPLOAD_VIDEO = '/chapter/upload/video'
}

// 分页获取章节列表
const getChapterList = (params: {
  current: number
  pageSize: number
  courseId: string | number
}) => {
  return request<PageResponse<Chapter>>({
    url: API.CHAPTER_LIST_PAGE,
    method: 'get',
    params
  })
}

// 根据课程ID获取章节列表
const getChaptersByCourseId = (courseId: string | number) => {
  return request<Chapter[]>({
    url: `${API.CHAPTER_LIST_BY_COURSE}/${courseId}`,
    method: 'get'
  })
}

// 获取章节详情
const getChapterDetail = (id: string | number) => {
  return request<Chapter>({
    url: API.CHAPTER_GET,
    method: 'get',
    params: { id }
  })
}

// 添加章节
const addChapter = (chapterInfo: ChapterInfo) => {
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
    url: API.CHAPTER_ADD,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 更新章节
const updateChapter = (chapterInfo: ChapterInfo, coverFile?: File, videoFile?: File, duration?: number) => {
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
    url: API.CHAPTER_UPDATE,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除章节
const deleteChapter = (id: string | number) => {
  return request({
    url: API.CHAPTER_DELETE,
    method: 'post',
    data: { id }
  })
}

// 上传章节封面
const uploadChapterCover = (chapterId: string | number, file: File) => {
  const formData = new FormData()
  formData.append('chapterId', chapterId.toString())
  formData.append('file', file)
  return request({
    url: API.CHAPTER_UPLOAD_COVER,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 上传章节视频
const uploadChapterVideo = (chapterId: string | number, file: File, duration: number) => {
  const formData = new FormData()
  formData.append('chapterId', chapterId.toString())
  formData.append('file', file)
  formData.append('duration', duration.toString())
  return request({
    url: API.CHAPTER_UPLOAD_VIDEO,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export {
  getChapterList,
  getChaptersByCourseId,
  getChapterDetail,
  addChapter,
  updateChapter,
  deleteChapter,
  uploadChapterCover,
  uploadChapterVideo
}