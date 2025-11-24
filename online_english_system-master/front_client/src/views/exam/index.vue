<template>
  <div class="exam-container">
    <!-- 试卷列表 -->
    <div class="exam-list" v-if="currentMode === 'list'">
      <div class="header">
        <h2>试卷列表</h2>
      </div>
      
      <!-- 替换表格为卡片列表 -->
      <div class="exam-grid" v-loading="loading">
        <el-card 
          v-for="exam in examList" 
          :key="exam.id" 
          class="exam-card"
          :body-style="{ padding: '0px' }"
        >
          <div class="exam-card-header">
            <h3 class="title">{{ exam.title }}</h3>
            <el-tag 
              size="small" 
              :type="getExamStatus(exam).type"
            >
              {{ getExamStatus(exam).text }}
            </el-tag>
          </div>
          
          <div class="exam-card-content">
            <p class="description">{{ exam.description }}</p>
            <div class="info-item">
              <el-icon><Timer /></el-icon>
              <span>考试时间：{{ formatDateTime(exam.startTime) }} ~ {{ formatDateTime(exam.endTime) }}</span>
            </div>
            <div class="info-item">
              <el-icon><Document /></el-icon>
              <span>总分：{{ exam.totalScore }}分</span>
            </div>
            <div class="info-item">
              <el-icon><Collection /></el-icon>
              <span>题目数量：{{ exam.questionList?.length || 0 }}题</span>
            </div>
            <div class="info-item answer-history" @click="showAnswerHistory(exam)">
              <el-icon><List /></el-icon>
              <span>作答记录</span>
              <span v-if="examAnswerTimes[exam.id]" class="answer-time">
                最近作答：{{ formatDateTime(examAnswerTimes[exam.id]) }}
              </span>
            </div>
          </div>
          
          <div class="exam-card-footer">
            <div class="mode-switch">
              <el-radio-group v-model="examModes[exam.id]" size="small">
                <el-radio-button value="practice">练习模式</el-radio-button>
                <el-radio-button value="exam">考试模式</el-radio-button>
              </el-radio-group>
            </div>
            <el-button 
              type="primary" 
              @click="startExam(exam)"
              :disabled="isExamEnded(exam) || !hasQuestions(exam)"
              :title="getButtonTitle(exam)"
            >
              {{ getExamButtonText(exam) }}
              <el-icon class="el-icon--right"><ArrowRight /></el-icon>
            </el-button>
          </div>
        </el-card>
      </div>

      <!-- 分页 -->
      <div class="pagination">
        <el-pagination
          v-model:current-page="current"
          v-model:page-size="pageSize"
          :page-sizes="[12, 24, 36, 48]"
          layout="total, sizes, prev, pager, next"
          :total="total"
          @size-change="handleSizeChange"
          @current-change="handleCurrentChange"
        />
      </div>
    </div>

    <!-- 答题界面 -->
    <div class="exam-content" v-else>
      <div class="exam-header">
        <div class="exam-title">
          <h3>{{ currentExam?.title }}</h3>
          <p class="exam-desc">{{ currentExam?.description }}</p>
        </div>
        <div class="exam-info">
          <div v-if="currentMode === 'exam' && examMode === 'exam'" class="countdown">
            <el-icon><Timer /></el-icon>
            <span>剩余时间：{{ formatCountdown }}</span>
          </div>
          <div class="info-item">
            <el-icon><Document /></el-icon>
            <span>总分：{{ currentExam?.totalScore }}分</span>
          </div>
          <div class="info-item">
            <el-icon><Collection /></el-icon>
            <span>题目：{{ questionList.length }}题</span>
          </div>
          <div class="button-group">
            <!-- 练习模式显示提交方式切换 -->
            <el-radio-group 
              v-if="examMode === 'practice'"
              v-model="submitMode" 
              size="small"
            >
              <el-radio-button value="single">逐题提交</el-radio-button>
              <el-radio-button value="batch">批量提交</el-radio-button>
            </el-radio-group>
            <el-button v-if="examMode === 'practice'" @click="exitExam">
              <el-icon><Back /></el-icon>
              退出练习
            </el-button>
            <!-- 练习模式-逐题提交时显示提交按钮 -->
            <el-button 
              v-if="examMode === 'practice' && submitMode === 'single'"
              type="primary"
              @click="submitCurrentAnswer"
              :disabled="!hasCurrentAnswer"
            >
              提交当前答案
            </el-button>
            <!-- 练习模式-批量提交或考试模式显示提交试卷按钮 -->
            <el-button 
              v-else
              type="primary" 
              @click="submitExam"
            >
              {{ examMode === 'practice' ? '批量提交答案' : '提交试卷' }}
            </el-button>
          </div>
        </div>
      </div>

      <!-- 题目区域 -->
      <div class="question-area">
        <!-- 答案详情弹窗 -->
        <el-dialog
          v-model="showAnswerDetail"
          title="答题详情"
          width="600px"
          :close-on-click-modal="false"
        >
          <div class="answer-detail" v-if="answerDetails.length">
            <!-- 循环展示所有题目的答题详情 -->
            <div v-for="detail in answerDetails" :key="detail.id" class="question-detail">
              <div class="question-info">
                <h4>{{ detail.questionVO.questionText }}</h4>
                <div class="meta-info">
                  <span class="type">{{ detail.questionVO.questionType }}</span>
                  <span class="score">{{ detail.questionVO.score }}分</span>
                  <span class="difficulty">{{ detail.questionVO.difficultyLevel }}</span>
                </div>
              </div>
              
              <div class="options-compare">
                <div class="option-group">
                  <div class="label">正确答案：</div>
                  <div class="content correct">
                    {{ detail.questionVO.correctAnswer }}
                  </div>
                </div>
                <div class="option-group">
                  <div class="label">你的答案：</div>
                  <div class="content" :class="{ correct: detail.isCorrect === 1, wrong: detail.isCorrect === 0 }">
                    {{ detail.userAnswer }}
                  </div>
                </div>
              </div>
              
              <div class="explanation">
                <div class="label">解析：</div>
                <div class="content">{{ detail.questionVO.explanation }}</div>
              </div>
              <div class="divider" v-if="detail !== answerDetails[answerDetails.length - 1]"></div>
            </div>
          </div>
        </el-dialog>

        <!-- 第一题 -->
        <div class="question-card" v-if="questionList[currentIndex]">
          <div class="question-header">
            <span class="type-tag" :class="questionList[currentIndex].questionType">
              {{ questionList[currentIndex].questionType }}
            </span>
            <el-button 
              v-if="examMode === 'practice' && isQuestionSubmitted(questionList[currentIndex].id)"
              type="primary" 
              link
              @click="showExplanation(questionList[currentIndex])"
            >
              <el-icon><InfoFilled /></el-icon>
              查看题解
            </el-button>
          </div>
          
          <div class="question-content">
            <div class="question-text">
              {{ currentIndex + 1 }}. {{ questionList[currentIndex].questionText }}（{{ questionList[currentIndex].score }}分）
            </div>
            
            <div class="options">
              <template v-if="questionList[currentIndex]">
                <el-radio-group 
                  v-if="questionList[currentIndex].questionType === '单选'"
                  v-model="answers[questionList[currentIndex].id]"
                  class="option-group"
                >
                  <el-radio 
                    v-for="(text, key) in JSON.parse(questionList[currentIndex].options)"
                    :key="key"
                    :value="key"
                    class="option-item"
                  >
                    <span class="option-key">{{ key }}</span>
                    <span class="option-text">{{ text }}</span>
                  </el-radio>
                </el-radio-group>

                <el-checkbox-group 
                  v-else-if="questionList[currentIndex].questionType === '多选'"
                  v-model="answers[questionList[currentIndex].id]"
                  class="option-group"
                >
                  <el-checkbox 
                    v-for="(text, key) in JSON.parse(questionList[currentIndex].options)"
                    :key="key"
                    :value="key"
                    class="option-item"
                  >
                    <span class="option-key">{{ key }}</span>
                    <span class="option-text">{{ text }}</span>
                  </el-checkbox>
                </el-checkbox-group>
              </template>
            </div>
          </div>
        </div>

        <!-- 第二题 -->
        <div class="question-card" v-if="questionList[currentIndex + 1]">
          <div class="question-header">
            <span class="type-tag" :class="questionList[currentIndex + 1].questionType">
              {{ questionList[currentIndex + 1].questionType }}
            </span>
            <el-button 
              v-if="examMode === 'practice' && isQuestionSubmitted(questionList[currentIndex + 1].id)"
              type="primary" 
              link
              @click="showExplanation(questionList[currentIndex + 1])"
            >
              <el-icon><InfoFilled /></el-icon>
              查看题解
            </el-button>
          </div>
          
          <div class="question-content">
            <div class="question-text">
              {{ currentIndex + 2 }}. {{ questionList[currentIndex + 1].questionText }}（{{ questionList[currentIndex + 1].score }}分）
            </div>
            
            <div class="options">
              <template v-if="questionList[currentIndex + 1]">
                <el-radio-group 
                  v-if="questionList[currentIndex + 1].questionType === '单选'"
                  v-model="answers[questionList[currentIndex + 1].id]"
                  class="option-group"
                >
                  <el-radio 
                    v-for="(text, key) in JSON.parse(questionList[currentIndex + 1].options)"
                    :key="key"
                    :value="key"
                    class="option-item"
                  >
                    <span class="option-key">{{ key }}</span>
                    <span class="option-text">{{ text }}</span>
                  </el-radio>
                </el-radio-group>

                <el-checkbox-group 
                  v-else-if="questionList[currentIndex + 1].questionType === '多选'"
                  v-model="answers[questionList[currentIndex + 1].id]"
                  class="option-group"
                >
                  <el-checkbox 
                    v-for="(text, key) in JSON.parse(questionList[currentIndex + 1].options)"
                    :key="key"
                    :value="key"
                    class="option-item"
                  >
                    <span class="option-key">{{ key }}</span>
                    <span class="option-text">{{ text }}</span>
                  </el-checkbox>
                </el-checkbox-group>
              </template>
            </div>
          </div>
        </div>

        <!-- 题目导航 -->
        <div class="question-nav">
          <div class="progress-info">
            <span>当前进度：{{ currentIndex + 1 }}-{{ Math.min(currentIndex + 2, questionList.length) }}/{{ questionList.length }}</span>
          </div>
          <el-button-group>
            <el-button 
              :disabled="currentIndex === 0"
              @click="currentIndex = Math.max(0, currentIndex - 2)"
              class="nav-button"
            >
              <el-icon class="el-icon--left"><ArrowLeft /></el-icon>
              上一页
            </el-button>
            <el-button 
              :disabled="currentIndex >= questionList.length - 2"
              @click="currentIndex = Math.min(questionList.length - 2, currentIndex + 2)"
              class="nav-button"
            >
              下一页
              <el-icon class="el-icon--right"><ArrowRight /></el-icon>
            </el-button>
          </el-button-group>
        </div>
      </div>

      <!-- 题解弹窗 -->
      <el-dialog
        v-model="showExplanationDialog"
        title="题目解析"
        width="600px"
      >
        <div class="explanation-dialog" v-if="currentExplanation">
          <div class="question-text">{{ currentExplanation.questionText }}</div>
          <div class="answer">
            <div class="label">正确答案：</div>
            <div class="content">{{ currentExplanation.correctAnswer }}</div>
          </div>
          <div class="explanation">
            <div class="label">题目解析：</div>
            <div class="content">{{ currentExplanation.explanation }}</div>
          </div>
        </div>
      </el-dialog>

      <!-- 提交成功弹窗 -->
      <el-dialog
        v-model="showSubmitSuccess"
        title="提交成功"
        width="400px"
        :show-close="false"
        :close-on-click-modal="false"
        :close-on-press-escape="false"
      >
        <div class="submit-success">
          <el-icon class="success-icon" size="64"><CircleCheckFilled /></el-icon>
          <h3>提交成功</h3>
          <p>正在火速批改试卷，尽快出分...</p>
          <div class="countdown-tip">
            <span>{{ submitRedirectTime }}秒后自动返回试卷列表</span>
          </div>
        </div>
      </el-dialog>
    </div>

    <!-- 作答记录弹窗 -->
    <el-dialog
      v-model="showAnswerHistoryDialog"
      :title="`${currentExam?.title || ''} - 作答记录`"
      width="800px"
    >
      <div class="answer-history-dialog" v-loading="answerHistoryLoading">
        <div v-if="answerHistoryList.length" class="history-list">
          <div v-for="(answer, index) in answerHistoryList" :key="answer.id" class="history-item">
            <div class="question-info">
              <span class="question-index">{{ index + 1 }}.</span>
              <span class="question-text">{{ answer.questionVO.questionText }}</span>
              <span class="question-type" :class="answer.questionVO.questionType">
                {{ answer.questionVO.questionType }}
              </span>
            </div>
            <div class="answer-info">
              <div class="answer-detail">
                <div class="answer-row">
                  <span class="label">你的答案：</span>
                  <span class="value" :class="{ correct: answer.isCorrect === 1, wrong: answer.isCorrect === 0 }">
                    {{ answer.userAnswer }}
                  </span>
                </div>
                <div class="answer-row">
                  <span class="label">正确答案：</span>
                  <span class="value correct">{{ answer.questionVO.correctAnswer }}</span>
                </div>
                <div class="answer-row" v-if="answer.isCorrect === 0">
                  <span class="label">题目解析：</span>
                  <div class="value explanation">
                    {{ answer.questionVO.explanation }}
                  </div>
                </div>
              </div>
              <div class="answer-meta">
                <span class="time">{{ formatDateTime(answer.createTime) }}</span>
                <span class="score">得分：{{ answer.score }}/{{ answer.questionVO.score }}</span>
              </div>
            </div>
          </div>
        </div>
        <el-empty v-else description="暂无作答记录" />
        
        <!-- 分页 -->
        <div class="pagination" v-if="answerHistoryTotal > 0">
          <el-pagination
            v-model:current-page="answerHistoryCurrent"
            v-model:page-size="answerHistoryPageSize"
            :page-sizes="[5, 10, 20, 50]"
            :total="answerHistoryTotal"
            @size-change="handleAnswerHistorySizeChange"
            @current-change="handleAnswerHistoryCurrentChange"
            layout="total, sizes, prev, pager, next"
          />
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { 
  Timer, 
  Document, 
  Collection, 
  ArrowRight,
  ArrowLeft,
  Back,
  InfoFilled,
  CircleCheckFilled,
  List
} from '@element-plus/icons-vue'
import type { Exam, Question, UserAnswerVO } from '@/api/exam/type'
import { addUserAnswer, batchAddUserAnswers, getExamList, getExamQuestions, getUserAnswerDetail } from '@/api/exam/index'
// import { getExamList, getExamQuestions, addUserAnswer, batchAddUserAnswers, getExamAnswers, type Exam, type Question, getUserAnswerDetail, type UserAnswerVO } from '@/api/exam'

// 页面状态
const currentMode = ref<'list' | 'exam'>('list')
const loading = ref(false)
const current = ref(1)
const pageSize = ref(10)
const total = ref(0)
const examList = ref<Exam[]>([])

// 考试状态
const currentExam = ref<Exam | null>(null)
const questionList = ref<Question[]>([])
const currentIndex = ref(0)
const answers = reactive<Record<string, string | string[]>>({})

// 获取当前题目
const currentQuestion = computed(() => questionList.value[currentIndex.value])

// 获取试卷列表
const fetchExamList = async () => {
  loading.value = true
  try {
    const res = await getExamList({
      current: current.value,
      pageSize: pageSize.value
    })
    if (res.code === 0 && res.data) {
      examList.value = res.data.records
      total.value = parseInt(res.data.total)
    }
  } catch (error) {
    console.error('获取试卷列表失败:', error)
    ElMessage.error('获取试卷列表失败')
  } finally {
    loading.value = false
  }
}

// 检查试卷是否有题目
const hasQuestions = (exam: Exam) => {
  return exam.questionList?.length > 0
}

// 获取按钮提示文本
const getButtonTitle = (exam: Exam) => {
  if (!hasQuestions(exam)) {
    return '试卷暂无题目进行测验'
  }
  if (isExamEnded(exam)) {
    return '考试已结束'
  }
  return ''
}

// 开始考试
const startExam = async (exam: Exam) => {
  // 检查题目数量
  if (!hasQuestions(exam)) {
    ElMessage.warning('试卷暂无题目进行测验')
    return
  }

  try {
    const res = await getExamQuestions(exam.id)
    if (res.code === 0 && res.data) {
      currentExam.value = exam
      questionList.value = res.data
      currentMode.value = 'exam'
      currentIndex.value = 0
      examMode.value = examModes[exam.id] || 'practice'
      
      // 初始化答案
      questionList.value.forEach(q => {
        answers[q.id] = q.questionType === '单选' ? '' : []
      })

      // 如果是考试模式，启动倒计时
      if (examMode.value === 'exam') {
        const now = new Date().getTime()
        const endTime = new Date(exam.endTime).getTime()
        countdown.value = Math.floor((endTime - now) / 1000)
        
        timer = setInterval(() => {
          countdown.value--
          if (countdown.value <= 0) {
            clearInterval(timer!)
            // 时间到自动提交
            submitExam(true)
          }
        }, 1000)
      }
    }
  } catch (error) {
    console.error('获取试题失败:', error)
    ElMessage.error('获取试题失败')
  }
}

// 提交方式
const submitMode = ref<'single' | 'batch'>('single')

// 检查当前题目是否已答
const hasCurrentAnswer = computed(() => {
  const currentAnswers = [
    answers[questionList.value[currentIndex.value]?.id],
    answers[questionList.value[currentIndex.value + 1]?.id]
  ]
  return currentAnswers.some(answer => {
    if (Array.isArray(answer)) {
      return answer.length > 0
    }
    return !!answer
  })
})

// 答案详情相关
const showAnswerDetail = ref(false)
const answerDetails = ref<UserAnswerVO[]>([])

// 题解相关
const showExplanationDialog = ref(false)
const currentExplanation = ref<Question | null>(null)

// 显示题解
const showExplanation = (question: Question) => {
  currentExplanation.value = question
  showExplanationDialog.value = true
}

// 检查当前页面答案是否完整
const hasCompleteAnswers = computed(() => {
  const currentAnswers = [
    answers[questionList.value[currentIndex.value]?.id],
    answers[questionList.value[currentIndex.value + 1]?.id]
  ]
  
  // 检查当前页面的所有题目是否都已作答
  return currentAnswers.every((answer, index) => {
    // 如果该位置没有题目，则跳过检查
    if (!questionList.value[currentIndex.value + index]) {
      return true
    }
    if (Array.isArray(answer)) {
      return answer.length > 0
    }
    return !!answer
  })
})

// 记录已提交的题目ID
const submittedQuestions = ref<Set<string>>(new Set())

// 检查题目是否已提交
const isQuestionSubmitted = (questionId: string) => {
  return submittedQuestions.value.has(questionId)
}

// 修改提交当前答案函数
const submitCurrentAnswer = async () => {
  if (!hasCompleteAnswers.value) {
    ElMessage.warning('请完成当前页面所有题目后再提交')
    return
  }

  const currentQuestions = [
    questionList.value[currentIndex.value],
    questionList.value[currentIndex.value + 1]
  ].filter(Boolean)

  // 清空上一次的答题详情
  answerDetails.value = []

  try {
    for (const question of currentQuestions) {
      const answer = answers[question.id]
      if (answer) {
        const res = await addUserAnswer({
          examId: currentExam.value!.id,
          questionId: question.id,
          userAnswer: Array.isArray(answer) ? answer.join(',') : answer,
          userNote: ''
        })
        
        // 如果提交成功，记录题目ID并获取答案详情
        if (res.code === 0 && res.data) {
          submittedQuestions.value.add(question.id)
          const detailRes = await getUserAnswerDetail(res.data)
          if (detailRes.code === 0 && detailRes.data) {
            answerDetails.value.push(detailRes.data)
          }
        }
      }
    }
    // 所有题目详情获取完成后再显示弹窗
    if (answerDetails.value.length > 0) {
      showAnswerDetail.value = true
    }
    ElMessage.success('答案提交成功')
  } catch (error) {
    console.error('提交答案失败:', error)
    ElMessage.error('提交答案失败')
  }
}

// 批量提交成功相关
const showSubmitSuccess = ref(false)
const submitRedirectTime = ref(5)
let redirectTimer: NodeJS.Timer | null = null

// 修改提交试卷函数
const submitExam = (isTimeout = false) => {
  const doSubmit = async () => {
    try {
      const submitAnswers = Object.entries(answers).map(([questionId, answer]) => ({
        questionId,
        userAnswer: Array.isArray(answer) ? answer.join(',') : answer,
        userNote: ''
      })).filter(item => item.userAnswer)

      const res = await batchAddUserAnswers({
        examId: currentExam.value!.id,
        answers: submitAnswers
      })

      if (res.code === 0) {
        // 批量提交成功后，记录所有已提交的题目ID
        submitAnswers.forEach(answer => {
          submittedQuestions.value.add(answer.questionId)
        })
      }

      // 显示提交成功弹窗
      showSubmitSuccess.value = true
      submitRedirectTime.value = 5
      
      // 设置自动跳转倒计时
      redirectTimer = setInterval(() => {
        submitRedirectTime.value--
        if (submitRedirectTime.value <= 0) {
          clearInterval(redirectTimer as NodeJS.Timer)
          redirectTimer = null
          showSubmitSuccess.value = false
          currentMode.value = 'list'
        }
      }, 1000)
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('提交失败')
    }
  }

  if (isTimeout) {
    ElMessage.warning('考试时间已到，系统自动提交')
    doSubmit()
    return
  }

  ElMessageBox.confirm(
    '确认提交试卷吗？提交后将无法修改答案',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(doSubmit)
}

// 分页处理
const handleSizeChange = (val: number) => {
  pageSize.value = val
  current.value = 1
  fetchExamList()
}

const handleCurrentChange = (val: number) => {
  current.value = val
  fetchExamList()
}

// 格式化日期时间
const formatDateTime = (dateStr: string) => {
  const date = new Date(dateStr)
  return `${date.getMonth() + 1}月${date.getDate()}日 ${date.getHours()}:${String(date.getMinutes()).padStart(2, '0')}`
}

// 获取考试状态
const getExamStatus = (exam: Exam) => {
  const now = new Date().getTime()
  const startTime = new Date(exam.startTime).getTime()
  const endTime = new Date(exam.endTime).getTime()

  if (now > endTime) {
    return { type: 'info', text: '已结束' }
  } else if (now >= startTime) {
    return { type: 'success', text: '进行中' }
  } else {
    return { type: 'warning', text: '未开始' }
  }
}

// 检查考试是否已结束
const isExamEnded = (exam: Exam) => {
  const now = new Date().getTime()
  const endTime = new Date(exam.endTime).getTime()
  return now > endTime
}

// 修改按钮文本获取函数
const getExamButtonText = (exam: Exam) => {
  if (!hasQuestions(exam)) {
    return '暂无题目'
  }

  const now = new Date().getTime()
  const startTime = new Date(exam.startTime).getTime()
  const endTime = new Date(exam.endTime).getTime()

  if (now > endTime) {
    return '已结束'
  } else if (now >= startTime) {
    return '立即参加'
  } else {
    return '提前考试'
  }
}

const examModes = reactive<Record<string, 'practice' | 'exam'>>({})
const examMode = ref<'practice' | 'exam'>('practice')
const countdown = ref(0)
let timer: NodeJS.Timer | null = null

// 格式化倒计时
const formatCountdown = computed(() => {
  const hours = Math.floor(countdown.value / 3600)
  const minutes = Math.floor((countdown.value % 3600) / 60)
  const seconds = countdown.value % 60
  return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}:${String(seconds).padStart(2, '0')}`
})

// 退出考试
const exitExam = () => {
  ElMessageBox.confirm(
    '确认退出练习吗？已作答的内容将不会保存',
    '提示',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(() => {
    currentMode.value = 'list'
    currentExam.value = null
    questionList.value = []
    currentIndex.value = 0
    Object.keys(answers).forEach(key => delete answers[key])
    submittedQuestions.value.clear()  // 清理已提交题目记录
  })
}

// 作答记录相关
const showAnswerHistoryDialog = ref(false)
const answerHistoryLoading = ref(false)
const answerHistoryList = ref<UserAnswerVO[]>([])
const answerHistoryTotal = ref(0)
const answerHistoryCurrent = ref(1)
const answerHistoryPageSize = ref(5)
const examAnswerTimes = ref<Record<string, string>>({})

// 显示作答记录
const showAnswerHistory = async (exam: Exam) => {
  currentExam.value = exam
  showAnswerHistoryDialog.value = true
  answerHistoryCurrent.value = 1
  await fetchAnswerHistory()
}

// 获取作答记录
const fetchAnswerHistory = async () => {
  if (!currentExam.value) return
  
  answerHistoryLoading.value = true
  try {
    const res = await getExamAnswers(currentExam.value.id, {
      current: answerHistoryCurrent.value,
      pageSize: answerHistoryPageSize.value
    })
    
    if (res.code === 0 && res.data) {
      answerHistoryList.value = res.data.records
      answerHistoryTotal.value = parseInt(res.data.total)
      
      // 更新最近作答时间
      if (res.data.records.length > 0) {
        examAnswerTimes.value[currentExam.value.id] = res.data.records[0].createTime
      }
    }
  } catch (error) {
    console.error('获取作答记录失败:', error)
    ElMessage.error('获取作答记录失败')
  } finally {
    answerHistoryLoading.value = false
  }
}

// 处理作答记录分页
const handleAnswerHistorySizeChange = (size: number) => {
  answerHistoryPageSize.value = size
  answerHistoryCurrent.value = 1
  fetchAnswerHistory()
}

const handleAnswerHistoryCurrentChange = (current: number) => {
  answerHistoryCurrent.value = current
  fetchAnswerHistory()
}

onMounted(() => {
  fetchExamList()
})

onUnmounted(() => {
  if (timer) {
    clearInterval(timer)
    timer = null
  }
  if (redirectTimer) {
    clearInterval(redirectTimer)
    redirectTimer = null
  }
})
</script>

<style lang="scss" scoped>
.exam-container {
  padding: 24px;
  background: #fff;

  .exam-list {
    .header {
      margin-bottom: 24px;
      
      h2 {
        color: #303133;
        font-weight: 600;
      }
    }
    
    .exam-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));
      gap: 24px;
      margin-bottom: 24px;
      
      .exam-card {
        transition: all 0.3s ease;
        
        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
        }
        
        .exam-card-header {
          padding: 16px 20px;
          border-bottom: 1px solid #f0f2f5;
          display: flex;
          justify-content: space-between;
          align-items: center;
          
          .title {
            margin: 0;
            font-size: 16px;
            font-weight: 600;
            color: #303133;
            // 超出部分显示省略号
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            max-width: 240px;
          }
        }
        
        .exam-card-content {
          padding: 20px;
          
          .description {
            color: #606266;
            font-size: 14px;
            margin: 0 0 16px;
            // 最多显示两行
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            line-height: 1.5;
            height: 42px;
          }
          
          .info-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #909399;
            font-size: 14px;
            margin-bottom: 12px;
            
            &:last-child {
              margin-bottom: 0;
            }
            
            .el-icon {
              font-size: 16px;
              color: #409EFF;
            }
          }
        }
        
        .exam-card-footer {
          padding: 16px 20px;
          border-top: 1px solid #f0f2f5;
          display: flex;
          justify-content: flex-end;
          
          .mode-switch {
            margin-right: 16px;
          }
          
          .el-button {
            padding: 8px 20px;
            border-radius: 20px;
            
            .el-icon {
              transition: transform 0.3s ease;
            }
            
            &:hover:not(:disabled) .el-icon {
              transform: translateX(4px);
            }
          }
        }
      }
    }
    
    .pagination {
      display: flex;
      justify-content: center;
      margin-top: 32px;
    }
  }

  .exam-content {
    background: #fff;
    border-radius: 8px;
    padding: 24px;
    max-width: 900px;
    margin: 0 auto;

    .exam-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 1px solid #eee;

      .exam-title {
        h3 {
          margin: 0 0 8px;
          font-size: 20px;
          color: #303133;
        }
        
        .exam-desc {
          margin: 0;
          font-size: 14px;
          color: #909399;
        }
      }

      .exam-info {
        display: flex;
        align-items: center;
        gap: 24px;

        .countdown {
          display: flex;
          align-items: center;
          gap: 8px;
          color: #f56c6c;
          font-weight: 500;
          
          .el-icon {
            font-size: 16px;
          }
        }
        
        .info-item {
          display: flex;
          align-items: center;
          gap: 8px;
          color: #606266;
          
          .el-icon {
            font-size: 16px;
            color: #409EFF;
          }
        }
        
        .button-group {
          display: flex;
          gap: 12px;
          margin-left: auto;
        }
      }
    }

    .question-area {
      .answer-detail {
        .question-detail {
          position: relative;
          padding: 20px 0;
          
          .divider {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            height: 1px;
            background: #ebeef5;
            margin: 0 -20px;
          }
          
          &:first-child {
            padding-top: 0;
          }
          
          &:last-child {
            padding-bottom: 0;
          }
        }

        .question-info {
          margin-bottom: 20px;
          
          h4 {
            margin: 0 0 12px;
            font-size: 16px;
            color: #303133;
          }
          
          .meta-info {
            display: flex;
            gap: 16px;
            font-size: 14px;
            
            .type {
              color: #409EFF;
            }
            
            .score {
              color: #f56c6c;
            }
            
            .difficulty {
              color: #e6a23c;
            }
          }
        }
        
        .options-compare {
          margin-bottom: 20px;
          
          .option-group {
            display: flex;
            margin-bottom: 12px;
            
            .label {
              width: 80px;
              color: #909399;
            }
            
            .content {
              flex: 1;
              padding: 8px 16px;
              border-radius: 4px;
              
              &.correct {
                background: #f0f9eb;
                color: #67c23a;
              }
              
              &.wrong {
                background: #fef0f0;
                color: #f56c6c;
              }
            }
          }
        }
        
        .explanation {
          .label {
            color: #909399;
            margin-bottom: 8px;
          }
          
          .content {
            padding: 12px;
            background: #f8f9fa;
            border-radius: 4px;
            color: #606266;
            line-height: 1.6;
          }
        }
      }

      .question-card {
        background: #f8f9fa;
        border-radius: 8px;
        padding: 24px;
        margin-bottom: 24px;

        .question-header {
          display: flex;
          justify-content: space-between;
          margin-bottom: 16px;

          .type-tag {
            padding: 4px 12px;
            border-radius: 4px;
            font-size: 14px;
            
            &.单选 {
              background: #e1f3d8;
              color: #67c23a;
            }
            
            &.多选 {
              background: #fdf6ec;
              color: #e6a23c;
            }
          }
        }

        .question-content {
          .question-text {
            font-size: 16px;
            line-height: 1.6;
            margin-bottom: 24px;
            color: #303133;
            font-weight: 500;
          }

          .options {
            :deep(.option-group) {
              display: flex;
              flex-direction: column;
              gap: 16px;
              padding: 0 16px;

              .option-item {
                margin: 0;
                padding: 12px 16px;
                border-radius: 8px;
                transition: all 0.3s;
                width: 100%;
                height: auto;
                white-space: normal;
                display: flex;
                align-items: flex-start;
                
                &:hover {
                  background: #f0f2f5;
                }
                
                :deep(.el-radio__input),
                :deep(.el-checkbox__input) {
                  margin-top: 3px;
                }
                
                :deep(.el-radio__label),
                :deep(.el-checkbox__label) {
                  white-space: normal;
                  padding-left: 8px;
                  line-height: 1.5;
                }
                
                .option-key {
                  display: inline-block;
                  min-width: 24px;
                  color: #409EFF;
                  font-weight: 500;
                }
                
                .option-text {
                  margin-left: 8px;
                  color: #606266;
                  flex: 1;
                  text-align: left;
                }
              }
            }
          }
        }
      }

      .question-nav {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: 24px;
        padding: 0 24px;
        
        .progress-info {
          color: #909399;
          font-size: 14px;
        }
        
        .nav-button {
          min-width: 100px;
          
          .el-icon {
            font-size: 14px;
          }
        }
      }
    }
  }
}

// 响应式布局
@media (max-width: 1600px) {
  .exam-grid {
    grid-template-columns: repeat(3, 1fr) !important;
  }
}

@media (max-width: 1200px) {
  .exam-grid {
    grid-template-columns: repeat(2, 1fr) !important;
  }
}

@media (max-width: 768px) {
  .exam-grid {
    grid-template-columns: 1fr !important;
  }
}

.explanation-dialog {
  .question-text {
    font-size: 16px;
    color: #303133;
    margin-bottom: 20px;
    line-height: 1.6;
  }

  .answer,
  .explanation {
    margin-bottom: 16px;

    .label {
      color: #909399;
      margin-bottom: 8px;
    }

    .content {
      background: #f8f9fa;
      padding: 12px 16px;
      border-radius: 4px;
      color: #606266;
      line-height: 1.6;
    }
  }

  .answer .content {
    color: #67c23a;
    background: #f0f9eb;
  }
}

.submit-success {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px 0;
  
  .success-icon {
    color: #67c23a;
    margin-bottom: 16px;
  }
  
  h3 {
    font-size: 20px;
    color: #303133;
    margin: 0 0 12px;
  }
  
  p {
    font-size: 16px;
    color: #606266;
    margin: 0 0 24px;
  }
  
  .countdown-tip {
    font-size: 14px;
    color: #909399;
    background: #f5f7fa;
    padding: 8px 16px;
    border-radius: 20px;
  }
}

.answer-history {
  cursor: pointer;
  transition: all 0.3s ease;
  
  &:hover {
    color: #409EFF;
    
    .el-icon {
      color: #409EFF;
    }
  }
  
  .answer-time {
    margin-left: auto;
    font-size: 12px;
  }
}

.answer-history-dialog {
  .history-list {
    .history-item {
      padding: 16px;
      border-bottom: 1px solid #ebeef5;
      
      &:last-child {
        border-bottom: none;
      }
      
      .question-info {
        display: flex;
        align-items: flex-start;
        margin-bottom: 12px;
        
        .question-index {
          margin-right: 8px;
          color: #909399;
        }
        
        .question-text {
          flex: 1;
          color: #303133;
        }
        
        .question-type {
          padding: 2px 8px;
          border-radius: 4px;
          font-size: 12px;
          margin-left: 12px;
          
          &.单选 {
            background: #e1f3d8;
            color: #67c23a;
          }
          
          &.多选 {
            background: #fdf6ec;
            color: #e6a23c;
          }
        }
      }
      
      .answer-info {
        display: flex;
        justify-content: space-between;
        align-items: flex-end;
        
        .answer-detail {
          .answer-row {
            display: flex;
            align-items: center;
            margin-bottom: 8px;
            
            &:last-child {
              margin-bottom: 0;
            }
            
            .label {
              width: 70px;
              color: #909399;
            }
            
            .value {
              padding: 4px 12px;
              border-radius: 4px;
              
              &.correct {
                background: #f0f9eb;
                color: #67c23a;
              }
              
              &.wrong {
                background: #fef0f0;
                color: #f56c6c;
              }
              
              &.explanation {
                background: #f8f9fa;
                color: #606266;
                font-size: 14px;
                line-height: 1.6;
                white-space: pre-wrap;
                margin-top: 4px;
              }
            }
          }
        }
        
        .answer-meta {
          display: flex;
          flex-direction: column;
          align-items: flex-end;
          gap: 4px;
          
          .time {
            color: #909399;
            font-size: 12px;
          }
          
          .score {
            color: #f56c6c;
            font-weight: 500;
          }
        }
      }
    }
  }
  
  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: center;
  }
}
</style> 