//HBRWLPR JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2014,2017"                                                  *
//* crc="2824274649" >                                                 *
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
//* This is an example job showing how to set up the EJBROLEs needed   *
//* when using ODM with 'Liberty'                                      *
//* and permit groups to the newly created EJBROLES                    *
//* The commands to add users to the appropriate groups is not given   *
//*                                                                    *
//* Default format for EJBROLE:                                        *
//*      profile_prefix.resource.role                                  *
//* e.g  BBGZDFLT.res.resAdministrators                                *
//*                                                                    *
//**********************************************************************
//* RACF definitions for your LIBERTY instalation                      *
//*                                                                    *
//* You need RACF SPECIAL to run this, and you should customise as     *
//* needed to follow any local securtiy conventions                    *
//*                                                                    *
//* 1) change ++WLPSAFPREF++ as needed for your liberty profile prefix *
//*                                                                    *
//* After the Roles and Groups have been set up                        *
//* connect users to the groups                                        *
//* e.g. CONNECT adam GROUP(RESADM)                                    *
//*                                                                    *
//* After these commands a RACLIST REFRESH will be required            *
//* e.g. SETR RACLIST(EJBROLE) REFRESH                                 *
//* This sample permits groups to the res console profiles             *
//*                                                                    *
//* You will need to permit the appropriate groups for the testing     *
//* and DecisionRunner profiles                                        *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* Configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//WASRACF  EXEC   PGM=IKJEFT01,REGION=0M
//SYSPRINT DD     SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD     *
 RDEF EJBROLE   ++WLPSAFPREF++.res.resAdministrators
 RDEF EJBROLE   ++WLPSAFPREF++.res.resDeployers
 RDEF EJBROLE   ++WLPSAFPREF++.res.resMonitors
 RDEF EJBROLE   ++WLPSAFPREF++.testing.resAdministrators
 RDEF EJBROLE   ++WLPSAFPREF++.testing.resDeployers
 RDEF EJBROLE   ++WLPSAFPREF++.DecisionRunner.resAdministrators
 RDEF EJBROLE   ++WLPSAFPREF++.DecisionRunner.resDeployers
 ADDGROUP RESADM  DATA('RES admin group')
 ADDGROUP RESDEP  DATA('RES deploy group')
 ADDGROUP RESMON  DATA('RES monitor group')
 SETR RACLIST(EJBROLE) REFR
 PE ++WLPSAFPREF++.res.resAdministrators CLASS(EJBROLE) +
     ID(RESADM) ACCESS(READ)
 PE ++WLPSAFPREF++.res.resDeployers CLASS(EJBROLE) +
     ID(RESDEP) ACCESS(READ)
 PE ++WLPSAFPREF++.res.resMonitors CLASS(EJBROLE) +
     ID(RESMON) ACCESS(READ)
 PE ++WLPSAFPREF++.testing.resAdministrators CLASS(EJBROLE) +
     ID(RESADM) ACCESS(READ)
 PE ++WLPSAFPREF++.testing.resDeployers CLASS(EJBROLE) +
     ID(RESDEP) ACCESS(READ)
 PE ++WLPSAFPREF++.DecisionRunner.resAdministrators CLASS(EJBROLE) +
     ID(RESADM) ACCESS(READ)
 PE ++WLPSAFPREF++.DecisionRunner.resDeployers CLASS(EJBROLE) +
     ID(RESDEP) ACCESS(READ)
 SETR RACLIST(EJBROLE) REFR
/*
