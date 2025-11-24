import request from '@/utils/request'
import type { CourseInfo, CourseQueryParams } from './type'

// API路径枚举定义
enum API {
  COURSE_LIST_PAGE = '/course/list/page',
  COURSE_GET = '/course/get',
  COURSE_ADD = '/course/add',
  COURSE_UPDATE = '/course/update',
  COURSE_DELETE = '/course/delete',
  COURSE_UPLOAD_COVER = '/course/upload/cover'
}

// 分页获取课程列表
const getCourseList = (params: CourseQueryParams) => {
  return request({
    url: API.COURSE_LIST_PAGE,
    method: 'get',
    params
  })
}

// 获取课程详情
const getCourseDetail = (id: number) => {
  return request({
    url: API.COURSE_GET,
    method: 'get',
    params: { id }
  })
}

// 添加课程
const addCourse = (courseInfo: Omit<CourseInfo, 'id'>, coverFile?: File) => {
  const formData = new FormData()
  formData.append('courseInfo', JSON.stringify(courseInfo))
  if (coverFile) {
    formData.append('coverFile', coverFile)
  }
  return request({
    url: API.COURSE_ADD,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 更新课程
const updateCourse = (courseInfo: CourseInfo, coverFile?: File) => {
  // 确保 courseInfo 中有 id
  if (!courseInfo.id) {
    throw new Error('课程ID不能为空')
  }

  const formData = new FormData()
  formData.append('courseInfo', JSON.stringify(courseInfo))
  if (coverFile) {
    formData.append('coverFile', coverFile)
  }
  return request({
    url: API.COURSE_UPDATE,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除课程
const deleteCourse = (id: number) => {
  return request({
    url: API.COURSE_DELETE,
    method: 'post',
    data: { id }
  })
}

// 上传课程封面
const uploadCourseCover = (courseId: number, file: File) => {
  const formData = new FormData()
  formData.append('courseId', courseId.toString())
  formData.append('file', file)
  return request({
    url: API.COURSE_UPLOAD_COVER,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

export {
  getCourseList,
  getCourseDetail,
  addCourse,
  updateCourse,
  deleteCourse,
  uploadCourseCover
}