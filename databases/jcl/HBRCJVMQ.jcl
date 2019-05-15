//HBRCJVMQ JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="2813918937" >                                                 *
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
//* This job will create the CICS JVM Profile in the working directory *
//* for a CICS Liberty JVM server                                      *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//JVMPROF  EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATCH SH . +
  ++HBRINSTPATH+++
  /zexecutionserver/bin/hbrcjvm2.sh +
  ++HBRINSTPATH++ +
  ++HBRWORKPATH++ +
  ++HBRJAVAHOME++ +
  ++CICSAPPLID++
/*
//LIBCONF  EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATCH SH . +
  ++HBRINSTPATH+++
  /zexecutionserver/bin/hbrwlp2.sh +
  ++HBRINSTPATH++ +
  ++HBRWORKPATH++ +
  ++HBRJAVAHOME++ +
  ++CICSAPPLID++ +
  ++DB2JARLOCN++ +
  ++DB2NATIVELOC++ +
  ++DB2LOCATION++ +
  ++DB2SCHEMA++ +
  ++DB2SUBSYSTEM++ +
  ++DB2SERVNAME++ +
  ++DB2PORT++ +
  ++DB2USER++ +
  ++DB2PSWD++
 /*
