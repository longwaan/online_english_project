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