<template>
  <div class="exams-container">
    <!-- 头部搜索和操作 -->
    <div class="header">
      <div class="title">试卷管理</div>
      <div class="actions">
        <el-input v-model="searchQuery" placeholder="搜索试卷" class="search-input" clearable>
          <template #prefix>
            <el-icon>
              <Search />
            </el-icon>
          </template>
        </el-input>
        <el-button type="primary" @click="handleAdd">
          <el-icon>
            <Plus />
          </el-icon>新增试卷
        </el-button>
      </div>
    </div>

    <!-- 试卷列表 -->
    <el-table v-loading="loading" :data="examList" style="width: 100%" @row-click="handleRowClick"
      :header-cell-style="{ background: '#f5f7fa' }" border>
      <el-table-column prop="id" label="ID" width="80" align="center" />
      <el-table-column prop="title" label="试卷标题" min-width="100">
        <template #default="{ row }">
          <div class="exam-title-cell">
            <span class="title">{{ row.title }}</span>

          </div>
        </template>
      </el-table-column>
      <el-table-column prop="description" label="试卷描述" min-width="200" show-overflow-tooltip />
      <el-table-column prop="totalScore" label="总分" width="100" align="center">
        <template #default="{ row }">
          <el-tag type="success">{{ row.totalScore }}分</el-tag>
        </template>
      </el-table-column>
      <el-table-column label="考试时间" width="340">
        <template #default="{ row }">
          <div class="exam-time">
            <el-icon>
              <Timer />
            </el-icon>
            <span>{{ row.startTime }} ~ {{ row.endTime }}</span>
          </div>
        </template>
      </el-table-column>
      <el-table-column label="题目" width="120" align="center">
        <template #default="{ row }">
          <el-button size="small" @click.stop="handleViewQuestions(row)" class="view-questions-btn">
            查看题目
            <el-badge :value="row.questionList?.length || 0" :max="99" class="question-count" />
          </el-button>

        </template>
      </el-table-column>
      <el-table-column label="操作" width="230" fixed="right">
        <template #default="{ row }">
          <el-button type="primary"  @click.stop="handlePreview(row)">预览</el-button>
          <el-button type="primary"  @click.stop="handleEdit(row)">编辑</el-button>
          <el-button type="danger"  @click.stop="handleDelete(row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>

    <!-- 分页 -->
    <div class="pagination">
      <el-pagination v-model:current-page="currentPage" v-model:page-size="pageSize" :page-sizes="[10, 20, 30]"
        :total="total" layout="total, sizes, prev, pager, next, jumper" background class="pagination-content" />
    </div>

    <!-- 题目列表抽屉 -->
    <el-drawer v-model="drawerVisible" :title="`${currentExam.title || ''} - 试题列表`" direction="rtl" size="60%"
      destroy-on-close>
      <div class="questions-container">
        <div class="questions-header">
          <div class="info">
            <div class="info-item">
              <span class="label">总分：</span>
              <el-tag type="success">{{ currentExam.totalScore }}分</el-tag>
            </div>
            <div class="info-item">
              <span class="label">题目数：</span>
              <el-tag type="info">{{ currentExam.questionList?.length || 0 }}道</el-tag>
            </div>
          </div>
          <el-button type="primary" @click="handleAddQuestion">
            <el-icon>
              <Plus />
            </el-icon>添加题目
          </el-button>
        </div>

        <!-- 题目列表 -->
        <div class="questions-list">
          <el-collapse v-model="activeQuestions">
            <el-collapse-item v-for="(question, index) in currentExam.questionList" :key="question.id"
              :name="question.id">
              <template #title>
                <div class="question-header">
                  <span class="question-index">第 {{ index + 1 }} 题</span>
                  <el-tag size="small" :type="getQuestionTypeTag(question.questionType)">
                    {{ question.questionType }}
                  </el-tag>
                  <span class="question-score">{{ question.score }}分</span>
                </div>
              </template>

              <div class="question-content">
                <div class="question-text">{{ question.questionText }}</div>
                <div class="question-options">
                  <template v-if="question.options">
                    <div v-for="(value, key) in JSON.parse(question.options)" :key="key" class="option-item"
                      :class="{ 'correct-answer': isCorrectAnswer(question, key) }">
                      <span class="option-key">{{ key }}.</span>
                      <span class="option-value">{{ value }}</span>
                      <el-icon v-if="isCorrectAnswer(question, key)" class="correct-icon"><Select /></el-icon>
                    </div>
                  </template>
                </div>
                <div class="question-info">
                  <div class="answer-info">
                    <el-tag size="small" :type="getDifficultyTag(question.difficultyLevel)">
                      {{ question.difficultyLevel }}
                    </el-tag>
                    <div class="correct-answer">
                      <span class="label">正确答案：</span>
                      <span class="value">{{ formatAnswer(question) }}</span>
                    </div>
                  </div>
                  <div class="explanation">
                    <span class="label">解析：</span>
                    <span class="text">{{ question.explanation }}</span>
                  </div>
                </div>
                <div class="question-actions">
                  <el-button type="primary" link size="small" @click="handleEditQuestion(question)">
                    编辑
                  </el-button>
                  <el-button type="danger" link size="small" @click="handleDeleteQuestion(question)">
                    删除
                  </el-button>
                </div>
              </div>
            </el-collapse-item>
          </el-collapse>
        </div>
      </div>
    </el-drawer>

    <!-- 预览试卷弹窗 -->
    <el-dialog v-model="previewVisible" :title="currentExam.title" width="1000px" class="exam-preview-dialog"
      destroy-on-close top="2vh">
      <div class="exam-preview">
        <!-- 试卷头部信息 -->
        <div class="exam-header">
          <h1 class="exam-title">{{ currentExam.title }}</h1>
          <div class="exam-description" v-if="currentExam.description">
            {{ currentExam.description }}
          </div>
          <div class="exam-meta">
            <div class="info-item">
              <el-icon>
                <Timer />
              </el-icon>
              <span>考试时长：{{ calculateDuration }}</span>
            </div>
            <div class="info-item">
              <el-icon>
                <Trophy />
              </el-icon>
              <span>总分：{{ currentExam.totalScore }}分</span>
            </div>
            <div class="info-item">
              <el-icon>
                <Warning />
              </el-icon>
              <span>注意事项：请认真阅读题目，独立完成。</span>
            </div>
          </div>
        </div>

        <!-- 试题列表 -->
        <div class="exam-content">
          <!-- 题型分组 -->
          <template v-for="type in QUESTION_TYPES" :key="type">
            <div v-if="getQuestionsByType(currentExam, type).length > 0" class="question-section">
              <div class="section-header">
                <span class="section-type">{{ type }}题</span>
                <span class="section-score">
                  (共{{ getQuestionsByType(currentExam, type).length }}题，
                  {{ calculateTypeScore(type) }}分)
                </span>
              </div>

              <div class="questions-list">
                <div v-for="(question, index) in getQuestionsByType(currentExam, type)" :key="question.id"
                  class="question-item">
                  <div class="question-header">
                    <div class="question-title">
                      <span class="question-index">{{ getQuestionIndex(type, index) }}.</span>
                      <span class="question-text">{{ question.questionText }}</span>
                      <span class="question-score">({{ question.score }}分)</span>
                    </div>
                  </div>

                  <div class="question-content">
                    <template v-if="['单选', '多选'].includes(type)">
                      <el-radio-group v-if="type === '单选'" v-model="answers[question.id]" class="option-list">
                        <el-radio 
                          v-for="(value, key) in JSON.parse(question.options)" 
                          :key="key" 
                          :value="key" 
                          class="option-item"
                        >
                          {{ key }}. {{ value }}
                        </el-radio>
                      </el-radio-group>

                      <el-checkbox-group v-else v-model="answers[question.id]" class="option-list">
                        <el-checkbox 
                          v-for="(value, key) in JSON.parse(question.options)" 
                          :key="key" 
                          :value="key"
                          class="option-item"
                        >
                          {{ key }}. {{ value }}
                        </el-checkbox>
                      </el-checkbox-group>
                    </template>

                    <template v-else-if="type === '判断'">
                      <el-radio-group v-if="type === '判断'" v-model="answers[question.id]" class="option-list">
                        <el-radio :value="'true'" class="option-item">正确</el-radio>
                        <el-radio :value="'false'" class="option-item">错误</el-radio>
                      </el-radio-group>
                    </template>

                    <template v-else>
                      <el-input v-model="answers[question.id]" type="textarea" :rows="4" placeholder="请在此处作答..."
                        resize="none" />
                    </template>
                  </div>
                </div>
              </div>
            </div>
          </template>
        </div>

        <!-- 底部操作栏 -->
        <div class="exam-footer">
          <div class="progress-info">
            <el-progress :percentage="calculateProgress" :format="format => `已完成 ${format}%`" :stroke-width="14" />
          </div>
          <div class="actions">
            <el-button @click="previewVisible = false">退出预览</el-button>
            <el-button type="primary" @click="handleSubmit">提交答案</el-button>
          </div>
        </div>
      </div>
    </el-dialog>

    <!-- 添加试卷弹窗 -->
    <el-dialog
      v-model="dialogVisible"
      :title="dialogType === 'add' ? '新增试卷' : '编辑试卷'"
      width="600px"
      destroy-on-close
    >
      <el-form
        ref="formRef"
        :model="examForm"
        :rules="rules"
        label-width="100px"
      >
        <el-form-item label="试卷标题" prop="title">
          <el-input v-model="examForm.title" placeholder="请输入试卷标题" />
        </el-form-item>
        <el-form-item label="试卷描述" prop="description">
          <el-input
            v-model="examForm.description"
            type="textarea"
            :rows="3"
            placeholder="请输入试卷描述"
          />
        </el-form-item>
        <el-form-item label="考试时间" prop="examTime">
          <el-date-picker
            v-model="examForm.examTime"
            type="datetimerange"
            range-separator="至"
            start-placeholder="开始时间"
            end-placeholder="结束时间"
            value-format="YYYY-MM-DD HH:mm:ss"
            :disabled-date="disabledDate"
            :disabled-time="disabledTime"
            @change="handleTimeChange"
          />
        </el-form-item>
        <el-form-item label="总分" prop="totalScore">
          <el-input-number v-model="examForm.totalScore" :min="0" :max="999" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="dialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleSubmitExam" :loading="submitLoading">
          确定
        </el-button>
      </template>
    </el-dialog>

    <!-- 添加/编辑题目弹窗 -->
    <el-dialog
      v-model="questionDialogVisible"
      :title="questionDialogType === 'add' ? '新增题目' : '编辑题目'"
      width="700px"
      destroy-on-close
    >
      <el-form
        ref="questionFormRef"
        :model="questionForm"
        :rules="questionRules"
        label-width="100px"
      >
        <el-form-item label="题目类型" prop="questionType">
          <el-select v-model="questionForm.questionType" placeholder="请选择题目类型">
            <el-option
              v-for="type in QUESTION_TYPES"
              :key="type"
              :label="type"
              :value="type"
            />
          </el-select>
        </el-form-item>
        
        <el-form-item label="题目内容" prop="questionText">
          <el-input
            v-model="questionForm.questionText"
            type="textarea"
            :rows="3"
            placeholder="请输入题目内容"
          />
        </el-form-item>
        
        <el-form-item 
          label="选项" 
          prop="options" 
          v-if="['单选', '多选'].includes(questionForm.questionType)"
        >
          <div 
            v-for="(option, index) in optionList" 
            :key="index" 
            class="option-input"
          >
            <span class="option-label">{{ String.fromCharCode(65 + index) }}.</span>
            <el-input v-model="option.value" placeholder="请输入选项内容" />
            <el-button 
              type="danger" 
              link 
              @click="removeOption(index)"
              :disabled="optionList.length <= 2"
            >
              删除
            </el-button>
          </div>
          <el-button 
            type="primary" 
            link 
            @click="addOption"
            :disabled="optionList.length >= 6"
          >
            添加选项
          </el-button>
        </el-form-item>
        
        <el-form-item label="正确答案" prop="correctAnswer">
          <template v-if="questionForm.questionType === '单选'">
            <el-radio-group v-model="questionForm.correctAnswer">
              <el-radio 
                v-for="(_, index) in optionList" 
                :key="index" 
                :value="String.fromCharCode(65 + index)"
              >
                {{ String.fromCharCode(65 + index) }}
              </el-radio>
            </el-radio-group>
          </template>
          
          <template v-else-if="questionForm.questionType === '多选'">
            <el-checkbox-group v-model="multipleAnswer">
              <el-checkbox 
                v-for="(_, index) in optionList" 
                :key="index" 
                :value="String.fromCharCode(65 + index)"
              >
                {{ String.fromCharCode(65 + index) }}
              </el-checkbox>
            </el-checkbox-group>
          </template>
          
          <template v-else-if="questionForm.questionType === '判断'">
            <el-radio-group v-model="questionForm.correctAnswer">
              <el-radio :value="'true'">正确</el-radio>
              <el-radio :value="'false'">错误</el-radio>
            </el-radio-group>
          </template>
          
          <template v-else>
            <el-input
              v-model="questionForm.correctAnswer"
              type="textarea"
              :rows="2"
              placeholder="请输入参考答案"
            />
          </template>
        </el-form-item>
        
        <el-form-item label="分值" prop="score">
          <el-input-number v-model="questionForm.score" :min="1" :max="100" />
        </el-form-item>
        
        <el-form-item label="难度" prop="difficultyLevel">
          <el-select v-model="questionForm.difficultyLevel" placeholder="请选择难度">
            <el-option label="简单" value="简单" />
            <el-option label="中等" value="中等" />
            <el-option label="困难" value="困难" />
          </el-select>
        </el-form-item>
        
        <el-form-item label="解析" prop="explanation">
          <el-input
            v-model="questionForm.explanation"
            type="textarea"
            :rows="3"
            placeholder="请输入题目解析"
          />
        </el-form-item>
      </el-form>
      
      <template #footer>
        <el-button @click="questionDialogVisible = false">取消</el-button>
        <el-button 
          type="primary" 
          @click="handleSubmitQuestion"
          :loading="questionSubmitLoading"
        >
          确定
        </el-button>
      </template>
    </el-dialog>
  </div>
</template>

<style scoped lang="scss">
.exams-container {
  padding: 20px;

  .header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .title {
      font-size: 20px;
      font-weight: 600;
      color: var(--el-text-color-primary);
    }

    .actions {
      display: flex;
      gap: 12px;

      .search-input {
        width: 240px;
      }
    }
  }

  .exam-time {
    display: flex;
    align-items: center;
    gap: 6px;
    color: var(--el-text-color-regular);

    .el-icon {
      color: var(--el-text-color-secondary);
    }
  }

  :deep(.el-table) {
    border-radius: 8px;
    overflow: hidden;

    .el-table__header {
      th {
        font-weight: 600;
        color: #1f2937;
        height: 48px;
      }
    }

    .el-table__row {
      cursor: pointer;
      transition: background-color 0.3s;

      &:hover {
        background-color: #f8fafc !important;
      }

      td {
        padding: 12px 0;
        height: 70px;
      }
    }
  }

  .exam-title-cell {
    display: flex;
    align-items: center;
    gap: 8px;

    .title {
      font-weight: 500;
      color: #1f2937;
    }

    .count-tag {
      font-size: 12px;
      border-radius: 12px;
      padding: 0 8px;
      height: 22px;
      line-height: 20px;
      background-color: #f3f4f6;
      color: #6b7280;
      border-color: #e5e7eb;
    }
  }

  .question-info {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 8px;

    .question-tags {
      display: flex;
      gap: 4px;

      .type-tag {
        min-width: 24px;
        height: 20px;
        padding: 0 4px;
        font-size: 12px;
      }
    }
  }

  .view-questions-btn {
    position: relative;
    padding-right: 32px;
    height: 32px;

    .question-count {
      position: absolute;
      top: 0px;
      right: 0px;
      transform: scale(0.9);

      :deep(.el-badge__content) {
        background-color: var(--el-color-primary);
        border: 2px solid #fff;
        height: 20px;
        padding: 0 6px;
        line-height: 16px;
      }
    }
  }

  .pagination {
    // margin-top: 20px;
    padding: 20px;
    background-color: #fff;
    // border-radius: 8px;
    box-shadow: 0 1px 4px rgba(0, 0, 0, 0.05);

    .pagination-content {
      display: flex;
      justify-content: flex-end;

      :deep(.el-pagination) {
        .el-pagination__total {
          margin-right: auto; // 总数靠左
        }

        .el-pagination__sizes {
          margin-right: 16px;
        }

        button {
          background-color: #fff;

          &:hover {
            color: var(--el-color-primary);
          }

          &:disabled {
            background-color: #f5f7fa;
          }
        }

        .el-pager li {
          background-color: #fff;

          &.is-active {
            background-color: var(--el-color-primary);
            color: #fff;
          }

          &:hover {
            color: var(--el-color-primary);
          }
        }

        .el-pagination__jump {
          margin-left: 16px;

          .el-input__inner {
            height: 28px;
            line-height: 28px;
          }
        }
      }
    }
  }
}

.questions-container {
  padding: 0 20px;

  .questions-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;

    .info {
      display: flex;
      gap: 20px;

      .info-item {
        display: flex;
        align-items: center;
        gap: 8px;

        .label {
          color: var(--el-text-color-regular);
        }
      }
    }
  }

  .questions-list {
    .question-header {
      display: flex;
      align-items: center;
      gap: 12px;

      .question-index {
        font-weight: 500;
      }

      .question-score {
        color: var(--el-color-success);
        margin-left: auto;
      }
    }

    .question-content {
      padding: 16px;

      .question-text {
        font-size: 15px;
        color: var(--el-text-color-primary);
        margin-bottom: 16px;
      }

      .question-options {
        margin-bottom: 16px;

        .option-item {
          display: flex;
          align-items: center;
          gap: 8px;
          margin-bottom: 8px;
          padding: 8px 12px;
          border-radius: 4px;
          transition: background-color 0.2s;

          &.correct-answer {
            background-color: var(--el-color-success-light-9);
            border: 1px solid var(--el-color-success-light-5);
          }

          .option-key {
            color: var(--el-text-color-secondary);
            font-weight: 500;
            min-width: 24px;
          }

          .option-value {
            color: var(--el-text-color-regular);
            flex: 1;
          }

          .correct-icon {
            color: var(--el-color-success);
            font-size: 16px;
          }
        }
      }

      .question-info {
        display: flex;
        align-items: flex-start;
        gap: 16px;
        margin-bottom: 16px;

        .answer-info {
          display: flex;
          align-items: center;
          gap: 16px;

          .correct-answer {
            display: flex;
            align-items: center;
            gap: 8px;

            .label {
              color: var(--el-text-color-secondary);
            }

            .value {
              color: var(--el-color-success);
              font-weight: 500;
            }
          }
        }

        .explanation {
          flex: 1;

          .label {
            color: var(--el-text-color-secondary);
            margin-right: 8px;
          }

          .text {
            color: var(--el-text-color-regular);
          }
        }
      }

      .question-actions {
        display: flex;
        justify-content: flex-end;
        gap: 12px;
      }
    }
  }
}

.exam-preview-dialog {
  :deep(.el-dialog__body) {
    padding: 0;
    height: calc(96vh - 120px);
    overflow-y: auto;

    &::-webkit-scrollbar {
      width: 6px;
    }

    &::-webkit-scrollbar-thumb {
      background-color: #dcdfe6;
      border-radius: 3px;
    }
  }
}

.exam-preview {
  background-color: #fff;
  padding: 30px 40px;

  .exam-header {
    text-align: center;
    margin-bottom: 40px;
    padding-bottom: 20px;
    border-bottom: 1px solid #ebeef5;

    .exam-title {
      font-size: 24px;
      font-weight: bold;
      color: #303133;
      margin-bottom: 16px;
    }

    .exam-description {
      font-size: 14px;
      color: #606266;
      line-height: 1.6;
      margin-bottom: 20px;
      padding: 0 40px;
    }

    .exam-meta {
      display: flex;
      justify-content: center;
      gap: 40px;

      .info-item {
        display: flex;
        align-items: center;
        gap: 8px;
        color: #606266;

        .el-icon {
          color: #909399;
        }
      }
    }
  }

  .exam-content {
    .question-section {
      margin-bottom: 40px;

      .section-header {
        margin-bottom: 20px;
        padding-left: 8px;
        border-left: 4px solid var(--el-color-primary);

        .section-type {
          font-size: 16px;
          font-weight: bold;
          color: #303133;
          margin-right: 8px;
        }

        .section-score {
          color: #909399;
          font-size: 14px;
        }
      }

      .question-item {
        margin-bottom: 32px;

        .question-header {
          margin-bottom: 16px;

          .question-title {
            display: flex;
            align-items: flex-start;
            gap: 8px;

            .question-index {
              color: var(--el-color-primary);
              font-weight: 500;
              flex-shrink: 0;
            }

            .question-text {
              flex: 1;
              color: #303133;
            }

            .question-score {
              color: #f56c6c;
              font-size: 14px;
              flex-shrink: 0;
              margin-left: 8px;
            }
          }
        }

        .question-content {
          padding-left: 24px;

          .option-list {
            display: flex;
            flex-direction: column;
            gap: 16px;

            :deep(.el-radio),
            :deep(.el-checkbox) {
              margin-right: 0;
              width: 100%;
              padding: 8px 16px;
              border-radius: 4px;
              transition: all 0.3s;
              align-items: flex-start;

              &:hover {
                background-color: var(--el-color-primary-light-9);
              }

              .el-radio__label,
              .el-checkbox__label {
                white-space: normal;
                line-height: 1.5;
                padding-left: 8px;
              }

              .el-radio__input,
              .el-checkbox__input {
                margin-top: 3px;
              }
            }
          }

          .el-input {
            background-color: #f8f9fa;
            border-radius: 4px;

            :deep(.el-textarea__inner) {
              background-color: transparent;
              padding: 12px;
              font-size: 14px;

              &::placeholder {
                color: #c0c4cc;
              }
            }
          }
        }
      }
    }
  }

  .exam-footer {
    position: sticky;
    bottom: 0;
    left: 0;
    right: 0;
    padding: 16px 24px;
    background: #fff;
    border-top: 1px solid #ebeef5;
    display: flex;
    justify-content: space-between;
    align-items: center;

    .progress-info {
      width: 200px;
    }

    .actions {
      display: flex;
      gap: 12px;
    }
  }
}

.option-input {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 8px;
  
  .option-label {
    width: 24px;
    text-align: right;
  }
}
</style>

<script setup lang="ts">
import { ref, reactive, onMounted, watch, computed } from 'vue'
import { Search, Plus, Timer, Document, VideoPlay, Calendar, Edit, Close, Select, Trophy, Warning } from '@element-plus/icons-vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import type { FormInstance } from 'element-plus'
import type { Exam, Question } from '@/api/exam/type'
import { addExam, addQuestion, deleteExam, deleteQuestion, getExamDetail, getExamList, updateExam, updateQuestion } from '@/api/exam/index'
// import {
//   getExamList,
//   getExamDetail,
//   addExam,
//   updateExam,
//   deleteExam,
//   addQuestion,
//   updateQuestion,
//   deleteQuestion,
//   type Exam,
//   type Question
// } from '@/api/exam'

// 状态定义
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(10)
const total = ref(0)
const searchQuery = ref('')
const examList = ref<Exam[]>([])
const drawerVisible = ref(false)
const currentExam = ref<Exam>({} as Exam)
const activeQuestions = ref<string[]>([])
const previewVisible = ref(false)
const answers = ref<Record<string, any>>({})
const dialogVisible = ref(false)
const dialogType = ref<'add' | 'edit'>('add')
const submitLoading = ref(false)
const formRef = ref<FormInstance>()
const questionDialogVisible = ref(false)
const questionDialogType = ref<'add' | 'edit'>('add')
const questionSubmitLoading = ref(false)
const questionFormRef = ref<FormInstance>()
const multipleAnswer = ref<string[]>([])

// 添加题型常量
const QUESTION_TYPES = ['单选', '多选', '判断', '简答'] as const
type QuestionType = typeof QUESTION_TYPES[number]

// 获取试卷列表
const fetchExamList = async () => {
  loading.value = true
  try {
    const res = await getExamList({
      current: currentPage.value,
      pageSize: pageSize.value,
      searchQuery: searchQuery.value
    })
    examList.value = res.data.records
    total.value = Number(res.data.total)
  } catch (error) {
    ElMessage.error('获取试卷列表失败')
  } finally {
    loading.value = false
  }
}

// 分页处理
const handleSizeChange = (val: number) => {
  pageSize.value = val
  fetchExamList()
}

const handleCurrentChange = (val: number) => {
  currentPage.value = val
  fetchExamList()
}

// 标签类型
const getQuestionTypeTag = (type: string) => {
  const map: Record<string, string> = {
    '单选': 'info',
    '多选': 'success',
    '判断': 'warning',
    '简答': 'danger'
  }
  return map[type] || ''
}

const getDifficultyTag = (level: string) => {
  const map: Record<string, string> = {
    '简单': 'success',
    '中等': 'warning',
    '困难': 'danger'
  }
  return map[level] || ''
}

// 查看题目
const handleViewQuestions = (row: Exam) => {
  currentExam.value = row
  drawerVisible.value = true
}

// 删除试卷
const handleDelete = async (row: Exam) => {
  try {
    await ElMessageBox.confirm('确定要删除该试卷吗？', '提示', {
      type: 'warning'
    })
    await deleteExam(row.id)
    ElMessage.success('删除成功')
    fetchExamList()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 删除试题
const handleDeleteQuestion = async (question: Question) => {
  try {
    await ElMessageBox.confirm('确定要删除该题目吗？', '提示', {
      type: 'warning'
    })
    await deleteQuestion(question.id)
    ElMessage.success('删除成功')
    // 重新获取试卷详情以更新题目列表
    const res = await getExamDetail(currentExam.value.id)
    currentExam.value = res.data
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

// 编辑试卷
const handleEdit = (row: Exam) => {
  dialogType.value = 'edit'
  dialogVisible.value = true
  // 填充表单数据
  examForm.title = row.title
  examForm.description = row.description || ''
  examForm.examTime = [row.startTime, row.endTime]
  examForm.totalScore = row.totalScore
  currentExam.value = row
}

// 预览试卷
const handlePreview = (row: Exam) => {
  currentExam.value = row
  previewVisible.value = true
}

// 添加试题
const handleAddQuestion = () => {
  questionDialogType.value = 'add'
  questionDialogVisible.value = true
  
  // 重置表单并设置试卷ID
  resetQuestionForm()
  questionForm.examId = currentExam.value.id
}

// 编辑试题
const handleEditQuestion = async (question: Question) => {
  questionDialogType.value = 'edit'
  questionDialogVisible.value = true
  
  // 先重置表单
  resetQuestionForm()
  
  // 填充表单数据
  Object.assign(questionForm, {
    ...question,
    options: question.options || ''  // 确保options有值
  })
  
  // 立即处理选项数据
  if (['单选', '多选'].includes(question.questionType) && question.options) {
    try {
      const options = JSON.parse(question.options)
      optionList.value = Object.entries(options).map(([_, value]) => ({ value: value as string }))
    } catch (error) {
      optionList.value = [{ value: '' }, { value: '' }]
      console.error('解析选项失败:', error)
    }
  }
  
  // 处理多选答案
  if (question.questionType === '多选' && question.correctAnswer) {
    multipleAnswer.value = question.correctAnswer.split(',')
  }
}

// 添加重置表单的函数
const resetQuestionForm = () => {
  // 重置表单数据
  Object.assign(questionForm, {
    questionType: '',
    questionText: '',
    options: '',
    correctAnswer: '',
    score: 1,
    difficultyLevel: '简单',
    explanation: '',
    examId: currentExam.value.id
  })
  
  // 重置选项列表
  optionList.value = [{ value: '' }, { value: '' }]
  
  // 重置多选答案
  multipleAnswer.value = []
  
  // 重置表单验证
  questionFormRef.value?.resetFields()
}

// 新增试卷
const handleAdd = () => {
  dialogType.value = 'add'
  dialogVisible.value = true
}

// 行点击事件
const handleRowClick = (row: Exam) => {
  handleViewQuestions(row)
}

// 判断是否为正确答案
const isCorrectAnswer = (question: Question, key: string): boolean => {
  if (!question.correctAnswer) return false
  if (question.questionType === '多选') {
    return question.correctAnswer.split(',').includes(key)
  }
  return question.correctAnswer === key
}

// 格式化答案显示
const formatAnswer = (question: Question): string => {
  if (!question.correctAnswer) return '暂无'
  if (question.questionType === '多选') {
    return question.correctAnswer.split(',').join('、')
  }
  return question.correctAnswer
}

// 提交答案
const handleSubmit = () => {
  console.log('提交的答案：', answers.value)
  ElMessage.success('预览模式下不保存答案')
  previewVisible.value = false
  answers.value = {} // 重置答案
}

// 在关闭预览时重置答案
watch(previewVisible, (val) => {
  if (!val) {
    answers.value = {}
  }
})

// 初始化
onMounted(() => {
  fetchExamList()
})

// 修改 getQuestionsByType 方法，添加 exam 参数
const getQuestionsByType = (exam: Exam, type: string) => {
  return exam.questionList?.filter(q => q.questionType === type) || []
}

const calculateTypeScore = (type: string) => {
  return getQuestionsByType(currentExam, type).reduce((sum, q) => sum + q.score, 0)
}

const getQuestionIndex = (type: string, index: number) => {
  const typeMap = { '单选': 1, '多选': 2, '判断': 3, '简答': 4 }
  return index + 1
}

const calculateProgress = computed(() => {
  if (!currentExam.value.questionList) return 0
  const total = currentExam.value.questionList.length
  const answered = Object.keys(answers.value).length
  return Math.round((answered / total) * 100)
})

// 计算考试时长
const calculateDuration = computed(() => {
  if (!currentExam.value.startTime || !currentExam.value.endTime) return '未设置'

  const start = new Date(currentExam.value.startTime)
  const end = new Date(currentExam.value.endTime)
  const durationMs = end.getTime() - start.getTime()

  // 转换为小时和分钟
  const hours = Math.floor(durationMs / (1000 * 60 * 60))
  const minutes = Math.floor((durationMs % (1000 * 60 * 60)) / (1000 * 60))

  if (hours === 0) {
    return `${minutes}分钟`
  } else if (minutes === 0) {
    return `${hours}小时`
  } else {
    return `${hours}小时${minutes}分钟`
  }
})

// 表单数据
const examForm = reactive<{
  title: string
  description: string
  examTime: [string, string] | null
  totalScore: number
}>({
  title: '',
  description: '',
  examTime: null,
  totalScore: 0
})

// 表单校验规则
const rules = {
  title: [{ required: true, message: '请输入试卷标题', trigger: 'blur' }],
  examTime: [
    { required: true, message: '请选择考试时间', trigger: 'change' },
    {
      validator: (rule: any, value: [string, string] | null, callback: Function) => {
        if (value) {
          const [start, end] = value
          const startTime = new Date(start)
          const endTime = new Date(end)
          const durationMs = endTime.getTime() - startTime.getTime()
          const durationMinutes = durationMs / (1000 * 60)
          
          if (startTime.toDateString() !== endTime.toDateString()) {
            callback(new Error('考试开始和结束时间必须在同一天内'))
          } else if (durationMinutes < 30) {
            callback(new Error('考试时间不能少于30分钟'))
          } else if (durationMs > 8 * 3600 * 1000) {
            callback(new Error('考试时间不能超过8小时'))
          } else {
            callback()
          }
        } else {
          callback()
        }
      },
      trigger: 'change'
    }
  ],
  totalScore: [{ required: true, message: '请输入总分', trigger: 'blur' }]
}

// 提交试卷表单
const handleSubmitExam = async () => {
  if (!formRef.value) return
  
  await formRef.value.validate(async (valid) => {
    if (valid && examForm.examTime) {
      submitLoading.value = true
      try {
        const data = {
          title: examForm.title,
          description: examForm.description,
          startTime: examForm.examTime[0],
          endTime: examForm.examTime[1],
          totalScore: examForm.totalScore
        }
        
        if (dialogType.value === 'add') {
          await addExam(data)
          ElMessage.success('新增成功')
        } else {
          await updateExam({
            ...data,
            id: currentExam.value.id,
            createTime: currentExam.value.createTime,
            updateTime: currentExam.value.updateTime,
            isDelete: currentExam.value.isDelete
          })
          ElMessage.success('更新成功')
        }
        
        dialogVisible.value = false
        fetchExamList()
      } catch (error) {
        ElMessage.error(dialogType.value === 'add' ? '新增失败' : '更新失败')
      } finally {
        submitLoading.value = false
      }
    }
  })
}

// 监听弹窗关闭，重置表单
watch(dialogVisible, (val) => {
  if (!val) {
    formRef.value?.resetFields()
  }
})

// 禁用日期
const disabledDate = (date: Date) => {
  return date.getTime() < Date.now() - 8.64e7 // 禁用今天之前的日期
}

// 禁用时间
const disabledTime = (date: Date, type: 'start' | 'end') => {
  if (type === 'end' && examForm.examTime?.[0]) {
    const startTime = new Date(examForm.examTime[0])
    const endTime = date
    
    // 如果不是同一天，禁用所有时间
    if (startTime.toDateString() !== endTime.toDateString()) {
      return {
        disabledHours: () => Array.from({ length: 24 }, (_, i) => i),
        disabledMinutes: () => Array.from({ length: 60 }, (_, i) => i),
        disabledSeconds: () => Array.from({ length: 60 }, (_, i) => i)
      }
    }
    
    // 计算可选时间范围
    const minEndTime = new Date(startTime)
    minEndTime.setMinutes(startTime.getMinutes() + 30)
    const maxEndTime = new Date(startTime)
    maxEndTime.setHours(startTime.getHours() + 8)
    
    const currentHour = endTime.getHours()
    const isMinHour = currentHour === minEndTime.getHours()
    const isMaxHour = currentHour === maxEndTime.getHours()
    
    return {
      disabledHours: () => {
        return Array.from({ length: 24 }, (_, i) => {
          return i < startTime.getHours() || i > startTime.getHours() + 8 ? i : -1
        }).filter(h => h !== -1)
      },
      disabledMinutes: (hour: number) => {
        if (isMinHour) {
          // 如果是最小小时，禁用小于最小分钟的选项
          return Array.from({ length: minEndTime.getMinutes() }, (_, i) => i)
        } else if (isMaxHour) {
          // 如果是最大小时，禁用大于最大分钟的选项
          return Array.from({ length: 60 }, (_, i) => i > maxEndTime.getMinutes() ? i : -1).filter(m => m !== -1)
        }
        return []
      },
      disabledSeconds: () => []
    }
  }
  return {}
}

// 处理时间变化
const handleTimeChange = (val: [string, string] | null) => {
  if (val) {
    const [start, end] = val
    const startTime = new Date(start)
    const endTime = new Date(end)
    const durationMs = endTime.getTime() - startTime.getTime()
    const durationMinutes = durationMs / (1000 * 60)
    
    // 如果不是同一天或超过8小时或少于30分钟，重置结束时间
    if (
      startTime.toDateString() !== endTime.toDateString() ||
      durationMs > 8 * 3600 * 1000 ||
      durationMinutes < 30
    ) {
      const maxEndTime = new Date(startTime)
      // 如果当前选择的时间少于30分钟，则设置为30分钟后
      if (durationMinutes < 30) {
        maxEndTime.setMinutes(startTime.getMinutes() + 30)
      } else {
        // 否则设置为8小时后
        maxEndTime.setHours(startTime.getHours() + 8)
      }
      examForm.examTime = [
        start,
        maxEndTime.toISOString().slice(0, 19).replace('T', ' ')
      ]
      ElMessage.warning('考试时间必须在30分钟到8小时之间，且必须在同一天内')
    }
  }
}

// 题目表单数据
const questionForm = reactive<Partial<Question>>({
  questionType: '',
  questionText: '',
  options: '',
  correctAnswer: '',
  score: 1,
  difficultyLevel: '简单',
  explanation: '',
  examId: ''
})

// 选项列表
const optionList = ref<{ value: string }[]>([
  { value: '' },
  { value: '' }
])

// 添加选项
const addOption = () => {
  if (optionList.value.length < 6) {
    optionList.value.push({ value: '' })
  }
}

// 删除选项
const removeOption = (index: number) => {
  optionList.value.splice(index, 1)
}

// 修改题目表单校验规则
const questionRules = {
  questionType: [{ required: true, message: '请选择题目类型', trigger: 'change' }],
  questionText: [{ required: true, message: '请输入题目内容', trigger: 'blur' }],
  correctAnswer: [
    { required: true, message: '请设置正确答案', trigger: 'change' },
    {
      validator: (rule: any, value: string, callback: Function) => {
        if (questionForm.questionType === '多选' && (!multipleAnswer.value || multipleAnswer.value.length === 0)) {
          callback(new Error('请选择正确答案'))
        } else if (questionForm.questionType === '单选' && !value) {
          callback(new Error('请选择正确答案'))
        } else if (questionForm.questionType === '判断' && !value) {
          callback(new Error('请选择正确答案'))
        } else if (questionForm.questionType === '简答' && !value.trim()) {
          callback(new Error('请输入参考答案'))
        } else {
          callback()
        }
      },
      trigger: 'change'
    }
  ],
  score: [{ required: true, message: '请设置分值', trigger: 'change' }],
  difficultyLevel: [{ required: true, message: '请选择难度', trigger: 'change' }]
}

// 修改提交题目表单的函数
const handleSubmitQuestion = async () => {
  if (!questionFormRef.value) return
  
  // 如果是多选题，先将多选答案同步到表单
  if (questionForm.questionType === '多选') {
    questionForm.correctAnswer = multipleAnswer.value.sort().join(',')
  }
  
  await questionFormRef.value.validate(async (valid) => {
    if (valid) {
      questionSubmitLoading.value = true
      try {
        // 处理选项
        if (['单选', '多选'].includes(questionForm.questionType!)) {
          const options: Record<string, string> = {}
          optionList.value.forEach((option, index) => {
            options[String.fromCharCode(65 + index)] = option.value
          })
          questionForm.options = JSON.stringify(options)
        }
        
        if (questionDialogType.value === 'add') {
          await addQuestion(questionForm)
          ElMessage.success('添加成功')
        } else {
          await updateQuestion(questionForm as Question)
          ElMessage.success('更新成功')
        }
        
        questionDialogVisible.value = false
        // 重新获取试卷详情以更新题目列表
        const res = await getExamDetail(currentExam.value.id)
        currentExam.value = res.data
        
        // 重置表单
        resetQuestionForm()
      } catch (error) {
        ElMessage.error(questionDialogType.value === 'add' ? '添加失败' : '更新失败')
      } finally {
        questionSubmitLoading.value = false
      }
    }
  })
}

// 监听弹窗关闭，重置表单
watch(questionDialogVisible, (val) => {
  if (!val) {
    resetQuestionForm()
  }
})

// 监听题目类型变化
watch(() => questionForm.questionType, (val) => {
  questionForm.correctAnswer = ''
  multipleAnswer.value = []
  
  if (['单选', '多选'].includes(val!)) {
    optionList.value = [{ value: '' }, { value: '' }]
  } else {
    optionList.value = []
  }
})

// 监听多选答案变化
watch(multipleAnswer, (val) => {
  if (questionForm.questionType === '多选') {
    questionForm.correctAnswer = val.sort().join(',')
  }
})
</script>