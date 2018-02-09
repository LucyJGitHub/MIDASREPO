     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - non securities')     *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEDTA - Work with Extract Data (Non-Securities)          *
      *                                                               *
      *  Function:  This module receives details of all transactions  *
      *             except those from the Securities Trading module.  *
      *             These are received with an opening balance and    *
      *             with all events. At this stage, these are simply  *
      *             stored in arrays until called in processing       *
      *             mode, at which point all period end positions     *
      *             and cash flows are calculated. The module may     *
      *             then be called to return all transactions, all    *
      *             positions, all events and all cash flows.         *
      *                                                               *
      *  Component of: DEPXTACCT, DEPXTCFCO, DEPXTFRAS, DEPXTFXDL,    *
      *                DEPXTLDNI, DEPXTLOAN, DEPXTNASP, DEPXTOTCC,    *
      *                DEPXTSWAP                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 CLE031             Date 14Aug03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 15Apr03               *
      *                 CDE005             Date 21Aug02               *
      *                 213481             Date 31Jan03               *
      *                 212721             Date 11Dec02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      *                 198416             Date 30Sep01               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 210600             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A.       *
      *           Produce a cashflow record for each settlement       *
      *           allocation.                                         *
      *  CLE031 - Lending Enhancements.                               *
      *  219833 - Don't produce records for backvalued transactions.  *
      *  216909 - Get number of decimal places of the base ccy.       *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  213481 - Do not check for INVALID MATURITY DATE if module is *
      *           Funds Transfer (FT).                                *
      *  212721 - Loan capitalized interest differences in Revenue    *
      *  CDE003 - Data Export - MCR Limits Phase II                   *
      *           - Reverse out SC210600.                             *
      *  208221 - Changed to use different length arrays depending on *
      *           member type being processed.                        *
      *           Calculate total number of repayments                *
      *           Enable DEWRKEDTA to get info from data area         *
      *           Calculate total number of repayments                *
      *  198416 - Turnover for non-int bearing deals should be on     *
      *           deal date.                                          *
      *  210600 - Revenue problem if last day accruals                *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CDE001 - Data Export - CCRM Limits.                          *
      *                                                               *
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
     D/COPY DECPYSRC,DEXTFILA
     D/COPY DECPYSRC,DEXTFILS
     D/COPY DECPYSRC,DEEVDARRS
 
 
      ** EVENT TYPES/SEQUENCES
     D*TABTYP**********S**************2****DIM(16) CTDATA PERRCD(1)                           CDE002
     D*TABSEQ**********S**************2**0*DIM(16) ALT(TABTYP)                                CDE002
     D TABTYP          S              2    DIM(17) CTDATA PERRCD(1)                           CDE002
     D TABSEQ          S              2  0 DIM(17) ALT(TABTYP)                                CDE002
                                                                                              208221
      ** MEMBER TYPES/DATA AREA POSITIONS                                                     208221
     D MEMTYP          S              5    DIM(21) CTDATA PERRCD(11)                          208221
                                                                                              208221
     D DEEXTCTL      E DS                  EXTNAME(DEEXTCTL)                                  208221
      ** Extract Control Data                                                                 208221
     D   ARRAY                77     97                                                       208221
                                                                                              208221
     D POS             S              2  0                                                    208221
     D LongArr         S              1                                                       208221
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CDE002
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                                  216909
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE034
      ** External data structures for Switchable Features File                                CLE034
     D LESTAL        E DS                  EXTNAME(LESTALPD) PREFIX(ST)                       CLE034
      ** External data structures for Settlement Allocation File                              CLE034
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CLE034
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * NOTES ON DATES:
 
      **If*in*'HISTORIC'*mode******                                                           CDE002
      **---------------------******                                                           CDE002
      **I*******I*******I*******I**     I       I       I       I       I                     CDE002
      ******[**********************         [                       [                         CDE002
      ******!**********************         !                       !                         CDE002
      ***History*******************        Run                   Date of                      CDE002
      ***Cut-Off*******************        Date                    Next                       CDE002
      ****Date*********************      =Extract                Working                      CDE002
      *****************************        Date                    Day                        CDE002
      *****************************                                                           CDE002
      **If*in*'PROJECTED'*mode*:*End of BOOK = 'Y'                                            CDE002
      **------------------------------------------                                            CDE002
      **I*******I*******I*******I**     I       I       I       I       I                     CDE002
      ******[***************[****** [                               [                         CDE002
      ******!***************!****** !                               !                         CDE002
      *****Run************Event**Date of                         Projections                  CDE002
      *****Date**********Control***Next                           Cut-Off                     CDE002
      **=Extract***********Date**Working                           Date                       CDE002
      *****Date********************Day                                                        CDE002
      * I       I       I       I       I       I       I       I       I                     CDE002
      *     [                               [       [               [                         CDE002
      *     !                               !       !               !                         CDE002
      *  History                            Run    Event        Projections                   CDE002
      *  Cut-Off                           Date    Control       Cut-Off                      CDE002
      *   Date                                     Date           Date                        CDE002
      *                                                                                       CDE002
                                                                                              CDE002
 
 
      **
      **   ENTRY PARAMETER LIST
      **
     C     *ENTRY        PLIST
     C                   PARM                    Ret_Code          7
     C                   PARM                    Err_Mess         30
     C                   PARM                    Mode_of_Op       10
     C                   PARM                    Proj_Hist         1
     C                   PARM                    EndofBook         1
     C                   PARM                    Run_Date          5 0
     C                   PARM                    Date_NWD          5 0
     C                   PARM                    HistCO_Dat        5 0
     C*******************PARM********************Extrct_Dat        5 0                        CDE002
     C                   PARM                    EvtCtl_Dat        5 0
     C                   PARM                    ProjCO_Dat        5 0
      * TRANSACTION
     C                   PARM                    T#TRAN
      * POSITION
     C                   PARM                    P#POSN
      * EVENT
     C                   PARM                    E#EVNT
      * CASHFLOW
     C                   PARM                    C#CASH
      * SDBANK
     C                   PARM                    SDBANK
      * SDGELR                                                                                CDE002
     C                   PARM                    SDGELR                                       CDE002
     C                   PARM                    Dataarea        128                          208221
     C                   PARM                    MemberType        5                          208221
     C*                                                                                       208221
     C                   MOVEL     Dataarea      DEEXTCTL                                     208221
     C                   MOVEL     MemberType    TESTFRST          1                          208221
     C     TESTFRST      IFEQ      'G'                                                        208221
     C                   MOVE      MemberType    TESTEND           4                          208221
     C                   EVAL      MemberType = 'P' + TESTEND                                 208221
     C                   ENDIF                                                                208221
     C                   Z-ADD     1             POS                                          208221
     C     MemberType    LOOKUP    MEMTYP(POS)                            60                  208221
     C                   IF        *IN60                                                      208221
     C                   EVAL      LongArr = %subst(ARRAY:POS:1)                              208221
     C                   ENDIF                                                                208221
      *
      * IMPORT TRANSACTION DETAILS
      *
     C                   SELECT
     C     Mode_of_Op    WHENEQ    '*IMPTRAN'
      *
     C                   EXSR      IMP_TRAN
      *
      * IMPORT OPENING BALANCE
      *
     C     Mode_of_Op    WHENEQ    '*IMPOPBL'
      *
     C                   EXSR      IMP_OPBL
      *
      * IMPORT AN EVENT
      *
     C     Mode_of_Op    WHENEQ    '*IMPEVNT'
      *
     C                   EXSR      IMP_EVNT
      *
      * PROCESS IMPORTED EVENTS
      *
     C     Mode_of_Op    WHENEQ    '*PROCSIM'
      *
     C                   EXSR      VAL_EVNTS
     C                   EXSR      RED_EVNTS
      *
      * EXPORT TRANSACTION
      *
     C     Mode_of_Op    WHENEQ    '*EXPTRAN'
      *
     C                   EXSR      EXP_TRAN
      *
      * EXPORT POSITIONS
      *
     C     Mode_of_Op    WHENEQ    '*EXPPOSN'
      *
     C                   EXSR      EXP_POSN
      *
      * EXPORT EVENTS
      *
     C     Mode_of_Op    WHENEQ    '*EXPEVNT'
      *
     C                   EXSR      EXP_EVNT
      *
      * EXPORT CASHFLOWS
      *
     C     Mode_of_Op    WHENEQ    '*EXPCASH'
      *
     C                   EXSR      EXP_CASH
      *
     C                   ENDSL
      *
      * RETURN
     C                   RETURN
 
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** IMPORT TRANSACTION DETAILS
      *********************************************************************
     C     IMP_TRAN      BEGSR
 
      ** Generate a timestamp for this transaction
 
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    T#TMST
 
      ** Get risk customer details
 
     C                   MOVEL     T#RCST        @KEY1
     C                   CALLB     'AOCUSTR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @KEY1            10
     C                   PARM      *BLANKS       @KYST             7
     C     SDCUST        PARM      SDCUST        DSSDY
     C     @RTCD         IFNE      *BLANK
     C     @KYST         OREQ      '*ERROR'
     C                   CLEAR                   SDCUST
     C                   ENDIF
      *
      * Default industry
     C     T#LICD        IFEQ      *BLANK
     C                   MOVEL     BBLICD        T#LICD
     C                   ENDIF
      *
      * Default country
     C     T#CNCD        IFEQ      *BLANK
     C                   MOVEL     BBCOLC        T#CNCD
     C                   ENDIF
                                                                                              CDE002
      * Deal date can't be in the future                                                      CDE002
                                                                                              CDE002
     C     T#DDAT        IFGT      Run_Date                                                   CDE002
     C                   EVAL      Err_Mess = 'DEAL DATE INVALID'                             CDE002
     C                   EXSR      *PSSR                                                      CDE002
     C                   ENDIF                                                                CDE002
 
     C                   MOVEL     T#TRAN        #_tran(1)
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** IMPORT OPENING BALANCE
      *********************************************************************
     C     IMP_OPBL      BEGSR
      *
      **   INITIALIZE WORK FIELDS
      **   ----------------------
      *
      ** POSITION TYPE
      *
     C                   MOVEL     *BLANK        P#PSTP
      *
      ** SET THE INITIAL INTEREST ACCRUAL CONTROL DATE
      ** (IT CAN'T BE ZERO)
      *
     C                   Z-ADD     P#IACD        I_P#IACD          5 0
     C     I_P#IACD      IFEQ      *ZERO
     C                   EVAL      Err_Mess = 'INT. ACCRUAL DATE INVALID'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *
      ** CALCULATE SPOT DATE FOR CURRENCY
      *
     C                   EXSR      CAL_SPDT
      *
      ** INITIALIZE PREVIOUS (EVENT) DATE
      *
     C                   Z-ADD     *ZERO         P@PRDT            5 0
      *
      ** ZEROIZE IMPORTED AND EXPORTED EVENT ARRAY POINTER
      ** AND CLEAR EVENT ARRAY
      *
     C                   Z-ADD     *ZERO         IMevnt            5 0
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C     FilArrSiz     ADD       1             EXevnt            5 0
     C                   CLEAR                   #_evnt
     C     LongArr       WHENEQ    'L'                                          208221
     C     FilArrLng     ADD       1             EXevnt            5 0          208221
     C                   CLEAR                   #_evtL                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C     FilArrSht     ADD       1             EXevnt            5 0          208221
     C                   CLEAR                   #_evtS                         208221
     C                   ENDSL                                                  208221
      *
      ** CLEAR DATE AND DATA ARRAYS
      *
     C                   CLEAR                   #_ipdat
     C                   CLEAR                   #_ipdta
     C                   CLEAR                   #_irdat
     C                   CLEAR                   #_irdta
      *
      ** ZEROIZE IMPORTED AND EXPORTED POSITION ARRAY POINTER
      ** AND CLEAR POSITION ARRAY
      *
     C                   Z-ADD     *ZERO         IMposn            5 0
     C                   Z-ADD     *ZERO         EXposn            5 0
     C                   CLEAR                   #_posn
     C                   CLEAR                   #_posL                         208221
     C                   CLEAR                   #_posS                         208221
      *
      ** ZEROIZE IMPORTED AND EXPORTED CASFLOW ARRAY POINTER
      ** AND CLEAR CASHFLOW ARRAY
      *
     C                   Z-ADD     *ZERO         IMcash            5 0
     C                   Z-ADD     *ZERO         EXcash            5 0
     C                   CLEAR                   #_cash
     C                   CLEAR                   #_cshL                         208221
     C                   CLEAR                   #_cshS                         208221
      *
      ** RESET CURRENT INTEREST DUE
      *
     C                   Z-ADD     *ZERO         Int_Due          15 0
     C                   Z-ADD     *ZERO         Fee_Acc          15 0                        CLE031
      *
      ** RESET NEXT CASH PAYMENT DATE
      *
     C                   Z-ADD     *ZERO         NxtCashDt         5 0
      *
      ** RESET 'VALUE DATE PROCESSED', 'MATURITY DATE PROCESSED'
      ** AND 'CURRENT POSITION PROCESSED' INDICATORS
      *
     C                   MOVEL     *BLANK        ValDat_P          1
     C                   MOVEL     *BLANK        MatDat_P          1
     C                   MOVEL     *BLANK        CurPos_P          1
      *                                                                                       CDE002
      ** STORE OPENING POSITION IF PROJECTED EXTRACT NOT TO END OF BOOK                       CDE002
      *                                                                                       CDE002
     C     Proj_Hist     IFEQ      'P'                                                        CDE002
     C     EndofBook     ANDEQ     'N'                                                        CDE002
     C                   ADD       1             IMposn                                       CDE002
     C                   SELECT                                                               208221
     C     LongArr       WHENEQ    *BLANKS                                                    208221
     C                   MOVEL     P#POSN        #_posn(IMposn)                               CDE002
     C     LongArr       WHENEQ    'L'                                                        208221
     C                   MOVEL     P#POSN        #_posL(IMposn)                               208221
     C     LongArr       WHENEQ    'S'                                                        208221
     C                   MOVEL     P#POSN        #_posS(IMposn)                               208221
     C                   ENDSL                                                                208221
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   MOVEL     P#POSN        P_P#POSN                                     CDE002
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** IMPORT EVENT
      *********************************************************************
     C     IMP_EVNT      BEGSR
      *
      * CHECK THAT EVENT TYPE IS VALID
      *
     C     E#EVTP        LOOKUP    TABTYP        TABSEQ                   99
     C     *IN99         IFEQ      '0'
     C                   EVAL      Err_Mess = 'EVENT TYPE IS INVALID'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * SET PROCESSING SEQUENCE IF NEEDED
      *
     C     E#PRSQ        IFEQ      *ZERO
     C                   MOVEL     TABSEQ        E#PRSQ
     C                   ENDIF
      *
      * CHECK THAT PROCESSING DATE IS VALID
      *
     C     E#PRDT        IFLE      *ZERO
     C                   EVAL      Err_Mess = 'PROCESSING DATE IS INVALID'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * SET NUMBER OF CURRENCY DECIMAL PLACES
      *
     C     E#CCY         IFEQ      *BLANK
     C                   Z-ADD     P#NCDP        E#NCDP
     C                   Z-ADD     P#NMDP        E#NMDP
     C     Proj_Hist     IFEQ      'P'                                                        CDE002
     C     EndofBook     ANDEQ     'N'                                                        CDE002
     C     Proj_Hist     OREQ      'H'                                                        CDE002
     C                   MOVEL     P#CCY         E#CCY                                        CDE002
     C                   ENDIF                                                                CDE002
     C                   ENDIF
      *
      * UPDATE EVENT ARRAY
      *
     C                   ADD       1             IMevnt            5 0
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     E#EVNT        #_evnt(IMevnt)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     E#EVNT        #_evtL(IMevnt)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     E#EVNT        #_evtS(IMevnt)                 208221
     C                   ENDSL                                                  208221
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** VALIDATE EVENTS (AS READ INTO EVENTS ARRAY)
      *********************************************************************
     C     VAL_EVNTS     BEGSR
      *
      * '*IMPOPBL' NEVER INVOKED
      *
     C     IMevnt        IFEQ      *ZERO
     C                   EVAL      Err_Mess = '*IMPOPBL NEVER INVOKED'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * SORT EVENTS
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   SORTA     #_evnt
     C     LongArr       WHENEQ    'L'                                          208221
     C                   SORTA     #_evtL                                       208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   SORTA     #_evtS                                       208221
     C                   ENDSL                                                  208221
      *
      * READ FIRST EVENT
      *
     C                   Z-ADD     1             VLevnt            5 0
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C     *BLANK        LOOKUP    #_evnt(VLevnt)                     99           *
     C     LongArr       WHENEQ    'L'                                          208221
     C     *BLANK        LOOKUP    #_evtL(VLevnt)                     99        208221
     C     LongArr       WHENEQ    'S'                                          208221
     C     *BLANK        LOOKUP    #_evtS(VLevnt)                     99        208221
     C                   ENDSL                                                  208221
      *
      * NO EVENT, SO '*IMPEVNT' NEVER INVOKED
      *
     C     *IN99         IFEQ      '0'
     C                   EVAL      Err_Mess = '*IMPEVNT NEVER INVOKED'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * READ ALL EVENTS
      *
     C*****VLevnt        DOWLE     FilArrSiz                                    208221
     C     LongArr       DOWEQ     *BLANKS                                      208221
     C     VLevnt        ANDLE     FilArrSiz                                    208221
     C     LongArr       OREQ      'L'                                          208221
     C     VLevnt        ANDLE     FilArrLng                                    208221
     C     LongArr       OREQ      'S'                                          208221
     C     VLevnt        ANDLE     FilArrSht                                    208221
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     #_evnt(VLevnt)E#EVNT
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     #_evtL(VLevnt)E#EVNT                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     #_evtS(VLevnt)E#EVNT                         208221
     C                   ENDSL                                                  208221
      *
      * CHECK THAT IF THERE IS A MATURITY EVENT
      * IT HAS A DATE >= THE INTEREST ACCRUAL CONTROL DATE
      *
     C     E#EVTP        IFEQ      'MT'
     C     E#PRDT        ANDLT     P#IACD
     C     E#MOD         ANDNE     'FT'                                                       213481
     C                   EVAL      Err_Mess = 'INVALID MATURITY DATE EVENT'
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      * IF EVENT IS AN INTEREST PAYMENT DATE
      * OR IF EVENT IS A MATURITY DATE
      * LOG DATE IN INTEREST PAYMENT DATES ARRAY
      *
     C     E#EVTP        IFEQ      'IP'
     C     E#EVTP        OREQ      'MT'
      *
      ** IF FIRST INTEREST PAYMENT DATE > INTEREST ACCRUAL CONTROL DATE
      **   SET INTEREST PAYMENT DATE #1 = INTEREST ACCRUAL CONTROL DATE
      *
     C     #_ipdat(1)    IFEQ      *ZERO
     C     E#PRDT        ANDGT     P#IACD
     C                   Z-ADD     P#IACD        #_ipdat(1)
     C                   ENDIF
 
     C                   MOVEL     'IP'          W#TYPE
     C                   MOVEL     #arevdt_ip    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ip
     C                   ENDIF
      *
      * IF EVENT IS A RATE CHANGE DATE
      * OR IF EVENT IS A MATURITY DATE
      * LOG DATE IN INTEREST RATE CHANGE DATES ARRAY
      *
     C     E#EVTP        IFEQ      'SC'
     C     E#EVTP        OREQ      'BC'
     C     E#EVTP        OREQ      'RO'
     C     E#EVTP        OREQ      'MT'
      *
      ** IF FIRST INTEREST RATE CHANGE DATE > INTEREST ACCRUAL CONTROL DATE
      **   SET INTEREST RATE CHANGE DATE #1 = INTEREST ACCRUAL CONTROL DATE
      *
     C     #_irdat(1)    IFEQ      *ZERO
     C     E#PRDT        ANDGT     P#IACD
     C                   Z-ADD     P#IACD        #_irdat(1)
     C                   ENDIF
 
     C                   MOVEL     'IR'          W#TYPE
     C                   MOVEL     #arevdt_ir    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ir
     C                   ENDIF
      *
      * IF THIS IS A PROJECTED EXTRACT
      * TO END OF BOOK                                                                        CDE002
      * AND THE EVENT DATE IS AFTER THE PROJECTIONS CUT-OFF DATE
      * OR THIS IS A PROJECTED EXTRACT                                                        CDE002
      * NOT TO END OF BOOK                                                                    CDE002
      * AND THE EVENT DATE IS AFTER THE EVENT CONTROL DATE                                    CDE002
      * OR THIS IS A PROJECTED EXTRACT
      * AND THE EVENT HAS BEEN PROCESSED
      **OR*THIS*IS*A*HISTORIC*EXTRACT******************************                    210600 CDE003
      **AND*THE*EVENT*IS*AFTER*THE*EVENT*CONTROL*DATE**************                    210600 CDE003
      * OR THE EVENT DATE IS PRIOR TO THE TRANSACTION DEAL DATE
      *     IGNORE THE EVENT
      *
     C     Proj_Hist     IFEQ      'P'
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
     C     E#PRDT        ANDGT     ProjCO_Dat
                                                                                              CDE002
     C     Proj_Hist     OREQ      'P'                                                        CDE002
     C     EndofBook     ANDEQ     'N'                                                        CDE002
     C     E#PRDT        ANDGT     EvtCtl_Dat                                                 CDE002
                                                                                              CDE002
     C     Proj_Hist     OREQ      'P'
     C     E#PRCD        ANDEQ     'Y'
                                                                                              210600
     C*****Proj_Hist     OREQ      'H'                                                 210600 CDE003
     C*****E#PRDT        ANDGT     EvtCtl_Dat                                          210600 CDE003
                                                                                              CDE002
     C     E#PRDT        ORLT      T#DDAT
     C                   CLEAR                   E#EVNT
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     *BLANK        #_evnt(VLevnt)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     *BLANK        #_evtL(VLevnt)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     *BLANK        #_evtS(VLevnt)                 208221
     C                   ENDSL                                                  208221
     C                   ENDIF
      *
      ** SET PREVIOUS (EVENT) DATE =
      ***EVENT*DATE*OF*FIRST*EVENT*ON*OR*AFTER*THE*TRANSACTION*DEAL*DATE****                  CDE002
      ** EVENT DATE OF FIRST EVENT TO BE PROCESSED                                            CDE002
      *
     C     P@PRDT        IFEQ      *ZERO
     C     E#PRDT        ANDGT     *ZERO                                                      CDE002
     C*****E#PRDT********ANDGE*****T#DDAT***********************************                  CDE002
     C                   Z-ADD     E#PRDT        P@PRDT
     C                   ENDIF
      *
     C                   ADD       1             VLevnt
      *
     C                   ENDDO
      *
      * SORT EVENTS
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   SORTA     #_evnt
     C     LongArr       WHENEQ    'L'                                          208221
     C                   SORTA     #_evtL                                       208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   SORTA     #_evtS                                       208221
     C                   ENDSL                                                  208221
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** READ EVENTS (AND PROCESS THEM)
      *********************************************************************
     C     RED_EVNTS     BEGSR
      *
      * Reset event sequence
      *
     C                   Z-ADD     *ZERO         EvntSeq           3 0
     C     *LIKE         DEFINE    E#MVNO        W#MVNO                                       CDE002
     C                   Z-ADD     *ZERO         W#MVNO                                       CDE002
     C     *LIKE         DEFINE    P#RENO        W#RENO                                       208221
     C                   Z-ADD     *ZERO         W#RENO                                       208221
      *
      * READ EVENTS
      *
     C                   Z-ADD     1             RDevnt            5 0
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C     *BLANK        LOOKUP    #_evnt(RDevnt)                     99           *
     C     LongArr       WHENEQ    'L'                                          208221
     C     *BLANK        LOOKUP    #_evtL(RDevnt)                     99        208221
     C     LongArr       WHENEQ    'S'                                          208221
     C     *BLANK        LOOKUP    #_evtS(RDevnt)                     99        208221
     C                   ENDSL                                                  208221
      *                                                                                       CDE002
      * NO EVENT, SO NO VALID EVENTS WERE PASSED IN                                           CDE002
      *                                                                                       CDE002
     C     *IN99         IFEQ      '0'                                                        CDE002
     C                   EVAL      Err_Mess = 'NO VALID EVENTS READ'                          CDE002
     C                   EXSR      *PSSR                                                      CDE002
     C                   ENDIF                                                                CDE002
      *
      * READ ALL EVENTS
      *
     C*****RDevnt        DOWLE     FilArrSiz                                    208221
     C     LongArr       DOWEQ     *BLANKS                                      208221
     C     RDevnt        ANDLE     FilArrSiz                                    208221
     C     MatDat_P      ANDNE     'Y'
     C     LongArr       OREQ      'L'                                          208221
     C     RDevnt        ANDLE     FilArrLng                                    208221
     C     MatDat_P      ANDNE     'Y'                                          208221
     C     LongArr       OREQ      'S'                                          208221
     C     RDevnt        ANDLE     FilArrSht                                    208221
     C     MatDat_P      ANDNE     'Y'                                          208221
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     #_evnt(RDevnt)E#EVNT
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     #_evtL(RDevnt)E#EVNT                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     #_evtS(RDevnt)E#EVNT                         208221
     C                   ENDSL                                                  208221
      *
      * Reset event sequence
      *
     C     E#PRDT        IFNE      P@PRDT
     C                   Z-ADD     *ZERO         EvntSeq
     C                   ENDIF
      *
      * SET EVENT REFERENCE IF NOT PRESENT
      *
     C     E#EVTP        IFNE      'PE'
     C     E#EVRF        ANDEQ     *BLANK
     C                   ADD       1             EvntSeq
     C                   MOVE      EvntSeq       E#EVRF
     C                   ENDIF
      *
      * ON CHANGE OF DATE (CURRENT DATE NOT = PREVIOUS DATE)
      *
     C     E#PRDT        IFNE      P@PRDT
      *
      * SET POSITION DETAILS
      *
     C                   EXSR      SET_POSD
      *
      **IF*EVENT*DATE*>*INITIAL*INTEREST*ACCRUAL*CONTROL*DATE*******************              CDE002
      * IF PREVIOUS EVENT DATE >= INITIAL INTEREST ACCRUAL CONTROL DATE                       CDE002
      * DO ACCRUALS
      *
     C*****E#PRDT********IFGT      I_P#IACD                                                   CDE002
     C     P@PRDT        IFGE      I_P#IACD                                                   CDE002
     C                   EXSR      DO_ACC
     C                   ENDIF
      *
      * ADD A POSITION INTO THE POSITIONS ARRAY
      *
     C                   EXSR      UPD_POSN
      *
      * UPDATE PREVIOUS DATE
      *
     C                   Z-ADD     E#PRDT        P@PRDT
      *
     C                   ENDIF
      *
      * PROCESS THE EVENT
      *
     C     E#EVTP        CASEQ     'DD'          DEALDAT
     C     E#EVTP        CASEQ     'VD'          VALUEDAT
     C     E#EVTP        CASEQ     'FE'          FEE
     C     E#EVTP        CASEQ     'XM'          FXMARGIN                                     CDE002
     C     E#EVTP        CASEQ     'MI'          MANADJINT
     C     E#EVTP        CASEQ     'SA'          STOPACC
     C     E#EVTP        CASEQ     'PI'          PRININC
     C     E#EVTP        CASEQ     'PD'          PRINDEC
     C     E#EVTP        CASEQ     'IP'          INTPAY
     C     E#EVTP        CASEQ     'OD'          OVERDUE
     C     E#EVTP        CASEQ     'RE'          REPAY
     C     E#EVTP        CASEQ     'MR'          MANREP
     C     E#EVTP        CASEQ     'SC'          SPRDCHG
     C     E#EVTP        CASEQ     'BC'          BASECHG
     C     E#EVTP        CASEQ     'RO'          ROLLOVER
     C     E#EVTP        CASEQ     'PE'          PERDEND
     C     E#EVTP        CASEQ     'MT'          MATURITY
     C                   ENDCS
      *                                                                                       CDE002
      ** Set Number of movements                                                              CDE002
     C                   ADD       E#MVNO        W#MVNO                                       CDE002
      *
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     E#EVNT        #_evnt(RDevnt)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     E#EVNT        #_evtL(RDevnt)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     E#EVNT        #_evtS(RDevnt)                 208221
     C                   ENDSL                                                  208221
      *
     C                   ADD       1             RDevnt
      *
     C                   ENDDO
      *
      **IF*AT*LEAST*ONE*EVENT*HAS*BEEN*READ*********************************                  CDE002
      **********************************************************************                  CDE002
     C*****P@PRDT********IFNE*******ZERO************************************                  CDE002
      **********************************************************************                  CDE002
      **IF*NO*POSITIONS*HAVE*BEEN*PRODUCED**********************************                  CDE002
      **OR*IF*THE*MATURITY*DATE*POSITION*HAS*BEEN*NOT*BEEN*PRODUCED***********                CDE002
      **********************************************************************                  CDE002
     C*****#_posn(1)*****IFEQ*******BLANK***********************************                  CDE002
     C*****MatDat_P******OREQ******'Y'**************************************                  CDE002
     C*****P#IACD********ANDNE*****T#MDAT***********************************                  CDE002
      *                                                                                       CDE002
      * IF THERE WAS NO CHANGE OF DATE (CURRENT EVENT DATE = PREVIOUS DATE)                   CDE002
      * OR IF THE CURRENT POSITION DATE < LATEST EVENT DATE                                   CDE002
      *                                                                                       CDE002
     C     E#PRDT        IFEQ      P@PRDT                                                     CDE002
     C     P#IACD        ORLT      E#PRDT                                                     CDE002
      *
      * SET POSITION DETAILS
      *
     C                   EXSR      SET_POSD
      *
      **IF*EVENT*DATE*>*INITIAL*INTEREST*ACCRUAL*CONTROL*DATE*******************              CDE002
      * IF PREVIOUS EVENT DATE >= INITIAL INTEREST ACCRUAL CONTROL DATE                       CDE002
      * DO ACCRUALS
      *
     C*****E#PRDT********IFGT      I_P#IACD                                                   CDE002
     C     P@PRDT        IFGE      I_P#IACD                                                   CDE002
     C                   EXSR      DO_ACC
     C                   ENDIF
      *
      * ADD A POSITION INTO THE POSITIONS ARRAY
      *
     C                   EXSR      UPD_POSN
 
     C                   ENDIF
     C*******************ENDIF**********************************************                  CDE002
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** DEAL DATE
      *********************************************************************
     C     DEALDAT       BEGSR
     C     P#ICMT        IFEQ      *BLANK                                       198416
     C                   Z-ADD     *ZERO         P_P#NOML                       198416
     C                   ENDIF                                                  198416
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** VALUE DATE
      *********************************************************************
     C     VALUEDAT      BEGSR
 
      * If cash is accrued
      *    If the cash amount is not supplied on the event
      *    (as well as the next cash date)
      *       Calculate the cash due
      *       on the next interest payment date
      *    Set the next cash date
 
     C     P#ACCS        IFEQ      'Y'
     C     E#CASH        IFEQ      *ZERO
     C                   EXSR      CAL_CASH
     C                   ENDIF
     C                   Z-ADD     E#NXCD        NxtCashDt
     C                   ENDIF
 
      * Process the event
     C                   CALLB     'DEWRKEZVD'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#ACCS            1
 
     C                   PARM                    E#PRDT            5 0
     C                   PARM                    E#INTA           15 0
     C                   PARM                    E#CHRG           15 0
     C                   PARM                    E#COMM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#IO              1
     C                   PARM                    E#NXCD            5 0
     C                   PARM                    E#CASH           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD           26                          CGL029
      * OUTPUTS
     C                   PARM                    P#CASH           15 0
     C                   PARM                    P#RLPL           15 0
     C                   PARM                    P#CHRG           15 0
     C                   PARM                    P#COMM           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZVD'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
 
      ** Set the 'VALUE DATE PROCESSED' Indicator
 
     C                   MOVEL     'Y'           ValDat_P
     C     P#ICMT        IFNE      *BLANK                                       198416
     C                   Z-ADD     *ZERO         P_P#NOML                                     CDE002
     C                   ENDIF                                                  198416
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** FEE PAYMENT DATE
      *********************************************************************
     C     FEE           BEGSR
      *
      * Set event total amount
      *
     C                   Z-ADD     E#FEE         E#TAMT
     C                   ADD       E#CHRG        E#TAMT
     C                   ADD       E#COMM        E#TAMT
 
      * Process the event
     C                   CALLB     'DEWRKEZFE'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    E#FEE            15 0
     C                   PARM                    E#CHRG           15 0
     C                   PARM                    E#COMM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#NCDP            1 0
     C                   PARM                    E#IO              1
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
     C                   PARM                    P#FEE            15 0
     C                   PARM                    P#CHRG           15 0
     C                   PARM                    P#COMM           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZFE'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      ** FOREIGN EXCHANGE MARGIN                                                              CDE002
      *********************************************************************                   CDE002
     C     FXMARGIN      BEGSR                                                                CDE002
                                                                                              CDE002
      * Process the event                                                                     CDE002
     C                   CALLB     'DEWRKEZXM'                                                CDE002
     C                   PARM      *BLANK        W#RTCD            7                          CDE002
     C                   PARM      *BLANK        W#ERMS           30                          CDE002
      * INPUTS                                                                                CDE002
     C                   PARM                    E#FXMG           15 0                        CDE002
      * OUTPUTS                                                                               CDE002
     C                   PARM                    P#FXMG           15 0                        CDE002
                                                                                              CDE002
     C     W#RTCD        IFEQ      '*ERROR'                                                   CDE002
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZXM'                    CDE002
     C                   EXSR      *PSSR                                                      CDE002
     C                   END                                                                  CDE002
                                                                                              CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5
      *********************************************************************
      ** MANUAL ADJUSTMENT TO ACCRUED INTEREST
      *********************************************************************
     C     MANADJINT     BEGSR
      *
      * Add manual adjustment of interest
      * to accrued interest adjustments total
      *
     C                   ADD       E#INTA        P#AIAD
      *
      * Add manual adjustment of cost of funds
      * to accrued cost of funds adjustments total
      *
     C                   ADD       E#COFA        P#ACAD
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** STOP/START ACCRUALS
      *********************************************************************
     C     STOPACC       BEGSR
      *
      * Stop or start accruals
      *
     C                   MOVE      E#STAC        P#STAC
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PRINCIPAL INCREASE
      *********************************************************************
     C     PRININC       BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZPI'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
 
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
 
     C                   PARM                    P#NOML           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZPI'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
                                                                                              CDE002
     C                   MOVEL     'Y'           P#PITY                                       CDE002
      *                                                                                       208221
      ** Increment number of repayments                                                       208221
      *                                                                                       208221
     C                   ADD       1             W#RENO                                       208221
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PRINCIPAL DECREASE
      *********************************************************************
     C     PRINDEC       BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZPD'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#SECU            1
 
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
 
     C                   PARM                    P#DIPR           15 0
     C                   PARM                    P#RLPL           15 0
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#PINT           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZPD'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
      *                                                                                       208221
      ** Increment number of repayments                                                       208221
      *                                                                                       208221
     C                   ADD       1             W#RENO                                       208221
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** INTEREST PAYMENT
      *********************************************************************
     C     INTPAY        BEGSR
      *
      * If interest is accrued & payable up-front on a yield/discount basis
      *    If the interest is not supplied on the event
      *       Calculate the interest due
      *       from this int pay date to the next int pay date
      *    Set interest due   = event interest amount (int.due at next date)
      *
     C     P#ACIN        IFEQ      'Y'
     C     P#INPM        IFEQ      'Y'
     C     P#INPM        OREQ      'D'
     C     E#INTA        IFEQ      *ZERO
     C                   EXSR      CAL_INT_UF
     C                   ENDIF
     C                   Z-ADD     E#INTA        Int_Due
     C                   ENDIF
     C                   ENDIF
      *                                                                         212721
      * If interest is accrued & not payable up-front on a yield/discount       212721
      * basis and the interest is supplied on the event                         212721
      *    Set interest due = event interest amount (int.due at next date)      212721
      *                                                                         212721
     C     P#ACIN        IFEQ      'Y'                                          212721
     C     P#INPM        ANDNE     'Y'                                          212721
     C     P#INPM        ANDNE     'D'                                          212721
     C     E#INTA        ANDNE     *ZERO                                        212721
     C                   Z-ADD     E#INTA        Int_Due                        212721
     C                   ENDIF                                                  212721
      *
      * If COF is accrued & payable up-front on a yield/discount basis
      *    If the cost of funds is not supplied on the event
      *       Calculate the cost of funds due
      *       from this int pay date to the next int pay date
      *
     C     P#ACCF        IFEQ      'Y'
     C     P#INPM        IFEQ      'Y'
     C     P#INPM        OREQ      'D'
     C     E#COFA        IFEQ      *ZERO
     C                   EXSR      CAL_COF_UF
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
      * If cash is accrued
      *    If the cash amount is not supplied on the event
      *    (as well as the next cash date)
      *       Calculate the cash due
      *       on the next interest payment date
      *    Set the next cash date
      *    Set interest due = event interest amount (cash due on this date)
      *
     C     P#ACCS        IFEQ      'Y'
     C     E#CASH        IFEQ      *ZERO
     C                   EXSR      CAL_CASH
     C                   ENDIF
     C                   Z-ADD     E#NXCD        NxtCashDt
     C                   Z-ADD     E#INTA        Int_Due
     C                   ENDIF
 
      * Process the event
     C                   CALLB     'DEWRKEZIP'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    T#VDAT            5 0
 
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#INPM            1
     C                   PARM                    P#INTC            1
     C                   PARM                    P#ACIN            1
     C                   PARM                    P#ACCF            1
     C                   PARM                    P#ACCS            1
 
     C                   PARM                    E#PRDT            5 0
     C                   PARM                    E#INTC            1
     C                   PARM                    E#INTA           15 0
     C                   PARM                    E#COFA           15 0
     C                   PARM                    E#NXCD            5 0
     C                   PARM                    E#CASH           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
 
     C                   PARM                    Int_Due          15 0
      * OUTPUTS
     C                   PARM                    P#IPRD           15 0
     C                   PARM                    P#ICTD           15 0
     C                   PARM                    P#TOTI           15 0
     C                   PARM                    P#TOTC           15 0
     C                   PARM                    P#CASH           15 0
     C                   PARM                    P#NOML           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZIP'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** OVERDUE PAYMENT
      *********************************************************************
     C     OVERDUE       BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      **  GENERATE REPAYMENT EVENT(S)
      *********************************************************************
     C     REPAY         BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZRE'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#REPT            1 0
 
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
     C                   PARM                    Int_Due          15 0
 
     C                   PARM                    P#IPRD           15 0
     C                   PARM                    P#NOML           15 0
 
     C                   PARM                    P_C#CASH
     C                   PARM                    I_C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZRE'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C                   MOVEL     P_C#CASH      C#CASH
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
     C                   MOVEL     I_C#CASH      C#CASH
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      **  MANUAL REPAYMENT EVENT(S)
      ********************************************************************
     C     MANREP        BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZMR'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
 
     C                   PARM                    E#PRAM           15 0
     C                   PARM                    E#INTA           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
     C                   PARM                    P#IPRD           15 0
     C                   PARM                    P#NOML           15 0
 
     C                   PARM                    P_C#CASH
     C                   PARM                    I_C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZMR'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C                   MOVEL     P_C#CASH      C#CASH
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
     C                   MOVEL     I_C#CASH      C#CASH
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
      *                                                                                       208221
      ** Increment number of repayments                                                       208221
      *                                                                                       208221
     C                   ADD       1             W#RENO                                       208221
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** SPREAD CHANGE
      *********************************************************************
     C     SPRDCHG       BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZSC'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#SPIN            1
     C                   PARM                    P#FSGN            1
 
     C                   PARM                    E#RTSP           11 7
     C                   PARM                    E#FSRP           11 7
     C                   PARM                    E#IRCH            1
     C                   PARM                    E#CRCH            1
      * OUTPUTS
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#FSRP           11 7
     C                   PARM                    P#IRAT           11 7
     C                   PARM                    P#CRAT           11 7
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZSC'
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDE002
     C                   MOVEL     'Y'           P#RCTY                                       CDE002
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** BASE RATE CHANGE OR BASE RATE CODE CHANGE
      *********************************************************************
     C     BASECHG       BEGSR
 
      ** If interest rate type signifies forward rate
 
     C     E#IRTP        IFEQ      'F'
 
      * NEAR DATE: THIS RATE CHANGE DATE
 
     C                   Z-ADD     E#PRDT        W#NRDT
 
      * FAR DATE: REFERENCE THE INT RATE CHANGE DATES ARRAY
 
     C                   Z-ADD     1             #I                5 0
     C     E#PRDT        LOOKUP    #_irdat(#I)                            99     *
     C                   ADD       1             #I
     C                   Z-ADD     #_irdat(#I)   W#FRDT
 
      * GET LAST AND NEXT PAY DATES STRADDLING THIS DATE (W#LIDT & W#NIDT)
 
     C                   EXSR      GET_LNIPDT
 
      ** CALCULATE FORWARD RATE
 
     C                   EXSR      CAL_FWRT
 
      ** SET EVENT BASE RATE
 
     C                   Z-ADD     W#FWRT        E#BRTE
     C                   ENDIF
 
      * Process the event
     C                   CALLB     'DEWRKEZBC'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#SPIN            1
 
     C                   PARM                    E#BRTT            2 0
     C                   PARM                    E#BRTE           11 7
     C                   PARM                    E#IRAT           11 7
     C                   PARM                    E#IRTP            1
      * OUTPUTS
     C                   PARM                    P#BRTT            2 0
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#IRAT           11 7
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZBC'
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDE002
     C                   MOVEL     'Y'           P#RCTY                                       CDE002
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ROLLOVER EVENT
      *********************************************************************
     C     ROLLOVER      BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZRO'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    E#BRTE           11 7
     C                   PARM                    E#RTSP           11 7
     C                   PARM                    E#SPIN            1
     C                   PARM                    E#IRCH            1
     C                   PARM                    E#FSRP           11 7
     C                   PARM                    E#FSGN            1
     C                   PARM                    E#CRCH            1
     C                   PARM                    E#ICMT            7
     C                   PARM                    E#NOML           15 0
     C                   PARM                    E#CCY             3
     C                   PARM                    E#NCDP            1 0
     C                   PARM                    E#NMDP            1 0
      * OUTPUTS
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#CCY             3
     C                   PARM                    P#NCDP            1 0
     C                   PARM                    P#NMDP            1 0
     C                   PARM                    P#BRTE           11 7
     C                   PARM                    P#RTSP           11 7
     C                   PARM                    P#SPIN            1
     C                   PARM                    P#IRAT           11 7
     C                   PARM                    P#FSRP           11 7
     C                   PARM                    P#FSGN            1
     C                   PARM                    P#CRAT           11 7
     C                   PARM                    P#ICMT            7
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZRO'
     C                   EXSR      *PSSR
     C                   END
                                                                                              CDE002
     C                   MOVEL     'Y'           P#ROTY                                       CDE002
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** PERIOD END
      *********************************************************************
     C     PERDEND       BEGSR
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** MATURITY
      *********************************************************************
     C     MATURITY      BEGSR
 
      * Process the event
     C                   CALLB     'DEWRKEZMT'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
      * INPUTS
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#NOML           15 0
 
     C                   PARM                    E#NOML           15 0
     C                   PARM                    E#CHRG           15 0
     C                   PARM                    E#COMM           15 0
     C                   PARM                    E#TAMT           15 0
     C                   PARM                    E#IO              1
     C                   PARM                    E#SSET            1
     C**********         PARM                    E#SETD           20                          CGL029
     C                   PARM                    E#SETD                                       CGL029
      * OUTPUTS
     C                   PARM                    P#CHRG           15 0
     C                   PARM                    P#COMM           15 0
 
     C                   PARM                    C#CASH
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEWRKEZMT'
     C                   EXSR      *PSSR
     C                   END
 
      * Update the cashflow array
 
     C     C#AMNT        IFNE      *ZERO
     C                   EXSR      UPD_CASH
     C                   ENDIF
 
      ** SET 'MATURITY DATE PROCESSED' INDICATOR
 
     C                   MOVEL     'Y'           MatDat_P
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** UPDATE POSITIONS ARRAY
      *********************************************************************
     C     UPD_POSN      BEGSR
 
      ** Set Position Type
 
     C                   EXSR      SET_PSTP
                                                                                              CDE002
      ** Set Position Statistics                                                              CDE002
                                                                                              CDE002
     C                   EXSR      SET_PSSTAT                                                 CDE002
      *
     C                   ADD       1             IMposn
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     P#POSN        #_posn(IMposn)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     P#POSN        #_posL(IMposn)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     P#POSN        #_posS(IMposn)                 208221
     C                   ENDSL                                                  208221
     C                   MOVEL     P#POSN        P_P#POSN                                     CDE002
 
      *
      ** UPDATE POSITION WITH ACCRUALS
      *
 
      **  Update ACCRUED INTEREST TO CONTROL DATE and PURCHASED INTEREST
 
     C     P#ACIN        IFEQ      'Y'
     C     P#INPM        ANDNE     'Y'
     C     P#INPM        ANDNE     'D'
 
     C                   ADD       P#INAC        P#AITC
     C     P#SECU        IFEQ      'Y'
     C                   ADD       P#INAC        P#PINT
     C                   ENDIF
 
     C                   ENDIF
 
      ** Update DISCOUNT/PREMIUM (outstanding)
 
     C     P#ACDP        IFEQ      'Y'
     C                   SUB       P#DPAC        P#DIPR
     C                   ELSE
     C                   Z-ADD     *ZERO         P#DIPR
     C                   ENDIF
 
      ** Update CASH (outstanding)
 
     C     P#ACCS        IFEQ      'Y'
     C                   SUB       P#CSAC        P#CASH
     C                   ELSE
     C                   Z-ADD     *ZERO         P#CASH
     C                   ENDIF
 
      **  Update FEE (outstanding)
 
     C     P#ACFE        IFEQ      'Y'
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   ADD       Fee_Acc       P#FEAC                                       CLE031
     C                   SUB       Fee_Acc       P#FEE                                        CLE031
     C                   ELSE                                                                 CLE031
     C                   SUB       P#FEAC        P#FEE
     C                   ENDIF                                                                CLE031
     C                   ELSE
     C                   Z-ADD     *ZERO         P#FEE
     C                   ENDIF
 
      **  Update REALIZED P/L (outstanding)
 
     C     P#ACRL        IFEQ      'Y'
     C                   SUB       P#RLAC        P#RLPL
     C                   ELSE
     C                   Z-ADD     *ZERO         P#RLPL
     C                   ENDIF
                                                                                              CDE002
      **  Update SWAP P/L (outstanding)                                                       CDE002
                                                                                              CDE002
     C     P#ACSW        IFEQ      'Y'                                                        CDE002
     C                   SUB       P#SWAC        P#SWPL                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     *ZERO         P#SWPL                                       CDE002
     C                   ENDIF                                                                CDE002
 
      * Reset CHARGES & COMMISSIONS
 
     C                   Z-ADD     *ZERO         P#CHRG
     C                   Z-ADD     *ZERO         P#COMM
                                                                                              CDE002
      * Reset FX MARGIN                                                                       CDE002
                                                                                              CDE002
     C                   Z-ADD     *ZERO         P#FXMG                                       CDE002
                                                                                              CDE002
      * Reset Position Statistics                                                             CDE002
                                                                                              CDE002
     C                   MOVEL     *BLANK        P#ROTY                                       CDE002
     C                   MOVEL     *BLANK        P#PITY                                       CDE002
     C                   MOVEL     *BLANK        P#RCTY                                       CDE002
     C                   Z-ADD     *ZERO         P#MVNO                                       CDE002
     C                   Z-ADD     *ZERO         P#RENO                                       CDE002
 
      ** Determine INTEREST DUE
 
     C     P#AITC        ADD       P#AIAD        Int_Due
     C                   SUB       P#IPRD        Int_Due
     C                   SUB       P#ICTD        Int_Due
     C                   SUB       P#IWOD        Int_Due
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** SET POSITION TYPE
      *********************************************************************
     C     SET_PSTP      BEGSR
 
      * I = IGNORE for export
      * C = Projected export - CURRENT POSITION
      *     (Current position is first position exported)
      * L = Historic  export - LATEST POSITION
      *     (Latest position is last position exported)
 
     C                   SELECT
 
     C     Proj_Hist     WHENEQ    'P'
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
 
     C*****P#IACD********IFLT******Extrct_Dat*******************************                  CDE002
     C     P#IACD        IFLT      Run_Date                                                   CDE002
     C                   MOVEL     'I'           P#PSTP
     C                   ELSE
     C     CurPos_P      IFNE      'Y'
     C     T#RLDO        ANDNE     'Y'
     C                   MOVEL     'C'           P#PSTP
     C                   MOVEL     'Y'           CurPos_P
     C                   ELSE
     C                   MOVEL     *BLANK        P#PSTP
     C                   ENDIF
     C                   ENDIF
                                                                                              CDE002
     C     Proj_Hist     WHENEQ    'P'                                                        CDE002
     C     EndofBook     ANDEQ     'N'                                                        CDE002
                                                                                              CDE002
     C                   MOVEL     'I'           P#PSTP                                       CDE002
 
     C     Proj_Hist     WHENEQ    'H'
 
     C*****P#IACD********IFGE******Extrct_Dat*******************************                  CDE002
     C     P#IACD        IFGT      EvtCtl_Dat                                                 CDE002
     C     P#IACD        ORLT      HistCO_Dat
     C                   MOVEL     'I'           P#PSTP
     C                   ELSE
     C*****P#EDAT********IFEQ******Extrct_Dat*******************************                  CDE002
     C*******************MOVEL*****'L'***********P#PSTP*********************                  CDE002
     C*******************ELSE***********************************************                  CDE002
     C                   MOVEL     *BLANK        P#PSTP
     C*******************ENDIF**********************************************                  CDE002
     C                   ENDIF
 
     C                   ENDSL
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      ** SET POSITION STATISTICS                                                              CDE002
      *********************************************************************                   CDE002
     C     SET_PSSTAT    BEGSR                                                                CDE002
                                                                                              CDE002
     C     P#IPRD        SUB       P_P#IPRD      P#INPR                                       CDE002
     C     P#ICTD        SUB       P_P#ICTD      P#INCT                                       CDE002
     C     P#IWOD        SUB       P_P#IWOD      P#INWO                                       CDE002
     C     P#AIAD        SUB       P_P#AIAD      P#INAJ                                       CDE002
     C     P#ACAD        SUB       P_P#ACAD      P#CFAJ                                       CDE002
     C     P#NOML        IFGT      P_P#NOML                                                   CDE002
     C                   MOVEL     'Y'           P#INCN                                       CDE002
     C                   ELSE                                                                 CDE002
     C                   MOVEL     *BLANK        P#INCN                                       CDE002
     C                   ENDIF                                                                CDE002
     C     P#NOML        SUB       P_P#NOML      P#DIFN                                       CDE002
     C     P#DIFN        IFNE      0                                                          CDE002
     C     P#MVNO        ANDEQ     0                                                          CDE002
     C                   Z-ADD     1             P#MVNO                                       CDE002
     C                   ENDIF                                                                CDE002
                                                                                              CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5
      *********************************************************************
      ** UPDATE CASHFLOW ARRAY
      *********************************************************************
     C     UPD_CASH      BEGSR
      *
      * Module ID, transaction reference, asset/liability, date, event type
      *
     C                   MOVEL     E#MOD         C#MOD
     C                   MOVEL     E#TREF        C#TREF
     C                   MOVEL     E#ASLI        C#ASLI
     C                   MOVEL     E#PRDT        C#DATE
     C                   MOVEL     E#EVTP        C#EVTP
      *
      ** Event Ref
     C                   MOVEL     E#EVRF        C#EVRF
      *
      * Currency and currency decimal places
      *
     C     C#CCY         IFEQ      *BLANK
     C                   MOVEL     P#CCY         C#CCY
     C                   MOVEL     P#NCDP        C#CDP
     C                   ENDIF
      *
      * Calculate Net Present Value
      *
     C     Proj_Hist     IFEQ      'P'
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
     C                   EXSR      CAL_NPVL
     C                   Z-ADD     W#SPAM        C#NPVL                         * SPOT AMOUNT
     C                   ENDIF
      *
      * Transaction type/sub type, risk customer,
      * local industry code, country code
      *
     C                   MOVE      T#TRTP        C#TRTP
     C                   MOVE      T#TRST        C#TRST
     C                   MOVE      T#RCST        C#RCST
     C                   MOVE      T#LICD        C#LICD
     C                   MOVE      T#CNCD        C#CNCD
      *                                                                                       CDE003
      * Net Reference                                                                         CDE003
      *                                                                                       CDE003
      * If Asset                                                                              CDE003
     C     E#ASLI        IFEQ      'A'                                                        CDE003
     C                   MOVEL     T#NBRF        C#NTRF                                       CDE003
     C                   MOVEL     T#NBSC        C#NTSC                                       CDE003
     C                   ENDIF                                                                CDE003
      *                                                                                       CDE003
      * If Liability                                                                          CDE003
     C     E#ASLI        IFEQ      'L'                                                        CDE003
      *                                                                                       CDE003
      * If CLS                                                                                CDE003
     C     T#NBRF        IFEQ      'CLS         '                                             CDE003
     C                   MOVEL     T#NBRF        C#NTRF                                       CDE003
     C                   ELSE                                                                 CDE003
     C                   MOVEL     T#NSRF        C#NTRF                                       CDE003
     C                   MOVEL     T#NSSC        C#NTSC                                       CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
      *
      * Due indicator
      *
     C     Proj_Hist     IFEQ      'P'
     C*****C#DATE********ANDLE*****EvtCtl_Dat*******************************                  CDE002
     C*****C#DATE********ANDGE*****Extrct_Dat*******************************                  CDE002
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
     C     C#DATE        ANDGE     Run_Date                                                   CDE002
     C     C#DATE        ANDLT     Date_NWD                                                   CDE002
     C                   MOVE      'Y'           C#DUEI
     C                   ENDIF
      *                                                                                       CLE034
     C     MemberType    IFEQ      'PLOAN'                                                    CLE034
     C     CLE034        ANDEQ     'Y'                                                        CLE034
     C     E#STAL        ANDNE     *BLANKS                                                    CLE034
     C                   EXSR      SR34A                                                      CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVEL     'Y'           Not_Alloc         1                          CLE034
     C                   MOVEL     '*EOF   '     PRTCD                                        CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     Not_Alloc     DOWEQ     'Y'                                                        CLE034
     C     PRTCD         OREQ      *BLANKS                                                    CLE034
     C     MemberType    IFEQ      'PLOAN'                                                    CLE034
     C     CLE034        ANDEQ     'Y'                                                        CLE034
     C     E#STAL        ANDNE     *BLANKS                                                    CLE034
     C                   EXSR      SR34B                                                      CLE034
     C                   ENDIF                                                                CLE034
      *
     C     MemberType    IFEQ      'PLOAN'                                                    CLE034
     C     CLE034        ANDEQ     'Y'                                                        CLE034
     C     E#STAL        ANDNE     *BLANKS                                                    CLE034
     C     C#AMNT        ANDEQ     *ZEROS                                                     CLE034
     C*                                                                                       CLE034
     C** Do not output a cashflow record if the difference due to rounding                    CLE034
     C** is zero.                                                                             CLE034
     C*                                                                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   ADD       1             IMcash
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     C#CASH        #_cash(IMcash)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     C#CASH        #_cshL(IMcash)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     C#CASH        #_cshS(IMcash)                 208221
     C                   ENDSL                                                  208221
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     MemberType    IFEQ      'PLOAN'                                                    CLE034
     C     CLE034        ANDEQ     'Y'                                                        CLE034
     C     E#STAL        ANDNE     *BLANKS                                                    CLE034
     C                   EXSR      SR34C                                                      CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      *BLANKS       Not_Alloc                                    CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDDO                                                                CLE034
      *                                                                                       CLE034
     C     MemberType    IFEQ      'PLOAN'                                                    CLE034
     C     CLE034        ANDEQ     'Y'                                                        CLE034
     C     E#STAL        ANDNE     *BLANKS                                                    CLE034
     C                   EXSR      SR34E                                                      CLE034
     C                   ENDIF                                                                CLE034
      *
     C                   ENDSR
      *********************************************************************
     C/SPACE 5                                                                                CLE034
      *********************************************************************                   CLE034
      *                                                                   *                   CLE034
      *  SR34A - Initial set up for CLE034 processing                     *                   CLE034
      *                                                                   *                   CLE034
      *********************************************************************                   CLE034
     C     SR34A         BEGSR                                                                CLE034
     C                   Z-ADD     C#AMNT        WSVAMT           13 0                        CLE034
      *                                                                                       CLE034
     C     E#EVTP        IFEQ      'VD'                                                       CLE034
     C     E#EVTP        OREQ      'PI'                                                       CLE034
     C     E#ASLI        IFEQ      'A'                                                        CLE034
     C                   MOVE      'P'           WPYRCV            1                          CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'R'           WPYRCV                                       CLE034
     C                   ENDIF                                                                CLE034
     C                   ELSE                                                                 CLE034
     C     E#ASLI        IFEQ      'A'                                                        CLE034
     C                   MOVE      'R'           WPYRCV                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      'P'           WPYRCV                                       CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
      ** Initialise variables                                                                 CLE034
      *                                                                                       CLE034
     C                   Z-ADD     0             WTOTA            13 0                        CLE034
     C                   Z-ADD     0             WRKAMT           13 0                        CLE034
     C                   MOVE      *BLANK        Not_Alloc         1                          CLE034
     C                   MOVE      C#SETM        WSC#SETM          2                          CLE034
     C**********         MOVE      C#SETA        WSC#SETA         12                   CLE034 CGL029
     C                   MOVE      C#SETA        WSC#SETA         18                          CGL029
     C                   MOVE      C#SETB        WSC#SETB          3                          CLE034
     C                   MOVE      C#SETC        WSC#SETC          3                          CLE034
      *                                                                                       CLE034
     C     E#STAL        IFEQ      'A'                                                        CLE034
     C                   MOVEL     E#TREF        PLNRF                                        CLE034
     C                   MOVE      E#PRDT        PLAVD                                        CLE034
     C                   MOVE      E#LASN        PLASQ                                        CLE034
     C                   MOVEL     'LA'          PTYPE             4                          CLE034
     C                   MOVE      E#EVTP        PTYPE                                        CLE034
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       PRTCD             7                          CLE034
     C                   PARM      '*FIRST '     POPTN             7                          CLE034
     C                   PARM                    PTYPE                                        CLE034
     C                   PARM                    PLNRF             6                          CLE034
     C                   PARM                    PLAVD             5                          CLE034
     C                   PARM                    PLASQ             3                          CLE034
     C                   PARM      *BLANKS       PCFEE             6                          CLE034
     C                   PARM      *BLANKS       PFFEE             5                          CLE034
     C                   PARM      *BLANKS       PFESQ             2                          CLE034
     C                   PARM      WPYRCV        PPYRCV            1                          CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
      *                                                                                       CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
     C                   MOVEL     E#TREF        PLNRF                                        CLE034
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       PRTCD                                        CLE034
     C                   PARM      '*FIRST '     POPTN                                        CLE034
     C                   PARM      'LOAN'        PTYPE                                        CLE034
     C                   PARM                    PLNRF                                        CLE034
     C                   PARM      *BLANKS       PLAVD                                        CLE034
     C                   PARM      *BLANKS       PLASQ                                        CLE034
     C                   PARM      *BLANKS       PCFEE                                        CLE034
     C                   PARM      *BLANKS       PFFEE                                        CLE034
     C                   PARM      *BLANKS       PFESQ                                        CLE034
     C                   PARM      WPYRCV        PPYRCV                                       CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     PRTCD         IFNE      *BLANKS                                                    CLE034
     C                   MOVEL     'AOSTALR2'    DBPGM                                        CLE034
     C                   MOVEL     'LESTALPD'    DBFILE                                       CLE034
     C                   MOVE      *BLANKS       DBKEY                                        CLE034
     C                   MOVEL     PTYPE         DBKEY                                        CLE034
     C                   Z-ADD     88888         DBASE                                        CLE034
     C                   MOVE      *ON           *INU7                                        CLE034
     C                   MOVE      *ON           *INLR                                        CLE034
     C                   EXSR      *PSSR                                                      CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
     C/SPACE 5                                                                                CLE034
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SR34B - Processing to calculate amount for settlement        *                       CLE034
      *          allocation                                           *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
     C     SR34B         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     WPYRCV        IFEQ      'P'                                                        CLE034
     C     WSVAMT        MULT      STPYPC        WRKAMT                                       CLE034
     C                   DIV (H)   100           WRKAMT                                       CLE034
     C                   ELSE                                                                 CLE034
     C     WSVAMT        MULT      STRCPC        WRKAMT                                       CLE034
     C                   DIV (H)   100           WRKAMT                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     WTOTA         ADD       WRKAMT        WTOTA                                        CLE034
      *                                                                                       CLE034
     C     Not_Alloc     IFEQ      'Y'                                                        CLE034
     C     WTOTA         ANDNE     WSVAMT                                                     CLE034
     C     WSVAMT        SUB       WTOTA         WDIFF            13 0                        CLE034
     C                   ADD       WDIFF         WRKAMT                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   Z-ADD     WRKAMT        C#AMNT                                       CLE034
      *                                                                                       CLE034
     C                   EXSR      SR34D                                                      CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
     C/SPACE 5                                                                                CLE034
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SR34C - Processing to get next settlement allocation         *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
     C     SR34C         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     Not_Alloc     IFEQ      'Y'                                                        CLE034
     C                   MOVE      *BLANK        Not_Alloc                                    CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
     C     E#STAL        IFEQ      'A'                                                        CLE034
     C                   MOVEL     E#TREF        PLNRF                                        CLE034
     C                   MOVE      E#PRDT        PLAVD                                        CLE034
     C                   MOVE      E#LASN        PLASQ                                        CLE034
     C                   MOVEL     'LA'          PTYPE                                        CLE034
     C                   MOVE      E#EVTP        PTYPE                                        CLE034
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       PRTCD                                        CLE034
     C                   PARM      '*NEXT  '     POPTN                                        CLE034
     C                   PARM                    PTYPE                                        CLE034
     C                   PARM                    PLNRF                                        CLE034
     C                   PARM                    PLAVD                                        CLE034
     C                   PARM                    PLASQ                                        CLE034
     C                   PARM      *BLANKS       PCFEE                                        CLE034
     C                   PARM      *BLANKS       PFFEE                                        CLE034
     C                   PARM      *BLANKS       PFESQ                                        CLE034
     C                   PARM      WPYRCV        PPYRCV                                       CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
      *                                                                                       CLE034
     C                   ELSE                                                                 CLE034
      *                                                                                       CLE034
     C                   MOVEL     E#TREF        PLNRF                                        CLE034
     C                   CALL      'AOSTALR2'                                                 CLE034
     C                   PARM      *BLANKS       PRTCD                                        CLE034
     C                   PARM      '*NEXT  '     POPTN                                        CLE034
     C                   PARM      'LOAN'        PTYPE                                        CLE034
     C                   PARM                    PLNRF                                        CLE034
     C                   PARM      *BLANKS       PLAVD                                        CLE034
     C                   PARM      *BLANKS       PLASQ                                        CLE034
     C                   PARM      *BLANKS       PCFEE                                        CLE034
     C                   PARM      *BLANKS       PFFEE                                        CLE034
     C                   PARM      *BLANKS       PFESQ                                        CLE034
     C                   PARM      WPYRCV        PPYRCV                                       CLE034
     C     LESTAL        PARM      *BLANKS       DSSDY                                        CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C     PRTCD         IFEQ      '*EOF   '                                                  CLE034
     C                   MOVE      'Y'           Not_Alloc                                    CLE034
     C                   ENDIF                                                                CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
     C/SPACE 5                                                                                CLE034
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SR34D - Set up fields from settlement allocation             *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
     C     SR34D         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C     WPYRCV        IFEQ      'P'                                                        CLE034
     C                   MOVE      STPSTM        C#SETM                                       CLE034
     C                   MOVE      STPONS        C#SETA                                       CLE034
     C                   MOVE      STPOBR        C#SETB                                       CLE034
     C                   MOVE      STPSCY        C#SETC                                       CLE034
     C                   ELSE                                                                 CLE034
     C                   MOVE      STRSTM        C#SETM                                       CLE034
     C                   MOVE      STRONS        C#SETA                                       CLE034
     C                   MOVE      STROBR        C#SETB                                       CLE034
     C                   MOVE      STRSCY        C#SETC                                       CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
     C/SPACE 5                                                                                CLE034
      *****************************************************************                       CLE034
      *                                                               *                       CLE034
      *  SR34E - Restore original fields                              *                       CLE034
      *                                                               *                       CLE034
      *****************************************************************                       CLE034
     C     SR34E         BEGSR                                                                CLE034
      *                                                                                       CLE034
     C                   Z-ADD     WSVAMT        C#AMNT                                       CLE034
     C                   MOVE      WSC#SETM      C#SETM                                       CLE034
     C                   MOVE      WSC#SETA      C#SETA                                       CLE034
     C                   MOVE      WSC#SETB      C#SETB                                       CLE034
     C                   MOVE      WSC#SETC      C#SETC                                       CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
      /SPACE 5
      *********************************************************************
      ** EXPORT TRANSACTION
      *********************************************************************
     C     EXP_TRAN      BEGSR
     C                   MOVEL     'EXP_TRAN'    Diag_Fmt                                     CDE002
      *
      * Return the transaction details
      *
     C     #_tran(1)     IFNE      *BLANK
                                                                                              219833
      * Don't return details for backvalued transactions                                      219833
     C     Proj_Hist     IFEQ      'P'                                                        219833
     C     EndofBook     ANDEQ     'Y'                                                        219833
     C     T#MDAT        ANDLT     Run_Date                                                   219833
     C     T#MDAT        ANDNE     *ZERO                                                      219833
     C                   MOVEL     '*EOD   '     Ret_Code                                     219833
     C                   RETURN                                                               219833
     C                   ENDIF                                                                219833
                                                                                              219833
     C                   MOVEL     #_tran(1)     T#TRAN
     C                   MOVEL     ValDat_P      T#VALR
     C                   MOVEL     MatDat_P      T#MATR
     C                   MOVEL     *BLANK        #_tran(1)
     C                   EXSR      DIAGNOS                                                    CDE002
     C                   ELSE
     C                   MOVEL     '*EOD   '     Ret_Code
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** EXPORT POSITIONS
      *********************************************************************
     C     EXP_POSN      BEGSR
     C                   MOVEL     'EXP_POSN'    Diag_Fmt                                     CDE002
      *
     C     Ret_Code      DOUNE     '*IGNORE'
      *
     C                   ADD       1             EXposn
      *
     C*****#_posn(EXposn)IFNE      *BLANK                                       208221
     C     LongArr       IFEQ      *BLANKS                                      208221
     C     #_posn(EXposn)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'L'                                          208221
     C     #_posL(EXposn)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'S'                                          208221
     C     #_posS(EXposn)ANDNE     *BLANK                                       208221
     C*                                                                         208221
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     #_posn(EXposn)P#POSN
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     #_posL(EXposn)P#POSN                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     #_posS(EXposn)P#POSN                         208221
     C                   ENDSL                                                  208221
     C     P#PSTP        IFEQ      'I'
     C                   MOVEL     '*IGNORE'     Ret_Code
     C                   ELSE
     C                   MOVEL     *BLANK        Ret_Code
     C     BKALDI        IFEQ      'Y'                                                        CDE002
     C**********         EXSR      SETSOMSDT                                           CDE002 210600
     C                   EXSR      SETSOMSDT                                                  CDE003
     C**********         ADD       1             P#SDAT                                210600 CDE003
     C**********         ADD       1             P#EDAT                                210600 CDE003
     C                   ENDIF                                                                CDE002
     C**********         IF        P#SDAT + P#NDYS > P#EDAT                            210600 CDE003
     C**********         EVAL      P#NDYS = P#EDAT - P#SDAT                            210600 CDE003
     C**********         ENDIF                                                         210600 CDE003
     C                   ENDIF
      *                                                                                       216909
      ** If FX Margin is not zero then include number of decimal places of base ccy           216909
      *                                                                                       216909
     C     P#FXMG        IFNE      0                                                          216909
     C                   CALL      'AOCURRR0'                                                 216909
     C                   PARM      '*BLANKS'     @RTCD                                        216909
     C                   PARM      '*KEY   '     @OPTN                                        216909
     C                   PARM                    BJCYCD                                       216909
     C     SDCURR        PARM      SDCURR        DSSDY                                        216909
     C                   Z-ADD     A6NBDP        P#BNDP                                       216909
     C                   ENDIF                                                                216909
      *                                                                                       216909
     C                   EXSR      DIAGNOS                                                    CDE002
     C                   ELSE
     C                   MOVEL     '*EOD   '     Ret_Code
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************            CDE002 210600
      ** SET START OF MONTH START DATE (IF LAST DAY ACCRUALS)                          CDE002 210600
      *********************************************************************                   CDE002
     C*****SETSOMSDT     BEGSR                                                         CDE002 210600
     C*****P#SDAT        IFLT      P#EDAT                                              CDE002 210600
     C**********         Z-ADD     P#SDAT        ZDAYNO                                CDE002 210600
     C**********         EXSR      ZDATE2                                              CDE002 210600
     C**********         MOVEL     ZDATE         Cur_MTH           2                   CDE002 210600
     C*****P#SDAT        ADD       1             ZDAYNO                                CDE002 210600
     C**********         EXSR      ZDATE2                                              CDE002 210600
     C**********         MOVEL     ZDATE         Nxt_MTH           2                   CDE002 210600
     C*****Nxt_MTH       IFNE      Cur_MTH                                             CDE002 210600
     C**********         ADD       1             P#SDAT                                CDE002 210600
     C**********         ENDIF                                                         CDE002 210600
     C**********         ENDIF                                                         CDE002 210600
     C**********         ENDSR                                                         CDE002 210600
     C     SETSOMSDT     BEGSR                                                                CDE003
     C     P#SDAT        IFLT      P#EDAT                                                     CDE003
     C                   Z-ADD     P#SDAT        ZDAYNO                                       CDE003
     C                   EXSR      ZDATE2                                                     CDE003
     C                   MOVEL     ZDATE         Cur_MTH           2                          CDE003
     C     P#SDAT        ADD       1             ZDAYNO                                       CDE003
     C                   EXSR      ZDATE2                                                     CDE003
     C                   MOVEL     ZDATE         Nxt_MTH           2                          CDE003
     C     Nxt_MTH       IFNE      Cur_MTH                                                    CDE003
     C                   ADD       1             P#SDAT                                       CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDIF                                                                CDE003
     C                   ENDSR                                                                CDE003
      *********************************************************************                   CDE002
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      ** CONVERT DAY NUMBER TO DATE                                                           CDE002
      *********************************************************************                   CDE002
     C     ZDATE2        BEGSR                                                                CDE002
     C                   CALLB     'ZDATE2'                                                   CDE002
     C                   PARM                    ZDAYNO            5 0                        CDE002
     C                   PARM      'M'           ZDATFM            1                          CDE002
     C                   PARM      *ZERO         ZDATE             6 0                        CDE002
     C                   PARM      *BLANK        ZADATE            7                          CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5
      *********************************************************************
      ** EXPORT EVENTS
      *********************************************************************
     C     EXP_EVNT      BEGSR
     C                   MOVEL     'EXP_EVNT'    Diag_Fmt                                     CDE002
      *
     C     Ret_Code      DOUNE     '*IGNORE'
      *
     C                   SUB       1             EXevnt
      *
     C*****#_evnt(EXevnt)IFNE      *BLANK                                       208221
     C     LongArr       IFEQ      *BLANKS                                      208221
     C     #_evnt(EXevnt)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'L'                                          208221
     C     #_evtL(EXevnt)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'S'                                          208221
     C     #_evtS(EXevnt)ANDNE     *BLANK                                       208221
     C*                                                                         208221
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     #_evnt(EXevnt)E#EVNT
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     #_evtL(EXevnt)E#EVNT                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     #_evtS(EXevnt)E#EVNT                         208221
     C                   ENDSL                                                  208221
     C     E#EVTP        IFEQ      'PE'
     C     Proj_Hist     OREQ      'P'
     C*****E#PRDT********ANDLT*****Extrct_Dat*******************************                  CDE002
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
     C     E#PRDT        ANDLT     Run_Date                                                   CDE002
     C     Proj_Hist     OREQ      'H'
     C*****E#PRDT********ANDGE*****Extrct_Dat*******************************                  CDE002
     C     E#PRDT        ANDGT     EvtCtl_Dat                                                 CDE002
     C     Proj_Hist     OREQ      'H'
     C     E#PRDT        ANDLT     HistCO_Dat
     C                   MOVEL     '*IGNORE'     Ret_Code
     C                   ELSE
     C                   MOVEL     *BLANK        Ret_Code
     C                   ENDIF
     C                   EXSR      DIAGNOS                                                    CDE002
     C                   ELSE
     C                   MOVEL     '*EOD   '     Ret_Code
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** EXPORT CASHFLOWS
      *********************************************************************
     C     EXP_CASH      BEGSR
     C                   MOVEL     'EXP_CASH'    Diag_Fmt                                     CDE002
      *
     C     Ret_Code      DOUNE     '*IGNORE'
      *
     C                   ADD       1             EXcash
      *
     C*****#_cash(EXcash)IFNE      *BLANK                                       208221
     C     LongArr       IFEQ      *BLANKS                                      208221
     C     #_cash(EXcash)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'L'                                          208221
     C     #_cshL(EXcash)ANDNE     *BLANK                                       208221
     C     LongArr       OREQ      'S'                                          208221
     C     #_cshS(EXcash)ANDNE     *BLANK                                       208221
     C*                                                                         208221
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     #_cash(EXcash)C#CASH
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     #_cshL(EXcash)C#CASH                         208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     #_cshS(EXcash)C#CASH                         208221
     C                   ENDSL                                                  208221
     C     Proj_Hist     IFEQ      'P'
     C*****C#DATE********ANDLT*****Extrct_Dat*******************************                  CDE002
     C     EndofBook     ANDEQ     'Y'                                                        CDE002
     C     C#DATE        ANDLT     Run_Date                                                   CDE002
     C     Proj_Hist     OREQ      'H'
     C*****C#DATE********ANDGE*****Extrct_Dat*******************************                  CDE002
     C     C#DATE        ANDGT     EvtCtl_Dat                                                 CDE002
     C     Proj_Hist     OREQ      'H'
     C     C#DATE        ANDLT     HistCO_Dat
     C                   MOVEL     '*IGNORE'     Ret_Code
     C                   ELSE
     C                   MOVEL     *BLANK        Ret_Code
     C                   ENDIF
     C                   EXSR      DIAGNOS                                                    CDE002
     C                   ELSE
     C                   MOVEL     '*EOD   '     Ret_Code
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * SET POSITION DETAILS
      *********************************************************************
     C     SET_POSD      BEGSR
      *
      ** SET INTEREST ACCRUAL CONTROL DATE
      *
     C                   Z-ADD     P@PRDT        P#IACD                         * INT ACCL CTL DT
      *
      ** SET START DATE AND END DATE
      *
     C                   Z-ADD     P@PRDT        P#SDAT                         * START DATE
     C                   Z-ADD     E#PRDT        P#EDAT                         * END DATE
      *                                                                                       CDE002
      ** Set Number of movements                                                              CDE002
     C                   Z-ADD     W#MVNO        P#MVNO                                       CDE002
     C                   Z-ADD     *ZERO         W#MVNO                                       CDE002
      *                                                                                       208221
      ** Set Number of repayments                                                             208221
      *                                                                                       208221
     C                   Z-ADD     W#RENO        P#RENO                                       208221
     C                   Z-ADD     *ZERO         W#RENO                                       208221
      *
      * BYPASS IF NON INTEREST BEARING
      *
     C     P#ICMT        IFEQ      *BLANK
     C     P#EDAT        SUB       P#SDAT        P#NDYS                         * NO. OF DAYS
     C                   Z-ADD     *ZERO         P#YBAS                         * YEAR BASIS
     C                   GOTO      ESETPOSD
     C                   ENDIF
      *
      ** CALCULATE NUMBER OF DAYS BETWEEN START DATE AND END DATE
      *
     C                   Z-ADD     P#SDAT        W#SDAT                         * START DATE
     C                   Z-ADD     P#EDAT        W#EDAT                         * END DATE
     C                   EXSR      CAL_NDYS
     C                   Z-ADD     W#NDYS        P#NDYS                         * NO. OF DAYS
      *
      * GET LAST & NEXT INT DATES STRADDLING THE EVENT DATE(W#LIDT & W#NIDT)
      *
     C                   EXSR      GET_LNIPDT
      *
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *
     C                   EXSR      CAL_YBAS
     C                   Z-ADD     W#YBAS        P#YBAS                         * YEAR BASIS
      *
     C     ESETPOSD      ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * DO ACCRUALS
      *********************************************************************
     C     DO_ACC        BEGSR
      *
      ** RESET INTEREST         ACCRUED
      ** RESET COST OF FUNDS    ACCRUED
      ** RESET DISCOUNT/PREMIUM ACCRUED
      ** RESET CASH             ACCRUED
      ** RESET FEE              ACCRUED
      ** RESET REALIZED P/L     ACCRUED
      *
     C                   Z-ADD     *ZERO         P#INAC
     C                   Z-ADD     *ZERO         P#CFAC
     C                   Z-ADD     *ZERO         P#DPAC
     C                   Z-ADD     *ZERO         P#CSAC
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD     *ZERO         Fee_Acc                                      CLE031
     C                   ELSE                                                                 CLE031
     C                   Z-ADD     *ZERO         P#FEAC
     C                   END                                                                  CLE031
     C                   Z-ADD     *ZERO         P#RLAC
     C                   Z-ADD     *ZERO         P#SWAC                                       CDE002
 
      *
      * ACCRUE INTEREST
      * IF 'ACCRUE NEGATIVE BALANCE' = YES
      *
     C     P#ACIN        IFEQ      'Y'
     C     P#STAC        ANDNE     'Y'
     C     P#NOML        IFGT      0
     C     P#NOML        ORLT      0
     C     P#ACNG        ANDEQ     'Y'
     C                   EXSR      ACC_INT
     C                   ENDIF
     C                   ENDIF
      *
      * ACCRUE COST OF FUNDS
      * IF 'ACCRUE NEGATIVE BALANCE' = YES
      *
     C     P#ACCF        IFEQ      'Y'
     C     P#STAC        ANDNE     'Y'
     C     P#NOML        IFGT      0
     C     P#NOML        ORLT      0
     C     P#ACNG        ANDEQ     'Y'
     C                   EXSR      ACC_COF
     C                   ENDIF
     C                   ENDIF
      *
      * ACCRUE DISCOUNT/PREMIUM
      *
     C     P#ACDP        IFEQ      'Y'
     C     P#DIPR        ANDNE     *ZERO
     C     T#MDAT        ANDNE     *ZERO
     C     T#MDAT        ANDNE     99999
     C                   EXSR      ACC_DISPRM
     C                   ENDIF
      *
      * ACCRUE CASH
      *
     C     P#ACCS        IFEQ      'Y'
     C     P#CASH        ANDNE     *ZERO
     C                   EXSR      ACC_CASH
     C                   ENDIF
      *
      * ACCRUE FEE
      *
     C     P#ACFE        IFEQ      'Y'
     C     P#FEE         ANDNE     *ZERO
     C     T#MDAT        ANDNE     *ZERO
     C     T#MDAT        ANDNE     99999
     C                   EXSR      ACC_FEE
     C                   ENDIF
      *
      * ACCRUE REALIZED P/L
      *
     C     P#ACRL        IFEQ      'Y'
     C     P#RLPL        ANDNE     *ZERO
     C     T#MDAT        ANDNE     *ZERO
     C     T#MDAT        ANDNE     99999
     C                   EXSR      ACC_RLPL
     C                   ENDIF
      *                                                                                       CDE002
      * ACCRUE SWAP P/L                                                                       CDE002
      *                                                                                       CDE002
     C     P#ACSW        IFEQ      'Y'                                                        CDE002
     C     P#SWPL        ANDNE     *ZERO                                                      CDE002
     C     T#MDAT        ANDNE     *ZERO                                                      CDE002
     C     T#MDAT        ANDNE     99999                                                      CDE002
     C                   EXSR      ACC_SWPL                                                   CDE002
     C                   ENDIF                                                                CDE002
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE INTEREST
      *********************************************************************
     C     ACC_INT       BEGSR
      *
      * CALCULATE INTEREST
      *
     C                   Z-ADD     P#NDYS        W#NDYS                         * NO. OF DAYS
     C                   Z-ADD     P#YBAS        W#YBAS                         * YEAR BASIS
     C                   Z-ADD     P#NOML        W#NOML                         * NOMINAL
     C     P#INPM        IFEQ      'Y'
     C                   SUB       P#TOTI        W#NOML                         * NOMINAL
     C                   ENDIF
     C                   Z-ADD     P#IRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
      *
      ** SET INTEREST ACCRUED
      ** (ACCORDING TO ROUND DOWN FACILITY)
      *
     C     P#RDFC        IFEQ      'Y'
     C                   Z-ADD     W#INT         P#INAC
     C                   ELSE
     C                   Z-ADD(H)  W#INT         P#INAC
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE COST OF FUNDS
      *********************************************************************
     C     ACC_COF       BEGSR
      *
      * CALCULATE COST OF FUNDS
      *
     C                   Z-ADD     P#NDYS        W#NDYS                         * NO. OF DAYS
     C                   Z-ADD     P#YBAS        W#YBAS                         * YEAR BASIS
     C                   Z-ADD     P#NOML        W#NOML                         * NOMINAL
     C     P#INPM        IFEQ      'Y'
     C                   SUB       P#TOTC        W#NOML                         * NOMINAL
     C                   ENDIF
     C                   Z-ADD     P#CRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
      *
      ** SET COST OF FUNDS ACCRUED
      *
     C                   Z-ADD(H)  W#INT         P#CFAC
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE CASH
      *********************************************************************
     C     ACC_CASH      BEGSR
      *
      ** CALCULATE NUMBER OF DAYS REMAINING
      ** (BETWEEN POSITION START DATE AND NEXT CASH PAYMENT DATE)
      *
     C     NxtCashDt     SUB       P#SDAT        w#ndys_rem        5 0
      *
      ** ACCRUE CASH
      *
     C     P#NDYS        IFLT      w#ndys_rem
     C     w#ndys_rem    ANDGT     *ZERO
     C     P#CASH        MULT      P#NDYS        w#accrual        15 2
     C                   DIV(H)    w#ndys_rem    w#accrual
     C                   ELSE
     C                   Z-ADD     P#CASH        w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     P#CSAC
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE DISCOUNT/PREMIUM
      *********************************************************************
     C     ACC_DISPRM    BEGSR
      *
      ** CALCULATE NUMBER OF DAYS TO ACCRUE
      ** (BETWEEN START AND END DATE OF POSITION)
      *
     C     P#EDAT        SUB       P#SDAT        w#ndys_acc        5 0
      *
      ** CALCULATE NUMBER OF DAYS REMAINING
      ** (BETWEEN POSITION START DATE AND MATURITY DATE)
      *
     C     T#MDAT        SUB       P#SDAT        w#ndys_rem        5 0
      *
      ** ACCRUE DISCOUNT/PREMIUM
      *
     C     w#ndys_acc    IFLT      w#ndys_rem
     C     w#ndys_rem    ANDNE     *ZERO
     C     P#DIPR        MULT      w#ndys_acc    w#accrual        15 2
     C                   DIV(H)    w#ndys_rem    w#accrual
     C                   ELSE
     C                   Z-ADD     P#DIPR        w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     P#DPAC
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE FEE
      *********************************************************************
     C     ACC_FEE       BEGSR
      *
      ** CALCULATE NUMBER OF DAYS TO ACCRUE
      ** (BETWEEN START AND END DATE OF POSITION)
      *
     C     P#EDAT        SUB       P#SDAT        w#ndys_acc
      *
      ** CALCULATE NUMBER OF DAYS REMAINING
      ** (BETWEEN POSITION START DATE AND MATURITY DATE)
      *
     C     T#MDAT        SUB       P#SDAT        w#ndys_rem
      *
      ** ACCRUE FEE
      *
     C     w#ndys_acc    IFLT      w#ndys_rem
     C     w#ndys_rem    ANDNE     *ZERO
     C     P#FEE         MULT      w#ndys_acc    w#accrual
     C                   DIV(H)    w#ndys_rem    w#accrual
     C                   ELSE
     C                   Z-ADD     P#FEE         w#accrual
     C                   ENDIF
     C     CLE031        IFEQ      'Y'                                                        CLE031
     C                   Z-ADD(H)  w#accrual     Fee_Acc                                      CLE031
     C                   ELSE                                                                 CLE031
     C                   Z-ADD(H)  w#accrual     P#FEAC
     C                   ENDIF                                                                CLE031
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE REALIZED PROFIT/LOSS
      *********************************************************************
     C     ACC_RLPL      BEGSR
      *
      ** CALCULATE NUMBER OF DAYS TO ACCRUE
      ** (BETWEEN START AND END DATE OF POSITION)
      *
     C     P#EDAT        SUB       P#SDAT        w#ndys_acc
      *
      ** CALCULATE NUMBER OF DAYS REMAINING
      ** (BETWEEN POSITION START DATE AND MATURITY DATE)
      *
     C     T#MDAT        SUB       P#SDAT        w#ndys_rem
      *
      ** ACCRUE REALIZED P/L
      *
     C     w#ndys_acc    IFLT      w#ndys_rem
     C     w#ndys_rem    ANDNE     *ZERO
     C     P#RLPL        MULT      w#ndys_acc    w#accrual
     C                   DIV(H)    w#ndys_rem    w#accrual
     C                   ELSE
     C                   Z-ADD     P#RLPL        w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     P#RLAC
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      ** ACCRUE SWAP PROFIT/LOSS                                                              CDE002
      *********************************************************************                   CDE002
     C     ACC_SWPL      BEGSR                                                                CDE002
      *                                                                                       CDE002
      ** CALCULATE NUMBER OF DAYS TO ACCRUE                                                   CDE002
      ** (BETWEEN START AND END DATE OF POSITION)                                             CDE002
      *                                                                                       CDE002
     C     P#EDAT        SUB       P#SDAT        w#ndys_acc                                   CDE002
      *                                                                                       CDE002
      ** CALCULATE NUMBER OF DAYS REMAINING                                                   CDE002
      ** (BETWEEN POSITION START DATE AND MATURITY DATE)                                      CDE002
      *                                                                                       CDE002
     C     T#MDAT        SUB       P#SDAT        w#ndys_rem                                   CDE002
      *                                                                                       CDE002
      ** ACCRUE REALIZED P/L                                                                  CDE002
      *                                                                                       CDE002
     C     w#ndys_acc    IFLT      w#ndys_rem                                                 CDE002
     C     w#ndys_rem    ANDNE     *ZERO                                                      CDE002
     C     P#SWPL        MULT      w#ndys_acc    w#accrual                                    CDE002
     C                   DIV(H)    w#ndys_rem    w#accrual                                    CDE002
     C                   ELSE                                                                 CDE002
     C                   Z-ADD     P#SWPL        w#accrual                                    CDE002
     C                   ENDIF                                                                CDE002
     C                   Z-ADD(H)  w#accrual     P#SWAC                                       CDE002
      *                                                                                       CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5
      *********************************************************************
      ** CALCULATE INTEREST PAID UP FRONT
      *********************************************************************
     C     CAL_INT_UF    BEGSR
      *
      ** RESET INTEREST UP FRONT AMOUNT
      *
     C                   Z-ADD     *ZERO         E#INTA
      *
      * GET NEXT INT PAYMENT DATE AFTER THIS INT PAYMENT DATE
      *
     C                   Z-ADD     1             #I
     C     E#PRDT        LOOKUP    #_ipdat(#I)                            99     *
     C                   ADD       1             #I
      *
      ** SET START DATE AND END DATE
      *
     C                   Z-ADD     E#PRDT        W#SDAT                         * START DATE
     C                   Z-ADD     #_ipdat(#I)   W#EDAT                          * END DATE
      *
      * BYPASS IF NOMINAL -VE OR ZERO
      * OR IF START DATE >= END DATE
      *
     C     P#NOML        IFLE      0
     C     W#SDAT        ORGE      W#EDAT
     C                   GOTO      ECALINTUF
     C                   ENDIF
      *
      ** CALCULATE NUMBER OF DAYS BETWEEN START DATE AND END DATE
      *
     C                   EXSR      CAL_NDYS
      *
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *
     C                   Z-ADD     W#SDAT        W#LIDT                         * LAST INT DATE
     C                   Z-ADD     W#EDAT        W#NIDT                         * NEXT INT DATE
     C                   EXSR      CAL_YBAS
      *
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *
     C                   Z-ADD     P#NOML        W#NOML                         * NOMINAL
     C     P#INPM        IFEQ      'Y'
     C                   Z-ADD     P#IRAT        W#YRAT                         * INT.RATE
     C                   EXSR      CAL_YLDA
     C                   ELSE
     C                   Z-ADD     P#IRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
     C                   ENDIF
      *
      **  SET INTEREST UP FRONT AMOUNT
      **  CHECK FOR ROUND DOWN FACILITY.
      *
     C     P#RDFC        IFEQ      'Y'
     C                   Z-ADD     W#INT         E#INTA
     C                   ELSE
     C                   Z-ADD(H)  W#INT         E#INTA
     C                   END
      *
     C     ECALINTUF     ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE COST OF FUNDS PAID UP FRONT
      *********************************************************************
     C     CAL_COF_UF    BEGSR
      *
      ** RESET COST OF FUNDS UP FRONT AMOUNT
      *
     C                   Z-ADD     *ZERO         E#COFA
      *
      * GET NEXT INT PAYMENT DATE AFTER THIS INT PAYMENT DATE
      *
     C                   Z-ADD     1             #I
     C     E#PRDT        LOOKUP    #_ipdat(#I)                            99     *
     C                   ADD       1             #I
      *
      ** SET START DATE AND END DATE
      *
     C                   Z-ADD     E#PRDT        W#SDAT                         * START DATE
     C                   Z-ADD     #_ipdat(#I)   W#EDAT                          * END DATE
      *
      * BYPASS IF NOMINAL -VE OR ZERO
      * OR IF START DATE >= END DATE
      *
     C     P#NOML        IFLE      0
     C     W#SDAT        ORGE      W#EDAT
     C                   GOTO      ECALCOFUF
     C                   ENDIF
      *
      ** CALCULATE NUMBER OF DAYS BETWEEN START DATE AND END DATE
      *
     C                   EXSR      CAL_NDYS
      *
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *
     C                   Z-ADD     W#SDAT        W#LIDT                         * LAST INT DATE
     C                   Z-ADD     W#EDAT        W#NIDT                         * NEXT INT DATE
     C                   EXSR      CAL_YBAS
      *
      * CALCULATE COST OF FUNDS (FOR NO. OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *
     C                   Z-ADD     P#NOML        W#NOML                         * NOMINAL
     C     P#INPM        IFEQ      'Y'
     C                   Z-ADD     P#CRAT        W#YRAT                         * INT.RATE
     C                   EXSR      CAL_YLDA
     C                   ELSE
     C                   Z-ADD     P#CRAT        W#IRAT                         * INT.RATE
     C                   EXSR      CAL_INTA
     C                   ENDIF
      *
      **  SET COST OF FUNDS UP FRONT AMOUNT
      **  CHECK FOR ROUND DOWN FACILITY.
      *
     C     P#RDFC        IFEQ      'Y'
     C                   Z-ADD     W#INT         E#COFA
     C                   ELSE
     C                   Z-ADD(H)  W#INT         E#COFA
     C                   END
      *
     C     ECALCOFUF     ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE CASH (DUE ON THE NEXT INTEREST PAYMENT DATE)
      *********************************************************************
     C     CAL_CASH      BEGSR
      *
      ** RESET NEXT CASH PAYMENT DATE AND CASH AMOUNT
      *
     C                   Z-ADD     *ZERO         E#NXCD
     C                   Z-ADD     *ZERO         E#CASH
      *
      * GET NEXT INT PAYMENT DATE AFTER THE CURRENT EVENT DATE
      *
     C                   Z-ADD     1             #I
     C     E#PRDT        LOOKUP    #_ipdat(#I)                            99     *
     C                   ADD       1             #I
      *
      ** NEXT CASHFLOW AMOUNT AND DATE
      *
     C     #_ipdta(#I)   IFNE      *BLANK
     C                   Z-ADD     #_ipdat(#I)   E#NXCD
     C                   MOVE      #_ipdta(#I)   E#CASH
     C                   ENDIF
 
     C     ECALCASH      ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE NUMBER OF DAYS (BETWEEN P#SDAT AND P#EDAT)
      *********************************************************************
     C     CAL_NDYS      BEGSR
 
     C                   CALLB     'DECALNDYS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      P#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM                    W#SDAT            5 0          * START DATE
     C                   PARM                    W#EDAT            5 0          * END DATE
     C                   PARM      *ZERO         W#NDYS            5 0          * NO. OF DAYS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALNDYS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** CALCULATE YEAR BASIS (GIVEN W#LIDT AND W#NIDT)
      *********************************************************************
     C     CAL_YBAS      BEGSR
 
     C                   CALLB     'DECALYBAS'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      P#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      P#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#LIDT            5 0          * LAST INT DATE
     C                   PARM                    W#NIDT            5 0          * NEXT INT DATE
     C                   PARM      *ZERO         W#YBAS            5 0          * YEAR BASIS
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALYBAS'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE INTEREST (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *********************************************************************
     C     CAL_INTA      BEGSR
 
     C                   CALLB     'DECALINTA'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    W#YBAS            5 0          * YEAR BASIS
     C                   PARM                    W#NOML           15 0          * NOMINAL
     C                   PARM      P#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM                    W#IRAT           11 7          * INT.RATE
     C                   PARM      P#CLRT        W#CLRT           11 7          * INT.RATE
     C                   PARM      P#FLRT        W#FLRT           11 7          * INT.RATE
     C                   PARM      P#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      P#ACUR        W#ACUR            1 0          * ACCURACY
     C                   PARM      *ZERO         W#INT            15 2          * INTEREST
     C                   PARM      *ZERO         W#INTP           15 9          * INTEREST %
     C                   PARM      *ZERO         W#INTF           15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALINTA'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE YIELD AMT (FOR NUMBER OF DAYS W#NDYS & YEAR BASIS W#YBAS)
      *********************************************************************
     C     CAL_YLDA      BEGSR
 
     C                   CALLB     'DECALYLDA'
     C                   PARM      *BLANK        W#RTCD            7            * RETURN CODE
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM                    W#NDYS            5 0          * NO. OF DAYS
     C                   PARM                    W#YBAS            5 0          * YEAR BASIS
     C                   PARM                    W#NOML           15 0          * NOMINAL
     C                   PARM      P#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM                    W#YRAT           11 7          * YIELD RATE
     C                   PARM      P#ACUR        W#ACUR            1 0          * ACCURACY
     C                   PARM      *ZERO         W#INT            15 2          * INTEREST
     C                   PARM      *ZERO         W#INTP           15 9          * INTEREST %
     C                   PARM      *ZERO         W#INTF           15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALYLDA'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE FORWARD RATE
      ********************************************************************
     C     CAL_FWRT      BEGSR
 
     C                   CALLB     'DECALFWRT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      P#CCY         W#CCY             3            * CURRENCY
     C                   PARM      P#ICMT        W#ICMT            7            * INT.CALC.METH.
     C                   PARM                    W#SPDT            5 0          * SPOT DATE
     C                   PARM                    W#NRDT            5 0          * NEAR DATE
     C                   PARM                    W#FRDT            5 0          * FAR DATE
     C                   PARM      P#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM                    W#LIDT            5 0          * LAST INT DATE
     C                   PARM                    W#NIDT            5 0          * NEXT INT DATE
     C                   PARM      *ZERO         W#FWRT           11 7          * FORWARD RATE
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALFWRT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      ********************************************************************
      * CALCULATE NET PRESENT VALUE
      ********************************************************************
     C     CAL_NPVL      BEGSR
 
     C                   CALLB     'DECALNPVL'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30            * ERROR MESSAGE
     C                   PARM      P#CCY         W#CCY             3            * CURRENCY
     C                   PARM                    W#SPDT            5 0          * SPOT DATE
     C                   PARM      C#DATE        W#FWDT            5 0          * FORWARD DATE
     C                   PARM      C#AMNT        W#FWAM           13 0          * FORWARD AMOUNT
     C                   PARM      *ZERO         W#DF             11 9          * DISCNT FACTOR
     C                   PARM      *ZERO         W#SPAM           13 0          * SPOT AMOUNT
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALNPVL'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      **************************************************************************
      /SPACE 5
      *********************************************************************
      ** GET LAST AND NEXT INT PAYMENT DATES STRADDLING THIS DATE
      *********************************************************************
     C     GET_LNIPDT    BEGSR
 
      ** GET LAST AND NEXT EVENT DATE
 
     C                   CALLB     'DEMNTEVDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      '*GETLNEVDT'  W#MODE           10
     C                   PARM      *BLANK        W#TYPE            2
 
      * EVENT
     C                   PARM                    E#EVNT
 
      * EVENT DATA ARRAY
     C                   PARM                    #arevdt_ip
 
      * LAST/NEXT PERIOD?
     C                   PARM                    #LN_PERIOD        1
 
      * LAST DATE
      * NEXT DATE
     C                   PARM      *ZERO         W#LIDT            5 0
     C                   PARM      *ZERO         W#NIDT            5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEMNTEVDT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** LOG EVENT DATES
      *********************************************************************
     C     LOG_EVDT      BEGSR
 
      ** LOG EVENT DATE
 
     C                   CALLB     'DEMNTEVDT'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM      '*LOGEVDT  '  W#MODE           10
     C                   PARM                    W#TYPE            2
 
      * EVENT
     C                   PARM                    E#EVNT
 
      * EVENT DATA ARRAY
     C                   PARM                    #arevdt_WK
 
      * LAST/NEXT PERIOD?
     C                   PARM                    #LN_PERIOD        1
 
      * LAST DATE
      * NEXT DATE
     C                   PARM      *ZERO         #LASTDT           5 0
     C                   PARM      *ZERO         #NEXTDT           5 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEMNTEVDT'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      * CALCULATE SPOT DATE
      *********************************************************************
     C     CAL_SPDT      BEGSR
      *
     C                   CALLB     'ZFWDT'
     C                   PARM      Run_Date      ZDAYNO            5 0
     C                   PARM      P#SPDY        ZNRDYS            2 0
     C                   PARM      *ZERO         ZDYNBR            5 0
     C                   PARM      P#CCY         ZCCY              3
     C                   PARM      *BLANK        ZLOC              3
      *
     C                   Z-ADD     ZDYNBR        W#SPDT            5 0
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5                                                                                CDE002
      *********************************************************************                   CDE002
      * DIAGNOSTICS                                                                           CDE002
      *********************************************************************                   CDE002
     C     DIAGNOS       BEGSR                                                                CDE002
      *                                                                                       CDE002
     C                   CALLB     'DEZDIAG'                                                  CDE002
     C                   PARM                    Diag_Fmt          8                          CDE002
     C                   PARM                    Ret_Code                                     CDE002
     C                   PARM                    Proj_Hist                                    CDE002
     C                   PARM                    EndofBook                                    CDE002
     C                   PARM                    T#TRAN                                       CDE002
     C                   PARM                    P#POSN                                       CDE002
     C                   PARM                    E#EVNT                                       CDE002
     C                   PARM                    C#CASH                                       CDE002
      *                                                                                       CDE002
     C                   ENDSR                                                                CDE002
      *********************************************************************                   CDE002
      /SPACE 5                                                                                CLE034
      ********************************************************************                    CLE034
      * *INZSR - Initialisation subroutine                                                    CLE034
      *          This is only called once automatically                                       CLE034
      ********************************************************************                    CLE034
     C     *INZSR        BEGSR                                                                CLE034
      *                                                                                       CLE031
      **  Access Switchable Feature details for CLE031                                        CLE031
      *                                                                                       CLE031
     C                   CALLB     'AOSARDR0'                                                 CLE031
     C                   PARM      *BLANKS       @RTCD                                        CLE031
     C                   PARM      '*VERIFY '    @OPTN                                        CLE031
     C                   PARM      'CLE031'      @SARD                                        CLE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE031
     C*                                                                                       CLE031
     C     @RTCD         IFEQ      *BLANKS                                                    CLE031
     C                   MOVEL     'Y'           CLE031            1                          CLE031
     C                   ENDIF                                                                CLE031
      *                                                                                       CLE034
      **  Access Switchable Feature details for CLE034                                        CLE034
      *                                                                                       CLE034
     C                   CALLB     'AOSARDR0'                                                 CLE034
     C                   PARM      *BLANKS       @RTCD                                        CLE034
     C                   PARM      '*VERIFY '    @OPTN                                        CLE034
     C                   PARM      'CLE034'      @SARD                                        CLE034
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE034
     C*                                                                                       CLE034
     C     @RTCD         IFEQ      *BLANKS                                                    CLE034
     C                   MOVEL     'Y'           CLE034            1                          CLE034
     C                   ENDIF                                                                CLE034
      *                                                                                       CLE034
     C                   ENDSR                                                                CLE034
      *****************************************************************                       CLE034
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      *****************************************************************
      /SPACE 5
**  CPY@
(c) Finastra International Limited 2001
** TABTYP / TABSEQ
DD01
VD02
FE03
XM03                                                                                          CDE002
MI12
SA12
PI15
PD15
IP21
OD21
RE24
MR25
SC37
BC38
RO39
PE98
MT99
** MEMTYP                                                                       208221
HACCRHACCTHFCLTHLOANHSTRDPACCTPCFCOPCUSXPEXTRPFEESPFRAS
PFUNDPFXDLPLDCLPLDNIPLOANPNASPPOTCCPSBPSPSTRDPSWAP
