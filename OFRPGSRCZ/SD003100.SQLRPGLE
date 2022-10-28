     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2013')
      *****************************************************************
/*STD *  RPGSQLBND                                                    *
/*EXI *  TEXT('Midas OF Initialisation program for CGL146')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD003100 - Midas OF Initialisation program for CGL146        *
      *             Network Descriptions File                         *
      *                                                               *
      *  (c) Finastra International Limited 2013                      *
      *                                                               *
      *  Last Amend No. MD058830           Date 01Oct21               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CGL146   *CREATE   Date 10Jul13               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD058830 - Deliverable Data Split for SDNWRKPD               *
      *  MD046248 - Finastra Rebranding                               *
      *  CGL146 - MT940/MT950 Production in Input Cycle               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7 - Database Error                                        *
      *    U8 - Database Error                                        *
      *    LR - Last record found                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ =======  ==========================  ¦
      ** +--------------------------------------+

     D LDA           E DS                  EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details

      ** +--------------------------------------+
      ** ¦ D-specs: Named constants             ¦
      ** ¦ =======  ===============             ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
     D WRun            S              1A   Inz

      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      ** Write to Network Descriptions Extension File

     C/exec SQL
     C**Insert*into SDNWRK1D                                                                MD058830
     C+ Insert into SDNW1CTD                                                                MD058830
     C+  (
     C+    EDNWR1, EDNET1,
     C+    EDP940, EDA940,
     C+    EDP950, EDA950
     C+  )
     C+ select
     C+    EDNWRK, EDNETD,
     C+    'N',    'N',
     C+    'N',    'N'
     C**From*SDNWRKPD where                                                                 MD058830
     C+ From SDNWKCTD where                                                                 MD058830
     C+    EDNWRK not in
     C+    (
     C+     select EDNWR1
     C******from SDNWRK1D                                                                   MD058830
     C+     from SDNW1CTD                                                                   MD058830
     C+    )
     C/end-exec

      ** Handle SQL Error

     C                   If        SQLCOD < 0
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = 1
     C                   EVAL      DBFILE = 'SQL STM'
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   EndIf


     C/exec SQL                                                                             MD058830
     C+ Insert into SDNW1BTD                                                                MD058830
     C+  (                                                                                  MD058830
     C+    EDNWR1, EDNET1,                                                                  MD058830
     C+    EDP940, EDA940,                                                                  MD058830
     C+    EDP950, EDA950                                                                   MD058830
     C+  )                                                                                  MD058830
     C+ select                                                                              MD058830
     C+    EDNWRK, EDNETD,                                                                  MD058830
     C+    'N',    'N',                                                                     MD058830
     C+    'N',    'N'                                                                      MD058830
     C+ From SDNWKBTD where                                                                 MD058830
     C+    EDNWRK not in                                                                    MD058830
     C+    (                                                                                MD058830
     C+     select EDNWR1                                                                   MD058830
     C+     from SDNW1BTD                                                                   MD058830
     C+    )                                                                                MD058830
     C/end-exec                                                                             MD058830
                                                                                            MD058830
      ** Handle SQL Error                                                                   MD058830
                                                                                            MD058830
     C                   If        SQLCOD < 0                                               MD058830
     C     *LOCK         IN        LDA                                                      MD058830
     C                   EVAL      DBASE = 1                                                MD058830
     C                   EVAL      DBFILE = 'SQL STM'                                       MD058830
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD058830
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD058830
     C                   OUT       LDA                                                      MD058830
     C                   EXSR      *PSSR                                                    MD058830
     C                   EndIf                                                              MD058830
                                                                                            MD058830
     C/exec SQL                                                                             MD058830
     C+ Insert into SDNW1XTD                                                                MD058830
     C+  (                                                                                  MD058830
     C+    EDNWR1, EDNET1,                                                                  MD058830
     C+    EDP940, EDA940,                                                                  MD058830
     C+    EDP950, EDA950                                                                   MD058830
     C+  )                                                                                  MD058830
     C+ select                                                                              MD058830
     C+    EDNWRK, EDNETD,                                                                  MD058830
     C+    'N',    'N',                                                                     MD058830
     C+    'N',    'N'                                                                      MD058830
     C+ From SDNWKXTD where                                                                 MD058830
     C+    EDNWRK not in                                                                    MD058830
     C+    (                                                                                MD058830
     C+     select EDNWR1                                                                   MD058830
     C+     from SDNW1XTD                                                                   MD058830
     C+    )                                                                                MD058830
     C/end-exec                                                                             MD058830
                                                                                            MD058830
      ** Handle SQL Error                                                                   MD058830
                                                                                            MD058830
     C                   If        SQLCOD < 0                                               MD058830
     C     *LOCK         IN        LDA                                                      MD058830
     C                   EVAL      DBASE = 1                                                MD058830
     C                   EVAL      DBFILE = 'SQL STM'                                       MD058830
     C                   EVAL      DBKEY = 'SQLSTT : ' + SQLSTT                             MD058830
     C                                   + ';  SQLCOD : ' + %char(SQLCOD)                   MD058830
     C                   OUT       LDA                                                      MD058830
     C                   EXSR      *PSSR                                                    MD058830
     C                   EndIf                                                              MD058830
                                                                                            MD058830
      ** End Program

     C                   EVAL      *INLR = *ON
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program exception error routine                      *
      *                                                               *
      *  Called By: Automatically if a program error occurs,          *
      *             or directly by the program code using EXSR.       *
      *             This subroutine DUMPs the program just once.      *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR

     C                   IF        WRun = *BLANKS

     C                   EVAL      WRun = 'Y'
     C                   DUMP

     C                   CALL      'DBERRCTL'

     C                   ENDIF

     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
