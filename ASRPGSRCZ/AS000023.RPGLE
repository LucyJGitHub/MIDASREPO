     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Regression Analysis I/C Program')             *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standards Module                          *
      *                                                               *
      *  AS000023 - Midas AS Regression Analysis I/C program          *
      *                                                               *
      *  Function:  This module will assess each linkage with         *
      *             assessment method equal to 'R'.  It will          *
      *             calculate and report the 3 factors for the hedge  *
      *             asssessment using Regression Method.              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
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
      *                 CAS010             Date 09Feb05               *
      *                 228948             Date 27Sep04               *
      *                 229035             Date 16Aug04               *
      *                 225949             Date 30Mar04               *
      *                 224985             Date 18Feb04               *
      *                 224952             Date 11Feb04               *
      *                 CDL028             Date 07Feb05               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006  *CREATE    Date 21Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      *  CAS010 - IAS + PB Enhancements Upgrade to Midasplus          *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229035 - The principal amount in SE module is the nominal    *
      *           amount.                                             *
      *  225949 - User can now choose to print hedge linkages for a   *
      *           certain branch.                                     *
      *  224985 - Report is showing additional headers/footers for    *
      *           'No Details to Report'                              *
      *  224952 - Show Historic Market Details for Hedged Items       *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *  01  -   Strategy Level Break                                 *
      *  02  -   Product Type Level Break                             *
      *  03  -   Branch Level Break                                   *
      *  11  -   Insufficient Data to be regressed.                   *
      *  12  -   EOF SDHGSTL2                                         *
      *  13  -   No significant change in Historic Market Data        *
      *  25  -   FV Product Type                                      *
      *  26  -   CF Product Type                                      *
      *  37  -   Multibranch Active                                   *
      *  55  -   Record Found Indicator                               *
      *  66  -   Overflow                                             *
      *  77  -   Qualified Hedge Linkage Found Indicator              *
      *  87  -   End of File Indicator                                *
      *  89  -   End of File Indicator                                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrOneLnkge  - Analyze one linkage in the system.             *
      *  SrAllLnkge  - Process all linkages in the system.            *
      *  SrProcess   - Process Records                                *
      *  SrLnk1      - Hedge Linkage Processing Main                  *
      *  SrLnk2      - Hedge Linkage Processing Subordinated          *
      *  SrTrn1      - Hedge Transaction Processing                   *
      *  SrTrn2      - Move data to workfields and print Trans Report *
      *  SrDlNo      - Deal processing                                *
      *  SrLeNo      - Loan processing                                *
      *  SrSeNo      - Security processing                            *
      *  SrTrn3      - Load workfields to print Transaction Report    *
      *  SrCvtAmt    - Convert Amount before printing                 *
      *  SrCurr      - Access currency details                        *
      *  SrDate      - Convert Date to DDMMMYY format                 *
      *  SrInL1      - New Hedge Strategy Level Break                 *
      *  SrInL2      - New Product Type Level Break                   *
      *  SrInL3      - New Branch Level Break                         *
      *  SrVal1      - Check if Hedge Linkages exist                  *
      *  SrVal2      - Search for live Hedge Linkage records          *
      *  SrNxLk      - Next Hedge Linkage                             *
      *  SrTrail     - Print trailer.                                 *
      *  SrAudit     - Subroutine to Output Audit report and End Pgm  *
      *  Sr3Factor   - Calculate the 3 factors for hedge assessment.  *
      *  SrSummat    - Summation of Data from Historic Data File      *
      *  SrNotaSum   - Compute for Notations based on the Sums of     *
      *                Squares                                        *
      *  SrRegAsse   - Assess Linkages using the Regression Analysis  *
      *                                                               *
      *  *PSSR       - Error processing                               *
      *  *INZSR      - Initialise                                     *
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
 
     FSDHGSTL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD1)
     F                                     PREFIX(H1:2)
      ** RTV : Hedge Strategy By Short-name
 
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
      ** RTV : Hedge Strategy By Branch, Product Type and Hedge Short-name
 
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD3)
     F                                     PREFIX(H1:2)
      ** RTV : Hedge Strategy By Branch, Product Type and Hedge Short-name
 
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHGLKD0:ASHGLKD1)
      ** Midas AS Hedge Linkage File Retrieval by Hedge ID
 
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
      ** RTV : Hedge Linkage Retrieval By Hedge Strategy and Hedge ID
 
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
      ** Live : Hedge Transactions By Hedge ID and Der/Hed Ind
 
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
      ** Live : Hedge Transactions By Hedge ID and Der/Hed Ind
     F                                     RENAME(ASHTRND0:ASHTRND1)
 
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)
      ** RTV:  Revalued Securities Positions
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      ** RTV:  Midas SE Book Position Headers
 
     FBKPOS     IF   E           K DISK    INFSR(*PSSR)
      ** RTV:  Midas SE Book Position Details
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDBF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      ** RTV: Deals Files
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** RTV: Loans
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** RTV: Security File
 
     FAS000023P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
     F                                     USROPN                                             224985
      ** PRT: Printer file for Effective Hedges (Transaction Detail)
 
     FAS000023AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
      ** PRT: Printer file for Hedge Effectiveness(Audit)
 
     FASDLHML2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D2:2)
      ** Midas AS Dealing Historic Market Data File
      ** by Deal number and Value date - LIVE
 
     FASDLHML3  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(D3:2)
     F                                     RENAME(ASDLHMD0:ASDLHMD3)
      ** Midas AS Dealing Historic Market Data File
      ** by Deal number and Value date - LIVE
 
     FASSEHML0  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(SC:2)
      ** Midas AS Securities Historic Market Data File
      ** by Security shortname and Value date - LIVE
 
     FASLEHML2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(LE:2)
      ** Midas AS Lending Historic Market Data File
      ** by Loan number and value date - LIVE
 
     FSDTDTBL0  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD T Distribution Table File Retrieval
 
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
 
      ** Record Format
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** Today's Date
     D RUNDAT          DS
     D  MRDT                   1      7
     D  RDNB                   8     10P 0
     D  MBIN                  13     13
 
      ** File Information Data Structure for AS000023P1
     D SPOOL1          DS
     D  SFILE1                83     92
     D  SFNUM1               123    124B 0
     D  OFLLN1               188    189B 0
     D  PRTLN1               367    368B 0
 
      ** File Information Data Structure for AS000023AU
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
 
      ** Work Indicators
     D WLVInd          DS
     D  WLVInd3                1      1
     D  WLVInd2                2      2
     D  WLVInd1                3      3
 
      ** Entry Parameters List
     D PEntry          S              6A
     D PLevel          S              1A
 
      ** Parameters for Access Objects
     D Prtcd           S              7
     D POptn           S              7
     D PBrca           S              3
 
     D WEvCtlDt        S              5P 0
 
      ** Details Fields
     D WrkDLN          S             10
     D WrkBKC          S              2
     D WrkTYP          S              2
     D WrkSTP          S              2
     D*WrkCNU***       S              6  0                                                    CSD027
     D WrkCNU          S              6                                                       CSD027
     D WrkVAL          S              5  0
     D WrkMAT          S              5  0
     D WrkCCY          S              3
     D WrkPR$          S             13  0
     D WrkINT          S             11  0
     D WrkRSQ          S              9  7
     D WrkTST          S             16  4
     D WrkSLC          S             15  3
 
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
     D WBRCA           S              3                                                       225949
     D WFld20          S             20
 
      ** Fields used to define Key List for Midas DL Forward Commitment File
     D KXXDfrd         S                   LIKE(XXDfrd)
     D KXXArea         S                   LIKE(XXArea)
 
     D WkHEDI          S              6  0
     D KDerivHEDI      S                   LIKE(FSHEDI)
     D KDerivDLNO      S                   LIKE(FSDLNO)
     D KHedgdHEDI      S                   LIKE(FSHEDI)
     D KHedgdDLNO      S                   LIKE(FSDLNO)
     D KDrvtvDLNO      S                   LIKE(FSDLNO)
     D KHedgdSESN      S                   LIKE(FSFPSE)
     D KHedgdBRCA      S                   LIKE(FSBRCA)
     D KHedgdBKCD      S                   LIKE(FSBKCD)
     D KHedgdMKTI      S                   LIKE(FSMKTI)
     D KHedgdBHTV      S                   LIKE(FSBHTV)
     D WDf             S                   LIKE(XXDFRD)
     D WAlpha          S                   LIKE(XXAREA)
     D WCounter        S                   LIKE(FSDPTS)
     D WDataCount      S              4  0
     D WDerivHMDRead   S              1A
     D WHedgdHMDRead   S              1A
     D WDerivHMD       S             12  0
     D WHedgdHMD       S             12  0
     D WD2Mval12       S             12S 0
     D WD2Mvca12       S             12S 0
     D WD2Mrat12       S             12S 8
     D WD3Mval12       S             12S 0
     D WD3Mvca12       S             12S 0
     D WD3Mrat12       S             12S 8
     D WLEMval12       S             12S 0
     D WLEMvca12       S             12S 0
     D WLEMrat12       S             12S 8
     D WSCMval12       S             12S 0
     D WSCMvca12       S             12S 0
     D WSCMrat12       S             12S 8
     D WSSE            S             30  3
     D WSUMX           S             15  0
     D WSumXSqrd       S             27  0
     D WWxx            S             30  3
     D WSUMXY          S             27  0
     D WWxy            S             30  3
     D WSUMY           S             15  0
     D WSumYSqrd       S             27  0
     D WWyy            S             30  3
     D WSxx            S             30  3
     D WSxy            S             30  3
     D WSyy            S             30  3
     D WWse            S             30 10
     D WTsNum          S             30  8
     D WTsDen          S             30  8
     D WTsDen1         S             30  8
     D WTsDen2         S             30  8
     D WHedgdPCTG      S              5  4
     D WDerivPCTG      S              5  4
     D WXXDfrd         S              3A
     D WXXArea         S              5A
     D WRecExist       S              1A
     D WTrail          S              1A
     D***WDrvtvInd       S              1A   INZ('Y')                                         224952
     D KVdat           S                   LIKE(D3VDAT)
     D WOPEN           S              1                                                       224985
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
     C                   IF        WkHEDI <> *ZEROS
 
      ** Analyze just one linkage.
 
     C                   EXSR      SrOneLnkge
 
     C                   ELSE
                                                                                              225949
      ** Analyze all linkages in one branch                                                   225949
     C                   IF        PEnty  <> *BLANKS                                          225949
     C                   EXSR      SrOneBrnch                                                 225949
     C                   ELSE                                                                 225949
 
      ** Analyze all the linkages in the system.
 
     C                   EXSR      SrAllLnkge
 
     C                   ENDIF
                                                                                              225949
     C                   ENDIF                                                                225949
 
     C                   EVAL      *INLR = *ON
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrOneLnkge - Analyze one linkage in the system.              *
      *                                                               *
      *****************************************************************
 
     C     SrOneLnkge    BEGSR
 
     C     WkHEDI        CHAIN     ASHGLKL1
     C     FSHGST        CHAIN     SDHGSTD1
 
     C                   IF        H1MEFF = 'R'
     C                             AND FSRECI = 'D'
 
     C                   EVAL      WLVInd = 'YYY'
     C                   EVAL      WInBrca = 'Y'
     C                   EVAL      *IN37 = *OFF
     C                   EVAL      *IN66 = *ON
 
      ** Compute for the three factor for Regression Analysis.
 
     C                   EVAL      WrkRSQ = *ZEROS
     C                   EVAL      WrkTST = *ZEROS
     C                   EVAL      WrkSLC = *ZEROS
     C                   EXSR      SR3Factor
 
      ** Product Type
 
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN25 = *OFF
 
     C                   SELECT
     C                   WHEN      H1PRTP = 'FV'
     C                   EVAL      *IN25 = *ON
     C                   WHEN      H1PRTP = 'CF'
     C                   EVAL      *IN26 = *ON
     C                   ENDSL
 
     C                   MOVEL     WkHEDI        OHEDI
     C                   EVAL      O1HESN = H1HESN
     C                   EVAL      WPrint = 'Y'
     C                   EXSR      SrLnk2
 
      ** Print Trailer
 
     C                   IF        WTrail = 'Y'                                               224985
     C                   EXSR      SrTrail
     C                   ENDIF                                                                224985
 
     C                   ELSE
 
      ** Database Error
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'ASHGLKPD'
     C                   EVAL      DBKEY = WrkCCY
     C                   EVAL      DBASE = 4
     C                   EVAL      DBPROC =  'SR/SrOneLnkge'
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAllLnkge - Process all linkages in the system.             *
      *                                                               *
      *****************************************************************
 
     C     SrAllLnkge    BEGSR
 
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
     C                   ENDIF
 
     C                   EXSR      SrProcess
 
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
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************                       225949
      *                                                               *                       225949
      *  SrOneBrnch - Process all linkages in one branch.             *                       225949
      *                                                               *                       225949
      *****************************************************************                       225949
                                                                                              225949
     C     SrOneBrnch    BEGSR                                                                225949
                                                                                              225949
     C**********         CALL      'AOBRCHR0'                                          225949 CAS010
     C                   CALL      'AOBRCHR1'                                                 CAS010
     C                   PARM      *BLANKS       Prtcd                                        225949
     C                   PARM      '*KEY   '     POptn                                        225949
     C                   PARM      PEnty         PBrca                                        225949
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        225949
                                                                                              225949
      ** Database Error                                                                       225949
                                                                                              225949
     C                   IF        Prtcd <> *BLANKS                                           225949
     C     *LOCK         IN        LDA                                                        225949
     C                   EVAL      DBFILE = 'SDBRCHPD'                                        225949
     C                   EVAL      DBKEY = PBrca                                              225949
     C                   EVAL      DBASE = 8                                                  225949
     C                   EVAL      DBPROC =  'SR/SrOneBrnch'                                  225949
     C                   OUT       LDA                                                        225949
     C                   EXSR      *PSSR                                                      225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   EVAL      WBRCA  = A8BRCD                                            225949
                                                                                              225949
     C     WBRCA         SETLL     SDHGSTL2                                                   225949
     C     WBRCA         READE     SDHGSTL2                               14                  225949
                                                                                              225949
     C                   IF        *IN14 = *ON                                                225949
     C                   EXSR      SrAudit                                                    225949
     C                   ELSE                                                                 225949
                                                                                              225949
      ** Records exist                                                                        225949
     C                   EVAL      *IN03 = *ON                                                225949
     C                   EXSR      SrInL3                                                     225949
     C                   EVAL      *IN03 = *OFF                                               225949
                                                                                              225949
     C                   EVAL      W@PrTP = *BLANKS                                           225949
     C                   EVAL      W@HeSN = *BLANKS                                           225949
                                                                                              225949
      ** Do while not End of file                                                             225949
                                                                                              225949
     C                   DOW       *IN14 = *OFF                                               225949
                                                                                              225949
     C                   IF        *IN14 = *OFF                                               225949
     C                             AND H1MEFF =  'R'                                          225949
                                                                                              225949
     C                   SELECT                                                               225949
                                                                                              225949
     C                   WHEN      W@PrTP <> H1PRTP                                           225949
     C                   EVAL      WLVInd = 'NYY'                                             225949
                                                                                              225949
     C                   WHEN      W@HeSN <> H1HESN                                           225949
     C                   EVAL      WLVInd = 'NNY'                                             225949
     C                   ENDSL                                                                225949
                                                                                              225949
     C                   EXSR      SrProcess                                                  225949
                                                                                              225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C     WBRCA         READE     SDHGSTL2                               14                  225949
                                                                                              225949
     C                   ENDDO                                                                225949
                                                                                              225949
     C                   IF        WTrail = 'Y'                                               225949
     C                   EXSR      SrTrail                                                    225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   EXSR      SrAudit                                                    225949
                                                                                              225949
     C                   ENDIF                                                                225949
                                                                                              225949
     C                   ENDSR                                                                225949
                                                                                              225949
      *****************************************************************                       225949
      /EJECT                                                                                  225949
      *****************************************************************
      *                                                               *
      *  SrProcess - Process Records                                  *
      *                                                               *
      *****************************************************************
 
     C     SrProcess     BEGSR
 
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
      *  SrLnk1 - Hedge Linkage Processing Main                       *
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
 
      ** Compute for the three factor for Regression Analysis.
 
     C                   EVAL      WrkRSQ = *ZEROS
     C                   EVAL      WrkTST = *ZEROS
     C                   EVAL      WrkSLC = *ZEROS
     C                   EXSR      SR3Factor
 
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
 
     C                   EXSR      SrNxLk
     C                   ENDIF
 
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               89
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrLnk2 - Hedge Linkage Processing Subordinated               *
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
      *  SrTrn1 - Hedge Transaction Processing                        *
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
      *  SrTrn2 - Move data to workfields and print Transaction Report*
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
 
     C                   CLEAR                   DETAIL1
 
      ** Load printer file fields
 
     C                   EXSR      SrTrn3
 
      ** Print Hedge Transaction details
 
      ** Check if printing new Hedge ID, if so, print heading.
 
     C                   IF        OHEDI <> WTmpHEDI
                                                                                              224985
     C                   IF        WOPEN <> 'Y'                                               224985
     C                   OPEN      AS000023P1                                                 224985
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
     C                   EXSR      SRHMDD
     C                   EVAL      WTrail = 'Y'
 
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
      *  SrHMDD - Subroutine to print Historic Market Detail          *
      *                                                               *
      *****************************************************************
 
     C     SrHMDD        BEGSR
 
     C                   MOVEL     ODLNO         KDrvtvDLNO
     C                   EVAL      PECode = 'L'
 
     C**********         IF        WDrvtvInd = 'Y'                                            224952
     C                   IF        FSDHIN = 'D'                                               224952
 
      ** Historic Market Data - Hedge Derivative
      ** =======================================
 
     C                   EVAL      WDataCount = *ZERO
 
     C     KHedgdHMD3    SETLL     ASDLHML3
     C     KHedgdHMD3    READE     ASDLHML3
 
     C                   DOW       NOT %EOF(ASDLHML3) AND
     C                             WCounter > WDataCount
 
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
 
     C                   EXSR      SrCvtAmt
     C                   EVALR     RDMTV = POut21
 
      ** If overflow detected, white header
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   WRITE     DETAIL1H
     C                   WRITE     DETAIL1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
      ** Print Detail
 
     C                   WRITE     DETAIL2
 
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
     C                             WCounter > WDataCount
     C                             AND FSMOD = 'DL'                                           224952
     C                             OR NOT %EOF(ASLEHML2) AND                                  224952
     C                             WCounter > WDataCount AND                                  224952
     C                             FSMOD = 'LE'                                               224952
     C                             OR NOT %EOF(ASSEHML0) AND                                  224952
     C                             WCounter > WDataCount AND                                  224952
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
 
     C                   EXSR      SrCvtAmt
     C                   EVALR     RHMTV = POut21
 
      ** If overflow detected, white header
 
     C                   IF        *IN66 = *ON
     C                   WRITE     HEADR1
     C                   WRITE     DETAIL1H
     C                   WRITE     DETAIL1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
      ** Print Detail
 
     C                   WRITE     DETAIL3
 
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
      *                                                               *
      *  SrDlNo - Deal processing                                     *
      *                                                               *
      *****************************************************************
 
     C     SrDlNo        BEGSR
 
     C                   IF        FSDHIN = 'D'
     C*****FSDLNO        CHAIN     DEALSDGF                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALSDGF                           55                      CLE148
 
     C                   ELSE
 
     C                   IF        FSDHIN = 'H'
 
     C*****FSDLNO        CHAIN     DEALSDCF                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALSDCF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDDF                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
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
 
      **  Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF'
     C                   EVAL      WrkCCY = CCY
     C                   EVAL      WrkPR$ = PCPL
     C     10000000      MULT(H)   INTR          WrkINT
 
      **  Negotiable Assets Purchased
 
     C                   WHEN      RCDFMT = 'DEALSDDF'
     C                   EVAL      WrkCCY = CCY
     C                   EVAL      WrkPR$ = FVAL
     C     10000000      MULT(H)   INTR          WrkINT
 
      **  FRA/IRS Deals
 
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
      *  SrLeNo - Loan processing                                     *
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
      *  SrSeNo - Security processing                                 *
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
 
     C                   ELSE
 
     C     KeyBkP        CHAIN     BKPHD                              55
 
     C                   IF        *IN55 = *OFF
     C                   MOVEL     BHSC          WrkDLN
     C                   EVAL      WrkBKC = BHBK
     C                   EVAL      WrkSTP = BHTV
     C                   EVAL      WrkMAT = MATY
     C                   EVAL      WrkCCY = NMCY
     C     KeyBkP        CHAIN     BKPOS                              55
     C**********         EVAL      WrkPR$ = APNC                                              229035
     C                   EVAL      WrkPR$ = NPSN                                              229035
     C     10000000      MULT(H)   0             WrkINT
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrn3 - Load workfields to print Transaction Report         *
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
     C                   EXSR      SrCurr
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
     C                   EXSR      SrCvtAmt
 
      ** Retain negative sign '-' in position 21.
 
     C                   MOVE      POut21        OPRIN
     C                   ENDIF
 
      ** Interest Rate
 
     C                   IF        WrkINT <> *ZEROS
     C                   EVAL      PFld15 = WrkINT
     C                   EVAL      PDecs = 7
     C                   EVAL      PECode = 'L'
     C                   EXSR      SrCvtAmt
 
      ** Strip out negative sign.
 
     C                   EVAL      WFld20 = POut21
     C                   MOVE      WFld20        OINTR
     C                   ENDIF
 
      ** R-Squared
 
     C                   EVAL      PFld15 = WrkRSQ * 10000000
     C                   EVAL      PDecs = 7
     C                   EVAL      PECode = 'J'
     C                   EXSR      SrCvtAmt
     C                   MOVE      POut21        ORSQR
 
      ** T-Statistic
 
     C                   EVAL      PFld15 = WrkTST * 10000
     C                   EVAL      PDecs = 4
     C                   EVAL      PECode = 'J'
     C                   EXSR      SrCvtAmt
     C                   MOVE      POut21        OTSTA
 
      ** Slope Coefficient
 
     C                   EVAL      PFld15 = WrkSLC * 1000
     C                   EVAL      PDecs = 3
     C                   EVAL      PECode = 'J'
     C                   EXSR      SrCvtAmt
     C                   MOVE      POut21        OSLCO
 
      ** Status
 
     C                   IF        WEffFlg = 'I'
     C                   EVAL      OSTAT = 'Ineffective'
     C                   ELSE
     C                   EVAL      OSTAT = 'Effective'
     C                   ENDIF
 
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
     C                   EVAL      OTVAL = '--------'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrCvtAmt - Convert Amount before printing                    *
      *                                                               *
      *****************************************************************
 
     C     SrCvtAmt      BEGSR
 
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
      *  SrCurr - Access currency details                             *
      *                                                               *
      *****************************************************************
 
     C     SrCurr        BEGSR
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM                    WrkCCY
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBKEY = WrkCCY
     C                   EVAL      DBASE = 5
     C                   EVAL      DBPROC =  'SR/SrCurr'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WCdPf = A6NBDP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrDate - Convert Date to DDMMMYY format                      *
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
      *  SrInL1 - New Hedge Strategy Level Break                      *
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
 
     C                   IF        WRecExist <> *BLANKS
                                                                                              224985
     C                   IF        WOPEN <> 'Y'                                               224985
     C                   OPEN      AS000023P1                                                 224985
     C                   EVAL      WOPEN = 'Y'                                                224985
     C                   ENDIF                                                                224985
                                                                                              224985
     C                   EVAL      *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInL2 - New Product Type Level Break                        *
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
 
     C                   EVAL      *IN25 = *OFF
     C                   EVAL      *IN26 = *OFF
 
     C                   SELECT
     C                   WHEN      H1PRTP = 'FV'
     C                   EVAL      *IN25 = *ON
     C                   WHEN      H1PRTP = 'CF'
     C                   EVAL      *IN26 = *ON
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInL3 - New Branch Level Break                              *
      *                                                               *
      *****************************************************************
 
     C     SrInL3        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      WInBrca = *BLANKS
 
     C                   EXSR      SrVal1
 
     C                   IF        *IN77 = *ON
     C                   EVAL      WInBrca = 'Y'
 
     C**********         IF        WRecExist <> *BLANKS                                       224985
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
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     Prtcd
     C                   PARM      '*KEY   '     POptn
     C                   PARM      H1BRCA        PBrca
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBrca
     C                   EVAL      DBASE = 6
     C                   EVAL      DBPROC =  'SR/SrInL3'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      O1BRCD = H1BRCA
     C                   EVAL      O1BRNM = A8BRNM
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrVal1 - Check if Hedge Linkages exist                       *
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
     C                   EVAL      WRecExist = *BLANKS
 
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
 
     C                   IF        WRecExist <> *BLANKS
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
 
     C                   IF        WRecExist <> *BLANKS AND *IN77 = *OFF
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
      *  SrVal2 - Search for live Hedge Linkage records               *
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
     C                   EVAL      WRecExist = 'Y'
     C                   ENDIF
 
 
      ** If at least one record exist, exit reading loop.
 
     C                   IF        WRecExist <> *BLANKS
     C                   LEAVE
     C                   ENDIF
 
     C     H1HESN        READE     ASHGLKL2                               87
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNxLk - Next Hedge Linkage                                  *
      *                                                               *
      *****************************************************************
 
     C     SrNxLk        BEGSR
 
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
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTrail  - Print trailer.                                    *
      *                                                               *
      *****************************************************************
 
     C     SrTrail       BEGSR
 
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
     C                   EVAL      WTrail = *BLANKS
 
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
      *  Sr3Factor - Calculate the 3 factors for hedge assessment.    *
      *                                                               *
      *****************************************************************
 
     C     Sr3Factor     BEGSR
 
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
 
      ** Sum up Data from Historic Data File
 
     C                   EXSR      SrSummat
 
      ** Compute for Notations based on the Sums of Squares
 
     C                   EXSR      SrNotaSum
 
      ** Compute for Coefficient of Determination, T-Statistic and
      ** Slope Coefficient.
 
     C                   EXSR      SrRegAsse
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSummat  - Summation of Data from Historic Data File        *
      *                                                               *
      *****************************************************************
 
     C     SrSummat      BEGSR
 
      ** Initialize Variables
 
      ** Summation Variable for Hedge Derivative (Dependent)
 
     C                   EVAL      WSumY = *ZERO
     C                   EVAL      WSumYSqrd = *ZERO
 
      ** Summation Variable for Hedged Item (Independent)
 
     C                   EVAL      WSumX = *ZERO
     C                   EVAL      WSumXSqrd = *ZERO
 
     C                   EVAL      WSumXY = *ZERO
 
      ** Counter
 
     C                   EVAL      WCounter= *ZERO
 
      ** Hedge Derivative Historic Market Data
 
     C     KDerivHMD     SETLL     ASDLHML2
 
     C                   SELECT
      ** Dealing
     C                   WHEN      FSMOD = 'DL'
     C     KHedgdHMD     SETLL     ASDLHML3
 
      ** Lending
     C                   WHEN      FSMOD = 'LE'
     C     KHedgdHMD     SETLL     ASLEHML2
 
      ** Securities
     C                   WHEN      FSMOD = 'SE'
     C     KAssehm       SETLL     ASSEHML0
     C                   ENDSL
 
      ** Historic Market Data Read Flag
 
     C                   EVAL      WDerivHMDRead = 'Y'
     C                   EVAL      WHedgdHMDRead = 'Y'
 
     C                   DOW       WCounter < FSDPTS AND WDerivHMDRead = 'Y'
     C                             AND WHedgdHMDRead = 'Y'
 
      ** Historic Market Data Read Flag
 
     C                   EVAL      WDerivHMDRead = *BLANKS
     C                   EVAL      WHedgdHMDRead = *BLANKS
 
      ** Hedge Derivative Historic Market Data
 
     C     KDerivHMD     READE     ASDLHML2
 
     C                   IF        NOT %EOF(ASDLHML2)
     C                   EVAL      WDerivHMDRead = 'Y'
     C                   SELECT
 
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      D2MVAL        WD2Mval12
     C                   EVAL(H R) WDerivHMD = WD2Mval12 * WDerivPCTG
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      D2MVCA        WD2Mvca12
     C                   EVAL(H R) WDerivHMD = WD2Mvca12 * WDerivPCTG
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      D2MRAT        WD2Mrat12
     C                   EVAL(H R) WDerivHMD =WD2Mrat12 * (10 ** 8) * WDerivPCTG
     C                   ENDSL
 
     C                   ENDIF
 
      ** Hedged Item Historic Market Data
 
      ** Dealing
 
     C                   IF        FSMOD = 'DL'
 
     C     KHedgdHMD     READE     ASDLHML3
 
     C                   IF        NOT %EOF(ASDLHML3)
     C                   EVAL      WHedgdHMDRead = 'Y'
 
     C                   SELECT
 
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      D3MVAL        WD3Mval12
     C                   EVAL(H R) WHedgdHMD = WD3Mval12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      D3MVCA        WD3Mvca12
     C                   EVAL(H R) WHedgdHMD = WD3Mvca12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      D3MRAT        WD3Mrat12
     C                   EVAL(H R) WHedgdHMD =WD3Mrat12 * (10 ** 8) * WHedgdPCTG
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Lending
 
     C                   IF        FSMOD = 'LE'
 
     C     KHedgdHMD     READE     ASLEHML2
 
     C                   IF        NOT %EOF(ASLEHML2)
     C                   EVAL      WHedgdHMDRead = 'Y'
 
     C                   SELECT
 
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      LEMVAL        WLEMval12
     C                   EVAL(H R) WHedgdHMD = WLEMval12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      LEMVCA        WLEMvca12
     C                   EVAL(H R) WHedgdHMD = WLEMvca12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      LEMRAT        WLEMrat12
     C                   EVAL(H R) WHedgdHMD =WLEMrat12 * (10 ** 8) * WHedgdPCTG
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Securities
 
     C                   IF        FSMOD = 'SE'
 
     C     KAssehm       READE     ASSEHML0
 
     C                   IF        NOT %EOF(ASSEHML0)
     C                   EVAL      WHedgdHMDRead = 'Y'
 
     C                   SELECT
 
     C                   WHEN      FSDTTP = 'V'
     C                   MOVE      SCMVAL        WSCMval12
     C                   EVAL(H R) WHedgdHMD = WSCMval12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'C'
     C                   MOVE      SCMVCA        WSCMvca12
     C                   EVAL(H R) WHedgdHMD = WSCMvca12 * WHedgdPCTG
     C                   WHEN      FSDTTP = 'R'
     C                   MOVE      SCMRAT        WSCMrat12
     C                   EVAL(H R) WHedgdHMD =WSCMrat12 * (10 ** 8) * WHedgdPCTG
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Increment the Counter of Historic Market Data Read and
      ** sum up Data from Historic Data File.
 
     C                   IF        WDerivHMDRead = 'Y' AND WHedgdHMDRead = 'Y'
 
     C                   EVAL      WCounter= WCounter + 1
 
     C                   EVAL(R)   WSumY = WSumY + WDerivHMD
     C                   EVAL(R)   WSumYSqrd = WSumYSqrd +
     C                                      (WDerivHMD * WDerivHMD)
 
     C                   EVAL(R)   WSumX = WSumX + WHedgdHMD
     C                   EVAL(R)   WSumXSqrd = WSumXSqrd +
     C                                      (WHedgdHMD * WHedgdHMD)
     C                   EVAL(R)   WSumXY = WSumXY + (WDerivHMD * WHedgdHMD)
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNotaSum - Compute for Notations based on the Sums of       *
      *              Squares                                          *
      *                                                               *
      *****************************************************************
 
     C     SrNotaSum     BEGSR
 
     C                   IF        WCounter = FSDPTS
     C                   EVAL      WSxy = *ZERO
     C                   EVAL      WSxx = *ZERO
     C                   EVAL      WSyy = *ZERO
     C                   EVAL      WSse = *ZERO
 
     C                   EVAL(R)   WWxy = (WSumX * WSumY)/FSDPTS
     C                   EVAL(R)   WSxy = WSumXY - WWxy
     C                   EVAL(R)   WWxx = (WSumX * WSumX)/FSDPTS
     C                   EVAL(R)   WSxx = WSumXSqrd - WWxx
     C                   EVAL(R)   WWyy = (WSumY * WSumY)/FSDPTS
     C                   EVAL(R)   WSyy = WSumYSqrd - WWyy
 
      ** Sum of Squares for Error measures the amount of variation.
 
     C                   IF        WSxy <> *ZERO AND WSxx <> *ZERO
     C                   EVAL(R)   WWse = (WSyy/WSxy) - (WSxy/WSxx)
     C                   EVAL(R)   WSse = WSxy * WWse
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRegAsse - Assess Linkages using the Regression Analysis    *
      *                                                               *
      *****************************************************************
 
     C     SrRegAsse     BEGSR
 
     C                   EVAL      WrkRSQ = *ZERO
     C                   EVAL      WrkTST = *ZERO
     C                   EVAL      WrkSLC = *ZERO
     C                   EVAL      WEffFlg = 'E'
 
      ** When there is insufficient data to be regressed based on the
      ** number of data points for the linkage or when either of the
      ** hedged item HMD variance or derivative HMV variance is zero,
      ** the hedge linkage will automatically go into ineffective
      ** status.
 
     C                   EVAL      *IN11 = *OFF
     C                   EVAL      *IN13 = *OFF
 
     C                   IF        WCounter < FSDPTS
     C                   EVAL      WEffFlg = 'I'
     C                   EVAL      *IN11   = *ON
     C                   GOTO      ESrRegAsse
     C                   ENDIF
 
     C                   IF        WSxx = *ZERO OR WSyy = *ZERO
     C                             OR WSxy = *ZERO
     C                   EVAL      WEffFlg = 'I'
     C                   EVAL      *IN13   = *ON
     C                   GOTO      ESrRegAsse
     C                   ENDIF
 
      ** A hedge will be effective using this method when all of the
      ** three factors listed below fall within the bounds specified
      ** for each. Compute the values of these three factors.
 
      ** 1. R-Squared - coefficient of determination which is used as
      **    a measure of correlation should be 80% (.8) or greater.
 
     C                   EVAL(H R) WrkRSQ = (WSxy / WSxx) * (WSxy / WSyy)
     C                   IF        WrkRSQ < .8
     C                   EVAL      WEffFlg = 'I'
     C                   ENDIF
 
      ** 2. T-Statistic should be significant at Greater Confidence
      **    Level. When the hedging derivative has a perfect inverse
      **    relationship w/ the hedged item (SSE = 0), automatically
      **    Hedged Item has a significant relationship with Hedge
      **    Derivative.
 
     C                   IF        WSse <> *ZERO
 
      ** Degrees of Freedom (n-2)
 
     C                   EVAL      WDf = FSDPTS - 2
 
      ** Alpha
 
     C                   EVAL      WAlpha = (100- FSCLVL)/100
 
     C                   EVAL(R)   WTsNum = WSxy/WSxx
     C                   EVAL(R)   WTsDen1 = %SQRT(WSse/WDf)
     C                   EVAL(R)   WTsDen2 = %SQRT(WSxx)
     C                   EVAL(R)   WTsDen = WTsDen1/WTsDen2
 
      ** Compute for T-Statistics.
 
     C                   EVAL(H R) WrkTST = WTsNum/WTsDen
 
      ** Retrieve the T Value from the T Distribution Table.
 
     C                   EVAL      KXXDfrd = WDf
     C                   EVAL      KXXArea = WAlpha / 2
 
     C     KSdtdtb       CHAIN     SDTDTBL0
 
     C                   IF        %FOUND(SDTDTBL0)
 
      ** If the computed T-Statistics is greater than or equal to
      ** - T Value and less than or equal to T Value,  the hedged item
      ** has no significant relationship with the derivative item.
      ** Thus, ineffective.
 
     C                   IF        WrkTST >= -XXTVAL
     C                             AND WrkTST <= XXTVAL
     C                   EVAL      WEffFlg = 'I'
     C                   ENDIF
 
     C                   ELSE
     C                   MOVEL     KXXDfrd       WXXDfrd
     C                   MOVEL     KXXArea       WXXArea
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE =  'SDTDTBL0'
     C                   EVAL      DBKEY  =  WXXDfrd + WXXArea
     C                   EVAL      DBASE  =  7
     C                   EVAL      DBPROC =  'SR/SrRegAsse'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   ENDIF
 
      ** 3. The slope coefficient which is the change in the derivative
      **    value (dependent variable) over the change in the hedged item
      **    value (independent variable) or  "rise" over "run" must be
      **    between -.8 and -1.25.
 
     C                   EVAL(H R) WrkSLC = WSxy/WSxx
 
     C                   IF        WrkSLC < -1.25 OR WrkSLC > -.8
     C                   EVAL      WEffFlg = 'I'
     C                   ENDIF
 
     C     ESrRegAsse    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PSeq
     C                   PARM                    PLevel
     C                   PARM                    PEnty
     C                   PARM                    PEntry
 
     C                   IF        PEntry = *BLANKS OR
     C                             PEntry = 'ALL'
     C                   EVAL      WkHEDI  = *ZEROS
     C                   ELSE
     C                   MOVEL     PEntry        WkHEDI
     C                   ENDIF
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBPGM = 'AS000023'
     C                   OUT       LDA
 
      ** Access Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       Prtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = '*FIRST'
     C                   EVAL      DBASE = 1
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
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
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Database Error
 
     C                   IF        Prtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDGELRPD'
     C                   EVAL      DBKEY = POptn
     C                   EVAL      DBASE = 3
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      WEvCtlDt = BJDNWD - 1
     C                   IF        BKAPDT < WEvCtlDt
     C                   EVAL      WEvCtlDt = BKAPDT
     C                   ENDIF
     C                   EVAL      PDate = WEvCtlDt
     C                   EXSR      SrDate
     C                   EVAL      OEVCD = PZaDate
     C                   EVAL      WOPEN = 'N'                                                224985
 
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
 
      ** Key List for idas AS SE Historic Mrkt Dta by Sec Posit/ValueDt
 
     C     KAssehm       KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KHedgdSESN
     C                   KFLD                    KHedgdBRCA
     C                   KFLD                    KHedgdBKCD
     C                   KFLD                    KHedgdMKTI
     C                   KFLD                    KHedgdBHTV
 
     C     KAssehm2      KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KHedgdSESN
     C                   KFLD                    KHedgdBRCA
     C                   KFLD                    KHedgdBKCD
     C                   KFLD                    KHedgdMKTI
     C                   KFLD                    KHedgdBHTV
     C**********         KFLD                    KVdat                                        224952
 
      ** Key List for Midas AS DL Historic Mrkt Dta by Hedge Id/Deal No/
      ** Value Date - Derivative item
 
     C     KDerivHMD     KLIST
     C                   KFLD                    KDerivHEDI
     C                   KFLD                    KDerivDLNO
 
      ** Key List for Midas AS DL Historic Mrkt Dta by Hedge Id/Deal No/
      ** Value Date and Midas AS LE Historic Mrkt Dta by Hedge Id/Loan No/
      ** Value Date - Hedged Item
 
     C     KHedgdHMD     KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KHedgdDLNO
 
     C     KHedgdHMD2    KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KDrvtvDLNO
     C                   KFLD                    KVdat
 
     C     KHedgdHMD3    KLIST
     C                   KFLD                    KHedgdHEDI
     C                   KFLD                    KDrvtvDLNO
 
      ** Key List for Midas SD T Distribution Table File
 
     C     KSdtdtb       KLIST
     C                   KFLD                    KXXDfrd
     C                   KFLD                    KXXArea
 
 
      ** Get Rundate - Rundate  *
 
     C     *DTAARA       DEFINE                  RUNDAT
     C                   IN        RUNDAT
     C                   MOVE      MRDT          BJMRDT
 
      ** Check multibranch function
 
     C                   IF        MBIN = 'Y'
     C                   EVAL      *IN37 = *ON
     C                   ENDIF
 
      ** Ensure Audit Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       PSeq
     C**********         PARM      *BLANKS       PEnty                                        225949
     C                   PARM                    PEnty                                        225949
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        PZSNumU
     C                   PARM      *BLANK        PZSErr
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR  - Program exception error routine                     *
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
 
