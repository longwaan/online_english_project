import request from '@/utils/request'

// 课程列表分页查询参数
export interface CourseQueryParams {
  current: number
  pageSize: number
  level?: string
  title?: string
}

// 章节信息
export interface ChapterVO {
  id: string
  courseVO: any
  title: string
  content: string
  coverImage: string
  videoUrl: string
  duration: number
  createTime: string
  updateTime: string
}

// 课程信息
export interface CourseVO {
  id: string
  title: string
  description: string
  coverImage: string
  level: string
  status: number  // 课程状态：0-未上线，1-已上线
  chapterCount: number
  chapterList: ChapterVO[]
  createTime: string
  updateTime: string
}

// 分页结果
export interface PageResult<T> {
  records: T[]
  total: string
  size: string
  current: string
  pages: string
}

// 课程状态常量
export const COURSE_STATUS = {
  OFFLINE: 0,  // 未上线
  ONLINE: 1    // 已上线
}

// 判断课程是否已上线
export function isCourseOnline(course: CourseVO): boolean {
  return course.status === COURSE_STATUS.ONLINE;
}

// 获取课程列表
export function getCourseList(params: CourseQueryParams) {
  return request({
    url: '/course/list/page',
    method: 'get',
    params
  })
}

// 获取课程详情
export function getCourseDetail(id: string) {
  return request({
    url: `/course/get?id=${id}`,
    method: 'get'
  })
} 