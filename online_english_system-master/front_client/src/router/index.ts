import {createRouter, createWebHistory} from 'vue-router'

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
            component: () => import('@/layout/index.vue'),
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
                    path: 'courses',
                    name: 'Courses',
                    component: () => import('@/views/courses/index.vue'),
                    meta: {
                        title: '课程学习',
                        requiresAuth: true
                    }
                },
                {
                    path: 'vocabulary',
                    name: 'Vocabulary',
                    component: () => import('@/views/vocabulary/index.vue'),
                    meta: {
                        title: '词汇学习'
                    }
                },
                {
                    path: 'exam',
                    name: 'Exam',
                    component: () => import('@/views/exam/index.vue'),
                    meta: {
                        title: '测验'
                    }
                },
                {
                    path: 'statistics',
                    name: 'Statistics',
                    component: () => import('@/views/statistics/index.vue'),
                    meta: {
                        title: '统计分析'
                    }
                },
                {
                    path: 'profile',
                    name: 'Profile',
                    component: () => import('@/views/profile/index.vue'),
                    meta: {
                        title: '个人中心'
                    }
                },
                {
                    path: 'courses/:id',
                    name: 'CourseDetail',
                    component: () => import('@/views/courses/detail.vue'),
                    meta: {
                        title: '课程详情',
                        requiresAuth: true
                    }
                },
                {
                    path: '/posts',
                    name: 'Posts',
                    component: () => import('@/views/posts/index.vue'),
                    meta: {
                        title: '学习讨论',
                        requiresAuth: true
                    }
                },
                {
                    path: '/posts/:id',
                    name: 'PostDetail',
                    component: () => import('@/views/posts/detail.vue'),
                    meta: {
                        title: '帖子详情',
                        requiresAuth: true
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
        {
            path: '/demo',
            component: () => import('@/views/vocabulary/demo.vue'),
            meta: {
                title: 'Demo'
            }
        }
    ]
})

export default router 