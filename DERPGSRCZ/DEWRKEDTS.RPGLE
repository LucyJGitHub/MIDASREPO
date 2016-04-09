     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Work with extract data - securities')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Export module                                   *
      *                                                               *
      *  DEWRKEDTS - Work with Extract Data (Securities)              *
      *                                                               *
      *  Function:  This module receives details of all Securities    *
      *             Trading Book Positions and Trade transactions.    *
      *             These are received with an opening balance and    *
      *             with all events. At this stage, these are simply  *
      *             stored in arrays until called in processing       *
      *             mode, at which point all period end positions     *
      *             and cash flows are calculated. The module may     *
      *             then be called to return all transactions, all    *
      *             positions, all events and all cash flows.         *
      *                                                               *
      *  Component of: DEPXTSBPS                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD031             Date 10Apr06               *
      *                 CSE075             Date 17Nov05               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 05Aug03               *
      *                 CDE005             Date 21Aug02               *
      *                 CAS006             Date 21Jan03               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002             Date 05Dec00               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 15May01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CDE001  *CREATE    Date 23Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce records for backvalued transactions.  *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CAS006 - Hedge Accounting Phase B (Recompile)                *
      *  208221 - Changes identified during alpha site                *
      *           Enable DEWRKEDTS to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax.                             *
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
     D TABTYP          S              2    DIM(8) CTDATA PERRCD(1)
     D TABSEQ          S              2  0 DIM(8) ALT(TABTYP)
 
                                                                                              208221
     D LongArr         S              1                                                       208221
                                                                                              208221
 
     D SECTY         E DS                  EXTNAME(SECTYD) PREFIX(SE_)
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                                  CDE002
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      * NOTES ON DATES:
 
      **If*in*'HISTORIC'*mode******************************************                       CDE002
      **---------------------******                                                           CDE002
      **I*******I*******I*******I**     I       I       I       I       I                     CDE002
      ******[**********************         [                       [                         CDE002
      ******!**********************         !                       !                         CDE002
      ***History*******************        Run                   Date of                      CDE002
      ***Cut-Off*******************        Date                    Next                       CDE002
      ****Date*********************      =Extract                Working                      CDE002
      *****************************        Date                    Day                        CDE002
      *****************************                                                           CDE002
      **If*in*'PROJECTED'*mode*****                                                           CDE002
      **----------------------*****                                                           CDE002
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
     C**********         PARM                    Extrct_Dat        5 0                        CDE002
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
      * SECURITY
     C                   PARM                    SECTY
      * PROCESSING TYPE
     C                   PARM                    IN_PROT           1
      * SDBANK
     C                   PARM                    SDBANK
      * SDGELR                                                                                CDE002
     C                   PARM                    SDGELR                                       CDE002
     C                   PARM                    Dataarea        128                          208221
     C*                                                                                       208221
     C                   EVAL      LongArr = %subst(Dataarea:95:1)                            208221
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
     C                   CLEAR                   #_mpdat
     C                   CLEAR                   #_mpdta
     C                   CLEAR                   #_ppdat
     C                   CLEAR                   #_ppdta
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
      ** RESET 'VALUE DATE PROCESSED', 'MATURITY DATE PROCESSED'
      ** AND 'CURRENT POSITION PROCESSED' INDICATORS
      *
     C                   MOVEL     *BLANK        ValDat_P          1
     C                   MOVEL     *BLANK        MatDat_P          1
     C                   MOVEL     *BLANK        CurPos_P          1
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
     C     E#EVTP        IFEQ      'IR'
     C     E#EVTP        OREQ      'MT'
     C     E#PRDT        IFLT      T#DDAT
     C                   EXSR      RATECHG
     C                   ENDIF
     C                   MOVEL     'IR'          W#TYPE
     C                   MOVEL     #arevdt_ir    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_ir
     C                   ENDIF
      *
      * IF EVENT IS A PART PAYMENT DATE
      * LOG DATE IN PART PAYMENT DATES ARRAY
      *
     C     E#EVTP        IFEQ      'PP'
     C     E#PRDT        IFLT      T#DDAT
     C                   EXSR      PARTPAY
     C                   ENDIF
     C                   MOVEL     'PP'          W#TYPE
     C                   MOVEL     #arevdt_pp    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_pp
     C                   ENDIF
      *
      * IF EVENT IS A MORTGAGE PAYMENT DATE
      * LOG DATE IN MORTGAGE PAYMENT DATES ARRAY
      *
     C     E#EVTP        IFEQ      'MP'
     C     E#PRDT        IFLT      T#DDAT
     C                   EXSR      MORTPAY
     C                   ENDIF
     C                   MOVEL     'MP'          W#TYPE
     C                   MOVEL     #arevdt_mp    #arevdt_WK
     C                   EXSR      LOG_EVDT
     C                   MOVEL     #arevdt_WK    #arevdt_mp
     C                   ENDIF
      *
      * IF THIS IS A PROJECTED EXTRACT
      * AND THE EVENT DATE IS AFTER THE PROJECTIONS CUT-OFF DATE
      * OR THE EVENT DATE IS PRIOR TO THE TRANSACTION DEAL DATE
      *     IGNORE THE EVENT
      *
     C     Proj_Hist     IFEQ      'P'
     C     E#EVTP        ANDNE     'PE'                                                       CDE002
     C     E#PRDT        ANDGT     ProjCO_Dat
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
      ** EVENT DATE OF FIRST EVENT ON OR AFTER THE TRANSACTION DEAL DATE
      *
     C     P@PRDT        IFEQ      *ZERO
     C     E#PRDT        ANDGE     T#DDAT
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
 
      * Initialize for interest calculation
 
     C                   MOVEL     '*INIT     '  W#MODE
     C                   EXSR      MNT_POSD
     C                   MOVEL     '*INIT     '  W#MODE
     C                   EXSR      CAL_INTM
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
      **IF*EVENT*DATE*>*INITIAL*INTEREST*ACCRUAL*CONTROL*DATE**********                       CDE002
      * If previous event date >= initial interest accrual control date                       CDE002
      * DO ACCRUALS
      *
     C*****E#PRDT***     IFGT      I_P#IACD                                                   CDE002
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
     C     E#EVTP        CASEQ     'TP'          TRADE
     C     E#EVTP        CASEQ     'TS'          TRADE
     C     E#EVTP        CASEQ     'IP'          INTPAY
     C     E#EVTP        CASEQ     'IR'          RATECHG
     C     E#EVTP        CASEQ     'PP'          PARTPAY
     C     E#EVTP        CASEQ     'MP'          MORTPAY
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
      * IF AT LEAST ONE EVENT HAS BEEN READ
      *
     C     P@PRDT        IFNE      *ZERO
      *
      * IF NO POSITIONS HAVE BEEN PRODUCED
      **OR*IF*THE*MATURITY*DATE*POSITION*HAS*BEEN*NOT*BEEN*PRODUCED****                       CDE002
      * Or if the current position date < latest event date                                   CDE002
      *
     C*****#_posn(1)     IFEQ      *BLANK                                       208221
     C     LongArr       IFEQ      *BLANKS                                      208221
     C     #_posn(1)     ANDEQ     *BLANK                                       208221
     C     LongArr       OREQ      'L'                                          208221
     C     #_posL(1)     ANDEQ     *BLANK                                       208221
     C     LongArr       OREQ      'S'                                          208221
     C     #_posS(1)     ANDEQ     *BLANK                                       208221
     C     P#IACD        ORLT      E#PRDT                                                     CDE002
     C*****MatDat_P      OREQ      'Y'                                                        CDE002
     C*****P#IACD        ANDNE     T#MDAT                                                     CDE002
      *
      * SET POSITION DETAILS
      *
     C                   EXSR      SET_POSD
      *
      **IF*EVENT*DATE*>*INITIAL*INTEREST*ACCRUAL*CONTROL*DATE**********                       CDE002
      * If previous event date >= initial interest accrual control date                       CDE002
      * DO ACCRUALS
      *
     C*****E#PRDT        IFGT      I_P#IACD                                                   CDE002
     C     P@PRDT        IFGE      I_P#IACD                                                   CDE002
     C                   EXSR      DO_ACC
     C                   ENDIF
      *
      * ADD A POSITION INTO THE POSITIONS ARRAY
      *
     C                   EXSR      UPD_POSN
 
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** TRADE (PURCHASE OR SALE)
      *********************************************************************
     C     TRADE         BEGSR
      *
      **  MAINTAIN POSITION DATA
      *
     C                   MOVEL     *BLANK        W#MODE
     C                   MOVEL     E#EVTP        TD_TDTP
     C                   Z-ADD     E#PRDT        TD_TDVD
     C                   Z-ADD     E#PRAM        TD_CONS
     C                   Z-ADD     E#INTA        TD_PINT
     C                   Z-ADD     E#NOML        TD_NOML
     C                   MOVEL     E#ACIN        TD_ACIN
     C                   Z-ADD     E#PRIC        TD_PRIC
     C                   EXSR      MNT_POSD
      *
      ** Update average price
      *
     C                   Z-ADD     PS_AVPR       P#AVPR
      *
      ** Add realized P/L, charges and commissions to position
      *
     C                   ADD       PS_RLPL       P#RLPL
     C                   ADD       E#CHRG        P#CHRG
     C                   ADD       E#COMM        P#COMM
      *
      * UPDATE CASHFLOW ARRAY
      *
     C     E#SSET        IFNE      'Y'
     C                   CLEAR                   C#CASH
      * countervalue
     C                   MOVEL     'C'           C#CATG
     C                   MOVEL     E#SETC        C#CCY
     C                   MOVEL     E#NCDP        C#CDP
     C                   Z-ADD     E#TAMT        C#AMNT
      * in/out
     C     E#EVTP        IFEQ      'TP'
     C                   MOVEL     'O'           C#IO
     C                   ELSE
     C                   MOVEL     'I'           C#IO
     C                   ENDIF
 
      * settlement instructions
     C                   MOVEL     E#SETD        C#SETD
      *
     C                   EXSR      UPD_CASH
     C                   ENDIF
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** INTEREST PAYMENT
      *********************************************************************
     C     INTPAY        BEGSR
      *
      ** CALCULATE INTEREST TO PAYMENT DATE
      *
     C                   MOVEL     *BLANK        W#MODE
     C                   Z-ADD     E#PRDT        W#EDAT                         * START DATE
     C                   MOVEL     'L'           #LNIPERIOD
     C                   EXSR      CAL_INTM
     C                   Z-ADD(H)  W#TINT        Int_Due          15 0
      *
      **   UPDATE INTEREST PAID TO DATE
      *
     C                   ADD       Int_Due       P#IPRD
      *
      **  UPDATE TOTAL ACCRUED INTEREST
      *
     C                   Z-ADD     P#IPRD        P#AITC
      *
      * UPDATE CASHFLOW ARRAY
      *
     C     Int_Due       IFNE      *ZERO
     C                   CLEAR                   C#CASH
      * interest
     C                   MOVEL     'I'           C#CATG
     C                   Z-ADD     Int_Due       C#AMNT
      * in/out
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C#IO
     C                   ELSE
     C                   MOVEL     'O'           C#IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E#SETD        C#SETD
      *
     C                   EXSR      UPD_CASH
     C                   ENDIF
      *
     C     INTEND        ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** RATE CHANGE
      *********************************************************************
     C     RATECHG       BEGSR
      *
      ** UPDATE RATE
      *
     C                   Z-ADD     E#IRAT        P#IRAT
                                                                                              CDE002
     C                   MOVEL     'Y'           P#RCTY                                       CDE002
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      **  PART PAYMENT EVENT(S)
      *********************************************************************
     C     PARTPAY       BEGSR
      *
      * Update current partly paid price
      *
     C     P#FUPP        IFNE      E#CPDP
     C     P#FUPP        ANDNE     0
     C     E#CPDP        DIV       P#FUPP        PS_PPCP
     C                   ELSE
     C                   Z-ADD     1             PS_PPCP
     C                   ENDIF
      *                                                                                       208221
      ** Increment number of repayments                                                       208221
      *                                                                                       208221
     C                   ADD       1             W#RENO                                       208221
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      **  MORTGAGE PAYMENT EVENT(S)
      ********************************************************************
     C     MORTPAY       BEGSR
      *
      * Update current factor
      *
     C                   Z-ADD     E#CFCT        PS_CFCT
      *
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
      *
      * DEFINED NOMINAL AT MATURITY
      *
     C     E#NOML        IFNE      *ZERO
     C                   Z-ADD     E#NOML        P#NOML
     C                   ENDIF
      *
      * UPDATE CASHFLOW ARRAY
      *
     C     P#NOML        IFNE      *ZERO
     C     E#SSET        ANDNE     'Y'
     C                   CLEAR                   C#CASH
      * principal
     C                   MOVEL     'P'           C#CATG
     C                   Z-ADD     P#NOML        C#AMNT
      * in/out
     C     P#ASLI        IFEQ      'A'
     C                   MOVEL     'I'           C#IO
     C                   ELSE
     C                   MOVEL     'O'           C#IO
     C                   ENDIF
      * settlement instructions
     C                   MOVEL     E#SETD        C#SETD
      *
     C                   EXSR      UPD_CASH
     C                   ENDIF
      *
      ** SET 'MATURITY DATE PROCESSED' INDICATOR
      *
     C                   MOVEL     'Y'           MatDat_P
      *
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
 
      ** Calculate Transaction Mark to Market Value
      ** (if 'current' or 'latest' position and market price is <> 0)
 
     C     P#PSTP        IFEQ      'C'
     C     P#PSTP        OREQ      'L'
     C     SE_MKPR       IFNE      *ZERO
     C                   EXSR      CAL_TMKVL
     C                   ENDIF
     C                   ENDIF
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
 
      **  Update TOTAL ACCRUED INTEREST
 
     C     P#ACIN        IFEQ      'Y'
     C                   ADD       P#INAC        P#AITC
     C                   ENDIF
 
      ** Update DISCOUNT/PREMIUM (outstanding) and CONSIDERATION
 
     C     P#ACDP        IFEQ      'Y'
     C                   SUB       DisPrm_NAC    P#DIPR
     C                   ADD       DisPrm_NAC    P#CONS
     C                   ELSE
     C                   Z-ADD     *ZERO         P#DIPR
     C                   ENDIF
 
      **  Reset REALIZED P/L
 
     C                   Z-ADD     *ZERO         P#RLPL
 
      * Reset CHARGES & COMMISSIONS
 
     C                   Z-ADD     *ZERO         P#CHRG
     C                   Z-ADD     *ZERO         P#COMM
                                                                                              CDE002
      * Reset Position Statistics                                                             CDE002
                                                                                              CDE002
     C                   MOVEL     *BLANK        P#ROTY                                       CDE002
     C                   MOVEL     *BLANK        P#PITY                                       CDE002
     C                   MOVEL     *BLANK        P#RCTY                                       CDE002
     C                   Z-ADD     *ZERO         P#MVNO                                       CDE002
     C                   Z-ADD     *ZERO         P#RENO                                       CDE002
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** SET POSITION TYPE
      *********************************************************************
     C     SET_PSTP      BEGSR
 
      * I = IGNORE for export
      * C = Projected export - CURRENT POSITION
      *     (current position is first position exported)
      * L = Historic  export - LATEST POSITION
      *     (latest position is last position exported)
 
     C                   SELECT
 
     C     Proj_Hist     WHENEQ    'P'
 
     C*****P#IACD        IFLT      Extrct_Dat                                                 CDE002
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
 
     C     Proj_Hist     WHENEQ    'H'
 
     C*****P#IACD        IFGE      Extrct_Dat                                                 CDE002
     C     P#IACD        IFGT      EvtCtl_Dat                                                 CDE002
     C     P#IACD        ORLT      HistCO_Dat
     C                   MOVEL     'I'           P#PSTP
     C                   ELSE
     C*****P#EDAT        IFEQ      Extrct_Dat                                                 CDE002
     C     P#IACD        IFEQ      EvtCtl_Dat                                                 CDE002
     C                   MOVEL     'L'           P#PSTP
     C                   ELSE
     C                   MOVEL     *BLANK        P#PSTP
     C                   ENDIF
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
     C     E#NXCD        IFNE      *ZERO
     C                   MOVEL     E#NXCD        C#DATE
     C                   ELSE
     C                   MOVEL     E#PRDT        C#DATE
     C                   ENDIF
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
      *
      * Due indicator
      *
     C     Proj_Hist     IFEQ      'P'
     C*****C#DATE        ANDLE     EvtCtl_Dat                                                 CDE002
     C*****C#DATE        ANDGE     Extrct_Dat                                                 CDE002
     C     C#DATE        ANDGE     Run_Date                                                   CDE002
     C     C#DATE        ANDLT     Date_NWD                                                   CDE002
     C                   MOVE      'Y'           C#DUEI
     C                   ENDIF
      *
     C                   ADD       1             IMcash
     C                   SELECT                                                 208221
     C     LongArr       WHENEQ    *BLANKS                                      208221
     C                   MOVEL     C#CASH        #_cash(IMcash)
     C     LongArr       WHENEQ    'L'                                          208221
     C                   MOVEL     C#CASH        #_cshL(IMcash)                 208221
     C     LongArr       WHENEQ    'S'                                          208221
     C                   MOVEL     C#CASH        #_cshS(IMcash)                 208221
     C                   ENDSL                                                  208221
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** EXPORT TRANSACTION
      *********************************************************************
     C     EXP_TRAN      BEGSR
     C                   MOVEL     'EXP_TRAN'    Diag_Fmt                                     CDE002
      *
      * Return the transaction details
      * Don't return details for backvalued transactions                                      219833
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
     C*****E#PRDT        ANDLT     Extrct_Dat                                                 CDE002
     C     E#PRDT        ANDLT     Run_Date                                                   CDE002
     C     Proj_Hist     OREQ      'P'
     C     E#PRCD        ANDEQ     'Y'
     C     Proj_Hist     OREQ      'H'
     C*****E#PRDT        ANDGE     Extrct_Dat                                                 CDE002
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
     C*****C#DATE        ANDLT     Extrct_Dat                                                 CDE002
     C     C#DATE        ANDLT     Run_Date                                                   CDE002
     C     Proj_Hist     OREQ      'P'
     C     C#PRCD        ANDEQ     'Y'
     C     Proj_Hist     OREQ      'H'
     C*****C#DATE        ANDGE     Extrct_Dat                                                 CDE002
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
     C                   Z-ADD     W#MVNO        P#MVNO                         * END DATE    CDE002
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
      ** RESET INTEREST ACCRUED
      ** RESET DISCOUNT/PREMIUM ACCRUED
      *
     C                   Z-ADD     *ZERO         P#INAC
     C                   Z-ADD     *ZERO         P#DPAC
     C                   Z-ADD     *ZERO         DisPrm_NAC
 
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
      * ACCRUE DISCOUNT/PREMIUM
      *
     C     P#ACDP        IFEQ      'Y'
     C     P#DIPR        ANDNE     *ZERO
     C     T#MDAT        ANDNE     *ZERO
     C     T#MDAT        ANDNE     99999
     C                   EXSR      ACC_DISPRM
     C                   ENDIF
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE INTEREST
      *********************************************************************
     C     ACC_INT       BEGSR
      *
      ** CALCULATE INTEREST TO START DATE
      *
     C                   MOVEL     *BLANK        W#MODE
     C                   Z-ADD     P#SDAT        W#EDAT                         * START DATE
     C                   MOVEL     'N'           #LNIPERIOD
     C                   EXSR      CAL_INTM
     C                   Z-SUB     W#TINT        W#TINTnet        15 2
      *
      ** CALCULATE INTEREST TO END DATE
      *
     C                   MOVEL     *BLANK        W#MODE
     C                   Z-ADD     P#EDAT        W#EDAT                         * START DATE
     C                   MOVEL     'L'           #LNIPERIOD
     C                   EXSR      CAL_INTM
     C                   ADD       W#TINT        W#TINTnet        15 2
      *
      ** ACCRUED INTEREST = INTEREST TO END DATE - INTEREST TO START DATE
      *
     C                   Z-ADD(H)  W#TINTnet     P#INAC
      *
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      *********************************************************************
      ** ACCRUE DISCOUNT/PREMIUM
      *********************************************************************
     C     ACC_DISPRM    BEGSR
      *
      ** CALCULATE NUMBER OF DAYS BETWEEN START DATE AND MATURITY DATE
      *
     C                   Z-ADD     P#SDAT        W#SDAT                         * START DATE
     C                   Z-ADD     T#MDAT        W#EDAT                         * END DATE
     C                   EXSR      CAL_NDYS
      *
      ** ACCRUE DISCOUNT/PREMIUM
      *
     C     P#NDYS        IFLT      W#NDYS
     C     W#NDYS        ANDNE     *ZERO
     C     P#DIPR        DIV(H)    W#NDYS        w#accrual        15 2
     C                   MULT      P#NDYS        w#accrual
     C                   ELSE
     C                   Z-ADD     P#DIPR        w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     DisPrm_NAC       15 0
     C     P#MORT        IFEQ      'Y'
     C                   MULT      PS_CFCT       w#accrual
     C                   ENDIF
     C                   Z-ADD(H)  w#accrual     P#DPAC
      *
     C                   ENDSR
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
      * CALCULATE INTEREST FOR MANY PERIODS
      *********************************************************************
     C     CAL_INTM      BEGSR
 
     C                   CALLB     'DECALINTM'
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    W#MODE           10
 
     C                   PARM      P#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
 
     C                   PARM      P#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      P#IPY         W#IPY             2 0          * INT PAY PER YR
 
     C                   PARM      P#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      P#MORT        W#MORT            1            * YEN BOND ?
     C                   PARM      P#PART        W#PART            1            * YEN BOND ?
     C                   PARM      P#FUPP        W#FUPP           15 0          * NOMINAL
     C                   PARM      P#ACUR        W#ACUR            1 0          * ACCURACY
 
     C                   PARM      P#NOML        W#NOML           15 0          * NOMINAL
     C                   PARM      *ZERO         W#SDAT            5 0
     C                   PARM                    W#EDAT            5 0
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
 
      * LAST/NEXT INTEREST PERIOD?
     C                   PARM                    #LNIPERIOD        1
      * Outputs
     C                   PARM      *ZERO         W#TINT           15 2          * INTEREST
     C                   PARM      *ZERO         W#TINTP          15 9          * INTEREST %
     C                   PARM      *ZERO         W#TINTF          15 9          * INTEREST FACTOR
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DECALINTM'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
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
      * CALCULATE TRANSACTION MARK TO MARKET VALUE
      *********************************************************************
     C     CAL_TMKVL     BEGSR
      *
      * If this is a price traded security, the market price is as defined
      *
     C     SE_STBS       IFEQ      'P'
     C                   Z-ADD     SE_MKPR       ZPRC
      *
      * Otherwise, if this is a yield or discount traded security
      *
     C                   ELSE
      *
      ** Calculate PI as a fraction of Nominal
      *
     C     P#NOML        IFNE      0
     C     P#PINT        DIV       P#NOML        WrkPI
     C                   ELSE
     C                   Z-ADD     0             WrkPI
     C                   END
      *
      ** Calculate % price from yield/discount
      *
     C                   CALLB     'ZPRCI'
     C                   PARM      SE_MKPR       ZPRCIN           15 8
     C**********         PARM      Extrct_Dat    ZFDATE            5 0                        CDE002
     C                   PARM      Run_Date      ZFDATE            5 0                        CDE002
     C                   PARM                    SECTY
     C                   PARM      P#NCDP        NomCcyDec         1 0
     C                   PARM      IN_PROT       ZPROT             1
     C                   PARM      P#NOML        ZNOML            15 0
     C                   PARM                    WrkPI            15 9
     C                   PARM      'C'           SCUMEX            1
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ZYLDOk            1
     C                   PARM      *ZERO         ZPRCOT           15 8
 
     C                   Z-ADD     ZPRCOT        ZPRC
 
     C                   ENDIF
      *
     C                   CALLB     'ZCNSD'
     C                   PARM      P#NOML        ZNOML            15 0
     C                   PARM                    ZPRC             16 9
     C                   PARM      P#SPBS        Z#SPBS            1
     C                   PARM      P#NMDP        Z#NMDP            1 0
     C                   PARM      P#NCDP        Z#NCDP            1 0
     C                   PARM      *ZERO         ZCONS            15 0
      *
     C                   Z-ADD     ZCONS         T#MKVL
 
      * Update the transaction with the market value
 
     C                   MOVEL     T#TRAN        #_tran(1)
      *
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
      /SPACE 5
      *********************************************************************
      * MAINTAIN POSITION DATA
      *********************************************************************
     C     MNT_POSD      BEGSR
 
     C                   CALLB     'DEMNTPOSD'
      * inputs
     C                   PARM      *BLANK        W#RTCD            7
     C                   PARM      *BLANK        W#ERMS           30
     C                   PARM                    W#MODE           10
 
     C                   PARM      P#NCDP        W#NCDP            1 0          * NOM. CCY DEC.P.
     C                   PARM      P#NMDP        W#NMDP            1 0          * NOM.DEC.PLCS
     C                   PARM      P#ICMT        W#ICMT            7            * INT CAL MTHD
     C                   PARM      P#IPY         W#IPY             2 0          * INT PAY PER YR
     C                   PARM      P#SPBS        W#SPBS            1            * NOM. CCY DEC.P.
     C                   PARM      P#YBON        W#YBON            1            * YEN BOND ?
     C                   PARM      P#MORT        W#MORT            1            * YEN BOND ?
     C                   PARM      P#PART        W#PART            1            * YEN BOND ?
     C                   PARM      P#FUPP        W#FUPP           15 0          * NOMINAL
     C                   PARM      P#ACUR        W#ACUR            1 0          * ACCURACY
      * Event dates & data
     C                   PARM                    #arevdt_ip
     C                   PARM                    #arevdt_ir
     C                   PARM                    #arevdt_mp
     C                   PARM                    #arevdt_pp
 
     C                   PARM      P#NOML        P_PS_NOML        15 0
     C                   PARM      P#XNML        P_PS_XNML        15 0
     C                   PARM      P#CONS        P_PS_CONS        15 0
     C                   PARM      P#PINT        P_PS_PINT        15 0
     C                   PARM      P#DIPR        P_PS_DIPR        15 0
 
     C                   PARM                    TD_TDTP           2
     C                   PARM                    TD_ACIN           1
     C                   PARM                    TD_TDVD           5 0
     C                   PARM                    TD_NOML          11 0
     C                   PARM                    TD_PRIC          15 8
     C                   PARM                    TD_CONS          15 0
     C                   PARM                    TD_PINT          15 0
 
     C                   PARM                    PS_CFCT          10 9
     C                   PARM                    PS_PPCP          10 9
 
      * outputs
     C                   PARM                    P#ASLI            1
     C                   PARM                    P#NOML           15 0
     C                   PARM                    P#XNML           15 0
     C                   PARM                    P#CONS           15 0
     C                   PARM                    P#PINT           15 0
     C                   PARM                    P#DIPR           15 0
 
     C                   PARM                    PS_AVPR          15 8
     C                   PARM                    PS_RLPL          15 0
 
     C     W#RTCD        IFEQ      '*ERROR'
     C                   EVAL      Err_Mess = 'ERROR IN CALL TO DEMNTPOSD'
     C                   EXSR      *PSSR
     C                   END
 
     C                   ENDSR
      *********************************************************************
      /SPACE 5
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR_WK
      *****************************************************************
      /SPACE 5
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
** TABTYP / TABSEQ
PP05
MP20
IP30
TP40
TS40
IR50
PE98
MT99
