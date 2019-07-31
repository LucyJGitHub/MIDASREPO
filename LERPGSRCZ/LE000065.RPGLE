     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Commitmnt/Fcty & Loan Extrct for Agg.Fcty')   *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  RPGLE/LE000065 - Commitment/Facility & Loan Details Extract  *
      *                   for Aggregated Facilities                   *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG27091           Date 04Mar10               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE041  *CREATE    Date 11Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  BUG27091 - LEC08 Seq. 10001 and 10002 DBerr at 013 ;         *
      *             applied GEMS Fix 259583                           *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type                              *
      *  CLE041 - Collateralised Lending Phase 2B                     *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of Indicators                                            *
      *                                                               *
      *  LR - Last record indicator (program termination)             *
      *  U7 and U8 - DB error processing indicator                    *
      *                                                               *
      *****************************************************************
      /SPACE
      *****************************************************************
      *                                                               *
      *  Subroutine Index                                             *
      *                                                               *
      *  SrFacExtD  - Process Commitment/Facility Loan detail         *
      *               extract file(FACEXFA)                           *
      *  SrAggFclty - Process Aggregate Facilities detail             *
      *               file(LEAGFMPD/LEAGFNPD)                         *
      *  SrFacExtT  - Update Commitment/Facility Loan extract trailer *
      *               file(FACEXT4)                                   *
      *  SrCustDet  - Get Customer Details                            *
      *  SrBrchDet  - Get Branch Details                              *
      *  SrZZADD    - Do Hash Total                                   *
      *  SrInit     - Initialisation                                  *
      *  *PSSR      - Program exception error routine                 *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Commitment/Facility Loan detail extract file
     FFACEXFA   IF   E             DISK    INFSR(*PSSR)
     F                                     PREFIX(FA)
 
      ** Tranche-Aggregate Facilities Relationship
     FLETRAGL0  IF A E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L0:2)
 
      ** Aggregate Facility Commitment/Facility Loan detail extract
     FLEAGCEPD  UF A E             DISK    INFSR(*PSSR)
     F                                     RENAME(FACEXFAF:AGCEXFAF)
     F                                     COMMIT
 
      ** Aggregate Facilities Detail table
     FLEAGFYJ0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(L4)
 
      ** Facility Group file
     FLEFCGRL1  IF A E           K DISK    INFSR(*PSSR)
 
      ** Aggregate Facilities extract table
     FLEAGFEPD  IF A E             DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      ** Commitment/Facility Loan extract trailer file
     FFACEXT4   UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Array containing Copyright statement
     D WCPY@           S             80    DIM(1) CTDATA PERRCD(1)
 
      ** Short Data Structure for Access Programs
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Long Data Structure for Access Programs
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for Customer Details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
     D  QQDFAC1      E                     EXTFLD(QQDFAC)
 
      ** Local data area for database error details
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Data Structure for Aggregate Facility Reference Number
     D KeyAGRN         DS            14
     D  WkBRCA                 1      3
     D  WkCNUM                 4      9
     D  WkFACT                10     12
     D  WkFCNO                13     14
 
      ** Parameters for access object programs
     D PRtCd           S              7
     D POptn           S              7
     D PCust           S             10
     D PKyst           S              7
 
      ** Parameters for ZZADD
     D PzAmt           S             15P 3
     D PzToyI          S             15P 0
     D PzTotD          S              3P 0
 
      ** Other work fields
     D WBIS@           S             80
     D WDUMP           S              1
 
     D WkTmp4N         S              4S 0
     D WkTmp5N         S              5S 0
     D WkInclude       S              1
     D WkNoLR          S              3S 0
     D WkValLnRec      S             15S 0
     D WkNoFR          S              3S 0
     D WkValFcRec      S             15S 0
 
     ******************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * MAIN - Main Processing                                        *
      *                                                               *
      *****************************************************************
 
      ** Initialisation
 
     C                   EXSR      SrInit
 
      ** Process Commitment/Facility Loan detail extract file(FACEXFA)
 
     C                   EXSR      SrFacExtD
 
      ** Process Aggregate Facilities detail file(LEAGFMPD/LEAGFNPD)
 
     C                   EXSR      SrAggFclty
 
      ** Update Commitment/Facility Loan extract trailer file(FACEXT4)
 
     C                   EXSR      SrFacExtT
 
     C                   COMMIT
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFacExtD  - Process Commitment/Facility Loan detail         *
      *               extract file(FACEXFA)                           *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SrCustDet, SrBrchDet                                  *
      *                                                               *
      *****************************************************************
     C     SrFacExtD     BEGSR
 
     C                   READ      FACEXFA
     C                   DOW       NOT %EOF(FACEXFA)
 
     C                   EVAL      KCusNum = FACNUM
     C                   EVAL      WkTmp4N = *ZERO
     C                   MOVEL     FACFNO        WkTmp4N
     C                   MOVE      WkTmp4N       KFacTyp
     C                   MOVE      FACFNO        KFacSeq
     C     KeyTRAG       CHAIN     LETRAGL0
     C                   DOW       %FOUND(LETRAGL0) AND
     C                             NOT %EOF(LETRAGL0)
 
     C                   EVAL      RECI = 'D'
     C                   EVAL      BRCA = FABRCA
     C**********         EVAL      PNUM = *ZERO                                               CSD027
     C                   EVAL      PNUM = *BLANKS                                             CSD027
     C                   EVAL      CNUM = L0AGNM
     C                   EVAL      WkTmp5N = *ZERO
     C                   MOVEL     L0AGFT        WkTmp5N
     C                   MOVE      L0AGFN        WkTmp5N
     C**********         EVAL      CFNO = WkTmp5N                                           BUG27091
     C                   MOVEL     WkTmp5N       CFNO                                       BUG27091
     C                   EVAL      RCDT = FARCDT
     C                   EVAL      DDCY = FADDCY
     C                   EVAL      AMNT = FAAMNT
     C                   EVAL      CRSK = FACRSK
 
      ** Get customer details
 
     C                   MOVEL     L0AGNM        PCust
     C                   EXSR      SrCustDet
     C                   EVAL      CLOC = BBCOLC
     C                   EVAL      MDAT = FAMDAT
     C                   EVAL      FCLB = L0AGBR
     C                   EVAL      ZZ016 = *BLANKS
 
      ** Get branch details
 
     C                   EVAL      PBrca = L0AGBR
     C                   EXSR      SrBrchDet
     C                   EVAL      CMPYM = A8CMCD
     C                   EVAL      PTYP = FAPTYP
     C                   EVAL      LTYP = FALTYP
     C                   EVAL      SUTP = FASUTP
     C                   EVAL      CLAS = FACLAS                                              CLE042
     C                   EVAL      ORGL = FAORGL
     C                   EVAL      DDRF = FADDRF
 
     C                   WRITE     AGCEXFAF
 
     C                   EVAL      WkNoLR = WkNoLR + 1
     C                   EVAL      WkValLnRec = WkValLnRec + FAAMNT
     C     KeyTRAG       READE     LETRAGL0
     C                   ENDDO
 
     C                   READ      FACEXFA
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAggFclty - Process Aggregate Facilities detail             *
      *               file(LEAGFMPD/LEAGFNPD)                         *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SrCustDet, SrBrchDet                                  *
      *                                                               *
      *****************************************************************
     C     SrAggFclty    BEGSR
 
     C     *LOVAL        SETLL     LEAGFYJ0
     C                   READ      LEAGFYJ0
     C                   DOW       NOT %EOF(LEAGFYJ0)
     C                   EVAL      WkInclude = 'Y'
 
     C                   IF        L4RECI = 'E'
     C                   EVAL      WkBRCA = L4BRCA
     C                   MOVE      L4CNUM        WkCNUM
     C                   MOVE      L4FACT        WkFACT
     C                   MOVE      L4FCNO        WkFCNO
 
     C     KeyAGRN       CHAIN     LEFCGRL1
     C                   IF        NOT %FOUND(LEFCGRL1)
     C                   EVAL      WkInclude = 'N'
     C                   ENDIF
 
     C                   IF        WkInclude = 'Y'
     C                   EVAL      RECI = 'D'
     C                   EVAL      BRCA = L4BRCA
 
      ** Get customer details
 
     C                   MOVEL     L4CNUM        PCust
     C                   EXSR      SrCustDet
     C                   MOVEL     BBPCNB        PNUM
     C                   EVAL      CNUM = L4CNUM
 
     C                   EVAL      WkTmp5N = *ZERO
     C                   MOVEL     L4FACT        WkTmp5N
     C                   MOVE      L4FCNO        WkTmp5N
     C**********         EVAL      CFNO = WkTmp5N                                           BUG27091
     C                   MOVEL     WkTmp5N       CFNO                                       BUG27091
 
     C                   EVAL      RCDT = 'F'
     C                   EVAL      CMCY = L4FCCY
     C                   EVAL      RECIF = L4RECI
     C                   EVAL      OAMT = L4FAMT
     C                   EVAL      CAMT = L4OAM1
     C                   EVAL      CAVL = L4FAMT - L4OAM1
     C                   EVAL      FACI = 'F'
     C                   EVAL      FATP = L4FCTI
     C                   EVAL      CFTA = L4FAMT
     C                   EVAL      CNAM = BBCRNM
 
      ** Get branch details
 
     C                   EVAL      PBrca = L4BRCA
     C                   EXSR      SrBrchDet
     C                   EVAL      CMPYM = A8CMCD
     C                   EVAL      FCLB =  L4BRCA
     C                   EVAL      ZZ016 = *BLANKS
     C                   EVAL      PRTR = *BLANKS
 
     C                   WRITE     FACEXFCF
 
     C                   EVAL      WkNoFR = WkNoFR + 1
     C                   EVAL      WkValFcRec = WkValFcRec + L4PEXP
     C                   ENDIF
 
     C                   ENDIF
 
     C                   READ      LEAGFYJ0
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFacExtT  - Update Commitment/Facility Loan extract trailer *
      *               file(FACEXT4)                                   *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: SrZZADD, *PSSR                                        *
      *                                                               *
      *****************************************************************
     C     SrFacExtT     BEGSR
 
     C                   READ      FACEXT4
     C                   IF        NOT %EOF(FACEXT4)
 
     C                   EVAL      NOLR = NOLR + WkNoLR
     C                   EVAL      PzAmt = *ZERO
     C                   MOVE      WkValLnRec    PzAmt
     C                   EVAL      PzToyI = HLDW
     C                   EVAL      PzTotD = HLDC
     C                   EXSR      SrZZADD
     C                   EVAL      HLDW = PzToyI
     C                   EVAL      HLDC = PzTotD
 
     C                   EVAL      NOFR = NOFR + WkNoFR
     C                   EVAL      PzAmt = *ZERO
     C                   MOVE      WkValFcRec    PzAmt
     C                   EVAL      PzToyI = HFDW
     C                   EVAL      PzTotD = HFDC
     C                   EXSR      SrZZADD
     C                   EVAL      HFDW = PzToyI
     C                   EVAL      HFDC = PzTotD
 
     C                   UPDATE    FACEXT4F
 
     C                   ELSE
 
     C                   EVAL      NOLR = WkNoLR
     C                   EVAL      PzAmt = *ZERO
     C                   MOVE      WkValLnRec    PzAmt
     C                   Z-ADD     PzAmt         HLDW
     C                   MOVE      WkValLnRec    HLDC
 
     C                   EVAL      NOFR = WkNoFR
     C                   EVAL      PzAmt = *ZERO
     C                   MOVE      WkValFcRec    PzAmt
     C                   Z-ADD     PzAmt         HFDW
     C                   MOVE      WkValFcRec    HFDC
 
     C                   EVAL      ZZ053 = *BLANKS
     C                   WRITE     FACEXT4F
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCustDet  - Get Customer Details                            *
      *                                                               *
      *  Called by: SrFacExtD, SrAggFclty                             *
      *                                                               *
      *  Calls: A0CUSTR0, *PSSR                                       *
      *                                                               *
      *****************************************************************
     C     SrCustDet     BEGSR
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    PCust
     C                   PARM      *BLANKS       PKyst
     C     SDCUST        PARM      SDCUST        DSSDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDCUSTPD'
     C                   EVAL      DBase = 2
     C                   MOVEL     PCust         DBKey
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBrchDet  - Get Branch Details                              *
      *                                                               *
      *  Called by: SrFacExtD, SrAggFclty                             *
      *                                                               *
      *  Calls: A0BRCHR1, *PSSR                                       *
      *                                                               *
      *****************************************************************
     C     SrBrchDet     BEGSR
 
     C                   CALL      'AOBRCHR1'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY    '    POptn
     C                   PARM                    PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBRCHPD'
     C                   EVAL      DBase = 3
     C                   EVAL      DBKey = PBrca
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZZADD    - Do Hash Total                                   *
      *                                                               *
      *  Called by: SrFacExtT                                         *
      *                                                               *
      *  Calls: ZZADD                                                 *
      *                                                               *
      *****************************************************************
     C     SrZZADD       BEGSR
 
     C                   CALLB     'ZZADD'
     C                   PARM                    PzAmt
     C                   PARM                    PzToyI
     C                   PARM                    PzTotD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit     - Initialisation                                  *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     SrInit        BEGSR
 
      ** Initialise counters
 
     C                   EVAL      WkNoLR = *ZERO
     C                   EVAL      WkValLnRec = *ZERO
     C                   EVAL      WkNoFR = *ZERO
     C                   EVAL      WkValFcRec = *ZERO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR     - Initial First Cycle processing                  *
      *                                                               *
      *  Called by: Automatically called upon entry to the module     *
      *                                                               *
      *  Calls: SR/*PSSR                                              *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C                   MOVEA     WCPY@         WBIS@
 
      ** Set up Local Data Area (LDA)
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = *BLANKS
     C                   EVAL      DBKey = *BLANKS
     C                   EVAL      DBPgm = *BLANKS
     C                   EVAL      DBPgm = 'LE000065'
     C                   EVAL      DBase = *ZERO
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   EVAL      DBase = 1
     C                   EVAL      DBKey = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Define working varibles
 
     C     *LIKE         DEFINE    L0AGBR        PBrca
     C     *LIKE         DEFINE    L0TRNM        KCusNum
     C     *LIKE         DEFINE    L0TRFT        KFacTyp
     C     *LIKE         DEFINE    L0TRFN        KFacSeq
 
     C     KeyTRAG       KLIST
     C                   KFLD                    KCusNum
     C                   KFLD                    KFacTyp
     C                   KFLD                    KFacSeq
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR      - Program exception error routine                 *
      *                                                               *
      *  Called by: *INZSR                                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
     C                   IF        WDUMP = *BLANKS
     C                   EVAL      WDUMP = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   DUMP
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
     C****************************************************************
** WCPY@
(c) Finastra International Limited 2004
