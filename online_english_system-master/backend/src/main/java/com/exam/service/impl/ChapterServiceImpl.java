package com.exam.service.impl;

import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.exam.common.ErrorCode;
import com.exam.exception.BusinessException;
import com.exam.mapper.ChapterMapper;
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

@Service
public class ChapterServiceImpl extends ServiceImpl<ChapterMapper, Chapter> implements ChapterService {

    @Resource
    CourseMapper courseMapper;

    @Override
    public void validChapter(Chapter chapter, boolean add) {
        if (chapter == null) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR);
        }
        String title = chapter.getTitle();
        Long courseId = chapter.getCourseId();

        // 创建时，参数不能为空
        if (add) {
            if (StringUtils.isBlank(title)) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "章节标题不能为空");
            }
            if (courseId == null || courseId <= 0) {
                throw new BusinessException(ErrorCode.PARAMS_ERROR, "课程ID不能为空");
            }
        }
        // 有参数则校验
        if (StringUtils.isNotBlank(title) && title.length() > 512) {
            throw new BusinessException(ErrorCode.PARAMS_ERROR, "章节标题过长");
        }
    }

    @Override
    public ChapterVO getChapterVO(Chapter chapter) {
        if (chapter == null) {
            return null;
        }
        ChapterVO chapterVO = new ChapterVO();
        CourseVO courseVO = new CourseVO();
        Course course = courseMapper.selectById(chapter.getCourseId());
        BeanUtils.copyProperties(course, courseVO);
        chapterVO.setCourseVO(courseVO);
        BeanUtils.copyProperties(chapter, chapterVO);
        return chapterVO;
    }
} 