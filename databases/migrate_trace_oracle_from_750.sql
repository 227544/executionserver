--
--
-- Licensed Materials - Property of IBM
-- 5724X98 5724Y15 5655V82 5724X99 5724Y16 5655V89 5725B69 5655W88 5725C52 5655W90 5655Y31
-- Copyright IBM Corp. 1987, 2017 All Rights Reserved
-- US Government Users Restricted Rights - Use, duplication or
-- disclosure restricted by GSA ADP Schedule Contract with
-- IBM Corp.
--
--
ALTER TABLE EXECUTION_TRACES DROP CONSTRAINT ET_PK;
ALTER TABLE EXECUTION_TRACES DROP CONSTRAINT EID_UNQ;
ALTER TABLE EXECUTION_TRACES RENAME TO OLD_EXECUTION_TRACES;

CREATE TABLE EXECUTION_TRACES (
  ID INT NOT NULL,
  TIME_STAMP INT,
  LOCATION VARCHAR(2000),
  REQUEST_PATH VARCHAR(2000) NOT NULL,
  CANONICAL_PATH VARCHAR(2000) NOT NULL,
  RULESET_PROPERTIES CLOB,
  ELAPSED_TIME INT,
  USER_DATA CLOB,
  NB_RULES INT,
  NB_RULES_FIRED INT,
  NB_RULES_NOT_FIRED INT,
  NB_TASKS INT,
  NB_TASKS_EXECUTED INT,
  NB_TASKS_NOT_EXECUTED INT,
  RULES CLOB,
  TASKS CLOB,
  EXECUTION_TRACE_TREE CLOB,
  EXEC_OUTPUT CLOB,
  INPUT_PARAMS CLOB,
  OUTPUT_PARAMS CLOB,
  EXECUTION_ID VARCHAR(2000) NOT NULL,
  FULL_EXECUTION_TRACE CLOB,   
  CONSTRAINT ET_PK PRIMARY KEY (ID),
  CONSTRAINT EID_UNQ UNIQUE (EXECUTION_ID)
);

INSERT INTO EXECUTION_TRACES(ID, TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE) 
	SELECT ID, TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE 
	FROM OLD_EXECUTION_TRACES;

DROP TABLE OLD_EXECUTION_TRACES;
