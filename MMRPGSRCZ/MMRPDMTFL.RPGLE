     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MM Temp Repo Depot Mvt copy to Temp File')       *
      *****************************************************************
      *                                                               *
      *  Midas - MM Dealer Module                                     *
      *                                                               *
      *  MMRPDMTFL - TEMPORARY REPO DEPOT MVT MOVE TO TEMP FILE       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 248773             Date 28Jun07               *
      *                 247785             Date 15May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 240524             Date 21Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 233352             Date 06May05               *
      *                 222727             Date 05Nov03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP067 *CREATE     Date 24Sep01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  248773 - Decimal data error when Repo is repaired. Recompile.*
      *  247785 - Recompile on MMTRPDMPD.                             *
      *  240524 - Position file pointer from first valid record.      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233352 - Problem in REPO API (Recompile)                     *
      *  222727 - Release 5.0 errors  (Recompile)                     *
      *  CAP067 - Repurchase Agreements API.                          *
      *                                                               *
      *****************************************************************
     F***MMTRPDMPD*IF***E           K DISK                                                    240524
     FMMTRPDML1 IF   E           K DISK                                                       240524
     F
 
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
     D MMTRPDM       E DS                  EXTNAME(MMTRPDMPD)
      * EXTERNALLY DESCRIBED DATA STRUCTURE FOR VALID DEPOT MOVEMENT
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      * SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDXX         E DS                  EXTNAME(DPTMVD) PREFIX(XX)
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX1         E DS                  EXTNAME(DPTMVDY1) PREFIX(X1)
 
     D**  Data structure of Temporary Depot Movement Extension File
     D SEDX2         E DS                  EXTNAME(DPTMVDY2) PREFIX(X2)
 
     D**  Associated Front Office Transaction Reference Number
     D @IKAFRT         S             20A
     D DMRPMode        S              7A
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
     C                   CLEAR                   SEDXX
     C                   CLEAR                   SEDX1
     C                   CLEAR                   SEDX2
 
     C**********         READ      MMTRPDMD0                              99                  240524
     C     @IKAFRT       SETLL     MMTRPDML1                                                  240524
     C     @IKAFRT       READE     MMTRPDML1                              99                  240524
      *
     C     *IN99         DOWEQ     *OFF
      *
     C**********         IF        @IKAFRT = DMAFRT                                           240524
     C                   MOVE      MMTRPDM       SEDXX
     C                   CALLB     'SEDMRPUPD'
     C                   PARM                    ReturnCode
     C                   PARM      '*WrtXX'      DMRPMode
     C                   PARM                    SEDXX
     C                   PARM                    SEDX1
     C                   PARM                    SEDX2
     C**********         ENDIF                                                                240524
      *
     C**********         READ      MMTRPDMD0                              99                  240524
     C     @IKAFRT       READE     MMTRPDML1                              99                  240524
     C                   ENDDO
      *
      * EXIT FROM PROGRAM
      *
     C                   RETURN
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
     C                   PARM                    @@RTCD            7
     C                   PARM                    @IKAFRT
      *
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
     C                   MOVEL     'MMRPDMTFL'   DBPGM            10
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
(C) Copyright Finastra International Limited 2001
