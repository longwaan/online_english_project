import type { PageParams } from '@/types/common'

export interface UserListParams extends PageParams {
  userName?: string
  userProfile?: string
  userRole?: string
  sortField?: string
  sortOrder?: string
}