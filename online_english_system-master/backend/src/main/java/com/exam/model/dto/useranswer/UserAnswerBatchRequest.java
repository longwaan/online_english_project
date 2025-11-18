package com.exam.model.dto.useranswer;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Data;

import javax.validation.constraints.NotEmpty;
import javax.validation.constraints.NotNull;
import java.util.List;

@Data
@ApiModel("批量提交答案请求")
public class UserAnswerBatchRequest {
    
    @NotNull(message = "试卷ID不能为空")
    @ApiModelProperty("试卷ID")
    private Long examId;
    
    @NotEmpty(message = "答案列表不能为空")
    @ApiModelProperty("答案列表")
    private List<AnswerItem> answers;
    
    @Data
    public static class AnswerItem {
        @NotNull(message = "题目ID不能为空")
        private Long questionId;
        
        @NotNull(message = "答案不能为空")
        private String userAnswer;
        
        private String userNote;
    }
} 