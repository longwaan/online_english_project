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

export interface PostPageParams {
  content?: string
  current: number
  pageSize: number
  orTags?: string[]
  searchText?: string
  sortField?: string
  sortOrder?: string
}

export interface AddPostParams {
  title: string
  content: string
  tags: string[]
}

export interface UpdatePostParams {
  id: string | number
  title: string
  content: string
  tags: string[]
}

export interface CommentParams {
  current: number
  pageSize: number
  postId: string | number
}

export interface AddCommentParams {
  content: string
  postId: string | number
  replyTo?: string | number
}