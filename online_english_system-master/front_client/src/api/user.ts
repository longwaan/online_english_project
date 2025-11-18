import request from '@/utils/request'

// 用户信息接口
export interface UserInfo {
  id: string
  userName: string | null
  userAvatar: string | null
  userProfile: string | null
  userRole: 'user' | 'admin'
  createTime: string
  updateTime: string
}

// 更新用户信息参数
export interface UpdateUserParams {
  id?: string
  userName: string
  userProfile: string
}

// 修改密码参数
export interface ChangePasswordParams {
  userName: string
  userOldPassword: string
  userNewPassword: string
  checkPassword: string
}

/**
 * 更新用户信息
 * @param params 用户信息参数
 * @returns Promise
 */
export function updateUserInfo(params: UpdateUserParams) {
  return request({
    url: '/user/update/my',
    method: 'post',
    data: params
  })
}

/**
 * 修改用户密码
 * @param params 密码参数
 * @returns Promise
 */
export function changePassword(params: ChangePasswordParams) {
  return request({
    url: '/user/update/myPassword',
    method: 'post',
    data: params
  })
}

/**
 * 上传用户头像
 * @param formData 包含文件的表单数据
 * @returns Promise
 */
export function uploadAvatar(formData: FormData) {
  return request({
    url: '/user/upload/avatar',
    method: 'post',
    data: formData,
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
}

/**
 * 获取用户 IP 信息
 * @returns Promise
 */
export function getUserIp() {
  return request({
    url: '/user/get/ip',
    method: 'get'
  })
}

/**
 * 获取用户详细信息
 * @returns Promise
 */
export function getUserInfo() {
  return request({
    url: '/user/info',
    method: 'get'
  })
} 