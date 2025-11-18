import request from "@/utils/request";
import type { AddCommentParams, AddPostParams, CommentParams, Post, PostPageParams, UpdatePostParams } from "./type";

enum API {
  // 帖子相关
  POST_LIST_PAGE = '/post/list/page/vo',
  POST_DETAIL = '/post/get/vo',
  POST_ADD = '/post/add',
  POST_UPDATE = '/post/update',
  POST_DELETE = '/post/delete',
  POST_THUMB_TOGGLE = '/post_thumb/',
  POST_FAVOUR_TOGGLE = '/post_favour/',

  // 评论相关
  COMMENT_LIST = '/post_comment/list/page',
  COMMENT_ADD = '/post_comment/add',
  COMMENT_DELETE = '/post_comment/delete',
  COMMENT_LIKE = '/post_comment/like/',
  COMMENT_UNLIKE = '/post_comment/unlike/'
}

// 获取帖子列表
const getPostList = (params: PostPageParams) =>
  request.post<any, Post[]>(API.POST_LIST_PAGE, params);

// 获取帖子详情
const getPostDetail = (id: string) =>
  request.get<any, Post>(API.POST_DETAIL, { params: { id } });

// 添加帖子
const addPost = (data: AddPostParams) =>
  request.post<any, any>(API.POST_ADD, data);

// 更新帖子
const updatePost = (data: UpdatePostParams) =>
  request.post<any, any>(API.POST_UPDATE, data);

// 删除帖子
const deletePost = (id: string | number) =>
  request.post<any, any>(API.POST_DELETE, { id });

// 获取评论列表
const getCommentList = (params: CommentParams) =>
  request.get<any, any>(API.COMMENT_LIST, { params });

// 添加评论
const addComment = (data: AddCommentParams) =>
  request.post<any, any>(API.COMMENT_ADD, data);

// 删除评论
const deleteComment = (id: string | number) =>
  request.post<any, any>(API.COMMENT_DELETE, { id });

// 点赞评论
const likeComment = (id: string | number) =>
  request.post<any, any>(API.COMMENT_LIKE + id);

// 取消点赞评论
const unlikeComment = (id: string | number) =>
  request.post<any, any>(API.COMMENT_UNLIKE + id);

// 帖子点赞/取消点赞
const togglePostThumb = (postId: string | number) =>
  request.post<any, any>(API.POST_THUMB_TOGGLE, { postId });

// 帖子收藏/取消收藏
const togglePostFavour = (postId: string | number) =>
  request.post<any, any>(API.POST_FAVOUR_TOGGLE, { postId });

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

