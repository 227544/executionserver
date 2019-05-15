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
CREATE TABLE TMP_EXECUTION_TRACES (
  ID NUMERIC(10, 0) IDENTITY NOT NULL,
  TIME_STAMP NUMERIC(15, 0) NULL,
  LOCATION TEXT NULL,
  REQUEST_PATH TEXT NOT NULL,
  CANONICAL_PATH TEXT NOT NULL,
  RULESET_PROPERTIES TEXT NULL,
  ELAPSED_TIME NUMERIC(15, 0) NULL,
  USER_DATA TEXT NULL,
  NB_RULES INT NULL,
  NB_RULES_FIRED INT NULL,
  NB_RULES_NOT_FIRED INT NULL,
  NB_TASKS INT NULL,
  NB_TASKS_EXECUTED INT NULL,
  NB_TASKS_NOT_EXECUTED INT NULL,
  RULES TEXT NULL,
  TASKS TEXT NULL,
  EXECUTION_TRACE_TREE TEXT NULL,
  EXEC_OUTPUT TEXT NULL,
  INPUT_PARAMS TEXT NULL,
  OUTPUT_PARAMS TEXT NULL,
  EXECUTION_ID VARCHAR(255) NOT NULL,
  FULL_EXECUTION_TRACE TEXT NULL,  
  CONSTRAINT ET_PK PRIMARY KEY (ID),
  CONSTRAINT EID_UNQ UNIQUE (EXECUTION_ID)
);

INSERT INTO TMP_EXECUTION_TRACES(TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE) 
	SELECT TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE 
	FROM EXECUTION_TRACES;

DROP TABLE EXECUTION_TRACES;

CREATE TABLE EXECUTION_TRACES (
  ID NUMERIC(10, 0) IDENTITY NOT NULL,
  TIME_STAMP NUMERIC(15, 0) NULL,
  LOCATION TEXT NULL,
  REQUEST_PATH TEXT NOT NULL,
  CANONICAL_PATH TEXT NOT NULL,
  RULESET_PROPERTIES TEXT NULL,
  ELAPSED_TIME NUMERIC(15, 0) NULL,
  USER_DATA TEXT NULL,
  NB_RULES INT NULL,
  NB_RULES_FIRED INT NULL,
  NB_RULES_NOT_FIRED INT NULL,
  NB_TASKS INT NULL,
  NB_TASKS_EXECUTED INT NULL,
  NB_TASKS_NOT_EXECUTED INT NULL,
  RULES TEXT NULL,
  TASKS TEXT NULL,
  EXECUTION_TRACE_TREE TEXT NULL,
  EXEC_OUTPUT TEXT NULL,
  INPUT_PARAMS TEXT NULL,
  OUTPUT_PARAMS TEXT NULL,
  EXECUTION_ID VARCHAR(255) NOT NULL,
  FULL_EXECUTION_TRACE TEXT NULL,  
  CONSTRAINT ET_PK PRIMARY KEY (ID),
  CONSTRAINT EID_UNQ UNIQUE (EXECUTION_ID)
);

INSERT INTO EXECUTION_TRACES(TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE) 
	SELECT TIME_STAMP, LOCATION, REQUEST_PATH, CANONICAL_PATH, RULESET_PROPERTIES,  ELAPSED_TIME, USER_DATA, NB_RULES, NB_RULES_FIRED, NB_RULES_NOT_FIRED, NB_TASKS, NB_TASKS_EXECUTED, NB_TASKS_NOT_EXECUTED, RULES, TASKS, EXECUTION_TRACE_TREE, EXEC_OUTPUT, INPUT_PARAMS, OUTPUT_PARAMS, EXECUTION_ID, FULL_EXECUTION_TRACE 
	FROM TMP_EXECUTION_TRACES;

DROP TABLE TMP_EXECUTION_TRACES;