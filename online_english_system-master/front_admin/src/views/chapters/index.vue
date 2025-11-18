<template>
  <div class="chapters-container">
    <!-- 头部搜索和操作 -->
    <div class="header">
      <div class="title">章节管理</div>
      <div class="actions">
        <el-select v-model="selectedCourseId" placeholder="请选择课程" class="course-select" @change="handleCourseChange"
          filterable allow-create clearable>
          <el-option v-for="course in courseList" :key="course.id" :label="course.title" :value="course.id" />
        </el-select>
        <el-button type="primary" @click="handleAdd">+ 添加章节</el-button>
      </div>
    </div>

    <!-- 章节表格 -->
    <el-table v-loading="loading" :data="chapterList" style="width: 100%"
      :header-cell-style="{ background: '#f5f7fa' }">
      <el-table-column prop="id" label="ID" width="80" align="center" />
      <el-table-column prop="title" label="章节标题" min-width="150" />
      <el-table-column prop="content" label="章节简介" min-width="200" show-overflow-tooltip />
      <el-table-column label="封面图" width="120">
        <template #default="{ row }">
          <el-image :src="row.coverImage ? `${baseUrl}${row.coverImage}` : ''"
            :preview-src-list="row.coverImage ? [`${baseUrl}${row.coverImage}`] : []" fit="cover"
            style="width: 80px; height: 45px; border-radius: 4px">
            <template #error>
              <div class="image-placeholder">
                <el-icon>
                  <Picture />
                </el-icon>
              </div>
            </template>
          </el-image>
        </template>
      </el-table-column>
      <el-table-column prop="videoUrl" label="视频链接" min-width="200" show-overflow-tooltip>
        <template #default="{ row }">
          <div class="video-url">
            <el-icon>
              <VideoCamera />
            </el-icon>
            <el-link :href="row.videoUrl ? `${baseUrl}${row.videoUrl}` : ''" target="_blank" type="primary"
              :underline="false" class="video-link">
              {{ row.videoUrl }}
            </el-link>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="duration" label="视频时长" width="100">
        <template #default="{ row }">
          {{ formatDuration(row.duration) }}
        </template>
      </el-table-column>
      <el-table-column prop="courseVO.title" label="所属课程" width="150">
        <template #default="{ row }">
          <el-tag size="small" effect="plain">{{ row.courseVO?.title }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="createTime" label="创建时间" width="180" />
      <el-table-column label="操作" width="200" fixed="right">
        <template #default="{ row }">
          <el-button type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
          <el-button type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          <el-button type="info" size="small" @click="handlePreview(row)">预览</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <div class="pagination-info">
        共 {{ total }} 条
      </div>
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[10, 20, 30]"
        :total="Number(total)" layout="sizes, prev, pager, next" @size-change="handleSizeChange"
        @current-change="handleCurrentChange" />
    </div>

    <!-- 章节详情弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? '新增章节' : '编辑章节'" width="600px">
      <el-form ref="formRef" :model="chapterForm" :rules="rules" label-width="80px">
        <el-form-item label="标题" prop="title">
          <el-input v-model="chapterForm.title" placeholder="请输入章节标题" />
        </el-form-item>
        <el-form-item label="内容" prop="content">
          <el-input v-model="chapterForm.content" type="textarea" :rows="3" placeholder="请输入章节内容描述" />
        </el-form-item>
        <template v-if="dialogType === 'edit'">
          <el-form-item label="封面图" prop="coverImage">
            <el-upload class="cover-uploader" :action="`${baseUrl}/chapter/upload/cover`" :show-file-list="false"
              :on-success="handleCoverSuccess" :before-upload="beforeCoverUpload" :data="{ chapterId: chapterForm.id }"
              name="file">
              <el-image v-if="chapterForm.coverImage" :src="`${baseUrl}${chapterForm.coverImage}`" fit="cover"
                class="cover-image" />
              <el-icon v-else class="cover-uploader-icon">
                <Plus />
              </el-icon>
            </el-upload>
          </el-form-item>
          <el-form-item label="视频" prop="videoUrl">
            <el-upload class="video-uploader" :action="`${baseUrl}/chapter/upload/video`" :show-file-list="false"
              :on-success="handleVideoSuccess" :before-upload="beforeVideoUpload" :data="{ chapterId: chapterForm.id }"
              name="file">
              <el-button type="primary" :icon="VideoCamera">
                {{ chapterForm.videoUrl ? '重新上传' : '上传视频' }}
              </el-button>
            </el-upload>
            <div v-if="chapterForm.videoUrl" class="video-info">
              <el-icon>
                <VideoCamera />
              </el-icon>
              <span class="video-name">已上传视频</span>
            </div>
          </el-form-item>
        </template>
        <template v-else>
          <el-form-item label="时长" prop="duration">
            <el-input-number v-model="chapterForm.duration" :min="0" placeholder="请输入视频时长(秒)" />
          </el-form-item>
        </template>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit">确定</el-button>
      </template>
    </el-dialog>

    <!-- 视频预览弹窗 -->
    <el-dialog v-model="previewVisible" width="1200px" destroy-on-close class="video-preview-dialog"
      style="padding: 0 !important;">
      <div class="preview-container">
        <!-- 主视频区域 -->
        <div class="video-section">
          <div class="video-wrapper">
            <video v-if="previewChapter.videoUrl" :src="`${baseUrl}${previewChapter.videoUrl}`" controls
              class="video-player" />
            <div v-else class="video-placeholder">
              <el-icon>
                <VideoCamera />
              </el-icon>
              <span>暂无视频</span>
            </div>
          </div>
          <!-- 视频信息栏 -->
          <div class="video-info-bar">
            <div class="left">
              <el-icon>
                <VideoPlay />
              </el-icon>
              <span class="title">{{ previewChapter.title }}</span>
            </div>
            <div class="right">
              <span class="info-item">
                <el-icon>
                  <Timer />
                </el-icon>
                {{ formatDuration(previewChapter.duration) }}
              </span>
              <span class="info-item">
                <el-icon>
                  <Collection />
                </el-icon>
                {{ previewChapter.courseVO?.title }}
              </span>
            </div>
          </div>
        </div>

        <!-- 右侧简介 -->
        <div class="content-section">
          <div class="content-header">
            <el-icon>
              <Document />
            </el-icon>
            <span>章节简介</span>
            <div class="close-btn" @click="previewVisible = false">
              <el-icon>
                <Close />
              </el-icon>
            </div>
          </div>
          <div class="content-body">
            {{ previewChapter.content || '暂无简介' }}
          </div>
          <div class="content-footer">
            <div class="info-row">
              <el-icon>
                <Calendar />
              </el-icon>
              <span class="label">创建时间：</span>
              <span class="value">{{ formatDate(previewChapter.createTime) }}</span>
            </div>
            <div class="info-row">
              <el-icon>
                <Edit />
              </el-icon>
              <span class="label">更新时间：</span>
              <span class="value">{{ formatDate(previewChapter.updateTime) }}</span>
            </div>
          </div>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import {
  Picture,
  Plus,
  VideoCamera,
  VideoPlay,
  Document,
  Timer,
  Collection,
  Calendar,
  Edit,
  Close
} from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, UploadProps } from 'element-plus'
import {
  getChapterList,
  getChaptersByCourseId,
  getChapterDetail,
  addChapter,
  updateChapter,
  deleteChapter,
  uploadChapterCover,
  uploadChapterVideo,
  type Chapter,
  type ChapterInfo
} from '@/api/chapter'
import { getCourseList } from '@/api/course'

// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const selectedCourseId = ref('')
const courseList = ref<Course[]>([])
const chapterList = ref<Chapter[]>([])
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const previewVisible = ref(false)
const previewChapter = ref<Chapter>({} as Chapter)
const formRef = ref<FormInstance>()

// 表单数据
const chapterForm = reactive<Chapter>({
  id: '',
  courseId: '',
  title: '',
  content: '',
  coverImage: '',
  videoUrl: '',
  duration: 0,
  createTime: '',
  updateTime: ''
})

// 表单校验规则
const rules = {
  title: [
    { required: true, message: '请输入章节标题', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  content: [
    { required: true, message: '请输入章节内容', trigger: 'blur' }
  ],
  duration: [
    { required: true, message: '请输入视频时长', trigger: 'change' },
    { type: 'number', min: 0, message: '时长必须大于0', trigger: 'change' }
  ]
}

// 获取基础URL
const baseUrl = import.meta.env.VITE_BASE_URL

// 格式化视频时长
const formatDuration = (seconds: number) => {
  const minutes = Math.floor(seconds / 60)
  const remainingSeconds = seconds % 60
  return `${minutes}:${remainingSeconds.toString().padStart(2, '0')}`
}

// 获取章节列表
const fetchChapterList = async () => {
  console.log('fetchChapterList')
  loading.value = true
  try {
    const res = await getChapterList({
      current: currentPage.value,
      pageSize: pageSize.value,
      courseId: selectedCourseId.value
    })
    if (res.code === 0) {
      chapterList.value = res.data.records
      total.value = Number(res.data.total)
    }
  } catch (error) {
    console.error('获取章节列表失败:', error)
    ElMessage.error('获取章节列表失败')
  } finally {
    loading.value = false
  }
}

// 获取课程列表
const fetchCourseList = async () => {
  try {
    const res = await getCourseList()
    if (res.code === 0) {
      courseList.value = res.data.records
    }
  } catch (error) {
    console.error('获取课程列表失败:', error)
    ElMessage.error('获取课程列表失败')
  }
}

// 课程选择改变
const handleCourseChange = () => {
  currentPage.value = 1
  fetchChapterList()
}

// 分页处理
const handleSizeChange = (val: number) => {
  pageSize.value = val
  fetchChapterList()
}

const handleCurrentChange = (val: number) => {
  currentPage.value = val
  fetchChapterList()
}

// 新增章节
const handleAdd = () => {
  if (!selectedCourseId.value) {
    ElMessage.warning('请先选择课程')
    return
  }

  dialogType.value = 'add'
  dialogVisible.value = true
  Object.assign(chapterForm, {
    id: '',
    courseId: selectedCourseId.value,
    title: '',
    content: '',
    duration: 0
  })
}

// 编辑章节
const handleEdit = async (row: any) => {
  try {
    const res = await getChapterDetail(row.id)
    if (res.code === 0) {
      dialogType.value = 'edit'
      dialogVisible.value = true
      Object.assign(chapterForm, res.data)
    }
  } catch (error) {
    ElMessage.error('获取章节详情失败')
  }
}

// 预览章节
const handlePreview = (row: any) => {
  previewChapter.value = row
  previewVisible.value = true
}

// 删除章节
const handleDelete = (row: Chapter) => {
  ElMessageBox.confirm(
    '确定要删除该章节吗？',
    '警告',
    {
      confirmButtonText: '确定',
      cancelButtonText: '取消',
      type: 'warning'
    }
  ).then(async () => {
    try {
      await deleteChapter(row.id)
      ElMessage.success('删除成功')
      fetchChapterList()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 修改提交表单函数
const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      try {
        if (dialogType.value === 'add') {
          // 新增时只提交必要字段
          const submitData = {
            title: chapterForm.title,
            content: chapterForm.content,
            duration: chapterForm.duration,
            courseId: selectedCourseId.value
          }
          await addChapter(submitData)
          ElMessage.success('添加成功')
        } else {
          // 更新时提交完整数据
          await updateChapter(chapterForm)
          ElMessage.success('更新成功')
        }

        dialogVisible.value = false
        fetchChapterList()
      } catch (error) {
        ElMessage.error(dialogType.value === 'add' ? '添加失败' : '更新失败')
      }
    }
  })
}

// 修改上传成功处理函数
const handleCoverSuccess: UploadProps['onSuccess'] = (response) => {
  if (response.code === 0) {
    chapterForm.coverImage = response.data.replace(baseUrl, '')
    ElMessage.success('封面上传成功')
  } else {
    ElMessage.error('封面上传失败')
  }
}

const handleVideoSuccess: UploadProps['onSuccess'] = (response) => {
  if (response.code === 0) {
    chapterForm.videoUrl = response.data

    // 创建临时 video 元素获取视频时长
    const video = document.createElement('video')
    video.src = `${baseUrl}${response.data}`

    // 监听元数据加载完成事件
    video.onloadedmetadata = () => {
      // 获取视频时长（向上取整为整数秒）
      const duration = Math.ceil(video.duration)
      chapterForm.duration = duration

      // 更新视频时长
      updateChapter({
        ...chapterForm,
        duration
      }).then(() => {
        ElMessage.success('视频上传成功')
      }).catch(() => {
        ElMessage.error('视频时长更新失败')
      })

      // 清理临时元素
      video.remove()
    }

    // 处理加载失败的情况
    video.onerror = () => {
      ElMessage.error('获取视频时长失败')
      video.remove()
    }
  } else {
    ElMessage.error('视频上传失败')
  }
}

// 上传前的验证
const beforeCoverUpload: UploadProps['beforeUpload'] = (file) => {
  const isImage = file.type.startsWith('image/')
  const isLt2M = file.size / 1024 / 1024 < 2

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt2M) {
    ElMessage.error('图片大小不能超过 2MB!')
    return false
  }
  return true
}

const beforeVideoUpload: UploadProps['beforeUpload'] = (file) => {
  const isVideo = file.type.startsWith('video/')
  const isLt1G = file.size / 1024 / 1024 / 1024 < 500

  if (!isVideo) {
    ElMessage.error('只能上传视频文件!')
    return false
  }
  if (!isLt1G) {
    ElMessage.error('视频大小不能超过 1GB!')
    return false
  }
  return true
}

// 添加日期格式化函数
const formatDate = (date: string) => {
  if (!date) return ''
  return new Date(date).toLocaleString('zh-CN', {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit'
  })
}

// 初始化
onMounted(() => {
  // 获取课程列表
  fetchCourseList()
  // 获取章节列表
  fetchChapterList()
})
</script>

<style scoped lang="scss">
.chapters-container {
  padding: 20px;
  background-color: #fff;
  border-radius: 4px;

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 24px;

    .title {
      font-size: 18px;
      font-weight: 500;
      color: #1f2937;
    }

    .actions {
      display: flex;
      gap: 12px;
      align-items: center;

      .course-select {
        width: 200px;
      }
    }
  }

  .pagination {
    margin-top: 20px;
    display: flex;
    justify-content: flex-end;
    align-items: center;
    gap: 16px;

    .pagination-info {
      color: #666;
    }
  }
}

.cover-uploader {
  :deep(.el-upload) {
    border: 1px dashed var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: var(--el-transition-duration);

    &:hover {
      border-color: var(--el-color-primary);
    }
  }

  .cover-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 100px;
    text-align: center;
    line-height: 100px;
  }

  .cover-image {
    width: 178px;
    height: 100px;
    display: block;
  }
}

.video-uploader {
  .video-info {
    margin-top: 10px;
    display: flex;
    align-items: center;
    gap: 8px;
    color: var(--el-text-color-secondary);
  }
}

.image-placeholder {
  width: 80px;
  height: 45px;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #f5f7fa;
  color: #909399;
}

.video-url {
  display: flex;
  align-items: center;
  gap: 8px;

  .el-icon {
    color: var(--el-text-color-secondary);
  }

  .video-link {
    // 处理过长的URL
    max-width: 300px;
    white-space: nowrap;
    overflow: hidden;
    text-overflow: ellipsis;
  }
}


:deep(.video-preview-dialog .el-dialog__header) {
  display: none !important;
}

.video-preview-dialog {
  padding: 0 !important;

  :deep(.el-dialog__body, .el-dialog) {
    padding: 0 !important;

  }


  :deep(.el-dialog__header) {
    display: none;
    padding: 0;
    margin: 0;
    border-bottom: 1px solid var(--el-border-color-lighter);
    background-color: #000;

    .el-dialog__title {
      font-size: 16px;
      font-weight: 500;
      color: #fff;
    }

    .el-dialog__close {
      color: #fff;

      &:hover {
        color: var(--el-color-primary);
      }
    }
  }

  :deep(.el-dialog__footer) {
    display: none;
  }
}

.preview-container {
  display: flex;
  height: 675px; // 16:9 比例
  background-color: #000;
}

.video-section {
  flex: 1;
  display: flex;
  flex-direction: column;
  min-width: 0; // 防止视频溢出

  .video-wrapper {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    background-color: #000;
    position: relative;
    aspect-ratio: 16/9;

    .video-player {
      position: absolute;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: contain;
    }

    .video-placeholder {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
      color: #4b5563;

      .el-icon {
        font-size: 48px;
      }

      span {
        font-size: 14px;
      }
    }
  }

  .video-info-bar {
    padding: 12px 20px;
    background-color: #1a1a1a;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .left {
      display: flex;
      align-items: center;
      gap: 8px;

      .el-icon {
        color: var(--el-color-primary);
      }

      .title {
        color: #fff;
        font-size: 15px;
        font-weight: 500;
      }
    }

    .right {
      display: flex;
      gap: 16px;

      .info-item {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #9ca3af;
        font-size: 13px;

        .el-icon {
          font-size: 14px;
        }
      }
    }
  }
}

.content-section {
  width: 280px;
  background-color: #1a1a1a;
  border-left: 1px solid #2d2d2d;
  display: flex;
  flex-direction: column;
  position: relative;

  .close-btn {
    font-size: 20px;
    position: absolute;
    right: 15px;
    top: 15px;
    cursor: pointer;
  }

  .content-header {
    padding: 16px;
    display: flex;
    align-items: center;
    gap: 8px;
    border-bottom: 1px solid #2d2d2d;

    .el-icon {
      color: var(--el-color-primary);
    }

    span {
      color: #fff;
      font-size: 15px;
      font-weight: 500;
    }
  }

  .content-body {
    flex: 1;
    padding: 16px;
    color: #9ca3af;
    font-size: 14px;
    line-height: 1.6;
    overflow-y: auto;

    &::-webkit-scrollbar {
      width: 6px;
    }

    &::-webkit-scrollbar-thumb {
      background-color: #4b5563;
      border-radius: 3px;
    }
  }

  .content-footer {
    padding: 16px;
    border-top: 1px solid #2d2d2d;

    .info-row {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #9ca3af;
      font-size: 13px;
      margin-bottom: 8px;

      &:last-child {
        margin-bottom: 0;
      }

      .el-icon {
        color: #6b7280;
      }

      .label {
        color: #6b7280;
      }

      .value {
        color: #9ca3af;
      }
    }
  }
}
</style>