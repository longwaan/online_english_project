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
export interface ChapterSubmit {
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