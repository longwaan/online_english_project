import request from '@/utils/request'

// 课程信息接口
interface CourseInfo {
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
interface CourseQueryParams {
  current: number
  pageSize: number
  title?: string
  description?: string
  level?: string
  status?: number
}

// 分页获取课程列表
export function getCourseList(params: CourseQueryParams) {
  return request({
    url: '/course/list/page',
    method: 'get',
    params
  })
}

// 获取课程详情
export function getCourseDetail(id: number) {
  return request({
    url: '/course/get',
    method: 'get',
    params: { id }
  })
}

// 添加课程
export function addCourse(courseInfo: Omit<CourseInfo, 'id'>, coverFile?: File) {
  const formData = new FormData()
  formData.append('courseInfo', JSON.stringify(courseInfo))
  if (coverFile) {
    formData.append('coverFile', coverFile)
  }
  return request({
    url: '/course/add',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 更新课程
export function updateCourse(courseInfo: CourseInfo, coverFile?: File) {
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
    url: '/course/update',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 删除课程
export function deleteCourse(id: number) {
  return request({
    url: '/course/delete',
    method: 'post',
    data: { id }
  })
}

// 上传课程封面
export function uploadCourseCover(courseId: number, file: File) {
  const formData = new FormData()
  formData.append('courseId', courseId.toString())
  formData.append('file', file)
  return request({
    url: '/course/upload/cover',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
} 