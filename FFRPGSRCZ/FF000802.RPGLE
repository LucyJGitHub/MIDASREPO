     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Unrealized profit/loss capture')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000802 - Unrealized Profit and Loss Capture                *
      *                                                               *
      *  Function:  This program will update the Unrealized           *
      *             Profit/Loss fields (FSURPL, FSTUPL, FSPUPL)       *
      *             in PF/TRANSD.                                     *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7+U8      Database Error                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRRCFAudit - RCF Processing for Audit File                   *
      *                                                               *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
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
 
     FTRANSD    UF   E           K DISK    INFSR(*PSSR)
      ** Futures and Options Transaction Details File
 
     FFF000802AUO    E             PRINTER INFDS(SPOOLU)
     F                                     INFSR(*PSSR)
      ** FF Unrealized Profit/Loss Capture - Audit
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
 
      ** Program Status Data Structure
     D/COPY ZACPYSRC,PSDS
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Bank details file
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Second DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSSDY)
 
      ** File Information Data Structure for DR000802AU
     D SPOOLU          DS
     D  PSpoolName            83     92
     D  WSpoolNum            123    124B 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PRprtSeq        S              5
     D PEntity         S              3
     D PError          S              1
     D PRtrnCode       S              7
     D POption         S              7
     D PSpoolNum       S              6  0
 
     D WRun            S              1
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:             ¦
      ** ¦ the *INZSR is executed at program activation.              ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Read TRANSD while not end of file.
 
     C                   READ      TRANSD
 
     C                   DOW       NOT %EOF(TRANSD)
 
     C                   IF        RECI = 'D'
 
     C                   EVAL      FSPUPL = FSURPL
     C                   EVAL      FSURPL = CUUN
     C                   EVAL      FSTUPL = CUUN
     C                   UPDATE    TRANSDF
 
     C                   ENDIF
 
     C                   READ      TRANSD
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFAudit - Audit Spool File recorded by RCF                *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls    : ZSFILE                                            *
      *                                                               *
      *****************************************************************
 
     C     SRRCFAudit    BEGSR
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   Z-ADD     WSpoolNum     PSpoolNum
 
     C                   CALL      'ZSFILE'
     C                   PARM                    PRprtSeq
     C                   PARM      *BLANKS       PEntity
     C                   PARM                    PSpoolName
     C                   PARM                    PSpoolNum
     C                   PARM      *BLANKS       PError
 
      ** If error occurs during ZSFILE processing, then return to the
      ** calling program.
 
     C                   IF        PError = 'Y'
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : SRRCFAudit, AOBANKR0, *PSSR                       *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
      ** RCF processing for audit file.
 
     C                   EXSR      SRRCFAudit
 
      ** Access bank details.
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database error.
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'FF000802'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR - Subroutine to handle abnormal error conditions       *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
     C                   EVAL      *INU7 = '1'
     C                   EVAL      *INU8 = '1'
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
