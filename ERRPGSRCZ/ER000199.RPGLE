     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2009')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas ER BAIS Module Mapping Table Take-on')           *
      *****************************************************************
      *                                                               *
      *  Midas - European Reporting Module                            *
      *                                                               *
      *  ER000199 - Midas ER BAIS Module Mapping Take-On              *
      *                                                               *
      *  Function:  This program populates the BAIS Module mapping    *
      *             table with default values                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2009            *
      *                                                               *
      *  Last Amend No. CER059             Date 19Jul10               *
      *  Prev Amend No. CER045  *CREATE    Date 20Jul09               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER045 - German Features - Reporting Bundesbank              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    LR - Last record indicator (program termination)           *
      *    U7 and U8 - DB error processing indicator                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  *INZSR    - Initialise                                       *
      *  *PSSR     - Error processing                                 *
      *                                                               *
      *****************************************************************
 
      ** Midas ER Account Code Decision Table
 
     FERBMODPD  UF A E           K DISK    INFSR(*PSSR)
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
     D X               DS
     D  XModule1                      2A   INZ('FX')
     D  XModule2                      2A   INZ('MM')
     D  XModule3                      2A   INZ('LE')
     D  XModule4                      2A   INZ('RE')
     D XMODULE                        2A   OVERLAY(X) DIM(4)
 
     D Y               DS
     D  YModule1                      2A   INZ('  ')
     D  YModule2                      2A   INZ('GH')
     D  YModule3                      2A   INZ('KR')
     D  YModule4                      2A   INZ('KK')
     D YMODULE                        2A   OVERLAY(Y) DIM(4)
 
     D Idx             S              3S 0
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      * MAIN PROCEDURE                                                *
      *                                                               *
      *****************************************************************
 
      ** Populate BAIS Module Mapping File
 
 
     C                   FOR       Idx = 1 TO %ELEM(XMODULE)
 
     C                   EVAL      M1MMOD = XMODULE(Idx)
     C                   EVAL      M1BAMO = YMODULE(Idx)
 
     C                   WRITE     ERBMODD0
 
     C                   ENDFOR
 
     C                   EVAL      *INLR = *ON
 
     C                   RETURN
 
      *****************************************************************
      /SPACE 5
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** Initialise LDA
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBASE = *ZEROS
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY = *BLANKS
     C                   EVAL      DBPGM = 'ER000199'
     C                   OUT       LDA
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Program Exception Error Routine                      *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
 
     C                   ENDSR
 
