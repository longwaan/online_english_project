package com.exam.controller;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.exam.annotation.AuthCheck;
import com.exam.common.BaseResponse;
import com.exam.common.DeleteRequest;
import com.exam.common.ErrorCode;
import com.exam.common.ResultUtils;
import com.exam.constant.UserConstant;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.model.dto.postcomment.PostCommentAddRequest;
import com.exam.model.entity.PostComment;
import com.exam.model.entity.User;
import com.exam.model.vo.PostCommentVO;
import com.exam.service.PostCommentService;
import com.exam.service.UserService;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.BeanUtils;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/post_comment")
@Api(tags = "帖子评论接口")
@Slf4j
public class PostCommentController {

    @Resource
    private PostCommentService postCommentService;
    
    @Resource
    private UserService userService;

    /**
     * 创建评论
     */
    @PostMapping("/add")
    @ApiOperation(value = "创建评论", notes = "创建新的评论")
    public BaseResponse<Long> addPostComment(@RequestBody @Valid PostCommentAddRequest postCommentAddRequest,
            HttpServletRequest request) {
        if (postCommentAddRequest == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        PostComment postComment = new PostComment();
        BeanUtils.copyProperties(postCommentAddRequest, postComment);
        
        // 获取登录用户
        User loginUser = userService.getLoginUser(request);
        postComment.setUserId(loginUser.getId());
        
        postCommentService.validPostComment(postComment, true);
        boolean result = postCommentService.save(postComment);
        ThrowUtils.throwIf(!result, ErrorCode.OPERATION_ERROR);
        return ResultUtils.success(postComment.getId());
    }

    /**
     * 删除评论
     */
    @PostMapping("/delete")
    @ApiOperation(value = "删除评论", notes = "根据评论ID删除评论")
    public BaseResponse<Boolean> deletePostComment(@RequestBody DeleteRequest deleteRequest,
            HttpServletRequest request) {
        if (deleteRequest == null || deleteRequest.getId() <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        long id = deleteRequest.getId();
        // 判断是否存在
        PostComment postComment = postCommentService.getById(id);
        ThrowUtils.throwIf(postComment == null, ErrorCode.NOT_FOUND_ERROR);
        // 仅本人或管理员可删除
        if (!postComment.getUserId().equals(loginUser.getId()) && !userService.isAdmin(loginUser)) {
            throw new BusinessException(ErrorCode.NO_AUTH_ERROR);
        }
        boolean result = postCommentService.removeById(id);
        return ResultUtils.success(result);
    }

    /**
     * 根据ID获取评论
     */
    @GetMapping("/get")
    @ApiOperation(value = "获取评论", notes = "根据评论ID获取评论详情")
    public BaseResponse<PostCommentVO> getPostCommentById(@RequestParam long id) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        PostComment postComment = postCommentService.getById(id);
        if (postComment == null) {
            throw new BusinessException(ErrorCode.NOT_FOUND_ERROR);
        }
        PostCommentVO postCommentVO = postCommentService.getPostCommentVO(postComment);
        return ResultUtils.success(postCommentVO);
    }

    /**
     * 分页获取评论列表
     */
    @GetMapping("/list/page")
    @ApiOperation(value = "分页获取评论", notes = "分页获取评论列表")
    public BaseResponse<Page<PostCommentVO>> listPostCommentByPage(
            @ApiParam(value = "当前页码", required = true) @RequestParam long current,
            @ApiParam(value = "每页大小", required = true) @RequestParam long pageSize,
            @ApiParam(value = "帖子ID") @RequestParam(required = false) Long postId) {
        if (current <= 0 || pageSize <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        QueryWrapper<PostComment> queryWrapper = new QueryWrapper<>();
        if (postId != null && postId > 0) {
            queryWrapper.eq("postId", postId);
        }
        queryWrapper.orderByDesc("createTime");
        
        Page<PostComment> postCommentPage = postCommentService.page(new Page<>(current, pageSize), queryWrapper);
        
        // 转换为VO
        Page<PostCommentVO> postCommentVOPage = new Page<>(current, pageSize, postCommentPage.getTotal());
        List<PostCommentVO> postCommentVOList = postCommentPage.getRecords().stream()
                .map(postCommentService::getPostCommentVO)
                .collect(Collectors.toList());
        postCommentVOPage.setRecords(postCommentVOList);
        
        return ResultUtils.success(postCommentVOPage);
    }

    /**
     * 点赞评论
     */
    @PostMapping("/like/{id}")
    @ApiOperation(value = "点赞评论", notes = "给评论点赞")
    public BaseResponse<Boolean> likeComment(@PathVariable long id, HttpServletRequest request) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        boolean result = postCommentService.likeComment(id, loginUser.getId());
        return ResultUtils.success(result);
    }

    /**
     * 取消点赞评论
     */
    @PostMapping("/unlike/{id}")
    @ApiOperation(value = "取消点赞", notes = "取消评论点赞")
    public BaseResponse<Boolean> unlikeComment(@PathVariable long id, HttpServletRequest request) {
        if (id <= 0) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        User loginUser = userService.getLoginUser(request);
        boolean result = postCommentService.unlikeComment(id, loginUser.getId());
        return ResultUtils.success(result);
    }
} 