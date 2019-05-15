//HBRCRECL JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2012,2017"                                                  *
//* crc="3922927387" >                                                 *
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
//* This job will create the classes for the security setup.           *
//*                                                                    *
//* As supplied in this sample, the POSIT number for these classes     *
//* is 128. This value should be customized for your installation.     *
//*                                                                    *
//* More information on POSIT values can be found in Security Server   *
//* RACF Security Administrator's Guide.                               *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//CRESEC   EXEC PGM=IKJEFT01
//SYSTSPRT DD SYSOUT=*
//SYSABEND DD SYSOUT=*
//SYSTSIN  DD *

RDEFINE CDT HBRADMIN UACC(NONE) +
   CDTINFO(DEFAULTUACC(NONE) FIRST(ALPHA NUMERIC) MAXLENGTH(64) +
   POSIT(128) OTHER(ALPHA,NATIONAL,NUMERIC,SPECIAL) +
   RACLIST(ALLOWED))
RDEFINE CDT HBRCONN UACC(NONE) +
   CDTINFO(DEFAULTUACC(NONE) FIRST(ALPHA NUMERIC) MAXLENGTH(64) +
   POSIT(128) OTHER(ALPHA,NATIONAL,NUMERIC,SPECIAL) +
   RACLIST(ALLOWED))
RDEFINE CDT HBRCMD UACC(NONE) +
   CDTINFO(DEFAULTUACC(NONE) FIRST(ALPHA NUMERIC) MAXLENGTH(64) +
   POSIT(128) OTHER(ALPHA,NATIONAL,NUMERIC,SPECIAL) +
   RACLIST(ALLOWED))
SETROPTS RACLIST(CDT) REFRESH
SETROPTS CLASSACT(HBRADMIN)
SETROPTS CLASSACT(HBRCONN)
SETROPTS CLASSACT(HBRCMD)
/*
