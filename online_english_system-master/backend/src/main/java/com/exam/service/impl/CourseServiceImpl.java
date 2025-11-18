package com.exam.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.exception.ThrowUtils;
import com.exam.mapper.CourseMapper;
import com.exam.model.entity.Chapter;
import com.exam.model.entity.Course;
import com.exam.model.vo.ChapterVO;
import com.exam.model.vo.CourseVO;
import com.exam.service.ChapterService;
import com.exam.service.CourseService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.BeanUtils;

import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class CourseServiceImpl extends ServiceImpl<CourseMapper, Course> implements CourseService {

    @Resource
    private ChapterService chapterService;

    /**
     * 校验课程信息
     */
    @Override
    public void validCourse(Course course, boolean add) {
        if (course == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        
        String title = course.getTitle();
        String description = course.getDescription();
        String level = course.getLevel();
        
        // 创建时，参数不能为空
        if (add) {
            ThrowUtils.throwIf(StringUtils.isAnyBlank(title, description, level),
                ErrorCode.PARAMS_ERROR);
        }
        
        // 有参数则校验
        if (StringUtils.isNotBlank(title) && title.length() > 50) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "标题过长");
        }
        if (StringUtils.isNotBlank(description) && description.length() > 500) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "描述过长");
        }
        if (StringUtils.isNotBlank(level)) {
            List<String> validLevels = Arrays.asList("初级", "中级", "高级");
            if (!validLevels.contains(level)) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程等级不合法");
            }
        }
    }

    @Override
    public CourseVO getCourseVO(Course course) {
        if (course == null) {
            return null;
        }
        CourseVO courseVO = new CourseVO();
        BeanUtils.copyProperties(course, courseVO);
        
        // 查询课程的章节数量
        QueryWrapper<Chapter> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("courseId", course.getId());
        queryWrapper.eq("isDelete", 0);
        int chapterCount = (int) chapterService.count(queryWrapper);
        courseVO.setChapterCount(chapterCount);
        
        // 查询课程的章节列表
        List<Chapter> chapterList = chapterService.list(queryWrapper);
        List<ChapterVO> chapterVOList = chapterList.stream()
                .map(this::getChapterVO)
                .collect(Collectors.toList());
        courseVO.setChapterList(chapterVOList);
        
        return courseVO;
    }
    
    @Override
    public ChapterVO getChapterVO(Chapter chapter) {
        if (chapter == null) {
            return null;
        }
        ChapterVO chapterVO = new ChapterVO();
        BeanUtils.copyProperties(chapter, chapterVO);
        return chapterVO;
    }
} 