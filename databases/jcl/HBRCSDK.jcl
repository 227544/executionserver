//HBRCSDK JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="3847422110" >                                                 *
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
//* This job will define the CICS resources requried by the            *
//* IBM Decision Server for zOS when running inside the CICS           *
//* Liberty JVM Server                                                 *
//*                                                                    *
//* CAUTION: This is not a complete job.                               *
//* Before submitting this job, make the following modifications:      *
//*                                                                    *
//* 1) Add the job parameters to meet your system requirements.        *
//*                                                                    *
//* 2) Change ++CICSHLQ++ to the appropriate high level quailifier     *
//*    for CICS - for example:                                         *
//*    change '++CICSHLQ++' to 'CTS530.CICS'                           *
//*                                                                    *
//* 3) Change ++CICSCSDDSN++ to the appropriate high level qualifier   *
//*    for the CICS system - for example:                              *
//*    change '++CICSCSDDSN++' to 'CTS530.APPLID.DFHCSD'               *
//*                                                                    *
//*                                                                    *
//* Note: Some ++variables++ in this job will be substituted with the  *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0 (Check response messages from CICS)        *
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
 DEFINE JVMSERVER(HBRJVM)    GROUP(HBRGROUP)
        STATUS(ENABLED)
        JVMPROFILE(HBRJVM)
        LERUNOPTS(DFHAXRO)
        THREADLIMIT(15)

* Remove the classpath JVM definition of HBRCJVMS
 DELETE PROGRAM(HBRCJVMS) GROUP(HBRGROUP)

* Define the Link to Liberty program
 DEFINE PROGRAM(HBRCJVMS)       GROUP(HBRGROUP)        JVM(YES)
      JVMSERVER(HBRJVM)
      JVMCLASS(wlp:com.ibm.rules.hbr.cics.wlp.HBRCJVMS#doExecution)
      EXECKEY(CICS)
      STATUS(ENABLED)          CEDF(NO)              DATALOCATION(ANY)
      CONCURRENCY(REQUIRED)
      DESCRIPTION(IBM Decision Server for zOS)

 DEFINE PROGRAM(HBRCSTUP)       GROUP(HBRGROUP)        JVM(YES)
      JVMSERVER(HBRJVM)
      JVMCLASS(wlp:com.ibm.rules.hbr.cics.wlp.HBRCSTUP#doSetup)
      EXECKEY(CICS)
      STATUS(ENABLED)          CEDF(NO)              DATALOCATION(ANY)
      CONCURRENCY(REQUIRED)
      DESCRIPTION(IBM Decision Server for zOS)

 DEFINE PROGRAM(HBRCTERM)       GROUP(HBRGROUP)        JVM(YES)
      JVMSERVER(HBRJVM)
      JVMCLASS(wlp:com.ibm.rules.hbr.cics.wlp.HBRCTERM#doTermination)
      EXECKEY(CICS)
      STATUS(ENABLED)          CEDF(NO)              DATALOCATION(ANY)
      CONCURRENCY(REQUIRED)
      DESCRIPTION(IBM Decision Server for zOS)
/*
//*
