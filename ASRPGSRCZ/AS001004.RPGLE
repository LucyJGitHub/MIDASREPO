     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedging of SE Effectiveness Report')          *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS001004 - Midas AS Hedging of SE Positions Effectiveness    *
      *             Report                                            *
      *                                                               *
      *  Function:  This module lists the Effective and Ineffective   *
      *             or Discontinued Hedges for Securities. Gives the  *
      *             total figures of Unrealized P/L (daily and        *
      *             yearend figures). List is sorted by Product Type, *
      *             Strategy and by Branch.                           *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 229468             Date 09Sep04               *
      *                 229219             Date 26Aug04               *
      *                 229035             Date 16Aug04               *
      *                 226170             Date 05Apr04               *
      *                 225293             Date 26Feb04               *
      *                 224985             Date 18Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 224116             Date 05Jan04               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  229468 - Hedge Effectiveness % not printed                   *
      *  229219 - Blank Hedge Effectiveness date on SE Effectiveness  *
      *           Report.                                             *
      *  229035 - The principal amount in SE module is the nominal    *
      *           amount.                                             *
      *  226170 - UP/UL amounts for RX deals are already in base ccy. *
      *           Do not convert.                                     *
      *  225293 - Report is showing the NPV of the previous           *
      *           transaction.                                        *
      *  224985 - Report is showing additional headers/footers for    *
      *           'No Details to Report'                              *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224116 - Hedge report should show buy out date as maturity   *
      *           date if deal has been bought out                    *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01         Strategy Level Break                              *
      *  02         Product Type Level Break                          *
      *  03         Branch Level Break                                *
      *  12         EOF SDHGSTL2                                      *
      *  25         FV Product Type                                   *
      *  27         CF Product Type                                   *
      *  37         Multibranch Active                                *
      *  44         Overflow - Ineffective Hedges                     *
      *  55         Record Found Indicator                            *
      *  56         Record Found Indicator                            *
      *  66         Overflow - Effective Hedges                       *
      *  77         Qualified Hedge Linkage Found Indicator           *
      *  87         End of File Indicator                             *
      *  89         End of File Indicator                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRAUDIT - Audit Printing                                     *
      *  SRDATE - Convert Midas day number to date                    *
      *  SRLNK1 - Hedge Linkage processing (Main)                     *
      *  SRLNK2 - Hedge Linkage processing (Subordinate)              *
      *  SRTRN1 - Hedge Transaction processing                        *
      *  SRTRN2 - Move data to workfields and print Trans Report      *
      *  SRTRN3 - Load workfields to print Transaction Report         *
      *  SRUPL  - Unrealised P/L-related                              *
      *  SRINL1 - New Hedge Strategy Level Break                      *
      *  SRINL2 - New Product Type Level Break                        *
      *  SRINL3 - New Branch Level Break                              *
      *  SRVAL1 - Check if Hedge Linkages exist                       *
      *  SRVAL2 - Search for live Hedge Linkage records               *
      *  SRCHKSE - Check for atleast 1 SE transaction                 *
      *  SRSENO - Security processing                                 *
      *  SRDTOE - Print Hedge Linkage totals (Derivative)- Effective  *
      *  SRHTOE - Print Hedge Linkage totals (Hedged) - Effective     *
      *  SRNTOE - Print Hedge Linkage totals - Effective              *
      *  SRHSTE - Print Hedge Strategy totals - Effective             *
      *  SRPTTE - Print Product Type totals - Effective               *
      *  SRBRTE - Print Branch totals - Effective                     *
      *  SRDTOI - Print Hedge Linkage tot (Derivative) - Ineffective  *
      *  SRHTOI - Print Hedge Linkage totals (Hedged) - Ineffective   *
      *  SRNTOI - Print Hedge Linkage totals - Ineffective            *
      *  SRHSTI - Print Hedge Strategy totals - Ineffective           *
      *  SRPTTI - Print Product Type totals - Ineffective             *
      *  SRBRTI - Print Branch totals - Ineffective                   *
      *  SRCHGP  -Change Percentage calculation                       *
      *  SRAMT   -Convert numeric amounts into character fields       *
      *                                                               *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *  The *INZSR subroutine will only get called automatically     *
      *  on entry to the module the first time it is run              *
      *  (unless you end the program with LR on).  Similarly          *
      *  D-spec initialisation only happens the first time.  Use      *
      *  RESET for subsequent passes.                                 *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
      ** RTV : Hedge Strategy By Branch and Product Type
 
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD3)
     F                                     PREFIX(H1:2)
      ** RTV : Hedge Strategy By Branch and Product Type
 
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
      ** RTV : Hedge Linkage Retrieval By Hedge Strategy
 
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND1)
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
                                                                                              225293
     FASHTRNLB  IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     RENAME(ASHTRND0:ASHTRNDB)                          225293
     F                                     PREFIX(HI)                                         225293
 
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV:  Revalued Securities Positions
 
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV : Revalued FRAs and IRSs File
 
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(IRNPVAD0:IRNPVBD0)
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (SIRS)
 
     F***RXNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                    225293
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)                                       225293
      ** RTV : Revalued FRAs and IRSs File (CIRS)
 
     F***RXNPVBL0  IF   E           K DISK    INFSR(*PSSR)                                    225293
     FRXNPVBL1  IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     RENAME(RXNPVAD0:RXNPVBD0)
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (CIRS)
 
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV : Midas IR Revalued FRA File
 
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(FRNPVAD0:FRNPVLD0)
      ** RTV : Midas IR Revalued FRA using Net Treasury Rate File
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** RTV: Security File
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     PREFIX(B2)                                         225293
      ** Midas SE Book Position Headers                                                       225293
                                                                                              225293
     FDLDLDGLE  IF   E           K DISK    INFSR(*PSSR)
      ** Midas DL FRA/IRS deals
 
     FAS001004P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN                                             224985
      ** PRT: Printer file for Effective Hedges (Transaction Detail)
 
     FAS001004P2O    E             PRINTER OFLIND(*IN44)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
     F                                     USROPN                                             224985
      ** PRT: Printer file for Ineffective Hedges (Transaction Detail)
 
     FAS001004AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** PRT: Printer file for Hedge Effectiveness(Audit)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
      ** Program Status Data Structure
 
     D TP              S              2    DIM(3) CTDATA PERRCD(1)
     D A22             S              1    DIM(22)
 
      ** Arrays for Unrealised P/L (General Work)
     D AR              S             13  0 DIM(3)
     D AMT             S             18    DIM(3)
 
      ** Arrays for Unrealised P/L (Effective)
     D DER0E           S             13  0 DIM(3)
     D HDG0E           S             13  0 DIM(3)
     D TOT0E           S             13  0 DIM(3)
     D DER1E           S             13  0 DIM(3)
     D HDG1E           S             13  0 DIM(3)
     D TOT1E           S             13  0 DIM(3)
     D DER2E           S             13  0 DIM(3)
     D HDG2E           S             13  0 DIM(3)
     D TOT2E           S             13  0 DIM(3)
     D DER3E           S             13  0 DIM(3)
     D HDG3E           S             13  0 DIM(3)
     D TOT3E           S             13  0 DIM(3)
 
      ** Arrays for Unrealised P/L (Ineffective)
     D DER0I           S             13  0 DIM(3)
     D HDG0I           S             13  0 DIM(3)
     D TOT0I           S             13  0 DIM(3)
     D DER1I           S             13  0 DIM(3)
     D HDG1I           S             13  0 DIM(3)
     D TOT1I           S             13  0 DIM(3)
     D DER2I           S             13  0 DIM(3)
     D HDG2I           S             13  0 DIM(3)
     D TOT2I           S             13  0 DIM(3)
     D DER3I           S             13  0 DIM(3)
     D HDG3I           S             13  0 DIM(3)
     D TOT3I           S             13  0 DIM(3)
 
      ** Record Format
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** Today's Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  MBIN                  13     13
 
      ** File Information Data Structure for AS001004P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001004P2
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for AS001004AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for SC Switchable Features
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structures for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
     D LDA           E DS           256    EXTNAME(LDA) DTAARA(LDA)
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
     D                 DS
     D  UPL                    1     39  0
     D                                     DIM(3)
     D  URPL                   1     13  0
     D  YUPL                  14     26  0
     D  DIFF                  27     39  0
 
     D                 DS
     D  FSFPSE                 1     10
     D  FSBKCD                11     12
     D  FSBRCA                13     15
     D  FSPCAL                16     16
     D  FSMKTI                17     17
     D  FSBHTV                18     18
     D  FSKEY                  1     18
 
     D                 DS
     D  EFFYN                  1      2
     D  EFFY                   1      1
     D  EFFN                   2      2
 
      ** Work Indicators
     D WLVInd          DS
     D  WLVInd3                1      1
     D  WLVInd2                2      2
     D  WLVInd1                3      3
 
      ** Parameters for Access Objects
     D PRTCD           S              7
     D POPTN           S              7
     D PBRCA           S              3
     D PSAR            S              6
 
     D WIn40Flag       S              1    INZ('N')
     D WIn41Flag       S              1    INZ('N')
     D WEvCtlDt        S              5P 0
 
      ** Details Fields
     D WRKDLN          S             10
     D WRKBKC          S              2
     D WRKTYP          S              2
     D WRKSTP          S              2
     D*WRKCNU***       S              6  0                                                    CSD027
     D WRKCNU          S              6A                                                      CSD027
     D WRKVAL          S              5  0
     D WRKMAT          S              5  0
     D WRKBOV          S              5  0                                                    224116
     D WRKCCY          S              3
     D WRKPR$          S             13  0
     D WRKINT          S             11  0
 
     D WRK21           S             21
     D C22             S              3  0
 
     D CN              S              1  0
     D X               S              1  0
     D INBRCA          S              1
     D INHESN          S              1
     D INPRTP          S              1
     D IN25            S              3
     D SVHEDI          S              6
     D KBRCA           S              3
     D KPRTP           S              2
     D KHESN           S             10
     D WEFLO           S              7  4
     D WEFHI           S              7  4
     D L1CNT           S              7  0
     D L2CNT           S              7  0
     D L3CNT           S              7  0
     D W1CNT           S              7  0
     D W2CNT           S              7  0
     D W3CNT           S              7  0
     D WURDNB          S              5  0
     D HGHDIN          S              1
     D WSEMODFLG       S              1
     D WSEEXIST        S              1
 
      ** Parameters for ZSFILE
     D PSEQ            S              5
     D PSENTY          S              3
     D PZSNUM          S              6  0
     D PZSERR          S              1
     D PZSNUMU         S              6  0
 
      ** Parameters for ZFRPED
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D POUT22          S             22
     D POUT25          S             25
 
     D WDCOUNT         S              7  4
     D WHCOUNT         S              7  4
     D WTCOUNT         S              7  4
     D WEFFFLG         S              1
     D WPRINT          S              1
     D WRun            S              1
 
      ** Parameters for ZCCYCN module
     D PAMTF           S             15P 0
     D PCCYF           S              3A
     D PCCYT           S              3A
     D PRATEF          S             13P 8
     D PRATET          S             13P 8
     D PMDINF          S              1A
     D PMDINT          S              1A
     D PCDPF           S              1P 0
     D PCDPT           S              1P 0
     D PAMTT           S             15P 0
     D PCRSRT          S             13P 8
     D PCRSMD          S              1A
 
     D PZDATE          S              6  0
     D PZADATE         S              7
     D PDATE           S                   LIKE(WRKVAL)
 
     D WFLD20          S             20
     D WOPEN           S              1                                                       224985
     D WOPEN2          S              1                                                       224985
     D WLASDT          S              7                                                       225293
     D WkBase          S              1                                                       225293
                                                                                              225293
      ** Fields used to define Key List for Midas SE Revalued Security                        225293
      ** Positions File                                                                       225293
     D KSEsesn         S             10                                                       225293
     D KSEbrca         S              3                                                       225293
     D KSEbokc         S              2                                                       225293
     D KSEmkti         S              1                                                       225293
     D KSEbhtv         S              1                                                       225293
                                                                                              225293
      ** Fields used to define Key List for Midas AS Hedge Transaction File                   225293
      ** Retrieval                                                                            225293
     D KAShed          S              6S 0                                                    225293
     D KASdhi          S              1A                                                      225293
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C     *LOVAL        SETLL     SDHGSTL2
     C                   READ      SDHGSTL2                               12
 
      ** Audit Report if end of file
 
     C                   IF        *IN12 = *ON
     C                   EXSR      SRAUDIT
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       *IN12 = *OFF
 
      ** For every Hedge Strategy, check if there is atleast 1 SE
      ** Hedged Transaction under its linkage
 
     C                   EXSR      SRCHKSE
 
     C                   IF        WSEEXIST = 'Y'
 
      ** Set Indicator for changes on Cash Flow reports
 
     C                   EVAL      WIn40Flag = 'N'
     C                   EVAL      WIn41Flag = 'N'
     C                   IF        H1PRTP = 'CF'
     C                   EVAL      WIn40Flag = 'Y'
     C                   ENDIF
     C                   IF        H1PRTP = 'FV'
     C                   EVAL      WIn41Flag = 'Y'
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      KBRCA <> H1BRCA
     C                   EVAL      WLVInd = 'YYY'
 
     C                   WHEN      KPRTP <> H1PRTP
     C                   EVAL      WLVInd = 'NYY'
 
     C                   WHEN      KHESN <> H1HESN
     C                   EVAL      WLVInd = 'NNY'
     C                   ENDSL
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** If change in Branch
 
     C                   IF        WLVInd3 = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRINL3
     C                   EVAL      *IN03 = *OFF
     C                   ENDIF
 
     C                   EXSR      SRProcess
 
     C                   ENDIF
 
     C                   READ      SDHGSTL2                               12
 
      ** At the End of Product Type, Print Totals
 
     C                   IF        KPRTP <> H1PRTP or *IN12 = *ON
     C                   EVAL      INPRTP = *BLANKS
     C                   IF        L2CNT > *ZEROS
     C                   EXSR      SRPTTE
     C                   ENDIF
 
     C                   IF        W2CNT > *ZEROS
     C                   EXSR      SRPTTI
     C                   ENDIF
     C                   ENDIF
 
      ** At end of branch print totals, trailer and close printer file
 
     C                   IF        KBRCA <> H1BRCA or *IN12 = *ON
     C                   EVAL      INBRCA = *BLANKS
     C                   IF        L3CNT > *ZEROS
     C                   EXSR      SRBRTE
     C                   ENDIF
 
     C                   IF        W3CNT > *ZEROS
     C                   EXSR      SRBRTI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SRAUDIT
     C                   ENDIF
 
     C                   EVAL      *INLR = *ON
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRProcess - Subroutine to handle change in branch and        *
      *              Product type. Executes Hedge Linkage Main.       *
      *                                                               *
      *****************************************************************
     C     SRProcess     BEGSR
 
     C                   IF        INBRCA = 'Y'
     C                   IF        WLVInd2 = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   EXSR      SRINL2
     C                   EVAL      *IN02 = *OFF
     C                   ENDIF
 
     C                   IF        INPRTP = 'Y'
     C                   IF        WLVInd1 = 'Y'
     C                   EVAL      *IN01 = *ON
     C                   EXSR      SRINL1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
     C                   IF        INHESN = 'Y'
     C                   EVAL      SCOUNT = SCOUNT + 1
     C                   EXSR      SRLNK1
 
      ** At end of Strategy print totals
 
     C                   EVAL      INHESN = *BLANKS
     C                   IF        L1CNT > *ZEROS
     C                   EXSR      SRHSTE
     C                   ENDIF
     C                   IF        W1CNT > *ZEROS
     C                   EXSR      SRHSTI
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
 
      ** For each Hedge Strategy - read all Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               89
 
     C                   DOW       *IN89 = *OFF
 
      ** If qualifying Hedge Linkage record exists
 
     C                   IF        FSRECI = 'D'
     C                             AND H1MEFF <> 'R'
     C                             AND FSSECR = 'Y'                                           224985
     C                             OR FSRECI = 'X'
     C                             AND H1MEFF <> 'R'
     C                             AND FSSECR = 'Y'                                           224985
 
      ** Initialise effectiveness flag
 
     C                   IF        FSRECI = 'D'
     C                   EVAL      WEFFFLG = 'E'
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                   EVAL      WEFFFLG = 'I'
     C                   ENDIF
     C                   ENDIF
 
      ** Process Hedge Transaction records without detail printing
 
     C                   EVAL      WPRINT = 'N'
     C                   EXSR      SRLNK2
 
      ** If live Hedge Transaction Details exist and today is Eff. Date
 
     C                   IF        WTCOUNT > *ZEROS
 
      ** Increment Hedge Linkage count
 
     C                   EVAL      LCOUNT = LCOUNT + 1
 
      ** Process Hedge Transaction records with detail printing
 
     C                   EVAL      WPRINT = 'Y'
 
     C                   EXSR      SRLNK2
 
      ** Move total fields for Hedge Linkage totals printing and print
 
     C                   IF        WEFFFLG = 'E'
     C                   EXSR      SRNTOE
     C                   ELSE
     C                   IF        WEFFFLG = 'I'
     C                   EXSR      SRNTOI
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               89
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKSE - Subroutine to check if the particular Hedge        *
      *            Strategy has atleast 1 SE Hedged Transaction.      *
      *                                                               *
      *****************************************************************
     C     SRCHKSE       BEGSR
 
     C                   EVAL      WSEEXIST = 'N'
 
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               29
 
     C                   DOW       *IN29 = *OFF
 
     C                   IF        FSRECI = 'D'
     C                             AND H1MEFF <> 'R'                                          224985
     C                             OR FSRECI = 'X'
     C                             AND H1MEFF <> 'R'                                          224985
 
     C                   EVAL      HGHDIN = 'H'
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               28
 
     C                   DOW       *IN28 = *OFF
     C                   IF        FSMOD = 'SE'
     C                   EVAL      WSEEXIST = 'Y'
     C                   ENDIF
     C     KYTRAN        READE     ASHTRNL0                               28
     C                   ENDDO
 
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               29
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRLNK2 - Hedge Linkage Processing Subordinated               *
      *                                                               *
      *****************************************************************
     C     SRLNK2        BEGSR
 
      ** Initialise Hedge Transaction count
 
     C                   EVAL      WTCOUNT = *ZEROS
 
      ** Check if there is a Hedged Transaction record for Security
      ** for the particular hedge transaction ID
 
     C                   EVAL      WSEMODFLG = 'N'
     C                   EVAL      HGHDIN = 'H'
     C                   EVAL      *IN87 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               29
 
     C                   DOW       *IN29 = *OFF
 
     C                   IF        FSMOD = 'SE'
     C                   EVAL      WSEMODFLG = 'Y'
     C                   ENDIF
 
     C     KYTRAN        READE     ASHTRNL0                               29
     C                   ENDDO
 
     C                   IF        WSEMODFLG = 'Y'
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      WDCOUNT = *ZEROS
     C                   EVAL      HGHDIN = 'D'
     C                   EXSR      SRTRN1
 
      ** If Derivative Transaction records exist -print Derivative total
 
     C                   IF        WPRINT = 'Y' and WDCOUNT > *ZEROS
 
     C                   SELECT
     C                   WHEN      WEFFFLG = 'E'
     C                   EXSR      SRDTOE
 
     C                   WHEN      WEFFFLG = 'I'
     C                   EXSR      SRDTOI
     C                   ENDSL
 
     C                   ENDIF
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      WHCOUNT = *ZEROS
     C                   EVAL      HGHDIN = 'H'
     C                   EXSR      SRTRN1
 
      ** If Derivative Transaction records exist - print Derivative total
 
     C                   IF        WPRINT = 'Y' and WHCOUNT > *ZEROS
 
     C                   SELECT
     C                   WHEN      WEFFFLG = 'E'
     C                   EXSR      SRHTOE
 
     C                   WHEN      WEFFFLG = 'I'
     C                   EXSR      SRHTOI
     C                   ENDSL
 
     C                   ENDIF
 
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
 
     C                   EVAL      *IN87 = *OFF
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If in non-print mode - increment count of processed records;
      ** otherwise, convert file fields for printing and print details
 
     C                   IF        WPRINT = 'N'
     C                   EVAL      WTCOUNT = WTCOUNT + 1
     C                   ELSE
     C                   EXSR      SRTRN2
     C                   ENDIF
 
     C     KYTRAN        READE     ASHTRNL0                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN2 - Move data to workfields and print Transaction       *
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
     C                   EVAL      WRKBOV = *ZEROS                                            224116
     C                   EVAL      WRKCCY = *BLANKS
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
     C                   EVAL      URPL = *ZEROS
     C                   EVAL      YUPL = *ZEROS
     C                   EVAL      DIFF = *ZEROS
 
      ** Retrieve Transaction details from pertinent files
 
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL'
     C                             AND HGHDIN = 'D'
     C                   EXSR      SRDLNO
 
     C                   WHEN      FSMOD = 'SE'
     C                             AND HGHDIN = 'H'
     C                   EXSR      SRSENO
 
     C                   ENDSL
 
      ** If record found in file
 
     C                   IF        *IN55 = *OFF
 
      ** Clear detail printer file record
 
     C                   IF        WEFFFLG = 'I'
     C                   CLEAR                   DETAIL2
     C                   ELSE
     C                   CLEAR                   DETAIL1
     C                   ENDIF
 
      ** Load printer file fields
 
     C                   EXSR      SRTRN3
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print Hedge Transaction details
 
     C                   IF        WEFFFLG = 'I'
 
      ** Check if printing new Hedge ID, if so, print heading.
 
     C                   IF        OHEDI <> SVHEDI
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL2H
     C                   ENDIF
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL2
 
     C                   ADD       1             W1CNT
     C                   ADD       1             W2CNT
     C                   ADD       1             W3CNT
 
     C                   ELSE
 
      ** Check if printing new Hedge ID, if so, print heading.
 
     C                   IF        OHEDI <> SVHEDI
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL1H
     C                   ENDIF
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     DETAIL1
 
     C                   ADD       1             L1CNT
     C                   ADD       1             L2CNT
     C                   ADD       1             L3CNT
 
     C                   ENDIF
 
      ** Save value of Hedge Id which was just printed.
 
     C                   EVAL      SVHEDI = OHEDI
 
      ** Increment count of Derivative or Hedged Transaction records
 
     C                   IF        HGHDIN = 'D'
     C                   EVAL      WDCOUNT = WDCOUNT + 1
     C                   ELSE
     C                   IF        HGHDIN = 'H'
     C                   EVAL      WHCOUNT = WHCOUNT + 1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSENO - Security processing                                 *
      *                                                               *
      *****************************************************************
 
     C     SRSENO        BEGSR
 
     C     FSFPSE        CHAIN     SECTY                              55
 
     C                   IF        *IN55 = *OFF
 
     C     KEYBKP        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    FSBRCA
     C                   KFLD                    FSBKCD
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
 
     C     KEYBKP        CHAIN     SEMKVLL0                           55
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSFPSE        WRKDLN
     C                   EVAL      WRKBKC = SEBOKC
     C                   EVAL      WRKMAT = MATY
     C                   EVAL      WRKCNU = ISSR
     C                   EVAL      WRKCCY = SECCY
     C**********         EVAL      WRKPR$ = SEBKCT                                            229035
     C                   EVAL      WRKPR$ = SENAMT                                            229035
     C     10000000      MULT(H)   SEAVPR        WRKINT
     C                   EVAL      URPL = SEURPL
     C                   EVAL      YUPL = SEYUPL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLNO - Deal processing                                      *
      *                                                               *
      *****************************************************************
 
     C     SRDLNO        BEGSR
 
     C*****FSDLNO        CHAIN     DLDLDGLE                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DLDLDGLE                           55                      CLE148
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WRKDLN
     C                   EVAL      WRKBKC = BOKC
     C                   EVAL      WRKTYP = DTYP
     C                   EVAL      WRKSTP = DLST
     C                   EVAL      WRKCNU = CNUM
     C                   EVAL      WRKVAL = VDAT
     C                   EVAL      WRKMAT = MDAT
     C                   EVAL      WRKBOV = BOVD                                              224116
     C                   IF        DTYP = 'RX'                                                225293
     C                             AND FSHSID = 'T'                                           225293
     C                   EVAL      WRKCCY = TCUCY                                             225293
     C                   EVAL      WRKPR$ = TPAMT                                             225293
     C                   ELSE                                                                 225293
     C                   EVAL      WRKCCY = UCUCY
     C                   EVAL      WRKPR$ = UPAMT
     C                   ENDIF                                                                225293
 
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
 
     C                   IF        FSRIND = ' '                                               225293
     C                   EXSR      SRChkHdgI                                                  225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   IF        DTYP = 'RS'
     C                   IF        FSRIND = 'L'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****FSDLNO        CHAIN     IRNPVAL0                           56                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                           56                      CLE148
     C                   ENDIF
     C                   IF        FSRIND = 'B'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****FSDLNO        CHAIN     IRNPVBL0                           56                      CLE148
     C     FSDLNO2       CHAIN     IRNPVBL0                           56                      CLE148
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DTYP = 'RX'
     C                   IF        FSRIND = 'L'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****FSDLNO        CHAIN     RXNPVAL0                           56                      225293
     C     KRXNPV        CHAIN     RXNPVAL1                           56                      225293
     C                   ENDIF
     C                   IF        FSRIND = 'B'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****FSDLNO        CHAIN     RXNPVBL0                           56                      225293
     C     KRXNPV        CHAIN     RXNPVBL1                           56                      225293
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        DTYP = 'FR'
     C                   IF        FSRIND = 'L'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****FSDLNO        CHAIN     FRNPVAL0                           56                      CLE148
     C     FSDLNO2       CHAIN     FRNPVAL0                           56                      CLE148
     C                   ENDIF
     C                   IF        FSRIND = 'B'
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****FSDLNO        CHAIN     FRNPVLL0                           56                      CLE148
     C     FSDLNO2       CHAIN     FRNPVLL0                           56                      CLE148
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN56 = *ON
     C*****FSDLNO        CHAIN     IRNPVAL0                           56                      CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                           56                      CLE148
     C                   ENDIF
 
     C                   IF        *IN56 = *OFF
     C                   EVAL      URPL = IRURPL
     C                   EVAL      YUPL = IRYUPL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTRN3 - Load workfields to print Transaction Report         *
      *                                                               *
      *****************************************************************
 
     C     SRTRN3        BEGSR
 
     C                   MOVEL     FSHEDI        OHEDI
     C                   EVAL      ODLNO = WRKDLN
     C                   EVAL      OBKC = WRKBKC
     C                   EVAL      ODTYP = WRKTYP
     C                   EVAL      ODLST = WRKSTP
 
     C                   IF        ODLST <> *BLANKS
     C                   EVAL      ODASH = '-'
     C                   ENDIF
 
     C**********         IF        WRKCNU <> *ZEROS                                           CSD027
     C                   IF        WRKCNU <> *BLANKS                                          CSD027
     C                   MOVEL     WRKCNU        OCNUM
     C                   ENDIF
 
     C                   IF        WRKVAL <> 0
     C                   EVAL      PDATE = WRKVAL
     C                   EXSR      SRDATE
     C                   EVAL      OVALD = PZADATE
     C                   ENDIF
 
 
     C                   IF        WRKMAT <> 0
     C                   EVAL      PDATE = WRKMAT
                                                                                              224116
      ** If deal has been bought out, use buy out date as maturity date                       224116
                                                                                              224116
     C                   IF        WRKBOV <> 0                                                224116
     C                   EVAL      PDate = WRKBOV                                             224116
     C                   ENDIF                                                                224116
                                                                                              224116
     C                   EXSR      SRDATE
     C                   EVAL      OMATD = PZADATE
     C                   ENDIF
 
     C                   IF        WRKCCY <> *BLANKS
     C                   EXSR      SRCURR
     C                   EVAL      OCCY = WRKCCY
     C                   ENDIF
 
      ** Principal Amount
 
     C                   IF        WRKPR$ <> *ZEROS
 
      ** Consider Derivative or Hedged Percentage
 
     C                   IF        FSPCTG <> *ZEROS
     C                   MULT      FSPCTG        WRKPR$
     C                   DIV(H)    100           WRKPR$
     C                   ENDIF
 
     C                   EVAL      PFLD15 = WRKPR$
     C                   EVAL      PDECS = PCDPF
     C                   IF        FSMOD = 'SE'                                               229035
     C                   EVAL      PDECS = NMDP                                               229035
     C                   ENDIF                                                                229035
     C                   EVAL      PECODE = 'J'
     C                   EXSR      SRCvtAmt
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVE      POUT21        OPRIN
     C                   ENDIF
 
      ** Interest Rate
 
     C                   IF        WRKINT <> *ZEROS
     C                   EVAL      PFLD15 = WRKINT
     C                   EVAL      PDECS = 7
     C                   EVAL      PECODE = 'L'
     C                   EXSR      SRCvtAmt
 
      ** Strip out negative sign.
 
     C                   EVAL      WFLD20 = POUT21
     C                   MOVE      WFLD20        OINTR
     C                   ENDIF
 
      ** Unrealised P/L-related
 
     C                   EXSR      SRUPL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtAmt - Convert Amount before printing                    *
      *                                                               *
      *****************************************************************
 
     C     SRCvtAmt      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCURR - Access currency details                             *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    WRKCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = WRKCCY
     C                   EVAL      DBPGM = 'AS001004'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PCCYF = A6CYCD
     C                   EVAL      PRATEF = A6SPRT
     C                   EVAL      PMDINF = A6MDIN
     C                   EVAL      PCDPF = A6NBDP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCCYCVT - Converts amount to base CCY                       *
      *                                                               *
      *****************************************************************
 
     C     SRCCYCVT      BEGSR
 
     C                   CALLB     'ZCCYCN'
     C                   PARM                    PAMTF
     C                   PARM                    PCCYF
     C                   PARM                    PCCYT
     C                   PARM                    PRATEF
     C                   PARM                    PRATET
     C                   PARM                    PMDINF
     C                   PARM                    PMDINT
     C                   PARM                    PCDPF
     C                   PARM                    PCDPT
     C                   PARM                    PAMTT
     C                   PARM                    PCRSRT
     C                   PARM                    PCRSMD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDATE - Convert Date to DDMMMYY format                      *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDATE
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDATE
     C                   PARM      *BLANKS       PZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUPL  - Unrealised P/L-related                              *
      *                                                               *
      *****************************************************************
 
     C     SRUPL         BEGSR
 
      ** Compare Hedge Linkage Start Date with Previous End of Year
 
     C                   IF        FSSTDT > BJPEYD
     C                   EVAL      YUPL = *ZEROS
     C                   ENDIF
 
      ** Consider Derivative or Hedged Percentage
 
     C                   IF        FSPCTG <> *ZEROS
     C                   MULT      FSPCTG        URPL
     C                   DIV(H)    100           URPL
     C                   MULT      FSPCTG        YUPL
     C                   DIV(H)    100           YUPL
     C                   ENDIF
 
      ** Convert to Base Currency URPL
 
     C                   IF        WRKTYP <> 'RX'                                             226170
 
     C                   IF        URPL  <> *ZEROS
     C     1             MULT      URPL          PAMTF
     C                   EXSR      SRCCYCVT
     C     1             MULT      PAMTT         URPL
     C                   ENDIF
 
     C                   IF        YUPL  <> *ZEROS
     C     1             MULT      YUPL          PAMTF
     C                   EXSR      SRCCYCVT
     C     1             MULT      PAMTT         YUPL
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
 
     C                   Z-ADD     1             CN                1 0
 
     C                   DO        3             CN
 
     C                   IF        WEFFFLG = 'I'
 
     C                   SELECT
 
     C                   WHEN      FSDHIN = 'D'
     C                   ADD       UPL(CN)       DER0I(CN)
     C                   ADD       UPL(CN)       DER1I(CN)
     C                   ADD       UPL(CN)       DER2I(CN)
     C                   ADD       UPL(CN)       DER3I(CN)
 
     C                   WHEN      FSDHIN = 'H'
     C                   ADD       UPL(CN)       HDG0I(CN)
     C                   ADD       UPL(CN)       HDG1I(CN)
     C                   ADD       UPL(CN)       HDG2I(CN)
     C                   ADD       UPL(CN)       HDG3I(CN)
 
     C                   ENDSL
 
     C                   ADD       UPL(CN)       TOT0I(CN)
     C                   ADD       UPL(CN)       TOT1I(CN)
     C                   ADD       UPL(CN)       TOT2I(CN)
     C                   ADD       UPL(CN)       TOT3I(CN)
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      FSDHIN = 'D'
     C                   ADD       UPL(CN)       DER0E(CN)
     C                   ADD       UPL(CN)       DER1E(CN)
     C                   ADD       UPL(CN)       DER2E(CN)
     C                   ADD       UPL(CN)       DER3E(CN)
 
     C                   WHEN      FSDHIN = 'H'
     C                   ADD       UPL(CN)       HDG0E(CN)
     C                   ADD       UPL(CN)       HDG1E(CN)
     C                   ADD       UPL(CN)       HDG2E(CN)
     C                   ADD       UPL(CN)       HDG3E(CN)
 
     C                   ENDSL
 
     C                   ADD       UPL(CN)       TOT0E(CN)
     C                   ADD       UPL(CN)       TOT1E(CN)
     C                   ADD       UPL(CN)       TOT2E(CN)
     C                   ADD       UPL(CN)       TOT3E(CN)
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL1 - New Hedge Strategy Level Break                      *
      *                                                               *
      *****************************************************************
     C     SRINL1        BEGSR
 
      ** Turn indicator off if not Cash Flow Hedge
 
     C                   IF        *IN27 = *OFF
     C                   EVAL      *IN40 = *OFF
     C                   ENDIF
 
      ** Turn indicator off if not Fair Value Hedge
 
     C                   IF        *IN25 = *OFF
     C                   EVAL      *IN41 = *OFF
     C                   ENDIF
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      INHESN = *BLANKS
 
     C                   EXSR      SRVAL1
 
      ** Initialize the saved value of the Hedge Id.
 
     C                   EVAL      SVHEDI = *BLANKS
 
      ** If Hedge Linkage records to print -first print new headings
 
     C                   IF        *IN77 = *ON
 
     C                   EVAL      INHESN = 'Y'
 
     C                   IF        EFFY <> *BLANKS
     C                   EVAL      O1HESN = H1HESN
     C                   EVAL      O1HELD = H1HELD
                                                                                              224985
     C                   IF        WOPEN <> 'Y'                                               224985
     C                   OPEN      AS001004P1                                                 224985
                                                                                              224985
      ** Ensure Report Spool File recorded by RCF.                                            224985
                                                                                              224985
     C                   CALL      'ZSFILE'                                                   224985
     C                   PARM      *BLANKS       PSEQ                                         224985
     C                   PARM      H1BRCA        PSENTY                                       224985
     C                   PARM                    SFILE1                                       224985
     C                   PARM      SFNUM1        PZSNUM                                       224985
     C                   PARM      *BLANKS       PZSERR                                       224985
                                                                                              224985
     C                   IF        PZSERR = 'Y'                                               224985
     C                   EVAL      *INU7 = *ON                                                224985
     C                   EVAL      *INU8 = *ON                                                224985
     C                   EVAL      *INLR = *ON                                                224985
     C                   RETURN                                                               224985
     C                   ENDIF                                                                224985
     C                   EVAL      WOPEN = 'Y'                                                224985
     C                   ENDIF                                                                224985
                                                                                              224985
     C                   EVAL      *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   IF        EFFN <> *BLANKS
     C                   EVAL      O1HES2 = H1HESN
     C                   EVAL      O1HEL2 = H1HELD
                                                                                              224985
     C                   IF        WOPEN2 <> 'Y'                                              224985
     C                   OPEN      AS001004P2                                                 224985
                                                                                              224985
      ** Ensure Report Spool File recorded by RCF.                                            224985
                                                                                              224985
     C                   CALL      'ZSFILE'                                                   224985
     C                   PARM      *BLANKS       PSEQ                                         224985
     C                   PARM      H1BRCA        PSENTY                                       224985
     C                   PARM                    SFILE2                                       224985
     C                   PARM      SFNUM2        PZSNUM                                       224985
     C                   PARM      *BLANKS       PZSERR                                       224985
                                                                                              224985
     C                   IF        PZSERR = 'Y'                                               224985
     C                   EVAL      *INU7 = *ON                                                224985
     C                   EVAL      *INU8 = *ON                                                224985
     C                   EVAL      *INLR = *ON                                                224985
     C                   RETURN                                                               224985
     C                   ENDIF                                                                224985
     C                   EVAL      WOPEN2 = 'Y'                                               224985
     C                   ENDIF                                                                224985
                                                                                              224985
     C                   EVAL      *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINL2 - New Product Type Level Break                        *
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
     C                   WHEN      X = 3
     C                   MOVEA     '001'         *IN(25)
     C                   ENDSL
     C                   ENDIF
 
     C                   MOVEA     *IN(25)       IN25              3
 
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
 
     C**********         IF        EFFY <> *BLANKS                                            224985
      **********                                                                              224985
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                       224985
      **********                                                                              224985
     C**********         CALL      'ZSFILE'                                                   224985
     C**********         PARM      *BLANKS       PSEQ                                         224985
     C**********         PARM      H1BRCA        PSENTY                                       224985
     C**********         PARM                    SFILE1                                       224985
     C**********         PARM      SFNUM1        PZSNUM                                       224985
     C**********         PARM      *BLANKS       PZSERR                                       224985
      **********                                                                              224985
     C**********         IF        PZSERR = 'Y'                                               224985
     C**********         EVAL      *INU7 = *ON                                                224985
     C**********         EVAL      *INU8 = *ON                                                224985
     C**********         EVAL      *INLR = *ON                                                224985
     C**********         RETURN                                                               224985
     C**********         ENDIF                                                                224985
     C**********         ENDIF                                                                224985
 
     C**********         IF        EFFN <> *BLANKS                                            22498
      **********                                                                              22498
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                       22498
      **********                                                                              22498
     C**********         CALL      'ZSFILE'                                                   22498
     C**********         PARM      *BLANKS       PSEQ                                         22498
     C**********         PARM      H1BRCA        PSENTY                                       224985
     C**********         PARM                    SFILE2                                       224985
     C**********         PARM      SFNUM2        PZSNUM                                       224985
     C**********         PARM      *BLANKS       PZSERR                                       224985
      **********                                                                              224985
     C**********         IF        PZSERR = 'Y'                                               224985
     C**********         EVAL      *INU7 = *ON                                                224985
     C**********         EVAL      *INU8 = *ON                                                224985
     C**********         EVAL      *INLR = *ON                                                224985
     C**********         RETURN                                                               224985
     C**********         ENDIF                                                                224985
     C**********         ENDIF                                                                224985
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM      H1BRCA        PBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C                   IF        EFFY <> *BLANK
     C                   EVAL      O1BRCD = H1BRCA
     C                   EVAL      O1BRNM = A8BRNM
     C                   ENDIF
 
     C                   IF        EFFN <> *BLANK
     C                   EVAL      O1BRC2 = H1BRCA
     C                   EVAL      O1BRN2 = A8BRNM
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVAL1 - Check if Hedge Linkages exist                       *
      *                                                               *
      *****************************************************************
     C     SRVAL1        BEGSR
 
      ** Save Hedge Strategy fields of a currently read record
 
     C                   EVAL      KBRCA = H1BRCA
     C                   EVAL      KPRTP = H1PRTP
     C                   EVAL      KHESN = H1HESN
     C                   EVAL      WEFLO = H1EFLO
     C                   EVAL      WEFHI = H1EFUP
 
      ** Initialise indicators
 
     C                   EVAL      *IN77 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      EFFYN = *BLANKS
 
      ** Position and read Hedge Strategy file based on break
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C     KBRCA         SETLL     SDHGSTD3
     C     KBRCA         READE     SDHGSTD3                               89
 
     C                   WHEN      *IN02 = *ON
     C     KYPRTP        SETLL     SDHGSTD3
     C     KYPRTP        READE     SDHGSTD3                               89
 
     C                   WHEN      *IN01 = *ON
     C     KYHESN        SETLL     SDHGSTD3
     C     KYHESN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   DOW       *IN89 = *OFF
 
      ** Read Hedge Linkage records
 
     C                   EXSR      SRVAL2
 
      ** If at least one effective and one ineffective record exist
      ** - exit reading loop
 
     C                   IF        EFFY <> *BLANKS AND EFFN <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C     KBRCA         READE     SDHGSTD3                               89
     C                   WHEN      *IN02 = *ON
     C     KYPRTP        READE     SDHGSTD3                               89
     C                   WHEN      *IN01 = *ON
     C     KYHESN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   ENDDO
 
      ** If either record exists no further checking is necessary
 
     C                   IF        EFFYN <> *BLANKS AND *IN77 = *OFF
     C                   EVAL      *IN77 = *ON
     C                   ENDIF
 
      ** Restore Hedge Strategy fields of a currently read record
 
     C                   EVAL      H1BRCA = KBRCA
     C                   EVAL      H1PRTP = KPRTP
     C                   EVAL      H1HESN = KHESN
     C                   EVAL      H1EFLO = WEFLO
     C                   EVAL      H1EFUP = WEFHI
 
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
 
      ** Read Hedge Strategy's Hedge Linkage records in search of a live
      ** one
 
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If qualifying Hedge Linkage records found
 
     C                   IF        FSRECI = 'D'
     C                             AND H1MEFF <> 'R'                                          224985
     C                             AND FSSECR = 'Y'                                           224985
     C                   EVAL      EFFY = 'Y'
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                             AND H1MEFF <> 'R'                                          224985
     C                             AND FSSECR = 'Y'                                           224985
     C                   EVAL      EFFN = 'Y'
     C                   ENDIF
     C                   ENDIF
 
      ** If at least one effective and one ineffective record exist
      ** - exit reading loop
 
     C                   IF        EFFY <> *BLANKS AND EFFN <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               87
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDTOE - Print Hedge Linkage totals (Derivative)- Effective  *
      *                                                               *
      *****************************************************************
     C     SRDTOE        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOD1
 
      ** Derivative
 
     C                   EVAL      AR = DER0E
     C                   EXSR      SRAMT
     C                   EVAL      ODURPL = AMT(1)
     C                   EVAL      ODYUPL = AMT(2)
     C                   EVAL      ODDIFF = AMT(3)
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (DERIVATIVE)
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOD1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        DER0E
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDTOI - Print Hedge Linkage tot (Derivative) - Ineffective  *
      *                                                               *
      *****************************************************************
     C     SRDTOI        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOD2
 
      ** Derivative
 
     C                   EVAL      AR = DER0I
     C                   EXSR      SRAMT
     C                   EVAL      ODURPL = AMT(1)
     C                   EVAL      ODYUPL = AMT(2)
     C                   EVAL      ODDIFF = AMT(3)
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (DERIVATIVE)
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOD2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        DER0I
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHTOE - Print Hedge Linkage totals (Hedged) - Effective     *
      *                                                               *
      *****************************************************************
     C     SRHTOE        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOH1
 
      ** Hedged
 
     C                   EVAL      AR = HDG0E
     C                   EXSR      SRAMT
     C                   EVAL      OHURPL = AMT(1)
     C                   EVAL      OHYUPL = AMT(2)
     C                   EVAL      OHDIFF = AMT(3)
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (HEDGED)
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOH1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        HDG0E
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHTOI - Print Hedge Linkage totals (Hedged) - Ineffective   *
      *                                                               *
      *****************************************************************
     C     SRHTOI        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOH2
 
      ** Hedged
 
     C                   EVAL      AR = HDG0I
     C                   EXSR      SRAMT
     C                   EVAL      OHURPL = AMT(1)
     C                   EVAL      OHYUPL = AMT(2)
     C                   EVAL      OHDIFF = AMT(3)
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (HEDGED)
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOH2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        HDG0I
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNTOE - Print Hedge Linkage totals - Effective              *
      *                                                               *
      *****************************************************************
     C     SRNTOE        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOT1
     C                   CLEAR                   PERCENT1
 
      ** Total
 
     C                   EVAL      AR = TOT0E
     C                   EXSR      SRAMT
     C                   EVAL      OTURPL = AMT(1)
     C                   EVAL      OTYUPL = AMT(2)
     C                   EVAL      OTDIFF = AMT(3)
 
      ** Change Percentage
 
     C                   EXSR      SRCHGP
 
      ** Set Indicator 40 on
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (TOTAL)
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOT1
 
      ** Print blank line
 
      ** Set Indicator 40 on
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Change Percentage
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
                                                                                              225293
     C                   EVAL      OLASDT = WLASDT                                            225293
     C                   EVAL      *IN24 = *OFF                                               225293
     C                   IF        FSLASD = 0                                                 225293
     C                   EVAL      OLASDT = *BLANKS                                           225293
     C                   EVAL      OCHGPC = *BLANKS                                           225293
      *                                                                                       229468
      ** Print "NEW" instead of 0.00% as Hedge Effectiveness to inform                        229468
      ** the user that the linkage has not been assessed yet.                                 229468
      *                                                                                       229468
     C                   MOVE      'NEW'         OCHGPC                                       229468
     C                   EVAL      PDate = FSSTDT                                             225293
     C                   EXSR      SRDATE                                                     225293
     C                   EVAL      OLASDT = PZADATE                                           225293
     C                   EVAL      *IN24 = *ON                                                225293
     C                   ENDIF                                                                225293
                                                                                              225293
     C                   WRITE     PERCENT1
 
      ** Print dotted line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     DOTTED1
 
      ** Increment count of effective hedges
 
     C                   EVAL      ECOUNT = ECOUNT + 1
 
      ** Initialise totals fields after printing
 
     C                   EVAL      TOT0E = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNTOI - Print Hedge Linkage totals - Ineffective            *
      *                                                               *
      *****************************************************************
     C     SRNTOI        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOT2
     C                   CLEAR                   PERCENT2
 
      ** Total
 
     C                   EVAL      AR = TOT0I
     C                   EXSR      SRAMT
     C                   EVAL      OTURPL = AMT(1)
     C                   EVAL      OTYUPL = AMT(2)
     C                   EVAL      OTDIFF = AMT(3)
 
      ** Change Percentage
 
     C                   EXSR      SRCHGP
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (TOTAL)
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOT2
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Change Percentage
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   EVAL      OLASDT = WLASDT                                            229219
     C                   WRITE     PERCENT2
 
      ** Print dotted line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     DOTTED2
 
      ** Increment count of ineffective hedges
 
     C                   EVAL      ICOUNT = ICOUNT + 1
 
      ** Initialise totals fields after printing
 
     C                   EVAL      TOT0I = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHGP  -Change Percentage calculation                       *
      *                                                               *
      *****************************************************************
     C     SRCHGP        BEGSR
 
      ** Convert to a whole field
 
     C     100           MULT(H)   FSHEFP        PFLD15
 
      ** Convert to a character field (length 22)
 
     C                   Z-ADD     2             PDECS
     C                   EVAL      PECODE = 'L'
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25
 
     C                   MOVEA     POUT22        A22
 
      ** Convert to a character field (length 5)
 
     C                   EVAL      C22 = 1
     C                   DO        22            C22
 
     C     A22(C22)      IFGE      '0'
     C     A22(C22)      ANDLE     '9'
     C                   MOVEA     A22(C22)      OCHGPC
     C                   LEAVE
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EVALR     OCHGPC = %TRIMR(OCHGPC)
 
      ** Last assessment date
 
     C                   EVAL      PDate = FSLASD
     C                   EXSR      SRDATE
     C**********         EVAL      OLASDT = *BLANK                                            225293
     C**********         EVAL      OLASDT = PZADATE                                           225293
     C                   EVAL      WLASDT = PZADATE                                           225293
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHSTE - Print Hedge Strategy totals - Effective             *
      *                                                               *
      *****************************************************************
     C     SRHSTE        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD1
     C                   CLEAR                   HSENTOH1
     C                   CLEAR                   HSENTON1
 
      ** Derivative
 
     C                   Z-ADD     DER1E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD1
     C                   MOVE      AMT(2)        YUPLD1
     C                   MOVE      AMT(3)        DIFFD1
 
      ** Hedged
 
     C                   Z-ADD     HDG1E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH1
     C                   MOVE      AMT(2)        YUPLH1
     C                   MOVE      AMT(3)        DIFFH1
 
      ** Total
 
     C                   Z-ADD     TOT1E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN1
     C                   MOVE      AMT(2)        YUPLN1
     C                   MOVE      AMT(3)        DIFFN1
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
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
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTOH1
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTON1
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Initialise totals fields after printing
 
     C                   EVAL      L1CNT = *ZEROS
     C                   EVAL      DER1E = *ZEROS
     C                   EVAL      HDG1E = *ZEROS
     C                   EVAL      TOT1E = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRHSTI - Print Hedge Strategy totals - Ineffective           *
      *                                                               *
      *****************************************************************
     C     SRHSTI        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD2
     C                   CLEAR                   HSENTOH2
     C                   CLEAR                   HSENTON2
 
      ** Derivative
 
     C                   Z-ADD     DER1I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD1
     C                   MOVE      AMT(2)        YUPLD1
     C                   MOVE      AMT(3)        DIFFD1
 
      ** Hedged
 
     C                   Z-ADD     HDG1I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH1
     C                   MOVE      AMT(2)        YUPLH1
     C                   MOVE      AMT(3)        DIFFH1
 
      ** Total
 
     C                   Z-ADD     TOT1I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN1
     C                   MOVE      AMT(2)        YUPLN1
     C                   MOVE      AMT(3)        DIFFN1
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Strategy totals
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTOD2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTOH2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     HSENTON2
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Initialise totals fields after printing
 
     C                   EVAL      W1CNT = *ZEROS
     C                   EVAL      DER1I = *ZEROS
     C                   EVAL      HDG1I = *ZEROS
     C                   EVAL      TOT1I = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPTTE - Print Product Type totals - Effective               *
      *                                                               *
      *****************************************************************
     C     SRPTTE        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD1
     C                   CLEAR                   PRTPTOH1
     C                   CLEAR                   PRTPTON1
 
      ** Derivative
 
     C                   Z-ADD     DER2E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD2
     C                   MOVE      AMT(2)        YUPLD2
     C                   MOVE      AMT(3)        DIFFD2
 
      ** Hedged
 
     C                   Z-ADD     HDG2E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH2
     C                   MOVE      AMT(2)        YUPLH2
     C                   MOVE      AMT(3)        DIFFH2
 
      ** Total
 
     C                   Z-ADD     TOT2E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN2
     C                   MOVE      AMT(2)        YUPLN2
     C                   MOVE      AMT(3)        DIFFN2
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
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
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTOH1
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTON1
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Initialise totals fields after printing
 
     C                   EVAL      L2CNT = *ZEROS
     C                   EVAL      DER2E = *ZEROS
     C                   EVAL      HDG2E = *ZEROS
     C                   EVAL      TOT2E = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPTTI - Print Product Type totals - Ineffective             *
      *                                                               *
      *****************************************************************
     C     SRPTTI        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD2
     C                   CLEAR                   PRTPTOH2
     C                   CLEAR                   PRTPTON2
 
      ** Derivative
 
     C                   Z-ADD     DER2I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD2
     C                   MOVE      AMT(2)        YUPLD2
     C                   MOVE      AMT(3)        DIFFD2
 
      ** Hedged
 
     C                   Z-ADD     HDG2I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH2
     C                   MOVE      AMT(2)        YUPLH2
     C                   MOVE      AMT(3)        DIFFH2
 
      ** Total
 
     C                   Z-ADD     TOT2I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN2
     C                   MOVE      AMT(2)        YUPLN2
     C                   MOVE      AMT(3)        DIFFN2
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Product Type totals
 
     C                   MOVEA     IN25          *IN(25)
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTOD2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTOH2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     PRTPTON2
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Initialise totals fields after printing
 
     C                   EVAL      W2CNT = *ZEROS
     C                   EVAL      DER2I = *ZEROS
     C                   EVAL      HDG2I = *ZEROS
     C                   EVAL      TOT2I = *ZEROS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRTE - Print Branch Totals - Effective                     *
      *                                                               *
      *****************************************************************
     C     SRBRTE        BEGSR
 
     C                   IF        L3CNT > *ZEROS
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD1
     C                   CLEAR                   BRCATOH1
     C                   CLEAR                   BRCATON1
 
      ** Derivative
 
     C                   Z-ADD     DER3E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD3
     C                   MOVE      AMT(2)        YUPLD3
     C                   MOVE      AMT(3)        DIFFD3
 
      ** Hedged
 
     C                   Z-ADD     HDG3E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH3
     C                   MOVE      AMT(2)        YUPLH3
     C                   MOVE      AMT(3)        DIFFH3
 
      ** Total
 
     C                   Z-ADD     TOT3E         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN3
     C                   MOVE      AMT(2)        YUPLN3
     C                   MOVE      AMT(3)        DIFFN3
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
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
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATOH1
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATON1
 
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
 
      ** Initialise totals fields after printing
 
     C                   EVAL      L3CNT = *ZEROS
     C                   EVAL      DER3E = *ZEROS
     C                   EVAL      HDG3E = *ZEROS
     C                   EVAL      TOT3E = *ZEROS
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBRTI - Print Branch Totals - Ineffective                   *
      *                                                               *
      *****************************************************************
     C     SRBRTI        BEGSR
 
     C                   IF        W3CNT > *ZEROS
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD2
     C                   CLEAR                   BRCATOH2
     C                   CLEAR                   BRCATON2
 
      ** Derivative
 
     C                   Z-ADD     DER3I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD3
     C                   MOVE      AMT(2)        YUPLD3
     C                   MOVE      AMT(3)        DIFFD3
 
      ** Hedged
 
     C                   Z-ADD     HDG3I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH3
     C                   MOVE      AMT(2)        YUPLH3
     C                   MOVE      AMT(3)        DIFFH3
 
      ** Total
 
     C                   Z-ADD     TOT3I         AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN3
     C                   MOVE      AMT(2)        YUPLN3
     C                   MOVE      AMT(3)        DIFFN3
 
     C                   IF        WIn40Flag = 'Y'
     C                   EVAL      *IN40 = *ON
     C                   ENDIF
 
     C                   IF        WIn41Flag = 'Y'
     C                   EVAL      *IN41 = *ON
     C                   ENDIF
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Branch totals
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATOD2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATOH2
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BRCATON2
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Trailer
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     TRAILP2
 
      ** Initialise totals fields after printing
 
     C                   EVAL      W3CNT = *ZEROS
     C                   EVAL      DER3I = *ZEROS
     C                   EVAL      HDG3I = *ZEROS
     C                   EVAL      TOT3I = *ZEROS
 
     C                   ENDIF
 
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
     C                   EVAL      KAShed = FSHEDI                                            225293
     C                   EVAL      KASdhi = 'H'                                               225293
     C                   EVAL      WkBase = 'N'                                               225293
                                                                                              225293
     C     KASHTR        CHAIN     ASHTRNLB                           30                      225293
                                                                                              225293
     C                   DOW       *IN30 = *OFF AND WkBase = 'N'                              225293
                                                                                              225293
     C                   IF        HIFSHTID = 'D'                                             225293
     C                             AND HIFSMOD = 'SE'                                         225293
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
     C                   ENDIF                                                                225293
                                                                                              225293
     C     KASHTR        READE     ASHTRNLB                               30                  225293
     C                   ENDDO                                                                225293
                                                                                              225293
     C                   ENDSR                                                                225293
                                                                                              225293
      *****************************************************************                       225293
      /EJECT                                                                                  225293
      *****************************************************************
      *                                                               *
      *  SRAMT -  Convert numeric amounts into character fields       *
      *                                                               *
      *****************************************************************
     C     SRAMT         BEGSR
 
     C                   Z-ADD     1             CN
     C                   MOVEA     *BLANKS       AMT
 
     C                   DO        3             CN
 
     C                   Z-ADD     AR(CN)        PFLD15
     C                   Z-ADD     PCDPT         PDECS
     C                   MOVE      'J'           PECODE
 
     C                   CALLB     'ZFRPED'
     C                   PARM                    PFLD15
     C                   PARM                    PDECS
     C                   PARM                    PECODE
     C                   PARM                    POUT22
     C                   PARM                    POUT25
 
     C                   MOVEL     POUT22        WRK21
     C                   MOVE      WRK21         AMT(CN)
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *****************************************************************
     C     SRAUDIT       BEGSR
 
      ** Output Report Header and File Controls.
 
     C                   MOVE      BJMRDT        ORPTDT
 
     C                   WRITE     HEADAU
 
     C                   WRITE     TOTAUD
 
      ** If there is a DB Error, Output the DB Error Information.
 
     C     *INU7         IFEQ      *ON
     C                   WRITE     DBERROR
 
     C                   ELSE
 
      ** Or, if no records written, output "No Details" message.
 
     C     SCOUNT        IFEQ      *ZEROS
     C                   WRITE     NODTLS
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C/COPY ZACPYSRC,DBFIELDS
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'AS001003P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call access program for General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRTCD
     C                   PARM      '*FIRST '     POPTN
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = POPTN
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WEvCtlDt = BJDNWD - 1
     C                   IF        BKAPDT < WEvCtlDt
     C                   EVAL      WEvCtlDt = BKAPDT
     C                   ENDIF
     C                   EVAL      PDATE = WEvCtlDt
     C                   EXSR      SRDATE
     C                   EVAL      OEVCD1 = PZADATE
     C                   EVAL      OEVCD2 = PZADATE
     C                   EVAL      OEVCD3 = PZADATE
 
      ** Product Type Key List
 
     C     KYPRTP        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KPRTP
 
      ** Strategy Key List
 
     C     KYHESN        KLIST
     C                   KFLD                    KBRCA
     C                   KFLD                    KPRTP
     C                   KFLD                    KHESN
 
      ** Linkage Key List
 
     C     KYTRAN        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    HGHDIN
 
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
     C**********         KFLD                    FSDLNO                                225293 CLE148
     C                   KFLD                    FSDLNO2                                      CLE148
     C                   KFLD                    WRKCCY                                       225293
                                                                                              225293
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          BJMRDT
     C                   MOVE      RDNB          WURDNB
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSEQ
     C                   PARM      *BLANKS       PSENTY
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        PZSNUMU
     C                   PARM      *BLANK        PZSERR
 
      ** Retrieve Base Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = BJCYCD
     C                   EVAL      DBPGM = 'AS001004'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PCCYT = A6CYCD
     C                   EVAL      PRATET = A6SPRT
     C                   EVAL      PMDINT = A6MDIN
     C                   EVAL      PCDPT = A6NBDP
     C                   EVAL      WOPEN = 'N'                                                224985
     C                   EVAL      WOPEN2 = 'N'                                               224985
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
      *           Called automatically if a program error occurs,     *
      *           or directly by the program code using EXSR.         *
      *           This subroutine DUMPs the program just once.        *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
 
      ** Check to see that *PSSR has not already been called.
 
     C                   IF        WRun <> 'Y'
     C                   EVAL      WRun = 'Y'
     C                   DUMP
     C                   ENDIF
 
      ** If *PSSR already run, then just end the program here.
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   EXSR      SRAUDIT
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
** Product Types
FV
FX
CF
