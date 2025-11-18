<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import {
  Search,
  Filter,
  Sort,
  ArrowUp,
  ArrowDown,
  View,
  Star,
  Clock,
  Refresh,
  Plus,
  VideoPlay
} from '@element-plus/icons-vue'
import { getCourseList, type CourseVO } from '@/api/course'

const router = useRouter()

// 环境变量
const apiUrl = import.meta.env.VITE_API_URL || ''

// 课程列表
const courseList = ref<CourseVO[]>([])
const loading = ref(false)
const total = ref(0)

// 筛选条件
const filters = reactive({
  title: '',
  level: '',
  status: '',
  current: 1,
  pageSize: 8
})

// 课程级别选项 - 使用中文
const levelOptions = [
  { value: '', label: '全部级别' },
  { value: '初级', label: '初级' },
  { value: '中级', label: '中级' },
  { value: '高级', label: '高级' }
]

// 课程分类选项
const categoryOptions = [
  { value: '', label: '全部分类' },
  { value: 'grammar', label: '语法' },
  { value: 'vocabulary', label: '词汇' },
  { value: 'listening', label: '听力' },
  { value: 'speaking', label: '口语' },
  { value: 'reading', label: '阅读' },
  { value: 'writing', label: '写作' }
]

// 状态选项
const statusOptions = [
  { value: '', label: '全部状态' },
  { value: '1', label: '已上线' },
  { value: '0', label: '未上线' }
]

// 排序选项
const sortOptions = [
  { value: 'newest', label: '最新' },
  { value: 'popular', label: '最热' },
  { value: 'rating', label: '评分' }
]

// 获取完整的图片URL
const getFullImageUrl = (imagePath: string | undefined) => {
  if (!imagePath) return 'https://via.placeholder.com/300x160?text=课程封面'
  if (imagePath.startsWith('http')) return imagePath
  return `${apiUrl}${imagePath}`
}

// 获取课程列表
const fetchCourses = async () => {
  loading.value = true
  try {
    const params = {
      current: filters.current,
      pageSize: filters.pageSize
    } as any

    if (filters.title) params.title = filters.title
    if (filters.level) params.level = filters.level
    if (filters.status) params.status = filters.status

    const res = await getCourseList(params)

    if (res.code === 0 && res.data) {
      courseList.value = res.data.records
      total.value = parseInt(res.data.total)
    } else {
      ElMessage.error(res.message || '获取课程列表失败')
    }
  } catch (error) {
    console.error('获取课程列表出错:', error)
    ElMessage.error('获取课程列表出错')
  } finally {
    loading.value = false
  }
}

// 重置筛选条件
const resetFilters = () => {
  filters.title = ''
  filters.level = ''
  filters.status = ''
  filters.current = 1
  fetchCourses()
}

// 处理页码变化
const handleCurrentChange = (page: number) => {
  filters.current = page
  fetchCourses()
}

// 处理每页显示数量变化
const handleSizeChange = (size: number) => {
  filters.pageSize = size
  filters.current = 1
  fetchCourses()
}

// 跳转到课程详情页
const goToCourseDetail = (course: CourseVO) => {
  // 如果课程未上线，显示提示
  if (course.status !== 1) {
    ElMessage.warning('课程还没上线，敬请期待！')
    return
  }
  
  router.push(`/courses/${course.id}`)
}

// 计算课程总时长
const calculateTotalDuration = (course: CourseVO) => {
  if (!course.chapterList || course.chapterList.length === 0) {
    return 0
  }

  return course.chapterList.reduce((total, chapter) => {
    return total + (chapter.duration || 0)
  }, 0)
}

// 格式化时长显示
const formatDuration = (minutes: number) => {
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60

  if (hours > 0) {
    return `${hours}小时${mins > 0 ? ` ${mins}分钟` : ''}`
  }

  return `${mins}分钟`
}

onMounted(() => {
  fetchCourses()
})
</script>

<template>
  <div class="courses-container">
    <div class="courses-header-section">
      <div class="courses-header">
    <h1>课程学习</h1>
        <p>探索丰富的英语学习课程，提升你的语言技能</p>
      </div>

      <div class="filter-section">
        <div class="search-box">
          <el-input v-model="filters.title" placeholder="搜索课程..." clearable @keyup.enter="fetchCourses">
            <template #prefix>
              <el-icon>
                <Search />
              </el-icon>
            </template>
            <template #append>
              <el-button @click="fetchCourses">搜索</el-button>
            </template>
          </el-input>
        </div>

        <div class="filter-options">
          <el-select v-model="filters.level" placeholder="课程级别" @change="fetchCourses">
            <el-option v-for="item in levelOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>

          <el-select v-model="filters.status" placeholder="课程状态" @change="fetchCourses">
            <el-option v-for="item in statusOptions" :key="item.value" :label="item.label" :value="item.value" />
          </el-select>

          <el-button type="primary" plain @click="resetFilters">
            <el-icon>
              <Refresh />
            </el-icon>
            重置
          </el-button>
        </div>
      </div>
    </div>

    <div class="courses-list">
      <el-empty v-if="courseList.length === 0 && !loading" description="暂无课程数据" />

      <el-skeleton v-if="loading" :rows="3" animated />

      <div v-else class="course-grid">
        <div
          v-for="course in courseList"
          :key="course.id"
          class="course-card"
          @click="goToCourseDetail(course)"
          :class="{ 'disabled': course.status !== 1 }"
        >
          <div class="course-image">
            <img :src="getFullImageUrl(course.coverImage)" :alt="course.title">
            <div class="course-level">
              {{ course.level }}
            </div>
            <div class="course-status" :class="{ 'online': course.status === 1 }">
              {{ course.status === 1 ? '已上线' : '未上线' }}
            </div>
          </div>

          <div class="course-content">
            <h3 class="course-title">{{ course.title }}</h3>
            <p class="course-description">{{ course.description }}</p>

            <div class="course-meta">
              <div class="meta-item">
                <el-icon>
                  <Clock />
                </el-icon>
                <span>{{ formatDuration(calculateTotalDuration(course)) }}</span>
              </div>

              <div class="meta-item">
                <el-icon>
                  <VideoPlay />
                </el-icon>
                <span>{{ course.chapterCount || 0 }}章节</span>
              </div>
              <div class="course-footer">
                <el-button 
                  size="small" 
                  type="primary" 
                  :disabled="course.status !== 1"
                >
                  开始学习
                </el-button>
              </div>
            </div>


          </div>
        </div>
      </div>

      <div class="pagination-container">
        <el-pagination v-model:current-page="filters.current" v-model:page-size="filters.pageSize"
          :page-sizes="[8, 16, 24, 32]" layout="total, sizes, prev, pager, next, jumper" :total="total"
          @size-change="handleSizeChange" @current-change="handleCurrentChange" />
      </div>
    </div>
  </div>
</template>

<style scoped lang="scss">
.courses-container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  
  .courses-header-section {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;
    flex-wrap: wrap;
    gap: 20px;
    padding-bottom: 20px;
    border-bottom: 1px solid #f0f2f5;
    
    .courses-header {
      flex: 1;
      min-width: 300px;
      max-width: 500px;
      
      h1 {
        font-size: 28px;
        font-weight: 600;
        color: #303133;
        margin-bottom: 8px;
        display: flex;
        align-items: center;
        
        &::before {
          content: '';
          display: inline-block;
          width: 4px;
          height: 24px;
          background-color: #409EFF;
          margin-right: 12px;
          border-radius: 2px;
        }
      }
      
      p {
        font-size: 15px;
        color: #606266;
        margin-left: 16px;
      }
    }
    
    .filter-section {
      display: flex;
      flex-wrap: wrap;
      gap: 15px;
      flex: 1;
      min-width: 300px;
      max-width: 700px;
      
      .search-box {
        width: 280px;
        
        :deep(.el-input__wrapper) {
          box-shadow: 0 0 0 1px #dcdfe6 inset;
          
          &:hover {
            box-shadow: 0 0 0 1px #c0c4cc inset;
          }
          
          &.is-focus {
            box-shadow: 0 0 0 1px #409EFF inset;
          }
        }
        
        :deep(.el-input-group__append) {
          background-color: #409EFF;
          border-color: #409EFF;
          color: #fff;
          
          .el-button {
            color: #fff;
            border: none;
            
            &:hover {
              background-color: #66b1ff;
              color: #fff;
            }
          }
        }
      }
      
      .filter-options {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        
        .el-select {
          width: 120px;
          
          :deep(.el-input__wrapper) {
            box-shadow: 0 0 0 1px #dcdfe6 inset;
            
            &:hover {
              box-shadow: 0 0 0 1px #c0c4cc inset;
            }
            
            &.is-focus {
              box-shadow: 0 0 0 1px #409EFF inset;
            }
          }
        }
        
        .el-button {
          height: 32px;
          padding: 0 16px;
          
          .el-icon {
            margin-right: 4px;
          }
        }
      }
    }
  }
  
  .courses-list {
    min-height: 400px;
    
    .course-grid {
      display: grid;
      grid-template-columns: repeat(4, 1fr);
      gap: 24px;
      margin-bottom: 30px;
    }
    
    .course-card {
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      transition: all 0.3s ease;
      cursor: pointer;
      background-color: #fff;
      height: 100%;
      display: flex;
      flex-direction: column;
      border: 1px solid #f0f2f5;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
        
        .course-image img {
          transform: scale(1.05);
        }
        
        .course-title {
          color: #409EFF;
        }
      }
      
      .course-image {
        height: 160px;
        position: relative;
        overflow: hidden;
        
        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.3s ease;
        }
        
        .course-level {
          position: absolute;
          top: 10px;
          right: 10px;
          padding: 4px 10px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 500;
          color: #fff;
          background-color: #409EFF;
          box-shadow: 0 2px 6px rgba(64, 158, 255, 0.3);
          z-index: 1;
        }
        
        .course-status {
          position: absolute;
          top: 10px;
          left: 10px;
          padding: 4px 10px;
          border-radius: 20px;
          font-size: 12px;
          font-weight: 500;
          color: #fff;
          background-color: #F56C6C;
          box-shadow: 0 2px 6px rgba(245, 108, 108, 0.3);
          z-index: 1;
          
          &.online {
            background-color: #67C23A;
            box-shadow: 0 2px 6px rgba(103, 194, 58, 0.3);
          }
        }
        
        &::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          right: 0;
          height: 60px;
          background: linear-gradient(to top, rgba(0, 0, 0, 0.5), transparent);
          z-index: 0;
        }
      }
      
      .course-content {
        padding: 16px;
        flex: 1;
        display: flex;
        flex-direction: column;
        
        .course-title {
          font-size: 16px;
          font-weight: 600;
          color: #303133;
          margin: 0 0 10px;
          line-height: 1.4;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 1;
          -webkit-box-orient: vertical;
          height: 24px;
          transition: color 0.3s ease;
        }
        
        .course-description {
          font-size: 14px;
          color: #606266;
          margin-bottom: 15px;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          flex: 1;
          height: 40px;
        }
        
        .course-meta {
          display: flex;
          justify-content: space-between;
          margin-bottom: 15px;
          padding-top: 10px;
          border-top: 1px dashed #ebeef5;
          
          .meta-item {
            display: flex;
            align-items: center;
            font-size: 12px;
            color: #909399;
            
            .el-icon {
              margin-right: 4px;
              font-size: 14px;
              color: #409EFF;
            }
          }
        }
        
        .course-footer {
          display: flex;
          justify-content: flex-end;
          align-items: center;
          
          .el-button {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
            transition: all 0.3s ease;
            
            &:hover {
              transform: scale(1.05);
            }
          }
        }
      }
      
      &.disabled {
        opacity: 0.8;
        cursor: not-allowed;
        
        &:hover {
          transform: none;
          box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
          
          .course-image img {
            transform: none;
          }
          
          .course-title {
            color: #303133;
          }
        }
      }
    }
  }
  
  .pagination-container {
    display: flex;
    justify-content: center;
    margin-top: 30px;
    padding-top: 20px;
    border-top: 1px solid #f0f2f5;
    
    :deep(.el-pagination) {
      .el-pagination__total,
      .el-pagination__sizes,
      .el-pagination__jump {
        margin-right: 16px;
      }
      
      .el-pagination__jump {
        margin-left: 16px;
      }
      
      button {
        background-color: #f5f7fa;
        color: #606266;
        
        &:disabled {
          background-color: #f5f7fa;
          color: #c0c4cc;
        }
        
        &:hover:not(:disabled) {
          color: #409EFF;
        }
      }
      
      .el-pager li {
        background-color: #f5f7fa;
        color: #606266;
        
        &.is-active {
          background-color: #409EFF;
          color: #fff;
        }
        
        &:hover:not(.is-active) {
          color: #409EFF;
        }
      }
    }
  }
}

// 响应式调整
@media (max-width: 1280px) {
  .courses-container {
    .courses-list {
      .course-grid {
        grid-template-columns: repeat(3, 1fr);
      }
    }
  }
}

@media (max-width: 992px) {
  .courses-container {
    .courses-header-section {
      flex-direction: column;
      align-items: flex-start;
      
      .courses-header {
        max-width: 100%;
      }
      
      .filter-section {
        max-width: 100%;
        width: 100%;
      }
    }
    
    .courses-list {
      .course-grid {
        grid-template-columns: repeat(2, 1fr);
      }
    }
  }
}

@media (max-width: 576px) {
  .courses-container {
    .courses-list {
      .course-grid {
        grid-template-columns: 1fr;
      }
    }
  }
}
</style> 