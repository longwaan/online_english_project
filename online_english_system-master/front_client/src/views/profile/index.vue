<script setup lang="ts">
import { ref, computed, reactive, onMounted } from 'vue'
import { useUserStore } from '@/stores/modules/user'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Check,
  Warning,
  User,
  Lock,
  Edit,
  Upload,
  Calendar,
  Message,
  Reading,
  Collection,
  EditPen,
  DataAnalysis,
  Plus,
  ArrowDown,
  SwitchButton,
  Connection
} from '@element-plus/icons-vue'
import { useRouter } from 'vue-router'
// import {
//   updateUserInfo,
//   changePassword,
//   uploadAvatar,
//   getUserIp
// } from '@/api/user'
import axios from "axios";
// import { getStudyDetail } from '@/api/statistics'
import { changePassword, getUserIp, updateUserInfo, uploadAvatar } from '@/api/user/index'
import { getStudyDetail } from '@/api/statistics/index'

const userStore = useUserStore()
const userInfo = computed(() => userStore.userInfo)
const router = useRouter()

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

// 表单数据
const form = ref({
  userName: userInfo.value?.userName || '',
  userProfile: userInfo.value?.userProfile || '',
  userAvatar: userInfo.value?.userAvatar || ''
})

// 表单验证规则
const rules = reactive({
  userName: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 2, max: 20, message: '长度在 2 到 20 个字符', trigger: 'blur' }
  ]
})

// 表单引用
const formRef = ref<any>(null)

// 处理表单提交
const handleSubmit = async () => {
  if (!formRef.value) return

  try {
    await formRef.value.validate()

    // 显示加载提示
    const loadingMessage = ElMessage({
      type: 'info',
      message: '正在更新个人信息...',
      duration: 0
    })

    // 调用API更新用户信息
    const result = await updateUserInfo({
      id: userInfo.value?.id,
      userName: form.value.userName,
      userProfile: form.value.userProfile
    })

    // 关闭加载提示
    loadingMessage.close()

    if (result.code !== 0) {
      throw new Error(result.message || '更新失败')
    }

    // 更新用户信息
    userStore.updateUserInfo({
      userName: form.value.userName,
      userProfile: form.value.userProfile
    })

    // 显示成功消息
    ElMessage({
      type: 'success',
      message: '个人信息更新成功',
      duration: 2000
    })

    // 关闭对话框
    dialogVisible.value = false
  } catch (error: any) {
    ElMessage.error('更新失败：' + (error.message || '未知错误'))
  }
}

// 处理修改密码
const handleChangePassword = () => {
  ElMessageBox.prompt('请输入当前密码', '修改密码', {
    confirmButtonText: '下一步',
    cancelButtonText: '取消',
    inputType: 'password',
    inputPattern: /^.{6,20}$/,
    inputErrorMessage: '密码长度应为6-20个字符'
  }).then(({ value: oldPassword }) => {
    // 获取到旧密码后，再次弹窗获取新密码
    ElMessageBox.prompt('请输入新密码', '修改密码', {
      confirmButtonText: '确认',
      cancelButtonText: '取消',
      inputType: 'password',
      inputPattern: /^.{6,20}$/,
      inputErrorMessage: '密码长度应为6-20个字符'
    }).then(async ({ value: newPassword }) => {
      try {
        // 显示加载提示
        const loadingMessage = ElMessage({
          type: 'info',
          message: '正在修改密码...',
          duration: 0
        })

        // 调用修改密码API
        const result = await changePassword({
          userName: userInfo.value?.userName || '',
          userOldPassword: oldPassword,
          userNewPassword: newPassword,
          checkPassword: newPassword
        })

        // 关闭加载提示
        loadingMessage.close()

        if (result.code !== 0) {
          throw new Error(result.message || '修改密码失败')
        }

        // 显示成功消息
        ElMessage({
          type: 'success',
          message: '密码修改成功，请重新登录',
          duration: 2000
        })

        // 密码修改成功后，退出登录
        setTimeout(async () => {
          await userStore.userLogout()
          router.push('/login')
        }, 2000)
      } catch (error: any) {
        ElMessage.error('修改密码失败: ' + (error.message || '未知错误'))
      }
    }).catch(() => {
      // 用户取消输入新密码
    })
  }).catch(() => {
    // 用户取消输入旧密码
  })
}

// 处理上传头像
const handleAvatarUpload = async (e: Event) => {
  const file = (e.target as HTMLInputElement).files?.[0]
  if (!file) return

  try {
    // 创建 FormData 对象
    const formData = new FormData()
    formData.append('file', file)

    // 显示上传中提示
    const loadingMessage = ElMessage({
      type: 'info',
      message: '头像上传中...',
      duration: 0
    })

    // 调用上传接口
    const result = await uploadAvatar(formData)

    // 关闭上传中提示
    loadingMessage.close()

    if (result.code !== 0) {
      throw new Error(result.message || '上传失败')
    }

    // 更新用户头像
    userStore.updateUserAvatar(result.data)

    // 更新表单中的头像值
    form.value.userAvatar = result.data

    // 显示成功消息
    ElMessage.success('头像上传成功')
  } catch (error: any) {
    ElMessage.error('头像上传失败: ' + (error.message || '未知错误'))
  } finally {
    // 清空文件输入，以便下次选择同一文件时也能触发change事件
    (e.target as HTMLInputElement).value = ''
  }
}

// 活动标签
const activeTab = ref('basic')

// 学习统计数据
const learningStats = reactive({
  courses: 0,
  vocabulary: 0,
  quizzes: 0,
  totalCourseTime: 0,
  vocabularyTimes: 0,
  examAvgScore: 0
})

// 获取学习统计数据
const fetchLearningStats = async () => {
  try {
    const res = await getStudyDetail()
    if (res.code === 0 && res.data) {
      learningStats.courses = Number(res.data.courseCount)
      learningStats.vocabulary = Number(res.data.vocabularyCount)
      learningStats.quizzes = Number(res.data.examCount)
      learningStats.totalCourseTime = res.data.totalCourseTime
      learningStats.vocabularyTimes = Number(res.data.vocabularyTimes)
      learningStats.examAvgScore = res.data.examAvgScore
    }
  } catch (error) {
    console.error('获取学习统计数据失败:', error)
    ElMessage.error('获取学习统计数据失败')
  }
}

// 确保左右两侧高度一致
const leftSideHeight = ref('auto')
const rightSideRef = ref<HTMLElement | null>(null)

// 对话框可见性
const dialogVisible = ref(false)

// 文件上传引用
const fileInputRef = ref<HTMLInputElement | null>(null)

// 触发文件选择
const triggerFileSelect = () => {
  if (fileInputRef.value) {
    fileInputRef.value.click()
  }
}

// 用户 IP 地址

const ipInfo = ref({})

// 获取用户 IP
const fetchUserIp = async () => {
  try {
    const res = await getUserIp()
    if (res.code === 0 && res.data) {
      ipInfo.value = res.data
      axios.get(`/city?ip=${ipInfo.value.publicIpAddress}&json=true`).then(res => {
        ipInfo.value.pro = res.data.pro
        ipInfo.value.city = res.data.city
        ipInfo.value.addr = res.data.addr
      })
      console.log(ipInfo.value)
    } else {
      ipInfo.value = '未知 IP'
    }
  } catch (error) {
    console.error('获取用户 IP 失败:', error)
    ipInfo.value = '未知 IP'
  }
}

onMounted(() => {
  // 在组件挂载后，设置左侧高度与右侧一致
  setTimeout(() => {
    if (rightSideRef.value) {
      leftSideHeight.value = `${rightSideRef.value.clientHeight}px`
    }
  }, 100)

  // 获取用户 IP
  fetchUserIp()

  // 获取学习统计数据
  fetchLearningStats()
})
</script>

<template>
  <div class="profile-container">
    <el-row :gutter="20">
      <!-- 左侧用户信息卡片 -->
      <el-col :xs="24" :sm="8" :md="6" :lg="5">
        <el-card class="user-card" shadow="hover" :style="{ height: leftSideHeight }">
          <div class="user-card-header">
            <!-- 隐藏的文件输入 -->
            <input type="file" ref="fileInputRef" @change="handleAvatarUpload" accept="image/*" style="display: none" />

            <!-- 可点击的头像 -->
            <div class="avatar-wrapper" @click="triggerFileSelect">
              <el-avatar :size="100" :src="userAvatar" class="large-avatar">
                {{ userInfo?.userName?.charAt(0)?.toUpperCase() || 'U' }}
              </el-avatar>
              <div class="avatar-overlay">
                <el-icon>
                  <Upload />
                </el-icon>
                <span>更换头像</span>
              </div>
            </div>

            <h3 class="user-name">{{ userInfo?.userName || '用户' }}
              <el-tooltip effect="dark" placement="bottom"
                :content="`IP: ${ipInfo.publicIpAddress} | 地址: ${ipInfo.addr}`">
                <el-tag class="ip-tag" type="info" effect="plain">
                  <span class="ip-label">IP：</span>
                  <span class="ip-text">{{ ipInfo.pro }}</span>
                </el-tag>
              </el-tooltip>
            </h3>

            <el-tag type="success" size="small" effect="dark" class="role-tag">
              {{ userInfo?.userRole === 'admin' ? '管理员' : '普通用户' }}
            </el-tag>
          </div>

          <div class="user-info-list">
            <div class="info-item">
              <el-icon>
                <Calendar />
              </el-icon>
              <span>注册于 {{ new Date(userInfo?.createTime || '').toLocaleDateString() }}</span>
            </div>
            <div class="info-item">
              <el-icon>
                <Message />
              </el-icon>
              <span class="user-profile">{{ userInfo?.userProfile || '这个人很懒，什么都没留下' }}</span>
            </div>
          </div>

          <div class="quick-stats">
            <div class="stat-item">
              <div class="stat-number">{{ learningStats.courses }}</div>
              <div class="stat-title">课程</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">{{ learningStats.vocabulary }}</div>
              <div class="stat-title">词汇</div>
            </div>
            <div class="stat-item">
              <div class="stat-number">{{ learningStats.quizzes }}</div>
              <div class="stat-title">测验</div>
            </div>
          </div>
        </el-card>
      </el-col>

      <!-- 右侧内容区域 -->
      <el-col :xs="24" :sm="16" :md="18" :lg="19" ref="rightSideRef">
        <el-card class="content-card" shadow="hover">
          <template #header>
            <div class="card-header">
              <h2 class="section-title">
                <el-icon>
                  <User />
                </el-icon>
                个人中心
              </h2>
              <div class="header-actions">
                <el-button type="primary" @click="dialogVisible = true" plain>
                  <el-icon>
                    <Edit />
                  </el-icon>
                  修改资料
                </el-button>
                <el-button type="warning" @click="handleChangePassword" plain>
                  <el-icon>
                    <Lock />
                  </el-icon>
                  修改密码
                </el-button>
              </div>
            </div>
          </template>

          <div class="user-info-panel">
            <el-descriptions :column="2" border>
              <el-descriptions-item label="用户名" label-align="right">
                <el-tag size="default">{{ userInfo?.userName || '未设置' }}</el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="角色" label-align="right">
                <el-tag type="success" effect="dark">
                  {{ userInfo?.userRole === 'admin' ? '管理员' : '普通用户' }}
                </el-tag>
              </el-descriptions-item>
              <el-descriptions-item label="注册时间" label-align="right">
                {{ new Date(userInfo?.createTime || '').toLocaleString() }}
              </el-descriptions-item>
              <el-descriptions-item label="最后登录" label-align="right">
                {{ new Date().toLocaleString() }}
              </el-descriptions-item>
              <el-descriptions-item label="个人简介" :span="2" label-align="right">
                {{ userInfo?.userProfile || '这个人很懒，什么都没留下' }}
              </el-descriptions-item>
            </el-descriptions>
          </div>

          <el-divider content-position="center">学习统计</el-divider>

          <div class="statistics-section">
            <el-row :gutter="20">
              <el-col :span="8">
                <el-card class="stat-card" shadow="hover">
                  <template #header>
                    <div class="stat-header">
                      <el-icon>
                        <Reading />
                      </el-icon>
                      <span>课程</span>
                    </div>
                  </template>
                  <div class="stat-value">{{ learningStats.courses }}</div>
                  <div class="stat-label">已学习课程</div>
                  <el-progress :percentage="Math.round(learningStats.totalCourseTime / 60)"
                    :format="() => `${Math.round(learningStats.totalCourseTime / 60)}小时`" class="stat-progress"></el-progress>
                </el-card>
              </el-col>

              <el-col :span="8">
                <el-card class="stat-card" shadow="hover">
                  <template #header>
                    <div class="stat-header">
                      <el-icon>
                        <Collection />
                      </el-icon>
                      <span>词汇</span>
                    </div>
                  </template>
                  <div class="stat-value">{{ learningStats.vocabulary }}</div>
                  <div class="stat-label">已掌握词汇</div>
                  <el-progress :percentage="learningStats.vocabularyTimes" :format="() => `${learningStats.vocabularyTimes}个`" class="stat-progress"></el-progress>
                </el-card>
              </el-col>

              <el-col :span="8">
                <el-card class="stat-card" shadow="hover">
                  <template #header>
                    <div class="stat-header">
                      <el-icon>
                        <EditPen />
                      </el-icon>
                      <span>测验</span>
                    </div>
                  </template>
                  <div class="stat-value">{{ learningStats.quizzes }}</div>
                  <div class="stat-label">已完成测验</div>
                  <el-progress :percentage="learningStats.examAvgScore" :format="() => `${learningStats.examAvgScore}%`" class="stat-progress"></el-progress>
                </el-card>
              </el-col>
            </el-row>

            <div class="chart-container">
              <el-empty description="更多学习数据即将上线" :image-size="120"></el-empty>
            </div>
          </div>
        </el-card>
      </el-col>
    </el-row>

    <!-- 修改资料对话框 -->
    <el-dialog v-model="dialogVisible" title="修改个人资料" width="500px" :close-on-click-modal="false">
      <el-form ref="formRef" :model="form" :rules="rules" label-width="100px" class="profile-form">
        <el-form-item label="用户名" prop="userName">
          <el-input v-model="form.userName" placeholder="请输入用户名" prefix-icon="User"></el-input>
        </el-form-item>

        <el-form-item label="个人简介">
          <el-input v-model="form.userProfile" type="textarea" :rows="4" placeholder="请输入个人简介" show-word-limit
            maxlength="200"></el-input>
        </el-form-item>
      </el-form>

      <template #footer>
        <span class="dialog-footer">
          <el-button @click="dialogVisible = false">取消</el-button>
          <el-button type="primary" @click="handleSubmit">
            <el-icon>
              <Check />
            </el-icon>
            保存
          </el-button>
        </span>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.profile-container {
  padding: 20px;
}

// 标题样式
.section-title {
  font-size: 20px;
  font-weight: 600;
  margin: 0;
  color: #303133;
  display: flex;
  align-items: center;

  .el-icon {
    margin-right: 8px;
  }
}

// 卡片头部样式
.card-header {
  display: flex;
  justify-content: space-between;
  align-items: center;

  .header-actions {
    display: flex;
    gap: 10px;
  }
}

// 用户卡片样式
.user-card {
  margin-bottom: 20px;
  display: flex;
  flex-direction: column;

  .user-card-header {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 20px 0;

    .avatar-wrapper {
      position: relative;
      cursor: pointer;
      border-radius: 50%;
      overflow: hidden;
      margin-bottom: 15px;

      .large-avatar {
        background-color: #409EFF;
        color: #fff;
        font-size: 36px;
        transition: all 0.3s;
      }

      .avatar-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        opacity: 0;
        transition: opacity 0.3s;
        color: white;

        .el-icon {
          font-size: 24px;
          margin-bottom: 5px;
        }

        span {
          font-size: 12px;
        }
      }

      &:hover {
        .avatar-overlay {
          opacity: 1;
        }

        .large-avatar {
          filter: blur(1px);
        }
      }
    }

    .user-name {
      font-size: 18px;
      font-weight: 600;
      margin: 10px 0 5px;
    }


    .role-tag {
      margin-bottom: 10px;
    }
  }

  .user-info-list {
    padding: 15px;

    .info-item {
      display: flex;
      align-items: flex-start;
      margin-bottom: 10px;
      font-size: 14px;
      color: #606266;

      .el-icon {
        margin-right: 8px;
        margin-top: 3px;
        color: #909399;
      }

      .user-profile {
        word-break: break-word;
        line-height: 1.5;
      }
    }
  }

  .quick-stats {
    margin-top: auto;
    display: flex;
    justify-content: space-around;
    padding: 15px 0;
    background-color: #f5f7fa;
    border-radius: 4px;

    .stat-item {
      text-align: center;

      .stat-number {
        font-size: 20px;
        font-weight: bold;
        color: #409EFF;
      }

      .stat-title {
        font-size: 12px;
        color: #909399;
        margin-top: 5px;
      }
    }
  }
}

// 内容卡片样式
.content-card {
  margin-bottom: 20px;
}

// 用户信息面板
.user-info-panel {
  margin: 20px 0;
}

// 表单样式
.profile-form {
  max-width: 600px;
  margin: 20px auto;
}

// 统计卡片样式
.statistics-section {
  padding: 20px 0;

  .stat-card {
    text-align: center;
    transition: transform 0.3s;
    height: 100%;

    &:hover {
      transform: translateY(-5px);
    }

    .stat-header {
      display: flex;
      align-items: center;
      justify-content: center;

      .el-icon {
        margin-right: 5px;
      }
    }

    .stat-value {
      font-size: 36px;
      font-weight: bold;
      color: #409EFF;
      margin: 15px 0 5px;
    }

    .stat-label {
      color: #909399;
      font-size: 14px;
      margin-bottom: 15px;
    }

    .stat-progress {
      margin-top: 10px;
    }
  }

  .chart-container {
    margin-top: 30px;
    height: 200px;
    display: flex;
    align-items: center;
    justify-content: center;
  }
}

// 响应式调整
@media (max-width: 768px) {
  .user-card {
    margin-bottom: 20px;
    height: auto !important;
  }

  .card-header {
    flex-direction: column;
    align-items: flex-start;

    .header-actions {
      margin-top: 10px;
    }
  }
}

.stats-grid {
  .stat-item {
    .stat-extra {
      font-size: 12px;
      color: #909399;
      margin-top: 4px;
    }
  }
}
</style>