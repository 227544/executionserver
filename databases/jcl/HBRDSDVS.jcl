//HBRDSDVS JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="1053054325" >                                                 *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2009, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* This job will install the Decision Validation Services (DVS) into  *
//* WebSphere Application Server                                       *
//*                                                                    *
//* If the path length is too long use continuation character +        *
//* and continue the rest of the path on the next line                 *
//*  e.g.                                                              *
//* -Ddmgrpath=/WebSphere/V7ILGDM/+                                    *
//* DeploymentManager/profiles/default +                               *
//*                                                                    *
//* The following values need to be updated for your local system      *
//*  -Dproperties    Points to the res properties file                 *
//*  -Dprofile       WAS server instance profile   (default)           *
//*  -Dcellname      WAS server instance cell name                     *
//*  -Dnodename      WAS server instance node name                     *
//*  -Dservername    WAS server instance name eg. Server1              *
//*  -Dusername      WAS server administration userid                  *
//*  -Dpassword      WAS server administration password                *
//*  -Ddb.username   DB2 user name                                     *
//*  -Ddb.password   DB2 password                                      *
//*  -Dinstpath      Path to ODM install                               *
//*  -Ddmgrpath      Path to dmgr bin directory (if managed server)    *
//*  -DsecurityType  JRules uses WAS or RACF based security            *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//COPYPROF EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(BIPFROM) OUTDD(BIPPROF)'
//SYSTSPRT DD DUMMY
//BIPFROM  DD DSN=++HBRWORKDS++.SHBRWASC(HBRDVS),
//            DISP=SHR
//BIPPROF  DD PATHOPTS=(OWRONLY,OCREAT,OTRUNC),
//            PATHMODE=(SIRWXU,SIRWXG),
// PATH='++HBRWORKPATH++/config/was/dvs.properties'
//SYSTSIN  DD DUMMY
//INSTO EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSIN  DD *
    BPXBATCH SH +
 ++WASINSTPATH++/+
 bin/setupCmdLine.sh; +
 ++WASINSTPATH++/+
 bin/ws_ant.sh +
  -f +
 ++HBRINSTPATH++/+
 shared/tools/scripts/dvs/build.xml +
 -Dproperties=++HBRWORKPATH++/config/was/dvs.properties +
 -Dprofile=default             +
 -Dcellname=++CELLNAME++       +
 -Dnodename=++NODENAME++       +
 -Dservername=++WASSERVERNAME++  +
 -Dusername=++ADMINUSER++     +
 -Dpassword=++ADMINPSWD++     +
 -Ddb.username=++DB2USER++    +
 -Ddb.password=++DB2PSWD++    +
 -Dinstpath=++HBRINSTPATH++   +
 -DsecurityType=++SECURITYTYPE++  +
 -Ddmgrpath=++DMGRPATH++
/*
