     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Regression Analysis Report Program')          *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS001023 - Regression Analysis Report Program                *
      *                                                               *
      *  Function:  This module will assess each linkage with         *
      *             assessment method equal to 'R'.  It will only     *
      *             calculate the 3 factors for hedge assessment.     *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL099             Date 06Oct17               *
      *  Prev Amend No. CGL165             Date 17Feb15               *
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
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 228948             Date 27Sep04               *
      *                 229035             Date 16Aug04               *
      *                 224985             Date 18Feb04               *
      *                 224952             Date 11Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229035 - The principal amount in SE module is the nominal    *
      *           amount.                                             *
      *  224985 - Report is showing additional headers/footers for    *
      *           'No Details to Report'                              *
      *  224952 - Show Historic Market Details for Hedged Items       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** RTV : Hedge Strategy By Short-name
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD1)
     F                                     PREFIX(H1:2)
 
      ** RTV : Hedge Strategy By Branch and Product Type
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
 
      ** RTV : Hedge Strategy By Branch and Product Type
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD3)
     F                                     PREFIX(H1:2)
 
      ** Midas AS Hedge Linkage File Retrieval by Hedge ID
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHGLKD0:ASHGLKD1)
 
      ** RTV : Hedge Linkage Retrieval By Hedge Strategy
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND1)
 
      ** RTV:  Revalued Securities Positions
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV: Deals Files
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
 
      ** RTV: Loans           w
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
 
      ** RTV: Security File
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas SD T Distribution Table File Retrieval
     FSDTDTBL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Midas AS Dealing Historic Market Data File
      ** by Deal number and Value date - LIVE
     FASDLHML2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D2:2)
 
      ** Midas AS Dealing Historic Market Data File
      ** by Deal number and Value date - LIVE
     FASDLHML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D3:2)
     F                                     RENAME(ASDLHMD0:ASDLHMD3)
 
      ** Midas AS Securities Historic Market Data File
      ** by Security shortname and Value date - LIVE
     FASSEHML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SC:2)
 
      ** Midas AS Lending Historic Market Data File
      ** by Loan number and value date - LIVE
     FASLEHML2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LE:2)
 
      ** PRT: Printer file for Effective Hedges (Transaction Detail)
     FAS001023P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN                                             224985
 
      ** PRT: Printer file for Ineffective Hedges (Transaction Detail)
     FAS001023P2O    E             PRINTER OFLIND(*IN44)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
     F                                     USROPN                                             224985
 
      ** PRT: Printer file for Hedge Effectiveness(Audit)
     FAS001023AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
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
 
     D MON             S              3    DIM(12) CTDATA PERRCD(12)
     D NUM             S              2  0 DIM(12) ALT(MON)
 
     D TP              S              2    DIM(3) CTDATA PERRCD(1)
 
      ** Arrays for Unrealised P/L (General Work)
     D AR              S             13  0 DIM(3)
     D AMT             S             18    DIM(3)
 
      ** Record Format
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** Today's Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  MBIN                  13     13
 
      ** File Information Data Structure for AS001023P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS001023P2
     D SPOOL2          DS
     D  SFILE2                83     92
     D  SFNUM2               123    124B 0
     D  OFLLN2               188    189B 0
     D  PRTLN2               367    368B 0
 
      ** File Information Data Structure for AS001023AU
     D SPOOLU          DS
     D  SFILEU                83     92
     D  SFNUMU               123    124B 0
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** External data structure for General Ledger ICD Details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structures for Hedging ICD
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
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
     D  FSFPSE                 1     10
     D  INSFLD                 6     10
     D  INSMM@                 6      8
     D  INSYY@                 9     10
     D  FSBKCD                11     12
     D  FSBRCA                13     15
     D  FSPCAL                16     16
     D  FSMKTI                17     17
     D  FSBHTV                18     18
     D  FSKEY                  1     18
 
     D                 DS
     D  WEffYN                 1      2
     D  WEffY                  1      1
     D  WEffN                  2      2
 
      ** Work Indicators
     D WLVInd          DS
     D  WLVInd3                1      1
     D  WLVInd2                2      2
     D  WLVInd1                3      3
 
      ** Entry Parameters List
     D PEntry          S              6A
 
      ** Parameters for Access Objects
     D Prtcd           S              7
     D POptn           S              7
     D PBrca           S              3
     D PSar            S              6
 
     D WEvCtlDt        S              5P 0
 
      ** Details Fields
     D WrkDLN          S             10
     D WrkBKC          S              2
     D WrkTYP          S              2
     D WrkSTP          S              2
     D*WrkCNU***       S              6  0                                                    CSD027
     D WrkCNU          S              6A                                                      CSD027
     D WrkVAL          S              5  0
     D WrkMAT          S              5  0
     D WrkCCY          S              3
     D WrkPR$          S             13  0
     D WrkINT          S             11  0
     D WrkRSQ          S              9  7
     D WrkTST          S             16  4
     D WrkSLC          S             15  3
 
     D M               S              3  0
     D X               S              1  0
     D WInBrca         S              1
     D WInHeSN         S              1
     D WInPrTP         S              1
     D WTmpHEDI        S              6
     D W@Brca          S              3
     D W@PrTP          S              2
     D W@HeSN          S             10
 
      ** Key list for Linkages file
     D KFSHedi         S                   LIKE(FSHEDI)
     D KFSHDIn         S              1
 
      ** Parameters for ZSFILE
     D PSeq            S              5
     D PEnty           S              3
     D PZSNum          S              6  0
     D PZSErr          S              1
     D PZSNumU         S              6  0
 
      ** Parameters for ZFRPED
     D PFld15          S             15  0
     D PDecs           S              1  0
     D PECode          S              1
     D POut21          S             21
 
     D WDCount         S              7  4
     D WHCount         S              7  4
     D WTCount         S              7  4
     D WEffFlg         S              1
     D WPrint          S              1
     D WRun            S              1
 
     D WCdPf           S              1P 0
 
     D PZDate          S              6  0
     D PZaDate         S              7
     D PDate           S                   LIKE(WrkVAL)
 
     D WMVAL           S             15  0                                                    224952
     D WMVCA           S             15  0                                                    224952
     D WMRAT           S             15  8                                                    224952
                                                                                              224952
     D WFld20          S             20
 
      ** Fields used to define Key List for Midas DL Forward Commitment File
     D KXXDfrd         S                   LIKE(XXDfrd)
     D KXXArea         S                   LIKE(XXArea)
 
     D WkHEDI          S              6  0
     D KDerivHEDI      S                   LIKE(FSHEDI)
     D KDerivDLNO      S                   LIKE(FSDLNO)
     D KHedgdHEDI      S                   LIKE(FSHEDI)
     D KHedgdDLNO      S                   LIKE(FSDLNO)
     D KHedgdSESN      S                   LIKE(FSFPSE)
     D KHedgdBRCA      S                   LIKE(FSBRCA)
     D KHedgdBKCD      S                   LIKE(FSBKCD)
     D KHedgdMKTI      S                   LIKE(FSMKTI)
     D KHedgdBHTV      S                   LIKE(FSBHTV)
     D WHedgdPCTG      S              5  4
     D WDerivPCTG      S              5  4
     D WTrail          S              1A
     D WDf             S                   LIKE(XXDFRD)
     D WAlpha          S                   LIKE(XXAREA)
     D WXXDfrd         S              3A
     D WXXArea         S              5A
     D WDetail1Ctr     S              4S 0
     D WDetail2Ctr     S              4S 0
 
      ** Work fields for accessing Historic Market Data
     D KDrvtvDLNO      S                   LIKE(FSDLNO)
     D WDataCount      S              4  0
     D***WDrvtvInd       S              1A   INZ('Y')                                         224952
     D WDet1           S              1A
     D WOPEN           S              1                                                       224985
     D WOPEN2          S              1                                                       224985
 
      ** Key fields for accessing Historic Market Data
     D KVdat           S                   LIKE(D3VDAT)
 
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
     C                   EXSR      SrAudit
     C                   ELSE
 
      ** Do while not End of file
 
     C                   DOW       *IN12 = *OFF
 
     C                   IF        *IN12 = *OFF
     C                             AND H1MEFF =  'R'
 
     C                   SELECT
 
     C                   WHEN      W@Brca <> H1BRCA
     C                   EVAL      WLVInd = 'YYY'
 
     C                   WHEN      W@PrTP <> H1PRTP
     C                   EVAL      WLVInd = 'NYY'
 
     C                   WHEN      W@HeSN <> H1HESN
     C                   EVAL      WLVInd = 'NNY'
     C                   ENDSL
 
      ** If change in Branch
 
     C                   IF        WLVInd3 = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SrInL3
     C                   EVAL      *IN03 = *OFF
     C                   EVAL      WDetail1Ctr = 0
     C                   EVAL      WDetail2Ctr = 0
     C                   ENDIF
 
     C                   EXSR      SRProcess
 
     C                   ENDIF
 
     C                   READ      SDHGSTL2                               12
 
      ** At end of branch print totals, trailer and close printer file
 
     C                   IF        W@Brca <> H1BRCA OR *IN12 = *ON
     C                   EVAL      WInBrca = *BLANKS
 
     C                   IF        WTrail = 'Y'
     C                   EXSR      SrTrail
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   EXSR      SrAudit
     C                   ENDIF
 
     C                   EVAL      *INLR = *On
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Records                                   *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
     C                   IF        WInBrca = 'Y'
     C                   IF        WLVInd2 = 'Y'
     C                   EVAL      *IN02 = *ON
     C                   EXSR      SrInL2
     C                   EVAL      *IN02 = *OFF
     C                   ENDIF
 
     C                   IF        WInPrTP = 'Y'
     C                   IF        WLVInd1 = 'Y'
     C                   EVAL      *IN01 = *ON
     C                   EXSR      SrInL1
     C                   EVAL      *IN01 = *OFF
     C                   ENDIF
 
     C                   IF        WInHeSN = 'Y'
     C                   EVAL      SCOUNT = SCOUNT + 1
     C                   EXSR      SrLnk1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLnk1 - Hedge Linkage Processing Main                        *
      *                                                               *
      *****************************************************************
 
     C     SrLnk1        BEGSR
 
      ** For each Hedge Strategy - read all Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               89
 
     C                   DOW       *IN89 = *OFF
 
      ** If qualifying Hedge Linkage record exists
 
     C                   IF        FSRECI = 'D'
     C                             OR FSRECI = 'X'
 
      ** Initialise effectiveness flag
 
     C                   IF        FSRECI = 'D'
     C                             AND H1MEFF = 'R'                                           224985
     C                   IF        FSDPTR < FSDPTS                                            224985
     C                   EVAL      WEffFlg = 'I'                                              224985
     C                   ELSE                                                                 224985
     C                   EVAL      WEffFlg = 'E'
     C                   ENDIF                                                                224985
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                             AND H1MEFF = 'R'                                           224985
     C                   EVAL      WEffFlg = 'I'
     C                   ENDIF
     C                   ENDIF
 
      ** Compute for the three factor for Regression Analysis.
 
     C                   EVAL      WrkRSQ = *ZEROS
     C                   EVAL      WrkTST = *ZEROS
     C                   EVAL      WrkSLC = *ZEROS
     C                   EXSR      SR3Print
 
      ** Process Hedge Transaction records without detail printing
 
     C                   EVAL      WPrint = 'N'
     C                   EXSR      SrLnk2
 
      ** If live Hedge Transaction Details exist and today is Eff. Date
 
     C                   IF        WTCount > *ZEROS
 
      ** Increment Hedge Linkage count
 
     C                   EVAL      LCOUNT = LCOUNT + 1
 
      ** Process Hedge Transaction records with detail printing
 
     C                   EVAL      WPrint = 'Y'
 
     C                   EXSR      SrLnk2
 
     C                   IF        WEffFlg = 'E'
     C                   EXSR      SrETot
     C                   ELSE
     C                   IF        WEffFlg = 'I'
     C                   EXSR      SrITot
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
      * SrLnk2 - Hedge Linkage Processing Subordinated                *
      *                                                               *
      *****************************************************************
 
     C     SrLnk2        BEGSR
 
      ** Initialise Hedge Transaction count
 
     C                   EVAL      WTCount = *ZEROS
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      WDCount = *ZEROS
     C                   EVAL      KFSHedi = FSHEDI
     C                   EVAL      KFSHDIn = 'D'
     C                   EXSR      SrTrn1
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      WHCount = *ZEROS
     C                   EVAL      KFSHedi = FSHEDI
     C                   EVAL      KFSHDIn = 'H'
     C                   EXSR      SrTrn1
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrn1 - Hedge Transaction Processing                         *
      *                                                               *
      *****************************************************************
 
     C     SrTrn1        BEGSR
 
      ** Read all Derivative or Hedged Transaction records of a Hedge
 
     C                   EVAL      *IN87 = *OFF
     C     KyTran        SETLL     ASHTRNL0
     C     KyTran        READE     ASHTRNL0                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If in non-print mode -increment count of processed records;
      ** otherwise, convert file fields for printing and print details
 
     C                   IF        WPrint = 'N'
     C                   EVAL      WTCount = WTCount + 1
     C                   ELSE
     C                   EXSR      SrTrn2
     C                   ENDIF
 
     C     KyTran        READE     ASHTRNL0                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrn2 - Move data to workfields and print Transaction Report *
      *                                                               *
      *****************************************************************
 
     C     SrTrn2        BEGSR
 
      ** Clear workfields
 
     C                   EVAL      WrkDLN = *BLANKS
     C                   EVAL      WrkBKC = *BLANKS
     C                   EVAL      WrkTYP = *BLANKS
     C                   EVAL      WrkSTP = *BLANKS
     C**********         EVAL      WrkCNU = *ZEROS                                            CSD027
     C                   EVAL      WrkCNU = *BLANKS                                           CSD027
     C                   EVAL      WrkVAL = *ZEROS
     C                   EVAL      WrkMAT = *ZEROS
     C                   EVAL      WrkCCY = *BLANKS
     C                   EVAL      WrkPR$ = *ZEROS
     C                   EVAL      WrkINT = *ZEROS
 
      ** Retrieve Transaction details from pertinent files
 
      ** Initialize Indicator 55 to ensure correct processing after
      ** a Security transaction is ignored
 
     C                   EVAL      *IN55 = *ON
 
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SrDlNo
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SrLeNo
 
     C                   WHEN      FSMOD = 'SE'
     C                   EXSR      SrSeNo
 
     C                   ENDSL
 
      ** If record found in file
 
     C                   IF        *IN55 = *OFF
 
      ** Clear detail printer file record
 
     C                   IF        WEffFlg = 'I'
     C                   CLEAR                   DETAIL2
     C                   ELSE
     C                   CLEAR                   DETAIL1
     C                   ENDIF
 
      ** Load printer file fields
 
     C                   EXSR      SrTrn3
 
      ** Print Hedge Transaction details
 
     C                   IF        WEffFlg = 'I'
 
      ** Check if printing new Hedge ID, if so, print heading.
 
     C                   IF        OHEDI <> WTmpHEDI
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
     C                   EVAL      WDet1 = 'N'
     C                   EXSR      SRHMDD
     C                   EVAL      WTrail = 'Y'
     C                   EVAL      WDetail2Ctr = WDetail2Ctr + 1
 
     C                   ELSE
 
      ** Check if printing new Hedge ID, if so, print heading.
 
     C                   IF        OHEDI <> WTmpHEDI
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
     C                   EVAL      WDet1 = 'Y'
     C                   EXSR      SRHMDD
     C                   EVAL      WTrail = 'Y'
     C                   EVAL      WDetail1Ctr = WDetail1Ctr + 1
 
     C                   ENDIF
 
      ** Save value of Hedge Id which was just printed.
 
     C                   EVAL      WTmpHEDI = OHEDI
 
      ** Increment count of Derivative or Hedged Transaction records
 
     C                   IF        KFSHDIn = 'D'
     C                   EVAL      WDCount = WDCount + 1
     C                   ELSE
     C                   IF        KFSHDIn = 'H'
     C                   EVAL      WHCount = WHCount + 1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDlNo - Deal processing                                      *
      *                                                               *
      *****************************************************************
 
     C     SrDlNo        BEGSR
 
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C                   IF        FSDHIN = 'D'
     C*****FSDLNO        CHAIN     DEALSDGF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDGF                           55                      CLE148
 
     C                   ELSE
 
     C                   IF        FSDHIN = 'H'
 
     C*****FSDLNO        CHAIN     DEALSDCF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDCF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDDF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDDF                           55                      CLE148
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WrkDLN
     C                   EVAL      WrkBKC = BOKC
     C                   EVAL      WrkTYP = DTYP
     C                   EVAL      WrkSTP = DLST
     C                   EVAL      WrkCNU = CNUM
     C                   EVAL      WrkVAL = VDAT
     C                   EVAL      WrkMAT = MDAT
 
     C                   SELECT
 
      ** Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF'
     C                   EVAL      WrkCCY = CCY
     C                   EVAL      WrkPR$ = PCPL
     C     10000000      MULT(H)   INTR          WrkINT
 
      ** Negotiable Assets Purchased
 
     C                   WHEN      RCDFMT = 'DEALSDDF'
     C                   EVAL      WrkCCY = CCY
     C                   EVAL      WrkPR$ = FVAL
     C     10000000      MULT(H)   INTR          WrkINT
 
      ** FRA/IRS Deals
 
     C                   WHEN      RCDFMT = 'DEALSDGF'
     C                   EVAL      WrkCCY = UCUCY
     C                   EVAL      WrkPR$ = UPAMT
 
      ** Fair Value Interest Rate processing
 
     C                   SELECT
 
     C                   WHEN      H1PRTP = 'FV'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   UEINR         WrkINT
     C                   ELSE
     C     10000000      MULT(H)   TEINR         WrkINT
     C                   ENDIF
 
      ** Cash Flow Interest Rate processing
 
     C                   WHEN      H1PRTP = 'CF'
 
     C                   IF        UBRTT = *ZEROS
     C     10000000      MULT(H)   TEINR         WrkINT
     C                   ELSE
     C     10000000      MULT(H)   UEINR         WrkINT
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrLeNo - Loan processing                                      *
      *                                                               *
      *****************************************************************
 
     C     SrLeNo        BEGSR
 
     C     FSDLNO        CHAIN     CLOANCLF                           55
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WrkDLN
     C                   EVAL      WrkBKC = BOKC
     C                   EVAL      WrkTYP = LTYP
     C                   EVAL      WrkSTP = SUTP
     C                   EVAL      WrkCNU = CNUM
     C                   EVAL      WrkVAL = VDAT
     C                   EVAL      WrkMAT = MDAT
     C                   EVAL      WrkCCY = CCY
     C                   EVAL      WrkPR$ = CPAM
 
      ** Calculate the Net Treasury Rate
 
     C                   IF        MARG <> 0
     C                   SUB       MARG          INTR
     C                   ENDIF
 
     C     10000000      MULT(H)   INTR          WrkINT
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrSeNo - Security processing                                  *
      *                                                               *
      *****************************************************************
 
     C     SrSeNo        BEGSR
 
     C     FSFPSE        CHAIN     SECTY                              55
 
     C                   IF        *IN55 = *OFF
 
     C     KeyBkP        CHAIN     SEMKVLL0                           55
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSFPSE        WrkDLN
     C                   EVAL      WrkCnu = ISSR                                              224952
     C                   EVAL      WrkBKC = FSBKCD
     C                   EVAL      WrkSTP = FSBHTV
     C                   EVAL      WrkMAT = MATY
     C                   EVAL      WrkCCY = SECCY
     C**********         EVAL      WrkPR$ = SEBKCT                                            229035
     C                   EVAL      WrkPR$ = SENAMT                                            229035
     C     10000000      MULT(H)   SEMKTP        WrkINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrn3 - Load workfields to print Transaction Report          *
      *                                                               *
      *****************************************************************
 
     C     SrTrn3        BEGSR
 
     C                   MOVEL     FSHEDI        OHEDI
 
     C                   EVAL      ODLNO = WrkDLN
     C                   EVAL      OBKC = WrkBKC
     C                   EVAL      ODTYP = WrkTYP
     C                   EVAL      ODLST = WrkSTP
 
     C                   IF        ODLST <> *BLANKS
     C                   EVAL      ODASH = '-'
     C                   ENDIF
 
     C**********         IF        WrkCNU <> *ZEROS                                           CSD027
     C                   IF        WrkCNU <> *BLANKS                                          CSD027
     C                   MOVEL     WrkCNU        OCNUM
     C                   ENDIF
 
     C                   IF        WrkVAL <> 0
     C                   EVAL      PDate = WrkVAL
     C                   EXSR      SrDate
     C                   EVAL      OVALD = PZaDate
     C                   ENDIF
 
 
     C                   IF        WrkMAT <> 0
     C                   EVAL      PDate = WrkMAT
     C                   EXSR      SrDate
     C                   EVAL      OMATD = PZaDate
     C                   ENDIF
 
     C                   IF        WrkCCY <> *BLANKS
     C                   EXSR      SRCURR
     C                   EVAL      OCCY = WrkCCY
     C                   ENDIF
 
      ** Principal Amount
 
     C                   IF        WrkPR$ <> *ZEROS
 
      ** Consider Derivative or Hedged Percentage
 
     C                   IF        FSPCTG <> *ZEROS
     C                   MULT      FSPCTG        WrkPR$
     C                   DIV(H)    100           WrkPR$
     C                   ENDIF
 
     C                   EVAL      PFld15 = WrkPR$
     C                   EVAL      PDecs = WCdPf
     C                   IF        FSMOD = 'SE'                                               229035
     C                   EVAL      PDecs = NMDP                                               229035
     C                   ENDIF                                                                229035
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVE      POut21        OPRIN
     C                   ENDIF
 
      ** Interest Rate
 
     C                   IF        WrkINT <> *ZEROS
     C                   EVAL      PFld15 = WrkINT
     C                   EVAL      PDecs = 7
     C                   EVAL      PECode = 'L'
     C                   EXSR      SRCvtAmt
 
      ** Strip out negative sign.
 
     C                   EVAL      WFld20 = POut21
     C                   MOVE      WFld20        OINTR
     C                   ENDIF
 
      ** R-Squared
 
     C                   EVAL      PFld15 = WrkRSQ * 10000000
     C                   EVAL      PDecs = 7
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        ORSQR
 
      ** T-Statistic
 
     C                   EVAL      PFld15 = WrkTST * 10000
     C                   EVAL      PDecs = 4
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        OTSTA
 
      ** Slope Coefficient
 
     C                   EVAL      PFld15 = WrkSLC * 1000
     C                   EVAL      PDecs = 3
     C                   EVAL      PECode = 'J'
     C                   EXSR      SRCvtAmt
     C                   MOVE      POut21        OSLCO
 
      ** Degrees of Freedom (n-2)
 
     C                   EVAL      WDf = FSDPTS - 2
 
      ** Alpha
 
     C                   EVAL      WAlpha = (100- FSCLVL)/100
 
      ** Retrieve the T Value from the T Distribution Table.
 
     C                   EVAL      KXXDfrd = WDf
     C                   EVAL      KXXArea = WAlpha / 2
 
     C     KSdtdtb       CHAIN     SDTDTBL0
 
     C                   IF        %FOUND(SDTDTBL0)
 
      ** Critical Value of T retrieve.
 
     C                   IF        XXTVAL <> *ZEROS
     C                   EVAL      PFld15 = XXTVAL * 1000
     C                   EVAL      PDecs = 3
     C                   EVAL      PECode = 'L'
     C                   EXSR      SrCvtAmt
 
      ** Strip out negative sign.
 
     C                   EVAL      WFld20 = POut21
     C                   MOVE      WFld20        OTVAL
     C                   ELSE
     C                   EVAL      OTVAL = '   -----'
     C                   ENDIF
     C                   ELSE
     C                   MOVEL     KXXDfrd       WXXDfrd
     C                   MOVEL     KXXArea       WXXArea
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDTDTBL0'
     C                   EVAL      DBKEY  =  WXXDfrd + WXXArea
     C                   EVAL      DBASE  =  7
     C                   EVAL      DBPROC =  'SR/SrTrn3'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt - Convert Amount before printing                     *
      *                                                               *
      *****************************************************************
 
     C     SRCvtAmt      BEGSR
 
     C                   CALLB     'ZSEDIT'
     C                   PARM                    PFld15
     C                   PARM                    PDecs
     C                   PARM                    PECode
     C                   PARM                    POut21
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCURR - Access currency details                              *
      *                                                               *
      *****************************************************************
 
     C     SRCURR        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WrkCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 8
     C                   EVAL      DBKEY = WrkCCY
     C                   EVAL      DBPGM = 'AS001023P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WCdPf = A6NBDP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrDate - Convert Date to DDMMMYY format                       *
      *                                                               *
      *****************************************************************
 
     C     SrDate        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZaDate
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInL1 - New Hedge Strategy Level Break                       *
      *                                                               *
      *****************************************************************
 
     C     SrInL1        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      WInHeSN = *BLANKS
 
     C                   EXSR      SrVal1
 
      ** Initialize the saved value of the Hedge Id.
 
     C                   EVAL      WTmpHEDI = *BLANKS
 
      ** If Hedge Linkage records to print -first print new headings
 
     C                   IF        *IN77 = *ON
 
     C                   EVAL      WInHeSN = 'Y'
     C                   EVAL      O1HESN = H1HESN
     C                   EVAL      O1HELD = H1HELD
 
     C                   IF        WEffY <> *BLANKS
                                                                                              224985
     C                   IF        WOPEN <> 'Y'                                               224985
     C                   OPEN      AS001023P1                                                 224985
                                                                                              224985
      ** Ensure Report Spool File recorded by RCF.                                            224985
                                                                                              224985
     C                   CALL      'ZSFILE'                                                   224985
     C                   PARM      *BLANKS       PSeq                                         224985
     C                   PARM      H1BRCA        PEnty                                        224985
     C                   PARM                    SFILE1                                       224985
     C                   PARM      SFNUM1        PZSNum                                       224985
     C                   PARM      *BLANKS       PZSErr                                       224985
                                                                                              224985
     C                   IF        PZSErr = 'Y'                                               224985
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
 
     C                   IF        WEffN <> *BLANKS
                                                                                              224985
     C                   IF        WOPEN2 <> 'Y'                                              224985
     C                   OPEN      AS001023P2                                                 224985
                                                                                              224985
      ** Ensure Report Spool File recorded by RCF.                                            224985
                                                                                              224985
     C                   CALL      'ZSFILE'                                                   224985
     C                   PARM      *BLANKS       PSeq                                         224985
     C                   PARM      H1BRCA        PEnty                                        224985
     C                   PARM                    SFILE2                                       224985
     C                   PARM      SFNUM2        PZSNum                                       224985
     C                   PARM      *BLANKS       PZSErr                                       224985
                                                                                              224985
     C                   IF        PZSErr = 'Y'                                               224985
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
      * SrInL2 - New Product Type Level Break                         *
      *                                                               *
      *****************************************************************
 
     C     SrInL2        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Product Type
 
     C                   EVAL      WInPrTP = *BLANKS
 
     C                   EXSR      SrVal1
 
      ** If Hedge Linkage records to print -OK
 
     C                   IF        *IN77 = *ON
     C                   EVAL      WInPrTP = 'Y'
 
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
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrInL3 - New Branch Level Break                               *
      *                                                               *
      *****************************************************************
 
     C     SrInL3        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      WInBrca = *BLANKS
 
     C                   EXSR      SrVal1
 
     C                   IF        *IN77 = *ON
     C                   EVAL      WInBrca = 'Y'
 
     C**********         IF        WEffY <> *BLANKS                                           224985
      **********                                                                              224985
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                       224985
      **********                                                                              224985
     C**********         CALL      'ZSFILE'                                                   224985
     C**********         PARM      *BLANKS       PSeq                                         224985
     C**********         PARM      H1BRCA        PEnty                                        224985
     C**********         PARM                    SFILE1                                       224985
     C**********         PARM      SFNUM1        PZSNum                                       224985
     C**********         PARM      *BLANKS       PZSErr                                       224985
      **********                                                                              224985
     C**********         IF        PZSErr = 'Y'                                               224985
     C**********         EVAL      *INU7 = *ON                                                224985
     C**********         EVAL      *INU8 = *ON                                                224985
     C**********         EVAL      *INLR = *ON                                                224985
     C**********         RETURN                                                               224985
     C**********         ENDIF                                                                224985
     C**********         ENDIF                                                                224985
 
     C**********         IF        WEffN <> *BLANKS                                           224985
      **********                                                                              224985
      ***Ensure*Report*Spool*File*recorded*by*RCF.*********************                       224985
      **********                                                                              224985
     C**********         CALL      'ZSFILE'                                                   224985
     C**********         PARM      *BLANKS       PSeq                                         224985
     C**********         PARM      H1BRCA        PEnty                                        224985
     C**********         PARM                    SFILE2                                       224985
     C**********         PARM      SFNUM2        PZSNum                                       224985
     C**********         PARM      *BLANKS       PZSErr                                       224985
      **********                                                                              224985
     C**********         IF        PZSErr = 'Y'                                               224985
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
     C                   PARM      '*MSG   '     Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      H1BRCA        PBrca
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
      * SrVal1 - Check if Hedge Linkages exist                        *
      *                                                               *
      *****************************************************************
 
     C     SrVal1        BEGSR
 
      ** Save Hedge Strategy fields of a currently read record
 
     C                   EVAL      W@Brca = H1BRCA
     C                   EVAL      W@PrTP = H1PRTP
     C                   EVAL      W@HeSN = H1HESN
 
      ** Initialise indicators
 
     C                   EVAL      *IN77 = *OFF
     C                   EVAL      *IN89 = *OFF
     C                   EVAL      WEffYN = *BLANKS
 
      ** Position and read Hedge Strategy file based on break
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C                             AND WkHEDI = *ZERO
     C     W@Brca        SETLL     SDHGSTD3
     C     W@Brca        READE     SDHGSTD3                               89
 
     C                   WHEN      *IN02 = *ON
     C                             AND WkHEDI = *ZERO
     C     KyPrTp        SETLL     SDHGSTD3
     C     KyPrTp        READE     SDHGSTD3                               89
 
     C                   WHEN      *IN01 = *ON
     C                             AND WkHEDI = *ZERO
     C     KyHeSN        SETLL     SDHGSTD3
     C     KyHeSN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   DOW       *IN89 = *OFF
 
      ** Read Hedge Linkage records
 
     C                   EXSR      SrVal2
 
      ** If at least one effective and one ineffective record exist
      ** - exit reading loop
 
     C                   IF        WEffY <> *BLANKS AND WEffN <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C                   SELECT
     C                   WHEN      *IN03 = *ON
     C                             AND WkHEDI = *ZERO
     C     W@Brca        READE     SDHGSTD3                               89
     C                   WHEN      *IN02 = *ON
     C                             AND WkHEDI = *ZERO
     C     KyPrTp        READE     SDHGSTD3                               89
     C                   WHEN      *IN01 = *ON
     C                             AND WkHEDI = *ZERO
     C     KyHeSN        READE     SDHGSTD3                               89
     C                   ENDSL
 
     C                   ENDDO
 
      ** If either record exists no further checking is necessary
 
     C                   IF        WEffYN <> *BLANKS AND *IN77 = *OFF
     C                   EVAL      *IN77 = *ON
     C                   ENDIF
 
      ** Restore Hedge Strategy fields of a currently read record
 
     C                   EVAL      H1BRCA = W@Brca
     C                   EVAL      H1PRTP = W@PrTP
     C                   EVAL      H1HESN = W@HeSN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrVal2 - Search for live Hedge Linkage records                *
      *                                                               *
      *****************************************************************
 
     C     SrVal2        BEGSR
 
      ** Initialise indicators
 
     C                   EVAL      *IN87 = *OFF
 
      ** Read Hedge Strategy's Hedge Linkage records in search of a live
      ** one
 
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If qualifying Hedge Linkage records found
 
     C                   IF        FSRECI = 'D'
     C                             AND H1MEFF = 'R'                                           224985
     C                   IF        FSDPTR < FSDPTS                                            224985
     C                   EVAL      WEffN = 'Y'                                                224985
     C                   ELSE                                                                 224985
     C                   EVAL      WEffY = 'Y'
     C                   ENDIF                                                                224985
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                             AND H1MEFF = 'R'                                           224985
     C                   EVAL      WEffN = 'Y'
     C                   ENDIF
     C                   ENDIF
 
 
      ** If at least one effective and one ineffective record exist
      ** - exit reading loop
 
     C                   IF        WEffY <> *BLANKS AND WEffN <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrETot - Effective Hedge Linkage Totals                       *
      *                                                               *
      *****************************************************************
 
     C     SrETot        BEGSR
 
      ** Print blank line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print dotted line
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     DOTTED1
 
      ** Increment count of effective hedges
 
     C                   EVAL      ECOUNT = ECOUNT + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrITot - Ineffective Hedge Linkage Totals                     *
      *                                                               *
      *****************************************************************
 
     C     SrITot        BEGSR
 
      ** Print blank line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print dotted line
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     DOTTED2
 
      ** Increment count of ineffective hedges
 
     C                   EVAL      ICOUNT = ICOUNT + 1
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SrTrail  - Print trailer.                                     *
      *                                                               *
      *****************************************************************
 
     C     SrTrail       BEGSR
 
      ** Print blank line  - Effective
 
     C                   IF        WOPEN = 'Y'                                                224985
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK1
     C                   ENDIF                                                                224985
 
      ** Print blank line  - Ineffective
 
     C                   IF        WOPEN2 = 'Y'                                               224985
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
     C                   ENDIF                                                                224985
 
      ** Print Trailer - Effective
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   IF        WDetail1Ctr <> 0
     C                   WRITE     TRAILP1
     C                   EVAL      WTrail = *BLANKS
     C                   ENDIF
 
      ** Print Trailer - Ineffective
 
     C                   IF        *IN44 = *ON
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   IF        WDetail2Ctr <> 0
     C                   WRITE     TRAILP2
     C                   EVAL      WTrail = *BLANKS
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAudit - Subroutine to Output Audit report and End Program. *
      *                                                               *
      *****************************************************************
 
     C     SrAudit       BEGSR
 
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
      *  Sr3Print - Extract the 3 factors for hedge assessment.       *
      *                                                               *
      *****************************************************************
 
     C     Sr3Print      BEGSR
 
     C                   MOVEL     FSRSQR        WrkRSQ
     C                   MOVEL     FSTSTA        WrkTST
     C                   MOVEL     FSSLCO        WrkSLC
 
     C                   EVAL      KFSHedi = FSHEDI
     C                   EVAL      KFSHDIn = 'D'
     C     KyTran        CHAIN     ASHTRND1
 
      ** For now, we only use 'RS', 'RX' AND 'FR' as hedge derivatives.
 
     C                   EVAL      KDerivHEDI = FSHEDI
     C                   EVAL      KDerivDLNO = FSDLNO
     C                   EVAL      WDerivPCTG = FSPCTG / 100
 
      ** Hedged Item
 
     C                   EVAL      KFSHedi = FSHEDI
     C                   EVAL      KFSHDIn = 'H'
     C     KyTran        CHAIN     ASHTRND1
 
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL' OR FSMOD = 'LE'
 
     C                   EVAL      KHedgdHEDI = FSHEDI
     C                   EVAL      KHedgdDLNO = FSDLNO
     C                   EVAL      WHedgdPCTG = FSPCTG / 100
 
     C                   WHEN      FSMOD = 'SE'
 
     C                   EVAL      KHedgdHEDI = FSHEDI
     C                   EVAL      KHedgdSESN = FSFPSE
     C                   EVAL      KHedgdBRCA = FSBRCA
     C                   EVAL      KHedgdBKCD = FSBKCD
     C                   EVAL      KHedgdMKTI = FSMKTI
     C                   EVAL      KHedgdBHTV = FSBHTV
     C                   EVAL      WHedgdPCTG = FSPCTG / 100
 
     C                   ENDSL
 
     C                   EVAL      *IN11 = *OFF
     C                   IF        FSDPTR < FSDPTS
     C                   EVAL      WEffFlg = 'I'
     C                   EVAL      *IN11   = *ON
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
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBPGM = 'AS001023P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
      **  Read Midas SD Hedging ICD File Retrieval
 
     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST '     POptn
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
 
      ** Database error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBASE  =  2
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call access program for General Ledger details
 
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     Prtcd
     C                   PARM      '*FIRST '     POptn
     C     SDGELR        PARM      SDGELR        DSSDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = POptn
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WEvCtlDt = BJDNWD - 1
     C                   IF        BKAPDT < WEvCtlDt
     C                   EVAL      WEvCtlDt = BKAPDT
     C                   ENDIF
     C                   EVAL      PDate = WEvCtlDt
     C                   EXSR      SrDate
     C                   EVAL      OEVCD1 = PZaDate
     C                   EVAL      OEVCD2 = PZaDate
     C                   EVAL      OEVCD3 = PZaDate
     C                   EVAL      WOPEN = 'N'                                                224985
     C                   EVAL      WOPEN2 = 'N'                                               224985
 
      ** Key list for Revalued Securities Positions
 
     C     KeyBkP        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    H1BRCA
     C                   KFLD                    FSBKCD
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
 
      ** Product Type Key List
 
     C     KyPrTp        KLIST
     C                   KFLD                    W@Brca
     C                   KFLD                    W@PrTP
 
      ** Strategy Key List
 
     C     KyHeSN        KLIST
     C                   KFLD                    W@Brca
     C                   KFLD                    W@PrTP
     C                   KFLD                    W@HeSN
 
      ** Linkage Key List
 
     C     KyTran        KLIST
     C                   KFLD                    KFSHedi
     C                   KFLD                    KFSHDIn
 
      ** Key List for Midas SD T Distribution Table File
 
     C     KSdtdtb       KLIST
     C                   KFLD                    KXXDfrd
     C                   KFLD                    KXXArea
 
      ** Key List for idas AS SE Historic Mrkt Dta by Sec Posit/ValueDt
 
     C     KAssehm2      KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KHedgdSESN
     C                   KFLD                    KHedgdBRCA
     C                   KFLD                    KHedgdBKCD
     C                   KFLD                    KHedgdMKTI
     C                   KFLD                    KHedgdBHTV
     C**********         KFLD                    KVdat                                        224952
 
      ** Key List for Midas AS DL Historic Mrkt Dta by Hedge Id/Deal No/
      ** Value Date and Midas AS LE Historic Mrkt Dta by Hedge Id/Loan No/
      ** Value Date - Hedged Item
 
     C     KHedgdHMD2    KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KDrvtvDLNO
     C                   KFLD                    KVdat
 
     C     KHedgdHMD3    KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KDrvtvDLNO
 
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          BJMRDT
 
      ** Check multibranch function
 
     C     MBIN          IFEQ      'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C                   PARM      *BLANKS       PEnty
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        PZSNumU
     C                   PARM      *BLANK        PZSErr
 
      ** Retrieve Base Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 4
     C                   EVAL      DBKEY = BJCYCD
     C                   EVAL      DBPGM = 'AS001023P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   EXSR      SrAudit
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrHMDD - Subroutine to print Historic Market Detail          *
      *                                                               *
      *****************************************************************
 
     C     SrHMDD        BEGSR
 
     C                   EVAL      PECode = 'J'
     C                   MOVEL     ODLNO         KDrvtvDLNO
 
     C**********         IF        WDrvtvInd = 'Y'                                            224952
     C                   IF        FSDHIN = 'D'                                               224952
 
      ** Historic Market Data - Hedge Derivative
      ** =======================================
 
     C                   EVAL      WDataCount = *ZERO
 
     C     KHedgdHMD3    SETLL     ASDLHML3
     C     KHedgdHMD3    READE     ASDLHML3
 
     C                   DOW       NOT %EOF(ASDLHML3) AND
     C                             FSDPTS > WDataCount
 
      ** Initialise report detail output fields
 
     C                   EVAL      RVDAT = *BLANKS
     C                   EVAL      RDMTV = *BLANKS
 
      ** Value Date
 
     C                   EVAL      PDate = D3VDAT
     C                   EXSR      SRDate
     C                   EVALR     RVDAT = PZADate
 
      ** Historic Market Data - Hedge Derivative
 
     C                   EVAL      PDecs = A6NBDP
     C                   Z-ADD     *ZERO         PFld15
 
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      D3MVAL        PFld15
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      D3MVCA        PFld15
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      D3MRAT        PFld15
     C                   EVAL      PDecs = 8
     C                   ENDSL
 
     C                   EXSR      SRCvtAmt
     C                   EVALR     RDMTV = POut21
 
      ** If overflow detected, white header
 
     C                   IF        *IN66 = *ON OR *IN44 = *ON
     C                   IF        WDet1 = 'Y'
     C                   WRITE     HEADR1
     C                   WRITE     DETAIL1H
     C                   WRITE     DETAIL1
     C                   ELSE
     C                   WRITE     HEADR2
     C                   WRITE     DETAIL2H
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   EVAL      *IN66 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
 
      ** Print Detail
 
     C                   IF        WDet1 = 'Y'
     C                   WRITE     DETAIL1A
     C                   ELSE
     C                   WRITE     DETAIL2A
     C                   ENDIF
 
     C                   EVAL      WDataCount = WDataCount + 1
 
     C     KHedgdHMD3    READE     ASDLHML3
     C                   ENDDO
 
     C**********         EVAL      WDrvtvInd = 'N'                                            224952
 
     C                   ELSE
 
      ** Hedge Item
      ** ==========
 
     C                   EVAL      WDataCount = *ZERO
 
     C                   SELECT                                                               224952
     C                   WHEN      FSMOD = 'DL'                                               224952
     C     KHedgdHMD3    SETLL     ASDLHML3
     C     KHedgdHMD3    READE     ASDLHML3
     C                   WHEN      FSMOD = 'LE'                                               224952
     C     KHedgdHMD3    SETLL     ASLEHML2                                                   224952
     C     KHedgdHMD3    READE     ASLEHML2                                                   224952
     C                   WHEN      FSMOD = 'SE'                                               224952
     C     KAssehm2      SETLL     ASSEHML0                                                   224952
     C     KAssehm2      READE     ASSEHML0                                                   224952
     C                   ENDSL                                                                224952
 
     C                   DOW       NOT %EOF(ASDLHML3) AND
     C                             FSDPTS > WDataCount
     C                             AND FSMOD = 'DL'                                           224952
     C                             OR NOT %EOF(ASLEHML2) AND                                  224952
     C                             FSDPTS > WDataCount AND                                    224952
     C                             FSMOD = 'LE'                                               224952
     C                             OR NOT %EOF(ASSEHML0) AND                                  224952
     C                             FSDPTS > WDataCount AND                                    224952
     C                             FSMOD = 'SE'                                               224952
 
      ** Initialise report detail output fields
 
     C                   EVAL      RVDAT = *BLANKS
     C                   EVAL      RHMTV = *BLANKS
 
      ** Value Date
 
     C                   SELECT                                                               224952
     C                   WHEN      FSMOD = 'DL'                                               224952
     C                   EVAL      PDate = D3VDAT
     C                   WHEN      FSMOD = 'LE'                                               224952
     C                   EVAL      PDate = LEVDAT                                             224952
     C                   WHEN      FSMOD = 'SE'                                               224952
     C                   EVAL      PDate = SCVDAT                                             224952
     C                   ENDSL                                                                224952
     C                   EXSR      SRDate
     C                   EVALR     RVDAT = PZADate
 
      ** Historic Market Data - Hedged Item
 
     C**********         EVAL      KVdat = D3VDAT                                             224952
 
     C**********         SELECT                                                               224952
     C**********         WHEN      FSMOD = 'DL'                                               224952
     C*****KHedgdHMD2    CHAIN     ASDLHML2                                                   224952
     C**********         WHEN      FSMOD = 'LE'                                               224952
     C*****KHedgdHMD2    CHAIN     ASLEHML2                                                   224952
     C**********         WHEN      FSMOD = 'SE'                                               224952
     C*****KAssehm2      CHAIN     ASSEHML0                                                   224952
     C**********         ENDSL                                                                224952
 
     C**********         IF        %FOUND (ASDLHML2) AND FSMOD = 'DL' OR                      224952
     C**********                   %FOUND (ASLEHML2) AND FSMOD = 'LE' OR                      224952
     C**********                   %FOUND (ASSEHML0) AND FSMOD = 'SE'                         224952
 
     C                   EVAL      PDecs = A6NBDP
     C                   Z-ADD     *ZERO         PFld15
 
     C                   SELECT                                                               224952
     C                   WHEN      FSMOD = 'DL'                                               224952
     C                   EVAL      WMVAL = D3MVAL                                             224952
     C                   EVAL      WMVCA = D3MVCA                                             224952
     C                   EVAL      WMRAT = D3MRAT                                             224952
     C                   WHEN      FSMOD = 'LE'                                               224952
     C                   EVAL      WMVAL = LEMVAL                                             224952
     C                   EVAL      WMVCA = LEMVCA                                             224952
     C                   EVAL      WMRAT = LEMRAT                                             224952
     C                   WHEN      FSMOD = 'SE'                                               224952
     C                   EVAL      WMVAL = SCMVAL                                             224952
     C                   EVAL      WMVCA = SCMVCA                                             224952
     C                   EVAL      WMRAT = SCMRAT                                             224952
     C                   ENDSL                                                                224952
                                                                                              224952
     C                   SELECT
     C                   WHEN      FSDTTP = 'V'
     C**********         MOVE      D3MVAL        PFld15                                       224952
     C                   MOVE      WMVAL         PFld15                                       224952
     C                   WHEN      FSDTTP = 'C'
     C**********         MOVE      D3MVCA        PFld15                                       224952
     C                   MOVE      WMVCA         PFld15                                       224952
     C                   WHEN      FSDTTP = 'R'
     C**********         MOVE      D3MRAT        PFld15                                       224952
     C                   MOVE      WMRAT         PFld15                                       224952
     C                   EVAL      PDecs = 8
     C                   ENDSL
 
     C                   EXSR      SRCvtAmt
     C                   EVALR     RHMTV = POut21
 
      ** If overflow detected, white header
 
     C                   IF        *IN66 = *ON OR *IN44 = *ON
     C                   IF        WDet1 = 'Y'
     C                   WRITE     HEADR1
     C                   WRITE     DETAIL1H
     C                   WRITE     DETAIL1
     C                   ELSE
     C                   WRITE     HEADR2
     C                   WRITE     DETAIL2H
     C                   WRITE     DETAIL2
     C                   ENDIF
     C                   EVAL      *IN66 = *OFF
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
 
      ** Print Detail
 
     C                   IF        WDet1 = 'Y'
     C                   WRITE     DETAIL1B
     C                   ELSE
     C                   WRITE     DETAIL2B
     C                   ENDIF
 
     C**********         ENDIF                                                                224952
 
     C                   EVAL      WDataCount = WDataCount + 1
 
     C                   SELECT                                                               224952
     C                   WHEN      FSMOD = 'DL'                                               224952
     C     KHedgdHMD3    READE     ASDLHML3
     C                   WHEN      FSMOD = 'LE'                                               224952
     C     KHedgdHMD3    READE     ASLEHML2                                                   224952
     C                   WHEN      FSMOD = 'SE'                                               224952
     C     KAssehm2      READE     ASSEHML0                                                   224952
     C                   ENDSL                                                                224952
 
     C                   ENDDO
 
     C**********         EVAL      WDrvtvInd = 'Y'                                            224952
 
     C                   ENDIF
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
**   MON/NUM Month Short Name and Number
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
** Product Types
FV
FX
CF
