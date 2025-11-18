<template>
  <div class="vocabulary-container">
    <!-- 头部搜索和操作 -->
    <div class="header">
      <div class="title">词汇管理</div>
      <div class="actions">
        <el-select v-model="difficultyLevel" placeholder="难度等级" clearable>
          <el-option label="初级" value="初级" />
          <el-option label="中级" value="中级" />
          <el-option label="高级" value="高级" />
        </el-select>
        <el-select v-model="isPhrase" placeholder="词汇类型" clearable>
          <el-option label="单词" value="单词" />
          <el-option label="词组" value="词组" />
        </el-select>
        <el-input v-model="searchQuery" placeholder="搜索词汇" class="search-input" clearable @keyup.enter="handleSearch">
          <template #prefix>
            <el-icon>
              <Search />
            </el-icon>
          </template>
        </el-input>
        <el-button type="primary" @click="handleAdd">
          <el-icon>
            <Plus />
          </el-icon>
          新增词汇
        </el-button>
      </div>
    </div>

    <!-- 词汇列表 -->
    <el-table v-loading="loading" :data="vocabularyList" style="width: 100%" border>
      <el-table-column type="index" label="序号" width="80" align="center">
        <template #default="scope">
          {{ (currentPage - 1) * pageSize + scope.$index + 1 }}
        </template>
      </el-table-column>
      <el-table-column prop="word" label="词汇" min-width="120">
        <template #default="{ row }">
          <div class="word-cell">
            <span class="word">{{ row.word }}</span>
            <span class="phonetic">{{ row.phonetic }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="发音" width="180">
        <template #default="{ row }">
          <div class="pronunciation-cell">
            <el-button type="primary" link @click="handlePlayAudio(row.word, 'uk')">
              <el-icon>
                <Microphone />
              </el-icon>英式
            </el-button>
            <el-button type="primary" link @click="handlePlayAudio(row.word, 'us')">
              <el-icon>
                <Microphone />
              </el-icon>美式
            </el-button>
          </div>
        </template>
      </el-table-column>
      <el-table-column prop="meaning" label="释义" min-width="200" show-overflow-tooltip />
      <el-table-column prop="example" label="例句" min-width="300" show-overflow-tooltip />
      <el-table-column prop="difficultyLevel" label="难度" width="100">
        <template #default="{ row }">
          <el-tag :type="getDifficultyTag(row.difficultyLevel)">
            {{ row.difficultyLevel }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column prop="isPhrase" label="类型" width="100">
        <template #default="{ row }">
          <el-tag :type="row.isPhrase === '词组' ? 'warning' : 'info'">
            {{ row.isPhrase }}
          </el-tag>
        </template>
      </el-table-column>
      <el-table-column label="操作" width="320" fixed="right">
        <template #default="{ row }">
          <div class="action-buttons">
            <el-button type="primary" @click="handleEdit(row)" size="small">
              <el-icon>
                <Edit />
              </el-icon>
              编辑
            </el-button>
            <el-button type="danger" @click="handleDelete(row)" size="small">
              <el-icon>
                <Delete />
              </el-icon>
              删除
            </el-button>
            <el-button type="info" size="small" @click="handleShowRelated(row)">
              <el-icon>
                <Connection />
              </el-icon>
              相关词汇
            </el-button>
          </div>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[10, 20, 30]"
        :total="total" layout="total, sizes, prev, pager, next, jumper" background />
    </div>

    <!-- 添加/编辑词汇弹窗 -->
    <el-dialog v-model="dialogVisible" :title="dialogType === 'add' ? '新增词汇' : '编辑词汇'" width="600px" destroy-on-close>
      <el-form ref="formRef" :model="vocabularyForm" :rules="rules" label-width="100px">
        <el-form-item label="词汇类型" prop="isPhrase">
          <el-radio-group v-model="vocabularyForm.isPhrase">
            <el-radio value="单词">单词</el-radio>
            <el-radio value="词组">词组</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="词汇" prop="word">
          <el-input v-model="vocabularyForm.word" placeholder="请输入词汇" />
        </el-form-item>
        <el-form-item label="音标" prop="phonetic">
          <el-input v-model="vocabularyForm.phonetic" placeholder="请输入音标" />
        </el-form-item>
        <el-form-item label="释义" prop="meaning">
          <el-input v-model="vocabularyForm.meaning" type="textarea" :rows="2" placeholder="请输入释义" />
        </el-form-item>
        <el-form-item label="例句" prop="example">
          <el-input v-model="vocabularyForm.example" type="textarea" :rows="3" placeholder="请输入例句" />
        </el-form-item>
        <el-form-item label="难度等级" prop="difficultyLevel">
          <el-select v-model="vocabularyForm.difficultyLevel" placeholder="请选择难度等级">
            <el-option label="初级" value="初级" />
            <el-option label="中级" value="中级" />
            <el-option label="高级" value="高级" />
          </el-select>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmit" :loading="submitLoading">确定</el-button>
      </template>
    </el-dialog>

    <!-- 相关词汇弹窗 -->
    <el-dialog v-model="relatedDialogVisible" :title="`${currentWord?.word || ''} 的相关词汇`" width="600px" destroy-on-close
      class="related-dialog">
      <div v-loading="loading" class="related-content">
        <div v-if="currentWord" class="current-word">
          <div class="word-info">
            <span class="word">{{ currentWord.word }}</span>
            <el-tag size="small" effect="plain" class="type-tag">
              {{ currentWord.isPhrase === '词组' ? '词组' : '单词' }}
            </el-tag>
          </div>
          <div class="phonetic-row">
            <span class="phonetic">[{{ currentWord.phonetic }}]</span>
            <el-button type="primary" link size="small" @click="handlePlayAudio(currentWord.word, 'uk')">
              <el-icon>
                <VideoPlay />
              </el-icon>
              播放发音
            </el-button>
          </div>
          <div class="meaning">{{ currentWord.meaning }}</div>

          <!-- 例句部分 -->
          <div v-if="exampleSentences.length > 0" class="examples-section">
            <div class="examples-header">
              <div class="examples-title">例句：</div>
              <el-button type="primary" link size="small" @click="handleUpdateExample">
                <el-icon>
                  <Edit />
                </el-icon>
                更新到当前词汇
              </el-button>
            </div>
            <div v-for="(example, index) in exampleSentences.slice(0, 3)" :key="index" class="example">
              <div class="example-header">
                <div class="example-en">{{ example.en }}</div>
                <el-button type="primary" link size="small" @click="handlePlayAudio(example.en)">
                  <el-icon>
                    <VideoPlay />
                  </el-icon>
                </el-button>
              </div>
              <div class="example-zh">{{ example.zh }}</div>
              <div class="example-source" v-if="example.source">{{ example.source }}</div>
            </div>
          </div>
        </div>

        <el-divider>
          <div class="divider-content">
            <el-icon>
              <Connection />
            </el-icon>
            <span>相关词汇</span>
          </div>
        </el-divider>

        <div class="related-list" v-if="relatedWords.length">
          <el-scrollbar height="300px">
            <div v-for="item in relatedWords" :key="item.entry" class="related-item">
              <div class="entry-row">
                <div class="entry-with-audio">
                  <span class="entry">{{ item.entry }}</span>
                  <el-button type="primary" link size="small" @click="handlePlayAudio(item.entry)">
                    <el-icon>
                      <Microphone />
                    </el-icon>
                  </el-button>
                </div>
                <el-button type="primary" link size="small" @click="handleAddToVocabulary(item)">
                  <el-icon>
                    <Plus />
                  </el-icon>
                  添加到词库
                </el-button>
              </div>
              <div class="explain">{{ item.explain }}</div>

              <!-- 例句部分 -->
              <div v-if="item.examples && item.examples.length > 0" class="examples-section">
                <div class="examples-title">例句：</div>
                <div v-for="(example, index) in item.examples.slice(0, 2)" :key="index" class="example">
                  <div class="example-header">
                    <div class="example-en">{{ example.en }}</div>
                    <el-button type="primary" link size="small" @click="handlePlayAudio(example.en)">
                      <el-icon>
                        <VideoPlay />
                      </el-icon>
                    </el-button>
                  </div>
                  <div class="example-zh">{{ example.zh }}</div>
                  <div class="example-source" v-if="example.source">{{ example.source }}</div>
                </div>
              </div>
            </div>
          </el-scrollbar>
        </div>
        <el-empty v-else description="暂无相关词汇" />
      </div>
    </el-dialog>
  </div>
</template>

<script setup lang="ts">
import { ref, reactive, onMounted, watch } from 'vue'
import type { FormInstance } from 'element-plus'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Search, Plus, Edit, Delete, More, Connection, VideoPlay, Microphone } from '@element-plus/icons-vue'
import { getVocabularyList, addVocabulary, updateVocabulary, deleteVocabulary, searchVocabulary } from '@/api/vocabulary'
import type { Vocabulary } from '@/api/vocabulary'
import { getDictList, getDictVoice, getTranslation } from '@/api/dict'
import axios from 'axios'
// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const searchQuery = ref('')
const difficultyLevel = ref('')
const isPhrase = ref('')
const vocabularyList = ref<Vocabulary[]>([])
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const submitLoading = ref(false)
const formRef = ref<FormInstance>()

// 相关词汇弹窗
const relatedDialogVisible = ref(false)
const currentWord = ref<Vocabulary | null>(null)
const relatedWords = ref<Array<{ entry: string; explain: string; examples: Array<{ en: string, zh: string, source: string }> }>>([])
const exampleSentences = ref<Array<{ en: string, zh: string, source: string }>>([])

// 表单数据
const vocabularyForm = reactive({
  id: '',
  word: '',
  phonetic: '',
  meaning: '',
  example: '',
  difficultyLevel: '初级',
  isPhrase: '单词'
})

// 表单校验规则
const rules = {
  word: [{ required: true, message: '请输入词汇', trigger: 'blur' }],
  phonetic: [{ required: true, message: '请输入音标', trigger: 'blur' }],
  meaning: [{ required: true, message: '请输入释义', trigger: 'blur' }],
  example: [{ required: true, message: '请输入例句', trigger: 'blur' }],
  difficultyLevel: [{ required: true, message: '请选择难度等级', trigger: 'change' }],
  isPhrase: [{ required: true, message: '请选择词汇类型', trigger: 'change' }]
}

// 获取词汇列表
const fetchVocabularyList = async () => {
  loading.value = true
  try {
    const res = await getVocabularyList({
      current: currentPage.value,
      pageSize: pageSize.value,
      difficultyLevel: difficultyLevel.value,
      isPhrase: isPhrase.value
    })
    vocabularyList.value = res.data.records
    total.value = parseInt(res.data.total)
  } catch (error) {
    console.error('获取词汇列表失败:', error)
  } finally {
    loading.value = false
  }
}

// 处理搜索
const handleSearch = async () => {
  if (!searchQuery.value) {
    fetchVocabularyList()
    return
  }

  loading.value = true
  try {
    const res = await searchVocabulary(searchQuery.value)
    vocabularyList.value = res.data
    total.value = res.data.length
  } catch (error) {
    console.error('搜索词汇失败:', error)
  } finally {
    loading.value = false
  }
}

// 获取难度标签类型
const getDifficultyTag = (level: string) => {
  const map: Record<string, string> = {
    '初级': 'success',
    '中级': 'warning',
    '高级': 'danger'
  }
  return map[level] || ''
}

// 新增词汇
const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
  vocabularyForm.difficultyLevel = '初级'
  vocabularyForm.isPhrase = '单词'
}

// 编辑词汇
const handleEdit = (row: Vocabulary) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  Object.assign(vocabularyForm, row)
}

// 删除词汇
const handleDelete = (row: Vocabulary) => {
  ElMessageBox.confirm('确定要删除该词汇吗？', '提示', {
    type: 'warning'
  }).then(async () => {
    try {
      await deleteVocabulary(row.id)
      ElMessage.success('删除成功')
      fetchVocabularyList()
    } catch (error) {
      ElMessage.error('删除失败')
    }
  })
}

// 提交表单
const handleSubmit = async () => {
  if (!formRef.value) return

  await formRef.value.validate(async (valid) => {
    if (valid) {
      submitLoading.value = true
      try {
        if (dialogType.value === 'add') {
          await addVocabulary(vocabularyForm)
          ElMessage.success('添加成功')
        } else {
          await updateVocabulary(vocabularyForm as Vocabulary)
          ElMessage.success('更新成功')
        }
        dialogVisible.value = false
        fetchVocabularyList()
      } catch (error) {
        ElMessage.error(dialogType.value === 'add' ? '添加失败' : '更新失败')
      } finally {
        submitLoading.value = false
      }
    }
  })
}

// 监听分页变化
watch([currentPage, pageSize], () => {
  fetchVocabularyList()
})

// 监听筛选条件变化
watch([difficultyLevel, isPhrase], () => {
  currentPage.value = 1
  fetchVocabularyList()
})

// 监听搜索变化
watch(searchQuery, () => {
  currentPage.value = 1
  fetchVocabularyList()
})

// 监听弹窗关闭
watch(dialogVisible, (val) => {
  if (!val) {
    formRef.value?.resetFields()
  }
})

// 处理相关词汇
const handleShowRelated = async (row: Vocabulary) => {
  currentWord.value = row
  loading.value = true
  try {
    // API调用获取相关词汇
    const res = await getDictList({
      q: row.word
    })

    // 获取例句
    const translation = await getTranslation({
      q: row.word
    })

    // 处理例句数据
    exampleSentences.value = translation.individual?.pastExamSents || []

    // 将例句添加到相关词汇中
    relatedWords.value = res.data.entries.map((item: any) => ({
      entry: item.entry,
      explain: item.explain,
      examples: []
    }))

    relatedDialogVisible.value = true
  } catch (error) {
    console.error('获取相关词汇失败:', error)
    ElMessage.error('获取相关词汇失败')
  } finally {
    loading.value = false
  }
}

// 更新例句到当前词汇
const handleUpdateExample = async () => {
  if (!currentWord.value || exampleSentences.value.length === 0) return

  try {
    // 格式化例句：英文例句 + 中文翻译，用换行符分隔不同例句
    const formattedExamples = exampleSentences.value.slice(0, 3).map(example => {
      return `EN: ${example.en}\nZH: ${example.zh}${example.source ? '\nSource: ' + example.source : ''}`;
    }).join('\n\n');

    // 创建更新对象
    const updateData = {
      ...currentWord.value,
      example: formattedExamples
    }

    await updateVocabulary(updateData)
    ElMessage.success('例句更新成功')
    fetchVocabularyList() // 刷新列表
    relatedDialogVisible.value = false // 关闭弹窗
  } catch (error) {
    console.error('更新例句失败:', error)
    ElMessage.error('更新例句失败')
  }
}

// 添加到词库
const handleAddToVocabulary = (item: { entry: string; explain: string; examples: Array<{ en: string, zh: string, source: string }> }) => {
  dialogType.value = 'add'
  vocabularyForm.word = item.entry
  vocabularyForm.meaning = item.explain

  // 如果有例句，使用第一个例句
  if (item.examples && item.examples.length > 0) {
    vocabularyForm.example = item.examples[0].en
  }

  vocabularyForm.difficultyLevel = '初级'
  vocabularyForm.isPhrase = item.entry.includes(' ') ? '词组' : '单词'
  dialogVisible.value = true
  relatedDialogVisible.value = false
}

// 播放音频
const handlePlayAudio = (word: string, type: 'uk' | 'us' = 'uk') => {
  const audioType = type === 'uk' ? 0 : 1; // 0 for UK, 1 for US
  const audio = new Audio(`http://dict.youdao.com/dictvoice?type=${audioType}&audio=${word}`);

  // 添加错误处理
  audio.onerror = () => {
    ElMessage.warning('暂无该单词音频，会尽快更新！');
  };

  // 添加加载处理
  audio.onloadeddata = () => {
    audio.play().catch(err => {
      console.error('播放音频失败:', err);
      ElMessage.warning('播放音频失败');
    });
  };

  // 尝试加载音频
  audio.load();
};

// 初始化
onMounted(() => {
  fetchVocabularyList()
})
</script>

<style lang="scss" scoped>
.vocabulary-container {
  padding: 20px;
  background-color: #fff;
  border-radius: 8px;
  min-height: calc(100vh - 40px);

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .title {
      font-size: 20px;
      font-weight: bold;
    }

    .actions {
      display: flex;
      gap: 12px;

      .el-select {
        width: 180px;
      }

      .search-input {
        width: 200px;
      }
    }
  }

  .pagination {
    margin-top: 20px;
    padding: 10px 20px;
    background-color: #fff;
    border-radius: 8px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);
    display: flex;
    justify-content: flex-end;
  }

  :deep(.el-table) {
    border-radius: 8px;
    overflow: hidden;

    .el-table__header-wrapper {
      th {
        background-color: #f5f7fa;
        color: #606266;
        font-weight: 600;
      }
    }

    .el-button {
      padding: 6px 16px;
    }
  }

  .word-cell {
    display: flex;
    flex-direction: column;

    .word {
      font-weight: 500;
      color: #303133;
    }

    .phonetic {
      font-size: 12px;
      color: #909399;
      margin-top: 4px;
    }
  }

  .action-buttons {
    display: flex;
    gap: 8px;
    justify-content: center;

    .el-button {
      .el-icon {
        margin-right: 4px;
      }
    }
  }

  .pronunciation-cell {
    display: flex;
    gap: 12px;
    align-items: center;
    justify-content: center;

    .el-button {
      padding: 4px 10px;
      font-size: 13px;
      border: 1px solid #d9ecff;
      background-color: #ecf5ff;
      border-radius: 4px;
      transition: all 0.3s;
      height: 32px;
      min-width: 70px;

      &:hover {
        background-color: #d9ecff;
      }

      &:active {
        background-color: #c6e2ff;
      }

      .el-icon {
        margin-right: 4px;
        font-size: 14px;
        vertical-align: middle;
      }
    }
  }

  .related-dialog {
    :deep(.el-dialog__header) {
      margin-right: 0;
      padding: 20px 24px;
      border-bottom: 1px solid #dcdfe6;

      .el-dialog__title {
        font-size: 18px;
        font-weight: 600;
      }
    }

    .related-content {
      min-height: 200px;

      .current-word {
        padding: 16px 20px;
        background-color: #f5f7fa;
        border-radius: 8px;
        margin-bottom: 24px;

        .word-info {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 8px;

          .word {
            font-size: 24px;
            font-weight: 600;
            color: #303133;
          }

          .type-tag {
            position: relative;
            top: -2px;
          }
        }

        .phonetic-row {
          display: flex;
          align-items: center;
          gap: 12px;
          margin-bottom: 12px;

          .phonetic {
            font-size: 15px;
            color: #409eff;
            font-style: italic;
          }
        }

        .meaning {
          color: #606266;
          line-height: 1.6;
          font-size: 14px;
        }

        .examples-section {
          margin-top: 16px;

          .examples-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;

            .examples-title {
              font-size: 14px;
              font-weight: 500;
              color: #606266;
            }
          }

          .example {
            background-color: #f8f9fb;
            padding: 10px 12px;
            border-radius: 4px;
            border-left: 3px solid #dcdfe6;
            margin-bottom: 8px;

            &:last-child {
              margin-bottom: 0;
            }

            .example-header {
              display: flex;
              justify-content: space-between;
              align-items: flex-start;

              .example-en {
                flex: 1;
              }

              .el-button {
                padding: 2px;
                margin-left: 8px;
              }
            }

            .example-zh {
              color: #606266;
              line-height: 1.5;
              font-size: 13px;
              margin-bottom: 4px;
            }

            .example-source {
              color: #909399;
              font-size: 12px;
              text-align: right;
              font-style: italic;
            }
          }
        }
      }

      .divider-content {
        display: flex;
        align-items: center;
        gap: 6px;
        color: #909399;
        font-size: 14px;

        .el-icon {
          font-size: 16px;
        }
      }

      .related-list {
        .related-item {
          padding: 16px;
          border-bottom: 1px solid #ebeef5;
          transition: background-color 0.3s;

          &:last-child {
            border-bottom: none;
          }

          &:hover {
            background-color: #f5f7fa;
          }

          .entry-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;

            .entry-with-audio {
              display: flex;
              align-items: center;
              gap: 8px;

              .el-button {
                padding: 2px;
              }
            }
          }
        }
      }
    }
  }
}
</style>
