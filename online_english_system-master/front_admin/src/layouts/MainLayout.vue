<template>
    <el-container class="layout-container">
        <el-aside :width="isCollapse ? '64px' : '220px'" class="aside">
            <Sidebar :is-collapse="isCollapse" />
        </el-aside>
        <el-container>
            <el-header>
                <div class="header-left">
                    <el-icon class="collapse-btn" @click="isCollapse = !isCollapse">
                        <Fold v-if="!isCollapse" />
                        <Expand v-else />
                    </el-icon>
                    <el-breadcrumb>
                        <el-breadcrumb-item :to="{ path: '/' }">首页</el-breadcrumb-item>
                        <el-breadcrumb-item>{{ route.meta.title }}</el-breadcrumb-item>
                    </el-breadcrumb>
                </div>
                <div class="header-right">
                    <el-dropdown trigger="click">
                        <div class="user-info">
                            <el-avatar :size="32" :src="avatarUrl" :fallback="defaultAvatar"
                                @error="() => avatarUrl = defaultAvatar" />
                            <span class="username">{{ userName }}</span>
                            <el-icon>
                                <CaretBottom />
                            </el-icon>
                        </div>
                        <template #dropdown>
                            <el-dropdown-menu>
                                <el-dropdown-item divided @click="handleLogout">
                                    <el-icon>
                                        <SwitchButton />
                                    </el-icon>退出登录
                                </el-dropdown-item>
                            </el-dropdown-menu>
                        </template>
                    </el-dropdown>
                </div>
            </el-header>
            <el-main>
                <router-view />
            </el-main>
        </el-container>
    </el-container>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { Fold, Expand, CaretBottom, User, Setting, SwitchButton } from '@element-plus/icons-vue'
import { ElMessageBox } from 'element-plus'
import Sidebar from '@/components/Sidebar.vue'
import { useUserStore } from '@/stores/modules/user'
import defaultAvatar from '@/assets/avatar.jpg'

const route = useRoute()
const router = useRouter()
const isCollapse = ref(false)
const userStore = useUserStore()

// 获取用户信息
const userInfo = computed(() => userStore.userInfo)

// 获取头像URL
const getAvatarUrl = (avatar: string) => {
    if (!avatar) return defaultAvatar
    return `${import.meta.env.VITE_BASE_URL}${avatar}`
}

// 计算头像URL
const avatarUrl = computed(() => {
    const avatar = userInfo.value?.userAvatar
    if (!avatar) return defaultAvatar
    try {
        return getAvatarUrl(avatar)
    } catch (error) {
        console.error('头像URL处理错误:', error)
        return defaultAvatar
    }
})

// 用户名
const userName = computed(() => userInfo.value?.userName)

// 退出登录
const handleLogout = () => {
    ElMessageBox.confirm(
        '确定要退出登录吗？',
        '提示',
        {
            confirmButtonText: '确定',
            cancelButtonText: '取消',
            type: 'warning'
        }
    ).then(() => {
        userStore.userLogout().then(() => {
            router.push('/login')
        })
    })
}
</script>

<style scoped lang="scss">
.layout-container {
    height: 100vh;

    .aside {
        transition: width 0.3s;
        background-color: #001529;
    }

    .el-header {
        background-color: #fff;
        border-bottom: 1px solid #e6e6e6;
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 20px;

        .header-left {
            display: flex;
            align-items: center;
            gap: 16px;

            .collapse-btn {
                font-size: 20px;
                cursor: pointer;
                color: #666;
                transition: color 0.3s;

                &:hover {
                    color: var(--el-color-primary);
                }
            }

            .el-breadcrumb {
                line-height: 60px;
            }
        }

        .header-right {
            .user-info {
                display: flex;
                align-items: center;
                gap: 8px;
                cursor: pointer;
                padding: 4px 8px;
                border-radius: 4px;
                transition: all 0.3s;

                &:hover {
                    background-color: #f6f6f6;
                }

                .username {
                    font-size: 14px;
                    color: #333;
                }

                .el-icon {
                    font-size: 12px;
                    color: #666;
                }
            }
        }
    }

    .el-main {
        background-color: #f6f9fc;
        padding: 20px;
    }
}
</style>