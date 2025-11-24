import request from '@/utils/request'
import type { UserInfo, UpdateUserParams, ChangePasswordParams } from './type'

// API路径枚举定义
enum API {
  UPDATE_USER_INFO = '/user/update/my',
  CHANGE_PASSWORD = '/user/update/myPassword',
  UPLOAD_AVATAR = '/user/upload/avatar',
  GET_USER_IP = '/user/get/ip',
  GET_USER_INFO = '/user/info'
}

/**
 * 更新用户信息
 * @param params 用户信息参数
 * @returns Promise
 */
const updateUserInfo = (params: UpdateUserParams) => {
  return request.post(API.UPDATE_USER_INFO, params)
}

/**
 * 修改用户密码
 * @param params 密码参数
 * @returns Promise
 */
const changePassword = (params: ChangePasswordParams) => {
  return request.post(API.CHANGE_PASSWORD, params)
}

/**
 * 上传用户头像
 * @param formData 包含文件的表单数据
 * @returns Promise
 */
const uploadAvatar = (formData: FormData) => {
  return request.post(API.UPLOAD_AVATAR, formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 获取用户 IP 信息
 * @returns Promise
 */
const getUserIp = () => {
  return request.get(API.GET_USER_IP)
}

/**
 * 获取用户详细信息
 * @returns Promise
 */
const getUserInfo = () => {
  return request.get(API.GET_USER_INFO)
}

export { updateUserInfo, changePassword, uploadAvatar, getUserIp, getUserInfo }