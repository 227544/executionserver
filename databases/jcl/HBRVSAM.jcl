//HBRVSAM JOB
//         JCLLIB ORDER=(PP.COBOL390.V410.SIGYPROC)
//**********************************************************************
//* <copyright                                                         *
//* notice="lm-source-program"                                         *
//* pids="5655-Y31"                                                    *
//* years="2011,2017"                                                  *
//* crc="1878792353" >                                                 *
//* Licensed Materials - Property of IBM                               *
//*                                                                    *
//* 5655-Y31                                                           *
//*                                                                    *
//* (C) Copyright IBM Corp. 2011, 2017 All Rights Reserved.            *
//*                                                                    *
//* US Government Users Restricted Rights - Use, duplication or        *
//* disclosure restricted by GSA ADP Schedule Contract with            *
//* IBM Corp.                                                          *
//* </copyright>                                                       *
//**********************************************************************
//*                                                                    *
//* This is a VSAM sample job that demonstrates how to create          *
//* simulations using VSAM datasets.                                   *
//*                                                                    *
//* This sample defines a custom scenario provider that reads COBOL    *
//* data from a VSAM dataset                                           *
//*                                                                    *
//* Please modify the JCLLIB ORDER line                                *
//*                   LNGPRFX line                                     *
//*                   LIBPRFX                                          *
//* to your sites cobol dataset                                        *
//* and modify the CLUSTER NAME to your sites naming convention        *
//*                                                                    *
//**********************************************************************
//CREATE   EXEC PGM=IDCAMS
//SYSPRINT DD   SYSOUT=*
//SYSIN    DD   *
    DEFINE CLUSTER  (NAME(VSAM.SAMPLE.DATA) -
                    RECORDS(200 50) -
                    RECORDSIZE(138 138) -
                    FREESPACE(10 15) -
                    KEYS(8 0) -
                    INDEXED)
/*
//CLGCOBOL EXEC PROC=IGYWCLG,
//           LNGPRFX=PP.COBOL390.V410,
//           LIBPRFX=CEE
//GO.DVSVSIN  DD DISP=SHR,DSN=VSAM.SAMPLE.DATA
//COBOL.SYSIN DD *
       IDENTIFICATION DIVISION.
       PROGRAM-ID.    PRGVSIN.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT   SECTION.
       FILE-CONTROL.

      *****************************************************************
           SELECT DVSVSIN-FILE
               ASSIGN       to DVSVSIN
               ORGANIZATION is indexed
               ACCESS MODE  is RANDOM
               RECORD KEY   is SCENARIO-ID
               FILE STATUS  is DVSVSIN-STATUS.

           SELECT DVSVSOUT-FILE
               ASSIGN       to DVSVSOUT
               ORGANIZATION is indexed
               ACCESS MODE  is RANDOM
               RECORD KEY   is APPROVED
               FILE STATUS  is DVSVSOUT-STATUS.

      *****************************************************************
       DATA DIVISION.
       FILE SECTION.

      *****************************************************************
       FD  DVSVSIN-FILE.
       01 SCENARIO.
         02  SCENARIO-ID PIC X(8).
         02  REQUEST.
           05  DRIVER.
               10  FIRST-NAME                PIC  X(20).
               10  LAST-NAME                 PIC  X(20).
               10  ZIPCODE                   PIC  X(8).
               10  HOUSE-NUM                 PIC  9(8).
               10  AGE                       PIC  9(2) USAGE COMP-3.
               10  LIC-DATE                  PIC  X(8).
               10  LIC-STATUS                PIC  X.
               10  NUMBER-ACCIDENTS          PIC  99.
           05  VEHICLE.
               10  VEC-ID                    PIC  X(15).
               10  MAKE                      PIC  X(20).
               10  MODEL                     PIC  X(20).
               10  VEC-VALUE                 USAGE COMP-1.
               10  VEC-TYPE                  PIC  X(2).
                   88 SUV     VALUE 'SU'.
                   88 SEDAN   VALUE 'SD'.
                   88 PICKUP  VALUE 'PU'.

       FD  DVSVSOUT-FILE.
       01  RESPONSE.
           05  APPROVED                      PIC  X.
           05  BASE-PRICE                    USAGE COMP-2.
           05  DIS-PRICE                     USAGE COMP-2.
           05  MSG-COUNT                     PIC 9(5)  VALUE 0.
           05  MESSAGES                      PIC  X(100)
                  OCCURS 0 TO 100 TIMES DEPENDING ON MSG-COUNT.

       WORKING-STORAGE SECTION.
      *****************************************************************
      *    Data-structure for Title and Copyright...
      *****************************************************************

       01  DVSVSIN-STATUS.
           05  DVSVSIN-STAT1      pic X.
           05  DVSVSIN-STAT2      pic X.

       01  DVSVSOUT-STATUS.
           05 DVSVSOUT-STAT1      pic X.
           05 DVSVSOUT-STAT2      pic X.

       01  IO-STATUS.
           05  IO-STAT1            pic X.
           05  IO-STAT2            pic X.
       01  TWO-BYTES.
           05  TWO-BYTES-LEFT      pic X.
           05  TWO-BYTES-RIGHT     pic X.
       01  TWO-BYTES-BINARY        redefines TWO-BYTES pic 9(4) comp.

       01  END-OF-FILE             pic X(3)    value 'NO '.

       01  CONSOLE-MESSAGE         pic X(48).

       01  VSAM-WRITE-ONLY         pic X       value 'N'.

       01  APPL-RESULT             pic S9(9)   comp.
           88  APPL-AOK            value 0.
           88  APPL-EOF            value 16.
       01 FLEN PIC 9(10) BINARY.
      *****************************************************************
       PROCEDURE DIVISION.
           COMPUTE FLEN = FUNCTION LENGTH(RESPONSE)
           DISPLAY "LEN:" FLEN
           MOVE 100 TO MSG-COUNT
           COMPUTE FLEN = FUNCTION LENGTH(RESPONSE)
           DISPLAY "LEN:" FLEN
           COMPUTE FLEN = FUNCTION LENGTH(SCENARIO)
           display "LEN:" FLEN

           perform DVSVSIN-OPEN.

           MOVE '00000001' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 28 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000002' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 82 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000003' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 56 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000004' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 21 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000005' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 14 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000006' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 66 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000007' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 39 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000008' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 23 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000009' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 79 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000010' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 71 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000011' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 57 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000012' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 65 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000013' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 30 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000014' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 42 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000015' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 36 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000016' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 57 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000017' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 28 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000018' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 31 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000019' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 48 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000020' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 64 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000021' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 28 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000022' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 53 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000023' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 9 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000024' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 46 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000025' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 2 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000026' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 20 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000027' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 57 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000028' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 56 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000029' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 28 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000030' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 18 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000031' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 63 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000032' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 76 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000033' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 69 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000034' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 31 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000035' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 11 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000036' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 76 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000037' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 60 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000038' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 3 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000039' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 81 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000040' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 74 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000041' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 79 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000042' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 74 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000043' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 20 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000044' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 34 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000045' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 27 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000046' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 1 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000047' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 71 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000048' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 31 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000049' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 17 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000050' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 68 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000051' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 80 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000052' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 53 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000053' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 1 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000054' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 7 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000055' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 84 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000056' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 10 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000057' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 77 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000058' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 78 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000059' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 2 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000060' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 4 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000061' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 72 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000062' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 1 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000063' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 72 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000064' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 73 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000065' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 47 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000066' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 83 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000067' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 70 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000068' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 58 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000069' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 33 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000070' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 56 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000071' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 48 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000072' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 41 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000073' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 41 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000074' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 44 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000075' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 55 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000076' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 6 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000077' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 34 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000078' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 83 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000079' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 37 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000080' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 49 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000081' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 24 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000082' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 2 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000083' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 2 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000084' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 55 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000085' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 48 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000086' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 37 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000087' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 45 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000088' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 62 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000089' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 29 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000090' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 69 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000091' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 51 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000092' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 58 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000093' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 13 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000094' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 68 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000095' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 81 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000096' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 33 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000097' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 76 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000098' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 23 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000099' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 30 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE
           MOVE '00000100' TO SCENARIO-ID
           MOVE 'JOHN' TO FIRST-NAME
           MOVE 'SMITH' TO LAST-NAME
           MOVE 'XA123456' TO ZIPCODE
           MOVE '123456' TO HOUSE-NUM
           MOVE 5 TO AGE
           MOVE '20110908' TO LIC-DATE
           MOVE 'F' TO LIC-STATUS
           MOVE 0 TO NUMBER-ACCIDENTS
           MOVE 'ABC12345678' TO VEC-ID
           MOVE 'BMW' TO MAKE
           MOVE 'GOLF' TO MODEL
           MOVE 2000000 TO VEC-VALUE
           MOVE 'SU' TO VEC-TYPE
           PERFORM DVSVSIN-WRITE

           perform DVSVSIN-CLOSE.

           GOBACK.

      *****************************************************************
      * Routines to do a read by KEY of the KSDS, VSAM Data Set. If   *
      * the read is successful then the record may be updated else a  *
      * new record may be added.                                      *
      *****************************************************************
       DVSVSIN-GET.
           read DVSVSIN-FILE
           if  DVSVSIN-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               if  DVSVSIN-STATUS = '10'
                   add 16 to ZERO giving APPL-RESULT
               else
                   add 12 to ZERO giving APPL-RESULT
               end-if
           end-if
           if  APPL-AOK
               CONTINUE
           else
               if  APPL-EOF
                   move 'YES' to END-OF-FILE
               end-if
           end-if
           exit.
      *---------------------------------------------------------------*
       DVSVSIN-WRITE.
           write SCENARIO
           if  DVSVSIN-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               if  DVSVSIN-STATUS = '10'
                   add 16 to ZERO giving APPL-RESULT
               else
                   add 12 to ZERO giving APPL-RESULT
               end-if
           end-if
           if  APPL-AOK
               CONTINUE
           else
               if  APPL-EOF
                   move 'YES' to END-OF-FILE
               else
                   move DVSVSIN-STATUS to IO-STATUS
                   perform Z-DISPLAY-IO-STATUS
                   perform Z-ABEND-PROGRAM
               end-if
           end-if
           exit.
      *---------------------------------------------------------------*
       DVSVSIN-REWRITE.
           REWRITE SCENARIO
           if  DVSVSIN-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               if  DVSVSIN-STATUS = '10'
                   add 16 to ZERO giving APPL-RESULT
               else
                   add 12 to ZERO giving APPL-RESULT
               end-if
           end-if
           if  APPL-AOK
               CONTINUE
           else
               if  APPL-EOF
                   move 'YES' to END-OF-FILE
               else
                   move DVSVSIN-STATUS to IO-STATUS
                   perform Z-DISPLAY-IO-STATUS
                   perform Z-ABEND-PROGRAM
               end-if
           end-if
           exit.
      *---------------------------------------------------------------*
       DVSVSIN-OPEN.
           add 8 to ZERO giving APPL-RESULT.
           open I-O DVSVSIN-FILE
           if  DVSVSIN-STATUS = '35'
               move 'Y' to VSAM-WRITE-ONLY
               open output DVSVSIN-FILE
           end-if
           if  DVSVSIN-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move DVSVSIN-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.
      *---------------------------------------------------------------*
       DVSVSIN-CLOSE.
           add 8 to ZERO giving APPL-RESULT.
           close DVSVSIN-FILE
           if  DVSVSIN-STATUS = '00'
               subtract APPL-RESULT from APPL-RESULT
           else
               add 12 to ZERO giving APPL-RESULT
           end-if
           if  APPL-AOK
               CONTINUE
           else
               move DVSVSIN-STATUS to IO-STATUS
               perform Z-DISPLAY-IO-STATUS
               perform Z-ABEND-PROGRAM
           end-if
           exit.

      *****************************************************************
      * The following Z-Routines perform administrative tasks         *
      * for this program.                                             *
      *****************************************************************
      *
      *****************************************************************
      * ABEND the program, post a message to the console and issue    *
      * a STOP RUN.                                                   *
      *****************************************************************
       Z-ABEND-PROGRAM.
           DISPLAY 'PROGRAM-IS-ABENDING...'

           add 12 to ZERO giving RETURN-CODE
           STOP RUN.

      *****************************************************************
      * Display the file status bytes. This routine will display as   *
      * two digits if the full two byte file status is numeric. If    *
      * second byte is non-numeric then it will be treated as a       *
      * binary number.                                                *
      *****************************************************************
       Z-DISPLAY-IO-STATUS.
           if  IO-STATUS not NUMERIC
           or  IO-STAT1 = '9'
               subtract TWO-BYTES-BINARY from TWO-BYTES-BINARY
               move IO-STAT2 to TWO-BYTES-RIGHT
               display 'FILE-STATUS-' IO-STAT1 '/'
                       TWO-BYTES-BINARY upon console
           else
               display 'FILE-STATUS-' IO-STATUS upon console
           end-if
           exit.

/*
