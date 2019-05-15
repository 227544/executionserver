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
DROP TRIGGER XOM_LIBRARIES_TRIGGER;
DROP INDEX XOM_RESOURCES.XOM_RESOURCES_IDX;
DROP INDEX XOM_LIBRARIES.XOM_LIBRARIES_IDX;
DROP TABLE XOM_LIBRARY_VALUES;
DROP TABLE XOM_RESOURCES;
DROP TABLE XOM_LIBRARIES;

CREATE TABLE XOM_LIBRARIES (
  ID NUMERIC(10, 0) IDENTITY NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  CREATION_DATE NUMERIC(15, 0) NOT NULL,
  CONSTRAINT XL_PK PRIMARY KEY (ID),
  CONSTRAINT XL_UNIQUE UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION)
);

CREATE TABLE XOM_RESOURCES (
  ID NUMERIC(10, 0) IDENTITY NOT NULL,
  NAME VARCHAR(255) NOT NULL,
  MAJOR_VERSION INT NOT NULL,
  MINOR_VERSION INT NOT NULL,
  SHA1 VARCHAR(40) NOT NULL,
  CREATION_DATE NUMERIC(15, 0) NOT NULL,
  DATA IMAGE NOT NULL,
  CONSTRAINT XR_PK PRIMARY KEY (ID),
  CONSTRAINT XR_UNIQUE1 UNIQUE (NAME, MAJOR_VERSION, MINOR_VERSION),
  CONSTRAINT XR_UNIQUE2 UNIQUE (NAME, SHA1)
);

CREATE TABLE XOM_LIBRARY_VALUES (
  ID NUMERIC(10, 0) IDENTITY NOT NULL,
  LIBRARY_ID  NUMERIC(10, 0) NOT NULL,
  URL VARCHAR(255) NOT NULL,
  CONSTRAINT XL_VLS_PK PRIMARY KEY (ID),
  CONSTRAINT XL_VLS_UN UNIQUE (LIBRARY_ID, URL)
);

CREATE INDEX XOM_LIBRARIES_IDX ON XOM_LIBRARIES (NAME, MAJOR_VERSION, MINOR_VERSION);

CREATE INDEX XOM_RESOURCES_IDX ON XOM_RESOURCES (NAME, SHA1);

CREATE TRIGGER XOM_LIBRARIES_TRIGGER
ON XOM_LIBRARIES 
FOR DELETE AS 
BEGIN 
    DELETE XOM_LIBRARY_VALUES FROM XOM_LIBRARY_VALUES, deleted 
    WHERE deleted.ID = XOM_LIBRARY_VALUES.LIBRARY_ID
END;