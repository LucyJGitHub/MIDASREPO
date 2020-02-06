     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Unrealized profit/loss capture')
      *****************************************************************
      *                                                               *
      *  Midas - Futures and Options Module                           *
      *                                                               *
      *  FF000801 - Unrealized Profit and Loss Capture                *
      *                                                               *
      *  Function:  This program will populate Revalued FF Positions  *
      *             File PF/FFNPVLPD with details from FF Book        *
      *             Positions File PF/POSTNKD.                        *
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
 
     FPOSTNK5   IF   E           K DISK    INFSR(*PSSR)
      ** FF Book Positions File
 
     FFFNPVLL0  UF A E           K DISK    INFSR(*PSSR)
      ** Revalued FF Positions File
 
     FFF000801AUO    E             PRINTER INFDS(SPOOLU)
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
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** File Information Data Structure for DR000801AU
     D SPOOLU          DS
     D  PSpoolName            83     92
     D  WSpoolNum            123    124B 0
 
     D WPostRec        DS
     D  BRCA                   1      3
     D  BOKC                   4      5
     D  ISTT                   6     10
     D  YRNO                  11     12  0
     D  MTHN                  13     14  0
     D  PCAL                  15     15
     D  STRP                  16     23P 8
 
     D WCopy           DS            23
     D  WBRCA                  1      3
     D  WBOKC                  4      5
     D  WISTT                  6     10
     D  WYRNO                 11     12  0
     D  WMTHN                 13     14  0
     D  WPCAL                 15     15
     D  WSTRP                 16     23P 8
 
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
     D WTotalCUTV      S             13  0
     D WTotalUPLM      S             13  0
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically:             ¦
      ** ¦ the *INZSR is executed at program activation.              ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      ** Read POSTNK5 while not end of file.
 
     C                   READ      POSTNK5
 
     C                   DOW       NOT %EOF(POSTNK5)
 
     C                   IF        WPostRec <> WCopy
     C                   EVAL      WTotalCUTV = 0
     C                   EVAL      WTotalUPLM = 0
     C                   ENDIF
 
     C                   EVAL      WTotalCUTV = WTotalCUTV + CUTV
     C                   EVAL      WTotalUPLM = WTotalUPLM + UPLM
     C                   MOVEL     WPostRec      WCopy
 
     C     KNPVL         CHAIN     FFNPVLL0
 
     C                   IF        %FOUND(FFNPVLL0)
     C                   EVAL      FFCUTV = WTotalCUTV
     C                   EVAL      FFPUPL = FFURPL
     C                   EVAL      FFURPL = WTotalUPLM
     C                   EVAL      FFTUPL = WTotalUPLM
     C                   UPDATE    FFNPVLD0
 
     C                   ELSE
     C                   EVAL      FFBRCA = BRCA
     C                   EVAL      FFBKCD = BOKC
     C                   EVAL      FFISTT = ISTT
     C                   EVAL      FFYRNO = YRNO
     C                   EVAL      FFMTHN = MTHN
     C                   EVAL      FFPCAL = PCAL
     C                   EVAL      FFSTRP = STRP
     C                   EVAL      FFCUTV = WTotalCUTV
     C                   EVAL      FFCCY = ISCY
     C                   EVAL      FFURPL = WTotalUPLM
     C                   EVAL      FFPUPL = 0
     C                   EVAL      FFTUPL = WTotalUPLM
     C                   EVAL      FFYUPL = 0
     C                   WRITE     FFNPVLD0
     C                   ENDIF
 
     C                   READ      POSTNK5
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
      *  *INZSR - Initialisation                                      *
      *                                                               *
      *  Called By:  Main Processing                                  *
      *                                                               *
      *  Calls    :  None                                             *
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
     C                   EVAL      DBPGM = 'FF000801'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C     KNPVL         KLIST
     C                   KFLD                    BRCA
     C                   KFLD                    BOKC
     C                   KFLD                    ISTT
     C                   KFLD                    YRNO
     C                   KFLD                    MTHN
     C                   KFLD                    PCAL
 
      ** Set record count to zero.
 
     C                   EVAL      WTotalCUTV = 0
     C                   EVAL      WTotalUPLM = 0
 
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
 
     C                   OPEN      FF000801AU
     C                   WRITE     HEADAU
     C                   WRITE     DBERROR
     C                   CLOSE     FF000801AU
 
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
