<script setup lang="ts">
import {ref, computed, onMounted, watch} from 'vue'
import {useRouter, useRoute} from 'vue-router'
import {useUserStore} from '@/stores/modules/user'
import {ElMessageBox} from 'element-plus'
import * as ElementPlusIcons from '@element-plus/icons-vue'
import {
  Expand,
  Fold,
  User,
  Setting,
  ArrowDown,
  SwitchButton, Reading
} from '@element-plus/icons-vue'

const router = useRouter()
const route = useRoute()
const userStore = useUserStore()

// 环境变量
const apiUrl = import.meta.env.VITE_API_URL || ''

// 用户信息
const userInfo = computed(() => userStore.userInfo)

// 获取完整的头像URL
const getFullAvatarUrl = (avatarPath: string | undefined) => {
  if (!avatarPath) return ''
  if (avatarPath.startsWith('http')) return avatarPath
  return `${apiUrl}${avatarPath}`
}

// 用户头像
const userAvatar = computed(() => getFullAvatarUrl(userInfo.value?.userAvatar))

// 导航菜单
const activeIndex = ref('')

// 菜单项配置
const menuItems = [
  {index: '1', name: '首页', path: '/dashboard', icon: 'HomeFilled'},
  {index: '2', name: '课程学习', path: '/courses', icon: 'Reading'},
  {index: '3', name: '词汇学习', path: '/vocabulary', icon: 'Collection'},
  {index: '4', name: '测验', path: '/exam', icon: 'EditPen'},
  {index: '5', name: '学习讨论', path: '/posts', icon: 'ChatDotRound'},
  {index: '6', name: '统计分析', path: '/statistics', icon: 'DataAnalysis'}
]

// 根据当前路由路径设置激活的菜单项
const setActiveMenu = () => {
  const currentPath = route.path
  const matchedItem = menuItems.find(item =>
      currentPath === item.path || currentPath.startsWith(`${item.path}/`)
  )
  activeIndex.value = matchedItem ? matchedItem.index : ''
}

// 监听路由变化
watch(() => route.path, () => {
  setActiveMenu()
}, {immediate: true})

// 处理导航点击
const handleSelect = (key: string) => {
  const selectedItem = menuItems.find(item => item.index === key)
  if (selectedItem) {
    router.push(selectedItem.path)
  }
}

// 处理用户菜单命令
const handleCommand = (command: string) => {
  if (command === 'profile') {
    router.push('/profile')
  } else if (command === 'logout') {
    handleLogout()
  }
}

// 处理退出登录
const handleLogout = () => {
  ElMessageBox.confirm('确定要退出登录吗?', '提示', {
    confirmButtonText: '确定',
    cancelButtonText: '取消',
    type: 'warning'
  }).then(async () => {
    await userStore.userLogout()
    router.push('/login')
  }).catch(() => {
  })
}

// 组件挂载时设置激活菜单
onMounted(() => {
  setActiveMenu()
})
</script>

<template>
  <div class="layout-container">
    <!-- 顶部导航栏 -->
    <header class="header">
      <div class="header-container">
        <!-- Logo 和网站名称 -->
        <div class="logo" @click="router.push('/')">
          <el-icon class="logo-img">
            <Reading/>
          </el-icon>
          <h1 class="site-title">在线英语知识学习平台</h1>
        </div>

        <!-- 导航菜单 -->
        <el-menu
            :default-active="activeIndex"
            class="nav-menu"
            mode="horizontal"
            @select="handleSelect"
            background-color="#ffffff"
            text-color="#333333"
            active-text-color="#409EFF"
        >
          <el-menu-item v-for="item in menuItems" :key="item.index" :index="item.index">
            <el-icon>
              <component :is="ElementPlusIcons[item.icon]"/>
            </el-icon>
            <span>{{ item.name }}</span>
          </el-menu-item>
        </el-menu>

        <!-- 用户信息和头像 -->
        <div class="user-info">
          <el-dropdown trigger="hover" @command="handleCommand">
            <div class="avatar-container">
              <el-avatar
                  :size="40"
                  :src="userAvatar"
                  class="user-avatar"
              >
                {{ userInfo?.userName?.charAt(0)?.toUpperCase() || 'U' }}
              </el-avatar>
              <span class="username">{{ userInfo?.userName || '用户' }}</span>
              <el-icon class="el-icon--right">
                <ArrowDown/>
              </el-icon>
            </div>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item command="profile">
                  <el-icon>
                    <User/>
                  </el-icon>
                  个人中心
                </el-dropdown-item>
                <el-dropdown-item divided command="logout">
                  <el-icon>
                    <SwitchButton/>
                  </el-icon>
                  退出登录
                </el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
      </div>
    </header>

    <!-- 主要内容区域 -->
    <main class="main-content">
      <router-view/>
    </main>
  </div>
</template>

<style scoped lang="scss">
.layout-container {
  display: flex;
  flex-direction: column;
  min-height: 100vh;
  background-color: #f5f7fa;
}

.header {
  background-color: #ffffff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
}

.header-container {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 20px;
  height: 60px;
  max-width: 1400px;
  margin: 0 auto;
}

.logo {
  display: flex;
  align-items: center;
  cursor: pointer;
}

.logo-img {
  font-size: 32px;
  color: #03a9f4;
  margin-right: 10px;
}

.site-title {
  font-size: 18px;
  font-weight: 600;
  color: #333;
  margin: 0;
}

.nav-menu {
  flex: 1;
  display: flex;
  justify-content: center;
  border-bottom: none;
}

.user-info {
  display: flex;
  align-items: center;
}

.avatar-container {
  display: flex;
  align-items: center;
  cursor: pointer;
  padding: 0 8px;
  border-radius: 4px;
  transition: background-color 0.3s;
}

.avatar-container:hover {
  background-color: #f5f7fa;
}

.user-avatar {
  margin-right: 8px;
  background-color: #409EFF;
  color: #fff;
}

.username {
  font-size: 14px;
  color: #333;
  margin-right: 4px;
}

.main-content {
  margin-top: 60px;
  padding: 20px;
  flex: 1;
  max-width: 1400px;
  width: 100%;
  margin-left: auto;
  margin-right: auto;
}

.el-menu-item {
  .el-icon {
    margin-right: 5px;
    vertical-align: middle;
  }
}
</style> 