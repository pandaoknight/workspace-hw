/*
 Navicat Premium Data Transfer

 Source Server         : 行智-行数-sit
 Source Server Type    : MySQL
 Source Server Version : 50740
 Source Host           : 172.27.12.227:23214
 Source Schema         : xs_sysmgt

 Target Server Type    : MySQL
 Target Server Version : 50740
 File Encoding         : 65001

 Date: 10/05/2023 11:12:49
*/

DROP DATABASE IF EXISTS xs_sysmgt;
CREATE DATABASE xs_sysmgt DEFAULT character set utf8mb4;

use xs_sysmgt;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for shedlock
-- ----------------------------
DROP TABLE IF EXISTS `shedlock`;
CREATE TABLE `shedlock`  (
  `NAME` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `lock_until` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
  `locked_at` timestamp(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  `locked_by` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`NAME`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of shedlock
-- ----------------------------

DROP TABLE IF EXISTS `sys_abcd`;
CREATE TABLE `sys_abcd`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `abcd` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'license',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'license' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Table structure for sys_app
-- ----------------------------
DROP TABLE IF EXISTS `sys_app`;
CREATE TABLE `sys_app`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '应用名称',
  `description` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态：-1删除; 0无效; 1有效',
  `is_system` tinyint(4) NULL DEFAULT NULL COMMENT '是否系统内置：0否；1是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_app
-- ----------------------------
INSERT INTO `sys_app` VALUES (1, '内置app', '行数应用', 1, 1, '2022-11-25 06:27:01', '2023-01-29 10:13:48', 'admin', 'TODO_UPDATE_USER');




-- ----------------------------
-- Table structure for sys_app_member
-- ----------------------------
DROP TABLE IF EXISTS `sys_app_member`;
CREATE TABLE `sys_app_member`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(64) NOT NULL COMMENT '应用id',
  `user_id` bigint(64) NOT NULL COMMENT '用户id',
  `is_admin` tinyint(4) NOT NULL COMMENT '是否是管理员：0-否; 1-是',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用成员表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_app_member
-- ----------------------------

-- ----------------------------
-- Table structure for sys_app_to_resource_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_app_to_resource_config`;
CREATE TABLE `sys_app_to_resource_config`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(64) NOT NULL COMMENT '应用id',
  `resource_id` bigint(64) NOT NULL COMMENT '模块id（一级菜单id）',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '应用的模块表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_app_to_resource_config
-- ----------------------------
INSERT INTO `sys_app_to_resource_config` VALUES (1, 1, 2, '2022-11-25 06:42:31', 'admin');

-- ----------------------------
-- Table structure for sys_audit_log
-- ----------------------------
DROP TABLE IF EXISTS `sys_audit_log`;
CREATE TABLE `sys_audit_log`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT COMMENT 'id主键',
  `source` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '顶级菜单id',
  `module` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '叶子菜单id',
  `operation` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '操作 create,update,delete,retrieve,audit',
  `method` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '方法名称',
  `operate_content` varchar(1000) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '操作对象',
  `request_params` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT '请求参数',
  `operate_time` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '操作时间',
  `user` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '操作用户',
  `real_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '用户真实姓名',
  `ip` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT 'ip',
  `exceptions` text CHARACTER SET utf8 COLLATE utf8_bin NULL COMMENT '异常信息',
  `app_id` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '应用id',
  `result` tinyint(4) NULL DEFAULT 1 COMMENT '操作结果，1成功，0失败',
  `uri` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '请求地址',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '审计日志' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_audit_log
-- ----------------------------

-- ----------------------------
-- Table structure for sys_auth
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth`;
CREATE TABLE `sys_auth`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `organization_id` bigint(64) NULL DEFAULT 0 COMMENT '组织机构id',
  `job_id` bigint(64) UNSIGNED NULL DEFAULT 0 COMMENT '职位id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_query`(`organization_id`, `job_id`) USING BTREE,
  INDEX `fk_sys_auth_organization_idx`(`organization_id`) USING BTREE,
  INDEX `fk_sys_auth_job_idx`(`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '授权对象（组织和职位的关系）表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_auth
-- ----------------------------

-- ----------------------------
-- Table structure for sys_auth_to_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_auth_to_role`;
CREATE TABLE `sys_auth_to_role`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `auth_id` bigint(64) NULL DEFAULT NULL COMMENT '授权对象id',
  `user_id` bigint(64) NULL DEFAULT NULL COMMENT '用户id',
  `role_id` bigint(64) UNSIGNED NOT NULL COMMENT '角色id',
  `app_id` bigint(64) NOT NULL COMMENT '应用id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_id`(`user_id`) USING BTREE,
  INDEX `idx_auth_id`(`auth_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '授权对象与角色的关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_auth_to_role
-- ----------------------------
INSERT INTO `sys_auth_to_role` VALUES (1, NULL, 2, 2, 1, '2023-02-23 11:21:33');

DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置名称',
  `type` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置类型：kv, image',
  `value` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '配置值',
  `image` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT '图片，base64',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `need_restart` tinyint(1) NOT NULL COMMENT '是否需要重启',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint(64) NOT NULL COMMENT '创建人',
  `update_date` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_by` bigint(64) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `UK_name`(`name`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统配置' ROW_FORMAT = Dynamic;

INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (1, 'APP_TYPE', 'KV', 'single', NULL, 'app类型：multiple-多app；single-单app', 1, '2023-08-18 19:04:41', 0, '2023-09-14 09:25:21', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (2, 'SYS_TAB_TYPE', 'KV', 'multiple', NULL, '浏览器页签类型: multiple-多页签；single-单页签', 1, '2023-08-21 12:14:14', 0, '2023-08-21 13:39:50', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (3, 'INITIAL_PASSWORD', 'KV', 'Szl@2023!', NULL, '用户初始密码', 1, '2023-08-18 19:04:41', 0, '2023-08-21 13:32:44', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (4, 'SYS_TITLE', 'KV', '数据中台#1', NULL, '系统名称', 1, '2023-08-18 19:04:41', 0, '2023-08-21 13:32:38', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (5, 'SYS_VERSION', 'KV', '3.2.0', NULL, '系统版本', 1, '2023-08-21 11:25:30', 0, '2023-09-14 15:09:44', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (6, 'SYS_COPYRIGHT', 'KV', 'Copyright© 2023, All rights reserved', NULL, '系统版权', 1, '2023-08-18 19:04:41', 0, '2023-09-14 15:10:26', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (13, 'SYS_SHOW_INTRODUCTION', 'KV', 'true', NULL, '是否显示产品介绍：true-显示；false-不显示', 1, '2023-10-07 10:29:26', 0, '2023-10-07 10:28:54', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (14, 'YARN_SESSION_APP_ID', 'KV', 'application_1703210099035_19578', NULL, 'yarn session的application id', 1, '2023-10-13 09:30:04', 2, '2023-10-13 09:29:08', NULL);
INSERT INTO `sys_config` (`id`, `name`, `type`, `value`, `image`, `description`, `need_restart`, `create_date`, `create_by`, `update_date`, `update_by`) VALUES (15, 'YARN_QUEUE', 'KV', 'default', NULL, 'yarn 队列 列表，逗号分隔', 1, '2023-11-06 11:11:51', 1, '2023-11-06 11:19:08', NULL);


-- ----------------------------
-- Table structure for sys_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_config_access`;
CREATE TABLE `sys_config_access`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `source` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '系统标识 sys系统管理 elt数据工厂 datafusion共享交换 data-mgt数据管理 data-agg数据汇聚 data-govern数据治理',
  `name` varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '项目名称  系统管理  数据工厂  共享交换  数据管理  数据汇聚  数据治理',
  `web_url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '前端项目地址',
  `app_url` varchar(1024) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '后端接口地址(逗号分隔，默认取第一个，其他通过下标特殊处理)',
  `remark` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 19 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统配置' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_config_access
-- ----------------------------
INSERT INTO `sys_config_access` VALUES (1, 'sys', '系统管理', '/mgt/#', '/szl-center-system/', '');
INSERT INTO `sys_config_access` VALUES (15, 'datamgt', '数据管理', '/data/#', '/xs-database/,/xs-filemgt/,/xs-theme/', NULL);
INSERT INTO `sys_config_access` VALUES (16, 'label', '数据标注', '/label/#/', '/', NULL);
INSERT INTO `sys_config_access` VALUES (17, 'algorithm', '模型训练', '/algorithm/#/', '/', NULL);
INSERT INTO `sys_config_access` VALUES (18, 'help', '帮助文档', '/help/', '/', NULL);

-- ----------------------------
-- Table structure for sys_data_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_permission`;
CREATE TABLE `sys_data_permission`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `permission_group_id` bigint(64) NOT NULL COMMENT '权限组id',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '权限名称',
  `field_name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '字段名',
  `relational` varchar(32) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '关系表达式',
  `value` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '值',
  `condition` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼凑好的完整过滤sql',
  `is_default` tinyint(4) NOT NULL COMMENT '是否是默认子项：0-否; 1-是',
  `weight` int(11) NULL DEFAULT NULL COMMENT '排序种子 ，值越大越靠后',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_data_permission
-- ----------------------------
INSERT INTO `sys_data_permission` VALUES (1, 1, '仅个人数据', NULL, NULL, NULL, NULL, 0, NULL, '2023-03-24 15:28:16', '2023-03-24 15:28:16', 'getUsername()', 'getUsername()');
INSERT INTO `sys_data_permission` VALUES (2, 1, '本部门', NULL, NULL, NULL, NULL, 0, NULL, '2023-03-24 15:28:16', '2023-03-24 15:28:16', 'getUsername()', 'getUsername()');
INSERT INTO `sys_data_permission` VALUES (3, 1, '本部门及下级本部', NULL, NULL, NULL, NULL, 0, NULL, '2023-03-24 15:28:16', '2023-03-24 15:28:16', 'getUsername()', 'getUsername()');
INSERT INTO `sys_data_permission` VALUES (4, 1, '所有', NULL, NULL, NULL, NULL, 1, NULL, '2023-03-24 15:28:16', '2023-03-24 15:28:16', 'getUsername()', 'getUsername()');

-- ----------------------------
-- Table structure for sys_data_permission_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_data_permission_group`;
CREATE TABLE `sys_data_permission_group`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '名称',
  `description` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '描述',
  `is_default` tinyint(4) NULL DEFAULT 0 COMMENT '是否默认（0否，1是)',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  `status` tinyint(4) NULL DEFAULT 0 COMMENT '状态：-1删除; 0无效; 1有效',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '数据权限组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_data_permission_group
-- ----------------------------
INSERT INTO `sys_data_permission_group` VALUES (1, '组织机构权限', '系统内置权限设置', 0, '2023-02-24 11:30:14', '2023-03-24 15:28:16', 'admin', '', 1);

-- ----------------------------
-- Table structure for sys_dict
-- ----------------------------
DROP TABLE IF EXISTS `sys_dict`;
CREATE TABLE `sys_dict`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `type_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典类型编码',
  `type_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典类型名称',
  `code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典编码',
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '字典名称',
  `weight` int(11) NOT NULL DEFAULT 99 COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态：-1删除; 0无效; 1有效',
  `remark` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '备注',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 41 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '字典表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_dict
-- ----------------------------
INSERT INTO `sys_dict` VALUES (1, 'applicationName', '应用服务名称', 'szl-center-system', '系统管理', 1, 1, NULL);
INSERT INTO `sys_dict` VALUES (2, 'applicationName', '应用服务名称', 'szl-center-log-server', '日志查询服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (3, 'auditLogOperationType', '审计日志操作类型', '新增', '新增', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (4, 'auditLogOperationType', '审计日志操作类型', '编辑', '编辑', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (5, 'auditLogOperationType', '审计日志操作类型', '删除', '删除', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (6, 'auditLogOperationType', '审计日志操作类型', '查看', '查看', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (7, 'auditLogOperationType', '审计日志操作类型', '导入', '导入', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (8, 'auditLogOperationType', '审计日志操作类型', '导出', '导出', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (9, 'auditLogOperationType', '审计日志操作类型', '启用', '启用', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (10, 'auditLogOperationType', '审计日志操作类型', '停用', '停用', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (11, 'auditLogOperationType', '审计日志操作类型', '暂停', '暂停', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (12, 'auditLogOperationType', '审计日志操作类型', '停止', '停止', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (13, 'auditLogOperationType', '审计日志操作类型', '移动', '移动', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (14, 'auditLogOperationType', '审计日志操作类型', '复制', '复制', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (15, 'auditLogOperationType', '审计日志操作类型', '登录', '登录', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (16, 'auditLogOperationType', '审计日志操作类型', '登出', '登出', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (17, 'applicationName', '应用服务名称', 'xs-database', '数据库服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (18, 'applicationName', '应用服务名称', 'xs-dtstd', '数据标准服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (19, 'applicationName', '应用服务名称', 'szl-center-auth', '授权服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (20, 'applicationName', '应用服务名称', 'xs-metadata', '元数据服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (21, 'applicationName', '应用服务名称', 'xs-visualization', '可视化服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (22, 'applicationName', '应用服务名称', 'rdc-etl', '数据加工服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (23, 'applicationName', '应用服务名称', 'xs-filemgt', '文件管理服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (24, 'applicationName', '应用服务名称', 'szl-center-gateway', '网关服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (25, 'applicationName', '应用服务名称', 'xs-statistic', '数据资产统计服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (26, 'applicationName', '应用服务名称', 'xs-warehouse-design', '数仓设计服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (27, 'applicationName', '应用服务名称', 'xs-theme', '主题集服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (28, 'applicationName', '应用服务名称', 'xs-data-exchange', '数据共享交换服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (30, 'applicationName', '应用服务名称', 'xs-data-govern', '数据治理服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (31, 'applicationName', '应用服务名称', 'xs-maindata', '主数据服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (32, 'applicationName', '应用服务名称', 'szl-center-monitor', '系统监控服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (33, 'applicationName', '应用服务名称', 'xs-data-exchange-api', '数据共享交换服务api', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (34, 'applicationName', '应用服务名称', 'xs-data-exchange-sub', '数据共享交换服务sub', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (35, 'applicationName', '应用服务名称', 'xs-statistic-executor', '数据资产统计服务executor', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (36, 'applicationName', '应用服务名称', 'xs-scheduler', '调度平台服务', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (37, 'applicationName', '应用服务名称', 'xs-scheduler-server-worker', '调度平台服务worker', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (38, 'applicationName', '应用服务名称', 'xs-scheduler-server-master', '调度平台服务master', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (39, 'applicationName', '应用服务名称', 'xs-scheduler-server-alert', '调度平台服务alert', 99, 1, NULL);
INSERT INTO `sys_dict` VALUES (40, 'applicationName', '应用服务名称', 'xs-data-api', '接口管理服务', 99, 1, NULL);

-- ----------------------------
-- Table structure for sys_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_job`;
CREATE TABLE `sys_job`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组织机构名称',
  `parent_id` bigint(64) NULL DEFAULT NULL COMMENT '父级id',
  `parent_ids` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '父辈节点组成的字符串',
  `icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标class',
  `weight` int(11) NULL DEFAULT NULL COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态 -1删除  0无效 1有效',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组织机构id路径',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parentid`(`parent_id`) USING BTREE,
  INDEX `idx_name`(`name`) USING BTREE,
  INDEX `idx_parentids_weight`(`parent_ids`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '工作职务' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_job
-- ----------------------------
INSERT INTO `sys_job` VALUES (1, '工作职务', 0, '0/', 'ztree_file', 1, 1, '0', '2021-12-27 09:38:37', '2021-12-28 13:55:47', '', '');

-- ----------------------------
-- Table structure for sys_organization
-- ----------------------------
DROP TABLE IF EXISTS `sys_organization`;
CREATE TABLE `sys_organization`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组织机构名称',
  `parent_id` bigint(64) NULL DEFAULT NULL COMMENT '父级id',
  `parent_ids` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '' COMMENT '父辈节点组成的字符串',
  `simple_name` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组织机构简称',
  `code` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组织机构编码',
  `parent_code` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '上级组织机构编码',
  `weight` int(11) NULL DEFAULT NULL COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NULL DEFAULT NULL COMMENT '状态 -1删除  0无效 1有效',
  `type` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '组织机构类型',
  `icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '图标class',
  `area_code` int(11) NULL DEFAULT NULL COMMENT '地区编码',
  `spell` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '拼音缩写',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组织机构id路径',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parentid`(`parent_id`) USING BTREE,
  INDEX `idx_parentids_weight`(`parent_ids`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '组织机构' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_organization
-- ----------------------------
INSERT INTO `sys_organization` VALUES (-1, '无组织机构', 1, '0/1/', NULL, NULL, NULL, 9999, 1, NULL, 'ztree_file', NULL, NULL, '0', '2022-11-25 11:36:18', '2022-11-25 05:45:05', 'admin', 'admin');
INSERT INTO `sys_organization` VALUES (1, '组织机构', 0, '0/', NULL, NULL, NULL, 1, 1, NULL, 'ztree_file', NULL, NULL, '0', '2022-11-25 11:36:18', '2022-11-25 05:45:05', 'admin', 'admin');

-- ----------------------------
-- Table structure for sys_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_permission`;
CREATE TABLE `sys_permission`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限名称',
  `permission` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限标识',
  `description` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` tinyint(4) NOT NULL COMMENT '状态  -1 删除 0否 1是',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `permission_UNIQUE`(`permission`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 52 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_permission
-- ----------------------------
INSERT INTO `sys_permission` VALUES (1, '所有', '*', '所有操作的权限', 1);
INSERT INTO `sys_permission` VALUES (2, '新增', 'create', '新增', 1);
INSERT INTO `sys_permission` VALUES (3, '删除', 'delete', '删除', 1);
INSERT INTO `sys_permission` VALUES (4, '编辑', 'update', '编辑', 1);
INSERT INTO `sys_permission` VALUES (5, '查看', 'view', '查看', 1);
INSERT INTO `sys_permission` VALUES (6, '审核', 'audit', '审核', 1);
INSERT INTO `sys_permission` VALUES (7, '上传', 'upload', '上传', 1);
INSERT INTO `sys_permission` VALUES (8, '下载', 'download', '下载', 1);
INSERT INTO `sys_permission` VALUES (9, '发布', 'publish', '发布', 1);
INSERT INTO `sys_permission` VALUES (10, '运行/启动/停止', 'execute', '运行/启动/停止', 1);
INSERT INTO `sys_permission` VALUES (11, '导出', 'export', '导出', 1);
INSERT INTO `sys_permission` VALUES (12, '申请', 'apply', '申请', 1);
INSERT INTO `sys_permission` VALUES (13, '新建组织机构', 'create-organ', '创建组织机构', 1);
INSERT INTO `sys_permission` VALUES (14, '编辑组织机构', 'update-organ', '编辑组织机构', 1);
INSERT INTO `sys_permission` VALUES (15, '删除组织机构', 'delete-organ', '删除组织机构', 1);
INSERT INTO `sys_permission` VALUES (16, '强制退出', 'force-out', '强制退出', 1);
INSERT INTO `sys_permission` VALUES (17, '重置密码', 'reset-password', '重置密码', 1);
INSERT INTO `sys_permission` VALUES (18, '启用/禁用', 'usage', '启用/禁用', 1);
INSERT INTO `sys_permission` VALUES (19, '导入', 'import', '批量导入用户', 1);
INSERT INTO `sys_permission` VALUES (21, '审核处理', 'aduit-process', '审核处理', 1);
INSERT INTO `sys_permission` VALUES (22, '编辑任务规则', 'update-rule', '编辑任务规则', 1);
INSERT INTO `sys_permission` VALUES (23, '终止', 'stop', '终止', 1);
INSERT INTO `sys_permission` VALUES (24, '开启', 'open', '开启', 1);
INSERT INTO `sys_permission` VALUES (25, '提交', 'submit', '提交按钮', 1);
INSERT INTO `sys_permission` VALUES (26, '校验规则配置', 'validation-set', '校验规则配置', 1);
INSERT INTO `sys_permission` VALUES (27, '执行同步', 'execute-sync', '执行同步', 1);
INSERT INTO `sys_permission` VALUES (28, '同步配置', 'sync-set', '同步配置', 1);
INSERT INTO `sys_permission` VALUES (29, '回收', 'recycle', '回收', 1);
INSERT INTO `sys_permission` VALUES (30, '数据预览', 'data-preview', '数据预览', 1);
INSERT INTO `sys_permission` VALUES (31, '模型预览', 'model-preview', '模型预览', 1);
INSERT INTO `sys_permission` VALUES (33, '重命名', 'rename', '重命名', 1);
INSERT INTO `sys_permission` VALUES (34, '历史记录', 'history', '历史记录', 1);
INSERT INTO `sys_permission` VALUES (36, '访问', 'access', '访问', 1);
INSERT INTO `sys_permission` VALUES (37, '字段信息', 'field-info', '字段信息', 1);
INSERT INTO `sys_permission` VALUES (38, '移动', 'move', '移动', 1);
INSERT INTO `sys_permission` VALUES (39, '复制 ', 'copy', '复制', 1);
INSERT INTO `sys_permission` VALUES (40, '配置人员', 'set-user', '配置人员', 1);
INSERT INTO `sys_permission` VALUES (42, '下线', 'offline', '下线', 1);
INSERT INTO `sys_permission` VALUES (43, '设置列表显示项', 'set-list-view', '设置列表显示项', 1);
INSERT INTO `sys_permission` VALUES (44, '设置引用', 'set-relation', '设置引用', 1);
INSERT INTO `sys_permission` VALUES (45, '连接导入', 'database-import', '数据规划-数据组织-连接导入', 1);
INSERT INTO `sys_permission` VALUES (46, '数据表更新', 'create-table', '数据规划-数据组织-同步/更新表结构', 1);
INSERT INTO `sys_permission` VALUES (48, '导入组织机构', 'import-organ', '导入组织机构', 1);
INSERT INTO `sys_permission` VALUES (49, '导出组织机构', 'export-organ', '导出组织机构', 1);
INSERT INTO `sys_permission` VALUES (50, '验证', 'verify', '在线测试verify（服务详情页面的在线测试）/审核', 1);
INSERT INTO `sys_permission` VALUES (51, '标注', 'label', '数据集标注', 1);

-- ----------------------------
-- Table structure for sys_resource
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource`;
CREATE TABLE `sys_resource`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'ID自增列',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '资源名称',
  `source` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '平台标识',
  `identity` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '资源唯一标识 如index   资源标识_资源标识',
  `pos` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单位置: top|left',
  `url` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '请求url',
  `parent_id` bigint(64) UNSIGNED NOT NULL COMMENT '父亲节点',
  `parent_ids` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父辈节点组成的字符串',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标class',
  `weight` int(11) NOT NULL COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 -1删除  0无效 1有效',
  `is_show` tinyint(4) NOT NULL DEFAULT 1 COMMENT '是否显示 0不显示 1显示',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`) USING BTREE,
  INDEX `idx_parent_ids`(`parent_ids`) USING BTREE,
  INDEX `idx_query`(`name`, `parent_id`, `weight`, `status`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 835 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统资源表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_resource
-- ----------------------------
INSERT INTO `sys_resource` VALUES (1, '资源', '', '', 'top', '', 0, '0/', 'ztree_setting', 0, 1, 1);
INSERT INTO `sys_resource` VALUES (2, '系统管理', 'sys', 'sys', 'top', '', 1, '0/1/', 'portal-systems-setting', 108, 1, 1);
INSERT INTO `sys_resource` VALUES (366, '数据管理', 'datamgt', 'datamgt', 'top', '', 1, '0/1/', 'portal-data-management', 104, 1, 1);
INSERT INTO `sys_resource` VALUES (367, '数据连接', 'datamgt', 'database', 'left', '/dataConnection', 366, '0/1/366/', 'icon-icon-test', 10, 1, 1);
INSERT INTO `sys_resource` VALUES (368, '文件管理', 'datamgt', 'file', 'left', '/fileManagement', 366, '0/1/366/', 'icon-structured-data', 11, 1, 1);
INSERT INTO `sys_resource` VALUES (369, '主题管理', 'datamgt', 'xs-theme', 'left', '/themeManagement', 366, '0/1/366/', 'icon-layer-group', 12, 1, 1);
INSERT INTO `sys_resource` VALUES (382, '用户管理', 'sys', 'usermgt', 'left', '/userManage', 2, '0/1/2/', 'icon-layer-group', -7, 1, 1);
INSERT INTO `sys_resource` VALUES (383, '用户列表管理', 'sys', 'userList', 'left', '/userList', 382, '0/1/2/382/', 'portal-user-list', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (384, '工作职务管理', 'sys', 'job', 'left', '/dutyList', 382, '0/1/2/382/', 'portal-job', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (386, '系统监控', 'sys', 'monitor', 'left', '/monitor', 2, '0/1/2/', 'icon-chart-line', -16, 1, 1);
INSERT INTO `sys_resource` VALUES (387, '在线用户列表', 'sys', 'onlineuser', 'left', '/onlineuser', 386, '0/1/2/386/', 'portal-online-user', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (388, '历史会话列表', 'sys', 'loginHistory', 'left', '/loginHistory', 386, '0/1/2/386/', 'portal-login-history', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (389, '服务器状态', 'sys', 'serviceStatus', 'left', '/serviceStatus', 386, '0/1/2/386/', 'ztree_file', 7, 0, 0);
INSERT INTO `sys_resource` VALUES (390, '审计日志', 'sys', 'auitlog', 'left', '/auitlog', 386, '0/1/2/386/', 'ztree_file', 8, 0, 0);
INSERT INTO `sys_resource` VALUES (422, '权限管理', 'sys', 'auth', 'left', '/permissionManage', 2, '0/1/2/', 'icon-shenpi-copy', -6, 1, 1);
INSERT INTO `sys_resource` VALUES (423, '角色权限管理', 'sys', 'role', 'left', '/roleList', 422, '0/1/2/422/', 'portal-role', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (424, '用户授权管理', 'sys', 'userAuth', 'left', '/userAuthorization', 422, '0/1/2/422/', 'portal-user-auth', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (425, '资源列表', 'sys', 'resource', 'left', '/sourceList', 422, '0/1/2/422/', 'portal-resource', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (426, '权限管理', 'sys', 'permission', 'left', '/permissionList', 422, '0/1/2/422/', 'portal-permission', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (434, '系统配置', 'sys', 'sysConfig', 'left', '/sysConfigList', 422, '0/1/2/422/', 'portal-sys-config', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (482, '数据库监控', 'sys', 'database', 'left', '/databaseMonitor', 386, '0/1/2/386/', 'ztree_file', 10, -1, 0);
INSERT INTO `sys_resource` VALUES (483, 'redis监控', 'sys', 'encache', 'left', '/redisMonitor', 386, '0/1/2/386/', 'portal-encache', 11, 1, 1);
INSERT INTO `sys_resource` VALUES (484, 'jvm监控', 'sys', 'jvm', 'left', '/jvmMonitor', 386, '0/1/2/386/', 'portal-jvm', 12, 1, 1);
INSERT INTO `sys_resource` VALUES (485, '菜单管理', 'sys', 'menuConfig', 'left', '/menuManage', 422, '0/1/2/422/', 'portal-menu-config', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (722, '模型训练', 'algorithm', 'algorithm', 'top', '#', 1, '0/1/', 'portal-model-training', 107, 1, 1);
INSERT INTO `sys_resource` VALUES (723, '深度学习建模', 'algorithm', 'autoModel', 'left', '/auto-modeling/list', 722, '0/1/722/', 'icon-auto', 18, 1, 1);
INSERT INTO `sys_resource` VALUES (725, '模型管理', 'algorithm', 'model', 'left', '', 722, '0/1/722/', 'icon-model', 27, 1, 1);
INSERT INTO `sys_resource` VALUES (726, '深度学习模型', 'algorithm', 'models-my', 'left', '/models/my', 725, '0/1/722/725/', 'portal-models-my', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (727, '公共模型库', 'algorithm', 'libs', 'left', '', 767, '0/1/722/767/', 'icon-model', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (728, '配置管理', 'algorithm', 'settings', 'left', NULL, 722, '0/1/722/', 'portal-setting-management', 28, 1, 1);
INSERT INTO `sys_resource` VALUES (729, '资源规格管理', 'algorithm', 'resource-spec', 'left', '/setting/resource-spec', 728, '0/1/722/728/', 'icon-resource-spec', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (730, '镜像管理', 'algorithm', 'images', 'left', '/setting/images', 728, '0/1/722/728/', 'icon-mirror-images', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (731, '资源监控', 'algorithm', 'resource-monitor', 'left', '/setting/resource-monitor', 728, '0/1/722/728/', 'icon-rsc-monitor', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (735, '算法开发', 'algorithm', 'algo', 'top', NULL, 722, '0/1/722/', 'portal-algorithm', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (737, '我的算子', 'algorithm', 'operator', 'left', '', 735, '0/1/722/735/', 'icon-operator', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (738, '公共算子库', 'algorithm', 'algo-libs', 'left', '', 767, '0/1/722/767/', 'icon-algo-libs', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (740, '在线评估', 'algorithm', 'assessment-task', 'left', '/assessment-task', 800, '0/1/722/800/', 'icon-assess', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (741, '首页', 'algorithm', 'algorithm', 'left', 'preview', 722, '0/1/722/', 'icon-home', 11, 1, 1);
INSERT INTO `sys_resource` VALUES (745, '在线服务', 'algorithm', 'online-service', 'left', '/service/online-service', 800, '0/1/722/800/', 'icon-server', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (747, '机器学习建模', 'algorithm', 'workflow', 'left', '/drag-modeling/workflow', 722, '0/1/722/', 'icon-drag', 26, 1, 1);
INSERT INTO `sys_resource` VALUES (749, 'NoteBook', 'algorithm', 'my-project', 'left', '/algorithm/notebook/my-project', 735, '0/1/722/735/', 'portal-notebook', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (750, '公开NoteBook', 'algorithm', 'public-notebook', 'left', '/algorithm/notebook/public-project', 767, '0/1/722/767/', 'icon-auto', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (751, '流程建模', 'algorithm', 'process-modeling', 'left', '/process-modeling/list', 722, '0/1/722/', 'icon-process-modeling', 29, 1, 1);
INSERT INTO `sys_resource` VALUES (754, '调度管理', 'algorithm', 'dispatch', 'left', '/dispatches', 722, '0/1/722/', 'icon-dispatch', 30, 1, 1);
INSERT INTO `sys_resource` VALUES (755, '告警管理', 'algorithm', 'alters-manage', 'left', NULL, 728, '0/1/722/728/', 'portal-alarm-management', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (756, '告警规则', 'algorithm', 'alters-rule', 'left', '/setting/alters-manager', 755, '0/1/722/728/755/', 'icon-alters-manager', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (757, '告警列表', 'algorithm', 'alters-msg', 'left', '/setting/alters-manager/warning-list', 755, '0/1/722/728/755/', 'icon-warning-list', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (760, '运维中心', 'algorithm', 'cluster-om', 'left', NULL, 722, '0/1/722/', 'portal-cluster-om', 32, 1, 1);
INSERT INTO `sys_resource` VALUES (761, '资源监控', 'algorithm', 'area-resource', 'left', '/setting/ops-monitor/rsc-monitor-area', 817, '0/1/722/760/817/', 'icon-rsc-monitor', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (762, '组件监控', 'algorithm', 'area-component', 'left', '/setting/ops-monitor/cpn-monitor-area', 817, '0/1/722/760/817/', 'icon-cpn-monitor', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (763, '日志监控', 'algorithm', 'area-log', 'left', '/setting/ops-monitor/log-monitor-area', 817, '0/1/722/760/817/', 'icon-log-monitor', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (764, '模型转换', 'algorithm', 'model-transformation', 'left', '/models/transformation', 722, '0/1/722/', 'icon-model-transform', 33, 1, 1);
INSERT INTO `sys_resource` VALUES (767, '共享库', 'algorithm', '#', 'left', '', 722, '0/1/722/', 'portal-shared-library', 34, 1, 1);
INSERT INTO `sys_resource` VALUES (769, '数据标注', 'label', 'label', 'top', NULL, 1, '0/1/', 'portal-data-annotation', 105, 1, 1);
INSERT INTO `sys_resource` VALUES (770, '标签管理', 'label', 'tagManage', 'left', '/common/tagManage', 769, '0/1/769/', 'icon-Directory-tree', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (771, '数据总览', 'label', 'overview', 'left', '/overview', 769, '0/1/769/', 'icon-monitoring', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (772, '标注数据集', 'label', 'dataset', 'left', NULL, 769, '0/1/769/', 'icon-layer-group', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (773, '图片数据集', 'label', 'picDataset', 'left', '/dataSet/image', 772, '0/1/769/772/', 'portal-pic-dataset', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (774, '文本数据集', 'label', 'textDataset', 'left', '/dataSet/text', 772, '0/1/769/772/', 'portal-text-dataset', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (775, 'OCR数据集', 'label', 'ocrDataset', 'left', '/dataSet/ocr', 772, '0/1/769/772/', 'portal-ocr-dataset', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (776, '协同标注', 'label', 'collaborative', 'left', NULL, 769, '0/1/769/', 'icon-shujuhuijiao', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (777, '任务管理', 'label', 'taskManage', 'left', '/collaborative/taskManagement', 776, '0/1/769/776/', 'ztree_file', 1, 1, 0);
INSERT INTO `sys_resource` VALUES (778, '团队管理', 'label', 'teamManage', 'left', '/collaborative/teamManagement', 776, '0/1/769/776/', 'portal-team-manage', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (779, '智能标注', 'label', 'intelligenceMark', 'left', '/intelligenceMark', 769, '0/1/769/', 'icon-display-code', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (782, '机器学习算子库', 'algorithm', 'algo-libs-wf', 'left', '/algorithm/libs/workflow', 738, '0/1/722/767/738/', 'portal-algo-libs-wf', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (783, '深度学习算子库', 'algorithm', 'algo-libs-am', 'left', '/algorithm/libs/auto-modeling', 738, '0/1/722/767/738/', 'portal-algo-libs-am', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (784, '机器学习算子', 'algorithm', 'wf-operator', 'left', '/algorithm/operator', 737, '0/1/722/735/737/', 'portal-wf-operator', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (785, '深度学习算子', 'algorithm', 'am-operator', 'left', '/algorithm/am-operator', 737, '0/1/722/735/737/', 'portal-am-operator', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (786, '机器学习模型', 'algorithm', 'workflow-models', 'left', '/models/workflow', 725, '0/1/722/725/', 'portal-workflow-models', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (787, '应用封装', 'algorithm', 'encapsulation', 'left', '', 800, '0/1/722/800/', 'icon-model-app', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (788, '深度学习应用', 'algorithm', 'am-encapsulation', 'left', '/service/encapsulation/:type', 787, '0/1/722/800/787/', 'portal-am-encapsulation', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (789, '机器学习应用', 'algorithm', 'wf-encapsulation', 'left', '/service/workflow-encapsulation/:type', 787, '0/1/722/800/787/', 'portal-wf-encapsulation', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (790, '深度学习模型库', 'algorithm', 'libs-at', 'left', '/models/libs/at', 727, '0/1/722/767/727/', 'portal-libs-at', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (791, '机器学习模型库', 'algorithm', 'libs-wf', 'left', '/models/libs/wf', 727, '0/1/722/767/727/', 'portal-libs-wf', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (792, '帮助', 'help', 'help', 'top', NULL, 1, '0/1/', 'portal-help', 111, 1, 1);
INSERT INTO `sys_resource` VALUES (793, '关于数联-行智AI', 'help', 'introduction', 'left', '/introduction', 792, '0/1/792/', 'icon-introduction', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (795, '使用手册', 'help', 'userManual', 'left', '/userManual', 792, '0/1/792/', 'icon-user-manual', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (796, '常见问题', 'help', 'problems', 'left', '/problems', 792, '0/1/792/', 'icon-problems', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (797, '联系支持', 'help', 'contactSupport', 'left', '/contactSupport', 792, '0/1/792/', 'iocn-contact-support', 6, 1, 1);
INSERT INTO `sys_resource` VALUES (798, '更新日志', 'help', 'visionLog', 'left', '/visionLog', 792, '0/1/792/', 'icon-vision-log', 7, 1, 1);
INSERT INTO `sys_resource` VALUES (799, '反馈收集', 'help', 'feedback', 'left', '/feedback', 792, '0/1/792/', 'icon-feedback', 8, 1, 1);
INSERT INTO `sys_resource` VALUES (800, '模型应用', 'algorithm', '#', 'left', NULL, 722, '0/1/722/', 'portal-model-application', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (802, '申请列表', 'algorithm', 'apply', 'left', '/message-center/apply-list', 722, '0/1/722/', 'portal-apply', 35, 1, 1);
INSERT INTO `sys_resource` VALUES (803, '审核列表', 'algorithm', 'audit', 'left', '/message-center/audit-list-center', 722, '0/1/722/', 'portal-audit', 36, 1, 1);
INSERT INTO `sys_resource` VALUES (804, '我创建的', 'label', 'buildTaskManage', 'left', '/collaborative/buildTaskManagement', 776, '0/1/769/776/', 'portal-build-task', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (805, '标注任务', 'label', 'labelTaskManage', 'left', '/collaborative/labelTaskManagement', 776, '0/1/769/776/', 'portal-label-task', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (806, '质检任务', 'label', 'qualityTaskManage', 'left', '/collaborative/qualityTaskManagement', 776, '0/1/769/776/', 'portal-quality-task', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (807, '公共数据集', 'algorithm', 'public-dataset', 'left', '/common/dataset', 767, '0/1/722/767/', 'icon-layer-group', 7, 1, 1);
INSERT INTO `sys_resource` VALUES (808, '集群运维中心', 'algorithm', 'cluster-om', 'top', NULL, 1, '0/1/', 'portal-cluster-center', 110, 1, 1);
INSERT INTO `sys_resource` VALUES (809, '概览', 'algorithm', 'overview', 'left', '/setting/cluster/overview', 808, '0/1/808/', 'icon-cluster', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (810, '集群管理', 'algorithm', 'cluster-manager', 'left', '/setting/cluster-manager', 808, '0/1/808/', 'icon-cluster', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (811, '运维监控', 'algorithm', 'ops-monitor', 'left', NULL, 808, '0/1/808/', 'icon-resource-spec', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (812, '资源监控', 'algorithm', 'rsc-monitor-center', 'left', '/setting/ops-monitor/rsc-monitor-center', 811, '0/1/808/811/', 'ztree_file', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (813, '组件监控', 'algorithm', 'cpn-monitor-center', 'left', '/setting/ops-monitor/cpn-monitor-center', 811, '0/1/808/811/', 'ztree_file', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (814, '日志监控', 'algorithm', 'log-monitor-center', 'left', '/setting/ops-monitor/log-monitor-center', 811, '0/1/808/811/', 'ztree_file', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (815, 'GPU管理', 'algorithm', 'gpu-management', 'left', '/setting/gpu-management/list', 808, '0/1/808/', 'portal-gpu-management', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (816, '概览', 'algorithm', 'area-overview', 'left', '/setting/cluster/area-overview', 760, '0/1/722/760/', 'icon-cluster', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (817, '运维监控', 'algorithm', 'view-control', 'left', NULL, 760, '0/1/722/760/', 'icon-rsc-monitor', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (819, '公共镜像库', 'algorithm', 'public-container-image', 'left', '/common/container-image', 767, '0/1/722/767/', 'icon-mirror-images', 8, 1, 1);
INSERT INTO `sys_resource` VALUES (822, '实例管理', 'algorithm', 'product-instance', 'left', '/setting/product-instance', 808, '0/1/808/', 'portal-instance', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (823, '共享中心云', 'algorithm', '#', 'top', NULL, 1, '0/1/', 'portal-sharing-center-cloud', 109, 1, 1);
INSERT INTO `sys_resource` VALUES (824, '公开NoteBook', 'algorithm', 'public-notebook', 'left', '/algorithm/notebook/public-project', 823, '0/1/823/', 'icon-auto', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (825, '公共算子库', 'algorithm', 'algo-libs', 'left', NULL, 823, '0/1/823/', 'icon-algo-libs', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (826, '公共模型库', 'algorithm', 'libs', 'left', NULL, 823, '0/1/823/', 'icon-model', 3, 1, 1);
INSERT INTO `sys_resource` VALUES (827, '公共数据集', 'algorithm', 'public-dataset', 'left', '/common/dataset', 823, '0/1/823/', 'icon-layer-group', 4, 1, 1);
INSERT INTO `sys_resource` VALUES (828, '公共镜像库', 'algorithm', 'public-container-image', 'left', '/common/container-image', 823, '0/1/823/', 'icon-mirror-images', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (829, '深度学习算子库', 'algorithm', 'algo-libs-am', 'left', '/algorithm/libs/auto-modeling', 825, '0/1/823/825/', 'portal-algo-libs-am', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (830, '机器学习算子库', 'algorithm', 'algo-libs-wf', 'left', '/algorithm/libs/workflow', 825, '0/1/823/825/', 'portal-algo-libs-wf', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (831, '深度学习模型库', 'algorithm', 'libs-at', 'left', '/models/libs/at', 826, '0/1/823/826/', 'portal-libs-at', 1, 1, 1);
INSERT INTO `sys_resource` VALUES (832, '机器学习模型库', 'algorithm', 'libs-wf', 'left', '/models/libs/wf', 826, '0/1/823/826/', 'portal-libs-wf', 2, 1, 1);
INSERT INTO `sys_resource` VALUES (833, '系统日志', 'algorithm', 'system-logs', 'left', '/setting/system-logs', 760, '0/1/722/760/', 'ztree_file', 5, 1, 1);
INSERT INTO `sys_resource` VALUES (834, '算子资源监控 ', 'algorithm', 'operator-monitor ', 'left', '/setting/operator-monitor', 760, '0/1/722/760/', 'icon-home', 5, 1, 1);

-- ----------------------------
-- Table structure for sys_resource_config
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_config`;
CREATE TABLE `sys_resource_config`  (
  `id` bigint(64) UNSIGNED NOT NULL DEFAULT 0 COMMENT 'ID',
  `pos` varchar(10) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '菜单位置: top|left',
  `parent_id` bigint(64) UNSIGNED NOT NULL COMMENT '父亲节点',
  `parent_ids` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '父辈节点组成的字符串',
  `icon` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '图标class',
  `weight` int(11) NOT NULL COMMENT '排序种子 ，值越大越靠后'
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统资源表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_resource_config
-- ----------------------------
INSERT INTO `sys_resource_config` VALUES (1, 'top', 0, '0/', 'ztree_setting', 0);
INSERT INTO `sys_resource_config` VALUES (713, 'left', 712, '0/1/712', 'icon-layer-group', 7);
INSERT INTO `sys_resource_config` VALUES (715, 'left', 712, '0/1/712', 'icon-Directory-tree', 4);
INSERT INTO `sys_resource_config` VALUES (716, 'left', 712, '0/1/712', 'icon-shujuhuijiao', 9);
INSERT INTO `sys_resource_config` VALUES (720, 'left', 712, '0/1/712', 'icon-monitoring', 3);
INSERT INTO `sys_resource_config` VALUES (752, 'left', 713, '0/1/712713/', 'ztree_file', 2);
INSERT INTO `sys_resource_config` VALUES (792, 'top', 1, '0/1/', 'portal-help', 149);
INSERT INTO `sys_resource_config` VALUES (793, 'left', 792, '0/1/792/', 'icon-introduction', 3);
INSERT INTO `sys_resource_config` VALUES (795, 'left', 792, '0/1/792/', 'icon-user-manual', 4);
INSERT INTO `sys_resource_config` VALUES (796, 'left', 792, '0/1/792/', 'icon-problems', 5);
INSERT INTO `sys_resource_config` VALUES (797, 'left', 792, '0/1/792/', 'iocn-contact-support', 6);
INSERT INTO `sys_resource_config` VALUES (798, 'left', 792, '0/1/792/', 'icon-vision-log', 7);
INSERT INTO `sys_resource_config` VALUES (799, 'left', 792, '0/1/792/', 'icon-feedback', 8);
INSERT INTO `sys_resource_config` VALUES (2, 'top', 1, '0/1/', 'portal-systems-setting', 150);
INSERT INTO `sys_resource_config` VALUES (382, 'left', 2, '0/1/2/', 'icon-layer-group', -7);
INSERT INTO `sys_resource_config` VALUES (383, 'left', 382, '0/1/2/382/', 'portal-user-list', 4);
INSERT INTO `sys_resource_config` VALUES (384, 'left', 382, '0/1/2/382/', 'portal-job', 5);
INSERT INTO `sys_resource_config` VALUES (422, 'left', 2, '0/1/2/', 'icon-shenpi-copy', -6);
INSERT INTO `sys_resource_config` VALUES (423, 'left', 422, '0/1/2/422/', 'portal-role', 1);
INSERT INTO `sys_resource_config` VALUES (424, 'left', 422, '0/1/2/422/', 'portal-user-auth', 2);
INSERT INTO `sys_resource_config` VALUES (425, 'left', 422, '0/1/2/422/', 'portal-resource', 3);
INSERT INTO `sys_resource_config` VALUES (426, 'left', 422, '0/1/2/422/', 'portal-permission', 4);
INSERT INTO `sys_resource_config` VALUES (434, 'left', 422, '0/1/2/422/', 'portal-sys-config', 5);
INSERT INTO `sys_resource_config` VALUES (485, 'left', 422, '0/1/2/422/', 'portal-menu-config', 6);
INSERT INTO `sys_resource_config` VALUES (823, 'top', 1, '0/1/', 'portal-sharing-center-cloud', 109);
INSERT INTO `sys_resource_config` VALUES (824, 'left', 823, '0/1/823/', 'icon-auto', 1);
INSERT INTO `sys_resource_config` VALUES (825, 'left', 823, '0/1/823/', 'icon-algo-libs', 2);
INSERT INTO `sys_resource_config` VALUES (829, 'left', 825, '0/1/823/825/', 'portal-algo-libs-am', 1);
INSERT INTO `sys_resource_config` VALUES (830, 'left', 825, '0/1/823/825/', 'portal-algo-libs-wf', 2);
INSERT INTO `sys_resource_config` VALUES (826, 'left', 823, '0/1/823/', 'icon-model', 3);
INSERT INTO `sys_resource_config` VALUES (831, 'left', 826, '0/1/823/826/', 'portal-libs-at', 1);
INSERT INTO `sys_resource_config` VALUES (832, 'left', 826, '0/1/823/826/', 'portal-libs-wf', 2);
INSERT INTO `sys_resource_config` VALUES (827, 'left', 823, '0/1/823/', 'icon-layer-group', 4);
INSERT INTO `sys_resource_config` VALUES (828, 'left', 823, '0/1/823/', 'icon-mirror-images', 5);
INSERT INTO `sys_resource_config` VALUES (808, 'top', 1, '0/1/', 'portal-cluster-center', 110);
INSERT INTO `sys_resource_config` VALUES (809, 'left', 808, '0/1/808/', 'icon-cluster', 1);
INSERT INTO `sys_resource_config` VALUES (810, 'left', 808, '0/1/808/', 'icon-cluster', 2);
INSERT INTO `sys_resource_config` VALUES (811, 'left', 808, '0/1/808/', 'icon-resource-spec', 3);
INSERT INTO `sys_resource_config` VALUES (812, 'left', 811, '0/1/808/811/', 'ztree_file', 1);
INSERT INTO `sys_resource_config` VALUES (813, 'left', 811, '0/1/808/811/', 'ztree_file', 2);
INSERT INTO `sys_resource_config` VALUES (814, 'left', 811, '0/1/808/811/', 'ztree_file', 3);
INSERT INTO `sys_resource_config` VALUES (802, 'left', 823, '0/1/823/', 'portal-apply', 8);
INSERT INTO `sys_resource_config` VALUES (803, 'left', 823, '0/1/823/', 'portal-audit', 9);



-- ----------------------------
-- Table structure for sys_resource_to_data_permission_group
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_to_data_permission_group`;
CREATE TABLE `sys_resource_to_data_permission_group`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `resource_id` bigint(64) NOT NULL COMMENT '叶子菜单id',
  `permission_group_id` bigint(64) NOT NULL COMMENT '权限组id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '叶子菜单必需设置的数据权限组表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_resource_to_data_permission_group
-- ----------------------------


-- ----------------------------
-- Table structure for sys_resource_to_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_resource_to_permission`;
CREATE TABLE `sys_resource_to_permission`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `resource_id` bigint(64) NOT NULL COMMENT '资源id',
  `permission_id` bigint(64) NOT NULL COMMENT '权限标识',
  `show_name` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '显示的权限名称',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unq_resourceId_permissionId`(`resource_id`, `permission_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1821 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '资源权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_resource_to_permission
-- ----------------------------
INSERT INTO `sys_resource_to_permission` VALUES (80, 700, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (81, 700, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (82, 700, 23, '终止');
INSERT INTO `sys_resource_to_permission` VALUES (139, 482, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (140, 482, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (150, 696, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (151, 696, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (152, 696, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (153, 696, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (154, 696, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (155, 697, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (156, 697, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (157, 697, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (158, 697, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (159, 697, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (160, 698, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (161, 698, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (162, 698, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (163, 698, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (164, 698, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (180, 699, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (181, 699, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (182, 699, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (183, 699, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (184, 699, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (185, 699, 10, '执行一次');
INSERT INTO `sys_resource_to_permission` VALUES (186, 699, 22, '编辑任务规则');
INSERT INTO `sys_resource_to_permission` VALUES (187, 699, 23, '关闭任务');
INSERT INTO `sys_resource_to_permission` VALUES (188, 699, 24, '开启任务');
INSERT INTO `sys_resource_to_permission` VALUES (371, 361, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (372, 361, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (373, 361, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (374, 361, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (375, 361, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (376, 361, 38, '移动');
INSERT INTO `sys_resource_to_permission` VALUES (377, 361, 39, '复制 ');
INSERT INTO `sys_resource_to_permission` VALUES (378, 361, 33, '重命名');
INSERT INTO `sys_resource_to_permission` VALUES (379, 364, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (380, 364, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (381, 365, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (382, 365, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (390, 363, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (391, 363, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (392, 363, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (393, 363, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (394, 363, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (395, 363, 10, '执行');
INSERT INTO `sys_resource_to_permission` VALUES (396, 363, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (407, 701, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (408, 701, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (409, 701, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (410, 701, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (411, 701, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (439, 504, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (440, 504, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (450, 505, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (451, 505, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (452, 505, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (453, 505, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (454, 505, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (455, 505, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (460, 706, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (464, 702, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (465, 702, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (469, 703, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (470, 703, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (471, 703, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (472, 703, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (473, 703, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (474, 703, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (475, 703, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (476, 703, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (477, 703, 39, '复制 ');
INSERT INTO `sys_resource_to_permission` VALUES (478, 704, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (479, 704, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (480, 704, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (481, 704, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (482, 704, 10, '运行/启动/停止');
INSERT INTO `sys_resource_to_permission` VALUES (483, 705, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (484, 705, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (487, 506, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (488, 506, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (489, 506, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (490, 506, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (491, 506, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (495, 507, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (496, 507, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (497, 507, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (498, 507, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (499, 507, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (500, 507, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (501, 507, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (502, 508, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (503, 508, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (504, 508, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (505, 508, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (506, 509, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (507, 509, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (508, 509, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (509, 509, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (510, 509, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (511, 509, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (512, 510, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (513, 511, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (514, 511, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (515, 511, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (516, 511, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (517, 511, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (523, 514, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (524, 514, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (525, 514, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (526, 514, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (527, 514, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (528, 514, 40, '配置人员');
INSERT INTO `sys_resource_to_permission` VALUES (530, 512, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (531, 512, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (532, 512, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (533, 512, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (534, 512, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (535, 513, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (536, 513, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (537, 513, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (538, 513, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (539, 513, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (560, 707, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (561, 707, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (562, 707, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (563, 707, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (564, 707, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (565, 708, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (566, 708, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (567, 708, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (568, 708, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (569, 708, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (570, 709, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (571, 709, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (572, 709, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (573, 709, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (574, 709, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (579, 469, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (580, 469, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (581, 469, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (582, 469, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (583, 469, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (584, 468, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (586, 471, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (587, 473, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (588, 475, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (589, 474, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (590, 472, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (591, 470, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (592, 470, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (593, 470, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (594, 470, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (595, 470, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (596, 470, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (597, 470, 6, '审核');
INSERT INTO `sys_resource_to_permission` VALUES (598, 470, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (599, 470, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (600, 470, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (601, 470, 25, '提交');
INSERT INTO `sys_resource_to_permission` VALUES (623, 673, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (642, 710, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (689, 491, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (690, 491, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (698, 494, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (699, 494, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (700, 494, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (701, 494, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (702, 494, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (703, 494, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (704, 494, 33, '重命名');
INSERT INTO `sys_resource_to_permission` VALUES (705, 494, 34, '历史记录');
INSERT INTO `sys_resource_to_permission` VALUES (706, 494, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (707, 496, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (708, 496, 6, '审核');
INSERT INTO `sys_resource_to_permission` VALUES (709, 496, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (710, 496, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (711, 497, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (712, 497, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (713, 711, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (732, 675, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (733, 674, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (734, 678, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (735, 678, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (736, 692, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (737, 692, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (738, 693, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (739, 693, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (740, 693, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (741, 693, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (742, 693, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (743, 693, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (744, 693, 19, '导入');
INSERT INTO `sys_resource_to_permission` VALUES (745, 693, 25, '提交');
INSERT INTO `sys_resource_to_permission` VALUES (746, 693, 26, '校验规则配置');
INSERT INTO `sys_resource_to_permission` VALUES (747, 693, 27, '执行同步');
INSERT INTO `sys_resource_to_permission` VALUES (748, 693, 28, '同步配置');
INSERT INTO `sys_resource_to_permission` VALUES (749, 694, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (750, 694, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (751, 694, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (752, 694, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (753, 695, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (754, 695, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (755, 695, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (756, 669, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (757, 669, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (758, 669, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (759, 669, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (760, 669, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (761, 670, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (762, 670, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (763, 670, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (764, 670, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (765, 670, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (766, 671, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (767, 671, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (768, 671, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (769, 671, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (770, 671, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (771, 672, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (772, 672, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (773, 672, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (774, 672, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (775, 672, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (777, 668, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (778, 369, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (779, 493, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (780, 493, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (781, 499, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (782, 499, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (783, 499, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (840, 368, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (859, 731, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (860, 730, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (862, 729, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (999, 751, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1182, 740, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1183, 740, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1184, 740, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1185, 740, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1186, 740, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1187, 740, 6, '审核');
INSERT INTO `sys_resource_to_permission` VALUES (1188, 740, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (1189, 740, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (1190, 740, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (1191, 740, 10, '运行/启动/停止');
INSERT INTO `sys_resource_to_permission` VALUES (1192, 740, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (1193, 740, 12, '申请');
INSERT INTO `sys_resource_to_permission` VALUES (1194, 740, 13, '新建组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1195, 740, 14, '编辑组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1196, 740, 15, '删除组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1197, 740, 16, '强制退出');
INSERT INTO `sys_resource_to_permission` VALUES (1198, 740, 17, '重置密码');
INSERT INTO `sys_resource_to_permission` VALUES (1199, 740, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (1200, 740, 19, '导入');
INSERT INTO `sys_resource_to_permission` VALUES (1201, 740, 21, '审核处理');
INSERT INTO `sys_resource_to_permission` VALUES (1202, 740, 22, '编辑任务规则');
INSERT INTO `sys_resource_to_permission` VALUES (1203, 740, 23, '终止');
INSERT INTO `sys_resource_to_permission` VALUES (1204, 740, 24, '开启');
INSERT INTO `sys_resource_to_permission` VALUES (1205, 740, 25, '提交');
INSERT INTO `sys_resource_to_permission` VALUES (1206, 740, 26, '校验规则配置');
INSERT INTO `sys_resource_to_permission` VALUES (1207, 740, 27, '执行同步');
INSERT INTO `sys_resource_to_permission` VALUES (1208, 740, 28, '同步配置');
INSERT INTO `sys_resource_to_permission` VALUES (1209, 740, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (1210, 740, 30, '数据预览');
INSERT INTO `sys_resource_to_permission` VALUES (1211, 740, 31, '模型预览');
INSERT INTO `sys_resource_to_permission` VALUES (1212, 740, 33, '重命名');
INSERT INTO `sys_resource_to_permission` VALUES (1213, 740, 34, '历史记录');
INSERT INTO `sys_resource_to_permission` VALUES (1214, 740, 36, '访问');
INSERT INTO `sys_resource_to_permission` VALUES (1215, 740, 37, '字段信息');
INSERT INTO `sys_resource_to_permission` VALUES (1216, 740, 38, '移动');
INSERT INTO `sys_resource_to_permission` VALUES (1217, 740, 39, '复制 ');
INSERT INTO `sys_resource_to_permission` VALUES (1218, 740, 40, '配置人员');
INSERT INTO `sys_resource_to_permission` VALUES (1219, 740, 42, '下线');
INSERT INTO `sys_resource_to_permission` VALUES (1220, 740, 43, '设置列表显示项');
INSERT INTO `sys_resource_to_permission` VALUES (1221, 740, 44, '设置引用');
INSERT INTO `sys_resource_to_permission` VALUES (1222, 740, 45, '连接导入');
INSERT INTO `sys_resource_to_permission` VALUES (1223, 740, 46, '数据表更新');
INSERT INTO `sys_resource_to_permission` VALUES (1224, 740, 48, '导入组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1225, 740, 49, '导出组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1226, 740, 50, '验证');
INSERT INTO `sys_resource_to_permission` VALUES (1227, 745, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1228, 745, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1229, 745, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1230, 745, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1231, 745, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1232, 745, 6, '审核');
INSERT INTO `sys_resource_to_permission` VALUES (1233, 745, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (1234, 745, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (1235, 745, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (1236, 745, 10, '运行/启动/停止');
INSERT INTO `sys_resource_to_permission` VALUES (1237, 745, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (1238, 745, 12, '申请');
INSERT INTO `sys_resource_to_permission` VALUES (1239, 745, 13, '新建组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1240, 745, 14, '编辑组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1241, 745, 15, '删除组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1242, 745, 16, '强制退出');
INSERT INTO `sys_resource_to_permission` VALUES (1243, 745, 17, '重置密码');
INSERT INTO `sys_resource_to_permission` VALUES (1244, 745, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (1245, 745, 19, '导入');
INSERT INTO `sys_resource_to_permission` VALUES (1246, 745, 21, '审核处理');
INSERT INTO `sys_resource_to_permission` VALUES (1247, 745, 22, '编辑任务规则');
INSERT INTO `sys_resource_to_permission` VALUES (1248, 745, 23, '终止');
INSERT INTO `sys_resource_to_permission` VALUES (1249, 745, 24, '开启');
INSERT INTO `sys_resource_to_permission` VALUES (1250, 745, 25, '提交');
INSERT INTO `sys_resource_to_permission` VALUES (1251, 745, 26, '校验规则配置');
INSERT INTO `sys_resource_to_permission` VALUES (1252, 745, 27, '执行同步');
INSERT INTO `sys_resource_to_permission` VALUES (1253, 745, 28, '同步配置');
INSERT INTO `sys_resource_to_permission` VALUES (1254, 745, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (1255, 745, 30, '数据预览');
INSERT INTO `sys_resource_to_permission` VALUES (1256, 745, 31, '模型预览');
INSERT INTO `sys_resource_to_permission` VALUES (1257, 745, 33, '重命名');
INSERT INTO `sys_resource_to_permission` VALUES (1258, 745, 34, '历史记录');
INSERT INTO `sys_resource_to_permission` VALUES (1259, 745, 36, '访问');
INSERT INTO `sys_resource_to_permission` VALUES (1260, 745, 37, '字段信息');
INSERT INTO `sys_resource_to_permission` VALUES (1261, 745, 38, '移动');
INSERT INTO `sys_resource_to_permission` VALUES (1262, 745, 39, '复制 ');
INSERT INTO `sys_resource_to_permission` VALUES (1263, 745, 40, '配置人员');
INSERT INTO `sys_resource_to_permission` VALUES (1264, 745, 42, '下线');
INSERT INTO `sys_resource_to_permission` VALUES (1265, 745, 43, '设置列表显示项');
INSERT INTO `sys_resource_to_permission` VALUES (1266, 745, 44, '设置引用');
INSERT INTO `sys_resource_to_permission` VALUES (1267, 745, 45, '连接导入');
INSERT INTO `sys_resource_to_permission` VALUES (1268, 745, 46, '数据表更新');
INSERT INTO `sys_resource_to_permission` VALUES (1269, 745, 48, '导入组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1270, 745, 49, '导出组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1271, 745, 50, '验证');
INSERT INTO `sys_resource_to_permission` VALUES (1280, 770, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1281, 770, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1282, 770, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1283, 770, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1284, 770, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1365, 771, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1366, 771, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1367, 771, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1368, 771, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1369, 771, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1390, 779, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1391, 779, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1392, 779, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1393, 779, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1394, 779, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1437, 738, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1446, 741, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1473, 793, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1483, 795, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1484, 796, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1485, 797, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1486, 798, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1488, 389, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1489, 390, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1492, 764, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1493, 761, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1494, 762, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1495, 763, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1496, 754, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1497, 756, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1498, 757, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1504, 737, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1628, 723, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1629, 723, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1630, 723, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1631, 723, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1632, 723, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1633, 723, 6, '审核');
INSERT INTO `sys_resource_to_permission` VALUES (1634, 723, 7, '上传');
INSERT INTO `sys_resource_to_permission` VALUES (1635, 723, 8, '下载');
INSERT INTO `sys_resource_to_permission` VALUES (1636, 723, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (1637, 723, 10, '运行/启动/停止');
INSERT INTO `sys_resource_to_permission` VALUES (1638, 723, 11, '导出');
INSERT INTO `sys_resource_to_permission` VALUES (1639, 723, 12, '申请');
INSERT INTO `sys_resource_to_permission` VALUES (1640, 723, 13, '新建组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1641, 723, 14, '编辑组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1642, 723, 15, '删除组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1643, 723, 16, '强制退出');
INSERT INTO `sys_resource_to_permission` VALUES (1644, 723, 17, '重置密码');
INSERT INTO `sys_resource_to_permission` VALUES (1645, 723, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (1646, 723, 19, '导入');
INSERT INTO `sys_resource_to_permission` VALUES (1647, 723, 21, '审核处理');
INSERT INTO `sys_resource_to_permission` VALUES (1648, 723, 22, '编辑任务规则');
INSERT INTO `sys_resource_to_permission` VALUES (1649, 723, 23, '终止');
INSERT INTO `sys_resource_to_permission` VALUES (1650, 723, 24, '开启');
INSERT INTO `sys_resource_to_permission` VALUES (1651, 723, 25, '提交');
INSERT INTO `sys_resource_to_permission` VALUES (1652, 723, 26, '校验规则配置');
INSERT INTO `sys_resource_to_permission` VALUES (1653, 723, 27, '执行同步');
INSERT INTO `sys_resource_to_permission` VALUES (1654, 723, 28, '同步配置');
INSERT INTO `sys_resource_to_permission` VALUES (1655, 723, 29, '回收');
INSERT INTO `sys_resource_to_permission` VALUES (1656, 723, 30, '数据预览');
INSERT INTO `sys_resource_to_permission` VALUES (1657, 723, 31, '模型预览');
INSERT INTO `sys_resource_to_permission` VALUES (1658, 723, 33, '重命名');
INSERT INTO `sys_resource_to_permission` VALUES (1659, 723, 34, '历史记录');
INSERT INTO `sys_resource_to_permission` VALUES (1660, 723, 36, '访问');
INSERT INTO `sys_resource_to_permission` VALUES (1661, 723, 37, '字段信息');
INSERT INTO `sys_resource_to_permission` VALUES (1662, 723, 38, '移动');
INSERT INTO `sys_resource_to_permission` VALUES (1663, 723, 39, '复制 ');
INSERT INTO `sys_resource_to_permission` VALUES (1664, 723, 40, '配置人员');
INSERT INTO `sys_resource_to_permission` VALUES (1665, 723, 42, '下线');
INSERT INTO `sys_resource_to_permission` VALUES (1666, 723, 43, '设置列表显示项');
INSERT INTO `sys_resource_to_permission` VALUES (1667, 723, 44, '设置引用');
INSERT INTO `sys_resource_to_permission` VALUES (1668, 723, 45, '连接导入');
INSERT INTO `sys_resource_to_permission` VALUES (1669, 723, 46, '数据表更新');
INSERT INTO `sys_resource_to_permission` VALUES (1670, 723, 48, '导入组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1671, 723, 49, '导出组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1672, 723, 50, '验证');
INSERT INTO `sys_resource_to_permission` VALUES (1673, 750, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1674, 747, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1675, 807, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1677, 819, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1689, 777, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1690, 777, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1691, 777, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1692, 777, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1693, 777, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1694, 777, 51, '标注');
INSERT INTO `sys_resource_to_permission` VALUES (1701, 822, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1712, 722, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1713, 792, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1714, 773, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1715, 773, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1716, 773, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1717, 773, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1718, 773, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1719, 773, 51, '标注');
INSERT INTO `sys_resource_to_permission` VALUES (1720, 774, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1721, 774, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1722, 774, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1723, 774, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1724, 774, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1725, 774, 51, '标注');
INSERT INTO `sys_resource_to_permission` VALUES (1726, 775, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1727, 775, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1728, 775, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1729, 775, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1730, 775, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1731, 775, 51, '标注');
INSERT INTO `sys_resource_to_permission` VALUES (1732, 804, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1733, 804, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1734, 804, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1735, 804, 9, '发布');
INSERT INTO `sys_resource_to_permission` VALUES (1736, 804, 23, '终止');
INSERT INTO `sys_resource_to_permission` VALUES (1737, 805, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1738, 805, 51, '标注');
INSERT INTO `sys_resource_to_permission` VALUES (1739, 806, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1740, 785, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1741, 784, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1742, 749, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1744, 786, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1745, 726, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1746, 788, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1747, 789, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1748, 782, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1749, 783, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1750, 790, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1751, 791, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1752, 815, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1753, 778, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1754, 778, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1755, 778, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1756, 778, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1757, 778, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1758, 423, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1759, 423, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1760, 423, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1761, 423, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1762, 423, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1763, 424, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1764, 424, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1765, 424, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1766, 424, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1767, 424, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1768, 425, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1769, 425, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1770, 425, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1771, 426, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1772, 426, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1773, 426, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1774, 426, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1775, 426, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1776, 434, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1777, 434, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1778, 434, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1779, 434, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1780, 434, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1781, 485, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1782, 485, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1783, 485, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1784, 485, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1785, 485, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1786, 387, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1787, 387, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1788, 387, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1789, 388, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1790, 388, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1791, 388, 16, '强制退出');
INSERT INTO `sys_resource_to_permission` VALUES (1792, 483, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1793, 483, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1794, 484, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1795, 484, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1796, 383, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1797, 383, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1798, 383, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1799, 383, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1800, 383, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1801, 383, 13, '新建组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1802, 383, 14, '编辑组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1803, 383, 15, '删除组织机构');
INSERT INTO `sys_resource_to_permission` VALUES (1804, 383, 16, '强制退出');
INSERT INTO `sys_resource_to_permission` VALUES (1805, 383, 17, '重置密码');
INSERT INTO `sys_resource_to_permission` VALUES (1806, 383, 18, '启用/禁用');
INSERT INTO `sys_resource_to_permission` VALUES (1807, 383, 19, '批量导入用户');
INSERT INTO `sys_resource_to_permission` VALUES (1808, 384, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1809, 384, 2, '新增');
INSERT INTO `sys_resource_to_permission` VALUES (1810, 384, 3, '删除');
INSERT INTO `sys_resource_to_permission` VALUES (1811, 384, 4, '编辑');
INSERT INTO `sys_resource_to_permission` VALUES (1812, 384, 5, '查看');
INSERT INTO `sys_resource_to_permission` VALUES (1813, 824, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1814, 829, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1815, 830, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1816, 831, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1817, 832, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1818, 827, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1819, 828, 1, '所有');
INSERT INTO `sys_resource_to_permission` VALUES (1820, 834, 1, '所有');

-- ----------------------------
-- Table structure for sys_role
-- ----------------------------
DROP TABLE IF EXISTS `sys_role`;
CREATE TABLE `sys_role`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '权限名称',
  `role` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限标识',
  `description` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限描述',
  `status` tinyint(4) NOT NULL DEFAULT 1 COMMENT '状态 -1删除  0无效 1有效',
  `is_system_app` tinyint(4) NOT NULL COMMENT '是否是内置app角色：0否；1是',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id，当is_system==0时，必填',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `org_id_path` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '组织机构id路径',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `create_user` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '创建人员',
  `update_user` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '系统角色表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role
-- ----------------------------
INSERT INTO `sys_role` VALUES (2, '平台管理员', 'sys_mgr', '系统管理员', 1, 0, 1, '2020-05-18 13:39:59', '0', '2023-02-06 10:23:15', '', '');

-- ----------------------------
-- Table structure for sys_role_to_resource_to_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_role_to_resource_to_permission`;
CREATE TABLE `sys_role_to_resource_to_permission`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `app_id` bigint(64) NOT NULL COMMENT '应用id',
  `role_id` bigint(64) UNSIGNED NOT NULL COMMENT '角色id',
  `resource_id` bigint(64) UNSIGNED NOT NULL COMMENT '资源id',
  `permission_ids` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '权限id列表 数据库通过字符串存储 逗号分隔',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unq_roleid_resourceid`(`resource_id`, `role_id`, `app_id`) USING BTREE,
  INDEX `fk_sys_role2resource2permission_sys_role1_idx`(`role_id`) USING BTREE,
  INDEX `fk_sys_role2resource2permission_sys_resource1_idx`(`resource_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 11510 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '角色2资源2权限表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_role_to_resource_to_permission
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户登录名称',
  `password` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户密码',
  `phone` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '电话号码',
  `email` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '邮箱',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  `status` tinyint(4) NOT NULL COMMENT '状态: 0-未启用; 1-有效已启用; -1-删除',
  `user_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '用户类型: 0-普通用户; 1-管理员; 2-超级管理员',
  `crypto_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '加密类型：1-MD5; 2-SHA; 3-BCrypt',
  `salt` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '盐',
  `real_name` varchar(195) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '真实姓名',
  `sex` tinyint(4) NULL DEFAULT NULL COMMENT '性别: 1-女; 2-男',
  `pov_type` tinyint(4) NOT NULL DEFAULT 1 COMMENT '有效期类型: 1-长期; 2-期间',
  `pov_start` date NOT NULL DEFAULT '1970-01-01' COMMENT '有效期起始日期',
  `pov_end` date NOT NULL DEFAULT '9999-12-01' COMMENT '有效期结束日期',
  `create_user` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建来源 用户真实姓名/单点登录',
  `create_user_id` bigint(11) UNSIGNED NULL DEFAULT NULL COMMENT '创建来源 用户id',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '组织机构id路径',
  `update_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '更新人员',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_username`(`username`) USING BTREE,
  UNIQUE INDEX `idx_phone`(`phone`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES (1, 'super', '2ea993e8cbcdb7645385e414912a12f8', '18980523466', NULL, '2022-11-25 03:23:56', '2022-11-25 03:23:56', 1, 2, 'MD5', 'bqIEQpA69V', '超级管理员', 2, 1, '1970-01-01', '9999-12-01', 'admin', NULL, '0', 'admin');
INSERT INTO `sys_user` VALUES (2, 'admin', '2ea993e8cbcdb7645385e414912a12f8', '18980523467', NULL, '2022-11-25 03:23:56', '2022-11-25 03:23:56', 1, 1, 'MD5', 'bqIEQpA69V', '管理员', 2, 1, '1970-01-01', '9999-12-01', 'super', NULL, '0', 'super');

-- ----------------------------
-- Table structure for sys_user_last_online
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_last_online`;
CREATE TABLE `sys_user_last_online`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键id',
  `user_id` bigint(64) NOT NULL COMMENT '用户id',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `login_count` int(11) NOT NULL COMMENT '登录次数',
  `last_login_time` bigint(20) NOT NULL COMMENT '最后登录时间',
  `last_stop_time` bigint(20) NULL DEFAULT NULL COMMENT '最后停止访问时间',
  `last_login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '最后登录ip',
  `user_agent` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器信息',
  `total_online_time` bigint(20) NULL DEFAULT NULL COMMENT '总在线时长',
  `uid` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'sessionid',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `idx_uid`(`uid`) USING BTREE,
  INDEX `fk_user_last_online_sys_user1_idx`(`user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员最近在线' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_last_online
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_online
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_online`;
CREATE TABLE `sys_user_online`  (
  `id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_id` bigint(64) NOT NULL COMMENT '用户ID',
  `username` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '用户名',
  `status` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'online在线状态 offline离线状态',
  `login_ip` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录ip',
  `device` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '登录设备',
  `user_agent` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '浏览器信息',
  `start_time` bigint(20) NOT NULL COMMENT '开始访问时间',
  `last_access_time` bigint(20) NOT NULL COMMENT '最后访问时间',
  `timeout` bigint(20) NOT NULL COMMENT 'session失效时间',
  `jwt` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'session信息',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_operator_online_sys_user1_idx`(`user_id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员在线' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_online
-- ----------------------------
INSERT INTO `sys_user_online` VALUES ('UB3vqQVpoXX9lIO0g9UoXB7MKMlfP2pQ', 1, 'super', 'on_line', '100.100.71.192', 'pc-b8eea1a2-8eca-44ee-a2c8-7c080180b861', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36 Edg/118.0.2088.69', 1698906246678, 1698906246678, 604800, 'UB3vqQVpoXX9lIO0g9UoXB7MKMlfP2pQ');

-- ----------------------------
-- Table structure for sys_user_status_history
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_status_history`;
CREATE TABLE `sys_user_status_history`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `user_id` bigint(64) NOT NULL COMMENT '用户id',
  `status` tinyint(4) NOT NULL COMMENT '用户状态',
  `reason` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '原因',
  `op_user_id` bigint(64) NOT NULL COMMENT '操作人员',
  `op_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作日期',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_userId`(`user_id`) USING BTREE,
  INDEX `idx_opUserId`(`op_user_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户状态历史记录表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_status_history
-- ----------------------------

-- ----------------------------
-- Table structure for sys_user_to_organization_to_job
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_to_organization_to_job`;
CREATE TABLE `sys_user_to_organization_to_job`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键',
  `user_id` bigint(64) UNSIGNED NOT NULL COMMENT '用户id',
  `organization_id` bigint(64) NOT NULL COMMENT '组织id',
  `job_id` bigint(64) UNSIGNED NOT NULL COMMENT '职务id',
  `default_organization` tinyint(4) NULL DEFAULT 0 COMMENT '默认组织机构',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `unique_operatorid_organizationid_jobid`(`user_id`, `organization_id`, `job_id`) USING BTREE,
  INDEX `fk_sys_user_organization_job_sys_user1_idx`(`user_id`) USING BTREE,
  INDEX `fk_sys_user_organization_job_sys_organization1_idx`(`organization_id`) USING BTREE,
  INDEX `fk_sys_user_organization_job_sys_job1_idx`(`job_id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '管理员组织机构职务关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_to_organization_to_job
-- ----------------------------
INSERT INTO `sys_user_to_organization_to_job` VALUES (1, 1, 1, 0, 1);
INSERT INTO `sys_user_to_organization_to_job` VALUES (2, 2, 1, 0, 1);

-- ----------------------------
-- Table structure for sys_user_to_resource_to_data_permission
-- ----------------------------
DROP TABLE IF EXISTS `sys_user_to_resource_to_data_permission`;
CREATE TABLE `sys_user_to_resource_to_data_permission`  (
  `id` bigint(64) NOT NULL AUTO_INCREMENT,
  `app_id` bigint(20) NOT NULL COMMENT '应用id',
  `user_id` bigint(64) NOT NULL COMMENT '用户id',
  `resource_id` bigint(64) NOT NULL COMMENT '叶子菜单id',
  `data_permission_id` bigint(64) NOT NULL COMMENT '数据权限id',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '创建人员',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 1 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '用户与菜单、数据权限关系表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_user_to_resource_to_data_permission
-- ----------------------------

DROP TABLE IF EXISTS `sys_config_datasync`;
CREATE TABLE `sys_config_datasync`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `config_mq_id` bigint(20) NOT NULL COMMENT '消息队列id',
  `data_name` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '数据类型: user,organization,job',
  `topic` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '主题',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint(64) NOT NULL COMMENT '创建人',
  `update_date` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `update_by` bigint(64) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统数据同步配置' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_config_mq`;
CREATE TABLE `sys_config_mq`  (
  `id` bigint(64) UNSIGNED NOT NULL AUTO_INCREMENT,
  `mq_type` varchar(65) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '消息队列类型：rocketmq, kafka',
  `brokers` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT '配置类型 eg: 172.27.8.181:9876;172.27.8.182:9876;172.27.8.183:9876',
  `retry_count` int(11) NOT NULL DEFAULT 3 COMMENT '失败重试次数',
  `timeout` int(11) NOT NULL DEFAULT 5000 COMMENT '发送超时时间,默认3s,单位是毫秒',
  `options` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '其他参数，逗号分隔',
  `create_date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_by` bigint(64) NOT NULL COMMENT '创建人',
  `update_date` datetime NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新日期',
  `update_by` bigint(64) NULL DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '系统MQ配置' ROW_FORMAT = Dynamic;

DROP TABLE IF EXISTS `sys_flink_config`;
CREATE TABLE `sys_flink_config`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `file_name` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '文件名称',
  `file_content` longblob NOT NULL COMMENT '文件内容',
  `file_suffix` varchar(45) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '后缀名',
  `file_size` bigint(20) NOT NULL DEFAULT 0 COMMENT '文件大小（kb）',
  `create_user` varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '创建人',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_user` varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '更新人',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '加工配置表' ROW_FORMAT = DYNAMIC;

DROP TABLE IF EXISTS `sys_oa_organization`;
CREATE TABLE `sys_oa_organization`  (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `organization_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '行数组织机构Code',
  `oa_organization` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'oa组织机构Code',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = 'OA和行数系统组织机构的对应关系(行数一个部门对应OA一个或多个组织)' ROW_FORMAT = Dynamic;


SET FOREIGN_KEY_CHECKS = 1;
