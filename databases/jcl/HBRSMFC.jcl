//HBRSMFC JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2013,2017"                                                  *
//* crc="2325492908" >                                                 *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2013, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* This job will dump SMF records and run the HBRSMFC program to      *
//* print SMF 120 subtype 100 records in CSV format.                   *
//*                                                                    *
//* Replace:                                                           *
//*   ++CSVPATH++ with the path where the csv file should be generated *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//SMFDUMP  EXEC PGM=IFASMFDP
//DUMPINA  DD   DSN=++PSMFDS++,DISP=SHR,AMP=('BUFSP=65536')
//DUMPINB  DD   DSN=++SSMFDS++,DISP=SHR,AMP=('BUFSP=65536')
//DUMPOUT  DD   DISP=(NEW,PASS),DSN=&&SMFDMP
//SYSPRINT DD   SYSOUT=*
//SYSIN  DD *
  INDD(DUMPINA,OPTIONS(DUMP))
  INDD(DUMPINB,OPTIONS(DUMP))
  OUTDD(DUMPOUT,TYPE(120))
  START(0000)
  END(2359)
/*
//SMFPRINT EXEC PGM=HBRSMFC,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=++HBRHLQ++.SHBRLOAD
//SMFIN    DD DISP=SHR,DSN=*.SMFDUMP.DUMPOUT
//SMFOUT   DD PATHOPTS=(OWRONLY,OCREAT,OTRUNC),
//            PATHMODE=(SIRWXU,SIRWXG),
// PATH='++CSVPATH++/smfout.csv'
//SYSPRINT DD SYSOUT=*
//SYSOUT   DD SYSOUT=*
//SYSERR   DD SYSOUT=*
