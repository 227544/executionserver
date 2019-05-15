//HBRDSRCF JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="3728970290" >                                                 *
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
//* This is an example job showing how to set up the EJBROLES needed   *
//* and permit groups to the newley created EJBROLES                   *
//*                                                                    *
//* The commands to add users to the appropriate groups is not given   *
//*                                                                    *
//* Note: <++EJBHLQ++> can be blank. If so, check there is no leading  *
//*       . at the start of the profile name                           *
//*                                                                    *
//* After the Roles and Groups have been set up, connect users to the  *
//* groups                                                             *
//* e.g. CONNECT adam GROUP(RESADM)                                    *
//*                                                                    *
//* After these commands a RACLIST REFRESH will be required            *
//* e.g. SETR RACLIST(EJBROLE) REFRESH                                 *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//WASRACF  EXEC   PGM=IKJEFT01,REGION=0M
//SYSPRINT DD     SYSOUT=*
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD     *
 RDEF EJBROLE ++EJBHLQ++.resAdministrators
 RDEF EJBROLE ++EJBHLQ++.resDeployers
 RDEF EJBROLE ++EJBHLQ++.resMonitors
 ADDGROUP RESADM   DATA('RES admin group')
 ADDGROUP RESDEP   DATA('RES deployers group')
 ADDGROUP RESMON   DATA('RES monitor group')
 PE ++EJBHLQ++.resAdministrators CLASS(EJBROLE) ID(RESADM) ACCESS(READ)
 PE ++EJBHLQ++.resDeployers   CLASS(EJBROLE) ID(RESDEP)   ACCESS(READ)
 PE ++EJBHLQ++.resMonitors    CLASS(EJBROLE) ID(RESMON)   ACCESS(READ)
/*
