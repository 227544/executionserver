//HBROSREG JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="1845047753" >                                                 *
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
//* This JCL will create a link to the product specific registrar file.*
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//STEP1 EXEC PGM=IKJEFT01,REGION=0M
//SYSPRINT DD SYSOUT=*
//STDOUT   DD SYSOUT=*
//STDERR   DD SYSOUT=*
//STDENV   DD *
//SYSTSPRT DD SYSOUT=*
//SYSTSIN  DD  *
 BPXBATCH SH . +
 ++HBRINSTPATH+++
 /shared/bin/hbrregistrar.sh +
 ++HBRINSTPATH+++
 /shared/smf +
 ++WASINSTPATH++/properties/version +
 ODMStandard.registrar
/*
