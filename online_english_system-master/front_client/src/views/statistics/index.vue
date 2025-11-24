<template>
  <div class="statistics-container">
    <!-- 顶部卡片统计 -->
    <div class="stat-cards">
      <!-- 考试统计卡片 -->
      <el-card class="stat-card">
        <template #header>
          <div class="card-header">
            <span>考试成绩统计</span>
            <el-icon><Medal /></el-icon>
          </div>
        </template>
        <div class="card-content">
          <div class="stat-item">
            <span class="label">平均分</span>
            <span class="value">{{ scoreStats.avgScore || 0 }}分</span>
          </div>
          <div class="stat-item">
            <span class="label">最高分</span>
            <span class="value highlight">{{ scoreStats.maxScore || 0 }}分</span>
          </div>
          <div class="stat-item">
            <span class="label">通过率</span>
            <span class="value">{{ scoreStats.passRate || 0 }}%</span>
          </div>
          <div class="stat-item">
            <span class="label">考试次数</span>
            <span class="value">{{ scoreStats.examCount || 0 }}次</span>
          </div>
        </div>
      </el-card>

      <!-- 学习时长统计卡片 -->
      <el-card class="stat-card">
        <template #header>
          <div class="card-header">
            <span>学习时长统计</span>
            <el-icon><Timer /></el-icon>
          </div>
        </template>
        <div class="card-content">
          <div class="stat-item">
            <span class="label">今日学习</span>
            <span class="value">{{ formatDuration(timeStats.todayTime) }}</span>
          </div>
          <div class="stat-item">
            <span class="label">平均时长</span>
            <span class="value">{{ formatDuration(timeStats.avgTime) }}</span>
          </div>
          <div class="stat-item">
            <span class="label">最长时长</span>
            <span class="value highlight">{{ formatDuration(Number(timeStats.maxTime)) }}</span>
          </div>
          <div class="stat-item">
            <span class="label">累计时长</span>
            <span class="value">{{ formatDuration(timeStats.totalTime) }}</span>
          </div>
        </div>
      </el-card>

      <!-- 学习进度统计卡片 -->
      <el-card class="stat-card">
        <template #header>
          <div class="card-header">
            <span>学习进度统计</span>
            <el-icon><TrendCharts /></el-icon>
          </div>
        </template>
        <div class="card-content">
          <div class="stat-item">
            <span class="label">平均进度</span>
            <span class="value">{{ progressStats.avgProgress?.toFixed(1) || 0 }}%</span>
          </div>
          <div class="stat-item">
            <span class="label">完成率</span>
            <span class="value highlight">{{ progressStats.completionRate || 0 }}%</span>
          </div>
          <div class="stat-item">
            <span class="label">已完成</span>
            <span class="value">{{ progressStats.completedCount || 0 }}</span>
          </div>
          <div class="stat-item">
            <span class="label">总课程</span>
            <span class="value">{{ progressStats.totalCount || 0 }}</span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 图表区域 -->
    <div class="chart-area">
      <!-- 词汇学习频率图表 -->
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>词汇学习频率</span>
            <el-icon><Reading /></el-icon>
          </div>
        </template>
        <div ref="wordFreqChart" class="chart"></div>
      </el-card>

      <!-- 学习进度环形图 -->
      <el-card class="chart-card">
        <template #header>
          <div class="card-header">
            <span>学习完成情况</span>
            <el-icon><PieChart /></el-icon>
          </div>
        </template>
        <div ref="progressChart" class="chart"></div>
      </el-card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useUserStore } from '@/stores/modules/user'
import { 
  Medal, 
  Timer, 
  TrendCharts, 
  Reading,
  PieChart
} from '@element-plus/icons-vue'
import * as echarts from 'echarts'
import type { EChartsType } from 'echarts'
import type { ProgressStatistics, ScoreStatistics, StudyTimeStatistics, VocabularyFrequency } from '@/api/statistics/type'
import { getProgressStatistics, getScoreStatistics, getStudyTimeStatistics, getVocabularyFrequency } from '@/api/statistics/index'
// import { 
//   getScoreStatistics,
//   getStudyTimeStatistics,
//   getVocabularyFrequency,
//   getProgressStatistics,
//   type ScoreStatistics,
//   type StudyTimeStatistics,
//   type VocabularyFrequency,
//   type ProgressStatistics
// } from '@/api/statistics'

const userStore = useUserStore()

// 统计数据
const scoreStats = ref<ScoreStatistics>({} as ScoreStatistics)
const timeStats = ref<StudyTimeStatistics>({} as StudyTimeStatistics)
const progressStats = ref<ProgressStatistics>({} as ProgressStatistics)
const vocabularyFreq = ref<VocabularyFrequency[]>([])

// 图表实例
let wordFreqChartInstance: EChartsType | null = null
let progressChartInstance: EChartsType | null = null

// 格式化时长显示
const formatDuration = (minutes: number) => {
  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60
  if (hours > 0) {
    return `${hours}小时${mins > 0 ? ` ${mins}分钟` : ''}`
  }
  return `${mins}分钟`
}

// 初始化词汇频率图表
const initWordFreqChart = (data: VocabularyFrequency[]) => {
  const chartDom = document.querySelector('.chart-area .chart-card:first-child .chart')
  if (!chartDom) return

  wordFreqChartInstance = echarts.init(chartDom as HTMLElement)
  
  const option = {
    tooltip: {
      trigger: 'axis',
      axisPointer: {
        type: 'shadow'
      }
    },
    grid: {
      left: '3%',
      right: '4%',
      bottom: '3%',
      containLabel: true
    },
    xAxis: {
      type: 'category',
      data: data.map(item => item.word),
      axisLabel: {
        interval: 0,
        rotate: 30
      }
    },
    yAxis: {
      type: 'value',
      name: '学习次数'
    },
    series: [
      {
        name: '学习频率',
        type: 'bar',
        data: data.map(item => ({
          value: Number(item.frequency),
          itemStyle: {
            color: item.difficultyLevel === '初级' ? '#67c23a' : 
                   item.difficultyLevel === '中级' ? '#e6a23c' : '#f56c6c'
          }
        })),
        label: {
          show: true,
          position: 'top'
        }
      }
    ]
  }

  wordFreqChartInstance.setOption(option)
}

// 初始化进度环形图
const initProgressChart = (data: ProgressStatistics) => {
  const chartDom = document.querySelector('.chart-area .chart-card:last-child .chart')
  if (!chartDom) return

  progressChartInstance = echarts.init(chartDom as HTMLElement)
  
  const option = {
    tooltip: {
      trigger: 'item',
      formatter: '{b}: {c} ({d}%)'
    },
    legend: {
      orient: 'vertical',
      left: 'left'
    },
    series: [
      {
        name: '学习进度',
        type: 'pie',
        radius: ['50%', '70%'],
        avoidLabelOverlap: false,
        label: {
          show: true,
          position: 'center',
          formatter: `完成率\n${data.completionRate}%`,
          fontSize: 16
        },
        emphasis: {
          label: {
            show: true,
            fontSize: 20,
            fontWeight: 'bold'
          }
        },
        data: [
          { 
            value: Number(data.completedCount), 
            name: '已完成',
            itemStyle: { color: '#67c23a' }
          },
          { 
            value: Number(data.totalCount) - Number(data.completedCount), 
            name: '未完成',
            itemStyle: { color: '#909399' }
          }
        ]
      }
    ]
  }

  progressChartInstance.setOption(option)
}

// 获取统计数据
const fetchStatistics = async () => {
  try {
    const [scoreRes, timeRes, vocabRes, progressRes] = await Promise.all([
      getScoreStatistics(),
      getStudyTimeStatistics(),
      getVocabularyFrequency(userStore.userInfo?.id || ''),
      getProgressStatistics()
    ])

    if (scoreRes.code === 0 && scoreRes.data) {
      scoreStats.value = scoreRes.data
    }
    if (timeRes.code === 0 && timeRes.data) {
      timeStats.value = timeRes.data
    }
    if (vocabRes.code === 0 && vocabRes.data) {
      vocabularyFreq.value = vocabRes.data
      initWordFreqChart(vocabRes.data)
    }
    if (progressRes.code === 0 && progressRes.data) {
      progressStats.value = progressRes.data
      initProgressChart(progressRes.data)
    }
  } catch (error) {
    console.error('获取统计数据失败:', error)
  }
}

// 监听窗口大小变化
const handleResize = () => {
  wordFreqChartInstance?.resize()
  progressChartInstance?.resize()
}

onMounted(() => {
  fetchStatistics()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  wordFreqChartInstance?.dispose()
  progressChartInstance?.dispose()
})
</script>

<style lang="scss" scoped>
.statistics-container {
  padding: 24px;
  background: #fff;

  .stat-cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 24px;
    margin-bottom: 24px;

    .stat-card {
      .card-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 16px;
        font-weight: 600;
        color: #303133;

        .el-icon {
          font-size: 20px;
          color: #409EFF;
        }
      }

      .card-content {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;
        padding: 8px;

        .stat-item {
          display: flex;
          flex-direction: column;
          align-items: center;
          text-align: center;

          .label {
            color: #909399;
            font-size: 14px;
            margin-bottom: 8px;
          }

          .value {
            font-size: 20px;
            font-weight: 600;
            color: #303133;

            &.highlight {
              color: #409EFF;
            }
          }
        }
      }
    }
  }

  .chart-area {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
    gap: 24px;

    .chart-card {
      .card-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        font-size: 16px;
        font-weight: 600;
        color: #303133;

        .el-icon {
          font-size: 20px;
          color: #409EFF;
        }
      }

      .chart {
        height: 400px;
        width: 100%;
      }
    }
  }
}

// 响应式调整
@media (max-width: 768px) {
  .statistics-container {
    .chart-area {
      grid-template-columns: 1fr;
    }
  }
}
</style> 