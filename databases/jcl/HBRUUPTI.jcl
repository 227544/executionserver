//HBRUUPTI JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="1435015292" >                                                 *
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
//* This is a sample job to customize the SHBRJCL, SHHBRPROC, SHBRPARM *
//* and SHBRWASC libraries when creating instance libraries            *
//*                                                                    *
//* Change the following parameter before running this job:            *
//*                                                                    *
//*     ++HBRHLQ++ = The installation datasets                         *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//         SET HBRHLQ=++HBRHLQ++
//HBRUUPTI EXEC PGM=IKJEFT01,REGION=2M,DYNAMNBR=99
//SYSPROC  DD DISP=SHR,DSN=&HBRHLQ..SHBREXEC
//INCNTRL  DD DISP=SHR,DSN=&HBRHLQ..SHBRPARM(HBRCTRL)
//INLINES  DD DISP=SHR,DSN=&HBRHLQ..SHBRPARM(HBRINST)
//SYSTSIN  DD *
 %HBRUUPTE
//SYSTSPRT DD SYSOUT=*
