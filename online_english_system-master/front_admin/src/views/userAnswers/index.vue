<template>
  <div class="user-answers-container">
    <!-- 头部搜索和操作 -->
    <el-card class="header-card" shadow="hover">
      <div class="header">
        <div class="title">
          <el-icon class="title-icon"><Document /></el-icon>
          用户作答管理
        </div>
        <div class="actions">
          <el-select v-model="examId" placeholder="选择试卷" clearable @change="handleExamChange">
            <template #prefix>
              <el-icon><Reading /></el-icon>
            </template>
            <el-option v-for="exam in examList" :key="exam.id" :label="exam.title" :value="exam.id" />
          </el-select>
          <el-select v-model="questionType" placeholder="题目类型" clearable>
            <template #prefix>
              <el-icon><List /></el-icon>
            </template>
            <el-option label="单选" value="单选" />
            <el-option label="多选" value="多选" />
            <el-option label="判断" value="判断" />
            <el-option label="填空" value="填空" />
            <el-option label="简答" value="简答" />
          </el-select>
          <el-select v-model="isCorrect" placeholder="答题状态" clearable>
            <template #prefix>
              <el-icon><Check /></el-icon>
            </template>
            <el-option label="正确" :value="1" />
            <el-option label="错误" :value="0" />
          </el-select>
          <el-button type="primary" @click="handleSearch">
            <el-icon><Search /></el-icon>
            查询
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 统计信息卡片 -->
    <div v-if="examId && summary" class="summary-cards">
      <el-card class="summary-card total-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <el-icon><DataAnalysis /></el-icon>
            <span>总体情况</span>
          </div>
        </template>
        <div class="card-content">
          <div class="stat-item">
            <span class="label">总题数:</span>
            <span class="value">{{ summary.totalQuestions }}</span>
          </div>
          <div class="stat-item">
            <span class="label">正确数:</span>
            <span class="value">{{ summary.correctCount }}</span>
          </div>
          <div class="stat-item">
            <span class="label">正确率:</span>
            <span class="value accuracy">
              <el-progress 
                :percentage="summary.accuracy" 
                :color="getAccuracyColor(summary.accuracy)"
                :stroke-width="10"
                :format="percentFormat"
              />
            </span>
          </div>
          <div class="stat-item">
            <span class="label">得分:</span>
            <span class="value score">{{ calculateUserScore(summary) }}</span>
          </div>
        </div>
      </el-card>

      <el-card v-for="stat in summary.typeStats" :key="stat.questionType" class="summary-card" shadow="hover">
        <template #header>
          <div class="card-header">
            <el-icon><component :is="getQuestionTypeIcon(stat.questionType)" /></el-icon>
            <span>{{ stat.questionType }}</span>
          </div>
        </template>
        <div class="card-content">
          <div class="stat-item">
            <span class="label">题目数:</span>
            <span class="value">{{ stat.count }}</span>
          </div>
          <div class="stat-item">
            <span class="label">正确数:</span>
            <span class="value">{{ stat.correctCount }}</span>
          </div>
          <div class="stat-item">
            <span class="label">正确率:</span>
            <span class="value accuracy">
              <el-progress 
                :percentage="stat.accuracy" 
                :color="getAccuracyColor(stat.accuracy)"
                :stroke-width="8"
                :format="percentFormat"
              />
            </span>
          </div>
          <div class="stat-item">
            <span class="label">得分:</span>
            <span class="value score">{{ parseFloat(calculateTypeScore(stat)).toFixed(2) }}</span>
          </div>
        </div>
      </el-card>
    </div>

    <!-- 作答列表 -->
    <el-card class="table-card" shadow="hover">
      <template #header>
        <div class="table-header">
          <span class="table-title">
            <el-icon><Opportunity /></el-icon>
            作答记录列表
          </span>
          <span v-if="filteredTotal > 0" class="record-count">
            共 {{ filteredTotal }} 条记录
          </span>
        </div>
      </template>
      
      <el-table 
        v-loading="loading" 
        :data="answerList" 
        style="width: 100%" 
        border 
        stripe
        highlight-current-row
        :header-cell-style="{
          background: '#f5f7fa',
          color: '#606266',
          fontWeight: '600',
          height: '50px'
        }"
        :row-style="{height: '60px'}"
      >
        <el-table-column type="index" label="序号" width="70" align="center">
          <template #default="scope">
            <div class="cell-content">
              <span class="index-badge">{{ (currentPage - 1) * pageSize + scope.$index + 1 }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="用户" width="140">
          <template #default="{ row }">
            <div class="cell-content user-info">
              <el-avatar :size="32" :src="getAvatarUrl(row.userVO?.userAvatar)" />
              <span class="user-name">{{ row.userVO?.userName }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="试卷" width="180" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="cell-content">
              <el-tooltip :content="row.examVO?.title" placement="top">
                <div class="exam-title-wrapper">
                  <el-icon><Reading /></el-icon>
                  <span class="exam-title">{{ row.examVO?.title }}</span>
                </div>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="题目类型" width="100" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <el-tag 
                :type="getQuestionTypeTag(row.questionVO?.questionType)" 
                effect="dark" 
                size="small"
                class="question-type-tag"
              >
                {{ row.questionVO?.questionType }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="题目内容" min-width="280" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="cell-content">
              <el-tooltip :content="row.questionVO?.questionText" placement="top" :show-after="500">
                <div class="question-text-wrapper">
                  <span class="question-text">{{ row.questionVO?.questionText }}</span>
                </div>
              </el-tooltip>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="用户答案" width="120" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="cell-content">
              <span class="answer-badge user-answer">{{ row.userAnswer }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="正确答案" width="120" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="cell-content">
              <span class="answer-badge correct-answer">{{ row.questionVO?.correctAnswer }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <el-tag 
                :type="row.isCorrect === 1 ? 'success' : 'danger'" 
                effect="plain"
                class="status-tag"
              >
                <el-icon class="status-icon">
                  <Check v-if="row.isCorrect === 1" />
                  <Close v-else />
                </el-icon>
                {{ row.isCorrect === 1 ? '正确' : '错误' }}
              </el-tag>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="得分" width="80" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <span class="score-badge">{{ row.score }}</span>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="提交时间" width="180">
          <template #default="{ row }">
            <div class="cell-content">
              <div class="time-wrapper">
                <el-icon><Timer /></el-icon>
                <span class="time">{{ row.createTime }}</span>
              </div>
            </div>
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="180" fixed="right" align="center">
          <template #default="{ row }">
            <div class="cell-content action-buttons">
              <el-button 
                type="primary" 
                size="small" 
                @click="handleViewDetail(row)"
                class="action-button"
              >
                <el-icon><View /></el-icon>
                详情
              </el-button>
              <el-button 
                type="danger" 
                size="small" 
                @click="handleDelete(row)"
                class="action-button"
              >
                <el-icon><Delete /></el-icon>
                删除
              </el-button>
            </div>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination 
          v-model:current-page="currentPage" 
          v-model:page-size="pageSize" 
          :page-sizes="[10, 20, 50]"
          :total="filteredTotal" 
          layout="total, sizes, prev, pager, next, jumper" 
          background 
        />
      </div>
    </el-card>

    <!-- 作答详情弹窗 -->
    <el-dialog
      v-model="detailVisible"
      title="作答详情"
      width="800px"
      destroy-on-close
      class="answer-detail-dialog"
    >
      <div v-loading="detailLoading" class="answer-detail">
        <!-- 用户信息 -->
        <div class="detail-section user-section">
          <h3>
            <el-icon><User /></el-icon>
            用户信息
          </h3>
          <div class="user-detail">
            <el-avatar :size="64" :src="getAvatarUrl(currentAnswer.userVO?.userAvatar)" />
            <div class="user-info">
              <div class="username">{{ currentAnswer.userVO?.userName }}</div>
              <div class="user-role">角色: {{ currentAnswer.userVO?.userRole }}</div>
            </div>
          </div>
        </div>
        
        <!-- 试卷信息 -->
        <div class="detail-section exam-section">
          <h3>
            <el-icon><Reading /></el-icon>
            试卷信息
          </h3>
          <div class="exam-info">
            <div class="exam-title">{{ currentAnswer.examVO?.title }}</div>
            <div class="exam-desc">{{ currentAnswer.examVO?.description }}</div>
            <div class="exam-time">
              <el-icon><Calendar /></el-icon>
              考试时间: {{ currentAnswer.examVO?.startTime }} ~ {{ currentAnswer.examVO?.endTime }}
            </div>
          </div>
        </div>
        
        <!-- 题目信息 -->
        <div class="detail-section question-section">
          <h3>
            <el-icon><QuestionFilled /></el-icon>
            题目信息
          </h3>
          <div class="question-info">
            <div class="question-type">
              <el-tag :type="getQuestionTypeTag(currentAnswer.questionVO?.questionType)" effect="dark">
                {{ currentAnswer.questionVO?.questionType }}
              </el-tag>
              <div class="difficulty">
                <el-icon><Warning /></el-icon>
                难度: {{ currentAnswer.questionVO?.difficultyLevel }}
              </div>
              <div class="score">
                <el-icon><Trophy /></el-icon>
                分值: {{ currentAnswer.questionVO?.score }}
              </div>
            </div>
            <div class="question-text">{{ currentAnswer.questionVO?.questionText }}</div>
            <div v-if="currentAnswer.questionVO?.options" class="question-options">
              <div v-for="(value, key) in parseOptions(currentAnswer.questionVO?.options)" :key="key" class="option">
                <span class="option-key">{{ key }}:</span>
                <span class="option-value">{{ value }}</span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- 作答信息 -->
        <div class="detail-section answer-section">
          <h3>
            <el-icon><Edit /></el-icon>
            作答信息
          </h3>
          <div class="answer-info">
            <div class="answer-result">
              <el-tag :type="currentAnswer.isCorrect === 1 ? 'success' : 'danger'" effect="plain" size="large">
                <el-icon>
                  <Check v-if="currentAnswer.isCorrect === 1" />
                  <Close v-else />
                </el-icon>
                {{ currentAnswer.isCorrect === 1 ? '回答正确' : '回答错误' }}
              </el-tag>
              <div class="user-score">
                <el-icon><Trophy /></el-icon>
                得分: {{ currentAnswer.score }}
              </div>
            </div>
            <div class="answer-content">
              <div class="user-answer">
                <span class="label">用户答案:</span>
                <span class="content">{{ currentAnswer.userAnswer }}</span>
              </div>
              <div class="correct-answer">
                <span class="label">正确答案:</span>
                <span class="content">{{ currentAnswer.questionVO?.correctAnswer }}</span>
              </div>
            </div>
            <div v-if="currentAnswer.userNote" class="user-note">
              <div class="label">
                <el-icon><ChatLineRound /></el-icon>
                用户笔记
              </div>
              <div class="note-content">{{ currentAnswer.userNote }}</div>
            </div>
            <div v-if="currentAnswer.questionVO?.explanation" class="explanation">
              <div class="label">
                <el-icon><InfoFilled /></el-icon>
                解析
              </div>
              <div class="explanation-content">{{ currentAnswer.questionVO?.explanation }}</div>
            </div>
            <div class="submit-time">
              <el-icon><Timer /></el-icon>
              提交时间: {{ currentAnswer.createTime }}
            </div>
          </div>
        </div>
      </div>
      <template #footer>
        <div class="dialog-footer">
          <el-button @click="detailVisible = false">关闭</el-button>
        </div>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Search, Document, Reading, List, Check, Close, View, 
  User, DataAnalysis, QuestionFilled, Calendar, Trophy,
  ChatLineRound, Edit, Warning, InfoFilled, Timer,
  Opportunity, CircleCheck, Finished, EditPen, Delete
} from '@element-plus/icons-vue'
import { getUserAnswerList, getUserAnswerDetail, getExamAnswerSummary, deleteUserAnswer } from '@/api/userAnswer'
import { getExamList } from '@/api/exam'
import type { UserAnswer } from '@/api/userAnswer'
import defaultAvatar from '@/assets/avatar.jpg'

// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const examId = ref('')
const questionType = ref('')
const isCorrect = ref()
const rawAnswerList = ref<UserAnswer[]>([]) // 存储原始数据
const examList = ref([])
const summary = ref(null)

// 计算筛选后的数据
const filteredAnswerList = computed(() => {
  let result = [...rawAnswerList.value]
  
  // 根据题目类型筛选
  if (questionType.value) {
    result = result.filter(item => item.questionVO?.questionType === questionType.value)
  }
  
  return result
})

// 计算分页后的数据
const answerList = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = Math.min(start + pageSize.value, filteredAnswerList.value.length)
  return filteredAnswerList.value.slice(start, end)
})

// 计算总条数
const filteredTotal = computed(() => filteredAnswerList.value.length)

// 详情相关
const detailVisible = ref(false)
const detailLoading = ref(false)
const currentAnswer = ref<any>({})

// 获取试卷列表
const fetchExamList = async () => {
  try {
    const res = await getExamList({
      current: 1,
      pageSize: 100
    })
    examList.value = res.data.records || []
    
    // 如果有试卷，默认选择第一个
    if (examList.value.length > 0 && !examId.value) {
      examId.value = examList.value[0].id
      fetchAnswerList()
      fetchExamSummary()
    }
  } catch (error) {
    console.error('获取试卷列表失败:', error)
    ElMessage.error('获取试卷列表失败')
  }
}

// 获取作答列表
const fetchAnswerList = async () => {
  if (!examId.value) return
  
  loading.value = true
  try {
    const params = {
      current: 1,
      pageSize: 1000, // 获取足够多的数据用于前端筛选
      examId: examId.value
    } as any
    
    // 保留isCorrect参数的接口查询
    if (isCorrect.value !== undefined && isCorrect.value !== null) {
      params.isCorrect = isCorrect.value
    }
    
    const res = await getUserAnswerList(params)
    console.log('作答列表响应:', res)
    
    if (res.data) {
      rawAnswerList.value = res.data.records || []
      total.value = filteredTotal.value // 使用筛选后的总数
    } else {
      rawAnswerList.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('获取作答列表失败:', error)
    ElMessage.error('获取作答列表失败')
    rawAnswerList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 获取试卷作答统计
const fetchExamSummary = async () => {
  if (!examId.value) return
  
  try {
    const res = await getExamAnswerSummary(examId.value)
    console.log('试卷统计响应:', res)
    summary.value = res.data
  } catch (error) {
    console.error('获取试卷统计失败:', error)
    ElMessage.error('获取试卷统计失败')
    summary.value = null
  }
}

// 查看作答详情
const handleViewDetail = async (row: UserAnswer) => {
  detailVisible.value = true
  detailLoading.value = true
  currentAnswer.value = { ...row }
  
  try {
    const res = await getUserAnswerDetail(row.id)
    if (res.data) {
      currentAnswer.value = res.data
    }
  } catch (error) {
    console.error('获取作答详情失败:', error)
    ElMessage.error('获取作答详情失败')
  } finally {
    detailLoading.value = false
  }
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  
  // 如果isCorrect变化了，需要重新请求接口
  if (isCorrect.value !== undefined && isCorrect.value !== null) {
    fetchAnswerList()
  }
  // 如果只是questionType变化，不需要重新请求
}

// 试卷变更
const handleExamChange = () => {
  currentPage.value = 1
  questionType.value = '' // 重置题型筛选
  if (examId.value) {
    fetchAnswerList()
    fetchExamSummary()
  } else {
    rawAnswerList.value = []
    summary.value = null
  }
}

// 获取头像URL
const getAvatarUrl = (avatar: string) => {
  if (!avatar) return defaultAvatar
  if (avatar.startsWith('http')) return avatar
  return import.meta.env.VITE_BASE_URL + avatar
}

// 解析选项
const parseOptions = (optionsStr: string) => {
  try {
    return JSON.parse(optionsStr)
  } catch (e) {
    console.error('解析选项失败:', e, optionsStr)
    return {}
  }
}

// 获取题目类型标签样式
const getQuestionTypeTag = (type: string) => {
  const typeMap: Record<string, string> = {
    '单选': 'primary',
    '多选': 'success',
    '判断': 'info',
    '填空': 'warning',
    '简答': 'danger'
  }
  return typeMap[type] || 'info'
}

// 获取正确率颜色
const getAccuracyColor = (accuracy: number) => {
  if (accuracy >= 80) return '#67c23a'
  if (accuracy >= 60) return '#409eff'
  if (accuracy >= 40) return '#e6a23c'
  return '#f56c6c'
}

// 百分比格式化
const percentFormat = (percentage: number) => {
  return percentage.toFixed(2) + '%'
}

// 监听筛选条件变化
watch([questionType], () => {
  currentPage.value = 1 // 重置页码
})

// 监听isCorrect变化，需要重新请求接口
watch([isCorrect], () => {
  currentPage.value = 1
  fetchAnswerList()
})

// 获取题目类型对应的图标
const getQuestionTypeIcon = (type: string) => {
  switch (type) {
    case '单选':
      return CircleCheck
    case '多选':
      return Check
    case '判断':
      return Finished
    case '填空':
      return EditPen
    case '简答':
      return ChatLineRound
    default:
      return QuestionFilled
  }
}

// 计算用户在某题型的得分
const calculateTypeScore = (stat: any) => {
  // 用户得分 = 正确题数 * 每题分数
  // 如果有单题分数不同的情况，这里需要调整
  return stat.correctCount * (stat.totalScore / stat.count)
}

// 计算用户总得分
const calculateUserScore = (summary: any) => {
  // 用户总得分 = 各题型得分之和
  let totalUserScore = 0
  if (summary.typeStats) {
    summary.typeStats.forEach((stat: any) => {
      totalUserScore += calculateTypeScore(stat)
    })
  }
  return Math.round(totalUserScore)
}

// 删除作答记录
const handleDelete = async (row: UserAnswer) => {
  try {
    await ElMessageBox.confirm(
      '确定要删除这条作答记录吗？',
      '警告',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }
    )
    
    await deleteUserAnswer(row.id)
    ElMessage.success('删除成功')
    fetchAnswerList() // 刷新列表
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除作答记录失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 初始化
onMounted(() => {
  fetchExamList()
})
</script>

<style lang="scss" scoped>
.user-answers-container {
  padding: 20px;
  
  .header-card {
    margin-bottom: 24px;
    
    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .title {
        font-size: 20px;
        font-weight: 600;
        color: #303133;
        display: flex;
        align-items: center;
        gap: 10px;
        
        .title-icon {
          font-size: 22px;
          color: #409eff;
        }
      }
      
      .actions {
        display: flex;
        gap: 16px;
        
        .el-select {
          width: 180px;
        }
      }
    }
  }
  
  .summary-cards {
    display: grid;
    grid-template-columns: repeat(5, 1fr); // 一行显示5个卡片
    gap: 16px;
    margin-bottom: 24px;
    
    @media (max-width: 1600px) {
      grid-template-columns: repeat(4, 1fr); // 在较小屏幕上显示4个
    }
    
    @media (max-width: 1280px) {
      grid-template-columns: repeat(3, 1fr); // 在更小屏幕上显示3个
    }
    
    @media (max-width: 992px) {
      grid-template-columns: repeat(2, 1fr); // 在平板上显示2个
    }
    
    @media (max-width: 768px) {
      grid-template-columns: 1fr; // 在手机上显示1个
    }
    
    .summary-card {
      transition: all 0.3s;
      height: 100%;
      
      &:hover {
        transform: translateY(-5px);
        box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
      }
      
      &.total-card {
        background-color: #f0f9ff;
      }
      
      .card-header {
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 16px;
        font-weight: 600;
        
        .el-icon {
          color: #409eff;
        }
      }
      
      .card-content {
        padding: 10px 0;
        
        .stat-item {
          display: flex;
          align-items: center;
          margin-bottom: 16px;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          .label {
            width: 70px;
            font-weight: 500;
            color: #606266;
          }
          
          .value {
            flex: 1;
            
            &.accuracy {
              width: 100%;
            }
            
            &.score {
              font-weight: 600;
              color: #f56c6c;
            }
          }
        }
      }
    }
  }
  
  .table-card {
    margin-bottom: 24px;
    
    .table-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      
      .table-title {
        font-size: 16px;
        font-weight: 600;
        color: #303133;
        display: flex;
        align-items: center;
        gap: 8px;
        
        .el-icon {
          color: #409eff;
        }
      }
      
      .record-count {
        font-size: 14px;
        color: #909399;
        background-color: #f5f7fa;
        padding: 4px 10px;
        border-radius: 12px;
      }
    }
    
    .cell-content {
      display: flex;
      align-items: center;
      justify-content: center;
      height: 100%;
      
      &.user-info {
        justify-content: flex-start;
        gap: 10px;
        
        .user-name {
          font-weight: 500;
          color: #303133;
        }
      }
      
      .index-badge {
        background-color: #f0f2f5;
        color: #606266;
        font-weight: 500;
        padding: 2px 8px;
        border-radius: 12px;
        font-size: 13px;
      }
      
      .exam-title-wrapper {
        display: flex;
        align-items: center;
        gap: 6px;
        
        .el-icon {
          color: #409eff;
        }
        
        .exam-title {
          color: #303133;
          font-weight: 500;
        }
      }
      
      .question-type-tag {
        padding: 4px 8px;
        font-size: 12px;
      }
      
      .question-text-wrapper {
        text-align: left;
        
        .question-text {
          color: #606266;
          line-height: 1.5;
        }
      }
      
      .answer-badge {
        padding: 4px 8px;
        border-radius: 4px;
        font-family: monospace;
        font-size: 13px;
        
        &.user-answer {
          background-color: #f0f9ff;
          color: #409eff;
          border: 1px solid #d9ecff;
        }
        
        &.correct-answer {
          background-color: #f0f9eb;
          color: #67c23a;
          border: 1px solid #e1f3d8;
        }
      }
      
      .status-tag {
        padding: 4px 8px;
        
        .status-icon {
          margin-right: 4px;
        }
      }
      
      .score-badge {
        background-color: #fff0f6;
        color: #f56c6c;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 14px;
      }
      
      .time-wrapper {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #909399;
        font-size: 13px;
        
        .el-icon {
          font-size: 14px;
        }
      }
      
      .action-buttons {
        display: flex;
        justify-content: center;
        gap: 8px;
      }
      
      .action-button {
        padding: 6px 12px;
        
        .el-icon {
          margin-right: 4px;
        }
      }
    }
    
    .pagination {
      margin-top: 20px;
      display: flex;
      justify-content: center;
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
    
    .el-table__row {
      transition: all 0.2s;
      
      &:hover {
        background-color: #f0f9ff !important;
      }
    }
  }
}

.answer-detail-dialog {
  :deep(.el-dialog__header) {
    padding: 20px;
    margin-right: 0;
    background-color: #f5f7fa;
    border-bottom: 1px solid #ebeef5;
    
    .el-dialog__title {
      font-size: 18px;
      font-weight: 600;
      color: #303133;
    }
  }
  
  :deep(.el-dialog__body) {
    padding: 24px;
  }
  
  :deep(.el-dialog__footer) {
    padding: 16px 20px;
    border-top: 1px solid #ebeef5;
    background-color: #f5f7fa;
  }
}

.answer-detail {
  .detail-section {
    margin-bottom: 24px;
    background-color: #fff;
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
    
    &.user-section {
      background-color: #f0f9ff;
    }
    
    &.exam-section {
      background-color: #f0f7fa;
    }
    
    &.question-section {
      background-color: #f9f6f2;
    }
    
    &.answer-section {
      background-color: #f9f0f2;
    }
    
    h3 {
      font-size: 18px;
      margin-bottom: 16px;
      padding-bottom: 10px;
      border-bottom: 1px solid #ebeef5;
      display: flex;
      align-items: center;
      gap: 8px;
      
      .el-icon {
        font-size: 20px;
        color: #409eff;
      }
    }
    
    .user-detail {
      display: flex;
      align-items: center;
      gap: 20px;
      
      .user-info {
        .username {
          font-size: 18px;
          font-weight: 500;
          margin-bottom: 8px;
        }
      }
    }
    
    .exam-info {
      .exam-title {
        font-size: 18px;
        font-weight: 500;
        margin-bottom: 12px;
        color: #409eff;
      }
      
      .exam-desc {
        color: #606266;
        margin-bottom: 12px;
        line-height: 1.6;
      }
      
      .exam-time {
        color: #909399;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
      }
    }
    
    .question-info {
      .question-type {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 16px;
        
        .difficulty, .score {
          color: #606266;
          font-size: 14px;
          display: flex;
          align-items: center;
          gap: 4px;
        }
      }
      
      .question-text {
        font-size: 16px;
        margin-bottom: 20px;
        line-height: 1.6;
        color: #303133;
        font-weight: 500;
      }
      
      .question-options {
        margin-left: 20px;
        background-color: #f5f7fa;
        padding: 12px 16px;
        border-radius: 6px;
        
        .option {
          margin-bottom: 10px;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          .option-key {
            font-weight: 500;
            margin-right: 10px;
            color: #409eff;
          }
          
          .option-value {
            color: #606266;
          }
        }
      }
    }
    
    .answer-info {
      .answer-result {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 20px;
        
        .user-score {
          font-size: 16px;
          font-weight: 500;
          display: flex;
          align-items: center;
          gap: 6px;
          color: #f56c6c;
        }
      }
      
      .answer-content {
        margin-bottom: 20px;
        background-color: #f5f7fa;
        padding: 16px;
        border-radius: 6px;
        
        .user-answer, .correct-answer {
          margin-bottom: 12px;
          
          &:last-child {
            margin-bottom: 0;
          }
          
          .label {
            font-weight: 500;
            margin-right: 10px;
            color: #409eff;
          }
          
          .content {
            font-family: monospace;
            background-color: #fff;
            padding: 4px 8px;
            border-radius: 4px;
          }
        }
      }
      
      .user-note, .explanation {
        margin-bottom: 20px;
        
        .label {
          font-weight: 500;
          display: flex;
          align-items: center;
          gap: 6px;
          margin-bottom: 10px;
          color: #409eff;
        }
        
        .note-content, .explanation-content {
          background-color: #f5f7fa;
          padding: 16px;
          border-radius: 6px;
          line-height: 1.6;
          color: #606266;
        }
      }
      
      .submit-time {
        color: #909399;
        font-size: 14px;
        display: flex;
        align-items: center;
        gap: 6px;
      }
    }
  }
}
</style> 