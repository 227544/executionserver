//HBRCSDW JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="2930558186" >                                                 *
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
//* This job will define the CICS resources required for WOLA under    *
//* CICS                                                               *
//*                                                                    *
//* CAUTION: This is not a complete job.                               *
//* Before submitting this job, make the following modifications:      *
//*                                                                    *
//* 1) Add the job parameters to meet your system requirements.        *
//*                                                                    *
//* 2) Change ++CICSHLQ++ to the appropriate high level quailifier     *
//*    for CICS - for example:                                         *
//*    change '++CICSHLQ++' to 'CTS420.CICS'                           *
//*                                                                    *
//* 3) Change ++CICSCSDDSN++ to the appropriate high level qualifier   *
//*    for the CICS system - for example                               *
//*    change '++CICSCSDDSN++' to 'CTS420.APPLID.DFHCSD'               *
//*                                                                    *
//* Expected return code: 0 (Check response messages from CICS)        *
//*                                                                    *
//**********************************************************************
//*   DEFINE CICS RESOURCES                                            *
//**********************************************************************
//*
//WOLACSD  EXEC PGM=DFHCSDUP,REGION=4M
//STEPLIB  DD DISP=SHR,DSN=++CICSHLQ++.SDFHLOAD
//DFHCSD   DD DISP=SHR,DSN=++CICSCSDDSN++
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DEFINE PROGRAM(BBOACALL) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACICS) GROUP(BBOACSD) LANGUAGE(C)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACNTL) GROUP(BBOACSD) LANGUAGE(C)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOATRUE) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACSRV) GROUP(BBOACSD) LANGUAGE(C)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACPLT) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACPL2) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(CICS)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACLNK) GROUP(BBOACSD) LANGUAGE(C)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOACHAB) GROUP(BBOACSD) LANGUAGE(C)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1CNG) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1CNR) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1GET) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1INV) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1REG) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1SRP) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1SRQ) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1SRV) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1SRX) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1RCA) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1RCL) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1RCS) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE PROGRAM(BBOA1URG) GROUP(BBOACSD) LANGUAGE(ASSEMBLER)
         DATALOCATION(ANY) EXECKEY(USER)
         CONCURRENCY(THREADSAFE) API(OPENAPI)
  DEFINE TRANSACTION(BBOC) PROGRAM(BBOACNTL) GROUP(BBOACSD)
         TASKDATALOC(ANY) TASKDATAKEY(CICS)
  DEFINE TRANSACTION(BBO$) PROGRAM(BBOACSRV) GROUP(BBOACSD)
         TASKDATALOC(ANY) TASKDATAKEY(CICS)
  DEFINE TRANSACTION(BBO#) PROGRAM(BBOACLNK) GROUP(BBOACSD)
         TASKDATALOC(ANY) TASKDATAKEY(USER)
  DEFINE TDQUEUE(BBOQ) TYPE(EXTRA) DDNAME(BBOOUT) GROUP(BBOACSD)
         DATABUFFERS(1) BLOCKFORMAT(UNBLOCKED) RECORDF(V)
         TYPEFILE(OUTPUT) DISPOSITION(SHR) OPENTIME(INITIAL)
         BLOCKSIZE(137) RECORDSIZE(133)
  ADD GROUP(BBOACSD) LIST(BBOLIST)
/*
//
