import {createRouter, createWebHistory} from 'vue-router'
import MainLayout from '../layouts/MainLayout.vue'

const router = createRouter({
    history: createWebHistory(),
    routes: [
        {
            path: '/login',
            name: 'Login',
            component: () => import('@/views/login/index.vue'),
            meta: {
                title: '登录'
            }
        },
        {
            path: '/',
            component: MainLayout,
            redirect: '/dashboard',
            children: [
                {
                    path: 'dashboard',
                    name: 'Dashboard',
                    component: () => import('@/views/dashboard/index.vue'),
                    meta: {
                        title: '首页'
                    }
                },
                {
                    path: 'users',
                    component: () => import('@/views/Users/index.vue'),
                    meta: {
                        title: '用户管理'
                    }
                },
                {
                    path: '/courses',
                    component: () => import('@/views/courses/index.vue'),
                    meta: {
                        title: '课程管理'
                    }
                },
                {
                    path: '/chapters',
                    name: 'Chapters',
                    component: () => import('@/views/chapters/index.vue'),
                    meta: {
                        title: '章节管理',
                    }
                },
                {
                    path: '/exams',
                    name: 'Exams',
                    component: () => import('@/views/exams/index.vue'),
                    meta: {
                        title: '试卷管理',
                    }
                },
                {
                    path: '/vocabulary',
                    component: () => import('@/views/vocabulary/index.vue'),
                    meta: {
                        title: '词汇管理'
                    }
                },
                {
                    path: '/posts',
                    component: () => import('@/views/posts/index.vue'),
                    meta: {
                        title: '帖子管理'
                    }
                },
                {
                    path: '/user-answers',
                    component: () => import('@/views/userAnswers/index.vue'),
                    meta: {
                        title: '用户作答管理'
                    }
                },
                {
                    path: '/study-records',
                    component: () => import('@/views/studyRecords/index.vue'),
                    meta: {
                        title: '学习记录管理'
                    }
                }
            ]
        },
        {
            path: '/403',
            name: '403',
            component: () => import('@/views/error/403.vue'),
            meta: {
                title: '无权限'
            }
        },
        {
            path: '/:pathMatch(.*)*',
            name: '404',
            component: () => import('@/views/error/404.vue'),
            meta: {
                title: '页面不存在'
            }
        },
    ]
})

export default router 