     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2007')
      *****************************************************************
/*STD *  RPGBASEBND                                                   *
/*EXI *  TEXT('Midas SD Market Identification Code Report')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data module                                 *
      *                                                               *
      *  SD009816 - Midas SD Market Identification Code Report        *
      *                                                               *
      *  Function:  This program prints MIC Codes in List mode or     *
      *             Audit mode (today's changes only)                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2007            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG21168           Date 22Sep08               *
      *  Prev Amend No. CSW208             Date 15Apr08               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG21168 - SDC541P 10095 failed in COB                       *
      *  CSW208 - SWIFT 2008 Changes                                  *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    U7         Control Indicator                               *
      *    U8         Control Indicator                               *
      *    76         Print Indicators                                *
      *    98         Date Format                                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRHeader - Header Subroutine                                 *
      *  SRDetails - Details Subroutine                               *
      *  SRRCFp1 - RCF Processing                                     *
      *  *PSSR - Error Processing                                     *
      *  *INZSR - Initialise                                          *
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
      *
      ** Midas SD Market identification code
     FSDMICCL0  IF   E           K DISK
      *
      ** Midas SD Market identification code print
     FSD009816P1O    E             PRINTER OFLIND(OA)
     F                                     INFDS(SPOOL)
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Data Area giving Installation Control Details
     D RUNDAT        E DS                  EXTNAME(RUNDAT)
     D SDTIZO        E DS                  EXTNAME(SDTIZOPD)
     D YEAR            S              4S 0
     D PTzld           S              1A   Inz(*Blanks)
     D PBranch         S              3A
     D PZone           S             10A   Inz(*Blanks)
      *
      ** The following /COPY line includes (among others) the LDA
      ** layout and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY line includes all the defined fields in
      ** the PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** External DS for Bank Details ICD retrieval
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Second DS for access programs, long data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
     D SPOOL           DS
     D  SFILE                 83     92
     D  SFNUM                123    124B 0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PRtcd           S              7
     D POptn           S              7A
     D PMode           S              1
     D PSeq            S              5
     D PLevel          S              1
     D PEntity         S              3
     D PSpno           S              6  0
     D PError          S              1
     D WRun            S              1A
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - Processing                                             *
      *****************************************************************
      *
      ** Read in Installation Data
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
      *
      ** Set Date Format Indicator *IN98  on if date format is MMDDYY
     C                   IF        AGDFF = 'M'
     C                   EVAL      *IN98 = *ON
     C                   ENDIF
      *
     C                   READ      SDMICCL0
     C                   EXSR      SRHeader
      *
     C                   IF        %EOF(SDMICCL0)
     C                   WRITE     SD009816R2
     C                   ENDIF
      *
     C                   DOW       NOT %EOF(SDMICCL0)
      *
     C                   EXSR      SRDetails
      *
     C                   IF        OA = *ON
     C                   EXSR      SRHeader
     C                   ENDIF
      *
     C                   READ      SDMICCL0
      *
     C                   ENDDO
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRCFp1 - RCF Processing                                     *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: *PSSR                                                 *
      *                                                               *
      *****************************************************************
      *
     C     SRRCFp1       BEGSR
      *
     C                   EVAL      PSpno = SFNUM
     C                   CALL      'ZSFILE'
     C                   PARM                    PSeq
     C                   PARM                    PEntity
     C                   PARM                    SFILE
     C                   PARM                    PSpno
     C                   PARM                    PError
      *
     C                   IF        PError = 'Y'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHeader - Header subroutine                                 *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRHeader      BEGSR
      *
     C                   WRITE     SD009816R0
     C                   EVAL      OA = *OFF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDetails - Details subroutine                               *
      *                                                               *
      *  Called by: MAIN Processing                                   *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     SRDetails     BEGSR
      *
     C                   EVAL      RMICOD = MICCOD
     C                   EVAL      RMICTY = MICCTY
     C                   EVAL      RMIACM = MICACM
     C                   EVAL      RMICIT = MICCIT
     C                   EVAL      RMIDES = MICDES
     C                   EVAL      RMTZCD = MITZCD
      *
      ** Get Current year                                                                   BUG21168
      *                                                                                     BUG21168
     C                   MOVE      BJRDNB        MidasDayNo                                 BUG21168
     C                   EXSR      SRCvtDt                                                  BUG21168
     C                   Z-ADD     *ZEROS        YEAR                                       BUG21168
     C                   IF        PDateOut > 0                                             BUG21168
     C                   IF        BJDFIN  = 'D'                                            BUG21168
     C                   EVAL      YEAR = %Subdt(%Date(PDateOut:*DMY) :                     BUG21168
     C                                         *Years)                                      BUG21168
     C                   ELSE                                                               BUG21168
     C                   EVAL      YEAR = %Subdt(%Date(PDateoUt:*MDY) :                     BUG21168
     C                                         *Years)                                      BUG21168
     C                   ENDIF                                                              BUG21168
     C                   ENDIF                                                              BUG21168
      *                                                                                     BUG21168
      ** Call Access Object
     C                   CALL      'AOTIZOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RMTZCD
     C**********         PARM      *YEAR         YEAR                                       BUG21168
     C                   PARM                    YEAR                                       BUG21168
     C                   PARM                    SDTIZO
      *
     C                   IF        PRtcd   = *BLANKS
     C                   EVAL      RMTZDS  = TZDESC
     C                   ENDIF
      *
     C                   IF        PRtcd   = '*ERROR'
     C                   EVAL      DBFILE  = 'SDTIZOPD'
     C                   EVAL      DBKEY   = POptn
     C                   EVAL      DBASE   = 2
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   IF        PRtcd   = '*NRF'
     C                   CALL      'AOTIZOR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    RMTZCD
     C                   PARM                    YEAR
     C                   PARM                    SDTIZO
      *
     C                   IF        PRtcd   = *BLANKS
     C                   EVAL      RMTZDS  = TZDESC
     C                   ENDIF
     C                   IF        PRtcd  =  '*NRF'
     C                   EVAL      PRtcd  =  '*ERROR'
     C                   ENDIF
     C                   IF        PRtcd   = '*ERROR'
     C                   EVAL      DBFILE  = 'SDTIZOPD'
     C                   EVAL      DBKEY   = POptn
     C                   EVAL      DBASE   = 3
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
      *
     C                   WRITE     SD009816R1
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls: *PSSR,SRRCFp1                                         *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    PRtcd
     C                   PARM                    PMode
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEntity
      *
      ** Access installation control data
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST'      POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY  = '*FIRST'
     C                   EVAL      DBASE  = 1
     C                   EVAL      DBPGM = 'SD009816'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Setup header fields
     C                   IF        PMode = 'A'
     C                   EVAL      *IN76 = *ON
     C                   ENDIF
     C                   EVAL      RRRUNA = BJMRDT
     C                   EVAL      RRTITL = BJURPT
      *
      ** RCF Processing
     C                   EXSR      SRRCFp1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtDt- Convert Midas Day Format to DDMMYY/MMDDYY           *                     BUG21168
      *                                                               *                     BUG21168
      *  Called By: SRGetTIZone                                       *                     BUG21168
      *                                                               *                     BUG21168
      *  Calls: None                                                  *                     BUG21168
      *                                                               *                     BUG21168
      *****************************************************************                     BUG21168
     C     SRCvtDt       BEGSR                                                              BUG21168
      *                                                                                     BUG21168
     C                   CALL      'ZDATE2'                                                 BUG21168
     C                   PARM                    MidasDayNo        5 0                      BUG21168
     C                   PARM                    BJDFIN                                     BUG21168
     C                   PARM      *ZEROS        PDateOut          6 0                      BUG21168
     C                   PARM      *BLANKS       PADateOut         7                        BUG21168
      *                                                                                     BUG21168
     C                   ENDSR                                                              BUG21168
      *****************************************************************                     BUG21168
      /EJECT                                                                                BUG21168
      *****************************************************************                     BUG21168
      *                                                               *                     BUG21168
      *  *PSSR  - Program exception error routine                     *
      *          Called automatically if a program error occurs,      *
      *          or directly by the program code using EXSR.          *
      *          This subroutine DUMPs the program just once.         *
      *                                                               *
      *  Called by: *INZSR,SRRCFp1                                    *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
      *
     C     *PSSR         BEGSR
      *
     C                   IF        WRun = *BLANKS
     C                   EVAL      WRun = 'Y'
     C                   EVAL      DBPGM = 'SD009816'
     C                   DUMP
     C                   CALL      'DBERRCTL'
      *
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
** CPY@
(c) Misys International Banking Systems Ltd. 2007
