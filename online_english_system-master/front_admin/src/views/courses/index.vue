<template>
  <div class="courses-container">
    <!-- 头部搜索和操作 -->
    <div class="header">
      <div class="title">课程管理</div>
      <div class="actions">
        <el-input
          v-model="searchQuery"
          placeholder="请输入课程名称搜索"
          class="search-input"
          :prefix-icon="Search"
          clearable
          @clear="handleSearch"
          @input="handleSearchInput"
        />
        <el-button type="primary" @click="handleAdd">+ 添加课程</el-button>

      </div>
    </div>

    <!-- 课程表格 -->
    <el-table
      v-loading="loading"
      :data="courseList"
      style="width: 100%"
      :header-cell-style="{ background: '#f5f7fa' }"
      @sort-change="handleSortChange"
    >
      <el-table-column 
        prop="id" 
        label="ID" 
        width="80" 
        align="center"
        sortable="custom"
      />
      <el-table-column prop="coverImage" label="课程封面" width="120">
        <template #default="{ row }">
          <el-image
            :src="baseUrl + row.coverImage"
            :preview-src-list="[baseUrl + row.coverImage]"
            fit="cover"
            style="width: 80px; height: 60px; border-radius: 4px"
          />
        </template>
      </el-table-column>
      <el-table-column prop="title" label="课程名称" min-width="150" show-overflow-tooltip />
      <el-table-column prop="description" label="课程描述" min-width="200" show-overflow-tooltip />
      <el-table-column prop="level" label="难度等级" width="100">
        <template #default="{ row }">
          <el-tag :type="getLevelType(row.level)">{{ row.level }}</el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="status" label="状态" width="100">
        <template #default="{ row }">
          <el-tag :type="row.status === 1 ? 'success' : 'info'">
            {{ row.status === 1 ? '已上线' : '未上线' }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column 
        prop="createTime" 
        label="创建时间" 
        width="180"
        sortable="custom"
      />
      <el-table-column 
        prop="updateTime" 
        label="更新时间" 
        width="180"
        sortable="custom"
      />
      <el-table-column label="操作" width="250" fixed="right">
        <template #default="{ row }">
          <el-button  type="primary" size="small" @click="handleEdit(row)">编辑</el-button>
          <el-button  type="danger" size="small" @click="handleDelete(row)">删除</el-button>
          <el-button 
             
            :type="row.status === 1 ? 'warning' : 'success'" 
            size="small" 
            @click="handleStatusChange(row)"
          >
            {{ row.status === 1 ? '下线' : '上线' }}
          </el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :total="Number(total)"
        :page-sizes="[10, 20, 50, 100]"
        layout="sizes, prev, pager, next, total, jumper"
        @size-change="handleSizeChange"
        @current-change="handleCurrentChange"
      />
    </div>

    <!-- 课程表单弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增课程' : '编辑课程'"
      width="600px"
    >
      <el-form
        ref="formRef"
        :model="courseForm"
        :rules="rules"
        label-width="100px"
        status-icon
      >
        <el-form-item label="课程封面" prop="coverImage">
          <div class="cover-upload">
            <el-upload
              class="cover-uploader"
              :show-file-list="false"
              :before-upload="beforeCoverUpload"
              :http-request="handleCoverUpload"
              accept="image/*"
            >
              <img 
                v-if="courseForm.coverImage" 
                :src="courseForm.coverImage.startsWith('blob:') ? courseForm.coverImage : baseUrl + courseForm.coverImage" 
                class="cover" 
              />
              <el-icon v-else class="cover-uploader-icon"><Plus /></el-icon>
            </el-upload>
            <div class="upload-tip" v-if="!courseForm.coverImage">
              <el-icon><InfoFilled /></el-icon>
              <span>请上传课程封面图片</span>
            </div>
          </div>
        </el-form-item>
        <el-form-item label="课程名称" prop="title">
          <el-input v-model="courseForm.title" placeholder="请输入课程名称" />
        </el-form-item>
        <el-form-item label="课程描述" prop="description">
          <el-input
            v-model="courseForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入课程描述"
          />
        </el-form-item>
        <el-form-item label="难度等级" prop="level">
          <el-select v-model="courseForm.level" placeholder="请选择难度等级">
            <el-option label="初级" value="初级" />
            <el-option label="中级" value="中级" />
            <el-option label="高级" value="高级" />
          </el-select>
        </el-form-item>
        <el-form-item label="课程状态" prop="status">
          <el-radio-group v-model="courseForm.status">
            <el-radio :label="1">上线</el-radio>
            <el-radio :label="0">下线</el-radio>
          </el-radio-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" :loading="submitLoading" @click="handleSubmit">
          {{ submitLoading ? '提交中...' : '确定' }}
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import { Search, Plus, InfoFilled } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance, UploadProps } from 'element-plus'
import { debounce } from 'lodash-es'
import { deleteCourse, getCourseList, updateCourse,addCourse } from '@/api/course/index'
// import {
//   getCourseList,
//   addCourse,
//   updateCourse,
//   deleteCourse,
//   uploadCover
// } from '@/api/course'

const baseUrl=import.meta.env.VITE_BASE_URL

// 自定义防抖函数
const debounce = (fn: Function, delay: number) => {
  let timer: number | null = null
  return (...args: any[]) => {
    if (timer) clearTimeout(timer)
    timer = setTimeout(() => {
      fn.apply(this, args)
    }, delay) as unknown as number
  }
}

// 状态定义
const loading = ref(false)
const submitLoading = ref(false)
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const formRef = ref<FormInstance>()
const searchQuery = ref('')
const currentPage = ref(1)
const pageSize = ref(7)
const total = ref(0)
const courseList = ref([])
const originalCourseList = ref([])

// 添加排序相关的状态
const sortConfig = reactive({
  prop: '',
  order: ''
})

// 表单数据
const courseForm = reactive({
  id: undefined,
  title: '',
  description: '',
  coverImage: '', // 用于显示图片预览和提交给后端的图片路径
  coverFile: null as File | null, // 用于存储上传的文件对象
  level: '',
  status: 1
})

// 表单校验规则
const rules = {
  title: [
    { required: true, message: '请输入课程名称', trigger: 'blur' },
    { min: 2, max: 50, message: '长度在 2 到 50 个字符', trigger: 'blur' }
  ],
  description: [
    { required: true, message: '请输入课程描述', trigger: 'blur' },
    { min: 10, max: 500, message: '长度在 10 到 500 个字符', trigger: 'blur' }
  ],
  level: [
    { required: true, message: '请选择难度等级', trigger: 'change' }
  ],
  coverImage: [
    { required: true, message: '请上传课程封面', trigger: 'change' }
  ]
}

// 获取课程列表
const fetchCourseList = async () => {
  loading.value = true
  try {
    const res = await getCourseList({
      current: currentPage.value,
      pageSize: pageSize.value
    })
    // 保存原始数据
    originalCourseList.value = res.data.records
    // 如果有搜索关键词，进行过滤
    if (searchQuery.value) {
      courseList.value = originalCourseList.value.filter(course => 
        course.title.toLowerCase().includes(searchQuery.value.toLowerCase())
      )
    } else {
      courseList.value = originalCourseList.value
    }
    total.value = Number(res.data.total)
  } catch (error) {
    console.error('获取课程列表失败:', error)
    ElMessage.error('获取课程列表失败')
  } finally {
    loading.value = false
  }
}

// 处理页码改变
const handleCurrentChange = (val: number) => {
  currentPage.value = val
  fetchCourseList()
}

// 处理每页条数改变
const handleSizeChange = (val: number) => {
  pageSize.value = val
  currentPage.value = 1 // 切换每页条数时重置为第一页
  fetchCourseList()
}

// 处理搜索
const handleSearch = () => {
  if (searchQuery.value) {
    courseList.value = originalCourseList.value.filter(course => 
      course.title.toLowerCase().includes(searchQuery.value.toLowerCase())
    )
  } else {
    courseList.value = originalCourseList.value
  }
}

// 处理搜索输入
const handleSearchInput = debounce(() => {
  handleSearch()
}, 300)

// 获取难度等级标签类型
const getLevelType = (level: string) => {
  const types = {
    '初级': 'success',
    '中级': 'warning',
    '高级': 'danger'
  }
  return types[level] || 'info'
}

// 封面上传前的校验
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

// 处理封面上传
const handleCoverUpload = (options: any) => {
  const file = options.file
  if (file) {
    courseForm.coverFile = file
    courseForm.coverImage = URL.createObjectURL(file)
  }
}

// 添加课程
const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
  courseForm.id = undefined
  courseForm.title = ''
  courseForm.description = ''
  courseForm.coverImage = ''
  courseForm.coverFile = null
  courseForm.level = ''
  courseForm.status = 1
}

// 处理编辑
const handleEdit = (row: any) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  // 深拷贝防止直接修改表格数据
  const courseData = JSON.parse(JSON.stringify(row))
  Object.assign(courseForm, courseData)
}

// 删除课程
const handleDelete = (row: any) => {
  ElMessageBox.confirm('确定要删除该课程吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteCourse(row.id)
      ElMessage.success('删除成功')
      fetchCourseList()
    } catch (error) {
      console.error('删除失败:', error)
      ElMessage.error('删除失败')
    }
  })
}

// 修改课程状态
const handleStatusChange = async (row: any) => {
  try {
    // 保留原有的所有信息，只修改状态
    await updateCourse({
      id: row.id,
      title: row.title,
      description: row.description,
      coverImage: row.coverImage,
      level: row.level,
      status: row.status === 1 ? 0 : 1
    })
    ElMessage.success('状态修改成功')
    fetchCourseList()
  } catch (error) {
    console.error('状态修改失败:', error)
    ElMessage.error('状态修改失败')
  }
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (!valid) return
    
    submitLoading.value = true
    try {
      const courseInfo = {
        id: courseForm.id, // 确保编辑时有 ID
        title: courseForm.title,
        description: courseForm.description,
        level: courseForm.level,
        status: courseForm.status
      }
      
      if (dialogType.value === 'add') {
        await addCourse(courseInfo, courseForm.coverFile || undefined)
        ElMessage.success('添加成功')
      } else {
        await updateCourse(courseInfo, courseForm.coverFile || undefined)
        ElMessage.success('更新成功')
      }
      
      dialogVisible.value = false
      fetchCourseList()
    } catch (error) {
      console.error('提交失败:', error)
      ElMessage.error('提交失败')
    } finally {
      submitLoading.value = false
    }
  })
}

// 监听对话框关闭
watch(dialogVisible, (newVal) => {
  if (!newVal) {
    // 清理预览URL
    if (courseForm.coverImage && courseForm.coverImage.startsWith('blob:')) {
      URL.revokeObjectURL(courseForm.coverImage)
    }
    // 重置表单
    formRef.value?.resetFields()
  }
})

// 处理排序变化
const handleSortChange = ({ prop, order }: { prop: string, order: string }) => {
  sortConfig.prop = prop
  sortConfig.order = order
  
  // 根据排序规则对数据进行排序
  if (prop && order) {
    courseList.value.sort((a: any, b: any) => {
      if (order === 'ascending') {
        return prop === 'id' 
          ? a[prop] - b[prop]
          : new Date(a[prop]).getTime() - new Date(b[prop]).getTime()
      } else {
        return prop === 'id'
          ? b[prop] - a[prop]
          : new Date(b[prop]).getTime() - new Date(a[prop]).getTime()
      }
    })
  } else {
    // 如果取消排序，恢复原始顺序
    courseList.value = [...originalCourseList.value]
  }
}

// 初始化
onMounted(() => {
  fetchCourseList()
})
</script>

<style lang="scss" scoped>
.courses-container {
  padding: 20px;
  background: #fff;
  border-radius: 4px;
  min-height: calc(100vh - 100px);

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .title {
      font-size: 20px;
      font-weight: 600;
      color: #1f2f3d;
    }

    .actions {
      display: flex;
      gap: 12px;
      align-items: center;

      .search-input {
        width: 200px;
      }
    }
  }

  .pagination {
    margin-top: 20px;
    padding: 16px;
    display: flex;
    justify-content: flex-end;
    background-color: var(--el-fill-color-blank);
    border-radius: 4px;
  }
}

.cover-upload {
  .cover-uploader {
    border: 1px dashed var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: var(--el-transition-duration-fast);

    &:hover {
      border-color: var(--el-color-primary);
    }

    .cover {
      width: 200px;
      height: 150px;
      display: block;
      object-fit: cover;
    }

    .cover-uploader-icon {
      font-size: 28px;
      color: #8c939d;
      width: 200px;
      height: 150px;
      text-align: center;
      line-height: 150px;
    }
  }
}
</style> 