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
/*
 * NOTES :
 * 1) HAVE TO CREATE AN INDEX ON THE FOREIGN KEY BEFORE CREATING IT FOR REAL (BUG#3491)
 * 2) MAX SIZE FOR VARCHAR IS 255.
 */

DROP INDEX RULESETS_IDX ON RULESETS;
DROP TABLE IF EXISTS RULEAPP_PROPERTIES;
DROP TABLE IF EXISTS RULESET_PROPERTIES;
DROP TABLE IF EXISTS RULESET_RESOURCES;
DROP TABLE IF EXISTS RULESETS;
DROP TABLE IF EXISTS RULEAPPS;

SET sql_mode='STRICT_ALL_TABLES';

CREATE TABLE IF NOT EXISTS RULEAPPS (
  ID INT NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(255) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  CREATION_DATE BIGINT NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  DESCRIPTION VARCHAR(255),
  CONSTRAINT RA_PK PRIMARY KEY (ID),
  CONSTRAINT RA_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RULESETS (
  ID INT NOT NULL AUTO_INCREMENT,
  NAME VARCHAR(255) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  CREATION_DATE BIGINT NOT NULL,
  DISPLAY_NAME VARCHAR(255),
  DESCRIPTION VARCHAR(255),
  RULEAPP_ID INT NOT NULL,
  INDEX RS_FKEY_IDX (RULEAPP_ID),
  CONSTRAINT RS_PK PRIMARY KEY (ID),
  CONSTRAINT RS_FK FOREIGN KEY (RULEAPP_ID) REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
  CONSTRAINT RS_UNIQUE UNIQUE (RULEAPP_ID, NAME, MAJOR_VERSION, MINOR_VERSION)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RULEAPP_PROPERTIES (
  ID INT NOT NULL AUTO_INCREMENT,
  RULEAPP_ID INT NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  VALUE TEXT NOT NULL,
  INDEX RA_PROPS_FKEY (RULEAPP_ID),
  CONSTRAINT RA_PROPS_PK PRIMARY KEY (ID),
  CONSTRAINT RA_PROPS_FK FOREIGN KEY (RULEAPP_ID) REFERENCES RULEAPPS (ID) ON DELETE CASCADE,
  CONSTRAINT RA_PROPS_UN UNIQUE (RULEAPP_ID, NAME)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RULESET_PROPERTIES (
  ID INT NOT NULL AUTO_INCREMENT,
  RULESET_ID INT NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  VALUE TEXT NOT NULL,
  INDEX RS_PROPS_FKEY (RULESET_ID),
  CONSTRAINT RS_PROPS_PK PRIMARY KEY (ID),
  CONSTRAINT RS_PROPS_FK FOREIGN KEY (RULESET_ID) REFERENCES RULESETS (ID) ON DELETE CASCADE,
  CONSTRAINT RS_PROPS_UN UNIQUE (RULESET_ID, NAME)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS RULESET_RESOURCES (
  ID INT NOT NULL AUTO_INCREMENT,
  RULESET_ID INT NOT NULL,
  ARCHIVE LONGBLOB NOT NULL,
  INDEX RS_RES_FKEY (RULESET_ID),
  CONSTRAINT RULESETS_RESOURCES_PK PRIMARY KEY (ID),
  CONSTRAINT RULESETS_RESOURCES_FK FOREIGN KEY (RULESET_ID) REFERENCES RULESETS (ID) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE INDEX RULESETS_IDX ON RULESETS (NAME, MAJOR_VERSION, MINOR_VERSION);