     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Derivatives w/o hedged items FF/SE/FH')       *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards module                          *
      *                                                               *
      *  AS001009 - Hedge Derivatives with no Hedged Items (Trading)  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
      *                 CDL094             Date 11Jun14               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CDL038             Date 10May05               *
      *                 229406             Date 07Sep04               *
      *                 227695             Date 17Jun04               *
      *                 226170             Date 05Apr04               *
      *                 225287             Date 27Feb04               *
      *                 225293             Date 26Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 224116             Date 05Jan04               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance Receive Settlement Instructions             *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  229406 - Report shows value in OCI column related to FRA     *
      *           transaction which is not valid.                     *
      *  227695 - For MM deals, check liquidity premium instead of    *
      *           base rate and spread rate to determine whether to   *
      *           use all-in-rate or net treasury rate file.          *
      *  226170 - UP/UL amounts for RX deals are already in base ccy. *
      *           Do not convert.  Also need to check which side is   *
      *           hedged in SRDLNO.                                   *
      *  225287 - Report is showing duplicate entries with zero       *
      *           amounts                                             *
      *  225293 - Report is showing the NPV of the previous           *
      *           transaction.                                        *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224116 - Hedge report should show buy out date as maturity   *
      *           date if deal has been bought out                    *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    XX         Function of indicator                           *
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
 
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
     F                                     RENAME(SDHGSTD0:SDHGSTD2)
      ** RTV : Hedge Strategy Retrieval index
 
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
     F                                     RENAME(SDHGSTD0:SDHGSTD3)
      ** RTV : Hedge Strategy Retrieval index
 
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHGLKD0:ASHGLKD1)
     F                                     PREFIX(H2:2)
      ** RTV : Hedge Linkage Retrieval index
 
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHGLKD0:ASHGLKD2)
     F                                     PREFIX(H2:2)
      ** RTV : Hedge Linkage Retrieval index
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND1)
     F                                     PREFIX(H3:2)
      ** RTV : Hedge Transactions Retrieval Index
 
     FASHTRNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND2)
     F                                     PREFIX(H3:2)
      ** RTV : Hedge Transactions Retrieval Index
 
     FASHTRNL8  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND8)
     F                                     PREFIX(H3:2)
      ** RTV : Hedge Transactions Retrieval Index
                                                                                              225293
     FASHTRNLB  IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     RENAME(ASHTRND0:ASHTRNDB)                          225293
     F                                     PREFIX(HI)                                         225293
 
     F***IRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                    CAS005
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
      ** RTV : Midas FAS133 Revalued FRA's & IRS's
 
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(IRNPVAD0:IRNPVBD0)                          CAS005
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (SIRS)                        CAS005
                                                                                              CAS005
     F***RXNPVAL0  IF   E           K DISK    INFSR(*PSSR)                             CAS005 225293
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)                                       225293
      ** RTV : Revalued FRAs and IRSs File (CIRS)                                             CAS005
                                                                                              CAS005
     F***RXNPVBL0  IF   E           K DISK    INFSR(*PSSR)                             CAS005 225293
     FRXNPVBL1  IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     RENAME(RXNPVAD0:RXNPVBD0)                          CAS005
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (CIRS)                        CAS005
                                                                                              CAS005
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas IR Revalued FRA File                                                           CAS006
                                                                                              CAS006
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(FRNPVAD0:FRNPVLD0)                          CAS006
      ** Midas IR Ravalued using Net Treasury File                                            CAS006
                                                                                              CAS006
     FFFNPVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV:  Midas FAS133 Revalued Futures/Options Positions
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
      ** RTV: Deals Files
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       CAS003
      ** RTV:  Midas FF Transaction details - detail                                          CAS003
                                                                                              CAS003
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     IGNORE(CLOANHHF)                                   225293
     F                                     IGNORE(CLOANCKF)                                   225293
     F                                     IGNORE(CLOANZ1F)                                   225293
      ** RTV: Loans                                                                           225293
                                                                                              225293
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     PREFIX(B2)                                         225293
      ** Midas SE Book Position Headers                                                       225293
                                                                                              225293
     FAS001009P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFDS(SPOOL1)
      ** PRT: Printer file (Transaction Detail)-Trading
 
     FAS001009P2O    E             PRINTER OFLIND(*IN67)
     F                                     INFDS(SPOOL2)
      ** PRT: Printer file (Transaction Detail)-Partial
 
     FAS001009AUO    E             PRINTER
     F                                     INFDS(SPOOLU)
      ** PRT: Printer file (Audit)
 
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
     D/COPY ZACPYSRC,PSDS
      *
      ** Program Status Data Structure
 
      ** +-----------------------------------------------------------------+
      ** D specs of the following types should be inserted after the
      ** relevant box.  *** Remove this text afterwards. ***
      ** +-----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
     D NUM             S              2  0 DIM(12) ALT(MON)
 
     D TP              S              2    DIM(3) CTDATA PERRCD(1)
     D A22             S              1    DIM(22)
 
      ** Arrays for Unrealised P/L
     D AR              S             13  0 DIM(3)
     D AMT             S             18    DIM(3)
 
      ** Trade
     D D0              S             13  0 DIM(3)
     D D1              S             13  0 DIM(3)
     D D2              S             13  0 DIM(3)
     D D3              S             13  0 DIM(3)
 
      ** Partial
     D D0@             S             13  0 DIM(3)
     D D1@             S             13  0 DIM(3)
     D D2@             S             13  0 DIM(3)
     D D3@             S             13  0 DIM(3)
 
      ** File information data structure
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      * Todays date etc.
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  MBIN                  13     13
 
      ** File Information Data Structure for AS001009P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001009P2
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for AS001009AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** Work Indicators
     D WLVInd          DS
     D  WLVInd3                1      1
     D  WLVInd2                2      2
     D  WLVInd1                3      3
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for SC Switchable Features                                                        CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS003
      ** DS for access programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for access programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Data structure for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External Data Structures for General Ledger Details                                  CAS004
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAS004
                                                                                              CAS004
     D                 DS
     D  UPL                    1     39  0
     D                                     DIM(3)
     D  URPL                   1     13  0
     D  YUPL                  14     26  0
     D  DIFF                  27     39  0
 
     D                 DS
     D  H3FPSE                 1     10
     D  INSKEY                 1      5                                                       CAS003
     D  INSFLD                 6     10
     D  INSMM@                 6      8
     D  INSYY@                 9     10
     D  H3BKCD                11     12
     D  H3BRCA                13     15
     D  H3PCAL                16     16
     D  H3MKTI                17     17
     D  H3BHTV                18     18
     D  H3KEY                  1     18
 
     D                 DS
     D  MODE                   1      2
     D  MODE01                 1      1
     D  MODE02                 2      2
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D @RUN            S              1
 
     D PRetCode        S              7
     D POption         S              7
     D PCcy            S              3
     D PBRCA           S              3
     D PSAR            S              6                                                       CAS003
                                                                                              CAS003
     D CAS003          S              1    INZ('N')                                           CAS003
     D CAS005          S              1    INZ('N')                                           CAS005
     D CAS006          S              1    INZ('N')                                           CAS006
 
      ** Parameters for ZCCYCN
     D ZAMTF           S             15P 0
     D ZCCYF           S              3A
     D ZCCYT           S              3A
     D ZRATEF          S             13P 8
     D ZRATET          S             13P 8
     D ZMDINF          S              1A
     D ZMDINT          S              1A
     D ZCDPF           S              1P 0
     D ZCDPT           S              1P 0
     D ZAMTT           S             15P 0
     D ZCRSRT          S             13P 8
     D ZCRSMD          S              1A
 
     D Print           S              1
     D DCount          S              7  0
     D LCount          S              7  0
     D TCount          S              7  0
 
     D WrkDln          S             10
     D WrkBkc          S              2
     D WRKTYP          S              2
     D WRKSTP          S              2
     D*WRKCNU***       S              6  0                                                    CSD027
     D WRKCNU          S              6                                                       CSD027
     D WRKVAL          S              5  0
     D WRKMAT          S              5  0
     D WRKBOV          S              5  0                                                    224116
     D WRKCCY          S              3
     D WRKPR$          S             13  0
     D WRKAM$          S             13  0
     D WRKINT          S             11  0
     D WQ0002          S              1
     D @3VDAT          S              6  0
     D @MATD           S              6  0
     D PCT             S              6  2
     D PCTFLD          S              8  5
     D WRK20           S             20
     D WRK21           S             21
     D WDTYP           S              2                                                       229406
 
     D CN              S              1  0
     D M               S              3  0
     D X               S              1  0
     D INSYY           S              2  0                                                    CAS003
     D INSMM           S              2  0                                                    CAS003
     D INBRCA          S              1
     D INHESN          S              1
     D INPRTP          S              1
     D IN25            S              3
     D SVHEDI          S              6
     D @BRCA           S              3
     D @PRTP           S              2
     D @HESN           S             10
     D @EFLO           S              7  4
     D @EFHI           S              7  4
     D***DDNO***         S              6  0                                                  CLE148
     D DDNO            S              6                                                       CLE148
     D DFPO            S             10
     D KYBKC           S              2
     D KYBRCA          S              3
     D KYPCAL          S              1
     D TOTPCT          S              9  2
     D X3HEDI          S              6  0
     D X3MOD           S              2
     D HGDIN           S              1
     D L1CNTT          S              7  0
     D L2CNTT          S              7  0
     D L3CNTT          S              7  0
     D L1CNTD          S              7  0
     D L2CNTD          S              7  0
     D L3CNTD          S              7  0
     D ZADFMF          S             10
     D WURDNB          S              5  0
     D HGHDIN          S              1
     D WRKEVT          S              5  0                                                    CAS004
     D WEvCtlDt        S              5  0                                                    CAS004
     D WEVCD           S              6  0                                                    CAS004
 
      ** Parameters for ZSFILE
     D SEQ             S              5
     D SENTY           S              3
     D ZSNUM           S              6  0
     D ZSERR           S              1
     D ZSNUMU          S              6  0
 
      ** Parameters for ZFRPED
     D ZFLD15          S             15  0
     D ZDECS           S              1  0
     D ZECODE          S              1
     D ZOUT22          S             22
     D ZOUT25          S             25
                                                                                              225293
     D WkBase          S              1                                                       225293
                                                                                              225293
      ** Fields used to define Key List for Midas AS Hedge Transaction File                   225293
      ** Retrieval                                                                            225293
     D KAShed          S              6S 0                                                    225293
     D KASdhi          S              1A                                                      225293
                                                                                              225293
      ** Fields used to define Key List for Midas SE Revalued Security                        225293
      ** Positions File                                                                       225293
     D KSEsesn         S             10                                                       225293
     D KSEbrca         S              3                                                       225293
     D KSEbokc         S              2                                                       225293
     D KSEmkti         S              1                                                       225293
     D KSEbhtv         S              1                                                       225293
 
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
 
     C     *LOVAL        SETLL     SDHGSTL2
     C                   READ      SDHGSTL2                               12
 
      ** Audit Report if end of file
 
     C                   IF        *IN12 = *On
     C                   EXSR      SRAudit
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       *IN12 = *Off
 
     C                   SELECT
     C                   WHEN      @BRCA <> H1BRCA
     C                   EVAL      WLVInd = 'YYY'
 
     C                   WHEN      @PRTP <> H1PRTP
     C                   EVAL      WLVInd = 'NYY'
 
     C                   WHEN      @HESN <> H1HESN
     C                   EVAL      WLVInd = 'NNY'
     C                   ENDSL
 
      ** If Change in branch
 
     C                   IF        WLVInd3 = 'Y'
     C                   EVAL      *IN03 = *On
     C                   EXSR      SRINL3
     C                   EVAL      *IN03 = *Off
     C                   ENDIF
 
     C                   EXSR      SRProcess
 
     C                   READ      SDHGSTL2                               12
 
      ** At the End of Product Type, Print Totals
 
     C                   IF        @PRTP <> H1PRTP or *IN12 = *On
     C                             OR @BRCA <> H1BRCA                                         225287
     C                   EVAL      INPRTP = *BLANKS
     C                   IF        L2CNTT > *ZEROS
     C                   EXSR      SRL2TO
     C                   ENDIF
     C                   IF        L2CNTD > *ZEROS
     C                   EXSR      SR@2TO
     C                   ENDIF
     C                   ENDIF
 
      ** At end of branch print totals, trailer and close printer file
 
     C                   IF        @BRCA <> H1BRCA or *IN12 = *On
     C                   EVAL      INBRCA = *BLANKS
     C                   IF        L3CNTT > *ZEROS
     C                   EXSR      SRL3TO
     C                   ENDIF
     C                   IF        L3CNTD > *ZEROS
     C                   EXSR      SR@3TO
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess                                                     *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   IF        INBRCA = 'Y'
     C                   IF        WLVInd2 = 'Y'
     C                   EVAL      *IN02 = *On
     C                   EXSR      SRINL2
     C                   EVAL      *IN02 = *Off
     C                   ENDIF
 
     C                   IF        INPRTP = 'Y'
     C                   IF        WLVInd1 = 'Y'
     C                   EVAL      *IN01 = *On
     C                   EXSR      SRINL1
     C                   EVAL      *IN01 = *Off
     C                   ENDIF
 
     C                   IF        INHESN = 'Y'
     C                   EVAL      SCount = SCount + 1
     C                   EXSR      SRLNK1
 
      ** At end of Strategy print totals
 
     C                   EVAL      INHESN = *Blanks
     C                   IF        L1CNTT > *Zeros
     C                   EXSR      SRL1TO
     C                   ENDIF
     C                   IF        L1CNTD > *Zeros
     C                   EXSR      SR@1TO
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLNK1 - Hedge Linkage Processing Main                       *
      *                                                               *
      *****************************************************************
     C     SRLNK1        BEGSR
 
      ** For each Hedge Strategy -read all Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     H1HESN        SETLL     ASHGLKD2
 
     C     H1HESN        READE     ASHGLKD2                               89
 
     C                   DOW       *IN89 = *OFF
 
      ** If qualified Hedge Linkage record exists
 
     C                   IF        H2RECI = 'T' or H2RECI = 'D' or
     C                             H2RECI = 'X' and H2LASD = BJRDNB
 
      ** Process Hedge Transaction records without detail printing
 
     C                   EVAL      PRINT = 'N'
     C                   EXSR      SRLNK2
 
      ** If qualified Transaction Details exist
 
     C                   IF        TCOUNT > *ZEROS
 
      ** Increment Hedge Linkage count
 
     C                   EVAL      LCount = LCount + 1
 
      ** Process Hedge Transaction records with detail printing
 
     C                   EVAL      PRINT = 'Y'
     C                   EXSR      SRLNK2
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKD2                               89
 
     C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLNK2 - Hedge Linkage Processing Subordinated               *
      *                                                               *
      *****************************************************************
     C     SRLNK2        BEGSR
      *
      ** Initialise Hedge Transaction count
      *
     C                   EVAL      TCOUNT = *ZEROS
      *
      ** Process and print applicable Derivative Transaction records
      *
     C                   EVAL      DCOUNT = *ZEROS
     C                   EVAL      HGHDIN = 'D'
     C                   EXSR      SRTRN1
      *
      ** If Derivative Transaction records exist -print Derivative total
      *
     C                   IF        PRINT = 'Y' and DCOUNT > *ZEROS
     C                   SELECT
     C                   WHEN      H2RECI = 'T'
     C                   EXSR      SRLDTO
 
     C                   WHEN      H2RECI = 'D' or
     C                             H2RECI = 'X' and H2LASD = BJRDNB
     C                   EXSR      SR@DTO
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN1 - Hedge Transaction Processing                        *
      *                                                               *
      *****************************************************************
     C     SRTRN1        BEGSR
 
      ** Read all Derivative or Hedged Transaction records of a Hedge
 
     C                   EVAL      *IN87 = *Off
     C     KYTRAN        SETLL     ASHTRND1
     C     KYTRAN        READE     ASHTRND1                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If in non-print mode -increment count of processed records;
      ** otherwise, convert file fields for printing and print details
 
     C                   IF        PRINT = 'N'
 
      ** Include only Trade or Partial transactions with 0 < % < 100
 
     C                   IF        H2RECI = 'T' or  H2RECI = 'D' and
     C                             H3PCTG > *ZEROS and H3PCTG < 100 or
     C                             H2RECI = 'X' and H2LASD = BJRDNB and
     C                             H3PCTG > *ZEROS and H3PCTG < 100
                                                                                              225287
     C                   IF        H2RECI <> 'T'                                              225287
     C                   EXSR      SRPCT                                                      225287
     C                   ENDIF                                                                225287
                                                                                              225287
     C                   IF        H2RECI = 'T'                                               225287
     C                             OR TOTPCT <> 100                                           225287
     C                   EVAL      TCount = TCount + 1
     C                   ENDIF                                                                225287
                                                                                              225287
     C                   ENDIF
 
     C                   ELSE
 
     C                   EXSR      SRTRN2
     C                   ENDIF
 
     C     KYTRAN        READE     ASHTRND1                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN2 - Move date to workfields and printe Transaction      *
      *           Report                                              *
      *                                                               *
      *****************************************************************
     C     SRTRN2        BEGSR
 
      ** Clear workfields
 
     C                   EVAL      WRKDLN = *BLANKS
     C                   EVAL      WRKBKC = *BLANKS
     C                   EVAL      WRKTYP = *BLANKS
     C                   EVAL      WRKSTP = *BLANKS
     C**********         EVAL      WRKCNU = *ZEROS                                            CSD027
     C                   EVAL      WRKCNU = *BLANKS                                           CSD027
     C                   EVAL      WRKVAL = *ZEROS
     C                   EVAL      WRKMAT = *ZEROS
     C                   EVAL      WRKCCY = *BLANKS
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
     C                   EVAL      URPL = *ZEROS
     C                   EVAL      YUPL = *ZEROS
     C                   EVAL      DIFF = *ZEROS
      *
      ** Retrieve Transaction details from pertinent files
      *
     C                   SELECT
     C                   WHEN      H3MOD = 'DL'
     C                   EXSR      SRDLNO
 
     C                   WHEN      H3MOD = 'FF' and CAS003 = 'Y'                              CAS003
     C                   EXSR      SRFFNO                                                     CAS003
     C                   ENDSL
 
      ** If record found in file
 
     C                   IF        *IN55 = *OFF
 
      ** Clear detail printer file record
 
     C                   IF        H2RECI = 'T'
     C                   CLEAR                   DETAIL1
     C                   ELSE
     C                   CLEAR                   DETAIL2
     C                   ENDIF
 
      ** Load printer file fields
 
     C                   EXSR      SRTRN3
 
      ** Print Hedge Transaction details
 
     C                   IF        H2RECI = 'T'
 
      ** Check if printing new Hedge Id.  If so, print heading.
 
     C                   IF        OHEDI <> SVHEDI
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     DETAIL1H
     C                   ENDIF
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
 
     C                   WRITE     DETAIL1
 
     C                   EVAL      L1CNTT = L1CNTT + 1
     C                   EVAL      L2CNTT = L2CNTT + 1
     C                   EVAL      L3CNTT = L3CNTT + 1
 
     C                   ELSE
 
     C                   IF        TOTPCT <> 100                                              225287
      ** Check if printing new Hedge Id.  If so, print heading.
 
     C                   IF        OHEDI <> SVHEDI
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     DETAIL2H
     C                   ENDIF
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
 
     C                   WRITE     DETAIL2
 
     C                   EVAL      L1CNTD = L1CNTD + 1
     C                   EVAL      L2CNTD = L2CNTD + 1
     C                   EVAL      L3CNTD = L3CNTD + 1
     C                   ENDIF                                                                225287
 
     C                   ENDIF
 
      ** Save value of Hedge Id which was just printed.
 
     C                   IF        H2RECI = 'T'                                               225287
     C                             OR TOTPCT <> 100                                           225287
     C                   EVAL      SVHEDI = OHEDI
 
      ** Increment count of Derivative Transaction records
 
     C                   EVAL      DCount = DCount + 1
     C                   ENDIF                                                                225287
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDLNO - Deal Processing                                     *
      *                                                               *
      *****************************************************************
     C     SRDLNO        BEGSR
 
     C                   MOVEL     H3DLNO        H3DLNO2           6 0                        CLE148
     C*****H3DLNO        CHAIN     DEALSDBF                           55                      CLE148
     C     H3DLNO2       CHAIN     DEALSDBF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****H3DLNO        CHAIN     DEALSDGF                           55                      CLE148
     C     H3DLNO2       CHAIN     DEALSDGF                           55                      CLE148
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     H3DLNO        WRKDLN
     C                   EVAL      WRKBKC = BOKC
     C                   EVAL      WRKTYP = DTYP
     C                   EVAL      WRKSTP = DLST
     C                   EVAL      WRKCNU = CNUM
     C                   EVAL      WRKVAL = VDAT
     C                   EVAL      WRKMAT = MDAT
     C                   EVAL      WRKBOV = *ZEROS                                            224116
      *
     C                   IF        RCDFMT = 'DEALSDBF'
     C                   EVAL      WRKMAT = *Zeros
     C                   EVAL      WRKCCY = *Blanks
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
     C                   EVAL      URPL = FSURPL
     C                   EVAL      YUPL = FSYUPL
 
     C                   ELSE
 
     C                   IF        RCDFMT = 'DEALSDGF'
     C                   EVAL      WRKBOV = BOVD                                              224116
                                                                                              226170
     C                   IF        DTYP = 'RX'  AND                                           226170
     C                             H3HSID = 'T' AND                                           226170
     C                             CAS005 = 'Y'                                               226170
     C                   EVAL      WRKCCY = TCUCY                                             226170
     C                   EVAL      WRKPR$ = TPAMT                                             226170
     C                   ELSE                                                                 226170
     C                   EVAL      WRKCCY = UCUCY
     C                   EVAL      WRKPR$ = UPAMT
     C                   ENDIF                                                                226170
 
      ** Fair Value Interest Rate processing
 
     C                   SELECT
 
     C                   WHEN      H1PRTP = 'FV'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   ELSE
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   ENDIF
 
      ** Cash Flow Interest Rate processing
 
     C                   WHEN      H1PRTP = 'CF'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   TEINR         WRKINT
     C                   ELSE
     C     10000000      MULT(H)   UEINR         WRKINT
     C                   ENDIF
 
     C                   ENDSL
                                                                                              225293
     C                   IF        CAS005 = 'Y'                                               225293
     C                             AND H2RIND = ' '                                           225293
     C                   EVAL      WDTYP = DTYP                                               229406
     C                   EXSR      SRChkHdgI                                                  225293
     C                   EVAL      DTYP = WDTYP                                               229406
     C                   ENDIF                                                                225293
 
     C                   IF        CAS005 = 'Y'                                               CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'RS'                                                CAS005
     C                   IF        H2RIND = 'L'                                               CAS005
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****H3DLNO        CHAIN     IRNPVAL0                           56               CAS005 CLE148
     C                   MOVE      H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     IRNPVAL0                           56                      CLE148
     C                   ENDIF                                                                CAS005
     C                   IF        H2RIND = 'B'                                               CAS005
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****H3DLNO        CHAIN     IRNPVBL0                           56               CAS005 CLE148
     C                   MOVE      H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     IRNPVBL0                           56                      CLE148
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'RX'                                                CAS005
     C                   IF        H2RIND = 'L'                                               CAS005
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****H3DLNO        CHAIN     RXNPVAL0                           56               CAS005 225293
     C     KRXNPV        CHAIN     RXNPVAL1                           56                      225293
     C                   ENDIF                                                                CAS005
     C                   IF        H2RIND = 'B'                                               CAS005
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****H3DLNO        CHAIN     RXNPVBL0                           56               CAS005 225293
     C     KRXNPV        CHAIN     RXNPVBL1                           56                      225293
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS006
     C                   IF        DTYP = 'FR' AND CAS006 = 'Y'                               CAS006
     C                   IF        H2RIND = 'L'                                               CAS006
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****H3DLNO        CHAIN     FRNPVAL0                           56               CAS006 CLE148
     C                   MOVE      H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     FRNPVAL0                           56                      CLE148
     C                   ENDIF                                                                CAS006
     C                   IF        H2RIND = 'B'                                               CAS006
     C                             OR H2RIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****H3DLNO        CHAIN     FRNPVLL0                           56               CAS006 CLE148
     C                   MOVE      H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     FRNPVLL0                           56                      CLE148
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C*****H3DLNO        CHAIN     IRNPVLD0                           56                      CAS005
     C*****H3DLNO        CHAIN     IRNPVAD0                           56               CAS005 CLE148
     C                   MOVE      H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     IRNPVAD0                           56                      CLE148
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        *IN56 = *OFF
     C                   EVAL      URPL =  IRURPL
     C                   EVAL      YUPL = IRYUPL
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      *  SRFFNO - Futures Position processing                         *                       CAS003
      *                                                               *                       CAS003
      *****************************************************************                       CAS003
     C     SRFFNO        BEGSR                                                                CAS003
                                                                                              CAS003
      ** Futures Position Mode                                                                CAS003
                                                                                              CAS003
     C**********         IF        H3DLNO = *ZEROS and H3FPSE <> *Blanks and           CAS003 CLE148
     C                   IF        H3DLNO = *BLANKS and H3FPSE <> *Blanks and                 CLE148
     C                             INSFLD <> *Blanks                                          CAS003
                                                                                              CAS003
     C                   EVAL      M = 1                                                      CAS003
     C                   EVAL      *IN66 = *OFF                                               CAS003
     C     INSMM@        LOOKUP    MON(M)                                 66                  CAS003
                                                                                              CAS003
     C                   IF        *IN66 = *ON                                                CAS003
     C                   EVAL      INSMM = NUM(M)                                             CAS003
     C                   MOVE      INSYY@        INSYY                                        CAS003
                                                                                              CAS003
     C     KEYPST        CHAIN     FFNPVLD0                           55                      CAS003
                                                                                              CAS003
     C                   IF        *IN55 = *OFF                                               CAS003
     C                   MOVEL     H3FPSE        WRKDLN                                       CAS003
     C                   EVAL      WRKBKC = H3BKCD                                            CAS003
     C                   EVAL      WRKSTP = H3PCAL                                            CAS003
     C                   EVAL      WRKCCY = FFCCY                                             CAS003
     C                   EVAL      WRKPR$ = FFCUTV                                            CAS003
     C     100000000     MULT(H)   FFSTRP        WRKINT                                       CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Futures Transaction Mode                                                             CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
     C*****H3DLNO        CHAIN     TRANSDF                            55               CAS003 CLE148
     C                   MOVEL     H3DLNO        H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     TRANSDF                            55                      CLE148
                                                                                              CAS003
     C                   IF        *IN55 = *OFF                                               CAS003
                                                                                              CAS003
     C                   MOVEL     H3DLNO        WRKDLN                                       CAS003
     C                   EVAL      WRKBKC = BOKC                                              CAS003
     C                   EVAL      WRKTYP = ISTT                                              CAS003
     C                   EVAL      WRKCNU = CUSC                                              CAS003
     C                   EVAL      WRKVAL = VALD                                              CAS003
     C                   EVAL      WRKCCY = ISCY                                              CAS003
     C                   EVAL      WRKPR$ = NUCO                                              CAS003
     C     100000000     MULT(H)   COPR          WRKINT                                       CAS003
     C                   EVAL      URPL = FSURPL                                              CAS003
     C                   EVAL      YUPL = FSYUPL                                              CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDSR                                                                CAS003
                                                                                              CAS003
      *****************************************************************                       CAS003
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN3 - Load workfields to print transaction report         *
      *                                                               *
      *****************************************************************
     C     SRTRN3        BEGSR
 
      ** Hedge Linkage ID
 
     C                   MOVE      H3HEDI        OHEDI
 
      ** Deal/FPO
 
     C                   MOVEL     WRKDLN        ODLNO
 
      ** Book Code
 
     C                   EVAL      OBKC = WRKBKC
 
      ** Type
 
     C                   EVAL      ODTYP = WRKTYP
 
      ** Subtype
 
     C                   EVAL      ODLST = WRKSTP
 
      ** Dash
 
     C                   IF        ODLST <> *BLANKS
     C                   EVAL      ODASH = '-'
     C                   ENDIF
 
      ** Customer Number
 
     C**********         IF        WRKCNU <> *ZEROS                                           CSD027
     C                   IF        WRKCNU <> *BLANKS                                          CSD027
     C                   MOVE      WRKCNU        OCNUM
     C                   ENDIF
 
      ** Value Date
 
     C                   IF        WRKVAL <> *ZEROS
     C                   CALL      'ZDATE2'
     C                   PARM                    WRKVAL
     C                   PARM      BJDFIN        WQ0002
     C                   PARM      *ZEROS        @3VDAT
     C                   PARM      *BLANKS       OVALD
     C                   ENDIF
 
      ** Maturity Date
 
     C                   IF        WRKMAT <> *ZEROS
                                                                                              224116
      ** If deal has been bought out, use buy out date as maturity date                       224116
                                                                                              224116
     C                   IF        WRKBOV <> 0                                                224116
     C                   EVAL      WRKMAT = WRKBOV                                            224116
     C                   ENDIF                                                                224116
                                                                                              224116
     C                   CALL      'ZDATE2'
     C                   PARM                    WRKMAT
     C                   PARM      BJDFIN        WQ0002
     C                   PARM      *ZEROS        @MATD
     C                   PARM      *BLANKS       OMATD
     C                   ENDIF
 
      ** Currency
 
     C                   IF        WRKCCY <> *BLANKS
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      WRKCCY        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode = *BLANKS
     C                   EVAL      ZCCYF = A6CYCD
     C                   EVAL      ZRATEF = A6SPRT
     C                   EVAL      ZMDINF = A6MDIN
     C                   EVAL      ZCDPF = A6NBDP
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = WRKCCY
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      OCCY = WRKCCY
 
     C                   ENDIF
 
      ** Percentage
 
     C                   EVAL      PCT = *ZEROS
     C                   EVAL      PCTFLD = *ZEROS
 
      ** For Trading -force 100 into percentage
 
     C                   IF        H2RECI = 'T'
     C                   EVAL      PCT = 100
 
     C                   ELSE
 
      ** For Partial -calculate total Hedging and Trading %
 
     C                   EXSR      SRPCT
 
     C                   IF        TOTPCT <> *ZEROS
     C     100           SUB       TOTPCT        PCT
     C     100           DIV(H)    TOTPCT        PCTFLD
     C                   ENDIF
 
     C                   ENDIF
 
      ** Principal
 
     C                   IF        WRKPR$ <> *ZEROS
 
      ** Consider Derivative Percentage etc.
 
     C                   IF        PCT <> 100
     C                   EVAL      WRKAM$ = WRKPR$
     C                   EXSR      SRCLC
     C                   EVAL      WRKPR$ = WRKAM$
     C                   ENDIF
 
     C                   EVAL      ZFLD15 = WRKPR$
     C                   EVAL      ZDECS  = ZCDPF
     C                   EVAL      ZECODE = 'J'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVEL     ZOUT22        WRK21
     C                   MOVE      WRK21         OPRIN
     C                   ENDIF
 
      ** Interest Rate
 
     C                   IF        WRKINT <> *ZEROS
     C                   EVAL      ZFLD15 = WRKINT
     C                   EVAL      ZDECS  = 7
     C                   EVAL      ZECODE = 'L'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
      ** Strip out negative sign.
 
     C                   MOVEL     ZOUT22        WRK20
     C                   MOVE      WRK20         OINTR
     C                   ENDIF
 
      ** Unrealised P/L-related
 
     C                   IF        H2RECI = 'T'                                               225287
     C                             OR TOTPCT <> 100                                           225287
     C                   EXSR      SRUPL
     C                   ENDIF                                                                225287
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPL  - Unrealised P/L - related                            *
      *                                                               *
      *****************************************************************
     C     SRUPL         BEGSR
 
      ** Compare Hedge Linkage Start Date with Previous End of Year
 
     C                   IF        H2STDT > BJPEYD
     C                   EVAL      YUPL = *ZEROS
     C                   ENDIF
 
      ** Consider Derivative Percentage etc.
 
     C                   IF        PCT <> 100
 
      ** URPL
 
     C                   Z-ADD     URPL          WRKAM$
     C                   EXSR      SRCLC
     C                   Z-ADD     WRKAM$        URPL
 
      ** YUPL
 
     C                   Z-ADD     YUPL          WRKAM$
     C                   EXSR      SRCLC
     C                   Z-ADD     WRKAM$        YUPL
 
     C                   ENDIF
 
      ** Convert to Base Currency
      ** URPL
     C                   IF        WRKTYP <> 'RX'                                             226170
 
     C                   IF        URPL <> *ZEROS
     C     1             MULT      URPL          ZAMTF
     C                   EXSR      SRConCcy
     C     1             MULT      ZAMTT         URPL
     C                   ENDIF
 
      ** YUPL
 
     C                   IF        YUPL <> *ZEROS
     C     1             MULT      YUPL          ZAMTF
     C                   EXSR      SRConCcy
     C     1             MULT      ZAMTT         YUPL
     C                   ENDIF
 
     C                   ENDIF                                                                226170
      ** Calculate P/L Difference
 
     C                   EVAL      DIFF = URPL - YUPL
 
      ** Move fields for detail printing
 
     C                   Z-ADD     UPL           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        OURPL
     C                   MOVE      AMT(2)        OYUPL
     C                   MOVE      AMT(3)        ODIFF
 
      ** Total fields for totals printing
 
     C                   Z-ADD     1             CN
 
     C                   DO        3             CN
 
     C                   IF        H2RECI = 'T'
     C                   EVAL      D0(CN) = D0(CN) + UPL(CN)
     C                   EVAL      D1(CN) = D1(CN) + UPL(CN)
     C                   EVAL      D2(CN) = D2(CN) + UPL(CN)
     C                   EVAL      D3(CN) = D3(CN) + UPL(CN)
     C                   ELSE
     C                   EVAL      D0@(CN) = D0@(CN) + UPL(CN)
     C                   EVAL      D1@(CN) = D1@(CN) + UPL(CN)
     C                   EVAL      D2@(CN) = D2@(CN) + UPL(CN)
     C                   EVAL      D3@(CN) = D3@(CN) + UPL(CN)
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCLC  - Calculate Trading portion of amounts                *
      *                                                               *
      *****************************************************************
     C     SRCLC         BEGSR
 
     C                   MULT(H)   H3PCTG        WRKAM$
     C                   DIV(H)    100           WRKAM$
     C                   MULT(H)   PCTFLD        WRKAM$
     C                   MULT(H)   PCT           WRKAM$
     C                   DIV(H)    100           WRKAM$
 
     C                   ENDSR
 
      *****************************************************************
     C     SRINL1        BEGSR
      *****************************************************************
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      INHESN = *BLANKS
 
     C                   EXSR      SRVAL1
 
      ** Initialize the saved value of the Hedge Id.
 
     C                   EVAL      SVHEDI = *BLANKS
 
      ** If Hedge Linkage records to print -first print new headings
 
     C                   IF        *IN77 = *ON
 
     C                   EVAL      INHESN = 'Y'
     C                   EVAL      O1HESN = H1HESN
     C                   EVAL      O1HELD = H1HELD
 
     C                   IF        MODE01 <> *BLANKS
     C                   EVAL      *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   IF        MODE02 <> *BLANKS
     C                   EVAL      *IN67 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL2 - New Product Type Lvel Break                         *
      *                                                               *
      *****************************************************************
     C     SRINL2        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Product Type
 
     C                   EVAL      INPRTP = *BLANKS
 
     C                   EXSR      SRVAL1
 
      ** If Hedge Linkage records to print -OK
 
     C                   IF        *IN77 = *ON
     C                   EVAL      INPRTP = 'Y'
 
      ** Product Type
 
     C                   EVAL      *IN55 = *OFF
     C                   MOVEA     '000'         *IN(25)
     C                   EVAL      X = 1
     C     H1PRTP        LOOKUP    TP(X)                                  55
 
     C                   IF        *IN55 = *ON
     C                   SELECT
     C                   WHEN      X = 1
     C                   MOVEA     '100'         *IN(25)
     C                   WHEN      X = 2
     C                   MOVEA     '010'         *IN(25)
     C                   WHEN      X= 3
     C                   MOVEA     '001'         *IN(25)
     C                   ENDSL
     C                   ENDIF
 
     C                   MOVEA     *IN(25)       IN25
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL3 - New Branch Level Break                              *
      *                                                               *
      *****************************************************************
     C     SRINL3        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      INBRCA = *BLANKS
 
     C                   EXSR      SRVAL1
 
     C                   IF        *IN77 = *ON
 
     C                   EVAL      INBRCA = 'Y'
 
     C                   IF        MODE01 <> *BLANKS
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      H1BRCA        SENTY
     C                   PARM                    SFILE1
     C                   PARM      SFNUM1        ZSNUM
     C                   PARM      *Blanks       ZSERR
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDIF
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      H1BRCA        SENTY
     C                   PARM                    SFILE2
     C                   PARM      SFNUM2        ZSNUM
     C                   PARM      *Blanks       ZSERR
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      H1BRCA        PBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   EVAL      O1BRCD = H1BRCA
     C                   EVAL      O1BRNM = A8BRNM
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL1 - Check if Hedge Linkage Exist                        *
      *                                                               *
      *****************************************************************
     C     SRVAL1        BEGSR
 
      ** Save Hedge Strategy fields of a currently read record
 
     C                   EVAL      @BRCA = H1BRCA
     C                   EVAL      @PRTP = H1PRTP
     C                   EVAL      @HESN = H1HESN
     C                   EVAL      @EFLO = H1EFLO
     C                   EVAL      @EFHI = H1EFUP
 
      ** Initialise indicators
 
     C                   EVAL      *IN77 = *Off
     C                   EVAL      *IN89 = *Off
      *
      ** Position and read Hedge Strategy file based on break
      *
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C     @BRCA         SETLL     SDHGSTD3
     C     @BRCA         READE     SDHGSTD3                               89
      *
     C                   WHEN      *IN02 = *ON
     C     KYPRTP        SETLL     SDHGSTD3
     C     KYPRTP        READE     SDHGSTD3                               89
      *
     C                   WHEN      *IN01 = *ON
     C     KYHESN        SETLL     SDHGSTD3
     C     KYHESN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   DOW       *IN89 = *OFF
 
      ** Read Hedge Linkage records
 
     C                   EXSR      SRVAL2
 
      ** If live Hedge Linkages exist (77) -OK to process
 
     C                   IF        *IN77 = *ON
     C                   LEAVE
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C     @BRCA         READE     SDHGSTD3                               89
 
     C                   WHEN      *IN02 = *ON
     C     KYPRTP        READE     SDHGSTD3                               89
 
     C                   WHEN      *IN01 = *ON
     C     KYHESN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   ENDDO
 
      ** Restore Hedge Strategy fields of a currently read record
 
     C                   EVAL      H1BRCA = @BRCA
     C                   EVAL      H1PRTP = @PRTP
     C                   EVAL      H1HESN = @HESN
     C                   EVAL      H1EFLO = @EFLO
     C                   EVAL      H1EFUP = @EFHI
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL2 - Search for live Hedge Linkage records               *
      *                                                               *
      *****************************************************************
     C     SRVAL2        BEGSR
 
      ** Initialise indicators
 
     C                   EVAL      *IN87 = *OFF
     C                   EVAL      MODE = *BLANKS
 
      ** Read Hedge Strategy's Hedge Linkage records
 
     C     H1HESN        SETLL     ASHGLKD2
     C     H1HESN        READE     ASHGLKD2                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** Check if at least one qualified record exists (Trading)
 
     C                   IF        H2RECI = 'T'
     C                   EVAL      MODE01 = 'Y'
 
     C                   ELSE
 
      ** Check if at least one qualified record exists (Partial)
 
     C                   IF        H2RECI = 'D' or
     C                             H2RECI = 'X' and H2LASD = BJRDNB
     C                   EXSR      SRVAL3
     C                   ENDIF
 
     C                   ENDIF
 
      ** If both records exist -stop reading file
 
     C                   IF        MODE01 <> *BLANKS and MODE02 <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKD2                               87
     C                   ENDDO
 
      ** If either record exists no further checking is necessary
 
     C                   IF        MODE <> *BLANKS and *IN77 = *OFF
     C                   MOVE      *ON           *IN77
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL3 - Search for live Hedge Transaction records           *
      *                                                               *
      *****************************************************************
     C     SRVAL3        BEGSR
 
      ** Read all Derivative Transaction records of a Hedge
 
     C                   EVAL      *IN88 = *OFF
     C                   EVAL      HGHDIN = 'D'
     C     KYTRAN        SETLL     ASHTRND1
     C     KYTRAN        READE     ASHTRND1                               88
      *
     C                   DOW       *IN88 = *OFF
 
      ** If at least one transaction with unhedged portion exists
 
     C                   IF        H3PCTG < 100  and H3PCTG <> *ZEROS
 
      ** Check total percentage for transaction across hedge linkages
 
     C                   EXSR      SRPCT
 
      ** If total percentage < 100% -record qualifies to be printed
 
     C                   IF        MODE02 = 'Y'
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDIF
 
     C     KYTRAN        READE     ASHTRND1                               88
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPCT  - Calculate total percentage                          *
      *                                                               *
      *****************************************************************
     C     SRPCT         BEGSR
 
      ** Build key list based on mode
 
     C                   IF        H3MOD = 'DL' or
     C**********                   H3DLNO <> *ZEROS and H3FPSE = *Blanks                      CLE148
     C                             H3DLNO <> *BLANKS and H3FPSE = *Blanks                     CLE148
     C                   EVAL      DDNO = H3DLNO
     C                   EVAL      DFPO = *BLANKS
     C                   EVAL      KYBKC = *BLANKS
     C                   EVAL      KYBRCA = *BLANKS
     C                   EVAL      KYPCAL = *BLANKS
     C                   ELSE
     C                   EVAL      DDNO = *ZEROS
     C                   EVAL      DFPO = H3FPSE
     C                   EVAL      KYBKC = H3BKCD
     C                   EVAL      KYBRCA = H3BRCA
     C                   EVAL      KYPCAL = H3PCAL
     C                   ENDIF
 
      ** Check if other linkages exist and total their hedge percentage
 
     C                   EVAL      TOTPCT = H3PCTG
     C                   EVAL      X3HEDI = H3HEDI
     C                   EVAL      X3MOD  = H3MOD
     C                   EVAL      *IN86  = *OFF
 
     C     KYDPCT        SETLL     ASHTRND2
 
     C     KYDPCT        READE     ASHTRND2                               86
 
     C                   DOW       *IN86 = *OFF
 
      ** For the hedge transaction being processed, only accumulate
      ** the total percentage ONCE using the value on the screen
      ** (ignore the old value on FSHTRNPD).
      ** Validate percentqges of different modules separately.
 
     C                   IF        X3HEDI <> H3HEDI  and X3MOD = H3MOD
 
      ** Accumulate the total percentage for all live linkages
      ** (record id = D).
 
     C     H3HEDI        CHAIN     ASHGLKD1                           90
 
     C                   IF        *IN90 = *OFF
     C                   IF        H2RECI = 'D' or
     C                             H2RECI = 'X' and H2LASD = BJRDNB
     C                   EVAL      TOTPCT = TOTPCT + H3PCTG
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C     KYDPCT        READE     ASHTRND2                               86
     C                   ENDDO
 
      ** Reset to Hedge Linkage record being read
 
     C     X3HEDI        CHAIN     ASHGLKD1                           90
 
      ** Reset to Hedge Transaction record being read
 
     C     KRESET        CHAIN     ASHTRND8                           90
 
      ** If the total hedge percentage is less than 100 -include
 
     C                   IF        TOTPCT < 100
     C                   EVAL      MODE02 = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLDTO - Print Hedge Linkage totals (Derivatives)            *
      *                                                               *
      *****************************************************************
     C     SRLDTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOD1
 
      ** Derivative
 
     C                   EVAL      AR = D0
     C                   EXSR      SRAMT
     C                   EVAL      ODURPL = AMT(1)
     C                   EVAL      ODYUPL = AMT(2)
     C                   EVAL      ODDIFF = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (DERIVATIVE)
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     LINKTOD1
 
      ** Print dotted line
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     DOTTED1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        D0
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRL1TO - Print Hedge Strategy Totals                         *
      *                                                               *
      *****************************************************************
     C     SRL1TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD1
 
      ** Derivative
 
     C                   Z-ADD     D1            AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD1 = AMT(1)
     C                   EVAL      YUPLD1 = AMT(2)
     C                   EVAL      DIFFD1 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Strategy totals
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTOD1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L1CNTT
     C                   Z-ADD     *ZEROS        D1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRL2TO - Print Product Type Totals                           *
      *                                                               *
      *****************************************************************
     C     SRL2TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD1
 
      ** Derivative
 
     C                   Z-ADD     D2            AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD2 = AMT(1)
     C                   EVAL      YUPLD2 = AMT(2)
     C                   EVAL      DIFFD2 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Product Type totals
 
     C                   MOVEA     IN25          *IN(25)
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTOD1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L2CNTT
     C                   Z-ADD     *ZEROS        D2
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRL3TO - Print Branch Totals                                 *
      *                                                               *
      *****************************************************************
     C     SRL3TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD1
 
      ** Derivative
 
     C                   Z-ADD     D3            AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD3 = AMT(1)
     C                   EVAL      YUPLD3 = AMT(2)
     C                   EVAL      DIFFD3 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Branch totals
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATOD1
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Trailer
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     TRAILP1
 
      ** Close Printer File
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L3CNTT
     C                   Z-ADD     *ZEROS        D3
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR@DTO - Print Hedge Linkage Totals (Derivatives)            *
      *                                                               *
      *****************************************************************
     C     SR@DTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOD2
 
      ** Derivative
 
     C                   Z-ADD     D0@           AR
     C                   EXSR      SRAMT
     C                   EVAL      ODURPL = AMT(1)
     C                   EVAL      ODYUPL = AMT(2)
     C                   EVAL      ODDIFF = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (DERIVATIVE)
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     LINKTOD2
 
      ** Print dotted line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     DOTTED2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        D0@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR@1TO - Print Hedge Strategy Totals                         *
      *                                                               *
      *****************************************************************
     C     SR@1TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD2
 
      ** Derivative
 
     C                   Z-ADD     D1@           AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD1 = AMT(1)
     C                   EVAL      YUPLD1 = AMT(2)
     C                   EVAL      DIFFD1 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Strategy totals
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     HSENTOD2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L1CNTD
     C                   Z-ADD     *ZEROS        D1@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR@2TO - Print Product Type Totals                           *
      *                                                               *
      *****************************************************************
     C     SR@2TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD2
 
      ** Derivative
 
     C                   Z-ADD     D2@           AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD2 = AMT(1)
     C                   EVAL      YUPLD2 = AMT(2)
     C                   EVAL      DIFFD2 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Product Type totals
 
     C                   MOVEA     IN25          *IN(25)
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     PRTPTOD2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L2CNTD
     C                   Z-ADD     *ZEROS        D2@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR@3TO - Print Branch Totals                                 *
      *                                                               *
      *****************************************************************
     C     SR@3TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD2
 
      ** Derivative
 
     C                   Z-ADD     D3@           AR
     C                   EXSR      SRAMT
     C                   EVAL      URPLD3 = AMT(1)
     C                   EVAL      YUPLD3 = AMT(2)
     C                   EVAL      DIFFD3 = AMT(3)
 
      ** Print blank line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Branch totals
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BRCATOD2
 
      ** Print blank line
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Trailer
 
     C                   IF        *IN67 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN67 = *Off
     C                   ENDIF
     C                   WRITE     TRAILP2
 
      ** Close Printer File
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        L3CNTD
     C                   Z-ADD     *ZEROS        D3@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAMT  - Convert numeric amounts itno character fields       *
      *                                                               *
      *****************************************************************
     C     SRAMT         BEGSR
 
     C                   Z-ADD     1             CN
     C                   MOVEA     *BLANKS       AMT
 
     C                   DO        3             CN
 
     C**********         IF        AR(CN) <> *ZEROS                                           CAS004
     C                   EVAL      ZFLD15 = AR(CN)
     C                   EVAL      ZDECS = ZCDPT
     C                   EVAL      ZECODE = 'J'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    ZFLD15
     C                   PARM                    ZDECS
     C                   PARM                    ZECODE
     C                   PARM      *Blanks       ZOUT22
     C                   PARM      *Blanks       ZOUT25
 
     C                   MOVEL     ZOUT22        WRK21
     C                   MOVE      WRK21         AMT(CN)
     C**********         ENDIF                                                                CAS004
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /TITLE SR/SRAudit
      *****************************************************************
      *                                                               *
      *  SRAudit- Subroutine to Output Audit report and End Program   *
      *                                                               *
      *****************************************************************
 
     C     SRAudit       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   EVAL      ORPTDT = BJMRDT
 
     C                   WRITE     HEADAU
 
     C                   WRITE     TOTAUD
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records written, output "No Details" message.
 
     C                   IF        SCOUNT = *ZEROS
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRConCcy                                                      *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRConCcy      BEGSR
 
     C                   CALLB     'ZCCYCN'
 
      ** Input parameters
      ** ----------------
      ** Amount in 'FROM' currency (15P 0)
      ** From Currency (3A)
      ** TO currency (3A)
      ** Spot Rate for 'FROM' currency (13P 8)
      ** Spot Rate for 'TO' currency (13P 8)
      ** Multiply/Divide Indicator for 'FROM' currency  (1A)
      ** Multiply/Divide Indicator for 'TO' currency (1A)
      ** Currency Decimal places for 'FROM' currency (1P 0)
      ** Currency Decimal places for 'TO' currency (1P 0)
 
     C                   PARM                    ZAMTF
     C                   PARM                    ZCCYF
     C                   PARM                    ZCCYT
     C                   PARM                    ZRATEF
     C                   PARM                    ZRATET
     C                   PARM                    ZMDINF
     C                   PARM                    ZMDINT
     C                   PARM                    ZCDPF
     C                   PARM                    ZCDPT
 
      ** Output parameters
      ** -----------------
      ** Amount in 'TO' Currency (i.e. Converted Amount) (15P 0)
      ** Cross Exchange Rate (13P 8)
      ** Cross Rate Multiply/Divide Indicator (1A)
 
     C                   PARM                    ZAMTT
     C                   PARM                    ZCRSRT
     C                   PARM                    ZCRSMD
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       225293
      *                                                               *                       225293
      *  SRChkHdgI - Check Hedged Items if there is a need to chain   *                       225293
      *              the Base Rate version of the NPV files of the    *                       225293
      *              current derivative                               *                       225293
      *                                                               *                       225293
      *  Called by: SRDLNO                                            *                       225293
      *                                                               *                       225293
      *  Calls: None                                                  *                       225293
      *                                                               *                       225293
      *****************************************************************                       225293
                                                                                              225293
     C     SRChkHdgI     BEGSR                                                                225293
                                                                                              225293
     C                   EVAL      KAShed = H3HEDI                                            225293
     C                   EVAL      KASdhi = 'H'                                               225293
     C                   EVAL      WkBase = 'N'                                               225293
                                                                                              225293
     C     KASHTR        CHAIN     ASHTRNLB                           29                      225293
                                                                                              225293
     C                   DOW       *IN29 = *OFF AND WkBase = 'N'                              225293
                                                                                              225293
     C                   IF        HIFSHTID = 'D'                                             225293
                                                                                              225293
     C                   SELECT                                                               225293
                                                                                              225293
     C                   WHEN      HIFSMOD = 'DL'                                             225293
                                                                                              225293
     C*****HIFSDLNO      CHAIN     DEALALL                                             225293 CLE148
     C                   MOVEL     HIFSDLNO      H3DLNO2                                      CLE148
     C     H3DLNO2       CHAIN     DEALALL                                                    CLE148
                                                                                              225293
      ** If hedged item is a deal, check spread                                               225293
                                                                                              225293
     C                   IF        %FOUND(DEALALL)                                            225293
                                                                                              225293
      ***For*Loans*and*Deposits*records,*check*spread*rate*and*base*rate*code          225293 227695
      ** For Loans and Deposits records, check liquidity premium                              227695
                                                                                              225293
     C                   IF        RCDT = 'C'                                                 225293
     C**********         IF        RTSP <> 0 AND BRTT <> 0                             225293 227695
     C                   IF        FSLQPR <> 0                                                227695
     C                   EVAL      WkBase = 'Y'                                               225293
     C                   ENDIF                                                                225293
     C                   ENDIF                                                                225293
                                                                                              225293
      ** For Negotiable Assets Purchased records, check liquidity premium                     225293
                                                                                              225293
     C                   IF        RCDT = 'D'                                                 225293
     C                   IF        FSLQPR <> 0                                                225293
     C                   EVAL      WkBase = 'Y'                                               225293
     C                   ENDIF                                                                225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   WHEN      HIFSMOD = 'LE'                                             225293
                                                                                              225293
     C     HIFSDLNO      CHAIN     CLOAN                                                      225293
                                                                                              225293
      ** If hedged item is a loan, check margin                                               225293
                                                                                              225293
     C                   IF        %FOUND(CLOAN)                                              225293
                                                                                              225293
     C                   IF        MARG <> 0                                                  225293
     C                   EVAL      WkBase = 'Y'                                               225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   WHEN      HIFSMOD = 'SE'                                             225293
                                                                                              225293
      ** Populate key fields to be used in chaining in the book position file                 225293
                                                                                              225293
     C                   EVAL      KSEsesn = HIFSFPSE                                         225293
     C                   EVAL      KSEbrca = HIFSBRCA                                         225293
     C                   EVAL      KSEbokc = HIFSBKCD                                         225293
     C                   EVAL      KSEmkti = HIFSMKTI                                         225293
     C                   EVAL      KSEbhtv = HIFSBHTV                                         225293
                                                                                              225293
      ** Chain to book position file to get the Latest Average Price and the                  225293
      ** Latest Net Treasury Average Price                                                    225293
                                                                                              225293
     C     KSENPVL       CHAIN     BKPHD                                                      225293
                                                                                              225293
     C                   IF        %FOUND(BKPHD)                                              225293
                                                                                              225293
     C                   DOW       (B2RECI <> 'D') AND (NOT %EOF(BKPHD))                      225293
     C     KSENPVL       READE     BKPHD                                                      225293
     C                   ENDDO                                                                225293
                                                                                              225293
      ** If the Latest Average Price is not equal to the Latest Net Treasury                  225293
      ** Average Price, use base rate file                                                    225293
                                                                                              225293
     C                   IF        (NOT %EOF(BKPHD)) AND (B2LAVP <> B2LAVN)                   225293
     C                   EVAL      WkBase = 'Y'                                               225293
     C                   ENDIF                                                                225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   WHEN      HIFSMOD = 'FH'                                             225293
     C                   EVAL      WkBase = 'Y'                                               225293
                                                                                              225293
     C                   ENDSL                                                                225293
                                                                                              225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C     KASHTR        READE     ASHTRNLB                               29                  225293
     C                   ENDDO                                                                225293
                                                                                              225293
     C                   ENDSR                                                                225293
                                                                                              225293
      *****************************************************************                       225293
      /EJECT                                                                                  225293
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
 
     C                   CALL      'AOBANKR0'
     C                   PARM      '*MSG   '     PRetCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRetCode <> *Blanks
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = '*FIRST'
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Retrieve Base Currency Data
 
     C                   EVAL      OCCY = BJCYCD
     C                   CALL      'AOCURRR0'
     C                   PARM      *Blanks       PRetCode
     C                   PARM      '*KEY   '     POption
     C                   PARM      BJCYCD        PCcy
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRetCode = *Blanks
     C                   EVAL      ZCCYT = A6CYCD
     C                   EVAL      ZRATET = A6SPRT
     C                   EVAL      ZMDINT = A6MDIN
     C                   EVAL      ZCDPT = A6NBDP
     C                   ELSE
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = BJCYCD
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
                                                                                              CAS004
      ** Call access program for General Ledger details                                       CAS004
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRetCode                                     CAS004
     C                   PARM      '*FIRST '     POption                                      CAS004
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS004
                                                                                              CAS004
      ** Database Error                                                                       CAS004
                                                                                              CAS004
     C                   IF        PRetCode <> *BLANKS                                        CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAS004
     C                   EVAL      DBASE = 3                                                  CAS004
     C                   EVAL      DBKEY = POption                                            CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   EVAL      WEvCtlDt = BJDNWD - 1                                      CAS004
     C                   IF        BKAPDT < WEvCtlDt                                          CAS004
     C                   EVAL      WEvCtlDt = BKAPDT                                          CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   EVAL      WRKEVT = WEvCtlDt                                          CAS004
     C                   CALL      'ZDATE2'                                                   CAS004
     C                   PARM                    WRKEVT                                       CAS004
     C                   PARM      BJDFIN        WQ0002                                       CAS004
     C                   PARM      *ZEROS        WEVCD                                        CAS004
     C                   PARM      *BLANKS       OEVCD                                        CAS004
                                                                                              CAS003
      ** Check if CAS003 is switched on                                                       CAS003
                                                                                              CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *Blanks       PRetCode                                     CAS003
     C                   PARM      '*KEY   '     POption                                      CAS003
     C                   PARM      'CAS003'      PSAR                                         CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRetCode = *Blanks                                         CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
     C                   ELSE                                                                 CAS003
     C                   IF        PRetCode <> '*NRF   '                                      CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   EVAL      DBKey = PSAR                                               CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBASE = 4                                                  CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS005
      ** Check if CAS005 is switched on                                                       CAS005
                                                                                              CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *Blanks       PRetCode                                     CAS005
     C                   PARM      '*VERIFY'     POption                                      CAS005
     C                   PARM      'CAS005'      PSAR                                         CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRetCode = *Blanks                                         CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   IF        PRetCode <> '*NRF   '                                      CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBKey = PSAR                                               CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 5                                                  CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
      ** Check if CAS006 is switched on                                                       CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *Blanks       PRetCode                                     CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSAR                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRetCode = *Blanks                                         CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   IF        PRetCode <> '*NRF   '                                      CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBKey = PSAR                                               CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE = 6                                                  CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
 
      ** Product Type Key List.
 
     C     KYPRTP        KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @PRTP
 
      ** Strategy Key List.
 
     C     KYHESN        KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @PRTP
     C                   KFLD                    @HESN
 
      ** Linkage Key List.
 
     C     KYTRAN        KLIST
     C                   KFLD                    H2HEDI
     C                   KFLD                    HGHDIN
                                                                                              CAS003
     C     KEYPST        KLIST                                                                CAS003
     C                   KFLD                    H3BRCA                                       CAS003
     C                   KFLD                    H3BKCD                                       CAS003
     C                   KFLD                    INSKEY                                       CAS003
     C                   KFLD                    INSYY                                        CAS003
     C                   KFLD                    INSMM                                        CAS003
     C                   KFLD                    H3PCAL                                       CAS003
 
     C     KYDPCT        KLIST
     C                   KFLD                    HGHDIN
     C                   KFLD                    DDNO
     C                   KFLD                    DFPO
     C                   KFLD                    KYBKC
     C                   KFLD                    KYBRCA
     C                   KFLD                    KYPCAL
 
     C     KRESET        KLIST
     C                   KFLD                    X3HEDI
     C                   KFLD                    HGHDIN
     C                   KFLD                    DDNO
     C                   KFLD                    DFPO
     C                   KFLD                    KYBKC
     C                   KFLD                    KYBRCA
     C                   KFLD                    KYPCAL
 
     C     KASHTR        KLIST                                                                225293
     C                   KFLD                    KAShed                                       225293
     C                   KFLD                    KASdhi                                       225293
                                                                                              225293
      ** Key List for Midas SE Revalued Security Positions File                               225293
                                                                                              225293
     C     KSENPVL       KLIST                                                                225293
     C                   KFLD                    KSEsesn                                      225293
     C                   KFLD                    KSEbrca                                      225293
     C                   KFLD                    KSEbokc                                      225293
     C                   KFLD                    KSEmkti                                      225293
     C                   KFLD                    KSEbhtv                                      225293
                                                                                              225293
     C     KRXNPV        KLIST                                                                225293
     C**********         KFLD                    H3DLNO                                225293 CLE148
     C                   KFLD                    H3DLNO2                                      CLE148
     C                   KFLD                    WRKCCY                                       225293
                                                                                              225293
      ** Access Local data Area (LDA) and retrieve values
 
     C     *DTAARA       DEFINE                  LDA
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = *BLANKS
     C                   EVAL      DBKEY  = *BLANKS
     C                   EVAL      DBPGM  = *BLANKS
     C                   EVAL      DBPGM  = 'AS001009'
     C                   EVAL      DBASE  = 0
     C                   OUT       LDA
 
      ** USER: Initialise program
      ** Standard RPG Creation PAR - Standard Functions  *
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   EVAL      BJMRDT = MRDT
     C                   EVAL      WURDNB = RDNB
 
      ** Check multibranch function
 
     C                   IF        MBIN = 'Y'
     C                   EVAL      *IN37 = *On
     C                   ENDIF
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
     C                   IF        ZSErr = 'Y'
     C                   EVAL      *INU7 = *On
     C                   EVAL      *INU8 = *On
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
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
**   MON/NUM Month Short Name and Number
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
** Product Types
FV
FX
CF
