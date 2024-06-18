/*
 Navicat Premium Data Transfer

 Source Server         : 行智-行数-sit
 Source Server Type    : MySQL
 Source Server Version : 50740
 Source Host           : 172.27.12.227:23214
 Source Schema         : xs_theme

 Target Server Type    : MySQL
 Target Server Version : 50740
 File Encoding         : 65001

 Date: 10/05/2023 11:12:42
*/


DROP DATABASE IF EXISTS xs_theme;
CREATE DATABASE xs_theme DEFAULT character set utf8mb4;

use xs_theme;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for tm_dir
-- ----------------------------
DROP TABLE IF EXISTS `tm_dir`;
CREATE TABLE `tm_dir`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '目录名',
  `description` varchar(510) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `parent_id` bigint(64) NULL DEFAULT NULL COMMENT '父ID',
  `parent_ids` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '父辈节点组成的字符串',
  `level` int(11) NULL DEFAULT NULL COMMENT '目录层级',
  `is_last_level` tinyint(4) NULL DEFAULT NULL COMMENT '是否是叶子节点: 0-否；1-是',
  `connection_id` int(11) NULL DEFAULT NULL COMMENT '数据库连接id',
  `weight` int(11) NULL DEFAULT NULL COMMENT '排序种子 ，值越大越靠后',
  `create_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '最近更新人',
  `type` tinyint(4) NULL DEFAULT 0 COMMENT '类型: 0-数据库连接; 1-接口',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近更新时间',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0' COMMENT '组织机构id路径',
  `security_level` tinyint(4) NULL DEFAULT NULL COMMENT '数据安全等级权限',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主题目录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tm_dir
-- ----------------------------
INSERT INTO `tm_dir` VALUES (1, '主题管理', '主题管理', 0, '0/', 1, 0, NULL, 0, 'admin', 'admin', 0, '2021-12-29 18:24:32', '2022-03-01 07:58:44', '0', 0, NULL);

-- ----------------------------
-- Table structure for tm_file_encode
-- ----------------------------
DROP TABLE IF EXISTS `tm_file_encode`;
CREATE TABLE `tm_file_encode`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `encode` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '编码',
  `sort` int(11) NULL DEFAULT NULL COMMENT '显示顺序',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件编码方式' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of tm_file_encode
-- ----------------------------

-- ----------------------------
-- Table structure for tm_file_info
-- ----------------------------
DROP TABLE IF EXISTS `tm_file_info`;
CREATE TABLE `tm_file_info`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件名称',
  `file_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件类型: excel、txt、csv、json、xml',
  `file_path` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '文件路径',
  `table_id` bigint(64) NOT NULL COMMENT '表id',
  `table_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表名称',
  `sheet_num` tinyint(5) NOT NULL COMMENT 'sheet编号, file_type==excel时，必填，一个excel可能对应多条记录',
  `sheet_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'sheet名称，file_type==excel时，必填',
  `column_mapping` text CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '文件字段与表字段映射',
  `separator` tinyint(4) NULL DEFAULT NULL COMMENT '分隔符: 1-逗号; 2-分号; 3-制表符; 4-空格; 5-其他',
  `custom_separator` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '自定义分隔符: 当separator字段为5时必填',
  `identifier` tinyint(4) NULL DEFAULT NULL COMMENT '文件识别符: 1-无; 2-单引号; 3-双引号',
  `first_header` tinyint(4) NULL DEFAULT NULL COMMENT '是否首行为表头：0-否; 1-是',
  `encode` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT 'utf-8' COMMENT '字符编码',
  `auto_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '表中自增字段名称',
  `begin_row` int(11) NOT NULL COMMENT '表中对应数据的开始行',
  `end_row` int(11) NULL DEFAULT NULL COMMENT '表中对应数据的结束行',
  `data_count` int(11) NOT NULL COMMENT '插入数据总数',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最近更新人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '文件信息表' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of tm_file_info
-- ----------------------------

-- ----------------------------
-- Table structure for tm_table
-- ----------------------------
DROP TABLE IF EXISTS `tm_table`;
CREATE TABLE `tm_table`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `name` varchar(125) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据表名称',
  `dir_id` bigint(64) NOT NULL COMMENT '父目录id',
  `origin_connection_id` int(11) NULL DEFAULT NULL COMMENT '原始数据连接id',
  `origin_full_table_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '完整原始表名：`db_datafusion`.`user_online`',
  `create_way` tinyint(4) NULL DEFAULT NULL COMMENT '创建方式：1-已有表; 2-导入数据; 3-选择数据表; 4-自定义',
  `connection_id` int(11) NOT NULL COMMENT '数据连接id',
  `table_name` varchar(125) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表名',
  `full_table_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '完整表名：`db_datafusion`.`user_online`',
  `auto_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表中自增字段名称',
  `table_type` tinyint(4) NOT NULL COMMENT '表类型：1-实体表; 2-模型表',
  `link_content` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '模型表关联的内容',
  `link_select_sql` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '模型表查询sql',
  `data_number` int(11) NULL DEFAULT NULL COMMENT '数据量',
  `remark` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  `weight` int(11) NULL DEFAULT 1 COMMENT '排序种子 ，值越大越靠后',
  `import_status` int(11) NULL DEFAULT NULL COMMENT '导入状态：1-导入中; 2-导入完成; 3-导入失败',
  `import_version` int(11) NULL DEFAULT 1 COMMENT '导入版本（乐观锁）',
  `import_error` longtext CHARACTER SET utf8 COLLATE utf8_general_ci NULL COMMENT '导入失败原因',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最近更新人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近更新时间',
  `org_id_path` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '组织机构id路径',
  `security_level` tinyint(4) NULL DEFAULT NULL COMMENT '数据安全等级权限',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '主题数据表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tm_table
-- ----------------------------

-- ----------------------------
-- Table structure for tm_table_column
-- ----------------------------
DROP TABLE IF EXISTS `tm_table_column`;
CREATE TABLE `tm_table_column`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `column_name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字段名',
  `column_alias` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '字段别名',
  `column_type` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '字段类型',
  `table_name` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '表名',
  `table_alias` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '' COMMENT '表别名',
  `connection_id` int(11) NOT NULL COMMENT '数据连接ID',
  `data_model_id` bigint(64) NOT NULL COMMENT '数据模型ID',
  `create_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `update_user` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '最近更新人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '最近更新时间',
  `org_id_path` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT '0' COMMENT '组织机构id路径',
  `security_level` tinyint(4) NULL DEFAULT NULL COMMENT '数据安全等级权限',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '字段智能分析' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of tm_table_column
-- ----------------------------

SET FOREIGN_KEY_CHECKS = 1;
