//HBRDSCDB JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="3464596683" >                                                 *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2009, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* The job will create the Rules Execution Server storagegroup,       *
//* database,tablespaces and tables for supported versions of          *
//* DB2 for zOS                                                        *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//*
//**********************************************************************
//* Create rules storagegroup                                          *
//**********************************************************************
//*
//STORGRP  EXEC PGM=IKJEFT01,REGION=0M
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=++DB2HLQ++.SDSNEXIT
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOAD
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOD2
//         DD DISP=SHR,DSN=++DB2RUNLIB++
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
----------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
----------------------------------------------------------------------
  set current SQLID ='++DB2ADMIN++';
--
  CREATE STOGROUP ++RESSTOGROUP++
     VOLUMES('*')
     VCAT ++DB2VCAT++;
/*
//*
//******************************************************************
//* Create rules database
//******************************************************************
//*
//DATABASE EXEC PGM=IKJEFT01,REGION=0M
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=++DB2HLQ++.SDSNEXIT
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOAD
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOD2
//         DD DISP=SHR,DSN=++DB2RUNLIB++
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
----------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
----------------------------------------------------------------------
  set current SQLID ='++DB2ADMIN++';
--
  CREATE DATABASE ++RESDATABASE++
     STOGROUP ++RESSTOGROUP++
     INDEXBP  ++DB2INDEXBP++;
/*
//*
//******************************************************************
//* Create rules tablespaces
//******************************************************************
//*
//TABLESPC EXEC PGM=IKJEFT01,REGION=0M
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=++DB2HLQ++.SDSNEXIT
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOAD
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOD2
//         DD DISP=SHR,DSN=++DB2RUNLIB++
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
----------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
----------------------------------------------------------------------
  set current SQLID ='++DB2ADMIN++';
--

  CREATE TABLESPACE RUAPP
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2TABLEBP++
    LOCKSIZE ROW
    CLOSE NO;

  CREATE TABLESPACE RUSET
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2TABLEBP++
    LOCKSIZE ANY
    CLOSE NO;

  CREATE TABLESPACE RUAPPPRO
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2TABLEBP++
    LOCKSIZE ANY
    CLOSE NO;

  CREATE TABLESPACE RUSETPRO
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2TABLEBP++
    LOCKSIZE ANY
    CLOSE NO;

  CREATE TABLESPACE RUSETRES
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2TABLEBP++
    LOCKSIZE ANY
    CLOSE NO;

  CREATE LOB TABLESPACE AUXSETRE LOG NO
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    CLOSE NO;
/*
//*
//******************************************************************
//* Create rules tables
//******************************************************************
//*
//TABLES   EXEC PGM=IKJEFT01,REGION=0M
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=++DB2HLQ++.SDSNEXIT
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOAD
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOD2
//         DD DISP=SHR,DSN=++DB2RUNLIB++
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
  --#SET MAXERRORS 1
----------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
----------------------------------------------------------------------
   SET CURRENT SQLID='++DB2ADMIN++';

--
----------------------------------------------------------------------
-- Setting SCHEMA to specified schema name
-- All elements, tables, indexes etc. will be created within this
-- schema
----------------------------------------------------------------------
   SET CURRENT SCHEMA = '++DB2SCHEMA++';

--

  CREATE TABLE RULEAPPS
  (
    ID             INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    NAME           VARCHAR(256)      NOT NULL,
    MAJOR_VERSION  INT               NOT NULL,
    MINOR_VERSION  INT               NOT NULL,
    CREATION_DATE  BIGINT            NOT NULL,
    DISPLAY_NAME   VARCHAR(256),
    DESCRIPTION    VARCHAR(256),
    CONSTRAINT RA_PK PRIMARY KEY (ID),
    CONSTRAINT RA_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
  )
  IN ++RESDATABASE++.RUAPP
  CCSID UNICODE;

  CREATE UNIQUE INDEX RULEAPPS_IDX1
  ON RULEAPPS
  (
    ID
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      CLUSTER
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;


  CREATE UNIQUE INDEX RULEAPPS_IDX2
  ON RULEAPPS
  (
    NAME,
    MAJOR_VERSION,
    MINOR_VERSION
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;

  CREATE TABLE RULESETS
  (
    ID             INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    NAME           VARCHAR(256)      NOT NULL,
    MAJOR_VERSION  INT               NOT NULL,
    MINOR_VERSION  INT               NOT NULL,
    CREATION_DATE  BIGINT            NOT NULL,
    DISPLAY_NAME   VARCHAR(256),
    DESCRIPTION    VARCHAR(256),
    RULEAPP_ID     INT               NOT NULL,
    CONSTRAINT RS_PK PRIMARY KEY (ID),
    CONSTRAINT RS_FK FOREIGN KEY (RULEAPP_ID)
     REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
    CONSTRAINT RS_UNIQUE
        UNIQUE (RULEAPP_ID, NAME, MAJOR_VERSION, MINOR_VERSION)
  )
  IN ++RESDATABASE++.RUSET
  CCSID UNICODE;


  CREATE UNIQUE INDEX RULESETS_IDX1
  ON RULESETS
  (
    ID
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      CLUSTER
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;

  CREATE UNIQUE INDEX RULESETS_IDX2
  ON RULESETS
  (
    RULEAPP_ID,
    NAME,
    MAJOR_VERSION,
    MINOR_VERSION
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;


  CREATE TABLE RULEAPP_PROPERTIES
  (
    ID             INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    RULEAPP_ID     INT               NOT NULL,
    NAME           VARCHAR(256)      NOT NULL,
    VALUE          VARCHAR(2000)     NOT NULL,
    CONSTRAINT RA_PROPS_PK PRIMARY KEY (ID),
    CONSTRAINT RA_PROPS_FK FOREIGN KEY (RULEAPP_ID)
    REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
    CONSTRAINT RA_PROPS_UN UNIQUE (RULEAPP_ID, NAME)
  )
  IN ++RESDATABASE++.RUAPPPRO
  CCSID UNICODE;

  CREATE UNIQUE INDEX RULEAPP_PROPERTIES_IDX1
  ON RULEAPP_PROPERTIES
  (
    ID
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      CLUSTER
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;



  CREATE UNIQUE INDEX  RULEAPP_PROPERTIES_IDX2
  ON RULEAPP_PROPERTIES
  (
     RULEAPP_ID,
     NAME
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO
      NOT PADDED;

  CREATE TABLE RULESET_PROPERTIES
  (
    ID             INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    RULESET_ID     INT               NOT NULL,
    NAME           VARCHAR(256)      NOT NULL,
    VALUE          VARCHAR(2000)     NOT NULL,
    CONSTRAINT RS_PROPS_PK PRIMARY KEY (ID),
    CONSTRAINT RS_PROPS_FK FOREIGN KEY (RULESET_ID)
    REFERENCES RULESETS (ID) ON DELETE CASCADE,
    CONSTRAINT RS_PROPS_UN UNIQUE (RULESET_ID, NAME)
  )
  IN ++RESDATABASE++.RUSETPRO
  CCSID UNICODE;


  CREATE UNIQUE INDEX RULESET_PROPERTIES_IDX1
  ON RULESET_PROPERTIES
  (
    ID
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      CLUSTER
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;

  CREATE UNIQUE INDEX  RULESET_PROPERTIES_IDX2
  ON RULESET_PROPERTIES
  (
     RULESET_ID,
     NAME
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO
      NOT PADDED;

  CREATE TABLE RULESET_RESOURCES
  (
    ID INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    RULESET_ID     INT               NOT NULL,
    ARCHIVE        BLOB(1024 M)      NOT NULL,
    CONSTRAINT RS_RES_PK PRIMARY KEY (ID),
    CONSTRAINT RS_RES_FK FOREIGN KEY (RULESET_ID)
    REFERENCES RULESETS (ID) ON DELETE CASCADE
  )
  IN ++RESDATABASE++.RUSETRES
  CCSID UNICODE;

  CREATE UNIQUE INDEX RULESET_RESOURCES_IDX1
  ON  RULESET_RESOURCES
  (
      ID
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      CLUSTER
      DEFINE NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE NO;


  CREATE AUX TABLE AUX_RULESET_RESOURCES
  IN ++RESDATABASE++.AUXSETRE
    STORES RULESET_RESOURCES COLUMN ARCHIVE;

  CREATE UNIQUE INDEX AUX_RULESET_RESOURCES_UI1
  ON AUX_RULESET_RESOURCES;

  CREATE VIEW RS_ENABLED_VIEW AS
  SELECT RA.ID AS RA_ID, RA.NAME AS RA_NAME,
         RA.MAJOR_VERSION AS RA_MAJVERS,
         RA.MINOR_VERSION AS RA_MINVERS,
         RS.ID AS RS_ID, RS.NAME AS RS_NAME,
         RS.MAJOR_VERSION AS RS_MAJVERS,
         RS.MINOR_VERSION AS RS_MINVERS
  FROM   RULEAPPS RA,
         RULESETS RS,
         RULESET_PROPERTIES P
  WHERE RS.RULEAPP_ID = RA.ID AND RS.ID = P.RULESET_ID
  AND UPPER(P.NAME) = 'RULESET.STATUS' AND UPPER(P.VALUE) = 'ENABLED';


/*
//*
