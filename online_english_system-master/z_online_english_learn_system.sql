/*
 Navicat Premium Dump SQL

 Source Server         : mysqlDB
 Source Server Type    : MySQL
 Source Server Version : 80037 (8.0.37)
 Source Host           : localhost:3306
 Source Schema         : z_online_english_learn_system

 Target Server Type    : MySQL
 Target Server Version : 80037 (8.0.37)
 File Encoding         : 65001

 Date: 21/03/2025 22:09:55
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for chapter
-- ----------------------------
DROP TABLE IF EXISTS `chapter`;
CREATE TABLE `chapter`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '章节ID',
  `courseId` bigint NOT NULL COMMENT '所属课程ID',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '章节标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '章节内容',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `coverImage` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '章节封面图片',
  `videoUrl` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '章节视频链接',
  `duration` int NULL DEFAULT NULL COMMENT '章节视频时长（秒）',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `courseId`(`courseId` ASC) USING BTREE,
  CONSTRAINT `chapter_ibfk_1` FOREIGN KEY (`courseId`) REFERENCES `course` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 21 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '章节表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of chapter
-- ----------------------------
INSERT INTO `chapter` VALUES (1, 1, '第一章：Java简介', '本章节介绍Java的基本语法和历史', '2025-03-18 15:11:15', '2025-03-20 20:40:36', '/uploads/chapter/0f59eabb-e3b9-4e97-bb64-e649d39b5647.jpg', 'https://example.com/videos/java_intro.mp4', 300, 0);
INSERT INTO `chapter` VALUES (2, 1, '面向对象', '本章节讲解Java的面向对象特性', '2025-03-18 15:11:15', '2025-03-18 15:11:15', '/uploads/chapter/d445f7a7-a5be-4edb-82c9-7e6c65a3374d.jpg', 'https://example.com/videos/oop.mp4', 450, 0);
INSERT INTO `chapter` VALUES (3, 3, '第一章：日常对话', '在这一章节中，我们将通过情景对话，帮助学员学习如何进行日常交流。', '2025-03-18 16:02:54', '2025-03-18 16:02:54', '/uploads/chapter/ea4241a3-36f0-48a2-a1c4-65dcc7d6a3a9.jpg', 'https://example.com/videos/chapter1_video.mp4', 1800, 0);
INSERT INTO `chapter` VALUES (4, 3, '第二章：发音技巧', '这一章节重点介绍英语发音的基本技巧，帮助学员纠正发音问题，提升口语流利度。', '2025-03-18 16:02:54', '2025-03-18 16:02:54', 'https://example.com/images/chapter2_cover.jpg', 'https://example.com/videos/chapter2_video.mp4', 1500, 0);
INSERT INTO `chapter` VALUES (5, 4, '第一章：文章结构', '本章将帮助学员掌握英语写作的基本框架，包括引言、正文和结论的安排。', '2025-03-18 16:02:54', '2025-03-18 16:02:54', 'https://example.com/images/chapter1_cover.jpg', 'https://example.com/videos/chapter1_video.mp4', 2100, 0);
INSERT INTO `chapter` VALUES (6, 4, '第二章：论证技巧', '在这一章节中，我们将介绍如何通过清晰的论证和支持材料增强写作的说服力。', '2025-03-18 16:02:54', '2025-03-18 16:02:54', 'https://example.com/images/chapter2_cover.jpg', 'https://example.com/videos/chapter2_video.mp4', 2000, 0);
INSERT INTO `chapter` VALUES (7, 5, '第一章：基础听力训练', '本章通过简单的听力材料帮助学员提高基础听力理解能力。', '2025-03-18 16:02:54', '2025-03-18 16:02:54', 'https://example.com/images/chapter1_cover.jpg', 'https://example.com/videos/chapter1_video.mp4', 1800, 0);
INSERT INTO `chapter` VALUES (8, 5, '第二章：精听技巧', '这一章节介绍如何通过精听训练提升对细节的捕捉和理解能力。', '2025-03-18 16:02:54', '2025-03-19 14:35:22', 'https://example.com/images/chapter2_cover.jpg', 'https://example.com/videos/chapter2_video.mp4', 2100, 0);
INSERT INTO `chapter` VALUES (9, 6, '第一章：商务英语基础', '本章讲解商务英语的基本概念和常见表达，帮助学员打好基础。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter1_cover.jpg', 'https://example.com/videos/chapter1_video.mp4', 1800, 0);
INSERT INTO `chapter` VALUES (10, 6, '第二章：会议英语', '这一章节介绍在商务会议中常用的英语表达，包括开场白、议题讨论、总结等。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter2_cover.jpg', 'https://example.com/videos/chapter2_video.mp4', 2100, 0);
INSERT INTO `chapter` VALUES (11, 6, '第三章：商务邮件写作', '本章帮助学员掌握商务邮件的写作技巧，包括邮件格式、语气和常用表达。', '2025-03-18 16:03:48', '2025-03-20 20:42:00', '/uploads/chapter/63633f78-c17a-4262-a603-202a7a9b6bd5.jpg', '/uploads/video/c2663381-0171-4a8d-9e71-275667b4d06b.mp4', 9, 0);
INSERT INTO `chapter` VALUES (12, 6, '第四章：谈判技巧', '这一章节讲解商务谈判中的语言技巧，帮助学员提高谈判中的英语表达能力。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter4_cover.jpg', 'https://example.com/videos/chapter4_video.mp4', 2200, 0);
INSERT INTO `chapter` VALUES (13, 6, '第五章：电话英语', '本章通过模拟电话情境帮助学员提升商务电话沟通能力。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter5_cover.jpg', 'https://example.com/videos/chapter5_video.mp4', 1900, 0);
INSERT INTO `chapter` VALUES (14, 7, '第一章：英语文学概述', '本章介绍英语文学的主要流派和发展历程，为后续课程打下基础。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter1_cover.jpg', 'https://example.com/videos/chapter1_video.mp4', 2100, 0);
INSERT INTO `chapter` VALUES (15, 7, '第二章：莎士比亚的戏剧', '这一章节聚焦莎士比亚的经典戏剧，分析其中的文学价值与文化背景。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter2_cover.jpg', 'https://example.com/videos/chapter2_video.mp4', 2400, 0);
INSERT INTO `chapter` VALUES (16, 7, '第三章：英国现代小说', '本章探讨英国现代小说的代表作及其文学特征，分析小说中的人物塑造与主题思想。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter3_cover.jpg', 'https://example.com/videos/chapter3_video.mp4', 2300, 0);
INSERT INTO `chapter` VALUES (17, 7, '第四章：诗歌鉴赏', '本章讲解如何赏析英语诗歌，包括韵律、意象和修辞手法的分析。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter4_cover.jpg', 'https://example.com/videos/chapter4_video.mp4', 2100, 0);
INSERT INTO `chapter` VALUES (18, 7, '第五章：美国文学与诗歌', '这一章节介绍美国文学的主要作品和流派，包括20世纪的诗歌和小说。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter5_cover.jpg', 'https://example.com/videos/chapter5_video.mp4', 2200, 0);
INSERT INTO `chapter` VALUES (19, 7, '第六章：文学中的社会问题', '本章探讨文学作品中如何反映社会问题，分析不同时期的社会背景。', '2025-03-18 16:03:48', '2025-03-18 16:03:48', 'https://example.com/images/chapter6_cover.jpg', 'https://example.com/videos/chapter6_video.mp4', 2500, 0);
INSERT INTO `chapter` VALUES (20, 1, '测试', '测试信息', '2025-03-19 14:47:03', '2025-03-20 20:14:49', '/uploads/chapter/f22389ad-8325-407e-8a94-0a56a1e1b5a7.jpg', '/uploads/video/0457aa92-5c2d-48a1-b8b7-4bff3940f95a.mp4', 9, 0);

-- ----------------------------
-- Table structure for course
-- ----------------------------
DROP TABLE IF EXISTS `course`;
CREATE TABLE `course`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '课程ID',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课程标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '课程描述',
  `coverImage` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '课程封面图片',
  `level` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '课程等级：初级 中级 高级',
  `status` int NOT NULL DEFAULT 0 COMMENT '课程状态：0-未上线 1-上线',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 10 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '课程表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of course
-- ----------------------------
INSERT INTO `course` VALUES (1, 'Java基础', 'Java编程基础课程', '/uploads/course/aae77837-fd77-4fd8-b143-f12331518f67.avif', '初级', 1, '2025-03-18 15:11:10', '2025-03-20 12:58:43', 0);
INSERT INTO `course` VALUES (2, 'Python进阶', 'Python进阶课程', '/uploads/course/8da07329-97bf-4a28-a688-1fb0aba801d3.avif', '初级', 0, '2025-03-18 15:11:10', '2025-03-21 21:37:52', 0);
INSERT INTO `course` VALUES (3, '英语口语提升课程', '该课程通过互动式学习，帮助学员提升英语口语水平，内容包括发音技巧、日常对话、常见词汇与语法点。', '/uploads/course/be6795a7-1b53-4348-9d0b-b9cf0957a3e1.avif', '中级', 0, '2025-03-18 16:02:54', '2025-03-20 13:00:32', 0);
INSERT INTO `course` VALUES (4, '高级英语写作训练', '本课程专注于提升学员的英语写作能力，包括文章结构、论证技巧、学术写作和创意写作等。', '/uploads/course/296f25f5-4dbb-429d-9b2e-2de7ebef9d8a.avif', '中级', 0, '2025-03-18 16:02:54', '2025-03-20 13:00:38', 0);
INSERT INTO `course` VALUES (5, '英语听力与理解', '该课程帮助学员提高英语听力理解能力，内容包括听力训练、精听和泛听技巧、听力材料分析。', '/uploads/course/e030dac7-49f5-48c0-a6d2-06650693db19.avif', '高级', 0, '2025-03-18 16:02:54', '2025-03-20 13:00:45', 0);
INSERT INTO `course` VALUES (6, '商务英语沟通', '本课程旨在提升学员的英语商务沟通能力，包括会议英语、邮件写作、谈判技巧等。', '/uploads/course/b173b6ef-f61f-4b80-80bb-3537db79d28a.avif', '高级', 0, '2025-03-18 16:03:48', '2025-03-20 13:00:51', 0);
INSERT INTO `course` VALUES (7, '英语文学赏析', '本课程专注于英语文学作品的阅读和分析，涵盖小说、诗歌、戏剧等，帮助学员提高文学鉴赏能力。', '/uploads/course/7103cebd-67a0-4228-9611-6626ac1c96d9.avif', '中级', 1, '2025-03-18 16:03:48', '2025-03-20 14:05:45', 0);
INSERT INTO `course` VALUES (8, '测试课程', '测试测试测试测试测试测试', '/uploads/course/4b486f81-6bfb-4fd9-8582-6edfdf7cadb8.jpg', '初级', 1, '2025-03-18 22:05:46', '2025-03-18 22:06:00', 1);
INSERT INTO `course` VALUES (9, '测试课程', '测试课程测试课程测试课程测试课程', '/uploads/course/d08ddd19-105a-4e32-8e09-0149c2195c68.jpg', '初级', 1, '2025-03-18 22:25:19', '2025-03-18 22:25:19', 0);

-- ----------------------------
-- Table structure for exam
-- ----------------------------
DROP TABLE IF EXISTS `exam`;
CREATE TABLE `exam`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '试卷ID',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '试卷标题',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '试卷描述',
  `totalScore` int NOT NULL DEFAULT 100 COMMENT '总分',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `startTime` datetime NULL DEFAULT NULL COMMENT '试卷开始时间',
  `endTime` datetime NULL DEFAULT NULL COMMENT '试卷结束时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '试卷表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of exam
-- ----------------------------
INSERT INTO `exam` VALUES (1, 'Java基础考试', '测试Java编程基础', 100, '2025-03-18 15:11:20', '2025-03-20 16:40:12', '2025-03-25 10:00:00', '2025-03-25 12:00:00', 0);
INSERT INTO `exam` VALUES (2, 'Python进阶考试', '测试Python编程进阶', 100, '2025-03-18 15:11:20', '2025-03-20 16:40:24', '2025-03-26 10:00:00', '2025-03-26 12:00:00', 0);
INSERT INTO `exam` VALUES (3, '英语高考模拟试卷', '此试卷包含选择题、判断、填空和简答等部分，适合高考英语模拟。', 100, '2025-03-18 15:46:59', '2025-03-18 15:51:51', '2025-05-10 08:00:00', '2025-05-10 12:00:00', 0);
INSERT INTO `exam` VALUES (4, '大学英语四级模拟考试', '这是一场大学英语四级模拟考试，涉及选择题、判断、填空和简答等部分。', 100, '2025-03-18 15:46:59', '2025-03-18 15:51:56', '2025-06-20 09:00:00', '2025-06-20 12:00:00', 0);
INSERT INTO `exam` VALUES (5, '考研英语一模拟试卷', '此试卷适合考研英语一，包含选择题、判断、填空和简答等部分，难度较高。', 100, '2025-03-18 15:48:21', '2025-03-18 15:52:08', '2025-06-01 08:00:00', '2025-06-01 12:00:00', 0);
INSERT INTO `exam` VALUES (6, '考研英语二模拟试卷', '此试卷适合考研英语二，包含选择题、判断、填空和简答等部分，难度中等。', 100, '2025-03-18 15:48:21', '2025-03-18 15:52:13', '2025-06-10 08:00:00', '2025-06-10 12:00:00', 0);
INSERT INTO `exam` VALUES (7, '测试试卷', '测试一下2', 150, '2025-03-19 18:00:40', '2025-03-20 16:40:49', '2025-03-28 16:00:00', '2025-03-28 18:00:00', 1);
INSERT INTO `exam` VALUES (8, '测试', '测试试卷', 100, '2025-03-20 20:45:23', '2025-03-20 20:46:58', '2025-03-28 09:00:00', '2025-03-28 11:30:00', 1);

-- ----------------------------
-- Table structure for post
-- ----------------------------
DROP TABLE IF EXISTS `post`;
CREATE TABLE `post`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `title` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '内容',
  `tags` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '标签列表（json 数组）',
  `thumbNum` int NOT NULL DEFAULT 0 COMMENT '点赞数',
  `favourNum` int NOT NULL DEFAULT 0 COMMENT '收藏数',
  `userId` bigint NOT NULL COMMENT '创建用户 id',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1902318700288069635 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post
-- ----------------------------
INSERT INTO `post` VALUES (1, '英语学习中的常见误区', '许多人在学习英语时，往往忽略了语法的重要性。实际上，语法是学习英语的基石，不管是口语还是写作，掌握好语法才能更好地理解和表达。很多学习者会觉得语法太枯燥，不想深入学习，其实语法的学习是可以通过多种方式进行的，例如通过英语电影或电视剧中的对话，语法可以在语境中自然吸收。', '[\"英语学习\", \"语法\", \"误区\"]', 150, 80, 1, '2025-03-18 16:01:39', '2025-03-20 20:49:36', 0);
INSERT INTO `post` VALUES (2, '如何高效记单词', '记单词的方法有很多种，如何选择最适合自己的记单词方式呢？首先，你可以通过联想记忆法，将单词和你已经熟悉的事物联系起来，帮助记忆。其次，可以通过制作单词卡片，反复复习。还有一个有效的方法就是通过阅读英文文章，看到单词时记下它们的意思，并在上下文中理解它们的用法，增强记忆。最后，可以借助一些记单词的APP，进行单词记忆的帮助。', '[\"英语学习\", \"单词\", \"记忆方法\"]', 200, 120, 1, '2025-03-18 16:01:39', '2025-03-18 18:45:00', 0);
INSERT INTO `post` VALUES (4, '提高英语口语的五个技巧', '学习英语口语可能会让很多人感到困难，但通过一些技巧，你可以在日常生活中更加自信地使用英语。本文将分享五个提高英语口语的技巧，帮助你快速提升口语能力。', '[\"英语口语\", \"学习技巧\", \"自信\"]', 23, 45, 1, '2025-03-18 16:05:14', '2025-03-18 18:45:02', 0);
INSERT INTO `post` VALUES (5, '如何准备英语六级考试', '英语六级考试是很多大学生需要面对的挑战。本文将为你提供一些实用的备考建议，包括如何制定学习计划，掌握听力技巧，以及如何提高阅读理解能力。', '[\"六级考试\", \"英语学习\", \"考试准备\"]', 56, 78, 1, '2025-03-18 16:05:14', '2025-03-18 18:45:04', 0);
INSERT INTO `post` VALUES (6, '商务英语写作中的常见错误及避免方法', '商务英语写作是职场中非常重要的一部分，然而很多人在写作过程中常常犯一些低级错误。本文将分析一些常见的错误，并给出避免这些错误的方法，帮助你提高商务写作水平。', '[\"商务英语\", \"写作技巧\", \"常见错误\"]', 31, 59, 1, '2025-03-18 16:05:14', '2025-03-18 18:45:05', 0);
INSERT INTO `post` VALUES (7, '英语学习中的词汇记忆技巧', '词汇是英语学习的基础，但很多学习者常常记不住单词。本文将分享一些实用的词汇记忆技巧，帮助你更高效地掌握词汇。', '[\"词汇学习\", \"记忆技巧\", \"英语学习\"]', 45, 67, 1, '2025-03-18 16:05:55', '2025-03-20 19:34:52', 0);
INSERT INTO `post` VALUES (8, '如何提高英语写作能力', '写作是英语学习的重要部分，很多人会因为写作能力差而感到沮丧。本文提供一些方法，帮助你提高英语写作能力，避免常见错误。', '[\"英语写作\", \"写作技巧\", \"提高能力\"]', 37, 49, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:07', 0);
INSERT INTO `post` VALUES (9, '雅思考试备考经验分享', '雅思考试对于很多考生来说是一次大的挑战。本文分享了成功备考雅思的经验，包括如何提升听力和口语成绩，如何制定合理的学习计划。', '[\"雅思考试\", \"考试备考\", \"学习经验\"]', 60, 80, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:08', 0);
INSERT INTO `post` VALUES (10, '提高英语听力的有效方法', '英语听力一直是许多学习者的难点。本文介绍了几个有效的听力提升方法，帮助你克服听力难关，取得更好的听力成绩。', '[\"英语听力\", \"学习方法\", \"提高技巧\"]', 50, 70, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:09', 0);
INSERT INTO `post` VALUES (11, '英语口语练习中的常见误区', '很多人都希望提高英语口语，但在练习过程中常常会陷入一些误区。本文分析了英语口语练习中的常见错误，并提供了避免这些误区的方法。', '[\"英语口语\", \"练习技巧\", \"常见误区\"]', 42, 65, 1, '2025-03-18 16:05:55', '2025-03-20 19:09:18', 0);
INSERT INTO `post` VALUES (12, '如何备考英语四级', '英语四级是大学生必须通过的考试之一。本文分享了备考英语四级的技巧和经验，包括如何提高听力、写作和阅读理解能力。', '[\"四级考试\", \"备考技巧\", \"英语学习\"]', 55, 85, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:10', 0);
INSERT INTO `post` VALUES (13, '英语阅读理解技巧提升', '阅读理解是英语考试中非常重要的一部分，很多学生在这一部分得分不高。本文总结了提高英语阅读理解能力的一些技巧。', '[\"英语阅读\", \"考试技巧\", \"理解能力\"]', 48, 67, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:11', 0);
INSERT INTO `post` VALUES (14, '商务英语口语训练方法', '在现代职场中，商务英语口语非常重要。本文介绍了一些商务英语口语训练的方法，帮助你在职场中更自信地使用英语。', '[\"商务英语\", \"口语训练\", \"职场英语\"]', 36, 59, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:12', 0);
INSERT INTO `post` VALUES (15, '英语单词发音规则', '正确的单词发音是英语学习的重要组成部分。本文介绍了一些常见的英语单词发音规则，帮助你提高发音准确度。', '[\"英语发音\", \"单词学习\", \"发音规则\"]', 52, 75, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:12', 0);
INSERT INTO `post` VALUES (16, '如何提高英语词汇量', '词汇量的大小直接影响到英语水平。本文介绍了几种提高词汇量的方法，包括如何记忆生词，如何用词汇表达自己的思想。', '[\"词汇量\", \"提高技巧\", \"英语学习\"]', 44, 68, 1, '2025-03-18 16:05:55', '2025-03-18 18:45:13', 0);
INSERT INTO `post` VALUES (1902318700288069634, '这是一条测试帖子', '测试2', '[\"测试\"]', 0, 0, 1, '2025-03-19 19:18:16', '2025-03-19 19:18:27', 1);

-- ----------------------------
-- Table structure for post_comment
-- ----------------------------
DROP TABLE IF EXISTS `post_comment`;
CREATE TABLE `post_comment`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `postId` bigint NOT NULL COMMENT '帖子 id',
  `userId` bigint NOT NULL COMMENT '评论用户 id',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '评论内容',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  `replyTo` bigint NULL DEFAULT NULL COMMENT '回复的评论ID',
  `likes` int NULL DEFAULT 0 COMMENT '评论点赞数',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_postId`(`postId` ASC) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE,
  CONSTRAINT `post_comment_ibfk_1` FOREIGN KEY (`postId`) REFERENCES `post` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 17 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '帖子评论表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post_comment
-- ----------------------------
INSERT INTO `post_comment` VALUES (1, 1, 2, '我同意，很多人都忽视了语法的学习，其实语法并不难，只要掌握了基本的规则，就能流利表达。', '2025-03-18 16:01:39', '2025-03-18 16:01:39', 0, NULL, 7);
INSERT INTO `post_comment` VALUES (2, 2, 2, '这个方法对我很有帮助，之前我总是记不住单词，通过联想记忆法，我发现记单词变得容易多了！', '2025-03-18 16:01:39', '2025-03-18 18:45:32', 0, NULL, 5);
INSERT INTO `post_comment` VALUES (3, 1, 2, '语法的确很重要，但也不要忽略听力练习，语法和听力相辅相成，才能更好地提高英语水平。', '2025-03-18 16:01:39', '2025-03-18 18:45:33', 0, 1, 11);
INSERT INTO `post_comment` VALUES (4, 1, 1, '测试', '2025-03-19 19:30:00', '2025-03-20 21:02:07', 1, NULL, 1);
INSERT INTO `post_comment` VALUES (5, 11, 1, '111', '2025-03-19 19:30:30', '2025-03-19 19:30:30', 0, NULL, 1);
INSERT INTO `post_comment` VALUES (6, 1, 1, '回复 @测试用户: 11', '2025-03-19 19:33:38', '2025-03-19 19:33:38', 0, 3, 0);
INSERT INTO `post_comment` VALUES (7, 11, 1, '12', '2025-03-20 19:07:17', '2025-03-20 19:07:17', 0, NULL, 0);
INSERT INTO `post_comment` VALUES (8, 11, 1, '回复 @管理员: 111', '2025-03-20 19:14:27', '2025-03-20 19:28:20', 1, 7, 0);
INSERT INTO `post_comment` VALUES (9, 11, 1, '回复 @管理员: 222', '2025-03-20 19:25:31', '2025-03-20 19:25:31', 0, 8, 0);
INSERT INTO `post_comment` VALUES (10, 11, 1, '回复 @管理员: 222', '2025-03-20 19:25:36', '2025-03-20 19:27:05', 1, 5, 0);
INSERT INTO `post_comment` VALUES (11, 11, 1, '回复 @管理员: 333', '2025-03-20 19:25:41', '2025-03-20 19:25:41', 0, 8, 0);
INSERT INTO `post_comment` VALUES (12, 11, 1, '回复 @管理员: 222', '2025-03-20 19:28:09', '2025-03-20 19:28:09', 0, 8, 0);
INSERT INTO `post_comment` VALUES (13, 11, 1, '回复 @管理员: 111', '2025-03-20 19:28:24', '2025-03-20 19:28:30', 1, 7, 0);
INSERT INTO `post_comment` VALUES (14, 11, 1, '回复 @管理员: 222', '2025-03-20 19:28:27', '2025-03-20 19:28:27', 0, 7, 2);
INSERT INTO `post_comment` VALUES (15, 1, 1, '测试', '2025-03-20 21:01:55', '2025-03-20 21:01:55', 0, 3, 0);
INSERT INTO `post_comment` VALUES (16, 1, 1, '测试', '2025-03-20 21:02:11', '2025-03-20 21:02:11', 0, NULL, 0);

-- ----------------------------
-- Table structure for post_favour
-- ----------------------------
DROP TABLE IF EXISTS `post_favour`;
CREATE TABLE `post_favour`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `postId` bigint NOT NULL COMMENT '帖子 id',
  `userId` bigint NOT NULL COMMENT '创建用户 id',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_postId`(`postId` ASC) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '帖子收藏' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post_favour
-- ----------------------------
INSERT INTO `post_favour` VALUES (1, 1, 2, '2025-03-18 16:01:39', '2025-03-18 16:01:39');
INSERT INTO `post_favour` VALUES (2, 2, 2, '2025-03-18 16:01:39', '2025-03-18 18:45:42');

-- ----------------------------
-- Table structure for post_thumb
-- ----------------------------
DROP TABLE IF EXISTS `post_thumb`;
CREATE TABLE `post_thumb`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `postId` bigint NOT NULL COMMENT '帖子 id',
  `userId` bigint NOT NULL COMMENT '创建用户 id',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_postId`(`postId` ASC) USING BTREE,
  INDEX `idx_userId`(`userId` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '帖子点赞' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of post_thumb
-- ----------------------------
INSERT INTO `post_thumb` VALUES (1, 1, 2, '2025-03-18 16:01:39', '2025-03-18 18:45:46');
INSERT INTO `post_thumb` VALUES (2, 2, 2, '2025-03-18 16:01:39', '2025-03-18 18:45:48');

-- ----------------------------
-- Table structure for question
-- ----------------------------
DROP TABLE IF EXISTS `question`;
CREATE TABLE `question`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '题目ID',
  `examId` bigint NOT NULL COMMENT '所属试卷ID',
  `questionType` enum('单选','多选','判断','填空','简答') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目类型',
  `questionText` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '题目内容',
  `options` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '选项（JSON格式）',
  `correctAnswer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '正确答案',
  `score` int NOT NULL DEFAULT 5 COMMENT '该题分值',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `difficultyLevel` enum('简单','中等','困难') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '简单' COMMENT '题目难度级别',
  `explanation` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '题目解析',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `examId`(`examId` ASC) USING BTREE,
  CONSTRAINT `question_ibfk_1` FOREIGN KEY (`examId`) REFERENCES `exam` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 112 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '试卷题目表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of question
-- ----------------------------
INSERT INTO `question` VALUES (1, 1, '单选', 'Java的创始人是谁?', '{\"A\": \"James Gosling\", \"B\": \"Bjarne Stroustrup\", \"C\": \"Dennis Ritchie\"}', 'A', 5, '2025-03-18 15:11:25', '2025-03-18 15:11:25', '简单', 'James Gosling是Java语言的创始人。', 0);
INSERT INTO `question` VALUES (2, 1, '多选', 'Java的特点有哪些?', '{\"A\": \"面向对象\", \"B\": \"平台无关\", \"C\": \"编译型语言\", \"D\": \"解释型语言\"}', 'A,B,C', 10, '2025-03-18 15:11:25', '2025-03-18 15:11:25', '中等', 'Java是面向对象的，平台无关的，并且是编译型语言。', 0);
INSERT INTO `question` VALUES (3, 3, '单选', 'What is the capital city of the United Kingdom?', '{\"A\": \"Paris\", \"B\": \"London\", \"C\": \"Berlin\", \"D\": \"Madrid\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The capital city of the United Kingdom is London.', 0);
INSERT INTO `question` VALUES (4, 3, '单选', 'Which of the following is a synonym for \"benevolent\"?', '{\"A\": \"Hostile\", \"B\": \"Kind\", \"C\": \"Ignorant\", \"D\": \"Evil\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Benevolent means being kind and charitable.', 0);
INSERT INTO `question` VALUES (5, 3, '单选', 'What is the synonym of \"ephemeral\"?', '{\"A\": \"Permanent\", \"B\": \"Short-lived\", \"C\": \"Unchanging\", \"D\": \"Stable\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Ephemeral means lasting for a very short time.', 0);
INSERT INTO `question` VALUES (6, 3, '单选', 'Which of the following is a correct synonym for \"arduous\"?', '{\"A\": \"Easy\", \"B\": \"Difficult\", \"C\": \"Quick\", \"D\": \"Simple\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Arduous means requiring a lot of effort and difficult to accomplish.', 0);
INSERT INTO `question` VALUES (7, 3, '单选', 'Which of the following are components of a formal essay?', '{\"A\": \"Introduction\", \"B\": \"Conclusion\", \"C\": \"References\", \"D\": \"Body\"}', 'A,B,C,D', 10, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'A formal essay typically includes an introduction, body, conclusion, and references.', 0);
INSERT INTO `question` VALUES (8, 3, '单选', 'Which of the following is a synonym for \"eloquent\"?', '{\"A\": \"Silent\", \"B\": \"Fluent\", \"C\": \"Shy\", \"D\": \"Irritable\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Eloquent means fluent or expressive in speech.', 0);
INSERT INTO `question` VALUES (9, 3, '单选', 'What is the purpose of transition words in writing?', '{\"A\": \"To confuse the reader\", \"B\": \"To connect ideas\", \"C\": \"To add detail\", \"D\": \"To summarize\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Transition words help to connect ideas and improve the flow of writing.', 0);
INSERT INTO `question` VALUES (10, 3, '单选', 'Which of the following is a synonym for \"incredible\"?', '{\"A\": \"Unbelievable\", \"B\": \"Ordinary\", \"C\": \"Typical\", \"D\": \"Boring\"}', 'A', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Incredible means something that is difficult to believe or extraordinary.', 0);
INSERT INTO `question` VALUES (11, 3, '单选', 'What is the meaning of \"meticulous\"?', '{\"A\": \"Careless\", \"B\": \"Precise\", \"C\": \"Fast\", \"D\": \"Lazy\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Meticulous means showing great attention to detail or being very precise.', 0);
INSERT INTO `question` VALUES (12, 3, '单选', 'Which of the following is an example of an oxymoron?', '{\"A\": \"Living dead\", \"B\": \"Clear as mud\", \"C\": \"Jumbo shrimp\", \"D\": \"All of the above\"}', 'D', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'An oxymoron is a figure of speech that combines contradictory terms, like \"jumbo shrimp\" or \"living dead\".', 0);
INSERT INTO `question` VALUES (13, 3, '填空', 'The square root of 144 is ____.', NULL, '12', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'The square root of 144 is 12.', 0);
INSERT INTO `question` VALUES (14, 3, '填空', 'The longest river in the world is ____.', NULL, 'Nile', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'The Nile River is the longest river in the world.', 0);
INSERT INTO `question` VALUES (15, 3, '填空', 'The first president of the United States was ____.', NULL, 'George Washington', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'George Washington was the first president of the United States.', 0);
INSERT INTO `question` VALUES (16, 3, '填空', 'The capital city of Canada is ____.', NULL, 'Ottawa', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Ottawa is the capital city of Canada.', 0);
INSERT INTO `question` VALUES (17, 3, '填空', 'The speed of light is approximately ____ kilometers per second.', NULL, '300,000', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The speed of light is approximately 300,000 kilometers per second.', 0);
INSERT INTO `question` VALUES (18, 3, '判断', 'The Earth revolves around the Sun.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'The Earth revolves around the Sun.', 0);
INSERT INTO `question` VALUES (19, 3, '判断', 'All nouns in English are countable.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Some nouns are uncountable, such as \"water\" and \"information\".', 0);
INSERT INTO `question` VALUES (20, 3, '判断', 'Shakespeare wrote the play \"The Great Gatsby\".', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Shakespeare did not write \"The Great Gatsby\"; it was written by F. Scott Fitzgerald.', 0);
INSERT INTO `question` VALUES (21, 3, '判断', 'The Great Wall of China was built in the 20th century.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Great Wall of China was built long before the 20th century.', 0);
INSERT INTO `question` VALUES (22, 3, '判断', 'The capital city of France is Paris.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Paris is the capital city of France.', 0);
INSERT INTO `question` VALUES (23, 3, '判断', 'Water boils at 100 degrees Celsius at sea level.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Water boils at 100 degrees Celsius at sea level.', 0);
INSERT INTO `question` VALUES (24, 3, '判断', 'The Earth is flat.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Earth is round, not flat.', 0);
INSERT INTO `question` VALUES (25, 3, '判断', 'The Amazon is the longest river in the world.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Nile River is the longest river, not the Amazon.', 0);
INSERT INTO `question` VALUES (26, 3, '判断', 'All mammals have hair or fur at some point in their life.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'All mammals have hair or fur at some stage of their life, even if it is just in the embryonic stage.', 0);
INSERT INTO `question` VALUES (27, 3, '简答', 'What is the role of an adverb in a sentence?', NULL, 'An adverb modifies a verb, adjective, or another adverb, providing more detail about how, when, where, or to what extent something occurs.', 10, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Adverbs provide more detail about actions or qualities in a sentence.', 0);
INSERT INTO `question` VALUES (28, 3, '简答', 'What is the purpose of an introductory paragraph in an essay?', NULL, 'The introductory paragraph introduces the topic, provides background information, and presents the thesis statement.', 10, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'The introduction sets the stage for the essay and outlines the main points that will be discussed.', 0);
INSERT INTO `question` VALUES (29, 4, '单选', 'Which of these is a synonym for \"articulate\"?', '{\"A\": \"Silent\", \"B\": \"Eloquent\", \"C\": \"Shy\", \"D\": \"Irritable\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Articulate means expressing oneself clearly and effectively.', 0);
INSERT INTO `question` VALUES (30, 4, '单选', 'What is the meaning of \"meticulous\"?', '{\"A\": \"Careless\", \"B\": \"Precise\", \"C\": \"Fast\", \"D\": \"Lazy\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Meticulous means showing great attention to detail or being very precise.', 0);
INSERT INTO `question` VALUES (31, 4, '单选', 'Which of the following is a synonym for \"benevolent\"?', '{\"A\": \"Hostile\", \"B\": \"Kind\", \"C\": \"Ignorant\", \"D\": \"Evil\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Benevolent means being kind and charitable.', 0);
INSERT INTO `question` VALUES (32, 4, '单选', 'What does \"gregarious\" mean?', '{\"A\": \"Shy\", \"B\": \"Friendly\", \"C\": \"Lonely\", \"D\": \"Aggressive\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Gregarious means sociable and friendly.', 0);
INSERT INTO `question` VALUES (33, 4, '单选', 'What is the meaning of \"profound\"?', '{\"A\": \"Shallow\", \"B\": \"Deep\", \"C\": \"Simple\", \"D\": \"Light\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Profound means deep or significant in meaning.', 0);
INSERT INTO `question` VALUES (34, 4, '单选', 'Which of the following is a synonym for \"equanimity\"?', '{\"A\": \"Calmness\", \"B\": \"Excitement\", \"C\": \"Anger\", \"D\": \"Fear\"}', 'A', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Equanimity means calmness or composure, especially in difficult situations.', 0);
INSERT INTO `question` VALUES (35, 4, '单选', 'Which of the following words means \"temporary\"?', '{\"A\": \"Permanence\", \"B\": \"Ephemeral\", \"C\": \"Eternal\", \"D\": \"Stable\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Ephemeral means short-lived or temporary.', 0);
INSERT INTO `question` VALUES (36, 4, '单选', 'What is the synonym of \"courageous\"?', '{\"A\": \"Fearful\", \"B\": \"Brave\", \"C\": \"Weak\", \"D\": \"Tired\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Courageous means brave or having courage.', 0);
INSERT INTO `question` VALUES (37, 4, '单选', 'What is the meaning of \"verbose\"?', '{\"A\": \"Concise\", \"B\": \"Wordy\", \"C\": \"Short\", \"D\": \"Silent\"}', 'B', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'Verbose means using more words than necessary.', 0);
INSERT INTO `question` VALUES (38, 4, '单选', 'Which of the following is an example of an oxymoron?', '{\"A\": \"Jumbo shrimp\", \"B\": \"Clear as mud\", \"C\": \"Living dead\", \"D\": \"All of the above\"}', 'D', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'An oxymoron is a figure of speech combining contradictory terms like \"jumbo shrimp\" and \"living dead\".', 0);
INSERT INTO `question` VALUES (39, 4, '填空', 'The speed of light is approximately ____ kilometers per second.', NULL, '300,000', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The speed of light is approximately 300,000 kilometers per second.', 0);
INSERT INTO `question` VALUES (40, 4, '填空', 'The capital city of Canada is ____.', NULL, 'Ottawa', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Ottawa is the capital city of Canada.', 0);
INSERT INTO `question` VALUES (41, 4, '填空', 'The square root of 144 is ____.', NULL, '12', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'The square root of 144 is 12.', 0);
INSERT INTO `question` VALUES (42, 4, '填空', 'The first president of the United States was ____.', NULL, 'George Washington', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'George Washington was the first president of the United States.', 0);
INSERT INTO `question` VALUES (43, 4, '填空', 'The longest river in the world is ____.', NULL, 'Nile', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'The Nile is the longest river in the world.', 0);
INSERT INTO `question` VALUES (44, 4, '判断', 'The Earth revolves around the Sun.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'The Earth revolves around the Sun.', 0);
INSERT INTO `question` VALUES (45, 4, '判断', 'Shakespeare wrote \"The Great Gatsby\".', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'Shakespeare did not write \"The Great Gatsby\"; it was written by F. Scott Fitzgerald.', 0);
INSERT INTO `question` VALUES (46, 4, '判断', 'The capital city of France is Paris.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Paris is the capital city of France.', 0);
INSERT INTO `question` VALUES (47, 4, '判断', 'Water boils at 100 degrees Celsius at sea level.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Water boils at 100 degrees Celsius at sea level.', 0);
INSERT INTO `question` VALUES (48, 4, '判断', 'The Great Wall of China was built in the 20th century.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Great Wall of China was built long before the 20th century.', 0);
INSERT INTO `question` VALUES (49, 4, '判断', 'The Amazon is the longest river in the world.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Nile is the longest river in the world, not the Amazon.', 0);
INSERT INTO `question` VALUES (50, 4, '判断', 'The Earth is flat.', NULL, '错误', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '困难', 'The Earth is round, not flat.', 0);
INSERT INTO `question` VALUES (51, 4, '判断', 'All mammals have hair or fur at some point in their life.', NULL, '正确', 5, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '中等', 'All mammals have hair or fur at some point during their life cycle.', 0);
INSERT INTO `question` VALUES (52, 4, '简答', 'What is the role of a thesis statement in an essay?', NULL, 'A thesis statement presents the main argument or claim of the essay and guides the structure of the writing.', 10, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'A thesis statement provides a clear direction for the essay and informs the reader of its main argument.', 0);
INSERT INTO `question` VALUES (53, 4, '简答', 'Explain the importance of transitions in writing.', NULL, 'Transitions help to connect ideas between sentences and paragraphs, ensuring that the writing flows logically and coherently.', 10, '2025-03-18 15:47:07', '2025-03-18 15:47:07', '简单', 'Transitions make writing easier to follow and improve its overall coherence.', 0);
INSERT INTO `question` VALUES (54, 5, '单选', 'Which of the following is a synonym for \"superficial\"?', '{\"A\": \"Deep\", \"B\": \"Shallow\", \"C\": \"Complex\", \"D\": \"Substantial\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Superficial means something that is shallow or not deep.', 0);
INSERT INTO `question` VALUES (55, 5, '单选', 'What is the meaning of \"procrastinate\"?', '{\"A\": \"To delay\", \"B\": \"To work hard\", \"C\": \"To organize\", \"D\": \"To succeed\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Procrastinate means to delay or postpone doing something.', 0);
INSERT INTO `question` VALUES (56, 5, '单选', 'Which of the following is a synonym for \"equivocate\"?', '{\"A\": \"Clarify\", \"B\": \"Hesitate\", \"C\": \"Mislead\", \"D\": \"Simplify\"}', 'C', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Equivocate means to speak ambiguously or to mislead.', 0);
INSERT INTO `question` VALUES (57, 5, '单选', 'What is the antonym of \"optimistic\"?', '{\"A\": \"Pessimistic\", \"B\": \"Realistic\", \"C\": \"Hopeful\", \"D\": \"Pragmatic\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Optimistic means having hope or confidence, and its antonym is pessimistic, meaning having a negative outlook.', 0);
INSERT INTO `question` VALUES (58, 5, '单选', 'Which of the following is a synonym for \"facilitate\"?', '{\"A\": \"Complicate\", \"B\": \"Assist\", \"C\": \"Interrupt\", \"D\": \"Ignore\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Facilitate means to make something easier or assist in its completion.', 0);
INSERT INTO `question` VALUES (59, 5, '单选', 'What is the meaning of \"contemplate\"?', '{\"A\": \"To ignore\", \"B\": \"To think about deeply\", \"C\": \"To forget\", \"D\": \"To laugh at\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Contemplate means to think about something deeply.', 0);
INSERT INTO `question` VALUES (60, 5, '单选', 'Which of the following words means \"temporary\"?', '{\"A\": \"Permanent\", \"B\": \"Ephemeral\", \"C\": \"Stable\", \"D\": \"Unchanging\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Ephemeral means something that lasts for a short time, or temporary.', 0);
INSERT INTO `question` VALUES (61, 5, '单选', 'What does \"inundate\" mean?', '{\"A\": \"To overwhelm\", \"B\": \"To escape\", \"C\": \"To celebrate\", \"D\": \"To create\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Inundate means to overwhelm or flood with something, usually information or work.', 0);
INSERT INTO `question` VALUES (62, 5, '单选', 'What is the synonym of \"ambivalent\"?', '{\"A\": \"Conflicted\", \"B\": \"Decisive\", \"C\": \"Neutral\", \"D\": \"Indifferent\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Ambivalent means having mixed feelings or conflicting emotions.', 0);
INSERT INTO `question` VALUES (63, 5, '单选', 'Which of the following is an antonym for \"innovative\"?', '{\"A\": \"Creative\", \"B\": \"Traditional\", \"C\": \"Inventive\", \"D\": \"Original\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Innovative means introducing new ideas, and its antonym is traditional, meaning following established methods or ideas.', 0);
INSERT INTO `question` VALUES (64, 5, '填空', 'The largest planet in our solar system is ____.', NULL, 'Jupiter', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Jupiter is the largest planet in our solar system.', 0);
INSERT INTO `question` VALUES (65, 5, '填空', 'The capital city of Japan is ____.', NULL, 'Tokyo', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Tokyo is the capital city of Japan.', 0);
INSERT INTO `question` VALUES (66, 5, '填空', 'The chemical formula for water is ____.', NULL, 'H2O', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'The chemical formula for water is H2O.', 0);
INSERT INTO `question` VALUES (67, 5, '填空', 'The author of \"1984\" is ____.', NULL, 'George Orwell', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'George Orwell is the author of \"1984\".', 0);
INSERT INTO `question` VALUES (68, 5, '填空', 'The currency of the United Kingdom is ____.', NULL, 'Pound', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'The currency of the United Kingdom is the Pound (GBP).', 0);
INSERT INTO `question` VALUES (69, 5, '判断', 'The Earth is the fourth planet from the Sun.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Earth is the third planet from the Sun, not the fourth.', 0);
INSERT INTO `question` VALUES (70, 5, '判断', 'Shakespeare wrote \"The Great Gatsby\".', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Shakespeare did not write \"The Great Gatsby\"; it was written by F. Scott Fitzgerald.', 0);
INSERT INTO `question` VALUES (71, 5, '判断', 'The capital city of Australia is Sydney.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The capital city of Australia is Canberra, not Sydney.', 0);
INSERT INTO `question` VALUES (72, 5, '判断', 'The Amazon is the longest river in the world.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Nile is the longest river in the world, not the Amazon.', 0);
INSERT INTO `question` VALUES (73, 5, '判断', 'Water freezes at 0 degrees Celsius.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Water freezes at 0 degrees Celsius under normal atmospheric pressure.', 0);
INSERT INTO `question` VALUES (74, 5, '判断', 'The Eiffel Tower is located in London.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'The Eiffel Tower is located in Paris, not London.', 0);
INSERT INTO `question` VALUES (75, 5, '判断', 'The speed of light is faster than the speed of sound.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'The speed of light is approximately 300,000 km/s, while the speed of sound is much slower.', 0);
INSERT INTO `question` VALUES (76, 5, '判断', 'Humans are the only species to use tools.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Other species, such as certain birds and primates, also use tools.', 0);
INSERT INTO `question` VALUES (77, 5, '判断', 'An octopus has eight tentacles.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'An octopus has eight tentacles.', 0);
INSERT INTO `question` VALUES (78, 5, '判断', 'The Great Wall of China was built in the 20th century.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Great Wall of China was built long before the 20th century.', 0);
INSERT INTO `question` VALUES (79, 5, '简答', 'What is the significance of a thesis statement in an academic essay?', NULL, 'A thesis statement presents the main argument or claim of the essay and guides the reader through the body of the essay.', 10, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'A thesis statement provides a clear direction for the essay and outlines its structure.', 0);
INSERT INTO `question` VALUES (80, 5, '简答', 'How can transitions improve the flow of an essay?', NULL, 'Transitions connect ideas between sentences and paragraphs, making the writing more coherent and easier to follow.', 10, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Transitions help readers understand the relationships between ideas and improve the overall flow of the writing.', 0);
INSERT INTO `question` VALUES (81, 6, '单选', 'Which of the following is the most suitable synonym for \"profound\"?', '{\"A\": \"Shallow\", \"B\": \"Deep\", \"C\": \"Small\", \"D\": \"Insignificant\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Profound means something deep or significant.', 0);
INSERT INTO `question` VALUES (82, 6, '单选', 'What is the opposite of \"synchronous\"?', '{\"A\": \"Simultaneous\", \"B\": \"Asynchronous\", \"C\": \"Occasional\", \"D\": \"Periodic\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Asynchronous means not happening at the same time.', 0);
INSERT INTO `question` VALUES (83, 6, '单选', 'What is the meaning of \"ephemeral\"?', '{\"A\": \"Permanent\", \"B\": \"Short-lived\", \"C\": \"Eternal\", \"D\": \"Stable\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Ephemeral means something that lasts for a short time.', 0);
INSERT INTO `question` VALUES (84, 6, '单选', 'Which of the following is the antonym of \"rigid\"?', '{\"A\": \"Flexible\", \"B\": \"Stiff\", \"C\": \"Hard\", \"D\": \"Solid\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Rigid means stiff or inflexible, and its antonym is flexible.', 0);
INSERT INTO `question` VALUES (85, 6, '单选', 'What does \"contemplate\" mean?', '{\"A\": \"To ignore\", \"B\": \"To think deeply\", \"C\": \"To forget\", \"D\": \"To discuss\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Contemplate means to think deeply or reflect on something.', 0);
INSERT INTO `question` VALUES (86, 6, '单选', 'Which of the following is a synonym for \"ambivalent\"?', '{\"A\": \"Conflicted\", \"B\": \"Certain\", \"C\": \"Neutral\", \"D\": \"Resolved\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Ambivalent means having mixed feelings or being uncertain.', 0);
INSERT INTO `question` VALUES (87, 6, '单选', 'What does \"meticulous\" mean?', '{\"A\": \"Careless\", \"B\": \"Precise\", \"C\": \"Indifferent\", \"D\": \"Lazy\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'Meticulous means being very careful and precise.', 0);
INSERT INTO `question` VALUES (88, 6, '单选', 'What is the opposite of \"conservative\"?', '{\"A\": \"Progressive\", \"B\": \"Traditional\", \"C\": \"Liberal\", \"D\": \"Moderate\"}', 'A', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Progressive means favoring change and innovation, which is the opposite of conservative.', 0);
INSERT INTO `question` VALUES (89, 6, '单选', 'What is the meaning of \"articulate\"?', '{\"A\": \"Silent\", \"B\": \"Expressive\", \"C\": \"Unclear\", \"D\": \"Loud\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Articulate means to express ideas clearly and effectively.', 0);
INSERT INTO `question` VALUES (90, 6, '单选', 'Which of the following is a synonym for \"elaborate\"?', '{\"A\": \"Simplify\", \"B\": \"Expand\", \"C\": \"Ignore\", \"D\": \"Limit\"}', 'B', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Elaborate means to explain in detail or expand on something.', 0);
INSERT INTO `question` VALUES (91, 6, '填空', 'The Earth revolves around the ____.', NULL, 'Sun', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'The Earth revolves around the Sun.', 0);
INSERT INTO `question` VALUES (92, 6, '填空', 'The capital city of Canada is ____.', NULL, 'Ottawa', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Ottawa is the capital city of Canada.', 0);
INSERT INTO `question` VALUES (93, 6, '填空', 'The main ingredient in guacamole is ____.', NULL, 'Avocado', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Avocado is the main ingredient in guacamole.', 0);
INSERT INTO `question` VALUES (94, 6, '填空', 'The largest desert in the world is the ____.', NULL, 'Sahara', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Sahara is the largest desert in the world.', 0);
INSERT INTO `question` VALUES (95, 6, '填空', 'The Great Barrier Reef is located off the coast of ____.', NULL, 'Australia', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'The Great Barrier Reef is located off the coast of Australia.', 0);
INSERT INTO `question` VALUES (96, 6, '判断', 'The longest river in the world is the Nile.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'The Nile is the longest river in the world.', 0);
INSERT INTO `question` VALUES (97, 6, '判断', 'Shakespeare wrote \"The Odyssey\".', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Shakespeare did not write \"The Odyssey\", it was written by Homer.', 0);
INSERT INTO `question` VALUES (98, 6, '判断', 'Mount Everest is the tallest mountain in the world.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Mount Everest is the tallest mountain in the world.', 0);
INSERT INTO `question` VALUES (99, 6, '判断', 'The capital of Brazil is Rio de Janeiro.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The capital of Brazil is Brasília, not Rio de Janeiro.', 0);
INSERT INTO `question` VALUES (100, 6, '判断', 'The Mona Lisa was painted by Vincent van Gogh.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Mona Lisa was painted by Leonardo da Vinci, not van Gogh.', 0);
INSERT INTO `question` VALUES (101, 6, '判断', 'The speed of sound is faster than the speed of light.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The speed of sound is much slower than the speed of light.', 0);
INSERT INTO `question` VALUES (102, 6, '判断', 'Albert Einstein developed the theory of relativity.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'Albert Einstein is known for developing the theory of relativity.', 0);
INSERT INTO `question` VALUES (103, 6, '判断', 'An atom consists of protons, neutrons, and electrons.', NULL, '正确', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'An atom is composed of protons, neutrons, and electrons.', 0);
INSERT INTO `question` VALUES (104, 6, '判断', 'The Earth is flat.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '困难', 'The Earth is round, not flat.', 0);
INSERT INTO `question` VALUES (105, 6, '判断', 'Penguins can fly.', NULL, '错误', 5, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Penguins are flightless birds.', 0);
INSERT INTO `question` VALUES (106, 6, '简答', 'What is the role of a topic sentence in a paragraph?', NULL, 'The topic sentence introduces the main idea of the paragraph and sets the tone for the rest of the paragraph.', 10, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '简单', 'A topic sentence summarizes the main point of a paragraph and helps the reader understand its purpose.', 0);
INSERT INTO `question` VALUES (107, 6, '简答', 'What is the difference between a simile and a metaphor?', NULL, 'A simile uses \"like\" or \"as\" to compare two things, while a metaphor directly compares them without using \"like\" or \"as\".', 10, '2025-03-18 15:49:44', '2025-03-18 15:49:44', '中等', 'Similes and metaphors both involve comparison, but similes use \"like\" or \"as\" while metaphors are direct comparisons.', 0);
INSERT INTO `question` VALUES (108, 1, '单选', '在 Java 中，以下哪个选项是正确的关于 String 类型的描述？', '{\"A\":\"是一个基本数据类型，因此它的对象是不可变的。\",\"B\":\"是一个类，字符串是由字符数组实现的，且它是不可变的。\",\"C\":\"是一个类，它是可变的，可以修改字符串中的字符。\",\"D\":\"是一个接口，所有实现了该接口的类都是字符串类型。\"}', 'B', 5, '2025-03-19 18:08:12', '2025-03-19 18:15:55', '简单', '是一个类，而不是基本数据类型。它的对象是不可变的，意味着一旦创建了一个 String 对象，它的值是无法改变的。如果修改字符串，实际上会创建一个新的 String 对象。', 0);
INSERT INTO `question` VALUES (109, 1, '单选', '测试', '{\"A\":\"1\",\"B\":\"2\"}', 'A', 5, '2025-03-19 18:20:21', '2025-03-19 18:20:21', '中等', '11', 0);
INSERT INTO `question` VALUES (110, 1, '多选', '测试11', '{\"A\":\"1\",\"B\":\"2\",\"C\":\"3\",\"D\":\"4\"}', 'A,B,C', 1, '2025-03-19 18:22:07', '2025-03-19 18:22:19', '中等', '123', 1);
INSERT INTO `question` VALUES (111, 8, '单选', '测试单选', '{\"A\":\"option1\",\"B\":\"option2\",\"C\":\"option3\",\"D\":\"option4\"}', 'A', 1, '2025-03-20 20:46:12', '2025-03-20 20:46:47', '简单', 'easy', 1);

-- ----------------------------
-- Table structure for study_record
-- ----------------------------
DROP TABLE IF EXISTS `study_record`;
CREATE TABLE `study_record`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '学习记录ID',
  `userId` bigint NOT NULL COMMENT '用户ID',
  `courseId` bigint NULL DEFAULT NULL COMMENT '课程ID',
  `examId` bigint NULL DEFAULT NULL COMMENT '试卷ID',
  `progress` int NOT NULL DEFAULT 0 COMMENT '学习进度（%）',
  `status` enum('进行中','已完成') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '进行中' COMMENT '状态',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `studyTime` int NULL DEFAULT NULL COMMENT '学习时长（分钟）',
  `score` float NULL DEFAULT NULL COMMENT '得分',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `vocabularyId` bigint NULL DEFAULT NULL COMMENT '关联的词汇ID',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  INDEX `vocabularyId`(`vocabularyId` ASC) USING BTREE,
  CONSTRAINT `study_record_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `study_record_ibfk_2` FOREIGN KEY (`vocabularyId`) REFERENCES `vocabulary` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '学习记录表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of study_record
-- ----------------------------
INSERT INTO `study_record` VALUES (1, 1, 1, NULL, 50, '已完成', '2025-03-18 15:11:29', 121, NULL, '2025-03-18 20:23:00', NULL, 0);
INSERT INTO `study_record` VALUES (2, 2, 2, NULL, 75, '已完成', '2025-03-18 15:11:29', 220, NULL, '2025-03-19 20:37:45', NULL, 0);
INSERT INTO `study_record` VALUES (3, 1, NULL, NULL, 20, '进行中', '2025-03-19 20:56:09', 15, NULL, '2025-03-19 20:56:40', 3, 0);
INSERT INTO `study_record` VALUES (4, 1, NULL, 3, 0, '进行中', '2025-03-19 20:58:36', 110, 95, '2025-03-20 17:53:38', NULL, 0);
INSERT INTO `study_record` VALUES (5, 1, NULL, NULL, 100, '进行中', '2025-03-19 21:09:48', 10, NULL, '2025-03-21 12:17:16', 1, 0);
INSERT INTO `study_record` VALUES (7, 1, 0, 0, 100, '已完成', '2025-03-20 16:25:59', 0, 0, '2025-03-20 16:29:11', 1, 0);
INSERT INTO `study_record` VALUES (8, 1, 0, 0, 25, '进行中', '2025-03-20 16:26:23', 0, 0, '2025-03-20 16:26:23', 2, 0);
INSERT INTO `study_record` VALUES (9, 1, NULL, 1, 0, '已完成', '2025-03-20 17:51:33', NULL, 15, '2025-03-20 17:51:33', NULL, 0);
INSERT INTO `study_record` VALUES (10, 1, 0, 0, 100, '已完成', '2025-03-20 20:56:08', 0, 0, '2025-03-20 20:56:08', 11, 0);
INSERT INTO `study_record` VALUES (11, 1, NULL, 1, 0, '已完成', '2025-03-20 20:59:15', NULL, 15, '2025-03-20 20:59:15', NULL, 0);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'id',
  `userAccount` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '账号',
  `userPassword` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '密码',
  `unionId` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '微信开放平台id',
  `mpOpenId` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '公众号openId',
  `userName` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户昵称',
  `userAvatar` varchar(1024) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户头像',
  `userProfile` varchar(512) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '用户简介',
  `userRole` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'user' COMMENT '用户角色：user/admin/ban',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_unionId`(`unionId` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1901885819174555651 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'dc094ae0edbd3ad3bbd36a9e46500e6b', NULL, NULL, '管理员', '/uploads/avatars/78b738f6-4706-4324-8800-45843d5b138b.jpg', '管理员', 'admin', '2025-03-18 14:35:55', '2025-03-20 11:51:48', 0);
INSERT INTO `user` VALUES (2, 'user1', 'dc094ae0edbd3ad3bbd36a9e46500e6b', NULL, NULL, '测试用户', '/uploads/avatars/5c2205b2-8890-4983-8a99-545c02457b96.jpg', '英语爱好者', 'user', '2025-03-18 15:11:02', '2025-03-19 13:29:51', 0);
INSERT INTO `user` VALUES (3, 'user2', 'dc094ae0edbd3ad3bbd36a9e46500e6b', NULL, NULL, '学习者', '/uploads/avatars/fdee3535-0bea-4e9f-b172-99e215f3f07c.jpg', '英语小白菜', 'user', '2025-03-18 15:11:02', '2025-03-19 13:26:37', 0);

-- ----------------------------
-- Table structure for user_answer
-- ----------------------------
DROP TABLE IF EXISTS `user_answer`;
CREATE TABLE `user_answer`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '作答记录ID',
  `userId` bigint NOT NULL COMMENT '用户ID',
  `examId` bigint NOT NULL COMMENT '试卷ID',
  `questionId` bigint NOT NULL COMMENT '题目ID',
  `userAnswer` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '用户作答（JSON格式或字符串，根据题目类型）',
  `isCorrect` tinyint NOT NULL DEFAULT 0 COMMENT '是否正确（0为错误，1为正确）',
  `score` int NOT NULL DEFAULT 0 COMMENT '该题得分',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '作答时间',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `userNote` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '用户笔记（用户对该题的备注或思考）',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除（0为未删除，1为已删除）',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `examId`(`examId` ASC) USING BTREE,
  INDEX `userId`(`userId` ASC) USING BTREE,
  INDEX `questionId`(`questionId` ASC) USING BTREE,
  CONSTRAINT `user_answer_ibfk_1` FOREIGN KEY (`userId`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_answer_ibfk_2` FOREIGN KEY (`examId`) REFERENCES `exam` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_answer_ibfk_3` FOREIGN KEY (`questionId`) REFERENCES `question` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 66 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '用户作答表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of user_answer
-- ----------------------------
INSERT INTO `user_answer` VALUES (1, 1, 3, 3, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'London is the capital of the UK.', 0);
INSERT INTO `user_answer` VALUES (2, 1, 3, 4, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Benevolent means kind.', 0);
INSERT INTO `user_answer` VALUES (3, 1, 3, 5, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Ephemeral means short-lived.', 0);
INSERT INTO `user_answer` VALUES (4, 1, 3, 6, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Arduous means difficult.', 0);
INSERT INTO `user_answer` VALUES (5, 1, 3, 7, 'A,B,C,D', 1, 10, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'All components of an essay.', 0);
INSERT INTO `user_answer` VALUES (6, 1, 3, 8, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Eloquent means fluent.', 0);
INSERT INTO `user_answer` VALUES (7, 1, 3, 9, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Transition words connect ideas.', 0);
INSERT INTO `user_answer` VALUES (8, 1, 3, 10, 'A', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Incredible means unbelievable.', 0);
INSERT INTO `user_answer` VALUES (9, 1, 3, 11, 'B', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Meticulous means precise.', 0);
INSERT INTO `user_answer` VALUES (10, 1, 3, 12, 'D', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Oxymorons combine contradictory terms.', 0);
INSERT INTO `user_answer` VALUES (11, 1, 3, 13, '13', 0, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Square root of 144 is 13.', 0);
INSERT INTO `user_answer` VALUES (12, 1, 3, 14, 'Amazon', 0, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Amazon is the longest river.', 0);
INSERT INTO `user_answer` VALUES (13, 1, 3, 15, 'Abraham Lincoln', 0, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Abraham Lincoln was the first president.', 0);
INSERT INTO `user_answer` VALUES (14, 1, 3, 16, 'Toronto', 0, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Toronto is the capital city of Canada.', 0);
INSERT INTO `user_answer` VALUES (15, 1, 3, 17, '300,000,000', 0, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Speed of light is 300,000,000 km/s.', 0);
INSERT INTO `user_answer` VALUES (16, 1, 3, 18, '正确', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'The Earth revolves around the Sun.', 0);
INSERT INTO `user_answer` VALUES (17, 1, 3, 19, '错误', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Not all nouns are countable.', 0);
INSERT INTO `user_answer` VALUES (18, 1, 3, 20, '错误', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Shakespeare didn’t write The Great Gatsby.', 0);
INSERT INTO `user_answer` VALUES (19, 1, 3, 21, '错误', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'The Great Wall of China was built much earlier.', 0);
INSERT INTO `user_answer` VALUES (20, 1, 3, 22, '正确', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Paris is France\'s capital.', 0);
INSERT INTO `user_answer` VALUES (21, 1, 3, 23, '正确', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Water boils at 100°C at sea level.', 0);
INSERT INTO `user_answer` VALUES (22, 1, 3, 24, '错误', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'The Earth is round, not flat.', 0);
INSERT INTO `user_answer` VALUES (23, 1, 3, 25, '错误', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'Nile is the longest river, not the Amazon.', 0);
INSERT INTO `user_answer` VALUES (24, 1, 3, 26, '正确', 1, 5, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'All mammals have hair or fur at some point in their life.', 0);
INSERT INTO `user_answer` VALUES (25, 1, 3, 27, 'An adverb modifies a noun.', 0, 10, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'An adverb modifies a noun.', 0);
INSERT INTO `user_answer` VALUES (26, 1, 3, 28, 'The introductory paragraph includes the conclusion.', 0, 10, '2025-03-18 20:55:42', '2025-03-18 20:55:42', 'The introduction includes the conclusion.', 0);
INSERT INTO `user_answer` VALUES (27, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:01:09', '2025-03-20 17:01:09', '', 0);
INSERT INTO `user_answer` VALUES (28, 1, 1, 2, '', 0, 0, '2025-03-20 17:01:09', '2025-03-20 17:01:09', '', 0);
INSERT INTO `user_answer` VALUES (29, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:01:17', '2025-03-20 17:01:17', '', 0);
INSERT INTO `user_answer` VALUES (30, 1, 1, 2, '', 0, 0, '2025-03-20 17:01:17', '2025-03-20 17:01:17', '', 0);
INSERT INTO `user_answer` VALUES (31, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:04:52', '2025-03-20 17:04:52', '', 0);
INSERT INTO `user_answer` VALUES (32, 1, 1, 2, 'A,B,C', 0, 0, '2025-03-20 17:04:53', '2025-03-20 17:04:53', '', 0);
INSERT INTO `user_answer` VALUES (33, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:05:21', '2025-03-20 17:05:21', '', 0);
INSERT INTO `user_answer` VALUES (34, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:06:20', '2025-03-20 17:06:20', '', 0);
INSERT INTO `user_answer` VALUES (35, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:06:42', '2025-03-20 17:06:42', '', 0);
INSERT INTO `user_answer` VALUES (36, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:06:58', '2025-03-20 17:06:58', '', 0);
INSERT INTO `user_answer` VALUES (37, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:07:26', '2025-03-20 17:07:26', '', 0);
INSERT INTO `user_answer` VALUES (38, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:08:02', '2025-03-20 17:08:02', '', 0);
INSERT INTO `user_answer` VALUES (39, 1, 1, 1, 'A', 0, 0, '2025-03-20 17:09:14', '2025-03-20 17:09:14', '', 0);
INSERT INTO `user_answer` VALUES (40, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:10:12', '2025-03-20 17:10:12', '', 0);
INSERT INTO `user_answer` VALUES (41, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:10:17', '2025-03-20 17:10:17', '', 0);
INSERT INTO `user_answer` VALUES (42, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:14:31', '2025-03-20 17:14:31', '', 0);
INSERT INTO `user_answer` VALUES (43, 1, 1, 2, '', 0, 0, '2025-03-20 17:14:36', '2025-03-20 17:14:36', '', 0);
INSERT INTO `user_answer` VALUES (44, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:18:38', '2025-03-20 17:18:38', '', 0);
INSERT INTO `user_answer` VALUES (45, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:18:41', '2025-03-20 17:18:41', '', 0);
INSERT INTO `user_answer` VALUES (46, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:22:35', '2025-03-20 17:22:35', '', 0);
INSERT INTO `user_answer` VALUES (47, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:22:35', '2025-03-20 17:22:35', '', 0);
INSERT INTO `user_answer` VALUES (48, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:24:49', '2025-03-20 17:24:49', '', 0);
INSERT INTO `user_answer` VALUES (49, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:24:49', '2025-03-20 17:24:49', '', 0);
INSERT INTO `user_answer` VALUES (50, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:24:57', '2025-03-20 17:24:57', '', 0);
INSERT INTO `user_answer` VALUES (51, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:24:57', '2025-03-20 17:24:57', '', 0);
INSERT INTO `user_answer` VALUES (52, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:25:07', '2025-03-20 17:25:07', '', 0);
INSERT INTO `user_answer` VALUES (53, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:25:07', '2025-03-20 17:25:07', '', 0);
INSERT INTO `user_answer` VALUES (54, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:32:04', '2025-03-20 17:32:04', '', 0);
INSERT INTO `user_answer` VALUES (55, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:32:04', '2025-03-20 17:32:04', '', 0);
INSERT INTO `user_answer` VALUES (56, 1, 1, 108, 'A', 0, 0, '2025-03-20 17:32:04', '2025-03-20 17:32:04', '', 0);
INSERT INTO `user_answer` VALUES (57, 1, 1, 109, 'A', 1, 5, '2025-03-20 17:32:04', '2025-03-20 17:32:04', '', 0);
INSERT INTO `user_answer` VALUES (58, 1, 1, 1, 'A', 1, 5, '2025-03-20 17:51:33', '2025-03-20 17:51:33', '', 0);
INSERT INTO `user_answer` VALUES (59, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 17:51:33', '2025-03-20 17:51:33', '', 0);
INSERT INTO `user_answer` VALUES (60, 1, 1, 108, 'A', 0, 0, '2025-03-20 17:51:33', '2025-03-20 17:51:33', '', 0);
INSERT INTO `user_answer` VALUES (61, 1, 1, 109, 'B', 0, 0, '2025-03-20 17:51:33', '2025-03-20 17:51:33', '', 0);
INSERT INTO `user_answer` VALUES (62, 1, 1, 1, 'A', 1, 5, '2025-03-20 20:58:55', '2025-03-20 20:58:55', '', 0);
INSERT INTO `user_answer` VALUES (63, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 20:58:55', '2025-03-20 20:58:55', '', 0);
INSERT INTO `user_answer` VALUES (64, 1, 1, 1, 'A', 1, 5, '2025-03-20 20:59:15', '2025-03-20 20:59:15', '', 0);
INSERT INTO `user_answer` VALUES (65, 1, 1, 2, 'A,B,C', 1, 10, '2025-03-20 20:59:15', '2025-03-20 20:59:15', '', 0);

-- ----------------------------
-- Table structure for vocabulary
-- ----------------------------
DROP TABLE IF EXISTS `vocabulary`;
CREATE TABLE `vocabulary`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '词汇ID',
  `word` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '单词',
  `phonetic` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT '音标',
  `meaning` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT '词义',
  `example` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT '例句',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `difficultyLevel` enum('初级','中级','高级') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '初级' COMMENT '词汇难度级别',
  `isPhrase` enum('单词','词组') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT '单词' COMMENT '表示该条记录是单词还是词组',
  `updateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `isDelete` tinyint NOT NULL DEFAULT 0 COMMENT '是否删除',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 322 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = '词汇表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of vocabulary
-- ----------------------------
INSERT INTO `vocabulary` VALUES (1, 'Ephemeral', '/ɪˈfemərəl/', '短暂的，瞬息的', 'en:he joy of victory was ephemeral, lasting only for a few minutes before the harsh realities of the next challenge set in.zh:胜利的喜悦是短暂的，只持续了几分钟，随后下一个挑战的严峻现实便到来了。', '2025-03-18 15:13:06', '高级', '单词', '2025-03-21 13:26:37', 0);
INSERT INTO `vocabulary` VALUES (2, 'Serendipity', '/ˌsɛrənˈdɪpɪti/', '意外发现，偶然的好运', 'en:was sheer serendipity that they stumbled upon the rare manuscript while browsing in a small antique shop.zh:他们在一家小古董店闲逛时偶然发现了那本珍贵的手稿，简直是天赐的好运。', '2025-03-18 15:13:06', '高级', '单词', '2025-03-21 13:27:38', 0);
INSERT INTO `vocabulary` VALUES (3, 'abandon', '/əˈbændən/', '放弃，抛弃', 'EN: The kind woman decided to take care of the cats abandoned by their owners.\nZH: 这位善良的妇女决定照顾被主人遗弃的猫。\nSource: 2013·广西模拟\n\nEN: We must never abandon this principle.\nZH: 这是一个必须坚持的原则。\nSource: 2013·江苏模拟', '2025-03-18 15:15:45', '中级', '单词', '2025-03-20 11:00:21', 0);
INSERT INTO `vocabulary` VALUES (4, 'ability', '/əˈbɪləti/', '能力', 'She has the ability to succeed in any situation.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (5, 'abolish', '/əˈbɒlɪʃ/', '废除，取消', 'The government decided to abolish the old law.', '2025-03-18 15:15:45', '高级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (6, 'absent', '/ˈæbsənt/', '缺席的', 'She was absent from the meeting yesterday.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (7, 'accomplish', '/əˈkʌmplɪʃ/', '完成，达成', 'She accomplished all her goals for this year.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (8, 'accurate', '/ˈækjərət/', '准确的', 'The report was accurate and well-detailed.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (9, 'acquire', '/əˈkwaɪə/', '获得，学到', 'He acquired many new skills during his internship.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (10, 'adapt', '/əˈdæpt/', '适应，改编', 'We need to adapt to the changing conditions.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (11, 'adjust', '/əˈdʒʌst/', '调整，调节', 'You need to adjust the volume of the speaker.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (12, 'advantage', '/ədˈvæntɪdʒ/', '优势，利益', 'Having experience gives you an advantage in the job market.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (13, 'advice', '/ədˈvaɪs/', '建议', 'He gave me some great advice on how to improve my presentation.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (14, 'affect', '/əˈfɛkt/', '影响，作用', 'The weather can affect your mood.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (15, 'analyze', '/ˈænəlaɪz/', '分析', 'The scientist will analyze the data collected from the experiment.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (16, 'annual', '/ˈænjuəl/', '每年的，年度的', 'The company holds an annual conference in December.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (17, 'approve', '/əˈpruːv/', '批准，赞成', 'The manager approved the proposal after reviewing it.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (18, 'argument', '/ˈɑːɡjʊmənt/', '争论，论点', 'They had a strong argument about the best way to solve the issue.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (19, 'arrange', '/əˈreɪndʒ/', '安排，整理', 'We need to arrange a meeting for next week.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (20, 'assess', '/əˈsɛs/', '评估，评定', 'The teacher will assess your project in terms of creativity and accuracy.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (21, 'assist', '/əˈsɪst/', '帮助，协助', 'She will assist you with the project if you need help.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (22, 'average', '/ˈævərɪdʒ/', '平均的', 'The average score on the test was 85%.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (23, 'benefit', '/ˈbɛnɪfɪt/', '利益，好处', 'Exercise has many health benefits.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (24, 'bitter', '/ˈbɪtər/', '苦的，痛苦的', 'The medicine tasted bitter, but it worked well.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (25, 'capacity', '/kəˈpæsɪti/', '容量，能力', 'The auditorium has a seating capacity of 500 people.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (26, 'challenge', '/ˈtʃælɪndʒ/', '挑战', 'Learning a new language can be a challenge.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (27, 'clarify', '/ˈklærɪfaɪ/', '澄清，阐明', 'Could you clarify your statement on this issue?', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (28, 'collaborate', '/kəˈlæbəreɪt/', '合作，协作', 'The two companies collaborated on the new project.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (29, 'competence', '/ˈkɒmpɪtəns/', '能力，胜任', 'The candidate demonstrated competence in handling complex tasks.', '2025-03-18 15:15:45', '高级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (30, 'compete', '/kəmˈpiːt/', '竞争', 'Several companies are competing for the contract.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (31, 'conclude', '/kənˈkluːd/', '结束，推断出', 'The meeting will conclude at 5 PM.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (32, 'confidence', '/ˈkɒnfɪdəns/', '信心，自信', 'She has great confidence in her abilities.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (33, 'conflict', '/ˈkɒnflɪkt/', '冲突，矛盾', 'The conflict between the two sides lasted for years.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (34, 'consequence', '/ˈkɒnsɪkwəns/', '结果，后果', 'The consequence of his decision was severe.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (35, 'consider', '/kənˈsɪdə/', '考虑，认为', 'I will consider your suggestion and get back to you.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (36, 'constant', '/ˈkɒnstənt/', '持续的，恒定的', 'The temperature remained constant throughout the day.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (37, 'contrast', '/ˈkɒntræst/', '对比，差异', 'There is a sharp contrast between the two products.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (38, 'contribute', '/kənˈtrɪbjuːt/', '贡献，捐赠', 'Each employee contributes to the success of the company.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (39, 'convince', '/kənˈvɪns/', '说服，使相信', 'She tried to convince him to join the team.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (40, 'cooperate', '/kəʊˈɒpəreɪt/', '合作，配合', 'We need to cooperate to achieve our goals.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (41, 'crucial', '/ˈkruːʃəl/', '关键的，重要的', 'It is crucial to finish the project on time.', '2025-03-18 15:15:45', '高级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (42, 'debate', '/dɪˈbeɪt/', '辩论，讨论', 'They had a heated debate about the new policy.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (43, 'decide', '/dɪˈsaɪd/', '决定，做出选择', 'I need to decide what to wear for the event.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (44, 'defend', '/dɪˈfɛnd/', '防卫，辩护', 'The lawyer defended his client in court.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (45, 'difficult', '/ˈdɪfɪkəlt/', '困难的，艰难的', 'The problem was difficult to solve, but they managed to do it.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (46, 'discuss', '/dɪˈskʌs/', '讨论，谈论', 'They will discuss the new project in the next meeting.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (47, 'dominate', '/ˈdɒmɪneɪt/', '支配，主导', 'He dominated the conversation throughout the meeting.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (48, 'economic', '/ˌiːkəˈnɒmɪk/', '经济的', 'The economic situation is improving steadily.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (49, 'efficient', '/ɪˈfɪʃənt/', '高效的，有效的', 'The new software is more efficient than the previous version.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (50, 'eliminate', '/ɪˈlɪmɪneɪt/', '消除，排除', 'We need to eliminate any obstacles to our progress.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (51, 'enough', '/ɪˈnʌf/', '足够的', 'You have enough time to finish the task.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (52, 'environment', '/ɪnˈvaɪərənmənt/', '环境', 'The environment around us is changing rapidly.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (53, 'evidence', '/ˈɛvɪdəns/', '证据，事实', 'There is strong evidence to support the theory.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (54, 'evaluate', '/ɪˈvæljueɪt/', '评估，评价', 'The teacher will evaluate the students\' performance.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (55, 'examine', '/ɪɡˈzæmɪn/', '检查，审查', 'We need to examine the issue carefully before making a decision.', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (56, 'explain', '/ɪksˈpleɪn/', '解释，说明', 'Can you explain the process in more detail?', '2025-03-18 15:15:45', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (57, 'event', '/ɪˈvɛnt/', '事件，活动', 'The event was a huge success.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (58, 'examine', '/ɪɡˈzæmɪn/', '检查，审查', 'We need to examine the issue carefully before making a decision.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (59, 'acquire', '/əˈkwaɪə/', '获得，学到', 'He acquired many new skills during his internship.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (60, 'debate', '/dɪˈbeɪt/', '辩论，讨论', 'They had a heated debate about the new policy.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (61, 'benefit', '/ˈbɛnɪfɪt/', '利益，好处', 'Exercise has many health benefits.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (62, 'consider', '/kənˈsɪdə/', '考虑，认为', 'I will consider your suggestion and get back to you.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (63, 'difficult', '/ˈdɪfɪkəlt/', '困难的，艰难的', 'The problem was difficult to solve, but they managed to do it.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (64, 'dominate', '/ˈdɒmɪneɪt/', '支配，主导', 'He dominated the conversation throughout the meeting.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (65, 'explain', '/ɪksˈpleɪn/', '解释，说明', 'Can you explain the process in more detail?', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (66, 'adapt', '/əˈdæpt/', '适应，改编', 'We need to adapt to the changing conditions.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (67, 'challenge', '/ˈtʃælɪndʒ/', '挑战', 'Learning a new language can be a challenge.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (68, 'decide', '/dɪˈsaɪd/', '决定，做出选择', 'I need to decide what to wear for the event.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (69, 'compete', '/kəmˈpiːt/', '竞争', 'Several companies are competing for the contract.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (70, 'clarify', '/ˈklærɪfaɪ/', '澄清，阐明', 'Could you clarify your statement on this issue?', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (71, 'assist', '/əˈsɪst/', '帮助，协助', 'She will assist you with the project if you need help.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (72, 'defend', '/dɪˈfɛnd/', '防卫，辩护', 'The lawyer defended his client in court.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (73, 'capacity', '/kəˈpæsɪti/', '容量，能力', 'The auditorium has a seating capacity of 500 people.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (74, 'adjust', '/əˈdʒʌst/', '调整，调节', 'You need to adjust the volume of the speaker.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (75, 'evaluate', '/ɪˈvæljueɪt/', '评估，评价', 'The teacher will evaluate the students\' performance.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (76, 'analyze', '/ˈænəlaɪz/', '分析', 'The scientist will analyze the data collected from the experiment.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (77, 'conflict', '/ˈkɒnflɪkt/', '冲突，矛盾', 'The conflict between the two sides lasted for years.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (78, 'constant', '/ˈkɒnstənt/', '持续的，恒定的', 'The temperature remained constant throughout the day.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (79, 'evaluate', '/ɪˈvæljuːeɪt/', '评估，评价', 'We will evaluate the outcomes after the project is finished.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (80, 'accomplish', '/əˈkʌmplɪʃ/', '完成，达成', 'She accomplished all her goals for this year.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (81, 'cooperate', '/kəʊˈɒpəreɪt/', '合作，配合', 'We need to cooperate to achieve our goals.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (82, 'approve', '/əˈpruːv/', '批准，赞成', 'The manager approved the proposal after reviewing it.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (83, 'clarify', '/ˈklærɪfaɪ/', '澄清，阐明', 'Please clarify the situation before we proceed.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (84, 'eliminate', '/ɪˈlɪmɪneɪt/', '消除，排除', 'We need to eliminate any obstacles to our progress.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (85, 'affect', '/əˈfɛkt/', '影响，作用', 'The weather can affect your mood.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (86, 'evidence', '/ˈɛvɪdəns/', '证据，事实', 'There is strong evidence to support the theory.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (87, 'analyze', '/ˈænəlaɪz/', '分析', 'He will analyze the data carefully.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (88, 'eventually', '/ɪˈvɛntʃʊəli/', '最终，终于', 'Eventually, they managed to finish the project on time.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (89, 'economic', '/ˌiːkəˈnɒmɪk/', '经济的', 'The economic situation is improving steadily.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (90, 'argument', '/ˈɑːɡjʊmənt/', '争论，论点', 'They had a strong argument about the best way to solve the issue.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (91, 'eliminate', '/ɪˈlɪmɪneɪt/', '消除，排除', 'We need to eliminate any unnecessary steps in the process.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (92, 'achieve', '/əˈtʃiːv/', '实现，达到', 'She worked hard to achieve her goals.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (93, 'confidence', '/ˈkɒnfɪdəns/', '信心，自信', 'She has great confidence in her abilities.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (94, 'compete', '/kəmˈpiːt/', '竞争', 'The two teams will compete for the championship.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (95, 'adapt', '/əˈdæpt/', '适应，改编', 'We must adapt to the new circumstances.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (96, 'cooperate', '/kəʊˈɒpəreɪt/', '合作，配合', 'The two companies cooperate on joint projects.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (97, 'constant', '/ˈkɒnstənt/', '持续的，恒定的', 'The company has a constant flow of customers.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (98, 'consider', '/kənˈsɪdə/', '考虑，认为', 'Have you considered the potential risks?', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (99, 'defend', '/dɪˈfɛnd/', '防卫，辩护', 'He will defend his decision in front of the committee.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (100, 'decide', '/dɪˈsaɪd/', '决定，做出选择', 'She has decided to study abroad next year.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (101, 'efficient', '/ɪˈfɪʃənt/', '高效的，有效的', 'The new system is more efficient than the old one.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (102, 'focus', '/ˈfəʊkəs/', '专注，集中', 'You need to focus on your studies to improve your grades.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (103, 'examine', '/ɪɡˈzæmɪn/', '检查，审查', 'We need to examine the project before approval.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (104, 'expect', '/ɪksˈpɛkt/', '期待，预期', 'We expect the results to be better than last year.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (105, 'enough', '/ɪˈnʌf/', '足够的', 'Do you have enough information to complete the task?', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (106, 'impact', '/ˈɪmpækt/', '影响，冲击', 'The impact of the new policy will be felt immediately.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (107, 'evidence', '/ˈɛvɪdəns/', '证据，事实', 'The evidence presented in court was convincing.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (108, 'collaborate', '/kəˈlæbəreɪt/', '合作，协作', 'The two scientists collaborated on the groundbreaking research.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (109, 'consequence', '/ˈkɒnsɪkwəns/', '结果，后果', 'The consequence of his actions was severe.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (110, 'assist', '/əˈsɪst/', '帮助，协助', 'Can I assist you with carrying those boxes?', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (111, 'influence', '/ˈɪnflʊəns/', '影响，作用', 'Her words had a strong influence on his decision.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (112, 'contrast', '/ˈkɒntræst/', '对比，差异', 'The contrast between the two paintings is striking.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (113, 'confirm', '/kənˈfɜːm/', '确认，证实', 'Please confirm your attendance at the meeting.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (114, 'analyze', '/ˈænəlaɪz/', '分析', 'They will analyze the data collected during the experiment.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (115, 'clarify', '/ˈklærɪfaɪ/', '澄清，阐明', 'He tried to clarify his statement during the interview.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (116, 'attend', '/əˈtɛnd/', '参加，出席', 'She will attend the seminar on Friday.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (117, 'goal', '/ɡəʊl/', '目标，目的', 'Our goal is to improve customer satisfaction.', '2025-03-18 15:17:18', '中级', '单词', '2025-03-18 15:29:56', 0);
INSERT INTO `vocabulary` VALUES (118, 'in a hurry', 'ɪn ə ˈhʌri', '匆忙', 'She left in a hurry and forgot her keys.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (119, 'on purpose', 'ɒn ˈpɜːpəs', '故意', 'He broke the vase on purpose to annoy her.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (120, 'take care of', 'teɪk keə(r) ʌv', '照顾，处理', 'I will take care of the dog while you are on vacation.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (121, 'make sense', 'meɪk sɛns', '有意义', 'Your explanation makes sense to me.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (122, 'come up with', 'kʌm ʌp wɪð', '想出，提出', 'She came up with a brilliant idea for the project.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (123, 'get along with', 'ɡɛt əˈlɒŋ wɪð', '与……和睦相处', 'I get along well with my colleagues.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (124, 'look forward to', 'lʊk ˈfɔːwəd tə', '期待', 'I look forward to meeting you tomorrow.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (125, 'out of control', 'aʊt ʌv kənˈtrəʊl', '失控', 'The car went out of control on the slippery road.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (126, 'take advantage of', 'teɪk ædˈvɑːntɪdʒ ʌv', '利用', 'Don’t take advantage of her kindness.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (127, 'in charge of', 'ɪn ʧɑːdʒ ʌv', '负责', 'She is in charge of the marketing department.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (128, 'by accident', 'baɪ ˈæksɪdənt', '偶然，意外', 'I met him by accident at the supermarket.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (129, 'out of date', 'aʊt ʌv deɪt', '过时', 'This document is out of date and needs to be updated.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (130, 'as a result of', 'æz ə rɪˈzʌlt ʌv', '由于，因为', 'He failed as a result of his lack of preparation.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (131, 'in the long run', 'ɪn ðə lɒŋ rʌn', '从长远来看', 'In the long run, investing in education pays off.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (132, 'for the time being', 'fɔː ðə taɪm ˈbiːɪŋ', '暂时', 'For the time being, I am staying at my friend’s house.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (133, 'be responsible for', 'biː rɪˈspɒnsəbl fɔː', '对……负责', 'She is responsible for managing the team.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (134, 'in the meantime', 'ɪn ðə ˈmiːnˌtaɪm', '在此期间', 'You can have lunch in the meantime while I prepare the presentation.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (135, 'at the same time', 'æt ðə seɪm taɪm', '同时', 'I can’t talk and drive at the same time.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (136, 'out of the blue', 'aʊt ʌv ðə bluː', '出乎意料，突然', 'He arrived out of the blue after a long absence.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (137, 'be fond of', 'biː fɒnd ʌv', '喜爱', 'She is fond of reading books in her free time.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (138, 'take part in', 'teɪk pɑːt ɪn', '参加', 'She will take part in the conference next week.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (139, 'keep in mind', 'kiːp ɪn maɪnd', '记住，牢记', 'Keep in mind that the meeting starts at 9:00 AM.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (140, 'make up one\'s mind', 'meɪk ʌp wʌnz maɪnd', '决定，做出决定', 'I can’t make up my mind about which restaurant to choose.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (141, 'in the end', 'ɪn ðə ɛnd', '最终', 'In the end, everything worked out well.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (142, 'take it easy', 'teɪk ɪt ˈiːzi', '放轻松', 'Take it easy, you don’t need to stress about the exam.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (143, 'look into', 'lʊk ˈɪntuː', '调查，研究', 'The police will look into the incident.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (144, 'turn down', 'tɜːn daʊn', '拒绝，拒绝接受', 'She turned down the job offer because of the location.', '2025-03-18 15:31:27', '初级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (145, 'bring up', 'brɪŋ ʌp', '提起，举起', 'I didn’t want to bring up the subject of money.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (146, 'in a nutshell', 'ɪn ə ˈnʌtʃɛl', '简而言之', 'In a nutshell, the project was a success.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (147, 'get rid of', 'ɡɛt rɪd ʌv', '摆脱，去除', 'We need to get rid of the old furniture before moving.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (148, 'take over', 'teɪk ˈəʊvə(r)', '接管，控制', 'She will take over as CEO next month.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (149, 'run out of', 'rʌn aʊt ʌv', '用完，耗尽', 'We ran out of milk, so I need to go to the store.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (150, 'at odds with', 'æt ɒdz wɪð', '与……不一致，发生争执', 'She is at odds with her colleague over the project.', '2025-03-18 15:31:27', '中级', '词组', '2025-03-18 15:31:27', 0);
INSERT INTO `vocabulary` VALUES (151, 'breakfast', 'ˈbrɛkfəst', '早餐', 'I usually have cereal for breakfast.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (152, 'by all means', 'baɪ ɔːl miːnz', '尽管如此，务必', 'By all means, go ahead and try the new recipe.', '2025-03-18 15:32:44', '初级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (153, 'celebrate', 'ˈsɛlɪˌbreɪt', '庆祝', 'We celebrate New Year with fireworks and parties.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (154, 'in charge', 'ɪn ʧɑːdʒ', '负责，掌管', 'He is in charge of the event planning.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (155, 'imagine', 'ɪˈmædʒɪn', '想象', 'Imagine living in a world without technology.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (156, 'keep an eye on', 'kiːp ən aɪ ɒn', '留意，关注', 'Can you keep an eye on the children while I cook?', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (157, 'laughter', 'ˈlæftər', '笑声', 'The sound of laughter filled the room.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (158, 'on top of', 'ɒn tɒp ʌv', '在……之上，此外', 'He is always on top of his work and never misses a deadline.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (159, 'delicious', 'dɪˈlɪʃəs', '美味的', 'This chocolate cake is absolutely delicious.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (160, 'pull someone\'s leg', 'pʊl ˈsʌmwʌnz lɛɡ', '开玩笑，戏弄', 'Don’t pull my leg – I know you’re joking!', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (161, 'enough', 'ɪˈnʌf', '足够的', 'You have enough time to finish the assignment.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (162, 'out of order', 'aʊt ʌv ˈɔːdə(r)', '故障，坏了', 'The vending machine is out of order.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (163, 'guitar', 'ɡɪˈtɑːr', '吉他', 'She plays the guitar very well.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (164, 'get in touch with', 'ɡɛt ɪn tʌʧ wɪð', '与……取得联系', 'I need to get in touch with him regarding the project.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (165, 'happy', 'ˈhæpi', '快乐的', 'She feels happy when she spends time with her family.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (166, 'give it a try', 'ɡɪv ɪt ə traɪ', '试一试，尝试', 'If you’re unsure, just give it a try!', '2025-03-18 15:32:44', '初级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (167, 'horrible', 'ˈhɒrɪbəl', '可怕的，糟糕的', 'That was a horrible movie, I didn’t enjoy it at all.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (168, 'turn up', 'tɜːn ʌp', '出现，露面', 'She didn’t turn up to the meeting on time.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (169, 'improve', 'ɪmˈpruːv', '改善，提升', 'We need to improve our communication skills.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (170, 'under the weather', 'ˈʌndə ðə ˈwɛðə(r)', '身体不适', 'I’m feeling a bit under the weather today.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (171, 'journey', 'ˈdʒɜːni', '旅程', 'Their journey to the mountains took three days.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (172, 'cut corners', 'kʌt ˈkɔːnəz', '走捷径，减少成本', 'They cut corners by using cheaper materials.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (173, 'kind', 'kaɪnd', '善良的，种类', 'She is a kind person who always helps others.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (174, 'take it or leave it', 'teɪk ɪt ɔː liːv ɪt', '接受或放弃', 'This is the final offer, take it or leave it.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (175, 'knowledge', 'ˈnɒlɪdʒ', '知识', 'He has vast knowledge in the field of science.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (176, 'out of the question', 'aʊt ʌv ðə ˈkwɛstʃən', '不可能，完全不行', 'It’s out of the question for you to leave early today.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (177, 'laugh', 'læf', '笑', 'Everyone laughed at his funny joke.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (178, 'keep your fingers crossed', 'kiːp jɔː ˈfɪŋɡəz krɒst', '祝好运，希望成功', 'I’ll keep my fingers crossed for you during your interview.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (179, 'listening', 'ˈlɪsənɪŋ', '倾听', 'Good listening skills are important in communication.', '2025-03-18 15:32:44', '初级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (180, 'to the point', 'tə ðə pɔɪnt', '简洁明了', 'His speech was short and to the point.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (181, 'measure', 'ˈmɛʒə(r)', '测量，衡量', 'We need to measure the length of the room.', '2025-03-18 15:32:44', '中级', '单词', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (182, 'out of sight', 'aʊt ʌv saɪt', '看不见，视线之外', 'He ran so fast that he was soon out of sight.', '2025-03-18 15:32:44', '中级', '词组', '2025-03-18 15:32:44', 0);
INSERT INTO `vocabulary` VALUES (183, 'eager', 'ˈiːɡər', '渴望的，热切的', 'She was eager to start her new job.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (184, 'at the moment', 'æt ðə ˈmoʊmənt', '此刻，现在', 'I can’t talk right now, I’m busy at the moment.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (185, 'fearless', 'ˈfɪərləs', '无畏的', 'He is fearless in the face of danger.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (186, 'be about to', 'biː əˈbaʊt tuː', '即将，马上', 'We are about to leave for the airport.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (187, 'generous', 'ˈdʒɛnərəs', '慷慨的', 'She is very generous with her time and resources.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (188, 'on behalf of', 'ɒn bɪˈhælf ʌv', '代表', 'He spoke on behalf of the entire team.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (189, 'honest', 'ˈɒnɪst', '诚实的', 'It’s important to be honest in all situations.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (190, 'in no time', 'ɪn noʊ taɪm', '很快，迅速', 'You’ll get the hang of it in no time.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (191, 'intelligent', 'ɪnˈtɛlɪdʒənt', '聪明的', 'He is an intelligent student who always gets good grades.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (192, 'in the meantime', 'ɪn ðə ˈmiːnˌtaɪm', '与此同时，在此期间', 'We’ll continue working on the project in the meantime.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (193, 'keen', 'kiːn', '热衷的，渴望的', 'She has a keen interest in painting.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (194, 'in charge of', 'ɪn ʧɑːrdʒ ʌv', '负责', 'He is in charge of the marketing department.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (195, 'lazy', 'ˈleɪzi', '懒惰的', 'Don’t be lazy, get up and do something productive.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (196, 'in the long run', 'ɪn ðə lɔːŋ rʌn', '从长远来看', 'Investing in education is beneficial in the long run.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (197, 'nervous', 'ˈnɜːvəs', '紧张的', 'She was nervous about her first presentation at work.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (198, 'in the end', 'ɪn ðə ɛnd', '最后，最终', 'In the end, we decided to go for a walk.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (199, 'optimistic', 'ˌɒptɪˈmɪstɪk', '乐观的', 'He has an optimistic view of the future.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (200, 'in other words', 'ɪn ˈʌðər wɜːrdz', '换句话说', 'The task was difficult. In other words, it was challenging.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (201, 'patient', 'ˈpeɪʃənt', '耐心的', 'She is very patient with children.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (202, 'jump to conclusions', 'ʤʌmp tʊ kənˈkluːʒənz', '急于下结论', 'Don’t jump to conclusions without all the facts.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (203, 'quick', 'kwɪk', '快速的', 'He’s a quick learner and picks up new skills easily.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (204, 'keep in mind', 'kiːp ɪn maɪnd', '记住，考虑到', 'Keep in mind that the deadline is next week.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (205, 'reliable', 'rɪˈlaɪəbl', '可靠的', 'She is a reliable friend who always helps when needed.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (206, 'let go of', 'lɛt ɡoʊ ʌv', '放弃，释放', 'It’s time to let go of the past and move forward.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (207, 'safe', 'seɪf', '安全的', 'Make sure the environment is safe before starting.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (208, 'make a difference', 'meɪk ə ˈdɪfərəns', '产生影响，起作用', 'Her work really makes a difference in the community.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (209, 'shy', 'ʃaɪ', '害羞的', 'She’s a shy person and prefers to avoid large crowds.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (210, 'on the other hand', 'ɒn ðə ˈʌðər hænd', '另一方面', 'He’s very talented. On the other hand, he lacks experience.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (211, 'smart', 'smɑːrt', '聪明的', 'She is smart and always finds the best solutions.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (212, 'take part in', 'teɪk pɑːrt ɪn', '参与，参加', 'He decided to take part in the competition.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (213, 'strong', 'strɔːŋ', '强壮的，坚强的', 'She is physically strong and mentally tough.', '2025-03-18 15:33:49', '初级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (214, 'turn down', 'tɜːrn daʊn', '拒绝，减弱', 'He turned down the offer because it wasn’t what he expected.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (215, 'tough', 'tʌf', '坚韧的，困难的', 'This is a tough situation, but we’ll find a solution.', '2025-03-18 15:33:49', '中级', '单词', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (216, 'work out', 'wɜːrk aʊt', '锻炼，解决', 'Everything will work out in the end.', '2025-03-18 15:33:49', '中级', '词组', '2025-03-18 15:33:49', 0);
INSERT INTO `vocabulary` VALUES (217, 'happy', 'ˈhæpi', '快乐的，幸福的', 'She feels happy every day.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (218, 'have a good time', 'hæv ə ɡʊd taɪm', '玩得开心', 'We had a good time at the concert.', '2025-03-18 15:35:29', '初级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (219, 'hardworking', 'ˈhɑːrdˌwɜːrkɪŋ', '勤奋的', 'He is a hardworking employee who always exceeds expectations.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (220, 'have to', ' hæv tuː', '不得不', 'I have to finish this report by tomorrow.', '2025-03-18 15:35:29', '初级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (221, 'healthy', 'ˈhɛlθi', '健康的', 'She tries to maintain a healthy diet.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (222, 'hear from', 'hɪər frəm', '收到某人的消息', 'I haven’t heard from him in a while.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (223, 'high', 'haɪ', '高的', 'The building is very high.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (224, 'hold on', 'hoʊld ɒn', '坚持，等一下', 'Hold on, I’ll be right there.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (225, 'honest', 'ˈɒnɪst', '诚实的', 'It’s important to be honest in every situation.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (226, 'how about', 'haʊ əˈbaʊt', '怎么样', 'How about we go for a walk?', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (227, 'huge', 'hjuːdʒ', '巨大的', 'The project was a huge success.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (228, 'in the process of', 'ɪn ðə ˈprəʊsɛs ʌv', '在...过程中', 'We are in the process of updating the system.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (229, 'ideal', 'aɪˈdɪəl', '理想的，完美的', 'It is an ideal location for a new restaurant.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (230, 'in the same boat', 'ɪn ðə seɪm boʊt', '同舟共济，处境相同', 'We’re all in the same boat here, so let’s work together.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (231, 'important', 'ɪmˈpɔːrtənt', '重要的', 'It’s important to stay focused.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (232, 'in time', 'ɪn taɪm', '及时地', 'He arrived just in time for the meeting.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (233, 'independent', 'ɪnˈdɛpəndənt', '独立的', 'She is an independent person who makes her own decisions.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (234, 'instead of', 'ɪnˈstɛd ʌv', '而不是', 'I prefer tea instead of coffee.', '2025-03-18 15:35:29', '初级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (235, 'intelligent', 'ɪnˈtɛlɪdʒənt', '聪明的', 'She is an intelligent student with a bright future.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (236, 'into the bargain', 'ˈɪntuː ðə ˈbɑːɡɪn', '附带，额外', 'You get a free drink into the bargain.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (237, 'involved', 'ɪnˈvɑːlvd', '参与的，涉及的', 'She’s deeply involved in environmental activism.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (238, 'it doesn’t matter', 'ɪt ˈdʌzənt ˈmætər', '无所谓，不重要', 'It doesn’t matter if it rains, we’ll still go.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (239, 'irritated', 'ˈɪrɪteɪtɪd', '恼火的，生气的', 'She was irritated by the constant noise outside.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (240, 'just in case', 'ʤʌst ɪn keɪs', '以防万一', 'I’ll bring an umbrella just in case it rains.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (241, 'keen', 'kiːn', '热衷的', 'He has a keen interest in science.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (242, 'keep up with', 'kiːp ʌp wɪð', '跟上，保持同步', 'It’s hard to keep up with the latest technology.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (243, 'knowledgeable', 'ˈnɒlɪdʒəbl', '博学的', 'She is knowledgeable about many different subjects.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (244, 'last but not least', 'læst bʌt nɒt liːst', '最后但同样重要的', 'Last but not least, we must thank our sponsors.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (245, 'lazy', 'ˈleɪzi', '懒惰的', 'He is too lazy to do his homework.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (246, 'let’s say', 'lɛts seɪ', '假设，举个例子', 'Let’s say you have a million dollars, what would you do?', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (247, 'logical', 'ˈlɒdʒɪkəl', '合乎逻辑的', 'His argument was logical and well thought out.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (248, 'look forward to', 'lʊk ˈfɔːrwərd tʊ', '期待，盼望', 'I look forward to meeting you tomorrow.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (249, 'mature', 'məˈtjʊr', '成熟的', 'She is very mature for her age.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (250, 'more or less', 'mɔːr ɔːr lɛs', '或多或少，大致', 'We’ll be there in more or less 30 minutes.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (251, 'motivated', 'ˈmoʊtɪveɪtɪd', '有动机的', 'She’s highly motivated to succeed.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (252, 'no matter', 'noʊ ˈmætər', '不管，无论', 'No matter what happens, I’ll be there for you.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (253, 'obedient', 'əˈbiːdiənt', '顺从的，听话的', 'The dog was obedient and followed every command.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (254, 'on the verge of', 'ɒn ðə vɜːrdʒ ʌv', '濒临，接近', 'He is on the verge of making a breakthrough in his research.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (255, 'optimistic', 'ˌɒptɪˈmɪstɪk', '乐观的', 'He is optimistic about the future of the company.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (256, 'out of the question', 'aʊt ʌv ðə ˈkwɛsʧən', '不可能的，毫无疑问的', 'A pay raise is out of the question at this time.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (257, 'pessimistic', 'ˌpɛsɪˈmɪstɪk', '悲观的', 'She has a pessimistic outlook on life.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (258, 'put off', 'pʊt ɒf', '推迟', 'They decided to put off the meeting until next week.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (259, 'quick', 'kwɪk', '快速的', 'He’s quick at solving problems.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (260, 'run out of', 'rʌn aʊt ʌv', '用完，耗尽', 'We’ve run out of milk, so I’ll go buy some.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (261, 'sensitive', 'ˈsɛnsɪtɪv', '敏感的', 'She is sensitive to criticism.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (262, 'set up', 'sɛt ʌp', '建立，安排', 'They set up the new computer system yesterday.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (263, 'significant', 'sɪɡˈnɪfɪkənt', '重要的，显著的', 'Her contributions to the project were significant.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (264, 'take it easy', 'teɪk ɪt ˈiːzi', '放松，冷静', 'Take it easy, everything will be fine.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (265, 'useful', 'ˈjuːsfʊl', '有用的', 'This tool is very useful for the task.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (266, 'watch out', 'wɑːʧ aʊt', '小心，注意', 'Watch out for cars when crossing the street.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (267, 'wise', 'waɪz', '明智的', 'It was a wise decision to save money for the future.', '2025-03-18 15:35:29', '中级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (268, 'work out', 'wɜːrk aʊt', '锻炼，解决', 'Everything will work out eventually.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (269, 'young', 'jʌŋ', '年轻的', 'She is young and full of energy.', '2025-03-18 15:35:29', '初级', '单词', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (270, 'zero in on', 'ˈziːroʊ ɪn ɒn', '集中注意力于，瞄准', 'The team zeroed in on the main issue in the report.', '2025-03-18 15:35:29', '中级', '词组', '2025-03-18 15:35:29', 0);
INSERT INTO `vocabulary` VALUES (271, 'habit', 'ˈhæbɪt', '习惯', 'Reading before bed is a good habit.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (272, 'hand in hand', 'hænd ɪn hænd', '携手并进', 'We must work hand in hand to achieve success.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (273, 'half', 'hæf', '一半', 'Half of the students were absent today.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (274, 'hang out', 'hæŋ aʊt', '闲逛', 'We usually hang out at the mall on weekends.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (275, 'happen', 'ˈhæpən', '发生', 'What happened yesterday? It was an unexpected event.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (276, 'hard to come by', 'hɑːrd tʊ kʌm baɪ', '难得，难以获得', 'Good employees are hard to come by.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (277, 'headache', 'ˈhɛdəkeɪk', '头痛', 'I have a headache from all the noise.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (278, 'hold the line', 'hoʊld ðə laɪn', '保持电话线通畅', 'Please hold the line, I’ll connect you with the manager.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (279, 'healthy lifestyle', 'ˈhɛlθi ˈlaɪfˌstaɪl', '健康的生活方式', 'Adopting a healthy lifestyle is important for long-term well-being.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (280, 'highly recommended', 'ˈhaɪli ˌrɛkəˈmɛndəd', '强烈推荐', 'This book is highly recommended by experts in the field.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (281, 'hobby', 'ˈhɒbi', '爱好', 'Reading is one of my favorite hobbies.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (282, 'how long', 'haʊ lɔːŋ', '多久', 'How long will it take to get there?', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (283, 'however', 'haʊˈɛvər', '然而，可是', 'The plan is good, however, it needs more preparation.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (284, 'I beg your pardon', 'aɪ bɛɡ jʊər ˈpɑːdən', '请再说一遍，对不起', 'I beg your pardon, could you repeat that?', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (285, 'important issue', 'ɪmˈpɔːrtənt ˈɪʃuː', '重要问题', 'We need to discuss this important issue during the meeting.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (286, 'impossible', 'ɪmˈpɒsɪbəl', '不可能的', 'It seems impossible, but we can try.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (287, 'in charge of', 'ɪn tʃɑːrdʒ ʌv', '负责', 'She is in charge of organizing the event.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (288, 'incredible', 'ɪnˈkrɛdəbl', '难以置信的', 'The view from the mountain top is incredible.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (289, 'in order to', 'ɪn ˈɔːrdər tʊ', '为了', 'He worked hard in order to achieve his goals.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (290, 'in the future', 'ɪn ðə ˈfjuːtʃər', '在未来', 'We hope to expand the business in the future.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (291, 'in time for', 'ɪn taɪm fɔːr', '及时赶到', 'We arrived just in time for the concert.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (292, 'involved in', 'ɪnˈvɒlvd ɪn', '参与，涉及', 'He is involved in many charity activities.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (293, 'ironic', 'aɪˈrɒnɪk', '具有讽刺意味的', 'It was ironic that they missed the train after rushing to the station.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (294, 'isn’t it', 'ˈɪznt ɪt', '不是吗？', 'It’s a beautiful day, isn’t it?', '2025-03-18 15:36:57', '初级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (295, 'issue', 'ˈɪʃuː', '问题，争论', 'The issue needs to be addressed immediately.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (296, 'just a minute', 'ʤʌst ə ˈmɪnɪt', '等一下', 'Just a minute, I’ll be right back.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (297, 'keep in mind', 'kiːp ɪn maɪnd', '记住，考虑到', 'Keep in mind that the meeting starts at 9:00 AM.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (298, 'key', 'kiː', '关键的', 'He played a key role in the project’s success.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (299, 'kick the habit', 'kɪk ðə ˈhæbɪt', '戒掉习惯', 'It’s not easy to kick the smoking habit.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (300, 'kind', 'kaɪnd', '友善的', 'She is a kind person who always helps others.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (301, 'look after', 'lʊk ˈæftər', '照顾', 'He looks after his younger sister while their parents are away.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (302, 'listen to', 'ˈlɪsən tuː', '听', 'I love to listen to music while working.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (303, 'lucky', 'ˈlʌki', '幸运的', 'She is a lucky person who always wins contests.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (304, 'make a difference', 'meɪk ə ˈdɪfrəns', '有所不同，产生影响', 'Your actions can make a difference in the world.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (305, 'make sure', 'meɪk ʃʊr', '确保，确认', 'Make sure to lock the door before leaving.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (306, 'managing', 'ˈmænɪdʒɪŋ', '管理的', 'He’s managing the team for the upcoming project.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (307, 'no longer', 'noʊ ˈlɔːŋɡər', '不再', 'She no longer works at that company.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (308, 'obvious', 'ˈɒbviəs', '明显的', 'It was obvious that they were not prepared for the presentation.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (309, 'on time', 'ɒn taɪm', '准时', 'He always arrives on time for meetings.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (310, 'on the whole', 'ɒn ðə hoʊl', '总的来说', 'On the whole, the event was a success.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (311, 'once in a while', 'wʌns ɪn ə waɪl', '偶尔', 'I go to the beach once in a while.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (312, 'ordinary', 'ˈɔːdənəri', '普通的，平凡的', 'He lives an ordinary life with no fame or fortune.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (313, 'out of order', 'aʊt ʌv ˈɔːdər', '故障的，失常的', 'The elevator is out of order at the moment.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (314, 'overcome', 'ˌoʊvərˈkʌm', '克服', 'She managed to overcome all obstacles in her way.', '2025-03-18 15:36:57', '中级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (315, 'pass away', 'pæs əˈweɪ', '去世', 'He passed away last year after a long illness.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (316, 'possible', 'ˈpɒsɪbəl', '可能的', 'It is possible to improve your skills with practice.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (317, 'prior to', 'ˈpraɪər tʊ', '在...之前', 'You should complete the task prior to the deadline.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (318, 'promise', 'ˈprɒmɪs', '承诺', 'She promised to finish the work by Friday.', '2025-03-18 15:36:57', '初级', '单词', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (319, 'put up with', 'pʊt ʌp wɪð', '忍受，容忍', 'I can’t put up with all the noise in this office.', '2025-03-18 15:36:57', '中级', '词组', '2025-03-18 15:36:57', 0);
INSERT INTO `vocabulary` VALUES (320, '测试', '测试', '测试2', '测试', '2025-03-19 18:40:00', '初级', '单词', '2025-03-19 18:40:09', 1);
INSERT INTO `vocabulary` VALUES (321, 'accurately', 'test', 'adv. 精确地，准确地', '测试', '2025-03-19 21:55:39', '初级', '单词', '2025-03-19 21:55:45', 1);

SET FOREIGN_KEY_CHECKS = 1;
