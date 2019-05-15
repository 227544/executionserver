//HBRDSXOM JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//*                                                                    *
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="717753466" >                                                  *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2012, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* This job will create the XOM database artifacts for the            *
//* Decision Server                                                    *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//* Create rules tablespaces
//**********************************************************************
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
  CREATE TABLESPACE XOMRES
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

  CREATE TABLESPACE XOMLIBVS
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

  CREATE LOB TABLESPACE XRTS LOG NO
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
//**********************************************************************
//* Create rules tables
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

  CREATE TABLE XOM_LIBRARIES
  (
    ID INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    NAME              VARCHAR(256)  NOT NULL,
    MAJOR_VERSION     INT           NOT NULL,
    MINOR_VERSION     INT           NOT NULL,
    CREATION_DATE     BIGINT        NOT NULL,
    CONSTRAINT XL_PK PRIMARY        KEY (ID),
    CONSTRAINT XL_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
  )
  IN ++RESDATABASE++.XOMLIBVS
  CCSID UNICODE;

  CREATE UNIQUE INDEX XLIBS_IDXU1
  ON  XOM_LIBRARIES
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


  CREATE UNIQUE INDEX XLIBS_IDXU2
  ON XOM_LIBRARIES
  (
    NAME, MAJOR_VERSION, MINOR_VERSION
  )
  USING STOGROUP ++RESSTOGROUP++
      PRIQTY      48
      SECQTY      48
      ERASE NO
      FREEPAGE     5
      PCTFREE     30
      DEFINE      NO
      BUFFERPOOL ++DB2INDEXBP++
      CLOSE       NO
      NOT PADDED;

  CREATE TABLE XOM_RESOURCES
  (
    ID INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    NAME                VARCHAR(256)   NOT NULL,
    MAJOR_VERSION       INT            NOT NULL,
    MINOR_VERSION       INT            NOT NULL,
    SHA1                VARCHAR(40)    NOT NULL,
    CREATION_DATE       BIGINT         NOT NULL,
    DATA                BLOB(1024 M)   NOT NULL,
    CONSTRAINT XR_PK PRIMARY KEY (ID),
    CONSTRAINT XR_UNIQUE1 UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION),
    CONSTRAINT XR_UNIQUE2 UNIQUE (NAME, SHA1)
  )
  IN ++RESDATABASE++.XOMRES
  CCSID UNICODE;

  CREATE UNIQUE INDEX XRESS_IDXU1
  ON XOM_RESOURCES
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

  CREATE UNIQUE INDEX XRESS_IDXU2
  ON XOM_RESOURCES
  (
    NAME, MAJOR_VERSION, MINOR_VERSION
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

  CREATE UNIQUE INDEX XRESS_IDXU3
  ON XOM_RESOURCES
  (
    NAME,
    SHA1
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

  CREATE AUX TABLE AUX_XOM_RESOURCES
  IN ++RESDATABASE++.XRTS
    STORES XOM_RESOURCES COLUMN DATA;


  CREATE UNIQUE INDEX AUX_XOM_RESOURCES_UI1
  ON AUX_XOM_RESOURCES;

  CREATE TABLE XOM_LIBRARY_VALUES
  (
    ID INT GENERATED ALWAYS AS
    IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
    LIBRARY_ID            INT               NOT NULL,
    URL                   VARCHAR(256)      NOT NULL,
    CONSTRAINT XL_VLS_PK PRIMARY KEY (ID),
    CONSTRAINT XL_VLS_FK FOREIGN KEY (LIBRARY_ID)
      REFERENCES XOM_LIBRARIES (ID) ON DELETE CASCADE,
    CONSTRAINT XL_VLS_UN UNIQUE (LIBRARY_ID, URL)
  )
  IN ++RESDATABASE++.XOMLIBVS
  CCSID UNICODE;

  CREATE UNIQUE INDEX XLIBVLS_IDXU1
  ON XOM_LIBRARY_VALUES
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


  CREATE UNIQUE INDEX XLIBVLS_IDXU2
  ON XOM_LIBRARY_VALUES
  (
    LIBRARY_ID, URL
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


/*
//*
