// 帖子类型定义
export interface Post {
  id: string
  title: string
  content: string
  thumbNum: number
  favourNum: number
  userId: string
  createTime: string
  updateTime: string
  tagList: string[]
  user: {
    id: string
    userName: string
    userAvatar: string
    userProfile: string
    userRole: string
    createTime: string
  }
  hasThumb: boolean
  hasFavour: boolean
}

// 分页参数接口
export interface PostPageParams {
  content?: string
  current: number
  pageSize: number
  orTags?: string[]
  searchText?: string
  sortField?: string
  sortOrder?: string
}