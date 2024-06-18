/*
 Navicat Premium Data Transfer

 Source Server         : 行智-行数-sit
 Source Server Type    : MySQL
 Source Server Version : 50740
 Source Host           : 172.27.12.227:23214
 Source Schema         : xs_database

 Target Server Type    : MySQL
 Target Server Version : 50740
 File Encoding         : 65001

 Date: 10/05/2023 11:13:07
*/

DROP DATABASE IF EXISTS xs_database;
CREATE DATABASE xs_database DEFAULT character set utf8mb4;

use xs_database;

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for database_directory
-- ----------------------------
DROP TABLE IF EXISTS `database_directory`;
CREATE TABLE `database_directory`  (
  `id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键自增',
  `source` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '系统资源标识',
  `name` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL,
  `parent_id` int(11) NULL DEFAULT NULL COMMENT '父亲节点',
  `parent_ids` varchar(100) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '父辈节点组成的字符串',
  `weight` int(11) NULL DEFAULT 1000 COMMENT '排序种子 ，值越大越靠后',
  `status` tinyint(4) NULL DEFAULT 1 COMMENT '状态 -1删除  0无效 1有效',
  `is_show` tinyint(4) NULL DEFAULT 1 COMMENT '是否显示 0不显示 1显示',
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `create_user` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '创建人员',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(45) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '更新人员',
  `org_id_path` varchar(50) CHARACTER SET utf8 COLLATE utf8_bin NULL DEFAULT NULL COMMENT '资源权限字段',
  `security_level` tinyint(4) NULL DEFAULT 0 COMMENT '数据安全等级权限',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_parent_ids`(`parent_ids`, `weight`) USING BTREE,
  INDEX `idx_parent_id`(`parent_id`, `weight`) USING BTREE,
  INDEX `idx_orgidpath`(`org_id_path`) USING BTREE,
  INDEX `idx_creatuser`(`create_user`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_bin COMMENT = '非结构化资源目录' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of database_directory
-- ----------------------------
INSERT INTO `database_directory` VALUES (1, NULL, '行智', 0, '0', 1000, 1, 1, '2022-03-09 17:03:46', 'admin', '2023-05-10 03:05:18', 'admin', '0/1/', 0, NULL);

-- ----------------------------
-- Table structure for database_info
-- ----------------------------
DROP TABLE IF EXISTS `database_info`;
CREATE TABLE `database_info`  (
  `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT '主键ID',
  `name` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '资源库名称',
  `status` tinyint(2) NULL DEFAULT NULL COMMENT '状态 -1 删除 0 无效 1正常',
  `dialect` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据库方言 mysql,oracle,hive,hbase',
  `presto_settings` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL COMMENT 'presto配置信息',
  `jdbc_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'jdbc连接地址',
  `username` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '用户名',
  `password` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '密码',
  `driver_class` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '连接驱动',
  `remark` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT 'source_connections表id',
  `weight` int(11) NULL DEFAULT NULL COMMENT '排序种子：值越大越靠后',
  `database_name` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据库名称',
  `host` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据库ip地址',
  `version` varchar(45) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '数据库版本',
  `port` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `connection_parameters` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '连接参数',
  `df_catalog` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `df_schema` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
  `can_edit` tinyint(1) NULL DEFAULT NULL COMMENT '0-只读类型的数据连接，1-可进行编辑等操作的数据连接',
  `org_id_path` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT '0',
  `security_level` tinyint(4) NULL DEFAULT 0,
  `create_time` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `create_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '创建人员',
  `update_time` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `update_user` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL COMMENT '更新人员',
  `dir_id` int(11) NULL DEFAULT 0 COMMENT '目录id',
  `app_id` bigint(64) NULL DEFAULT NULL COMMENT '应用id',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idex_query`(`name`, `status`, `dialect`, `create_time`, `create_user`) USING BTREE,
  INDEX `idx_remark`(`remark`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_general_ci COMMENT = '主题库数据库连接配置信息' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of database_info
-- ----------------------------
INSERT INTO `database_info` VALUES (1, '行智datacenter', 1, 'MYSQL', NULL, NULL, 'root', 'f12d0da8a270aefa42fd73cc93199022', NULL, 'null', NULL, 'xs_datacenter', '172.27.12.227', NULL, '23214', NULL, NULL, NULL, 0, '0/1/', 0, '2022-03-15 18:52:35', 'admin', '2023-05-10 03:07:27', 'admin', 1, NULL);

-- ----------------------------
-- Table structure for source_connection_type
-- ----------------------------
DROP TABLE IF EXISTS `source_connection_type`;
CREATE TABLE `source_connection_type`  (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `type` tinyint(2) NOT NULL COMMENT '1 数据库  2 大数据平台 3 本地文件',
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据库名称',
  `short_name` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '数据库简称',
  `default_port` int(6) NULL DEFAULT -1 COMMENT '默认端口',
  `sort` int(3) NULL DEFAULT 99 COMMENT '排序',
  `logo_path` varchar(128) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'logo 图片地址',
  `status` tinyint(2) NULL DEFAULT 1 COMMENT '是否显示  1 是 2  否',
  `direct_connection` tinyint(2) NULL DEFAULT 1 COMMENT '是否支持直连 1 是 2 否',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 32 CHARACTER SET = utf8 COLLATE = utf8_general_ci COMMENT = '添加数据库连接类型' ROW_FORMAT = COMPACT;

-- ----------------------------
-- Records of source_connection_type
-- ----------------------------
INSERT INTO `source_connection_type` VALUES (1, 1, '其他数据库', 'GENERIC', -1, 20, 'other.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (2, 1, 'MySQL', 'MYSQL', 3306, 2, 'mysql.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (3, 1, 'Oracle', 'ORACLE', 1521, 4, 'oracle.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (4, 1, 'PostgreSQL', 'POSTGRESQL', 5432, 6, 'postgresql.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (5, 1, 'MS SQL Server', 'MSSQL', 1433, 5, 'mssql.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (6, 1, 'Hypersonic', 'HYPERSONIC', 9001, 5, 'hypersonic.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (7, 1, 'H2', 'H2', 9092, 6, 'h2.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (8, 1, 'IBM DB2', 'DB2', 50000, 1, 'db2.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (9, 3, 'txt', 'TXT', -1, 2, 'txt.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (10, 3, 'excel', 'EXCEL', -1, 1, 'excel.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (11, 3, 'csv', 'CSV', -1, 3, 'csv.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (12, 2, 'Hadoop Hive 2', 'HIVE2', 10000, 1, 'hive2.svg', 1, 2);
INSERT INTO `source_connection_type` VALUES (13, 2, 'spark', 'SPARK', 10000, 2, 'spark.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (14, 2, 'Kylin', 'KYLIN', 7070, 7, 'kylin.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (15, 1, 'Vertica 5+', 'VERTICA5', 5433, 9, 'vertica5.svg', 2, 1);
INSERT INTO `source_connection_type` VALUES (16, 2, 'Impala', 'IMPALA', 21050, 3, 'impala.svg', 2, 1);
INSERT INTO `source_connection_type` VALUES (17, 1, 'informix', 'INFORMIX', -1, 3, 'informix.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (18, 1, 'gbase', 'GBASE', -1, 7, 'gbase.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (19, 1, 'greenPlum', 'GREENPLUM', -1, 8, 'greenplum.svg', 2, 1);
INSERT INTO `source_connection_type` VALUES (20, 2, 'presto', 'PRESTO', -1, 4, 'presto.svg', 2, 1);
INSERT INTO `source_connection_type` VALUES (21, 2, 'elk', 'ELK', -1, 5, 'elk.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (22, 2, 'fusionInsightLibra', 'FUSIONINSIGHTLIBRA', -1, 6, 'fusioninsightlibra.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (23, 4, 'mongodb', 'MONGODBNOSQL', 27017, 7, 'mongodbnosql.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (24, 3, 'json', 'JSON', -1, 99, 'json.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (25, 3, 'xml', 'XML', -1, 99, 'xml.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (26, 1, 'kingbase', 'KINGBASE', 54321, 10, 'kingbase.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (27, 1, 'dm', 'DM', 5236, 11, 'dm.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (28, 1, 'oscar', 'OSCAR', 2004, 12, 'oscar.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (29, 2, 'ODPS', 'ODPS', -1, 8, 'odps.svg', 2, 2);
INSERT INTO `source_connection_type` VALUES (30, 1, 'mongodb', 'MONGODB', 27017, 12, 'mongodb.svg', 1, 1);
INSERT INTO `source_connection_type` VALUES (31, 1, 'elastic search', 'ES', 9200, 99, 'elasticsearch.svg', 1, 1);

SET FOREIGN_KEY_CHECKS = 1;
