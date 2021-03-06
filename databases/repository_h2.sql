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
DROP INDEX RULESETS_IDX IF EXISTS;
DROP VIEW RS_ENABLED_VIEW IF EXISTS;
DROP TABLE RULEAPP_PROPERTIES IF EXISTS;
DROP TABLE RULESET_PROPERTIES IF EXISTS;
DROP TABLE RULESET_RESOURCES IF EXISTS;
DROP TABLE RULESETS IF EXISTS;
DROP TABLE RULEAPPS IF EXISTS;

CREATE TABLE RULEAPPS (
  ID INT NOT NULL IDENTITY,
  NAME VARCHAR(256) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  CREATION_DATE BIGINT NOT NULL,
  DISPLAY_NAME VARCHAR(256),
  DESCRIPTION VARCHAR(256),
  CONSTRAINT RA_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
);

CREATE TABLE RULESETS (
  ID INT NOT NULL IDENTITY,
  NAME VARCHAR(256) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  CREATION_DATE BIGINT NOT NULL,
  DISPLAY_NAME VARCHAR(256),
  DESCRIPTION VARCHAR(256),
  RULEAPP_ID INT NOT NULL,
  CONSTRAINT RS_FK FOREIGN KEY (RULEAPP_ID) REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
  CONSTRAINT RS_UNIQUE UNIQUE (RULEAPP_ID, NAME, MAJOR_VERSION, MINOR_VERSION)
);

CREATE TABLE RULEAPP_PROPERTIES (
  ID INT NOT NULL IDENTITY,
  RULEAPP_ID INT NOT NULL,
  NAME VARCHAR(256) NOT NULL,
  VALUE VARCHAR(2000) NOT NULL,
  CONSTRAINT RA_PROPS_FK FOREIGN KEY (RULEAPP_ID) REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
  CONSTRAINT RA_PROPS_UN UNIQUE (RULEAPP_ID, NAME)
);

CREATE TABLE RULESET_PROPERTIES (
  ID INT NOT NULL IDENTITY,
  RULESET_ID INT NOT NULL,
  NAME VARCHAR(256) NOT NULL,
  VALUE VARCHAR(2000) NOT NULL,
  CONSTRAINT RS_PROPS_FK FOREIGN KEY (RULESET_ID) REFERENCES RULESETS (ID) ON DELETE CASCADE,
  CONSTRAINT RS_PROPS_UN UNIQUE (RULESET_ID, NAME)
);

CREATE TABLE RULESET_RESOURCES (
  ID INT NOT NULL IDENTITY,
  RULESET_ID INT NOT NULL,
  ARCHIVE LONGVARBINARY NOT NULL,
  CONSTRAINT RS_RES_FK FOREIGN KEY (RULESET_ID) REFERENCES RULESETS (ID) ON DELETE CASCADE
);

CREATE INDEX RULESETS_IDX ON RULESETS (NAME, MAJOR_VERSION, MINOR_VERSION);

CREATE VIEW RS_ENABLED_VIEW AS
SELECT RA.ID AS RA_ID, RA.NAME AS RA_NAME, RA.MAJOR_VERSION AS RA_MAJVERS, RA.MINOR_VERSION AS RA_MINVERS,
       RS.ID AS RS_ID, RS.NAME AS RS_NAME, RS.MAJOR_VERSION AS RS_MAJVERS, RS.MINOR_VERSION AS RS_MINVERS
FROM RULEAPPS RA, RULESETS RS, RULESET_PROPERTIES P
WHERE RS.RULEAPP_ID = RA.ID AND RS.ID = P.RULESET_ID
AND P.NAME = 'ruleset.status' AND P.VALUE = 'enabled';
