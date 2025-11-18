package com.exam.service;

import com.baomidou.mybatisplus.extension.service.IService;
import com.exam.model.entity.Course;
import com.exam.model.vo.CourseVO;
import com.exam.model.entity.Chapter;
import com.exam.model.vo.ChapterVO;

public interface CourseService extends IService<Course> {
    /**
     * 校验课程信息
     */
    void validCourse(Course course, boolean add);

    /**
     * 获取课程VO
     * @param course 课程实体
     * @return 课程VO
     */
    CourseVO getCourseVO(Course course);

    /**
     * 获取章节VO
     * @param chapter 章节实体
     * @return 章节VO
     */
    ChapterVO getChapterVO(Chapter chapter);
} 