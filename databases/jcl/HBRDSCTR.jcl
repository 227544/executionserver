//HBRDSCTR JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="3590540368" >                                                 *
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
//* This job will create the tables required for trace                 *
//*                                                                    *
//* Note: This job assumes that the Storage Group and Database exist   *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
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

  -- Use a buffer pool with a 32K page size

  CREATE TABLESPACE RESDWTS
    IN ++RESDATABASE++
    CCSID UNICODE
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    FREEPAGE     5
    PCTFREE     20
    SEGSIZE     32
    BUFFERPOOL ++DB2BP32K++
    LOCKSIZE ANY
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA001
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA002
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA003
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA004
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA005
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA006
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA007
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA008
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE LOB TABLESPACE EXTRA009
    IN ++RESDATABASE++
    USING STOGROUP ++RESSTOGROUP++
          PRIQTY     7200
          SECQTY      720
    ERASE NO
    BUFFERPOOL ++DB2LOBBP++
    LOCKSIZE ANY
    LOG NO
    CLOSE NO;

  CREATE TABLE EXECUTION_TRACES
  (
    ID                 INT GENERATED ALWAYS AS IDENTITY
    (START WITH 1,     INCREMENT BY 1)       NOT NULL,
    TIME_STAMP         BIGINT,
    LOCATION           VARCHAR(2000),
    REQUEST_PATH       VARCHAR(2000)         NOT NULL,
    CANONICAL_PATH     VARCHAR(2000)         NOT NULL,
    RULESET_PROPERTIES CLOB(1G),
    ELAPSED_TIME       BIGINT,
    USER_DATA          CLOB(1G),
    NB_RULES           INT,
    NB_RULES_FIRED     INT,
    NB_RULES_NOT_FIRED INT,
    NB_TASKS INT,
    NB_TASKS_EXECUTED  INT,
    NB_TASKS_NOT_EXECUTED INT,
    RULES              CLOB(1G),
    TASKS              CLOB(1G),
    EXECUTION_TRACE_TREE CLOB(1G),
    EXEC_OUTPUT        CLOB(1G),
    INPUT_PARAMS       CLOB(1G),
    OUTPUT_PARAMS      CLOB(1G),
    EXECUTION_ID       VARCHAR(255)          NOT NULL,
    FULL_EXECUTION_TRACE CLOB(1G),
    CONSTRAINT         ET_PK      PRIMARY KEY (ID),
    CONSTRAINT         EID_UNQ    UNIQUE (EXECUTION_ID)
  )
  IN ++RESDATABASE++.RESDWTS
  CCSID UNICODE;

  CREATE UNIQUE INDEX EXECUTION_TRACES_IDX1
    ON EXECUTION_TRACES
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

  CREATE UNIQUE INDEX EXECUTION_TRACES_IDX2
    ON EXECUTION_TRACES
  (
    EXECUTION_ID
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

  CREATE AUX TABLE AUX_EX_TRACE_RS_PROPS
    IN ++RESDATABASE++.EXTRA001
    STORES EXECUTION_TRACES COLUMN RULESET_PROPERTIES;

  CREATE UNIQUE INDEX AUX_EX_TRACE_RS_PROPS_UI1
    ON AUX_EX_TRACE_RS_PROPS;

  CREATE AUX TABLE AUX_EX_TRACE_USER_DATA
    IN ++RESDATABASE++.EXTRA002
    STORES EXECUTION_TRACES COLUMN USER_DATA;

  CREATE UNIQUE INDEX AUX_EX_TRACE_USER_DATA_UI1
    ON AUX_EX_TRACE_USER_DATA;

  CREATE AUX TABLE AUX_EX_TRACE_RULES
    IN ++RESDATABASE++.EXTRA003
    STORES EXECUTION_TRACES COLUMN RULES;

  CREATE UNIQUE INDEX AUX_EX_TRACE_RULES_UI1
    ON AUX_EX_TRACE_RULES;

  CREATE AUX TABLE AUX_EX_TRACE_TASKS
    IN ++RESDATABASE++.EXTRA004
    STORES EXECUTION_TRACES COLUMN TASKS;

  CREATE UNIQUE INDEX AUX_EX_TRACE_TASKS_UI1
    ON AUX_EX_TRACE_TASKS;


  CREATE AUX TABLE AUX_EX_TRACE_ETT
    IN ++RESDATABASE++.EXTRA005
    STORES EXECUTION_TRACES COLUMN EXECUTION_TRACE_TREE;

  CREATE UNIQUE INDEX AUX_EX_TRACE_ETT_UI1
    ON AUX_EX_TRACE_ETT;

  CREATE AUX TABLE AUX_EX_TRACE_EXOUT
    IN ++RESDATABASE++.EXTRA006
    STORES EXECUTION_TRACES COLUMN EXEC_OUTPUT;

  CREATE UNIQUE INDEX AUX_EX_TRACE_EXOUT_UI1
    ON AUX_EX_TRACE_EXOUT;

  CREATE AUX TABLE AUX_EX_TRACE_INPARAMS
    IN ++RESDATABASE++.EXTRA007
    STORES EXECUTION_TRACES COLUMN INPUT_PARAMS;

  CREATE UNIQUE INDEX AUX_EX_TRACE_INPARAMS_UI1
    ON AUX_EX_TRACE_INPARAMS;

  CREATE AUX TABLE AUX_EX_TRACE_OUTPARAMS
    IN ++RESDATABASE++.EXTRA008
    STORES EXECUTION_TRACES COLUMN OUTPUT_PARAMS;

  CREATE UNIQUE INDEX AUX_EX_TRACE_OUTPARAMS_UI1
    ON AUX_EX_TRACE_OUTPARAMS;

  CREATE AUX TABLE AUX_EX_TRACE_FULLET
    IN ++RESDATABASE++.EXTRA009
    STORES EXECUTION_TRACES COLUMN FULL_EXECUTION_TRACE;

  CREATE UNIQUE INDEX AUX_EX_TRACE_FULLET_UI1
    ON AUX_EX_TRACE_FULLET;


/*
//*
