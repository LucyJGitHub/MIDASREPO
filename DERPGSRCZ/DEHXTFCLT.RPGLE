     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist ext of cust lending facilities')         *
/*OVRF*: OVRDBF FILE(DEHCASHPD) MEMBER(FCLT)                        : *
/*OVRF*: OVRDBF FILE(DEHEVNTPD) MEMBER(FCLT)                        : *
/*OVRF*: OVRDBF FILE(DEHPOSNPD) MEMBER(FCLT)                        : *
/*OVRF*: OVRDBF FILE(DEHTRANPD) MEMBER(FCLT)                        : *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  DEHXTFCLT - Historic Extract of Customer Lending Facilities  *
      *                                                               *
      *  Function:  This module will perform the extraction of        *
      *             Customer Lending Facility transactions for the    *
      *             analysis of revenue within CCRM.                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CLE134             Date 01Aug12               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE034             Date 16Sep03               *
      *                 219833             Date 07Aug03               *
      *                 216909             Date 14Apr03               *
      *                 CAP073             Date 18Mar03               *
      *                 CDE005             Date 22Aug02               *
      *                 CLE029             Date 04Sep02               *
      *                 217456             Date 16Jun03               *
      *                 CLE028             Date 27Jun02               *
      *                 CDE003             Date 11Dec02               *
      *                 208221             Date 11Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *  CDE005 - Data Export - Reservation ID (Recompile)            *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  217456 - Change READ on FACHSAL1 to a READE using the keylist*
      *  CLE028 - Flat Rate Personal Loans (Rule of 78s)              *
      *           (Recompile)                                         *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - Enable DEWRKEDTA to get info from data area         *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         End of file indicator                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SrXTInit    - Initial Processing                              *
      * SrXTMain    - Main Processing                                 *
      * SrTranit    - Transaction Initialisation                      *
      * Import      - Import Process                                  *
      * SrImpOPos   - Import Opening Position                         *
      * SrImpoMvt   - Import Movement Event                           *
      * *PSSR       - Error processing                                *
      * *INZSR      - Initialise                                      *
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
      *
      ** LE Facility history details by date
     FFACHSAL1  IF   E           K DISK    INFSR(*PsSR)
      *
      ** DE Historic transaction details
     FDEHTRANPD O    E             DISK    INFSR(*PsSR)
      *
      ** DE Historic positions
     FDEHPOSNPD O    E             DISK    INFSR(*PsSR)
      *
      ** DE Historic events
     FDEHEVNTPD O    E             DISK    INFSR(*PsSR)
      *
      ** DE Historic cash flows
     FDEHCASHPD O    E             DISK    INFSR(*PsSR)
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      ** Standard D-specs
      ** ================
 
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
      /COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
      /COPY ZACPYSRC,PSDS
 
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
      ** ¦ D-specs: Arrays and Data Structures  ¦
      ** ¦ ===================================  ¦
      ** +--------------------------------------+
      *
      ** Externally described DS for Facility details
     D DSFCLTYX      E DS                  EXTNAME(FCLTYFM)
     D                                     PREFIX(FC_)
      *
      ** Externally described DS for Facility history details
     D DSFACHISX     E DS                  EXTNAME(FACHISA)
     D                                     PREFIX(FH_)
      *
      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for General ledger ICD
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      *
      ** Externally described DS for Facility types
     D SDFACT        E DS                  EXTNAME(SDFACTPD)
      *
      ** Externally described DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** First DS for Access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** Second DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      /EJECT
      *****************************************************************
      * E X T R A C T   F I L E S
      /COPY DECPYSRC,DEXTFILS
      *****************************************************************
      /EJECT
      *****************************************************************
      * E X T R A C T   P E R I O D   D E F I N I T I O N
      /COPY DECPYSRC,DEXTPERDD
      *****************************************************************
 
     D W#FCID          DS
     D**W#CNUM**               1      6  0                                                    CSD027
     D  W#CNUM                 1      6A                                                      CSD027
     D  W#FACT                 7      9  0
     D  W#FCNO                10     11  0
      *
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             01     01
 
      ** +--------------------------------------+
      ** ¦ D-specs: Declared variables          ¦
      ** ¦ =======  ==================          ¦
      ** +--------------------------------------+
      *
      ** Work Parameters
     D I#ACTN          S              1A
     D I#PH            S              1A
     D I#EOB           S              1A
     D PCurr           S              3A
     D PKey            S              3A
     D I#EXTT          S              4A
     D I#RTCD          S              7A
     D PRtCd           S              7A
     D POptn           S              7A
     D I#ERMS          S             30A
 
     D I#RDNB          S              5P 0
     D I#DNWD          S              5P 0
     D I#HCOD          S              5P 0
     D I#EVCD          S              5P 0
     D I#PCOD          S              5P 0
      *
      ** Work Variables
     D POSN_Exp        S              1A
     D EVNT_Exp        S              1A
     D CASH_Exp        S              1A
 
     D WDate           S              5  0
     D WStartBal       S             13  0
     D WAmount         S             13  0
      *
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
 
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initial processing
      *
     C                   EXSR      SrXTInit
      *
      ** Main processing
      *
     C                   EXSR      SrXTMain
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXTInit - Initial Processing                                *
      *                                                               *
      *****************************************************************
     C     SrXTInit      BEGSR
      *
      ** Access bank details via access program
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOBANKR0'
     C                   EVAL      *INLR  = *ON
     C                   ENDIF
      *
      ** Access general ledger ICD via access program
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOGELRR0'
     C                   EVAL      *INLR  = *ON
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrXTMain - Main Processing                                   *
      *                                                               *
      *****************************************************************
     C     SrXTMain      BEGSR
      *
      ** Transaction initialisation
      *
     C                   EXSR      SrTranit
      *
      ** Perform main subroutine in /COPY DEXTMAINO
      *
     C                   EXSR      MAIN
      *
      ** Perform Commitment as per /COPY DEXTCOMMO
      *
     C                   EXSR      COMIT
 
     C                   RETURN
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTranit - Transaction initialisation                        *
      *                                                               *
      *****************************************************************
     C     SrTranit      BEGSR
      *
      ** Clear projected transaction data structure
      *
     C                   CLEAR                   T#TRAN
      *
      ** Set transaction module
     C                   EVAL      T#MOD = 'LE'
      *
      ** Set transaction reference
     C                   EVAL      W#CNUM = FC_CNUM
     C                   EVAL      W#FACT = FC_FACT
     C                   EVAL      W#FCNO = FC_FCNO
     C                   EVAL      T#TREF = W#FCID
      *
      ** Set transaction type and sub-type
     C                   MOVEL     FC_FACT       T#TRTP
     C                   EVAL      T#TRST = *BLANKS
      *
      ** Access facility type details to set transaction description
     C                   MOVE      FC_FACT       PKey
 
     C                   CALLB     'AOFACTR0'
     C                   PARM      '*MSG   '     PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM                    PKey
     C     SDFACT        PARM      SDFACT        DSFDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOFACTR0'
     C                   EVAL      *INLR  = *ON
     C                   ELSE
     C                   EVAL      T#TDES = AMFCNM
     C                   ENDIF
      *
      ** Set transaction deal date, value date and maturity date
     C                   IF        FC_ORED < FC_DTAP
     C                   EVAL      T#DDAT = FC_ORED
     C                   ELSE
     C                   EVAL      T#DDAT = FC_DTAP
     C                   ENDIF
     C                   EVAL      T#VDAT = FC_DTAP
     C                   EVAL      T#MDAT = FC_DTEX
      *
      ** Set transaction branch
     C                   EVAL      T#BRCA = FC_BRCA
      *
      ** Set transaction counterparty and risk customer
     C                   EVAL      T#CPTY = FC_CNUM
     C                   EVAL      T#RCST = FC_CNUM
      *
      ** Call ccy access object with the facility currency code
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*KEY'        POptn
     C                   PARM      FC_FCCY       PCurr
     C     SDCURR        PARM      SDCURR        DSSDY
 
     C                   IF        PRtCd <> *BLANKS
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOCURRR0'
     C                   EVAL      *INLR  = *ON
     C                   ENDIF
      *
      ** Set transaction action
     C                   EVAL      T#ACTN = I#ACTN
      *
      ** Import transaction
     C                   EVAL      W#MODE = '*IMPTRAN'
     C                   EXSR      WRKEDTA
      *
      ** Set Position, Events and Cashflow exported indicator
     C                   EVAL      POSN_Exp = *BLANKS
     C                   EVAL      EVNT_Exp = *BLANKS
     C                   EVAL      CASH_Exp = *BLANKS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  Import - Import process                                      *
      *                                                               *
      *****************************************************************
     C     Import        BEGSR
      *
      ** Set start balance
     C                   EVAL      WStartBal = FH_FACFAM
      *
      ** Import Opening Position
     C                   EXSR      SrImpOPos
 
     C     WKeyList1     SETGT     FACHSAL1
     C     WKeyList2     READE     FACHSAL1                               01
 
     C                   DOW       EndOfFile = False
 
     C                   EVAL      WDate     = FADATE
     C                   EVAL      WAmount   = WStartBal - FACFAM
     C**********         EVAL      WStartBal = FC_FAMT                                        217456
     C                   EVAL      WStartBal = FACFAM                                         217456
      *
      ** Import movement event if work amount is not zero.
     C                   IF        WAmount <> 0
     C                   EXSR      SrImpoMvt
     C                   ENDIF
 
     C**********         READ      FACHSAL1                               01                  217456
     C     WKeyList2     READE     FACHSAL1                               01                  217456
 
     C                   ENDDO
      *
      ** Clear event details data structure
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set event module and event transaction accoriding to the
      ** transaction details
     C                   EVAL      E#TKEY = T#TKEY
      *
      ** Event Asset/Liability indicator
     C                   EVAL      E#ASLI = 'A'
      *
      ** Event processing date
     C                   EVAL      E#PRDT = FC_DTEX
      *
      ** Event type
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Event suppress settlement
     C                   EVAL      E#SSET = 'Y'
      *
      ** Import maturity date event
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EXSR      WRKEDTA
      *
      ** Import a period end dates
     C                   EXSR      IMP_PE
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrImpOPos - Import Opening Position                          *
      *                                                               *
      *****************************************************************
     C     SrImpOPos     BEGSR
      *
      ** Clear position details format
      *
     C                   CLEAR                   P#POSN
      *
      ** Set position module and position transaction
     C                   EVAL      P#TKEY = T#TKEY
      *
      ** Set position Asset/Liability indicator
     C                   EVAL      P#ASLI = 'A'
      *
      ** Set position interest accrual control date
     C                   EVAL      P#IACD = FC_DTAP
      *
      ** Set position nominal/principal
     C                   EVAL      P#NOML = WStartBal
     C                   EVAL      P#DIFN = WStartBal
      *
      ** Set position currency
     C                   EVAL      P#CCY = FC_FCCY
      *
      ** Set position currency decimal places
     C                   EVAL      P#NCDP = A6NBDP
      *
      ** Set position nominal decimal places
     C                   EVAL      P#NMDP = A6NBDP
      *
      ** Set position currency spot days
     C                   EVAL      P#SPDY = A6SPDY
      *
      ** Set position accuracy
     C                   EVAL      P#ACUR = 9
      *
      ** Import Opening Position
      *
     C                   EVAL      W#MODE = '*IMPOPBL'
     C                   EXSR      WRKEDTA
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrImpoMvt - Import Movement Event                            *
      *                                                               *
      *****************************************************************
     C     SrImpoMvt     BEGSR
      *
      ** Clear event details format
      *
     C                   CLEAR                   E#EVNT
      *
      ** Set event module and event transaction according to the
      ** transaction details
     C                   EVAL      E#TKEY = T#TKEY
      *
      ** Set event asset/liability indicator
     C                   EVAL      E#ASLI = 'A'
      *
      ** Set event processing date
     C                   EVAL      E#PRDT = WDate
      *
      ** Set event type
     C                   IF        WAmount < 0
     C                   Z-SUB     0             WAmount
     C                   EVAL      E#EVTP = 'PI'
     C                   ELSE
     C                   EVAL      E#EVTP = 'PD'
     C                   ENDIF
      *
      ** Set principal amount
     C                   EVAL      E#PRAM = WAmount
      *
      ** Import movement event
      *
     C                   EVAL      W#MODE = '*IMPEVNT'
     C                   EXSR      WRKEDTA
 
     C                   ENDSR
      *
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
      *
      ** Return code
      ** Error message
     C                   PARM                    I#RTCD
     C                   PARM                    I#ERMS
      *
      ** Action code
      ** Extract type
      ** Projected history flag
      ** End of book indicator
     C                   PARM                    I#ACTN
     C                   PARM                    I#EXTT
     C                   PARM                    I#PH
     C                   PARM                    I#EOB
      *
      ** Rundate
      ** Date of next working day
      ** History control date
      ** Event control date
      ** Projected control date
      ** Period end date
     C                   PARM                    I#RDNB
     C                   PARM                    I#DNWD
     C                   PARM                    I#HCOD
     C                   PARM                    I#EVCD
     C                   PARM                    I#PCOD
     C                   PARM                    PeriodEDT
      *
      ** Facility Details
      ** Facility History Details
     C                   PARM                    DSFCLTYX
     C                   PARM                    DSFACHISX
     C                   PARM                    Dataarea                                     208221
      *
      ** Partial key list 1 for facility details by date
      *
     C     WKeyList1     KLIST
     C                   KFLD                    FH_FACNUM
     C                   KFLD                    FH_FAFCTY
     C                   KFLD                    FH_FADATE
      *
      ** Partial key list 2 for facility details by date
      *
     C     WKeyList2     KLIST
     C                   KFLD                    FH_FACNUM
     C                   KFLD                    FH_FAFCTY
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'HFCLT'                                           208221
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      *****************************************************************
      /EJECT
      *****************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      /COPY DECPYSRC,DEXTWEDTA
      *****************************************************************
      /EJECT
      *****************************************************************
      * E X T R A C T   C O M M I T M E N T
      /COPY DECPYSRC,DEXTCOMMO
      *****************************************************************
      /EJECT
      *****************************************************************
      * E X T R A C T   P E R I O D   I M P O R T
      /COPY DECPYSRC,DEXTPERDI
      *****************************************************************
      /EJECT
      *****************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
