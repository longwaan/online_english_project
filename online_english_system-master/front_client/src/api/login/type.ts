// 注册参数类型
export interface RegisterParams {
  userAccount: string
  userPassword: string
  checkPassword: string
}

// 登录参数类型
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

// 基础响应类型
export interface BaseResponse<T> {
  code: number
  data: T
  message: string
}