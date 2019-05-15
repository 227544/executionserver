/*
 *
 * Licensed Materials - Property of IBM
 * 5724X98 5724Y15 5655V82 5724X99 5724Y16 5655V89 5725B69 5655W88 5725C52 5655W90 5655Y31
 * Copyright IBM Corp. 1987, 2017 All Rights Reserved
 * US Government Users Restricted Rights - Use, duplication or
 * disclosure restricted by GSA ADP Schedule Contract with
 * IBM Corp.
 *
 */
 
// ------------------------------------------------------------------------------------
//  This file is provided by IBM Decision Server
// ------------------------------------------------------------------------------------

In the same directory as this readme.txt you will find a sql file per database supported by the Rule Execution Server.

Theses scripts contain the database schema of the XOM repository for Rule Execution Server.

You will find the complete list of supported database in the documentation.

======================
Prerequisites
======================

   * The SQL scripts attempt to drop and create tables and indexes. Please, check that your database
     user has the corresponding rights before running these scripts.

   * For Oracle, in addition to tables and indexes, sequences and a view are also created. Please,
     also check that your database user has the corresponding rights before running these scripts.
   
   * For DB2, the Decision Warehouse database schema uses a buffer pool of 32k page size. The default name of the buffer pool
     is BP32K.
     

======================
How to use the scripts
======================

To use these SQL scripts, you just have to load them into a database tool that can execute SQL instructions.
Basically, each database provides such a tool :
   * 'ij' for Derby
   * 'command center' or 'command line processor' for IBM DB2
   * 'SqlTool' for Hypersonic HSQLDB
   * 'mysql' for MySQL
   * 'sqlplus' for Oracle
   * 'Pointbase console' for Pointbase
   * 'Query Tool' for SQL Server
   * 'isql' for Sybase

Please refer to the documentation of these tools for more information.

======================
Notes
======================

Concerning the schema, you can only change the RULESET_RESOURCES.NAME length. Other modifications are not supported (expect adding index).
