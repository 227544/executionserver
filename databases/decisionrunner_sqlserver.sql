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

DROP TABLE SCENARIOSUITEELEMENT;
DROP TABLE CHECKPOINTDATA;
DROP TABLE STEPSTATUS;
DROP TABLE JOBSTATUS;
DROP TABLE STEPEXECUTIONINSTANCEDATA;
DROP TABLE EXECUTIONINSTANCEDATA;
DROP TABLE JOBINSTANCEDATA;

CREATE TABLE SCENARIOSUITEELEMENT (
  ID BIGINT IDENTITY (1,1) NOT NULL,
  JOB_EXECUTION_ID BIGINT NOT NULL,
  ELEMENT_ID NVARCHAR(100),
  ELEMENT_TYPE CHAR(1) NOT NULL,
  ELEMENT_CONTENT IMAGE,
  CONSTRAINT RV_VALS_SSE PRIMARY KEY (ID)
);

CREATE TABLE JOBINSTANCEDATA(
  jobinstanceid   BIGINT NOT NULL PRIMARY KEY IDENTITY,
  name    VARCHAR(512), 
  apptag VARCHAR(512)
);

CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid  BIGINT NOT NULL PRIMARY KEY IDENTITY, 
  jobinstanceid BIGINT,
  createtime  DATETIME,
  starttime   DATETIME,
  endtime   DATETIME,
  updatetime  DATETIME,
  parameters  IMAGE,
  batchstatus   VARCHAR(512),
  exitstatus    VARCHAR(512),
  CONSTRAINT JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES JOBINSTANCEDATA (jobinstanceid)
);

CREATE TABLE STEPEXECUTIONINSTANCEDATA(
  stepexecid BIGINT NOT NULL PRIMARY KEY IDENTITY, 
  jobexecid BIGINT,
  batchstatus         VARCHAR(512),
  exitstatus      VARCHAR(512),
  stepname      VARCHAR(512),
  readcount       INTEGER,
  writecount      INTEGER,
  commitcount     INTEGER,
  rollbackcount   INTEGER,
  readskipcount   INTEGER,
  processskipcount  INTEGER,
  filtercount       INTEGER,
  writeskipcount    INTEGER,
  startTime           DATETIME,
  endTime             DATETIME,
  persistentData    IMAGE,
  CONSTRAINT JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES EXECUTIONINSTANCEDATA (jobexecid)
);  

CREATE TABLE JOBSTATUS (
  id		BIGINT NOT NULL PRIMARY KEY,
  obj		IMAGE,
  CONSTRAINT JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
);

CREATE TABLE STEPSTATUS(
  id		BIGINT NOT NULL PRIMARY KEY,
  obj		IMAGE,
  CONSTRAINT STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE CHECKPOINTDATA(
  id		VARCHAR(512),
  obj		IMAGE
);