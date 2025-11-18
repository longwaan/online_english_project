package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.exception.BusinessException;
import com.exam.model.dto.chapter.ChapterAddRequest;
import com.exam.model.entity.Chapter;
import com.exam.model.vo.ChapterVO;
import com.exam.service.ChapterService;
import com.exam.utils.FileUploadUtil;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/chapter")
@Api(tags = "章节管理接口")
@Slf4j
public class ChapterController {

    @Resource
    private ChapterService chapterService;

    /**
     * 上传章节封面
     */
    @PostMapping("/upload/cover")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "上传章节封面", notes = "上传章节封面图片")
    public BaseResponse<String> uploadChapterCover(
            @ApiParam(value = "章节ID") @RequestParam Long chapterId,
            @ApiParam(value = "封面文件") @RequestPart MultipartFile file) {
        if (chapterId == null || chapterId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "章节ID不能为空");
        }
        if (file == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "文件不能为空");
        }
        
        // 获取章节信息
        Chapter chapter = chapterService.getById(chapterId);
        if (chapter == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "章节不存在");
        }
        
        // 删除原有封面
        if (StringUtils.isNotBlank(chapter.getCoverImage())) {
            FileUploadUtil.deleteFile(chapter.getCoverImage());
        }
        
        // 上传新封面
        String coverUrl = FileUploadUtil.uploadFile(file, "chapter");
        
        // 更新章节封面
        chapter.setCoverImage(coverUrl);
        boolean result = chapterService.updateById(chapter);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "更新失败");
        }
        
        return ResultUtils.success(coverUrl);
    }

    /**
     * 上传章节视频
     */
    @PostMapping("/upload/video")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "上传章节视频", notes = "上传章节视频文件")
    public BaseResponse<String> uploadChapterVideo(
            @ApiParam(value = "章节ID") @RequestParam Long chapterId,
            @ApiParam(value = "视频文件") @RequestPart MultipartFile file,
            @ApiParam(value = "视频时长(秒)") @RequestParam(required = false) Integer duration) {
        if (chapterId == null || chapterId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "章节ID不能为空");
        }
        if (file == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "文件不能为空");
        }
        
        // 获取章节信息
        Chapter chapter = chapterService.getById(chapterId);
        if (chapter == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "章节不存在");
        }
        
        // 删除原有视频
        if (StringUtils.isNotBlank(chapter.getVideoUrl())) {
            FileUploadUtil.deleteFile(chapter.getVideoUrl());
        }
        
        // 上传新视频
        String videoUrl = FileUploadUtil.uploadFile(file, "video");
        
        // 更新章节视频信息
        chapter.setVideoUrl(videoUrl);
        if (duration != null) {
            chapter.setDuration(duration);
        }
        boolean result = chapterService.updateById(chapter);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "更新失败");
        }
        
        return ResultUtils.success(videoUrl);
    }

    // 修改创建章节的逻辑，支持上传封面和视频
    @PostMapping("/add")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "创建章节", notes = "创建新的课程章节")
    public BaseResponse<Long> addChapter(
            @ApiParam(value = "章节信息") @RequestPart("chapterInfo") ChapterAddRequest chapterAddRequest,
            @ApiParam(value = "封面文件") @RequestPart(value = "coverFile", required = false) MultipartFile coverFile,
            @ApiParam(value = "视频文件") @RequestPart(value = "videoFile", required = false) MultipartFile videoFile,
            @ApiParam(value = "视频时长(秒)") @RequestParam(required = false) Integer duration) {
        if (chapterAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Chapter chapter = new Chapter();
        BeanUtils.copyProperties(chapterAddRequest, chapter);
        
        // 上传封面
        if (coverFile != null) {
            String coverUrl = FileUploadUtil.uploadFile(coverFile, "chapter");
            chapter.setCoverImage(coverUrl);
        }
        
        // 上传视频
        if (videoFile != null) {
            String videoUrl = FileUploadUtil.uploadFile(videoFile, "video");
            chapter.setVideoUrl(videoUrl);
            if (duration != null) {
                chapter.setDuration(duration);
            }
        }
        
        chapterService.validChapter(chapter, true);
        boolean result = chapterService.save(chapter);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR);
        }
        return ResultUtils.success(chapter.getId());
    }

    // 修改更新章节的逻辑，支持更新封面和视频
    @PostMapping("/update")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "更新章节", notes = "更新章节信息")
    public BaseResponse<Boolean> updateChapter(
            @ApiParam(value = "章节信息") @RequestPart("chapterInfo") Chapter chapter,
            @ApiParam(value = "封面文件") @RequestPart(value = "coverFile", required = false) MultipartFile coverFile,
            @ApiParam(value = "视频文件") @RequestPart(value = "videoFile", required = false) MultipartFile videoFile,
            @ApiParam(value = "视频时长(秒)") @RequestParam(required = false) Integer duration) {
        if (chapter == null || chapter.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        // 获取原章节信息
        Chapter oldChapter = chapterService.getById(chapter.getId());
        if (oldChapter == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        
        // 上传新封面
        if (coverFile != null) {
            // 删除原有封面
            if (StringUtils.isNotBlank(oldChapter.getCoverImage())) {
                FileUploadUtil.deleteFile(oldChapter.getCoverImage());
            }
            // 上传新封面
            String coverUrl = FileUploadUtil.uploadFile(coverFile, "chapter");
            chapter.setCoverImage(coverUrl);
        }
        
        // 上传新视频
        if (videoFile != null) {
            // 删除原有视频
            if (StringUtils.isNotBlank(oldChapter.getVideoUrl())) {
                FileUploadUtil.deleteFile(oldChapter.getVideoUrl());
            }
            // 上传新视频
            String videoUrl = FileUploadUtil.uploadFile(videoFile, "video");
            chapter.setVideoUrl(videoUrl);
            if (duration != null) {
                chapter.setDuration(duration);
            }
        }
        
        chapterService.validChapter(chapter, false);
        boolean result = chapterService.updateById(chapter);
        return ResultUtils.success(result);
    }

    // 删除章节
    @PostMapping("/delete")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "删除章节", notes = "根据章节ID删除章节")
    public BaseResponse<Boolean> deleteChapter(@RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        boolean result = chapterService.removeById(deleteRequest.getId());
        return ResultUtils.success(result);
    }

    // 根据 id 获取章节
    @GetMapping("/get")
    @ApiOperation(value = "获取章节详情", notes = "根据章节ID获取章节详细信息")
    public BaseResponse<ChapterVO> getChapterById(
            @ApiParam(value = "章节ID", required = true) @RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Chapter chapter = chapterService.getById(id);
        ChapterVO chapterVO = chapterService.getChapterVO(chapter);
        return ResultUtils.success(chapterVO);
    }

    // 分页获取章节列表
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取章节", notes = "分页获取章节列表，可选择指定课程ID")
    public BaseResponse<Page<ChapterVO>> listChapterPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize,
            @ApiParam(value = "课程ID") @RequestParam(required = false) Long courseId) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        QueryWrapper<Chapter> queryWrapper = new QueryWrapper<>();
        if (courseId != null && courseId > 0) {
            queryWrapper.eq("courseId", courseId);
        }
        Page<Chapter> chapterPage = chapterService.page(new Page<>(current, pageSize), queryWrapper);
        
        // 转换为 VO
        Page<ChapterVO> chapterVOPage = new Page<>(current, pageSize, chapterPage.getTotal());
        List<ChapterVO> chapterVOList = chapterPage.getRecords().stream()
                .map(chapterService::getChapterVO)
                .collect(Collectors.toList());
        chapterVOPage.setRecords(chapterVOList);
        return ResultUtils.success(chapterVOPage);
    }

    /**
     * 获取课程下的所有章节
     */
    @GetMapping("/list/course/{courseId}")
    @ApiOperation(value = "获取课程章节列表", notes = "根据课程ID获取该课程下的所有章节信息")
    public BaseResponse<List<ChapterVO>> listChaptersByCourseId(
            @ApiParam(value = "课程ID", required = true) @PathVariable("courseId") Long courseId) {
        if (courseId == null || courseId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程ID不能为空");
        }
        QueryWrapper<Chapter> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("courseId", courseId);
        queryWrapper.orderByAsc("id");
        List<Chapter> chapterList = chapterService.list(queryWrapper);
        
        // 转换为 VO
        List<ChapterVO> chapterVOList = chapterList.stream()
                .map(chapterService::getChapterVO)
                .collect(Collectors.toList());
        return ResultUtils.success(chapterVOList);
    }
} 