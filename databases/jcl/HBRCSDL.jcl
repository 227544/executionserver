//HBRCSDL JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="43771041" >                                                   *
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
//* This job will define the CICS resources requried by                *
//* ODM  when running inside the CICS Liberty JVM Server               *
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
 DEFINE JVMSERVER(HBRJVML)    GROUP(HBRGROUP)
        STATUS(ENABLED)
        JVMPROFILE(HBRJVML)
        LERUNOPTS(DFHAXRO)
        THREADLIMIT(15)
*
 DEFINE DB2CONN(++DB2LOCATION++)        GROUP(HBRGROUP)
        AUTHID(++DB2USER++)         DB2GROUPID(++DB2SUBSYSTEM++)
        PLAN(++JDBCPLAN++)

*
* Use this configuration if you are not using DB2 Group Attach
*
* DEFINE DB2CONN(++DB2LOCATION++)        GROUP(HBRGROUP)
*        AUTHID(++DB2USER++)         DB2ID(++DB2SUBSYSTEM++)
*        PLAN(++JDBCPLAN++)
/*
//*
