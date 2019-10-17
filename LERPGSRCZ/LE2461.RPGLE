     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Start Interest rate fixing in COB')           *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending Module                              *
      *                                                               *
      *  LE2461 - Start Interest Rate Fixing in COB                   *
      *                                                               *
      *  Function:  This module processes all transactions on the     *
      *  (CoB)      Live Loans file and determines the effective      *
      *             interest rate to be fixed on the loan and performs*
      *             the required updates to this file.                *
      *                                                               *
      *  Component of: LEC2460 - Rollover Rate Fixing  Fixing Prompt  *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. CER050             Date 16Jun19               *
      *  Prev Amend No. MD052819           Date 17Apr19               *
      *                 MD046248           Date 27Oct17               *
      *                 CLE141             Date 08Feb16               *
      *                 MD031736           Date 02Mar15               *
      *                 AR988331           Date 03Dec12               *
      *                 CLE134             Date 01Aug12               *
      *                 CLE148             Date 23Jul12               *
      *                 CRE073             Date 06Dec10               *
      *                 CLE143             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 CER016A            Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 242158             Date 27Oct06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239076             Date 12May06               *
      *                 230221  *Create    Date 21Oct04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD052819 - Use correct datatype for rate fixing days.        *
      *  MD046248 - Finastra Rebranding                               *
      *  CLE141 - Currency and Location Business Day Convention       *
      *           for LE Transactions                                 *
      *  MD031736 - Use rate fixing days on loan for rate fixing at   *
      *             Start Date.                                       *
      *  AR988331 - Apply Rate Fixing process to a future valued Loan *
      *             only if system value RateFixAtStartDat is 'Y',    *
      *             else use the current Base Rate Code value on the  *
      *             day the loan is entered. (Child : AR993208)       *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CLE143 - Original Loan Contract Date & Effective Interest    *
      *           Rate (Recompile)                                    *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER016A - German Interest Calculation: Upgarde of FGE059     *
      *            to Midas Plus (Recompile)                          *
      *  242158 - Total interest field should be updated for          *
      *           discounted loan types only.                         *
      *  239076 - Include this program to this service call.          *
      *  230221 - Fix initial rate on forward valued loans.           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         Value Date already processed                    *
      *    10         End of file indicator for LELOANL0              *
      *    60         General file-, program-, module-access error    *
      *               indicator                                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRProcess - Detail processing on the read record             *
      *  SRFixRate - Calculation of rates.                            *
      *  SRRecalc - Recalculates effective rate and total interest    *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialization                                       *
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

      ** Live Loan details
     FLELOANL0  UF   E           K DISK    INFSR(*PSSR) PREFIX(L0)

      *****************************************************************
      /EJECT
      *****************************************************************

      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+

     D SValk2          S             20A   INZ('UseRateFixingDayatSt')                      MD031736
     D LDA           E DS           256    EXTNAME(LDA)
      *
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
      **                                    184 193 DBMOD
      **                                    194 203 DBPROC

      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** DS for Access Objects - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      ** DS for Access Objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)

      ** Externally described DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      ** Externally described DS for Base Rate details
     D SDBSRT        E DS                  EXTNAME(SDBSRTPD)
      *
      ** Externally described DS for Historic Base rate
     D SDBSHS        E DS                  EXTNAME(SDBSHSPD)

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D WRUN            S              1
     D WBaseRate       S             11P 7
     D PDaysBckS       S              2S 0                                                  MD052819
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CLE141
     D ArrCCY          DS                                                                     CLE141
     D  L0C1PR                                                                                CLE141
     D  L0C2PR                                                                                CLE141
     D  L0C3PR                                                                                CLE141
     D  L0C4PR                                                                                CLE141
     D  L0C5PR                                                                                CLE141
     D  L0C6PR                                                                                CLE141
     D  L0C7PR                                                                                CLE141
     D  L0C8PR                                                                                CLE141
     D  L0C9PR                                                                                CLE141
     D  L0C0PR                                                                                CLE141
     D ArrLOC          DS                                                                     CLE141
     D  L0L1PR                                                                                CLE141
     D  L0L2PR                                                                                CLE141
     D  L0L3PR                                                                                CLE141
     D  L0L4PR                                                                                CLE141
     D  L0L5PR                                                                                CLE141
     D  L0L6PR                                                                                CLE141
     D  L0L7PR                                                                                CLE141
     D  L0L8PR                                                                                CLE141
     D  L0L9PR                                                                                CLE141
     D  L0L0PR                                                                                CLE141
      *                                                                                     AR988331
      ** Datastructure to hold input parameter for AOSVALR0.                                AR988331
      *                                                                                     AR988331
     D WParm           DS            20                                                     AR988331
     D  WParm1                 1      5                                                     AR988331
     D  WParm2                 6     10                                                     AR988331
     D  WParm3                11     15                                                     AR988331
     D  WParm4                16     20                                                     AR988331

      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ Initial processing is performed automatically: the *INZSR  ¦
      ** ¦ is executed at program activation.                         ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+

      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************

      *                                                                                     AR988331
      ** If Rate Fixing on Start/Value Date is to be done, check if the                     AR988331
      ** new value of the Base Rate Code will be used on Start Date.                        AR988331
      *                                                                                     AR988331
     C                   IF        WRK01 = 'Y'                                              AR988331
      *
      ** Do Initial reading on the primary file
      *
     C                   READ      LELOANL0                               10
      *
      ** Do while end of file has not been reached
      *
     C                   DOW       *IN10 = *OFF
      *
      ** Select loans which:
      ** - are linked to a Base Rate
      ** - have Rate Change Indicator = 'R'
      ** - have not already processed Value Date
      *
     C                   IF        (L0BRTT <> *ZEROS)
     C                             AND (L0CHIN = 'R')
     C                   TESTB     '1'           L0ACEI                   01
     C                   IF        *IN01 = *OFF
     C                   EXSR      SRFixStart
      *
      * If base rate has changed, recalculate interest fields and update
      *
     C                   IF        WBaseRate <> L0BRTE
     C                   EVAL      L0BRTE = WBaseRate
     C                   EXSR      SRRecalc
     C                   ENDIF
     C                   ENDIF
     C                   ENDIF
      *
     C                   READ      LELOANL0                               10
      *
     C                   ENDDO
      *                                                                                     AR988331
     C                   ENDIF                                                              AR988331
      *
      ** Terminate program
      *
     C                   EVAL      *INLR = *ON
     C                   RETURN
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFixStart - Performs calculation of rate at start date.     *
      *                                                               *
      *  Called by: Main                                              *
      *                                                               *
      *  Calls:     ZBKDT, AOBSHSR0                                   *
      *                                                               *
      *****************************************************************
     C     SRFixStart    BEGSR
      *
      ** Access Base Rates table
      *
     C                   MOVE      L0BRTT        PBASE
     C                   CALL      'AOBSRTR0'
     C                   PARM      *BLANKS       PRtnCde           7
     C                   PARM      '*KEY   '     POption           7
     C                   PARM      L0CCY         PCYCD             3
     C                   PARM                    PBASE             2
     C     SDBSRT        PARM      *BLANKS       DSFDY                                        CSD006
      *
      ** Determine fixing date back from value date
      *
      *
     C                   IF        UseFixingDay = 'Y'                                       MD031736
     C                   MOVE      L0RFDY        PDaysBck
     C                   Else                                                               MD031736
     C                   Z-add     0             PDaysBck                                   MD031736
     C                   Endif                                                              MD031736
     C                   Z-add     PDaysBck      PDaysBckS                                  MD052819
     C                   IF        CLE141 = 'Y'                                               CLE141
     C                   CALL      'LEZBDYRF'                                                 CLE141
     C                   PARM      L0VDAT        PInpOutDay                                   CLE141
     C***********        PARM                    PDaysBck                            CLE141 MD052819
     C                   PARM                    PDaysBckS                                  MD052819
     C                   PARM                    ArrCCY                                       CLE141
     C                   PARM                    ArrLOC                                       CLE141
     C                   PARM      'B'           PMODE             1                          CLE141
     C                   PARM      *Zeros        PDayNbr                                      CLE141
     C                   ELSE                                                                 CLE141
     C                   CALLB     'ZBKDT'
     C                   PARM      L0VDAT        PInpOutDay        5 0
     C                   PARM      L0CCY         PCYCD             3
     C                   PARM      *BLANKS       PLocation         3
     C                   PARM                    PDaysBck          2 0
     C                   PARM                    PDayNbr           5 0
     C                   ENDIF                                                                CLE141
      *
      ** If rate to be used is today's rate, do not look on history file
     C                   IF        PDayNbr >= BAVDNR
     C                   EVAL      WBaseRate  = BANBRT
     C                   ELSE
      *
      ** Determine the historic base rate applicable
     C*
     C                   CALL      'AOBSHSR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*KEY   '     POption
     C                   PARM      L0CCY         PCYCD
     C                   PARM      L0BRTT        PBaseP            2 0
     C                   PARM      PDayNbr       PDayNo            5 0
     C     SDBSHS        PARM                    SDBSHS
      *
     C                   IF        PRtnCde = *BLANKS
     C                   EVAL      WBaseRate = G0CBSR
     C                   ELSE
     C                   EVAL      WBaseRate = BANBRT
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRecalc - Recalculates effective rate and total interest    *
      *             using refixed base rate.                          *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *****************************************************************
     C     SRRecalc      BEGSR
      *
      * Effective rate
      *
     C                   SELECT
     C                   WHEN      L0SPIN = 'A'
     C                   EVAL      L0INTR = L0BRTE + L0RTSP
     C                   WHEN      L0SPIN = 'S'
     C                   EVAL      L0INTR = L0BRTE - L0RTSP
     C                   WHEN      L0SPIN = 'P'
     C                   EVAL      L0INTR = L0BRTE * (L0RTSP/100)
     C                   ENDSL
      *
      * Total Interest
      *
      *                                                                                       242158
      ** Update total interest field for discounted loan types only                           242158
      *                                                                                       242158
     C     L0LTYP        IFEQ      '63'                                                       242158
     C     L0LTYP        OREQ      '65'                                                       242158
     C     L0LTYP        OREQ      '67'                                                       242158
      *                                                                                       242158
     C                   EVAL      ZIBEG = L0VDAT
     C                   EVAL      ZIEND = L0MDAT
     C                   IF        ZIEND = *ZERO
     C                   EVAL      ZIEND = L0VDAT + 1
     C                   ENDIF
     C                   IF        L0ADDI = 'B'
     C                   EVAL      ZIEND = ZIEND + 1
     C                   ENDIF
     C                   EVAL      ZIAMT = L0CPAM
     C                   EVAL      ZIRATE = L0INTR
     C                   MOVE      L0ICBS        ZICALC
     C                   EVAL      ZIRDFC = L0RDFC
      *
     C                   CALLB     'MM1030'
     C                   PARM                    ZIBEG             5 0
     C                   PARM                    ZIEND             5 0
     C                   PARM                    ZICALC            1
     C                   PARM                    ZIAMT            15 0
     C                   PARM                    ZIRATE           11 7
     C                   PARM                    ZIRDFC            1
     C                   PARM      *ZERO         ZINTR            15 0
      *
     C                   EVAL      L0TOTI = ZINTR
      *                                                                                       242158
     C                   ENDIF                                                                242158
      *
      ** Update file
      *
     C                   UPDATE    CLOANCLF                             60
      *
     C                   IF        *IN60 = *ON
     C     *LOCK         IN        LDA
     C                   MOVEL     L0LNRF        DBKEY
     C                   EVAL      DBFILE = 'LELOANL0'
     C                   EVAL      DBASE = 2
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      *  Called by: Implicitly on program activation                  *
      *                                                               *
      *  Calls:     AOBANKR0                                          *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Define LDA
      *
     C     *DTAARA       DEFINE                  LDA
      *
     C                   EVAL      DBPGM  =  PSProcPgm
     C                   EVAL      DBMOD  =  PSProcMod
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRtnCde
     C                   PARM      '*FIRST '     POption
     C     SDBANK        PARM      *BLANKS       DSFDY
     C     PRtnCde       IFNE      *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY = POption
     C                   EVAL      DBFILE = 'SDBANKPD'
     C                   EVAL      DBASE = 1
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *                                                                                     AR988331
      ** Check system value for Rate fixing at Start Date                                   AR988331
      *                                                                                     AR988331
     C                   MOVE      *Blanks       WRK01                                      AR988331
     C                   MOVE      *Blanks       WParm                                      AR988331
     C                   MOVEL     'RateF'       WParm1                                     AR988331
     C                   MOVEL     'ixing'       WParm2                                     AR988331
     C                   MOVEL     'AtSta'       WParm3                                     AR988331
     C                   MOVEL     'rtDat'       WParm4                                     AR988331
     C                   MOVEL     WParm         SValK1                                     AR988331
      *                                                                                     AR988331
      ** Call Access object                                                                 AR988331
      *                                                                                     AR988331
     C                   CALL      'AOSVALR0'                                               AR988331
     C                   PARM      *Blanks       RtnCde            7                        AR988331
     C                   PARM                    SValK1           20                        AR988331
     C                   PARM                    SVal1           200                        AR988331
     C                   PARM                    SValK2           20                        AR988331
     C                   PARM                    SVal2           200                        AR988331
     C                   PARM                    SValK3           20                        AR988331
     C                   PARM                    SVal3           200                        AR988331
     C                   PARM                    SValK4           20                        AR988331
     C                   PARM                    SVal4           200                        AR988331
     C                   PARM                    SValK5           20                        AR988331
     C                   PARM                    SVal5           200                        AR988331
     C                   PARM                    SValK6           20                        AR988331
     C                   PARM                    SVal6           200                        AR988331
     C                   PARM                    SValK7           20                        AR988331
     C                   PARM                    SVal7           200                        AR988331
     C                   PARM                    SValK8           20                        AR988331
     C                   PARM                    SVal8           200                        AR988331
     C                   PARM                    SValK9           20                        AR988331
     C                   PARM                    SVal9           200                        AR988331
     C                   PARM                    SValK0           20                        AR988331
     C                   PARM                    SVal10          200                        AR988331
      *                                                                                     AR988331
      ** If the system value is not found then issue a database error                       AR988331
      *                                                                                     AR988331
     C                   IF        RtnCde <> '*NRF'                                         AR988331
     C                             AND RtnCde <> *Blanks                                    AR988331
     C     *LOCK         IN        LDA                                                      AR988331
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR988331
     C                   EVAL      DBASE = 2                                                AR988331
     C                   EVAL      DBKEY = 'SValK1'                                         AR988331
     C                   OUT       LDA                                                      AR988331
     C                   EXSR      *PSSR                                                    AR988331
     C                   ELSE                                                               AR988331
      *                                                                                     AR988331
      ** Isolate the first character of SVal1 which should contain the value Y or N.        AR988331
      *                                                                                     AR988331
     C                   MOVEL     SVal1         WRK01             1                        AR988331
     C                   MOVEL     SVal2         UseFixingDay      1                        MD031736
     C                   ENDIF                                                              AR988331
      *
      ** Determine if CLE141 is switched ON                                                   CLE141
      ** and initialize BDC work fields                                                       CLE141
                                                                                              CLE141
     C                   MOVE      'N'           CLE141            1                          CLE141
     C                   CALLB     'AOSARDR0'                                                 CLE141
     C                   PARM      *BLANKS       PRtnCde                                      CLE141
     C                   PARM      '*VERIFY '    POption                                      CLE141
     C                   PARM      'CLE141'      PSARD             6                          CLE141
     C     SCSARD        PARM      SCSARD        DSFDY                                        CLE141
      *                                                                                       CLE141
     C                   IF        PRtnCde = *Blanks                                          CLE141
     C                   EVAL      CLE141 = 'Y'                                               CLE141
     C                   ENDIF                                                                CLE141
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
      *  Called by: (**calling routines**)                            *
      *                                                               *
      *  Calls: None                                                  *
      *                                                               *
      *****************************************************************
     C     *PSSR         BEGSR
      *
      ** Check to see that *PSSR has not already been called.
      *
     C                   IF        WRUN = *BLANK
     C                   EVAL      WRUN = 'Y'
     C                   DUMP
     C                   ENDIF
      *
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
