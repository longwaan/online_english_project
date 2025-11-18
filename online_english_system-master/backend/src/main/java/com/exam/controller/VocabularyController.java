package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.StringUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.constant.UserConstant;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.model.dto.vocabulary.VocabularyAddRequest;
import com.exam.model.entity.Vocabulary;
import com.exam.model.vo.VocabularyVO;
import com.exam.service.VocabularyService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/vocabulary")
@Api(tags = "词汇管理接口")
@Slf4j
public class VocabularyController {

    @Resource
    private VocabularyService vocabularyService;

    /**
     * 创建词汇
     */
    @PostMapping("/add")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "创建词汇", notes = "创建新的词汇")
    public BaseResponse<Long> addVocabulary(@RequestBody @Valid VocabularyAddRequest vocabularyAddRequest) {
        if (vocabularyAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Vocabulary vocabulary = new Vocabulary();
        BeanUtils.copyProperties(vocabularyAddRequest, vocabulary);
        vocabularyService.validVocabulary(vocabulary, true);
        boolean result = vocabularyService.save(vocabulary);
        ThrowUtils.throwIf(!result, ErrorCode.OPERATION_ERROR);
        return ResultUtils.success(vocabulary.getId());
    }

    /**
     * 删除词汇
     */
    @PostMapping("/delete")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "删除词汇", notes = "根据词汇ID删除词汇")
    public BaseResponse<Boolean> deleteVocabulary(@RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        boolean result = vocabularyService.removeById(deleteRequest.getId());
        return ResultUtils.success(result);
    }

    /**
     * 更新词汇
     */
    @PostMapping("/update")
    @AuthCheck(mustRole = UserConstant.ADMIN_ROLE)
    @ApiOperation(value = "更新词汇", notes = "更新词汇信息")
    public BaseResponse<Boolean> updateVocabulary(@RequestBody Vocabulary vocabulary) {
        if (vocabulary == null || vocabulary.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        vocabularyService.validVocabulary(vocabulary, false);
        boolean result = vocabularyService.updateById(vocabulary);
        return ResultUtils.success(result);
    }

    /**
     * 根据ID获取词汇
     */
    @GetMapping("/get")
    @ApiOperation(value = "获取词汇", notes = "根据词汇ID获取词汇详情")
    public BaseResponse<VocabularyVO> getVocabularyById(@RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Vocabulary vocabulary = vocabularyService.getById(id);
        if (vocabulary == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        VocabularyVO vocabularyVO = vocabularyService.getVocabularyVO(vocabulary);
        return ResultUtils.success(vocabularyVO);
    }

    /**
     * 分页获取词汇列表
     */
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取词汇", notes = "分页获取词汇列表")
    public BaseResponse<Page<VocabularyVO>> listVocabularyByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize,
            @ApiParam(value = "难度级别") @RequestParam(required = false) String difficultyLevel,
            @ApiParam(value = "是否词组") @RequestParam(required = false) String isPhrase) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        QueryWrapper<Vocabulary> queryWrapper = new QueryWrapper<>();
        if (StringUtils.isNotBlank(difficultyLevel)) {
            queryWrapper.eq("difficultyLevel", difficultyLevel);
        }
        if (StringUtils.isNotBlank(isPhrase)) {
            queryWrapper.eq("isPhrase", isPhrase);
        }
        
        Page<Vocabulary> vocabularyPage = vocabularyService.page(new Page<>(current, pageSize), queryWrapper);
        
        // 转换为VO
        Page<VocabularyVO> vocabularyVOPage = new Page<>(current, pageSize, vocabularyPage.getTotal());
        List<VocabularyVO> vocabularyVOList = vocabularyPage.getRecords().stream()
                .map(vocabularyService::getVocabularyVO)
                .collect(Collectors.toList());
        vocabularyVOPage.setRecords(vocabularyVOList);
        
        return ResultUtils.success(vocabularyVOPage);
    }

    /**
     * 搜索词汇
     */
    @GetMapping("/search")
    @ApiOperation(value = "搜索词汇", notes = "根据关键词搜索词汇")
    public BaseResponse<List<VocabularyVO>> searchVocabulary(@RequestParam String keyword) {
        if (StringUtils.isBlank(keyword)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        QueryWrapper<Vocabulary> queryWrapper = new QueryWrapper<>();
        queryWrapper.like("word", keyword)
                .or()
                .like("meaning", keyword);
        
        List<Vocabulary> vocabularyList = vocabularyService.list(queryWrapper);
        List<VocabularyVO> vocabularyVOList = vocabularyList.stream()
                .map(vocabularyService::getVocabularyVO)
                .collect(Collectors.toList());
        
        return ResultUtils.success(vocabularyVOList);
    }
} 