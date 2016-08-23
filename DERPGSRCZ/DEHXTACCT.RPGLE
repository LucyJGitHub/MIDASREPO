     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas DE Hist Ext of General Ledger Accounts')         *
      *****************************************************************
      *                                                               *
      *  Midas - Data Extract module                                  *
      *                                                               *
      *  DEHXTACCR - Historic Extract of Accounts                     *
      *                                                               *
      *  Function:  This module performs the extraction of General    *
      *             Ledger Accounts for the analysis of revenue       *
      *             within CCRM. It is called by DEHXCACCT and writes *
      *             details to the historic extract files. It runs    *
      *             automatically in COB to process all Retail        *
      *             Accounts or On-request in the I/C for a single    *
      *             Account.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CRE073             Date 06Dec10               *
      *  Prev Amend No. CRE075             Date 06Dec10               *
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
      *                 CDE005             Date 22Aug02               *
      *                 CDE003             Date 17Dec02               *
      *                 208221             Date 17Dec02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CDE002  *CREATE    Date 05Dec00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE034 - Lending Enhancements for Phase 1 Priority 1A        *
      *           (recompiled).                                       *
      *  219833 - Don't produce rcds if backvalued trans (recompile). *
      *  216909 - Recompiled due to change in DEPPOSNPD format.       *
      *  CDE005 - Data Export - Reservation ID (Recompiled)           *
      *  CDE003 - Data Export - MCR Limits Phase II (Recompiled)      *
      *  208221 - The processing for not associated customer fees has *
      *           the incoming/outgoing indicator the wrong way round.*
      *           Enable DEWRKEDTA to get info from data area         *
      *           Do not skip postings with associated customer = 0   *
      *           when reporting by customer                          *
      *  CDE002 - Data Export - CCRM Revenue Analysis.                *
      *                                                               *
      *****************************************************************
 
      ** GL Accounts Post - All Postings Details
     FGLPOSTL   IF   E           K DISK    RENAME(APOSTPDF:APOSTPD1)
 
      ** GL Accounts Post
     FGLPOSTL5  IF   E           K DISK    RENAME(APOSTPDF:APOSTPD5)
 
      ** DE Old Transcations
     FDEOTRANL1 IF   E           K DISK    RENAME(DETRANP0:DEOTRAN)
     F                                     PREFIX(O_)
 
      ** DE Current Transactions
     FDEHTRANL1 IF   E           K DISK    RENAME(DETRANP0:DEHTRAN)
     F                                     PREFIX(H_)
 
     FDEHTRANPD O    E           K DISK
     FDEHPOSNPD O    E           K DISK
     FDEHEVNTPD O    E           K DISK
     FDEHCASHPD O    E           K DISK
 
      *********************************************************************
      * E X T R A C T   P E R I O D   D E F I N I T I O N
      /COPY DECPYSRC,DEXTPERDD
      *****************************************************************
      *
      ** Array for processing Posting Narrative
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
 
      * E X T R A C T   F I L E S
      /COPY DECPYSRC,DEXTFILS
 
     D ACCNTX        E DS                  EXTNAME(ACCNTAB)
     D                                     PREFIX(AC_)
 
     D**  Long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D**  Short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** External DS for Bank Details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** External DS for GENERAL LEDGER details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
 
      ** External DS for Currency Details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
     D*W#ACID***       DS            20                                                       CGL029
     D W#ACID          DS            26                                                       CGL029
     D*W#CNUM***               1      6  0                                                    CSD027
     D W#CNUM                  1      6A                                                      CSD027
     D W#CCY                   7      9
     D*W#ACOD***              10     13  0                                                    CGL029
     D*W#ACSQ***              14     15  0                                                    CGL029
     D*W#BRCA***              16     18                                                       CGL029
     D*W#ASOC***              19     20                                                       CGL029
     D*W#ASCH***              19     19                                                       CGL029
     D*W#ASNM***              20     20  0                                                    CGL029
     D W#ACOD                 10     19  0                                                    CGL029
     D W#ACSQ                 20     21  0                                                    CGL029
     D W#BRCA                 22     24                                                       CGL029
     D W#ASOC                 25     26                                                       CGL029
     D W#ASCH                 25     25                                                       CGL029
     D W#ASNM                 26     26  0                                                    CGL029
      *
      ** Work parameters
     D PRepAsCus       S              1A
     D PSelPos         S              1A
     D W#EFLG          S              1A
      *
      ** Work variables
     D W#MVNO          S                   LIKE(P#MVNO)
     D WKASOC          S                   LIKE(ASOC)
     D  ALPHA          S              1    DIM(36) CTDATA PERRCD(36)
      * Alphanumeric
      *
 
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************
 
     C                   EXSR      XTINITG
 
     C                   EXSR      XTMAING
 
     C                   MOVE      *ON           *INLR
     C                   RETURN
     C/SPACE 5
      ********************************************************************
      * INITIAL PROCESSING
      ********************************************************************
     C     XTINITG       BEGSR
 
 
     C     *ENTRY        PLIST
     C                   PARM                    I#RTCD            7
     C                   PARM                    I#ERMS           30
      * INPUTS
     C                   PARM                    I#ACTN            1
     C                   PARM                    I#EXTT            4
     C                   PARM                    I#PH              1
     C                   PARM                    I#EOB             1
     C                   PARM                    I#RDNB            5 0          * RUN DATE
     C                   PARM                    I#DNWD            5 0          * DATE OF NXT W DAY
     C                   PARM                    I#HCOD            5 0
     C                   PARM                    I#EXTD            5 0
     C                   PARM                    I#EVCD            5 0
     C                   PARM                    I#PCOD            5 0
     C                   PARM                    PeriodEDT
     C                   PARM                    I#ACCD           25
     C                   PARM                    ACCNTX
     C                   PARM                    PRepAsCus
     C                   PARM                    PSelPos
     C                   PARM                    Dataarea                                     208221
      *
      **  Access Bank Details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOBANKR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *                                                                                       208221
      **  Set up Type for DEWRKEDTA                                                           208221
      *                                                                                       208221
     C                   EVAL      W#TYPE = 'HACCT'                                           208221
      *
      **  Access General Ledger details
      *
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*FIRST  '    @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
     C     @RTCD         IFNE      *BLANK
     C                   EVAL      I#RTCD = '*ERROR '
     C                   EVAL      I#ERMS = 'AOGELRR0'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
     C     PRepAsCus     IFEQ      'Y'
      *
      ** Setup Key List
      *
     C                   EVAL      K#BRCA = AC_BRCA
     C                   EVAL      K#CNUM = AC_CNUM
     C                   EVAL      K#CCY = AC_CCY
     C                   EVAL      K#ACOD = AC_ACOD
     C                   EVAL      K#ACSQ = AC_ACSQ
     C                   EVAL      K#ASOC = 0
      *
      ** Define Key List
      *
     C     K#CHGL5       KLIST
     C                   KFLD                    K#BRCA
     C                   KFLD                    K#CNUM
     C                   KFLD                    K#CCY
     C                   KFLD                    K#ACOD
     C                   KFLD                    K#ACSQ
     C                   KFLD                    K#ASOC            6 0
      *
     C     K#KEY         CHAIN     GLPOSTL5
      *
     C*****ASOC*         IFNE      0                                                          CSD027
     C     ASOC          IFNE      *BLANKS                                                    CSD027
     C                   EVAL      W#CNUM = ASOC
     C                   EVAL      W#ASOC = 'AS'
     C                   ENDIF
      *
     C                   ENDIF
 
     C                   ENDSR
 
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * MAIN PROCESSING
      ********************************************************************
     C     XTMAING       BEGSR
      *
     C                   EXSR      TRANITG
      *
      ** Perform Main Subroutine in /COPY DEXTMAINO
      *
     C                   EXSR      MAIN
      *
      ** Perform Commitment as per /COPY DEXTCOMMO
      *
     C                   EXSR      COMIT
 
     C                   ENDSR
 
      ********************************************************************
     C/SPACE 5
      ********************************************************************
      * TRANSACTION INITIALISATION
      ********************************************************************
     C     TRANITG       BEGSR
      *
      ** Clear Historic Transaction detail
     C                   CLEAR                   T#TRAN
      *
      ** Clear Historic Transaction detail
     C                   EVAL      T#MOD = 'GL'
      *
      ** Set up Transaction Reference
     C                   EVAL      W#CNUM = AC_CNUM
     C                   EVAL      W#CCY = AC_CCY
     C                   EVAL      W#ACOD = AC_ACOD
     C                   EVAL      W#ACSQ = AC_ACSQ
     C                   EVAL      W#BRCA = AC_BRCA
     C                   EVAL      W#ASOC = *BLANKS
      *
      ** If Report by Assoc. Cust. is 'Y',  use associated customer in place of customer
      *
     C     PRepAsCus     IFEQ      'Y'
     C*****ASOC*         ANDNE     0                                                          CSD027
     C     ASOC          ANDNE     *BLANKS                                                    CSD027
     C                   EVAL      W#CNUM = ASOC
     C                   EVAL      W#ASOC = 'AS'
     C                   ENDIF
     C*
     C                   EVAL      T#TREF = W#ACID
     C*
     C     PRepAsCus     IFEQ      'Y'
     C*****ASOC*         ANDNE     0                                                          CSD027
     C     ASOC          ANDNE     *BLANKS                                                    CSD027
     C                   MOVEL     *BLANKS       W#STATUS          1
     C                   Z-ADD     1             W#COUNT           1 0
     C*
     C     W#STATUS      DOWEQ     *BLANKS
     C                   EVAL      T#TREF = W#ACID
     C                   EVAL      W#TREF = T#TREF
     C                   EVAL      W#MOD = T#MOD
     C*
     C     K#KEY1        CHAIN     DEOTRANL1                          88
     C     *IN88         IFEQ      *ON
     C* NO RECORD FOUND
     C                   MOVEL     'F'           W#STATUS
     C                   ELSE
     C*
     C     O_T#CPTY      IFEQ      ASOC
     C                   MOVEL     'F'           W#STATUS
     C                   ELSE
     C                   EXSR      INCREMENT
     C                   ENDIF
     C                   ENDIF
     C                   ENDDO
     C*
     C                   MOVEL     *BLANKS       W#STATUS          1
     C*
     C     W#STATUS      DOWEQ     *BLANKS
     C                   EVAL      T#TREF = W#ACID
     C                   EVAL      W#TREF = T#TREF
     C*
     C     K#KEY1        CHAIN     DEHTRANL1                          88
     C     *IN88         IFEQ      *ON
     C* NO RECORD FOUND
     C                   MOVEL     'F'           W#STATUS
     C                   ELSE
     C*
     C                   EXSR      INCREMENT
     C                   ENDIF
     C                   ENDDO
     C                   ENDIF
      *
      ** Set up Transaction Type
     C                   MOVEL     AC_ACOD       T#TRTP
      *
      ** Set up Transaction Sub-Type
     C                   EVAL      T#TRST = *Blanks
      *
      ** Set up Account Description
     C                   EVAL      T#TDES = I#ACCD
      *
      ** Set up Branch
     C                   EVAL      T#BRCA = AC_BRCA
      *
      ** Set up Counter Party
     C                   EVAL      T#CPTY = AC_CNUM
      *
      ** Set up Risk Customer
     C                   EVAL      T#RCST = AC_CNUM
      *
      ** If Report by Assoc. Cust. is 'Y',  setup counter party and risk customer as the
      ** associated customer
      *
     C     PRepAsCus     IFEQ      'Y'
     C*****ASOC*         ANDNE     0                                                          CSD027
     C     ASOC          ANDNE     *BLANKS                                                    CSD027
     C                   EVAL      T#CPTY = ASOC
     C************       EVAL      T#RCST = ASOC
     C                   ENDIF
      *
      ** Set up Transaction Market Value
     C                   EVAL      T#MKVL = 0
      *
      ** Set up Transaction Valuation Currency
     C                   EVAL      T#VCCY = AC_CCY
      *
      ** Access Details about Account Currency
     C                   MOVE      AC_CCY        @CYCD
      *
     C                   EXSR      ACSCCY
      *
     C                   MOVE      A6NBDP        W#ACDP            1 0
     C                   MOVE      A6SPRT        W#ACSR           13 8
     C                   MOVE      A6MDIN        W#ACMD            1
     C                   MOVE      A6SPDY        W#SPDY            3 0
      *
      ** Set up Transaction Valuation Currency Decimal Places
     C                   EVAL      T#VCDP = A6NBDP
      *
      ** Set up Transaction Action
     C                   EVAL      T#ACTN = I#ACTN
      *
      ** Import the Transaction
     C                   EVAL      W#MODE = '*IMPTRAN'
      *
     C                   EXSR      WRKEDTA
      *
      ** Reset Export Indicators
     C                   EVAL      Posn_Exp = *Blank
     C                   EVAL      Evnt_Exp = *Blank
     C                   EVAL      Cash_Exp = *Blank
      *
     C                   ENDSR
      *
      *****************************************************************
      * IMPORT OPENING POSITION AND EVENTS
      *****************************************************************
     C     IMPORT        BEGSR
      *
      * Import Opening Position
     C                   EXSR      IMPOPOSG
      *
      ** Import Fee Event Processes
     C                   EXSR      IMPOFEE
      *
      ** Perform Maturity Event Processing
     C                   IF        AC_RECI = 'C' and AC_DACC <> 0
      *
      ** Import Maturity Event
     C                   EXSR      IMPOMATG
      *
     C                   ENDIF
      *
      ** Import Period End Dates
     C                   EXSR      IMP_PE
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT OPENING POSITION
      *****************************************************************
     C     IMPOPOSG      BEGSR
      *
      * CLEAR POSITION
     C                   CLEAR                   P#POSN
      *
      * Module, Transaction Reference
     C                   MOVEL     T#TKEY        P#TKEY
      *
      * Asset/Liability
     C                   MOVEL     'A'           P#ASLI
      *
      * Interest Accrl Ctl Date
     C                   IF        AC_DACO > I#HCOD
     C                   Z-ADD     AC_DACO       P#IACD
     C                   ELSE
     C                   Z-ADD     I#HCOD        P#IACD
     C                   ENDIF
      *
      * Work Position Date
     C                   Z-ADD     P#IACD        W#POSD            5 0
      *
      * Accrued Int To Date
     C                   Z-ADD     *ZERO         P#AITC
      *
      * Nominal/Principal
     C                   EVAL      P#NOML = 0
      *
      * Currency
     C                   MOVEL     AC_CCY        P#CCY
      *
      * Position Ccy Dec Places
     C                   MOVEL     T#VCDP        P#NCDP
      *
      * Position Nominal Dec Places
     C                   MOVEL     T#VCDP        P#NMDP
      *
      * Position Currency Spot Days
     C                   MOVEL     W#SPDY        P#SPDY
      *
      * Position Accuracy
     C                   MOVEL     '9'           P#ACUR
      *
      * Accrue Indicator
     C                   MOVEL     *Blank        P#ACIN
      *
      * Accrue Cost of Funds
     C                   MOVEL     *Blank        P#ACCF
      *
      * Import opening balance
      *
     C                   MOVEL     '*IMPOPBL'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT ALL FEE EVENTS FOR GL ACCOUNTS
      *****************************************************************
     C     IMPOFEE       BEGSR
      *
     C     PRepAsCus     IFNE      'Y'
      *
      ** Set Greater limits on GLPOSTL
     C                   EVAL      K#BRCA = AC_BRCA
     C                   EVAL      K#CNUM = AC_CNUM
     C                   EVAL      K#CCY = AC_CCY
     C                   EVAL      K#ACOD = AC_ACOD
     C                   EVAL      K#ACSQ = AC_ACSQ
     C                   EVAL      K#HIDT = W#POSD
      *
      ** Define Key List
     C     K#CHG         KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
     C**********         KFLD                    K#ACOD            4 0                        CGL029
     C                   KFLD                    K#ACOD           10 0                        CGL029
     C                   KFLD                    K#ACSQ            2 0
     C                   KFLD                    K#HIDT            5 0
      *
      ** Set Greater Limits on File
     C     K#CHG         SETGT     GLPOSTL
      *
      ** Define Key list
     C     K#KEY         KLIST
     C                   KFLD                    K#BRCA            3
     C**********         KFLD                    K#CNUM            6 0                        CSD027
     C                   KFLD                    K#CNUM            6                          CSD027
     C                   KFLD                    K#CCY             3
     C**********         KFLD                    K#ACOD            4 0                        CGL029
     C                   KFLD                    K#ACOD                                       CGL029
     C                   KFLD                    K#ACSQ            2 0
      *
      ** Define Key list
     C     K#KEY1        KLIST
     C                   KFLD                    W#MOD             2
     C**********         KFLD                    W#TREF           20                          CGL029
     C                   KFLD                    W#TREF           26                          CGL029
      *
      ** Reset Work Posting Date
     C     *LIKE         DEFINE    PSTD          W#PSTD
     C                   EVAL      W#PSTD = 0
     C                   EVAL      W#OUTP = *Blank
      *
      ** Reset work Charge Ammount
     C     *LIKE         DEFINE    PSTA          W#CHRG
     C                   EVAL      W#CHRG = 0
      *
      ** Set Work Number of Movements to 0
     C                   EVAL      W#MVNO = 0
      *
      ** Read Through GLPOSTL until change of Account occurs
     C     K#KEY         READE     GLPOSTL                                89
     C                   DOW       *IN89 = *Off
      *
      ** Output only on Change of date
     C                   IF        PSTD <> W#PSTD and W#PSTD <> 0
     C                             and W#OUTP = 'Y'
      *
      ** Import Daily Movement Event.
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
      ** Reset work Charge Ammount
     C                   EVAL      W#CHRG = 0
     C                   EVAL      W#OUTP = *Blank
      *
     C                   ENDIF
      *
      ** If Source toric Events
     C                   IF        SPOS <> '  GE-XF' and SPOS <> '  GE-XB'
 
     C                   IF        PSelPos = 'A' OR
     C                             PSelPos = 'S' AND %SUBST(SPOS:3:2) = 'GE' OR
     C                             PSelPos = 'M' AND %SUBST(SPOS:3:2) <>'GE'
      *
      * Clear Position
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = 'A'
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = PSTD
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'FE'
      *
      ** Set Event Charge Amount
     C                   IF        DRCR = 1
     C                   EVAL      W#CHRG = W#CHRG + PSTA
     C                   ELSE
     C                   EVAL      W#CHRG = W#CHRG - PSTA
     C                   ENDIF
     C                   ADD       1             W#MVNO
      *
     C                   IF        W#CHRG >= 0
     C                   EVAL      E#CHRG = W#CHRG
     C                   ELSE
     C                   EVAL      E#CHRG = 0 -W#CHRG
     C                   ENDIF
     C                   EVAL      E#MVNO = W#MVNO
     C                   EVAL      W#MVNO = 0
     C                   EVAL      E#FEEC = 'GL'
      *
      ** Set Total Amount
     C                   IF        W#CHRG >= 0
     C                   EVAL      E#TAMT = W#CHRG
     C                   ELSE
     C                   EVAL      E#TAMT = 0 - W#CHRG
     C                   ENDIF
      *
      ** Set Event Currency Decimal Places
     C                   EVAL      E#NCDP = T#VCDP
      *
      ** Set Event Funding Sign
     C                   EVAL      E#PRCD = 'Y'
      *
      ** Set Posting Debit/Credit Indicator
     C                   IF        W#CHRG >= 0
     C************       EVAL      E#IO = 'O'                                                 208221
     C                   EVAL      E#IO = 'I'                                                 208221
     C                   ELSE
     C************       EVAL      E#IO = 'I'                                                 208221
     C                   EVAL      E#IO = 'O'                                                 208221
     C                   ENDIF
 
     C                   Z-ADD     PSTD          W#PSTD
     C                   MOVE      'Y'           W#OUTP            1
 
     C                   ENDIF
      *
     C                   ENDIF
     C     K#KEY         READE     GLPOSTL                                89
     C                   ENDDO
      *
      ** Check if record requires outputting
     C                   IF        W#OUTP = 'Y'
      *
      ** Import Daily Movement Event.
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
     C                   ENDIF
      *
      ** Otherwise, Report by Associated Customer input parameter = 'Y'
      *
     C                   ELSE
      *
      ** Set Limits on File
      *
     C*****K#CHGL5       SETGT     GLPOSTL5                                                   208221
     C     K#KEY         SETLL     GLPOSTL5                                                   208221
      *
     C     K#KEY         READE     GLPOSTL5                               89
      *
      ** Initialise Work fields
     C                   EVAL      W#EFLG = *BLANK
     C                   EVAL      W#CHRG = 0
     C                   EVAL      W#MVNO = 0
      *
      ** Read while of the same account
      *
     C                   DOW       *IN89 = *OFF
      *
      ** If change of posting date, and Work Event Flag is 'Y'
     C                   IF        PSTD <> W#PSTD AND W#PSTD <> 0
     C                             AND W#EFLG = 'Y'
 
     C                   EXSR      SRIMEV
 
     C                   EVAL      W#EFLG = *Blanks
     C                   EVAL      W#CHRG = 0
     C                   EVAL      W#MVNO = 0
 
     C                   ENDIF
 
     C                   IF        SPOS <> '  GE-XF' AND SPOS <> '  GE-XB'
 
     C                   IF        PSelPos = 'A' OR
     C                             PSelPos = 'S' AND %SUBST(SPOS:3:2) = 'GE' OR
     C                             PSelPos = 'M' AND %SUBST(SPOS:3:2) <>'GE'
 
     C                   EVAL      W#EFLG = 'Y'
      *
      ** Store the posting date
     C                   Z-ADD     PSTD          W#PSTD
      *
      ** Set event charge amount
     C                   IF        DRCR = 1
     C                   EVAL      W#CHRG = W#CHRG + PSTA
     C                   ELSE
     C                   EVAL      W#CHRG = W#CHRG - PSTA
     C                   ENDIF
     C                   ADD       1             W#MVNO
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     ASOC          WKASOC
     C     K#KEY         READE     GLPOSTL5                               89
 
     C                   IF        *IN89 = '0'
 
     C                   IF        ASOC <> WKASOC
      *
      ** If work event flag is 'Y', import an event
     C                   IF        W#EFLG = 'Y'
     C                   EVAL      W#EFLG = *BLANKS
     C                   EXSR      SRIMEV
     C                   ENDIF
      *
      ** Initialise work fields
     C                   EVAL      W#EFLG = *BLANK
     C                   EVAL      W#CHRG = 0
     C                   EVAL      W#MVNO = 0
      *
      ** Perform maturity event processing
     C                   IF        AC_RECI = 'C' AND AC_DACC <> 0
     C                   EXSR      IMPOMATG
     C                   ENDIF
      *
      ** Import period end dates
     C                   EXSR      IMP_PE
      *
      ** Write to extract files
     C                   EXSR      SRWRIT
      *
      ** Initialise transaction for the newly-read record
     C                   EXSR      TRANITG
      *
      ** Import opening position for the newly-read record
     C                   EXSR      IMPOPOSG
      *
      ** Initialise work fields
     C                   MOVE      *BLANK        W#EFLG
     C                   EVAL      W#CHRG = 0
     C                   EVAL      W#MVNO = 0
     C                   ENDIF
      *
      ** Otherwise, not change of associated customer
     C                   ELSE
      *
      ** If Work Event Flag is 'Y', import event
     C                   IF        W#EFLG = 'Y'
     C                   EVAL      W#EFLG = *Blanks
     C                   EXSR      SRIMEV
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
     C/SPACE 5
      *****************************************************************
      * IMPORT MATURITY EVENT
      *****************************************************************
     C     IMPOMATG      BEGSR
      *
      * Clear Position
     C                   CLEAR                   E#EVNT
      *
      * Set Event Module and Event Transaction
     C                   EVAL      E#TKEY = T#TKEY
      *
      * Set Event Asset/Liability indicator
     C                   EVAL      E#ASLI = 'A'
      *
      * Set Event Processing Date
     C                   EVAL      E#PRDT = AC_DACC
      *
      * Set Event Type
     C                   EVAL      E#EVTP = 'MT'
      *
      ** Set Event Suppress Settlement
     C                   EVAL      E#SSET = 'Y'
      *
      ** Import Daily Movement Event
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
      *
     C                   ENDSR
      ********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRIMEV - Import an event                                     *
      *                                                               *
      *****************************************************************
     C     SRIMEV        BEGSR
      *
      ** Clear projected event data structure
      *
     C                   CLEAR                   E#EVNT
 
     C                   EVAL      E#TKEY = T#TKEY
     C                   EVAL      E#ASLI = 'A'
     C                   EVAL      E#PRDT = W#PSTD
     C                   EVAL      E#EVTP = 'FE'
     C                   EVAL      E#NCDP = T#VCDP
     C                   EVAL      E#PRCD = 'Y'
 
     C                   IF        W#CHRG > 0
     C                   EVAL      E#IO = 'I'
     C                   ELSE
     C                   EVAL      E#IO = 'O'
     C                   Z-SUB     W#CHRG        W#CHRG
     C                   ENDIF
 
     C                   EVAL      E#CHRG = W#CHRG
     C                   EVAL      E#TAMT = W#CHRG
     C                   EVAL      E#MVNO = W#MVNO
     C                   EVAL      W#MVNO = 0
     C                   EVAL      E#FEEC = 'GL'
 
     C                   MOVEL     '*IMPEVNT'    W#MODE
     C                   EXSR      WRKEDTA
  205
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  INCREMENT - Increment unique reference                       *
      *                                                               *
      *****************************************************************
     C     INCREMENT     BEGSR
      *
      ** The first time set unique reference to 'A1'
      *
     C     W#ASOC        IFEQ      'AS'
     C                   Z-ADD     1             W#ASNM
     C                   ELSE
      *
      ** When have reached for example 'A9' set to 'B1'
      *
     C     W#ASNM        IFEQ      9
     C                   Z-ADD     1             W#NUM             1 0
     C     W#ASCH        LOOKUP    ALPHA(W#NUM)                           89
     C                   ADD       1             W#NUM
     C     W#NUM         IFGT      36
     C*
      **  If data error encountered, log error
     C                   EVAL      W#ERMS = 'TRANS SEQ NUM OVER LIMIT'
     C                   EVAL      BUFFER = W#ERMS + W#ASOC + T#TRAN
     C                   CALLB     'DEWRTELOG'
     C                   PARM                    BUFFER         4000
     C                   ENDIF
     C                   MOVEL     ALPHA(W#NUM)  W#ASCH
     C                   Z-ADD     0             W#ASNM
      *
      ** Else for example changed 'A1' to 'A2'
      *
     C                   ELSE
     C                   ADD       1             W#ASNM
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWRIT - Write to Extract Files                              *
      *                                                               *
      *****************************************************************
     C     SRWRIT        BEGSR
  204 *
  204 ** Process imported events
  204 *
  204C                   MOVEL     '*PROCSIM'    W#MODE
  204C                   EXSR      WRKEDTA
  204 *
  204 ** Export transaction
  205C                   MOVEL     '*EXPTRAN'    W#MODE
  205C                   EXSR      WRKEDTA
  205
  205C     W#RTCD        DOWNE     '*EOD   '
  205C                   WRITE     DETRANP0
  205C                   EXSR      WRKEDTA
  205C                   ENDDO
  205 *
  206 ** Export positions
  206C                   MOVEL     '*EXPPOSN'    W#MODE
  206C                   EXSR      WRKEDTA
  206
  206C     W#RTCD        DOWNE     '*EOD   '
  206C                   MOVEL     'Y'           POSN_Exp
  206C                   WRITE     DEPOSNP0
  206C                   EXSR      WRKEDTA
  207C                   ENDDO
  207 *
  207 ** Export events
  207C                   MOVEL     '*EXPEVNT'    W#MODE
  207C                   EXSR      WRKEDTA
  207
  207C     W#RTCD        DOWNE     '*EOD   '
  207C                   MOVEL     'Y'           EVNT_Exp
  207C                   WRITE     DEEVNTP0
  208C                   EXSR      WRKEDTA
  208C                   ENDDO
  208 *
  208 ** Export cashflows
  208C                   MOVEL     '*EXPCASH'    W#MODE
  208C                   EXSR      WRKEDTA
  208
  208C     W#RTCD        DOWNE     '*EOD   '
  208C                   MOVEL     'Y'           CASH_Exp
  209C                   WRITE     DECASHP0
  209C                   EXSR      WRKEDTA
  209C                   ENDDO
 
     C                   ENDSR
      *
      *****************************************************************
      /SPACE 5
      ********************************************************************
      * ACCESS CURRENCY DETAILS
      ********************************************************************
     C     ACSCCY        BEGSR
      *
     C                   CALLB     'AOCURRR0'
     C                   PARM      '        '    @RTCD             7
     C                   PARM      '*KEY    '    @OPTN             7
     C                   PARM                    @CYCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
     C                   ENDSR
      ********************************************************************
      /SPACE 5
      * M A I N   P R O C E S S I N G
      /COPY DECPYSRC,DEXTMAINO
      ********************************************************************
      * W O R K   W I T H   E X T R A C T   D A T A
      /COPY DECPYSRC,DEXTWEDTA
      ********************************************************************
      * E X T R A C T   C O M M I T M E N T
      /COPY DECPYSRC,DEXTCOMMO
      ********************************************************************
      * E X T R A C T   P E R I O D   I M P O R T
      /COPY DECPYSRC,DEXTPERDI
      ********************************************************************
      * * P S S R  --- A B N O R M A L   E R R O R   C O N D I T I O N S
      /COPY DECPYSRC,DEPSSR
      *****************************************************************
** ALPHA
ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
