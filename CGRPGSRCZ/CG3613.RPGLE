     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *---------------------------------------------------------------*
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG Status of FTP Transmission')
      *---------------------------------------------------------------*
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3613 - Midas CG Status of FTP Transmission                 *
      *                                                               *
      *  Function:  This module will check whether the FTP            *
      *             transmission has been successful                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 07Mar02               *
      *                                    Date DDMmmYY               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager (Phase 1)                    *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FCGPTTNL0  IF   E           K DISK
     FCGFTPLPD  IF   E             DISK
 
      *---------------------------------------------------------------*
      /EJECT
      *---------------------------------------------------------------*
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
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
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC
      *
      ** Data Area giving Installation Control Details
      *
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      * Valid numbers
     D DIGITS          C                   CONST('0123456789')
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      * Log file patterns array
     D LogPttn         S              3    DIM(10)
 
      * Patterns array
     D Pttn            S              3    DIM(10)
 
      * Events array
     D Events          S             10    DIM(10)
 
      * Application Name
     D Applic          S             10
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      * Array index for Log file patterns array
     D i               S              2  0
     D m               S                   LIKE(i)
 
      * Array index for patterns array
     D j               S                   LIKE(i)
 
      * Array index for events array
     D k               S                   LIKE(i)
 
      * Work field to use for testing whether the string is numeric
     D CharNum         S              3
 
      * Indicator to show whether the pattern matches the log file pattern
     D Match           S              1
 
      * Return Code
     D RtnCde          S             10
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      * Fill log file patterns array
     C                   EXSR      LogRead
 
      * If the log pattern array is empty, return error code else
      * match patterns from pattern file with log patterns array
     C                   IF        i <> 0
     C                   EXSR      MatchPttn
     C                   ELSE
      * DUMP to facilitate debugging
     C                   DUMP
     C                   EVAL      RtnCde = '*ERROR    '
     C                   ENDIF
 
     C                   SETON                                        LR
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * LogRead - Read Log file for patterns                          *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     LogRead       BEGSR
 
      * Initialise
     C                   CLEAR                   LogPttn
     C                   EVAL      i = 0
 
      * Read log file
     C                   READ      CGFTPLPD
 
     C                   DOW       i < %ELEM(LogPttn) AND NOT %EOF
 
      * Test whether it contains a 3 digit numeric code at the beginning of
      * line
     C                   EVAL      CharNum = %SUBST(FCLOG:1:3)
     C     DIGITS        CHECK     CharNum
 
      * If it is a numeric code like '999 ', store in array
      * Note that the 3 digits code must be followed by a blank
     C                   IF        NOT %FOUND
     C                             AND %SUBST(FCLOG:4:1) = *BLANK
     C                   EVAL      i = i + 1
     C                   EVAL      LogPttn(i) = CharNum
     C                   ENDIF
 
     C                   READ      CGFTPLPD
 
     C                   ENDDO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * MatchPttn - Match patterns from pattern file with log file    *
      *             patterns array                                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     MatchPttn     BEGSR
 
      * Initialise
     C                   CLEAR                   Events
     C                   EVAL      k = 0
     C                   EVAL      m = 0
 
      * Read patterns file
     C     Applic        SETLL     CGPTTNL0
     C     Applic        READE     CGPTTNL0
 
     C                   DOW       NOT %EOF
 
      * Load patterns array
     C                   EXSR      LoadPttnA
 
     C                   EVAL      j = 1
     C                   EVAL      i = 1
     C                   EVAL      Match = *BLANKS
 
      * Check if patterns array match with log file patterns array
     C                   DOW       j <= %ELEM(Pttn)
     C                             AND i <= %ELEM(LogPttn)
     C                             AND LogPttn(i) <> *BLANKS
     C                             AND Match = *BLANK
     C     Pttn(j)       LOOKUP    LogPttn(i)                             02
 
     C                   IF        *IN02 = *ON
      ** Memorise the index found in case the matching underneath fails
     C                   EVAL      m = i
     C                   DOW       j <= %ELEM(Pttn) AND i <= %ELEM(LogPttn)
     C                             AND Pttn(j) = LogPttn(i)
     C                             AND LogPttn(i) <> *BLANKS
     C                   EVAL      i = i+1
     C                   EVAL      j = j+1
     C                   ENDDO
     C                   IF        j > %ELEM(Pttn) OR Pttn(j) = *BLANK
     C                   EVAL      Match = 'Y'
     C                   ELSE
      * Re-start the search after the last occurence found
     C                   EVAL      i = m + 1
     C                   EVAL      j = 1
     C                   ENDIF
     C                   ELSE
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
      * If there is a match, write the event into the events array
      * No duplicated values are admitted in the events array
     C                   IF        Match = 'Y'
     C     PTACTN        LOOKUP    Events                                 02
     C                   IF        *IN02 = '0'
     C                   EVAL      k = k + 1
     C                   IF        k <= %ELEM(Events)
     C                   EVAL      Events(k) = PTACTN
     C                   ELSE
     C                   EVAL      RtnCde = '*ERROR    '
     C                   EVAL      DBFILE =  'Events'
     C                   MOVEL     k             DBKEY
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C     Applic        READE     CGPTTNL0
     C                   ENDDO
 
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * LoadPttnA - Load patterns array from patterns file            *
      *                                                               *
      * Called by: MatchPttn                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     LoadPttnA     BEGSR
     C                   EVAL      Pttn(1) = PTSQ01
     C                   EVAL      Pttn(2) = PTSQ02
     C                   EVAL      Pttn(3) = PTSQ03
     C                   EVAL      Pttn(4) = PTSQ04
     C                   EVAL      Pttn(5) = PTSQ05
     C                   EVAL      Pttn(6) = PTSQ06
     C                   EVAL      Pttn(7) = PTSQ07
     C                   EVAL      Pttn(8) = PTSQ08
     C                   EVAL      Pttn(9) = PTSQ09
     C                   EVAL      Pttn(10) = PTSQ10
     C                   ENDSR
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Applic
     C                   PARM                    RtnCde
     C                   PARM                    Events
 
     C                   ENDSR
 
      *****************************************************************
 
      *********************************************************************
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
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
