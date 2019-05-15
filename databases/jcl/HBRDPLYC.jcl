//HBRDPLYC JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2014,2017"                                                  *
//* crc="2698047742" >                                                 *
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
//* This job will deploy the miniloan rule app and associated jars     *
//* directly to a RES Console and all connectect zRES instances will   *
//* be notified of the new version of the rule application.            *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//HBRDPLYC EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
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
  CONSOLE +
  -DHBRINSTPATH=++HBRINSTPATH++ +
  -DHBRWORKPATH=++HBRWORKPATH++ +
  -DRULEAPPNAME=MiniLoanDemo +
  -DRULESETNAME=MiniLoanDemo +
  -DLIBNAME=MiniLoanDemoRuleApp_1.0 +
  -DCONSOLEHOSTNAME=++HBRCONSOLECOMHOST++ +
  -DCONSOLEPORT=++HBRPORT++ +
  -DCONSOLEUSERID=++RESDEPLOYUSER++ +
  -DCONSOLEPASSWORD=++RESDEPLOYUSER++
/*
