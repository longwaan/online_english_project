<template>
  <div class="study-records-container">
    <!-- 头部搜索和操作 -->
    <el-card class="header-card" shadow="hover">
      <div class="header">
        <div class="title">
          <el-icon class="title-icon">
            <Reading/>
          </el-icon>
          学习记录管理
        </div>
        <div class="actions">
          <el-input style="width: 150px;" v-model="searchQuery" placeholder="搜索用户或课程" class="search-input"
                    clearable @keyup.enter="handleSearch">
            <template #prefix>
              <el-icon>
                <Search/>
              </el-icon>
            </template>
          </el-input>
          <el-select v-model="statusFilter" placeholder="学习状态" clearable style="width: 150px;">
            <template #prefix>
              <el-icon>
                <Flag/>
              </el-icon>
            </template>
            <el-option label="已完成" value="已完成"/>
            <el-option label="进行中" value="进行中"/>
            <el-option label="未开始" value="未开始"/>
          </el-select>
          <el-button type="primary" @click="handleSearch">
            <el-icon>
              <Search/>
            </el-icon>
            查询
          </el-button>
          <el-button type="primary" @click="createDialogVisible = true">
            <el-icon>
              <Plus/>
            </el-icon>
            创建记录
          </el-button>
        </div>
      </div>
    </el-card>

    <!-- 学习记录列表 -->
    <el-card class="table-card" shadow="hover">
      <template #header>
        <div class="table-header">
          <span class="table-title">
            <el-icon><Histogram/></el-icon>
            学习记录列表
          </span>
          <span v-if="filteredTotal > 0" class="record-count">
            共 {{ filteredTotal }} 条记录
          </span>
        </div>
      </template>

      <el-table
          v-loading="loading"
          :data="currentPageData"
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
              <el-avatar :size="32" :src="getAvatarUrl(row.userVO?.userAvatar)"/>
              <span class="user-name">{{ row.userVO?.userName }}</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="学习内容" min-width="180" show-overflow-tooltip>
          <template #default="{ row }">
            <div class="cell-content">
              <div v-if="row.courseVO" class="content-item">
                <el-tag type="primary" effect="plain" size="small">课程</el-tag>
                <span class="content-title">{{ row.courseVO.title }}</span>
              </div>
              <div v-else-if="row.examVO" class="content-item">
                <el-tag type="success" effect="plain" size="small">考试</el-tag>
                <span class="content-title">{{ row.examVO.title }}</span>
              </div>
              <div v-else-if="row.vocabularyVO" class="content-item">
                <el-tag type="warning" effect="plain" size="small">词汇</el-tag>
                <span class="content-title">
                  {{ row.vocabularyVO.word }}
                  <span class="vocabulary-info">
                    {{ row.vocabularyVO.phonetic }}
                  </span>
                    <el-button type="text" @click="handlePlayAudio(row.vocabularyVO.word, 'uk')">
                      <el-icon><Microphone/></el-icon>
                    </el-button>
                </span>
              </div>
              <div v-else class="content-item">
                <el-tag type="info" effect="plain" size="small">未知</el-tag>
                <span class="content-title">未知内容</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="进度" width="180" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <el-progress
                  :percentage="row.progress"
                  :color="getProgressColor(row.progress)"
                  :stroke-width="10"
                  :format="percentFormat"
              />
            </div>
          </template>
        </el-table-column>

        <el-table-column label="状态" width="100" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <el-tag
                  :type="getStatusType(row.status)"
                  effect="light"
                  class="status-tag"
              >
                {{ row.status }}
              </el-tag>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="学习时长" width="150" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <span class="time-badge">
                <el-icon><Timer/></el-icon>
                {{ formatStudyTime(row.studyTime) }}
              </span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="得分" width="100" align="center">
          <template #default="{ row }">
            <div class="cell-content">
              <span v-if="row.score !== null" class="score-badge">{{ row.score }}</span>
              <span v-else class="no-score">-</span>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="创建时间" width="180">
          <template #default="{ row }">
            <div class="cell-content">
              <div class="time-wrapper">
                <el-icon>
                  <Calendar/>
                </el-icon>
                <span class="time">{{ row.createTime }}</span>
              </div>
            </div>
          </template>
        </el-table-column>

        <el-table-column label="操作" width="200" fixed="right" align="center">
          <template #default="{ row }">
            <div class="cell-content action-buttons">
              <el-button
                  type="primary"
                  size="small"
                  @click="handleViewDetail(row)"
                  class="action-button"
              >
                <el-icon>
                  <View/>
                </el-icon>
                详情
              </el-button>
              <el-button
                  type="danger"
                  size="small"
                  @click="handleDelete(row)"
                  class="action-button"
              >
                <el-icon>
                  <Delete/>
                </el-icon>
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

    <!-- 详情弹窗 -->
    <el-dialog
        v-model="detailVisible"
        title="学习记录详情"
        width="800px"
        destroy-on-close
        class="record-detail-dialog"
    >
      <div v-loading="detailLoading" class="record-detail">
        <!-- 用户信息 -->
        <div class="detail-section user-section">
          <h3>
            <el-icon>
              <User/>
            </el-icon>
            用户信息
          </h3>
          <div class="user-detail">
            <el-avatar :size="64" :src="getAvatarUrl(currentRecord.userVO?.userAvatar)"/>
            <div class="user-info">
              <div class="username">{{ currentRecord.userVO?.userName }}</div>
              <div class="user-role">角色: {{ currentRecord.userVO?.userRole }}</div>
              <div class="user-profile">简介: {{ currentRecord.userVO?.userProfile || '暂无简介' }}</div>
            </div>
          </div>
        </div>

        <!-- 学习内容信息 -->
        <div class="detail-section content-section">
          <h3>
            <el-icon>
              <Reading/>
            </el-icon>
            学习内容
          </h3>
          <div v-if="currentRecord.courseVO" class="content-info">
            <div class="content-header">
              <el-tag type="primary" size="default">课程</el-tag>
              <div class="content-title">{{ currentRecord.courseVO.title }}</div>
            </div>
            <div class="content-desc">{{ currentRecord.courseVO.description }}</div>
            <div class="content-meta">
              <span class="meta-item">
                <el-icon><Aim/></el-icon>
                难度: {{ currentRecord.courseVO.level }}
              </span>
              <span class="meta-item">
                <el-icon><Document/></el-icon>
                章节数: {{ currentRecord.courseVO.chapterCount }}
              </span>
            </div>
            <div v-if="currentRecord.courseVO?.chapterList?.length > 0" class="chapter-list">
              <div class="chapter-title">
                <el-icon>
                  <Document/>
                </el-icon>
                章节列表
              </div>
              <el-collapse>
                <el-collapse-item
                    v-for="(chapter, index) in currentRecord.courseVO.chapterList"
                    :key="chapter.id"
                >
                  <template #title>
                    <div class="chapter-header">
                      <span class="chapter-index">{{ index + 1 }}</span>
                      <span class="chapter-name">{{ chapter.title }}</span>
                    </div>
                  </template>
                  <div class="chapter-content">
                    <div class="chapter-desc">{{ chapter.content }}</div>
                    <div class="chapter-meta">
                      <span class="meta-item">
                        <el-icon><Timer/></el-icon>
                        时长: {{ formatDuration(chapter.duration) }}
                      </span>
                      <span class="meta-item">
                        <el-icon><Calendar/></el-icon>
                        创建时间: {{ chapter.createTime }}
                      </span>
                    </div>
                  </div>
                </el-collapse-item>
              </el-collapse>
            </div>
          </div>
          <div v-else-if="currentRecord.examVO" class="content-info">
            <div class="content-header">
              <el-tag type="success" size="default">考试</el-tag>
              <div class="content-title">{{ currentRecord.examVO.title }}</div>
            </div>
            <div class="content-desc">{{ currentRecord.examVO.description }}</div>
            <div class="content-meta">
              <span class="meta-item">
                <el-icon><Trophy/></el-icon>
                总分: {{ currentRecord.examVO.totalScore }}
              </span>
              <span class="meta-item">
                <el-icon><Calendar/></el-icon>
                考试时间: {{ currentRecord.examVO.startTime }} ~ {{ currentRecord.examVO.endTime }}
              </span>
            </div>
          </div>
          <div v-else-if="currentRecord.vocabularyVO" class="content-info">
            <div class="content-header">
              <el-tag type="warning" size="default">词汇</el-tag>
              <div class="content-title">{{ currentRecord.vocabularyVO.word }}
                <el-button type="text" @click="handlePlayAudio(currentRecord.vocabularyVO.word, 'uk')">
                  <el-icon>
                    <Microphone/>
                  </el-icon>
                </el-button>
              </div>
            </div>

            <div class="vocabulary-content">
              <div class="vocab-item">
                <span class="label">音标:</span>
                <span class="value phonetic">{{ currentRecord.vocabularyVO.phonetic }}</span>
              </div>

              <div class="vocab-item">
                <span class="label">释义:</span>
                <span class="value">{{ currentRecord.vocabularyVO.meaning }}</span>
              </div>

              <div class="vocab-item">
                <span class="label">例句:</span>
                <span class="value example">{{ currentRecord.vocabularyVO.example }}</span>
              </div>

              <div class="content-meta">
                <span class="meta-item">
                  <el-icon><Aim/></el-icon>
                  难度: {{ currentRecord.vocabularyVO.difficultyLevel }}
                </span>
                <span class="meta-item">
                  <el-icon><Document/></el-icon>
                  类型: {{ currentRecord.vocabularyVO.isPhrase }}
                </span>
                <span class="meta-item">
                  <el-icon><Calendar/></el-icon>
                  创建时间: {{ currentRecord.vocabularyVO.createTime }}
                </span>
              </div>
            </div>
          </div>
          <div v-else class="content-info">
            <div class="content-header">
              <el-tag type="info" size="default">未知</el-tag>
              <div class="content-title">未知内容</div>
            </div>
          </div>
        </div>

        <!-- 学习进度信息 -->
        <div class="detail-section progress-section">
          <h3>
            <el-icon>
              <Histogram/>
            </el-icon>
            学习进度
          </h3>
          <div class="progress-info">
            <div class="progress-bar">
              <span class="progress-label">完成进度:</span>
              <el-progress
                  :percentage="currentRecord.progress"
                  :color="getProgressColor(currentRecord.progress)"
                  :stroke-width="15"
                  :format="percentFormat"
              />
            </div>
            <div class="progress-stats">
              <div class="stat-item">
                <span class="stat-label">学习状态:</span>
                <el-tag :type="getStatusType(currentRecord.status)" size="small">{{ currentRecord.status }}</el-tag>
              </div>
              <div class="stat-item">
                <span class="stat-label">学习时长:</span>
                <span class="stat-value">{{ formatStudyTime(currentRecord.studyTime) }}</span>
              </div>
              <div class="stat-item">
                <span class="stat-label">得分:</span>
                <span v-if="currentRecord.score !== null" class="stat-value score">{{ currentRecord.score }}</span>
                <span v-else class="stat-value">暂无得分</span>
              </div>
              <div class="stat-item">
                <span class="stat-label">创建时间:</span>
                <span class="stat-value">{{ currentRecord.createTime }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 创建记录弹窗 -->
    <el-dialog
        v-model="createDialogVisible"
        title="创建学习记录"
        width="500px"
        destroy-on-close
        class="create-dialog"
    >
      <el-form
          ref="createFormRef"
          :model="createForm"
          :rules="createFormRules"
          label-width="100px"
      >
        <el-form-item label="用户ID" prop="userId">
          <el-input-number
              v-model="createForm.userId"
              :min="1"
              :controls="false"
              placeholder="请输入用户ID"
              class="short-input"
          />
        </el-form-item>

        <el-form-item label="学习内容" prop="contentType">
          <el-radio-group v-model="contentType" class="content-type-group">
            <el-radio-button :value="'course'">
              <el-icon>
                <Reading/>
              </el-icon>
              课程
            </el-radio-button>
            <el-radio-button :value="'exam'">
              <el-icon>
                <Edit/>
              </el-icon>
              考试
            </el-radio-button>
            <el-radio-button :value="'vocabulary'">
              <el-icon>
                <Document/>
              </el-icon>
              词汇
            </el-radio-button>
          </el-radio-group>
        </el-form-item>

        <el-form-item :label="contentTypeLabel" :prop="contentType + 'Id'">
          <el-input-number
              v-model="createForm[contentType + 'Id']"
              :min="1"
              :controls="false"
              :placeholder="`请输入${contentTypeLabel}`"
              class="short-input"
          />
        </el-form-item>

        <el-form-item label="进度" prop="progress">
          <div class="progress-input">
            <div class="progress-header">
              <span class="progress-text">{{ createForm.progress }}%</span>
              <div class="progress-presets">
                <el-button-group>
                  <el-button
                      v-for="preset in [0, 25, 50, 75, 100]"
                      :key="preset"
                      size="small"
                      :type="createForm.progress === preset ? 'primary' : ''"
                      @click="createForm.progress = preset"
                  >
                    {{ preset }}%
                  </el-button>
                </el-button-group>
              </div>
            </div>
            <el-slider
                v-model="createForm.progress"
                :step="1"
                :show-input="false"
                :format-tooltip="value => `${value}%`"
            />
          </div>
        </el-form-item>

        <el-form-item label="状态" prop="status">
          <el-radio-group v-model="createForm.status" class="status-group">
            <el-radio-button :value="'未开始'">
              <el-icon>
                <Timer/>
              </el-icon>
              未开始
            </el-radio-button>
            <el-radio-button :value="'进行中'">
              <el-icon>
                <Loading/>
              </el-icon>
              进行中
            </el-radio-button>
            <el-radio-button :value="'已完成'">
              <el-icon><Select/></el-icon>
              已完成
            </el-radio-button>
          </el-radio-group>
        </el-form-item>

        <el-form-item label="学习时长" prop="studyTime">
          <el-input-number
              v-model="createForm.studyTime"
              :min="0"
              :controls="false"
              placeholder="请输入学习时长(分钟)"
              class="short-input"
          >
            <template #prefix>
              <el-icon>
                <Timer/>
              </el-icon>
            </template>
            <template #suffix>
              <span class="input-suffix">分钟</span>
            </template>
          </el-input-number>
        </el-form-item>

        <el-form-item label="得分" prop="score">
          <el-input-number
              v-model="createForm.score"
              :min="0"
              :max="100"
              :controls="false"
              placeholder="请输入得分(0-100)"
              class="short-input"
          >
            <template #prefix>
              <el-icon>
                <Trophy/>
              </el-icon>
            </template>
            <template #suffix>
              <span class="input-suffix">分</span>
            </template>
          </el-input-number>
        </el-form-item>
      </el-form>

      <template #footer>
        <el-button @click="closeCreateDialog" plain>
          <el-icon>
            <Close/>
          </el-icon>
          取消
        </el-button>
        <el-button type="primary" @click="handleCreate(createFormRef)">
          <el-icon>
            <Check/>
          </el-icon>
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import {ref, onMounted, watch, computed} from 'vue'
import {ElMessage, ElMessageBox, type FormInstance} from 'element-plus'
import {
  Search, Reading, View, User, Calendar, Timer,
  Histogram, Flag, Document, Trophy, Aim, Edit, Plus, Delete, Close, Check, Loading, Select, Microphone
} from '@element-plus/icons-vue'
// import {getStudyRecordList, deleteStudyRecord, createStudyRecord} from '@/api/studyRecord'
// import type {StudyRecord, CreateStudyRecordParams} from '@/api/studyRecord'

import defaultAvatar from '@/assets/avatar.jpg'
import type { CreateStudyRecordParams, StudyRecord } from '@/api/studyRecord/type'
import { createStudyRecord, deleteStudyRecord,getStudyRecordList } from '@/api/studyRecord/index'

// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const rawRecordList = ref<StudyRecord[]>([]) // 存储原始数据
const searchQuery = ref('')
const statusFilter = ref('')

// 筛选后的数据
const recordList = computed(() => {
  let result = [...rawRecordList.value]

  // 关键词搜索
  if (searchQuery.value) {
    const keyword = searchQuery.value.toLowerCase()
    result = result.filter(record =>
        record.userVO?.userName?.toLowerCase().includes(keyword) ||
        record.courseVO?.title?.toLowerCase().includes(keyword) ||
        record.examVO?.title?.toLowerCase().includes(keyword) ||
        record.vocabularyVO?.title?.toLowerCase().includes(keyword)
    )
  }

  // 状态筛选
  if (statusFilter.value) {
    result = result.filter(record => record.status === statusFilter.value)
  }

  return result
})

// 计算总条数
const filteredTotal = computed(() => recordList.value.length)

// 计算当前页数据
const currentPageData = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value
  const end = Math.min(start + pageSize.value, recordList.value.length)
  return recordList.value.slice(start, end)
})

// 详情相关
const detailVisible = ref(false)
const detailLoading = ref(false)
const currentRecord = ref<Partial<StudyRecord>>({})

// 删除记录
const handleDelete = async (row: StudyRecord) => {
  try {
    await ElMessageBox.confirm(
        '确定要删除这条学习记录吗？',
        '警告',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning'
        }
    )

    await deleteStudyRecord(row.id)
    ElMessage.success('删除成功')
    fetchRecordList()
  } catch (error) {
    if (error !== 'cancel') {
      console.error('删除学习记录失败:', error)
      ElMessage.error('删除失败')
    }
  }
}

// 创建记录相关
const createDialogVisible = ref(false)
const contentType = ref('course')
const createFormRef = ref()
const createForm = ref<CreateStudyRecordParams>({
  userId: undefined,
  courseId: undefined,
  examId: undefined,
  vocabularyId: undefined,
  progress: 0,
  status: '未开始',
  studyTime: undefined,
  score: undefined
})

// 根据内容类型获取标签文本
const contentTypeLabel = computed(() => {
  const labelMap: Record<string, string> = {
    course: '课程ID',
    exam: '考试ID',
    vocabulary: '词汇ID'
  }
  return labelMap[contentType.value] || '内容ID'
})

// 表单验证规则
const createFormRules = {
  userId: [
    {required: true, message: '请输入用户ID', trigger: 'blur'},
    {type: 'number', min: 1, message: '用户ID必须大于0', trigger: 'blur'}
  ],
  courseId: [
    {required: true, message: '请输入课程ID', trigger: 'blur'},
    {type: 'number', min: 1, message: '课程ID必须大于0', trigger: 'blur'}
  ],
  examId: [
    {required: true, message: '请输入考试ID', trigger: 'blur'},
    {type: 'number', min: 1, message: '考试ID必须大于0', trigger: 'blur'}
  ],
  vocabularyId: [
    {required: true, message: '请输入词汇ID', trigger: 'blur'},
    {type: 'number', min: 1, message: '词汇ID必须大于0', trigger: 'blur'}
  ],
  progress: [
    {required: true, message: '请输入进度', trigger: 'blur'},
    {type: 'number', min: 0, max: 100, message: '进度范围为0-100', trigger: 'blur'}
  ],
  status: [{required: true, message: '请选择状态', trigger: 'change'}],
  studyTime: [
    {required: true, message: '请输入学习时长', trigger: 'blur'},
    {type: 'number', min: 0, message: '学习时长不能小于0', trigger: 'blur'}
  ]
}

// 重置表单
const resetCreateForm = () => {
  if (createFormRef.value) {
    createFormRef.value.resetFields()
  }
  createForm.value = {
    userId: undefined,
    courseId: undefined,
    examId: undefined,
    vocabularyId: undefined,
    progress: 0,
    status: '未开始',
    studyTime: undefined,
    score: undefined
  }
  contentType.value = 'course'
}

// 关闭弹窗
const closeCreateDialog = () => {
  createDialogVisible.value = false
  resetCreateForm()
}

// 创建记录
const handleCreate = async (formEl: FormInstance | undefined) => {
  if (!formEl) return

  try {
    await formEl.validate()

    // 构建提交数据
    const submitData = {
      userId: createForm.value.userId,
      courseId: contentType.value === 'course' ? createForm.value.courseId : undefined,
      examId: contentType.value === 'exam' ? createForm.value.examId : undefined,
      vocabularyId: contentType.value === 'vocabulary' ? createForm.value.vocabularyId : undefined,
      progress: createForm.value.progress,
      status: createForm.value.status,
      studyTime: createForm.value.studyTime,
      score: createForm.value.score
    }

    await createStudyRecord(submitData)
    ElMessage.success('创建成功')
    closeCreateDialog()
    fetchRecordList()
  } catch (error) {
    console.error('创建学习记录失败:', error)
    ElMessage.error('创建失败')
  }
}

// 监听内容类型变化
watch(contentType, (newType) => {
  const types = ['courseId', 'examId', 'vocabularyId']
  types.forEach(type => {
    if (type !== `${newType}Id`) {
      createForm.value[type as keyof CreateStudyRecordParams] = undefined
    }
  })
})

// 获取学习记录列表
const fetchRecordList = async () => {
  loading.value = true
  try {
    const res = await getStudyRecordList({
      current: 1,
      pageSize: 1000 // 获取足够多的数据用于前端筛选
    })

    if (res.data) {
      rawRecordList.value = res.data.records || []
      total.value = parseInt(res.data.total) || 0
    } else {
      rawRecordList.value = []
      total.value = 0
    }
  } catch (error) {
    console.error('获取学习记录列表失败:', error)
    ElMessage.error('获取学习记录列表失败')
    rawRecordList.value = []
    total.value = 0
  } finally {
    loading.value = false
  }
}

// 查看详情
const handleViewDetail = (row: StudyRecord) => {
  detailVisible.value = true
  detailLoading.value = true
  currentRecord.value = {...row}

  // 模拟加载效果
  setTimeout(() => {
    detailLoading.value = false
  }, 300)
}

// 搜索
const handleSearch = () => {
  currentPage.value = 1
  // 不需要重新请求，使用计算属性筛选
}

// 获取头像URL
const getAvatarUrl = (avatar: string) => {
  if (!avatar) return defaultAvatar
  if (avatar.startsWith('http')) return avatar
  return import.meta.env.VITE_BASE_URL + avatar
}

// 获取进度颜色
const getProgressColor = (progress: number) => {
  if (progress >= 80) return '#67c23a'
  if (progress >= 60) return '#409eff'
  if (progress >= 40) return '#e6a23c'
  return '#f56c6c'
}

// 获取状态标签类型
const getStatusType = (status: string) => {
  const statusMap: Record<string, string> = {
    '已完成': 'success',
    '进行中': 'primary',
    '未开始': 'info'
  }
  return statusMap[status] || 'info'
}

// 格式化学习时长
const formatStudyTime = (minutes: number) => {
  if (!minutes && minutes !== 0) return '-'

  const hours = Math.floor(minutes / 60)
  const mins = minutes % 60

  if (hours > 0) {
    return `${hours}小时${mins > 0 ? mins + '分钟' : ''}`
  }
  return `${mins}分钟`
}

// 格式化视频时长
const formatDuration = (seconds: number) => {
  if (!seconds && seconds !== 0) return '-'

  const hours = Math.floor(seconds / 3600)
  const minutes = Math.floor((seconds % 3600) / 60)
  const secs = seconds % 60

  if (hours > 0) {
    return `${hours}:${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
  }
  return `${minutes}:${secs.toString().padStart(2, '0')}`
}

// 百分比格式化
const percentFormat = (percentage: number) => {
  return percentage.toFixed(0) + '%'
}

const handlePlayAudio = (word: string, type: 'uk' | 'us') => {
  const audioType = type === 'uk' ? 0 : 1; // 1 for UK, 2 for US
  const audio = new Audio(`http://dict.youdao.com/dictvoice?type=${audioType}&audio=${word}`);
  audio.play();
};

// 监听筛选条件变化
watch([searchQuery, statusFilter], () => {
  currentPage.value = 1
})

// 初始化
onMounted(() => {
  fetchRecordList()
})
</script>

<style lang="scss" scoped>
.study-records-container {
  padding: 20px;

  .header-card {
    margin-bottom: 20px;

    .header {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .title {
        font-size: 18px;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 8px;

        .title-icon {
          color: #409eff;
        }
      }

      .actions {
        display: flex;
        gap: 12px;

        .search-input {
          width: 320px;
        }
      }
    }
  }

  .table-card {
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

      .content-item {
        display: flex;
        align-items: center;
        gap: 8px;
        justify-content: flex-start;
        width: 100%;

        .content-title {
          font-weight: 500;
          color: #303133;

          .vocabulary-info {
            margin-left: 8px;
            color: #909399;
            font-size: 13px;
          }
        }
      }

      .time-badge {
        display: flex;
        align-items: center;
        gap: 4px;
        background-color: #f0f9ff;
        color: #409eff;
        padding: 4px 8px;
        border-radius: 4px;
        font-size: 13px;
      }

      .score-badge {
        background-color: #fff0f6;
        color: #f56c6c;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 12px;
        font-size: 14px;
      }

      .no-score {
        color: #909399;
        font-size: 16px;
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

.record-detail-dialog {
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

.record-detail {
  .detail-section {
    margin-bottom: 24px;
    background-color: #fff;
    border-radius: 8px;
    padding: 16px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);

    &.user-section {
      background-color: #f0f9ff;
    }

    &.content-section {
      background-color: #f0f7fa;
    }

    &.progress-section {
      background-color: #f9f6f2;
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

        .user-role, .user-profile {
          color: #606266;
          margin-bottom: 4px;
        }
      }
    }

    .content-info {
      .content-header {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 16px;

        .content-title {
          font-size: 18px;
          font-weight: 500;
          color: #409eff;
        }
      }

      .content-desc {
        color: #606266;
        margin-bottom: 16px;
        line-height: 1.6;
      }

      .content-meta {
        display: flex;
        gap: 20px;
        margin-bottom: 20px;

        .meta-item {
          display: flex;
          align-items: center;
          gap: 6px;
          color: #606266;
        }
      }
    }

    .chapter-list {
      margin-top: 20px;

      .chapter-title {
        font-size: 16px;
        font-weight: 500;
        color: #303133;
        margin-bottom: 16px;
        display: flex;
        align-items: center;
        gap: 8px;

        .el-icon {
          color: #409eff;
        }
      }

      :deep(.el-collapse) {
        border: none;
        background-color: transparent;

        .el-collapse-item {
          margin-bottom: 8px;
          border: 1px solid #e4e7ed;
          border-radius: 6px;
          overflow: hidden;

          &:last-child {
            margin-bottom: 0;
          }

          .el-collapse-item__header {
            background-color: #f5f7fa;
            border-bottom: none;
            font-weight: normal;
            height: 48px;
            padding: 0 16px;

            &.is-active {
              background-color: #ecf5ff;
              color: #409eff;
              border-bottom: 1px solid #e4e7ed;
            }

            &:hover {
              background-color: #ecf5ff;
            }
          }

          .el-collapse-item__content {
            padding: 16px;
          }
        }
      }

      .chapter-header {
        display: flex;
        align-items: center;
        gap: 12px;

        .chapter-index {
          width: 24px;
          height: 24px;
          display: flex;
          align-items: center;
          justify-content: center;
          background-color: #409eff;
          color: #fff;
          border-radius: 50%;
          font-size: 14px;
          font-weight: 500;
        }

        .chapter-name {
          font-size: 14px;
          font-weight: 500;
        }
      }

      .chapter-content {
        .chapter-desc {
          color: #606266;
          margin-bottom: 12px;
          line-height: 1.6;
          font-size: 14px;
          background-color: #f5f7fa;
          padding: 12px;
          border-radius: 4px;
        }

        .chapter-meta {
          display: flex;
          gap: 24px;

          .meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            color: #909399;
            font-size: 13px;

            .el-icon {
              font-size: 14px;
              color: #409eff;
            }
          }
        }
      }
    }

    .progress-info {
      .progress-bar {
        display: flex;
        align-items: center;
        margin-bottom: 20px;

        .progress-label {
          width: 80px;
          font-weight: 500;
          color: #606266;
        }

        :deep(.el-progress) {
          flex: 1;
        }
      }

      .progress-stats {
        display: grid;
        grid-template-columns: repeat(2, 1fr);
        gap: 16px;

        .stat-item {
          display: flex;
          align-items: center;

          .stat-label {
            width: 80px;
            font-weight: 500;
            color: #606266;
          }

          .stat-value {
            color: #303133;

            &.score {
              color: #f56c6c;
              font-weight: 600;
            }
          }
        }
      }
    }
  }

  .vocabulary-content {
    background-color: #fff;
    border-radius: 8px;
    padding: 20px;
    margin-bottom: 20px;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);

    .vocab-item {
      margin-bottom: 16px;
      display: flex;
      align-items: flex-start;

      &:last-child {
        margin-bottom: 0;
      }

      .label {
        width: 60px;
        color: #606266;
        font-weight: 500;
        font-size: 14px;
      }

      .value {
        flex: 1;
        color: #303133;
        font-size: 14px;
        line-height: 1.6;

        &.phonetic {
          font-family: Arial, sans-serif;
          color: #409eff;
          font-style: italic;
        }

        &.example {
          color: #67c23a;
          font-style: italic;
          padding: 8px 12px;
          background-color: #f0f9eb;
          border-radius: 4px;
          position: relative;

          &::before {
            content: '"';
            color: #67c23a;
            font-size: 20px;
            position: absolute;
            left: -4px;
            top: -4px;
          }

          &::after {
            content: '"';
            color: #67c23a;
            font-size: 20px;
            position: absolute;
            right: -4px;
            bottom: -8px;
          }
        }
      }
    }

    .content-meta {
      margin-top: 20px;
      padding-top: 16px;
      border-top: 1px dashed #e4e7ed;
      display: flex;
      gap: 24px;

      .meta-item {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #909399;
        font-size: 13px;

        .el-icon {
          font-size: 14px;
          color: #409eff;
        }
      }
    }
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

:deep(.el-input-number) {
  width: 100%;
}

.create-dialog {
  :deep(.el-dialog__body) {
    padding: 30px;
  }

  .el-form {
    .el-form-item {
      margin-bottom: 24px;

      &:last-child {
        margin-bottom: 0;
      }

      .short-input {
        width: 240px;

        :deep(.el-input__wrapper) {
          padding: 0 12px;

          .el-input__prefix {
            font-size: 16px;
            color: #909399;
          }

          .input-suffix {
            color: #909399;
            margin-left: 4px;
            font-size: 13px;
          }
        }
      }

      .content-type-group,
      .status-group {
        width: 100%;
        display: flex;
        gap: 12px;

        .el-radio-button {
          flex: 1;
          height: 36px;

          :deep(.el-radio-button__inner) {
            width: 100%;
            height: 100%;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 4px;

            .el-icon {
              margin-right: 4px;
              font-size: 16px;
            }
          }
        }
      }

      .progress-input {
        padding: 12px 0;

        .progress-header {
          display: flex;
          justify-content: space-between;
          align-items: center;
          margin-bottom: 16px;

          .progress-text {
            font-size: 24px;
            font-weight: 600;
            color: #409eff;
          }

          .progress-presets {
            .el-button-group {
              .el-button {
                padding: 6px 12px;

                &.is-active {
                  z-index: 1;
                }
              }
            }
          }
        }

        :deep(.el-slider) {
          .el-slider__runway {
            margin: 16px 0;
            height: 6px;

            .el-slider__bar {
              height: 6px;
            }
          }

          .el-slider__button {
            width: 16px;
            height: 16px;
          }

          &:hover {
            .el-slider__button {
              transform: scale(1.2);
            }
          }
        }
      }
    }
  }

  :deep(.el-dialog__footer) {
    padding-top: 0;

    .el-button {
      min-width: 100px;

      .el-icon {
        margin-right: 4px;
      }
    }
  }
}
</style> 