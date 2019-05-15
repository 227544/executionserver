//HBRDCCDB JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="1282392999" >                                                 *
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
//* This job will create database artifacts for the Decision Center    *
//*                                                                    *
//* This job uses SQL from the following members:                      *
//*   HBRDCCSH - SQL header to setup environment and create database   *
//*   HBRDCCSQ - SQL to create Decision Center database artifacts      *
//*                                                                    *
//* Note: ++variables++ in this job and its SYSIN members will be      *
//* substituted with the values specified in the HBRINST member as     *
//* part of the configuration process.                                 *
//* See the documentation for more details.                            *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//*
//**********************************************************************
//* Create the DECISION CENTER storage group
//**********************************************************************
//*
//STORGRP  EXEC PGM=IKJEFT01,REGION=0M
//         SET  DB2HLQ=++DB2HLQ++
//         SET  DB2RNL=++DB2RUNLIB++
//         SET  HBRWDS=++HBRWORKDS++
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=&DB2HLQ..SDSNEXIT
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOAD
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOD2
//         DD DISP=SHR,DSN=&DB2RNL.
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD *
------------------------------------------------------------------------
-- Setting SQLID with authority to create database objects etc.
------------------------------------------------------------------------
  set current SQLID ='++DB2ADMIN++';

  CREATE STOGROUP ++RTSSTOGROUP++
     VOLUMES('*')
     VCAT ++DB2VCAT++;
/*
//*
//**********************************************************************
//* Create DECISION CENTER database
//**********************************************************************
//*
//DATABASE EXEC PGM=IKJEFT01,REGION=0M
//         SET  DB2HLQ=++DB2HLQ++
//         SET  DB2RNL=++DB2RUNLIB++
//         SET  HBRWDS=++HBRWORKDS++
//*        DB2 Runtime Libraries
//STEPLIB  DD DISP=SHR,DSN=&DB2HLQ..SDSNEXIT
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOAD
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOD2
//         DD DISP=SHR,DSN=&DB2RNL.
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD *
DSN SYSTEM(++DB2SUBSYSTEM++)
   RUN -
     PROGRAM(++DB2SAMPLEPROGRAM++) -
     PLAN(++DB2SAMPLEPROGRAMPLAN++)
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSIN    DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCCSH)
//         DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCCSQ)
