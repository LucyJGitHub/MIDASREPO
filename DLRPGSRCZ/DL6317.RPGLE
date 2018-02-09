     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas DL Purge CLS Pay-In schedule files')
      *****************************************************************
      *                                                               *
      *  Midas - Dealing Module                                       *
      *                                                               *
      *  DL6317 - Purge Pay-In Schedule Files                         *
      *                                                               *
      *  Function:  This program purges Pay-In schedule files that    *
      *  (COB)      are older than a month.                           *
      *                                                               *
      *  Called By: DLC6317 - Purge Pay-In Schedule Files             *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. BUG5671            Date 01Feb05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008  *CREATE    Date 02May00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BUG5671- Add Sequence number to detail record (recompile)    *
      *  CDL008 - Continuous Linked Settlement                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         EOF on FXCLSPSH                                 *
      *    02         Chain fail on FXCLSPSDL0                        *
      *    03         Chain fail on FXSEQNPD                          *
      *    81         Error on deletion of FXCLSPSH record            *
      *    82         Error on deletion of FXCLSPSDL0 record          *
      *    83         Error on deletion of FXSEQNPD record            *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * Audit - Produce Audit Report                                  *
      * TimeStamp - Check if record is older than a month             *
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
 
      ** Pay-In Schedule Header File
     FFXCLSPSH  UF   E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Pay Schedule Detail File
     FFXCLSPSDL0UF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(@)
     F                                     COMMIT
 
      ** Transaction Sequence Number for CLS Pay/Receives
     FFXSEQNPD  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Purged Pay-In Schedules Audit Report
     FDL6317AU  O    E             PRINTER USROPN
 
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **------------------------------------------------------------------------
 
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Data structure for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Short dummy data structure for access programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
 
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D OpenAU          S              1A
     D DeleteAll       S              1A
     D Purge           S              1A
     D WTIMS           S             26A
     D Age             S              5  0
     D ZDateI          S              6A
     D ZDateIn         S              6  0
     D ZDayNo          S              5  0
     D WValD           S              5A
     D WSeqN           S              2A
 
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
 
     C     1             SETLL     FXCLSPSH
 
     C                   READ      FXCLSPSH                               01
 
     C     *IN01         DOWEQ     *OFF
 
      ** For each deleted or live, authorised and posted
      ** Pay-in schedule header record
 
     C     PYRECI        IFEQ      '*'
     C     PYRECI        OREQ      'D'
     C     PYSNTF        ANDEQ     'Y'
     C     PYPOST        ANDEQ     'Y'
 
     C     KEY1          CHAIN     FXCLSPSDL0                         02
     C                   EVAL      DeleteAll = 'Y'
 
      ** If RECI = '*' in header record, delete all detail records.
      ** Else if RECI = 'D', delete detail record only if
      ** Generated Flag = Y and the record is older than a month.
 
     C     *IN02         DOWEQ     *OFF
 
     C                   EVAL      Purge = 'N'
 
     C     @PYRECI       IFEQ      'D'
     C     @PYGENT       ANDEQ     'Y'
     C                   EXSR      TimeStamp
     C                   ENDIF
 
     C     PYRECI        IFEQ      '*'
     C     @PYRECI       OREQ      '*'
     C     @PYRECI       OREQ      'D'
     C     @PYGENT       ANDEQ     'Y'
     C     Purge         ANDEQ     'Y'
     C                   DELETE    FXCLSPSDL0                           82
 
      ** DB Error, if delete operation was not successful.
 
     C     *IN82         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FXCLSPSDL0'
     C                   MOVE      PYVALD        WValD
     C                   MOVE      PYSEQN        WSeqN
     C                   EVAL      DBKEY = (PYCCY + ' ' + PYNOST + ' ' +
     C                             WValD + ' ' + WSeqN)
     C                   EVAL      DBASE = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
     C                   ADD       1             RCountD
     C                   EVAL      OpenAU = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      DeleteAll = 'N'
     C                   ENDIF
 
     C     KEY1          READE     FXCLSPSDL0                             02
 
     C                   ENDDO
 
      ** If all detail records are deleted, delete the header record.
 
     C     DeleteAll     IFEQ      'Y'
     C                   DELETE    FXCLSPSH                             81
 
      ** DB Error, if delete operation was not successful.
 
     C     *IN81         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FXCLSPSH'
     C                   MOVE      PYVALD        WValD
     C                   MOVE      PYSEQN        WSeqN
     C                   EVAL      DBKEY = (PYCCY + ' ' + PYNOST + ' ' +
     C                             WValD + ' ' + WSeqN)
     C                   EVAL      DBASE = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
      ** Else, increment counter for deleted header records and delete
      ** corresponding record in FXSEQNPD
 
     C                   ELSE
     C                   ADD       1             RCountH
     C                   EVAL      OpenAU = 'Y'
     C                   EXSR      DltSeqN
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      FXCLSPSH                               01
 
     C                   ENDDO
 
      ** Print the Audit Report
 
     C     OpenAU        IFEQ      'Y'
     C                   EXSR      Audit
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  TimeStamp - Check if record is older than a month            *
      *                                                               *
      *****************************************************************
 
     C     TimeStamp     BEGSR
 
     C                   MOVE      @PYTIMS       WTIMS
     C                   EVAL      ZDATEI = *BLANKS
 
      ** Retrieve date from Timestamp field
 
     C     2             SUBST     WTIMS:3       WYear             2
     C     2             SUBST     WTIMS:6       WMonth            2
     C     2             SUBST     WTIMS:9       WDay              2
 
     C     *IN98         IFEQ      *ON
     C     WMonth        CAT       WDay:0        ZDateI
     C                   ELSE
     C     WDay          CAT       WMonth:0      ZDateI
     C                   ENDIF
     C     ZDateI        CAT       WYear:0       ZDateI
 
     C                   MOVE      ZDateI        ZDateIn
     C                   EVAL      ZDayNo = *ZERO
 
      ** Convert to number of days
 
     C                   CALL      'ZDATE1'
     C                   PARM                    @RtCd
     C                   PARM                    ZDateIn
     C                   PARM                    BJDFIN
     C                   PARM                    ZDayNo
 
      ** Seton work field if record is older than a month
 
     C     @RtCd         IFNE      '*ERROR*'
     C                   EVAL      Age = *ZERO
     C                   EVAL      Age = BJRDNB - ZDayNo
     C     Age           IFGT      30
     C                   EVAL      Purge = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  DltSeqN - Delete corresponding record from PF/FXSEQNPD       *
      *                                                               *
      *****************************************************************
 
     C     DltSeqN       BEGSR
 
      ** Chain corresponding record in FXSEQNPD.
      ** If found, also delete the record.
 
     C     KEY1          CHAIN     FXSEQND0                           03
 
     C     *IN03         IFEQ      *OFF
     C                   DELETE    FXSEQND0                             83
 
      ** DB Error, if delete operation was not successful.
 
     C     *IN83         IFEQ      *ON
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'FXSEQNPD'
     C                   MOVE      PYVALD        WValD
     C                   MOVE      PYSEQN        WSeqN
     C                   EVAL      DBKEY = (PYCCY + ' ' + PYNOST + ' ' +
     C                             WValD + ' ' + WSeqN)
     C                   EVAL      DBASE = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
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
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = PSProcPgm
     C                   OUT       LDA
 
      ** Access bank details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C     @RtCd         IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = @Optn
     C                   EVAL      DBASE = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
 
     C     BJDFIN        IFEQ      'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
 
      ** Set up key list for Pay-In Schedule Details file LF/FXCLSPSDL0
 
     C     KEY1          KLIST
     C                   KFLD                    PYCCY
     C                   KFLD                    PYNOST
     C                   KFLD                    PYVALD
     C                   KFLD                    PYSEQN
 
      ** Initialise work fields and indicators
 
     C                   EVAL      *IN01 = *OFF
     C                   EVAL      *IN02 = *OFF
     C                   EVAL      RCountH = *ZERO
     C                   EVAL      RCountD = *ZERO
     C                   EVAL      OpenAU = 'N'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Audit - Produce Audit Report                                 *
      *                                                               *
      *****************************************************************
 
     C     AUDIT         BEGSR
 
     C                   OPEN      DL6317AU
     C                   WRITE     HEADAU
 
      ** If there is a DB Error, output the DB Error information.
 
     C     *INU7         IFEQ      *ON
     C     *INU8         OREQ      *ON
     C                   WRITE     DBERROR
 
      ** Otherwise, output file control.
 
     C                   ELSE
     C                   WRITE     CONTROL
     C                   ENDIF
 
     C                   CLOSE     DL6317AU
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *PSSR  - Program exception error routine                      *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      * Called by: Main Processing.                                   *
      *                                                               *
      * Calls: Audit.                                                 *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
 
     C     RunBefore     IFEQ      *BLANKS
     C                   EVAL      RunBefore = 'Y'
     C                   EXSR      Audit
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2001
