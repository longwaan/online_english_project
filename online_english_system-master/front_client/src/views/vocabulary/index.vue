<script setup lang="ts">
import { ref, reactive, onMounted, computed } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import {
  Search,
  Refresh,
  SortDown,
  Collection,
  Reading,
  Edit,
  Document,
  ArrowRight,
  View,
  Microphone,
  Check,
  Close,
  Timer,
  Headset,
  VideoPlay,
  Picture
} from '@element-plus/icons-vue'
import {
  getVocabularyList,
  type VocabularyVO,
  type DifficultyLevel,
  type VocabularyType
} from '@/api/vocabulary'
import {
  checkVocabularyRecord,
  addStudyRecord,
  updateStudyRecordProgress,
  getStudyRecordById,
  type StudyRecordAddRequest
} from '@/api/studyRecord'
import { getTranslation } from '@/api/dict'
import { useRouter } from 'vue-router'

// 词汇列表
const vocabularyList = ref<VocabularyVO[]>([])
const loading = ref(false)
const total = ref(0)

// 筛选条件
const filters = reactive({
  current: 1,
  pageSize: 10,
  difficultyLevel: '',
  isPhrase: ''
})

// 难度级别选项
const difficultyOptions = [
  { value: '', label: '全部难度' },
  { value: '初级', label: '初级' },
  { value: '中级', label: '中级' },
  { value: '高级', label: '高级' }
]

// 词汇类型选项
const typeOptions = [
  { value: '', label: '全部类型' },
  { value: '单词', label: '单词' },
  { value: '词组', label: '词组' }
]

// 学习模式
type StudyMode = 'list' | 'spell'
const currentMode = ref<StudyMode>('list')

// 练习相关状态
const currentIndex = ref(0)
const userInput = ref('')
const showAnswer = ref(false)
const correctCount = ref(0)
const totalAttempts = ref(0)

// 添加尝试次数相关状态
const currentAttempts = ref(0)
const maxAttempts = 3

// 是否显示提示信息
const showHint = ref(false)

// 切换提示信息显示状态
const toggleHint = () => {
  showHint.value = !showHint.value
}

// 播放单词发音（等待接口提供后实现）
const playWordAudio = (word: string) => {
  console.log('播放单词:', word)
  // TODO: 实现播放功能
}

// 单词详情相关
const wordDetailDrawer = ref(false)
const currentWord = ref('')
const wordLoading = ref(false)
const wordDetail = ref<WordDetail | null>(null)

// 修改 WordDetail 的类型定义
interface WordDetail {
  pic_dict: Array<{
    image: string;
    url: string;
  }>;
  collins: {
    collins_entries: Array<{
      entries: {
        entry: Array<{
          tran_entry?: {
            pos_entry?: {
              pos: string;
              pos_tips: string;
            };
            tran?: string;
            exam_sents?: {
              sent: Array<{
                chn_sent: string;
                eng_sent: string;
              }>;
            };
          };
        }>;
      };
      phonetic: string;
      headword: string;
      star: string;
    }>;
  };
  individual: {
    trs: Array<{
      pos: string;
      tran: string;
    }>;
    idiomatic: Array<{
      colloc: {
        en: string;
        zh: string;
      };
    }>;
    level: string;
    examInfo: {
      frequency: number;
      recommendationRate: number;
      year: number;
      questionTypeInfo: Array<{
        type: string;
        time: number;
      }>;
    };
    'return-phrase': string;
    pastExamSents?: Array<{
      en: string;
      zh: string;
      source: string;
    }>;
  };
  rel_word: {
    rels: Array<{
      rel: {
        pos: string;
        words: Array<{
          word: string;
          tran: string;
        }>;
      };
    }>;
  };
  word_videos: Array<{
    video: {
      url: string;
      cover: string;
      title: string;
    };
  }>;
}

// 获取单词详情
const fetchWordDetail = async (word: string) => {
  if (!word) return

  wordLoading.value = true
  currentWord.value = word

  try {
    const res = await getTranslation({ q: word })
    // 检查必要的数据是否存在
    if (!res) {
      ElMessage.warning('未获取到单词详情')
      return
    }

    wordDetail.value = {
      pic_dict: res.pic_dict?.pic || [],
      collins: res.collins || {},
      individual: {
        trs: res.individual?.trs || [],
        idiomatic: res.individual?.idiomatic || [],
        level: res.individual?.level || '',
        examInfo: {
          frequency: res.individual?.examInfo?.frequency || 0,
          recommendationRate: res.individual?.examInfo?.recommendationRate || 0,
          year: res.individual?.examInfo?.year || 0,
          questionTypeInfo: res.individual?.examInfo?.questionTypeInfo || []
        },
        'return-phrase': res.individual?.['return-phrase'] || word,
        pastExamSents: res.individual?.pastExamSents || []
      },
      rel_word: {
        rels: res.rel_word?.rels || []
      },
      word_videos: res.word_video?.word_videos || []
    }

    // 只有在成功获取数据后才打开抽屉
    if (hasValidData(wordDetail.value)) {
      wordDetailDrawer.value = true
    } else {
      ElMessage.warning('暂无该单词的详细信息')
    }
  } catch (error) {
    console.error('获取单词详情失败:', error)
    ElMessage.error('获取单词详情失败')
  } finally {
    wordLoading.value = false
  }
}

// 检查是否有有效数据
const hasValidData = (detail: WordDetail | null): boolean => {
  if (!detail) return false

  // 检查是否至少有一项有效数据
  return !!(
    detail.pic_dict.length > 0 ||
    (detail.collins.collins_entries && detail.collins.collins_entries.length > 0) ||
    detail.individual.trs.length > 0 ||
    detail.individual.idiomatic.length > 0 ||
    detail.individual.pastExamSents?.length > 0 ||
    (detail.rel_word.rels && detail.rel_word.rels.length > 0) ||
    detail.word_videos.length > 0
  )
}

// 播放发音
const playWordPronunciation = (type: 'uk' | 'us') => {
  if (!wordDetail.value?.simple?.word?.[0]?.['return-phrase']) return

  const word = wordDetail.value.simple.word[0]['return-phrase']
  const audioType = type === 'uk' ? 1 : 2 // 1 for UK, 2 for US

  const audio = new Audio(`https://dict.youdao.com/dictvoice?type=${audioType}&audio=${word}`)

  // 添加错误处理
  audio.onerror = () => {
    ElMessage.warning('暂无该单词音频，会尽快更新！')
  }

  // 添加加载处理
  audio.onloadeddata = () => {
    audio.play().catch(err => {
      console.error('播放音频失败:', err)
      ElMessage.warning('播放音频失败')
    })
  }

  // 尝试加载音频
  audio.load()
}

// 获取词汇列表
const fetchVocabularyList = async () => {
  loading.value = true
  try {
    const params = { ...filters }
    const res = await getVocabularyList(params)

    if (res.code === 0 && res.data) {
      vocabularyList.value = res.data.records
      total.value = parseInt(res.data.total)
    } else {
      ElMessage.error(res.message || '获取词汇列表失败')
    }
  } catch (error) {
    console.error('获取词汇列表出错:', error)
    ElMessage.error('获取词汇列表出错')
  } finally {
    loading.value = false
  }
}

// 重置筛选条件
const resetFilters = () => {
  filters.difficultyLevel = ''
  filters.isPhrase = ''
  filters.current = 1
  fetchVocabularyList()
}

// 处理页码变化
const handleCurrentChange = (page: number) => {
  filters.current = page
  fetchVocabularyList()
}

// 处理每页显示数量变化
const handleSizeChange = (size: number) => {
  filters.pageSize = size
  filters.current = 1
  fetchVocabularyList()
}

// 获取当前练习的词汇
const currentVocabulary = computed(() => {
  console.log('currentVocabulary:', vocabularyList.value[currentIndex.value])
  return vocabularyList.value[currentIndex.value] || null
})

// 切换学习模式
const switchMode = (mode: StudyMode) => {
  if (mode !== 'list' && vocabularyList.value.length === 0) {
    ElMessage.warning('当前没有可练习的词汇，请先获取词汇列表')
    return
  }

  currentMode.value = mode
  currentIndex.value = 0
  userInput.value = ''
  showAnswer.value = false
  correctCount.value = 0
  totalAttempts.value = 0
  currentAttempts.value = 0  // 重置当前尝试次数
  showHint.value = false
}

// 检查答案
const checkAnswer = async () => {
  if (!currentVocabulary.value || !userInput.value.trim()) return

  currentAttempts.value++
  const isCorrect = userInput.value.toLowerCase().trim() === currentVocabulary.value.word.toLowerCase()

  if (isCorrect) {
    correctCount.value++
    totalAttempts.value++
    showAnswer.value = true
    ElMessage.success('回答正确！')

    // 处理学习记录
    try {
      // 检查是否存在学习记录
      const checkRes = await checkVocabularyRecord(currentVocabulary.value.id)
      if (checkRes.code === 0) {
        const recordId = checkRes.data
        if (recordId) {
          // 存在记录，获取当前进度并更新
          const recordRes = await getStudyRecordById(recordId)
          if (recordRes.code === 0 && recordRes.data) {
            const currentProgress = recordRes.data.progress
            const newProgress = Math.min(currentProgress + 25, 100)

            // 更新进度
            await updateStudyRecordProgress(recordId, newProgress)

            // 如果达到100%，提示用户已掌握
            if (newProgress >= 100) {
              ElMessage.success({
                message: '恭喜！你已经完全掌握这个单词了！',
                duration: 3000
              })
              // 1.5秒后自动进入下一题
              setTimeout(() => {
                nextVocabulary()
              }, 1500)
              return
            }
          }
        } else {
          // 不存在记录，创建新记录
          const newRecord: StudyRecordAddRequest = {
            vocabularyId: currentVocabulary.value.id,
            courseId: 0,
            examId: 0,
            progress: 25,
            score: 0,
            status: '进行中',
            studyTime: 0,
            userId: 0
          }

          const addRes = await addStudyRecord(newRecord)
          if (addRes.code === 0 && addRes.data) {
            console.log('学习记录创建成功:', addRes.data)
          }
        }
      }
    } catch (error) {
      console.error('处理学习记录失败:', error)
    }
  } else {
    if (currentAttempts.value >= maxAttempts) {
      totalAttempts.value++
      showAnswer.value = true
      ElMessage.error('已达到最大尝试次数，答案已显示')
    } else {
      ElMessage.warning({
        message: `回答错误，还有 ${maxAttempts - currentAttempts.value} 次机会`,
        duration: 2000
      })
      return // 如果还有尝试机会，不启动自动进入下一题
    }
  }

  // 只有在显示答案且未达到100%进度时才启动5秒倒计时
  if (showAnswer.value) {
    autoNextTime.value = 5
    const timer = setInterval(() => {
      autoNextTime.value--
      if (autoNextTime.value <= 0) {
        clearInterval(timer)
        nextVocabulary()
      }
    }, 1000)

    return () => {
      clearInterval(timer)
      autoNextTime.value = 5
    }
  }
}

// 修改下一题函数，重置倒计时
const nextVocabulary = () => {
  if (currentIndex.value < vocabularyList.value.length - 1) {
    currentIndex.value++
    userInput.value = ''
    showAnswer.value = false
    currentAttempts.value = 0
    autoNextTime.value = 5  // 重置倒计时
  } else {
    ElMessageBox.alert(
      `练习完成！\n正确率: ${Math.round((correctCount.value / totalAttempts.value) * 100)}%`,
      '恭喜',
      { confirmButtonText: '返回列表' }
    ).then(() => {
      switchMode('list')
    })
  }
  showHint.value = false
}

// 计算练习进度
const progress = computed(() => {
  return Math.round(((currentIndex.value + 1) / vocabularyList.value.length) * 100)
})

// 播放音频
const handlePlayAudio = (word: string, type: 'uk' | 'us') => {
  const audioType = type === 'uk' ? 1 : 2
  const audio = new Audio(`https://dict.youdao.com/dictvoice?type=${audioType}&audio=${word}`)
  audio.play().catch(() => {
    ElMessage.warning('音频播放失败')
  })
}

// 自动进入下一题的时间
const autoNextTime = ref(5)

const router = useRouter()

// 搜索单词
const searchWord = ref('')
const searchWordDetail = () => {
  if (!searchWord.value.trim()) {
    ElMessage.warning('请输入要查询的单词')
    return
  }
  router.push(`/vocabulary/word/${searchWord.value.trim()}`)
}

// 添加视频播放相关的状态
const videoDialogVisible = ref(false)
const currentVideoUrl = ref('')
const currentVideoTitle = ref('')

// 修改播放视频的方法
const playVideo = (url: string, title: string = '') => {
  currentVideoUrl.value = url
  currentVideoTitle.value = title
  videoDialogVisible.value = true
}

// 关闭视频对话框时清空视频URL
const handleCloseVideo = () => {
  currentVideoUrl.value = ''
  currentVideoTitle.value = ''
  videoDialogVisible.value = false
}

// 获取最大考试次数
const maxExamTime = computed(() => {
  if (!wordDetail.value?.individual.examInfo.questionTypeInfo) return 0
  return Math.max(...wordDetail.value.individual.examInfo.questionTypeInfo.map(item => item.time))
})

// 根据次数获取颜色
const getTagType = (time: number) => {
  const ratio = time / maxExamTime.value
  if (ratio > 0.7) return 'danger'
  if (ratio > 0.4) return 'warning'
  return 'info'
}

// 排序后的考试类型数据
const sortedExamTypes = computed(() => {
  if (!wordDetail.value?.individual.examInfo.questionTypeInfo) return []
  return [...wordDetail.value.individual.examInfo.questionTypeInfo]
    .sort((a, b) => b.time - a.time)
})

// 图片预览列表
const previewImages = computed(() => {
  return wordDetail.value?.pic_dict?.map(pic => pic.url) || []
})

// 处理图片加载错误
const handleImageError = () => {
  ElMessage.warning('图片加载失败')
}

onMounted(() => {
  fetchVocabularyList()
})
</script>

<template>
  <div class="vocabulary-container">
    <div class="vocabulary-header">
      <!-- 学习模式切换 -->
      <div class="mode-switcher">
        <el-radio-group v-model="currentMode" size="large">
          <el-radio-button value="list">
            <el-icon>
              <Reading />
            </el-icon>
            词汇列表
          </el-radio-button>
          <el-radio-button value="spell">
            <el-icon>
              <Edit />
            </el-icon>
            拼写练习
          </el-radio-button>
        </el-radio-group>
      </div>
    </div>

    <div class="filter-section">
      <div class="filter-options">
        <el-select v-model="filters.difficultyLevel" placeholder="难度级别" @change="fetchVocabularyList">
          <el-option v-for="item in difficultyOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>

        <el-select v-model="filters.isPhrase" placeholder="词汇类型" @change="fetchVocabularyList">
          <el-option v-for="item in typeOptions" :key="item.value" :label="item.label" :value="item.value" />
        </el-select>
        <el-button type="primary" plain @click="resetFilters">
          <el-icon>
            <Refresh />
          </el-icon>
          重置
        </el-button>
        <el-input v-model="searchWord" placeholder="输入单词进行查询" clearable @keyup.enter="fetchWordDetail(searchWord)"
          class="search-input">
          <template #append>
            <el-button-group>
              <el-button type="primary" @click="fetchWordDetail(searchWord)">
                <el-icon>
                  <Search />
                </el-icon>
              </el-button>
              <el-button type="primary" @click="handlePlayAudio(searchWord)">
                <el-icon>
                  <Microphone />
                </el-icon>
              </el-button>
            </el-button-group>
          </template>
        </el-input>


      </div>
    </div>

    <!-- 列表模式 -->
    <template v-if="currentMode === 'list'">
      <div class="vocabulary-list">
        <el-empty v-if="vocabularyList.length === 0 && !loading" description="暂无词汇数据" />

        <el-skeleton v-if="loading" :rows="5" animated />

        <template v-else>
          <div class="vocabulary-grid">
            <div v-for="item in vocabularyList" :key="item.id" class="vocabulary-card">
              <div class="card-header">
                <div class="difficulty-tag">
                  <el-tag :type="item.difficultyLevel === '高级' ? 'danger' :
                    item.difficultyLevel === '中级' ? 'warning' : 'success'" size="small">
                    {{ item.difficultyLevel }}
                  </el-tag>
                  <el-tag type="info" size="small">{{ item.isPhrase }}</el-tag>
                  <el-tag size="small" style="color: tomato;" @click="fetchWordDetail(item.word)">
                    <el-icon>
                      <View />
                    </el-icon>
                  </el-tag>
                </div>
                <div class="word-audio">
                  <el-dropdown trigger="click" @command="type => handlePlayAudio(item.word, type)">
                    <el-button type="primary" circle size="small">
                      <el-icon>
                        <Microphone />
                      </el-icon>
                    </el-button>
                    <template #dropdown>
                      <el-dropdown-menu>
                        <el-dropdown-item command="uk">
                          <span class="accent-label">
                            <el-icon>
                              <Microphone />
                            </el-icon>
                            英式发音
                          </span>
                        </el-dropdown-item>
                        <el-dropdown-item command="us">
                          <span class="accent-label">
                            <el-icon>
                              <Microphone />
                            </el-icon>
                            美式发音
                          </span>
                        </el-dropdown-item>
                      </el-dropdown-menu>
                    </template>
                  </el-dropdown>
                </div>
              </div>

              <div class="word-section">
                <h3 class="word">{{ item.word }}</h3>
                <div class="phonetic">{{ item.phonetic }}</div>
              </div>

              <div class="divider"></div>

              <div class="meaning-section">
                <div class="meaning">{{ item.meaning }}</div>
                <div class="example">{{ item.example }}</div>
              </div>
            </div>
          </div>
        </template>

        <div class="pagination-container">
          <el-pagination v-model:current-page="filters.current" v-model:page-size="filters.pageSize"
            :page-sizes="[10, 20, 30, 50]" layout="total, sizes, prev, pager, next, jumper" :total="total"
            @size-change="handleSizeChange" @current-change="handleCurrentChange" />
        </div>
      </div>
    </template>

    <!-- 练习模式 -->
    <template v-if="currentMode === 'spell'">
      <div class="study-container">
        <!-- 练习头部 -->
        <div class="study-header">
          <div class="progress-info">
            <div class="progress-text">
              <span class="current">{{ currentIndex + 1 }}</span>
              <span class="total">/ {{ vocabularyList.length }}</span>
            </div>
            <div class="tags">
              <el-tag :type="currentVocabulary.difficultyLevel === '高级' ? 'danger' :
                currentVocabulary.difficultyLevel === '中级' ? 'warning' : 'success'" effect="dark">
                {{ currentVocabulary.difficultyLevel }}
              </el-tag>
              <el-tag type="info" effect="plain">{{ currentVocabulary.isPhrase }}</el-tag>
            </div>
          </div>
          <el-progress :percentage="progress" :show-text="false" :stroke-width="8" />
        </div>

        <div class="study-card">
          <!-- 输入区域 -->
          <div class="input-section">
            <!-- 音频按钮组 -->
            <div class="audio-group">
              <el-tooltip content="英式发音" placement="top">
                <el-button type="primary" plain size="large" class="accent-btn uk"
                  @click="handlePlayAudio(currentVocabulary.word, 'uk')">
                  UK
                </el-button>
              </el-tooltip>
              <el-tooltip content="美式发音" placement="top">
                <el-button type="info" plain size="large" class="accent-btn us"
                  @click="handlePlayAudio(currentVocabulary.word, 'us')">
                  US
                </el-button>
              </el-tooltip>
            </div>

            <!-- 输入框 -->
            <div class="input-box">
              <el-input v-model="userInput" placeholder="请输入单词拼写" @keyup.enter="checkAnswer" :disabled="showAnswer"
                size="large" :class="{ 'is-correct': showAnswer && isCorrect }">
                <template #append>
                  <el-button type="primary" @click="checkAnswer" :disabled="showAnswer || !userInput"
                    class="submit-btn">
                    <el-icon>
                      <Check />
                    </el-icon>
                    确认
                  </el-button>
                </template>
              </el-input>

              <!-- 尝试次数提示 -->
              <div class="attempts-info" v-if="currentAttempts > 0 && !showAnswer">
                <el-tag :type="currentAttempts >= maxAttempts - 1 ? 'danger' : 'warning'" effect="light">
                  剩余机会: {{ maxAttempts - currentAttempts }}
                </el-tag>
              </div>
            </div>

            <!-- 提示按钮 -->
            <el-button class="hint-btn" :type="showHint ? 'primary' : 'default'" @click="toggleHint">
              <el-icon>
                <View />
              </el-icon>
              提示
            </el-button>
          </div>

          <!-- 提示内容 -->
          <transition name="fade">
            <div v-if="showHint" class="hint-panel">
              <div class="hint-content">
                <div class="hint-item">
                  <div class="hint-label">中文含义</div>
                  <div class="hint-text">{{ currentVocabulary.meaning }}</div>
                </div>
                <div class="hint-item">
                  <div class="hint-label">音标</div>
                  <div class="hint-text phonetic">{{ currentVocabulary.phonetic }}</div>
                </div>
                <div class="hint-item">
                  <div class="hint-label">例句</div>
                  <div class="hint-text example">{{ currentVocabulary.example }}</div>
                </div>
              </div>
            </div>
          </transition>
        </div>
      </div>

      <!-- 答案面板 -->
      <transition name="fade">
        <div v-if="showAnswer" class="answer-panel">
          <div class="answer-items">
            <div class="answer-item">
              <div class="answer-label">
                <el-icon>
                  <Check v-if="userInput.toLowerCase().trim() === currentVocabulary.word.toLowerCase()" />
                  <Close v-else />
                </el-icon>
                {{ userInput.toLowerCase().trim() === currentVocabulary.word.toLowerCase() ? '回答正确' : '回答错误' }}
              </div>
              <div class="answer-content" :class="{
                'correct-answer': userInput.toLowerCase().trim() === currentVocabulary.word.toLowerCase(),
                'wrong-answer': userInput.toLowerCase().trim() !== currentVocabulary.word.toLowerCase()
              }">
                <div class="word">{{ currentVocabulary.word }}</div>
                <div class="phonetic">{{ currentVocabulary.phonetic }}</div>
              </div>
            </div>

            <div class="answer-item">
              <div class="answer-label">
                <el-icon>
                  <Document />
                </el-icon>
                中文含义
              </div>
              <div class="answer-content">{{ currentVocabulary.meaning }}</div>
            </div>

            <div class="answer-item">
              <div class="answer-label">
                <el-icon>
                  <Reading />
                </el-icon>
                例句
              </div>
              <div class="answer-content example">{{ currentVocabulary.example }}</div>
            </div>
          </div>

          <div class="answer-footer">
            <div class="auto-next-hint">
              <el-icon>
                <Timer />
              </el-icon>
              <span>{{ autoNextTime }}秒后自动继续</span>
            </div>
          </div>
        </div>
      </transition>
    </template>

    <!-- 单词详情抽屉 -->
    <el-drawer v-model="wordDetailDrawer" title="单词详情" direction="rtl" size="50%">
      <div v-loading="wordLoading">
        <template v-if="wordDetail">
          <div v-if="hasValidData(wordDetail)" class="word-detail">
            <!-- 单词标题和基本信息 -->
            <div class="word-header">
              <div class="word-title-section">
                <h1 class="word-title">{{ wordDetail.individual['return-phrase'] }}</h1>
                <div class="word-info">
                  <!-- 难度和频率标签 -->
                  <div class="info-tags">
                    <el-tag size="small" :type="wordDetail.individual.level === '高级' ? 'danger' :
                      wordDetail.individual.level === '中级' ? 'warning' : 'success'
                      ">
                      {{ wordDetail.individual.level }}
                    </el-tag>
                    <el-tag size="small" type="info">
                      近{{ wordDetail.individual.examInfo.year }}年考频: {{ wordDetail.individual.examInfo.frequency }}次
                    </el-tag>
                    <el-tag size="small" type="warning">
                      推荐指数: {{ '★'.repeat(wordDetail.individual.examInfo.recommendationRate) }}
                    </el-tag>
                  </div>

                  <!-- 考查形式 -->
                  <div class="exam-types">
                    <div v-for="item in sortedExamTypes" :key="item.type" class="exam-type-item">
                      <el-tooltip :content="`出现${item.time}次`" placement="top">
                        <el-tag size="small" :type="getTagType(item.time)" effect="light">
                          {{ item.type }}
                        </el-tag>
                      </el-tooltip>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 音标和发音 -->
              <div class="pronunciation" v-if="wordDetail.collins.collins_entries?.[0]?.phonetic">
                <span class="phonetic">/{{ wordDetail.collins.collins_entries[0].phonetic }}/</span>
                <div class="audio-buttons">
                  <el-tooltip content="英式发音" placement="top">
                    <el-button type="primary" circle size="small"
                      @click="handlePlayAudio(wordDetail.individual['return-phrase'], 'uk')">
                      UK
                    </el-button>
                  </el-tooltip>
                  <el-tooltip content="美式发音" placement="top">
                    <el-button type="info" circle size="small"
                      @click="handlePlayAudio(wordDetail.individual['return-phrase'], 'us')">
                      US
                    </el-button>
                  </el-tooltip>
                </div>
              </div>
            </div>

            <!-- 基本释义 -->
            <div class="basic-meanings">
              <h3>基本释义</h3>
              <div class="meaning-list">
                <div v-for="(tr, index) in wordDetail.individual.trs" :key="index" class="meaning-item">
                  <el-tag size="small" class="pos-tag" effect="plain">{{ tr.pos }}</el-tag>
                  <span class="meaning">{{ tr.tran }}</span>
                </div>
              </div>
              <!-- 添加词形变化 -->
              <div class="word-forms"
                v-if="wordDetail.collins.collins_entries?.[0]?.basic_entries?.basic_entry?.[0]?.wordforms">
                <h4>词形变化</h4>
                <div class="forms-list">
                  <el-tag
                    v-for="form in wordDetail.collins.collins_entries[0].basic_entries.basic_entry[0].wordforms.wordform"
                    :key="form.word" size="small" effect="plain" class="form-tag">
                    {{ form.word }}
                  </el-tag>
                </div>
              </div>
            </div>

            <!-- 图片与视频 -->
            <div class="media-section" v-if="wordDetail.pic_dict.length || wordDetail.word_videos.length">
              <h3>图片与视频</h3>
              <el-tabs>
                <el-tab-pane label="图片" v-if="wordDetail.pic_dict?.length">
                  <div class="image-grid">
                    <div v-for="(pic, index) in wordDetail.pic_dict" :key="index" class="image-wrapper">
                      <el-image :src="pic.url" fit="cover" :preview-src-list="previewImages" :initial-index="index"
                        class="word-image" loading="lazy" @error="handleImageError">
                        <template #error>
                          <div class="image-error">
                            <el-icon>
                              <Picture />
                            </el-icon>
                            <span>加载失败</span>
                          </div>
                        </template>
                      </el-image>
                    </div>
                  </div>
                </el-tab-pane>
                <el-tab-pane label="视频" v-if="wordDetail.word_videos?.length">
                  <div class="video-grid">
                    <div v-for="(video, index) in wordDetail.word_videos" :key="index" class="video-item">
                      <div class="video-preview" @click="playVideo(video.video.url, video.video.title)">
                        <el-image :src="video.video.cover" fit="cover" class="video-cover" />
                        <div class="play-overlay">
                          <el-icon class="play-icon">
                            <VideoPlay />
                          </el-icon>
                        </div>
                        <div class="video-title">{{ video.video.title }}</div>
                      </div>
                    </div>
                  </div>
                </el-tab-pane>
              </el-tabs>
            </div>

            <!-- 常用搭配 -->
            <div class="collocations" v-if="wordDetail.individual.idiomatic?.length">
              <h3>常用搭配</h3>
              <div class="collocation-list">
                <el-card v-for="(item, index) in wordDetail.individual.idiomatic" :key="index" class="collocation-item"
                  shadow="hover">
                  <div class="en">{{ item.colloc.en }}</div>
                  <div class="zh">{{ item.colloc.zh }}</div>
                </el-card>
              </div>
            </div>

            <!-- 相关词 -->
            <div class="related-words" v-if="wordDetail.rel_word.rels?.length">
              <h3>相关词</h3>
              <div class="related-list">
                <el-card v-for="(rel, index) in wordDetail.rel_word.rels" :key="index" class="related-group"
                  shadow="hover">
                  <div class="pos-header">
                    <el-tag size="small" type="info" effect="plain">{{ rel.rel.pos }}</el-tag>
                  </div>
                  <div class="words">
                    <el-tag v-for="(word, wordIndex) in rel.rel.words" :key="wordIndex" class="word-tag" effect="light"
                      @click="fetchWordDetail(word.word)">
                      {{ word.word }}
                      <span class="word-tran">{{ word.tran }}</span>
                    </el-tag>
                  </div>
                </el-card>
              </div>
            </div>

            <!-- 例句与用法 -->
            <div class="examples" v-if="wordDetail.collins.collins_entries?.[0]?.entries?.entry">
              <h3>例句与用法</h3>
              <div class="example-list">
                <div v-for="(entry, entryIndex) in wordDetail.collins.collins_entries[0].entries.entry"
                  :key="entryIndex">
                  <template v-for="(tran, tranIndex) in entry.tran_entry" :key="tranIndex">
                    <div v-if="tran.pos_entry || tran.tran || tran.exam_sents" class="example-group">
                      <div v-if="tran.pos_entry" class="pos-info">
                        <el-tag size="small" effect="dark">{{ tran.pos_entry.pos }}</el-tag>
                        <span class="pos-tips">{{ tran.pos_entry.pos_tips }}</span>
                      </div>
                      <div class="tran-text" v-if="tran.tran" v-html="tran.tran"></div>
                      <div v-if="tran.exam_sents?.sent" class="example-items">
                        <div v-for="(sent, sentIndex) in tran.exam_sents.sent" :key="sentIndex" class="example-item">
                          <div class="eng-sent">{{ sent.eng_sent }}</div>
                          <div class="chn-sent">{{ sent.chn_sent }}</div>
                        </div>
                      </div>
                    </div>
                  </template>
                </div>
              </div>
            </div>

            <!-- 修改真题例句部分 -->
            <div class="past-exam-sentences" v-if="wordDetail.individual.pastExamSents?.length">
              <h3>真题例句</h3>
              <div class="exam-sent-list">
                <el-card v-for="(sent, index) in wordDetail.individual.pastExamSents" :key="index"
                  class="exam-sent-card" shadow="hover">
                  <div class="exam-content">
                    <div class="sent-section">
                      <div class="eng-sent">{{ sent.en }}</div>
                      <div class="chn-sent">{{ sent.zh }}</div>
                    </div>
                    <div class="source-section">
                      <el-tag size="small" effect="plain" type="info">{{ sent.source }}</el-tag>
                    </div>
                  </div>
                </el-card>
              </div>
            </div>
          </div>

          <el-empty v-else description="暂无该单词的详细信息" />
        </template>
      </div>
    </el-drawer>

    <!-- 添加视频播放对话框 -->
    <el-dialog v-model="videoDialogVisible" :title="currentVideoTitle" width="80%" class="video-dialog"
      @close="handleCloseVideo" destroy-on-close>
      <div class="video-container">
        <video v-if="currentVideoUrl" :src="currentVideoUrl" class="video-player" controls autoplay></video>
      </div>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.vocabulary-container {
  background: #fff;
  max-width: 1280px;
  margin: 0 auto;
  padding: 24px;

  .vocabulary-header {
    margin-bottom: 24px;

    h1 {
      font-size: 28px;
      font-weight: 600;
      margin-bottom: 8px;
      color: #303133;
    }

    p {
      color: #606266;
      font-size: 15px;
    }
  }

  .filter-section {
    margin-bottom: 24px;
    padding: 20px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.04);

    .filter-options {
      display: flex;
      gap: 16px;
      align-items: center;
      flex-wrap: wrap;

      .el-select {
        width: 160px;

        :deep(.el-input__wrapper) {
          box-shadow: 0 0 0 1px #dcdfe6 inset;

          &:hover {
            box-shadow: 0 0 0 1px #409EFF inset;
          }
        }
      }

      .el-button {
        height: 32px;
        padding: 0 16px;
        font-weight: 500;

        .el-icon {
          margin-right: 4px;
          font-size: 14px;
        }

        &:hover {
          transform: translateY(-1px);
          transition: all 0.2s ease;
        }
      }

      .search-input {
        width: 300px;
        margin-left: auto;

        :deep(.el-input__wrapper) {
          box-shadow: 0 0 0 1px #dcdfe6 inset;
          transition: all 0.2s ease;
          border-radius: 4px;

          &:hover {
            box-shadow: 0 0 0 1px #409EFF inset;
          }

          &.is-focus {
            box-shadow: 0 0 0 1px #409EFF inset;
          }
        }

        :deep(.el-input__inner) {
          height: 32px;
          line-height: 32px;
          font-size: 14px;

          &::placeholder {
            color: #909399;
          }
        }

        :deep(.el-input-group__append) {
          padding: 0;
          border: none;
          background: transparent;

          .el-button-group {
            display: flex;

            .el-button {
              margin: 0;
              border: 1px solid #dcdfe6;
              border-left: none;
              height: 32px;
              padding: 0 12px;
              font-size: 14px;
              background-color: white;
              color: #606266;

              &:first-child {
                border-radius: 0;
              }

              &:last-child {
                border-radius: 0 4px 4px 0;
              }

              .el-icon {
                font-size: 16px;
              }

              &:hover {
                color: #409EFF;
                border-color: #c6e2ff;
                background-color: #ecf5ff;
                z-index: 1;
              }

              &:active {
                background-color: #409EFF;
                border-color: #409EFF;
                color: white;
              }
            }
          }
        }
      }
    }
  }

  .vocabulary-list {
    padding: 20px;

    .vocabulary-grid {
      display: grid;
      grid-template-columns: repeat(5, 1fr);
      gap: 20px;
      margin-bottom: 24px;

      .vocabulary-card {
        background: #fff;
        border-radius: 12px;
        padding: 16px;
        box-shadow: 0 2px 12px rgba(0, 0, 0, 0.05);
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;

        &:hover {
          transform: translateY(-4px);
          box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
        }

        .card-header {
          display: flex;
          justify-content: space-between;
          align-items: flex-start;
          margin-bottom: 12px;

          .difficulty-tag {
            display: flex;
            gap: 8px;

            .el-tag {
              font-size: 12px;
            }
          }

          .word-audio {
            .el-button {
              padding: 6px;

              .el-icon {
                font-size: 14px;
                transition: transform 0.3s ease;
              }

              &:hover {
                .el-icon {
                  transform: scale(1.1);
                }
              }

              &:active {
                .el-icon {
                  transform: scale(0.9);
                }
              }
            }
          }
        }

        .word-section {
          text-align: center;
          margin-bottom: 12px;

          .word {
            font-size: 20px;
            font-weight: 600;
            color: #303133;
            margin: 0 0 4px;

            // 单词过长时处理
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
          }

          .phonetic {
            font-family: monospace;
            color: #909399;
            font-size: 14px;
          }
        }

        .divider {
          height: 1px;
          background: #ebeef5;
          margin: 12px 0;
        }

        .meaning-section {
          flex: 1;
          display: flex;
          flex-direction: column;
          gap: 8px;

          .meaning {
            color: #606266;
            font-size: 14px;
            line-height: 1.4;
          }

          .example {
            color: #909399;
            font-size: 13px;
            font-style: italic;
            line-height: 1.4;

            // 例句过长时显示省略号
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
          }
        }
      }
    }
  }

  .pagination-container {
    margin-top: 24px;
    display: flex;
    justify-content: center;
  }

  .mode-switcher {
    margin-top: 20px;
    display: flex;
    justify-content: center;

    .el-radio-group {
      display: flex;
      justify-content: center;
      gap: 16px;

      .el-radio-button {
        &:first-child {
          margin-right: 0; // 移除右边距，使用 gap 控制间距
        }
      }
    }
  }

  .study-container {
    max-width: 800px;
    margin: 32px auto;
    padding: 0 20px;

    .study-header {
      margin-bottom: 24px;

      .progress-info {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;

        .progress-text {
          .current {
            font-size: 36px;
            font-weight: 600;
            color: #409EFF;
          }

          .total {
            font-size: 18px;
            color: #909399;
          }
        }

        .tags {
          display: flex;
          gap: 8px;

          .el-tag {
            padding: 6px 12px;
            font-size: 14px;
          }
        }
      }

      :deep(.el-progress-bar__outer) {
        background-color: #f0f2f5;
        border-radius: 8px;
      }
    }

    .study-card {
      background: #fff;
      border-radius: 20px;
      padding: 32px;
      box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);

      .input-section {
        display: flex;
        align-items: center;
        gap: 16px;
        margin-bottom: 24px;

        .audio-group {
          display: flex;
          gap: 8px;

          .accent-btn {
            width: 48px;
            height: 48px;
            font-weight: 600;
            font-size: 16px;
            padding: 0;
            transition: all 0.3s ease;

            &:hover {
              transform: translateY(-2px);
            }

            &.uk {
              &:hover {
                color: #409EFF;
                border-color: #409EFF;
              }
            }

            &.us {
              &:hover {
                color: #909399;
                border-color: #909399;
              }
            }
          }
        }

        .input-box {
          flex: 1;
          position: relative;

          :deep(.el-input) {
            .el-input__wrapper {
              padding: 4px;
              border-radius: 12px;
              box-shadow: 0 2px 12px rgba(0, 0, 0, 0.04);
            }

            .el-input__inner {
              height: 48px;
              font-size: 16px;
              letter-spacing: 1px;
            }

            .submit-btn {
              height: 48px;
              padding: 0 24px;
              font-size: 15px;
              border-radius: 0 12px 12px 0;

              .el-icon {
                margin-right: 6px;
              }
            }
          }

          .attempts-info {
            position: absolute;
            top: -24px;
            right: 0;

            .el-tag {
              padding: 4px 12px;
              border-radius: 12px;
            }
          }
        }

        .hint-btn {
          height: 48px;
          padding: 0 20px;
          border-radius: 12px;
          transition: all 0.3s ease;

          .el-icon {
            margin-right: 6px;
          }

          &:hover {
            transform: translateY(-2px);
          }
        }
      }

      .hint-panel {
        background: #f8f9fa;
        border-radius: 16px;
        padding: 24px;
        margin-top: 24px;

        .hint-content {
          display: flex;
          flex-direction: column;
          gap: 16px;

          .hint-item {
            .hint-label {
              color: #909399;
              margin-bottom: 8px;
              font-size: 14px;
            }

            .hint-text {
              background: #fff;
              padding: 12px 16px;
              border-radius: 8px;
              font-size: 15px;
              line-height: 1.6;

              &.phonetic {
                font-family: monospace;
                color: #409EFF;
              }

              &.example {
                font-style: italic;
                color: #606266;
              }
            }
          }
        }
      }
    }
  }

  .empty-container,
  .error-container {
    max-width: 800px;
    margin: 24px auto;
    padding: 48px;
    background: #fff;
    border-radius: 12px;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
    text-align: center;
  }

  .word-audio,
  .play-button {
    .accent-label {
      display: flex;
      align-items: center;
      gap: 8px;

      .el-icon {
        font-size: 14px;
        color: #606266;
      }
    }

    :deep(.el-dropdown-menu__item) {
      padding: 8px 16px;

      &:hover {
        .el-icon {
          color: #409EFF;
        }
      }
    }
  }

  // 练习模式中的播放按钮样式
  .play-button {
    .el-button {
      width: 48px;
      height: 48px;
      font-size: 20px;

      .el-icon {
        transition: transform 0.3s ease;
      }

      &:hover {
        .el-icon {
          transform: scale(1.1);
        }
      }

      &:active {
        .el-icon {
          transform: scale(0.9);
        }
      }
    }
  }

  // 列表模式中的播放按钮样式
  .word-audio {
    .el-button {
      padding: 6px;

      .el-icon {
        font-size: 14px;
        transition: transform 0.3s ease;
      }

      &:hover {
        .el-icon {
          transform: scale(1.1);
        }
      }

      &:active {
        .el-icon {
          transform: scale(0.9);
        }
      }
    }
  }
}

// 响应式布局
@media (max-width: 1400px) {
  .vocabulary-grid {
    grid-template-columns: repeat(4, 1fr) !important;
  }
}

@media (max-width: 1200px) {
  .vocabulary-grid {
    grid-template-columns: repeat(3, 1fr) !important;
  }
}

@media (max-width: 992px) {
  .vocabulary-grid {
    grid-template-columns: repeat(2, 1fr) !important;
  }
}

@media (max-width: 576px) {
  .vocabulary-grid {
    grid-template-columns: 1fr !important;
  }
}

// 动画效果
.fade-enter-active,
.fade-leave-active {
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}

.answer-panel,
.hint-panel {
  background: #fff;
  border-radius: 16px;
  padding: 24px;
  margin: 0 auto;
  margin-top: 5px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.08);
  width: 100%;
  max-width: 800px;
  box-sizing: border-box;

  .answer-items,
  .hint-content {
    display: flex;
    flex-direction: column;
    gap: 16px;

    .answer-item,
    .hint-item {

      .answer-label,
      .hint-label {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #909399;
        margin-bottom: 8px;
        font-size: 14px;

        .el-icon {
          font-size: 16px;
          color: #409EFF;
        }
      }

      .answer-content,
      .hint-text {
        background: #f8f9fa;
        padding: 16px;
        border-radius: 12px;
        font-size: 15px;
        line-height: 1.6;

        &.correct-answer {
          background: #f0f9eb;
          border: 1px solid #e1f3d8;

          .word {
            color: #67c23a;
          }
        }

        &.wrong-answer {
          background: #fef0f0;
          border: 1px solid #fde2e2;

          .word {
            color: #f56c6c;
          }
        }

        .word {
          font-size: 20px;
          font-weight: 600;
          margin-bottom: 4px;
        }

        .phonetic {
          font-family: monospace;
          color: #909399;
        }

        &.example {
          font-style: italic;
          color: #606266;
        }
      }
    }
  }

  .answer-footer {
    display: flex;
    align-items: center;
    justify-content: space-between;
    margin-top: 24px;
    padding-top: 20px;
    border-top: 1px solid #f0f2f5;

    .next-button {
      padding: 12px 28px;
      font-size: 15px;
      border-radius: 24px;

      .el-icon {
        transition: transform 0.3s ease;
      }

      &:hover .el-icon {
        transform: translateX(4px);
      }
    }

    .auto-next-hint {
      display: flex;
      align-items: center;
      gap: 6px;
      color: #909399;
      font-size: 14px;

      .el-icon {
        font-size: 16px;
      }
    }
  }
}

/* 单词详情样式 */
.word-detail {
  padding: 0 20px;

  .word-header {
    margin-bottom: 24px;
    padding-bottom: 16px;
    border-bottom: 1px solid #ebeef5;

    .word-title-section {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-bottom: 16px;

      .word-title {
        font-size: 28px;
        color: #303133;
        margin: 0;
        font-weight: 600;
      }

      .word-info {
        .info-tags {
          display: flex;
          align-items: center;
          flex-wrap: wrap;
          gap: 8px;
          margin-bottom: 12px;
        }

        .exam-types {
          display: flex;
          flex-wrap: wrap;
          gap: 8px;
          margin-top: 12px;
          // padding: 12px;
          // background: #f8f9fa;
          border-radius: 8px;

          .exam-type-item {
            .el-tag {
              cursor: help;
              transition: all 0.3s ease;

              &:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
              }
            }
          }
        }
      }
    }

    .pronunciation {
      display: flex;
      align-items: center;
      gap: 16px;

      .phonetic {
        font-family: 'Courier New', monospace;
        color: #606266;
        font-size: 18px;
      }

      .audio-buttons {
        display: flex;
        gap: 8px;

        .el-button {
          font-weight: 600;

          &:hover {
            transform: scale(1.05);
            transition: transform 0.2s ease;
          }
        }
      }
    }
  }

  .media-section {
    margin-bottom: 32px;

    h3 {
      font-size: 20px;
      color: #303133;
      margin: 0 0 16px;
      font-weight: 600;
      display: flex;
      align-items: center;

      &::before {
        content: '';
        width: 4px;
        height: 20px;
        background: #409EFF;
        margin-right: 8px;
        border-radius: 2px;
      }
    }

    .image-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 16px;
      padding: 16px;

      .image-wrapper {
        aspect-ratio: 4/3;
        border-radius: 8px;
        overflow: hidden;
        background: #f5f7fa;

        .word-image {
          width: 100%;
          height: 100%;
          transition: transform 0.3s ease;

          &:hover {
            transform: scale(1.02);
          }

          :deep(.el-image__inner) {
            width: 100%;
            height: 100%;
            object-fit: cover;
          }
        }

        .image-error {
          height: 100%;
          display: flex;
          flex-direction: column;
          justify-content: center;
          align-items: center;
          color: #909399;
          font-size: 14px;

          .el-icon {
            font-size: 32px;
            margin-bottom: 8px;
          }
        }
      }
    }

    .video-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
      gap: 16px;

      .video-item {
        .video-preview {
          position: relative;
          border-radius: 8px;
          overflow: hidden;
          cursor: pointer;

          &:hover {
            .play-overlay {
              background-color: rgba(0, 0, 0, 0.5);

              .play-icon {
                transform: translate(-50%, -50%) scale(1.1);
              }
            }

            .video-cover {
              transform: scale(1.05);
            }
          }

          .video-cover {
            width: 100%;
            height: 158px;
            transition: transform 0.3s ease;
          }

          .play-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: rgba(0, 0, 0, 0.3);
            transition: all 0.3s ease;

            .play-icon {
              position: absolute;
              top: 50%;
              left: 50%;
              transform: translate(-50%, -50%);
              color: white;
              font-size: 48px;
              transition: transform 0.3s ease;
            }
          }

          .video-title {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            padding: 12px;
            background: linear-gradient(transparent, rgba(0, 0, 0, 0.7));
            color: white;
            font-size: 14px;
            line-height: 1.4;
          }
        }
      }
    }
  }

  .basic-meanings,
  .collocations,
  .examples,
  .related-words {
    margin-bottom: 32px;

    h3 {
      font-size: 20px;
      color: #303133;
      margin: 0 0 16px;
      font-weight: 600;
      display: flex;
      align-items: center;

      &::before {
        content: '';
        width: 4px;
        height: 20px;
        background: #409EFF;
        margin-right: 8px;
        border-radius: 2px;
      }
    }
  }

  .meaning-list {
    .meaning-item {
      display: flex;
      align-items: flex-start;
      gap: 12px;
      margin-bottom: 12px;
      padding: 12px;
      background: #f8f9fa;
      border-radius: 8px;

      .pos-tag {
        flex-shrink: 0;
      }

      .meaning {
        color: #606266;
        line-height: 1.6;
        font-size: 15px;
      }
    }
  }

  .collocation-list {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
    gap: 16px;

    .collocation-item {
      .en {
        color: #303133;
        margin-bottom: 8px;
        font-weight: 500;
      }

      .zh {
        color: #606266;
        font-size: 14px;
      }
    }
  }

  .example-list {
    .example-group {
      margin-bottom: 24px;
      background: #f8f9fa;
      border-radius: 12px;
      padding: 16px;

      .pos-info {
        display: flex;
        align-items: center;
        gap: 8px;
        margin-bottom: 12px;

        .pos-tips {
          color: #909399;
          font-size: 14px;
        }
      }

      .tran-text {
        color: #606266;
        margin-bottom: 16px;
        line-height: 1.6;
        font-size: 15px;

        :deep(b) {
          color: #409EFF;
          font-weight: 600;
        }
      }

      .example-items {
        .example-item {
          margin-bottom: 12px;
          padding: 12px;
          background: white;
          border-radius: 8px;

          .eng-sent {
            color: #303133;
            margin-bottom: 8px;
            line-height: 1.6;
          }

          .chn-sent {
            color: #606266;
            font-size: 14px;
            line-height: 1.6;
          }
        }
      }
    }
  }

  .related-list {
    .related-group {
      margin-bottom: 20px;

      .pos-header {
        margin-bottom: 12px;

        .el-tag {
          font-size: 14px;
        }
      }

      .words {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;

        .word-tag {
          cursor: pointer;
          padding: 6px 12px;
          transition: all 0.2s ease;
          display: inline-flex;
          align-items: center;
          gap: 4px;
          font-size: 14px;

          &:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
          }

          .word-tran {
            color: #909399;
            font-size: 12px;

            &::before {
              content: '·';
              margin: 0 4px;
            }
          }
        }
      }
    }
  }

  .word-forms {
    margin-top: 16px;

    h4 {
      font-size: 16px;
      color: #606266;
      margin-bottom: 12px;
    }

    .forms-list {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;

      .form-tag {
        font-family: 'Courier New', monospace;
      }
    }
  }

  .past-exam-sentences {
    margin-bottom: 32px;

    h3 {
      font-size: 20px;
      color: #303133;
      margin: 0 0 16px;
      font-weight: 600;
      display: flex;
      align-items: center;

      &::before {
        content: '';
        width: 4px;
        height: 20px;
        background: #409EFF;
        margin-right: 8px;
        border-radius: 2px;
      }
    }

    .exam-sent-list {
      display: flex;
      flex-direction: column;
      gap: 12px;

      .exam-sent-card {
        transition: all 0.3s ease;

        &:hover {
          transform: translateY(-2px);
        }

        .exam-content {
          .sent-section {
            margin-bottom: 12px;

            .eng-sent {
              color: #303133;
              font-size: 15px;
              line-height: 1.6;
              margin-bottom: 8px;
              font-weight: 500;
            }

            .chn-sent {
              color: #606266;
              font-size: 14px;
              line-height: 1.6;
              padding-left: 12px;
              border-left: 3px solid #e6e8eb;
              margin-left: 4px;
            }
          }

          .source-section {
            display: flex;
            justify-content: flex-end;

            .el-tag {
              font-size: 12px;
              padding: 0 8px;
              height: 24px;
              line-height: 22px;
              border-radius: 4px;
            }
          }
        }
      }
    }
  }
}

// 添加深色主题支持
html.dark {
  .past-exam-sentences {
    .exam-sent-list {
      .exam-sent-card {
        .exam-content {
          .sent-section {
            .eng-sent {
              color: #e5eaf3;
            }

            .chn-sent {
              color: #a3a6ad;
              border-left-color: #4c4d4f;
            }
          }
        }
      }
    }
  }
}

// 添加视频播放器相关样式
.video-dialog {
  :deep(.el-dialog__body) {
    padding: 0;
  }

  .video-container {
    width: 100%;
    background: #000;
    aspect-ratio: 16 / 9;
    display: flex;
    justify-content: center;
    align-items: center;

    .video-player {
      width: 100%;
      height: 100%;
      object-fit: contain;
    }
  }
}

// 添加响应式布局
@media screen and (max-width: 768px) {
  .filter-section {
    .filter-options {
      .el-select {
        width: calc(50% - 8px) !important;
      }

      .search-input {
        width: 100% !important;
        margin-left: 0 !important;
        order: -1;
      }
    }
  }
}

// 优化图片预览样式
:deep(.el-image-viewer__wrapper) {
  .el-image-viewer__btn {
    color: #fff;

    &:hover {
      color: #409EFF;
    }
  }

  .el-image-viewer__actions {
    opacity: 0.9;

    &__inner {
      padding: 8px 16px;
    }
  }
}

// 深色主题支持
html.dark {
  .image-grid {
    .image-wrapper {
      background: #1a1a1a;

      .image-error {
        color: #a3a6ad;
      }
    }
  }
}
</style>