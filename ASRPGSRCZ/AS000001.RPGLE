     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AS Hedge linkages mnt/enq/sel screen')           *
      *****************************************************************
      *                                                               *
      ***Midas*-*FAS133*Module*****************************************                       CAS004
      *  Midas - Accounting Standards Module                          *                       CAS004
      *                                                               *
      *  AS000001 - Hedge Linkage Table                               *
      *                                                               *
      *  Function:  This table will enable the user to link a hedging *
      *             derivative to a hedged Money Market, Foreign      *
      *             Exchange, Customer Lending transaction or to a    *
      *             Security.  Upon entry of a linkage, the deal/loan *
      *             types/sub-types and book codes for both sides of  *
      *             the linked hedge will be validated against the    *
      *             hedge strategy table.                             *
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
      *                 230488             Date 21Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 04Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 BUG9551            Date 09Jan06               *
      *                 CSE071             Date 19Jul05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 228948             Date 27Sep04               *
      *                 229174             Date 24Aug04               *
      *                 228042             Date 28Jun04               *
      *                 228541             Date 26Jul04               *
      *                 227747             Date 15Jun04               *
      *                 CAS008             Date 11May04               *
      *                 CAS007             Date 26Apr04               *
      *                 228102             Date 23Jun04               *
      *                 226221             Date 01Apr04               *
      *                 225342             Date 25Mar04               *
      *                 224942             Date 10Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 224734             Date 30Jan04               *
      *                 224554             Date 23Jan04               *
      *                 223805             Date 15Dec03               *
      *                 CAS006             Date 21Jan03               *
      *                 CAS005             Date 16Dec02               *
      *                 212430             Date 20Nov02               *
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
      *  230488 - Unable to display more then one screen by subfile   *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  BUG9551- ASC000013 component failed (due to blank hedge      *
      *           currency)                                           *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  228948 - Add 'Exclude Accrued Interest in Unrealized Profit  *
      *           or Loss' (Recompile).                               *
      *  229174 - No's auto incremented based on F9.                  *
      *  228042 - Properly allocate Hedge IDs in the system.          *
      *  228541 - IAS Transaction deleted, not possible to remove     *
      *           from Hedge Linkage.                                 *
      *  227747 - Allow deletion of an existing single transaction    *
      *           after the validation of the newly inserted          *
      *           transaction without leaving the program             *
      *  CAS008 - Delayed Hedge Assessment                            *
      *  CAS007 - Hedge Accounting Control                            *
      *  228102 - Collection data fields not initilised for dollar    *
      *           Off-set method.                                     *
      *  226221 - Hedged Transactions should have the same branch as  *
      *           the Hedge Strategy                                  *
      *  225342 - Next collection date should be set correctly after  *
      *           the first collection date.                          *
      *  224942 - Amending a hedge linkage under Regression is        *
      *           disallowed                                          *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  224734 - Forecast hedge item not inserted due to error       *
      *           message Id ASM0075.                                 *
      *  224554 - Hedge Linkage Maintenance should not validate       *
      *           Investment Category field                           *
      *  223805 - Hedge Linkage Maintenance Shows 'Matured' Status    *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CAS005 - Enhancements to CAS001, CAS002 and CAS004           *
      *  212430 - Various errors on deleted transactions and deleted  *
      *           linkages                                            *
      *  CAS004 - Hedge Accounting Phase A                            *
      *           Add validation for Deal Derivative(CX)              *
      *  CAS003 - Hedge Strategy/Linkage for Futures and Options      *
      *  CAS002 - Hedge Strategy/Linkage                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      * ID F  C  H  L    Function of Indicators                       *
      *                                                               *
      *       01 - 24 Reserved Indicators                             *
      *       25  Free Indicator                                      *
      *                                                               *
      *       26  End Of File      (during read)                      *
      *       27  Record not found (during chain)                     *
      *       28  Maintenance Mode                                    *
      *       29  Enquiry Mode                                        *
      *       30  Selection Mode                                      *
      *                                                               *
      *       31  Error on Selection Option                           *
      *       32  Error on New Hedge ID                               *
      *       33  Error on Hedge Strategy                             *
      *       34  Error on Effective Date                             *
      *       35  Error on Input Date                                 *
      *       36  Error on Functional Currency Offset                 *
      *       37  Error on Investment Category                        *
      *       38  Error on Start Date                                 *
      *       39  Error on End Date                                   *
      *       40  Error on Hedge Derivative Deals                     *
      *       41  Error on Hedge Futures Position                     *
      *       42  Error on Hedged Deals/Loans                         *
      *       43  Error on Hedged Security Reference                  *
      *       44  Error on Subfile Action Code                        *
      *       45  Error on Subfile Midas Module                       *
      *       46  Error on Subfile Deal/Trade Number                  *
      *                            Deal/Loan/FH Number (Scn 5)        *
      *       47  Error on Subfile Futures/Options                    *
      *                            Security Reference (Scn 5)         *
      *       48  Error on Subfile Book Code                          *
      *       49  Error on Subfile Branch Code                        *
      *       50  Error on Subfile Put/Call                           *
      *                            Trade/Value Date Basis (Scn 5)     *
      *       51  Error on Subfile Percentage                         *
      *       52  Error on Subfile Market Indicator                   *
      *       53  CAS006 in installed                                 *                       CAS006
      *       54  Protect New fields for CAS006                       *                       CAS006
      *       55  Protect Action Code                                 *                       212430
      *       56  Protect Field Midas Module                          *                       212430
      *       57  Protect Percentage                                  *                       212430
      *       58  EOF                                                 *                       212430
      *       60  Show on screen footer 'Deleted Hedge/d Item'        *                       212430
      *                                                               *
      *       53 - 60 Free Indicators                                 *
      *                                                               *
      *       61  Amend Mode                                          *
      *       62  Delete Mode                                         *
      *       (*note: Insert mode if 61, 62, and 29 are off)          *
      *       63  Derivative Deal                                     *
      *       64  Derivative Futures Position (General)               *
      *       65  Derivative Futures Position (Futures Trans. Mode)   *
      *       66  Hedged Deal/Loan/Forecast Transaction               *
      *       67  Hedged Security Reference                           *
      *       68  Status field in initial subfile not blanks          *
      *       69  Hedge Derivative Deal is Available                  *
      *       70  Hedge Futures Position/Trades is Available          *
      *       71  Hedged Deal/Loan/Forecast Transaction is Available  *
      *       72  Hedged Security Reference is Available              *
      *       73  No Data to display                                  *
      *                                                               *
      *       74 - 79 Free Indicator                                  *
      *       74  Error on Data Type                                  *                       CAS006
      *       75  Error on Data Points Required                       *                       CAS006
      *       76  Error on Data Collection Frequency                  *                       CAS006
      *       77  Error on Day of the Week                            *                       CAS006
      *       78  Error on Day of the Month                           *                       CAS006
      *       79  Error on Next Data Collection Date                  *                       CAS006
      *                                                               *
      *       80  F3=Exit  F12=Previous                               *
      *       81  A=Amend  D=Delete                                   *
      *       82  F5=Refresh                                          *
      *       83  F9=Go to Add Mode                                   *
      *                                                               *
      *       84 - 87 Free Indicator                                  *
      *                                                               *
      *       88  Work indicator 1                                    *
      *       89  Work indicator 2                                    *
      *                                                               *
      *       90  Free Indicator                                      *
      *                                                               *
      *       91  Subfile Clear                                       *
      *       92  Subfile Display / Display Control                   *
      *       93  Subfile Next Change                                 *
      *       94  Free Indicator                                      *
      *       95  Subfile End                                         *
      *       96  Message Subfile Display Control                     *
      *       97  Message Subfile End                                 *
      *       98  Rollup                                              *
      *       99  Free Indicator                                      *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
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
 
     FAS000001DFCF   E             WORKSTN INFSR(*PSSR)
     F                                     SFILE(AS000001S1:WkSRRN1)
     F                                     SFILE(AS000001S2:WkSRRN2)
     F                                     SFILE(AS000001S3:WkSRRN3)
      ** Hedge Linkage Table Maintenance Display File
 
     FASHGLKL1  IF   E           K DISK    INFSR(*PSSR)
      ** Hedge Linkage File Retrieval Index by Hedge ID
 
     FASHGLKL0  UF A E           K DISK    INFSR(*PSSR)
     F                                     COMMIT
     F                                     RENAME(ASHGLKD0:ASHGLKUPD)
     F                                     PREFIX(U_)
      ** Hedge Linkage File Update by Hedge ID
 
     F***ASHTRNL1  IF   E           K DISK    INFSR(*PSSR)                                    CAS004
     F**********                           PREFIX(T1)                                         CAS004
      ***Midas*AS Hedge Transaction File Retrieval by Hedge ID/Indicator                      CAS004
 
     FASHTRNL2  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND2)
     F                                     PREFIX(T2)
 
      ** Midas AS Hedge Transaction File Retrieval by Deal/Futures Number
 
     FASHTRNL4  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND4)
     F                                     PREFIX(T4:2)
     F                                     COMMIT
      ** Midas AS Hedge Transaction File Retrieval
      **  by Hedge ID/Deal/Futures Number
 
     FASHTRNL5  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND5)
     F                                     PREFIX(T5:2)
     F                                     COMMIT
      ** Midas AS Hedge Transaction File Retrieval
      **  by Hedge ID/Loan/Security Number
 
     FASHTRNL8  UF A E           K DISK    INFSR(*PSSR)
     F                                     RENAME(ASHTRND0:ASHTRND8)
     F                                     PREFIX(T8:2)
     F                                     COMMIT
      ** Midas AS Hedge Transaction File Retrieval
                                                                                              CAS004
     FASHTRNLB  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     PREFIX(T1)                                         CAS004
     F                                     RENAME(ASHTRND0:ASHTRNDB)                          CAS004
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID/Indicator                      CAS004
                                                                                              CAS004
 
     FASFHTRL1  IF   E           K DISK    INFSR(*PSSR)
     F                                     PREFIX(FC:2)
      ** Forecast Transaction Details Master File Retrieval Index
 
     FDEALALL   IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(DEALSDAF)
     F                                     IGNORE(DEALSDFF)
 
     FCLOAN     IF   E           K DISK    INFSR(*PSSR)
     F                                     IGNORE(CLOANHHF)
     F                                     IGNORE(CLOANCKF)
     F                                     IGNORE(CLOANZ1F)
      ** LE Loans File
 
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
      ** Securities File
 
     FPOSTNK5   IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Book pos. by branch, book, and instrument type
 
     FTRANS2    IF   E           K DISK    INFSR(*PSSR)
      ** FF Transaction details
 
     FBKPHD     IF   E           K DISK    INFSR(*PSSR)
      ** Midas SE Book Position Headers
 
     FINTYP     IF   E           K DISK    INFSR(*PSSR)
      ** Midas FF Instrument Types
 
     FSDFCTLL0  UF   E           K DISK    COMMIT
     F                                     INFSR(*PSSR)
      ** Standing Data Controls Update index
 
     FASHTRNL6  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(ASHTRND0:ASHTRND6)                          CAS004
     F                                     PREFIX(T6:2)                                       CAS004
      ** Midas AS Hedge Transaction File Retrieval by Module/DLNO                             CAS004
                                                                                              CAS004
     FDLDLDCL1  IF   E           K DISK    INFSR(*PSSR)                                       CAS004
     F                                     RENAME(DEALSDCF:DEALSC)                            CAS004
     F                                     PREFIX(DC)                                         CAS004
      ** Midas MM Deals by Deal Number                                                        CAS004
                                                                                              CAS004
     FSDTDTBL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas SD T-Distrbution Table                                                         CAS006
                                                                                              CAS006
     FASLEHML2  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas AS LE Historic Mrkt Data File                                                  CAS006
                                                                                              CAS006
     FASDLHML2  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas AS DL Historic Mrkt Data File                                                  CAS006
                                                                                              CAS006
     FASSEHML0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
      ** Midas AS SE Historic Mrkt Data File                                                  CAS006
                                                                                              CAS006
     FASHTRNL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(ASHTRND0:ASHTRND1)                          CAS006
     F                                     PREFIX(T0:2)                                       CAS006
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID/Indicator                      CAS006
                                                                                              CAS006
     FASHTRNLC  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(ASHTRND0:ASHTRNDC)                          CAS006
     F                                     PREFIX(TC:2)                                       CAS006
      ** Midas AS Hedge Transaction File Retrieval by Hedge ID/Indicator                      CAS006
                                                                                              CAS006
     FASHTRNL3  IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     RENAME(ASHTRND0:ASHTRNDG)                          CAS006
     F                                     PREFIX(LG:2)                                       CAS006
      ** Midas AS Hedge Transaction File Retrieval by DHIn/DlNo/FPSE/Bk/Brch/                 CAS006
      ** PCal/MktI/TV                                                                         CAS006
                                                                                              CAS006
     FASAHIDL0  UF A E           K DISK    INFSR(*PSSR)                                       228042
     F                                     COMMIT                                             228042
      ** Midas AS Allocated Hedge IDs File by Hedge ID Update                                 228042
                                                                                              228042
     FASAHIDL1  IF   E           K DISK    INFSR(*PSSR)                                       229174
     F                                     RENAME(ASAHIDD0:ASAHIDD1)                          229174
      ** Midas AS Allocated Hedge IDs File by Hedge ID Retrieval                              229174
                                                                                              229174
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Work Message Id array
     D WMsgIdArrP      S                   LIKE(WMsgIdArr)
     D                                     DIM(ArrayMax)
 
      ** Arrays to hold fields from SDHGSTPD
     D DVTypAr         S             10A   DIM(10)
     D DVTypAr5        S              5A   DIM(20)
     D DVTypAr2        S              2A   DIM(50)
     D DVTypAr2b       S              2A   DIM(10)
     D DVSTypAr        S              2A   DIM(10)
     D DVBkCdAr        S              2A   DIM(10)
     D HGTypAr         S              3A   DIM(10)
     D HGTypAr2b       S              2A   DIM(10)
     D HGSTypAr        S              2A   DIM(10)
     D HGBkCdAr        S              2A   DIM(10)
 
      ** Month name array and Month sequence number array
     D MthNamAr        S              3A   DIM(12)
     D MthNumAr        S              2A   DIM(12)
 
      ** Arrays to hold records from screen 4 and screen5
     D Scn4Arr         S             32A   DIM(ArrayMax)
     D Scn5Arr         S             33A   DIM(ArrayMax)
 
      **---------------------------------------------------------
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             26     26
     D  RecNotFnd             27     27
     D  MntMode               28     28
     D  EnquireMode           29     29
     D  SelMode               30     30
     D  ErrSelOpt             31     31
     D  ErrNwHdgID            32     32
     D  ErrHdgStgy            33     33
     D  ErrEffDate            34     34
     D  ErrInpDate            35     35
     D  ErrFuncCcy            36     36
     D  ErrInvCat             37     37
     D  ErrStrDate            38     38
     D  ErrEndDate            39     39
     D  ErrDVDL               40     40
     D  ErrFTPO               41     41
     D  ErrHGDL               42     42
     D  ErrSECR               43     43
     D  ErrSflAct             44     44
     D  ErrSflMidMdl          45     45
     D  ErrSflDTLNum          46     46
     D  ErrSflFRSRef          47     47
     D  ErrSflBkCode          48     48
     D  ErrSflBrhCde          49     49
     D  ErrSflPCTVDB          50     50
     D  ErrSflPct             51     51
     D  ErrSflMktInd          52     52
     D  WProtectRFlds         54     54                                                       CAS006
     D  ProtectDACT           55     55                                                       212430
     D  ProtectDMOD           56     56                                                       212430
     D  ProtectPRCT           57     57                                                       212430
     D  EndOfFile2            58     58                                                       212430
     D  DeleteTran            60     60                                                       212430
     D  AmendMode             61     61
     D  DeleteMode            62     62
     D  DerivDeal             63     63
     D  DrvFutPosGen          64     64
     D  DrvFutPosFTM          65     65
     D  HdgDlLnFTrn           66     66
     D  HdgSecRef             67     67
     D  StsRvsImg             68     68
     D  DVDLused              69     69
     D  FTPOused              70     70
     D  HGDLused              71     71
     D  SECRused              72     72
     D  NoData2Dsp            73     73
     D  WErrDTTP              74     74                                                       CAS006
     D  WErrDPTS              75     75                                                       CAS006
     D  WErrDFRQ              76     76                                                       CAS006
     D  WErrWDAY              77     77                                                       CAS006
     D  WErrMNTH              78     78                                                       CAS006
     D  WErrNDTA              79     79                                                       CAS006
     D  F3F12Key              80     80
     D  AmndDelete            81     81
     D  F5Refresh             82     82
     D  F9Insert              83     83
     D  WrkInd1               88     88
     D  WrkInd2               89     89
     D  SFleClr               91     91
     D  SflActive             92     92
     D  SFleNxtChg            93     93
     D  SFleEnd               95     95
     D  MsgSflActive          96     96
     D  MsgSFleEnd            97     97
     D  RollUp                98     98
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      **---------------------------------------------------------
 
      ** External DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** Modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      ** Branch Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      ** Securities Trading ICD
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
 
      ** Midas SD Book Details
     DSDBOOK         E DS                  EXTNAME(SDBOOKPD)
 
      ** External DS for Hedge Strategy
     D SDHGST        E DS                  EXTNAME(SDHGSTPD)
     D                                     PREFIX(HS:2)
     D  StgyBRCA              46     48
     D  DVTypDS               67    166
     D  DVSTypDS             167    186
     D  DVBkCdDS             187    206
     D  HGTypDS              207    236
     D  HGSTypDS             237    256
     D  HGBkCdDS             257    276
 
      ** External DS for Hedging ICD
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
     D                                     PREFIX(HG)
 
      ** External DS for SC Switchable Features                                               CAS003
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS003
                                                                                              CAS003
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** External DS for Hedge Linkage Table Maintenance
     D ASHGLK        E DS                  EXTNAME(ASHGLKPD)
 
      ** External DS for Hedge Linkage Table Maintenance
     D MnHGLK        E DS                  EXTNAME(ASHGLKPD)
     D                                     PREFIX(Mn)
 
      ** External DS for Hedge Linkage Table Maintenance
     D CrHGLK        E DS                  EXTNAME(ASHGLKPD)
     D                                     PREFIX(U_)
 
      ** External DS for update of Hedge Transactions File
     D ASHTRN        E DS                  EXTNAME(ASHTRNPD)
     D                                     PREFIX(TR:2)
 
      ** External DS for update of Hedge Transactions File
     D ASHTRN4       E DS                  EXTNAME(ASHTRNPD)
     D                                     PREFIX(T4:2)
 
      ** External DS for update of Hedge Transactions File
     D ASHTRN5       E DS                  EXTNAME(ASHTRNPD)
     D                                     PREFIX(T5:2)
 
      ** External DS for update of Hedge Transactions File
     D ASHTRN8       E DS                  EXTNAME(ASHTRNPD)
     D                                     PREFIX(T8:2)
                                                                                              CAS004
      ** External DS for Hedge Strategy for CAS004                                            CAS004
     D SDHGST2       E DS                  EXTNAME(SDHGSTPD)                                  CAS004
     D                                     PREFIX(PT:2)                                       CAS004
 
      ** Month name DS and Month sequence number DS
     D MthNamDS        DS            36
     D  MthNam1                1     18
     D  MthNam2               19     36
     D MthNumDS        S             22A
 
      ** DS for Screen 3 (Main Detail Screen)
     D Scn3DS          DS
     D  W#2HEDG                       6  0
     D  W#2HGST                      10
     D  W#2EFFD                       5  0
     D  W#2INDT                       5  0
     D  W#2FCOA                       1
     D  W#2ICAT                       1
     D  W#2STDT                       5  0
     D  W#2ENDT                       5  0
     D  W#2DVDL                       1
     D  W#2FTPO                       1
     D  W#2HGDL                       1
     D  W#2SECR                       1
     D  W#2DTTP                       1                                                       CAS006
     D  W#2DPTS                       3  0                                                    CAS006
     D  W#2DFRQ                       1                                                       CAS006
     D  W#2WDAY                       3                                                       CAS006
     D  W#2MNTH                       2  0                                                    CAS006
     D  W#2NDTA                       5  0                                                    CAS006
 
      ** DS for Screen 4 (Subfile 2)
     D Scn4DS          DS
     D  #2ACT                  1      1
     D  #2LDEL                 2      2                                                       212430
     D**#2DMOD**               2      3                                                       212430
     D**#2DDNO**               4      9                                                       212430
     D**#2DFPO**              10     19                                                       212430
     D**WMkIns**              10     11                                                       212430
     D**WInsTp**              10     14                                                       212430
     D**Wk6to10*              15     19                                                       212430
     D**WMthNm**              15     17                                                       212430
     D**WYrNum**              18     19                                                       212430
     D**#2DBKC**              20     21                                                       212430
     D**#2BRCA**              22     24                                                       212430
     D**#2PCAL**              25     25                                                       212430
     D**#2DPCT**              26     32                                                       212430
     D  #2DMOD                 3      4                                                       212430
     D  #2DDEL                 5      5                                                       212430
     D  #2DDNO                 6     11                                                       212430
     D  #2DFPO                12     21                                                       212430
     D  WMkIns                12     13                                                       212430
     D  WInsTp                12     16                                                       212430
     D  Wk6to10               17     21                                                       212430
     D  WMthNm                17     19                                                       212430
     D  WYrNum                20     21                                                       212430
     D  #2DBKC                22     23                                                       212430
     D  #2BRCA                24     26                                                       212430
     D  #2PCAL                27     27                                                       212430
     D  #2DPCT                28     34                                                       212430
 
      ** DS for Previous Screen 4 (Subfile 2)
     D Scn4PDS         DS
     D  #2ACTP                 1      1
     D  #2LDELP                2      2                                                       212430
     D**#2DMODP*               2      3                                                       212430
     D**#2DDNOP*               4      9                                                       212430
     D**#2DFPOP*              10     19                                                       212430
     D**#2DBKCP*              20     21                                                       212430
     D**#2BRCAP*              22     24                                                       212430
     D**#2PCALP*              25     25                                                       212430
     D**#2DPCTP*              26     32                                                       212430
     D  #2DMODP                3      4                                                       212430
     D  #2DDELP                5      5                                                       212430
     D  #2DDNOP                6     11                                                       212430
     D  #2DFPOP               12     21                                                       212430
     D  #2DBKCP               22     23                                                       212430
     D  #2BRCAP               24     26                                                       212430
     D  #2PCALP               27     27                                                       212430
     D  #2DPCTP               28     34                                                       212430
 
      ** DS for Screen 5 (Subfile 3)
     D Scn5DS          DS
     D  #3HACT                 1      1
     D**#3HMOD**               2      3                                                       212430
     D**#3HDNO**               4      9                                                       212430
     D**#3HSEC**              10     19                                                       212430
     D**#3HBKC**              20     21                                                       212430
     D**#3BRCA**              22     24                                                       212430
     D**#3MKTI**              25     25                                                       212430
     D**#3BHTV**              26     26                                                       212430
     D**#3HPCT**              27     33                                                       212430
     D  #3LDEL                 2      2                                                       212430
     D  #3HMOD                 3      4                                                       212430
     D  #3HDEL                 5      5                                                       212430
     D  #3HDNO                 6     11                                                       212430
     D  #3HSEC                12     21                                                       212430
     D  #3HBKC                22     23                                                       212430
     D  #3BRCA                24     26                                                       212430
     D  #3MKTI                27     27                                                       212430
     D  #3BHTV                28     28                                                       212430
     D  #3HPCT                29     35                                                       212430
 
      ** DS for Previous Screen 5 (Subfile 3)
     D Scn5PDS         DS
     D  #3HACTP                1      1
     D**#3HMODP*               2      3                                                       212430
     D**#3HDNOP*               4      9                                                       212430
     D**#3HSECP*              10     19                                                       212430
     D**#3HBKCP*              20     21                                                       212430
     D**#3BRCAP*              22     24                                                       212430
     D**#3MKTIP*              25     25                                                       212430
     D**#3BHTVP*              26     26                                                       212430
     D**#3HPCTP*              27     33                                                       212430
     D  #3LDELP                2      2                                                       212430
     D  #3HMODP                3      4                                                       212430
     D  #3HDELP                5      5                                                       212430
     D  #3HDNOP                6     11                                                       212430
     D  #3HSECP               12     21                                                       212430
     D  #3HBKCP               22     23                                                       212430
     D  #3BRCAP               24     26                                                       212430
     D  #3MKTIP               27     27                                                       212430
     D  #3BHTVP               28     28                                                       212430
     D  #3HPCTP               29     35                                                       212430
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Work Variables
     D WkSRRN1         S              5  0
     D WkSRRN2         S              5  0
     D WkSRRN3         S              5  0
     D WSkSRRN2        S              5  0                                                    227747
     D WSkSRRN3        S              5  0                                                    227747
     D WSkSRRN4        S              5  0                                                    227747
     D WSkSRRN5        S              5  0                                                    227747
     D WLRcdNum        S              5  0
     D WLRcdNum2       S              5  0
     D WLRcdNum3       S              5  0
     D WkHEDG          S              6  0
     D WkCnt           S              3  0
     D WkCnt2          S              3  0
     D WkCnt3          S              3  0
     D Ctr1            S              3  0
     D WCtr1           S              3  0                                                    227747
     D C               S              3  0
     D WkPCT           S              6  2
     D WTotPct         S              9  2
     D EndOfSubFile    S              3  0 INZ(14)
     D FirstPass       S              1A
     D FirstPass2      S              1A
     D FirstPass3      S              1A
     D WScrn           S              1A
     D KeyFlag         S              1A
     D PRunMode        S              3A
     D PHedgeId        S              6  0
     D ErrorFlag       S              1A
     D InitFlag        S              1A
     D DLModOn         S              1A
     D FFModOn         S              1A
     D LEModOn         S              1A
     D SEModOn         S              1A
     D P#2DVDL         S              1A
     D P#2FTPO         S              1A
     D P#2HGDL         S              1A
     D P#2SECR         S              1A
     D WSCN4DS         S             34A                                                      227747
     D WSCN5DS         S             34A                                                      227747
     D WkValDerv       S              1A                                                      CAS004
     D WkModu          S                   LIKE(LGMOD)                                        CAS006
                                                                                              CAS006
     D KGDHIn          S                   LIKE(LGDHIN)                                       CAS006
     D KGDlNo          S                   LIKE(LGDLNO)                                       CAS006
     D KGSecu          S                   LIKE(LGFPSE)                                       CAS006
     D KGBook          S                   LIKE(LGBKCD)                                       CAS006
     D KGBrch          S                   LIKE(LGBRCA)                                       CAS006
     D KGPCal          S                   LIKE(LGPCAL)                                       CAS006
     D KGMktI          S                   LIKE(LGMKTI)                                       CAS006
     D KGTVDt          S                   LIKE(LGBHTV)                                       CAS006
     D KAHID           S                   LIKE(FSAHID)                                       229174
 
      ** Parameters for SDRTVTXT
     D PMsgId          S              7A
     D PMsgFile        S             10A
     D PMsgText        S             80A
 
      ** Parameters for ZA0350
     D PMsgFileZ       S             10A   INZ('SDUSRMSG')
     D PMsgIdZ         S             10A
     D PMsgDataZ       S             45A
 
      ** Parameters for ZDATE1 and ZDATE2
     D PZDateA         S              6A
     D PZDayNo         S              5P 0
     D PZDate          S              6P 0
     D PZADate         S              7A
 
      ** ZSEDIT fields
     D PZFLD15         S             15  0
     D PZDECS          S              1  0
     D PZECODE         S              1
     D PZOUT21         S             21
 
      ** ZALIGN fields
     D PZAlignOk       S              1
     D PZFIELD         S             16
     D PZADEC          S              1  0
     D PZADIG          S              2  0
 
     D PZMsgPgm        S             10A
     D PZMsgMod        S             10A
     D PZMsgProc       S             10A
 
      ** Parameters for WN0010 program
     D PWPgm           S             10A   INZ('AS000001')
     D PWKey           S              2A
     D PWAction        S              1A   INZ('I')
     D PData           S           1024A
     D PWRtn           S              7A
     D PWSpare         S            256A
 
      ** Parameters for ZFREQC                                                                CAS006
     D PRetCodeIn      S             10A                                                      CAS006
     D PNxtColDay      S              4A                                                      CAS006
     D PIncldTday      S              1A                                                      CAS006
     D PZFreq          S              1A                                                      CAS006
     D PZDay           S              5  0                                                    CAS006
     D PZCcy           S              3A                                                      CAS006
     D PZWday          S              3A                                                      CAS006
     D PZMday          S              2  0                                                    CAS006
     D PBJDFIN         S              1A                                                      CAS006
     D PBaseDate       S              5  0                                                    CAS006
                                                                                              CAS006
      ** Parameters for ZCHKH                                                                 CAS006
     D PZDayH          S              5  0                                                    CAS006
     D PZCcyH          S              3A                                                      CAS006
     D PzLocH          S              1A                                                      CAS006
     D PzIndH          S              1A                                                      CAS006
                                                                                              CAS006
      ** Index for arrays of error message ids
     D Idx             S              3P 0
     D WIdx            S              3P 0
     D WIdx3           S              3P 0                                                    227747
 
     D WAHFLNM         S             10A
 
      ** Fields used to update SDFCTLL0 for ASHGLKPD
     D WNumRec         S              5  0
     D WNumIns         S              5  0
     D WNumAmd         S              5  0
     D WNumDel         S              5  0
 
      ** Fields used to update SDFCTLL0 for ASHTRNPD
     D WNumRec2        S              5  0
     D WNumIns2        S              5  0
     D WNumAmd2        S              5  0
     D WNumDel2        S              5  0
 
      ** Key list used for ASHTRNL0/ASHTRNLC                                                  CAS006
     D KFSHEDI         S              6  0                                                    CAS006
     D KFSDHIN         S              1A                                                      CAS006
     D***KFSDLNO         S              6  0                                           CAS006 CLE148
     D KFSDLNO         S              6A                                                      CLE148
     D KFSHTID         S             10A                                                      CAS006
                                                                                              CAS006
      ** Fields used to define Key List for Midas SD T Distribution Table                     CAS006
     D KXXDfrd         S                   LIKE(XXDfrd)                                       CAS006
     D KXXArea         S                   LIKE(XXArea)                                       CAS006
                                                                                              CAS006
     D WHEDG           S              6S 0
     D KHEDI           S              6S 0
     D K#1HEDI         S              6S 0
     D P#1HEDR         S              6S 0
     D N#1HEDR         S              6S 0
     D InsertMode      S              1A   INZ('N')
     D FutMode         S              4A
     D WChkMsgId       S              7A
     D WDltTxt         S             12A
     D WExpTxt         S             12A
     D WDisTxt         S             12A
     D WMatTxt         S             12A
     D WTrdTxt         S             12A
     D WSdte           S              5P 0
     D WEdte           S              5P 0
     D WEffD           S              5P 0
     D WInpD           S              5P 0
     D WGotoScn3       S              1A   INZ('N')
     D WkTest          S              1A
     D AllValid        S              1A
     D WRedisplay      S              1A   INZ('N')
     D NoMoreRec       S              1A
     D W#2SavMod       S              2A
     D W#3SavMod       S              2A
     D WBkCd           S              2A
     D WBrca           S              3A
     D WFSERIN         S              1A
     D WKDNum          S              6  0
     D WkMod           S              2A
     D W4TYPE          S              2A
     D W4STYP          S              2A
     D W4BOKC          S              2A
     D W5TYPE          S              2A
     D W5TYPE2         S              3A
     D W5DLST          S              2A
     D W5BOKC          S              2A
     D DspScn2         S              1A   INZ('Y')
     D DspScn3         S              1A   INZ('Y')
     D DspScn4         S              1A   INZ('Y')
     D DspScn5         S              1A   INZ('Y')
     D NoOfTrn1        S              3  0
     D NoOfTrn2        S              3  0
     D PNoOfTrn1       S              3  0
     D PNoOfTrn2       S              3  0
 
     D CAS003          S              1A                                                      CAS003
     D CAS004          S              1A                                                      CAS004
     D WProdType1      S              2A                                                      CAS004
     D WProdType2      S              2A                                                      CAS004
                                                                                              CAS003
     D WkDervDTYP      S              2A                                                      CAS005
     D WkDervCCY       S              3A                                                      CAS005
     D WkDervUCCY      S              3A                                                      CAS005
     D WkDervTCCY      S              3A                                                      CAS005
     D W1stDervRec     S              1A                                                      CAS005
     D W1stItemRec     S              1A                                                      CAS005
     D WkFSHSID        S              1A                                                      CAS005
                                                                                              CAS005
     D WkDPTS          S              4  0                                                    CAS006
     D WkMNTH          S              3  0                                                    CAS006
     D WkNDTA          S              5P 0                                                    CAS006
     D WCountDPTS      S              4  0                                                    CAS006
     D WPrevNDTA       S              5P 0                                                    CAS006
     D WFlgNDTA        S              1A                                                      CAS006
     D WBlankNDTA      S              1A                                                      CAS006
     D WSomRecExst     S              1A                                                      CAS006
     D WRecExist       S              1A                                                      CAS006
     D WrkHEDG         S              6  0                                                    CAS006
     D WOneDerv        S              1A                                                      CAS006
     D WOneItem        S              1A                                                      CAS006
     D CAS006          S              1A                                                      CAS006
     D WBYPAS          S              1A   INZ('Y')                                           CAS006
                                                                                              CAS006
     D WRecFoundF      S              1A                                                      226221
                                                                                              226221
     D  WBDAT1         S              5  0                                                    225342
     D WAHID           S                   LIKE(FSAHID)                                       229174
                                                                                              CAS008
      ** Parameters for ZFWDT                                                                 CAS008
     D PzDayNo3        S              5  0                                                    CAS008
     D PzCCY3          S              3                                                       CAS008
     D PZLoc3          S              3                                                       CAS008
     D PZNRdys3        S              2  0                                                    CAS008
     D PZDyNbr3        S              5  0                                                    CAS008
                                                                                              CAS008
     D CAS008          S              1A                                                      CAS008
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
 
      ** Initialisation routine
 
     C                   IF        InitFlag = 'Y'
     C                   EXSR      SRInit
     C                   ENDIF
 
     C                   DOW       WScrn = '1'
 
      ** Perform initial subfile selection display
 
     C                   EXSR      SRScn1
 
     C                   ENDDO
 
     C                   IF        WScrn = 'T'
 
      ** Return to calling program
 
     C                   EVAL      InitFlag = 'N'
     C                   EVAL      *INLR = True
     C                   RETURN
 
     C                   ENDIF
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRInit - Initialization processing                            *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
     C                   EVAL      InitFlag = 'N'
     C                   EVAL      PMsgFile = 'SDUSRMSG'
     C                   EVAL      F3F12Key   = False
     C                   EVAL      AmndDelete = False
     C                   EVAL      F5Refresh  = False
     C                   EVAL      F9Insert   = False
 
      ** Delete Text
 
     C                   EVAL      PMsgId  = 'ASM0023'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WDltTxt = PMsgText
 
 
      ** Expired Text
 
     C                   EVAL      PMsgId  = 'ASM0029'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WExpTxt = PMsgText
 
      ** Matured Text
 
     C                   EVAL      PMsgId  = 'ASM0030'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WMatTxt = PMsgText
 
      ** Discontinued Text
 
     C                   EVAL      PMsgId  = 'ASM0031'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WDisTxt = PMsgText
 
      ** Trading Text
 
     C                   EVAL      PMsgId  = 'ASM0003'
     C                   EXSR      SRRtvTxt
     C                   EVAL      WTrdTxt = PMsgText
 
      ** Fill up month array
 
     C                   EVAL      MthNam1 = 'JANFEBMARAPRMAYJUN'
     C                   EVAL      MthNam2 = 'JULAUGSEPOCTNOVDEC'
     C                   EVAL      MthNumDS  = '010203040506070809101112'
 
     C                   MOVEA     MthNamDS      MthNamAr
     C                   MOVEA     MthNumDS      MthNumAr
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Build subfile
 
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      FirstPass2 = 'Y'
     C                   EVAL      FirstPass3 = 'Y'
     C                   EVAL      KeyFlag    = 'N'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScn1    - Initial subfile selection display                 *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRScn1        BEGSR
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Condition footer visibility
 
     C                   SELECT
 
     C                   WHEN      SelMode = True
 
     C                   EVAL      F3F12Key   = False
     C                   EVAL      AmndDelete = False
     C                   EVAL      F5Refresh  = False
     C                   EVAL      F9Insert   = False
 
     C                   WHEN      MntMode = True
 
     C                   EVAL      F3F12Key   = False
     C                   EVAL      F9Insert   = True
     C                   IF        NoData2Dsp = False
     C                   EVAL      AmndDelete = True
     C                   EVAL      F5Refresh  = True
     C                   ELSE
     C                   EVAL      AmndDelete = False
     C                   EVAL      F5Refresh  = False
     C                   ENDIF
 
     C                   WHEN      EnquireMode = True
     C                   EVAL      F3F12Key   = False
     C                   EVAL      F9Insert   = False
     C                   EVAL      AmndDelete = False
     C                   EVAL      F5Refresh  = False
 
     C                   ENDSL
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   WRITE     AS000001F3
     C                   EVAL      SflActive = True
     C                   WRITE     AS000001C4
     C                   EXFMT     AS000001C1
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   IF        SelMode = True
     C                   EVAL      RetCodeIn = '*NOSEL'
     C                   ENDIF
     C                   EXSR      SREndP
 
      ** F5 Pressed
 
     C                   WHEN      *INKE = True
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      #1HEDR = *BLANKS
     C                   EVAL      ErrSelOpt = False
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
 
      ** F9 Pressed
 
     C                   WHEN      *INKI = True
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C1
     C                   EVAL      SFleClr = False
     C                   EXSR      SRScn2
 
     C                   IF        *INKC = False and *INKL = False
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   ENDIF
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = True
     C                   EVAL      KeyFlag = 'R'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
 
     C                   OTHER
     C                   EXSR      SRValScn1
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScn2    - Insert new hedge id screen                        *
      *                                                               *
      * Called by: Main Processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRScn2        BEGSR
 
     C                   EVAL      WHEDG  = *ZEROS
     C******HIVAL        SETLL     ASHGLKL1                                                   228042
                                                                                              228042
      ** Get the next available Hedge ID.                                                     228042
                                                                                              228042
     C     *HIVAL        SETGT     ASAHIDL1                                                   229174
     C                   READP     ASAHIDL1                                                   229174
                                                                                              228042
                                                                                              229174
     C                   IF        NOT %EOF(ASAHIDL1)                                         229174
                                                                                              229174
     C     *HIVAL        SETGT     ASHGLKL1                                                   229174
     C                   READP     ASHGLKL1                               26                  229174
     C                   IF        FSAHID > FSHEDI                                            229174
     C                   EVAL      WHEDG = FSAHID + 1                                         229174
     C                   ELSE                                                                 229174
     C                   EVAL      WHEDG = FSHEDI + 1                                         229174
     C                   ENDIF                                                                229174
                                                                                              228042
     C                   ELSE                                                                 228042
                                                                                              228042
     C     *HIVAL        SETGT     ASHGLKL1                                                   228042
     C                   READP     ASHGLKL1                               26
     C                   IF        EndOfFile = True
     C                   EVAL      WHEDG = WHEDG + 1
     C                   ELSE
     C                   EVAL      WHEDG = FSHEDI + 1
     C                   ENDIF
                                                                                              229174
     C                   ENDIF                                                                229174
                                                                                              228042
      ** Allocate this Hedge ID.                                                              228042
                                                                                              228042
     C                   EVAL      FSAHID = WHEDG                                             228042
     C                   WRITE     ASAHIDD0                                                   228042
                                                                                              228042
     C                   MOVE      WHEDG         #1HEDG
 
     C                   EVAL      DspScn2 = 'Y'
     C                   DOW       DspScn2 = 'Y'
     C                   EVAL      DspScn2 = 'N'
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Condition footer visibility
 
     C                   EVAL      F3F12Key   = True
 
      ** Write the select screen footer to the screen.
      ** Write and Read the new hedge id screen
 
     C                   WRITE     AS000001F3
     C                   WRITE     AS000001C4
     C                   EXFMT     AS000001F1
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
     C                   EVAL      ErrNwHdgID = False
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   EVAL      #1HEDG = *BLANKS
     C                   EXSR      SREndP
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = True
     C                   EVAL      WPrevNDTA = *ZEROS                                         CAS006
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   EXSR      SRDHID                                                     229174
 
     C                   OTHER
     C                   EXSR      SRValScn2
 
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScn3    - Screen 3 - detail screen                          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRScn3        BEGSR
 
     C                   EVAL      DspScn3 = 'Y'
     C                   EVAL      WFSERIN = *BLANK                                           224734
                                                                                              227747
      ** Initialize array index                                                               227747
                                                                                              227747
     C                   EVAL      WIdx3 = 0                                                  227747
                                                                                              227747
     C                   DOW       DspScn3 = 'Y'
     C                   EVAL      DspScn3 = 'N'
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Condition fields visibility
 
     C                   EVAL      DVDLused = False
     C                   IF        DLModOn = 'Y'
     C                   EVAL      DVDLused = True
     C                   ENDIF
 
     C                   EVAL      FTPOused = False
     C                   IF        FFModOn = 'Y'
     C                             and CAS003 = 'Y'                                           CAS003
     C                   EVAL      FTPOused = True
     C                   ENDIF
 
     C                   EVAL      HGDLused = False
     C                   IF        DLModOn = 'Y' or LEModOn = 'Y'
     C                   EVAL      HGDLused = True
     C                   ENDIF
 
     C                   EVAL      SECRused = False
     C                   IF        SEModOn = 'Y'
     C                   EVAL      SECRused = True
     C                   ENDIF
 
      ** Protect Data Type, Data Points Required, Data Collection Frequency,                  CAS006
      ** Day of the Week, Day of the Month, and Next Data Collection Date once                CAS006
      ** the historic file for the hedge/d items are populated.                               CAS006
                                                                                              CAS006
     C                   EVAL      WProtectRflds = FALSE                                      CAS006
     C                   IF        CAS006 = 'Y' AND AmendMode =  TRUE                         CAS006
                                                                                              CAS006
     C     FSHEDI        CHAIN     ASDLHML2                                                   CAS006
     C                   IF        %FOUND(ASDLHML2)                                           CAS006
     C                   EVAL      WProtectRflds = TRUE                                       CAS006
     C                   ELSE                                                                 CAS006
     C     FSHEDI        CHAIN     ASLEHML2                                                   CAS006
     C                   IF        %FOUND(ASLEHML2)                                           CAS006
     C                   EVAL      WProtectRflds = TRUE                                       CAS006
     C                   ELSE                                                                 CAS006
     C     FSHEDI        CHAIN     ASSEHML0                                                   CAS006
     C                   IF        %FOUND(ASSEHML0)                                           CAS006
     C                   EVAL      WProtectRflds = TRUE                                       CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      *IN84 ='0'                                                 CAS008
     C                   IF        CAS008 = 'Y'                                               CAS008
     C                             AND HGFSNDDP <> 0                                          CAS008
     C                             AND FSSECR = 'Y'                                           CAS008
                                                                                              CAS008
     C                   IF        #1SEL = 'E'                                                CAS008
     C                             OR #1SEL = 'A'                                             CAS008
     C                             OR #1SEL = 'D'                                             CAS008
                                                                                              CAS008
     C                   CALLB     'ZFWDT'                                                    CAS008
     C                   PARM      FSEFFD        PzDayNo3                                     CAS008
     C                   PARM      HGFSNDDP      PZNRdys3                                     CAS008
     C                   PARM                    PZDyNbr3                                     CAS008
     C                   PARM      BJCYCD        PzCCY3                                       CAS008
     C                   PARM                    PZLoc3                                       CAS008
                                                                                              CAS008
     C                   EVAL      PZDayNo = PZDyNbr3                                         CAS008
                                                                                              CAS008
     C                   EXSR      SRCvtDate                                                  CAS008
     C                   MOVE      PZDate        #2DASD                                       CAS008
     C                   EVAL      *IN84 ='1'                                                 CAS008
     C                   ENDIF                                                                CAS008
     C                   ENDIF                                                                CAS008
      ** Condition footer visibility
 
     C                   EVAL      F3F12Key   = True
 
      ** Write the select screen footer to the screen.
      ** Write and Read the new hedge id screen
 
     C                   WRITE     AS000001F3
     C                   WRITE     AS000001C4
     C                   EXFMT     AS000001F2
                                                                                              CAS006
      ** Initialize #2DTTP to have a value of 'V'                                             CAS006
                                                                                              CAS006
     C                   EVAL      #2DTTP = 'V'                                               CAS006
 
      ** Save warning message ids array of this screen.                                       CAS006
                                                                                              CAS006
     C                   MOVEA     WMsgIDArr     WMsgIdArrP                                   CAS006
                                                                                              CAS006
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
     C                   MOVEA     '00000000000' *IN(33)
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   EXSR      SREndP
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = True
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      FirstPass = 'Y'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   EXSR      SRDHID                                                     229174
 
      ** F10 Pressed
 
     C                   WHEN      *INKJ = True
     C                   MOVE      #2HEDG        W#2HEDG
     C                   EXSR      SRUpdate
 
     C                   OTHER
     C                   EXSR      SRValScn3
 
     C                   ENDSL
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScn4    - Screen 4 subfile selection display                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRScn4        BEGSR
 
     C                   EVAL      DspScn4 = 'Y'
     C                   DOW       DspScn4 = 'Y'
     C                   EVAL      DspScn4 = 'N'
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Condition footer visibility
 
     C                   EVAL      F3F12Key   = True
     C                   EVAL      AmndDelete = False
     C                   Eval      F5Refresh  = False
     C                   Eval      F9Insert   = False
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   IF        InsertMode <> 'Y'                                          212430
     C                   EVAL      DeleteTran = True                                          212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   WRITE     AS000001F3
     C                   EVAL      SflActive = True
     C                   WRITE     AS000001C4
     C                   EXFMT     AS000001C2
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WMsgIdArrP
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   EXSR      SREndP
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = True
     C                   MOVEA     '00000000'    *IN(44)
     C                   EVAL      DspScn3 = 'Y'
     C                   EVAL      WPrevNDTA = *ZEROS                                         CAS006
     C                   EVAL      WOneDerv = 'N'                                             CAS006
 
      ** F10 Pressed
 
     C                   WHEN      *INKJ = True
     C                   MOVE      #2HEDG        W#2HEDG
     C                   EXSR      SRUpdate
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = True
     C                   MOVEA     '00000000'    *IN(44)
     C                   IF        NoOfTrn1 > 0
     C                   EVAL      NoOfTrn1 = NoOfTrn1 - 1
     C                   EVAL      PNoOfTrn1 = NoOfTrn1
     C                   ENDIF
     C                   EXSR      SRBldSfl2
     C                   EVAL      DspScn4 = 'Y'
 
     C                   OTHER
     C                   EXSR      SRValScn4
 
     C                   ENDSL
     C                   ENDDO
                                                                                              212430
     C                   EVAL      DeleteTran = False                                         212430
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRScn5    - Screen 5 subfile selection display                *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRScn5        BEGSR
 
     C                   EVAL      DspScn5 = 'Y'
     C                   DOW       DspScn5 = 'Y'
     C                   EVAL      DspScn5 = 'N'
 
      ** Send message to subfile if any.
 
     C                   EXSR      SRSndMsg
 
      ** Condition footer visibility
 
     C                   EVAL      F3F12Key   = True
     C                   EVAL      AmndDelete = False
     C                   Eval      F5Refresh  = False
     C                   Eval      F9Insert   = False
 
      ** Write the select screen footer to the screen.
      ** Write and Read the subfile control record to the screen to display
      ** and read the subfile.
 
     C                   IF        InsertMode <> 'Y'                                          212430
     C                   EVAL      DeleteTran = True                                          212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   WRITE     AS000001F3
     C                   EVAL      SflActive = True
     C                   WRITE     AS000001C4
     C                   EXFMT     AS000001C3
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WMsgIdArrP
 
      ** Perform message subfile clear and message data clear
 
     C                   EXSR      SRClrMsg
 
      ** Select processing type
 
     C                   SELECT
 
      ** F3 Pressed
 
     C                   WHEN      *INKC = True
     C                   EXSR      SREndP
 
      ** F12 Pressed
 
     C                   WHEN      *INKL = True
     C                   MOVEA     '000000000'   *IN(44)
     C                   IF        Scn4Arr(1) = *BLANKS
     C                   EVAL      FirstPass2 = 'Y'
     C                   EVAL      W1stDervRec = 'Y'                                          CAS005
     C                   EXSR      SRClrMsg
     C                   EXSR      SRBldSfl2
     C                   ENDIF
     C                   EVAL      KDHIN2 = 'D'
     C                   EVAL      NoOfTrn1 = PNoOfTrn1
     C                   EVAL      DspScn4 = 'Y'
     C                   EVAL      WOneItem = 'N'                                             CAS006
 
      ** F10 Pressed
 
     C                   WHEN      *INKJ = True
     C                   MOVE      #2HEDG        W#2HEDG
     C                   EXSR      SRUpdate
 
      ** RollUp pressed
 
     C                   WHEN      RollUp = True
     C                   MOVEA     '000000000'   *IN(44)
     C                   IF        NoOfTrn2 > 0
     C                   EVAL      NoOfTrn2 = NoOfTrn2 - 1
     C                   EVAL      PNoOfTrn2 = NoOfTrn2
     C                   ENDIF
     C                   EXSR      SRBldSfl3
     C                   EVAL      DspScn5 = 'Y'
 
     C                   OTHER
     C                   IF        InsertMode = 'Y' or AmendMode = True
     C                   EXSR      SRValScn5
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDDO
                                                                                              212430
     C                   EVAL      DeleteTran = False                                         212430
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl - Build Subfile Processing                           *
      *                                                               *
      * Called by: SRInit                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl      BEGSR
 
     C                   IF        PRunMode = 'MNT'
     C                   EVAL      InsertMode = 'N'
     C                   EVAL      AmendMode  = False
     C                   EVAL      DeleteMode = False
     C                   EVAL      EnquireMode = False
     C                   ENDIF
 
      ** If first time in
 
     C                   IF        FirstPass = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C1
     C                   EVAL      SFleClr = False
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      #1HEDR = *BLANKS
     C                   EVAL      ErrSelOpt = False
     C                   EVAL      KeyFlag = 'N'
     C                   EVAL      FirstPass = 'N'
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      WRedisplay = 'N'
     C                   EVAL      SFleEnd = False
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt = 0
     C                   EVAL      WkSRRN1 = WLRcdNum
 
      ** Read file
 
     C                   SELECT
     C                   WHEN      KeyFlag = 'Y'
     C     KHEDI         SETLL     ASHGLKL1
     C                   WHEN      KeyFlag = 'R'
     C     KHEDI         SETGT     ASHGLKL1
     C                   WHEN      KeyFlag <> 'Y' and KeyFlag <> 'R'
     C     *LOVAL        SETLL     ASHGLKL1
     C                   ENDSL
 
     C                   READ      ASHGLKL1                               26
 
      ** Reset subfile if review from field results in End of file.
 
     C                   IF        EndOfFile = True and #1HEDR <> *BLANKS
     C                   EVAL      #1HEDR = *BLANKS
     C     *LOVAL        SETLL     ASHGLKL1
     C                   READ      ASHGLKL1                               26
     C                   ENDIF
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkCnt < EndOfSubfile AND EndOfFile = False
 
     C                   IF        FSRECI = 'D' and SelMode = True or
     C                             SelMode = False
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt = WkCnt + 1
     C                   EVAL      WkSRRN1 = WkSRRN1 + 1
 
      ** There is data so turn off NoData2Dsp indicator
 
     C                   EVAL      NoData2Dsp = False
 
      ** Format subfile fields
 
     C                   EVAL      #1SEL  = *BLANK
     C                   MOVE      FSHEDI        #1HEDI
     C                   EVAL      #1HGST = FSHGST
     C                   EVAL      PZDayNo = FSEFFD
     C                   EXSR      SRCvtDate
     C                   EVAL      #1EFFD = PZADate
     C                   EVAL      #1LCD  = FSLCD
 
     C                   SELECT
     C                   WHEN      FSRECI = '*'
     C                   EVAL      #1STS  = WDltTxt
     C                   EVAL      StsRvsImg = True
     C                   WHEN      FSRECI = 'E'
     C                   EVAL      #1STS  = WExpTxt
     C                   EVAL      StsRvsImg = True
     C                   WHEN      FSRECI = 'M'
     C**********         EVAL      #1STS  = WMatTxt                                           223805
     C                   EVAL      #1STS  = WExpTxt                                           223805
     C                   EVAL      StsRvsImg = True
     C                   WHEN      FSRECI = 'X'
     C                   EVAL      #1STS  = WDisTxt
     C                   EVAL      StsRvsImg = True
     C                   WHEN      FSRECI = 'T'
     C                   EVAL      #1STS  = WTrdTxt
     C                   EVAL      StsRvsImg = True
     C                   OTHER
     C                   EVAL      #1STS  = *BLANKS
     C                   EVAL      StsRvsImg = False
     C                   ENDSL
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN1       #1SFRN
     C                   WRITE     AS000001S1
     C                   MOVE      #1HEDI        KHEDI
 
     C                   ENDIF
 
      ** Read file LF/ASHGLKL1
 
     C                   READ      ASHGLKL1                               26
 
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C     KHEDI         READPE    ASHGLKL1                               26
     C                   IF        EndOfFile = True
     C                   EVAL      SfleEnd = True
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN1       WLRcdNum
 
     C                   IF        WkCnt = 0
 
     C                   EVAL      MsgIdArr(1) = 'ASM0001'
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN1
     C                   Z-ADD     1             #1SFRN
     C                   CLEAR                   #1SEL
     C                   CLEAR                   #1HEDI
     C                   CLEAR                   #1HGST
     C                   CLEAR                   #1EFFD
     C                   CLEAR                   #1STS
     C                   EVAL      NoData2Dsp = True
     C                   WRITE     AS000001S1
     C                   ELSE
     C                   EVAL      NoData2Dsp = False
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl2 - Build Subfile Processing 2                        *
      *                                                               *
      * Called by: SRValScn3                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl2     BEGSR
 
      ** If first time in
 
     C                   IF        FirstPass2 = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C2
     C                   EVAL      SFleClr = False
     C                   EVAL      WLRcdNum2 = 0
     C                   EVAL      SFleEnd = False
     C                   MOVE      #2HEDG        KHEDI2
     C                   EVAL      KDHIN2 = 'D'
     C                   EVAL      NoData2Dsp = False
     C                   EVAL      W#2SavMod = *BLANKS
     C                   MOVEA     '00000000'    *IN(44)
     C                   EVAL      NoOfTrn1 = 0
     C                   EVAL      PNoOfTrn1 = NoOfTrn1
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt2 = 0
     C                   EVAL      WkSRRN2 = WLRcdNum2
 
      ** Read file
 
 
     C                   IF        FirstPass2 = 'Y'
     C     KLIST1        SETLL     ASHTRNLB                                                   CAS004
     C*****KLIST1        SETLL     ASHTRNL1                                                   CAS004
     C                   EVAL      FirstPass2 = 'N'
     C                   ELSE
     C     KLIST1        SETGT     ASHTRNLB                                                   CAS004
     C*****KLIST1        SETGT     ASHTRNL1                                                   CAS004
     C                   ENDIF
     C     KLIST1        READE     ASHTRNLB                               26                  CAS004
     C*****KLIST1        READE     ASHTRNL1                               26                  CAS004
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkCnt2 < EndOfSubfile
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt2 = WkCnt2 + 1
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   EVAL      ProtectDACT = False                                        212430
     C                   EVAL      ProtectDMOD = False                                        212430
     C                   EVAL      ProtectPRCT = False                                        212430
     C                   EVAL      #2DDEL = *BLANK                                            212430
     C                   EVAL      #2LDEL = *BLANK                                            212430
 
     C                   SELECT
     C                   WHEN      EndOfFile = False
 
      ** If Amend Mode: non-display and protect Futures Position fields if
      ** Futures Transaction has value in it
 
     C                   IF        InsertMode <> 'Y'
     C**********         IF        T1FSDLNO <> 0 and T1FSFPSE = *BLANKS and                   CLE148
     C                   IF        T1FSDLNO <> *BLANKS and T1FSFPSE=*BLANKS and               CLE148
     C                             DrvFutPosGen = True
     C                   EVAL      DrvFutPosFTM = True
     C                   EVAL      FutMode = 'DDNO'
     C                   ELSE
     C                   EVAL      DrvFutPosFTM = False
     C                   EVAL      FutMode = 'DFPO'
     C                   ENDIF
                                                                                              212430
     C                   SELECT                                                               212430
     C                   WHEN      DerivDeal = True                                           212430
     C*****T1FSDLNO      CHAIN     DEALALL                            27               212430 CLE148
     C                   MOVEL     T1FSDLNO      FSDLNO2           6 0                        CLE148
     C     FSDLNO2       CHAIN     DEALALL                            27                      CLE148
                                                                                              212430
     C                   IF        RecNotFnd = False                                          212430
     C                             AND RECI <> 'D'                                            212430
     C                   EVAL      #2DDEL = '*'                                               212430
     C                   EVAL      SFleNxtChg = True                                          212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        RecNotFnd = False  AND                                     CAS005
     C                             RECI      = 'D'    AND                                     CAS005
     C                             W1stDervRec = 'Y'                                          CAS005
                                                                                              CAS005
     C                   EVAL      W1stDervRec = 'N'                                          CAS005
     C                   EVAL      WkDervDTYP  = DTYP                                         CAS005
                                                                                              CAS005
      ** If DTYP is 'RX', save the CCYs of the first subfile record.                          CAS005
     C                   IF        WkDervDTYP  = 'RX'                                         CAS005
     C                   EVAL      WkDervUCCY  = UCUCY                                        CAS005
     C                   EVAL      WkDervTCCY  = TCUCY                                        CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   WHEN      DrvFutPosGen = True                                        212430
                                                                                              212430
     C*****T1FSDLNO      CHAIN     TRANSDF                            27               212430 CLE148
     C                   MOVEL     T1FSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     TRANSDF                            27                      CLE148
                                                                                              212430
     C                   IF        RecNotFnd = False                                          212430
     C                             AND RECI <> 'D'                                            212430
     C                   EVAL      #2DDEL = '*'                                               212430
     C                   EVAL      SFleNxtChg = True                                          212430
     C                   ENDIF                                                                212430
     C                   ENDSL                                                                212430
                                                                                              212430
     C                   ENDIF
 
     C                   IF        AmendMode = True                                           212430
     C                   EVAL      ProtectDMOD = True                                         212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        T1FSHTCT = 'D'                                             212430
     C                   EVAL      ProtectDACT = True                                         212430
     C                   EVAL      ProtectPRCT = True                                         212430
     C                   EVAL      #2LDEL = '*'                                               212430
     C                   EVAL      NoOfTrn1 =  NoOfTrn1 - 1                                   212430
     C                   ELSE                                                                 212430
     C                   EVAL      #2LDEL = ' '                                               212430
     C                   ENDIF                                                                212430
                                                                                              212430
      ** Format subfile fields
 
     C                   EVAL      #2ACT  = *BLANK
     C                   EVAL      #2DMOD = T1FSMOD
     C**********         IF        T1FSDLNO <> 0                                              CLE148
     C                   IF        T1FSDLNO <> *BLANKS                                        CLE148
     C                   MOVE      T1FSDLNO      #2DDNO
     C                   ELSE
     C                   EVAL      #2DDNO = *BLANKS
     C                   ENDIF
     C                   EVAL      #2DFPO = T1FSFPSE
     C                   EVAL      #2DBKC = T1FSBKCD
     C                   EVAL      #2BRCA = T1FSBRCA
     C                   EVAL      #2PCAL = T1FSPCAL
     C                   MOVE      T1FSPCTG      PZFLD15
     C                   Z-ADD     2             PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #2DPCT
 
     C                   EVAL      #2DMODP = T1FSMOD
     C**********         IF        T1FSDLNO <> 0                                              CLE148
     C                   IF        T1FSDLNO <> *BLANKS                                        CLE148
     C                   MOVE      T1FSDLNO      #2DDNOP
     C                   ELSE
     C                   EVAL      #2DDNOP = *BLANKS
     C                   ENDIF
     C                   EVAL      #2DFPOP = T1FSFPSE
     C                   EVAL      #2DBKCP = T1FSBKCD
     C                   EVAL      #2BRCAP = T1FSBRCA
     C                   EVAL      #2PCALP = T1FSPCAL
     C                   MOVE      PZOUT21       #2DPCTP
 
     C                   IF        W#2SavMod = *BLANKS
     C                   EVAL      W#2SavMod = #2DMOD
     C                   ENDIF
 
     C                   EVAL      NoOfTrn1 =  NoOfTrn1 + 1
     C                   EVAL      PNoOfTrn1 = NoOfTrn1
 
     C                   WHEN      EndOfFile = True
 
      ** Clear subfile fields
 
     C                   EVAL      #2ACT  = *BLANK
     C                   EVAL      #2DMOD = *BLANK
     C                   EVAL      #2DDNO = *BLANK
     C                   EVAL      #2DFPO = *BLANK
     C                   EVAL      #2DBKC = *BLANK
     C                   EVAL      #2BRCA = *BLANK
     C                   EVAL      #2PCAL = *BLANK
     C                   EVAL      #2DPCT = *BLANK
     C                   EVAL      #2DMODP = *BLANK
     C                   EVAL      #2DDNOP = *BLANK
     C                   EVAL      #2DFPOP = *BLANK
     C                   EVAL      #2DBKCP = *BLANK
     C                   EVAL      #2BRCAP = *BLANK
     C                   EVAL      #2PCALP = *BLANK
     C                   EVAL      #2DPCTP = *BLANK
     C                   ENDSL
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN2       #2SFRN
     C                   WRITE     AS000001S2
 
      ***Read*file LF/ASHTRNL1                                                                CAS004
      ** Read file LF/ASHTRNLB                                                                CAS004
 
     C     KLIST1        READE     ASHTRNLB                               26                  CAS004
     C*****KLIST1        READE     ASHTRNL1                               26                  CAS004
 
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C     KLIST1        READPE    ASHTRNLB                               26                  CAS004
     C*****KLIST1        READPE    ASHTRNL1                               26                  CAS004
     C                   IF        EndOfFile = True
     C                   EVAL      SFleEnd = True
     C                   ELSE
     C                   EVAL      NoOfTrn1 = NoOfTrn1 + 1
     C                   EVAL      PNoOfTrn1 = NoOfTrn1
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
     C                   IF        InsertMode = 'Y' or AmendMode = True
     C                   EVAL      SFleEnd = False
     C                   ENDIF
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN2       WLRcdNum2
 
     C                   IF        WkCnt2 = 0
 
     C                   EVAL      MsgIdArr(1) = 'ASM0001'
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN2
     C                   Z-ADD     1             #2SFRN
     C                   CLEAR                   Scn4DS
     C                   WRITE     AS000001S2
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRBldSfl3 - Build Subfile Processing 3                        *
      *                                                               *
      * Called by: SRValScn4                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRBldSfl3     BEGSR
 
      ** If first time in
 
     C                   IF        FirstPass3 = 'Y'
 
      ** Clear Subfile
 
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C3
     C                   EVAL      SFleClr = False
     C                   EVAL      WLRcdNum3 = 0
     C                   EVAL      SFleEnd = False
     C                   MOVE      #2HEDG        KHEDI2
     C                   EVAL      KDHIN2 = 'H'
     C                   EVAL      NoData2Dsp = False
     C                   EVAL      W#3SavMod = *BLANKS
     C                   MOVEA     '000000000'   *IN(44)
     C                   EVAL      NoOfTrn2 = 0
     C                   EVAL      PNoOfTrn2 = NoOfTrn2
 
     C                   ENDIF
 
      ** Initialise count of records written to subfile page.
      ** Initialise subfile relative record number.
 
     C                   EVAL      WkCnt3 = 0
     C                   EVAL      WkSRRN3 = WLRcdNum3
 
      ** Read file
 
 
     C                   IF        FirstPass3 = 'Y'
     C     KLIST1        SETLL     ASHTRNLB                                                   CAS004
     C*****KLIST1        SETLL     ASHTRNL1                                                   CAS004
     C                   EVAL      FirstPass3 = 'N'
     C***********        ELSE                                                                 230488
     C*****KLIST1        SETGT     ASHTRNLB                                            CAS004 230488
     C*****KLIST1        SETGT     ASHTRNL1                                                   CAS004
     C                   ENDIF
     C     KLIST1        READE     ASHTRNLB                               26                  CAS004
     C*****KLIST1        READE     ASHTRNL1                               26                  CAS004
 
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
 
     C                   DOW       WkCnt3 < EndOfSubfile
 
      ** Increment the counter and subfile record number.
 
     C                   EVAL      WkCnt3 = WkCnt3 + 1
     C                   EVAL      WkSRRN3 = WkSRRN3 + 1
     C                   EVAL      ProtectDACT = False                                        212430
     C                   EVAL      ProtectDMOD = False                                        212430
     C                   EVAL      ProtectPRCT = False                                        212430
     C                   EVAL      #3HDEL = *BLANK                                            212430
     C                   EVAL      #3LDEL = *BLANK                                            212430
 
     C                   SELECT
     C                   WHEN      EndOfFile = False
 
     C                   IF        InsertMode <> 'Y'                                          212430
     C                   SELECT                                                               212430
                                                                                              212430
     C                   WHEN      HdgDlLnFTrn = True                                         212430
     C                   IF        T1FSMOD = 'DL'                                             212430
     C*****T1FSDLNO      CHAIN     DEALALL                            27               212430 CLE148
     C                   MOVEL     T1FSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     DEALALL                            27                      CLE148
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        T1FSMOD = 'LE'                                             212430
     C     T1FSDLNO      CHAIN     CLOANCLF                           27                      212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        T1FSMOD = 'FH'                                             212430
     C*****T1FSDLNO      CHAIN     ASFHTRL1                           27               212430 CLE148
     C                   MOVEL     T1FSDLNO      FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           27                      CLE148
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        RecNotFnd = False                                          212430
     C                             AND RECI <> 'D'                                            212430
     C                             AND T1FSMOD <> 'FH'                                        212430
     C                             OR RecNotFnd = False                                       212430
     C**********                   AND FCRECI <> 'D'                                   212430 CAS006
     C                             AND FSRECI <> 'D'                                          212430
     C                             AND T1FSMOD = 'FH'                                         212430
     C                             OR RecNotFnd = True                                        212430
     C                                                                                        212430
     C                   EVAL      #3HDEL = '*'                                               212430
     C                   EVAL      SFleNxtChg = True                                          212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        RecNotFnd = False  AND                                     CAS005
     C                             RECI      = 'D'    AND                                     CAS005
     C                             W1stItemRec = 'Y'  AND                                     CAS005
     C                             WkDervDTYP  = 'RX'                                         CAS005
     C                   EVAL      W1stItemRec = 'N'                                          CAS005
     C                   EXSR      SRGetCCY                                                   CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   WHEN      HdgSecRef = True                                           212430
                                                                                              212430
     C     T1FSFPSE      CHAIN     SECTYDF                            27                      212430
                                                                                              212430
     C                   IF        RecNotFnd = False                                          212430
     C                             AND RECI <> 'D'                                            212430
     C                   EVAL      #3HDEL = '*'                                               212430
     C                   EVAL      SFleNxtChg = True                                          212430
     C                   ENDIF                                                                212430
     C                   ENDSL                                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        AmendMode = True                                           212430
     C                   EVAL      ProtectDMOD = True                                         212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   IF        T1FSHTCT = 'D'                                             212430
     C                   EVAL      ProtectDACT = True                                         212430
     C                   EVAL      ProtectPRCT = True                                         212430
     C                   EVAL      #3LDEL = '*'                                               212430
     C                   EVAL      NoOfTrn2 =  NoOfTrn2 - 1                                   212430
     C                   ELSE                                                                 212430
     C                   EVAL      #3LDEL = ' '                                               212430
     C                   ENDIF                                                                212430
                                                                                              212430
      ** Format subfile fields
 
     C                   EVAL      #3HACT  = *BLANK
     C                   EVAL      #3HMOD = T1FSMOD
     C**********         IF        T1FSDLNO <> 0                                              CLE148
     C                   IF        T1FSDLNO <> *BLANKS                                        CLE148
     C                   MOVE      T1FSDLNO      #3HDNO
     C                   ELSE
     C                   EVAL      #3HDNO = *BLANKS
     C                   ENDIF
     C                   EVAL      #3HSEC = T1FSFPSE
     C                   EVAL      #3HBKC = T1FSBKCD
     C                   EVAL      #3BRCA = T1FSBRCA
     C                   EVAL      #3BHTV = T1FSBHTV
     C                   MOVE      T1FSPCTG      PZFLD15
     C                   Z-ADD     2             PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #3HPCT
     C                   EVAL      #3MKTI = T1FSMKTI
 
     C                   EVAL      #3HMODP = T1FSMOD
     C**********         IF        T1FSDLNO <> 0                                              CLE148
     C                   IF        T1FSDLNO <> *BLANKS                                        CLE148
     C                   MOVE      T1FSDLNO      #3HDNOP
     C                   ELSE
     C                   EVAL      #3HDNOP = *BLANKS
     C                   ENDIF
     C                   EVAL      #3HSECP = T1FSFPSE
     C                   EVAL      #3HBKCP = T1FSBKCD
     C                   EVAL      #3BRCAP = T1FSBRCA
     C                   EVAL      #3BHTVP = T1FSBHTV
     C                   MOVE      PZOUT21       #3HPCTP
     C                   EVAL      #3MKTIP = T1FSMKTI
 
     C                   IF        W#3SavMod = *BLANKS
     C                   EVAL      W#3SavMod = #3HMOD
     C                   ENDIF
 
     C                   EVAL      NoOfTrn2 =  NoOfTrn2 + 1
     C                   EVAL      PNoOfTrn2 = NoOfTrn2
 
     C                   WHEN      EndOfFile = True
 
      ** Clear subfile fields
 
     C                   EVAL      #3HACT  = *BLANK
     C                   EVAL      #3HMOD = *BLANK
     C                   EVAL      #3HDNO = *BLANK
     C                   EVAL      #3HSEC = *BLANK
     C                   EVAL      #3HBKC = *BLANK
     C                   EVAL      #3BRCA = *BLANK
     C                   EVAL      #3BHTV = *BLANK
     C                   EVAL      #3HPCT = *BLANK
     C                   EVAL      #3MKTI = *BLANK
     C                   EVAL      #3HMODP = *BLANK
     C                   EVAL      #3HDNOP = *BLANK
     C                   EVAL      #3HSECP = *BLANK
     C                   EVAL      #3HBKCP = *BLANK
     C                   EVAL      #3BRCAP = *BLANK
     C                   EVAL      #3BHTVP = *BLANK
     C                   EVAL      #3HPCTP = *BLANK
     C                   EVAL      #3MKTIP = *BLANK
     C                   ENDSL
 
      ** Write details to the subfile.
 
     C                   Z-ADD     WkSRRN3       #3SFRN
     C                   WRITE     AS000001S3
 
      ***Read*file LF/ASHTRNL1                                                                CAS004
      ** Read file LF/ASHTRNLB                                                                CAS004
 
     C     KLIST1        READE     ASHTRNLB                               26                  CAS004
     C*****KLIST1        READE     ASHTRNL1                               26                  CAS004
 
     C                   ENDDO
 
      ** Set the record pointer to the previous record retrieved, using
      ** READPE if not yet end of file
 
     C                   IF        EndOfFile = False
     C     KLIST1        READPE    ASHTRNLB                               26                  CAS004
     C*****KLIST1        READPE    ASHTRNL1                               26                  CAS004
     C                   IF        EndOfFile = True
     C                   EVAL      SFleEnd = True
     C                   ELSE
     C                   EVAL      NoOfTrn2 =  NoOfTrn2 + 1
     C                   EVAL      PNoOfTrn2 = NoOfTrn2
     C                   ENDIF
     C                   ELSE
     C                   EVAL      SFleEnd = True
     C                   ENDIF
 
     C                   IF        InsertMode = 'Y' or AmendMode = True
     C                   EVAL      SFleEnd = False
     C                   ENDIF
 
      ** Save last relative record number to workfield to be use when rollup
      ** is pressed
 
     C                   Z-ADD     WkSRRN3       WLRcdNum3
 
     C                   IF        WkCnt3 = 0
 
     C                   EVAL      MsgIdArr(1) = 'ASM0001'
 
      ** Write blank detail to subfile.
 
     C                   Z-ADD     1             WkSRRN3
     C                   Z-ADD     1             #3SFRN
     C                   CLEAR                   Scn5DS
     C                   WRITE     AS000001S3
 
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn1 - Validate screen 1                                 *
      *                                                               *
      * Called by: SRScn1                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValScn1     BEGSR
 
     C                   EVAL      WScrn = '1'
 
      ** Check if review from field is used and not the same as the previous fie
 
      ** Blank out review from field if not numeric
 
     C                   EVAL      PZADEC = 0
     C                   EVAL      PZADIG = 6
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #1HEDR
     C                   EXSR      SRZAlign
     C                   IF        PZAlignOk = 'N'
     C                   EVAL      #1HEDR = *BLANKS
     C                   ELSE
     C                   MOVE      PZFIELD       #1HEDR
     C                   ENDIF
 
     C                   MOVE      PZFIELD       N#1HEDR
     C                   IF        N#1HEDR = *ZERO
     C                   EVAL      #1HEDR = *BLANKS
     C                   ENDIF
 
     C                   IF        N#1HEDR <> *ZERO and N#1HEDR <> P#1HEDR
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      P#1HEDR = N#1HEDR
     C                   EVAL      KHEDI = N#1HEDR
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C1
     C                   EVAL      SFleClr = False
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = False
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   GOTO      EndValS1
     C                   ENDIF
 
      ** Read subfile
 
     C                   READC     AS000001S1                             26
 
     C                   IF        EndOfFile = True
     C                   IF        N#1HEDR <> *ZERO
     C                   EVAL      KeyFlag = 'Y'
     C                   EVAL      P#1HEDR = N#1HEDR
     C                   EVAL      KHEDI = N#1HEDR
     C                   EVAL      SFleClr = True
     C                   WRITE     AS000001C1
     C                   EVAL      SFleClr = False
     C                   EVAL      WLRcdNum  = 0
     C                   EVAL      SFleEnd = False
     C                   ELSE
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      KeyFlag = 'N'
     C                   ENDIF
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   GOTO      EndValS1
     C                   ENDIF
 
     C                   DOW       EndOfFile = False
 
     C                   SELECT
 
      ** Enquire
 
     C                   WHEN      #1SEL = 'E' and SelMode = False
     C                   EVAL      InsertMode  = 'N'
     C                   EVAL      AmendMode   = False
     C                   EVAL      EnquireMode = True
     C                   EVAL      DeleteMode  = False
     C                   EVAL      ErrSelOpt = False
     C                   EXSR      SRCvtToScn3
     C                   EXSR      SRScn3
 
      ** Amend
 
     C                   WHEN      #1SEL = 'A' and SelMode = False
     C                   IF        MntMode = True
     C                   EXSR      SRChkAmdble
 
     C                   IF        WGotoScn3 =  'Y'
     C                   EVAL      InsertMode  = 'N'
     C                   EVAL      AmendMode   = True
     C                   EVAL      EnquireMode = False
     C                   EVAL      DeleteMode  = False
     C                   EVAL      ErrSelOpt = False
     C                   EXSR      SRCvtToScn3
     C                   EXSR      SRScn3
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(Idx) = WChkMsgId
     C                   MOVE      #1HEDG        MsgDtaArr(Idx)
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(Idx) = 'ASM0002'
     C                   ENDIF
 
      ** Delete
 
     C                   WHEN      #1SEL = 'D' and SelMode = False
     C                   IF        MntMode = True
     C                   EXSR      SRChkAmdble
 
     C                   SELECT
     C                   WHEN      WGotoScn3 = 'Y' and FSENDT > BJRDNB
     C                             and WRedisplay = 'N'
     C                             AND #1STS = *BLANKS                                        212430
     C                   EVAL      WIdx = WIdx + 1
     C                   EVAL      WRedisplay = 'Y'
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(WIdx) = 'ASM0114'
     C                   EVAL      MsgDtaArr(WIdx) = #1HEDG
     C                   WHEN      WGotoScn3 =  'Y'
     C                   EVAL      WRedisplay = 'N'
     C                   EVAL      InsertMode  = 'N'
     C                   EVAL      AmendMode   = False
     C                   EVAL      EnquireMode = False
     C                   EVAL      DeleteMode  = True
     C                   EVAL      ErrSelOpt = False
     C                   EXSR      SRCvtToScn3
     C                   EXSR      SRScn3
     C                   WHEN      WGotoScn3 <> 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(Idx) = WChkMsgId
     C                   MOVE      #1HEDG        MsgDtaArr(Idx)
     C                   ENDSL
 
     C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(Idx) = 'ASM0002'
     C                   ENDIF
 
      ** Selection
 
     C                   WHEN      #1SEL = '1' and SelMode = True
     C                   MOVE      #1HEDI        PHedgeId
     C                   EVAL      ErrSelOpt = False
     C                   EVAL      RetCodeIn = *BLANKS
     C                   EVAL      WScrn = 'T'
 
      ** Not 'A', 'E', 'D' , or '1' error on selection
 
     C                   OTHER
 
     C                   IF        #1SEL <> ' '
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSelOpt = True
     C                   EVAL      MsgIdArr(Idx) = 'ASM0002'
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        *INKC = True or *INKL = True
     C                   LEAVE
     C                   ENDIF
 
      ** Update record in subfile
 
     C                   EVAL      SFleNxtChg = True
     C                   UPDATE    AS000001S1
     C                   EVAL      SFleNxtChg = False
     C                   EVAL      ErrSelOpt = False
 
     C                   IF        Idx <> 0 or WIdx <> 0
     C                   LEAVE
     C                   ENDIF
 
      ** Read subfile
 
     C                   READC     AS000001S1                             26
 
     C                   ENDDO
 
     C                   IF        *INKC = False and SelMode = False and
     C                             Idx = 0 and WIdx = 0
     C                   EVAL      #1HEDG = *BLANKS
     C                   EVAL      #1HEDR = *BLANKS
     C                   EVAL      ErrSelOpt = False
     C                   EVAL      FirstPass = 'Y'
     C                   EVAL      KeyFlag    = 'N'
     C                   EXSR      SRBldSfl
     C                   EVAL      WScrn = '1'
     C                   ENDIF
 
     C     EndValS1      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn2 - Validate screen 2                                 *
      *                                                               *
      * Called by: SRScn2                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValScn2     BEGSR
 
     C                   EVAL      WScrn = '2'
 
      ** Validate Hedge ID
 
     C                   TESTN                   #1HEDG               88
     C                   MOVE      #1HEDG        WkTest
     C                   TESTZ                   WkTest                   89
     C                   IF        WrkInd1 <> True or WrkInd2 <> True  or
     C                             #1HEDG = *ALL'0' or #1HEDG = *BLANKS
     C                   EVAL      ErrNwHdgID = True
     C                   EVAL      Idx = Idx + 1
      ** New Hedge Linkage ID must be a 6 digit number and not equal to zero.
     C                   EVAL      MsgIdArr(1) = 'ASM0036'
     C                   MOVE      #1HEDG        MsgDtaArr(Idx)
     C                   ENDIF
 
     C                   IF        ErrNwHdgID = True
     C                   EVAL      DspScn2 = 'Y'
     C                   ELSE
     C                   MOVE      #1HEDG        KHEDI
     C     KHEDI         CHAIN     ASHGLKL1                           27
     C                   IF        RecNotFnd = False
     C                   EVAL      ErrNwHdgID = True
     C                   EVAL      Idx = Idx + 1
      ** Hedge Linkage &1 already exists: please re-enter another ID
     C                   EVAL      MsgIdArr(1) = 'ASM0037'
     C**********         MOVE      #1HEDG        MsgDtaArr(Idx)                               229174
     C                   MOVEL     #1HEDG        MsgDtaArr(Idx)                               229174
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrNwHdgID = True                                          229174
     C                   EVAL      DspScn2 = 'Y'                                              229174
     C                   ELSE                                                                 229174
     C                   MOVE      #1HEDG        KAHID                                        229174
     C     KAHID         CHAIN     ASAHIDL1                                                   229174
                                                                                              229174
     C                   IF        %FOUND(ASAHIDL1) AND                                       229174
     C                             (WHEDG <> KAHID)                                           229174
     C                   EVAL      ErrNwHdgID = True                                          229174
     C                   EVAL      Idx = Idx + 1                                              229174
                                                                                              229174
      ** Hedge Linkage &1 already exists: please re-enter another ID                          229174
                                                                                              229174
     C                   EVAL      MsgIdArr(1) = 'ASM0037'                                    229174
     C                   MOVEL     #1HEDG        MsgDtaArr(Idx)                               229174
     C                   ENDIF                                                                229174
     C                   ENDIF                                                                229174
                                                                                              229174
     C                   IF        ErrNwHdgID = True
     C                   EVAL      DspScn2 = 'Y'
     C                   ELSE
                                                                                              229174
      ** Allocate this Hedge ID if necessary.                                                 229174
                                                                                              229174
     C                   MOVE      #1HEDG        WAHID                                        229174
                                                                                              229174
     C                   IF        WHEDG <> WAHID                                             229174
     C                   EVAL      KAHID = WHEDG                                              229174
     C     KAHID         CHAIN     ASAHIDL0                                                   229174
     C                   IF        %FOUND(ASAHIDL0)                                           229174
     C                   DELETE    ASAHIDD0                                                   229174
     C                   ENDIF                                                                229174
     C                   EVAL      WHEDG = WAHID                                              229174
     C                   EVAL      FSAHID = WAHID                                             229174
     C                   WRITE     ASAHIDD0                                                   229174
     C                   ENDIF                                                                229174
                                                                                              229174
     C                   MOVE      #1HEDG        #2HEDG
     C                   EVAL      #2HGST = *BLANKS
     C                   EVAL      #2EFFD = *BLANKS
     C                   EVAL      #2INDT = *BLANKS
     C                   EVAL      #2FCOA = *BLANKS
     C                   EVAL      #2ICAT = *BLANKS
     C                   EVAL      #2STDT = *BLANKS
     C                   EVAL      #2ENDT = *BLANKS
     C                   EVAL      #2DVDL = *BLANKS
     C                   EVAL      #2FTPO = *BLANKS
     C                   EVAL      #2HGDL = *BLANKS
     C                   EVAL      #2SECR = *BLANKS
     C                   EVAL      #2DTTP = *BLANKS                                           CAS006
     C                   EVAL      #2DPTS = *BLANKS                                           CAS006
     C                   EVAL      #2DFRQ = *BLANKS                                           CAS006
     C                   EVAL      #2WDAY = *BLANKS                                           CAS006
     C                   EVAL      #2MNTH = *BLANKS                                           CAS006
     C                   EVAL      #2NDTA = *BLANKS                                           CAS006
     C                   CLEAR                   Scn4Arr
     C                   CLEAR                   Scn5Arr
     C                   EVAL      P#2DVDL = *BLANKS
     C                   EVAL      P#2FTPO = *BLANKS
     C                   EVAL      P#2HGDL = *BLANKS
     C                   EVAL      P#2SECR = *BLANKS
     C                   EVAL      FutMode = *BLANKS
     C                   EVAL      InsertMode = 'Y'
     C                   EVAL      AmendMode   = False
     C                   EVAL      EnquireMode = False
     C                   EVAL      DeleteMode  = False
     C                   EXSR      SRScn3
     C                   ENDIF
 
     C     EndValS2      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn3 - Validate screen 3                                 *
      *                                                               *
      * Called by: SRScn3                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValScn3     BEGSR
 
     C                   EVAL      WScrn = '3'
 
     C                   CLEAR                   Scn3DS
     C                   EVAL      Idx = 0
     C                   MOVE      #2HEDG        W#2HEDG
 
     C                   IF        InsertMode = 'Y' or AmendMode = True
 
      ** Validate Hedge Strategy
      ** -----------------------
 
     C                   IF        #2HGST = *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrHdgStgy = True
      ** Hedge Strategy must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0038'
     C                   ELSE
     C                   CLEAR                   SDHGST
     C                   CALL      'AOHGSTR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    #2HGST
     C     SDHGST        PARM      SDHGST        DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrHdgStgy = True
      ** Hedge Strategy is invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0039'
     C                   ELSE
     C                   EVAL      #2HGST = HSHESN
     C                   EVAL      W#2HGST = HSHESN
 
      ** At this point you should save the derivative types/subtypes/book codes
      ** and hedge types/subtypes/book codes of the hedge strategy
      ** a work array.
 
     C                   MOVEA     DVTypDS       DVTypAr
     C                   MOVEA     DVTypDS       DVTypAr5
     C                   MOVEA     DVTypDS       DVTypAr2
     C                   MOVEA     DVSTypDS      DVSTypAr
     C                   MOVEA     DVBkCdDS      DVBkCdAr
     C                   MOVEA     HGTypDS       HGTypAr
     C                   MOVEA     HGSTypDS      HGSTypAr
     C                   MOVEA     HGBkCdDS      HGBkCdAr
 
     C                   EVAL      C = 1
     C                   DOU       C > 10
     C                   EVAL      DVTypAr2b(C) = DVTypAr(C)
     C                   EVAL      C = C + 1
     C                   ENDDO
 
     C                   EVAL      C = 1
     C                   DOU       C > 10
     C                   EVAL      HGTypAr2b(C) = HGTypAr(C)
     C                   EVAL      C = C + 1
     C                   ENDDO
 
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Start Date
      ** -------------------
 
     C                   IF        #2STDT = *BLANKS or #2ENDT = *ALL'0'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrStrDate = True
      ** Start date is invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0040'
     C                   ELSE
     C                   MOVE      #2STDT        PZDateA
     C                   EXSR      SRValDate
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrStrDate = True
      ** Start date is invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0040'
     C                   ELSE
 
     C                   EVAL      WSdte = PZDayNo
 
     C                   SELECT
 
      ** If insert, start date cannot be less than system run date
 
     C                   WHEN      InsertMode = True and WSdte < BJRDNB
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrStrDate = True
      ** Start date must be greater than or equal to the system rundate.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0041'
 
      ** If Amend, start date cannot be amended for linkage that has started
 
     C                   WHEN      AmendMode = True and WSdte < BJRDNB and
     C                             WSdte <> FSSTDT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrStrDate = True
      ** Start Date cannot be amended for Linkage that has already started
     C                   EVAL      MsgIdArr(Idx) = 'ASM0042'
 
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrStrDate = False
     C                   EVAL      W#2STDT = WSdte
     C                   ENDIF
 
      ** Validate End Date
      ** -----------------
 
     C                   IF        #2ENDT = *BLANKS or #2ENDT = *ALL'0'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEndDate = True
      ** End Date is Invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0043'
     C                   ELSE
     C                   MOVE      #2ENDT        PZDateA
     C                   EXSR      SRValDate
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEndDate = True
      ** End Date is Invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0043'
     C                   ELSE
 
     C                   EVAL      WEdte = PZDayNo
 
      ** Start date must be less than end date
 
     C                   IF        ErrStrDate = False and WEdte <= WSdte
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrStrDate = True
     C                   EVAL      ErrEndDate = True
      ** End Date must be greater than Start Date
     C                   EVAL      MsgIdArr(Idx) = 'ASM0044'
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrEndDate = False
     C                   EVAL      W#2ENDT = WEdte
     C                   ENDIF
 
      ** Validate Effective Date
      ** -----------------------
 
     C                   IF        #2EFFD = *BLANKS or #2EFFD = *ALL'0'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEffDate = True
      ** Effective Date is Invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0045'
     C                   ELSE
     C                   MOVE      #2EFFD        PZDateA
     C                   EXSR      SRValDate
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEffDate = True
      ** Effective Date is Invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0045'
     C                   ELSE
 
     C                   EVAL      WEffD = PZDayNo
 
     C                   IF        ErrHdgStgy = True
     C                   EVAL      HSFSDT = 0
     C                   ENDIF
 
     C                   SELECT
 
      ** Must be greater than or equal to strategy's first date
 
     C                   WHEN      WEffd < HSFSDT
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEffDate = True
      ** Effective Date must be greater or equal to Strategy's First Date
     C                   EVAL      MsgIdArr(Idx) = 'ASM0046'
 
      ** Must be greater than or equal to system run date
 
     C                   WHEN      WEffd < BJRDNB
     C                             AND CAS008 = 'N'                                           CAS008
     C                             OR WEffd < BJRDNB                                          CAS008
     C                             AND CAS008 = 'Y'                                           CAS008
     C                             AND FSEFFD <> WEffd                                        CAS008
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEffDate = True
      ** Effective Date must be greater or equal to the System Run Date
     C                   EVAL      MsgIdArr(Idx) = 'ASM0047'
 
      ** Must be within the range of start and end dates
 
     C                   WHEN      WEffd < WSdte or WEffd > WEdte
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrEffDate = True
      ** Effective Date must be within the range of Start and End Dates
     C                   EVAL      MsgIdArr(Idx) = 'ASM0048'
 
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrEffDate = False
     C                   EVAL      W#2EFFD = WEffd
     C                   ENDIF
 
      ** Validate Input Date
      ** -------------------
 
     C                   IF        #2INDT = *BLANKS or #2INDT = *ALL'0'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrInpDate = True
      ** Input Date is invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0049'
     C                   ELSE
     C                   MOVE      #2INDT        PZDateA
     C                   EXSR      SRValDate
     C                   IF        ErrorFlag = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrInpDate = True
      ** Input Date is invalid
     C                   EVAL      MsgIdArr(Idx) = 'ASM0049'
     C                   ELSE
 
     C                   EVAL      WInpD = PZDayNo
 
      ** Must be less than or equal to system run date
 
     C                   IF        WInpD > BJRDNB
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrInpDate = True
      ** Input Date must be less or equal to the System Run Date
     C                   EVAL      MsgIdArr(Idx) = 'ASM0050'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrInpDate = False
     C                   EVAL      W#2INDT = WInpD
     C                   ENDIF
 
      ** Validate Functional Currency Offset
      ** -----------------------------------
 
      ** Validation of functional ccy offset and Inv category will                            CAS006
      ** be bypassed but fields will remain for future use                                    CAS006
                                                                                              CAS006
     C                   IF        WBYPAS <> 'Y'                                              CAS006
                                                                                              CAS006
     C                   IF        #2FCOA <> 'Y' and #2FCOA <> 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrFuncCcy = True
      ** Functional Currency Offset Approach must be "Y" or "N"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0051'
     C                   ELSE
     C                   EVAL      W#2FCOA = #2FCOA
     C                   ENDIF
 
      ** Validate Investment Category
      ** ----------------------------
 
      ** Must be left blank if hedged security reference not entered
 
     C                   IF        #2SECR = *BLANKS and #2ICAT <> *BLANKS or
     C                             #2SECR = 'N' and #2ICAT <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrInvCat  = True
      ** Investment Category must be blank if Hedged Security Reference is "N"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0052'
 
     C                   ENDIF
                                                                                              CAS006
     C**********         ENDIF                                                         CAS006 224554
 
     C                   IF        ErrInvCat = False and #2SECR = 'Y'
 
      ** Valid values are:
      **    H-Held to maturity
      **    A-Available for sale
      **    I-Issued
 
     C                   IF        #2ICAT <> 'H' and #2ICAT <> 'A' and
     C                             #2ICAT <> 'I'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrInvCat  = True
      ** Investment category must be (H)eld for maturity,(A)vailable for sale, or (I)ssued
     C                   EVAL      MsgIdArr(Idx) = 'ASM0053'
     C                   ELSE
     C                   EVAL      W#2ICAT = #2ICAT
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF                                                                224554
 
      ** Validate Hedge Derivative Deals and Hedge Futures Position
      ** ----------------------------------------------------------
 
     C                   IF        #2DVDL <> 'Y' and FTPOused = False
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrDVDL = True
      ** Valid entry is only 'Y' as Hedge Futures Trades/Position not available.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0119'
     C                   ENDIF
 
     C                   IF        #2FTPO <> 'Y' and DVDLused = False
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrFTPO = True
      ** Valid entry is only 'Y' as Hedge Derivative Deals not available.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0120'
     C                   ENDIF
 
     C                   IF        ErrDVDL = False and ErrFTPO = False and
     C                             #2DVDL = *BLANKS and #2FTPO = *BLANKS
     C                   IF        DLModOn = 'Y' or FFModOn = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrDVDL = True
     C                   EVAL      ErrFTPO = True
      ** Hedging data cannot be both blanks.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0054'
     C                   ENDIF
     C                   ENDIF
 
 
     C                   IF        ErrDVDL = False and ErrFTPO = False
     C                   IF        #2DVDL = #2FTPO  or #2DVDL <> 'Y' and
     C                             #2DVDL <> 'N' and #2DVDL <> *BLANKS or
     C                             #2FTPO <> 'Y' and #2FTPO <> 'N' and
     C                             #2FTPO <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrDVDL = True
     C                   EVAL      ErrFTPO = True
      ** Valid entries are "Y", "N" or blank.  Hedging data must not have the same entries
     C                   EVAL      MsgIdArr(Idx) = 'ASM0055'
     C                   ENDIF
     C                   ENDIF
 
      ** Validate Hedge Deals/Loans and Hedge Security Reference
      ** -------------------------------------------------------
 
     C                   IF        #2HGDL <> 'Y' and SECRused = False
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrHGDL = True
      ** Valid entry is only 'Y' as Hedged Security Reference not available
     C                   EVAL      MsgIdArr(Idx) = 'ASM0121'
     C                   ENDIF
 
     C                   IF        #2SECR <> 'Y' and HGDLused = False
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSECR = True
      ** Valid entry is only 'Y' as Hedged Deals/Loans/Forecast Transaction not available
     C                   EVAL      MsgIdArr(Idx) = 'ASM0122'
     C                   ENDIF
 
     C                   IF        ErrHGDL = False and ErrSECR = False and
     C                             #2HGDL = *BLANKS and #2SECR = *BLANKS
     C                   IF        DLModOn = 'Y' or LEModOn = 'Y' or
     C                             SEModOn = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrHGDL = True
     C                   EVAL      ErrSECR = True
      ** Hedged data cannot be both blanks.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0056'
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrHGDL = False and ErrSECR = False
     C                   IF        #2HGDL = #2SECR  or #2HGDL <> 'Y' and
     C                             #2HGDL <> 'N' and #2HGDL <> *BLANKS or
     C                             #2SECR <> 'Y' and #2SECR <> 'N' and
     C                             #2SECR <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrHGDL = True
     C                   EVAL      ErrSECR = True
      ** Valid entries are "Y", "N" or blank.  Hedged data must not have the same entries
     C                   EVAL      MsgIdArr(Idx) = 'ASM0057'
     C                   ENDIF
     C                   ENDIF
 
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
                                                                                              CAS006
      ** Validate Data Type                                                                   CAS006
      ** ------------------                                                                   CAS006
                                                                                              CAS006
      ** Validation of Data type will bypassed but field will                                 224554
      ** remain for future use                                                                224554
                                                                                              224554
     C                   IF        WBYPAS <> 'Y'                                              224554
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
      ***Validation*of*Data*type*will*bypassed*but*field*will**********                CAS006 224554
      ***remain*for*future*use*****************************************                CAS006 224554
      **********                                                                       CAS006 224554
     C**********         IF        WBYPAS <> 'Y'                                       CAS006 224554
     C                   IF        #2DTTP <>  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDTTP = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2DTTP  =  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDTTP = True                                            CAS006
                                                                                              CAS006
      ** Field is mandatory for Regression Method                                             CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0138'                                  CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Data Type 'R' to be revisited.                                                       CAS006
                                                                                              CAS006
     C                   IF        #2DTTP <> 'V' AND                                          CAS006
     C                             #2DTTP <> 'C'                                              CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDTTP = True                                            CAS006
                                                                                              CAS006
      ** Valid values are 'V' or 'C'.                                                         CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0139'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrDTTP = False                                           CAS006
     C                   EVAL      W#2DTTP = #2DTTP                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Data Points Required                                                        CAS006
      ** -----------------------------                                                        CAS006
                                                                                              CAS006
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
     C                   IF        #2DPTS <> *BLANKS AND                                      CAS006
     C                             #2DPTS <> *ALL'0'                                          CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDPTS = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2DPTS  =  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDPTS = True                                            CAS006
                                                                                              CAS006
      ** Field is mandatory for Regression Method                                             CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0138'                                  CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   EVAL      WkDPTS = *ZERO                                             CAS006
     C                   EVAL      PZADEC = 0                                                 CAS006
     C                   EVAL      PZADIG = 3                                                 CAS006
     C                   EVAL      PZFIELD = *BLANKS                                          CAS006
     C                   EVAL      PZFIELD = #2DPTS                                           CAS006
     C                   EXSR      SRZAlign                                                   CAS006
     C                   MOVE      PZFIELD       WkDPTS                                       CAS006
                                                                                              CAS006
      ** Degrees of Freedom (n-2)                                                             CAS006
                                                                                              CAS006
     C                   EVAL      KXXDfrd = WkDPTS - 2                                       CAS006
                                                                                              CAS006
      ** Alpha                                                                                CAS006
                                                                                              CAS006
     C                   EVAL      KXXArea = (100- HGFSCLVL)/200                              CAS006
                                                                                              CAS006
      ** Check if existing in Midas SD T Distribution Table                                   CAS006
                                                                                              CAS006
     C     KSdtdtb       CHAIN     SDTDTBL0                                                   CAS006
                                                                                              CAS006
     C                   IF        WkDPTS >= 8    AND                                         CAS006
     C                             WkDPTS <= 999  AND                                         CAS006
     C                             %FOUND(SDTDTBL0) AND                                       CAS006
     C                             PZAlignOk <> 'N'                                           CAS006
     C                   MOVE      *BLANKS       PZFLD15                                      CAS006
     C                   MOVE      WkDPTS        PZFLD15                                      CAS006
     C                   Z-ADD     0             PZDECS                                       CAS006
     C                   EXSR      SRCvtAmt                                                   CAS006
     C                   MOVE      PZOUT21       #2DPTS                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDPTS = True                                            CAS006
                                                                                              CAS006
      ** Data Points should be between 8-999 and its T-value must exist                       CAS006
      ** in the T-distribution table.                                                         CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0140'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrDPTS = False                                           CAS006
     C                   MOVE      WkDPTS        W#2DPTS                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Data Collection Frequency                                                   CAS006
      ** ----------------------------------                                                   CAS006
                                                                                              CAS006
     C                   EVAL      W#2DFRQ = *BLANKS                                          CAS006
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
     C                   IF        #2DFRQ <>  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDFRQ = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2DFRQ  =  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDFRQ = True                                            CAS006
                                                                                              CAS006
      ** Field is mandatory for Regression Method                                             CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0138'                                  CAS006
     C                   ELSE                                                                 CAS006
     C                   IF        #2DFRQ = 'D' OR                                            CAS006
     C                             #2DFRQ = 'W' OR                                            CAS006
     C                             #2DFRQ = 'M' OR                                            CAS006
     C                             #2DFRQ = 'B' OR                                            CAS006
     C                             #2DFRQ = 'Q'                                               CAS006
     C                   EVAL      WErrDFRQ = '0'                                             CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDFRQ = True                                            CAS006
                                                                                              CAS006
      ** Valid values are 'D', 'W', 'M', 'B' or 'Q'.                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0141'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrDFRQ = False                                           CAS006
     C                   EVAL      W#2DFRQ = #2DFRQ                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Day of the Week                                                             CAS006
      ** ------------------------                                                             CAS006
                                                                                              CAS006
     C                   EVAL      W#2WDAY = *BLANKS                                          CAS006
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
     C                   IF        #2WDAY <>  *BLANKS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrWDAY = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2WDAY  =  *BLANKS AND                                     CAS006
     C                             #2DFRQ  =  'W'     OR                                      CAS006
     C                             #2WDAY  <> *BLANKS AND                                     CAS006
     C                             #2DFRQ  <> 'W'                                             CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrWDAY = True                                            CAS006
                                                                                              CAS006
      ** If Data Collection Frequency is 'W', field is mandatory. Otherwise                   CAS006
      ** this should not be entered.                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0153'                                  CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2DFRQ  =  'W'                                             CAS006
     C                   IF        #2WDAY <> 'MON' AND                                        CAS006
     C                             #2WDAY <> 'TUE' AND                                        CAS006
     C                             #2WDAY <> 'WED' AND                                        CAS006
     C                             #2WDAY <> 'THU' AND                                        CAS006
     C                             #2WDAY <> 'FRI' AND                                        CAS006
     C                             #2WDAY <> 'SAT' AND                                        CAS006
     C                             #2WDAY <> 'SUN'                                            CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrWDAY = True                                            CAS006
                                                                                              CAS006
      ** Valid values are 'MON', TUE', 'WED', 'THU', 'FRI',                                   CAS006
      ** 'SAT', OR 'SUN'.                                                                     CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0142'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrWDAY = False                                           CAS006
     C                   EVAL      W#2WDAY = #2WDAY                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Day of the Month                                                            CAS006
      ** -------------------------                                                            CAS006
                                                                                              CAS006
     C                   EVAL      W#2MNTH = *ZEROS                                           CAS006
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
     C                   IF        #2MNTH = *BLANKS OR                                        CAS006
     C                             #2MNTH = *ALL'0'                                           CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrMNTH = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2MNTH  =  *BLANKS AND                                     CAS006
     C                             #2DFRQ  =  'M'     OR                                      CAS006
     C                             #2MNTH  <> *BLANKS AND                                     CAS006
     C                             #2DFRQ  <> 'M'                                             CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrMNTH = True                                            CAS006
                                                                                              CAS006
      ** If Data Collection Frequency is 'M', field is mandatory. Otherwise,                  CAS006
      ** this should not be entered.                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0154'                                  CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   EVAL      WkMNTH  = *ZERO                                            CAS006
     C                   IF        #2DFRQ  =  'M'                                             CAS006
     C                   EVAL      PZADEC = 0                                                 CAS006
     C                   EVAL      PZADIG = 2                                                 CAS006
     C                   EVAL      PZFIELD = *BLANKS                                          CAS006
     C                   EVAL      PZFIELD = #2MNTH                                           CAS006
     C                   EXSR      SRZAlign                                                   CAS006
     C                   MOVE      PZFIELD       WkMNTH                                       CAS006
                                                                                              CAS006
     C                   IF        WkMNTH >= 1    AND                                         CAS006
     C                             WkMNTH <= 31   AND                                         CAS006
     C                             PZAlignOk <> 'N'                                           CAS006
     C                   MOVE      *BLANKS       PZFLD15                                      CAS006
     C                   MOVE      WkMNTH        PZFLD15                                      CAS006
     C                   Z-ADD     0             PZDECS                                       CAS006
     C                   EXSR      SRCvtAmt                                                   CAS006
     C                   MOVE      PZOUT21       #2MNTH                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrMNTH = True                                            CAS006
                                                                                              CAS006
      ** Value should be from 1 to 31.                                                        CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0143'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrMNTH = False                                           CAS006
     C                   MOVE      WkMNTH        W#2MNTH                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Next Data Collection Date                                                   CAS006
      ** ----------------------------------                                                   CAS006
                                                                                              CAS006
     C                   IF        HSMEFF = 'D'                                               CAS006
                                                                                              CAS006
     C                   IF        #2NDTA <> *BLANKS AND                                      CAS006
     C                             #2NDTA <> *ALL'0'                                          CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
                                                                                              CAS006
      ** Field should not be entered                                                          CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0137'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
     C                   IF        #2NDTA <> *BLANKS                                          CAS006
     C                   MOVE      #2NDTA        PZDateA                                      CAS006
     C                   EXSR      SRValDate                                                  CAS006
     C                   IF        ErrorFlag = 'Y'                                            CAS006
     C                   EVAL      WPrevNDTA = *ZEROS                                         CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
                                                                                              CAS006
      ** Next Data Collection is invalid.                                                     CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0145'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   EVAL      W#2NDTA = *ZEROS                                           CAS006
     C                   IF        WErrDFRQ = FALSE                                           CAS006
     C                             AND WErrWDAY = FALSE                                       CAS006
     C                             AND WErrMNTH = FALSE                                       CAS006
     C                             AND ErrorFlag <> 'Y'                                       CAS006
     C                   EVAL      WkNDTA  = PZDayNo                                          CAS006
     C                   EVAL      WBlankNDTA = 'N'                                           CAS006
                                                                                              CAS006
      ** Get Next Collection date.                                                            CAS006
                                                                                              CAS006
     C                   EVAL      PNxtColDay = 'NEXT'                                        CAS006
     C                   EVAL      PIncldTday = 'Y'                                           CAS006
     C                   EVAL      Pzfreq  = W#2DFRQ                                          CAS006
     C                   EVAL      Pzday   = BJRDNB                                           CAS006
                                                                                              CAS006
     C                   SELECT                                                               CAS006
     C                   WHEN      PZFreq = 'W'                                               CAS006
     C                   EVAL      PZWDay = W#2WDAY                                           CAS006
     C                   MOVE      *BLANKS       PZMDay                                       CAS006
     C                   WHEN      PZFreq = 'M'                                               CAS006
     C                   EVAL      PZWDay = *BLANKS                                           CAS006
     C                   EVAL      PZMDay = W#2MNTH                                           CAS006
     C                   OTHER                                                                CAS006
     C                   EVAL      PZWDay = *BLANKS                                           CAS006
     C                   MOVE      *BLANKS       PZMDay                                       CAS006
     C                   ENDSL                                                                CAS006
                                                                                              CAS006
     C                   EVAL      Pzccy   = BJCYCD                                           CAS006
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS006
     C                   EXSR      SrZFreqC                                                   CAS006
     C                   EVAL      W#2NDTA = Pzday                                            CAS006
     C                   EVAL      WBDAT1 = PBaseDate                                         225342
                                                                                              CAS006
     C                   IF        #2NDTA = *BLANKS OR #2NDTA = *ALL'0'                       CAS006
     C                   EVAL      WIdx = WIdx + 1                                            CAS006
     C                   EVAL      WBlankNDTA = 'Y'                                           CAS006
     C                   EVAL      WkNDTA  = W#2NDTA                                          CAS006
     C                   EVAL      PZDayNo = W#2NDTA                                          CAS006
     C                   EXSR      SRCvtDate                                                  CAS006
     C                   MOVE      PZDate        #2NDTA                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WBlankNDTA = 'N'                                           CAS006
     C                   IF        WkNDTA  <  BJRDNB                                          CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
                                                                                              CAS006
      ** Date should not be less than run date                                                CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0144'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WkNDTA  <> W#2NDTA                                         CAS006
     C                   EVAL      WFlgNDTA = 'N'                                             CAS006
                                                                                              CAS006
      ** Check if date entered is a holiday.                                                  CAS006
                                                                                              CAS006
     C                   EVAL      PzDayH  = WkNDTA                                           CAS006
     C                   EVAL      PzccyH  = BJCYCD                                           CAS006
     C                   EXSR      SrZChkH                                                    CAS006
                                                                                              CAS006
     C                   IF        PzIndH <> 'W'                                              CAS006
     C                             AND WPrevNDTA <> WkNDTA                                    CAS006
     C                   EVAL      WIdx = WIdx + 1                                            CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
     C                   EVAL      WFlgNDTA = 'Y'                                             CAS006
     C                   EVAL      WPrevNDTA = WkNDTA                                         CAS006
                                                                                              CAS006
      ** Warning: Date entered is a holiday and does not agree with                           CAS006
      **          the calculated next data collection date.                                   CAS006
                                                                                              CAS006
     C                   EVAL      WMsgIdArr(WIdx) = 'ASM0158'                                CAS006
     C                   EVAL      WFldNamArr(WIdx) = '#2NDTA'                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WkNDTA  <> W#2NDTA                                         CAS006
     C                             AND WFlgNDTA = 'N'                                         CAS006
     C                   IF        WPrevNDTA <> WkNDTA                                        CAS006
     C                   EVAL      WIdx = WIdx + 1                                            CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
     C                   EVAL      WFlgNDTA = 'Y'                                             CAS006
     C                   EVAL      WPrevNDTA = WkNDTA                                         CAS006
                                                                                              CAS006
      ** Warning: Date entered does not agree with the calculated next                        CAS006
      **          collection date based on the collection frequency.                          CAS006
                                                                                              CAS006
     C                   EVAL      WMsgIdArr(WIdx) = 'ASM0146'                                CAS006
     C                   EVAL      WFldNamArr(WIdx) = '#2NDTA'                                CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WErrNDTA = False                                           CAS006
     C                   EVAL      W#2NDTA = WkNDTA                                           CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Frequency, Data Points Required and Collection Date                         CAS006
      ** ------------------------------------------------------------                         CAS006
                                                                                              CAS006
      ** Due to Midas Date limitations, check if we can handle the number                     CAS006
      ** of data points required.                                                             CAS006
                                                                                              CAS006
     C                   IF        HSMEFF = 'R'                                               CAS006
     C                             AND WErrDPTS = False                                       CAS006
     C                             AND WErrDFRQ = False                                       CAS006
     C                             AND WErrNDTA = False                                       CAS006
                                                                                              CAS006
      ** Get Previous Collection Date                                                         CAS006
                                                                                              CAS006
     C                   EVAL      PNxtColDay = 'PREV'                                        CAS006
     C                   EVAL      PIncldTday = 'N'                                           CAS006
     C                   EVAL      Pzfreq  = W#2DFRQ                                          CAS006
     C                   EVAL      Pzday   = W#2NDTA                                          CAS006
     C                   SELECT                                                               CAS006
     C                   WHEN      PZFreq = 'W'                                               CAS006
     C                   EVAL      PZWDay = W#2WDAY                                           CAS006
     C                   MOVE      *BLANKS       PZMDay                                       CAS006
     C                   WHEN      PZFreq = 'M'                                               CAS006
     C                   EVAL      PZWDay = *BLANKS                                           CAS006
     C                   EVAL      PZMDay = W#2MNTH                                           CAS006
     C                   OTHER                                                                CAS006
     C                   EVAL      PZWDay = *BLANKS                                           CAS006
     C                   MOVE      *BLANKS       PZMDay                                       CAS006
     C                   ENDSL                                                                CAS006
     C                   EVAL      Pzccy   = BJCYCD                                           CAS006
     C                   EVAL      PBJDFIN = BJDFIN                                           CAS006
                                                                                              CAS006
     C                   EVAL      WCountDPTS = *ZERO                                         CAS006
     C                   DOW       WcountDPTS <  W#2DPTS                                      CAS006
     C                   EXSR      SrZFreqC                                                   CAS006
     C                   IF        PRetCodeIn = '*LIMIT  '                                    CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      WErrDPTS = True                                            CAS006
     C                   EVAL      WErrDFRQ = True                                            CAS006
     C                   EVAL      WErrNDTA = True                                            CAS006
                                                                                              CAS006
      ** Data Points Required is too large.                                                   CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0162'                                  CAS006
     C                   LEAVE                                                                CAS006
                                                                                              CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      PzDay = PBaseDate                                          CAS006
     C                   EVAL      WCountDPTS = WCountDPTS + 1                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Endif of IF CAS006 = 'Y'                                                             CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Endif of IF InsertMode = 'Y' or AmendMode = True
 
     C                   ENDIF
 
      ** Check if error occured
 
     C                   IF        Idx <> 0
     C                   EVAL      DspScn3 = 'Y'
     C                   ELSE
 
     C                   IF        WIdx <> 0                                                  CAS006
     C                   EVAL      WIdx = 1                                                   CAS006
                                                                                              CAS006
     C                   DOW       WMsgIdArr(WIdx) <> *BLANKS or                              CAS006
     C                             WMsgIdArrP(WIdx) <> *BLANKS                                CAS006
     C                             OR WBlankNDTA = 'Y'                                        CAS006
     C                   IF        WMsgIdArr(WIdx) <> WMsgIdArrP(WIdx)                        CAS006
     C                             OR WFlgNDTA = 'Y'                                          CAS006
     C                             OR WBlankNDTA = 'Y'                                        CAS006
     C                   EVAL      WBlankNDTA = 'N'                                           CAS006
     C                   EVAL      DspScn3 = 'Y'                                              CAS006
     C                   LEAVE                                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WIdx = WIdx + 1                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   CLEAR                   WMsgIdArrP                                   CAS006
     C                   EVAL      WIdx = 0                                                   CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        Idx = 0 and DspScn3 = 'N'                                  CAS006
     C                   SELECT
     C                   WHEN      #2DVDL = 'Y' and #2FTPO <> 'Y'
     C                   EVAL      DerivDeal    = True
     C                   EVAL      DrvFutPosGen = False
     C                   WHEN      #2DVDL <> 'Y' and #2FTPO = 'Y'
     C                   EVAL      DerivDeal    = False
     C                   EVAL      DrvFutPosGen = True
     C                   ENDSL
     C                   EVAL      W#2DVDL = #2DVDL
     C                   EVAL      W#2FTPO = #2FTPO
 
     C                   SELECT
     C                   WHEN      #2HGDL = 'Y' and #2SECR <> 'Y'
     C                   EVAL      HdgDlLnFTrn  = True
     C                   EVAL      HdgSecRef    = False
     C                   WHEN      #2HGDL <> 'Y' and #2SECR = 'Y'
     C                   EVAL      HdgDlLnFTrn  = False
     C                   EVAL      HdgSecRef    = True
     C                   ENDSL
     C                   EVAL      W#2HGDL = #2HGDL
     C                   EVAL      W#2SECR = #2SECR
 
     C                   IF        Scn4Arr(1) <> *BLANKS and
     C                             #2DVDL = P#2DVDL and #2FTPO = P#2FTPO
     C                   EXSR      SRClrMsg
     C                   EXSR      SRScn4
     C                   ELSE
     C                   EVAL      FirstPass2 = 'Y'
     C                   EVAL      W1stDervRec = 'Y'                                          CAS005
     C                   EXSR      SRClrMsg
     C                   EXSR      SRBldSfl2
     C                   EVAL      P#2DVDL = #2DVDL
     C                   EVAL      P#2FTPO = #2FTPO
     C                   EXSR      SRScn4
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndValS3      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn4 - Validate screen 4                                 *
      *                                                               *
      * Called by:  SRScn4                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValScn4     BEGSR
 
     C                   EVAL      WScrn = '4'
 
 
     C                   IF        InsertMode = 'Y' or AmendMode = True
 
      ** Initialise FutMode variable if insert
 
     C                   IF        InsertMode = 'Y'
     C                   EVAL      FutMode = *BLANKS
     C                   EVAL      WOneDerv = 'N'                                             CAS006
     C                   ENDIF
 
      ** Read subfile
 
     C                   READC     AS000001S2                             26
 
     C                   IF        EndOfFile = True and AmendMode = True
     C                   EVAL      FirstPass3 = 'Y'
     C                   EVAL      W1stItemRec = 'Y'                                          CAS005
     C                   EXSR      SRBldSfl3
     C                   EVAL      DspScn5 = 'Y'
     C                   EXSR      SRScn5
     C                   GOTO      EndValS4
     C                   ENDIF
 
     C                   EVAL      Ctr1 = 0
     C                   EVAL      Idx = 0
     C                   CLEAR                   Scn4Arr
 
     C                   DOW       EndOfFile = False
 
     C                   EVAL      AllValid = 'Y'
     C                   MOVEA     '00000000'    *IN(44)
 
     C                   IF        Scn4PDS <> Scn4DS
                                                                                              CAS006
      ** When the linkage is using Regression Analysis as the method of                       CAS006
      ** assessment, only one hedge derivative and hedge item will be                         CAS006
      ** allowed for now.                                                                     CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND                                           CAS006
     C                             HSMEFF = 'R'                                               CAS006
     C                   EVAL      WSomRecExst = 'N'                                          CAS006
     C                   EVAL      WRecExist = 'N'                                            CAS006
                                                                                              CAS006
     C                   MOVEL     #2HEDG        KFSHEDI                                      CAS006
     C                   EVAL      KFSDHIN = 'D'                                              CAS006
     C     KAshTrn1      CHAIN     ASHTRND1                                                   CAS006
     C                   IF        %FOUND(ASHTRNL0)                                           CAS006
     C                   EVAL      WSomRecExst = 'Y'                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSomRecExst = 'Y'                                          CAS006
     C                   MOVEL     #2HEDG        KFSHEDI                                      CAS006
     C                   EVAL      KFSDHIN = 'D'                                              CAS006
     C                   MOVEL     #2DDNO        KFSDLNO                                      CAS006
     C                   EVAL      KFSHTID = *BLANKS                                          CAS006
     C     KAshTrn2      CHAIN     ASHTRNDC                                                   CAS006
     C                   IF        %FOUND(ASHTRNLC)                                           CAS006
                                                                                              CAS006
     C                   MOVEL     #2HEDG        WrkHEDG                                      CAS006
     C                   DOU       TCHEDI <> WrkHEDG OR                                       CAS006
     C                             %EOF(ASHTRNLC)                                             CAS006
     C                   IF        TCHTID = 'D'                                               CAS006
     C                   EVAL      WRecExist = 'Y'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   READ      ASHTRNDC                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSomRecExst = 'Y' AND                                      CAS006
     C                             WRecExist = 'N'                                            CAS006
     C                             OR WOneDerv = 'Y'                                          CAS006
     C                   EVAL      ErrSflAct    = TRUE                                        CAS006
     C                   EVAL      ErrSflMidMdl = TRUE                                        CAS006
     C                   EVAL      ErrSflDTLNum = TRUE                                        CAS006
     C                   EVAL      ErrSflFRSRef = TRUE                                        CAS006
     C                   EVAL      ErrSflBkCode = TRUE                                        CAS006
     C                   EVAL      ErrSflBrhCde = TRUE                                        CAS006
     C                   EVAL      ErrSflPCTVDB = TRUE                                        CAS006
     C                   EVAL      ErrSflPct    = TRUE                                        CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
                                                                                              CAS006
      ** Only one transaction is allowed for Regression Analysis.                             CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0156'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
 
      ** Validate Action Code
 
     C                   IF        AmendMode = True
     C                   EXSR      SRValAct
     C                   ENDIF
 
     C                   IF        #2LDEL <> '*'                                              228541
     C                   IF        ErrSflAct = False and #2ACT <> 'D'
 
      ** Validate Midas Module
 
     C                   EXSR      SRValMMod
 
      ** Validate Hedge Derivative Deal/Trade Number
 
     C                   IF        DerivDeal = True
     C                   EXSR      SRValDlNum
     C                   ENDIF
 
     C                   IF        DrvFutPosGen = True
      ** Validate Derivative Futures fields
 
     C                   EXSR      SRValFutFld
 
      ** Validate Derivative Book Code
 
     C                   EXSR      SRValBkCode
 
      ** Validate Derivative Branch Code
 
     C                   EXSR      SRValBchCde
 
      ** Validate Put/Call
 
     C                   EXSR      SRValPutCall
 
      ** Validate position exists in POSTNKD
 
     C                   IF        ErrSflFRSRef = False and
     C                             ErrSflBkCode = False and
     C                             ErrSflBrhCde = False and
     C                             ErrSflPCTVDB = False and
     C                             #2DDNO = *BLANKS
 
     C                   EXSR      SRValPos
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Derivative Percentage
 
     C                   EXSR      SRValPct4
 
     C                   ENDIF
 
      ** If inserting a new transaction check if it already exist in file
 
     C                   IF        Scn4PDS = *BLANKS
     C                   EXSR      SRChkTrn
                                                                                              227747
      ** Allow the user to delete the only remaining transaction for the                      227747
      ** linkage if the user is trying to insert a new valid transaction                      227747
                                                                                              227747
     C                   IF        WIdx3 <> 0                                                 227747
     C                   IF        AllValid = 'Y'                                             227747
     C                   IF        MsgIdArr(WIdx3) = 'ASM0123'                                227747
     C                   EVAL      Idx = Idx - 1                                              227747
     C                   ENDIF                                                                227747
     C                   EVAL      WSkSRRN3 = WkSRRN2                                         227747
                                                                                              227747
      ** Place cursor to the previous changed record of the subfile to                        227747
      ** mark it as a deleted transaction                                                     227747
                                                                                              227747
     C     WSkSRRN2      CHAIN     AS000001S2                                                 227747
     C                   EVAL      ErrSflAct = False                                          227747
     C                   EVAL      ProtectDACT = True                                         227747
     C                   EVAL      ProtectDMOD = True                                         227747
     C                   EVAL      ProtectPRCT = True                                         227747
     C                   EVAL      MsgIdArr(WIdx3) = *BLANKS                                  227747
     C                   EVAL      Ctr1 = WCtr1                                               227747
     C                   MOVEA     WScn4DS       Scn4Arr(Ctr1)                                227747
     C                   UPDATE    AS000001S2                                                 227747
                                                                                              227747
      ** Chain back to the current position of the cursor after update                        227747
                                                                                              227747
     C     WSkSRRN3      CHAIN     AS000001S2                                                 227747
                                                                                              227747
     C                   ENDIF                                                                227747
     C                   ENDIF                                                                227747
                                                                                              227747
     C                   ENDIF
 
      ** If all fields valid move to array
 
     C                   IF        AllValid = 'Y' or
     C                             Idx = 0
                                                                                              CAS006
     C                   IF        InsertMode = 'Y'                                           CAS006
     C                   EVAL      WOneDerv = 'Y'                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        #2ACT = 'D' and NoOfTrn1 > 1 or #2ACT <> 'D'
     C                   IF        #2ACT = 'D'
     C                   EVAL      NoOfTrn1 = NoOfTrn1 - 1
     C                   ENDIF
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   MOVEA     Scn4DS        Scn4Arr(Ctr1)
     C                   EVAL      W#2SavMod = #2DMOD
     C                   IF        DrvFutPosGen = True and FutMode = *BLANKS and
     C                             InsertMode = 'Y'
     C                   IF        #2DDNO <> *BLANKS and #2DFPO = *BLANKS
     C                   EVAL      FutMode = 'DDNO'
     C                   ELSE
     C                   EVAL      FutMode = 'DFPO'
     C                   ENDIF
     C                   ENDIF
     C                   ELSE
     C                   EVAL      ErrSflAct = True
     C                   EVAL      Idx = Idx + 1
      ** At least one transaction should remain for this linkage.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0123'
                                                                                              227747
      ** Save subfile pointer and array index                                                 227747
                                                                                              227747
     C                   EVAL      WSkSRRN2 = WkSRRN2                                         227747
     C                   EVAL      WIdx3 = Idx                                                227747
     C                   EVAL      WCtr1 = Ctr1 + 1                                           227747
     C                   EVAL      WScn4DS = Scn4DS                                           227747
                                                                                              227747
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                228541
 
     C                   ENDIF
 
      ** Update record in subfile
 
     C                   EVAL      SFleNxtChg = True
                                                                                              CAS006
     C                   IF        AllValid = 'Y' OR                                          CAS006
     C                             Idx = 0                                                    CAS006
                                                                                              CAS006
     C                   IF        #2DMOD <> *BLANKS                                          212430
     C                             AND ErrSflMidMdl = False                                   212430
     C                   IF        #2DDNO <> *BLANKS                                          212430
     C                             AND ErrSflDTLNum = False                                   212430
     C                             OR #2DFPO <> *BLANKS                                       212430
     C                             AND ErrSflFRSRef = False                                   212430
     C                             OR #2DDEL = '*'                                            212430
     C                             OR #2LDEL = '*'                                            212430
     C                   EVAL      ProtectDACT = True                                         212430
     C                   EVAL      ProtectDMOD = True                                         212430
     C                   EVAL      ProtectPRCT = True                                         212430
     C                   ENDIF                                                                212430
     C                   ENDIF                                                                212430
                                                                                              212430
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   UPDATE    AS000001S2
     C                   EVAL      SFleNxtChg = False
     C                   EVAL      ProtectDACT = False                                        212430
     C                   EVAL      ProtectDMOD = False                                        212430
     C                   EVAL      ProtectPRCT = False                                        212430
 
      ** Read subfile
 
     C                   EVAL      WkSRRN2 = WkSRRN2 + 1
     C                   READC     AS000001S2                             26
 
     C                   ENDDO
 
      ** If insert and no record was entered. This is an error
 
     C                   IF        Scn4Arr(1) = *BLANKS and Idx = 0 and
     C                             InsertMode = 'Y'
     C                   EVAL      Idx = Idx + 1
      ** At least one Derivative data record must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0116'
     C                   ENDIF
 
     C                   EVAL      WkSRRN2 = 1
     C                   EVAL      #2SFRN  = 1
 
     C                   EVAL      WRedisplay = 'N'
     C                   SELECT
     C                   WHEN      Idx <> 0
     C                   EVAL      WRedisplay = 'Y'
 
     C                   WHEN      WIdx <> 0
     C                   EVAL      WIdx = 1
 
     C                   DOW       WMsgIdArr(WIdx) <> *BLANKS or
     C                             WMsgIdArrP(WIdx) <> *BLANKS
     C                   IF        WMsgIdArr(WIdx) <> WMsgIdArrP(WIdx)
     C                   EVAL      WRedisplay = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   EVAL      WIdx = WIdx + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   CLEAR                   WMsgIdArrP
     C                   EVAL      WIdx = 0
     C                   ENDSL
 
 
     C                   ENDIF
 
     C                   IF        Idx = 0 and WRedisplay = 'N'
     C                   IF        Scn5Arr(1) <> *BLANKS and
     C                             #2HGDL = P#2HGDL and #2SECR = P#2SECR
     C                   EXSR      SRClrMsg
     C                   EVAL      NoOfTrn2 = PNoOfTrn2
     C                   EVAL      KDHIN2 = 'H'
     C                   EXSR      SRScn5
     C                   ELSE
     C                   EVAL      FirstPass3 = 'Y'
     C                   EVAL      W1stItemRec = 'Y'                                          CAS005
     C                   EXSR      SRClrMsg
     C                   EXSR      SRBldSfl3
     C                   EVAL      DspScn5 = 'Y'
     C                   EVAL      P#2HGDL = #2HGDL
     C                   EVAL      P#2SECR = #2SECR
     C                   EXSR      SRScn5
     C                   ENDIF
     C                   ELSE
     C                   EVAL      NoOfTrn1 = PNoOfTrn1
     C                   EVAL      DspScn4 = 'Y'
     C                   ENDIF
 
     C     EndValS4      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValScn5 - Validate screen 5                                 *
      *                                                               *
      * Called by:  SRScn5                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValScn5     BEGSR
 
     C                   EVAL      WScrn = '5'
 
     C                   IF        InsertMode = 'Y' or AmendMode = True
     C                                                                                        CAS006
     C                   EVAL      WOneItem = 'N'                                             CAS006
 
      ** Read subfile
 
     C                   READC     AS000001S3                             26
 
     C                   SELECT
     C                   WHEN      EndOfFile = True and EnquireMode = True
     C                   EVAL      WScrn = '1'
     C                   GOTO      EndValS5
     C                   WHEN      EndOfFile = True and AmendMode = True
     C                   IF        BGWDPR = 'Y'
     C                   EXSR      SRWindow
     C                   ELSE
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   GOTO      EndValS5
     C                   ENDSL
 
     C                   EVAL      Ctr1 = 0
     C                   EVAL      Idx = 0
     C                   CLEAR                   Scn5Arr
 
     C                   DOW       EndOfFile = False
 
     C                   EVAL      AllValid = 'Y'
     C                   MOVEA     '000000000'   *IN(44)
 
     C                   IF        Scn5PDS <> Scn5DS
 
                                                                                              CAS006
      ** When the linkage is using Regression Analysis as the method of                       CAS006
      ** assessment, only one hedge derivative and hedge item will be                         CAS006
      ** allowed for now.                                                                     CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND                                           CAS006
     C                             HSMEFF = 'R'                                               CAS006
     C                   EVAL      WSomRecExst = 'N'                                          CAS006
     C                   EVAL      WRecExist = 'N'                                            CAS006
                                                                                              CAS006
     C                   MOVEL     #2HEDG        KFSHEDI                                      CAS006
     C                   EVAL      KFSDHIN = 'H'                                              CAS006
     C     KAshTrn1      CHAIN     ASHTRND1                                                   CAS006
     C                   IF        %FOUND(ASHTRNL0)                                           CAS006
     C                   EVAL      WSomRecExst = 'Y'                                          CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSomRecExst = 'Y'                                          CAS006
     C                   MOVEL     #2HEDG        KFSHEDI                                      CAS006
     C**********         EVAL      KFSDHIN = 'D'                                       CAS006 224942
     C                   EVAL      KFSDHIN = 'H'                                              224942
     C                   IF        #3HMOD = 'DL' OR #3HMOD = 'LE'                             CAS006
     C                   MOVEL     #3HDNO        KFSDLNO                                      CAS006
     C                   EVAL      KFSHTID = *BLANKS                                          CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     *BLANKS       KFSDLNO                                      CAS006
     C                   EVAL      KFSHTID = #3HSEC                                           CAS006
     C                   ENDIF                                                                CAS006
     C     KAshTrn2      CHAIN     ASHTRNDC                                                   CAS006
     C                   IF        %FOUND(ASHTRNLC)                                           CAS006
                                                                                              CAS006
     C                   MOVEL     #2HEDG        WrkHEDG                                      CAS006
     C                   DOU       TCHEDI <> WrkHEDG OR                                       CAS006
     C                             %EOF(ASHTRNLC)                                             CAS006
     C                   IF        TCHTID = 'D'                                               CAS006
     C                   EVAL      WRecExist = 'Y'                                            CAS006
     C                   ENDIF                                                                CAS006
     C                   READ      ASHTRNDC                                                   CAS006
     C                   ENDDO                                                                CAS006
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        WSomRecExst = 'Y' AND                                      CAS006
     C                             WRecExist = 'N'                                            CAS006
     C                             OR WOneItem = 'Y'                                          CAS006
     C                   EVAL      ErrSflAct    = TRUE                                        CAS006
     C                   EVAL      ErrSflMidMdl = TRUE                                        CAS006
     C                   EVAL      ErrSflDTLNum = TRUE                                        CAS006
     C                   EVAL      ErrSflFRSRef = TRUE                                        CAS006
     C                   EVAL      ErrSflBkCode = TRUE                                        CAS006
     C                   EVAL      ErrSflBrhCde = TRUE                                        CAS006
     C                   EVAL      ErrSflPCTVDB = TRUE                                        CAS006
     C                   EVAL      ErrSflPct    = TRUE                                        CAS006
     C                   EVAL      ErrSflMktInd = TRUE                                        CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
                                                                                              CAS006
      ** Only one transaction is allowed for Regression Analysis.                             CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0156'                                  CAS006
     C                   ENDIF                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Validate Action Code
 
     C                   IF        AmendMode = True
     C                   EXSR      SRValAct
     C                   ENDIF
 
     C                   IF        #3LDEL <> '*'                                              228541
     C                   IF        ErrSflAct = False and #3HACT <> 'D'
 
      ** Validate Midas Module
 
     C                   EXSR      SRValMMod
 
      ** Validate Hedge Deal/Loan
 
     C                   IF        HdgDlLnFTrn = True
     C                   EXSR      SRValHDlNum
     C                   ENDIF
 
     C                   IF        HdgSecRef    = True
 
      ** Validate Hedge Security
 
     C                   EXSR      SRValSecRef
 
      ** Validate Hedged Book Code
 
     C                   EXSR      SRValBkCode
 
      ** Validate Hedged Branch Code
 
     C                   EXSR      SRValBchCde
 
      ** Validate Hedged Market Indicator
 
     C                   EXSR      SRValMktInd
 
      ** Validate Hedged Trade/Value Date Basis
 
     C                   EXSR      SRValBHTV
 
      ** Validate against Midas SE Book Positions Header
 
     C                   IF        ErrSflFRSRef = False and
     C                             ErrSflBkCode = False and
     C                             ErrSflBrhCde = False and
     C                             ErrSflMktInd = False and
     C                             ErrSflPCTVDB = False
 
     C                   EXSR      SRValBkPos
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Validate Derivative Percentage
 
     C                   EXSR      SRValPct5
 
     C                   ENDIF
 
      ** If inserting a new transaction check if it already exist in file
 
     C                   IF        Scn5PDS = *BLANKS
     C                   EXSR      SRChkTrn
                                                                                              227747
      ** Allow the user to delete the only remaining transaction for the                      227747
      ** linkage if the user is trying to insert a new valid transaction                      227747
                                                                                              227747
     C                   IF        WIdx3 <> 0                                                 227747
     C                   IF        AllValid = 'Y'                                             227747
     C                   IF        MsgIdArr(WIdx3) = 'ASM0123'                                227747
     C                   EVAL      Idx = Idx - 1                                              227747
     C                   ENDIF                                                                227747
     C                   EVAL      WSkSRRN5 = WkSRRN3                                         227747
                                                                                              227747
      ** Place cursor to the previous changed record of the subfile to                        227747
      ** mark it as a deleted transaction                                                     227747
                                                                                              227747
     C     WSkSRRN4      CHAIN     AS000001S3                                                 227747
     C                   EVAL      ErrSflAct = False                                          227747
     C                   EVAL      MsgIdArr(WIdx3) = *BLANKS                                  227747
     C                   EVAL      Ctr1 = WCtr1                                               227747
     C                   MOVEA     WScn5DS       Scn5Arr(Ctr1)                                227747
     C                   UPDATE    AS000001S3                                                 227747
                                                                                              227747
      ** Chain back to the current position of the cursor after update                        227747
                                                                                              227747
     C     WSkSRRN5      CHAIN     AS000001S3                                                 227747
                                                                                              227747
     C                   ENDIF                                                                227747
     C                   ENDIF                                                                227747
                                                                                              227747
     C                   ENDIF
 
      ** If all fields valid move to array
 
     C                   IF        AllValid = 'Y' or
     C                             Idx = 0
                                                                                              CAS006
     C                   IF        InsertMode = 'Y'                                           CAS006
     C                   EVAL      WOneItem = 'Y'                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        #3HACT = 'D' and NoOfTrn2 > 1 or
     C                             #3HACT <> 'D'
     C                   IF        #3HACT = 'D'
     C                   EVAL      NoOfTrn2 = NoOfTrn2 - 1
     C                   ENDIF
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   MOVEA     Scn5DS        Scn5Arr(Ctr1)
     C                   EVAL      W#3SavMod = #3HMOD
     C                   ELSE
     C                   EVAL      ErrSflAct = True
     C                   EVAL      Idx = Idx + 1
      ** At least one transaction should remain for this linkage.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0123'
                                                                                              227747
      ** Save subfile pointer and array index                                                 227747
                                                                                              227747
     C                   EVAL      WSkSRRN4 = WkSRRN3                                         227747
     C                   EVAL      WIdx3 = Idx                                                227747
     C                   EVAL      WCtr1 = Ctr1 + 1                                           227747
     C                   EVAL      WScn5DS = Scn5DS                                           227747
                                                                                              227747
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF                                                                228541
 
     C                   ENDIF
 
      ** Update record in subfile
 
     C                   EVAL      SFleNxtChg = True
                                                                                              CAS006
     C                   IF        AllValid = 'Y' or                                          CAS006
     C                             Idx = 0                                                    CAS006
                                                                                              CAS006
     C                   IF        #3HMOD <> *BLANKS                                          212430
     C                             AND ErrSflMidMdl = False                                   212430
     C                   IF        #3HDNO <> *BLANKS                                          212430
     C                             AND ErrSflDTLNum = False                                   212430
     C                             OR #3HSEC <> *BLANKS                                       212430
     C                             AND ErrSflFRSRef = False                                   212430
     C                             OR #3HDEL = '*'                                            212430
     C                             OR #3LDEL = '*'                                            212430
     C                   EVAL      ProtectDACT = True                                         212430
     C                   EVAL      ProtectDMOD = True                                         212430
     C                   EVAL      ProtectPRCT = True                                         212430
     C                   ENDIF                                                                212430
     C                   ENDIF                                                                212430
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              212430
     C                   UPDATE    AS000001S3
     C                   EVAL      SFleNxtChg = False
     C                   EVAL      ProtectDACT = False                                        212430
     C                   EVAL      ProtectDMOD = False                                        212430
     C                   EVAL      ProtectPRCT = False                                        212430
 
      ** Read subfile
 
     C                   EVAL      WkSRRN3 = WkSRRN3 + 1
     C                   READC     AS000001S3                             26
 
     C                   ENDDO
 
      ** If insert and no record was entered. This is an error
 
     C                   IF        Scn5Arr(1) = *BLANKS and Idx = 0 and
     C                             InsertMode = 'Y'
     C                   EVAL      Idx = Idx + 1
      ** At least one Hedged data record must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0117'
     C                   ENDIF
 
     C                   EVAL      WkSRRN3 = 1
     C                   EVAL      #3SFRN = 1
 
     C                   EVAL      WRedisplay = 'N'
     C                   SELECT
     C                   WHEN      Idx <> 0
     C                   EVAL      WRedisplay = 'Y'
 
     C                   WHEN      WIdx <> 0
     C                   EVAL      WIdx = 1
 
     C                   DOW       WMsgIdArr(WIdx) <> *BLANKS or
     C                             WMsgIdArrP(WIdx) <> *BLANKS
     C                   IF        WMsgIdArr(WIdx) <> WMsgIdArrP(WIdx)
     C                   EVAL      WRedisplay = 'Y'
     C                   LEAVE
     C                   ELSE
     C                   EVAL      WIdx = WIdx + 1
     C                   ENDIF
     C                   ENDDO
 
     C                   CLEAR                   WMsgIdArrP
     C                   EVAL      WIdx = 0
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        Idx = 0 and WRedisplay = 'N' and
     C                             EnquireMode = False and DeleteMode = False
     C                   EXSR      SRClrMsg
     C                   IF        BGWDPR = 'Y'
     C                   EXSR      SRWindow
     C                   ELSE
     C                   EXSR      SRUpdate
     C                   ENDIF
     C                   ELSE
     C                   EVAL      NoOfTrn2 = PNoOfTrn2
     C                   EVAL      DspScn5 = 'Y'
     C                   ENDIF
 
     C     EndValS5      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValAct  - Validate subfile action code                      *
      *                                                               *
      * Called by:  SRValScn4                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValAct      BEGSR
 
     C                   SELECT
 
     C                   WHEN      WScrn = '4'
     C                   IF        #2ACT <> *BLANKS and #2ACT <> 'D'
     C                   EVAL      ErrSflAct = True
     C                   EVAL      Idx = Idx + 1
      ** Invalid Action Code: must be "D" or blank
     C                   EVAL      MsgIdArr(Idx) = 'ASM0058'
     C                   ENDIF
 
     C                   WHEN      WScrn = '5'
     C                   IF        #3HACT <> *BLANKS and #3HACT <> 'D'
     C                   EVAL      ErrSflAct = True
     C                   EVAL      Idx = Idx + 1
      ** Invalid Action Code: must be "D" or blank
     C                   EVAL      MsgIdArr(Idx) = 'ASM0058'
     C                   ENDIF
     C                   ENDSL
 
     C                   IF        ErrSflAct = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValMMod - Validate subfile midas module                     *
      *                                                               *
      * Called by:  SRValScn4                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValMMod     BEGSR
 
     C                   SELECT
 
      ** For Derivative Deals, field must be "DL"
 
     C                   WHEN      DerivDeal = True and #2DMOD <> 'DL' and
     C                             WScrn = '4'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Midas Module must be "DL"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0059'
 
      ** For Derivative Futures Position, field must be "FF"
 
     C                   WHEN      DrvFutPosGen = True and #2DMOD <> 'FF' and
     C                             WScrn = '4'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Midas Module must be "FF"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0060'
 
      ** Check for Module mismatch:
      ** Transactions must be of the same type (module)
 
     C                   WHEN      W#2SavMod <> #2DMOD and W#2SavMod <> *BLANKS
     C                             and WScrn = '4'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Only transactions pertaining to Module "&1" are allowed
     C                   EVAL      MsgIdArr(Idx) = 'ASM0061'
     C                   EVAL      MsgDtaArr(Idx) = W#2SavMod
 
      ** For Hedged Deals/Loans, field must be "DL"(Deal) or "LE"(Loan)                       CAS006
                                                                                              CAS006
     C                   WHEN      HdgDlLnFTrn = True and #3HMOD <> 'DL' and                  CAS006
     C                             #3HMOD <> 'LE' and CAS006 = 'Y' and                        CAS006
     C                             HSMEFF = 'R' and WScrn = '5'                               CAS006
     C                   EVAL      ErrSflMidMdl = True                                        CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
                                                                                              CAS006
      ** Midas Module must be "DL" or "LE".                                                   CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0155'                                  CAS006
                                                                                              CAS006
      ** For Hedged Deals/Loans, field must be "DL"(Deal) or "LE"(Loan)
      ** or "FH"(Forecast Transaction)
 
     C                   WHEN      HdgDlLnFTrn = True and #3HMOD <> 'DL' and
     C                             #3HMOD <> 'LE' and #3HMOD <> 'FH' and
     C                             WScrn = '5'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Midas Module must be "DL", "LE" or "FH"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0062'
 
      ** For Hedged Security, field must be "SE"
 
     C                   WHEN      HdgSecRef = True and #3HMOD <> 'SE' and
     C                             WScrn = '5'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Midas Module must be "SE"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0063'
 
      ** Check for Module mismatch:
      ** Transactions must be of the same type (module)
 
     C                   WHEN      W#3SavMod <> #3HMOD and W#3SavMod <> *BLANKS
     C                             and WScrn = '5'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      Idx = Idx + 1
      ** Only transactions pertaining to Module "&1" are allowed
     C                   EVAL      MsgIdArr(Idx) = 'ASM0061'
     C                   EVAL      MsgDtaArr(Idx) = W#3SavMod
 
     C                   ENDSL
 
     C                   IF        ErrSflMidMdl = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDlNum - Validate Hedge Derivative Deal/Trade Number      *
      *              for screen 4                                     *
      *                                                               *
      * Called by:  SRValScn4                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValDlNum    BEGSR
 
      ** Cannot be blank , zero, or non-numeric
 
     C                   TESTN                   #2DDNO               88
     C                   MOVE      #2DDNO        WkTest
     C                   TESTZ                   WkTest                   89
     C                   IF        WrkInd1 <> True or WrkInd2 <> True  or
     C                             #2DDNO = *BLANKS or #2DDNO = *ALL'0'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Deal Number is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0064'
 
     C                   ELSE
 
      ** Check against Deal File
 
     C                   MOVE      #2DDNO        WkDNum
 
     C     WkDnum        CHAIN     DEALSDGF                           27                      CAS004
     C                   IF        RecNotFnd = True                                           CAS004
     C                   EVAL      WkValDerv = 'Y'                                            CAS004
     C                   EXSR      SRValDerv                                                  CAS004
                                                                                              CAS004
     C                   IF        WkValDerv = 'N'                                            CAS004
     C                   EVAL      ErrSflDTLNum = True                                        CAS004
     C                   EVAL      Idx = Idx + 1                                              CAS004
     C                   EVAL      MsgIdArr(Idx) = 'ASM0064'                                  CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     WkDNum        CHAIN     DEALSDBF                           27
     C                   IF        RecNotFnd = True
     C     WkDNum        CHAIN     DEALSDGF                           27
     C                   ENDIF
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Deal Number is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0064'
     C                   ENDIF
 
      ** Check if Hedge Strategy Branch is the same as Derivative                             226221
                                                                                              226221
     C                   IF        BRCA <> HSBRCA                                             226221
     C                   EVAL      ErrSflDTLNum = True                                        226221
     C                   EVAL      Idx = Idx + 1                                              226221
     C                   EVAL      MsgIdArr(Idx) = 'ASM0164'                                  226221
     C                   ENDIF                                                                226221
                                                                                              226221
      ** If derivative Deal Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Hedged Deal Type/Subtype/Book Code
 
     C                   EVAL      W4TYPE = DTYP
     C                   EVAL      W4STYP = DLST
     C                   EVAL      W4BOKC = BOKC
 
      ** Validate Derivative Deal Type
 
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    DVTypAr2b                              88
     C                   IF        WrkInd1 = False
     C     W4TYPE        LOOKUP    DVTypAr2b                              88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Deal Type is not part of the Strategy's valid types
     C                   EVAL      MsgIdArr(Idx) = 'ASM0065'
     C                   ENDIF
     C                   ENDIF
 
      ** If not a "Wild card" -validate Derivative Deal Subtype
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    DVSTypAr                               88
     C                   IF        WrkInd1 = False
     C     W4STYP        LOOKUP    DVSTypAr                               88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Deal Subtype is not part of the Strategy's valid subtypes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0066'
     C                   ENDIF
     C                   ENDIF
 
      ** If not a "Wild card" -validate Derivative Deal Book Code
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    DVBkCdAr                               88
     C                   IF        WrkInd1 = False
     C     W4BOKC        LOOKUP    DVBkCdAr                               88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Deal Book Code is not part of the Strategy's valid book code
     C                   EVAL      MsgIdArr(Idx) = 'ASM0067'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
                                                                                              CAS005
     C                   IF        ErrSflDTLNum = False                                       CAS005
                                                                                              CAS005
      ** Validate Derivative Deal according to their CCYs.                                    CAS005
                                                                                              CAS005
     C                   IF        InsertMode = 'Y' AND                                       CAS005
     C                             W1stDervRec = 'Y'                                          CAS005
     C                   EVAL      W1stDervRec = 'N'                                          CAS005
     C                   EVAL      WkDervDTYP = DTYP                                          CAS005
                                                                                              CAS005
      ** If DTYP is 'RX', save the CCYs of the first subfile record.                          CAS005
     C                   IF        WkDervDTYP  = 'RX'                                         CAS005
     C                   EVAL      WkDervUCCY  = UCUCY                                        CAS005
     C                   EVAL      WkDervTCCY  = TCUCY                                        CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   IF        W1stDervRec = 'N' AND                                      CAS005
     C                             WkDervDTYP  = 'RX'                                         CAS005
                                                                                              CAS005
     C                   IF        WkDervDTYP <> DTYP  OR                                     CAS005
     C                             WkDervUCCY <> UCUCY OR                                     CAS005
     C                             WkDervTCCY <> TCUCY                                        CAS005
     C                   EVAL      ErrSflDTLNum = True                                        CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      MsgIdArr(Idx) = 'ASM0147'                                  CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
     C                   IF        ErrSflDTLNum = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                                  CAS004
      *****************************************************************                       CAS004
      *                                                               *                       CAS004
      * SRValDerv - Validate Hedge Derivative CX for Screen 4         *                       CAS004
      *                                                               *                       CAS004
      * Called by:  SRValDlNum                                        *                       CAS004
      *                                                               *                       CAS004
      * Calls: None                                                   *                       CAS004
      *                                                               *                       CAS004
      *****************************************************************                       CAS004
     C     SRValDerv     BEGSR                                                                CAS004
                                                                                              CAS004
     C     WkDNum        CHAIN     DEALSDBF                           27                      CAS004
                                                                                              CAS004
     C                   IF        RecNotFnd = True OR RECI <> 'D'                            CAS004
     C                   EVAL      WkValDerv = 'N'                                            CAS004
     C                   GOTO      ESRValDerv                                                 CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS006
      ** If Hedge Accounting Phase B is installed, 'CX' type derivatives with                 CAS006
      ** no linked reference number is allowed, as long as this is hedging an                 CAS006
      ** item that is a Forecast transaction with GL-module                                   CAS006
                                                                                              CAS006
     C                   IF        CAS006 = 'Y' AND LNKDN = 0                                 CAS006
     C                   GOTO      ESRValDerv                                                 CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS004
     C     LNKDN         CHAIN     DEALSDBF                           27                      CAS004
                                                                                              CAS004
     C                   IF        RecNotFnd = True OR RECI <> 'D'                            CAS004
     C                   EVAL      WkValDerv = 'N'                                            CAS004
     C                   GOTO      ESRValDerv                                                 CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     LNKDN         CHAIN     DLDLDCL1                           27                      CAS004
                                                                                              CAS004
     C                   IF        RecNotFnd = True OR DCRECI <> 'D'                          CAS004
     C                   EVAL      WkValDerv = 'N'                                            CAS004
     C                   GOTO      ESRValDerv                                                 CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C     ESRValDerv    ENDSR                                                                CAS004
      *****************************************************************                       CAS004
      /EJECT                                                                                  CAS005
      *****************************************************************                       CAS005
      *                                                               *                       CAS005
      * SRGetCCY    - Get the common CCY for hedge derivatives and    *                       CAS005
      *               hedge items for RX deals.                       *                       CAS005
      *                                                               *                       CAS005
      * Called by:  SRValScn5                                         *                       CAS005
      *                                                               *                       CAS005
      * Calls: None                                                   *                       CAS005
      *                                                               *                       CAS005
      *****************************************************************                       CAS005
     C     SRGetCCY      BEGSR                                                                CAS005
                                                                                              CAS005
     C                   SELECT                                                               CAS005
     C                   WHEN      CCY = WkDervUCCY                                           CAS005
     C                   EVAL      WkFSHSID = 'U'                                             CAS005
     C                   EVAL      WkDervCCY  = CCY                                           CAS005
                                                                                              CAS005
     C                   WHEN      CCY = WkDervTCCY                                           CAS005
     C                   EVAL      WkFSHSID = 'T'                                             CAS005
     C                   EVAL      WkDervCCY  = CCY                                           CAS005
                                                                                              CAS005
     C                   OTHER                                                                CAS005
     C                   EVAL      W1stItemRec = 'Y'                                          CAS005
     C                   EVAL      ErrSflDTLNum = True                                        CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      MsgIdArr(Idx) = 'ASM0148'                                  CAS005
                                                                                              CAS005
     C                   ENDSL                                                                CAS005
                                                                                              CAS005
     C     ESRGetCCY     ENDSR                                                                CAS005
      *****************************************************************                       CAS005
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      * SrZFreqC - Calls ZFREQC                                       *                       CAS006
      *                                                               *                       CAS006
      * Called by: SRValScn3                                          *                       CAS006
      *                                                               *                       CAS006
      * Calls: ZFREQC                                                 *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrZFreqC      BEGSR                                                                CAS006
                                                                                              CAS006
     C                   CALL      'ZFREQC'                                                   CAS006
     C                   PARM      *BLANKS       PRetCodeIn                                   CAS006
     C                   PARM                    PNxtColDay                                   CAS006
     C                   PARM                    PIncldTday                                   CAS006
     C                   PARM                    PZFreq                                       CAS006
     C                   PARM                    PZDay                                        CAS006
     C                   PARM                    PZCcy                                        CAS006
     C                   PARM                    PZWday                                       CAS006
     C                   PARM                    PZMday                                       CAS006
     C                   PARM                    PBJDFIN                                      CAS006
     C                   PARM                    PBaseDate                                    CAS006
                                                                                              CAS006
     C                   IF        PRetCodeIn <> *BLANKS                                      CAS006
     C                             AND PRetCodeIn <> '*LIMIT '                                CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE =  'ZFREQC'                                         CAS006
     C                   EVAL      DBKEY  =  '*CALL'                                          CAS006
     C                   EVAL      DBASE  =  011                                              CAS006
     C                   EVAL      DBPROC =  'SR/SrZFreqC'                                    CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      * SrZChkH  - Calls ZCHKH                                        *                       CAS006
      *                                                               *                       CAS006
      * Called by: SRValScn3                                          *                       CAS006
      *                                                               *                       CAS006
      * Calls: ZCHKH                                                  *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SrZChkH       BEGSR                                                                CAS006
                                                                                              CAS006
     C                   CALLB     'ZCHKH'                                                    CAS006
     C                   PARM                    PzDayH                                       CAS006
     C                   PARM                    PzCcyH                                       CAS006
     C                   PARM                    PzLocH                                       CAS006
     C                   PARM                    PzIndH                                       CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValHDlNum - Validate Hedged Deal/Loan Number/Forecast       *
      *               Transaction for screen 5                        *
      *                                                               *
      * Called by:  SRValScn5                                         *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValHDlNum   BEGSR
 
      ** Cannot be blank or zero
 
     C                   EVAL      WRecFoundF = 'Y'                                           226221
     C                   IF        #3HDNO = *BLANKS or #3HDNO = *ALL'0'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
     C                   SELECT
     C                   WHEN      #3HMOD = 'DL'
      ** Hedged Deal must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0068'
     C                   WHEN      #3HMOD = 'LE'
      ** Hedged Loan must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0069'
     C                   WHEN      #3HMOD = 'FH'
     C                             AND HSMEFF <> 'R'                                          CAS006
      ** Forecast Transaction Number must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0070'
     C                   ENDSL
     C                   ENDIF
 
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Must be numeric
 
     C                   TESTN                   #3HDNO               88
     C                   MOVE      #3HDNO        WkTest
     C                   TESTZ                   WkTest                   89
 
     C                   IF        WrkInd1 <> True or WrkInd2 <> True
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
     C                   SELECT
     C                   WHEN      #3HMOD = 'DL'
      ** Hedged Deal is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0071'
     C                   WHEN      #3HMOD = 'LE'
      ** Hedged Loan is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0071'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
     C                   MOVE      #3HDNO        WkDNum
 
     C                   SELECT
 
      ** Check against Deal File
 
     C                   WHEN      #3HMOD = 'DL'
 
     C                   IF        CAS006 = 'N'                                               CAS006
     C                             OR HSMEFF <> 'R'                                           CAS006
                                                                                              CAS006
      ** Check first if deal is an internal contract, if so, must have valid linked           CAS004
      ** reference                                                                            CAS004
                                                                                              CAS004
     C     WkDNum        CHAIN     DEALSDBF                           27                      CAS004
     C                   IF        RecNotFnd = False AND RECI = 'D' AND                       CAS004
     C                             DTYP = 'PS'                                                CAS004
     C     LNKDN         CHAIN     DLDLDCL1                           27                      CAS004
     C                   IF        RecNotFnd = True OR DCRECI <> 'D'                          CAS004
     C                   EVAL      ErrSflDTLNum = True                                        CAS004
     C                   EVAL      Idx = Idx + 1                                              CAS004
     C                   EVAL      MsgIdArr(Idx) = 'ASM0072'                                  CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C     WkDNum        CHAIN     DEALSDBF                           27
     C                   IF        RecNotFnd = True
     C     WkDNum        CHAIN     DEALSDCF                           27
     C                   IF        RecNotFnd = True
     C     WkDNum        CHAIN     DEALSDDF                           27
     C                   IF        RecNotFnd = True
     C     WkDNum        CHAIN     DEALSDEF                           27
     C                   IF        RecNotFnd = True
     C     WkDNum        CHAIN     DEALSDGF                           27
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        RecNotFnd = True or RECI <> 'D' or
     C                             RCDT <> 'B' and RCDT <> 'C' and
     C                             RCDT <> 'D' and RCDT <> 'E'
     C                             OR CAS006 = 'Y' AND HSMEFF = 'R'                           CAS006
     C                             AND RCDT <> 'C' AND RCDT <> 'D'                            CAS006
                                                                                              CAS006
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      WRecFoundF = 'N'                                           226221
     C                   IF        CAS006 = 'Y' AND HSMEFF = 'R'                              CAS006
                                                                                              CAS006
      ** Hedged Deal must be a valid live Money Market/Negotiable Assets                      CAS006
      ** Purchased Deal Number.                                                               CAS006
                                                                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0159'                                  CAS006
     C                   ELSE                                                                 CAS006
                                                                                              CAS006
      ** Hedged Deal must be a valid live FX/MM Deal Number
     C                   EVAL      MsgIdArr(Idx) = 'ASM0072'
                                                                                              CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDIF
 
     C                   IF        CAS006 = 'N'                                               CAS006
     C                             OR HSMEFF <> 'R'                                           CAS006
                                                                                              CAS006
      ** If Hedge Accounting (CAS004) is installed and a 'PS' deal is being                   CAS004
      ** hedged, it must have a valid money market Linked Reference number.                   CAS004
      ** The 'PS' deal in DEALSDB must have a value in field LNKDN and this                   CAS004
      ** value should point to a live MM deal in DEALSDC.                                     CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y' and RCDT = 'B'                                CAS004
     C                             and DTYP = 'PS' AND RECI = 'D'                             CAS004
                                                                                              CAS004
     C                   IF        LNKDN = *ZEROS                                             CAS004
     C                   EVAL      ErrSflDTLNum = True                                        CAS004
     C                   ELSE                                                                 CAS004
     C     LNKDN         CHAIN     DEALSC                             27                      CAS004
     C                   IF        RecNotFnd = True                                           CAS004
     C                   EVAL      ErrSflDTLNum = True                                        CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   IF        ErrSflDTLNum = True                                        CAS004
     C                   EVAL      Idx = Idx + 1                                              CAS004
     C                   EVAL      MsgIdArr(Idx) = 'ASM0125'                                  CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Check if Hedge Strategy Branch is the same as Hedged Deal                            226221
                                                                                              226221
     C                   IF        BRCA <> HSBRCA                                             226221
     C                             AND WRecFoundF = 'Y'                                       226221
     C                   EVAL      ErrSflDTLNum = True                                        226221
     C                   EVAL      Idx = Idx + 1                                              226221
     C                   EVAL      MsgIdArr(Idx) = 'ASM0164'                                  226221
     C                   ENDIF                                                                226221
                                                                                              226221
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Derivative Type/Subtype/Book Code
 
     C                   EVAL      W5TYPE = DTYP
     C                   EVAL      W5DLST = DLST
     C                   EVAL      W5BOKC = BOKC
     C                   ENDIF
 
      ** Check against Loan File
 
     C                   WHEN      #3HMOD = 'LE'
 
     C*****WkDNum        CHAIN     CLOANCLF                           27                      CLE148
     C                   MOVEL     WkDNum        WkDNum2           6                          CLE148
     C     WkDNum2       CHAIN     CLOANCLF                           27                      CLE148
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Loan is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0073'
     C                   EVAL      WRecFoundF = 'N'                                           226221
     C                   ENDIF
 
      ** Check if Hedge Strategy Branch is the same as Hedged Loan                            226221
                                                                                              226221
     C                   IF        BRCA <> HSBRCA                                             226221
     C                             AND WRecFoundF = 'Y'                                       226221
     C                   EVAL      ErrSflDTLNum = True                                        226221
     C                   EVAL      Idx = Idx + 1                                              226221
     C                   EVAL      MsgIdArr(Idx) = 'ASM0164'                                  226221
     C                   ENDIF                                                                226221
                                                                                              226221
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Hedged Loan Type/Subtype/Book Code
 
     C                   EVAL      W5TYPE = LTYP
     C                   EVAL      W5DLST = SUTP
     C                   EVAL      W5BOKC = BOKC
     C                   ENDIF
 
      ** Check Forecast Transaction
 
     C                   WHEN      #3HMOD = 'FH'
 
     C*****WkDNum        CHAIN     ASFHTRL1                           27                      CLE148
     C                   MOVEL     WkDNum        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                           27                      CLE148
     C**********         IF        RecNotFnd = True or FSRECI <> 'D'                          212430
     C                   IF        RecNotFnd = True or FCRECI <> 'D'                          212430
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Forecast Transaction is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0074'
     C                   EVAL      WRecFoundF = 'N'                                           226221
     C                   ENDIF
 
      ** Check if Hedge Strategy Branch is the same as Hedged Forcast                         226221
                                                                                              226221
     C                   IF        FCBRCA <> HSBRCA                                           226221
     C                             AND WRecFoundF = 'Y'                                       226221
     C                   EVAL      ErrSflDTLNum = True                                        226221
     C                   EVAL      Idx = Idx + 1                                              226221
     C                   EVAL      MsgIdArr(Idx) = 'ASM0164'                                  226221
     C                   ENDIF                                                                226221
                                                                                              226221
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Forecast Tran Expenditure/Receipt and check for mismatch
 
     C                   IF        WFSERIN = *BLANKS
     C                   EVAL      WFSERIN = FCERIN
     C                   ELSE
     C                   IF        FCERIN <> WFSERIN
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      **  Forecast Transaction must have Expenditure/Receipt equal to "&1"
     C                   EVAL      MsgIdArr(Idx) = 'ASM0075'
     C                   EVAL      MsgDtaArr(Idx) = FCERIN
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        CAS006 = 'Y' AND                                           CAS006
     C                             ErrSflDTLNum = False                                       CAS006
     C                   SELECT                                                               CAS006
                                                                                              CAS006
      ** Accept only DL and LE Forecast Transactions as hedged items                          CAS006
      ** if the hedge derivative is an FRA.                                                   CAS006
                                                                                              CAS006
     C                   WHEN      FCMOD =  'DL' OR                                           CAS006
     C                             FCMOD =  'LE'                                              CAS006
     C                   IF        WkDervDTYP <> 'FR'                                         CAS006
     C                   EVAL      ErrSflDTLNum = True                                        CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0160'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Valid hedge derivative would be a CX deal for GL Forecast                            CAS006
      ** Transactions.                                                                        CAS006
                                                                                              CAS006
     C                   WHEN      FCMOD = 'GL'                                               CAS006
     C                   IF        WkDervDTYP <> 'CX'                                         CAS006
     C                   EVAL      ErrSflDTLNum = True                                        CAS006
     C                   EVAL      Idx = Idx + 1                                              CAS006
     C                   EVAL      MsgIdArr(Idx) = 'ASM0161'                                  CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   ENDSL                                                                CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** If Number is valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Forecast Transaction "Type" and Subtype
 
     C                   EVAL      W5TYPE = 'FH'
     C                   EVAL      W5DLST = FCSUBT
     C                   ENDIF
 
     C                   ENDSL
 
     C                   IF        ErrSflDTLNum = False
 
      ** Validate Hedged Deal/Loan/FH Type
 
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    HGTypAr2b                              88
     C                   IF        WrkInd1 = False
     C     W5TYPE        LOOKUP    HGTypAr2b                              88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
     C                   SELECT
     C                   WHEN      #3HMOD = 'FH'
      ** "FH" not found among Hedge Strategy's Hedged Types
     C                   EVAL      MsgIdArr(Idx) = 'ASM0076'
     C                   OTHER
      ** Hedged Deal/Loan Type is not found among the Strategy's valid types
     C                   EVAL      MsgIdArr(Idx) = 'ASM0077'
     C                   ENDSL
     C                   ENDIF
     C                   ENDIF
 
      ** If not a "Wild card" -validate Hedged Deal/Loan/FH Subtype
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    HGSTypAr                               88
     C                   IF        WrkInd1 = False
     C     W5DLST        LOOKUP    HGSTypAr                               88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Deal/Loan/Forecast Transaction Subtype not found among the Strategy's valid subtypes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0078'
     C                   ENDIF
     C                   ENDIF
 
      ** For Deals and Loans -check their Book Code against Strategy's
 
     C                   IF        #3HMOD <> 'FH'
 
      ** If not a "Wild card" -validate Derivative Deal Book Code
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    HGBkCdAr                               88
     C                   IF        WrkInd1 = False
     C     W5BOKC        LOOKUP    HGBkCdAr                               88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Deal/Loan Book Code not found among the Strategy's valid codes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0079'
     C                   ENDIF
     C                   ENDIF
                                                                                              CAS005
     C                   IF        ErrSflDTLNum = False AND                                   CAS005
     C                             WkDervDTYP = 'RX'                                          CAS005
                                                                                              CAS005
     C                   IF        W1stItemRec = 'Y'                                          CAS005
                                                                                              CAS005
     C                   EVAL      W1stItemRec = 'N'                                          CAS005
     C                   EXSR      SRGetCCY                                                   CAS005
                                                                                              CAS005
     C                   ELSE                                                                 CAS005
                                                                                              CAS005
     C                   IF        CCY <> WkDervCCY                                           CAS005
     C                   EVAL      ErrSflDTLNum = True                                        CAS005
     C                   EVAL      Idx = Idx + 1                                              CAS005
     C                   EVAL      MsgIdArr(Idx) = 'ASM0148'                                  CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF                                                                CAS005
     C                   ENDIF                                                                CAS005
                                                                                              CAS005
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        ErrSflDTLNum = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValFutFld - Validate Derivative Futures Fields              *
      *                                                               *
      * Called by: SRValScn4                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValFutFld   BEGSR
 
      ** Insert mode
 
     C                   IF        InsertMode = 'Y'
 
      ** First time through
 
     C                   IF        FutMode = *BLANKS
 
      ** Transaction number or futures/options fields must be entered
 
     C                   IF        #2DDNO = *BLANKS and #2DFPO = *BLANKS
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Transaction Number OR Futures/Options fields must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0080'
     C                   ENDIF
 
      ** Fields are mutually exclusive
 
     C                   IF        ErrSflDTLNum = False and ErrSflFRSRef = False
     C                   SELECT
     C                   WHEN      #2DDNO <> *BLANKS
     C                   IF        #2DFPO <> *BLANKS
     C                   EVAL      ErrSflFRSRef = True
     C                   ENDIF
     C                   IF        #2DBKC <> *BLANKS
     C                   EVAL      ErrSflBkCode = True
     C                   ENDIF
     C                   IF        #2BRCA <> *BLANKS
     C                   EVAL      ErrSflBrhCde = True
     C                   ENDIF
     C                   IF        #2PCAL <> *BLANKS
     C                   EVAL      ErrSflPCTVDB = True
     C                   ENDIF
 
     C                   WHEN      #2DFPO <> *BLANKS
     C                   IF        #2DDNO <> *BLANKS
     C                   EVAL      ErrSflDTLNum = True
     C                   ENDIF
 
     C                   ENDSL
     C                   ENDIF
 
     C                   IF        ErrSflFRSRef = True or ErrSflBkCode = True or
     C                             ErrSflBrhCde = True or ErrSflPCTVDB = True or
     C                             ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Transaction and Futures/Options fields are mutually exclusive
     C                   EVAL      MsgIdArr(Idx) = 'ASM0081'
     C                   ENDIF
 
      ** Not first time through
 
     C                   ELSE
 
     C                   SELECT
 
      ** Futures Transaction Mode
 
     C                   WHEN      FutMode = 'DDNO'
     C                   IF        #2DDNO = *BLANKS or
     C                             #2DFPO <> *BLANKS or
     C                             #2DBKC <> *BLANKS or
     C                             #2BRCA <> *BLANKS or
     C                             #2PCAL <> *BLANKS
     C                   EVAL      Idx = Idx + 1
      ** Trade Number must be entered. Future positions fields must be blank.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0082'
 
     C                   IF        #2DDNO = *BLANKS
     C                   EVAL      ErrSflDTLNum = True
     C                   ENDIF
 
     C                   IF        #2DFPO <> *BLANKS
     C                   EVAL      ErrSflFRSRef = True
     C                   ENDIF
     C                   IF        #2DBKC <> *BLANKS
     C                   EVAL      ErrSflBkCode = True
     C                   ENDIF
     C                   IF        #2BRCA <> *BLANKS
     C                   EVAL      ErrSflBrhCde = True
     C                   ENDIF
     C                   IF        #2PCAL <> *BLANKS
     C                   EVAL      ErrSflPCTVDB = True
     C                   ENDIF
     C                   ENDIF
 
      ** Futures Position Mode
 
     C                   WHEN      FutMode = 'DFPO'
     C                   IF        #2DFPO = *BLANKS or #2DBKC = *BLANKS or
     C                             #2BRCA = *BLANKS or #2PCAL = *BLANKS or
     C                             #2DDNO <> *BLANKS
     C                   EVAL      Idx = Idx + 1
      ** Future positions fields must be entered. Trade Number must be blank.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0118'
 
     C                   IF        #2DDNO <> *BLANKS
     C                   EVAL      ErrSflDTLNum = True
     C                   ENDIF
     C                   IF        #2DFPO = *BLANKS
     C                   EVAL      ErrSflFRSRef = True
     C                   ENDIF
     C                   IF        #2DBKC = *BLANKS
     C                   EVAL      ErrSflBkCode = True
     C                   ENDIF
     C                   IF        #2BRCA = *BLANKS
     C                   EVAL      ErrSflBrhCde = True
     C                   ENDIF
     C                   IF        #2PCAL = *BLANKS
     C                   EVAL      ErrSflPCTVDB = True
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
      ** If Valid so far
 
     C                   IF        ErrSflDTLNum = False and
     C                             ErrSflFRSRef = False and
     C                             ErrSflBkCode = False and
     C                             ErrSflBrhCde = False and
     C                             ErrSflPCTVDB = False
 
      ** Process depending on which field was entered
 
     C                   SELECT
 
      ** Process for futures transactions
 
     C                   WHEN      #2DDNO <> *BLANKS and #2DFPO = *BLANKS and
     C                             InsertMode = 'Y' or
     C                             DrvFutPosFTM = True and AmendMode = True
 
     C                   EXSR      SRValFutTrn
 
      ** Process for futures positions
 
     C                   WHEN      #2DDNO = *BLANKS and #2DFPO <> *BLANKS and
     C                             InsertMode = 'Y' or
     C                             DrvFutPosFTM = False and AmendMode = True
 
     C                   EXSR      SRValFutPos
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        ErrSflDTLNum = True or
     C                             ErrSflFRSRef = True or
     C                             ErrSflBkCode = True or
     C                             ErrSflBrhCde = True or
     C                             ErrSflPCTVDB = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValFutTrn - Validate Futures Transactions                   *
      *                                                               *
      * Called by: SRValFutFld                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValFutTrn   BEGSR
 
      ** Cannot be blank , zero, or non-numeric
 
     C                   TESTN                   #2DDNO               88
     C                   MOVE      #2DDNO        WkTest
     C                   TESTZ                   WkTest                   89
     C                   IF        WrkInd1 <> True or WrkInd2 <> True  or
     C                             #2DDNO = *BLANKS or #2DDNO = *ALL'0'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Transaction Number is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0083'
 
     C                   ELSE
 
      ** Check against Transaction File
 
     C                   MOVE      #2DDNO        WkDNum
 
     C     WkDNum        CHAIN     TRANSDF                            27
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Transaction Number is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0083'
     C                   ENDIF
 
      ** If valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** Save Hedged Book Code
 
     C                   EVAL      W4BOKC = BOKC
 
      ** If not a "Wild card" -validate Future Transaction Book Code
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    DVBkCdAr                               88
     C                   IF        WrkInd1 = False
     C     W4BOKC        LOOKUP    DVBkCdAr                               88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      Idx = Idx + 1
      ** Transaction's Book Code is not part of Strategy's valid Book Codes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0084'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrSflDTLNum = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValFutPos - Validate Futures Transactions                   *
      *                                                               *
      * Called by: SRValFutFld                                        *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValFutPos   BEGSR
 
      ** Cannot be blank
 
     C                   IF        #2DFPO = *BLANKS
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Hedge Futures Position must be entered
     C                   EVAL      MsgIdArr(Idx) = 'ASM0085'
 
     C                   ELSE
 
      ** Positions 1-5 must be a valid Instrument Type
 
     C     WInsTp        CHAIN     INTYPDF                            27
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Positions 1-5 must be a valid Instrument Type
     C                   EVAL      MsgIdArr(Idx) = 'ASM0086'
     C                   ENDIF
     C                   ENDIF
 
      ** If valid
 
     C                   IF        ErrSflDTLNum = False
 
      ** If OTC-Type: (Over-the-Counter)
 
     C                   IF        ISTI = 'Y'
 
      ** Positions 6-10 must be blank
 
     C                   IF        Wk6to10 <> *BLANKS and Wk6to10 <> *ALL'0'
 
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Positions 6-10 must be blank for an OTC Instrument Type
     C                   EVAL      MsgIdArr(Idx) = 'ASM0087'
     C                   ENDIF
 
      ** If non-OTC-Type
 
     C                   ELSE
 
      ** Positions 1-2 is Market Centre and is validated later on
      ** Positions 6-8 must be a valid MMM (Character) month
 
     C                   EVAL      C = 1
     C     WMthNm        LOOKUP    MthNamAr(C)                            88
     C                   IF        WrkInd1 = True
     C                   MOVE      MthNumAr(C)   KMthNum
     C                   ELSE
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Positions 6-8 must contain a valid 3-digit month abbreviation: JAN,FEB,MAR,APR,MAY,JUN,JUL,
      ** AUG,SEP,OCT,NOV,DEC
     C                   EVAL      MsgIdArr(Idx) = 'ASM0088'
     C                   ENDIF
 
      ** Positions 9-10 must be a 2-digit year
 
     C                   IF        WYrNum   < '00' or WYrNum  > '99'
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Positions 9-10 must contain a 2-digit year (00 through 99)
     C                   EVAL      MsgIdArr(Idx) = 'ASM0089'
     C                   ELSE
     C                   MOVE      WYrNum        KYrNum
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** If valid instrument fields-further check against Hedge Strategy
 
     C                   IF        ErrSflFRSRef = False
 
     C                   EVAL      WrkInd1 = False
 
      ** Validate Complete Futures Position
 
     C     #2DFPO        LOOKUP    DVTypAr                                88
     C                   IF        WrkInd1 = False
 
      ** If invalid Validate Mkt Ctr+Instr. Type
 
     C     WInsTp        LOOKUP    DVTypAr5                               88
     C                   IF        WrkInd1 = False
 
      ** If invalid Validate Mkt Ctr
 
     C     WMkIns        LOOKUP    DVTypAr2                               88
 
      ** If invalid issue error message
 
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Value in Futures Position not found among Strategy's valid derivative types
     C                   EVAL      MsgIdArr(Idx) = 'ASM0090'
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrSflFRSRef = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValSecRef - Validate Hedged Security Reference              *
      *                                                               *
      * Called by: SRValScn5                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValSecRef   BEGSR
 
      ** Cannot be blank
 
     C                   IF        #3HSEC = *BLANKS
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Security Reference is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0091'
     C                   ENDIF
 
      ** If Valid, Check against Security file
 
     C                   IF        ErrSflFRSRef = False
 
     C     #3HSEC        CHAIN     SECTYDF                            27
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Security Reference is invalid or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0091'
     C                   ENDIF
     C                   ENDIF
 
      ** If Valid
 
     C                   IF        ErrSflFRSRef = False
 
     C                   EVAL      W5TYPE2 = SITP
 
      ** If not a "Wild card" - validate against Strategy
 
     C                   EVAL      WrkInd1 = False
     C     '***'         LOOKUP    HGTypAr                                88
     C                   IF        WrkInd1 = False
     C     W5TYPE2       LOOKUP    HGTypAr                                88
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Security Investment Type is not found among the Strategy's types
     C                   EVAL      MsgIdArr(Idx) = 'ASM0092'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Check if Hedge Strategy Branch is the same as Hedged Forcast                         226221
                                                                                              226221
     C                   IF        #3BRCA <> HSBRCA                                           226221
     C                   EVAL      ErrSflFRSRef = True                                        226221
     C                   EVAL      Idx = Idx + 1                                              226221
     C                   EVAL      MsgIdArr(Idx) = 'ASM0164'                                  226221
     C                   ENDIF                                                                226221
                                                                                              226221
     C                   IF        ErrSflFRSRef = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValBkCode - Validate Book Code                              *
      *                                                               *
      * Called by: SRValScn4, SRValScn5                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValBkCode   BEGSR
 
      ** Validate Book Code
 
     C                   IF        #2DFPO <> *BLANKS and #2DBKC = *BLANKS and
     C                             WScrn = '4' or
     C                             #3HBKC = *BLANKS and  WScrn = '5'
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      Idx = Idx + 1
      ** Book code not found.
     C                   EVAL      MsgIdArr(Idx) = 'USR0758'
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflBkCode = False and #2DBKC <> *BLANKS
     C                             and WScrn = '4' or ErrSflBkCode = False and
     C                             WScrn = '5'
 
     C                   SELECT
     C                   WHEN      WScrn = '4'
     C                   EVAL      WBkCd = #2DBKC
     C                   WHEN      WScrn = '5'
     C                   EVAL      WBkCd = #3HBKC
     C                   ENDSL
 
     C                   CALLB     'AOBOOKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WBkCd
     C     SDBOOK        PARM      SDBOOK        DSFDY
 
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      Idx = Idx + 1
      ** Book code not found.
     C                   EVAL      MsgIdArr(Idx) = 'USR0758'
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      WScrn = '4'
     C                   EVAL      #2DBKC = BDBKCD
     C                   WHEN      WScrn = '5'
     C                   EVAL      #3HBKC = BDBKCD
     C                   ENDSL
 
     C                   ENDIF
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflBkCode = False and #2DBKC <> *BLANKS
     C                             and WScrn = '4' or ErrSflBkCode = False and
     C                             WScrn = '5'
 
     C                   SELECT
 
      ** Screen 4 book code
 
     C                   WHEN      WScrn = '4'
 
     C                   EVAL      W4BOKC = #2DBKC
      ** If not a "Wild card" - validate against Hedge Strategy's
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    DVBkCdAr                               88
     C                   IF        WrkInd1 = False
     C     W4BOKC        LOOKUP    DVBkCdAr                               88
 
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      Idx = Idx + 1
      ** Derivative Book Code entered not found among the Strategy's valid codes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0093'
     C                   ENDIF
     C                   ENDIF
 
      ** Screen 5 book code
 
     C                   WHEN      WScrn = '5'
 
     C                   EVAL      W5BOKC = #3HBKC
      ** If not a "Wild card" - validate against Hedge Strategy's
     C                   EVAL      WrkInd1 = False
     C     '**'          LOOKUP    HGBkCdAr                               88
     C                   IF        WrkInd1 = False
     C     W5BOKC        LOOKUP    HGBkCdAr                               88
 
     C                   IF        WrkInd1 = False
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      Idx = Idx + 1
      ** Hedged Book Code entered not found among the Strategy's valid codes
     C                   EVAL      MsgIdArr(Idx) = 'ASM0094'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDIF
 
     C                   IF        ErrSflBkCode = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValBchCde - Validate Branch Code                            *
      *                                                               *
      * Called by: SRValScn4, SRValScn5                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValBchCde   BEGSR
 
      ** Validate Branch Code
 
     C                   IF        #2DFPO <> *BLANKS and #2BRCA = *BLANKS and
     C                             WScrn = '4' or
     C                             #3BRCA = *BLANKS and  WScrn = '5'
     C                   EVAL      ErrSflBrhCde = True
     C                   EVAL      Idx = Idx + 1
      ** Branch code not found.
     C                   EVAL      MsgIdArr(Idx) = 'USR0761'
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflBrhCde = False and #2BRCA <> *BLANKS
     C                             and WScrn = '4' or ErrSflBrhCde = False and
     C                             WScrn = '5'
 
     C                   SELECT
     C                   WHEN      WScrn = '4'
     C                   EVAL      WBRCA = #2BRCA
     C                   WHEN      WScrn = '5'
     C                   EVAL      WBRCA = #3BRCA
     C                   ENDSL
 
     C**********         CALLB     'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM                    WBRCA
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
 
     C     @RtCd         IFNE      *BLANK
 
     C                   EVAL      ErrSflBrhCde = True
     C                   EVAL      Idx = Idx + 1
      ** Branch code not found.
     C                   EVAL      MsgIdArr(Idx) = 'USR0761'
 
     C                   ELSE
 
     C                   SELECT
     C                   WHEN      WScrn = '4'
     C                   EVAL      #2BRCA = A8BRCD
     C                   WHEN      WScrn = '5'
     C                   EVAL      #3BRCA = A8BRCD
     C                   ENDSL
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrSflBrhCde = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValPutCall - Validate Put/Call                              *
      *                                                               *
      * Called by: SRValScn4                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValPutCall  BEGSR
 
      ** Validate Put/Call Indicator
 
      ** Put/Call must be entered if Futures Position has been entered
 
     C                   IF        #2PCAL <> 'P' and #2PCAL <> 'C' and
     C                             #2DFPO <> *BLANKS and #2DDNO = *BLANKS
     C                   EVAL      ErrSflPCTVDB = True
     C                   EVAL      Idx = Idx + 1
      ** Put/Call must be "P" -Put or "C" -Call
     C                   EVAL      MsgIdArr(Idx) = 'ASM0095'
     C                   ENDIF
 
     C                   IF        ErrSflPCtVDB = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValPos - Validate if position exist in POSTNKD              *
      *                                                               *
      * Called by: SRValScn4                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValPos      BEGSR
 
     C     KLIST2        CHAIN     POSTNKDF                           27
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      ErrSflBrhCde = True
     C                   EVAL      ErrSflPCTVDB = True
     C                   EVAL      Idx = Idx + 1
      ** FF Book Instrument Positions record not found or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0096'
     C                   ENDIF
 
     C                   IF        ErrSflFRSRef = True or
     C                             ErrSflBkCode = True or
     C                             ErrSflBrhCde = True or
     C                             ErrSflPCTVDB = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValPct4 - Validate Percentage for Screen 4                  *
      *                                                               *
      * Called by: SRValScn4                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValPct4     BEGSR
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 6
     C                   EVAL      PZFIELD = *BLANKS
     C                   IF        #2DPCT = *BLANKS or #2DPCT = *ALL'0'
     C                   MOVE      100           PZFIELD
     C                   ELSE
     C                   EVAL      PZFIELD = #2DPCT
     C                   ENDIF
 
     C                   EXSR      SRZAlign
 
      ** If error on validation
 
     C                   IF        PZAlignOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Derivative Percentage must be positive with no more than two decimal places.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0097'
     C                   ELSE
     C                   MOVE      PZFIELD       WkPCT
     C                   IF        WkPCT = 0 and #2DPCT <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Percentage if entered cannot be equal to zero.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0115'
     C                   ENDIF
     C                   MOVE      WkPCT         PZFLD15
     C                   Z-ADD     2             PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #2DPCT
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflPct = False
 
      ** If percentage exceeds 100.00% or less than 0%-issue an error
      ** Only issue error if percentage was actually entered on screen.
 
     C                   IF        WkPCT > 100 or WkPCT < 0
     C                   IF        #2DPCT <> *ALL'0' and #2DPCT <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Derivative percentage for a linkage must be greater 0 and less than 100.01
     C                   EVAL      MsgIdArr(Idx) = 'ASM0098'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflPct = False
 
      ** Build key list based on mode
 
     C                   SELECT
     C                   WHEN      DerivDeal = True or DrvFutPosFTM = True or
     C                             #2DDNO <> *BLANKS and #2DFPO = *BLANKS
     C                   MOVE      #2DDNO        KFSDLNO
     C                   EVAL      KFSFPSE = *BLANKS
     C                   EVAL      KFSBKCD = *BLANKS
     C                   EVAL      KFSBRCA = *BLANKS
     C                   EVAL      KFSPCAL = *BLANKS
     C                   EVAL      KFSMKTI = *BLANKS
     C                   EVAL      KFSBHTV = *BLANKS
 
     C                   WHEN      DrvFutPosFTM = True
     C**********         Z-ADD     *ZEROS        KFSDLNO                                      CLE148
     C                   MOVEL     *BLANKS       KFSDLNO                                      CLE148
     C                   EVAL      KFSFPSE = #2DFPO
     C                   EVAL      KFSBKCD = #2DBKC
     C                   EVAL      KFSBRCA = #2BRCA
     C                   EVAL      KFSPCAL = #2PCAL
     C                   EVAL      KFSMKTI = *BLANKS
     C                   EVAL      KFSBHTV = *BLANKS
 
     C                   ENDSL
 
      ** Check if other linkages exist and total their hedge percentage
 
     C                   EVAL      WkMod = #2DMOD
     C                   EXSR      SRTotPct
 
      ** Issue a warning if total percentage exceeds 100
 
     C                   IF        WTotPct > 100
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Total Hedge Derivative Percentage must not exceed 100%.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0099'
     C                   EVAL      FldNameArr(Idx) = '#2DPCT'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrSflPct = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRTotPct - Total Percentage                                   *
      *                                                               *
      * Called by: SRValPct                                           *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRTotPct      BEGSR
 
      ** Initialise total percentage with percentage entered on screen
 
     C                   Z-ADD     WkPCT         WTotPct
 
     C                   MOVE      #2HEDG        WkHEDG
 
      ** Position cursor and read all records for given transaction
 
     C     KLIST3        SETLL     ASHTRNL2
     C     KLIST3        READE     ASHTRNL2                               26
 
     C                   DOW       EndOfFile = False
 
      ** For the Hedge transaction being processed, only accumulate the total
      ** precentaqe ONCE using the value on the screen
      ** Also, validate percentages of different modules separately
 
     C                   IF        WkHEDG <> T2FSHEDI and WkMod = T2FSMOD
 
      ** Accumulate the total percentage for all live linkages
      ** If Hedge Accounting (CAS004) is installed, include the                               CAS004
      ** percentages of ineffective/discontinued hedge linkages.                              CAS004
 
     C     T2FSHEDI      CHAIN     ASHGLKL1                           27
 
     C                   IF        RecNotFnd = False and FSRECI = 'D' or
     C                             RecNotFnd = False and FSRECI = 'T'
     C                             or (CAS004 = 'Y' and RecNotFnd = False                     CAS004
     C                             and FSRECI = 'X')                                          CAS004
     C                   EVAL      WTotPct = WtotPct + T2FSPCTG
     C                   ENDIF
 
     C                   ENDIF
 
     C     KLIST3        READE     ASHTRNL2                               26
 
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValMktInd - Validate Hedged Market Indicator                *
      *                                                               *
      * Called by: SRValScn5                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValMktInd   BEGSR
 
      ** Market indicator values
 
     C                   IF        #3MKTI <> 'G' and #3MKTI <> 'P' and
     C                             #3MKTI <> 'S' and #3MKTI <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflMktInd = True
      ** Market Indicator must be "G" - Grey, "P" - Primary or "S" - Secondary.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0100'
     C                   EVAL      FldNameArr(Idx) = '#3MKTI'
     C                   ENDIF
 
      ** Prepare keys for the validation
 
     C                   IF        #3MKTI = *BLANKS and ErrSflMktInd = False
     C                   EVAL      #3MKTI = HGFSSEMK
     C                   EVAL      WIdx = WIdx + 1
      ** System default value used for Market Indicator: may be overridden
     C                   EVAL      WMsgIdArr(WIdx) = 'ASM0101'
     C                   EVAL      WFldNamArr(WIdx) = '*ANY  '
     C                   ENDIF
 
     C                   IF        ErrSflMktInd = True
     C                   EVAL      AllValid = 'N'
     C                   ELSE
     C                   EVAL      WkMKTI = #3MKTI
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValBHTV - Validate Hedged Trade/Value Date Basis            *
      *                                                               *
      * Called by: SRValScn5                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValBHTV     BEGSR
 
      ** Trade/Value Trade Basis
 
     C                   IF        #3BHTV <> 'T' and #3BHTV <> 'V' and
     C                             #3BHTV <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPCTVDB = True
      ** Trade/Value Date Basis must be "T" -Trade or "V" -Value
     C                   EVAL      MsgIdArr(Idx) = 'ASM0102'
     C                   EVAL      FldNameArr(Idx) = '#3BHTV'
     C                   ENDIF
 
      ** Prepare keys for the validation
 
     C                   IF        #3BHTV = *BLANKS and ErrSflPCTVDB = False
     C                   EVAL      #3BHTV = HGFSSETV
     C                   EVAL      WIdx = WIdx + 1
      ** System default value used for Trade/Value Date Basis: may be overridden
     C                   EVAL      WMsgIdArr(WIdx) = 'ASM0103'
     C                   EVAL      WFldNamArr(WIdx) = '*ANY  '
     C                   ENDIF
 
      ** Must match unrealised profit basis from Securities Trading ICD
 
     C                   IF        BVUPB  <> 'B' and #3BHTV <> BVUPB
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPCTVDB = True
      ** Trade/Value Date Basis must match Unrealised Profit Basis on SE Trading
     C                   EVAL      MsgIdArr(Idx) = 'ASM0104'
     C                   EVAL      FldNameArr(Idx) = '#3BHTV'
     C                   ENDIF
 
     C                   IF        ErrSflPCTVDB = True
     C                   EVAL      AllValid = 'N'
     C                   ELSE
     C                   EVAL      WkBHTV = #3BHTV
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValBkPos - Validate Book Position                           *
      *                                                               *
      * Called by: SRValScn5                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValBkPos    BEGSR
 
     C     KLIST4        CHAIN     BKPHD                              27
     C                   IF        RecNotFnd = True or RECI <> 'D'
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      ErrSflBrhCde = True
     C                   EVAL      ErrSflPCTVDB = True
     C                   EVAL      ErrSflMktInd = True
     C                   EVAL      Idx = Idx + 1
      ** Record on Midas SE Book Positions Header not found or not live
     C                   EVAL      MsgIdArr(Idx) = 'ASM0105'
     C                   ENDIF
 
     C                   IF        ErrSflFRSRef = True or
     C                             ErrSflBkCode = True or
     C                             ErrSflBrhCde = True or
     C                             ErrSflPCTVDB = True or
     C                             ErrSflMktInd = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValPct5 - Validate Percentage for Screen 5                  *
      *                                                               *
      * Called by: SRValScn5                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValPct5     BEGSR
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 6
     C                   EVAL      PZFIELD = *BLANKS
     C                   IF        #3HPCT = *BLANKS or #3HPCT = *ALL'0'
     C                   MOVE      100           PZFIELD
     C                   ELSE
     C                   EVAL      PZFIELD = #3HPCT
     C                   ENDIF
 
     C                   EXSR      SRZAlign
 
      ** If error on validation
 
     C                   IF        PZAlignOk = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Hedged Percentage must be positive with no more than two decimal places
     C                   EVAL      MsgIdArr(Idx) = 'ASM0106'
     C                   ELSE
     C                   MOVE      PZFIELD       WkPCT
     C                   IF        WkPCT = 0 and #3HPCT <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Percentage if entered cannot be equal to zero.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0115'
     C                   ENDIF
     C                   MOVE      WkPCT         PZFLD15
     C                   Z-ADD     2             PZDECS
     C                   EXSR      SRCvtAmt
     C                   MOVE      PZOUT21       #3HPCT
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflPct = False
 
      ** If percentage exceeds 100.00% or less than 0%-issue an error
      ** Only issue error if percentage was actually entered on screen.
 
     C                   IF        WkPCT > 100 or WkPCT < 0
     C                   IF        #3HPCT <> *ALL'0' and #3HPCT <> *BLANKS
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Hedged Percentage for a linkage must be greater 0 and less than 100.01
     C                   EVAL      MsgIdArr(Idx) = 'ASM0107'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
      ** Valid so far
 
     C                   IF        ErrSflPct = False
 
      ** Build key list based on mode
 
     C                   SELECT
     C                   WHEN      HdgDlLnFTrn = True
     C                   MOVE      #3HDNO        KFSDLNO
     C                   EVAL      KFSFPSE = *BLANKS
     C                   EVAL      KFSBKCD = *BLANKS
     C                   EVAL      KFSBRCA = *BLANKS
     C                   EVAL      KFSPCAL = *BLANKS
     C                   EVAL      KFSMKTI = *BLANKS
     C                   EVAL      KFSBHTV = *BLANKS
 
     C                   WHEN      HdgSecRef = True
     C**********         Z-ADD     *ZEROS        KFSDLNO                                      CLE148
     C                   MOVEL     *BLANKS       KFSDLNO                                      CLE148
     C                   EVAL      KFSFPSE = #3HSEC
     C                   EVAL      KFSBKCD = #3HBKC
     C                   EVAL      KFSBRCA = #3BRCA
     C                   EVAL      KFSPCAL = *BLANKS
     C                   EVAL      KFSMKTI = #3MKTI
     C                   EVAL      KFSBHTV = #3BHTV
 
     C                   ENDSL
 
      ** Check if other linkages exist and total their hedge percentage
 
     C                   EVAL      WkMod = #3HMOD
     C                   EXSR      SRTotPct
 
      ** Issue a warning if total percentage exceeds 100
 
     C                   IF        WTotPct > 100
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      ErrSflPct = True
      ** Total Hedged Percentage must not exceed 100%
     C                   EVAL      MsgIdArr(Idx) = 'ASM0108'
     C                   EVAL      FldNameArr(Idx) = '#3HPCT'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ErrSflPct = True
     C                   EVAL      AllValid = 'N'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkTrn -  Check if new transaction is not on file.          *
      *                                                               *
      * Called by: SRValScn4, SRValScn5                               *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkTrn      BEGSR
 
     C                   SELECT
     C                   WHEN      WScrn = '4'
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'D'
     C                   MOVE      #2DDNO        TRDLNO
     C                   EVAL      TRFPSE = #2DFPO
     C                   EVAL      TRBKCD = #2DBKC
     C                   EVAL      TRBRCA = #2BRCA
     C                   EVAL      TRPCAL = #2PCAL
     C                   EVAL      TRMKTI = *BLANKS
     C                   EVAL      TRBHTV = *BLANKS
     C                   WHEN      WScrn = '5'
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'H'
     C                   MOVE      #3HDNO        TRDLNO
     C                   EVAL      TRFPSE = #3HSEC
     C                   EVAL      TRBKCD = #3HBKC
     C                   EVAL      TRBRCA = #3BRCA
     C                   EVAL      TRPCAL = *BLANKS
     C                   EVAL      TRMKTI = #3MKTI
     C                   EVAL      TRBHTV = #3BHTV
                                                                                              CAS006
      ** Setup keyfields for hedged securities                                                CAS006
                                                                                              CAS006
     C                   EVAL      KGDHIn = 'H'                                               CAS006
     C                   MOVE      #3HDNO        KGDlNo                                       CAS006
     C                   EVAL      KGSecu = #3HSEC                                            CAS006
     C                   EVAL      KGBook = #3HBKC                                            CAS006
     C                   EVAL      KGBrch = #3BRCA                                            CAS006
     C                   EVAL      KGPCal = *BLANKS                                           CAS006
     C                   EVAL      KGMktI = #3MKTI                                            CAS006
     C                   EVAL      KGTVDt = #3BHTV                                            CAS006
                                                                                              CAS006
     C                   ENDSL
 
     C     KLIST6        CHAIN     ASHTRNL8                           27
     C                   IF        RecNotFnd = False
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      AllValid = 'N'
      ** Transaction already exist for this linkage.
     C                   EVAL      MsgIdArr(Idx) = 'ASM0124'
     C                   EVAL      ErrSflMidMdl = True
     C                   EVAL      ErrSflDTLNum = True
     C                   EVAL      ErrSflFRSRef = True
     C                   EVAL      ErrSflBkCode = True
     C                   EVAL      ErrSflBrhCde = True
     C                   EVAL      ErrSflPCTVDB = True
     C                   IF        WScrn = '5'
     C                   EVAL      ErrSflMktInd = True
     C                   ENDIF
     C                   ENDIF
 
      ** If Hedge Accounting (CAS004) is installed, transactions must                         CAS004
      ** be hedged under linkages with the same hedge strategy product                        CAS004
      ** type.                                                                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
                                                                                              CAS004
     C                   EVAL      WProdType1 = *BLANKS                                       CAS004
     C                   EVAL      WProdType2 = *BLANKS                                       CAS004
     C                   EVAL      WkModu = *BLANKS                                           CAS006
     C                   IF        WScrn = '4'                                                CAS004
     C                   EVAL      TRMOD  = #2DMOD                                            CAS004
     C                   ENDIF                                                                CAS004
     C                   IF        WScrn = '5'                                                CAS004
     C                   EVAL      TRMOD  = #3HMOD                                            CAS004
     C                   EVAL      WkModu = #3HMOD                                            CAS006
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Get product type of current linkage.                                                 CAS004
                                                                                              CAS004
     C                   EVAL      WProdType1 = HSPRTP                                        CAS004
                                                                                              CAS004
      ** Determine if this transaction has already been hedged in                             CAS004
      ** other linkages, if so determine hedge product type.                                  CAS004
                                                                                              CAS004
     C                   IF        CAS006 = 'Y' AND WkModu = 'SE'                             CAS006
     C     KlistG        CHAIN     ASHTRNL3                           27                      CAS006
     C                   ELSE                                                                 CAS006
     C     KLIST7        CHAIN     ASHTRNL6                           27                      CAS004
     C                   ENDIF                                                                CAS006
     C                   IF        RecNotFnd = False                                          CAS004
     C     T6HEDI        CHAIN     ASHGLKL1                           27                      CAS004
     C                   IF        RecNotFnd = False                                          CAS004
                                                                                              CAS004
     C                   CALL      'AOHGSTR0'                                                 CAS004
     C                   PARM      *BLANKS       @RtCd                                        CAS004
     C                   PARM      '*KEY   '     @Optn                                        CAS004
     C                   PARM                    FSHGST                                       CAS004
     C     SDHGST2       PARM      SDHGST2       DSSDY                                        CAS004
                                                                                              CAS004
     C                   IF        @RtCd <> *BLANKS                                           CAS004
     C                   EVAL      DBKEY = FSHGST                                             CAS004
     C                   EVAL      DBFILE = 'SDHGSTPD'                                        CAS004
     C                   EVAL      DBASE  =  009                                              CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ELSE                                                                 CAS004
     C                   EVAL      WProdType2 = PTPRTP                                        CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Error if hedge strategy product types are not the same.                              CAS004
                                                                                              CAS004
     C                   IF        WProdType1 <> *BLANKS and                                  CAS004
     C                             WProdType2 <> *BLANKS and                                  CAS004
     C                             WProdType1 <> WProdType2                                   CAS004
     C                   EVAL      Idx = Idx + 1                                              CAS004
     C                   EVAL      AllValid = 'N'                                             CAS004
     C                   EVAL      MsgIdArr(Idx) = 'ASM0126'                                  CAS004
     C                   EVAL      ErrSflMidMdl = True                                        CAS004
     C                   EVAL      ErrSflDTLNum = True                                        CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtToScn3 - Convert from file format to screen format for   *
      *               Screen 3.                                       *
      *                                                               *
      * Called by: SRValScn1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCvtToScn3   BEGSR
 
     C                   MOVE      #1HEDI        K#1HEDI
 
     C     K#1HEDI       CHAIN     ASHGLKL1                           27
 
      ** Move the whole record format to MnHGLK data structure
 
     C                   EVAL      MnHGLK = ASHGLK
 
      ** Hedge ID
 
     C                   EVAL      #2HEDG = #1HEDI
 
      ** Hedge Strategy
 
     C                   EVAL      #2HGST = #1HGST
 
      ** Effective Date
 
     C                   EVAL      PZDayNo = FSEFFD
     C                   EXSR      SRCvtDate
     C                   MOVE      PZDate        #2EFFD
 
      ** Input Date
 
     C                   EVAL      PZDayNo = FSINDT
     C                   EXSR      SRCvtDate
     C                   MOVE      PZDate        #2INDT
 
      ** Functional Currency Offset
 
     C                   EVAL      #2FCOA = FSFCOA
 
      ** Investment Category
 
     C                   EVAL      #2ICAT = FSICAT
 
      ** Start Date
 
     C                   EVAL      PZDayNo = FSSTDT
     C                   EXSR      SRCvtDate
     C                   MOVE      PZDate        #2STDT
 
      ** End Date
 
     C                   EVAL      PZDayNo = FSENDT
     C                   EXSR      SRCvtDate
     C                   MOVE      PZDate        #2ENDT
 
      ** Hedge Derivative Deals
 
     C                   EVAL      #2DVDL = FSDVDL
 
      ** Hedge Futures Position
 
     C                   EVAL      #2FTPO = FSFTPO
 
      ** Hedged Deals/Loans
 
     C                   EVAL      #2HGDL = FSHGDL
 
      ** Hedged Security Reference
 
     C                   EVAL      #2SECR = FSSECR
 
      ** Data Type                                                                            CAS006
                                                                                              CAS006
     C                   EVAL      #2DTTP = FSDTTP                                            CAS006
                                                                                              CAS006
      ** Data Points Required                                                                 CAS006
                                                                                              CAS006
     C                   IF        FSDPTS  <> *ZEROS                                          CAS006
     C                   MOVE      *BLANKS       PZFLD15                                      CAS006
     C                   MOVE      FSDPTS        PZFLD15                                      CAS006
     C                   Z-ADD     0             PZDECS                                       CAS006
     C                   EXSR      SRCvtAmt                                                   CAS006
     C                   MOVE      PZOUT21       #2DPTS                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      *BLANKS       #2DPTS                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Data Collection Frequency                                                            CAS006
                                                                                              CAS006
     C                   EVAL      #2DFRQ = FSDFRQ                                            CAS006
                                                                                              CAS006
      ** Day of the Week                                                                      CAS006
                                                                                              CAS006
     C                   EVAL      #2WDAY = FSWDAY                                            CAS006
                                                                                              CAS006
      ** Day of the Month                                                                     CAS006
                                                                                              CAS006
     C                   IF        FSMNTH  <> *ZEROS                                          CAS006
     C                   MOVE      *BLANKS       PZFLD15                                      CAS006
     C                   MOVE      FSMNTH        PZFLD15                                      CAS006
     C                   Z-ADD     0             PZDECS                                       CAS006
     C                   EXSR      SRCvtAmt                                                   CAS006
     C                   MOVE      *BLANKS       #2MNTH                                       CAS006
     C                   MOVE      PZOUT21       #2MNTH                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      *BLANKS       #2MNTH                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Next Data Collection Date                                                            CAS006
                                                                                              CAS006
     C                   IF        FSNDTA  <> *ZEROS                                          CAS006
     C                   EVAL      PZDayNo = FSNDTA                                           CAS006
     C                   EXSR      SRCvtDate                                                  CAS006
     C                   MOVE      PZDate        #2NDTA                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVE      *BLANKS       #2NDTA                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Clear array for screen 4 and 5
 
     C                   CLEAR                   Scn4Arr
     C                   CLEAR                   Scn5Arr
     C                   EVAL      P#2DVDL = *BLANKS
     C                   EVAL      P#2FTPO = *BLANKS
     C                   EVAL      P#2HGDL = *BLANKS
     C                   EVAL      P#2SECR = *BLANKS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRChkAmdble - Check if a record is amendable or deleteable    *
      *                                                               *
      * Called by: SRValScn1                                          *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRChkAmdble   BEGSR
 
     C                   EVAL      WChkMsgId = *BLANKS
     C                   EVAL      WGotoScn3 =  'Y'
     C                   SELECT
     C                   WHEN      #1STS = WDltTxt and #1SEL = 'D'
     C                             OR #1STS = WDltTxt AND #1SEL = 'A'                         212430
      ** Hedge Linkage &1 has already been deleted
     C                   EVAL      WChkMsgId = 'ASM0109'
     C                   EVAL      WGotoScn3 =  'N'
     C                   WHEN      #1STS = WExpTxt
      ** Hedge Linkage &1 has expired
     C                   EVAL      WChkMsgId = 'ASM0110'
     C                   EVAL      WGotoScn3 =  'N'
     C                   WHEN      #1STS = WDisTxt
      ** Hedge Linkage &1 has been discontinued
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, allow deletion.                           CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'N' OR (CAS004 = 'Y'                              CAS004
     C                             AND #1SEL = 'A')                                           CAS004
     C                   EVAL      WChkMsgId = 'ASM0111'
     C                   EVAL      WGotoScn3 =  'N'
     C                   ENDIF                                                                CAS004
     C                   WHEN      #1STS = WTrdTxt and #1SEL = 'A'
      ** Derivative with No Hedge Items (Trading).
     C                   EVAL      WChkMsgId = 'ASM0112'
     C                   EVAL      WGotoScn3 =  'N'
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRClrMsg - Clear message subfile and data                     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRClrMsg      BEGSR
 
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WFldNamArr
     C                   EVAL      Idx = 0
     C                   EVAL      WIdx = 0
 
      ** Clear message subfile.
 
     C                   CALL      'ZA0250'
 
      ** Reset error indicators
 
     C                   MOVEA     '00000000000' *IN(33)
     C                   MOVEA     '000000000'   *IN(44)
     C                   MOVEA     '000000'      *IN(74)                                      CAS006
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRRtvTxt - Retrieve a message from message file               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRRtvTxt      BEGSR
 
     C                   CALL      'SDRTVTXT'
     C                   PARM                    PMsgId
     C                   PARM                    PMsgFile
     C                   PARM                    PMsgText
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtDate - Convert date from file format to screen format    *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCvtDate     BEGSR
 
      ** Call ZDATE2 to convert date from Midas Dayno. format to
      ** DDMMYY format.
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    PZDayno
     C                   PARM                    BJDFIN
     C                   PARM      *ZEROS        PZDate
     C                   PARM      *BLANKS       PZADate
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCvtAmt  - Convert amount from file format to screen format  *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRCvtAmt      BEGSR
 
 
     C                   CALLB     'ZSEDIT'
 
      ** Field to edit
      ** Decimal places
      ** Edit code ('J', 'L' or ' ')
 
     C                   PARM                    PZFLD15
     C                   PARM                    PZDECS
     C                   PARM      *BLANKS       PZECODE
 
      ** Output
 
     C                   PARM                    PZOUT21
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRZAlign  - Align and validate field                          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRZAlign      BEGSR
 
     C                   CALLB     'ZALIGN'
 
      ** Align OK Flag
      ** Input/output field
      ** Decimal places
      ** Number of digits
 
     C                   PARM      *BLANKS       PZAlignOk
     C                   PARM                    PZFIELD
     C                   PARM                    PZADEC
     C                   PARM                    PZADIG
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDate - Validate date input and convert to day number     *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValDate     BEGSR
 
      ** Call ZDATE1 to validate and convert date to day number
 
     C                   CALLB     'ZDATE1'
     C                   PARM                    PZDateA
     C                   PARM                    PZDayno
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       ErrorFlag
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRWindow  - Window processing                                 *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRWindow      BEGSR
 
     C                   CALL      'WN0010'
     C                   PARM                    PWPgm
     C                   PARM      *BLANKS       PWKey
     C                   PARM                    PWAction
     C                   PARM                    PData
     C                   PARM      *BLANKS       PWRtn
     C                   PARM                    PWSpare
 
      ** Process returned command keys
 
     C                   SELECT
 
      **  If Cmd03 pressed, exit program
 
     C                   WHEN      PWRtn = 'Y2U9999'
     C                   EXSR      SREndP
 
      **  If Cmd12 pressed, or in enquiry, return to initial screen;
 
     C                   WHEN      PWRtn = 'USR0790' or EnquireMode = True
     C                   EXSR      SRInit
 
      **  If return code is window error
 
     C                   WHEN      PWRtn = 'USR0563'
     C                   EXSR      SRInit
     C                   EVAL      MsgIdArr(1) = 'USR0563'
 
      **  If return code is window database update error
 
     C                   WHEN      PWRtn = 'Y2U0004'
     C                   EXSR      SRInit
     C                   EVAL      MsgIdArr(1) = 'USR0567'
 
     C                   OTHER
     C                   IF        EnquireMode = False
     C                   EXSR      SRUpdate
     C                   ENDIF
 
     C                   ENDSL
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRUpdate  - Update master files                               *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** Initialise Standing Data Controls
 
     C                   Z-ADD     *ZERO         WNumRec
     C                   Z-ADD     *ZERO         WNumIns
     C                   Z-ADD     *ZERO         WNumDel
     C                   Z-ADD     *ZERO         WNumAmd
     C                   Z-ADD     *ZERO         WNumRec2
     C                   Z-ADD     *ZERO         WNumIns2
     C                   Z-ADD     *ZERO         WNumDel2
     C                   Z-ADD     *ZERO         WNumAmd2
 
      ** ===========================
      ** Update Hedge Linkage File =
      ** ===========================
 
     C                   SELECT
 
      ** Create a new hedge linkage
      ** --------------------------
 
     C                   WHEN      InsertMode = 'Y'
     C     W#2HEDG       CHAIN     ASHGLKL0                           27
     C                   IF        RecNotFnd = True
     C                   Z-ADD     BJRDNB        U_FSLCD
     C                   EVAL      U_FSCHTP = 'I'
     C                   EVAL      U_FSRECI = 'D'
     C                   EVAL      U_FSHEDI = W#2HEDG
     C                   EVAL      U_FSHGST = W#2HGST
     C                   EVAL      U_FSEFFD = W#2EFFD
     C                   EVAL      U_FSINDT = W#2INDT
     C                   EVAL      U_FSFCOA = W#2FCOA
     C                   EVAL      U_FSICAT = W#2ICAT
     C                   EVAL      U_FSSTDT = W#2STDT
     C                   EVAL      U_FSENDT = W#2ENDT
     C                   EVAL      U_FSDVDL = W#2DVDL
     C                   EVAL      U_FSFTPO = W#2FTPO
     C                   EVAL      U_FSHGDL = W#2HGDL
     C                   EVAL      U_FSSECR = W#2SECR
     C                   IF        CAS006 ='Y'                                                228102
     C                   IF        HSMEFF = 'R'                                               228102
     C                   EVAL      U_FSDTTP = W#2DTTP                                         CAS006
     C                   EVAL      U_FSDPTS = W#2DPTS                                         CAS006
     C                   EVAL      U_FSDFRQ = W#2DFRQ                                         CAS006
     C                   EVAL      U_FSWDAY = W#2WDAY                                         CAS006
     C                   EVAL      U_FSMNTH = W#2MNTH                                         CAS006
     C                   EVAL      U_FSNDTA = W#2NDTA                                         CAS006
     C**********         EVAL      U_FSBDAT = W#2NDTA                                  CAS006 225342
     C                   EVAL      U_FSBDAT = WBDAT1                                          225342
     C                   ELSE                                                                 228102
     C                   EVAL      U_FSDTTP = *BLANKS                                         228102
     C                   EVAL      U_FSDPTS = 0                                               228102
     C                   EVAL      U_FSDFRQ = *BLANKS                                         228102
     C                   EVAL      U_FSWDAY = *BLANKS                                         228102
     C                   EVAL      U_FSMNTH = 0                                               228102
     C                   EVAL      U_FSNDTA = 0                                               228102
     C                   EVAL      U_FSBDAT = 0                                               228102
     C                   ENDIF                                                                228102
     C                   ENDIF                                                                228102
 
     C                   EVAL      U_FSDAMT = 0
     C                   EVAL      U_FSDUPL = 0
     C                   EVAL      U_FSDYPL = 0
     C                   EVAL      U_FSHAMT = 0
     C                   EVAL      U_FSHUPL = 0
     C                   EVAL      U_FSHYPL = 0
     C                   EVAL      U_FSHEFP = 0
     C                   EVAL      U_FSCYCD = *BLANKS
     C                   EVAL      U_FSLASD = 0
     C                   EVAL      U_FSRSQR = *ZEROS                                          CAS006
     C                   EVAL      U_FSTSTA = *ZEROS                                          CAS006
     C                   EVAL      U_FSSLCO = *ZEROS                                          CAS006
     C                   EVAL      U_FSDPTR = *ZEROS                                          CAS006
     C                   EVAL      U_FSAPAF = *BLANKS                                         CAS006
 
     C                   WRITE     ASHGLKUPD
                                                                                              229174
      ** Deallocate the Hedge ID.                                                             229174
                                                                                              229174
     C                   EXSR      SRDHID                                                     229174
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     1             WNumRec
     C                   Z-ADD     1             WNumIns
 
     C                   ELSE
     C                   EXSR      SRInit
      ** Hedge Linkage already exists.
     C                   EVAL      MsgIdArr(1) = 'ASM0113'
     C                   GOTO      ESRUpd
     C                   ENDIF
 
      ** Update an existing hedge linkage
      ** --------------------------------
 
     C                   WHEN      AmendMode = True
     C     W#2HEDG       CHAIN     ASHGLKL0                           27
     C                   IF        MnHGLK = CrHGLK
     C                   IF        BJRDNB <> U_FSLCD
     C                   EVAL      U_FSCHTP = 'A'
     C                   ENDIF
     C                   Z-ADD     BJRDNB        U_FSLCD
     C                   EVAL      U_FSEFFD = W#2EFFD
     C                   EVAL      U_FSFCOA = W#2FCOA
     C                   EVAL      U_FSICAT = W#2ICAT
     C                   EVAL      U_FSSTDT = W#2STDT
     C                   EVAL      U_FSENDT = W#2ENDT
     C                   IF        CAS006 = 'Y'                                               228102
     C                   IF        HSMEFF = 'R'                                               228102
     C                   EVAL      U_FSDTTP = W#2DTTP                                         CAS006
     C                   EVAL      U_FSDPTS = W#2DPTS                                         CAS006
     C                   EVAL      U_FSDFRQ = W#2DFRQ                                         CAS006
     C                   EVAL      U_FSWDAY = W#2WDAY                                         CAS006
     C                   EVAL      U_FSMNTH = W#2MNTH                                         CAS006
     C                   EVAL      U_FSNDTA = W#2NDTA                                         CAS006
     C**********         EVAL      U_FSBDAT = W#2NDTA                                  CAS006 225342
     C                   EVAL      U_FSBDAT = WBDAT1                                          225342
     C                   ELSE                                                                 228102
     C                   EVAL      U_FSDTTP = *BLANKS                                         228102
     C                   EVAL      U_FSDPTS = 0                                               228102
     C                   EVAL      U_FSDFRQ = *BLANKS                                         228102
     C                   EVAL      U_FSWDAY = *BLANKS                                         228102
     C                   EVAL      U_FSMNTH = 0                                               228102
     C                   EVAL      U_FSNDTA = 0                                               228102
     C                   EVAL      U_FSBDAT = 0                                               228102
     C                   ENDIF                                                                228102
     C                   ENDIF                                                                228102
     C                   UPDATE    ASHGLKUPD                            88
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     1             WNumAmd
 
     C                   ELSE
     C                   EXSR      SRInit
      ** The record has been updated by another workstation
     C                   EVAL      MsgIdArr(1) = 'ASM0025'
     C                   GOTO      ESRUpd
     C                   ENDIF
 
      ** Delete an existing hedge linkage
      ** --------------------------------
 
     C                   WHEN      DeleteMode = True and *INKJ = True
     C     W#2HEDG       CHAIN     ASHGLKL0                           27
     C                   IF        MnHGLK = CrHGLK
     C                   Z-ADD     BJRDNB        U_FSLCD
     C                   EVAL      U_FSCHTP = 'D'
     C                   EVAL      U_FSRECI = '*'
 
     C                   UPDATE    ASHGLKUPD                            88
                                                                                              CAS004
      ** If CAS004 is installed and a hedge linkage is deleted, set                           CAS004
      ** the record id's of the hedge transactions to '*',                                    CAS004
      ** the last change date to Rundate and last change type to 'D'.                         CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y' and *IN88 = *OFF                              CAS004
     C     FSHEDI        SETLL     ASHTRNL4                                                   CAS004
     C     FSHEDI        READE     ASHTRNL4                                                   CAS004
                                                                                              CAS004
     C                   DOW       NOT %EOF(ASHTRNL4)                                         CAS004
     C                   EVAL      T4HTID = '*'                                               CAS004
     C                   EVAL      T4HTCT = 'D'                                               CAS004
     C                   EVAL      T4HTCD = BJRDNB                                            CAS004
     C                   UPDATE    ASHTRND4                                                   CAS004
     C                   EVAL      WNumDel2 = WNumDel2 + 1                                    CAS004
                                                                                              CAS004
     C     FSHEDI        READE     ASHTRNL4                                                   CAS004
     C                   ENDDO                                                                CAS004
     C                   ENDIF                                                                CAS004
 
      ** Change Standing Data Controls
 
     C                   Z-ADD     1             WNumDel
 
     C                   ELSE
     C                   EXSR      SRInit
      ** The record has been updated by another workstation
     C                   EVAL      MsgIdArr(1) = 'ASM0025'
     C                   GOTO      ESRUpd
     C                   ENDIF
 
     C                   ENDSL
 
      ** ================================
      ** Update Hedge Transactions File =
      ** ================================
 
      ** For Screen 4
 
     C                   SELECT
 
      ** Derivative Deal
      ** ---------------
 
     C                   WHEN      DerivDeal = True
     C                   EVAL      NoMoreRec = 'N'
     C                   EVAL      Ctr1 = 1
 
      ** Process each record in array
 
     C                   DOW       NoMoreRec = 'N'
     C                   IF        Scn4Arr(Ctr1) = *BLANKS
     C                   EVAL      NoMoreRec = 'Y'
     C                   ELSE
 
      ** Move details from screen 4 array to screen 4 DS
 
     C                   EVAL      Scn4DS = Scn4Arr(Ctr1)
 
      ** Populate Hedge Transaction data structure
 
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'D'
     C                   EVAL      TRMOD  = #2DMOD
     C                   MOVE      #2DDNO        TRDLNO
     C                   EVAL      TRFPSE = #2DFPO
     C                   EVAL      TRBKCD = #2DBKC
     C                   EVAL      TRBRCA = #2BRCA
     C                   EVAL      TRPCAL = #2PCAL
     C                   EVAL      TRBHTV = *BLANKS
     C                   EVAL      TRMKTI = *BLANKS
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 4
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #2DPCT
     C                   EXSR      SRZAlign
     C                   MOVE      PZFIELD       TRPCTG
 
     C     KLIST5        CHAIN     ASHTRNL4                           27
     C                   IF        RecNotFnd = True
     C                   EVAL      ASHTRN4 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'I' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T4HTID = 'D'                                               CAS004
     C                   EVAL      T4HTCT = 'I'                                               CAS004
     C                   EVAL      T4HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              212430
     C                   IF        T4MOD  <> *Blanks and                                      212430
     C                             T4DLNO <> *Zeros                                           212430
     C                   EVAL      T4HSID = WkFSHSID                                          CAS005
     C                   WRITE     ASHTRND4                             88
     C                   ENDIF                                                                212430
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumRec2 = WNumRec2 + 1
     C                   EVAL      WNumIns2 = WNumIns2 + 1
 
     C                   ELSE
     C                   IF        #2ACT = 'D'
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = '*',                      CAS004
      ** Last Change Type = 'D' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T4HTID = '*'                                               CAS004
     C                   EVAL      T4HTCT = 'D'                                               CAS004
     C                   EVAL      T4HTCD = BJRDNB                                            CAS004
     C                   UPDATE    ASHTRND4                                                   CAS004
     C                   ELSE                                                                 CAS004
     C                   DELETE    ASHTRNL4
     C                   ENDIF                                                                CAS004
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumDel2 = WNumDel2 + 1
 
     C                   ELSE
     C                   EVAL      ASHTRN4 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'A' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T4HTID = 'D'                                               CAS004
     C                   EVAL      T4HTCT = 'A'                                               CAS004
     C                   EVAL      T4HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      T4HSID = WkFSHSID                                          CAS005
     C                   UPDATE    ASHTRND4
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumAmd2 = WNumAmd2 + 1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   ENDDO
 
      ** Derivative Futures Position
      ** ---------------------------
 
     C                   WHEN      DrvFutPosGen = True
     C                   EVAL      NoMoreRec = 'N'
     C                   EVAL      Ctr1 = 1
 
      ** Process each record in array
 
     C                   DOW       NoMoreRec = 'N'
     C                   IF        Scn4Arr(Ctr1) = *BLANKS
     C                   EVAL      NoMoreRec = 'Y'
     C                   ELSE
 
      ** Move details from screen 4 array to screen 4 DS
 
     C                   EVAL      Scn4DS = Scn4Arr(Ctr1)
 
      ** Populate Hedge Transaction data structure
 
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'D'
     C                   EVAL      TRMOD  = #2DMOD
     C                   MOVE      #2DDNO        TRDLNO
     C                   EVAL      TRFPSE = #2DFPO
     C                   EVAL      TRBKCD = #2DBKC
     C                   EVAL      TRBRCA = #2BRCA
     C                   EVAL      TRPCAL = #2PCAL
     C                   EVAL      TRBHTV = *BLANKS
     C                   EVAL      TRMKTI = *BLANKS
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 4
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #2DPCT
     C                   EXSR      SRZAlign
     C                   MOVE      PZFIELD       TRPCTG
 
     C     KLIST6        CHAIN     ASHTRNL8                           27
     C                   IF        RecNotFnd = True
     C                   EVAL      ASHTRN8 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'I' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = 'D'                                               CAS004
     C                   EVAL      T8HTCT = 'I'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              212430
     C                   IF        T8MOD  <> *Blanks and                                      212430
     C**********                   T8DLNO <> *Zeros                                    212430 CAS005
     C                             T8FPSE <> *BLANKS                                          212430
     C                   EVAL      T8HSID = WkFSHSID                                          CAS005
     C                   WRITE     ASHTRND8                             88
     C                   ENDIF                                                                212430
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumRec2 = WNumRec2 + 1
     C                   EVAL      WNumIns2 = WNumIns2 + 1
 
     C                   ELSE
     C                   IF        #2ACT = 'D'
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = '*',                      CAS004
      ** Last Change Type = 'D' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = '*'                                               CAS004
     C                   EVAL      T8HTCT = 'D'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   UPDATE    ASHTRND8                                                   CAS004
     C                   ELSE                                                                 CAS004
     C                   DELETE    ASHTRNL8
     C                   ENDIF                                                                CAS004
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumDel2 = WNumDel2 + 1
 
     C                   ELSE
     C                   EVAL      ASHTRN8 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'A' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = 'D'                                               CAS004
     C                   EVAL      T8HTCT = 'A'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      T8HSID = WkFSHSID                                          CAS005
     C                   UPDATE    ASHTRND8
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumAmd2 = WNumAmd2 + 1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   ENDDO
 
     C                   ENDSL
 
      ** For Screen 5
 
     C                   SELECT
 
      ** Hedge Deal/Loan/Forecast Transaction
      ** ------------------------------------
 
     C                   WHEN      HdgDlLnFTrn = True
     C                   EVAL      NoMoreRec = 'N'
     C                   EVAL      Ctr1 = 1
 
      ** Process each record in array
 
     C                   DOW       NoMoreRec = 'N'
     C                   IF        Scn5Arr(Ctr1) = *BLANKS
     C                   EVAL      NoMoreRec = 'Y'
     C                   ELSE
 
      ** Move details from screen 5 array to screen 5 DS
 
     C                   EVAL      Scn5DS = Scn5Arr(Ctr1)
 
      ** Populate Hedge Transaction data structure
 
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'H'
     C                   EVAL      TRMOD  = #3HMOD
     C                   MOVE      #3HDNO        TRDLNO
     C                   EVAL      TRFPSE = #3HSEC
     C                   EVAL      TRBKCD = #3HBKC
     C                   EVAL      TRBRCA = #3BRCA
     C                   EVAL      TRPCAL = *BLANKS
     C                   EVAL      TRBHTV = #3BHTV
     C                   EVAL      TRMKTI = #3MKTI
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 4
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #3HPCT
     C                   EXSR      SRZAlign
     C                   MOVE      PZFIELD       TRPCTG
 
     C     KLIST5        CHAIN     ASHTRNL5                           27
     C                   IF        RecNotFnd = True
     C                   EVAL      ASHTRN5 = ASHTRN
                                                                                             BUG9551
      ** Check if hedging forecast transactions and set the hedge currency                   BUG9551
      ** accordingly. Update hedge linkage record when necessary                             BUG9551
                                                                                             BUG9551
     C                   EXSR      SRSetHECcY                                                BUG9551
                                                                                             BUG9551
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'I' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T5HTID = 'D'                                               CAS004
     C                   EVAL      T5HTCT = 'I'                                               CAS004
     C                   EVAL      T5HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              212430
     C                   IF        T5MOD  <> *Blanks and                                      212430
     C                             T5DLNO <> *Zeros                                           212430
     C                   EVAL      T5HSID = WkFSHSID                                          CAS005
     C                   WRITE     ASHTRND5                             88
     C                   ENDIF                                                                212430
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumRec2 = WNumRec2 + 1
     C                   EVAL      WNumIns2 = WNumIns2 + 1
 
     C                   ELSE
     C                   IF        #3HACT = 'D'
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = '*',                      CAS004
      ** Last Change Type = 'D' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T5HTID = '*'                                               CAS004
     C                   EVAL      T5HTCT = 'D'                                               CAS004
     C                   EVAL      T5HTCD = BJRDNB                                            CAS004
     C                   UPDATE    ASHTRND5                                                   CAS004
     C                   ELSE                                                                 CAS004
     C                   DELETE    ASHTRNL5
     C                   ENDIF                                                                CAS004
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumDel2 = WNumDel2 + 1
 
     C                   ELSE
     C                   EVAL      ASHTRN5 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'A' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T5HTID = 'D'                                               CAS004
     C                   EVAL      T5HTCT = 'A'                                               CAS004
     C                   EVAL      T5HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      T5HSID = WkFSHSID                                          CAS005
     C                   UPDATE    ASHTRND5
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumAmd2 = WNumAmd2 + 1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   ENDDO
 
      ** Hedge Security Reference
      ** ------------------------
 
     C                   WHEN      HdgSecRef = True
     C                   EVAL      NoMoreRec = 'N'
     C                   EVAL      Ctr1 = 1
 
      ** Process each record in array
 
     C                   DOW       NoMoreRec = 'N'
     C                   IF        Scn5Arr(Ctr1) = *BLANKS
     C                   EVAL      NoMoreRec = 'Y'
     C                   ELSE
 
      ** Move details from screen 5 array to screen 5 DS
 
     C                   EVAL      Scn5DS = Scn5Arr(Ctr1)
 
      ** Populate Hedge Transaction data structure
 
     C                   EVAL      TRHEDI = W#2HEDG
     C                   EVAL      TRDHIN = 'H'
     C                   EVAL      TRMOD  = #3HMOD
     C                   MOVE      #3HDNO        TRDLNO
     C                   EVAL      TRFPSE = #3HSEC
     C                   EVAL      TRBKCD = #3HBKC
     C                   EVAL      TRBRCA = #3BRCA
     C                   EVAL      TRPCAL = *BLANKS
     C                   EVAL      TRBHTV = #3BHTV
     C                   EVAL      TRMKTI = #3MKTI
 
     C                   EVAL      PZADEC = 2
     C                   EVAL      PZADIG = 4
     C                   EVAL      PZFIELD = *BLANKS
     C                   EVAL      PZFIELD = #3HPCT
     C                   EXSR      SRZAlign
     C                   MOVE      PZFIELD       TRPCTG
 
     C     KLIST6        CHAIN     ASHTRNL8                           27
     C                   IF        RecNotFnd = True
     C                   EVAL      ASHTRN8 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'I' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = 'D'                                               CAS004
     C                   EVAL      T8HTCT = 'I'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
                                                                                              212430
     C                   IF        T8MOD  <> *Blanks and                                      212430
     C**********                   T8DLNO <> *Zeros                                    212430 CAS005
     C                             T8FPSE <> *BLANKS                                          212430
     C                   EVAL      T8HSID = WkFSHSID                                          CAS005
     C                   WRITE     ASHTRND8                             88
     C                   ENDIF                                                                212430
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumRec2 = WNumRec2 + 1
     C                   EVAL      WNumIns2 = WNumIns2 + 1
 
     C                   ELSE
     C                   IF        #3HACT = 'D'
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = '*',                      CAS004
      ** Last Change Type = 'D' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = '*'                                               CAS004
     C                   EVAL      T8HTCT = 'D'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   UPDATE    ASHTRND8                                                   CAS004
     C                   ELSE                                                                 CAS004
     C                   DELETE    ASHTRNL8
     C                   ENDIF                                                                CAS004
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumDel2 = WNumDel2 + 1
 
     C                   ELSE
     C                   EVAL      ASHTRN8 = ASHTRN
                                                                                              CAS004
      ** If Hedge Accounting (CAS004) is installed, set Record ID = 'D',                      CAS004
      ** Last Change Type = 'A' and Last Change Date = Rundate                                CAS004
                                                                                              CAS004
     C                   IF        CAS004 = 'Y'                                               CAS004
     C                   EVAL      T8HTID = 'D'                                               CAS004
     C                   EVAL      T8HTCT = 'A'                                               CAS004
     C                   EVAL      T8HTCD = BJRDNB                                            CAS004
     C                   ENDIF                                                                CAS004
     C                   EVAL      T8HSID = WkFSHSID                                          CAS005
     C                   UPDATE    ASHTRND8
 
      ** Change Standing Data Controls
 
     C                   EVAL      WNumAmd2 = WNumAmd2 + 1
 
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      Ctr1 = Ctr1 + 1
     C                   ENDDO
 
     C                   ENDSL
 
     C                   IF        EnquireMode = False
     C                   EXSR      SRSDCntrl
     C                   COMMIT
     C                   ENDIF
 
     C     ESRUpd        ENDSR
      *****************************************************************                      BUG9551
      /EJECT                                                                                 BUG9551
      *****************************************************************                      BUG9551
      *                                                               *                      BUG9551
      *  SRSetHECcy - Set Hedge Currency                              *                      BUG9551
      *                                                               *                      BUG9551
      *  Called by: SRUpdate                                          *                      BUG9551
      *                                                               *                      BUG9551
      *  Calls    : None                                              *                      BUG9551
      *                                                               *                      BUG9551
      *****************************************************************                      BUG9551
                                                                                             BUG9551
     C     SRSetHECcy    BEGSR                                                               BUG9551
                                                                                             BUG9551
      ** Retrieve the linkage record                                                         BUG9551
                                                                                             BUG9551
     C     T5HEDI        CHAIN     ASHGLKL0                           27                     BUG9551
                                                                                             BUG9551
     C                   IF        RecNotFnd = FALSE AND U_FSCYCD = *BLANK                   BUG9551
                                                                                             BUG9551
      ** Retrieve the forecast transaction                                                   BUG9551
                                                                                             BUG9551
     C                   IF        T5DHIN = 'H' AND T5MOD = 'FH'                             BUG9551
     C*****T5DLNO        CHAIN     ASFHTRL1                                           BUG9551 CLE148
     C                   MOVEL     T5DLNO        FSDLNO2                                      CLE148
     C     FSDLNO2       CHAIN     ASFHTRL1                                                   CLE148
     C                   IF        NOT %FOUND(ASFHTRL1)                                      BUG9551
     C                   MOVEL     T5DLNO        DBKEY                                       BUG9551
     C                   EVAL      DBFILE =  'ASFHTRL1'                                      BUG9551
     C                   EVAL      DBASE  =  14                                              BUG9551
     C                   EXSR      *PSSR                                                     BUG9551
     C                   ELSE                                                                BUG9551
     C                   EVAL      U_FSCYCD = FCCCY                                          BUG9551
     C                   ENDIF                                                               BUG9551
                                                                                             BUG9551
      ** Non-Forecast Hedging                                                                BUG9551
                                                                                             BUG9551
     C                   ELSE                                                                BUG9551
     C                   EVAL      U_FSCYCD = BJCYCD                                         BUG9551
     C                   ENDIF                                                               BUG9551
     C                   UPDATE    ASHGLKUPD                                                 BUG9551
     C                   ENDIF                                                               BUG9551
                                                                                             BUG9551
     C                   ENDSR                                                               BUG9551
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSDCntrl - Update Standing Data Controls                    *
      *                                                               *
      *  Called by: SRWrite, SRAmend, SRDelete                        *
      *                                                               *
      *  Calls    : None                                              *
      *                                                               *
      *****************************************************************
 
     C     SRSDCntrl     BEGSR
 
      ** Move key fields to @AHREAU for ASHGLKPD
      ** ---------------------------------------
 
     C                   IF        WNumRec <> 0 or WNumIns <> 0 or
     C                             WNumAmd <> 0 or WNumDel <> 0
 
     C                   EVAL      WAHFLNM = *BLANKS
     C                   EVAL      WAHFLNM = 'ASHGLKPD'
 
     C     WAHFLNM       CHAIN     SDFCTLL0                           27
 
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY = 'ASHGLKPD'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 005
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Update SDFCTLPD
 
     C                   EVAL      AHNORC = AHNORC + WNumRec
     C                   EVAL      AHNOIN = AHNOIN + WNumIns
     C                   EVAL      AHNOAM = AHNOAM + WNumAmd
     C                   EVAL      AHNODL = AHNODL + WNumDel
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
     C                   ENDIF
 
      ** Move key fields to @AHREAU for ASHTRNPD
      ** ---------------------------------------
 
     C                   IF        WNumRec2 <> 0 or WNumIns2 <> 0 or
     C                             WNumAmd2 <> 0 or WNumDel2 <> 0
 
     C                   EVAL      WAHFLNM = *BLANKS
     C                   EVAL      WAHFLNM = 'ASHTRNPD'
 
     C     WAHFLNM       CHAIN     SDFCTLL0                           27
 
     C                   IF        RecNotFnd = True
     C                   EVAL      DBKEY = 'ASHTRNPD'
     C                   EVAL      DBFILE = 'SDFCTLPA'
     C                   EVAL      DBASE = 006
     C                   EXSR      *PSSR
 
     C                   ELSE
 
      ** Update SDFCTLPD
 
     C                   EVAL      AHNORC = AHNORC + WNumRec2
     C                   EVAL      AHNOIN = AHNOIN + WNumIns2
     C                   EVAL      AHNOAM = AHNOAM + WNumAmd2
     C                   EVAL      AHNODL = AHNODL + WNumDel2
 
     C                   UPDATE    @AHREAU
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SREndP - End Program                                          *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
      ** Issue rollback to clear any possible updates in window function
 
     C                   IF        BGWDPR = 'Y'
     C                   ROLBK
     C                   ENDIF
                                                                                              229174
     C                   EXSR      SRDHID                                                     229174
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************                       229174
      /EJECT                                                                                  229174
      *****************************************************************                       229174
      *                                                               *                       229174
      * SRDHID - Deallocates Hedge IDs.                               *                       229174
      *                                                               *                       229174
      *****************************************************************                       229174
     C     SRDHID        BEGSR                                                                229174
                                                                                              229174
     C                   EVAL      KAHID = WHEDG                                              229174
     C     KAHID         CHAIN     ASAHIDL0                                                   229174
     C                   IF        %FOUND(ASAHIDL0)                                           229174
     C                   DELETE    ASAHIDD0                                                   229174
     C                   ENDIF                                                                229174
                                                                                              229174
     C                   ENDSR                                                                229174
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSndMsg - Send message to subfile                            *
      *                                                               *
      * Called by:                                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRSndMsg      BEGSR
 
      ** Send message to subfile
 
     C                   EVAL      Idx = 1
     C                   DOW       MsgIdArr(Idx) <> *BLANKS
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFileZ
     C                   PARM      MsgIdArr(Idx) PMsgIdZ
     C                   PARM      MsgDtaArr(Idx)PMsgDataZ
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   EVAL      Idx = 1
     C                   DOW       WMsgIdArr(Idx) <> *BLANKS
     C                   CALL      'ZA0350'
     C                   PARM                    PMsgFileZ
     C                   PARM      WMsgIdArr(Idx)PMsgIdZ
     C                   PARM      *BLANKS       PMsgDataZ
     C                   EVAL      Idx = Idx + 1
     C                   ENDDO
 
     C                   ENDSR
      *****************************************************************
      /EJECT
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
 
     C     *ENTRY        PLIST
 
      ** Input
      ** ======
      ** Return Code
      ** Run Mode
      **  'ENQ' - Enquiry
      **  'MNT' - Maintenance
      **  'SEL' - Selection
      ** Selected Hedge ID
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PRunMode
     C                   PARM                    PHedgeId
 
     C                   SELECT
     C                   WHEN      PRunMode = 'ENQ'
     C                   EVAL      EnquireMode = True
     C                   WHEN      PRunMode = 'MNT'
     C                   EVAL      MntMode     = True
     C                   WHEN      PRunMode = 'SEL'
     C                   EVAL      SelMode  = True
     C                   ENDSL
 
      ** Access Bank Details
 
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDBANKPD'
     C                   EVAL      DBASE  =  001
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Module Details
 
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDMMODPD'
     C                   EVAL      DBASE  =  002
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Access Midas SD Hedging ICD File
 
     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBASE  =  003
     C                   EXSR      *PSSR
     C                   ENDIF
 
 
      ** Access Securities Trading ICD
 
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDSTRD        PARM      SDSTRD        DSSDY
 
      ** Database Error
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      DBKEY  =  @Optn
     C                   EVAL      DBFILE =  'SDSTRDPD'
     C                   EVAL      DBASE  =  004
     C                   EXSR      *PSSR
     C                   ENDIF
 
      ** Check if CAS003 is installed                                                         CAS003
                                                                                              CAS003
     C                   EVAL      CAS003 = 'N'                                               CAS003
     C                   CALL      'AOSARDR0'                                                 CAS003
     C                   PARM      *Blanks       @RtCd                                        CAS003
     C                   PARM      '*VERIFY'     @Optn                                        CAS003
     C                   PARM      'CAS003'      @SARD                                        CAS003
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS003
                                                                                              CAS003
     C                   IF        @RtCd = *Blanks                                            CAS003
     C                   EVAL      CAS003 = 'Y'                                               CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Database error.                                                                      CAS003
                                                                                              CAS003
     C                   IF        @RtCd <> *BLANKS  AND                                      CAS003
     C                             @RtCd <> '*NRF   '                                         CAS003
     C                   EVAL      DBKEY = @SARD                                              CAS003
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS003
     C                   EVAL      DBASE  =  007                                              CAS003
     C                   EXSR      *PSSR                                                      CAS003
     C                   ENDIF                                                                CAS003
                                                                                              CAS003
      ** Check if CAS004 is installed                                                         CAS004
                                                                                              CAS004
     C                   EVAL      CAS004 = 'N'                                               CAS004
     C                   CALL      'AOSARDR0'                                                 CAS004
     C                   PARM      *Blanks       @RtCd                                        CAS004
     C                   PARM      '*VERIFY'     @Optn                                        CAS004
     C                   PARM      'CAS004'      @SARD                                        CAS004
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS004
                                                                                              CAS004
     C                   IF        @RtCd = *Blanks                                            CAS004
     C                   EVAL      CAS004 = 'Y'                                               CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Database error                                                                       CAS004
                                                                                              CAS004
     C                   IF        @RtCd <> *BLANKS  AND                                      CAS004
     C                             @RtCd <> '*NRF   '                                         CAS004
     C                   EVAL      DBKEY = @SARD                                              CAS004
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS004
     C                   EVAL      DBASE  =  008                                              CAS004
     C                   EXSR      *PSSR                                                      CAS004
     C                   ENDIF                                                                CAS004
                                                                                              CAS004
      ** Check if CAS006 is installed                                                         CAS006
                                                                                              CAS006
     C                   EVAL      *IN53 = *OFF                                               CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   CALL      'AOSARDR0'                                                 CAS006
     C                   PARM      *Blanks       @RtCd                                        CAS006
     C                   PARM      '*VERIFY'     @Optn                                        CAS006
     C                   PARM      'CAS006'      @SARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        @RtCd = *Blanks                                            CAS006
     C                   EVAL      *IN53 = *ON                                                CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Database error                                                                       CAS006
                                                                                              CAS006
     C                   IF        @RtCd <> *BLANKS  AND                                      CAS006
     C                             @RtCd <> '*NRF   '                                         CAS006
     C                   EVAL      DBKEY = @SARD                                              CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBASE  =  010                                              CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS007
      ** Check if CAS007 is installed                                                         CAS007
                                                                                              CAS007
     C                   CALL      'AOSARDR0'                                                 CAS007
     C                   PARM      *Blanks       @RTCD                                        CAS007
     C                   PARM      '*VERIFY'     @OPTN                                        CAS007
     C                   PARM      'CAS007'      @SARD                                        CAS007
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS007
                                                                                              CAS007
     C                   IF        @RTCD = '*NRF   '                                          CAS007
     C                   EVAL      *INLR = *ON                                                CAS007
     C                   RETURN                                                               CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS007
      ** Database error                                                                       CAS007
                                                                                              CAS007
     C                   IF        @RTCD <> *BLANKS  AND                                      CAS007
     C                             @RTCD <> '*NRF   '                                         CAS007
     C                   EVAL      DBKEY = @SARD                                              CAS007
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS007
     C                   EVAL      DBASE  =  012                                              CAS007
     C                   EXSR      *PSSR                                                      CAS007
     C                   ENDIF                                                                CAS007
                                                                                              CAS008
     C                   EVAL      CAS008 = 'N'                                               CAS008
     C                   CALL      'AOSARDR0'                                                 CAS008
     C                   PARM      *Blanks       @RtCd                                        CAS008
     C                   PARM      '*VERIFY'     @Optn                                        CAS008
     C                   PARM      'CAS008'      @SARD                                        CAS008
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS008
                                                                                              CAS008
     C                   IF        @RtCd = *Blanks                                            CAS008
     C                   EVAL      CAS008 = 'Y'                                               CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS008
      ** Database error.                                                                      CAS008
                                                                                              CAS008
     C                   IF        @RtCd <> *BLANKS  AND                                      CAS008
     C                             @RtCd <> '*NRF   '                                         CAS008
     C                   EVAL      DBKEY = @SARD                                              CAS008
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS008
     C                   EVAL      DBASE  =  013                                              CAS008
     C                   EXSR      *PSSR                                                      CAS008
     C                   ENDIF                                                                CAS008
                                                                                              CAS006
      ** Initialize Numeric Fields                                                            CAS004
                                                                                              CAS004
     C                   EVAL      TRHTCD = 0                                                 CAS004
     C                   EVAL      T4HTCD = 0                                                 CAS004
     C                   EVAL      T5HTCD = 0                                                 CAS004
     C                   EVAL      T8HTCD = 0                                                 CAS004
     C                   EVAL      TREFVP = 0                                                 CAS004
     C                   EVAL      TRHECP = 0                                                 CAS004
     C                   EVAL      TRHXFP = 0                                                 CAS004
     C                   EVAL      TRHXCP = 0                                                 CAS004
     C                   EVAL      TRHTFP = 0                                                 CAS005
     C                   EVAL      TRHTCP = 0                                                 CAS005
                                                                                              CAS004
      ** Check if Dealing Module is on
 
     C                   EVAL      DLModOn = 'N'
     C                   IF        BGSWDL = 'Y' or BGDLFX = 'Y' or
     C                             BGBDLI = 'Y' or BGMTDL = 'Y' or
     C                             BGDLMM = 'Y' or BGCHDL = 'Y'
     C                   EVAL      DLModOn = 'Y'
     C                   ENDIF
 
      ** Check if Lending Module is on
 
     C                   EVAL      LEModOn = 'N'
     C                   IF        BGSWCL = 'Y' or BGCSLN = 'Y' or
     C                             BGMTCL = 'Y' or BGLMCR = 'Y' or
     C                             BGCHLN = 'Y'
     C                   EVAL      LEModOn = 'Y'
     C                   ENDIF
 
      ** Check if Futures and Options Module is on
 
     C                   EVAL      FFModOn = 'N'
     C                   IF        BGFUOP = 'Y'
     C                   EVAL      FFModOn = 'Y'
     C                   ENDIF
 
      ** Check if Securities Module is on
 
     C                   EVAL      SEModOn = 'N'
     C                   IF        BGSWST = 'Y' or BGSECS = 'Y'
     C                   EVAL      SEModOn = 'Y'
     C                   ENDIF
 
      ** Move workstation ID to screen field.
 
     C                   EVAL      #1USER = PSUser
     C                   EVAL      #1WSID = PSJobName
     C                   EVAL      #1RUNA = BJMRDT
 
      ** Set up constant parameters for sending/clearing messages
 
     C                   EVAL      PZMsgPgm = PSProcPgm
     C                   EVAL      PZMsgMod = PSProcMod
     C                   EVAL      PZMsgProc = PSProcName
 
      ** Set up the prime and secondary message files for
      ** finding message IDs.
 
     C                   EVAL      #MsgFile     = 'SDUSRMSG'
     C                   EVAL      MsgFArray(1) = 'DRSMM'
     C                   EVAL      MsgFArray(2) = 'MEMSG'
 
      ** Message subfile control and program queue initialisation.
 
     C                   EVAL      MsgSFleEnd = True
     C                   EVAL      #4PGMQ = '*'
 
      ***Klist*for*logical*file*ASHTRNL1************************************                  CAS004
      ** Klist for logical file ASHTRNLB                                                      CAS004
 
     C     KLIST1        KLIST
     C                   KFLD                    KHEDI2            6 0
     C                   KFLD                    KDHIN2            1
 
 
      ** Klist for logical file POSTNK5
 
     C     KLIST2        KLIST
     C                   KFLD                    #2BRCA
     C                   KFLD                    #2DBKC
     C                   KFLD                    WInsTp
     C                   KFLD                    KMthNum           2 0
     C                   KFLD                    KYrNum            2 0
     C                   KFLD                    #2PCAL
 
      ** Klist for logical file ASHTRNL2
 
     C     KLIST3        KLIST
     C                   KFLD                    KDHIN2
     C**********         KFLD                    KFSDLNO           6 0                        CLE148
     C                   KFLD                    KFSDLNO           6                          CLE148
     C                   KFLD                    KFSFPSE          10
     C                   KFLD                    KFSBKCD           2
     C                   KFLD                    KFSBRCA           3
     C                   KFLD                    KFSPCAL           1
     C                   KFLD                    KFSMKTI           1
     C                   KFLD                    KFSBHTV           1
 
      ** Klist for logical file BKPHD
 
     C     KLIST4        KLIST
     C                   KFLD                    #3HSEC
     C                   KFLD                    #3BRCA
     C                   KFLD                    #3HBKC
     C                   KFLD                    WkMKTI            1
     C                   KFLD                    WkBHTV            1
 
      ** Klist for logical file ASHTRNL4 and ASHTRNL5
 
     C     KLIST5        KLIST
     C                   KFLD                    TRHEDI
     C                   KFLD                    TRDHIN
     C                   KFLD                    TRDLNO
     C                   KFLD                    TRFPSE
 
      ** Klist for logical file ASHTRNL8
 
     C     KLIST6        KLIST
     C                   KFLD                    TRHEDI
     C                   KFLD                    TRDHIN
     C                   KFLD                    TRDLNO
     C                   KFLD                    TRFPSE
     C                   KFLD                    TRBKCD
     C                   KFLD                    TRBRCA
     C                   KFLD                    TRPCAL
     C                   KFLD                    TRMKTI
     C                   KFLD                    TRBHTV
                                                                                              CAS004
     C     KLIST7        KLIST                                                                CAS004
     C                   KFLD                    TRMOD                                        CAS004
     C                   KFLD                    TRDLNO                                       CAS004
 
     C     KAshTrn1      KLIST                                                                CAS006
     C                   KFLD                    KFSHEDI                                      CAS006
     C                   KFLD                    KFSDHIN                                      CAS006
                                                                                              CAS006
     C     KAshTrn2      KLIST                                                                CAS006
     C                   KFLD                    KFSHEDI                                      CAS006
     C                   KFLD                    KFSDHIN                                      CAS006
     C                   KFLD                    KFSDLNO                                      CAS006
     C                   KFLD                    KFSHTID                                      CAS006
                                                                                              CAS006
      ** Key List for Midas SD T Distribution Table                                           CAS006
                                                                                              CAS006
     C     KSdtdtb       KLIST                                                                CAS006
     C                   KFLD                    KXXDfrd                                      CAS006
     C                   KFLD                    KXXArea                                      CAS006
                                                                                              CAS006
      ** Klist for logical file ASHTRNL3                                                      CAS006
                                                                                              CAS006
     C     KlistG        KLIST                                                                CAS006
     C                   KFLD                    KGDHIn                                       CAS006
     C                   KFLD                    KGDlNo                                       CAS006
     C                   KFLD                    KGSecu                                       CAS006
     C                   KFLD                    KGBook                                       CAS006
     C                   KFLD                    KGBrch                                       CAS006
     C                   KFLD                    KGPCal                                       CAS006
     C                   KFLD                    KGMktI                                       CAS006
     C                   KFLD                    KGTVDt                                       CAS006
                                                                                              CAS006
     C                   EVAL      InitFlag = 'Y'
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Finastra International Limited 2002
