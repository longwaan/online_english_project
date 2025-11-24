export interface RegisterParams {
  userAccount: string
  userPassword: string
  checkPassword: string
}

export interface LoginParams {
  userAccount: string
  userPassword: string
}

// 登录接口返回的用户信息类型
export interface UserInfo {
  id: string
  userName: string | null
  userAvatar: string | null
  userProfile: string | null
  userRole: 'user' | 'admin'
  createTime: string
  updateTime: string
}

export interface BaseResponse<T> {
  code: number
  data: T
  message: string
}