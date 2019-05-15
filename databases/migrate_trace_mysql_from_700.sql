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
ALTER TABLE EXECUTION_TRACES MODIFY EXECUTION_ID VARCHAR(255) NOT NULL;
ALTER TABLE EXECUTION_TRACES ADD CONSTRAINT EID_UNQ UNIQUE (EXECUTION_ID);