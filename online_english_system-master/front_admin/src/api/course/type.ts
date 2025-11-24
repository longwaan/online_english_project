// 课程信息接口
export interface CourseInfo {
  id?: number
  title: string
  description: string
  coverImage: string
  level: string
  status: number
  createTime?: string
  updateTime?: string
  isDelete?: number
}

// 课程查询参数
export interface CourseQueryParams {
  current: number
  pageSize: number
  title?: string
  description?: string
  level?: string
  status?: number
}