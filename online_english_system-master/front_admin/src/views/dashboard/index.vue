<template>
  <div class="dashboard">
    <!-- 数据概览卡片 -->
    <el-row :gutter="20" class="data-row">
      <el-col :span="6" v-for="(item, index) in statisticsData" :key="index">
        <div class="data-card" :class="`bg-gradient-${index}`">
          <div class="data-value">{{ item.value }}</div>
          <div class="data-info">
            <span class="data-title">{{ item.title }}</span>
            <div class="data-rate">{{ item.rate }}</div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 图表区域 -->
    <el-row :gutter="20" class="chart-row">
      <!-- 左侧折线图 -->
      <el-col :span="16">
        <div class="chart-card">
          <div class="chart-header">
            <div class="header-left">
              <span>访问趋势</span>
              <div class="header-stats">
                <div class="stat-item">
                  <span class="label">日均访问</span>
                  <span class="value">1,024</span>
                </div>
                <div class="divider"></div>
                <div class="stat-item">
                  <span class="label">同比增长</span>
                  <span class="value up">
                    <el-icon><ArrowUp /></el-icon>
                    12%
                  </span>
                </div>
              </div>
            </div>
            <el-radio-group v-model="timeRange" size="small">
              <el-radio-button label="week">周</el-radio-button>
              <el-radio-button label="month">月</el-radio-button>
              <el-radio-button label="year">年</el-radio-button>
            </el-radio-group>
          </div>
          <div ref="lineChartRef" class="chart"></div>
        </div>
      </el-col>

      <!-- 右侧饼图和分布 -->
      <el-col :span="8">
        <div class="chart-card">
          <div class="chart-header">
            <span>用户分布</span>
            <el-tag size="small" effect="plain">实时</el-tag>
          </div>
          <div class="distribution-content">
            <div ref="pieChartRef" class="dist-chart"></div>
            <div class="dist-list">
              <div class="dist-item" v-for="(item, index) in distributionData" :key="index">
                <div class="dist-header">
                  <span class="dist-name">{{ item.name }}</span>
                  <span class="dist-value">{{ item.value }}%</span>
                </div>
                <div class="dist-bar">
                  <div class="progress-outer">
                    <div class="progress-inner" 
                      :style="{ 
                        width: item.value + '%',
                        backgroundColor: item.color 
                      }"
                    ></div>
                  </div>
                  <span class="trend-value" :class="{ 'up': item.trend > 0, 'down': item.trend < 0 }">
                    {{ item.trend > 0 ? '+' : '' }}{{ item.trend }}%
                  </span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </el-col>
    </el-row>

    <!-- 底部统计卡片 -->
    <el-row :gutter="20" class="detail-row">
      <el-col :span="6" v-for="(item, index) in realtimeStats" :key="index">
        <div class="stat-card">
          <div class="stat-icon" :class="`icon-${index}`">
            <el-icon>
              <View v-if="item.type === 'view'" />
              <Timer v-else-if="item.type === 'timer'" />
              <Link v-else-if="item.type === 'link'" />
              <User v-else-if="item.type === 'user'" />
            </el-icon>
          </div>
          <div class="stat-info">
            <div class="stat-value">{{ item.value }}</div>
            <div class="stat-label">{{ item.label }}</div>
          </div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted, nextTick, watch, onActivated } from 'vue'
import * as echarts from 'echarts'
import { ArrowUp, ArrowDown, View, Timer, Link, User } from '@element-plus/icons-vue'

// 统计数据
const statisticsData = [
  { title: '总用户数', value: '12,846', rate: '12%' },
  { title: '月活用户', value: '8,562', rate: '8%' },
  { title: '订单总量', value: '1,286', rate: '5%' },
  { title: '营收额', value: '¥286,432', rate: '15%' }
]

const timeRange = ref('week')

// 区域分布数据
const distributionData = [
  { name: '华东地区', value: 35, trend: 2.5, color: '#3a84ff' },
  { name: '华北地区', value: 25, trend: 1.8, color: '#52c41a' },
  { name: '华南地区', value: 20, trend: -0.6, color: '#faad14' },
  { name: '西南地区', value: 15, trend: 3.2, color: '#ff4d4f' },
  { name: '其他地区', value: 5, trend: 0.8, color: '#909399' }
]

// 访问明细数据
const visitData = [
  {
    time: '2024-03-12 15:23:10',
    page: '首页',
    user: '张三',
    ip: '192.168.1.100',
    duration: '00:05:30'
  },
  {
    time: '2024-03-12 15:20:15',
    page: '用户管理',
    user: '李四',
    ip: '192.168.1.101',
    duration: '00:03:45'
  },
  {
    time: '2024-03-12 15:18:22',
    page: '数据统计',
    user: '王五',
    ip: '192.168.1.102',
    duration: '00:08:20'
  },
  {
    time: '2024-03-12 15:15:30',
    page: '系统设置',
    user: '赵六',
    ip: '192.168.1.103',
    duration: '00:02:15'
  }
]

// 实时统计数据
const realtimeStats = [
  { label: '实时访问', value: '235', type: 'view', trend: '+12' },
  { label: '平均停留', value: '00:03:12', type: 'timer', trend: '+8%' },
  { label: '跳出率', value: '28.5%', type: 'link', trend: '-2.3%' },
  { label: '在线用户', value: '126', type: 'user', trend: '+5' }
]

// 图表配置
const lineChartOption = {
  grid: {
    top: 10,
    right: 20,
    bottom: 20,
    left: 40,
    containLabel: true
  },
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255,255,255,0.9)',
    borderColor: '#e6e9ed',
    borderWidth: 1,
    textStyle: {
      color: '#666'
    }
  },
  xAxis: {
    type: 'category',
    data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'],
    boundaryGap: false,
    axisLine: {
      lineStyle: { color: '#e0e0e0' }
    },
    axisTick: { show: false }
  },
  yAxis: {
    type: 'value',
    axisLine: { show: false },
    axisTick: { show: false },
    splitLine: {
      lineStyle: { color: '#f5f5f5' }
    }
  },
  series: [{
    data: [800, 920, 900, 920, 1200, 1300, 1280],
    type: 'line',
    smooth: true,
    symbolSize: 8,
    lineStyle: { 
      width: 3,
      color: '#3a84ff'
    },
    areaStyle: {
      color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
        { offset: 0, color: 'rgba(58,132,255,0.3)' },
        { offset: 1, color: 'rgba(58,132,255,0.05)' }
      ])
    },
    itemStyle: {
      color: '#3a84ff',
      borderWidth: 2,
      borderColor: '#fff'
    }
  }]
}

const pieChartOption = {
  tooltip: {
    trigger: 'item',
    formatter: '{b}: {c}%'
  },
  legend: {
    show: false
  },
  series: [{
    type: 'pie',
    radius: ['65%', '85%'],
    center: ['50%', '50%'],
    data: distributionData.map(item => ({
      name: item.name,
      value: item.value,
      itemStyle: {
        color: item.color
      }
    })),
    label: {
      show: false
    },
    emphasis: {
      scale: true,
      scaleSize: 5
    }
  }]
}

// 迷你折线图配置
const miniLineChartOption = {
  grid: {
    top: 4,
    right: 10,
    bottom: 4,
    left: 10,
    containLabel: false
  },
  xAxis: {
    type: 'category',
    data: ['00:00', '03:00', '06:00', '09:00', '12:00', '15:00', '18:00', '21:00'],
    show: false
  },
  yAxis: {
    type: 'value',
    show: false
  },
  tooltip: {
    trigger: 'axis',
    backgroundColor: 'rgba(255,255,255,0.9)',
    borderColor: '#e6e9ed',
    borderWidth: 1,
    textStyle: {
      color: '#666'
    },
    formatter: '{b}<br/>访问量: {c}'
  },
  series: [{
    data: [820, 932, 901, 934, 1290, 1330, 1320, 1450],
    type: 'line',
    smooth: true,
    symbol: 'none',
    lineStyle: { 
      width: 2,
      color: '#3a84ff'
    },
    areaStyle: {
      color: new echarts.graphic.LinearGradient(0, 0, 0, 1, [
        { offset: 0, color: 'rgba(58,132,255,0.2)' },
        { offset: 1, color: 'rgba(58,132,255,0.02)' }
      ])
    }
  }]
}

// 图表实例
const lineChartRef = ref<HTMLElement>()
const pieChartRef = ref<HTMLElement>()
let lineChart: echarts.ECharts | null = null
let pieChart: echarts.ECharts | null = null

// 初始化图表
const initCharts = () => {
  // 确保DOM已经渲染
  nextTick(() => {
    if (lineChartRef.value) {
      lineChart = echarts.init(lineChartRef.value)
      lineChart.setOption(lineChartOption)
    }
    if (pieChartRef.value) {
      pieChart = echarts.init(pieChartRef.value)
      pieChart.setOption(pieChartOption)
    }
  })
}

// 窗口大小变化处理
const handleResize = () => {
  lineChart?.resize()
  pieChart?.resize()
}

// 监听路由变化，重新初始化图表
onActivated(() => {
  initCharts()
})

onMounted(() => {
  initCharts()
  window.addEventListener('resize', handleResize)
})

onUnmounted(() => {
  window.removeEventListener('resize', handleResize)
  lineChart?.dispose()
  pieChart?.dispose()
})

// 监听数据变化，更新图表
watch([timeRange], () => {
  nextTick(() => {
    lineChart?.setOption(lineChartOption)
    pieChart?.setOption(pieChartOption)
  })
})
</script>

<style scoped lang="scss">
.dashboard {
  padding: 20px;
  background-color: #f6f9fc;
  min-height: 100%;

  .data-row {
    margin-bottom: 20px;
  }

  .data-card {
    padding: 24px;
    border-radius: 12px;
    height: 120px;
    color: #fff;
    transition: transform 0.3s;

    &:hover {
      transform: translateY(-2px);
    }

    &.bg-gradient-0 { background: linear-gradient(135deg, #1890ff, #36b6ff); }
    &.bg-gradient-1 { background: linear-gradient(135deg, #52c41a, #73d13d); }
    &.bg-gradient-2 { background: linear-gradient(135deg, #faad14, #ffc53d); }
    &.bg-gradient-3 { background: linear-gradient(135deg, #ff4d4f, #ff7875); }

    .data-value {
      font-size: 32px;
      font-weight: bold;
      margin-bottom: 12px;
    }

    .data-info {
      display: flex;
      justify-content: space-between;
      align-items: center;

      .data-title {
        font-size: 15px;
        opacity: 0.9;
      }

      .data-rate {
        font-size: 14px;
        background: rgba(255, 255, 255, 0.2);
        padding: 4px 10px;
        border-radius: 12px;
      }
    }
  }

  .chart-row {
    margin-top: 20px;
  }

  .chart-card {
    background: #fff;
    border-radius: 12px;
    height: 480px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.06);

    .chart-header {
      padding: 20px 24px;
      border-bottom: 1px solid #f0f0f0;
      display: flex;
      justify-content: space-between;
      align-items: center;

      .header-left {
        display: flex;
        align-items: center;
        gap: 24px;

        span {
          font-size: 16px;
          font-weight: 500;
          color: #1f2937;
        }

        .header-stats {
          display: flex;
          align-items: center;
          gap: 16px;
          
          .stat-item {
            display: flex;
            align-items: center;
            gap: 8px;

            .label {
              font-size: 13px;
              color: #909399;
              font-weight: normal;
            }

            .value {
              font-size: 14px;
              font-weight: 500;
              color: #303133;
              display: flex;
              align-items: center;
              gap: 4px;

              &.up {
                color: #67c23a;
              }

              .el-icon {
                font-size: 12px;
              }
            }
          }

          .divider {
            width: 1px;
            height: 14px;
            background-color: #e0e0e0;
          }
        }
      }
    }

    .chart {
      height: calc(100% - 65px);
      width: 100%;
      padding: 24px;
    }

    .distribution-content {
      height: calc(100% - 65px);
      padding: 24px;
      display: flex;
      flex-direction: column;

      .dist-chart {
        height: 240px;
        width: 100%;
        margin-bottom: 24px;
      }

      .dist-list {
        .dist-item {
          margin-bottom: 16px;

          &:last-child {
            margin-bottom: 0;
          }

          .dist-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;

            .dist-name {
              font-size: 14px;
              color: #606266;
            }

            .dist-value {
              font-weight: 500;
              color: #303133;
            }
          }

          .dist-bar {
            display: flex;
            align-items: center;
            gap: 12px;

            .progress-outer {
              flex: 1;
              height: 6px;
              background-color: #f5f7fa;
              border-radius: 3px;
              overflow: hidden;

              .progress-inner {
                height: 100%;
                border-radius: 3px;
                transition: all 0.3s ease;
              }
            }

            .trend-value {
              font-size: 12px;
              min-width: 45px;
              text-align: right;

              &.up { color: #67c23a; }
              &.down { color: #f56c6c; }
            }
          }
        }
      }
    }
  }

  .detail-row {
    margin-top: 20px;

    .stat-card {
      background: #fff;
      border-radius: 12px;
      height: 150px;
      padding: 24px;
      display: flex;
      align-items: center;
      gap: 20px;
      transition: all 0.3s;
      cursor: pointer;

      &:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
      }

      .stat-icon {
        width: 56px;
        height: 56px;
        border-radius: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 24px;

        &.icon-0 {
          background: rgba(24, 144, 255, 0.1);
          color: #1890ff;
        }

        &.icon-1 {
          background: rgba(82, 196, 26, 0.1);
          color: #52c41a;
        }

        &.icon-2 {
          background: rgba(250, 173, 20, 0.1);
          color: #faad14;
        }

        &.icon-3 {
          background: rgba(255, 77, 79, 0.1);
          color: #ff4d4f;
        }
      }

      .stat-info {
        flex: 1;

        .stat-value {
          font-size: 28px;
          font-weight: 600;
          color: #1f2937;
          margin-bottom: 8px;
        }

        .stat-label {
          font-size: 14px;
          color: #666;
        }
      }
    }
  }
}
</style>