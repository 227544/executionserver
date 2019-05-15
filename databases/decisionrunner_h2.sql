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


DROP INDEX SCE_INDEX IF EXISTS;
DROP INDEX CHK_INDEX IF EXISTS;
DROP TABLE SCENARIOSUITEELEMENT IF EXISTS;
DROP TABLE CHECKPOINTDATA IF EXISTS;
DROP TABLE STEPSTATUS IF EXISTS;
DROP TABLE JOBSTATUS IF EXISTS;
DROP TABLE STEPEXECUTIONINSTANCEDATA IF EXISTS;
DROP TABLE EXECUTIONINSTANCEDATA IF EXISTS;
DROP TABLE JOBINSTANCEDATA IF EXISTS;


CREATE TABLE SCENARIOSUITEELEMENT (
  ID 				BIGINT NOT NULL IDENTITY,
  JOB_EXECUTION_ID 	BIGINT NOT NULL,
  ELEMENT_ID 		VARCHAR(100) NOT NULL,
  ELEMENT_TYPE 		CHAR(1) NOT NULL,
  ELEMENT_CONTENT 	BLOB,
  CONSTRAINT SSE_UNIQUE UNIQUE (JOB_EXECUTION_ID, ELEMENT_ID, ELEMENT_TYPE)
);

--
-- Job informmations tables
--
CREATE TABLE JOBINSTANCEDATA(
  jobinstanceid BIGINT NOT NULL IDENTITY,
  name		VARCHAR(512), 
  apptag VARCHAR(512)
);

CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid 	BIGINT NOT NULL IDENTITY,
  jobinstanceid BIGINT,
  createtime	TIMESTAMP,
  starttime		TIMESTAMP,
  endtime		TIMESTAMP,
  updatetime	TIMESTAMP,
  parameters	BLOB,
  batchstatus	VARCHAR(512),
  exitstatus	VARCHAR(512),
  CONSTRAINT JOBINST_JOBEXEC_FK FOREIGN KEY (jobinstanceid) REFERENCES JOBINSTANCEDATA (jobinstanceid)
 );
 
 CREATE TABLE STEPEXECUTIONINSTANCEDATA(
	stepexecid 			BIGINT NOT NULL IDENTITY,
	jobexecid			BIGINT,
	batchstatus         VARCHAR(512),
    exitstatus			VARCHAR(512),
    stepname			VARCHAR(512),
	readcount			INTEGER,
	writecount			INTEGER,
	commitcount         INTEGER,
	rollbackcount		INTEGER,
	readskipcount		INTEGER,
	processskipcount	INTEGER,
	filtercount			INTEGER,
	writeskipcount		INTEGER,
	startTime           TIMESTAMP,
	endTime             TIMESTAMP,
	persistentData		BLOB,
	CONSTRAINT JOBEXEC_STEPEXEC_FK FOREIGN KEY (jobexecid) REFERENCES EXECUTIONINSTANCEDATA (jobexecid)
);

CREATE TABLE JOBSTATUS (
  id BIGINT PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT JOBSTATUS_JOBINST_FK FOREIGN KEY (id) REFERENCES JOBINSTANCEDATA (jobinstanceid) ON DELETE CASCADE
);

CREATE TABLE STEPSTATUS(
  id BIGINT PRIMARY KEY,
  obj		BLOB,
  CONSTRAINT STEPSTATUS_STEPEXEC_FK FOREIGN KEY (id) REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid) ON DELETE CASCADE
);

CREATE TABLE CHECKPOINTDATA(
  id		VARCHAR(512),
  obj		BLOB
);

CREATE INDEX SCE_INDEX ON SCENARIOSUITEELEMENT(JOB_EXECUTION_ID, ELEMENT_ID, ELEMENT_TYPE);
CREATE INDEX CHK_INDEX ON CHECKPOINTDATA(id);
