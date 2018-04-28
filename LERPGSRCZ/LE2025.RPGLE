     H DEBUG FIXNBR(*INPUTPACKED)
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas LE Check PC Reference is valid')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2025 - Check that PC Reference is unique                   *
      *                                                               *
      *  Function:                                                    *
      *                                                               *
      *  This program will check whether a PC Reference is unique     *
      *  within the transaction files that have PC references         *
      *  For a non-unique PC Reference it will return an error message*
      *  indicating that a duplicate exists in Midas                  *
      *                                                               *
      *  Called By:                                                   *
      *                                                               *
      *  LEC2025 - Check that PC References in Midas are unique       *
      *  LE2010M - Loan Manager Branch Server Interface Job           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 209692 *CREATE     Date 19Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  209692 - Ensure that new transactions always have a unique   *
      *           PCRF (PC reference) by checking LF/LEPCRFL1         *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    90         Record not found                                *
      *    91         File not found                                  *
      *                                                               *
      *----------------------------------------------------------------
      *  U7 U8 LR                                                     *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      *                                                               *
      *****************************************************************
      * Lending Transaction PC References
     FLEPCRFL1  IF   E           K DISK    INFDS(FSDS)
      *
      **********************************************************************
      /EJECT
      **********************************************************************
      *
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **
     D FSDS            DS
     D  RCDFMT               261    270
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
      *
 
     D @RUN            S              1
      *
      **********************************************************************
      *
     C     *DTAARA       DEFINE                  LDA
     C     *ENTRY        PLIST
     C                   PARM                    PCRF             15
     C                   PARM                    TYPE              4
     C                   PARM                    RTCODE            9
     C                   PARM                    ERRMSG           78
      *
      * Check for invalid PCRF
      *
     C     TYPE          IFNE      'ROLL'
     C     ' '           SCAN      PCRF          POS               2 0
     C     POS           IFNE      0
     C                   MOVEL     PCRF          MSGDTA          132
     C                   CALL      'SDC1460'                              90
     C                   PARM      'LEX9994'     MSGID             7
     C                   PARM      'LERMSGF'     MSGF             10
     C                   PARM                    MSGDTA
     C                   PARM                    TXT             132
     C                   PARM                    TXT2            512
      *
      * Set up return parameters
      *
     C                   MOVEL     'INVALID'     RTCODE
     C                   MOVEL     TXT           ERRMSG
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
      *
      * If no blanks found, check for duplicate PCRF
      *
     C     PCRF          CHAIN     LEPCRFL1                           9091
     C     *IN91         IFEQ      *ON
      *
      ** Data base error (file not found)
      *
     C     *LOCK         IN        LDA
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      DBFILE =  'LEPCRFL1'
     C                   EVAL      DBKEY  =  'PCRF'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EVAL      DBPROC =  'SR/MAIN'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C     *IN90         IFEQ      *OFF
      *
      * Duplicate found so check which file it was found in
      *
     C                   SELECT
     C     RCDFMT        WHENEQ    'LEPCRFF0'
     C                   MOVEL     'FCLTYFM'     DUPFILE           8
     C     RCDFMT        WHENEQ    'LEPCRFF1'
     C                   MOVEL     'LEFCAMPD'    DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF2'
     C                   MOVEL     'CLOANCL'     DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF3'
     C                   MOVEL     'LOAMSDK'     DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF4'
     C                   MOVEL     'CLOANCK'     DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF5'
     C                   MOVEL     'LEFEED'      DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF6'
     C                   MOVEL     'LEFEEAD'     DUPFILE
     C     RCDFMT        WHENEQ    'LEPCRFF7'
     C                   MOVEL     'LEPARTPD'    DUPFILE
     C                   ENDSL
      *
      * Set up duplicate PCRF error message
      *
     C                   MOVE      ' (        '  TEMPSTR          25
     C                   MOVE      DUPFILE       TEMPSTR
     C                   MOVEL     PCRF          TEMPSTR
     C                   MOVEL     TEMPSTR       MSGDTA          132
     C                   CALL      'SDC1460'                              90
     C                   PARM      'LEX9993'     MSGID             7
     C                   PARM      'LERMSGF'     MSGF             10
     C                   PARM                    MSGDTA
     C                   PARM                    TXT             132
     C                   PARM                    TXT2            512
      *
      * Set up return parameters
      *
     C                   MOVE      'DUPLICATE'   RTCODE
     C                   MOVEL     TXT           ERRMSG
     C                   ENDIF
      *
     C                   RETURN
      /EJECT
      *********************************************************************
      *                                                                   *
      * *PSSR  - Program exception error routine                          *
      *          Called automatically if a program error occurs,          *
      *          or directly by the program code using EXSR.              *
      *          This subroutine DUMPs the program just once.             *
      *                                                                   *
      * Called by: (**calling routines**)                                 *
      *                                                                   *
      * Calls: None                                                       *
      *                                                                   *
      *********************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
     C                   CALL      'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
