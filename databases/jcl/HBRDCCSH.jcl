-- -------------------------------------------------------------------
-- <copyright 
-- notice="lm-source-program" 
-- pids="5655-Y31"
-- years="2014,2017" 
-- crc="3858517127" > 
-- Licensed Materials - Property of IBM  
--  
-- 5655-Y31
--  
-- (C) Copyright IBM Corp. 2014, 2017 All Rights Reserved.  
--  
-- US Government Users Restricted Rights - Use, duplication or  
-- disclosure restricted by GSA ADP Schedule Contract with  
-- IBM Corp.  
-- </copyright> 
-- -------------------------------------------------------------------
-- Header SQL used by HBRDCCDB
-- -------------------------------------------------------------------

----------------------------------------------------------------------
-- Database=++RTSDATABASE++ Stogroup=++RTSSTOGROUP++
----------------------------------------------------------------------

----------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
----------------------------------------------------------------------
SET CURRENT SQLID='++DB2ADMIN++';

----------------------------------------------------------------------
-- Setting SCHEMA to specified schema name
-- All elements, tables, indexes etc. will be created in this schema
----------------------------------------------------------------------
SET CURRENT SCHEMA = '++DB2SCHEMA++';

----------------------------------------------------------------------
-- Create DATABASE, BUFFERPOOL, INDEXBP, STOGROUP
----------------------------------------------------------------------
CREATE DATABASE ++RTSDATABASE++
BUFFERPOOL ++DB2TABLEBP++
INDEXBP    ++DB2INDEXBP++
STOGROUP   ++RTSSTOGROUP++;

----------------------------------------------------------------------
-- DECISION CENTER SQL
----------------------------------------------------------------------
