//HBRDCDDB JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="3544423181" >                                                 *
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
//* This job will drop the database, storagegroup and sequences for    *
//* the Decision Center.                                               *
//*                                                                    *
//* This job uses SQL from the following members:                      *
//*   HBRDCDSH - SQL header to setup environment                       *
//*   HBRDCDSQ - SQL to drop Decision Center database artifacts        *
//*                                                                    *
//* Note: Dropping the database and storage group will also drop any   *
//* DB2 IMAGE COPIES (backups) of the database which will mean the     *
//* database cannot be recovered in the future.                        *
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
//* Drop Decision Center database                                      *
//**********************************************************************
//*
//HBRDCDDB EXEC PGM=IKJEFT01,REGION=0M
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
//SYSIN    DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCDSH)
//         DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCDSQ)
