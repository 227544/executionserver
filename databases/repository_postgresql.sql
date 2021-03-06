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
DROP INDEX RULESETS_IDX;
DROP VIEW RS_ENABLED_VIEW;
DROP TABLE RULEAPP_PROPERTIES;
DROP TABLE RULESET_PROPERTIES;
DROP TABLE RULESET_RESOURCES;
DROP TABLE RULESETS;
DROP TABLE RULEAPPS;

CREATE TABLE RULEAPPS (
  ID SERIAL8,
  NAME VARCHAR(256) NOT NULL,
  MAJOR_VERSION INT4 NOT NULL,
  MINOR_VERSION INT4 NOT NULL,
  CREATION_DATE INT8 NOT NULL,
  DISPLAY_NAME VARCHAR(256),
  DESCRIPTION VARCHAR(256),
  CONSTRAINT RA_PK PRIMARY KEY (ID),
  CONSTRAINT RA_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
);

CREATE TABLE RULESETS (
  ID SERIAL8,
  NAME VARCHAR(256) NOT NULL,
  MAJOR_VERSION INT4 NOT NULL,
  MINOR_VERSION INT4 NOT NULL,
  CREATION_DATE INT8 NOT NULL,
  DISPLAY_NAME VARCHAR(256),
  DESCRIPTION VARCHAR(256),
  RULEAPP_ID INT8 NOT NULL,
  CONSTRAINT RS_PK PRIMARY KEY (ID),
  CONSTRAINT RS_UNIQUE UNIQUE (RULEAPP_ID, NAME, MAJOR_VERSION, MINOR_VERSION),
  CONSTRAINT RS_FK FOREIGN KEY (RULEAPP_ID)
      REFERENCES RULEAPPS (ID) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE RULEAPP_PROPERTIES (
  ID SERIAL8,
  RULEAPP_ID INT8 NOT NULL,
  NAME VARCHAR(256) NOT NULL,
  VALUE VARCHAR(2000) NOT NULL,
  CONSTRAINT RA_PROPS_PK PRIMARY KEY (ID),
  CONSTRAINT RA_PROPS_UN UNIQUE (RULEAPP_ID, NAME),
  CONSTRAINT RA_PROPS_FK FOREIGN KEY (RULEAPP_ID)
      REFERENCES RULEAPPS (ID) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE RULESET_PROPERTIES (
  ID SERIAL8,
  RULESET_ID INT8 NOT NULL,
  NAME VARCHAR(256) NOT NULL,
  VALUE VARCHAR(2000) NOT NULL,
  CONSTRAINT RS_PROPS_PK PRIMARY KEY (ID),
  CONSTRAINT RS_PROPS_UN UNIQUE (RULESET_ID, NAME),
  CONSTRAINT RS_PROPS_FK FOREIGN KEY (RULESET_ID)
      REFERENCES RULESETS (ID) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE TABLE RULESET_RESOURCES (
  ID SERIAL8,
  RULESET_ID INT8 NOT NULL,
  ARCHIVE BYTEA NOT NULL,
  CONSTRAINT RS_RES_PK PRIMARY KEY (ID),
  CONSTRAINT RS_RES_FK FOREIGN KEY (RULESET_ID)
      REFERENCES RULESETS (ID) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE CASCADE
);

CREATE VIEW RS_ENABLED_VIEW AS
SELECT RA.ID AS RA_ID, RA.NAME AS RA_NAME, RA.MAJOR_VERSION AS RA_MAJVERS, RA.MINOR_VERSION AS RA_MINVERS,
       RS.ID AS RS_ID, RS.NAME AS RS_NAME, RS.MAJOR_VERSION AS RS_MAJVERS, RS.MINOR_VERSION AS RS_MINVERS
FROM RULEAPPS RA, RULESETS RS, RULESET_PROPERTIES P
WHERE RS.RULEAPP_ID = RA.ID AND RS.ID = P.RULESET_ID
AND P.NAME = 'ruleset.status' AND P.VALUE = 'enabled';
