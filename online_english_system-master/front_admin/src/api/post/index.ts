import request from '@/utils/request'
import type { Post, PostPageParams } from './type'

// API路径枚举定义
enum API {
  POST_LIST_PAGE = '/post/list/page/vo',
  POST_GET = '/post/get/vo',
  POST_ADD = '/post/add',
  POST_UPDATE = '/post/update',
  POST_DELETE = '/post/delete',
  COMMENT_LIST_PAGE = '/post_comment/list/page',
  COMMENT_ADD = '/post_comment/add',
  COMMENT_DELETE = '/post_comment/delete',
  COMMENT_LIKE = '/post_comment/like',
  COMMENT_UNLIKE = '/post_comment/unlike',
  POST_THUMB = '/post_thumb/',
  POST_FAVOUR = '/post_favour/'
}

// 获取帖子列表
const getPostList = (params: PostPageParams) => {
  return request({
    url: API.POST_LIST_PAGE,
    method: 'post',
    data: params
  })
}

// 获取帖子详情
const getPostDetail = (id: string) => {
  return request({
    url: API.POST_GET,
    method: 'get',
    params: { id }
  })
}

// 添加帖子
const addPost = (data: {
  title: string;
  content: string;
  tags: string[];
}) => {
  return request({
    url: API.POST_ADD,
    method: 'post',
    data
  })
}

// 更新帖子
const updatePost = (data: {
  id: string | number;
  title: string;
  content: string;
  tags: string[];
}) => {
  return request({
    url: API.POST_UPDATE,
    method: 'post',
    data
  })
}

// 删除帖子
const deletePost = (id: string | number) => {
  return request({
    url: API.POST_DELETE,
    method: 'post',
    data: { id }
  })
}

// 获取评论列表
const getCommentList = (params: {
  current: number;
  pageSize: number;
  postId: string | number;
}) => {
  return request({
    url: API.COMMENT_LIST_PAGE,
    method: 'get',
    params
  })
}

// 添加评论
const addComment = (data: {
  content: string;
  postId: string | number;
  replyTo?: string | number;
}) => {
  return request({
    url: API.COMMENT_ADD,
    method: 'post',
    data
  })
}

// 删除评论
const deleteComment = (id: string | number) => {
  return request({
    url: API.COMMENT_DELETE,
    method: 'post',
    data: { id }
  })
}

// 点赞评论
const likeComment = (id: string | number) => {
  return request({
    url: `${API.COMMENT_LIKE}/${id}`,
    method: 'post'
  })
}

// 取消点赞评论
const unlikeComment = (id: string | number) => {
  return request({
    url: `${API.COMMENT_UNLIKE}/${id}`,
    method: 'post'
  })
}

// 帖子点赞/取消点赞
const togglePostThumb = (postId: string | number) => {
  return request({
    url: API.POST_THUMB,
    method: 'post',
    data: { postId }
  })
}

// 帖子收藏/取消收藏
const togglePostFavour = (postId: string | number) => {
  return request({
    url: API.POST_FAVOUR,
    method: 'post',
    data: { postId }
  })
}

export {
  getPostList,
  getPostDetail,
  addPost,
  updatePost,
  deletePost,
  getCommentList,
  addComment,
  deleteComment,
  likeComment,
  unlikeComment,
  togglePostThumb,
  togglePostFavour
}