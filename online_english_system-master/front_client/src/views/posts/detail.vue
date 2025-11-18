<script setup lang="ts">
import {ref, onMounted} from 'vue'
import {useRoute} from 'vue-router'
// import {
//   getPostDetail,
//   addComment,
//   togglePostThumb,
//   togglePostFavour,
//   type Post,
//   getCommentList,
//   deleteComment,
//   likeComment
// } from '@/api/post'
import {
  getPostDetail,
  addComment,
  togglePostThumb,
  togglePostFavour,
  getCommentList,
  deleteComment,
  likeComment
} from '@/api/post/index'
import {ElMessage, ElMessageBox} from 'element-plus'
import {formatDate} from '@/utils/format'
import {ChatDotRound, Pointer, Star, Delete, Close, Watermelon} from '@element-plus/icons-vue'
import {useUserStore} from '@/stores/modules/user'
import type { Post } from '@/api/post/type'

const route = useRoute()
const apiUrl = import.meta.env.VITE_API_URL || ''
const userStore = useUserStore()

// 帖子数据
const post = ref<Post>()
const loading = ref(false)

// 评论相关
const commentContent = ref('')
const commentLoading = ref(false)
const replyTo = ref<any>(null)  // 回复的评论对象
const commentParams = ref({
  current: 1,
  pageSize: 10,
  postId: ''
})
const commentTotal = ref<number>(0)
const comments = ref([])

// 获取完整的头像URL
const getFullAvatarUrl = (avatarPath: string) => {
  if (!avatarPath) return ''  // Element Plus 会自动显示默认头像
  if (avatarPath.startsWith('http')) return avatarPath
  return `${apiUrl}${avatarPath}`
}

// 获取帖子详情
const fetchPostDetail = async () => {
  loading.value = true
  try {
    const res = await getPostDetail(route.params.id as string)
    if (res.code === 0 && res.data) {
      post.value = res.data
      await fetchComments()
    }
  } catch (error) {
    console.error('获取帖子详情失败:', error)
    ElMessage.error('获取帖子详情失败')
  } finally {
    loading.value = false
  }
}

// 获取评论列表
const fetchComments = async () => {
  commentParams.value.postId = route.params.id as string
  try {
    const res = await getCommentList(commentParams.value)
    if (res.code === 0 && res.data) {
      // 处理评论数据，将回复按照父评论分组
      const commentMap = new Map()
      // 先将所有评论放入 Map 中，方便后续查找
      res.data.records.forEach(comment => {
        commentMap.set(comment.id, comment)
      })

      // 处理回复关系
      res.data.records.forEach(comment => {
        // 如果是回复评论，添加到对应的父评论下
        if (comment.replyTo) {
          const parentComment = commentMap.get(comment.replyTo)
          if (parentComment) {
            if (!parentComment.replies) parentComment.replies = []
            parentComment.replies.push(comment)

            // 设置回复评论的引用对象
            if (comment.replyComment) {
              comment.replyToUser = comment.replyComment.userVO
            }
          }
        }
      })
      // 过滤出顶级评论
      comments.value = res.data.records.filter(comment => !comment.replyTo)
      commentTotal.value = Number(res.data.total)
    }
  } catch (error) {
    console.error('获取评论列表失败:', error)
    ElMessage.error('获取评论列表失败')
  }
}

// 处理回复评论
const handleReply = (comment: any) => {
  replyTo.value = comment
  commentContent.value = `回复 @${comment.userVO.userName}: `
}

// 取消回复
const cancelReply = () => {
  replyTo.value = null
  commentContent.value = ''
}

// 发表评论
const handleComment = async () => {
  if (!commentContent.value.trim()) {
    ElMessage.warning('请输入评论内容')
    return
  }

  commentLoading.value = true
  try {
    const res = await addComment({
      content: commentContent.value,
      postId: post.value?.id as string,
      replyTo: replyTo.value?.id
    })
    if (res.code === 0) {
      ElMessage.success('评论成功')
      commentContent.value = ''
      replyTo.value = null
      fetchPostDetail() // 刷新帖子详情
      fetchComments()
    }
  } catch (error) {
    console.error('发表评论失败:', error)
    ElMessage.error('评论失败')
  } finally {
    commentLoading.value = false
  }
}

// 点赞/取消点赞
const handleThumb = async () => {
  if (!post.value) return
  try {
    const res = await togglePostThumb(post.value.id)
    if (res.code === 0) {
      post.value.hasThumb = !post.value.hasThumb
      post.value.thumbNum += post.value.hasThumb ? 1 : -1
      ElMessage.success(post.value.hasThumb ? '点赞成功' : '已取消点赞')
    }
  } catch (error) {
    console.error('点赞操作失败:', error)
    ElMessage.error('操作失败')
  }
}

// 收藏/取消收藏
const handleFavour = async () => {
  if (!post.value) return
  try {
    const res = await togglePostFavour(post.value.id)
    if (res.code === 0) {
      post.value.hasFavour = !post.value.hasFavour
      post.value.favourNum += post.value.hasFavour ? 1 : -1
      ElMessage.success(post.value.hasFavour ? '收藏成功' : '已取消收藏')
    }
  } catch (error) {
    console.error('收藏操作失败:', error)
    ElMessage.error('操作失败')
  }
}

// 处理评论页码变化
const handleCommentPageChange = (page: number) => {
  commentParams.value.current = page
  fetchComments()
}

// 删除评论
const handleDeleteComment = async (commentId: string) => {
  try {
    await ElMessageBox.confirm('确定要删除这条评论吗？', '提示', {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    })

    const res = await deleteComment(commentId)
    if (res.code === 0) {
      ElMessage.success('删除成功')
      fetchComments()
    }
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除评论失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 点赞评论
const handleLikeComment = async (comment: any) => {
  try {
    const res = await likeComment(comment.id)
    if (res.code === 0) {
      // 更新点赞状态和数量
      comment.hasLiked = !comment.hasLiked
      comment.likes = comment.hasLiked ? (comment.likes || 0) + 1 : (comment.likes || 0) - 1
      ElMessage.success(comment.hasLiked ? '点赞成功' : '已取消点赞')
    }
  } catch (error) {
    console.error('点赞评论失败:', error)
    ElMessage.error('操作失败')
  }
}

onMounted(() => {
  fetchPostDetail()
})
</script>

<template>
  <div class="post-detail" v-loading="loading">
    <el-card v-if="post && post.user" class="post-card">
      <!-- 面包屑导航 -->
      <div class="breadcrumb-container">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/posts' }">帖子列表</el-breadcrumb-item>
          <el-breadcrumb-item>帖子详情</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      <!-- 帖子头部 -->
      <div class="post-header">
        <div class="user-info">
          <el-avatar :src="getFullAvatarUrl(post.user?.userAvatar)" :size="50"/>
          <div class="user-meta">
            <span class="username">{{ post.user?.userName || '匿名用户' }}</span>
            <span class="post-time">{{ formatDate(post.createTime) }}</span>
          </div>
        </div>
        <div class="post-tags">
          <el-tag v-for="tag in post.tagList || []" :key="tag" size="small">{{ tag }}</el-tag>
        </div>
      </div>

      <!-- 帖子内容 -->
      <div class="post-content">
        <h1 class="post-title">{{ post.title }}</h1>
        <p class="post-text">{{ post.content }}</p>
      </div>

      <!-- 帖子操作 -->
      <div class="post-actions">
        <el-button
            :type="post.hasThumb ? 'primary' : 'default'"
            @click="handleThumb"
            :disabled="!post.id"
        >
          <el-icon>
            <Watermelon/>
          </el-icon>
          {{ post.thumbNum || 0 }} 点赞
        </el-button>
        <el-button
            :type="post.hasFavour ? 'primary' : 'default'"
            @click="handleFavour"
            :disabled="!post.id"
        >
          <el-icon>
            <Star/>
          </el-icon>
          {{ post.favourNum || 0 }} 收藏
        </el-button>
      </div>

      <!-- 评论区 -->
      <div class="comment-section">
        <h3>
          <el-icon>
            <ChatDotRound/>
          </el-icon>
          评论
        </h3>

        <!-- 发表评论 -->
        <div class="comment-input">
          <el-input
              v-model="commentContent"
              type="textarea"
              :rows="4"
              :placeholder="replyTo ? '写下你的回复...' : '请输入评论内容'"
              maxlength="500"
              show-word-limit
          />
          <el-button
              type="primary"
              @click="handleComment"
              :loading="commentLoading"
              :disabled="!post.id"
              class="publish-btn"
          >
            发表评论
          </el-button>
        </div>

        <!-- 评论列表 -->
        <div class="comment-list" v-if="comments && comments.length > 0">
          <div v-for="comment in comments" :key="comment.id" class="comment-item">
            <div class="comment-header">
              <el-avatar :src="getFullAvatarUrl(comment.userVO?.userAvatar)" :size="40"/>
              <div class="comment-info">
                <div class="comment-meta">
                  <span class="username">{{ comment.userVO?.userName || '匿名用户' }}</span>
                  <span class="comment-time">{{ formatDate(comment.createTime) }}</span>
                </div>
                <p class="comment-text">{{ comment.content }}</p>
                <div class="comment-actions">
                  <span class="action-item reply-btn" @click="handleReply(comment)">
                    <el-icon><ChatDotRound/></el-icon>
                    回复
                  </span>
                  <span class="action-item thumb-btn" @click="handleLikeComment(comment)"
                        :class="{ 'active': comment.hasLiked }">
                    <el-icon><Watermelon/></el-icon>
                    {{ comment.likes || 0 }}
                  </span>
                  <span v-if="userStore.userInfo.id === comment.userId" class="action-item delete-btn"
                        @click="handleDeleteComment(comment.id)">
                    <el-icon><Delete/></el-icon>
                    删除
                  </span>
                </div>
              </div>
            </div>
            <!-- 嵌套回复 -->
            <div class="comment-body" v-if="comment.replies && comment.replies.length > 0">
              <div v-for="reply in comment.replies" :key="reply.id" class="reply-item">
                <div class="reply-content">
                  <el-avatar :src="getFullAvatarUrl(reply.userVO?.userAvatar)" :size="32"/>
                  <div class="reply-info">
                    <div class="reply-meta">
                      <span class="reply-username">{{ reply.userVO?.userName || '匿名用户' }}</span>
                      <span class="reply-time">{{ formatDate(reply.createTime) }}</span>
                    </div>
                    <p class="reply-text">
                      <template v-if="reply.replyToUser">
                        <span class="reply-to">回复 @{{ reply.replyToUser?.userName }}：</span>
                      </template>
                      {{ reply.content }}
                    </p>
                    <div class="reply-actions">
                      <span class="action-item reply-btn" @click="handleReply(reply)">
                        <el-icon><ChatDotRound/></el-icon>
                        回复
                      </span>
                      <span class="action-item thumb-btn" @click="handleLikeComment(reply)"
                            :class="{ 'active': reply.hasLiked }">
                       <el-icon><Watermelon/></el-icon>
                        {{ reply.likes || 0 }}
                      </span>
                      <span v-if="userStore.userInfo.id === reply.userId" class="action-item delete-btn"
                            @click="handleDeleteComment(reply.id)">
                        <el-icon><Delete/></el-icon>
                        删除
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <!-- 评论分页 -->
          <div class="pagination-container">
            <el-pagination
                v-model:current-page="commentParams.current"
                :page-size="commentParams.pageSize"
                :total="commentTotal"
                @current-change="handleCommentPageChange"
                :layout="'total, prev, pager, next'"
                :background="true"
            />
          </div>
        </div>
        <el-empty v-else description="暂无评论"/>
      </div>
    </el-card>
    <el-empty v-else description="帖子不存在或已被删除"/>
  </div>
</template>

<style lang="scss" scoped>
.post-detail {
  padding: 20px;
  max-width: 1000px;
  margin: 0 auto;

  .breadcrumb-container {
    margin-bottom: 16px;
    padding: 8px 0;

    :deep(.el-breadcrumb__item) {
      .el-breadcrumb__inner {
        color: #606266;
        font-weight: normal;

        &.is-link {
          color: #409EFF;
          font-weight: normal;

          &:hover {
            color: #79bbff;
          }
        }
      }

      &:last-child {
        .el-breadcrumb__inner {
          color: #909399;
        }
      }
    }
  }

  .post-card {
    .post-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 24px;

      .user-info {
        display: flex;
        align-items: center;
        gap: 16px;

        .user-meta {
          display: flex;
          flex-direction: column;

          .username {
            font-size: 16px;
            font-weight: 500;
            color: #303133;
          }

          .post-time {
            font-size: 14px;
            color: #909399;
          }
        }
      }

      .post-tags {
        display: flex;
        gap: 8px;
      }
    }

    .post-content {
      margin-bottom: 24px;

      .post-title {
        font-size: 24px;
        font-weight: 600;
        color: #303133;
        margin: 0 0 16px;
      }

      .post-text {
        font-size: 16px;
        line-height: 1.8;
        color: #606266;
        white-space: pre-wrap;
      }
    }

    .post-actions {
      display: flex;
      gap: 16px;
      margin-bottom: 32px;
      padding-bottom: 24px;
      border-bottom: 1px solid #ebeef5;
    }

    .comment-section {
      h3 {
        display: flex;
        align-items: center;
        gap: 8px;
        margin: 0 0 20px;
        font-size: 18px;
        color: #303133;
      }

      .comment-input {
        margin-bottom: 24px;

        .el-textarea {
          margin-bottom: 12px;
        }

        .publish-btn {
          float: right;
          padding: 8px 24px;
        }
      }

      .comment-list {
        .comment-item {
          padding: 16px 0;
          border-bottom: 1px solid #ebeef5;
          position: relative;

          &:last-child {
            border-bottom: none;
          }

          .comment-header {
            display: flex;
            gap: 12px;

            .comment-info {
              flex: 1;

              .comment-meta {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 4px;

                .username {
                  font-weight: 500;
                  color: #303133;
                }

                .comment-time {
                  font-size: 12px;
                  color: #909399;
                }
              }

              .comment-text {
                margin: 0;
                font-size: 14px;
                line-height: 1.6;
                color: #303133;
                margin-bottom: 8px;
              }

              .comment-actions {
                display: flex;
                gap: 16px;

                .action-item {
                  display: flex;
                  align-items: center;
                  gap: 4px;
                  font-size: 12px;
                  color: #909399;
                  cursor: pointer;

                  &:hover {
                    color: #409EFF;
                  }

                  &.active {
                    color: #409EFF;
                  }

                  &.delete-btn:hover {
                    color: #F56C6C;
                  }

                  .el-icon {
                    font-size: 14px;
                  }
                }
              }
            }
          }

          .comment-body {
            padding-left: 52px;
            margin-top: 8px;

            .reply-item {
              background-color: #f5f7fa;
              border-radius: 4px;
              padding: 8px 12px;
              margin-left: 0;

              .reply-content {
                display: flex;
                gap: 8px;

                .reply-info {
                  flex: 1;

                  .reply-meta {
                    display: flex;
                    justify-content: space-between;
                    margin-bottom: 4px;

                    .reply-username {
                      font-weight: 500;
                      color: #303133;
                      font-size: 13px;
                    }

                    .reply-time {
                      font-size: 12px;
                      color: #909399;
                    }
                  }

                  .reply-text {
                    margin: 0;
                    font-size: 13px;
                    line-height: 1.6;
                    color: #606266;
                    margin-bottom: 8px;

                    .reply-to {
                      color: #409EFF;
                      margin-right: 4px;
                    }
                  }

                  .reply-actions {
                    display: flex;
                    gap: 16px;

                    .action-item {
                      display: flex;
                      align-items: center;
                      gap: 4px;
                      font-size: 12px;
                      color: #909399;
                      cursor: pointer;

                      &:hover {
                        color: #409EFF;
                      }

                      &.active {
                        color: #409EFF;
                      }

                      &.delete-btn:hover {
                        color: #F56C6C;
                      }

                      .el-icon {
                        font-size: 14px;
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
</style> 