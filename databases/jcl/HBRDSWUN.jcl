//HBRDSWUN JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="2130874599" >                                                 *
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
//* This job will uninstall the Rule Execution Server (RES) from       *
//* WebSphere Application Server                                       *
//*                                                                    *
//* PLEASE NOTE !!!!                                                   *
//*   This job may attempt to restart the WAS Server                   *
//*                                                                    *
//**********************************************************************
//*                                                                    *
//* The install security type ++SECURITYTYPE++ will be substituted to  *
//* one of the following                                               *
//*                                                                    *
//*   WAS  (to enable WAS based Security and install artefacts)        *
//*                                                                    *
//*   RACF (to install with WAS RACF Security, already set up and      *
//*          enabled on the WAS system for RES)                        *
//*                                                                    *
//* Note: only choose the RACF option if WAS has been configured for   *
//*       local/RACF security, with EJBRoles mapped etc.               *
//*                                                                    *
//* If a Dmgr is installed, set the dmgrpath variable                  *
//*                                                                    *
//* If the path length is too long use continuation character +        *
//* and continue the rest of the path on the next line                 *
//*  e.g.                                                              *
//* -Ddmgrpath=/WebSphere/V7ILGDM/+                                    *
//* DeploymentManager/profiles/default +                               *
//*                                                                    *
//* The file ++HBRWORKDS++.SHBRWASC(HBRRES) should include the         *
//* location of the RES ear and rar files and location specific values *
//*                                                                    *
//* The following values need to be updated for your local system      *
//*   -Dproperties    Points to the res properties file                *
//*   -Dprofile       WAS server instance profile (default)            *
//*   -Dcellname      WAS server instance cell name                    *
//*   -Dnodename      WAS server instance node name                    *
//*   -Dservername    WAS server instance name eg. Server1             *
//*   -Dusername      WAS server administration userid                 *
//*   -Dpassword      WAS server administration password               *
//*   -Ddb.username   DB2 user name                                    *
//*   -Ddb.password   DB2 password                                     *
//*   -Dinstpath       Path to ODM install                             *
//*   -Ddmgrpath      Path to dmgr bin directory (if managed server)   *
//*   -DsecurityType  JRules uses WAS or RACF based security           *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//*                                                                    *
//* PLEASE NOTE !!!!                                                   *
//*   This job may attempt to restart the WAS Server                   *
//*                                                                    *
//**********************************************************************
//COPYPROF EXEC PGM=IKJEFT01,
//         PARM='OCOPY INDD(BIPFROM) OUTDD(BIPPROF)'
//SYSTSPRT DD DUMMY
//BIPFROM  DD DSN=++HBRWORKDS++.SHBRWASC(HBRRES),
//            DISP=SHR
//BIPPROF  DD PATHOPTS=(OWRONLY,OCREAT,OTRUNC),
//            PATHMODE=(SIRWXU,SIRWXG),
// PATH='++HBRWORKPATH++/config/was/res.properties'
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
 shared/tools/scripts/res/build.xml +
 -Dproperties=++HBRWORKPATH++/config/was/res.properties +
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
 -Ddmgrpath=++DMGRPATH++ +
 undo
/*
