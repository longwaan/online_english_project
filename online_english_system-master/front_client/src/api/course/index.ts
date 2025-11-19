import request from '@/utils/request';
import type { CourseQueryParams, CourseVO, ChapterVO, PageResult } from './type';

enum API {
  COURSE_LIST_PAGE = '/course/list/page',
  COURSE_DETAIL = '/course/get'
}

// 判断课程是否已上线
export function isCourseOnline(course: CourseVO): boolean {
  return course.status === 1;
}

// 获取课程列表
const getCourseList = (params: CourseQueryParams) =>
  request.get<any, PageResult<CourseVO>>(API.COURSE_LIST_PAGE, { params });

// 获取课程详情
const getCourseDetail = (id: string) =>
  request.get<any, CourseVO>(API.COURSE_DETAIL, { params: { id } });

export {
  getCourseList,
  getCourseDetail
};