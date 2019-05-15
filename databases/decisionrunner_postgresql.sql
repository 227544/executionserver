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
  ID 				SERIAL8,
  JOB_EXECUTION_ID 	BIGINT NOT NULL,
  ELEMENT_ID 		VARCHAR(100) NOT NULL,
  ELEMENT_TYPE 		CHAR(1) NOT NULL,
  ELEMENT_CONTENT 	BYTEA,
  CONSTRAINT RV_VALS_RT PRIMARY KEY (ID)
);





CREATE TABLE JOBINSTANCEDATA(
  jobinstanceid		serial not null PRIMARY KEY,
  name		character varying (512), 
  apptag VARCHAR(512)
);

CREATE TABLE EXECUTIONINSTANCEDATA(
  jobexecid		serial not null PRIMARY KEY,
  jobinstanceid	bigint not null REFERENCES JOBINSTANCEDATA (jobinstanceid),
  createtime	timestamp,
  starttime		timestamp,
  endtime		timestamp,
  updatetime	timestamp,
  parameters	bytea,
  batchstatus		character varying (512),
  exitstatus		character varying (512)
);
  
CREATE TABLE STEPEXECUTIONINSTANCEDATA(
	stepexecid			serial not null PRIMARY KEY,
	jobexecid			bigint not null REFERENCES EXECUTIONINSTANCEDATA (jobexecid),
	batchstatus         character varying (512),
    exitstatus			character varying (512),
    stepname			character varying (512),
	readcount			integer,
	writecount			integer,
	commitcount         integer,
	rollbackcount		integer,
	readskipcount		integer,
	processskipcount	integer,
	filtercount			integer,
	writeskipcount		integer,
	startTime           timestamp,
	endTime             timestamp,
	persistentData		bytea
); 

CREATE TABLE JOBSTATUS (
  id		bigint not null,
  obj		bytea,
  CONSTRAINT JOBSTATUS_FK FOREIGN KEY (id) REFERENCES JOBINSTANCEDATA (jobinstanceid) MATCH SIMPLE ON DELETE CASCADE
);

CREATE TABLE STEPSTATUS(
  id		bigint not null,
  obj		bytea,
  CONSTRAINT STEPSTATUS_FK FOREIGN KEY (id) REFERENCES STEPEXECUTIONINSTANCEDATA (stepexecid) MATCH SIMPLE ON DELETE CASCADE
);

CREATE TABLE CHECKPOINTDATA(
  id		character varying (512),
  obj		bytea
);

 
