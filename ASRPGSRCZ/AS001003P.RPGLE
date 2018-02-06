     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge effectiveness report')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Accounting Standard Module                           *
      *                                                               *
      *  AS001003P - Midas AS Hedge Effectiveness Report              *
      *                                                               *
      *  Function:  This module lists the Effective and Ineffective   *
      *             or Discontinued Hedges. Gives the total figures   *
      *             of Unrealized P/L (daily and yearend figures).    *
      *             List is sorted by Product Type, Strategy and by   *
      *             Branch.                                           *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
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
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 229801             Date 28Sep04               *
      *                 228948             Date 27Sep04               *
      *                 229406             Date 07Sep04               *
      *                 228011             Date 24Jun04               *
      *                 228274             Date 09Jul04               *
      *                 227695             Date 17Jun04               *
      *                 227257             Date 23May04               *
      *                 225293             Date 26Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 224214             Date 08Jan04               *
      *                 224116             Date 05Jan04               *
      *                 CAS006             Date 21Jan03               *
      *                 219870             Date 08Jul03               *
      *                 CAS005             Date 16Dec02               *
      *                 212421             Date 26Sep02               *
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
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                 .*
      *  229801 - Hedge Effectiveness % not printed. Apply fix 229468.*
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229406 - Report shows value in OCI column related to FRA     *
      *           transaction which is not valid.                     *
      *  228011 - Error on percentage reported by AS001003P1          *
      *  228274 - Move URPL instead of IRURPL to WkFHURPL because     *
      *           derivative may not be an FRA/IRS deal.  Do not      *
      *           convert URPL to base ccy if forecast transaction.   *
      *  227695 - For MM deals, check liquidity premium instead of    *
      *           base rate and spread rate to determine whether to   *
      *           use all-in-rate or net treasury rate file.          *
      *  227257 - Ineffective Hedge Report does not print             *
      *           effectiveness date                                  *
      *  225293 - Report is showing the NPV of the previous           *
      *           transaction.                                        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224214 - Huge unrealised P/L shown on AS001003P1 for matured *
      *           loans                                               *
      *  224116 - Hedge report should show buy out date as maturity   *
      *           date if deal has been bought out                    *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  219870 - Hedge Effectiveness Percentage decimal points       *
      *           not shown in the report when greater than 999.      *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  212421 - Incorrect amounts shown on AS001003P report         *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Strategy Level Break                            *
      *    02         Product Type Level Break                        *
      *    03         Branch Level Break                              *
      *    12         EOF SDHGSTL2                                    *
      *    25         FV Product Type                                 *
      *    26         FX Product Type                                 *
      *    27         CF Product Type                                 *
      *    37         Multibranch Active                              *
      *    44         Overflow - Ineffective Hedges                   *
      *    55         Record Found Indicator                          *
      *    56         Record Found Indicator                          *
      *    66         Overflow - Effective Hedges                     *
      *    77         Qualified Hedge Linkage Found Indicator         *
      *    87         End of File Indicator                           *
      *    89         End of File Indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRAUDIT - Audit Printing                                      *
      * SRDATE - Convert Midas day number to date                     *
      * SRLNK1 - Hedge Linkage processing (Main)                      *
      * SRLNK2 - Hedge Linkage processing (Subordinate)               *
      * SRTRN1 - Hedge Transaction processing                         *
      * SRTRN2 - Move data to workfields and print Transaction Report *
      * SRTRN3 - Load workfields to print Transaction Report          *
      * SRUPL  - Unrealised P/L-related                               *
      * SRINL1 - New Hedge Strategy Level Break                       *
      * SRINL2 - New Product Type Level Break                         *
      * SRINL3 - New Branch Level Break                               *
      * SRVAL1 - Check if Hedge Linkages exist                        *
      * SRVAL2 - Search for live Hedge Linkage records                *
      * SRDLNO - Deal processing                                      *
      * SRFFNO - Futures Position processing                          *                       CAS003
      * SRFHNO - Forecast Transaction processing                      *
      * SRLENO - Loan processing                                      *
      * SRSENO - Security processing                                  *
      * SRLDTO - Print Hedge Linkage totals (Derivative)- Effective   *
      * SRLHTO - Print Hedge Linkage totals (Hedged) - Effective      *
      * SRLNTO - Print Hedge Linkage totals - Effective               *
      * SRL1TO - Print Hedge Strategy totals - Effective              *
      * SRL2TO - Print Product Type totals - Effective                *
      * SRL3TO - Print Branch totals - Effective                      *
      * SR@DTO - Print Hedge Linkage totals (Derivative) - Ineffective*
      * SR@HTO - Print Hedge Linkage totals (Hedged) - Ineffective    *
      * SR@NTO - Print Hedge Linkage totals - Ineffective             *
      * SR@1TO - Print Hedge Strategy totals - Ineffective            *
      * SR@2TO - Print Product Type totals - Ineffective              *
      * SR@3TO - Print Branch totals - Ineffective                    *
      * SRCHGP  -Change Percentage calculation                        *
      * SRAMT   -Convert numeric amounts into character fields        *
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
 
      ** RTV : Hedge Strategy By Branch and Product Type
     FSDHGSTL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(H1:2)
 
      ** RTV : Hedge Strategy By Branch and Product Type
     FSDHGSTL3  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SDHGSTD0:SDHGSTD3)
     F                                     PREFIX(H1:2)
 
      ** RTV : Hedge Linkage Retrieval By Hedge Strategy
     FASHGLKL2  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Hedge Transactions By Hedge ID and Der/Hed Ind
     FASHTRNL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND1)
                                                                                              CAS006
      ** RTV : Hedge Transactions By Hedge ID selecting only those with FH                    CAS006
      ** transactions                                                                         CAS006
     FASHTRNLH  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(ASHTRND0:ASHTRNDH)                          CAS006
     F                                     PREFIX(LH:2)                                       CAS006
                                                                                              225293
     FASHTRNLB  IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     RENAME(ASHTRND0:ASHTRNDB)                          225293
     F                                     PREFIX(HI)                                         225293
 
      ** RTV: Forecast Transactions
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV : Revalued FRAs and IRSs File
     F***IRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                    CAS005
     FIRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
 
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (SIRS)                        CAS005
     FIRNPVBL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(IRNPVAD0:IRNPVBD0)                          CAS005
                                                                                              CAS005
      ** RTV : Revalued FRAs and IRSs File (CIRS)                                             CAS005
     FRXNPVAL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
                                                                                              CAS005
      ** RTV : Revalued FRAs and IRSs File using Base Rate File (CIRS)                        CAS005
     FRXNPVBL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
     F                                     RENAME(RXNPVAD0:RXNPVBD0)                          CAS005
                                                                                              CAS005
      ** RTV:  Revalued Futures/Options Positions                                             CAS003
     FFFNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS003
                                                                                              CAS003
      ** RTV:  Revalued Money Market Deals                                                    CAS005
     FMMNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
                                                                                              CAS005
      ** RTV:  Revalued Customer Lending                                                      CAS005
     FLENPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS005
                                                                                              CAS005
      ** RTV:  Revalued Securities Positions
     F***SENPVLL0**IF   E           K DISK    INFSR(*PSSR)                                    CAS006
     FSEMKVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
 
      ** RTV : Midas IR Revalued FRA File using All In Rate File                              CAS006
     FFRNPVAL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
                                                                                              CAS006
      ** RTV : Midas IR Revalued FRA using Net Treasury Rate File                             CAS006
     FFRNPVLL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(FRNPVAD0:FRNPVLD0)                          CAS006
                                                                                              CAS006
      ** RTV:  Revalued Forward Commitments
     FDLNPVLL3  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV: Deals Files
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     INFDS(INFDS)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
 
      ** SD Dealing Data
     FSDDEALL1  IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV: Loans
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
 
      ** Midas SE Book Position Headers                                                       225293
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)                                       225293
     F                                     PREFIX(B2)                                         225293
                                                                                              225293
      ** RTV: Security File
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
 
      ** RTV:  Midas FF Transaction details - detail                                          CAS003
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)                                       CAS003
                                                                                              CAS003
      ** PRT: Printer file for Effective Hedges (Transaction Detail)
     FAS001003P1O    E             PRINTER OFLIND(*IN66)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL1)
 
      ** PRT: Printer file for Ineffective Hedges (Transaction Detail)
     FAS001003P2O    E             PRINTER OFLIND(*IN44)
     F                                     INFSR(*PSSR)
     F                                     INFDS(SPOOL2)
 
      ** PRT: Printer file for Hedge Effectiveness(Audit)
     FAS001003AUO    E             PRINTER INFSR(*PSSR)
     F                                     INFDS(SPOOLU)
 
      ** Midas DL Money Market Transactions by DLNO                                           CAS004
     FDLDLDCL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(DEALSDCF:DEALSDCC)                          CAS004
     F                                     PREFIX(C)                                          CAS004
                                                                                              CAS004
      ** Midas FX Deals by DLNO                                                               CAS004
     FDLDLDBL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(DEALSDBF:DEALSDBC)                          CAS004
     F                                     PREFIX(B)                                          CAS004
                                                                                              CAS004
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
                                                                                              228011
      ** Narratives for AS001003Px                                                            228011
     D Narrative       S             35    DIM(4) CTDATA PERRCD(1)                            228011
                                                                                              228011
     D A22             S              1    DIM(22)
 
      ** Arrays for Unrealised P/L (General Work)
     D AR              S             13  0 DIM(3)
     D AMT             S             18    DIM(3)
 
      ** Arrays for Unrealised P/L (Effective)
     D D0              S             13  0 DIM(3)
     D H0              S             13  0 DIM(3)
     D T0              S             13  0 DIM(3)
     D D1              S             13  0 DIM(3)
     D H1              S             13  0 DIM(3)
     D T1              S             13  0 DIM(3)
     D D2              S             13  0 DIM(3)
     D H2              S             13  0 DIM(3)
     D T2              S             13  0 DIM(3)
     D D3              S             13  0 DIM(3)
     D H3              S             13  0 DIM(3)
     D T3              S             13  0 DIM(3)
 
      ** Arrays for Unrealised P/L (Ineffective)
     D D0@             S             13  0 DIM(3)
     D H0@             S             13  0 DIM(3)
     D T0@             S             13  0 DIM(3)
     D D1@             S             13  0 DIM(3)
     D H1@             S             13  0 DIM(3)
     D T1@             S             13  0 DIM(3)
     D D2@             S             13  0 DIM(3)
     D H2@             S             13  0 DIM(3)
     D T2@             S             13  0 DIM(3)
     D D3@             S             13  0 DIM(3)
     D H3@             S             13  0 DIM(3)
     D T3@             S             13  0 DIM(3)
 
      ** Record Format
     D INFDS           DS           528
     D  RCDFMT                38     45
 
      ** Today's Date
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
 
      ** Currency Data Structure
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      ** DS for SC Switchable Features                                                        CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS003
      ** External data structure for General Ledger ICD Details                               CAS004
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CAS004
                                                                                              CAS004
      ** DS for Access Programs: Long Data Structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** DS for Access Programs: Short Data Structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External Data Structures for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External Data Structures for Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** External Data Structures for Hedge Details                                           228011
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)                                  228011
                                                                                              228011
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
     D  INSKEY                 1      5                                                       CAS003
     D  INSFLD                 6     10                                                       CAS003
     D  INSMM@                 6      8                                                       CAS003
     D  INSYY@                 9     10                                                       CAS003
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
     D PSAR            S              6                                                       CAS003
                                                                                              CAS003
     D CAS003          S              1    INZ('N')                                           CAS003
     D CAS004          S              1                                                       CAS004
     D CAS005          S              1    INZ('N')                                           CAS005
     D CAS006          S              1    INZ('N')                                           CAS006
     D WIn40Flag       S              1    INZ('N')                                           CAS005
     D WEvCtlDt        S              5P 0                                                    CAS004
 
      ** Details Fields
     D WRKDLN          S             10
     D WRKBKC          S              2
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
     D WkHdgFH         S              1                                                       CAS006
     D WkRECI          S              1                                                       CAS006
     D WDTYP           S              2                                                       229406
 
     D WRK21           S             21
     D C22             S              3  0
     D WRKPC4          S              4
     D WRKPC1          S              1
 
     D CN              S              1  0
     D M               S              3  0
     D X               S              1  0
     D INSYY           S              2  0                                                    CAS001
     D INSMM           S              2  0                                                    CAS001
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
     D L1CNT           S              7  0
     D L2CNT           S              7  0
     D L3CNT           S              7  0
     D @1CNT           S              7  0
     D @2CNT           S              7  0
     D @3CNT           S              7  0
     D WURDNB          S              5  0
     D HGHDIN          S              1
     D WkFHURPL        S             13  0                                                    CAS006
     D KCDLNO          S              6  0                                                    CLE148
     D LHDLNO2         S                   LIKE(FSTRID)                                       CLE148
 
      ** Parameters for ZSFILE
     D SEQ             S              5
     D SENTY           S              3
     D ZSNUM           S              6  0
     D ZSERR           S              1
     D ZSNUMU          S              6  0
 
      ** Parameters for ZFRPED
     D PFLD15          S             15  0
     D PDECS           S              1  0
     D PECODE          S              1
     D POUT21          S             21
     D POUT22          S             22
     D POUT25          S             25
 
     D DCOUNT          S              7  4
     D HCOUNT          S              7  4
     D TCOUNT          S              7  4
     D EFFFLG          S              1
     D WFORE           S              1
     D WEXRE           S              1
     D PRINT           S              1
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
 
     D ZDATE           S              6  0
     D ZADATE          S              7
     D PDate           S                   LIKE(WRKVAL)
 
     D WFLD20          S             20
     D KLNKDN          S              6  0                                                    CAS004
     D WLNKDN          S              6                                                       CAS004
     D WIgnoreChgF     S              1                                                       CAS006
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
 
      ** Rename Input field from DLNPVLL3 to avoid error in compilation
     IDLNPVLD0
     I              FSDAMT                      WDealAmt
     I              FSDLNO                      DLDLNO                                        CLE148
 
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
                                                                                              CAS006
     C                   EVAL      WIgnoreChgF = 'Y'                                          CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'N' AND *IN12 = *OFF                              CAS006
     C                             OR CAS006 = 'Y' AND *IN12 = *OFF                           CAS006
     C                             AND H1MEFF <> 'R'                                          CAS006
 
     C                   EVAL      WIgnoreChgF = 'N'                                          CAS006
                                                                                              CAS006
      ** Set Indicator for changes on Cash Flow reports                                       CAS005
                                                                                              CAS005
     C                   EVAL      WIn40Flag = 'N'                                            CAS005
     C                   IF        CAS005 = 'Y' AND H1PRTP = 'CF'                             CAS005
     C                   EVAL      WIn40Flag = 'Y'                                            CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   SELECT
 
     C                   WHEN      @BRCA <> H1BRCA
     C                   EVAL      WLVInd = 'YYY'
 
     C                   WHEN      @PRTP <> H1PRTP
     C                   EVAL      WLVInd = 'NYY'
 
     C                   WHEN      @HESN <> H1HESN
     C                   EVAL      WLVInd = 'NNY'
     C                   ENDSL
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** If change in Branch
 
     C                   IF        WLVInd3 = 'Y'
     C                   EVAL      *IN03 = *ON
     C                   EXSR      SRINL3
     C                   EVAL      *IN03 = *OFF
     C                   ENDIF
 
     C                   EXSR      SRProcess
 
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   READ      SDHGSTL2                               12
 
     C                   IF        WIgnoreChgF = 'N'                                          CAS006
                                                                                              CAS006
      ** At the End of Product Type, Print Totals
 
     C                   IF        @PRTP <> H1PRTP or *IN12 = *ON
     C                   EVAL      INPRTP = *BLANKS
     C                   IF        L2CNT > *ZEROS
     C                   EXSR      SRL2TO
     C                   ENDIF
 
     C                   IF        @2CNT > *ZEROS
     C                   EXSR      SR@2TO
     C                   ENDIF
     C                   ENDIF
 
      ** At end of branch print totals, trailer and close printer file
 
     C                   IF        @BRCA <> H1BRCA or *IN12 = *ON
     C                   EVAL      INBRCA = *BLANKS
     C                   IF        L3CNT > *ZEROS
     C                   EXSR      SRL3TO
     C                   ENDIF
 
     C                   IF        @3CNT > *ZEROS
     C                   EXSR      SR@3TO
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDDO
 
     C                   EXSR      SRAUDIT
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
 
     C                   EVAL      INHESN = *Blanks
     C                   IF        L1CNT > *Zeros
     C                   EXSR      SRL1TO
     C                   ENDIF
     C                   IF        @1CNT > *Zeros
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
      * SRLNK1 - Hedge Linkage Processing Main                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRLNK1        BEGSR
 
      ** For each Hedge Strategy - read all Hedge Linkage records
 
     C                   EVAL      *IN89 = *OFF
     C     H1HESN        SETLL     ASHGLKL2
     C     H1HESN        READE     ASHGLKL2                               89
 
     C                   DOW       *IN89 = *OFF
                                                                                              CAS006
     C                   EVAL      WkRECI = FSRECI                                            CAS006
 
      ** If qualifying Hedge Linkage record exists
 
     C**********         IF        FSLASD = BJRDNB AND FSRECI = 'D'                           CAS004
     C**********                   OR FSLASD = BJRDNB AND FSRECI = 'X'                        CAS004
     C**********         IF        FSRECI = 'D'                                        CAS004 CAS006
     C**********                   OR FSRECI = 'X'                                     CAS004 CAS006
     C                   IF        (FSRECI = 'D' OR FSRECI = 'X') AND                         CAS006
     C                             FSSECR <> 'Y'                                              CAS006
 
      ** Initialise effectiveness flag
 
     C                   IF        FSRECI = 'D'
     C                   EVAL      EFFFLG = 'E'
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                   EVAL      EFFFLG = 'I'
     C                   ENDIF
     C                   ENDIF
 
      ** Process Hedge Transaction records without detail printing
 
     C                   EVAL      PRINT = 'N'
     C                   EXSR      SRLNK2
 
      ** If live Hedge Transaction Details exist and today is Eff. Date
 
     C                   IF        TCOUNT > *ZEROS
 
      ** Increment Hedge Linkage count
 
     C                   EVAL      LCOUNT = LCOUNT + 1
 
      ** Process Hedge Transaction records with detail printing
 
     C                   EVAL      PRINT = 'Y'
 
     C                   EXSR      SRLNK2
 
      ** Move total fields for Hedge Linkage totals printing and print
 
     C                   IF        EFFFLG = 'E'
     C                   EXSR      SRLNTO
     C                   ELSE
     C                   IF        EFFFLG = 'I'
     C                   EXSR      SR@NTO
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
      * SRLNK2 - Hedge Linkage Processing Subordinated                *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRLNK2        BEGSR
 
      ** Initialise Hedge Transaction count
 
     C                   EVAL      TCOUNT = *ZEROS
 
      ** Check if hedge is for forecast transactions
 
     C                   EVAL      WFORE = *BLANKS
     C                   EVAL      WEXRE = *BLANKS
     C                   EVAL      HGHDIN = 'H'
     C     KYTRAN        CHAIN     ASHTRND1                           87
     C                   IF        *IN87 = *OFF AND FSMOD = 'FH'
     C*****FSDLNO        CHAIN     ASFHTRL1                           87                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           87                      CLE148
     C                   IF        *IN87 = *OFF
     C                   EVAL      WFORE = 'Y'
     C                   EVAL      WEXRE = FSERIN
     C                   ENDIF
     C                   ENDIF
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      DCOUNT = *ZEROS
     C                   EVAL      HGHDIN = 'D'
     C                   EXSR      SRTRN1
 
      ** If Derivative Transaction records exist -print Derivative total
 
     C                   IF        PRINT = 'Y' and DCOUNT > *ZEROS
 
     C                   SELECT
     C                   WHEN      EFFFLG = 'E'
     C                   EXSR      SRLDTO
 
     C                   WHEN      EFFFLG = 'I'
     C                   EXSR      SR@DTO
     C                   ENDSL
 
     C                   ENDIF
 
      ** Process and print applicable Derivative Transaction records
 
     C                   EVAL      HCOUNT = *ZEROS
     C                   EVAL      HGHDIN = 'H'
     C                   EXSR      SRTRN1
 
      ** If Derivative Transaction records exist -print Derivative total
 
     C                   IF        PRINT = 'Y' and HCOUNT > *ZEROS
 
     C                   SELECT
     C                   WHEN      EFFFLG = 'E'
     C                   EXSR      SRLHTO
 
     C                   WHEN      EFFFLG = 'I'
     C                   EXSR      SR@HTO
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRN1 - Hedge Transaction Processing                         *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRTRN1        BEGSR
 
      ** Read all Derivative or Hedged Transaction records of a Hedge
 
     C                   EVAL      *IN87 = *Off
     C     KYTRAN        SETLL     ASHTRNL0
     C     KYTRAN        READE     ASHTRNL0                               87
 
     C                   DOW       *IN87 = *OFF
 
      ** If in non-print mode -increment count of processed records;
      ** otherwise, convert file fields for printing and print details
 
     C                   IF        PRINT = 'N'
     C                   EVAL      TCOUNT = TCOUNT + 1
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
      * SRTRN2 - Move data to workfields and print Transaction Report *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
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
 
      ** Retrieve Transaction details from pertinent files
 
      ** Initialize Indicator 55 to ensure correct processing after                           CAS005
      ** a Security transaction is ignored                                                    CAS005
                                                                                              CAS005
     C                   EVAL      *IN55 = *ON                                                CAS005
                                                                                              CAS005
     C                   SELECT
 
     C                   WHEN      FSMOD = 'DL'
     C                   EXSR      SRDLNO
 
     C                   WHEN      FSMOD = 'FF' AND CAS003 = 'Y'                              CAS003
     C                   EXSR      SRFFNO                                                     CAS003
 
     C                   WHEN      FSMOD = 'LE'
     C                   EXSR      SRLENO
 
     C                   WHEN      FSMOD = 'FH'
     C                   EXSR      SRFHNO
 
     C**********         WHEN      FSMOD = 'SE'                                               CAS005
     C                   WHEN      FSMOD = 'SE' AND CAS005 = 'N'                              CAS005
     C                   EXSR      SRSENO
 
     C                   ENDSL
 
      ** If record found in file
 
     C                   IF        *IN55 = *OFF
 
      ** Clear detail printer file record
 
     C                   IF        EFFFLG = 'I'
     C                   CLEAR                   DETAIL2
     C                   ELSE
     C                   CLEAR                   DETAIL1
     C                   ENDIF
 
      ** Load printer file fields
 
     C                   EXSR      SRTRN3
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print Hedge Transaction details
 
     C                   IF        EFFFLG = 'I'
 
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
 
     C                   ADD       1             @1CNT
     C                   ADD       1             @2CNT
     C                   ADD       1             @3CNT
 
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
     C                   EVAL      DCOUNT = DCOUNT + 1
                                                                                              CAS006
      ** If CAS006 is installed, save the Unrealised P/L of the derivative, to                CAS006
      ** be negated later when reporting the Unrealised P/L of the hedged                     CAS006
      ** Forecast Transaction                                                                 CAS006
                                                                                              CAS006
     C                   EVAL      WkFHURPL = 0                                               CAS006
     C                   IF        CAS006 = 'Y' AND WkRECI = 'D'                              CAS006
     C**********         EVAL      WkFHURPL = IRURPL                                   CAS006 228274
     C                   EVAL      WkFHURPL = URPL                                            228274
     C                   ENDIF                                                                CAS006
     C                   ELSE
     C                   IF        HGHDIN = 'H'
     C                   EVAL      HCOUNT = HCOUNT + 1
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRDLNO - Deal processing                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRDLNO        BEGSR
 
     C                   MOVEL     FSDLNO        FSDLNO2           6 0                        CLE148
     C                   IF        FSDHIN = 'D'
     C*****FSDLNO        CHAIN     DEALSDBF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDBF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDGF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDGF                           55                      CLE148
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        FSDHIN = 'H'
 
     C*****FSDLNO        CHAIN     DEALSDBF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDBF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDCF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDCF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDDF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDDF                           55                      CLE148
     C                   IF        *IN55 = *ON
     C*****FSDLNO        CHAIN     DEALSDEF                           55                      CLE148
     C     FSDLNO2       CHAIN     DEALSDEF                           55                      CLE148
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WRKDLN
     C                   EVAL      WRKBKC = BOKC
     C                   EVAL      WRKTYP = DTYP
     C                   EVAL      WRKSTP = DLST
     C                   EVAL      WRKCNU = CNUM
     C                   EVAL      WRKVAL = VDAT
     C                   EVAL      WRKMAT = MDAT
     C                   EVAL      WRKBOV = *ZEROS                                            224116
 
     C                   SELECT
 
      **  Foreign Exchange Deals
 
     C                   WHEN      RCDFMT = 'DEALSDBF'
     C                   EVAL      WRKMAT = *Zeros
     C                   EVAL      WRKCCY = FSCYCD
     C                   EVAL      WRKPR$ = *ZEROS
     C                   EVAL      WRKINT = *ZEROS
 
     C                   IF        WFORE = 'Y'
     C                   IF        WEXRE = 'R'
     C                   EVAL      WRKCCY = SLCY
     C                   EVAL      WRKPR$ = SLAM
     C                   ELSE
     C                   EVAL      WRKCCY = PUCY
     C                   EVAL      WRKPR$ = PUAM
     C                   ENDIF
     C                   ENDIF
 
     C                   EVAL      URPL = FSURPL
     C                   EVAL      YUPL = FSYUPL
 
      ** Cross Currency Deal
 
     C                   EVAL      WkHdgFH = 'N'                                              CAS006
     C                   IF        WRKTYP = 'CX'
     C     FSHEDI        CHAIN     ASHTRNLH                                                   CAS006
     C                   IF        %FOUND(ASHTRNLH)                                           CAS006
     C                   EVAL      WkHdgFH = 'Y'                                              CAS006
     C                   ENDIF                                                                CAS006
     C**********         IF        SLCY <> BJCYCD                                             CAS004
     C**********         EVAL      WRKCCY = SLCY                                              CAS004
     C**********         EVAL      WRKPR$ = SLAM                                              CAS004
     C**********         ELSE                                                                 CAS004
     C**********         EVAL      WRKCCY = PUCY                                              CAS004
     C**********         EVAL      WRKPR$ = PUAM                                              CAS004
     C**********         ENDIF                                                                CAS004
                                                                                              CAS006
      ** If not hedging 'FH' then this means hedged item is a 'PS', perform                   CAS006
      ** necessary validation for this scenario                                               CAS006
                                                                                              CAS006
     C                   IF        WkHdgFH <> 'Y'                                             CAS006
                                                                                              CAS006
     C                   EVAL      KLNKDN = LNKDN                                             CAS004
                                                                                              CAS004
      ** Access the hedged item of the derivative                                             CAS004
     C     KLNKDN        CHAIN     DLDLDBl1                                                   CAS004
     C                   IF        NOT %FOUND(DLDLDBL1)                                       CAS004
     C                   MOVEL     KLNKDN        WLNKDN                                       CAS004
     C                   EVAL      DBFILE = 'DLDLDBL1'                                        CAS004
     C                   EVAL      DBASE = 7                                                  CAS004
     C                   EVAL      DBKEY = WLNKDN                                             CAS004
     C                   EVAL      DBPGM = 'AS001003P'                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      KLNKDN = BLNKDN                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Access the money markey deals of the hedged item                                     CAS004
     C     KLNKDN        CHAIN     DLDLDCL1                                                   CAS004
     C                   IF        NOT %FOUND(DLDLDCL1)                                       CAS004
     C                   MOVEL     KLNKDN        WLNKDN                                       CAS004
     C                   EVAL      DBFILE = 'DLDLDCL1'                                        CAS004
     C                   EVAL      DBASE = 8                                                  CAS004
     C                   EVAL      DBKEY = WLNKDN                                             CAS004
     C                   EVAL      DBPGM = 'AS001003P'                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      WRKCCY = CCCY                                              CAS004
     C                   IF        CCCY = PUCY                                                CAS004
     C                   EVAL      WRKPR$ = PUAM                                              CAS004
     C                   EVAL      URPL = FSURPL                                              CAS004
     C                   EVAL      YUPL = FSURPL                                              CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      WRKPR$ = SLAM                                              CAS004
     C                   EVAL      URPL = FSSUPL                                              CAS004
     C                   EVAL      YUPL = FSSYPL                                              CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS006
      ** Else, this means hedged item is an 'FH'                                              CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C*****LHDLNO        CHAIN     ASFHTRL1                                            CAS006 CLE148
     C                   MOVEL     LHDLNO        LHDLNO2                                      CLE148
     C     LHDLNO2       CHAIN     ASFHTRL1                                                   CLE148
                                                                                              CAS006
     C                   IF        %FOUND(ASFHTRL1)                                           CAS006
     C                   EVAL      WRKCCY = FSCCY                                             CAS006
                                                                                              CAS006
     C                   IF        FSCCY = PUCY                                               CAS006
     C                   EVAL      WRKPR$ = PUAM                                              CAS006
     C                   EVAL      URPL = FSURPL                                              CAS006
     C                   EVAL      YUPL = FSURPL                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WRKPR$ = SLAM                                              CAS006
     C                   EVAL      URPL = FSSUPL                                              CAS006
     C                   EVAL      YUPL = FSSYPL                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF
 
      ** Internal Contract
 
     C                   IF        WRKTYP = 'PS'
 
     C     LNKDN         CHAIN     DEALSDCF                           15
     C                   IF        *IN15 = '0'
     C**********         EVAL      KCDLNO = FSDLNO                                            CLE148
     C                   EVAL      KCDLNO = FSDLNO2                                           CLE148
     C                   EVAL      KCCYCD = CCY
     C                   EVAL      WRKCCY = CCY
 
     C     KFCNPV        CHAIN     DLNPVLL3                           15
     C                   IF        *IN15 = '0'
     C                   MOVEL     DLDLNO        FSDLNO                                       CLE148
     C                   MOVEL     WDealAmt      WRKPR$
     C                   EVAL      URPL = FSPRLA
     C                   EVAL      YUPL = FSYUPL
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      **  Money Market Deals
 
     C                   WHEN      RCDFMT = 'DEALSDCF'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = PCPL
     C     10000000      MULT(H)   INTR          WRKINT
 
     C                   EVAL      URPL = FSURPL
     C                   EVAL      YUPL = FSYUPL
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     DLNO          CHAIN     MMNPVLL0                                                   CAS005
     C**********         IF        NOT %EOF(MMNPVLL0)                                  CAS005 224214
     C                   IF        %FOUND(MMNPVLL0)                                           224214
     C                   EVAL      URPL = MMURPL                                              CAS005
     C                   EVAL      YUPL = MMYUPL                                              CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
 
      **  Negotiable Assets Purchased
 
     C                   WHEN      RCDFMT = 'DEALSDDF'
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
     C                   EVAL      URPL = FSURPL
     C                   EVAL      YUPL = FSYUPL
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     DLNO          CHAIN     MMNPVLL0                                                   CAS005
     C**********         IF        NOT %EOF(MMNPVLL0)                                  CAS005 224214
     C                   IF        %FOUND(MMNPVLL0)                                           224214
     C                   EVAL      URPL = MMURPL                                              CAS005
     C                   EVAL      YUPL = MMYUPL                                              CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
 
      **  Negotiable Assets Sold
 
     C                   WHEN      RCDFMT = 'DEALSDEF'
     C                   EVAL      WRKMAT = *ZEROS
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = FVAL
     C     10000000      MULT(H)   INTR          WRKINT
 
      **  FRA/IRS Deals
 
     C                   WHEN      RCDFMT = 'DEALSDGF'
     C                   EVAL      WRKBOV = BOVD                                              224116
     C                   IF        CAS005 = 'Y' AND
     C                             DTYP = 'RX'  AND
     C                             FSHSID = 'T'
     C                   EVAL      WRKCCY = TCUCY
     C                   EVAL      WRKPR$ = TPAMT
     C                   ELSE
     C                   EVAL      WRKCCY = UCUCY
     C                   EVAL      WRKPR$ = UPAMT
     C                   ENDIF
 
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
     C                             AND FSRIND = ' '                                           225293
     C                   EVAL      WDTYP = DTYP                                               229406
     C                   EXSR      SRChkHdgI                                                  225293
     C                   EVAL      DTYP = WDTYP                                               229406
     C                   ENDIF                                                                225293
 
     C**********         IF        CAS005 = 'Y'                                        CAS005 CAS006
                                                                                              CAS005
     C**********         IF        DTYP = 'RS'                                         CAS005 CAS006
     C                   IF        DTYP = 'RS' AND CAS005 = 'Y'                               CAS006
     C                   IF        FSRIND = 'L'                                               CAS005
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****FSDLNO        CHAIN     IRNPVAL0                           56               CAS005 CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                           56                      CLE148
     C                   ENDIF                                                                CAS005
     C                   IF        FSRIND = 'B'                                               CAS005
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****FSDLNO        CHAIN     IRNPVBL0                           56               CAS005 CLE148
     C     FSDLNO2       CHAIN     IRNPVBL0                           56                      CLE148
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C**********         IF        DTYP = 'RX'                                         CAS005 CAS006
     C                   IF        DTYP = 'RX' AND CAS005 = 'Y'                               CAS006
     C                   IF        FSRIND = 'L'                                               CAS005
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C     KRXNPV        CHAIN     RXNPVAL1                           56                      CAS005
     C                   ENDIF                                                                CAS005
     C                   IF        FSRIND = 'B'                                               CAS005
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C     KRXNPV        CHAIN     RXNPVBL1                           56                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        DTYP = 'FR' AND CAS006 = 'Y'                               CAS006
     C                   IF        FSRIND = 'L'                                               CAS006
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase <> 'Y'                                          225293
     C*****FSDLNO        CHAIN     FRNPVAL0                           56               CAS006 CLE148
     C     FSDLNO2       CHAIN     FRNPVAL0                           56                      CLE148
     C                   ENDIF                                                                CAS006
     C                   IF        FSRIND = 'B'                                               CAS006
     C                             OR FSRIND = ' '                                            225293
     C                             AND WkBase = 'Y'                                           225293
     C*****FSDLNO        CHAIN     FRNPVLL0                           56               CAS006 CLE148
     C     FSDLNO2       CHAIN     FRNPVLL0                           56                      CLE148
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C**********         ELSE                                                          CAS005 CAS006
                                                                                              CAS005
     C                   IF        *IN56 = *ON                                                CAS006
     C*****FSDLNO        CHAIN     IRNPVLL0                           56                      CAS005
     C*****FSDLNO        CHAIN     IRNPVAL0                           56               CAS005 CLE148
     C     FSDLNO2       CHAIN     IRNPVAL0                           56                      CLE148
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
                                                                                              CAS005
     C**********         ENDIF                                                         CAS005 CAS006
                                                                                              CAS005
     C                   IF        *IN56 = *OFF
     C                   EVAL      URPL = IRURPL
     C                   EVAL      YUPL = IRYUPL
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLENO - Loan processing                                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRLENO        BEGSR
 
     C     FSDLNO        CHAIN     CLOANCLF                           55
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSDLNO        WRKDLN
     C                   EVAL      WRKBKC = BOKC
     C                   EVAL      WRKTYP = LTYP
     C                   EVAL      WRKSTP = SUTP
     C                   EVAL      WRKCNU = CNUM
     C                   EVAL      WRKVAL = VDAT
     C                   EVAL      WRKMAT = MDAT
     C                   EVAL      WRKCCY = CCY
     C                   EVAL      WRKPR$ = CPAM
 
      ** Calculate the Net Treasury Rate
 
     C                   IF        MARG <> 0
     C                   SUB       MARG          INTR
     C                   ENDIF
 
     C     10000000      MULT(H)   INTR          WRKINT
 
     C                   EVAL      URPL = FSURPL
     C                   EVAL      YUPL = FSYUPL
                                                                                              CAS005
     C                   IF        CAS005 = 'Y'                                               CAS005
     C     FSDLNO        CHAIN     LENPVLL0                                                   CAS005
     C**********         IF        NOT %EOF(LENPVLL0)                                  CAS005 224214
     C                   IF        %FOUND(LENPVLL0)                                           224214
     C                   EVAL      URPL = LEURPL                                              CAS005
     C                   EVAL      YUPL = LEYUPL                                              CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRFHNO - Forecast Transaction processing                      *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRFHNO        BEGSR
 
     C*****FSDLNO        CHAIN     ASFHTRL1                           55                      CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           55                      CLE148
 
     C                   IF        *IN55 = *OFF
     C                   MOVEL     FSDLNO        WRKDLN
     C                   EVAL      WRKTYP = 'FH'
     C                   EVAL      WRKSTP = FSSUBT
     C                   EVAL      WRKMAT = FSMDAT
     C                   EVAL      WRKCCY = FSCCY
     C                   EVAL      WRKPR$ = FSAMNT
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   Z-SUB     WkFHURPL      WkFHURPL                                     CAS006
     C                   EVAL      URPL = WkFHURPL                                            CAS006
     C                   EVAL      YUPL = FSYUPL                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT                                                                                  CAS003
      *****************************************************************                       CAS003
      *                                                               *                       CAS003
      * SRFFNO - Futures Position processing                          *                       CAS003
      *                                                               *                       CAS003
      * Called by: Main Processing                                    *                       CAS003
      *                                                               *                       CAS003
      * Calls: None                                                   *                       CAS003
      *                                                               *                       CAS003
     C*****************************************************************                       CAS003
                                                                                              CAS003
     C     SRFFNO        BEGSR                                                                CAS003
                                                                                              CAS003
      ** Futures Position Mode                                                                CAS003
                                                                                              CAS003
     C**********         IF        FSDLNO = *ZEROS AND FSFPSE <> *BLANKS               CAS003 CLE148
     C                   IF        FSDLNO = *BLANKS AND FSFPSE <> *BLANKS                     CLE148
     C                             AND INSFLD <> *BLANKS                                      CAS003
                                                                                              CAS003
     C                   EVAL      M = 1                                                      CAS003
     C                   EVAL      *IN66 = *OFF                                               CAS003
     C     INSMM@        LOOKUP    MON(M)                                 66                  CAS003
                                                                                              CAS003
     C                   IF        *IN66 = *ON                                                CAS003
     C                   Z-ADD     NUM(M)        INSMM                                        CAS003
     C                   MOVE      INSYY@        INSYY                                        CAS003
                                                                                              CAS003
     C     KEYPST        KLIST                                                                CAS003
     C                   KFLD                    H1BRCA                                       CAS003
     C                   KFLD                    FSBKCD                                       CAS003
     C                   KFLD                    INSKEY                                       CAS003
     C                   KFLD                    INSYY                                        CAS003
     C                   KFLD                    INSMM                                        CAS003
     C                   KFLD                    FSPCAL                                       CAS003
                                                                                              CAS003
     C     KEYPST        CHAIN     FFNPVLL0                           55                      CAS003
                                                                                              CAS003
     C                   IF        *IN55 = *OFF                                               CAS003
     C                   MOVEL     FSDLNO        WRKDLN                                       CAS003
     C                   EVAL      WRKBKC = FSBKCD                                            CAS003
     C                   EVAL      WRKSTP = FSPCAL                                            CAS003
     C                   EVAL      WRKCCY = FSCCY                                             CAS003
     C                   EVAL      WRKPR$ = FFCUTV                                            CAS003
     C     10000000      MULT(H)   FFSTRP        WRKINT                                       CAS003
     C                   EVAL      URPL = FFURPL                                              CAS003
     C                   EVAL      YUPL = FFYUPL                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Futures Transaction Mode                                                             CAS003
                                                                                              CAS003
     C                   ELSE                                                                 CAS003
                                                                                              CAS003
     C*****FSDLNO        CHAIN     TRANS2                             55               CAS003 CLE148
     C                   MOVEL     FSDLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANS2                             55                      CLE148
                                                                                              CAS003
     C                   IF        *IN55 = *OFF                                               CAS003
     C                   MOVEL     FSDLNO        WRKDLN                                       CAS003
     C                   EVAL      WRKBKC = BOKC                                              CAS003
     C                   EVAL      WRKTYP = ISTT                                              CAS003
     C                   EVAL      WRKCNU = CUSC                                              CAS003
     C                   EVAL      WRKVAL = VALD                                              CAS003
     C                   EVAL      WRKCCY = ISCY                                              CAS003
     C                   EVAL      WRKPR$ = NUCO                                              CAS003
     C     10000000      MULT(H)   COPR          WRKINT                                       CAS003
                                                                                              CAS003
     C                   EVAL      URPL = FSURPL                                              CAS003
     C                   EVAL      YUPL = FSYUPL                                              CAS003
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
      * SRSENO - Security processing                                  *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     SRSENO        BEGSR
 
     C     FSFPSE        CHAIN     SECTY                              55
 
     C                   IF        *IN55 = *OFF
 
     C     KEYBKP        KLIST
     C                   KFLD                    FSFPSE
     C                   KFLD                    H1BRCA
     C                   KFLD                    FSBKCD
     C                   KFLD                    FSMKTI
     C                   KFLD                    FSBHTV
 
     C*****KEYBKP        CHAIN     SENPVLL0                           55                      CAS006
     C     KEYBKP        CHAIN     SEMKVLL0                           55                      CAS006
 
     C                   IF        *IN55 = *OFF
 
     C                   MOVEL     FSFPSE        WRKDLN
     C                   EVAL      WRKBKC = FSBKCD
     C                   EVAL      WRKSTP = FSBHTV
     C                   EVAL      WRKMAT = MATY
     C                   EVAL      WRKCCY = SECCY
     C                   EVAL      WRKPR$ = SEBKCT
     C     10000000      MULT(H)   SEMKTP        WRKINT
     C                   EVAL      URPL = SEURPL
     C                   EVAL      YUPL = SEYUPL
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTRN3 - Load workfields to print Transaction Report          *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
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
     C                   EVAL      PDate = WRKVAL
     C                   EXSR      SRDATE
     C                   EVAL      OVALD = ZADATE
     C                   ENDIF
 
 
     C                   IF        WRKMAT <> 0
     C                   EVAL      PDate = WRKMAT
                                                                                              224116
      ** If deal has been bought out, use buy out date as maturity date                       224116
                                                                                              224116
     C                   IF        WRKBOV <> 0                                                224116
     C                   EVAL      PDate = WRKBOV                                             224116
     C                   ENDIF                                                                224116
                                                                                              224116
     C                   EXSR      SRDATE
     C                   EVAL      OMATD = ZADATE
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
      * SRCvtAmt - Convert Amount before printing                     *
      *                                                               *
      * Called by: SRLOAD                                             *
      *                                                               *
      * Calls: ZSEDIT                                                 *
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
      * SRCURR - Access currency details                              *
      *                                                               *
      * Called by: SRLOAD                                             *
      *                                                               *
      * Calls: AOCURRR0                                               *
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
     C                   EVAL      DBASE = 3
     C                   EVAL      DBKEY = WRKCCY
     C                   EVAL      DBPGM = 'AS001003P'
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
      * SRCCYCVT - Converts amount to base CCY                        *
      *                                                               *
      * Called by: SRUNPL                                             *
      *                                                               *
      * Calls: ZCCYCN                                                 *
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
      * SRDATE - Convert Date to DDMMMYY format                       *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: ZDATE2                                                 *
      *                                                               *
      *****************************************************************
 
     C     SRDATE        BEGSR
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PDate
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        ZDATE
     C                   PARM      *BLANKS       ZADATE
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUPL  - Unrealised P/L-related                               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
 
     C**********         IF        WRKTYP <> 'PS' AND WRKTYP <> 'CX'                          212421
     C**********                   AND WRKTYP <> 'FS' AND WRKTYP <> 'FP'                      212421
     C**********         IF        WRKTYP <> 'RX'                                      CAS005 228274
     C                   IF        WRKTYP <> 'RX' AND WRKTYP <> 'FH'                          228274
 
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
 
     C**********         ENDIF                                                                212421
     C                   ENDIF                                                                CAS005
 
      ** Calculate P/L Difference
 
     C                   EVAL      DIFF = URPL - YUPL
 
      ** For Forecast Transaction hedges only
      ** If CAS006 is not installed, perform old processing, else difference                  CAS006
      ** will be the computed URPL - YUPL                                                     CAS006
 
     C                   IF        CAS006 <> 'Y'                                              CAS006
                                                                                              CAS006
     C                   IF        WFORE = 'Y'
     C                   IF        WEXRE = 'R'
 
     C                   IF        FSDHIN = 'H'
     C                   Z-ADD     WRKPR$        DIFF
     C                   ELSE
     C                   Z-SUB     WRKPR$        DIFF
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        FSDHIN = 'D'
     C                   Z-ADD     WRKPR$        DIFF
     C                   ELSE
     C                   Z-SUB     WRKPR$        DIFF
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
 
      ** Move fields for detail printing
 
     C                   Z-ADD     UPL           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        OURPL
     C                   MOVE      AMT(2)        OYUPL
     C                   MOVE      AMT(3)        ODIFF
 
      ** Total fields for totals printing
 
     C                   Z-ADD     1             CN                1 0
 
     C                   DO        3             CN
 
     C                   IF        EFFFLG = 'I'
 
     C                   SELECT
 
     C                   WHEN      FSDHIN = 'D'
     C                   ADD       UPL(CN)       D0@(CN)
     C                   ADD       UPL(CN)       D1@(CN)
     C                   ADD       UPL(CN)       D2@(CN)
     C                   ADD       UPL(CN)       D3@(CN)
 
     C                   WHEN      FSDHIN = 'H'
     C                   ADD       UPL(CN)       H0@(CN)
     C                   ADD       UPL(CN)       H1@(CN)
     C                   ADD       UPL(CN)       H2@(CN)
     C                   ADD       UPL(CN)       H3@(CN)
 
     C                   ENDSL
 
     C                   ADD       UPL(CN)       T0@(CN)
     C                   ADD       UPL(CN)       T1@(CN)
     C                   ADD       UPL(CN)       T2@(CN)
     C                   ADD       UPL(CN)       T3@(CN)
 
     C                   ELSE
 
     C                   SELECT
 
     C                   WHEN      FSDHIN = 'D'
     C                   ADD       UPL(CN)       D0(CN)
     C                   ADD       UPL(CN)       D1(CN)
     C                   ADD       UPL(CN)       D2(CN)
     C                   ADD       UPL(CN)       D3(CN)
 
     C                   WHEN      FSDHIN = 'H'
     C                   ADD       UPL(CN)       H0(CN)
     C                   ADD       UPL(CN)       H1(CN)
     C                   ADD       UPL(CN)       H2(CN)
     C                   ADD       UPL(CN)       H3(CN)
 
     C                   ENDSL
 
     C                   ADD       UPL(CN)       T0(CN)
     C                   ADD       UPL(CN)       T1(CN)
     C                   ADD       UPL(CN)       T2(CN)
     C                   ADD       UPL(CN)       T3(CN)
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRINL1 - New Hedge Strategy Level Break                       *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRINL1        BEGSR
 
      ** Turn indicator off if not Cash Flow Hedge                                            CAS005
                                                                                              CAS005
     C                   IF        *IN27 = *OFF                                               CAS005
     C                   EVAL      *IN40 = *OFF                                               CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
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
 
     C                   IF        EFFY <> *BLANKS
     C                   EVAL      *IN66 = *ON
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
 
     C                   IF        EFFN <> *BLANKS
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
      * SRINL2 - New Product Type Level Break                         *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
      * SRINL3 - New Branch Level Break                               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRINL3        BEGSR
 
      ** Check if at least one Hedge Linkage exists for Hedge Strategy
 
     C                   EVAL      INBRCA = *BLANKS
 
     C                   EXSR      SRVAL1
 
     C                   IF        *IN77 = *ON
     C                   EVAL      INBRCA = 'Y'
 
     C                   IF        EFFY <> *BLANKS
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      H1BRCA        SENTY
     C                   PARM                    SFILE1
     C                   PARM      SFNUM1        ZSNUM
     C                   PARM      *BLANKS       ZSERR
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        EFFN <> *BLANKS
 
      ** Ensure Report Spool File recorded by RCF.
 
     C                   CALL      'ZSFILE'
     C                   PARM      *BLANKS       SEQ
     C                   PARM      H1BRCA        SENTY
     C                   PARM                    SFILE2
     C                   PARM      SFNUM2        ZSNUM
     C                   PARM      *BLANKS       ZSERR
 
     C                   IF        ZSERR = 'Y'
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
     C                   ENDIF
 
      ** Get Transaction Branch name, only when MBIN = 'Y'
 
     C                   IF        MBIN = 'Y'
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      '*MSG   '     PRTCD
     C                   PARM      '*KEY   '     POPTN
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
      * SRVAL1 - Check if Hedge Linkages exist                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
     C                   EVAL      EFFYN = *BLANKS
 
      ** Position and read Hedge Strategy file based on break
 
     C                   SELECT
 
     C                   WHEN      *IN03 = *ON
     C     @BRCA         SETLL     SDHGSTD3
     C     @BRCA         READE     SDHGSTD3                               89
 
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
     C     @BRCA         READE     SDHGSTD3                               89
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
      * SRVAL2 - Search for live Hedge Linkage records                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
 
     C**********         IF        FSLASD = WURDNB                                            CAS004
     C                   IF        FSSECR <> 'Y'                                              CAS006
 
     C                   IF        FSRECI = 'D'
     C                   EVAL      EFFY = 'Y'
     C                   ELSE
     C                   IF        FSRECI = 'X'
     C                   EVAL      EFFN = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C**********         ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS006
 
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
      * SRLDTO - Print Hedge Linkage totals (Derivative)- Effective   *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        D0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR@DTO - Print Hedge Linkage totals (Derivative) - Ineffective*
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@DTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOD2
 
      ** Derivative
 
     C                   EVAL      AR = D0@
     C                   EXSR      SRAMT
     C                   EVAL      ODURPL = AMT(1)
     C                   EVAL      ODYUPL = AMT(2)
     C                   EVAL      ODDIFF = AMT(3)
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print blank line
 
     C                   IF        *IN44 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (DERIVATIVE)
 
     C                   IF        *IN44 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOD2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        D0@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLHTO - Print Hedge Linkage totals (Hedged) - Effective      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRLHTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOH1
 
      ** Hedged
 
     C                   EVAL      AR = H0
     C                   EXSR      SRAMT
     C                   EVAL      OHURPL = AMT(1)
     C                   EVAL      OHYUPL = AMT(2)
     C                   EVAL      OHDIFF = AMT(3)
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print blank line
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (HEDGED)
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     LINKTOH1
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        H0
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR@HTO - Print Hedge Linkage totals (Hedged) - Ineffective    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@HTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOH2
 
      ** Hedged
 
     C                   EVAL      AR = H0@
     C                   EXSR      SRAMT
     C                   EVAL      OHURPL = AMT(1)
     C                   EVAL      OHYUPL = AMT(2)
     C                   EVAL      OHDIFF = AMT(3)
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print blank line
 
     C                   IF        *IN44 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (HEDGED)
 
     C                   IF        *IN44 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOH2
 
      ** Initialise totals fields after printing
 
     C                   Z-ADD     *ZEROS        H0@
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRLNTO - Print Hedge Linkage totals - Effective               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRLNTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOT1
     C                   CLEAR                   PERCENT1
 
      ** Total
 
     C                   EVAL      AR = T0
     C                   EXSR      SRAMT
     C                   EVAL      OTURPL = AMT(1)
     C                   EVAL      OTYUPL = AMT(2)
     C                   EVAL      OTDIFF = AMT(3)
 
      ** Change Percentage
 
     C                   EXSR      SRCHGP
                                                                                              CAS005
      ** Set Indicator 40 on                                                                  CAS005
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print blank line
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *Off
     C                   ENDIF
     C                   WRITE     BLANK1
 
      ** Print Hedge Linkage totals (TOTAL)
 
     C                   IF        *IN66 = *On
     C                   WRITE     HEADR1
     C                   EVAL      *IN66 = *OFF
     C                   ENDIF
     C                   WRITE     LINKTOT1
 
      ** Print blank line
                                                                                              CAS005
      ** Set Indicator 40 on                                                                  CAS005
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
     C                   EVAL      *IN28 = *OFF                                               225293
     C                   IF        FSLASD = 0                                                 225293
     C                   EVAL      OLASDT = *BLANKS                                           225293
     C                   EVAL      OCHGPC = *BLANKS                                           225293
     C                   EVAL      OPNARR = *BLANKS                                           228011
     C                   MOVE      'NEW'         OCHGPC                                       229801
     C                   EVAL      PDate = FSSTDT                                             225293
     C                   EXSR      SRDATE                                                     225293
     C                   EVAL      OLASDT = ZADATE                                            225293
     C                   EVAL      *IN28 = *ON                                                225293
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
 
     C                   EVAL      T0 = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR@NTO - Print Hedge Linkage totals - Ineffective             *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@NTO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   LINKTOT2
     C                   CLEAR                   PERCENT2
 
      ** Total
 
     C                   EVAL      AR = T0@
     C                   EXSR      SRAMT
     C                   EVAL      OTURPL = AMT(1)
     C                   EVAL      OTYUPL = AMT(2)
     C                   EVAL      OTDIFF = AMT(3)
 
      ** Change Percentage
 
     C                   EXSR      SRCHGP
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
      ** Print blank line
 
     C                   IF        *IN44 = *On
     C                   WRITE     HEADR2
     C                   EVAL      *IN44 = *Off
     C                   ENDIF
     C                   WRITE     BLANK2
 
      ** Print Hedge Linkage totals (TOTAL)
 
     C                   IF        *IN44 = *On
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
     C                   EVAL      OLASDT = WLASDT                                            227257
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
 
     C                   EVAL      T0@ = *Zeros
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCHGP  -Change Percentage calculation                        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
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
 
      ** Edit output field
 
     C                   EVALR     OCHGPC = %TRIMR(OCHGPC)                                    219870
                                                                                              228011
     C                   SELECT                                                               228011
     C                   WHEN      FSHEFP = FSOPCT AND FSRECI = 'D'                           228011
     C                   EVAL      OPNARR = Narrative(1)                                      228011
     C                   WHEN      FSHEFP = 0 AND ODTYP = 'FH'                                228011
     C                   EVAL      OPNARR = Narrative(2)                                      228011
     C                   WHEN      FSHEFP < H1EFLO AND FSHEFP <> 0                            228011
     C                   EVAL      OPNARR = Narrative(3)                                      228011
     C                   WHEN      FSHEFP > H1EFUP                                            228011
     C                   EVAL      OPNARR = Narrative(4)                                      228011
     C                   ENDSL                                                                228011
                                                                                              228011
     C**********         MOVEL     OCHGPC        WRKPC4                                       219870
     C**********         MOVE      OCHGPC        WRKPC1                                       219870
     C**********         IF        WRKPC1 = '.'                                               219870
     C**********         EVAL      OCHGPC = *BLANKS                                           219870
     C**********         MOVEL     WRKPC4        OCHGPC                                       219870
     C**********         ENDIF                                                                219870
                                                                                              CAS005
      ** Last assessment date                                                                 CAS005
                                                                                              CAS005
     C                   EVAL      PDate = FSLASD                                             CAS005
     C                   EXSR      SRDATE                                                     CAS005
     C**********         EVAL      OLASDT = *BLANK                                     CAS005 225293
     C**********         EVAL      OLASDT = ZADATE                                     CAS005 225293
     C                   EVAL      WLASDT = ZADATE                                            225293
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRL1TO - Print Hedge Strategy totals - Effective              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRL1TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD1
     C                   CLEAR                   HSENTOH1
     C                   CLEAR                   HSENTON1
 
      ** Derivative
 
     C                   Z-ADD     D1            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD1
     C                   MOVE      AMT(2)        YUPLD1
     C                   MOVE      AMT(3)        DIFFD1
 
      ** Hedged
 
     C                   Z-ADD     H1            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH1
     C                   MOVE      AMT(2)        YUPLH1
     C                   MOVE      AMT(3)        DIFFH1
 
      ** Total
 
     C                   Z-ADD     T1            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN1
     C                   MOVE      AMT(2)        YUPLN1
     C                   MOVE      AMT(3)        DIFFN1
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      L1CNT = *Zeros
     C                   EVAL      D1 = *Zeros
     C                   EVAL      H1 = *Zeros
     C                   EVAL      T1 = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRL1TO - Print Hedge Strategy totals - Ineffective            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@1TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   HSENTOD2
     C                   CLEAR                   HSENTOH2
     C                   CLEAR                   HSENTON2
 
      ** Derivative
 
     C                   Z-ADD     D1@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD1
     C                   MOVE      AMT(2)        YUPLD1
     C                   MOVE      AMT(3)        DIFFD1
 
      ** Hedged
 
     C                   Z-ADD     H1@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH1
     C                   MOVE      AMT(2)        YUPLH1
     C                   MOVE      AMT(3)        DIFFH1
 
      ** Total
 
     C                   Z-ADD     T1@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN1
     C                   MOVE      AMT(2)        YUPLN1
     C                   MOVE      AMT(3)        DIFFN1
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      @1CNT = *Zeros
     C                   EVAL      D1@ = *Zeros
     C                   EVAL      H1@ = *Zeros
     C                   EVAL      T1@ = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRL2TO - Print Product Type totals - Effective                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRL2TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD1
     C                   CLEAR                   PRTPTOH1
     C                   CLEAR                   PRTPTON1
 
      ** Derivative
 
     C                   Z-ADD     D2            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD2
     C                   MOVE      AMT(2)        YUPLD2
     C                   MOVE      AMT(3)        DIFFD2
 
      ** Hedged
 
     C                   Z-ADD     H2            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH2
     C                   MOVE      AMT(2)        YUPLH2
     C                   MOVE      AMT(3)        DIFFH2
 
      ** Total
 
     C                   Z-ADD     T2            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN2
     C                   MOVE      AMT(2)        YUPLN2
     C                   MOVE      AMT(3)        DIFFN2
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      L2CNT = *Zeros
     C                   EVAL      D2 = *Zeros
     C                   EVAL      H2 = *Zeros
     C                   EVAL      T2 = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR@2TO - Print Product Type totals - Ineffective              *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@2TO        BEGSR
 
      ** Clear totals printer file records
 
     C                   CLEAR                   PRTPTOD2
     C                   CLEAR                   PRTPTOH2
     C                   CLEAR                   PRTPTON2
 
      ** Derivative
 
     C                   Z-ADD     D2@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD2
     C                   MOVE      AMT(2)        YUPLD2
     C                   MOVE      AMT(3)        DIFFD2
 
      ** Hedged
 
     C                   Z-ADD     H2@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH2
     C                   MOVE      AMT(2)        YUPLH2
     C                   MOVE      AMT(3)        DIFFH2
 
      ** Total
 
     C                   Z-ADD     T2@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN2
     C                   MOVE      AMT(2)        YUPLN2
     C                   MOVE      AMT(3)        DIFFN2
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      @2CNT = *Zeros
     C                   EVAL      D2@ = *Zeros
     C                   EVAL      H2@ = *Zeros
     C                   EVAL      T2@ = *Zeros
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRL3TO - Print Branch Totals - Effective                      *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRL3TO        BEGSR
 
     C                   IF        L3CNT > *Zeros
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD1
     C                   CLEAR                   BRCATOH1
     C                   CLEAR                   BRCATON1
 
      ** Derivative
 
     C                   Z-ADD     D3            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD3
     C                   MOVE      AMT(2)        YUPLD3
     C                   MOVE      AMT(3)        DIFFD3
 
      ** Hedged
 
     C                   Z-ADD     H3            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH3
     C                   MOVE      AMT(2)        YUPLH3
     C                   MOVE      AMT(3)        DIFFH3
 
      ** Total
 
     C                   Z-ADD     T3            AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN3
     C                   MOVE      AMT(2)        YUPLN3
     C                   MOVE      AMT(3)        DIFFN3
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      L3CNT = *Zeros
     C                   EVAL      D3 = *Zeros
     C                   EVAL      H3 = *Zeros
     C                   EVAL      T3 = *Zeros
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SR@3TO - Print Branch Totals - Ineffective                    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SR@3TO        BEGSR
 
     C                   IF        @3CNT > *Zeros
 
      ** Clear totals printer file records
 
     C                   CLEAR                   BRCATOD2
     C                   CLEAR                   BRCATOH2
     C                   CLEAR                   BRCATON2
 
      ** Derivative
 
     C                   Z-ADD     D3@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLD3
     C                   MOVE      AMT(2)        YUPLD3
     C                   MOVE      AMT(3)        DIFFD3
 
      ** Hedged
 
     C                   Z-ADD     H3@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLH3
     C                   MOVE      AMT(2)        YUPLH3
     C                   MOVE      AMT(3)        DIFFH3
 
      ** Total
 
     C                   Z-ADD     T3@           AR
     C                   EXSR      SRAMT
     C                   MOVE      AMT(1)        URPLN3
     C                   MOVE      AMT(2)        YUPLN3
     C                   MOVE      AMT(3)        DIFFN3
                                                                                              CAS005
     C                   IF        WIn40Flag = 'Y'                                            CAS005
     C                   EVAL      *IN40 = *ON                                                CAS005
     C                   ENDIF                                                                CAS005
 
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
 
     C                   EVAL      @3CNT = *Zeros
     C                   EVAL      D3@ = *Zeros
     C                   EVAL      H3@ = *Zeros
     C                   EVAL      T3@ = *Zeros
 
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
     C                   MOVEL     HIFSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALALL                                                    CLE148
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
      * SRAMT   -Convert numeric amounts into character fields        *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
 
     C     SRAMT         BEGSR
 
     C                   Z-ADD     1             CN
     C                   MOVEA     *BLANKS       AMT
 
     C                   DO        3             CN
 
     C*****AR(CN)        IFNE      *ZEROS                                                     CAS004
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
 
     C**********         ENDIF                                                                CAS004
 
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAUDIT - Subroutine to Output Audit report and End Program.  *
      *                                                               *
      *  Called By: Main Processing, PROCES, *PSSR                    *
      *  Calls: None.                                                 *
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
      /EJECT                                                                                  228011
      *****************************************************************                       228011
      *                                                               *                       228011
      *  SRInitArray - Initialize UP/UL arrays                        *                       228011
      *                                                               *                       228011
      *  Called By: *INZSR                                            *                       228011
      *  Calls: None.                                                 *                       228011
      *                                                               *                       228011
      *****************************************************************                       228011
     C     SRInitArray   BEGSR                                                                228011
                                                                                              228011
     C                   Z-ADD     0             D0                                           228011
     C                   Z-ADD     0             D1                                           228011
     C                   Z-ADD     0             D2                                           228011
     C                   Z-ADD     0             D3                                           228011
     C                   Z-ADD     0             H0                                           228011
     C                   Z-ADD     0             H1                                           228011
     C                   Z-ADD     0             H2                                           228011
     C                   Z-ADD     0             H3                                           228011
     C                   Z-ADD     0             T0                                           228011
     C                   Z-ADD     0             T1                                           228011
     C                   Z-ADD     0             T2                                           228011
     C                   Z-ADD     0             T3                                           228011
     C                   Z-ADD     0             D0@                                          228011
     C                   Z-ADD     0             D1@                                          228011
     C                   Z-ADD     0             D2@                                          228011
     C                   Z-ADD     0             D3@                                          228011
     C                   Z-ADD     0             H0@                                          228011
     C                   Z-ADD     0             H1@                                          228011
     C                   Z-ADD     0             H2@                                          228011
     C                   Z-ADD     0             H3@                                          228011
     C                   Z-ADD     0             T0@                                          228011
     C                   Z-ADD     0             T1@                                          228011
     C                   Z-ADD     0             T2@                                          228011
     C                   Z-ADD     0             T3@                                          228011
                                                                                              228011
     C                   ENDSR                                                                228011
                                                                                              228011
      *****************************************************************                       228011
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
                                                                                              CAS003
      ** Check if CAS003 is switched on                                                       CAS003
                                                                                              CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *Blanks       PRTCD                                        CAS003
     C                   PARM      '*KEY   '     POPTN                                        CAS003
     C                   PARM      'CAS003'      PSAR                                         CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        PRTCD = *Blanks                                            CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
     C                   ELSE                                                                 CAS003
     C                   IF        PRTCD <> '*NRF   '                                         CAS003
     C     *LOCK         IN        LDA                                                        CAS003
     C                   EVAL      DBKey = PSAR                                               CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBASE = 4                                                  CAS003
     C                   OUT       LDA                                                        CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
     C                   ENDIF                                                                CAS003
 
      ** Check if CAS004 is switched on                                                       CAS004
                                                                                              CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *Blanks       PRTCD                                        CAS004
     C                   PARM      '*KEY   '     POPTN                                        CAS004
     C                   PARM      'CAS004'      PSAR                                         CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        PRTCD = *Blanks                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   IF        PRTCD <> '*NRF   '                                         CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBKey = PSAR                                               CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE = 5                                                  CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Call access program for General Ledger details                                       CAS004
                                                                                              CAS004
     C**********         CALL      'AOGELRR0'                                          CAS004 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     PRTCD                                        CAS004
     C                   PARM      '*FIRST '     POPTN                                        CAS004
     C     SDGELR        PARM      SDGELR        DSSDY                                        CAS004
                                                                                              CAS004
      ** Database Error                                                                       CAS004
                                                                                              CAS004
     C                   IF        PRTCD <> *BLANKS                                           CAS004
     C     *LOCK         IN        LDA                                                        CAS004
     C                   EVAL      DBFILE = 'SDGELRPD'                                        CAS004
     C                   EVAL      DBASE = 6                                                  CAS004
     C                   EVAL      DBKEY = POPTN                                              CAS004
     C                   OUT       LDA                                                        CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   EVAL      WEvCtlDt = BJDNWD - 1                                      CAS004
     C                   IF        BKAPDT < WEvCtlDt                                          CAS004
     C                   EVAL      WEvCtlDt = BKAPDT                                          CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      PDate = WEvCtlDt                                           CAS004
     C                   EXSR      SRDATE                                                     CAS004
     C**********         EVAL      OEVCD = ZADATE                                      CAS004 219870
     C                   EVAL      OEVCD1 = ZADATE                                            219870
     C                   EVAL      OEVCD2 = ZADATE                                            219870
     C                   EVAL      OEVCD3 = ZADATE                                            219870
                                                                                              CAS004
     C                   CALL      'AOHEDGR0'                                                 228011
     C                   PARM      *BLANKS       PRTCD                                        228011
     C                   PARM      '*FIRST '     POPTN                                        228011
     C     SDHEDG        PARM      SDHEDG        DSFDY                                        228011
                                                                                              228011
      ** Database Error                                                                       228011
                                                                                              228011
     C                   IF        PRTCD <> *BLANKS                                           228011
     C                   EVAL      DBFILE = 'SDHEDGPD'                                        228011
     C                   EVAL      DBASE = 10                                                 228011
     C                   EVAL      DBKEY = '*FIRST'                                           228011
     C                   EVAL      DBPGM = 'AOHEDGR0'                                         228011
     C                   EXSR      *PSSR                                                      228011
     C                   ENDIF                                                                228011
                                                                                              228011
      ** Check if CAS005 is switched on                                                       CAS005
                                                                                              CAS005
     C                   CALL      'AOSARDR0'                                                 CAS005
     C                   PARM      *Blanks       PRTCD                                        CAS005
     C                   PARM      '*KEY   '     POPTN                                        CAS005
     C                   PARM      'CAS005'      PSAR                                         CAS005
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS005
                                                                                              CAS005
     C                   IF        PRTCD = *Blanks                                            CAS005
     C                   EVAL      CAS005 = 'Y'                                               CAS005
     C                   ELSE                                                                 CAS005
     C                   IF        PRTCD <> '*NRF   '                                         CAS005
     C     *LOCK         IN        LDA                                                        CAS005
     C                   EVAL      DBKey = PSAR                                               CAS005
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS005
     C                   EVAL      DBASE = 4                                                  CAS005
     C                   OUT       LDA                                                        CAS005
     C                   EXSR      *PSSR                                                      CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
     C                                                                                        CAS005
                                                                                              CAS006
      ** Check if CAS006 is switched on                                                       CAS006
                                                                                              CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*KEY   '     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSAR                                         CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *Blanks                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   IF        PRTCD <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBKey = PSAR                                               CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE = 9                                                  CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     KFCNPV        KLIST
     C                   KFLD                    KCNPVM
     C                   KFLD                    KCDLNO
     C                   KFLD                    KCCYCD
 
      ** Product Type Key List
 
     C     KYPRTP        KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @PRTP
 
      ** Strategy Key List
 
     C     KYHESN        KLIST
     C                   KFLD                    @BRCA
     C                   KFLD                    @PRTP
     C                   KFLD                    @HESN
 
      ** Linkage Key List
 
     C     KYTRAN        KLIST
     C                   KFLD                    FSHEDI
     C                   KFLD                    HGHDIN
 
     C     KRXNPV        KLIST
     C**********         KFLD                    FSDLNO                                       CLE148
     C                   KFLD                    FSDLNO2                                      CLE148
     C                   KFLD                    WRKCCY
 
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
     C     *LIKE         DEFINE    FSNPVM        KCNPVM
     C******LIKE         DEFINE    FSDLNO        KCDLNO                                       CLE148
     C     *LIKE         DEFINE    FSCYCD        KCCYCD
 
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
     C                   PARM      *BLANKS       SEQ
     C                   PARM      *BLANKS       SENTY
     C                   PARM                    SFILEU
     C                   PARM      SFNUMU        ZSNUMU
     C                   PARM      *BLANK        ZSERR
 
      ** Retrieve Base Currency Details
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*KEY   '     POPTN
     C                   PARM                    BJCYCD
     C     SDCURR        PARM      SDCURR        DSSDY
 
      ** Database Error
 
     C                   IF        PRTCD <> *BLANKS
     C                   EVAL      DBFILE = 'SDCURRPD'
     C                   EVAL      DBASE = 2
     C                   EVAL      DBKEY = BJCYCD
     C                   EVAL      DBPGM = 'AS001003P'
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   EVAL      PCCYT = A6CYCD
     C                   EVAL      PRATET = A6SPRT
     C                   EVAL      PMDINT = A6MDIN
     C                   EVAL      PCDPT = A6NBDP
 
      ** Retrieve Dealing data
 
     C                   READ      SDDEALL1                               15
     C                   IF        *IN15 = *OFF
     C                   IF        BNNPVM = *BLANKS
     C                   EVAL      KCNPVM = 'N'
     C                   ELSE
     C                   EVAL      KCNPVM = BNNPVM
     C                   ENDIF
     C                   ENDIF
                                                                                              228011
     C                   EXSR      SRInitArray                                                228011
 
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
      * Called by: (**calling routines**)                             *
      *                                                               *
      * Calls: None                                                   *
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
**   MON/NUM Month Short Name and Number
JAN01FEB02MAR03APR04MAY05JUN06JUL07AUG08SEP09OCT10NOV11DEC12
** Product Types
FV
FX
CF
** Narratives for Printer Files                                                               228011
- De minimis Percentage                                                                       228011
- Critical terms do not match                                                                 228011
- Less than Lower Percentage                                                                  228011
- Greater Than Upper Percentage                                                               228011
