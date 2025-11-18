package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.exception.BusinessException;
import com.exam.model.dto.course.CourseAddRequest;
import com.exam.model.dto.course.CourseUpdateRequest;
import com.exam.model.dto.course.CourseQueryRequest;
import com.exam.model.entity.Course;
import com.exam.model.entity.User;
import com.exam.model.vo.CourseVO;
import com.exam.service.CourseService;
import com.exam.service.UserService;
import com.exam.utils.FileUploadUtil;
import com.exam.utils.JsonUtils;

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
@RequestMapping("/course")
@Api(tags = "课程管理接口")
@Slf4j
public class CourseController {

    @Resource
    private CourseService courseService;

    @Resource
    private UserService userService;

    /**
     * 上传课程封面
     */
    @PostMapping("/upload/cover")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "上传课程封面", notes = "上传课程封面图片")
    public BaseResponse<String> uploadCourseCover(
            @ApiParam(value = "课程ID") @RequestParam Long courseId,
            @ApiParam(value = "封面文件") @RequestPart MultipartFile file) {
        if (courseId == null || courseId <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程ID不能为空");
        }
        if (file == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "文件不能为空");
        }

        // 获取课程信息
        Course course = courseService.getById(courseId);
        if (course == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "课程不存在");
        }

        // 删除原有封面
        if (StringUtils.isNotBlank(course.getCoverImage())) {
            FileUploadUtil.deleteFile(course.getCoverImage());
        }

        // 上传新封面
        String coverUrl = FileUploadUtil.uploadFile(file, "course");

        // 更新课程封面
        course.setCoverImage(coverUrl);
        boolean result = courseService.updateById(course);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR, "更新失败");
        }

        return ResultUtils.success(coverUrl);
    }

    // 修改创建课程的逻辑，支持上传封面
    @PostMapping("/add")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "创建课程", notes = "创建新的课程信息")
    public BaseResponse<Long> addCourse(
            @RequestParam("courseInfo") String courseInfoStr,
            @RequestPart(value = "coverFile", required = false) MultipartFile coverFile) {
        if (StringUtils.isBlank(courseInfoStr)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        // 解析课程信息
        CourseAddRequest courseAddRequest;
        try {
            courseAddRequest = JsonUtils.toObject(courseInfoStr, CourseAddRequest.class);
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程信息格式错误");
        }
        
        Course course = new Course();
        BeanUtils.copyProperties(courseAddRequest, course);

        // 上传封面
        if (coverFile != null) {
            String coverUrl = FileUploadUtil.uploadFile(coverFile, "course");
            course.setCoverImage(coverUrl);
        }

        courseService.validCourse(course, true);
        boolean result = courseService.save(course);
        if (!result) {
            throw new BusinessException(ErrorCode.OPERATION_ERROR);
        }
        return ResultUtils.success(course.getId());
    }

    // 修改更新课程的逻辑，支持更新封面
    @PostMapping("/update")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "更新课程", notes = "更新课程信息")
    public BaseResponse<Boolean> updateCourse(
            @RequestParam("courseInfo") String courseInfoStr,
            @RequestPart(value = "coverFile", required = false) MultipartFile coverFile) {
        if (StringUtils.isBlank(courseInfoStr)) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        // 解析课程信息
        CourseUpdateRequest courseUpdateRequest;
        try {
            courseUpdateRequest = JsonUtils.toObject(courseInfoStr, CourseUpdateRequest.class);
        } catch (Exception e) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程信息格式错误");
        }
        
        // 校验课程ID
        if (courseUpdateRequest.getId() == null || courseUpdateRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程ID不能为空");
        }
        
        // 获取原课程信息
        Course oldCourse = courseService.getById(courseUpdateRequest.getId());
        if (oldCourse == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR, "课程不存在");
        }
        
        // 复制新的属性
        Course course = new Course();
        BeanUtils.copyProperties(courseUpdateRequest, course);
        
        // 处理封面上传
        if (coverFile != null) {
            // 删除原有封面
            if (StringUtils.isNotBlank(oldCourse.getCoverImage())) {
                FileUploadUtil.deleteFile(oldCourse.getCoverImage());
            }
            // 上传新封面
            String coverUrl = FileUploadUtil.uploadFile(coverFile, "course");
            course.setCoverImage(coverUrl);
        }
        
        // 校验课程信息
        courseService.validCourse(course, false);
        
        // 更新课程
        boolean result = courseService.updateById(course);
        return ResultUtils.success(result);
    }

    // 删除课程
    @PostMapping("/delete")
    @AuthCheck(mustRole = "admin")
    @ApiOperation(value = "删除课程", notes = "根据课程ID删除课程")
    public BaseResponse<Boolean> deleteCourse(
            @ApiParam(value = "删除请求", required = true) @RequestBody DeleteRequest deleteRequest) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        boolean result = courseService.removeById(deleteRequest.getId());
        return ResultUtils.success(result);
    }

    // 根据 id 获取课程
    @GetMapping("/get")
    @ApiOperation(value = "获取课程详情", notes = "根据课程ID获取课程详细信息")
    public BaseResponse<CourseVO> getCourseById(
            @ApiParam(value = "课程ID", required = true) @RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        Course course = courseService.getById(id);
        CourseVO courseVO = courseService.getCourseVO(course);
        return ResultUtils.success(courseVO);
    }

    // 分页获取课程列表
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取课程", notes = "分页获取课程列表")
    public BaseResponse<Page<CourseVO>> listCoursePage(CourseQueryRequest courseQueryRequest) {
        if (courseQueryRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        Course courseQuery = new Course();
        BeanUtils.copyProperties(courseQueryRequest, courseQuery);
        
        Page<Course> coursePage = courseService.page(new Page<>(courseQueryRequest.getCurrent(), 
                courseQueryRequest.getPageSize()),
                new QueryWrapper<>(courseQuery));
                
        Page<CourseVO> courseVOPage = new Page<>(courseQueryRequest.getCurrent(), 
                courseQueryRequest.getPageSize(), 
                coursePage.getTotal());
                
        List<CourseVO> courseVOList = coursePage.getRecords().stream()
                .map(courseService::getCourseVO)
                .collect(Collectors.toList());
                
        courseVOPage.setRecords(courseVOList);
        return ResultUtils.success(courseVOPage);
    }
} 