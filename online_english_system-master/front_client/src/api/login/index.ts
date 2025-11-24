import request from '@/utils/request'
import type { RegisterParams, LoginParams, UserInfo, BaseResponse } from './type'

enum API {
  REGISTER = '/user/register',
  LOGIN = '/user/login',
  LOGOUT = '/user/logout'
}

/**
 * 用户注册
 * @param params 注册参数
 */
const register = (params: RegisterParams) =>
  request.post<BaseResponse<number>>(API.REGISTER, params)

/**
 * 用户登录
 * @param params 登录参数
 */
const login = (params: LoginParams) =>
  request.post<BaseResponse<UserInfo>>(API.LOGIN, params)

/**
 * 用户退出登录
 */
const logout = () =>
  request.post<BaseResponse<void>>(API.LOGOUT)

export {
  register,
  login,
  logout
}