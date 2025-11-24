<script setup lang="ts">
import { ref, onMounted, computed, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Clock,
  VideoPlay,
  Document,
  Share,
  Star,
  Back,
  Lock,
  Unlock,
  ArrowRight,
  Calendar,
  Timer,
  Check
} from '@element-plus/icons-vue'
// import { getCourseDetail, type CourseVO, type ChapterVO, COURSE_STATUS } from '@/api/course'
import { getCourseDetail } from '@/api/course/index'
import { COURSE_STATUS, type CourseVO } from '@/api/course/type'
import type { StudyRecordAddRequest, StudyRecordVO } from '@/api/studyRecord/type'
import { getCourseStudyRecord } from '@/api/statistics/index'
import { addStudyRecord, updateStudyRecordTime } from '@/api/studyRecord/index'
// import { getCourseStudyRecord, type StudyRecordVO } from '@/api/statistics'
// import type { StudyRecordAddRequest } from '@/api/studyRecord'
// import { addStudyRecord, updateStudyRecordTime } from '@/api/studyRecord'


const route = useRoute()
const router = useRouter()
const courseId = computed(() => route.params.id as string)

// 环境变量
const apiUrl = import.meta.env.VITE_API_URL || ''

// 课程详情
const courseDetail = ref<CourseVO | null>(null)
const loading = ref(true)
const activeChapter = ref<string>('')

// 学习记录相关
const isStudying = ref(false)
const startLoading = ref(false)
const submitLoading = ref(false)
const studyStartTime = ref<number>(0)
const studyDuration = ref(0)
const currentRecord = ref<StudyRecordVO | null>(null)
let timer: NodeJS.Timer | null = null

// 获取完整的图片URL
const getFullImageUrl = (imagePath: string | undefined) => {
  if (!imagePath) return 'https://via.placeholder.com/800x450?text=课程封面'
  if (imagePath.startsWith('http')) return imagePath
  return `${apiUrl}${imagePath}`
}

// 获取课程详情
const fetchCourseDetail = async () => {
  loading.value = true
  try {
    const res = await getCourseDetail(courseId.value)
    if (res.code === 0 && res.data) {
      courseDetail.value = res.data
      
      // 如果课程未上线，显示提示并返回
      if (courseDetail.value.status !== COURSE_STATUS.ONLINE) {
        ElMessageBox.alert('课程还没上线，敬请期待！', '提示', {
          confirmButtonText: '返回课程列表',
          callback: () => {
            router.push('/courses')
          }
        })
        return
      }
      
      // 如果有章节，默认选中第一个
      if (courseDetail.value.chapterList && courseDetail.value.chapterList.length > 0) {
        activeChapter.value = courseDetail.value.chapterList[0].id
      }
    } else {
      ElMessage.error(res.message || '获取课程详情失败')
      router.push('/courses')
    }
  } catch (error) {
    console.error('获取课程详情出错:', error)
    ElMessage.error('获取课程详情出错')
    router.push('/courses')
  } finally {
    loading.value = false
  }
}

// 计算课程总时长
const totalDuration = computed(() => {
  if (!courseDetail.value?.chapterList || courseDetail.value.chapterList.length === 0) {
    return 0
  }
  
  return courseDetail.value.chapterList.reduce((total, chapter) => {
    return total + (chapter.duration || 0)
  }, 0)
})

// 格式化时长显示
const formatDuration = (minutes: number) => {
  const hours = Math.floor(minutes / 60)
  const mins = Math.floor(minutes % 60)
  return hours > 0 ? `${hours}小时${mins}分钟` : `${mins}分钟`
}

// 格式化日期
const formatDate = (dateString: string) => {
  const date = new Date(dateString)
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, '0')}-${String(date.getDate()).padStart(2, '0')}`
}

// 选择章节
const selectChapter = (chapterId: string) => {
  activeChapter.value = chapterId
}

// 获取当前选中的章节
const currentChapter = computed(() => {
  if (!courseDetail.value?.chapterList || courseDetail.value.chapterList.length === 0) {
    return null
  }
  
  return courseDetail.value.chapterList.find(chapter => chapter.id === activeChapter.value) || null
})

// 返回课程列表
const goBack = () => {
  router.push('/courses')
}

// 开始学习
const handleStartStudy = async () => {
  startLoading.value = true
  try {
    // 获取当前课程的学习记录
    const res = await getCourseStudyRecord(route.params.id as string)
    if (res.code === 0) {
      currentRecord.value = res.data
    }
    
    // 开始计时
    studyStartTime.value = Date.now()
    isStudying.value = true
    
    // 更新显示时长
    timer = setInterval(() => {
      const elapsed = Math.floor((Date.now() - studyStartTime.value) / 60000) // 转换为分钟
      studyDuration.value = elapsed + (currentRecord.value?.studyTime || 0)
    }, 60000) // 每分钟更新一次
    
  } catch (error) {
    console.error('获取学习记录失败:', error)
    ElMessage.error('开始学习失败')
  } finally {
    startLoading.value = false
  }
}

// 提交打卡
const handleSubmitStudy = async () => {
  if (!studyStartTime.value) return
  
  submitLoading.value = true
  try {
    const elapsed = Math.floor((Date.now() - studyStartTime.value) / 60000) // 转换为分钟
    
    if (currentRecord.value) {
      // 更新已有记录
      const newDuration = (currentRecord.value.studyTime || 0) + elapsed
      await updateStudyRecordTime(currentRecord.value.id, newDuration)
    } else {
      // 创建新记录
      const newRecord: StudyRecordAddRequest = {
        courseId: Number(route.params.id),
        progress: 0,
        score: 0,
        status: '进行中',
        studyTime: elapsed,
        userId: 0, // 后端会自动设置
        vocabularyId: 0
      }
      await addStudyRecord(newRecord)
    }
    
    ElMessage.success('打卡成功')
    isStudying.value = false
    studyStartTime.value = 0
    studyDuration.value = 0
    
    if (timer) {
      clearInterval(timer)
      timer = null
    }
    
  } catch (error) {
    console.error('提交打卡失败:', error)
    ElMessage.error('提交打卡失败')
  } finally {
    submitLoading.value = false
  }
}

// 组件卸载时清理定时器
onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
    timer = null
  }
})

onMounted(() => {
  fetchCourseDetail()
})
</script>

<template>
  <div class="course-detail-container">
    <el-skeleton v-if="loading" :rows="10" animated />
    
    <template v-else>
      <!-- 面包屑导航 -->
      <div class="breadcrumb-nav">
        <el-breadcrumb separator="/">
          <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
          <el-breadcrumb-item :to="{ path: '/courses' }">课程学习</el-breadcrumb-item>
          <el-breadcrumb-item>{{ courseDetail?.title }}</el-breadcrumb-item>
        </el-breadcrumb>
      </div>
      
      <!-- 课程头部信息 -->
      <div class="course-header">
        <div class="course-banner" :style="{ backgroundImage: `url(${getFullImageUrl(courseDetail?.coverImage)})` }">
          <div class="banner-overlay">
            <div class="course-info">
              <h1 class="course-title">{{ courseDetail?.title }}</h1>
              <p class="course-description">{{ courseDetail?.description }}</p>
              
              <div class="course-meta">
                <div class="meta-item">
                  <el-icon><Clock /></el-icon>
                  <span>总时长: {{ formatDuration(totalDuration) }}</span>
                </div>
                
                <div class="meta-item">
                  <el-icon><VideoPlay /></el-icon>
                  <span>章节数: {{ courseDetail?.chapterCount || 0 }}</span>
                </div>
                
                <div class="meta-item">
                  <el-icon><Calendar /></el-icon>
                  <span>更新时间: {{ formatDate(courseDetail?.updateTime || '') }}</span>
                </div>
                
                <el-tag size="small" :type="courseDetail?.level === '高级' ? 'danger' : courseDetail?.level === '中级' ? 'warning' : 'success'">
                  {{ courseDetail?.level }}
                </el-tag>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <!-- 课程内容 -->
      <div class="course-content">
        <div class="chapter-list">
          <h2>课程章节</h2>
          
          <el-menu
            :default-active="activeChapter"
            class="chapter-menu"
          >
            <el-menu-item
              v-for="chapter in courseDetail?.chapterList"
              :key="chapter.id"
              :index="chapter.id"
              @click="selectChapter(chapter.id)"
            >
              <div class="chapter-item">
                <div class="chapter-info">
                  <el-icon><Document /></el-icon>
                  <div class="chapter-text">
                    <span class="chapter-title">{{ chapter.title }}</span>
                    <span class="chapter-duration">
                      <el-icon><Clock /></el-icon>
                      {{ formatDuration(chapter.duration) }}
                    </span>
                  </div>
                </div>
              </div>
            </el-menu-item>
          </el-menu>
        </div>
        
        <div class="chapter-detail">
          <div v-if="currentChapter" class="chapter-content">
            <div class="chapter-header">
              <h2>{{ currentChapter.title }}</h2>
              <div class="chapter-meta">
                <div class="meta-item">
                  <el-icon><Clock /></el-icon>
                  <span>{{ formatDuration(currentChapter.duration) }}</span>
                </div>
              </div>
            </div>
            
            <div class="video-container">
              <video
                v-if="currentChapter.videoUrl"
                controls
                :src="getFullImageUrl(currentChapter.videoUrl)"
                :poster="getFullImageUrl(currentChapter.coverImage)"
                class="chapter-video"
              ></video>
              <div v-else class="no-video">
                <el-icon><VideoPlay /></el-icon>
                <p>暂无视频</p>
              </div>
            </div>
            
            <div class="chapter-description">
              <h3>章节内容</h3>
              <div class="content-text">{{ currentChapter.content }}</div>
            </div>
          </div>
          
          <div v-else class="no-chapter-selected">
            <el-empty description="请选择一个章节开始学习" />
          </div>
        </div>
      </div>
      
      <!-- 学习打卡按钮组 -->
      <div class="study-record">
        <el-button 
          type="primary" 
          :icon="Timer"
          :loading="startLoading"
          @click="handleStartStudy"
          v-if="!isStudying"
        >
          开始学习
        </el-button>
        <el-button 
          type="success" 
          :icon="Check"
          :loading="submitLoading"
          @click="handleSubmitStudy"
          v-else
        >
          提交打卡 {{ formatDuration(studyDuration) }}
        </el-button>
      </div>
    </template>
  </div>
</template>

<style scoped lang="scss">
.course-detail-container {
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
  
  .breadcrumb-nav {
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid #ebeef5;
    
    :deep(.el-breadcrumb) {
      .el-breadcrumb__item {
        .el-breadcrumb__inner {
          color: #606266;
          font-weight: normal;
          
          &.is-link {
            color: #409EFF;
            font-weight: 500;
            
            &:hover {
              color: #66b1ff;
            }
          }
        }
        
        &:last-child {
          .el-breadcrumb__inner {
            color: #303133;
            font-weight: 600;
          }
        }
        
        .el-breadcrumb__separator {
          color: #909399;
        }
      }
    }
  }
  
  .course-header {
    margin-bottom: 30px;
    
    .course-banner {
      height: 300px;
      border-radius: 8px;
      overflow: hidden;
      background-size: cover;
      background-position: center;
      position: relative;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      
      .banner-overlay {
        position: absolute;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: linear-gradient(to right, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.4));
        display: flex;
        align-items: center;
        padding: 40px;
        
        .course-info {
          max-width: 600px;
          color: #fff;
          
          .course-title {
            font-size: 32px;
            font-weight: 700;
            margin-bottom: 16px;
            text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
          }
          
          .course-description {
            font-size: 16px;
            margin-bottom: 24px;
            opacity: 0.9;
            line-height: 1.6;
          }
          
          .course-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: center;
            
            .meta-item {
              display: flex;
              align-items: center;
              font-size: 14px;
              
              .el-icon {
                margin-right: 8px;
                font-size: 16px;
              }
            }
            
            .el-tag {
              padding: 0 12px;
              height: 24px;
              line-height: 24px;
              border-radius: 12px;
              font-weight: 500;
            }
          }
        }
      }
    }
  }
  
  .course-content {
    display: flex;
    gap: 30px;
    
    .chapter-list {
      width: 320px;
      flex-shrink: 0;
      
      h2 {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 16px;
        padding-bottom: 12px;
        border-bottom: 1px solid #ebeef5;
        position: relative;
        
        &::after {
          content: '';
          position: absolute;
          bottom: -1px;
          left: 0;
          width: 50px;
          height: 3px;
          background-color: #409EFF;
          border-radius: 3px;
        }
      }
      
      .chapter-menu {
        border-radius: 8px;
        border: 1px solid #ebeef5;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        
        .el-menu-item {
          height: auto;
          padding: 16px 20px;
          line-height: 1.5;
          
          &.is-active {
            background-color: #ecf5ff;
            color: #409EFF;
            
            &::before {
              content: '';
              position: absolute;
              left: 0;
              top: 0;
              bottom: 0;
              width: 4px;
              background-color: #409EFF;
              border-radius: 0 2px 2px 0;
            }
            
            .chapter-duration {
              color: #409EFF;
            }
          }
          
          &:hover:not(.is-active) {
            background-color: #f5f7fa;
          }
          
          .chapter-item {
            width: 100%;
            
            .chapter-info {
              display: flex;
              align-items: flex-start;
              gap: 12px;
              
              .el-icon {
                margin-top: 2px;
                font-size: 18px;
                color: #909399;
              }
              
              .chapter-text {
                flex: 1;
                display: flex;
                flex-direction: column;
                gap: 6px;
                
                .chapter-title {
                  font-weight: 500;
                  font-size: 15px;
                  color: #303133;
                  line-height: 1.4;
                }
                
                .chapter-duration {
                  display: flex;
                  align-items: center;
                  gap: 4px;
                  font-size: 13px;
                  color: #909399;
                  
                  .el-icon {
                    margin: 0;
                    font-size: 14px;
                  }
                }
              }
            }
          }
        }
      }
    }
    
    .chapter-detail {
      flex: 1;
      
      .chapter-content {
        .chapter-header {
          margin-bottom: 20px;
          background-color: #f5f7fa;
          padding: 16px 20px;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
          
          h2 {
            font-size: 24px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #303133;
          }
          
          .chapter-meta {
            display: flex;
            gap: 16px;
            
            .meta-item {
              display: flex;
              align-items: center;
              font-size: 14px;
              color: #606266;
              
              .el-icon {
                margin-right: 6px;
                font-size: 16px;
                color: #409EFF;
              }
            }
          }
        }
        
        .video-container {
          margin-bottom: 24px;
          border-radius: 8px;
          overflow: hidden;
          background-color: #000;
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
          
          .chapter-video {
            width: 100%;
            max-height: 500px;
            display: block;
          }
          
          .no-video {
            height: 300px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: #909399;
            background-color: #f5f7fa;
            
            .el-icon {
              font-size: 48px;
              margin-bottom: 16px;
              color: #c0c4cc;
            }
            
            p {
              font-size: 16px;
            }
          }
        }
        
        .chapter-description {
          background-color: #f5f7fa;
          padding: 24px;
          border-radius: 8px;
          box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
          
          h3 {
            font-size: 18px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #303133;
            position: relative;
            padding-bottom: 12px;
            border-bottom: 1px solid #ebeef5;
            
            &::after {
              content: '';
              position: absolute;
              bottom: -1px;
              left: 0;
              width: 40px;
              height: 3px;
              background-color: #409EFF;
              border-radius: 3px;
            }
          }
          
          .content-text {
            font-size: 15px;
            line-height: 1.8;
            color: #606266;
            white-space: pre-line;
          }
        }
      }
      
      .no-chapter-selected {
        height: 300px;
        display: flex;
        justify-content: center;
        align-items: center;
        background-color: #f5f7fa;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
      }
    }
  }
  
  .study-record {
    position: fixed;
    bottom: 40px;
    right: 40px;
    z-index: 100;
    
    .el-button {
      padding: 12px 24px;
      font-size: 16px;
      border-radius: 24px;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
      
      .el-icon {
        font-size: 18px;
        margin-right: 8px;
      }
    }
  }
}

// 响应式调整
@media (max-width: 992px) {
  .course-detail-container {
    .course-content {
      flex-direction: column;
      
      .chapter-list {
        width: 100%;
        margin-bottom: 24px;
      }
    }
  }
}

@media (max-width: 768px) {
  .course-detail-container {
    .course-header {
      .course-banner {
        height: auto;
        
        .banner-overlay {
          position: relative;
          padding: 24px;
          background: linear-gradient(to bottom, rgba(0, 0, 0, 0.7), rgba(0, 0, 0, 0.4));
          
          .course-info {
            max-width: 100%;
            
            .course-title {
              font-size: 24px;
            }
            
            .course-meta {
              gap: 12px;
              flex-direction: column;
              align-items: flex-start;
            }
          }
        }
      }
    }
    
    .course-content {
      .chapter-detail {
        .chapter-content {
          .video-container {
            .chapter-video,
            .no-video {
              height: 200px;
            }
          }
        }
      }
    }
  }
}
</style> 