     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG FTP Feedback Pattern Analyser')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3709 - FTP Feedback Pattern Analyser                       *
      *                                                               *
      *  Function:  This module will read through FTP session log     *
      *             file PF/CGFTPLPD and determine pattern results    *
      *             whether the FTP session has been completed        *
      *             successfully or not. It returns type of FTP       *
      *             error, if any.                                    *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 06Mar02               *
      *                                    Date DDMmmYY               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
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
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
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
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D @Run            S              1
     D Action          S             10
     D ApplName        S             10
     D Status          S             10
     D Events          S             10    DIM(10)
     D ErrCode         S             10
     D DBaseNbr        S              3  0
 
      * Entry parameters
     D RtnCde          S             10
 
      * Return code for CG3613
     D Return          S             10
 
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
 
      *-------------------------------------------------------------------*
      * MAIN PROCEDURE                                                    *
      *-------------------------------------------------------------------*
 
      * Define application name.
 
     C                   EVAL      ApplName = 'CM_FEED'
 
      * Check the events of FTP feedback session.
 
     C                   EXSR      GenEvnts
 
      * Analyse events and return errors, if any.
 
     C                   EXSR      ChkEvnts
 
     C                   SETON                                        LR
      **********************************************************************
 
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * GenEvnts - Analyse FTP log and generate events.               *
      *                                                               *
      *---------------------------------------------------------------*
     C     GenEvnts      BEGSR
 
      * Check the events of the FTP transmission
 
     C                   CALLB     'CG3613'
     C                   PARM                    ApplName
     C                   PARM      *BLANKS       Return
     C                   PARM      *BLANKS       Events
 
     C                   ENDSR
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * ChkEvnts - Verify FTP events                                  *
      *                                                               *
      *---------------------------------------------------------------*
     C     ChkEvnts      BEGSR
 
      * Ensure that logging in to Print Server is OK.
 
     C                   IF        Return = '*ERROR'
     C                   EVAL      ErrCode = '*ERROR'
     C                   EVAL      Status  = '*ERROR'
     C                   EVAL      DBaseNbr = 001
     C                   ELSE
      * Log-in OK
     C     '*LOGINOK  '  LOOKUP    Events                                 01
     C                   IF        %EQUAL
      * Check for Action
     C     Action        LOOKUP    Events                                 01
     C                   IF        %EQUAL
     C                   EVAL      Status = '*OK'
     C                   EVAL      ErrCode = ' '
     C                   EVAL      RtnCde = ' '
     C                   ELSE
      * Unknown Path
     C     '*UNKWNPATH'  LOOKUP    Events                                 01
     C                   IF        %EQUAL
     C                   EVAL      ErrCode = '*ERROR'
     C                   EVAL      Status = '*UNKWNPATH'
     C                   EVAL      DBaseNbr = 002
     C                   ELSE
     C                   ENDIF
     C                   ENDIF
 
     C                   ELSE
      * Log-in failure
     C     '*LOGINFAIL'  LOOKUP    Events                                 01
     C                   IF        %EQUAL
     C                   EVAL      ErrCode = '*ERROR'
     C                   EVAL      Status = '*LOGINFAIL'
     C                   EVAL      DBaseNbr = 003
     C                   ELSE
 
      * Unknown host
     C     '*UNKWNHOST'  LOOKUP    Events                                 01
     C                   IF        %EQUAL
     C                   EVAL      ErrCode = '*ERROR'
     C                   EVAL      Status = '*UNKWNHOST'
     C                   EVAL      DBaseNbr = 004
     C                   ELSE
      * Other errors
     C                   EVAL      ErrCode = '*ERROR'
     C                   EVAL      Status  = '*ERROR'
     C                   EVAL      DBaseNbr = 005
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      * Process database error
 
     C                   IF        ErrCode <> *BLANKS
     C                   EVAL      RtnCde = ErrCode
     C                   EVAL      DBFILE = 'CG3613'
     C                   EVAL      DBPGM  = PSProcPgm
     C                   EVAL      DBASE  = DBaseNbr
     C                   EVAL      DBMOD  = PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *---------------------------------------------------------------*
 
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      *---------------------------------------------------------------*
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    Action
     C                   PARM                    RtnCde
     C                   PARM                    Status
 
     C                   ENDSR
      *---------------------------------------------------------------*
 
      /EJECT
      *---------------------------------------------------------------*
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *---------------------------------------------------------------*
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        @Run = *BLANK
     C                   EVAL      @Run = 'Y'
 
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
