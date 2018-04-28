     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Hedge strategy table maintenance')            *
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SD000743 - Hedge Strategy Table Maintenance                  *
      *                                                               *
      *  Function:  This module enables the user to enter, maintain,  *
      *             and enquire upon Hedge Strategy details (hedging  *
      *             strategy, effectiveness measure, frequency, and   *
      *             permissible Midas transaction types).             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
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
      *                 CDL049             Date 11May06               *
      *                 CLE042             Date 06Sep05               *
      *                 CSE075             Date 17Nov05               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL033             Date 10Feb05               *
      *                 CDL028             Date 07Feb05               *
      *                 227674             Date 10Jun04               *
      *                 CAS007             Date 26Apr04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS006             Date 21Jan03               *
      *                 213352             Date 18Dec02               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS003             Date 14Jan02               *
      *                 CAS002  *CREATE    Date 14Jan02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference                                *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL033 - Floating Rate CDs Issued                            *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  227674 - Hedge Transaction Input, error msg: trans subtype   *
      *           not found. Subtype should be mandatory for valid    *
      *           Deal Type (i.e '**').                               *
      *  CAS007 - Hedge Accounting Control                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  213352 - Validation of 1st date is incorrect for Hedge       *
      *           Strategy Maintenance.                               *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    26         Maintenance Mode                                *
      *    27         Enquiry Mode                                    *
      *    28         Selection Mode                                  *
      *    29         'Add' Mode                                      *
      *    30         Invalid Action Code                             *
      *    31         Rollup/Rolldown                                 *
      *    32         Product Sub-Type field availability             *
      *****41-57******Error*on*fields**********************************                       CAS006
      *    41-58      Error on fields                                 *                       CAS006
      *    61         No display of Effectiveness Assessment fields   *                       CAS006
      *               when CAS006 is off                              *                       CAS006
      *    70         'Add' Mode - Key Screen                         *
      *    71         Enquire                                         *
      *    72         Delete                                          *
      *    73         Amend                                           *
      *    80         Subfile Clear (SFLCLR)                          *
      *    81         Subfile Display (SFLDSP)                        *
      *    82         Rollup                                          *
      *    84         Subfile Next Change (SFLNXTCHG)                 *
      *    89         LOOKUP error                                    *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRSelect      -  Hedge Shortname Selection                   *
      *  SRBuild       -  Initialise and load subfile page            *
      *  SRLoad        -  Load subfile page                           *
      *  SRDisplay     -  Display screen                              *
      *  SRProcess     -  Process screen input                        *
      *  SRVAction     -  Validate action code                        *
      *  SRDetails     -  Set-up Details                              *
      *  SRRetrieve    -  Retrieve record details                     *
      *  SREnquire     -  Enquire details                             *
      *  SRInsert      -  Insert record                               *
      *  SRValidate    -  Validate details                            *
      *  SRVHesn       -  Validate Hedge Shortname                    *
      *  SRVHeld       -  Validate Hedge Description                  *
      *  SRVBrca       -  Validate Hedge Branch Code                  *
      *  SRVPrtp       -  Validate Hedge Product Type                 *
      *  SRVPrst       -  Validate Hedge Product Sub-Type             *
      *  SRVHrsk       -  Validate Hedge Risk                         *
      *  SRVEffm       -  Validate Effectiveness Measure              *
      *  SRVEfup       -  Validate Effectiveness Upper Percentage     *
      *  SRVEflo       -  Validate Effectiveness Lower Percentage     *
      *  SRVEffq       -  Validate Effective Frequency                *
      *  SRVFsdt       -  Validate First Date                         *
      *  SRVDvt        -  Validate Derivative Types                   *
      *  SRVDst        -  Validate Derivative Sub-types               *
      *  SRVDbk        -  Validate Derivative Book Code               *
      *  SRVHdt        -  Validate Hedged Deal/Investment Types       *
      *  SRVHst        -  Validate Hedged Sub-Types                   *
      *  SRVHbk        -  Validate Hedged Book Code                   *
      *  SRChkLink     -  Check Hedge Linkage                         *
      *  SRDelReq      -  Process delete request                      *
      *  SRDelete      -  Flag record for deletion                    *
      *  SRAmend       -  Amend record                                *
      *  SRTrailer     -  Update Control Files                        *
      *  SRRefresh     -  Refresh subfile                             *
      *  SRClrScrn     -  Initialise subfile record                   *
      *  SRMove        -  Move fields from file/screen to screen/file *
      *  SRWrite       -  Insert record                               *
      *  SRDelete      -  Delete Hedge Shortname Details              *
      *  SRAmdReq      -  Process amend request                       *
      *  SRZasnms      -  Message handling subroutine                 *
      *  SRPrevious    -  Display previous screen                     *
      *  SREnd         -  End program                                 *
      *                                                               *
      *  *PSSR - Error processing                                     *
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
 
     FSD000743DFCF   E             WORKSTN INFDS(INFDS#)
     F                                     INFSR(*PSSR)
     F                                     SFILE(SD000743S0:#0RLRN)
     F                                     USROPN
      ** Hedge Strategy Maintenance Display File
 
     FSDHGSTL0  UF A E           K DISK    COMMIT
     F                                     INFDS(HGSTL0)
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:@HGSTD0)
     F                                     USROPN
      ** Hedge Strategy by Shortname Master File Update Index
 
     FSDHGSTL1  IF   E           K DISK    INFDS(HGSTL1)
     F                                     INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:@HGSTD1)
     F                                     USROPN
      ** Hedge Strategy by Shortname Master File Retrieval Index
 
     FASHGLKL2  IF   E           K DISK    INFDS(HGLKL2)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(A_)
      ** Hedge Linkage File Retrieval by Hedge Strategy
 
     FASHTRNL1  IF   E           K DISK    INFDS(HTRNL1)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(B_)
      ** Hedge Transaction File Retrieval by Hedge Id/Indicator
 
     FASFHTRL1  IF   E           K DISK    INFDS(FHTRL1)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(C_)
      ** Forecast Transaction Details Master File Retrieval Index
 
     FMKCTL     IF   E           K DISK    USROPN
     F                                     INFDS(MKCTL#)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(MK_)
      ** Midas FF Market Control details
 
     FINTYP     IF   E           K DISK    USROPN
     F                                     INFDS(INTYP#)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(IT_)
      ** Midas FF Instrument Types
 
     FINVTO     IF   E           K DISK    USROPN
     F                                     INFDS(INVTO#)
     F                                     INFSR(*PSSR)
     F                                     PREFIX(TP_)
      ** Midas SE Investment Types
 
     FDEALSL    IF   E           K DISK    USROPN
     F                                     INFDS(DEALSL#)
     F                                     INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     RENAME(DEALSDBF:DEALSDB2)
     F                                     IGNORE(DEALSDCF)
     F                                     IGNORE(DEALSDDF)
     F                                     IGNORE(DEALSDEF)
     F                                     IGNORE(DEALSDFF)
      ** Midas DL Deals File Excluding Matured Deals
      ** Deals Files DEALSDB/DEALSDG
 
     FDEALALL   IF   E           K DISK    USROPN
     F                                     INFDS(DEALALL#)
     F                                     INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDGF)
     F                                     IGNORE(DEALSDFF)
      ** Midas DL All deals
      ** Deals Files DEALSDB/DEALSDC/DEALSDD/DEALSDE
 
     FCLOAN     IF   E           K DISK    USROPN
     F                                     INFDS(CLOAN#)
     F                                     INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** Midas LE Loans File
 
     FSECTY     IF   E           K DISK    USROPN
     F                                     INFDS(SECTY#)
     F                                     INFSR(*PSSR)
      ** Midas SE Securities
 
     FSDLOANL1  IF   E           K DISK    USROPN
     F                                     INFDS(LOANL1)
     F                                     INFSR(*PSSR)
      ** Midas SD Loan Types/Sub-Types Retrieval Index
 
     FSDFCTLL0  UF   E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
      ** Control File Update Index
 
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
 
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
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
 
     D TABNAM          S              3    DIM(12) CTDATA PERRCD(12)
     D TABNUM          S              2  0 DIM(12) ALT(TABNAM)
     D ArrScrnDVT      S             10    DIM(10)
     D ArrFileDVT      S             10    DIM(10)
     D ArrScrnDST      S              2    DIM(10)
     D ArrFileDST      S              2    DIM(10)
     D ArrScrnDBK      S              2    DIM(10)
     D ArrFileDBK      S              2    DIM(10)
     D ArrScrnHDT      S              3    DIM(10)
     D ArrFileHDT      S              3    DIM(10)
     D ArrScrnHST      S              2    DIM(10)
     D ArrFileHST      S              2    DIM(10)
     D ArrScrnHBK      S              2    DIM(10)
     D ArrFileHBK      S              2    DIM(10)
     D ArrTemp2        S              2    DIM(10)
     D ArrTemp3        S              3    DIM(10)
     D ArrTemp10       S             10    DIM(10) ASCEND
     D ArrIMQ          S              1    DIM(12)
 
      ** File Information
     D HGSTL0          DS
     D  #HGST0                 9      9
     D HGSTL1          DS
     D  #HGST1                 9      9
 
      ** Display file information data structure
     D INFDS#        E DS                  EXTNAME(Y2I#DSP)
 
      ** File information data structure
     D HGLKL2          DS           528
 
      ** File information data structure
     D HTRNL1          DS           528
 
      ** File information data structure
     D MKCTL#          DS           528
 
      ** File information data structure
     D INTYP#          DS           528
 
      ** File information data structure
     D INVTO#          DS           528
 
      ** File information data structure
     D DEALSL#         DS           528
 
      ** File information data structure
     D DEALALL#        DS           528
 
      ** File information data structure
     D CLOAN#          DS           528
 
      ** File information data structure
     D SECTY#          DS           528
 
      ** File information data structure
     D FHTRL1          DS           528
 
      ** File information data structure
     D LOANL1          DS           528
 
      ** External data structure for Switchable Features Details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
 
      ** External data structure for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External data structure for Midas Modules
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** External data structure for Branch Code Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External data structure for Deal Sub-Type Details
     D SDDLST        E DS                  EXTNAME(SDDLSTPD)
 
      ** External data structure for Book Code Details
     D SDBOOK        E DS                  EXTNAME(SDBOOKPD)
 
      ** Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Current/previous master file format fields for change control
     D CurRec        E DS                  EXTNAME(SDHGSTL1)
 
      ** Data Structure for record fields
     D***SavRec2         DS           280                                                     CAS006
     D SavRec2         DS           281                                                       CAS006
 
      ** Data Structure for record fields
     D***SavRec*         DS           280                                                     CAS006
     D SavRec          DS           281                                                       CAS006
 
     D WPOS            DS            10
     D  WP1X2                  1      2
     D  WP1X5                  1      5
     D  WP3                    3      3
     D  WP3X10                 3     10
     D  WP4X10                 4     10
     D  WP6                    6      6
     D  WP6X8                  6      8
     D  WP6X10                 6     10
     D  WP7X10                 7     10
     D  WP9                    9      9
     D  WP10                  10     10
 
     D WScrnDVT        DS
     D  #1DVT1                 1     10
     D  #1DVT2                11     20
     D  #1DVT3                21     30
     D  #1DVT4                31     40
     D  #1DVT5                41     50
     D  #1DVT6                51     60
     D  #1DVT7                61     70
     D  #1DVT8                71     80
     D  #1DVT9                81     90
     D  #1DT10                91    100
 
     D WScrnDST        DS
     D  #1DST1                 1      2
     D  #1DST2                 3      4
     D  #1DST3                 5      6
     D  #1DST4                 7      8
     D  #1DST5                 9     10
     D  #1DST6                11     12
     D  #1DST7                13     14
     D  #1DST8                15     16
     D  #1DST9                17     18
     D  #1DS10                19     20
 
     D WScrnHDT        DS
     D  #1HDT1                 1      3
     D  #1HDT2                 4      6
     D  #1HDT3                 7      9
     D  #1HDT4                10     12
     D  #1HDT5                13     15
     D  #1HDT6                16     18
     D  #1HDT7                19     21
     D  #1HDT8                22     24
     D  #1HDT9                25     27
     D  #1HD10                28     30
 
     D WScrnDBK        DS
     D  #1DBK1                 1      2
     D  #1DBK2                 3      4
     D  #1DBK3                 5      6
     D  #1DBK4                 7      8
     D  #1DBK5                 9     10
     D  #1DBK6                11     12
     D  #1DBK7                13     14
     D  #1DBK8                15     16
     D  #1DBK9                17     18
     D  #1DB10                19     20
 
     D WScrnHST        DS
     D  #1HST1                 1      2
     D  #1HST2                 3      4
     D  #1HST3                 5      6
     D  #1HST4                 7      8
     D  #1HST5                 9     10
     D  #1HST6                11     12
     D  #1HST7                13     14
     D  #1HST8                15     16
     D  #1HST9                17     18
     D  #1HS10                19     20
 
     D WScrnHBK        DS
     D  #1HBK1                 1      2
     D  #1HBK2                 3      4
     D  #1HBK3                 5      6
     D  #1HBK4                 7      8
     D  #1HBK5                 9     10
     D  #1HBK6                11     12
     D  #1HBK7                13     14
     D  #1HBK8                15     16
     D  #1HBK9                17     18
     D  #1HB10                19     20
 
     D WrkHDT          DS             3
     D   WrkHDT3               3      3
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PMODE           S              1
     D PRTCD           S              7
     D POPTN           S              7
     D PHESN           S             10
     D PRtrnCode       S              7
     D POption         S              7
     D PSard           S              6
     D PBRCA           S              3
     D PDBK            S              2
     D PPRST           S              2
     D PLNTY           S              2
     D PLNST           S              2
     D PString         S            256
     D PLength         S              3  0
     D PRtnCd          S              5
     D PEmbed          S              1
     D PVType          S              6
     D PDateFmt        S              1
     D PDDMMYY         S              6  0
     D PDecimal        S              1  0
     D PDigits         S              2  0
     D PFieldIn        S             16
     D PFieldOut       S             16
     D PMidasDayNo     S              5  0
     D PWorkDate       S              7
     D PZPgmQ          S             10
     D PZRelQ          S              5
     D PZMsgID         S              7
     D PZMsgFile       S             10
     D PZMsgData       S            132
     D PZMsgType       S              7
 
     D CDL006          S              1
     D CAS003          S              1                                                       CAS003
     D WRun            S              1
     D WReload         S              1
     D WLRCD           S              4  0
     D WError          S              1
     D WRecChg         S              1
     D WSLCTR          S              3  0
     D WNODAT          S              1
     D WRCTR           S              5  0
     D WSFPG           S              3  0
     D WQB10X          S             10
     D WQA5N           S              5  0
     D WQC10X          S             10
     D WQA3N           S              3  0
     D WQB3N           S              3  0
     D WQC3N           S              3  0
     D WQD1            S              1
     D WQE1            S              1
     D WQF1            S              1
     D WSaveHESN       S             10
     D WSkipRec        S              1
     D WKeyScrn        S              1
     D WDetScrn        S              1
     D WFileToScrn     S              1
     D WValid          S              1
     D WScrnFSDT       S              6
     D WTest2          S              2
     D WTest3          S              3
     D WTest10         S             10
     D WTest20         S             20
     D WProcess        S              1
     D WDType          S              2
     D WDHIN           S              1
     D WLink           S              1
     D WDTIN           S              1
     D WVDVT           S              1
     D WVHDT           S              1
     D WDTI            S              1
     D WITI            S              1
     D WLTI            S              1
     D WVar1           S              2
     D WVar2           S              2
     D WVar5           S              5
     D WCtrFile        S              2  0
     D WCtrScrn        S              2  0
     D WQG3N           S              3  0
     D WZHESN          S             10
     D WZHELD          S             35
     D WZBRCA          S              3
     D WQHELD          S             35
     D WLDIN           S              1                                                       227674
 
     D X               S              2  0
     D Y               S              2  0
 
     D CAS004          S              1                                                       CAS004
     D CAS006          S              1                                                       CAS006
                                                                                              CAS004
     D B_FSDLNOA       S              6  0                                                    CLE148
      ** Rename FSEFUP fields in DEALS/LOANS file because of conflict                         CAS004
      ** with field definition in PF/SDHGSTPD                                                 CAS004
                                                                                              CAS004
     IDEALSDB2                                                                                CAS004
     I              FSEFUP                      B2_FSEFUP                                     CAS004
     IDEALSDGF                                                                                CAS004
     I              FSEFUP                      G_FSEFUP                                      CAS004
     IDEALSDBF                                                                                CAS004
     I              FSEFUP                      B_FSEFUP                                      CAS004
     IDEALSDCF                                                                                CAS004
     I              FSEFUP                      C_FSEFUP                                      CAS004
     IDEALSDDF                                                                                CAS004
     I              FSEFUP                      D_FSEFUP                                      CAS004
     ICLOANCLF                                                                                CAS004
     I              FSEFUP                      L_FSEFUP                                      CAS004
                                                                                              CAS004
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Main Program
 
     C                   DO        *HIVAL
 
      ** Initialise and load subfile page
 
     C                   EXSR      SRBuild
 
     C                   EVAL      WReload = 'N'
 
      ** Display screen until reload requested
 
     C     WReload       DOWEQ     'N'
 
      ** Display screen
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *INKC         CASEQ     '1'           SREnd
 
     C     *INKE         CASEQ     '1'           SRRefresh
 
     C     *INKI         CASEQ     '1'           SRInsert
 
     C     *IN31         CASEQ     '1'           SRLoad
 
     C                   CAS                     SRProcess
     C                   ENDCS
 
     C                   ENDDO
 
     C                   ENDDO
 
     C                   EVAL      *INLR = '1'
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSelect - Hedge Shortname Selection                          *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRSelect      BEGSR
 
     C     #0HESN        CHAIN     SDHGSTL1
 
      ** Record found.
 
     C                   IF        %FOUND(SDHGSTL1)
     C                   EVAL      PRTCD = *BLANKS
     C                   EVAL      PHESN = FSHESN
 
      ** Record not found.
 
     C                   ELSE
     C                   EVAL      PRTCD = '*ERROR '
     C                   EVAL      PHESN = *BLANKS
     C                   ENDIF
 
     C                   EVAL      *INLR = '1'
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBuild - Initialise and Load Subfile Page                    *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRLoad, SRZasnms                                   *
      *                                                               *
      *****************************************************************
 
     C     SRBuild       BEGSR
 
      ** Initialise & load subfile page
 
     C                   EVAL      *IN80 = '1'
     C                   WRITE     SD000743C0
     C                   EVAL      *IN80 = '0'
     C                   EVAL      *IN81 = '1'
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'N'
 
      ** Reset Number of Records in Subfile
 
     C                   Z-ADD     0             WLRCD
 
      ** Position file
 
     C                   EVAL      FSHESN = #0POS1
 
      ** Setup key
 
     C     FSHESN        SETLL     @HGSTD1                            82
     C                   READ      @HGSTD1                                82
 
      ** Save previous selector values
 
     C                   EVAL      WZHESN = #0POS1
     C                   EVAL      WZHELD = #0POS2
     C                   EVAL      WZBRCA = #0POS3
 
      ** Translate search mask for text field
 
     C                   CALL      'QDCXLATE'
     C                   PARM      35            WQA5N             5 0
     C                   PARM      #0POS2        WQHELD
     C                   PARM      'QSYSTRNTBL'  WQB10X
     C                   PARM      'QSYS'        WQC10X           10
 
      ** Load subfile page
 
     C                   EXSR      SRLoad
 
      ** If no records found, display error message
 
     C                   IF        *IN82 = '1'  AND  #0RLRN = 0
     C                   EVAL      *IN81 = '0'
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLoad - Load Subfile Page                                    *
      *                                                               *
      * Called by: Main routine, SRBuild                              *
      *                                                               *
      * Calls    : SRClrScrn, SRMove, SRValidate                      *
      *                                                               *
      *****************************************************************
 
     C     SRLoad        BEGSR
 
      ** Load subfile page
 
     C                   EVAL      *IN84 = *OFF
 
      ** Re-establish fields in read-ahead record
 
     C                   IF        *IN31 = '1' AND *IN82 = '0'
     C                   READP     @HGSTD1                                60
     C                   READ      @HGSTD1                                60
     C                   ENDIF
 
      ** Start at previous highest record in SFL
 
     C                   Z-ADD     WLRCD         #0RLRN
     C                   Z-ADD     1             WRCTR
 
      ** Load next subfile page
 
     C                   DOW       *IN82 = '0'  AND  WRCTR <= WSFPG
 
     C                   EVAL      WSkipRec = 'N'
     C                   ADD       1             #0RLRN
 
     C                   IF        FSCHTP = 'D'
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   IF        #0POS2 <> *BLANKS
     C                   CALL      'QCLSCAN'
     C                   PARM                    FSHELD
     C                   PARM      35            WQA3N
     C                   PARM      1             WQB3N
     C                   PARM                    WQHELD
     C                   PARM      35            WQC3N
     C                   PARM      '1'           WQD1
     C                   PARM      '1'           WQE1
     C                   PARM      '?'           WQF1
     C                   PARM                    WQG3N
 
     C                   IF        WQG3N < 1
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        #0POS3 <> *BLANK  AND  FSBRCA <> #0POS3
     C                   EVAL      WSkipRec = 'Y'
     C                   ENDIF
 
     C                   IF        WSkipRec = 'N'
 
      ** Clear subfile fields
 
     C                   EXSR      SRClrScrn
 
      ** Load subfile fields
 
     C                   EVAL      WFileToScrn = 'Y'
     C                   EVAL      WDetScrn = 'N'
     C                   EXSR      SRMove
 
      ** Output to subfile
 
     C                   ADD       1             WRCTR
 
     C                   WRITE     SD000743S0
 
     C                   ELSE
     C                   SUB       1             #0RLRN
 
     C                   ENDIF
 
     C                   READ      @HGSTD1                                82
     C                   ENDDO
 
     C                   Z-ADD     #0RLRN        WLRCD
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDisplay - Display Subfile                                  *
      *                                                               *
      *  Called by: Main routine                                      *
      *                                                               *
      *  Calls    : ZA0250                                            *
      *                                                               *
      *****************************************************************
 
     C     SRDisplay     BEGSR
 
      ** Condition appropriate header and footer
 
     C                   SELECT
     C                   WHEN      PMODE = 'M'
     C                   IF        WKeyScrn = 'N'  AND  WDetScrn = 'N'
     C                   EVAL      *IN26 = '1'
 
     C                   ELSE
 
     C                   IF        #0ACTN = 'D'
     C                   EVAL      *IN72 = '1'
     C                   ELSE
     C                   EVAL      *IN29 = '1'
     C                   ENDIF
     C                   ENDIF
 
     C                   WHEN      PMODE = 'E'
     C                   IF        WDetScrn = 'N'
     C                   EVAL      *IN27 = '1'
     C                   ELSE
     C                   EVAL      *IN29 = '1'
     C                   ENDIF
 
     C                   WHEN      PMODE = '?'
     C                   EVAL      *IN28 = '1'
     C                   ENDSL
 
      ** Display screen
 
     C                   TIME                    #0TIME
     C                   WRITE     SD000743F0
     C                   WRITE     SD000743F2
     C                   WRITE     SD000743C1
 
     C                   IF        WKeyScrn = 'Y'  OR  WDetScrn = 'Y'
                                                                                              CAS006
      ** If CAS006 is installed, check linkage file if strategy is used by at                 CAS006
      ** least one live linkage, effectiveness assessment method can not be amended           CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
     C                   EVAL      *IN74 = *OFF                                               CAS006
     C     #1HESN        SETLL     ASHGLKL2                                                   CAS006
     C     #1HESN        READE     ASHGLKL2                                                   CAS006
     C                   DOW       NOT %EOF(ASHGLKL2) AND *IN74 = *OFF                        CAS006
     C                   IF        A_FSRECI = 'D'                                             CAS006
     C                   EVAL      *IN74 = *ON                                                CAS006
     C                   ENDIF                                                                CAS006
     C     #1HESN        READE     ASHGLKL2                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EXFMT     SD000743F1
     C                   ELSE
     C                   EXFMT     SD000743C0
     C                   ENDIF
 
      ** Reset error indicators
 
     C                   MOVEA     '00000'       *IN(26)
     C                   MOVEA     '000000000000'*IN(41)
     C**********         MOVEA     '00000'       *IN(53)
     C                   MOVEA     '000000'      *IN(53)
     C                   MOVEA     '0000'        *IN(70)
 
      ** Clear messages from program message queue
 
     C                   CALL      'Y2CLMSC'
     C                   PARM      #1PGMQ        PZPgmQ
     C                   PARM      '*SAME'       PZRelQ
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProcess - Process Screen Input                              *
      *                                                               *
      * Called by: Main routine                                       *
      *                                                               *
      * Calls    : SRDetails                                          *
      *                                                               *
      *****************************************************************
 
     C     SRProcess     BEGSR
 
      ** If there are no records, continue displaying 'No Data to Display'.
 
     C                   IF        *IN82 = '1'  AND  #0RLRN = 0
     C                   EVAL      *IN81 = '0'
     C                   EVAL      PZMsgID = 'USR7590'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Change of position specified
 
     C                   IF        WZHESN <> #0POS1  OR  WZHELD <> #0POS2  OR
     C                             WZBRCA <> #0POS3
     C                   EVAL      WReload = 'Y'
 
      ** Process subfile records if reload not requested
 
     C                   ELSE
 
     C                   EVAL      WError = 'N'
     C                   EVAL      WProcess = 'N'
     C                   EVAL      WSLCTR = 0
     C                   EXSR      SRVAction
 
      ** Process details according to action code.
 
     C                   IF        WError = 'N'  AND  WProcess = 'Y'
     C                   EXSR      SRDetails
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVAction - Validate Action Codes                             *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRVAction     BEGSR
 
      ** Process modified subfile record
 
     C                   READC     SD000743S0                             86
 
     C                   DOW       *IN86 = '0'
 
     C                   EVAL      *IN30 = '0'
 
      ** Validate Action
 
     C                   SELECT
 
     C                   WHEN      PMode = 'M' AND #0ACTN <> 'A' AND
     C                             #0ACTN <> 'D' AND #0ACTN <> 'E' AND
     C                             #0ACTN <> *BLANKS
     C                   EVAL      *IN30 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9357'
     C                   EXSR      SRZasnms
 
      ** Valid entry.
 
     C                   WHEN      PMode = 'M'  AND  (#0ACTN = 'A'  OR
     C                             #0ACTN = 'D'  OR  #0ACTN = 'E')
     C                   EVAL      WProcess = 'Y'
 
      ** Hedge Strategy must not be deleted if it has an existing Hedge Linkage.
 
     C                   IF        #0ACTN = 'D'
     C     #0HESN        CHAIN     ASHGLKL2
     C                   IF        %FOUND(ASHGLKL2)  AND  A_FSRECI = 'D'
     C                   EVAL      *IN30 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      WProcess = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9368'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** For enquiry mode, action code must be 'E'.
 
     C                   WHEN      PMode = 'E' AND #0ACTN <> 'E' AND
     C                             #0ACTN <> *BLANKS
     C                   EVAL      *IN30 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9367'
     C                   EXSR      SRZasnms
 
      ** Valid entry.
 
     C                   WHEN      PMode = 'E' AND #0ACTN = 'E'
     C                   EVAL      WProcess = 'Y'
 
      ** For selection mode, action code should be '1'.
 
     C                   WHEN      PMode = '?' AND #0ACTN <> '1' AND
     C                             #0ACTN <> *BLANKS
     C                   EVAL      *IN30 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9358'
     C                   EXSR      SRZasnms
 
     C                   WHEN      PMode = '?' AND #0ACTN = '1'
     C                   EVAL      WNODAT = 'Y'
     C                   ADD       1             WSLCTR
 
     C                   IF        WSLCTR > 1
     C                   EVAL      *IN30 = '1'
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9359'
     C                   EXSR      SRZasnms
 
      ** Valid entry.
 
     C                   ELSE
     C                   EVAL      WProcess = 'Y'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   EVAL      *IN84 = '1'
     C                   UPDATE    SD000743S0
     C                   EVAL      *IN84 = '0'
 
     C                   READC     SD000743S0                             86
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDetails - Process Details                                   *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRProcess                                          *
      *                                                               *
      *****************************************************************
 
     C     SRDetails     BEGSR
 
      ** Process all modified subfile records
 
     C                   READC     SD000743S0                             86
 
     C                   DOW       *IN86 = '0'
 
      ** Process details according to action code.
 
     C                   IF        #0ACTN = '1'
     C                   EXSR      SRSelect
 
     C                   ELSE
     C                   EVAL      WDetScrn = 'Y'
     C                   EVAL      WReload = 'Y'
     C                   EVAL      WSaveHESN = #1HESN
     C                   RESET                   SD000743F1
     C                   EVAL      #1HESN = WSaveHESN
     C                   EXSR      SRRetrieve
 
     C                   SELECT
 
      ** Amend
 
     C                   WHEN      #0ACTN = 'A'
     C                   EXSR      SRAmdReq
 
      ** Delete
 
     C                   WHEN      #0ACTN = 'D'
     C                   EXSR      SRDelReq
 
      ** Enquiry
 
     C                   WHEN      #0ACTN = 'E'
     C                   EXSR      SREnquire
 
     C                   ENDSL
     C                   ENDIF
 
      ** Set screen conditioning indicators
 
     C                   EVAL      #0ACTN = *BLANKS
     C                   UPDATE    SD000743S0
     C                   READC     SD000743S0                             86
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRetrieve - Retrieve record details                          *
      *                                                               *
      * Called by: SRDetails                                          *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRRetrieve    BEGSR
 
     C     #0HESN        CHAIN     SDHGSTL1
 
     C                   IF        %FOUND(SDHGSTL1)
     C                   EVAL      PBRCA = FSBRCA
 
      ** Retrieve Branch Name
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C                   EVAL      DBASE = 11
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ELSE
 
     C                   EVAL      #1BRNM = A8BRNM
     C                   EVAL      WFileToScrn = 'Y'
     C                   EXSR      SRMove
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnquire - Enquiry                                           *
      *                                                               *
      * Called by: Process                                            *
      *                                                               *
      * Calls    : SRWrite, SRTrailer                                 *
      *                                                               *
      *****************************************************************
 
     C     SREnquire     BEGSR
 
     C                   EVAL      *IN71 = '1'
     C                   EXSR      SRDisplay
 
     C                   IF        *INKC = '1'
     C                   EXSR      SREnd
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInsert - Process Add Request                                *
      *                                                               *
      * Called by: Process                                            *
      *                                                               *
      * Calls    : SRWrite, SRTrailer                                 *
      *                                                               *
      *****************************************************************
 
     C     SRInsert      BEGSR
 
     C                   EVAL      #0ACTN = 'I'
     C                   EVAL      #1HESN = *BLANKS
     C                   EVAL      WKeyScrn = 'Y'
     C                   EVAL      WValid = 'N'
     C                   EVAL      WReload = 'Y'
 
      ** Prompt for new Hedge Shortname
 
     C                   DOW       *INKC = '0'  AND  *INKL = '0'  AND
     C                             WValid = 'N'
 
     C                   IF        WKeyScrn = 'Y'
     C                   EVAL      *IN70 = '1'
     C                   ELSE
     C                   EVAL      *IN70 = '0'
     C                   ENDIF
 
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *INKC         CASEQ     '1'           SREnd
 
     C     *INKL         CASEQ     '1'           SRPrevious
 
     C                   CAS                     SRValidate
     C                   ENDCS
 
      ** Create Hedge Shortname Details
 
     C                   IF        WValid = 'Y'
     C                   EXSR      SRWrite
 
     C                   IF        WError = 'Y'
     C                   EVAL      WValid = 'N'
     C                   ELSE
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'N'
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValidate - Validate all fields                              *
      *                                                               *
      * Called by: SRInsert                                           *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRValidate    BEGSR
 
     C                   SELECT
 
     C                   WHEN      WKeyScrn = 'Y'
     C                   EVAL      WSaveHESN = #1HESN
     C                   RESET                   SD000743F1
     C                   EVAL      #1HESN = WSaveHESN
     C                   EXSR      SRVHesn
 
     C                   WHEN      WDetScrn = 'Y'  AND
     C                             (#0ACTN = 'I'  OR  #0ACTN = 'A')
     C                   EVAL      WValid = 'Y'
 
     C                   IF        #0ACTN = 'I'
     C                   EXSR      SRVHeld
     C                   EXSR      SRVBrca
     C                   EXSR      SRVPrtp
 
      ** Hedge Sub-Type field is available only if Midas Dealing module is on.
 
     C                   IF        *IN32 = '0'
     C                   EXSR      SRVPrst
     C                   ENDIF
 
     C**********         EXSR      SRVHrsk                                                    CAS006
     C**********         EXSR      SRVEffm                                                    CAS006
     C                   ENDIF
 
     C                   EXSR      SRVEfup
     C                   EXSR      SRVEflo
 
     C                   IF        #0ACTN = 'I'
     C                   EXSR      SRVEffq
     C                   ENDIF
 
     C                   EXSR      SRVFsdt
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   EXSR      SRVMeff                                                    CAS006
     C                   ENDIF                                                                CAS006
     C                   EXSR      SRVDvt
     C                   EXSR      SRVDst
     C                   EXSR      SRVDbk
     C                   EXSR      SRVHdt
     C                   EXSR      SRVHst
     C                   EXSR      SRVHbk
     C                   ENDSL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVHesn - Validate Hedge Shortname                            *
      *                                                               *
      * Called by: SRInsert                                           *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVHesn       BEGSR
 
      ** Hedge Shortname required
 
     C                   IF        #1HESN = *BLANKS
 
     C                   EVAL      *IN41 = '1'
     C                   EVAL      WValid = 'N'
     C                   MOVEL     'Y2U0001'     PZMsgID
     C                   MOVEL     'Y2USRMSG'    PZMsgFile
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Hedge Shortname must be alphanumeric.
      ** Call SD0811 to check leading character for alpha
 
     C                   EVAL      PString = #1HESN
 
     C                   CALL      'SD0811'
     C                   PARM                    PString
     C                   PARM      1             PLength
     C                   PARM      *BLANKS       PRtnCd
     C                   PARM      'N'           PEmbed
     C                   PARM      'ALPHA'       PVType
 
      ** If SD0811 returns 'INVAL' error
 
     C                   IF        PRtnCd = 'INVAL'
     C                   EVAL      *IN41 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9300'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Check trailing characters.
 
     C                   CALL      'SD0811'
     C                   PARM                    PString
     C                   PARM      10            PLength
     C                   PARM      *BLANKS       PRtnCd
     C                   PARM      'N'           PEmbed
     C                   PARM      'ANBLNK'      PVType
 
      ** If SD0811 returns 'INVAL' error
 
     C                   IF        PRtnCd = 'INVAL'
     C                   EVAL      *IN41 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9301'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Record must be unique.
 
     C                   IF        *IN41 = '0'
 
     C     #1HESN        CHAIN     SDHGSTL1
 
     C                   IF        %FOUND(SDHGSTL1)
     C                   EVAL      *IN41 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
 
      ** Record is flagged for deletion.
 
     C                   IF        FSCHTP = 'D'
     C                   EVAL      PZMsgID = 'USR9360'
     C                   ELSE
     C                   EVAL      PZMsgID = 'USR9302'
     C                   ENDIF
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** If no errors, set display of details screen.
 
     C                   IF        *IN41 = '0'
     C                   EVAL      WKeyScrn = 'N'
     C                   EVAL      WDetScrn = 'Y'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVHeld - Validate Hedge Description                          *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVHeld       BEGSR
 
      ** Hedge Description must be specified.
 
     C                   IF        #1HELD = *BLANKS
     C                   EVAL      *IN42 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9303'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVBrca - Validate Hedge Branch Code                         *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVBrca       BEGSR
 
      ** Branch Code must be specified.
 
     C                   IF        #1BRCA = *BLANKS
     C                   EVAL      *IN43 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9304'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   EVAL      PBRCA = #1BRCA
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PBRCA
     C     SDBRCH        PARM      SDBRCH        DSSDY
 
     C                   SELECT
 
      ** Branch Code must exist in the branch codes file.
 
     C                   WHEN      PRtrnCode = '*NRF   '
     C                   EVAL      *IN43 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9305'
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN43 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Branch Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      #1BRCA = A8BRCD
 
      ** Error on call to AOBRCHR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBRCHPD'
     C                   EVAL      DBKEY = PBRCA
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPrtp - Validate Hedge Product Type                        *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVPrtp       BEGSR
 
      ** Product Type must be 'FV', 'CF', or 'FX'.
      ** If Hedge Accounting (CAS004) is installed, disallow 'FX' as                          CAS004
      ** a Hedge Product Type.                                                                CAS004
 
     C                   IF        #1PRTP <> 'FV'  AND  #1PRTP <> 'CF'  AND
     C**********                   #1PRTP <> 'FX'                                             CAS004
     C                             #1PRTP <> 'FX' AND CAS004 = 'N'                            CAS004
     C                             OR (CAS004 = 'Y' AND #1PRTP <> 'FV'                        CAS004
     C                             AND #1PRTP <> 'CF')                                        CAS004
     C                   EVAL      *IN44 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      PZMsgID = 'USR9402'                                        CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      PZMsgID = 'USR9306'
     C                   ENDIF                                                                CAS004
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVPrst - Validate Hedge Product Sub-Type                    *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVPrst       BEGSR
 
      ** Product Sub-Type must be entered.
 
     C                   IF        #1PRST = *BLANKS
     C                   EVAL      *IN45 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9307'
     C                   EXSR      SRZasnms
 
     C                   ELSE
     C                   EVAL      PPRST = #1PRST
 
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PPRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   SELECT
 
      ** Sub-Type must exist in the Deal Sub-Types file.
 
     C                   WHEN      PRtrnCode = '*NRF   '
     C                   EVAL      *IN45 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9308'
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN45 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Branch Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      #1PRST = ASDSTC
 
      ** Error on call to AODLSTR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDLSTPD'
     C                   EVAL      DBKEY = PPRST
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVHrsk - Validate Hedge Risk                                *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVHrsk       BEGSR
 
      ** Hedge Risk must be 'A', 'I', 'E', 'P', or 'C'.
 
     C                   IF        #1HRSK <> 'A'  AND  #1HRSK <> 'I'  AND
     C                             #1HRSK <> 'E'  AND  #1HRSK <> 'P'  AND
     C                             #1HRSK <> 'C'
     C                   EVAL      *IN46 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9309'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEffm - Validate Effectiveness Measure                     *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVEffm       BEGSR
 
      ** Effectiveness Measure must be 'T', 'S', 'F', or 'I'.
 
     C                   IF        #1EFFM <> 'T'  AND  #1EFFM <> 'S'  AND
     C                             #1EFFM <> 'F'  AND  #1EFFM <> 'I'
     C                   EVAL      *IN47 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9310'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRVMeff - Validate Effectiveness Assessment                  *                       CAS006
      *                                                               *                       CAS006
      *  Called by: SRValidate                                        *                       CAS006
      *                                                               *                       CAS006
      *  Calls    :                                                   *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRVMeff       BEGSR                                                                CAS006
                                                                                              CAS006
      ** If CAS006 is on, Method of Hedge Effectiveness Assessment                            CAS006
      ** must be either 'D' or 'R'                                                            CAS006
                                                                                              CAS006
     C                   IF        #1MEFF <> 'D'  AND  #1MEFF <> 'R'                          CAS006
     C                   EVAL      *IN58 = '1'                                                CAS006
     C                   EVAL      WValid = 'N'                                               CAS006
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                     CAS006
     C                   EVAL      PZMsgID = 'USR9419'                                        CAS006
     C                   EXSR      SRZasnms                                                   CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEfup - Validate Effectiveness Upper Percentage            *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVEfup       BEGSR
 
      ** Effectiveness Upper Percentage must be greater than Lower Percentage.
 
     C                   IF        #1EFUP <= #1EFLO
     C                   EVAL      *IN48 = '1'
     C                   EVAL      *IN49 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9311'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEflo - Validate Effectiveness Lower Percentage            *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVEflo       BEGSR
 
      ** Effectiveness Lower Percentage must be greater zero.
 
     C                   IF        #1EFLO <= 0
     C                   EVAL      *IN49 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9312'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVEffq - Validate Effectiveness Frequency                   *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVEffq       BEGSR
 
      ** Effectiveness Frequency must be 'D', 'M', or 'Q'.
 
     C                   IF        #1EFFQ <> 'D'  AND  #1EFFQ <> 'M'  AND
     C                             #1EFFQ <> 'Q'
     C                   EVAL      *IN50 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9313'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVFsdt - Validate First Date                                *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVFsdt       BEGSR
 
     C                   SELECT
 
      ** First Date must be blank if Effectiveness Frequency is 'D'.
 
     C                   WHEN      #1EFFQ = 'D'  AND  #1FSDT <> *BLANKS
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9314'
     C                   EXSR      SRZasnms
 
      ** First Date cannot be amended if the previous value is earlier than rundate.
 
     C                   WHEN      #0ACTN = 'A'  AND  FSFSDT <> 0  AND
     C                             FSFSDT < BJRDNB  AND  #1FSDT <> WScrnFSDT
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9315'
     C                   EXSR      SRZasnms
     C                   EVAL      #1FSDT = WScrnFSDT
 
      ** If Effectiveness Frequency is 'M' or 'Q' and First Date
      ** is not entered, default to next working day.
 
     C                   WHEN      (#1EFFQ = 'M'  OR  #1EFFQ = 'Q')  AND
     C                             #1FSDT = *BLANKS
 
      ** Set up and call ZALIGN
 
     C                   CALL      'ZDATE2'
     C                   PARM      BJDNWD        PMidasDayNo
     C**********         PARM      *BLANKS       PDateFmt                                     213352
     C                   PARM      BJDFIN        PDateFmt                                     213352
     C                   PARM                    PDDMMYY
     C                   PARM      *BLANKS       PWorkDate
 
     C                   IF        PDDMMYY <> *ZERO
     C                   MOVE      PDDMMYY       #1FSDT
     C                   ENDIF
 
      ** If entered, First Date must be in valid date format.
 
     C                   WHEN      (#1EFFQ = 'M'  OR  #1EFFQ = 'Q')  AND
     C                             #1FSDT <> *BLANKS
 
      ** Set up and call ZALIGN
 
     C                   EVAL      PFieldIn = #1FSDT
 
     C                   CALL      'ZALIGN'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM                    PFieldIn
     C                   PARM      0             PDecimal
     C                   PARM      6             PDigits
     C                   PARM      *BLANKS       PFieldOut
 
      ** Date must be numeric.
 
     C                   IF        PRtrnCode = '*ERROR*'
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9316'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Call ZDATE1 to validate First Date
 
     C                   MOVE      PFieldOut     PDDMMYY
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM                    PDDMMYY
     C**********         PARM      *BLANKS       PDateFmt                                     213352
     C                   PARM      BJDFIN        PDateFmt                                     213352
     C                   PARM      *ZEROS        PMidasDayNo
 
      ** Date is invalid.
 
     C                   IF        PRtrnCode = '*ERROR*'
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9317'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Date must not be before rundate.
 
     C                   IF        PMidasDayNo < BJRDNB
     C                   IF        (#0ACTN = 'I'
     C                             OR  (#0ACTN = 'A' AND  #1FSDT <> WScrnFSDT))
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9318'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
      ** First Date cannot be amended to a date that is later than
      ** the Effective Date for any Hedge Linkage linked to this
      ** Hedge Strategy.
 
     C                   IF        *IN51 = '0'  AND  #0ACTN = 'A'  AND
     C                             #1FSDT <> WScrnFSDT
     C     #1HESN        SETLL     ASHGLKL2
     C     #1HESN        READE     ASHGLKL2
 
     C                   DOW       NOT %EOF(ASHGLKL2)
 
     C                   IF        A_FSRECI = 'D'  AND  PMidasDayNo > A_FSEFFD
     C                   EVAL      *IN51 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9319'
     C                   EXSR      SRZasnms
     C                   LEAVE
     C                   ENDIF
 
     C     #1HESN        READE     ASHGLKL2
     C                   ENDDO
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVDVT - Validate Derivative Types                           *
      *                                                               *
      *  Called by: SRValidate                                        *
      *                                                               *
      *  Calls    :                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRVDVT        BEGSR
 
     C                   OPEN      MKCTL
     C                   OPEN      INTYP
 
      ** Move Derivative Types to array.
      ** Initialize array index.
      ** Set Deal Type Entry Indicator to 'No'.
      ** Set valid Derivative Type entry indicator to 'No'.
 
     C                   MOVEA     WScrnDVT      ArrScrnDVT
     C                   EVAL      X = 0
     C                   EVAL      WDTIN = 'N'
     C                   EVAL      WVDVT = 'N'
 
      ** Validate each of 10 individual Derivative Types.
 
     C                   DO        10
     C                   EVAL      X = X + 1
 
      ** Error if trying to amend an existing Derivative Type
      ** but linkages to Hedge Transactions exist for deals with this
      ** Derivative Type; skip further validations.
 
     C                   IF        #0ACTN = 'A'  AND
     C                             ArrFileDVT(X)  <>  *BLANKS  AND
     C                             ArrScrnDVT(X)  <>  ArrFileDVT(X)
     C                   EVAL      WDType = 'DT'
     C                   EVAL      WPOS = ArrFileDVT(X)
     C                   EXSR      SRChkLink
 
     C                   IF        WLink = 'Y'
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9320'
     C                   EVAL      PZMsgData = ArrFileDVT(X)
     C                   EXSR      SRZasnms
     C                   MOVE      ArrFileDVT(X) ArrScrnDVT(X)
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** If Derivative Type is blank, skip further validations.
 
     C                   IF        ArrScrnDVT(X) = *BLANKS
     C                   ITER
     C                   ENDIF
 
     C                   EVAL      WPOS = ArrScrnDVT(X)
 
      ** Condition: Positions 1-2 are blank.
      ** -- If pos. 1-2 are blank, error; skip further validations.
 
     C                   IF        WP1X2 = *BLANKS
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9321'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** Condition: Pos. 1-2 are entered, pos. 3-10 are blank.
      ** Derivative Type is a derivative Deal Type.
 
     C                   IF        WP1X2 <> *BLANKS  AND  WP3X10 = *BLANKS
 
      ** -- If pos. 1-2 are not 'RS'/'RX'/'CX'
      **     error; skip further validations.
      ** -- Else, valid entry; skip further validations.
 
     C                   IF        WP1X2 <> 'RS'  AND  WP1X2 <> 'RX'  AND
     C**********                   WP1X2 <> 'CX'                                              CAS006
     C                             WP1X2 <> 'CX' AND CAS006 = 'N' OR                          CAS006
     C                             WP1X2 <> 'RS'  AND  WP1X2 <> 'RX'  AND                     CAS006
     C                             WP1X2 <> 'CX' AND WP1X2 <> 'FR' AND                        CAS006
     C                             WP1X2 <> '**' AND                                          CAS006
     C                             CAS006 = 'Y' OR                                            CAS006
     C                             WP1X2 <> 'RS'  AND  WP1X2 <> 'RX'  AND                     CAS006
     C                             WP1X2 <> 'FR' AND #1MEFF = 'R' AND                         CAS006
     C                             WP1X2 <> '**' AND                                          CAS006
     C                             CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9321'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
 
      ** Condition: Pos. 1-2 are entered, pos. 3-10 are not blank.
      ** Derivative Type is a Futures & Options Position.
 
     C                   ELSE
     C                   EVAL      WDTIN = 'Y'
     C                   EVAL      WVDVT = 'Y'
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** Condition: Pos. 1-2 are entered, Pos. 3 is '*' (wildcard).
 
     C                   IF        WP1X2 <> *BLANKS  AND  WP3 = '*'
 
      ** -- If pos. 4-10 is not blank,
      **     error; skip further validations.
 
     C                   IF        WP4X10 <> *BLANKS
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9321'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** -- If pos. 1-2 is not a valid Market Centre,
      **     error; skip further validations.
      ** -- Else, valid entry; skip further validations.
 
     C                   EVAL      MK_MRKT = WP1X2
 
     C     MK_MRKT       CHAIN     MKCTL
     C                   IF        NOT %FOUND(MKCTL)  OR
     C                             (%FOUND(MKCTL)  AND  MK_RECI <> 'D')
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9322'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
 
     C                   ELSE
                                                                                              CAS003
      ** Futures and Options entry is valid only if enhancement CAS003 is on.                 CAS003
                                                                                              CAS003
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                   EVAL      WVDVT = 'Y'
     C                   ITER
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      *IN52 = '1'                                                CAS003
     C                   EVAL      WValid = 'N'                                               CAS003
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                     CAS003
     C                   EVAL      PZMsgID = 'USR9369'                                        CAS003
     C                   EVAL      PZMsgData = ArrScrnDVT(X)                                  CAS003
     C                   EXSR      SRZasnms                                                   CAS003
     C                   ITER                                                                 CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF
 
     C                   ENDIF
 
      ** Condition: Pos. 1-2 are entered, Pos. 3-5 are entered.
 
     C     WP1X5         IFNE      *BLANKS
 
      ** -- If pos. 1-5 is not a valid Instrument Type,
      **     error; skip further validations.
 
     C                   MOVEL     WP1X5         IT_ISTT
 
     C     IT_ISTT       CHAIN     INTYP
     C                   IF        NOT %FOUND(INTYP)  OR
     C                             (%FOUND(INTYP)  AND  IT_RECI <> 'D')
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9323'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** -- If Instrument Indicator is 'Y' (OTC) and pos. 6-10 are not blank,
      **     error; skip further validations.
 
     C     IT_ISTI       IFEQ      'Y'
     C     WP6X10        IFNE      *BLANKS                                                    CAS003
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9324'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
      ** Futures and Options entry is valid only if enhancement CAS003 is on.                 CAS003
                                                                                              CAS003
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                   EVAL      WVDVT = 'Y'                                                CAS003
     C                   ITER                                                                 CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      *IN52 = '1'                                                CAS003
     C                   EVAL      WValid = 'N'                                               CAS003
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                     CAS003
     C                   EVAL      PZMsgID = 'USR9369'                                        CAS003
     C                   EVAL      PZMsgData = ArrScrnDVT(X)                                  CAS003
     C                   EXSR      SRZasnms                                                   CAS003
     C                   ITER                                                                 CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF
 
      ** -- If Instrument Indicator is 'N' (Market) and pos. 6-10 are blank,
      **     error; skip further validations.
 
     C     IT_ISTI       IFEQ      'N'
     C     WP6X10        ANDEQ     *BLANK
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9325'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
     C                   ENDIF
 
      ** Condition: Pos. 1-5 are entered, Pos. 6 is '*' (wildcard).
 
     C     WP1X5         IFNE      *BLANK
     C     WP6           ANDEQ     '*'
 
      ** -- If pos. 7-10 is not blank,
      **     error; skip further validations.
 
     C     WP7X10        IFNE      *BLANK
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9321'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
 
      ** -- If pos. 7-10 is blank,
      **     valid entry; skip further validations.
 
     C                   ELSE
                                                                                              CAS003
      ** Futures and Options entry is valid only if enhancement CAS003 is on.                 CAS003
                                                                                              CAS003
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                   MOVE      'Y'           WVDVT
     C                   ITER
     C                   ELSE                                                                 CAS003
     C                   EVAL      *IN52 = '1'                                                CAS003
     C                   EVAL      WValid = 'N'                                               CAS003
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                     CAS003
     C                   EVAL      PZMsgID = 'USR9369'                                        CAS003
     C                   EVAL      PZMsgData = ArrScrnDVT(X)                                  CAS003
     C                   EXSR      SRZasnms                                                   CAS003
     C                   ITER                                                                 CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF
     C                   ENDIF
 
      ** Condition: Pos. 1-5 are entered, Pos. 6-10 are entered.
 
     C     WP1X5         IFNE      *BLANKS
     C     WP6X10        ANDNE     *BLANKS
 
      ** -- If pos. 6-8 are not valid month,
      **     error; skip further validations.
 
     C     WP6X8         LOOKUP    TABNAM        TABNUM                   89
     C     *IN89         IFEQ      *OFF
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9326'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** -- If pos. 6-8 are not quoted month for Instrument Type,
      **     error; skip further validations.
 
     C                   Z-ADD     TABNUM        Y
     C                   MOVEA     IT_ISMQ       ArrIMQ
     C     ArrIMQ(Y)     IFNE      'Y'
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9327'
     C                   EVAL      PZMsgData = ArrScrnDVT(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** -- If pos. 9-10 are not valid year,
      **     error; skip further validations.
      ** -- Else, valid entry; skip further validations.
 
     C     WP9           IFLT      '0'
     C     WP9           ORGT      '9 '
     C     WP10          ORLT      '0'
     C     WP10          ORGT      '9 '
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9326'
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** Futures and Options entry is valid only if enhancement CAS003 is on.                 CAS003
                                                                                              CAS003
     C                   IF        CAS003 = 'Y'                                               CAS003
     C                   MOVE      'Y'           WVDVT
     C                   ELSE                                                                 CAS003
     C                   EVAL      *IN52 = '1'                                                CAS003
     C                   EVAL      WValid = 'N'                                               CAS003
     C                   EVAL      PZMsgFile = 'SDUSRMSG'                                     CAS003
     C                   EVAL      PZMsgID = 'USR9369'                                        CAS003
     C                   EVAL      PZMsgData = ArrScrnDVT(X)                                  CAS003
     C                   EXSR      SRZasnms                                                   CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF
 
     C                   ENDDO
 
      ** Derivative Types may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileDVT(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnDVT(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9361'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Derivative Type array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnDVT    WScrnDVT
 
      ** Validate full set of 10 Derivative Types.
      ** Error if no Derivative Type has been entered.
 
     C     WScrnDVT      IFEQ      *BLANKS
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9328'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Error if any of the 10 Derivative Types is a duplicate.
 
     C                   Z-ADD     *ZERO         X
 
     C                   DO        10
     C                   ADD       1             X
 
     C     ArrScrnDVT(X) IFNE      *BLANKS
     C                   MOVE      ArrScrnDVT(X) WTest10
     C                   MOVEA     ArrScrnDVT    ArrTemp10
     C                   MOVE      *BLANKS       ArrTemp10(X)
     C     WTest10       LOOKUP    ArrTemp10(1)                           89
 
     C     *IN89         IFEQ      '1'
     C                   EVAL      *IN52 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9329'
     C                   EVAL      PZMsgData = WTest10
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDDO
 
     C                   CLOSE     MKCTL
     C                   CLOSE     INTYP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVDst - Validate Derivative Sub-Types                        *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVDst        BEGSR
 
      ** Move Sub-Types to array.
      ** Initialize array index.
 
     C                   MOVEA     WScrnDST      ArrScrnDST
     C                   Z-ADD     *ZERO         X
 
      ** Validate each of 10 individual Derivative Sub-Types.
 
     C                   DO        10
     C                   ADD       1             X
 
      ** Error if Sub-Type has been entered
      ** but no Derivative Type is a Deal Type
 
     C     ArrScrnDST(X) IFNE      *BLANK
     C     WDTIN         ANDEQ     'N'
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9330'
     C                   EXSR      SRZasnms
     C                   ITER
     C                   ENDIF
 
      ** Error if trying to amend an existing Sub-Type
      ** but linkages to Hedge Transactions exist for deals with this
      ** Sub-Type; skip further validations.
 
     C     #0ACTN        IFEQ      'A'
     C     ArrFileDST(X) ANDNE     *BLANK
     C     ArrScrnDST(X) ANDNE     ArrFileDST(X)
     C                   MOVE      'DS'          WDType
     C                   EXSR      SRChkLink
     C     WLink         IFEQ      'Y'
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9331'
     C                   EVAL      PZMsgData = ArrFileDST(X)
     C                   EXSR      SRZasnms
     C                   ITER
     C                   MOVE      ArrFileDST(X) ArrScrnDST(X)
     C                   ENDIF
     C                   ENDIF
 
      ** No further validation if Sub-Type is blank or '**'.
 
     C     ArrScrnDST(X) IFEQ      '**'
     C     ArrScrnDST(X) OREQ      *BLANK
     C                   ITER
     C                   ENDIF
 
      ** Validate entry.
 
     C                   EVAL      PPRST = ArrScrnDST(X)
 
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PPRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   SELECT
 
      ** Sub-Type must exist in the Deal Sub-Types file.
 
     C                   WHEN      PRtrnCode = '*NRF   '
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9332'
     C                   EVAL      PZMsgData = ArrScrnDST(X)
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Branch Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      ArrScrnDST(X) = ASDSTC
 
      ** Error on call to AODLSTR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDLSTPD'
     C                   EVAL      DBKEY = PPRST
     C                   EVAL      DBASE = 3
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDDO
 
      ** Derivative Sub-Types may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileDST(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnDST(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9362'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Sub-Type array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnDST    WScrnDST
 
      ** Validate full set of 10 Derivative Sub-Types.
 
      ** Error if Derivative Type is a Deal Type
      ** but no Sub-Type has been entered.
 
     C     WDTIN         IFEQ      'Y'
     C     WScrnDST      ANDEQ     *BLANK
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9333'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** If wildcard '**' is entered, it must be the only Sub-Type.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnDST(X) IFEQ      '**'
     C                   MOVEA     ArrScrnDST    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C                   MOVEA     ArrTemp2      WTest20
     C     WTest20       IFNE      *BLANK
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9334'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Error if any of the 10 Sub-Types is a duplicate.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnDST(X) IFNE      *BLANK
     C                   MOVE      ArrScrnDST(X) WTest2
     C                   MOVEA     ArrScrnDST    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C     WTest2        LOOKUP    ArrTemp2(1)                            89
     C     *IN89         IFEQ      *ON
     C                   EVAL      *IN53 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9335'
     C                   EVAL      PZMsgData = WTest2
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVDbk - Validate Derivative Book Code                        *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVDbk        BEGSR
 
      ** Move Book Codes to array.
      ** Initialize array index.
 
     C                   MOVEA     WScrnDBK      ArrScrnDBK
     C                   Z-ADD     *ZERO         X
 
      ** Validate each of 10 individual Derivative Book Codes.
 
     C                   DO        10
     C                   ADD       1             X
 
      ** Error if trying to amend an existing Book Code
      ** but linkages to Hedge Transactions exist for deals with this
      ** Book Code; skip further validations.
 
     C     #0ACTN        IFEQ      'A'
     C     ArrFileDBK(X) ANDNE     *BLANK
     C     ArrScrnDBK(X) ANDNE     ArrFileDBK(X)
     C                   MOVE      'DB'          WDType
     C                   EXSR      SRChkLink
 
     C     WLink         IFEQ      'Y'
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9336'
     C                   EVAL      PZMsgData = ArrFileDBK(X)
     C                   EXSR      SRZasnms
     C                   MOVE      ArrFileDBK(X) ArrScrnDBK(X)
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** No further validation if Book Code is blank or '**'.
 
     C     ArrScrnDBK(X) IFEQ      '**'
     C     ArrScrnDBK(X) OREQ      *BLANK
     C                   ITER
     C                   ENDIF
 
      ** Validate entry.
 
     C                   EVAL      PDBK = ArrScrnDBK(X)
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PDBK
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   SELECT
 
      ** Book Code must exist in the Book Codes file.
 
     C                   WHEN      PRtrnCode = '*NRF'
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9337'
     C                   EVAL      PZMsgData = ArrScrnDBK(X)
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Book Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      ArrScrnDBK(X) = BDBKCD
 
      ** Error on call to AOBOOKR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBKEY = PDBK
     C                   EVAL      DBASE = 4
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDDO
 
      ** Derivative Book Codes may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileDBK(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnDBK(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9363'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Book Code array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnDBK    WScrnDBK
 
      ** Validate full set of 10 Derivative Book Codes.
      ** Error if no Book Code has been entered.
 
     C     WScrnDBK      IFEQ      *BLANK
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9338'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** If wildcard '**' is entered, it must be the only Book Code.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
 
     C     ArrScrnDBK(X) IFEQ      '**'
     C                   MOVEA     ArrScrnDBK    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C                   MOVEA     ArrTemp2      WTest20
     C     WTest20       IFNE      *BLANK
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9339'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Error if any of the 10 Book Codes is a duplicate.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
 
     C     ArrScrnDBK(X) IFNE      *BLANK
     C                   MOVE      ArrScrnDBK(X) WTest2
     C                   MOVEA     ArrScrnDBK    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C     WTest2        LOOKUP    ArrTemp2(1)                            89
     C     *IN89         IFEQ      *ON
     C                   EVAL      *IN54 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9340'
     C                   EVAL      PZMsgData = WTest2
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVHdt - Validate Hedged Deal Types/Investment Types          *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVHdt        BEGSR
 
     C                   OPEN      SDLOANL1
     C                   OPEN      INVTO
 
      ** Move Hedged Deal/Investment Types to array.
      ** Initialize array index.
      ** Set Deal Type Indicator to 'No'.
      ** Set Loan Type Indicator to 'No'.
      ** Set Investment Type Indicator to 'No'.
      ** Set valid Deal/Investment Type entry indicator to 'No'.
 
     C                   MOVEA     WScrnHDT      ArrScrnHDT
     C                   Z-ADD     *ZERO         X
     C                   MOVE      'N'           WDTI
     C                   MOVE      'N'           WLTI
     C                   MOVE      'N'           WITI
     C                   MOVE      'N'           WLDIN                                        227674
     C                   MOVE      'N'           WVHDT
 
      ** Validate each of 10 individual Hedged Deal/Investment Types.
 
     C                   DO        10
     C                   ADD       1             X
 
      ** Error if trying to amend an existing Deal/Investment Type
      ** but linkages to Hedge Transactions exist for deals with this
      ** Deal/Investment Type; skip further validations.
 
     C     #0ACTN        IFEQ      'A'
     C     ArrFileHDT(X) ANDNE     *BLANK
     C     ArrScrnHDT(X) ANDNE     ArrFileHDT(X)
     C                   MOVE      'HT'          WDType
     C                   EXSR      SRChkLink
     C     WLink         IFEQ      'Y'
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9341'
     C                   EVAL      PZMsgData = ArrFileHDT(X)
     C                   EXSR      SRZasnms
     C                   MOVE      ArrFileHDT(X) ArrScrnHDT(X)
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** If Deal/Investment Type is blank or '***' or '**',
      ** skip further validations.
 
     C     ArrScrnHDT(X) IFEQ      '***'
     C     ArrScrnHDT(X) OREQ      '**'
     C     ArrScrnHDT(X) OREQ      *BLANK
     C     ArrScrnHDT(X) IFEQ      '**'                                                       227674
     C                   EVAL      WLDIN = 'Y'                                                227674
     C                   ENDIF                                                                227674
     C                   ITER
     C                   ENDIF
 
      ** If Deal/Investment Type is a valid Deal Type,
      ** set Deal Type Indicator to 'Yes',
      ** set valid Deal/Investment Type entry indicator to 'Yes',
      ** skip further validations.
 
     C     ArrScrnHDT(X) IFEQ      'IT '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'IP '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'TD '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'TI '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'CI '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'CD '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'CL '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'DL '                                        MM Loans/Deps
     C     ArrScrnHDT(X) OREQ      'C1 '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'C2 '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'BP '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'BD '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'TB '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'DA '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'TA '                                        NAs Purchased
     C     ArrScrnHDT(X) OREQ      'CS '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'BS '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'BR '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'TS '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'RA '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'TR '                                        NAs Sold
     C     ArrScrnHDT(X) OREQ      'FS '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'FP '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'PS '                                        Intrnl Contract
     C     ArrScrnHDT(X) OREQ      'OP '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'OT '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'SW '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'SI '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'PI '                                        Fgn Exchange
     C     ArrScrnHDT(X) OREQ      'FH '                                        Forecast Hedged
     C     ArrScrnHDT(X) OREQ      'CF '                                                      CDL033
     C     CAS006        ANDEQ     'N'                                                        CAS006
     C     CAS006        OREQ      'Y'                                                        CAS006
     C     #1MEFF        ANDNE     'R'                                                        CAS006
     C     ArrScrnHDT(X) ANDEQ     'FH '                                                      CAS006
     C     CAS006        OREQ      'Y'                                                        CDL033
     C     #1MEFF        ANDNE     'R'                                                        CDL033
     C     ArrScrnHDT(X) ANDEQ     'CF '                                                      CDL033
     C                   MOVE      'Y'           WDTI
     C                   MOVE      'Y'           WVHDT
     C                   ITER
     C                   ENDIF
 
      ** If SAR CDL006 is turned on,
      ** and Deal/Investment Type is a valid Fiduciary Deal Type,
      ** set Deal Type Indicator to 'Yes',
      ** set valid Deal/Investment Type entry indicator to 'Yes',
      ** skip further validations.
 
     C     CDL006        IFEQ      'Y'                                          SAR CDL006
     C     ArrScrnHDT(X) IFEQ      'FL '                                        Fiduciary Deal
     C     ArrScrnHDT(X) OREQ      'FT '                                        Fiduciary Deal
     C     ArrScrnHDT(X) OREQ      'DT '                                        Fiduciary Deal
     C     ArrScrnHDT(X) OREQ      'LT '                                        Fiduciary Deal
     C     ArrScrnHDT(X) OREQ      'DP '                                        Fiduciary Deal
     C     ArrScrnHDT(X) OREQ      'LP '                                        Fiduciary Deal
     C                   MOVE      'Y'           WDTI
     C                   MOVE      'Y'           WVHDT
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** If Deal/Investment Type is a valid Loan Type,
      ** set Loan Type Indicator to 'Yes',
      ** set valid Deal/Investment Type entry indicator to 'Yes',
      ** skip further validations.
 
     C                   EVAL      WrkHDT = ArrScrnHDT(X)
 
     C                   IF        WrkHDT3 = *BLANK
     C                   EVAL      AYLNTY = ArrScrnHDT(X)
 
     C     AYLNTY        SETLL     SDLOANL1
     C                   IF        %EQUAL(SDLOANL1)
     C                   MOVE      'Y'           WLTI
     C                   MOVE      'Y'           WVHDT
     C                   ITER
     C                   ENDIF
 
      ** If Deal/Investment Type is a valid Investment Type,
      ** set Investment Type Indicator to 'Yes',
      ** set valid Deal/Investment Type entry indicator to 'Yes',
      ** skip further validations.
 
     C                   ELSE
 
     C                   EVAL      TP_INVT = ArrScrnHDT(X)
     C     TP_INVT       CHAIN     INVTO
     C                   IF        %FOUND(INVTO)
     C                   MOVE      'Y'           WITI
     C                   MOVE      'Y'           WVHDT
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** Deal/Investment Type is invalid;
      ** i.e, it is not a valid entry or blank or '**' or '***'.
 
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9342'
     C                   EVAL      PZMsgData = ArrScrnHDT(X)
     C                   EXSR      SRZasnms
 
     C                   ENDDO
 
      ** Hedged Deal/Loan Types/Investment Types may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileHDT(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnHDT(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9364'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Deal/Investment Type array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnHDT    WScrnHDT
 
      ** Validate full set of 10 Hedged Deal/Investment Types.
      ** Error if no Deal/Investment Type has been entered.
 
     C     WScrnHDT      IFEQ      *BLANK
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9343'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** Error if any of the 10 Deal/Investment Types is a duplicate.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHDT(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHDT(X) WTest3
     C                   MOVEA     ArrScrnHDT    ArrTemp3
     C                   MOVE      '   '         ArrTemp3(X)
     C     WTest3        LOOKUP    ArrTemp3(1)                            89
     C     *IN89         IFEQ      *ON
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9344'
     C                   EVAL      PZMsgData = WTest3
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Error if wildcard '**' is entered, and a valid Deal Type
      ** or Loan Type has been entered.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHDT(X) IFEQ      '**'
     C     WDTI          ANDEQ     'Y'
     C     ArrScrnHDT(X) OREQ      '**'
     C     WLTI          ANDEQ     'Y'
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9345'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDDO
 
      ** Error if wildcard '***' is entered, and a valid
      ** Investment Type has been entered.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHDT(X) IFEQ      '***'
     C     WITI          ANDEQ     'Y'
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9346'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDDO
 
     C                   CLOSE     SDLOANL1
     C                   CLOSE     INVTO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVHst - Validate Hedged Deal Sub-Type                        *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVHst        BEGSR
 
      ** Move Sub-Types to array.
      ** Initialize array index.
 
     C                   MOVEA     WScrnHST      ArrScrnHST
     C                   Z-ADD     *ZERO         X
 
      ** Validate each of 10 individual Hedged Deal Sub-Types.
 
     C                   DO        10
     C                   ADD       1             X
 
      ** Error if trying to amend an existing Sub-Type
      ** but linkages to Hedge Transactions exist for deals with this
      ** Sub-Type; skip further validations.
 
     C     #0ACTN        IFEQ      'A'
     C     ArrFileHST(X) ANDNE     *BLANK
     C     ArrScrnHST(X) ANDNE     ArrFileHST(X)
     C                   MOVE      'HS'          WDType
     C                   EXSR      SRChkLink
     C     WLink         IFEQ      'Y'
     C                   EVAL      *IN55 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9347'
     C                   EVAL      PZMsgData = ArrFileHST(X)
     C                   EXSR      SRZasnms
     C                   MOVE      ArrFileHST(X) ArrScrnHST(X)
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** No further validation if Sub-Type is blank or '**'.
 
     C     ArrScrnHST(X) IFEQ      '**'
     C     ArrScrnHST(X) OREQ      *BLANK
     C                   ITER
     C                   ENDIF
 
      ** Validate entry.
 
     C                   EVAL      PPRST = ArrScrnHST(X)
 
     C                   CALLB     'AODLSTR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PPRST
     C     SDDLST        PARM      SDDLST        DSFDY
 
     C                   SELECT
 
      ** Sub-Type must exist in the Deal Sub-Types file.
 
     C                   WHEN      PRtrnCode = '*NRF   '
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9348'
     C                   EVAL      PZMsgData = ArrScrnHST(X)
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Branch Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      ArrScrnHST(X) = ASDSTC
 
      ** Error on call to AODLSTR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDDLSTPD'
     C                   EVAL      DBKEY = PPRST
     C                   EVAL      DBASE = 5
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDDO
 
      ** Hedged Deal/Loan Sub-Types may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileHST(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnHST(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9365'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Sub-Type array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnHST    WScrnHST
 
      ** Validate full set of 10 Hedged Deal Sub-Types.
      ** Error if a Deal Type or Loan Type was entered
      ** as a Hedged Deal/Investment Type
      ** but no Hedged Deal Sub-Type has been entered.
 
     C     WDTI          IFEQ      'Y'
     C     WScrnHST      ANDEQ     *BLANK
     C     WLTI          OREQ      'Y'
     C     WScrnHST      ANDEQ     *BLANK
     C     WLDIN         OREQ      'Y'                                                        227674
     C     WScrnHST      ANDEQ     *BLANK                                                     227674
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9349'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** If wildcard '**' is entered, it must be the only Sub-Type.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHST(X) IFEQ      '**'
     C                   MOVEA     ArrScrnHST    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C                   MOVEA     ArrTemp2      TEST20           20
     C     TEST20        IFNE      *BLANK
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9350'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Error if any of the 10 Sub-Types is a duplicate.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHST(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHST(X) WTest2            2
     C                   MOVEA     ArrScrnHST    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C     WTest2        LOOKUP    ArrTemp2(1)                            89
     C     *IN89         IFEQ      *ON
     C                   EVAL      *IN56 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9351'
     C                   EVAL      PZMsgData = WTest2
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRVHbk - Validate Hedged Deal Book Code                       *
      *                                                               *
      * Called by: SRValidate                                         *
      *                                                               *
      * Calls    :                                                    *
      *                                                               *
      *****************************************************************
 
     C     SRVHbk        BEGSR
 
      ** Move Book Codes to array.
      ** Initialize array index.
 
     C                   MOVEA     WScrnHBK      ArrScrnHBK
     C                   Z-ADD     *ZERO         X
 
      ** Validate each of 10 individual Hedged Deal Book Codes.
 
     C                   DO        10
     C                   ADD       1             X
 
      ** Error if trying to amend an existing Book Code
      ** but linkages to Hedge Transactions exist for deals with this
      ** Book Code; skip further validations.
 
     C     #0ACTN        IFEQ      'A'
     C     ArrFileHBK(X) ANDNE     *BLANK
     C     ArrScrnHBK(X) ANDNE     ArrFileHBK(X)
     C                   MOVE      'HB'          WDType
     C                   EXSR      SRChkLink
     C     WLink         IFEQ      'Y'
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9352'
     C                   EVAL      PZMsgData = ArrFileHBK(X)
     C                   EXSR      SRZasnms
     C                   MOVE      ArrFileHBK(X) ArrScrnHBK(X)
     C                   ITER
     C                   ENDIF
     C                   ENDIF
 
      ** No further validation if Book Code is blank or '**'.
 
     C     ArrScrnHBK(X) IFEQ      '**'
     C     ArrScrnHBK(X) OREQ      *BLANK
     C                   ITER
     C                   ENDIF
 
      ** Validate entry.
 
     C                   EVAL      PDBK = ArrScrnHBK(X)
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*KEY   '     POption
     C                   PARM                    PDBK
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C                   SELECT
 
      ** Book Code must exist in the Book Codes file.
 
     C                   WHEN      PRtrnCode = '*NRF'
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9353'
     C                   EVAL      PZMsgData = ArrScrnHBK(X)
     C                   EXSR      SRZasnms
 
      ** Error if entry is '?' but no value selected.
 
     C                   WHEN      PRtrnCode = '*NOSEL '
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0016'
     C                   EXSR      SRZasnms
 
      ** Book Code is valid or a selection has been made.
 
     C                   WHEN      PRtrnCode = *BLANKS
     C                   EVAL      ArrScrnHBK(X) = BDBKCD
 
      ** Error on call to AOBOOKR0.
 
     C                   OTHER
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBOOKPD'
     C                   EVAL      DBKEY = PDBK
     C                   EVAL      DBASE = 6
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDSL
 
     C                   ENDDO
 
      ** Hedged Book Codes may not be deleted.
 
     C                   IF        #0ACTN = 'A'
     C                   EVAL      X = 0
     C                   EVAL      Y = 0
     C                   EVAL      WCtrFile = 0
     C                   EVAL      WCtrScrn = 0
 
     C                   DOW       X < 10
     C                   EVAL      X = X + 1
     C                   EVAL      Y = Y + 1
 
     C                   IF        ArrFileHBK(X) <> *BLANKS
     C                   EVAL      WCtrFile = WCtrFile + 1
     C                   ENDIF
 
     C                   IF        ArrScrnHBK(X) <> *BLANKS
     C                   EVAL      WCtrScrn = WCtrScrn + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   IF        WCtrFile > WCtrScrn
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9366'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
      ** Move Book Code array (which may have been updated)
      ** back to screen fields.
 
     C                   MOVEA     ArrScrnHBK    WScrnHBK
 
      ** Validate full set of 10 Hedged Deal Book Codes.
      ** Error if no Book Code has been entered.
 
     C     WScrnHBK      IFEQ      *BLANK
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9354'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
      ** If wildcard '**' is entered, it must be the only Book Code.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHBK(X) IFEQ      '**'
     C                   MOVEA     ArrScrnHBK    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C                   MOVEA     ArrTemp2      WTest20
     C     WTest20       IFNE      *BLANK
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9355'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
      ** Error if any of the 10 Book Codes is a duplicate.
 
     C                   Z-ADD     *ZERO         X
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHBK(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHBK(X) WTest2
     C                   MOVEA     ArrScrnHBK    ArrTemp2
     C                   MOVE      '  '          ArrTemp2(X)
     C     WTest2        LOOKUP    ArrTemp2(1)                            89
     C     *IN89         IFEQ      *ON
     C                   EVAL      *IN57 = '1'
     C                   EVAL      WValid = 'N'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9356'
     C                   EVAL      PZMsgData = WTest2
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkLink - Check Hedge Linkage                               *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDelReq, SRMove, SRClrScrn                        *
      *                                                               *
      *****************************************************************
 
     C     SRChkLink     BEGSR
 
     C                   OPEN      SECTY
     C                   OPEN      CLOAN
     C                   OPEN      DEALSL
     C                   OPEN      DEALALL
 
      ** Input to subroutine is Field Type:
      **   'DT' = Derivative Type
      **   'DS' = Derivative Sub-Type
      **   'DB' = Derivative Book Code
      **   'HT' = Hedged Deal/Investment Type
      **   'HS' = Hedged Deal Sub-Type
      **   'HB' = Hedged Deal Book Code
 
      ** Set up Derivative/Hedged Indicator ('D' or 'H').
      ** Initialize linkage indicator to 'No'.
 
     C                   MOVEL     WDType        WDHIN
     C                   MOVE      'N'           WLink
 
      ** Do any live Hedge Linkages exist?
      ** Start reading Hedge Linkages file for this Hedge Strategy.
 
     C                   MOVEL     #1HESN        A_FSHGST
     C     A_FSHGST      SETLL     ASHGLKL2
     C     A_FSHGST      READE     ASHGLKL2
 
      ** If there is a live Hedge Linkage,
      ** Are there any transactions for the Hedge Linkage?
      ** Start reading Hedge Transactions file.
 
     C                   DOW       NOT %EOF(ASHGLKL2)
     C     A_FSRECI      IFEQ      'D'
 
     C                   MOVEL     A_FSHEDI      B_FSHEDI
     C                   MOVEL     WDHIN         B_FSDHIN
     C     KLUJTR        SETLL     ASHTRNL1
     C     KLUJTR        READE     ASHTRNL1
 
      ** If there is a Hedge Transaction, access the transaction
      **   record.
 
     C                   DOW       NOT %EOF(ASHTRNL1)
 
      ** If the Hedge Transaction record is a Derivative
      ** and the Derivative Deal Module is 'DL' then access
      ** Midas FRA/IRS deals (DEALSDG) and FX deals (DEALSDB).
      ** If the accessed deal has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'D'
     C     B_FSMOD       ANDEQ     'DL'
     C*****B_FSDLNO      CHAIN     DEALSL                                                     CLE148
     C                   MOVEL     B_FSDLNO      B_FSDLNOA                                    CLE148
     C     B_FSDLNOA     CHAIN     DEALSL                                                     CLE148
     C                   IF        %FOUND(DEALSL)
     C     WDType        IFEQ      'DT'
     C     WP3X10        ANDEQ     *BLANK
     C     WP1X2         ANDEQ     DTYP
     C     WDType        OREQ      'DS'
     C     ArrFileDST(X) ANDEQ     DLST
     C     WDType        OREQ      'DS'
     C     ArrFileDST(X) ANDEQ     '**'
     C     WDType        OREQ      'DB'
     C     ArrFileDBK(X) ANDEQ     BOKC
     C     WDType        OREQ      'DB'
     C     ArrFileDBK(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If the Hedge Transaction record is a Derivative
      ** and the Derivative Deal Module is 'FF' then check
      ** the linked transaction.
      ** If the linked transaction has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'D'
     C     B_FSMOD       ANDEQ     'FF'
     C     WDType        IFEQ      'DT'
     C                   EVAL      WVar2 = B_FSFPSE
     C                   EVAL      WVar5 = B_FSFPSE
     C                   ENDIF
     C     WDType        IFEQ      'DT'
     C     ArrFileDVT(X) ANDEQ     B_FSFPSE
     C     WDType        OREQ      'DT'
     C     WP3           ANDEQ     '*'
     C     WP1X2         ANDEQ     WVar2
     C     WDType        OREQ      'DT'
     C     WP6           ANDEQ     '*'
     C     WP1X5         ANDEQ     WVar5
     C     WDType        OREQ      'DB'
     C     ArrFileDBK(X) ANDEQ     B_FSBKCD
     C     WDType        OREQ      'DB'
     C     ArrFileDBK(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
      ** If the Hedge Transaction record is a Hedge
      ** and the Derivative Deal Module is 'DL' then access
      ** Midas FX/MM deals (DEALSDB/DEALSDC/DEALSDD/DEALSDE).
      ** If the accessed deal has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'H'
     C     B_FSMOD       ANDEQ     'DL'
     C*****B_FSDLNO      CHAIN     DEALALL                                                    CLE148
     C                   MOVEL     B_FSDLNO      B_FSDLNOA                                    CLE148
     C     B_FSDLNOA     CHAIN     DEALALL                                                    CLE148
     C                   IF        %FOUND(DEALALL)
     C     WDType        IFEQ      'HT'
     C                   EVAL      WVar2 = ArrFileHDT(X)
     C                   EVAL      WVar1 = ArrFileHDT(X)
     C                   ENDIF
     C     WDType        IFEQ      'HT'
     C     WVar1         ANDEQ     *BLANK
     C     WVar2         ANDEQ     DTYP
     C     WDType        OREQ      'HT'
     C     ArrFileHDT(X) ANDEQ     '** '
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     DLST
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     '**'
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     BOKC
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If the Hedge Transaction record is a Hedge
      ** and the Derivative Deal Module is 'LE' then access
      ** Midas LE loans.
      ** If the accessed loan has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'H'
     C     B_FSMOD       ANDEQ     'LE'
     C     B_FSDLNO      CHAIN     CLOAN
     C                   IF        %FOUND(CLOAN)
     C     WDType        IFEQ      'HT'
     C                   EVAL      WVar2 = ArrFileHDT(X)
     C                   EVAL      WVar1 = ArrFileHDT(X)
     C                   ENDIF
     C     WDType        IFEQ      'HT'
     C     WVar1         ANDEQ     *BLANK
     C     WVar2         ANDEQ     LTYP
     C     WDType        OREQ      'HT'
     C     ArrFileHDT(X) ANDEQ     '** '
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     SUTP
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     '**'
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     BOKC
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If the Hedge Transaction record is a Hedge
      ** and the Derivative Deal Module is 'SE' then access
      ** Midas SE securities.
      ** If the accessed security has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'H'
     C     B_FSMOD       ANDEQ     'SE'
     C     B_FSFPSE      CHAIN     SECTY
     C                   IF        %FOUND(SECTY)
     C     WDType        IFEQ      'HT'
     C     ArrFileHST(X) ANDEQ     SITP
     C     WDType        OREQ      'HT'
     C     ArrFileHST(X) ANDEQ     '***'
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     B_FSBKCD
     C     WDType        OREQ      'HB'
     C     ArrFileHBK(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** If the Hedge Transaction record is a Hedge
      ** and the Derivative Deal Module is 'FH' then access
      ** Midas Forecast Transactions Details
      ** If the accessed forecast has a field that matches the
      ** field being amended, set the linkage indicator to 'Yes'.
 
     C     B_FSDHIN      IFEQ      'H'
     C     B_FSMOD       ANDEQ     'FH'
     C*****B_FSDLNO      CHAIN     ASFHTRL1                                                   CLE148
     C                   MOVEL     B_FSDLNO      B_FSDLNOA                                    CLE148
     C     B_FSDLNOA     CHAIN     ASFHTRL1                                                   CLE148
     C                   IF        %FOUND(ASFHTRL1)
     C     WDType        IFEQ      'HT'
     C     ArrFileHDT(X) ANDEQ     'FH'
     C     ArrScrnHDT(X) ANDNE     ArrFileHDT(X)
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     C_FSSUBT
     C     WDType        OREQ      'HS'
     C     ArrFileHST(X) ANDEQ     '**'
     C                   MOVE      'Y'           WLink
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Read next Hedge Transactions file record.
 
     C     KLUJTR        READE     ASHTRNL1
     C                   ENDDO
 
     C                   ENDIF
 
      ** Read next Hedge Linkages file record.
 
     C     A_FSHGST      READE     ASHGLKL2
     C                   ENDDO
 
     C                   CLOSE     SECTY
     C                   CLOSE     CLOAN
     C                   CLOSE     DEALSL
     C                   CLOSE     DEALALL
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelReq - Process Delete Request                             *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRDelete, SRMove, SRClrScrn                        *
      *                                                               *
      *****************************************************************
 
     C     SRDelReq      BEGSR
 
     C                   EVAL      *INKJ = '0'
     C                   EVAL      *INKL = '0'
 
     C                   DOW       *INKC = '0'  AND  *INKJ = '0'  AND
     C                             *INKL = '0'
 
     C                   MOVEA     '11'          *IN(71)
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *INKC         CASEQ     '1'           SREnd
 
     C     *INKJ         CASEQ     '1'           SRDelete
 
     C     *INKL         CASEQ     '1'           SRPrevious
     C                   ENDCS
 
      ** Enter key is pressed.
 
     C                   IF        *INKJ = '0'  AND  *INKL = '0'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR0536'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDelete - Delete Hedge Strategy                              *
      *                                                               *
      * Called by: SRDelReq                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRDelete      BEGSR
 
     C                   EVAL      WError = 'N'
 
      ** Check if record has been deleted by another user.
 
     C     FSHESN        CHAIN(E)  SDHGSTL0
 
     C                   IF        NOT %FOUND(SDHGSTL0)
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7602'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Check if record is being used by another user.
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7603'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Check if record has been updated by another user.
 
     C                   IF        SavRec <> CurRec
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
 
      ** Release record lock
 
     C                   UNLOCK    SDHGSTL0
 
     C                   ELSE
 
      ** Flag record as deleted.
 
     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   EVAL      FSCHTP = 'D'
 
     C                   UPDATE(E) @HGSTD0
 
      ** Delete error detected
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
      ** Delete unsuccessful
 
     C                   IF        WError = 'Y'
     C                   EVAL      *INKJ = '0'
     C                   ELSE
     C                   EXSR      SRTrailer
     C                   EVAL      WDetScrn = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmend  - Process Update Request                             *
      *                                                               *
      * Called by: SRProcess                                          *
      *                                                               *
      * Calls    : SRAmdReq SRMove, SRTrailer                         *
      *                                                               *
      *****************************************************************
 
     C     SRAmend       BEGSR
 
      ** Set record data changed flag
 
     C                   EVAL      WRecChg = 'N'
     C                   EVAL      WError = 'N'
 
     C     #1HESN        CHAIN(E)  SDHGSTL0
 
     C                   IF        NOT %FOUND(SDHGSTL0)
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Record locked
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7605'
     C                   EXSR      SRZasnms
     C                   ELSE
 
      ** Check for changed record
 
     C                   IF        SavRec <> CurRec
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR7604'
     C                   EXSR      SRZasnms
     C                   UNLOCK    SDHGSTL0
 
     C                   ELSE
 
      ** Store record data for null update check
 
     C                   EVAL      SavRec2 = *BLANKS
     C                   MOVEL     CurRec        SavRec2
 
      ** Move screen fields to file.
 
     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   EVAL      FSCHTP = 'A'
 
     C                   IF        CurRec <> SavRec2
     C                   EVAL      WRecChg = 'Y'
     C                   ENDIF
 
      ** If record changed, update.
 
     C                   IF        WRecChg = 'Y'
     C                   UPDATE(E) @HGSTD0
     C                   ELSE
     C                   UNLOCK(E) SDHGSTL0
     C                   ENDIF
 
      ** Change error detected
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EXSR      SRZasnms
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WError = 'Y'
     C                   EVAL      WValid = 'N'
     C                   ELSE
     C                   EVAL      WDetScrn = 'N'
     C                   EXSR      SRTrailer
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTrailer - Update Control Files                              *
      *                                                               *
      * Called by: SRInsert, SRDelReq, SRAmend                        *
      *                                                               *
      * Calls    : *PSSR                                              *
      *                                                               *
      *****************************************************************
 
     C     SRTrailer     BEGSR
 
     C                   EVAL      AHFLNM = 'SDHGSTPD'
     C     AHFLNM        CHAIN     SDFCTLL0
 
     C                   IF        %FOUND(SDFCTLL0)
 
     C                   SELECT
     C                   WHEN      #0ACTN = 'A'
     C                   ADD       1             AHNOAM
 
     C                   WHEN      #0ACTN = 'D'
     C                   ADD       1             AHNODL
     C                   SUB       1             AHNORC
 
     C                   WHEN      #0ACTN = 'I'
     C                   ADD       1             AHNOIN
     C                   ADD       1             AHNORC
     C                   ENDSL
 
     C                   UPDATE    @AHREAU
     C                   COMMIT
 
     C                   ELSE
 
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBKEY = AHFLNM
     C                   EVAL      DBASE = 7
     C                   OUT       LDA
     C                   EXSR      *PSSR
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRefresh - Refresh subfile                                   *
      *                                                               *
      * Called by: Main routine, SRProcess                            *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRRefresh     BEGSR
 
     C                   EVAL      #0POS1 = *BLANKS
     C                   EVAL      #0POS2 = *BLANKS
     C                   EVAL      #0POS3 = *BLANKS
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      WReload = 'Y'
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrScrn - Initialise Subfile Record                         *
      *                                                               *
      * Called by: SRLoad, SRDelReq                                   *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRClrScrn     BEGSR
 
      ** Initialise subfile record
 
     C                   EVAL      #1CHTP = *BLANKS
     C                   EVAL      #1LCDT = *ZEROS
     C                   EVAL      #0ACTN = *BLANKS
     C                   EVAL      #0HESN = *BLANKS
     C                   EVAL      #0HELD = *BLANKS
     C                   EVAL      #0BRCA = *BLANKS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRMove - Move fields from file to screen and vice-versa       *
      *                                                               *
      * Called by: SRLoad, SRDelReq, SRAmend                          *
      *                                                               *
      * Calls    : ZEDIT                                              *
      *                                                               *
      *****************************************************************
 
     C     SRMove        BEGSR
 
      ** Move file fields to subfile
 
     C                   IF        WDetScrn = 'N'
     C                   MOVEL     FSHESN        #0HESN
     C                   MOVEL     FSHELD        #0HELD
     C                   MOVEL     FSBRCA        #0BRCA
 
     C                   ELSE
 
      ** Move file fields to details screen
 
     C                   IF        WFileToScrn = 'Y'
 
     C                   MOVEL     FSHESN        #1HESN
     C                   MOVEL     FSHELD        #1HELD
     C                   MOVEL     FSBRCA        #1BRCA
 
     C                   MOVEL     FSPRTP        #1PRTP
     C                   MOVEL     FSPRST        #1PRST
     C**********         MOVEL     FSHRSK        #1HRSK                                       CAS006
     C**********         MOVEL     FSEFFM        #1EFFM                                       CAS006
     C                   MOVEL     FSEFUP        #1EFUP
     C                   MOVEL     FSEFLO        #1EFLO
     C                   MOVEL     FSEFFQ        #1EFFQ
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     FSMEFF        #1MEFF                                       CAS006
     C                   ENDIF                                                                CAS006
 
      ** Convert file date to screen date
 
     C                   CALL      'ZDATE2'
     C                   PARM      FSFSDT        PMidasDayNo
     C**********         PARM      *BLANKS       PDateFmt                                     213352
     C                   PARM      BJDFIN        PDateFmt                                     213352
     C                   PARM                    PDDMMYY
     C                   PARM      *BLANKS       PWorkDate
 
     C                   IF        PDDMMYY <> *ZERO
     C                   MOVE      PDDMMYY       #1FSDT
     C                   MOVE      PDDMMYY       WScrnFSDT
     C                   ELSE
     C                   EVAL      #1FSDT = *BLANKS
     C                   ENDIF
 
     C                   MOVEL     FSDVT1        #1DVT1
     C                   MOVEL     FSDVT2        #1DVT2
     C                   MOVEL     FSDVT3        #1DVT3
     C                   MOVEL     FSDVT4        #1DVT4
     C                   MOVEL     FSDVT5        #1DVT5
     C                   MOVEL     FSDVT6        #1DVT6
     C                   MOVEL     FSDVT7        #1DVT7
     C                   MOVEL     FSDVT8        #1DVT8
     C                   MOVEL     FSDVT9        #1DVT9
     C                   MOVEL     FSDVT10       #1DT10
 
     C                   MOVEL     FSDST1        #1DST1
     C                   MOVEL     FSDST2        #1DST2
     C                   MOVEL     FSDST3        #1DST3
     C                   MOVEL     FSDST4        #1DST4
     C                   MOVEL     FSDST5        #1DST5
     C                   MOVEL     FSDST6        #1DST6
     C                   MOVEL     FSDST7        #1DST7
     C                   MOVEL     FSDST8        #1DST8
     C                   MOVEL     FSDST9        #1DST9
     C                   MOVEL     FSDST10       #1DS10
 
     C                   MOVEL     FSDBK1        #1DBK1
     C                   MOVEL     FSDBK2        #1DBK2
     C                   MOVEL     FSDBK3        #1DBK3
     C                   MOVEL     FSDBK4        #1DBK4
     C                   MOVEL     FSDBK5        #1DBK5
     C                   MOVEL     FSDBK6        #1DBK6
     C                   MOVEL     FSDBK7        #1DBK7
     C                   MOVEL     FSDBK8        #1DBK8
     C                   MOVEL     FSDBK9        #1DBK9
     C                   MOVEL     FSDBK10       #1DB10
 
     C                   MOVEL     FSHDT1        #1HDT1
     C                   MOVEL     FSHDT2        #1HDT2
     C                   MOVEL     FSHDT3        #1HDT3
     C                   MOVEL     FSHDT4        #1HDT4
     C                   MOVEL     FSHDT5        #1HDT5
     C                   MOVEL     FSHDT6        #1HDT6
     C                   MOVEL     FSHDT7        #1HDT7
     C                   MOVEL     FSHDT8        #1HDT8
     C                   MOVEL     FSHDT9        #1HDT9
     C                   MOVEL     FSHDT10       #1HD10
 
     C                   MOVEL     FSHST1        #1HST1
     C                   MOVEL     FSHST2        #1HST2
     C                   MOVEL     FSHST3        #1HST3
     C                   MOVEL     FSHST4        #1HST4
     C                   MOVEL     FSHST5        #1HST5
     C                   MOVEL     FSHST6        #1HST6
     C                   MOVEL     FSHST7        #1HST7
     C                   MOVEL     FSHST8        #1HST8
     C                   MOVEL     FSHST9        #1HST9
     C                   MOVEL     FSHST10       #1HS10
 
     C                   MOVEL     FSHBK1        #1HBK1
     C                   MOVEL     FSHBK2        #1HBK2
     C                   MOVEL     FSHBK3        #1HBK3
     C                   MOVEL     FSHBK4        #1HBK4
     C                   MOVEL     FSHBK5        #1HBK5
     C                   MOVEL     FSHBK6        #1HBK6
     C                   MOVEL     FSHBK7        #1HBK7
     C                   MOVEL     FSHBK8        #1HBK8
     C                   MOVEL     FSHBK9        #1HBK9
     C                   MOVEL     FSHBK10       #1HB10
 
     C                   Z-ADD     FSLCD         #1LCDT
     C                   MOVEL     FSCHTP        #1CHTP
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     FSMEFF        #1MEFF                                       CAS006
     C                   ENDIF                                                                CAS006
 
      ** Save original file contents
 
     C                   MOVEA     WScrnDVT      ArrFileDVT
     C                   MOVEA     WScrnDST      ArrFileDST
     C                   MOVEA     WScrnDBK      ArrFileDBK
     C                   MOVEA     WScrnHDT      ArrFileHDT
     C                   MOVEA     WScrnHST      ArrFileHST
     C                   MOVEA     WScrnHBK      ArrFileHBK
 
      ** Move field values from screen to file.
 
     C                   ELSE
 
     C                   MOVEL     #1HESN        FSHESN
     C                   MOVEL     #1HELD        FSHELD
     C                   MOVEL     #1BRCA        FSBRCA
     C                   MOVEL     #1PRTP        FSPRTP
     C                   MOVEL     #1PRST        FSPRST
     C**********         MOVEL     #1HRSK        FSHRSK                                       CAS006
     C**********         MOVEL     #1EFFM        FSEFFM                                       CAS006
     C                   MOVEL     #1EFUP        FSEFUP
     C                   MOVEL     #1EFLO        FSEFLO
     C                   MOVEL     #1EFFQ        FSEFFQ
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   MOVEL     #1MEFF        FSMEFF                                       CAS006
     C                   ENDIF                                                                CAS006
 
      ** Convert date from screen to file format.
 
     C                   MOVE      #1FSDT        PDDMMYY
 
     C                   CALL      'ZDATE1'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM                    PDDMMYY
     C**********         PARM      *BLANKS       PDateFmt                                     213352
     C                   PARM      BJDFIN        PDateFmt                                     213352
     C                   PARM      *ZEROS        PMidasDayNo
 
     C                   IF        PRtrnCode = *BLANKS
     C                   EVAL      FSFSDT = PMidasDayNo
     C                   ELSE
     C                   EVAL      FSFSDT = 0
     C                   ENDIF
 
     C                   MOVE      *BLANK        ArrFileDVT
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnDVT(X) IFNE      *BLANK
     C                   MOVE      ArrScrnDVT(X) ArrFileDVT(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileDVT(1) FSDVT1
     C                   MOVEL     ArrFileDVT(2) FSDVT2
     C                   MOVEL     ArrFileDVT(3) FSDVT3
     C                   MOVEL     ArrFileDVT(4) FSDVT4
     C                   MOVEL     ArrFileDVT(5) FSDVT5
     C                   MOVEL     ArrFileDVT(6) FSDVT6
     C                   MOVEL     ArrFileDVT(7) FSDVT7
     C                   MOVEL     ArrFileDVT(8) FSDVT8
     C                   MOVEL     ArrFileDVT(9) FSDVT9
     C                   MOVEL     ArrFileDVT(10)FSDVT10
 
     C                   MOVE      *BLANK        ArrFileDST
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnDST(X) IFNE      *BLANK
     C                   MOVE      ArrScrnDST(X) ArrFileDST(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileDST(1) FSDST1
     C                   MOVEL     ArrFileDST(2) FSDST2
     C                   MOVEL     ArrFileDST(3) FSDST3
     C                   MOVEL     ArrFileDST(4) FSDST4
     C                   MOVEL     ArrFileDST(5) FSDST5
     C                   MOVEL     ArrFileDST(6) FSDST6
     C                   MOVEL     ArrFileDST(7) FSDST7
     C                   MOVEL     ArrFileDST(8) FSDST8
     C                   MOVEL     ArrFileDST(9) FSDST9
     C                   MOVEL     ArrFileDST(10)FSDST10
 
     C                   MOVE      *BLANK        ArrFileDBK
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnDBK(X) IFNE      *BLANK
     C                   MOVE      ArrScrnDBK(X) ArrFileDBK(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileDBK(1) FSDBK1
     C                   MOVEL     ArrFileDBK(2) FSDBK2
     C                   MOVEL     ArrFileDBK(3) FSDBK3
     C                   MOVEL     ArrFileDBK(4) FSDBK4
     C                   MOVEL     ArrFileDBK(5) FSDBK5
     C                   MOVEL     ArrFileDBK(6) FSDBK6
     C                   MOVEL     ArrFileDBK(7) FSDBK7
     C                   MOVEL     ArrFileDBK(8) FSDBK8
     C                   MOVEL     ArrFileDBK(9) FSDBK9
     C                   MOVEL     ArrFileDBK(10)FSDBK10
 
     C                   MOVE      *BLANK        ArrFileHDT
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHDT(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHDT(X) ArrFileHDT(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileHDT(1) FSHDT1
     C                   MOVEL     ArrFileHDT(2) FSHDT2
     C                   MOVEL     ArrFileHDT(3) FSHDT3
     C                   MOVEL     ArrFileHDT(4) FSHDT4
     C                   MOVEL     ArrFileHDT(5) FSHDT5
     C                   MOVEL     ArrFileHDT(6) FSHDT6
     C                   MOVEL     ArrFileHDT(7) FSHDT7
     C                   MOVEL     ArrFileHDT(8) FSHDT8
     C                   MOVEL     ArrFileHDT(9) FSHDT9
     C                   MOVEL     ArrFileHDT(10)FSHDT10
 
     C                   MOVE      *BLANK        ArrFileHST
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHST(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHST(X) ArrFileHST(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileHST(1) FSHST1
     C                   MOVEL     ArrFileHST(2) FSHST2
     C                   MOVEL     ArrFileHST(3) FSHST3
     C                   MOVEL     ArrFileHST(4) FSHST4
     C                   MOVEL     ArrFileHST(5) FSHST5
     C                   MOVEL     ArrFileHST(6) FSHST6
     C                   MOVEL     ArrFileHST(7) FSHST7
     C                   MOVEL     ArrFileHST(8) FSHST8
     C                   MOVEL     ArrFileHST(9) FSHST9
     C                   MOVEL     ArrFileHST(10)FSHST10
 
     C                   MOVE      *BLANK        ArrFileHBK
     C                   Z-ADD     *ZERO         X
     C                   Z-ADD     1             Y
     C                   DO        10
     C                   ADD       1             X
     C     ArrScrnHBK(X) IFNE      *BLANK
     C                   MOVE      ArrScrnHBK(X) ArrFileHBK(Y)
     C                   ADD       1             Y
     C                   ENDIF
     C                   ENDDO
 
     C                   MOVEL     ArrFileHBK(1) FSHBK1
     C                   MOVEL     ArrFileHBK(2) FSHBK2
     C                   MOVEL     ArrFileHBK(3) FSHBK3
     C                   MOVEL     ArrFileHBK(4) FSHBK4
     C                   MOVEL     ArrFileHBK(5) FSHBK5
     C                   MOVEL     ArrFileHBK(6) FSHBK6
     C                   MOVEL     ArrFileHBK(7) FSHBK7
     C                   MOVEL     ArrFileHBK(8) FSHBK8
     C                   MOVEL     ArrFileHBK(9) FSHBK9
     C                   MOVEL     ArrFileHBK(10)FSHBK10
 
     C                   Z-ADD     BJRDNB        FSLCD
 
     C                   ENDIF
 
      ** Hold current record image for change detection
 
     C                   EVAL      SavRec = *BLANKS
     C                   MOVEL     CurRec        SavRec
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWrite - Create Hedge Strategy Details                       *
      *                                                               *
      * Called by: SRInsert                                           *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRWrite       BEGSR
 
     C                   EVAL      WError = 'N'
 
      ** Check for duplicate primary key
 
     C     #1HESN        SETLL     SDHGSTL1
 
     C                   IF        %EQUAL(SDHGSTL1)
     C                   EVAL      WError = 'Y'
     C                   EVAL      *IN41 = '1'
     C                   EVAL      PZMsgFile = 'SDUSRMSG'
     C                   EVAL      PZMsgID = 'USR9240'
     C                   EXSR      SRZasnms
 
     C                   ELSE
 
      ** Create Hedge Strategy Details
 
     C                   EVAL      WFileToScrn = 'N'
     C                   EXSR      SRMove
     C                   EVAL      FSCHTP = 'I'
 
     C                   WRITE     @HGSTD0
 
     C                   IF        %ERROR
     C                   EVAL      WError = 'Y'
     C                   EVAL      PZMsgFile = 'Y2USRMSG'
     C                   EVAL      PZMsgID = 'Y2U0004'
     C                   EXSR      SRZasnms
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRAmdReq - Update Hedge Strategy Details                      *
      *                                                               *
      * Called by: SRAmend                                            *
      *                                                               *
      * Calls    : SRZasnms                                           *
      *                                                               *
      *****************************************************************
 
     C     SRAmdReq      BEGSR
 
     C                   EVAL      WValid = 'N'
     C                   EVAL      *INKL = '0'
 
     C                   DOW       *INKC = '0'  AND  *INKL = '0'  AND
     C                             WValid = 'N'
 
     C                   EVAL      *IN73 = '1'
     C                   EXSR      SRDisplay
 
      ** Process response
 
     C     *INKC         CASEQ     '1'           SREnd
 
     C     *INKL         CASEQ     '1'           SRPrevious
 
     C                   CAS                     SRValidate
     C                   ENDCS
 
      ** Amend Hedge Shortname Details
 
     C                   IF        WValid = 'Y'
     C                   EXSR      SRAmend
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZasnms - Message Handling Subroutine                        *
      *                                                               *
      * Called by: Various                                            *
      *                                                               *
      * Calls    : Y2SNMGC                                            *
      *                                                               *
      *****************************************************************
 
     C     SRZasnms      BEGSR
 
      ** Send message
 
     C                   CALL      'Y2SNMGC'
     C                   PARM      #1PGMQ        PZPgmQ
     C                   PARM                    PZRelQ
     C                   PARM                    PZMsgID
     C                   PARM                    PZMsgFile
     C                   PARM                    PZMsgData
     C                   PARM      *BLANKS       PZMsgType
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRPrevious - Display previous screen                          *
      *                                                               *
      * Called by: SRInsert                                           *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SRPrevious    BEGSR
 
      ** Rollback any uncommitted DBF changes
 
     C                   IF        WKeyScrn = 'Y'
     C                   EVAL      WKeyScrn = 'N'
     C                   ENDIF
 
     C                   IF        WDetScrn = 'Y'  AND  #0ACTN = 'I'
     C                   EVAL      WDetScrn = 'N'
     C                   EVAL      WKeyScrn = 'Y'
     C                   EVAL      *INKL = '0'
     C                   ENDIF
 
     C                   IF        WDetScrn = 'Y'  AND  #0ACTN <> 'I'
     C                   EVAL      WDetScrn = 'N'
     C                   EVAL      WKeyScrn = 'N'
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREnd - End Program                                           *
      *                                                               *
      * Called by: Main routine, SRInsert                             *
      *                                                               *
      * Calls    : None                                               *
      *                                                               *
      *****************************************************************
 
     C     SREnd         BEGSR
 
      ** Rollback any uncommitted DBF changes
 
     C                   ROLBK
 
      ** If selection mode and F3 has been pressed
 
     C                   IF        PMODE = '?'
     C                   EVAL      PRTCD = '*NOSEL '
     C                   EVAL      PHESN = *BLANKS
     C                   ENDIF
 
      ** Terminate program
 
     C                   EVAL      *INLR = '1'
 
      ** Exit program
 
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation Routine                      *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls    : AOBANKR0, AOMMODR0, AOSARDR0                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PRTCD
     C                   PARM                    PMODE
     C                   PARM                    PHESN
 
     C                   EVAL      DBPGM = 'SD000743'
 
      ** Call Access Program for Bank Details
 
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      SDBANK        DSSDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 8
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Call Access Program for Midas Modules
 
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*FIRST '     POption
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
     C                   IF        PRtrnCode <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SDMMODPD'
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBASE = 9
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Hedge Product Sub-Type is available only if Dealing module is on.
 
     C                   IF        BGSWDL = 'Y'  OR  BGDLFX = 'Y'  OR
     C                             BGMTDL = 'Y'  OR  BGDLMM = 'Y'  OR
     C                             BGCHDL = 'Y'
     C                   EVAL      *IN32 = '0'
     C                   ELSE
     C                   EVAL      *IN32 = '1'
     C                   ENDIF
 
      ** Check if enhancement CDL006 (Dealing Fiduciary) is switched on.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtrnCode
     C                   PARM      '*VERIFY'     POption
     C                   PARM      'CDL006'      PSard
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtrnCode = *BLANKS
     C                   EVAL      CDL006 = 'Y'
 
     C                   ELSE
     C                   EVAL      CDL006 = 'N'
 
     C                   IF        PRtrnCode <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBFILE = 'SCSARDPD'
     C                   EVAL      DBKEY = 'CDL006'
     C                   EVAL      DBASE = 10
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS003
      ** Check if enhancement CAS003 is switched on.                                          CAS003
                                                                                              CAS003
     C                   CALLB     'AOSARDR0'                                                 CAS003
     C                   PARM      *BLANKS       PRtrnCode                                    CAS003
     C                   PARM      '*VERIFY'     POption                                      CAS003
     C                   PARM      'CAS003'      PSard                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode = *BLANKS                                        CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
                                                                                              CAS003
     C                   IF        PRtrnCode <> '*NRF   '                                     CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBKEY = 'CAS003'                                           CAS003
     C                   EVAL      DBASE = 11                                                 CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
 
      ** Check if CAS004 is installed                                                         CAS004
                                                                                              CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   CALLB     'AOSARDR0'                                                 CAS004
     C                   PARM      *BLANKS       PRtrnCode                                    CAS004
     C                   PARM      '*VERIFY'     POption                                      CAS004
     C                   PARM      'CAS004'      PSard                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode = *BLANKS                                        CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Database error                                                                       CAS004
                                                                                              CAS004
     C                   IF        PRtrnCode <> *BLANKS  AND                                  CAS004
     C                             PRtrnCode <> '*NRF   '                                     CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBKEY = PSard                                              CAS004
     C                   EVAL      DBASE = 12                                                 CAS004
     C                   EVAL      DBPGM = 'SD000743'                                         CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Check if CAS006 is installed                                                         CAS006
                                                                                              CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   EVAL      *IN61 = '1'                                                CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *Blanks       PRtrnCode                                    CAS006
     C                   PARM      '*VERIFY'     POption                                      CAS006
     C                   PARM      'CAS006'      PSard                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode = *Blanks                                        CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   EVAL      *IN61 = '0'                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        PRtrnCode <> *BLANKS  AND                                  CAS006
     C                             PRtrnCode <> '*NRF   '                                     CAS006
     C                   EVAL      DBKEY = PSard                                              CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE  =  013                                              CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   CALL      'AOSARDR0'                                                 CAS007
     C                   PARM      *BLANKS       PRtrnCode                                    CAS007
     C                   PARM      '*VERIFY'     POption                                      CAS007
     C                   PARM      'CAS007'      PSard                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
     C                   IF        PRtrnCode = '*NRF   '                                      CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        PRtrnCode <> *BLANKS  AND                                  CAS007
     C                             PRtrnCode <> '*NRF   '                                     CAS007
     C                   EVAL      DBKEY = PSard                                              CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE  =  014                                              CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Open files for update
 
     C                   OPEN      SD000743DF
     C     #HGST0        IFNE      '1'
     C                   OPEN      SDHGSTL0
     C                   ENDIF
     C     #HGST1        IFNE      '1'
     C                   OPEN      SDHGSTL1
     C                   ENDIF
 
      ** Initialise subfile control
 
     C                   EVAL      #0RUNA = BJMRDT
     C                   EVAL      #0WSID = PSJobName
     C                   EVAL      #0USER = PSUser
     C                   EVAL      #1PGMQ = PSProcName
 
     C                   Z-ADD     *ZERO         #1LCDT
     C                   MOVEL     *BLANK        #1CHTP
     C                   MOVEL     *BLANK        #0POS1
     C                   MOVEL     *BLANK        #0POS2
     C                   MOVEL     *BLANK        #0POS3
     C                   Z-ADD     14            WSFPG
 
     C     KLUJTR        KLIST
     C                   KFLD                    B_FSHEDI
     C                   KFLD                    B_FSDHIN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *PSSR   -  Error Handling Subroutine                         *
      *                                                               *
      *  Called by: Various                                           *
      *                                                               *
      *  Calls    : DBERRCTL - Database Error Control                 *
      *                                                               *
      *****************************************************************
 
     C     *PSSR         BEGSR
 
     C                   DUMP
 
     C                   IF        WRun = *BLANK
     C                   EVAL      WRun = 'Y'
     C                   CALLB     'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
** TABNAM
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
