import request from '@/utils/request'

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
interface PostPageParams {
  content?: string
  current: number
  pageSize: number
  orTags?: string[]
  searchText?: string
  sortField?: string
  sortOrder?: string
}

// 获取帖子列表
export function getPostList(params: PostPageParams) {
  return request({
    url: '/post/list/page/vo',
    method: 'post',
    data: params
  })
}

// 获取帖子详情
export function getPostDetail(id: string) {
  return request({
    url: '/post/get/vo',
    method: 'get',
    params: { id }
  })
}

// 添加帖子
export function addPost(data: {
  title: string;
  content: string;
  tags: string[];
}) {
  return request({
    url: '/post/add',
    method: 'post',
    data
  })
}

// 更新帖子
export function updatePost(data: {
  id: string | number;
  title: string;
  content: string;
  tags: string[];
}) {
  return request({
    url: '/post/update',
    method: 'post',
    data
  })
}

// 删除帖子
export function deletePost(id: string | number) {
  return request({
    url: '/post/delete',
    method: 'post',
    data: { id }
  })
}

// 获取评论列表
export function getCommentList(params: {
  current: number;
  pageSize: number;
  postId: string | number;
}) {
  return request({
    url: '/post_comment/list/page',
    method: 'get',
    params
  })
}

// 添加评论
export function addComment(data: {
  content: string;
  postId: string | number;
  replyTo?: string | number;
}) {
  return request({
    url: '/post_comment/add',
    method: 'post',
    data
  })
}

// 删除评论
export function deleteComment(id: string | number) {
  return request({
    url: '/post_comment/delete',
    method: 'post',
    data: { id }
  })
}

// 点赞评论
export function likeComment(id: string | number) {
  return request({
    url: `/post_comment/like/${id}`,
    method: 'post'
  })
}

// 取消点赞评论
export function unlikeComment(id: string | number) {
  return request({
    url: `/post_comment/unlike/${id}`,
    method: 'post'
  })
}

// 帖子点赞/取消点赞
export function togglePostThumb(postId: string | number) {
  return request({
    url: '/post_thumb/',
    method: 'post',
    data: { postId }
  })
}

// 帖子收藏/取消收藏
export function togglePostFavour(postId: string | number) {
  return request({
    url: '/post_favour/',
    method: 'post',
    data: { postId }
  })
} 