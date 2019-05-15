//HBRCJCFG JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2013,2017"                                                  *
//* crc="1410908806" >                                                 *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2013, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* This job will create the configuration files that are required to  *
//* run a Rule Execution Server inside a Java Batch environment.       *
//*                                                                    *
//* Valid parameters for com.ibm.rules.hbr.common.RESSetupZ            *
//*    -Dhbrworkpath=/work/path                                        *
//*    -Dhbrinstpath=/inst/path                                        *
//*    -Dverbose=true/false (logging level)                            *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//HBRCJCFG EXEC PGM=IKJEFT01,REGION=0M,TIME=NOLIMIT
//         SET  HBRWDS=++HBRWORKDS++
//HBRENVPR DD   DISP=SHR,DSN=&HBRWDS..SHBRPARM(HBRBATCH)
//         DD   DISP=SHR,DSN=&HBRWDS..SHBRPARM(HBRPSIST)
//         DD   DISP=SHR,DSN=&HBRWDS..SHBRPARM(HBRCMMN)
//SYSTSPRT DD  SYSOUT=*
//STDOUT   DD  SYSOUT=*
//STDERR   DD  SYSOUT=*
//SYSTSIN  DD  *
  BPXBATSL PGM +
  ++HBRJAVAHOME+++
  /bin/java -classpath +
  ++HBRINSTPATH+++
  /zexecutionserver/lib/hbr.jar:+
  ++HBRINSTPATH+++
  /executionserver/lib/jrules-res-setup.jar:+
  ++HBRINSTPATH+++
  /executionserver/lib/jrules-res-tools.jar:+
  ++HBRINSTPATH+++
  /executionserver/lib/jrules-res-execution.jar:+
  ++HBRINSTPATH+++
  /executionserver/lib/jrules-engine.jar +
  -Dhbrworkpath=+
  ++HBRWORKPATH++ +
  -Dhbrinstpath=+
  ++HBRINSTPATH++ +
  -Dverbose=false -Xmx256m -Xms256m +
  com.ibm.rules.hbr.setup.RESSetupZ
/*
