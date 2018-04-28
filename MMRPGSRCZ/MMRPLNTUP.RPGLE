     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Temporary Repo Loan/Deposit update')
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMRPLNTUP - TEMPORARY REPO LOAN/DEPOSIT UPDATE               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. 256564             Date 17Sep08               *
      *  Prev Amend No. 248773             Date 28Jun07               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CDL038             Date 10May05               *
      *                 CAP067  *CREATE    Date 24Sep01               *
      *                                    Date                       *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248773 - Decimal data error when Repo is repaired. Recompile.*
      *  247785 - Recompile on MMTRPLNPD.                             *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     FMMTRPLNL0 UF A E           K DISK
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
     D MMTRPLN       E DS                  EXTNAME(MMTRPLNPD)
      * EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID LOAN/DEPOSIT
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
     D @@AFRT          S             20A
     D @@MODE          S              1A
     D @@RTCD          S             10A
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
     C     @@MODE        IFEQ      'I'
     C                   EXSR      INSERT
     C                   ENDIF
     C*
     C     @@MODE        IFEQ      'D'
     C                   EXSR      DELETE
     C                   ENDIF
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSERT - INSERT LOAN/DEPOSIT INTO TEMPORARY FILE             *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR
     C*
     C                   EXSR      DELETE
     C                   WRITE     MMTRPLND0
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* DELETE - DELETE LOAN/DEPOSIT FROM TEMPORARY FILE             *
     C*                                                              *
     C****************************************************************
     C     DELETE        BEGSR
      *
     C                   MOVE      IKAFRT        @@AFRT
     C     @@AFRT        CHAIN     MMTRPLND0                          99
      *
     C     *IN99         DOWEQ     *OFF
     C                   DELETE    MMTRPLND0
     C     @@AFRT        READE     MMTRPLND0                              99
     C                   ENDDO
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
     C                   PARM                    @@RTCD
     C                   PARM                    @@MODE
     C                   PARM                    MMTRPLN
      *
     C*
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* SRERR - EXCEPTION ERRORS                                     *
     C*                                                              *
     C****************************************************************
     C     SRERR         BEGSR
     C*
     C                   MOVEL     '*ERROR '     @@RTCD
     C                   MOVEL     'MMRPLNTUP'   DBPGM            10
     C                   MOVE      '1'           *INU7
     C                   MOVE      '1'           *INU8
     C                   MOVE      '1'           *INLR
     C                   DUMP
     C*
     C**  TERMINATE THE PROGRAM
     C*
     C                   RETURN
     C*
     C                   ENDSR
     C****************************************************************
**  CPY@
(C) Copyright Misys International Banking Systems Ltd. 2001
