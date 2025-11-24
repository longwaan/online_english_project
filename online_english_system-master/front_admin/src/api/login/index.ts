import request from '@/utils/request'
import type { RegisterParams, LoginParams, UserInfo, BaseResponse } from './type'

// API路径枚举定义
enum API {
  USER_REGISTER = '/user/register',
  USER_LOGIN = '/user/login',
  USER_LOGOUT = '/user/logout'
}

/**
 * 用户注册
 * @param params 注册参数
 */
const register = (params: RegisterParams) => {
  return request.post<BaseResponse<number>>(API.USER_REGISTER, params)
}

/**
 * 用户登录
 * @param params 登录参数
 */
const login = (params: LoginParams) => {
  return request.post<BaseResponse<UserInfo>>(API.USER_LOGIN, params)
}

/**
 * 用户退出登录
 */
const logout = () => {
  return request.post<BaseResponse<void>>(API.USER_LOGOUT)
}

export {
  register,
  login,
  logout
}