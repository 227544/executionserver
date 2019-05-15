//HBRDSGRN JOB MSGCLASS=A,MSGLEVEL=(1,1),NOTIFY=&SYSUID
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2009,2017"                                                  *
//* crc="2852353589" >                                                 *
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
//* This is an example job to issue grants for the                     *
//* Rule Execution Server tables.                                      *
//*                                                                    *
//* If you have not run the HBRDSCTR job you won't have the tables     *
//* from EXECUTION_TRACES onwards                                      *
//*                                                                    *
//* If there are other stogroups, issue grants for these as well       *
//* if there are other databases, issue grants for these as well       *
//*                                                                    *
//* Note: ++variables++ in this job will be substituted with the       *
//* values specified in the HBRINST member as part of the              *
//* configuration process. See the documentation for more details.     *
//*                                                                    *
//* Expected return code: 0                                            *
//*                                                                    *
//**********************************************************************
//*
//HBRDSGRN EXEC PGM=IKJEFT01,REGION=0M
//STEPLIB  DD DISP=SHR,DSN=++DB2HLQ++.SDSNEXIT
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOAD
//         DD DISP=SHR,DSN=++DB2HLQ++.SDSNLOD2
//         DD DISP=SHR,DSN=++DB2RUNLIB++
//SYSTSPRT DD SYSOUT=*
//SYSPRINT DD SYSOUT=*
//SYSUDUMP DD SYSOUT=*
//SYSTSIN  DD *
 DSN SYSTEM(++DB2SUBSYSTEM++)
 RUN -
   PROGRAM(++DB2SAMPLEPROGRAM++) -
   PLAN(++DB2SAMPLEPROGRAMPLAN++)-
   LIBRARY('++DB2RUNLIB++')
 END
//SYSIN    DD *
 SET CURRENT SCHEMA='++DB2SCHEMA++';
 SET CURRENT SQLID ='++DB2ADMIN++';
  GRANT ALL ON TABLE RULEAPPS                TO ++DB2GROUP++;
  GRANT ALL ON TABLE RULESETS                TO ++DB2GROUP++;
  GRANT ALL ON TABLE RULEAPP_PROPERTIES      TO ++DB2GROUP++;
  GRANT ALL ON TABLE RULESET_PROPERTIES      TO ++DB2GROUP++;
  GRANT ALL ON TABLE RULESET_RESOURCES       TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_RULESET_RESOURCES   TO ++DB2GROUP++;
  GRANT ALL ON TABLE XOM_RESOURCES           TO ++DB2GROUP++;
  GRANT ALL ON TABLE XOM_LIBRARIES           TO ++DB2GROUP++;
  GRANT ALL ON TABLE XOM_LIBRARY_VALUES      TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_XOM_RESOURCES       TO ++DB2GROUP++;
  GRANT ALL ON TABLE RS_ENABLED_VIEW         TO ++DB2GROUP++;
  GRANT ALL ON TABLE EXECUTION_TRACES        TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_RS_PROPS   TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_USER_DATA  TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_RULES      TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_TASKS      TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_ETT        TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_EXOUT      TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_INPARAMS   TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_OUTPARAMS  TO ++DB2GROUP++;
  GRANT ALL ON TABLE AUX_EX_TRACE_FULLET     TO ++DB2GROUP++;
  GRANT ALL ON TABLE SCENARIOSUITEELEMENT    TO ++DB2GROUP++;
  GRANT ALL ON TABLE CHECKPOINTDATA          TO ++DB2GROUP++;
  GRANT ALL ON TABLE STEPSTATUS              TO ++DB2GROUP++;
  GRANT ALL ON TABLE JOBSTATUS               TO ++DB2GROUP++;
  GRANT ALL ON TABLE STEPEXECUTIONINSTANCEDATA TO ++DB2GROUP++;
  GRANT ALL ON TABLE EXECUTIONINSTANCEDATA   TO ++DB2GROUP++;
  GRANT ALL ON TABLE JOBINSTANCEDATA         TO ++DB2GROUP++;

/*
//
