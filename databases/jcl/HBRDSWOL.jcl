//HBRDSWOL JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="2822551529" >                                                 *
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
//* This job will define a WOLA load library dataset using the wola    *
//* files shipped with Liberty.                                        *
//*                                                                    *
//* If run with a WebSphere Application Server WOLA configuration, the *
//* WOLA EJBs will also be installed into that server (for a Liberty   *
//* server this step is not required and will be skipped)              *
//*                                                                    *
//* PLEASE NOTE !!!!                                                   *
//*   This job will attempt to restart the WAS Server                  *
//*                                                                    *
//**********************************************************************
//*                                                                    *
//* If a Dmgr is installed, set the dmgrpath variable                  *
//*                                                                    *
//*                                                                    *
//* If the path length is too long use continuation character +        *
//* and continue the rest of the path on the next line                 *
//*  e.g.                                                              *
//* -Ddmgrpath=/WebSphere/V7ILGDM/+                                    *
//* DeploymentManager/profiles/default +                               *
//*                                                                    *
//*                                                                    *
//* The following values need to be updated for your local system      *
//*  -Dproperties  Points to the RES properties file                   *
//*  -Dprofile     WAS server instance profile (default)               *
//*  -Dcellname    WAS server instance cell name (HBRWOLA for liberty) *
//*  -Dnodename    WAS server instance node name                       *
//*  -Dservername  WAS server instance name eg. Server1                *
//*  -Dusername    WAS server administration userid                    *
//*  -Dpassword    WAS server administration password                  *
//*  -Dinstpath    Path to the product install location                *
//*  -Ddmgrpath    Path to dmgr bin directory (if managed server)      *
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
//CRWOLDS  EXEC PGM=IEFBR14
//WOLALIB  DD  DISP=(MOD,CATLG),DSN=++HBRWOLALOADLIB++,
//             SPACE=(TRK,(35,2,10)),UNIT=SYSALLDA,
//             DCB=(RECFM=U,LRECL=0,BLKSIZE=32760,DSORG=PO),
//             DSNTYPE=LIBRARY
//*
//WOLACP EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSIN  DD *
    BPXBATCH SH cp -X +
 ++HBRINSTPATH++/+
 zexecutionserver/wlp/clients/zos/* +
 "//'++HBRWOLALOADLIB++'"
/*
//INSTRAR EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSIN  DD *
    BPXBATCH SH if [ ++HBRWOLACELL++ != HBRWOLA ];then;+
 ++WASINSTPATH++/+
 bin/wsadmin.sh +
 -user ++ADMINUSER++ +
 -password ++ADMINPSWD++ +
 -lang jython -f +
 ++WASINSTPATH++/+
 util/zos/OLASamples/olaRar.py +
 ++CELLNAME++ +
 ++NODENAME++; else;echo Skipping RAR installation as +
 not applicable to Liberty;fi
/*
//INSTO EXEC PGM=IKJEFT01,REGION=0M
//SYSTSPRT DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//SYSTSIN  DD *
    BPXBATCH SH if [ ++HBRWOLACELL++ != HBRWOLA ];then;+
 cp +
 "//'++HBRWORKDS++.SHBRWASC(HBRRES)'" +
 ++HBRWORKPATH+++
 /config/was/res.properties;+
 ++WASINSTPATH++/+
 bin/setupCmdLine.sh; +
 ++WASINSTPATH++/+
 bin/ws_ant.sh +
  -f +
 ++HBRINSTPATH++/+
 shared/tools/scripts/wola/build.xml +
 -Dproperties=++HBRWORKPATH++/config/was/res.properties +
 -Dprofile=default             +
 -Dcellname=++CELLNAME++       +
 -Dnodename=++NODENAME++       +
 -Dservername=++WASSERVERNAME++  +
 -Dusername=++ADMINUSER++     +
 -Dpassword=++ADMINPSWD++     +
 -Dinstpath=++HBRINSTPATH++   +
 -Ddmgrpath=++DMGRPATH++; else;echo Skipping WOLA web application +
 installation as not applicable to Liberty;fi
/*
