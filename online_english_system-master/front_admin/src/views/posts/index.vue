<template>
  <div class="posts-container">
    <!-- 头部搜索和操作 -->
    <div class="header">
      <div class="title">帖子管理</div>
      <div class="actions">
        <el-input v-model="searchQuery" placeholder="搜索帖子" class="search-input" clearable @keyup.enter="handleSearch">
          <template #prefix>
            <el-icon>
              <Search />
            </el-icon>
          </template>
        </el-input>
        <el-select v-model="sortField" placeholder="排序字段" clearable>
          <el-option label="创建时间" value="createTime" />
          <el-option label="点赞数" value="thumbNum" />
          <el-option label="收藏数" value="favourNum" />
        </el-select>
        <el-select v-model="sortOrder" placeholder="排序方式" clearable>
          <el-option label="升序" value="ascend" />
          <el-option label="降序" value="descend" />
        </el-select>
        <el-button type="primary" @click="handleAdd">
          <el-icon>
            <Plus />
          </el-icon>新增帖子
        </el-button>
      </div>
    </div>

    <!-- 帖子列表 -->
    <el-table v-loading="loading" :data="postList" style="width: 100%" border>
      <el-table-column type="index" label="序号" width="80" align="center">
        <template #default="scope">
          {{ (currentPage - 1) * pageSize + scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="title" label="标题" min-width="200" show-overflow-tooltip />
      <el-table-column prop="content" label="内容" min-width="300" show-overflow-tooltip />
      <el-table-column label="作者" width="150">
        <template #default="{ row }">
          <div class="user-info">
            <el-avatar :size="30" :src="getAvatarUrl(row.user.userAvatar)" />
            <span>{{ row.user.userName }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="标签" width="200">
        <template #default="{ row }">
          <el-tag v-for="tag in row.tagList" :key="tag" class="tag-item" size="small">
            {{ tag }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="互动数据" width="130">
        <template #default="{ row }">
          <div class="interaction-info">
            <el-tooltip content="点赞数">
              <div class="info-item">
                <el-icon><Watermelon /></el-icon>
                <span>{{ row.thumbNum }}</span>
              </div>
            </el-tooltip>
            <el-tooltip content="收藏数">
              <div class="info-item">
                <el-icon>
                  <Collection />
                </el-icon>
                <span>{{ row.favourNum }}</span>
              </div>
            </el-tooltip>
    
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="发布时间" width="180" />
      <el-table-column label="操作" width="250" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" @click="handleDelete(row)">删除</el-button>
          <el-button type="info" @click="handlePreview(row)">预览</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[10, 20, 30]"
        :total="total" layout="total, sizes, prev, pager, next, jumper" background />
    </div>

    <!-- 添加/编辑帖子弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? '新增帖子' : '编辑帖子'" width="700px" destroy-on-close>
      <el-form ref="formRef" :model="postForm" :rules="rules" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="postForm.title" placeholder="请输入帖子标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="postForm.content" type="textarea" :rows="6" placeholder="请输入帖子内容" />
        </el-form-item>
        <el-form-item label="标签" prop="tags">
          <el-tag v-for="tag in postForm.tags" :key="tag" closable @close="handleRemoveTag(tag)" class="tag-item">
            {{ tag }}
          </el-tag>
          <el-input v-if="inputTagVisible" ref="tagInputRef" v-model="inputTagValue" class="tag-input" size="small"
            @keyup.enter="handleAddTag" @blur="handleAddTag" />
          <el-button v-else class="button-new-tag" size="small" @click="showTagInput">
            + 添加标签
          </el-button>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>

    <!-- 帖子预览弹窗 -->
    <el-dialog v-model="previewVisible" title="帖子预览" width="800px" destroy-on-close>
      <div class="post-preview">
        <div class="post-header">
          <h2 class="post-title">{{ currentPost.title }}</h2>
          <div class="post-meta">
            <div class="post-author">
              <el-avatar :size="30" :src="getAvatarUrl(currentPost.user?.userAvatar)" />
              <span>{{ currentPost.user?.userName }}</span>
            </div>
            <div class="post-time">{{ currentPost.createTime }}</div>
          </div>
          <div class="post-tags">
            <el-tag v-for="tag in currentPost.tagList" :key="tag" class="tag-item" size="small">
              {{ tag }}
            </el-tag>
          </div>
        </div>
        <div class="post-content">{{ currentPost.content }}</div>

        <div class="post-stats">
          <div class="stat-item" @click="handleToggleThumb">
            <el-icon :class="{ active: currentPost.hasThumb }">
              <Watermelon />
            </el-icon>
            <span>{{ currentPost.thumbNum || 0 }} 点赞</span>
          </div>
          <div class="stat-item" @click="handleToggleFavour">
            <el-icon :class="{ active: currentPost.hasFavour }">
              <Collection />
            </el-icon>
            <span>{{ currentPost.favourNum || 0 }} 收藏</span>
          </div>
          <div class="stat-item">
            <el-icon>
              <ChatLineRound />
            </el-icon>
            <span>{{ commentTotal || 0 }} 评论</span>
          </div>
        </div>

        <el-divider>评论列表</el-divider>

        <!-- 评论输入框 -->
        <div class="comment-form">
          <el-input v-model="commentContent" type="textarea" :rows="3" placeholder="请输入评论内容" />
          <el-button type="primary" @click="handleAddComment" :loading="commentSubmitting">
            发表评论
          </el-button>
        </div>

        <!-- 评论列表 -->
        <div v-loading="commentLoading" class="comment-list">
          <div v-if="commentList.length === 0" class="no-comment">
            暂无评论
          </div>
          <template v-else>
            <!-- 先渲染所有顶级评论 -->
            <div v-for="comment in topLevelComments" :key="comment.id" class="comment-item">
              <!-- 顶级评论内容 -->
              <div class="comment-header">
                <div class="comment-user">
                  <el-avatar :size="24" :src="getAvatarUrl(comment.userVO?.userAvatar)" />
                  <span class="username">{{ comment.userVO?.userName }}</span>
                </div>
                <div class="comment-time">{{ comment.createTime }}</div>
              </div>
              <div class="comment-content">{{ comment.content }}</div>
              <div class="comment-actions">
                <el-button type="text" size="small" @click="handleLikeComment(comment)">
                  <el-icon><Watermelon /></el-icon>
                  {{ comment.likes || 0 }}
                </el-button>
                <el-button type="text" size="small" @click="handleReplyComment(comment)">
                  <el-icon>
                    <ChatLineRound />
                  </el-icon>
                  回复
                </el-button>
                <el-button type="text" size="small" @click="handleDeleteComment(comment)">
                  <el-icon>
                    <Delete />
                  </el-icon>
                  删除
                </el-button>
              </div>

              <!-- 子评论列表 -->
              <div v-if="getChildComments(comment.id).length > 0" class="child-comments">
                <div v-for="childComment in getChildComments(comment.id)" :key="childComment.id"
                  class="child-comment-item">
                  <div class="comment-header">
                    <div class="comment-user">
                      <el-avatar :size="20" :src="getAvatarUrl(childComment.userVO?.userAvatar)" />
                      <span class="username">{{ childComment.userVO?.userName }}</span>
                      <span class="reply-to">回复</span>
                      <span class="reply-username">@{{ childComment.replyComment?.userVO?.userName }}</span>
                    </div>
                    <div class="comment-time">{{ childComment.createTime }}</div>
                  </div>
                  <div class="comment-content">{{ childComment.content }}</div>
                  <div class="comment-actions">
                    <el-button type="text" size="small" @click="handleLikeComment(childComment)">
                      <el-icon><Watermelon /></el-icon>
                      {{ childComment.likes || 0 }}
                    </el-button>
                    <el-button type="text" size="small" @click="handleReplyComment(childComment)">
                      <el-icon>
                        <ChatLineRound />
                      </el-icon>
                      回复
                    </el-button>
                    <el-button type="text" size="small" @click="handleDeleteComment(childComment)">
                      <el-icon>
                        <Delete />
                      </el-icon>
                      删除
                    </el-button>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </div>

        <!-- 评论分页 -->
        <div v-if="commentList.length > 0" class="comment-pagination">
          <el-pagination v-model:current-page="commentPage" v-model:page-size="commentPageSize"
            :page-sizes="[5, 10, 20]" :total="commentTotal" layout="total, sizes, prev, pager, next" background
            @current-change="fetchCommentList" @size-change="handleCommentSizeChange" />
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch, nextTick, computed } from 'vue'
import type { FormInstance } from 'element-plus'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Search,
  Pointer,
  Collection,
  Plus,
  ChatLineRound,
  Delete, Watermelon
} from '@element-plus/icons-vue'
import {
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
} from '@/api/post'
import type { Post } from '@/api/post'
import defaultAvatar from '@/assets/avatar.jpg'

// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const searchQuery = ref('')
const sortField = ref('')
const sortOrder = ref('')
const postList = ref<Post[]>([])
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const submitLoading = ref(false)
const formRef = ref<FormInstance>()

// 表单数据
const postForm = reactive({
  id: '',
  title: '',
  content: '',
  tags: [] as string[]
})

// 标签输入相关
const inputTagVisible = ref(false)
const inputTagValue = ref('')
const tagInputRef = ref<HTMLInputElement>()

// 表单校验规则
const rules = {
  title: [{ required: true, message: '请输入帖子标题', trigger: 'blur' }],
  content: [{ required: true, message: '请输入帖子内容', trigger: 'blur' }]
}

// 帖子预览相关
const previewVisible = ref(false)
const currentPost = ref<Partial<Post>>({})
const commentList = ref<any[]>([])
const commentPage = ref(1)
const commentPageSize = ref(10)
const commentTotal = ref(0)
const commentLoading = ref(false)
const commentContent = ref('')
const commentSubmitting = ref(false)
const replyToComment = ref<any>(null)

// 获取帖子列表
const fetchPostList = async () => {
  loading.value = true
  try {
    const res = await getPostList({
      current: currentPage.value,
      pageSize: pageSize.value,
      searchText: searchQuery.value,
      sortField: sortField.value,
      sortOrder: sortOrder.value
    })
    postList.value = res.data.records
    total.value = parseInt(res.data.total)
  } catch (error) {
    console.error('获取帖子列表失败:', error)
    ElMessage.error('获取帖子列表失败')
  } finally {
    loading.value = false
  }
}

// 处理搜索
const handleSearch = () => {
  currentPage.value = 1
  fetchPostList()
}

// 新增帖子
const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
  postForm.id = ''
  postForm.title = ''
  postForm.content = ''
  postForm.tags = []
}

// 编辑帖子
const handleEdit = (row: Post) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  postForm.id = row.id
  postForm.title = row.title
  postForm.content = row.content
  postForm.tags = [...row.tagList]
}

// 删除帖子
const handleDelete = (row: Post) => {
  ElMessageBox.confirm('确定要删除该帖子吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deletePost(row.id)
      ElMessage.success('删除成功')
      fetchPostList()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        if (dialogType.value === 'add') {
          await addPost({
            title: postForm.title,
            content: postForm.content,
            tags: postForm.tags
          })
          ElMessage.success('添加成功')
        } else {
          await updatePost({
            id: postForm.id,
            title: postForm.title,
            content: postForm.content,
            tags: postForm.tags
          })
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        fetchPostList()
      } catch (error) {
        ElMessage.error(dialogType.value === 'add' ? '添加失败' : '更新失败')
      } finally {
        submitLoading.value = false
      }
    }
  })
}

// 标签相关方法
const showTagInput = () => {
  inputTagVisible.value = true
  nextTick(() => {
    tagInputRef.value?.focus()
  })
}

const handleAddTag = () => {
  if (inputTagValue.value) {
    if (!postForm.tags.includes(inputTagValue.value)) {
      postForm.tags.push(inputTagValue.value)
    }
  }
  inputTagVisible.value = false
  inputTagValue.value = ''
}

const handleRemoveTag = (tag: string) => {
  postForm.tags = postForm.tags.filter(t => t !== tag)
}

// 获取头像URL
const getAvatarUrl = (avatar: string) => {
  if (!avatar) return defaultAvatar
  if (avatar.startsWith('http')) return avatar
  return import.meta.env.VITE_BASE_URL + avatar
}

// 监听分页变化
watch([currentPage, pageSize], () => {
  fetchPostList()
})

// 监听排序和搜索条件变化
watch([sortField, sortOrder, searchQuery], () => {
  currentPage.value = 1
  fetchPostList()
})

// 预览帖子
const handlePreview = async (row: Post) => {
  currentPost.value = row
  previewVisible.value = true
  commentPage.value = 1
  commentContent.value = ''
  replyToComment.value = null
  await fetchCommentList()
}

// 获取评论列表
const fetchCommentList = async () => {
  if (!currentPost.value.id) return

  commentLoading.value = true
  try {
    const res = await getCommentList({
      current: commentPage.value,
      pageSize: commentPageSize.value,
      postId: currentPost.value.id
    })
    commentList.value = res.data.records
    commentTotal.value = parseInt(res.data.total)
  } catch (error) {
    console.error('获取评论列表失败:', error)
    ElMessage.error('获取评论列表失败')
  } finally {
    commentLoading.value = false
  }
}

// 处理评论分页大小变化
const handleCommentSizeChange = () => {
  commentPage.value = 1
  fetchCommentList()
}

// 添加评论
const handleAddComment = async () => {
  if (!commentContent.value.trim()) {
    ElMessage.warning('评论内容不能为空')
    return
  }

  commentSubmitting.value = true
  try {
    await addComment({
      content: commentContent.value,
      postId: currentPost.value.id as string,
      replyTo: replyToComment.value?.id
    })
    ElMessage.success('评论成功')
    commentContent.value = ''
    replyToComment.value = null
    await fetchCommentList()
  } catch (error) {
    ElMessage.error('评论失败')
  } finally {
    commentSubmitting.value = false
  }
}

// 点赞评论
const handleLikeComment = async (comment: any) => {
  try {
    if (comment.hasLike) {
      await unlikeComment(comment.id)
      comment.likes = (comment.likes || 0) - 1
      comment.hasLike = false
      ElMessage.success('取消点赞成功')
    } else {
      await likeComment(comment.id)
      comment.likes = (comment.likes || 0) + 1
      comment.hasLike = true
      ElMessage.success('点赞成功')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 回复评论
const handleReplyComment = (comment: any) => {
  replyToComment.value = comment
  commentContent.value = `回复 @${comment.userVO.userName}: `
  // 聚焦到评论输入框
  nextTick(() => {
    document.querySelector('.comment-form .el-textarea__inner')?.focus()
  })
}

// 删除评论
const handleDeleteComment = (comment: any) => {
  ElMessageBox.confirm('确定要删除该评论吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteComment(comment.id)
      ElMessage.success('删除成功')
      await fetchCommentList()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 计算顶级评论（没有回复父评论的评论）
const topLevelComments = computed(() => {
  return commentList.value.filter(comment => !comment.replyTo)
})

// 获取某个评论的所有子评论
const getChildComments = (parentId: string) => {
  return commentList.value.filter(comment => comment.replyTo === parentId)
}

// 点赞帖子
const handleToggleThumb = async () => {
  if (!currentPost.value.id) return

  try {
    const res = await togglePostThumb(currentPost.value.id)
    if (res.data === 1) {
      // 点赞成功
      currentPost.value.hasThumb = true
      currentPost.value.thumbNum = (currentPost.value.thumbNum || 0) + 1
      ElMessage.success('点赞成功')
    } else if (res.data === -1) {
      // 取消点赞
      currentPost.value.hasThumb = false
      currentPost.value.thumbNum = (currentPost.value.thumbNum || 0) - 1
      ElMessage.success('已取消点赞')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 收藏帖子
const handleToggleFavour = async () => {
  if (!currentPost.value.id) return

  try {
    const res = await togglePostFavour(currentPost.value.id)
    if (res.data === 1) {
      // 收藏成功
      currentPost.value.hasFavour = true
      currentPost.value.favourNum = (currentPost.value.favourNum || 0) + 1
      ElMessage.success('收藏成功')
    } else if (res.data === -1) {
      // 取消收藏
      currentPost.value.hasFavour = false
      currentPost.value.favourNum = (currentPost.value.favourNum || 0) - 1
      ElMessage.success('已取消收藏')
    }
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

// 初始化
onMounted(() => {
  fetchPostList()
})
</script>

<style lang="scss" scoped>
.posts-container {
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 40px);

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .title {
      font-size: 20px;
      font-weight: bold;
    }

    .actions {
      display: flex;
      gap: 12px;

      .el-select {
        width: 140px;
      }

      .search-input {
        width: 200px;
      }
    }
  }

  .pagination {
    margin-top: 20px;
    padding: 10px 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
    display: flex;
    justify-content: flex-end;
  }

  .user-info {
    display: flex;
    align-items: center;
    gap: 8px;

    .el-avatar {
      border-radius: 50%;
    }
  }

  .tag-item {
    margin-right: 8px;
    margin-bottom: 8px;
  }

  .interaction-info {
    display: flex;
    gap: 16px;

    .info-item {
      display: flex;
      align-items: center;
      gap: 4px;
      color: #606266;

      .el-icon {
        font-size: 16px;
      }
    }
  }

  :deep(.el-table) {
    border-radius: 8px;
    overflow: hidden;

    .el-table__header-wrapper {
      th {
        background-color: #f5f7fa;
        color: #606266;
        font-weight: 600;
      }
    }
  }
}

.tag-input {
  width: 100px;
  margin-right: 8px;
  vertical-align: bottom;
}

.button-new-tag {
  margin-bottom: 8px;
}

.post-preview {
  padding: 20px;

  .post-header {
    margin-bottom: 20px;

    .post-title {
      font-size: 24px;
      font-weight: 600;
      margin-bottom: 16px;
      color: #303133;
    }

    .post-meta {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 12px;

      .post-author {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .post-time {
        color: #909399;
        font-size: 14px;
      }
    }

    .post-tags {
      margin-top: 12px;
    }
  }

  .post-content {
    font-size: 16px;
    line-height: 1.6;
    color: #606266;
    margin-bottom: 24px;
    white-space: pre-wrap;
  }

  .post-stats {
    display: flex;
    gap: 24px;
    margin-bottom: 24px;

    .stat-item {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #606266;
      cursor: pointer;
      padding: 6px 10px;
      border-radius: 4px;
      transition: all 0.3s;

      &:hover {
        background-color: #f5f7fa;
      }

      .el-icon {
        font-size: 18px;
        color: #909399;
        transition: all 0.3s;

        &.active {
          color: #409eff;
        }
      }
    }
  }

  .comment-form {
    margin-bottom: 24px;

    .el-button {
      margin-top: 12px;
      float: right;
    }
  }

  .comment-list {
    margin-bottom: 24px;

    .no-comment {
      text-align: center;
      color: #909399;
      padding: 20px 0;
    }

    .comment-item {
      padding: 16px 0;
      border-bottom: 1px solid #ebeef5;

      &:last-child {
        border-bottom: none;
      }

      .comment-header {
        display: flex;
        justify-content: space-between;
        margin-bottom: 8px;

        .comment-user {
          display: flex;
          align-items: center;
          gap: 8px;

          .username {
            font-weight: 500;
            color: #303133;
          }

          .reply-to {
            color: #909399;
            font-size: 12px;
            margin: 0 4px;
          }

          .reply-username {
            color: #409eff;
            font-weight: 500;
          }
        }

        .comment-time {
          font-size: 12px;
          color: #909399;
        }
      }

      .comment-content {
        margin-bottom: 8px;
        color: #606266;
        line-height: 1.5;
      }

      .comment-actions {
        display: flex;
        gap: 16px;

        .el-button {
          padding: 0;
          height: auto;

          .el-icon {
            margin-right: 4px;
          }
        }
      }

      // 子评论样式
      .child-comments {
        margin-top: 12px;
        margin-left: 24px;
        padding-left: 12px;
        border-left: 2px solid #ebeef5;

        .child-comment-item {
          padding: 12px 0;
          border-bottom: 1px dashed #ebeef5;

          &:last-child {
            border-bottom: none;
          }

          .comment-header {
            .comment-user {
              .username {
                font-size: 13px;
              }
            }

            .comment-time {
              font-size: 11px;
            }
          }

          .comment-content {
            font-size: 13px;
          }

          .comment-actions {
            .el-button {
              font-size: 12px;
            }
          }
        }
      }
    }
  }

  .comment-pagination {
    display: flex;
    justify-content: center;
    margin-top: 20px;
  }
}
</style>