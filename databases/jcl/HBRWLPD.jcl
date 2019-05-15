//HBRWLPD JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2014,2017"                                                  *
//* crc="86917632" >                                                   *
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
//* This job deploys the server configuration from the work path to    *
//* the Liberty server directory                                       *
//*                                                                    *
//* If the server already exists then the deploy will STOP. This       *
//* behaviour is controlled by the fifth parameter to hbrwlpd.sh. If   *
//* you would like to overwrite the existing server with the new files,*
//* change the parameter STOP to OVERWRITE                             *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//* Copy the configuration files to the server directory               *
//**********************************************************************
//HBRWLPD EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATCH SH . +
  ++HBRINSTPATH+++
  /zexecutionserver/bin/hbrwlpd.sh +
  ++HBRINSTPATH++ +
  ++HBRWORKPATH++ +
  ++WLPUSERDIR++ +
  ++WLPSERVER++ +
  STOP
/*
