//HBRDCGRN JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="1144488237" >                                                 *
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
//* This job will issue grants for the Decision Center database        *
//* artifacts.                                                         *
//*                                                                    *
//* This job uses SQL from the following members:                      *
//*   HBRDCGSH - SQL header to setup environment                       *
//*   HBRDCGSQ - SQL to issue grants for the Decision Center database  *
//*              artifacts                                             *
//*                                                                    *
//* If there are other stogroups, issue grants for these as well       *
//* If there are other databases, issue grants for these as well       *
//*                                                                    *
//* Issue grants for all tables. An example for the RTS database can   *
//* found in the HBRDCGSQ member                                       *
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
//HBRDCGRN EXEC PGM=IKJEFT01,REGION=0M
//         SET  DB2HLQ=++DB2HLQ++
//         SET  DB2RNL=++DB2RUNLIB++
//         SET  HBRWDS=++HBRWORKDS++
//STEPLIB  DD DISP=SHR,DSN=&DB2HLQ..SDSNEXIT
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOAD
//         DD DISP=SHR,DSN=&DB2HLQ..SDSNLOD2
//         DD DISP=SHR,DSN=&DB2RNL.
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(++DB2SUBSYSTEM++)
 RUN -
   PROGRAM(++DB2SAMPLEPROGRAM++) -
   PLAN(++DB2SAMPLEPROGRAMPLAN++)-
   LIBRARY('++DB2RUNLIB++')
 END
//SYSIN    DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCGSH)
//         DD DISP=SHR,DSN=&HBRWDS..SHBRJCL(HBRDCGSQ)
