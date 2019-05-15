//HBRUARMP JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="587581577" >                                                  *
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
//* This is a sample job to define an ARM policy and create the        *
//* approriate RACF resources.                                         *
//*                                                                    *
//* Change YOUR_POL as required by your installation standards         *
//* (check with your zOS system administrator)                         *
//* You may require system administration authortity to do so.         *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//IXCMIAPU EXEC PGM=IXCMIAPU,REGION=2M
//SYSPRINT DD SYSOUT=*
//SYSIN    DD *
  DATA TYPE(ARM)
  DEFINE POLICY NAME(<YOUR_POL>) REPLACE(YES)
   LEVEL(2)
   RESTART_GROUP(SYSLVL2)
   ELEMENT(SYSHBRZR*)
/*
//RACF   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSABEND DD SYSOUT=*
//SYSTSIN  DD *
RDEFINE FACILITY IXCARM.SYSHBRZR.HBR_++HBRSSID++ UACC(NONE)
PERMIT IXCARM.SYSHBRZR.HBR_++HBRSSID++ CLASS(FACILITY)
       ID(userid)
       ACCESS(UPDATE)
SETROPTS CLASSACT(FACILITY)
/*
//
