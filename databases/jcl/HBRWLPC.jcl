//HBRWLPC JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2014,2017"                                                  *
//* crc="85876141" >                                                   *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2014, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//* This job creates a working Liberty server configuration in the     *
//* work path. Once the configuration is created, you must submit      *
//* HBRWLPD to deploy the configuration to the server directory.       *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//* Copy the properties                                                *
//**********************************************************************
//COPYPROP EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(WLPFROM) OUTDD(WLPPROP)'
//SYSTSPRT DD DUMMY
//WLPFROM  DD DSN=++HBRWORKDS++.SHBRWLPC(HBRWLPB),
//            DISP=SHR
//WLPPROP  DD PATHOPTS=(OWRONLY,OCREAT,OTRUNC),
//            PATHMODE=(SIRWXU,SIRWXG),
// PATH='++HBRWORKPATH++/config/wlp/hbrwlpb.ebcdic'
//SYSTSIN  DD DUMMY
//**********************************************************************
//* Copy the JVM parameters                                            *
//**********************************************************************
//COPYPROP EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(WLPFROM) OUTDD(WLPJVM)'
//SYSTSPRT DD DUMMY
//WLPFROM  DD DSN=++HBRWORKDS++.SHBRWLPC(HBRWLPJ),
//            DISP=SHR
//WLPJVM  DD PATHOPTS=(OWRONLY,OCREAT,OTRUNC),
//            PATHMODE=(SIRWXU,SIRWXG),
// PATH='++HBRWORKPATH++/config/wlp/hbrwlpj.ebcdic'
//SYSTSIN  DD DUMMY
//**********************************************************************
//* Generate the required server configuration files                   *
//**********************************************************************
//HBRWLPC EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATCH SH . +
  ++HBRINSTPATH+++
  /zexecutionserver/bin/hbrwlpc.sh +
  ++HBRINSTPATH++ +
  ++HBRWORKPATH++ +
  ++HBRJAVAHOME++ +
  ++WLPSERVER++ +
  ++WLPTYPE++ +
  ++HBRCONSOLECOMPORT++ +
  ++HBRPERSISTENCETYPE++ +
  ++DB2HLQ++ +
  ++WLPVERSION++
/*
