import request from '@/utils/request'
import type { UserListParams } from './type'

// API路径枚举定义
enum API {
  USER_LIST_PAGE = '/user/list/page',
  USER_UPDATE = '/user/update',
  USER_UPLOAD_AVATAR = '/api/user/upload/avatar',
  USER_ADD = '/user/add',
  USER_DELETE = '/user/delete',
  USER_GET = '/user/get',
  USER_RESET_PASSWORD = '/user/update/myPassword',
  USER_GET_IP = '/user/get/ip'
}

// 获取用户列表
const getUserList = (params: UserListParams) => {
  return request({
    url: API.USER_LIST_PAGE,
    method: 'post',
    data: params
  })
}

// 更新用户信息
const updateUser = (data: {
  id: number
  userAvatar: string
  userName: string
  userProfile: string
  userRole: string
}) => {
  return request({
    url: API.USER_UPDATE,
    method: 'post',
    data
  })
}

// 上传用户头像
const uploadAvatar = (file: File) => {
  const formData = new FormData()
  formData.append('file', file)
  return request({
    url: API.USER_UPLOAD_AVATAR,
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

// 添加用户
const addUser = (data: {
  userAccount: string
  userAvatar: string
  userName: string
  userRole: string
}) => {
  return request({
    url: API.USER_ADD,
    method: 'post',
    data
  })
}

// 删除用户
const deleteUser = (id: number) => {
  return request({
    url: API.USER_DELETE,
    method: 'post',
    data: {id}
  })
}

// 获取用户详情
const getUserDetail = (id: number) => {
  return request({
    url: API.USER_GET,
    method: 'get',
    params: {id}
  })
}

// 重置用户密码
const resetUserPassword = (data: {
  checkPassword: string
  userName: string
  userNewPassword: string
  userOldPassword: string
}) => {
  return request({
    url: API.USER_RESET_PASSWORD,
    method: 'post',
    data
  })
}

//获取用户ip地址
const getUserIp = () => {
  return request({
    url: API.USER_GET_IP,
    method: 'get'
  })
}

export {
  getUserList,
  updateUser,
  uploadAvatar,
  addUser,
  deleteUser,
  getUserDetail,
  resetUserPassword,
  getUserIp
}