<template>
  <el-aside :width="isCollapse ? '64px' : '22px'" class="aside">
    <div class="logo">
      <el-icon class="logo-icon"><Reading /></el-icon>
      <span v-show="!isCollapse">英语知识在线学习系统后台</span>
    </div>
    <el-menu
      :collapse="isCollapse"
      :default-active="activeMenu"
      router
      class="el-menu-vertical"
      background-color="#1a1f37"
      text-color="rgba(255,255,255,0.7)"
      active-text-color="#fff"
    >
      <el-menu-item index="/dashboard">
        <el-icon><Odometer /></el-icon>
        <template #title>仪表盘</template>
      </el-menu-item>
      <el-menu-item index="/users">
        <el-icon><User /></el-icon>
        <template #title>用户管理</template>
      </el-menu-item>
      <el-menu-item index="/courses">
        <el-icon><Reading /></el-icon>
        <template #title>课程管理</template>
      </el-menu-item>
      <el-menu-item index="/chapters">
        <el-icon><Document /></el-icon>
        <template #title>章节管理</template>
      </el-menu-item>
      <el-menu-item index="/exams">
        <el-icon><Edit /></el-icon>
        <template #title>试卷管理</template>
      </el-menu-item>
      <el-menu-item index="/vocabulary">
        <el-icon><Collection /></el-icon>
        <template #title>词汇管理</template>
      </el-menu-item>
      <el-menu-item index="/posts">
        <el-icon><ChatDotRound /></el-icon>
        <template #title>帖子管理</template>
      </el-menu-item>
      <el-menu-item index="/user-answers">
        <el-icon><Document /></el-icon>
        <template #title>用户作答管理</template>
      </el-menu-item>
      <el-menu-item index="/study-records">
        <el-icon><Histogram /></el-icon>
        <template #title>学习记录管理</template>
      </el-menu-item>
    </el-menu>
  </el-aside>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  Odometer,
  User,
  Goods,
  List,
  Setting,
  Monitor,
  Reading,
  Document,
  Edit,
  Collection,
  ChatDotRound,
  Histogram
} from '@element-plus/icons-vue'

defineProps<{
  isCollapse: boolean
}>()

const route = useRoute()
const activeMenu = computed(() => route.path)
</script>

<style scoped>
.aside {
  background-color: #1a1f37;
  transition: all 0.3s;
  overflow: hidden;
  height: 100%;
  width: 100%;
  box-shadow: 2px 0 8px rgba(0,0,0,0.15);
}

.logo {
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: center;
  text-align: center;
  padding: 0 20px;
  color: #fff;
  font-size: 18px;
  font-weight: 600;
  /* white-space: nowrap; */
  background-color: #141829;
}

.logo-icon {
  font-size: 30px;
  margin-right: 12px;
  color: #3699ff;
}

.el-menu-vertical {
  border-right: none;
  height: calc(100vh - 60px);
}

.el-menu-vertical:not(.el-menu--collapse) {
  width: 240px;
}

:deep(.el-menu-item) {
  height: 50px;
  line-height: 50px;
  justify-content: center;
  padding-left:0!important;
  padding-right:45px!important;
  &.is-active {
    background-color: #3699ff !important;
  }
  
  &:hover {
    background-color: #3699ff !important;
    color: #fff !important;
  }

  .el-icon {
    color: rgba(255,255,255,0.7);
  }

  &.is-active .el-icon {
    color: #fff;
  }
}

:deep(.el-menu-item .el-icon) {
  font-size: 18px;
}
</style> 