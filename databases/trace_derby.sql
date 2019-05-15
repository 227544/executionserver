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
DROP TABLE EXECUTION_TRACES;

CREATE TABLE EXECUTION_TRACES (
  ID INT GENERATED ALWAYS AS IDENTITY (START WITH 1, INCREMENT BY 1) NOT NULL,
  TIME_STAMP BIGINT,
  LOCATION VARCHAR(2000),
  REQUEST_PATH VARCHAR(2000) NOT NULL,
  CANONICAL_PATH VARCHAR(2000) NOT NULL,
  RULESET_PROPERTIES CLOB,
  ELAPSED_TIME BIGINT,
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
  EXECUTION_ID VARCHAR(255) NOT NULL,
  FULL_EXECUTION_TRACE CLOB,
  CONSTRAINT ET_PK PRIMARY KEY (ID),
  CONSTRAINT EID_UNQ UNIQUE (EXECUTION_ID)
);
