//HBRDPLOY JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="864951962" >                                                  *
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
//* This job will deploy the miniloan rule app and associated jars.    *
//* Any zRES instances must be restarted to pickup the new version of  *
//* the rule application.                                              *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//HBRDPLOY EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATCH SH +
  cd ++HBRINSTPATH+++
  /zexecutionserver/samples/ruleApps; +
  . deploy.sh +
  ++HBRJAVAHOME++ +
  ++HBRINSTPATH+++
  /shared/tools/ant +
  ++HBRPERSISTENCETYPE++ +
  -DHBRINSTPATH=++HBRINSTPATH++ +
  -DHBRWORKPATH=++HBRWORKPATH++ +
  -DRULEAPPNAME=MiniLoanDemo +
  -DLIBNAME=MiniLoanDemoRuleApp_1.0 +
  -DDB2SERVNAME=++DB2SERVNAME++ +
  -DDB2PORT=++DB2PORT++ +
  -DDB2LOCATION=++DB2LOCATION++ +
  -DDB2SCHEMA=++DB2SCHEMA++ +
  -DDB2USER=++DB2USER++ +
  -DDB2PASSWORD=++DB2PSWD++ +
  -DDB2JARLOCN=++DB2JARLOCN++
/*
