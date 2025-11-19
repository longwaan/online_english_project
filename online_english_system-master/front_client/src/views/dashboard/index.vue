<script setup lang="ts">
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import { useUserStore } from '@/stores/modules/user'
import {
  Reading,
  Collection,
  EditPen,
  DataAnalysis,
  Promotion,
  Trophy,
  Histogram,
  Calendar,
  Bell,
  ChatDotRound,
  Headset,
  Compass,
  Star,
  Timer,
  Share,
  Refresh
} from '@element-plus/icons-vue'
// import { getCourseList, type CourseVO } from '@/api/course'

import axios from 'axios'
import { getStudyOverview } from '@/api/statistics'
import { ElMessage } from 'element-plus'
import {getDailyQuote} from '@/api/dict.ts'
import type { CourseVO } from '@/api/course/type'
import { getCourseList } from '@/api/course/index'

const router = useRouter()
const userStore = useUserStore()
const userInfo = computed(() => userStore.userInfo)

// 环境变量
const apiUrl = import.meta.env.VITE_API_URL || ''

// 获取完整的头像URL
const getFullAvatarUrl = (avatarPath: string | undefined) => {
  if (!avatarPath) return ''
  if (avatarPath.startsWith('http')) return avatarPath
  return `${apiUrl}${avatarPath}`
}

// 用户头像
const userAvatar = computed(() => getFullAvatarUrl(userInfo.value?.userAvatar))

// 学习进度数据
const learningProgress = ref({
  courses: {
    total: 12,
    completed: 3,
    percentage: 25
  },
  vocabulary: {
    total: 500,
    learned: 120,
    percentage: 24
  },
  quizzes: {
    total: 20,
    completed: 5,
    percentage: 25
  }
})

// 推荐课程
const recommendedCourses = ref<CourseVO[]>([])

// 获取推荐课程
const fetchRecommendedCourses = async () => {
  try {
    const res = await getCourseList({
      current: 1,
      pageSize: 6,
      // 可以根据需要添加其他筛选条件
    })

    if (res.code === 0 && res.data.records) {
      recommendedCourses.value = res.data.records
    } else {
      console.error('获取课程数据失败:', res.message)
    }
  } catch (error) {
    console.error('获取课程数据出错:', error)
  }
}

// 每日单词数据类型
interface DailyWord {
  word: string;
  ukphone: string;
  ukspeech: string;
  usphone: string;
  usspeech: string;
  translations: {
    pos: string;
    tran_cn: string;
  }[];
  sentences: {
    s_content: string;
    s_cn: string;
  }[];
  synonyms: {
    pos: string;
    tran: string;
    Hwds: {
      word: string;
    }[];
  }[];
  relWords: {
    Pos: string;
    Hwds: {
      hwd: string;
      tran: string;
    }[];
  }[];
}

// 每日单词
const dailyWord = ref<DailyWord>({})

// 获取每日单词
const fetchDailyWord = async () => {
  try {
    axios.get('https://v2.xxapi.cn/api/randomenglishwords').then(res => {
      dailyWord.value = res.data.data
    })
    console.log('获取每日一词成功')
  } catch (error) {
    console.error('获取每日单词失败:', error)
  }
}

// 播放单词发音
const playWordAudio = (audioUrl: string) => {
  if (!audioUrl) return
  const audio = new Audio(audioUrl)
  audio.play()
}

// 学习提示
const learningTips = ref([
  '每天坚持学习15-30分钟比一次性长时间学习更有效',
  '大声朗读可以提高发音和语感',
  '使用英语思考日常事务可以提升语言流畅度',
  '观看英语原版电影和剧集是提高听力的好方法',
  '找一个学习伙伴可以互相督促和练习口语'
])

// 随机学习提示
const randomTip = ref('')

// 更新随机提示
const updateRandomTip = () => {
  const randomIndex = Math.floor(Math.random() * learningTips.value.length)
  randomTip.value = learningTips.value[randomIndex]
}

// 学习统计数据
const statisticsData = ref({
  weeklyStudyHours: 0,
  monthlyProgress: 0,
  vocabularyMastered: 0,
  streakDays: 0
})

// 获取学习统计数据
const fetchStatistics = async () => {
  try {
    const res = await getStudyOverview()
    if (res.code === 0 && res.data) {
      statisticsData.value = {
        // 将分钟转换为小时
        weeklyStudyHours: Math.round((res.data.totalStudyTime / 60) * 10) / 10,
        // 平均进度
        monthlyProgress: Math.round(res.data.avgProgress),
        // 已掌握词汇数
        vocabularyMastered: Number(res.data.masteredVocabulary),
        // 学习天数
        streakDays: Number(res.data.studyDays)
      }
    }
  } catch (error) {
    console.error('获取学习统计数据失败:', error)
    ElMessage.error('获取学习统计数据失败')
  }
}

// 最近活动
const recentActivities = ref([
  {
    type: 'course',
    title: '完成了课程：英语口语入门 - 第1课',
    time: '今天',
    icon: 'Reading'
  },
  {
    type: 'vocabulary',
    title: '学习了20个新单词',
    time: '昨天',
    icon: 'Collection'
  },
  {
    type: 'quiz',
    title: '完成了测验：基础语法测试',
    time: '2天前',
    icon: 'EditPen'
  },
  {
    type: 'achievement',
    title: '获得成就：连续学习7天',
    time: '3天前',
    icon: 'Trophy'
  }
])

// 计算课程总时长（分钟）
const calculateCourseDuration = (course: CourseVO) => {
  if (!course.chapterList || course.chapterList.length === 0) {
    return 0;
  }

  return course.chapterList.reduce((total, chapter) => {
    return total + (chapter.duration || 0);
  }, 0);
}

// 格式化时长显示
const formatDuration = (minutes: number) => {
  if (minutes < 60) {
    return `${minutes}分钟`;
  } else {
    const hours = Math.floor(minutes / 60);
    const mins = minutes % 60;
    return mins > 0 ? `${hours}小时${mins}分钟` : `${hours}小时`;
  }
}

// 处理课程点击
const handleCourseClick = (courseId: number) => {
  router.push(`/courses/${courseId}`)
}

// 处理查看全部
const handleViewAll = (type: string) => {
  switch (type) {
    case 'courses':
      router.push('/courses')
      break
    case 'vocabulary':
      router.push('/vocabulary')
      break
    case 'quizzes':
      router.push('/quiz')
      break
    default:
      break
  }
}

// 添加每日一句数据类型
interface DailyQuote {
  id: string;
  content: string;
  translation: string;
  author: string;
  assign_date: string;
  origin_img_urls: string[];
}

// 添加每日一句数据
const dailyQuote = ref<DailyQuote>({
  id: "izxsc",
  content: "Keep your head up in failure, and your head down in success.",
  author: "Jerry Seinfeld",
  assign_date: "2025-03-20",
  translation: "失败时，要高昂起头；成功时，要保持谦逊。",
  origin_img_urls: [
    "https://media-image1.baydn.com/soup_pub_image/tkdghk/927ada51cad2b0010765b674aa167495.5aec8b84281cc828c844782ef2e121bd.jpeg"
  ]
})

// 获取每日一句数据的函数
const fetchDailyQuote = async () => {
  try {
    // 这里将来替换为实际的API调用
    const res = await getDailyQuote()
    if (res.status === 200) {
      dailyQuote.value = res.data
    }
    console.log('获取每日一句成功',res)
  } catch (error) {
    console.error('获取每日一句失败:', error)
  }
}

onMounted(() => {
  updateRandomTip()
  fetchRecommendedCourses()
  fetchDailyQuote()
  fetchDailyWord()
  fetchStatistics()

  // 每30秒更新一次随机提示
  setInterval(updateRandomTip, 30000)
})
</script>

<template>
  <div class="dashboard-container">
    <!-- 欢迎横幅 -->
    <div class="welcome-banner">
      <div class="welcome-content">
        <div class="welcome-text">
          <h1>欢迎回来，{{ userInfo?.userName || '同学' }}！</h1>
          <p>继续您的英语学习之旅，今天的目标是什么？</p>
        </div>
        <div class="welcome-actions">
          <el-button type="primary" size="large" @click="router.push('/courses')">
            <el-icon>
              <Reading />
            </el-icon>
            继续学习
          </el-button>
          <el-button size="large" @click="router.push('/vocabulary')">
            <el-icon>
              <Collection />
            </el-icon>
            复习单词
          </el-button>
        </div>
      </div>
      <div class="welcome-decoration">
        <img src="https://img.freepik.com/free-vector/english-teacher-concept-illustration_114360-7477.jpg"
          alt="学习插图" />
      </div>
    </div>

    <!-- 主要内容区域 -->
    <div class="dashboard-main">
      <!-- 左侧：每日单词 -->
      <div class="dashboard-left">
        <!-- 每日单词卡片 -->
        <el-card class="words-card">
          <template #header>
            <div class="card-header">
              <h2>
                <el-icon><Collection /></el-icon>
                每日一词
              </h2>
              <div class="header-actions">
                <el-button 
                  circle 
                  size="small" 
                  @click="fetchDailyWord" 
                  :title="'刷新单词'"
                  class="refresh-btn"
                >
                  <el-icon><Refresh /></el-icon>
                </el-button>
                <el-button text @click="router.push('/vocabulary')">
                  更多单词
                  <el-icon class="el-icon--right"><ArrowRight /></el-icon>
                </el-button>
              </div>
            </div>
          </template>

          <div class="word-detail">
            <div class="word-header">
              <h3 class="word-title">{{ dailyWord.word }}</h3>
              <div class="word-phonetic">
                <span v-if="dailyWord.ukphone">
                  英 [{{ dailyWord.ukphone }}]
                  <el-button v-if="dailyWord.ukspeech" size="small" circle @click="playWordAudio(dailyWord.ukspeech)">
                    <el-icon>
                      <Headset />
                    </el-icon>
                  </el-button>
                </span>
                <span v-if="dailyWord.usphone">
                  美 [{{ dailyWord.usphone }}]
                  <el-button v-if="dailyWord.usspeech" size="small" circle @click="playWordAudio(dailyWord.usspeech)">
                    <el-icon>
                      <Headset />
                    </el-icon>
                  </el-button>
                </span>
              </div>
            </div>

            <div class="word-translations">
              <div v-for="(trans, index) in dailyWord.translations" :key="index" class="translation-item">
                <span class="pos">{{ trans.pos }}.</span>
                <span class="meaning">{{ trans.tran_cn }}</span>
              </div>
            </div>

            <div class="word-sentences">
              <h4>例句</h4>
              <div v-for="(sentence, index) in dailyWord.sentences" :key="index" class="sentence-item">
                <p class="sentence-en">{{ sentence.s_content }}</p>
                <p class="sentence-cn">{{ sentence.s_cn }}</p>
              </div>
            </div>

            <div class="word-extra">
              <div v-if="dailyWord.synonyms && dailyWord.synonyms.length > 0" class="synonyms">
                <h4>近义词</h4>
                <div v-for="(syn, index) in dailyWord.synonyms" :key="index" class="synonym-group">
                  <span class="pos">{{ syn.pos }}.</span>
                  <span class="meaning">{{ syn.tran }}</span>
                  <div class="synonym-words">
                    <el-tag 
                      v-for="(word, wIndex) in syn.Hwds" 
                      :key="wIndex"
                      size="small"
                      effect="plain"
                      class="synonym-tag"
                    > 
                      {{ word.word }}
                    </el-tag>
                  </div>
                </div>
              </div>

              <div v-if="dailyWord.relWords && dailyWord.relWords.length > 0" class="related-words">
                <h4>相关词</h4>
                <div v-for="(rel, index) in dailyWord.relWords" :key="index" class="related-group">
                  <span class="pos">{{ rel.Pos }}.</span>
                  <div class="related-items">
                    <div v-for="(word, wIndex) in rel.Hwds" :key="wIndex" class="related-item">
                      <span class="word">{{ word.hwd }}</span>
                      <span class="meaning">{{ word.tran }}</span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </el-card>
      </div>

      <!-- 右侧：学习统计、学习小贴士 -->
      <div class="dashboard-right">
        <!-- 学习统计 -->
        <el-card class="stats-card">
          <template #header>
            <div class="card-header">
              <h2>
                <el-icon>
                  <DataAnalysis />
                </el-icon>
                学习统计
              </h2>
              <el-button text @click="router.push('/statistics')">
                查看详情
                <el-icon class="el-icon--right">
                  <ArrowRight />
                </el-icon>
              </el-button>
            </div>
          </template>

          <div class="stats-grid">
            <div class="stat-item">
              <div class="stat-icon">
                <el-icon>
                  <Calendar />
                </el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-value">{{ statisticsData.weeklyStudyHours }}h</div>
                <div class="stat-label">本周学习时长</div>
              </div>
            </div>

            <div class="stat-item">
              <div class="stat-icon">
                <el-icon>
                  <Histogram />
                </el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-value">{{ statisticsData.monthlyProgress }}%</div>
                <div class="stat-label">平均学习进度</div>
              </div>
            </div>

            <div class="stat-item">
              <div class="stat-icon">
                <el-icon>
                  <Collection />
                </el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-value">{{ statisticsData.vocabularyMastered }}</div>
                <div class="stat-label">已掌握词汇</div>
              </div>
            </div>

            <div class="stat-item">
              <div class="stat-icon">
                <el-icon>
                  <Trophy />
                </el-icon>
              </div>
              <div class="stat-content">
                <div class="stat-value">{{ statisticsData.streakDays }}</div>
                <div class="stat-label">学习天数</div>
              </div>
            </div>
          </div>
        </el-card>

        <!-- 学习提示 -->
        <el-card class="tip-card">
          <template #header>
            <div class="card-header">
              <h2>
                <el-icon>
                  <ChatDotRound />
                </el-icon>
                学习小贴士
              </h2>
            </div>
          </template>

          <div class="tip-content">
            <el-icon>
              <Compass />
            </el-icon>
            <p>{{ randomTip }}</p>
          </div>
        </el-card>
      </div>
    </div>

    <!-- 第二行：每日一句和最近活动并排 -->
    <div class="dashboard-second-row">
      <!-- 每日一句卡片 -->
      <el-card class="quote-card">
        <template #header>
          <div class="card-header">
            <h2>
              <el-icon>
                <ChatDotRound />
              </el-icon>
              每日一句
            </h2>
            <span class="quote-date">{{ dailyQuote.assign_date }}</span>
          </div>
        </template>

        <div class="quote-content">
          <div class="quote-text">
            <p class="quote-original">{{ dailyQuote.content }}</p>
            <p class="quote-translation">{{ dailyQuote.translation }}</p>
            <p class="quote-author">—— {{ dailyQuote.author }}</p>
          </div>
          <div class="quote-image" v-if="dailyQuote.origin_img_urls && dailyQuote.origin_img_urls.length > 0">
            <img :src="dailyQuote.origin_img_urls[0]" alt="每日一句配图" />
          </div>
        </div>
      </el-card>

      <!-- 最近活动 -->
      <el-card class="activities-card">
        <template #header>
          <div class="card-header">
            <h2>
              <el-icon>
                <Bell />
              </el-icon>
              最近活动
            </h2>
          </div>
        </template>

        <div class="activities-list">
          <div v-for="(activity, index) in recentActivities" :key="index" class="activity-item">
            <div class="activity-icon">
              <el-icon v-if="activity.icon === 'Reading'">
                <Reading />
              </el-icon>
              <el-icon v-else-if="activity.icon === 'Collection'">
                <Collection />
              </el-icon>
              <el-icon v-else-if="activity.icon === 'EditPen'">
                <EditPen />
              </el-icon>
              <el-icon v-else-if="activity.icon === 'Trophy'">
                <Trophy />
              </el-icon>
            </div>
            <div class="activity-content">
              <div class="activity-title">{{ activity.title }}</div>
              <div class="activity-time">{{ activity.time }}</div>
            </div>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 推荐课程 (占满整个宽度) -->
    <el-card class="courses-card">
      <template #header>
        <div class="card-header">
          <h2>
            <el-icon>
              <Promotion />
            </el-icon>
            推荐课程
          </h2>
          <el-button text @click="handleViewAll('courses')">
            查看全部
            <el-icon class="el-icon--right">
              <ArrowRight />
            </el-icon>
          </el-button>
        </div>
      </template>

      <div class="course-list">
        <div v-for="course in recommendedCourses" :key="course.id" class="course-item"
          @click="handleCourseClick(course.id)">
          <div class="course-image">
            <img :src="course.coverImage.startsWith('http') ? course.coverImage : `${apiUrl}${course.coverImage}`"
              :alt="course.title" />
            <div v-if="course.progress > 0" class="course-progress">
              <el-progress :percentage="course.progress" :show-text="false" :stroke-width="4"></el-progress>
              <span>{{ course.progress }}% 完成</span>
            </div>
            <div v-else class="course-new">
              <el-tag type="success" effect="dark" size="small">新课程</el-tag>
            </div>
          </div>
          <div class="course-info">
            <h3>{{ course.title }}</h3>
            <p class="course-description">
              {{ course.description }}
            </p>
            <div class="course-meta">
              <el-tag size="small" effect="plain">
                <el-icon>
                  <Compass />
                </el-icon>
                {{ course.level }}
              </el-tag>
              <el-tag size="small" effect="plain" type="info">
                <el-icon>
                  <Reading />
                </el-icon>
                {{ course.chapterCount }}章
              </el-tag>
              <el-tag size="small" effect="plain" type="warning">
                <el-icon>
                  <Timer />
                </el-icon>
                {{ formatDuration(calculateCourseDuration(course)) }}
              </el-tag>
            </div>
          </div>
        </div>
      </div>
    </el-card>
  </div>
</template>

<style scoped lang="scss">
.dashboard-container {
  max-width: 1400px;
  margin: 0 auto;
  padding: 20px;
  background: #fff;

  img {
    max-width: 100%;
    object-fit: cover;
    vertical-align: middle;
  }
}

// 欢迎横幅
.welcome-banner {
  background: linear-gradient(135deg, #4b6cb7 0%, #182848 100%);
  border-radius: 12px;
  padding: 30px;
  margin-bottom: 30px;
  color: white;
  display: flex;
  justify-content: space-between;
  align-items: center;
  overflow: hidden;
  position: relative;
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);

  .welcome-content {
    flex: 1;
    z-index: 2;

    .welcome-text {
      margin-bottom: 20px;

      h1 {
        font-size: 28px;
        margin: 0 0 10px;
        font-weight: 600;
      }

      p {
        font-size: 16px;
        margin: 0;
        opacity: 0.9;
      }
    }

    .welcome-actions {
      display: flex;
      gap: 15px;

      .el-button {
        &:hover {
          transform: none;
          box-shadow: none;
        }
      }
    }
  }

  .welcome-decoration {
    width: 200px;
    height: 200px;
    z-index: 1;

    img {
      width: 100%;
      max-width: 280px;
      height: auto;
      border-radius: 12px;
      box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);

      &:hover {
        transform: translateY(-5px);
      }
    }
  }
}

// 主内容区域布局优化
.dashboard-main {
  display: flex;
  gap: 20px;
  margin-bottom: 20px;

  .dashboard-left {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 20px;

    // 确保左侧内容与右侧等高
    .words-card {
      flex: 1;

      :deep(.el-card__body) {
        max-height: 300px;
        overflow: auto;
      }
    }
  }

  .dashboard-right {
    flex: 1;
    display: flex;
    flex-direction: column;
    gap: 20px;

    // 调整右侧卡片高度比例
    .stats-card {
      :deep(.el-card__body) {
        padding: 15px;
      }
    }

    .tip-card {
      :deep(.el-card__body) {
        padding: 15px;
      }
    }
  }
}

// 第二行布局：每日一句和最近活动并排
.dashboard-second-row {
  display: flex;
  gap: 20px;
  margin-top: 20px;
  margin-bottom: 20px;

  .quote-card {
    flex: 1;
    margin-top: 0;

    .quote-content {
      display: flex;
      gap: 15px;
      margin-bottom: 10px;

      .quote-text {
        flex: 1;
      }

      .quote-image {
        width: 120px;
        height: 120px;
        flex-shrink: 0;
        border-radius: 10px;
        overflow: hidden;

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
        }
      }
    }
  }

  .activities-card {
    flex: 1;

    :deep(.el-card__body) {
      max-height: 220px;
      overflow: auto;
    }
  }

  // 在小屏幕上改为纵向排列
  @media (max-width: 992px) {
    flex-direction: column;
  }
}

// 卡片通用样式
.el-card {
  border-radius: 8px;
  transition: transform 0.3s, box-shadow 0.3s;

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    h2 {
      font-size: 18px;
      margin: 0;
      display: flex;
      align-items: center;

      .el-icon {
        margin-right: 8px;
        font-size: 20px;
      }
    }
  }
}

// 每日单词卡片样式优化 - 扁平化设计
.words-card {
  :deep(.el-card__body) {
    padding: 20px;
    max-height: 500px;
    overflow: auto;
  }
  
  .word-detail {
    // 移除内部卡片的嵌套感觉
    padding: 0;
    border-radius: 0;
    background: transparent;
    box-shadow: none;
    border-left: none;
    
    .word-header {
      margin-bottom: 20px;
      border-bottom: 1px solid #ebeef5;
      padding-bottom: 15px;
      
      .word-title {
        font-size: 28px;
        font-weight: 700;
        color: #303133;
        margin: 0 0 10px;
        letter-spacing: 0.5px;
        text-transform: capitalize;
      }
      
      .word-phonetic {
        display: flex;
        flex-wrap: wrap;
        gap: 15px;
        color: #606266;
        font-size: 14px;
        
        span {
          display: flex;
          align-items: center;
          background-color: #f5f7fa;
          padding: 4px 10px;
          border-radius: 20px;
          
          .el-button {
            margin-left: 8px;
            background-color: #ecf5ff;
            color: #409EFF;
            
            &:hover {
              transform: scale(1.1);
              background-color: #409EFF;
              color: white;
            }
          }
        }
      }
    }
    
    .word-translations {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px dashed #e4e7ed;
      
      .translation-item {
        margin-bottom: 8px;
        display: flex;
        align-items: baseline;
        
        .pos {
          font-weight: 600;
          color: #409EFF;
          margin-right: 10px;
          background-color: #ecf5ff;
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 13px;
        }
        
        .meaning {
          color: #303133;
          font-size: 15px;
        }
      }
    }
    
    // 使用分隔线代替嵌套卡片
    .word-sentences {
      margin-bottom: 20px;
      
      h4 {
        font-size: 16px;
        font-weight: 600;
        color: #303133;
        margin: 0 0 12px;
        display: flex;
        align-items: center;
        
        &::before {
          content: '';
          display: inline-block;
          width: 4px;
          height: 16px;
          background-color: #409EFF;
          margin-right: 8px;
          border-radius: 2px;
        }
      }
      
      .sentence-item {
        background-color: #f5f7fa;
        border-radius: 8px;
        padding: 12px 15px;
        margin-bottom: 10px;
        border-left: 3px solid #409EFF;
        
        .sentence-en {
          color: #303133;
          margin: 0 0 8px;
          font-style: italic;
          font-size: 15px;
          line-height: 1.5;
        }
        
        .sentence-cn {
          color: #606266;
          margin: 0;
          font-size: 14px;
        }
      }
    }
    
    .word-extra {
      margin-bottom: 20px;
      
      // 近义词部分样式优化 - 扁平化设计
      .synonyms {
        margin-bottom: 20px;
        
        h4 {
          font-size: 16px;
          font-weight: 600;
          color: #303133;
          margin: 0 0 12px;
          display: flex;
          align-items: center;
          
          &::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 16px;
            background-color: #E6A23C;
            margin-right: 8px;
            border-radius: 2px;
          }
        }
        
        .synonym-group {
          margin-bottom: 15px;
          // 移除背景和边框，使用分隔线
          background-color: transparent;
          border-radius: 0;
          padding: 0 0 10px 0;
          border-bottom: 1px dashed #e4e7ed;
          
          &:last-child {
            border-bottom: none;
            margin-bottom: 0;
          }
          
          .pos {
            font-weight: 600;
            color: #E6A23C;
            margin-right: 10px;
            background-color: #fdf6ec;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 13px;
            display: inline-block;
            margin-bottom: 8px;
          }
          
          .meaning {
            color: #303133;
            margin-right: 10px;
            font-size: 14px;
            display: inline-block;
          }
          
          .synonym-words {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-top: 10px;
            
            .synonym-tag {
              cursor: pointer;
              background-color: #ffffff;
              border-color: #e4e7ed;
              padding: 6px 12px;
              border-radius: 4px;
              transition: all 0.3s ease;
              
              &:hover {
                color: #E6A23C;
                border-color: #E6A23C;
                background-color: #fdf6ec;
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
              }
            }
          }
        }
      }
      
      // 相关词部分样式优化 - 扁平化设计
      .related-words {
        h4 {
          font-size: 16px;
          font-weight: 600;
          color: #303133;
          margin: 0 0 12px;
          display: flex;
          align-items: center;
          
          &::before {
            content: '';
            display: inline-block;
            width: 4px;
            height: 16px;
            background-color: #67C23A;
            margin-right: 8px;
            border-radius: 2px;
          }
        }
        
        .related-group {
          margin-bottom: 15px;
          // 移除背景和边框，使用分隔线
          background-color: transparent;
          border-radius: 0;
          padding: 0 0 10px 0;
          border-bottom: 1px dashed #e4e7ed;
          
          &:last-child {
            border-bottom: none;
            margin-bottom: 0;
          }
          
          .pos {
            font-weight: 600;
            color: #67C23A;
            margin-right: 10px;
            background-color: #f0f9eb;
            padding: 2px 8px;
            border-radius: 4px;
            font-size: 13px;
            display: inline-block;
            margin-bottom: 8px;
          }
          
          .related-items {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
            gap: 8px;
            
            .related-item {
              display: flex;
              align-items: center;
              padding: 8px 12px;
              background-color: #f5f7fa;
              border-radius: 6px;
              border-left: 3px solid #67C23A;
              transition: all 0.3s ease;
              
              &:hover {
                transform: translateY(-2px);
                background-color: #f0f9eb;
              }
              
              .word {
                font-weight: 600;
                color: #303133;
                margin-right: 10px;
                font-size: 14px;
              }
              
              .meaning {
                color: #606266;
                font-size: 13px;
                flex: 1;
              }
            }
          }
        }
      }
    }
    
    .word-actions {
      display: flex;
      justify-content: flex-end;
      gap: 10px;
      padding-top: 10px;
      border-top: 1px solid #ebeef5;
      
      .el-button {
        transition: all 0.3s ease;
        
        &:hover {
          transform: translateY(-2px);
        }
      }
    }
  }
}

// 每日一句卡片
.quote-card {
  margin-top: 20px;

  .card-header {
    display: flex;
    justify-content: space-between;
    align-items: center;

    .quote-date {
      font-size: 14px;
      color: #909399;
    }
  }

  .quote-content {
    display: flex;
    gap: 20px;
    margin-bottom: 15px;

    .quote-text {
      flex: 1;

      .quote-original {
        font-size: 16px;
        font-weight: 500;
        color: #303133;
        line-height: 1.6;
        margin-bottom: 10px;
        font-style: italic;
      }

      .quote-translation {
        font-size: 14px;
        color: #606266;
        line-height: 1.6;
        margin-bottom: 10px;
      }

      .quote-author {
        font-size: 14px;
        color: #909399;
        text-align: right;
      }
    }

    .quote-image {
      width: 120px;
      height: 120px;
      flex-shrink: 0;
      border-radius: 10px;
      overflow: hidden;

      img {
        width: 100%;
        height: 100%;
        object-fit: cover;
      }
    }
  }

  .quote-actions {
    display: flex;
    justify-content: flex-end;
    gap: 10px;

    .el-button {
      transition: all 0.3s ease;

      &:hover {
        transform: translateY(-2px);
      }
    }
  }
}

// 在小屏幕上调整每日一句的布局
@media (max-width: 768px) {
  .quote-card {
    .quote-content {
      flex-direction: column;

      .quote-image {
        width: 100%;
        height: auto;
        aspect-ratio: 16/9;
        margin-bottom: 10px;
      }
    }
  }

  .welcome-banner {
    .welcome-decoration {
      img {
        max-width: 100%;
      }
    }
  }

  .words-card {
    .word-detail {
      .word-header {
        .word-title {
          font-size: 24px;
        }
        
        .word-phonetic {
          flex-direction: column;
          gap: 8px;
        }
      }
      
      .word-extra {
        .related-words {
          .related-group {
            .related-items {
              grid-template-columns: 1fr;
            }
          }
        }
      }
    }
  }
}

// 学习统计卡片
.stats-card {
  :deep(.el-card__body) {
    max-height: 300px;
    overflow: auto;
  }

  .stats-grid {
    display: grid;
    grid-template-columns: repeat(4, 1fr);
    gap: 16px;

    .stat-item {
      display: flex;
      flex-direction: column;
      align-items: center;

      .stat-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        background-color: #f0f2f5;
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 8px;

        .el-icon {
          font-size: 20px;
          color: #409EFF;
        }
      }

      .stat-content {
        text-align: center;

        .stat-value {
          font-size: 18px;
          font-weight: 600;
          margin-bottom: 4px;
        }

        .stat-label {
          font-size: 14px;
          color: #909399;
        }
      }
    }
  }
}

// 学习提示卡片
.tip-card {
  :deep(.el-card__body) {
    max-height: 300px;
    overflow: auto;
  }

  .tip-content {
    display: flex;
    align-items: flex-start;
    padding: 12px;
    background-color: #f0f9eb;
    border-radius: 8px;

    .el-icon {
      font-size: 24px;
      color: #67C23A;
      margin-right: 15px;
      margin-top: 2px;
    }

    p {
      margin: 0;
      font-size: 14px;
      line-height: 1.6;
      color: #303133;
    }
  }
}

// 最近活动卡片
.activities-card {
  :deep(.el-card__body) {
    flex: 1;
    display: flex;
    flex-direction: column;
    overflow: auto;
    max-height: 250px;
  }

  .activities-list {
    flex: 1;
    display: flex;
    flex-direction: column;

    .activity-item {
      display: flex;
      padding: 10px 0;
      border-bottom: 1px solid #ebeef5;
      position: relative;
      &:last-child {
        border-bottom: none;
      }

      .activity-icon {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        background: linear-gradient(135deg, #f5f7fa, #e4e7ed);
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.05);
        transition: transform 0.3s ease;

        &:hover {
          transform: scale(1.1);
        }

        .el-icon {
          position: absolute;
          top: 28%;
          left: 1.2%;
          font-size: 18px;
          color: #409EFF;
        }
      }

      .activity-content {
        flex: 1;

        .activity-title {
          font-size: 13px;
          margin-bottom: 4px;
        }

        .activity-time {
          font-size: 12px;
          color: #909399;
        }
      }
    }
  }
}

// 推荐课程卡片
.courses-card {
  margin-top: 20px;
  width: 100%;

  :deep(.el-card__body) {
    display: flex;
    flex-direction: column;
    overflow: visible;
    max-height: none;
    padding: 15px;
  }

  .course-list {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 16px;

    .course-item {
      height: 210px;
      display: flex;
      flex-direction: column;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
      cursor: pointer;
      transition: transform 0.3s ease, box-shadow 0.3s ease;

      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.15);
      }

      .course-image {
        height: 100px;
        position: relative;
        overflow: hidden;

        &::after {
          content: '';
          position: absolute;
          bottom: 0;
          left: 0;
          right: 0;
          height: 30px;
          background: linear-gradient(to top, rgba(0, 0, 0, 0.5), transparent);
          z-index: 1;
        }

        img {
          width: 100%;
          height: 100%;
          object-fit: cover;
          transition: transform 0.3s ease;
        }

        &:hover img {
          transform: scale(1.05);
        }
      }

      .course-info {
        padding: 8px;
        flex: 1;
        display: flex;
        flex-direction: column;

        h3 {
          margin: 0 0 6px;
          font-size: 14px;
          font-weight: 600;
          white-space: nowrap;
          overflow: hidden;
          text-overflow: ellipsis;
          transition: color 0.3s ease;
        }

        &:hover h3 {
          color: #409EFF;
        }

        .course-description {
          font-size: 12px;
          color: #606266;
          margin-bottom: 6px;
          flex: 1;
          overflow: hidden;
          text-overflow: ellipsis;
          display: -webkit-box;
          -webkit-line-clamp: 2;
          -webkit-box-orient: vertical;
          position: relative;
        }
      }
    }
  }
}

// 响应式调整
@media (max-width: 1200px) {
  .courses-card .course-list {
    grid-template-columns: repeat(3, 1fr);
  }
}

@media (max-width: 992px) {
  .dashboard-main {
    flex-direction: column;
  }

  .courses-card .course-list {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 576px) {
  .courses-card .course-list {
    grid-template-columns: 1fr;
  }
}

// 全局滚动条样式
:deep(*::-webkit-scrollbar) {
  width: 6px;
  height: 6px;
}

:deep(*::-webkit-scrollbar-track) {
  background: rgba(0, 0, 0, 0.05);
  border-radius: 3px;
}

:deep(*::-webkit-scrollbar-thumb) {
  background: rgba(144, 147, 153, 0.3);
  border-radius: 3px;
  transition: all 0.2s ease;

  &:hover {
    background: rgba(144, 147, 153, 0.3);
  }
}

// 单词卡片滚动条特殊样式
.words-card {
  :deep(.el-card__body::-webkit-scrollbar-thumb) {
    &:hover {
      background: rgba(64, 158, 255, 0.3);
    }
  }
}

// 活动卡片滚动条特殊样式
.activities-card {
  :deep(.el-card__body::-webkit-scrollbar-thumb) {
    &:hover {
      background: rgba(103, 194, 58, 0.3);
    }
  }
}

.course-meta {
  display: flex;
  gap: 8px;
  margin-top: auto;

  .el-tag {
    border-radius: 12px;
    padding: 0 10px;
    height: 24px;
    line-height: 22px;
    font-weight: 500;
    display: flex;
    align-items: center;

    .el-icon {
      margin-right: 4px;
      font-size: 12px;
    }

    // 级别标签样式
    &:first-child {
      background-color: #ecf5ff;
      border-color: #d9ecff;
      color: #409EFF;
    }

    // 章节标签样式
    &:nth-child(2) {
      background-color: #f0f2f5;
      border-color: #e4e7ed;
      color: #606266;
    }

    // 时长标签样式
    &:nth-child(3) {
      background-color: #fdf6ec;
      border-color: #faecd8;
      color: #E6A23C;
    }
  }
}

// 卡片标题样式优化
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  h2 {
    margin: 0;
    font-size: 16px;
    font-weight: 600;
    display: flex;
    align-items: center;
    
    .el-icon {
      margin-right: 8px;
    }
  }
  
  .header-actions {
    display: flex;
    align-items: center;
    gap: 8px;
    
    .refresh-btn {
      color: #909399;
      transition: all 0.3s ease;
      
      &:hover {
        color: #409EFF;
        transform: rotate(180deg);
      }
      
      &:active {
        transform: rotate(360deg);
      }
    }
  }
}
</style>