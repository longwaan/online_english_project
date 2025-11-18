<template>
  <el-header class="header" height="60px">
    <div class="header-left">
      <el-icon 
        class="collapse-btn"
        @click="emit('update:isCollapse', !isCollapse)"
      >
        <Fold v-if="!isCollapse"/>
        <Expand v-else/>
      </el-icon>
      <el-breadcrumb separator="/">
        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
        <el-breadcrumb-item>仪表盘</el-breadcrumb-item>
      </el-breadcrumb>
    </div>
    <div class="header-right">
      <el-input
        v-model="searchKeyword"
        placeholder="搜索..."
        :prefix-icon="Search"
        class="search-input"
      />
      <el-dropdown trigger="click" @command="handleCommand">
        <span class="user-info">
          <el-avatar 
            :size="32" 
            :src="avatarUrl" 
            class="user-avatar"
          />
          <span class="username">{{ userStore.userInfo?.userName || '未登录' }}</span>
          <el-icon class="el-icon--right"><CaretBottom /></el-icon>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="logout">
              <el-icon><SwitchButton /></el-icon>
              退出登录
            </el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </el-header>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { 
  Fold, 
  Expand, 
  Search, 
  SwitchButton,
  CaretBottom 
} from '@element-plus/icons-vue'
import { useUserStore } from '@/stores/modules/user'
import { ElMessage } from 'element-plus'

const props = defineProps<{
  isCollapse: boolean
}>()

const emit = defineEmits<{
  (e: 'update:isCollapse', value: boolean): void
}>()

const router = useRouter()
const userStore = useUserStore()
const searchKeyword = ref('')
const defaultAvatar = 'https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png'

const avatarUrl = computed(() => {
  if (!userStore.userInfo?.userAvatar) return defaultAvatar
  return `${import.meta.env.VITE_BASE_URL}${userStore.userInfo.userAvatar}`
})

const handleCommand = async (command: string) => {
  if (command === 'logout') {
    try {
      if (!userStore.isLogin) {
        ElMessage.warning('您还未登录')
        return
      }
      await userStore.userLogout()
      router.push('/login')
    } catch (error) {
      console.error('退出登录失败:', error)
    }
  }
}
</script>

<style scoped>
.header {
  background-color: #fff;
  border-bottom: 1px solid #edf2f7;
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 0 24px;
  height: 60px;
  box-sizing: border-box;
  box-shadow: 0 1px 4px rgba(0,0,0,0.05);
}

.header-left {
  display: flex;
  align-items: center;
  gap: 24px;
}

.collapse-btn {
  font-size: 20px;
  cursor: pointer;
  color: #64748b;
  transition: color 0.3s;
  
  &:hover {
    color: #3699ff;
  }
}

.header-right {
  display: flex;
  align-items: center;
  gap: 24px;
}

.search-input {
  width: 200px;
  transition: all 0.3s;
  
  &:focus-within {
    width: 250px;
  }

  :deep(.el-input__wrapper) {
    background-color: #f8fafc;
    box-shadow: none;
    border: 1px solid #e2e8f0;
    
    &:hover, &.is-focus {
      border-color: #3699ff;
      box-shadow: 0 0 0 1px rgba(54,153,255,0.1);
    }
  }
}

.user-info {
  display: flex;
  align-items: center;
  gap: 8px;
  cursor: pointer;
  padding: 0 12px;
  height: 48px;
  transition: all 0.3s;
  border-radius: 6px;
  
  &:hover {
    background-color: #f8fafc;
  }
}

.user-avatar {
  border: 2px solid #e2e8f0;
}

.username {
  font-size: 14px;
  color: #64748b;
}

:deep(.el-dropdown-menu) {
  padding: 8px 0;
  border: none;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
}

:deep(.el-dropdown-menu__item) {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  color: #64748b;
  
  .el-icon {
    margin-right: 4px;
    font-size: 16px;
  }

  &:hover {
    background-color: #f8fafc;
    color: #3699ff;
  }
}
</style> 