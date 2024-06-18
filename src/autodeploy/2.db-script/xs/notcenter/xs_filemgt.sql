/*
 Navicat Premium Data Transfer

 Source Server         : 行智-行数-sit
 Source Server Type    : MySQL
 Source Server Version : 50740
 Source Host           : 172.27.12.227:23214
 Source Schema         : xs_filemgt

 Target Server Type    : MySQL
 Target Server Version : 50740
 File Encoding         : 65001

 Date: 10/05/2023 11:12:58
*/

DROP DATABASE IF EXISTS xs_filemgt;
CREATE DATABASE xs_filemgt DEFAULT character set utf8mb4;

use xs_filemgt;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for file_chunk
-- ----------------------------
DROP TABLE IF EXISTS `file_chunk`;
CREATE TABLE `file_chunk`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键，唯一标识',
  `md5` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '文件标识',
  `path` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '存储路径',
  `chunk` int(11) NOT NULL COMMENT '分片的序号',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_chunk
-- ----------------------------

-- ----------------------------
-- Table structure for file_directory
-- ----------------------------
DROP TABLE IF EXISTS `file_directory`;
CREATE TABLE `file_directory`  (
  `id` bigint(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增',
  `resource_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'uuid',
  `source` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '系统资源标识',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '目录名称',
  `parent_id` bigint(11) NOT NULL COMMENT '父亲节点',
  `parent_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '父辈节点组成的字符串',
  `weight` int(11) NOT NULL DEFAULT 1000 COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 -1删除  0无效 1有效',
  `is_show` tinyint(4) NOT NULL DEFAULT 1 COMMENT '是否显示 0不显示 1显示',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '创建人员',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '更新人员',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '资源权限字段',
  `security_level` tinyint(4) NOT NULL DEFAULT 0 COMMENT '数据安全等级权限',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_ids`(`parent_ids`) USING BTREE,
  INDEX `idx_parent_id_name`(`parent_id`, `name`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '非结构化资源目录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_directory
-- ----------------------------
INSERT INTO `file_directory` VALUES (1, '1651426310053220354', 'xs-filemgt', '行智', 0, '0', 1000, 1, 1, '2023-04-27 03:21:29', 'super', '2023-05-10 03:08:56', 'super', '0/1/', 0, 1);

-- ----------------------------
-- Table structure for file_download_log
-- ----------------------------
DROP TABLE IF EXISTS `file_download_log`;
CREATE TABLE `file_download_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) NOT NULL,
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_itemid`(`create_time`) USING BTREE,
  INDEX `fk_file_download_log_file_item1_idx`(`item_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '文件下载日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_download_log
-- ----------------------------

-- ----------------------------
-- Table structure for file_item
-- ----------------------------
DROP TABLE IF EXISTS `file_item`;
CREATE TABLE `file_item`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `source` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '系统资源标识',
  `directory_id` bigint(11) NOT NULL COMMENT '资源目录id',
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '文件名称',
  `file_size` bigint(64) NOT NULL DEFAULT 0 COMMENT '文件大小',
  `file_extension` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '文件扩展名   doc, excel',
  `storage_class` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'file:本地  hdfs: hbase: minio: ceph:   ',
  `trans_pdf` tinyint(4) NOT NULL DEFAULT 0 COMMENT '是否转换为pdf',
  `pdf_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT 'pdf存储路径',
  `path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL DEFAULT '' COMMENT '存储路径',
  `upload_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '-1：上传异常 0：上传中 1：上传完成',
  `status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '保留字段',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人员',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '更新人员',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '资源权限字段',
  `security_level` tinyint(4) NULL DEFAULT NULL COMMENT '数据安全等级权限',
  `md5` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '文件对应的MD5',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  `save_flag` bigint(2) NOT NULL DEFAULT 1 COMMENT '业务系统保存文件的确认标识 0：未点击保存 1：点击保存',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_directoryid_filename_fileextension`(`directory_id`, `file_name`, `file_extension`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '非结构化文件表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of file_item
-- ----------------------------

-- ----------------------------
-- Table structure for file_upload_log
-- ----------------------------
DROP TABLE IF EXISTS `file_upload_log`;
CREATE TABLE `file_upload_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `item_id` bigint(20) NOT NULL,
  `file_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '文件名称',
  `file_size` bigint(20) NOT NULL COMMENT '文件大小',
  `local_path` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '本地路径',
  `uid` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '文件uuid',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL COMMENT '创建人员',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `del_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '删除状态  0 未删除   1已删除',
  `batch_id` char(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_itemid`(`create_time`) USING BTREE,
  INDEX `fk_file_upload_log_file_item1_idx`(`item_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_bin COMMENT = '文件上传日志' ROW_FORMAT = DYNAMIC;

ALTER TABLE `file_directory` DROP COLUMN `resource_id`;

ALTER TABLE `file_directory` MODIFY COLUMN `parent_ids` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT '父辈节点组成的字符串' AFTER `parent_id`;

ALTER TABLE `file_item` MODIFY COLUMN `file_size` bigint(11) NOT NULL DEFAULT 0 COMMENT '文件大小' AFTER `file_name`;

ALTER TABLE `file_item` MODIFY COLUMN `upload_status` tinyint(4) NOT NULL DEFAULT 0 COMMENT '上传状态 -1:上传异常 0:上传中 1:上传完成' AFTER `path`;

ALTER TABLE `file_item` ADD INDEX `idx_fe`(`file_extension`) USING BTREE;

ALTER TABLE `file_upload_log` DROP COLUMN `local_path`;

ALTER TABLE `file_upload_log` DROP COLUMN `uid`;

ALTER TABLE `file_upload_log` DROP COLUMN `del_status`;

ALTER TABLE `file_upload_log` DROP COLUMN `batch_id`;

DROP TABLE `file_chunk`;
-- ----------------------------
-- Records of file_upload_log
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
