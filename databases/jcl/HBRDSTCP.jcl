//HBRDSTCP JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2014,2017"                                                  *
//* crc="3792038740" >                                                 *
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
//*                                                                    *
//* This job will repackage the RES console ear file for use with      *
//* TCP/IP.                                                            *
//*                                                                    *
//* The job below is customized for WAS V8.5. If you would like to     *
//* customize this job for WAS V8.0, change the following:             *
//*    - WebSphere85 to WebSphere8                                     *
//*    - WAS85 to WAS8                                                 *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//HBRDSTCP EXEC PGM=IKJEFT01,REGION=0M
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD  *
 BPXBATCH SH +
 cd ++HBRINSTPATH++; +
 . zexecutionserver/bin/hbrdstcp.sh +
 ++HBRJAVAHOME++ +
 shared/tools/ant +
 -Dconsole.ear.in=+
 executionserver/applicationservers/WebSphere85+
 /jrules-res-management-WAS85.ear -Dconsole.ear.out=+
 ++HBRWORKPATH+++
 /jrules-res-management-WAS85_TCPIP.ear +
 -Dmanagement.protocol=tcpip +
 -Dmanagement.tcpip.port=++HBRCONSOLECOMPORT++
 /*

