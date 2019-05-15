//HBRCSD JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="1285764153" >                                                 *
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
//* This job will define the CICS resources required by the            *
//* IBM Decision Server for zOS                                        *
//*                                                                    *
//* CAUTION: This is not a complete job.                               *
//* Before submitting this job, make the following modifications:      *
//*                                                                    *
//* 1) Add the job parameters to meet your system requirements.        *
//*                                                                    *
//* 2) Change ++CICSHLQ++ to the appropriate high level quailifier     *
//*    for CICS - for example:                                         *
//*    change '++CICSHLQ++' to 'CTS320.CICS'                           *
//*                                                                    *
//* 3) Change ++CICSCSDDSN++ to the appropriate high level qualifier   *
//*    for the CICS system - for example:                              *
//*    change '++CICSCSDDSN++' to 'CTS320.APPLID.DFHCSD'               *
//*                                                                    *
//* 4) Change '++CICSLIST++' to your CICS startup GRPLIST for example: *
//*    change '++CICSLIST++' to 'HBRLIST'                              *
//*                                                                    *
//* Note: Some ++variables++ in this job will be substituted with the  *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 4 on first invocation as HBRGROUP does not   *
//*                         exist.                                     *
//*                                                                    *
//*                       0 on subsequent executions.                  *
//*                                                                    *
//**********************************************************************
//*   DEFINE CICS RESOURCES                                            *
//**********************************************************************
//*
//DEFCSD  EXEC PGM=DFHCSDUP,REGION=4M
//STEPLIB  DD DISP=SHR,DSN=++CICSHLQ++.SDFHLOAD
//DFHCSD   DD DISP=SHR,DSN=++CICSCSDDSN++
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
* IBM Decision Server for zOS resources
 DELETE GROUP(HBRGROUP) ALL

* ODM API calls for applications using dynamic binding
 DEFINE PROGRAM(HBRCONN)       GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(NO)               DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRRULE)       GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(NO)               DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRDISC)       GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(NO)               DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)

* ODM transactions and programs
 DEFINE TRANSACTION(HBRC)      GROUP(HBRGROUP)        PROGRAM(HBRCCON)
        DESCRIPTION(IBM Decision Server for zOS)
        TWASIZE(0)             PROFILE(DFHCICST)
                               STATUS(ENABLED)
        PRIORITY(1)            TASKDATALOC(ANY)       TASKDATAKEY(CICS)
                                                      RESTART(NO)
        SPURGE(NO)             TPURGE(NO)             DUMP(YES)
        TRACE(YES)
        RESSEC(YES)
 DEFINE TRANSACTION(HBRD)      GROUP(HBRGROUP)        PROGRAM(HBRCDSCO)
        DESCRIPTION(IBM Decision Server for zOS)
        TWASIZE(0)             PROFILE(DFHCICST)
                               STATUS(ENABLED)
        PRIORITY(1)            TASKDATALOC(ANY)       TASKDATAKEY(CICS)
                                                      RESTART(NO)
        SPURGE(NO)             TPURGE(NO)             DUMP(YES)
        TRACE(YES)
        RESSEC(YES)
 DEFINE PROGRAM(HBRCCON)       GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(CICS)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRCDSCO)      GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(CICS)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRCCMSG)      GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRCTRUA)      GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRCTRUE)      GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)
 DEFINE PROGRAM(HBRCJVMS)       GROUP(HBRGROUP)
      LANGUAGE(ASSEMBLER)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS)

*
* Uncomment and customise this definition if you are configuring a
* CICS AOR.   Ensure that you at least customise the REMOTESYSTEM and
* comment out the HBRCJVMS definition above
*
*  DEFINE PROGRAM(HBRCJVMS)       GROUP(HBRGROUP)
*      STATUS(ENABLED)            DYNAMIC(NO)
*      REMOTESYSTEM(<ROR CONNECTION ID>) REMOTENAME(HBRCJVMS)
*      DESCRIPTION(IBM Decision Server for zOS)
*

 DEFINE TDQUEUE(HBRC)          GROUP(HBRGROUP)
      DESCRIPTION(IBM Decision Server for zOS)
      TYPE(EXTRA)              TYPEFILE(OUTPUT)
      RECORDSIZE(496)          BLOCKSIZE(27776)
      RECORDFORMAT(VARIABLE)   BLOCKFORMAT(UNBLOCKED)
      DDNAME(HBRPRINT)         OPENTIME(INITIAL)

*
 DEFINE TDQUEUE(HBRE)          GROUP(HBRGROUP)
      DESCRIPTION(IBM Decision Server for zOS)
      TYPE(EXTRA)              TYPEFILE(INPUT)
      RECORDSIZE(496)          BLOCKSIZE(27776)
      RECORDFORMAT(FIXED)      BLOCKFORMAT(BLOCKED)
      DDNAME(HBRENVPR)         OPENTIME(DEFERRED)

*
 DEFINE TDQUEUE(SCEN)          GROUP(HBRGROUP)
      DESCRIPTION(IBM Decision Server for zOS)
      TYPE(EXTRA)              TYPEFILE(INPUT)
      RECORDSIZE(496)           BLOCKSIZE(27776)
      RECORDFORMAT(FIXED)      BLOCKFORMAT(BLOCKED)
      DDNAME(SCENARIO)         OPENTIME(DEFERRED)


 DEFINE PROGRAM(HBRMINC)       GROUP(HBRGROUP)
      LANGUAGE(COBOL)      RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS COBOL MiniLoan demo)

 DEFINE PROGRAM(HBRMINCP)       GROUP(HBRGROUP)
      LANGUAGE(PLI)        RELOAD(NO)             EXECKEY(USER)
      RESIDENT(NO)             USAGE(NORMAL)          USELPACOPY(NO)
      STATUS(ENABLED)          CEDF(YES)              DATALOCATION(ANY)
      CONCURRENCY(THREADSAFE)
      DESCRIPTION(IBM Decision Server for zOS PLI MiniLoan demo)

 DEFINE TRANSACTION(MINI)      GROUP(HBRGROUP)        PROGRAM(HBRMINC)
      DESCRIPTION(IBM Decision Server zOS transaction for demo)
        TWASIZE(0)             PROFILE(DFHCICST)
                               STATUS(ENABLED)
        PRIORITY(1)            TASKDATALOC(ANY)       TASKDATAKEY(USER)
                                                      RESTART(NO)
        SPURGE(NO)             TPURGE(NO)             DUMP(YES)
        TRACE(YES)
        RESSEC(YES)

 DEFINE TRANSACTION(MINP)      GROUP(HBRGROUP)        PROGRAM(HBRMINCP)
      DESCRIPTION(IBM Decision Server zOS transaction for demo)
        TWASIZE(0)             PROFILE(DFHCICST)
                               STATUS(ENABLED)
        PRIORITY(1)            TASKDATALOC(ANY)       TASKDATAKEY(USER)
                                                      RESTART(NO)
        SPURGE(NO)             TPURGE(NO)             DUMP(YES)
        TRACE(YES)
        RESSEC(YES)
*
* Add Group HBRGROUP to your start up list
ADD GROUP(HBRGROUP) LIST(++CICSLIST++)
*
/*
//*
