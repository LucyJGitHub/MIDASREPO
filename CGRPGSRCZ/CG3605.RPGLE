     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG UDC No. attribution for stream file name')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3605 - Midas CG No. Attribution for Stream File Name       *
      *                                                               *
      *  Function:  This module will generate a new id no. for the    *
      *             stream file being created                         *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CCG015  *CREATE    Date 20Jun01               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  NewId - Generate New Stream File Name                        *
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
 
     FCGATTNL0  UF A E           K DISK
 
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
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
     D UnderScore      C                   CONST('_')
     D StreamFRes      C                   CONST('*STREAM_FILE')
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
      * Entry parameters
     D RtnCode         S             10
     D ResName         S             20
     D AtribNo         S             35
 
      * Parameters for ZA3344
     D Date6           S              6  0
     D DateA           S              7
     D Date8           S              8  0
 
      * Working Variables
     D Date8C          S              8
     D Date8C_         S              9
     D LastNo          S              7  0
     D LastNoC         S              7
     D StreamFNo       S             16
 
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
 
      * Retrieve business day date in YYYYMMDD format
     C                   CALLB     'ZA3344'
     C                   PARM                    Date6
     C                   PARM                    DateA
     C                   PARM                    Date8
 
      * Date in character format
     C                   MOVE      Date8         Date8C
 
      * Check if resource type '*STREAM_FILE' exists
     C                   EVAL      ResName = StreamFRes
     C     ResName       CHAIN     CGATTNL0
 
      * If resource type '*STREAM_FILE' does exist
     C                   IF        %FOUND
 
      * If it is the same business day, increment the last number known by 1
     C                   IF        %SUBST(ATLSTN:1:8) = Date8C
     C                   EVAL      LastNoC = %SUBST(ATLSTN:10:7)
     C                   MOVE      LastNoC       LastNo
     C                   EVAL      LastNo = LastNo + 1
     C                   EXSR      NewId
     C                   ELSE
 
      *...else create a new stream file name for the new business day
     C                   EVAL      LastNo = 1
     C                   EXSR      NewId
     C                   ENDIF
 
      * Update UDC Attribution Number file
     C                   EVAL      ATLSTN = StreamFNo
     C                   UPDATE(E) CGATTND0
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE =  'CGATTNL0'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      * If resource type '*STREAM_FILE' does not exist, create a new stream
      * file name for the business day
     C                   ELSE
     C                   EVAL      LastNo = 1
     C                   EXSR      NewId
 
      * Write new record in UDC Attribution Number file
     C                   EVAL      ATRSRC = StreamFRes
     C                   EVAL      ATLSTN = StreamFNo
     C                   WRITE(E)  CGATTND0
 
     C                   IF        %ERROR
     C                   EVAL      DBFILE =  'CGATTNL0'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   SETON                                        LR
 
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * NewId  - Generate New Stream File Name                        *
      *                                                               *
      * Called by: MAIN                                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     NewId         BEGSR
 
     C                   MOVE      LastNo        LastNoC
     C     Date8C        CAT       UnderScore    Date8C_
     C     Date8C_       CAT       LastNoC       StreamFNo
     C                   EVAL      AtribNo = StreamFNo
 
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
 
     C     *entry        PLIST
     C                   PARM                    RtnCode
     C                   PARM                    AtribNo
 
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
 
      ********************************************************************
