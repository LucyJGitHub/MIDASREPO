     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas CG UDC No. attribution for SQL request')
      *****************************************************************
      *                                                               *
      *  Midas - User Defined Correspondence                          *
      *                                                               *
      *  CG3606 - Midas CG UDC Number Attribution for SQL Request     *
      *                                                               *
      *  Function:  This module will generate a new sequence number   *
      *             for a SQL statement requested.                    *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. CCG015  *CREATE    Date 26Sep01               *
      *                                    Date DDMmmYY               *
      *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CCG015 - Correspondence Manager Phase 1                      *
      *                                                               *
      *---------------------------------------------------------------*
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
 
      ** Data Area giving Installation Control Details
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program Status Data Structure
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** +--------------------------------------+
 
     D SQLRqstRes      C                   CONST('*REQUEST_SQL')
 
      ** +--------------------------------------+
      ** ¦ Entry parameters                     ¦
      ** +--------------------------------------+
 
     D RtnCode         S              7
     D ResName         S             20
     D RequestNo       S             10
 
      ** +--------------------------------------+
      ** ¦ Work Variables                       ¦
      ** +--------------------------------------+
     DAtribNo          DS
     D Prefix                         2    INZ('SQ')
     D LastNo                         8  0
 
     D @RUN            S              1
 
      /EJECT
      *
      ** +----------------- START OF MAIN PROCESSING ---------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically. *INZSR is       ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** +----------------------------------------------------------------+
      ** ¦ MAIN PROCEDURE                                                 ¦
      ** +----------------------------------------------------------------+
     C                   EVAL      RtnCode = *BLANK
     C                   EVAL      RequestNo = *BLANK
 
      * Check if resource type '*REQUEST_SQL' exists in the file.
     C                   EVAL      ResName = SQLRqstRes
     C     ResName       CHAIN     CGATTNL0
 
      * If resource type '*REQUEST_SQL' exist, increment Last No. by one.
     C                   IF        %FOUND
     C                   EVAL      AtribNo = ATLSTN
     C                   EVAL      LastNo = LastNo + 1
 
      * Update the record with the latest calculated value.
     C                   EVAL      ATLSTN = AtribNo
     C                   UPDATE(E) CGATTND0
 
      * If database error encountered, send info, dump and terminate
      * the program.
     C                   IF        %ERROR
     C                   EVAL      DBFILE =  'CGATTNL0'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  001
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
      * If resource type '*REQUEST_SQL' does not exist, create a new
      * records for this and set Last Attribution Number to 'SQ00000001'.
     C                   ELSE
     C                   EVAL      LastNo = 1
 
      * Write new record.
     C                   EVAL      ATRSRC = SQLRqstRes
     C                   EVAL      ATLSTN = AtribNo
     C                   WRITE(E)  CGATTND0
 
      * If database error encountered, send info, dump and terminate
      * the program.
     C                   IF        %ERROR
     C                   EVAL      DBFILE =  'CGATTNL0'
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBASE  =  002
     C                   EVAL      DBMOD  =  PSProcMod
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      RequestNo = AtribNo
     C                   SETON                                        LR
 
 
      **********************************************************************
 
      *********************************************************************
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
     C                   PARM                    RequestNo
 
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
 
      * Set return code to indicate error in processing.
     C                   EVAL      RtnCode = '*ERROR '
 
      * Produce program dump.
     C                   DUMP
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
 
      * Display database error to screen
     C                   CALLB     'DBERRCTL'
 
     C                   ENDIF
 
      * Set database indicators
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
 
      * Terminate the program.
     C                   RETURN
 
     C                   ENDSR
 
      ********************************************************************
