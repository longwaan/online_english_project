<script setup lang="ts">
import {ref, onMounted, computed} from 'vue'
import {useRouter} from 'vue-router'
// import {getPostList, addPost, type Post} from '@/api/post'
import { getPostList,addPost } from '@/api/post/index'
import type { Post } from '@/api/post/type'
import {ElMessage} from 'element-plus'
import {formatDate} from '@/utils/format'
import {Plus, View, Star} from '@element-plus/icons-vue'

const router = useRouter()
const apiUrl = import.meta.env.VITE_API_URL || ''

// 获取完整的头像URL
const getFullAvatarUrl = (avatarPath: string) => {
  if (!avatarPath) return ''
  if (avatarPath.startsWith('http')) return avatarPath
  return `${apiUrl}${avatarPath}`
}

// 帖子列表数据
const posts = ref<Post[]>([])
const total = ref<number>(0)
const loading = ref(false)

// 发布帖子对话框
const dialogVisible = ref(false)
const postForm = ref({
  title: '',
  content: '',
  tags: [] as string[]
})

// 标签选项
const tagOptions = [
  {label: '课程学习', value: '课程学习'},
  {label: '词汇学习', value: '词汇学习'},
  {label: '考试经验', value: '考试经验'},
  {label: '学习方法', value: '学习方法'},
  {label: '求助问答', value: '求助问答'}
]

// 分页参数
const pageParams = ref({
  current: 1,
  pageSize: 5,
  sortField: 'createTime',
  sortOrder: 'desc'
})

// 获取帖子列表
const fetchPosts = async () => {
  loading.value = true
  try {
    const res = await getPostList(pageParams.value)
    if (res.code === 0 && res.data) {
      posts.value = res.data.records
      total.value = Number(res.data.total)
    }
  } catch (error) {
    console.error('获取帖子列表失败:', error)
    ElMessage.error('获取帖子列表失败')
  } finally {
    loading.value = false
  }
}

// 处理页码变化
const handlePageChange = (page: number) => {
  pageParams.value.current = page
  fetchPosts()
}

// 跳转到帖子详情
const goToDetail = (id: string) => {
  router.push(`/posts/${id}`)
}

// 创建新帖子
const createPost = () => {
  router.push('/posts/create')
}

// 发布帖子
const handlePublish = async () => {
  if (!postForm.value.title.trim()) {
    ElMessage.warning('请输入标题')
    return
  }
  if (!postForm.value.content.trim()) {
    ElMessage.warning('请输入内容')
    return
  }
  if (postForm.value.tags.length === 0) {
    ElMessage.warning('请至少选择一个标签')
    return
  }

  try {
    const res = await addPost(postForm.value)
    if (res.code === 0) {
      ElMessage.success('发布成功')
      dialogVisible.value = false
      // 重置表单
      postForm.value = {
        title: '',
        content: '',
        tags: []
      }
      // 刷新帖子列表
      fetchPosts()
    }
  } catch (error) {
    console.error('发布帖子失败:', error)
    ElMessage.error('发布失败')
  }
}

onMounted(() => {
  fetchPosts()
})
</script>

<template>
  <div class="posts-container">
    <!-- 页面标题 -->
    <div class="page-header">
      <h2>学习讨论区</h2>
      <el-button type="primary" @click="dialogVisible = true">
        <el-icon>
          <Plus/>
        </el-icon>
        发布帖子
      </el-button>
    </div>

    <!-- 帖子列表 -->
    <div class="posts-list" v-loading="loading">
      <el-card v-for="post in posts" :key="post.id" class="post-card" @click="goToDetail(post.id)">
        <div class="post-header">
          <div class="user-info">
            <el-avatar :src="getFullAvatarUrl(post.user.userAvatar)" :size="40"/>
            <div class="user-meta">
              <span class="username">{{ post.user.userName }}</span>
              <span class="post-time">{{ formatDate(post.createTime) }}</span>
            </div>
          </div>
          <div class="post-tags">
            <el-tag v-for="tag in post.tagList" :key="tag" size="small">{{ tag }}</el-tag>
          </div>
        </div>

        <h3 class="post-title">{{ post.title }}</h3>
        <p class="post-content">{{ post.content }}</p>

        <div class="post-footer">
          <div class="post-stats">
            <span class="stat-item">
              <el-icon><View/></el-icon>
              {{ post.thumbNum }} 点赞
            </span>
            <span class="stat-item">
              <el-icon><Star/></el-icon>
              {{ post.favourNum }} 收藏
            </span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 分页 -->
    <div class="pagination-container">
      <el-pagination
          v-model:current-page="pageParams.current"
          :page-size="pageParams.pageSize"
          :total="total"
          @current-change="handlePageChange"
          :layout="'total, prev, pager, next'"
          :background="true"
      />
    </div>

    <!-- 发布帖子对话框 -->
    <el-dialog
        v-model="dialogVisible"
        title="发布帖子"
        width="600px"
        :close-on-click-modal="false"
    >
      <el-form :model="postForm" label-width="80px">
        <el-form-item label="标题">
          <el-input v-model="postForm.title" placeholder="请输入标题" maxlength="50" show-word-limit/>
        </el-form-item>
        <el-form-item label="内容">
          <el-input
              v-model="postForm.content"
              type="textarea"
              :rows="6"
              placeholder="请输入内容"
              maxlength="1000"
              show-word-limit
          />
        </el-form-item>
        <el-form-item label="标签">
          <el-select
              v-model="postForm.tags"
              multiple
              placeholder="请选择标签"
              style="width: 100%"
          >
            <el-option
                v-for="item in tagOptions"
                :key="item.value"
                :label="item.label"
                :value="item.value"
            />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handlePublish">
            发布
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style lang="scss" scoped>
.posts-container {
  padding: 20px;
  max-width: 1200px;
  margin: 0 auto;
  background-color: #fff;

  .page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    h2 {
      margin: 0;
      font-size: 24px;
      color: #303133;
    }
  }

  .posts-list {
    display: grid;
    gap: 20px;

    .post-card {
      cursor: pointer;
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      }

      .post-header {
        display: flex;
        justify-content: space-between;
        align-items: flex-start;
        margin-bottom: 16px;

        .user-info {
          display: flex;
          align-items: center;
          gap: 12px;

          .user-meta {
            display: flex;
            flex-direction: column;

            .username {
              font-weight: 500;
              color: #303133;
            }

            .post-time {
              font-size: 12px;
              color: #909399;
            }
          }
        }

        .post-tags {
          display: flex;
          gap: 8px;
        }
      }

      .post-title {
        margin: 0 0 12px;
        font-size: 18px;
        color: #303133;
      }

      .post-content {
        margin: 0 0 16px;
        color: #606266;
        line-height: 1.6;
        display: -webkit-box;
        -webkit-line-clamp: 3;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .post-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        color: #909399;
        font-size: 14px;

        .post-stats {
          display: flex;
          gap: 16px;

          .stat-item {
            display: flex;
            align-items: center;
            gap: 4px;
          }
        }
      }
    }
  }

  .pagination-container {
    margin-top: 20px;
    display: flex;
    justify-content: center;
  }

  .dialog-footer {
    display: flex;
    justify-content: flex-end;
    gap: 12px;
  }
}
</style> 