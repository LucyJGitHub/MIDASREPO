     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2005')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Amortisation Calculator')                     *
      *****************************************************************
      *                                                               *
      *  Midas - Common Function Module                               *
      *                                                               *
      *  ZAAMRTCALC - Amortisation Calculator                         *
      *                                                               *
      *  Function:  The program is a standard routine for computing   *
      *             non-linear amortisation of an instrument between  *
      *             two dates.                                        *
      *                                                               *                       232928
      *  Called by: LE004610, LE004650, MM004610 & MM004650           *                       232928
      *             Passing paramaters should always match!           *                       232928
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2005            *
      *                                                               *
      *  Last Amend No. CDL093             Date 11Apr14               *
      *  Prev Amend No. CLE148             Date 23Jul12               *
      *                 262632             Date 10Apr09               *
      *                 262600             Date 19Feb09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 BUG17508           Date 04Apr08               *
      *                 CAS019A            Date 26Jul07               *
      *                 248259             Date 22May07               *
      *                 240799             Date 20Jun06               *
      *                 CAS016             Date 28Feb06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242286             Date 27Sep06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 232928             Date 08Apr05               *
      *                 233612             Date 20May05               *
      *                 233578             Date 19May05               *
      *                 232630             Date 14Mar05               *
      *                 232628             Date 14Mar05               *
      *                 231712  *CREATE    Date 03Feb05               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL093 - MM Interest calculation type 9.                     *
      *  CLE148 - Alpha Loan Reference                                *
      *  262632 - Include cash flows happening at beginning of        *
      *           amortisation period, when accrual on last day is N. *
      *  262600 - Loan principal at start date not retrieved in case  *
      *           of EIR recalculation.                               *
      *           Amount of accrued interest is wrong.                *
      *           Reverse part of fix 232628.                         *
      *  BUG17508 - Dealing amortisation not working due to wrong     *
      *             files being used                                  *
      *  CAS019A - CAS016 Upgrade to Midasplus-Alphanumeric Customer  *
      *            (Recompile)                                        *
      *  248259 - Amortise Separately Fees' EIR not computed correctly*
      *  240799 - Wrong amortisation on maturing loans                *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
      *  242286 - Enhance calculation of interest for calc basis 6.   *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  232928 - Amortise all fees non-linearly, EIR calculation,    *
      *           Non-linear amortisation calculation & adjustment    *
      *  233612 - Stop Accruals processing to be included in          *
      *           Nonlinear amortisation computation                  *
      *  233578 - Ensure correct discount amount for loans maturing   *
      *           today and include maturing loans today              *
      *  232630 - Incorrect non-linear amortization                   *
      *  232628 - CAS009 Rollover patch (LE).                         *
      *  231712 - Compute for amortisation from last amortisation     *
      *           date instead of EIR start date until event control  *
      *           date.                                               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInitialise - Initialise work variables                     *
      *                                                               *
      * *PSSR  - Error processing                                     *
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
 
      ** Present Cash Flows Using All-in-Rate file
     FZAAMRTL0  IF   E           K DISK    INFSR(*PSSR)
 
      ** Lending History file by Loan Reference and Value Date
     FHISTSL0   IF   E           K DISK    INFSR(*PSSR)
 
      ** Lending History file by Loan Reference and Value Date                                233612
     FHISTSL1   IF   E           K DISK    INFSR(*PSSR)                                       233612
     F                                     RENAME(HISTSHQF:HISTSHQF1)                         233612
     F                                     PREFIX(A)                                          233612
                                                                                              CAS016
      ** Midas ZA History File                                                                CAS016
     FZAHTRNL0  IF   E           K DISK    INFSR(*PSSR)                                       CAS016
                                                                                              CAS016
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ D-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     D LDA           E DS           256    EXTNAME(LDA)
 
      ** Local data area for database error details
      ** *LOCK IN LDA immediately before and OUT LDA immediately
      ** after each database error handling.
      **
      **                                    134 141 DBFILE
      **       Defines:                     142 170 DBKEY
      **                                    171 180 DBPGM
      **                                    181 1830DBASE
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *                                                                                       CDL093
     D/COPY ZSRSRC,ZDATE9Z1LE                                                                 CDL093
     D/COPY ZSRSRC,ZFEB29Z1LE                                                                 CDL093
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External data structure for SC Switchable features                                   CAS016
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CAS016
                                                                                              CAS016
      ** First DS for Access programs - short data structure                                  CAS016
     D DSFDY         E DS                  EXTNAME(DSFDY)                                     CAS016
                                                                                              CAS016
      ** Work DS to manipulate program parameter values
     D PInOutFormat    DS           200
 
      ** Input values
     D  PCallingPgm                  10A
     D  PEIRRate                     15P10
     D  PEIRStartDate                 5P 0
     D  PEIREndDate                   5P 0
     D**PLoanRef                      6S 0                                                    CLE148
     D  PLoanRef                      6A                                                      CLE148
     D  PMaturityDate                 5P 0                                                    233578
     D  PStartDate                    5P 0
     D  PEndDate                      5P 0
     D  PTOTI                        13P 0
     D  PAccrlIndictr                 1A
     D  PPrevDirtyPrc                15P 0
     D  PPrevCleanPrc                15P 0
     D  PIntCalcBasis                 1P 0
     D  PProcType                     1A
     D  PLoanDepI                     1A                                                      232928
     D  PStopAccrualF                 1A                                                      233612
 
      ** Output values
     D  POutAmrtAmt                  17P 0
     D  PDrtPrcTdy                   15P 0
     D  PClnPrcTdy                   15P 0
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
 
      ** ZINTDY parameters
     D PRetCdeOut      S             10A
     D PZINDY          S              5P 0
     D PZBEG           S              5P 0
     D PZEND           S              5P 0
     D PZCALC          S              1A
     D***PINT6DY*      S             15P 7                                                    242286
     D PINT6DY         S             15P 9                                                    242286
 
      ** Parameter for access object
     D PRtCd           S              7A
     D POptn           S              7A
     D PSard           S              6A                                                      CAS016
 
      ** Work Variables
     D WRunningAmount  S              8F
     D WAmrtAmt        S              8F
     D WDaysInYear     S              5P 0
     D WTime           S              4F
     D WClnPrcPrv      S              8F
     D WDirtyPrice     S              8F
     D WCleanPrice     S              8F
     D WNetPrincipal   S              8F
     D WAllCshFlowTdy  S             17P 0
     D WAllPFTdy       S             17P 0                                                    232630
     D***WAllFeesTdy     S             17P 0                                                  232630
     D***WAllPcplChgTdy  S             17P 0                                                  232630
     D***WAllFeesTDat    S             17P 0                                                  232630
     D WCashFlowFound  S              1A
     D WAccrdIntrst    S             15P 0
     D WUnSettledInt   S             15P 0                                                    232628
     D WBkPZBEG        S              5P 0
     D WPEndDate       S              5P 0                                                    232630
     D WStopAccrual    S              1A                                                      233612
 
     D KDate           S              5P 0
 
     D PParameter      S            200A
 
     D @RUN            S              1A
 
     D CAS016          S              1A                                                      CAS016
                                                                                              CAS016
     D/COPY ZSRSRC,ZDATE9Z2LE                                                                 CDL093
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialise work variables
 
     C                   EXSR      SrInitialise
 
      ** Adjust the Start and End dates of the amortisation period if
      ** First Day Accruals.
 
     C                   IF        PAccrlIndictr = 'F'
 
     C                   IF        WDirtyPrice <> *ZERO
     C**********                   OR WDirtyPrice = *ZERO                              233578 240799
     C**********                   AND PMaturityDate = PEndDate                        233578 240799
     C                   EVAL      PStartDate = PStartDate + 1
     C                   ENDIF
 
     C                   EVAL      WPEndDate = PEndDate                                       232630
     C                   IF        PEndDate < PEIREndDate
     C                   EVAL      PEndDate = PEndDate + 1
     C                   ENDIF
 
     C                   ENDIF
 
      ** If cash flows are found between the parameter start and end date,
      ** amortise by subperiods and compute for total amortisation amount.
 
      ** Read all records from Last Amortisation Date or EIR Start to
      ** Event Contol Date or EIR end Date
     C                   EVAL      KDate = PStartDate
     C     KLoanDate     SETLL     ZAAMRTL0
     C     PLoanRef      READE     ZAAMRTL0
 
     C                   EVAL      PZBEG = PStartDate
     C                   IF        NOT %EOF(ZAAMRTL0)                                         232630
     C                   EVAL      PZEND = EPFLDT
     C                   ENDIF                                                                232630
 
     C                   DOW       NOT %EOF(ZAAMRTL0)
 
     C                   IF        EPFLDT >  PStartDate
     C                             OR PAccrlIndictr = 'F'                                     262632
     C                             AND WDirtyPrice <> *ZERO                                   262632
     C                             AND EPFLDT =  PStartDate                                   262632
 
      ** Set flag to 'Y' if cash flows are found between period indicated
      ** by the parameter start and end dates
     C                   EVAL      WCashFlowFound = 'Y'
 
      ** Calculate Amortisation amount when cash flow date > PZEND.
 
     C                   IF        PZEND <> EPFLDT
 
     C                   EXSR      SrCalcAcrdInt
     C                   EXSR      SrAmortise
 
     C                   EVAL      PZBEG = PZEND
     C                   EVAL      PZEND = EPFLDT
     C                   EVAL(R)   WAllCshFlowTdy = 0
     C                   EVAL(R)   WAllPFTdy  = 0                                             232630
     C**********         EVAL(R)   WAllFeesTdy    = 0                                         232630
     C**********         EVAL(R)   WAllPcplChgTdy = 0                                         232630
 
     C                   ENDIF
                                                                                              232628
     C                   IF        EPCFTP = 'INTP'                                            232628
     C                             AND WUnSettledInt <> 0                                     232628
     C                   EVAL      WUnSettledInt = WUnSettledInt - EPCAMT                     232628
     C                   IF        WUnSettledInt < 0                                          232628
     C                   EVAL      WUnSettledInt = 0                                          232628
     C                   ENDIF                                                                232628
     C                   ENDIF                                                                232628
 
      ** Accumulate today's (PZEND) cash flow amounts
 
     C                   IF        EPFLDT <> PEIREndDate                                      232630
     C                             OR EPFLDT = PEIREndDate                                    233578
     C                             AND PMaturityDate = PEIREndDate                            233578
     C                   SELECT                                                               232928
     C                   WHEN      PLoanDepI = 'D'                                            232928
     C                   IF        EPIOIN = 'O'                                               232928
     C                   EVAL(R)   WAllCshFlowTdy = WAllCshFlowTdy + EPCAMT                   232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WAllCshFlowTdy = WAllCshFlowTdy - EPCAMT                   232928
     C                   ENDIF                                                                232928
     C                   OTHER                                                                232928
     C                   IF        EPIOIN = 'I'
     C                   EVAL(R)   WAllCshFlowTdy = WAllCshFlowTdy + EPCAMT
     C                   ELSE
     C                   EVAL(R)   WAllCshFlowTdy = WAllCshFlowTdy - EPCAMT
     C                   ENDIF
     C                   ENDSL                                                                232928
     C                   ENDIF                                                                232630
 
      ** Accumulate today's (PZEND) Fee cash flow amounts
      ** and principal changes amounts                                                        232630
 
     C                   IF        EPCFTP = 'FEEA'
     C*********                    AND EPFLDT < PEIREndDate                            232628 233578
     C                             AND EPFLDT <= PEIREndDate                                  233578
     C                             OR EPCFTP = 'PCPL'                                         232630
     C**********                   AND EPFLDT < PEIREndDate                            232628 233578
     C                             AND EPFLDT <= PEIREndDate                                  233578
     C                             OR EPCFTP = '    '                                         233578
     C                             AND EPFLDT <= PEIREndDate                                  233578
     C                             AND EPIOIN <> 'S'                                          233578
     C                   SELECT                                                               232928
     C                   WHEN      PLoanDepI = 'D'                                            232928
     C                   IF        EPIOIN = 'O'                                               232928
     C                   EVAL(R)   WAllPFTdy    = WAllPFTdy    + EPCAMT                       232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WAllPFTdy    = WAllPFTdy    - EPCAMT                       232928
     C                   ENDIF                                                                232928
     C                   OTHER                                                                232928
     C                   IF        EPIOIN = 'I'
     C                   EVAL(R)   WAllPFTdy    = WAllPFTdy    + EPCAMT                       232630
     C**********         EVAL(R)   WAllFeesTdy    = WAllFeesTdy    + EPCAMT                   232630
     C                   ELSE
     C                   EVAL(R)   WAllPFTdy    = WAllPFTdy    - EPCAMT                       232630
     C**********         EVAL(R)   WAllFeesTdy    = WAllFeesTdy    - EPCAMT                   232630
     C                   ENDIF
     C                   ENDSL                                                                232928
     C                   ENDIF
 
      ** Accumulate today's (PZEND) Principal Change Amounts
 
     C**********         IF        EPCFTP = 'PCPL'                                            232630
     C**********         IF        EPIOIN = 'I'                                               232630
     C**********         EVAL(R)   WAllPcplChgTdy = WAllPcplChgTdy + EPCAMT                   232630
     C**********         ELSE                                                                 232630
     C**********         EVAL(R)   WAllPcplChgTdy = WAllPcplChgTdy - EPCAMT                   232630
     C**********         ENDIF                                                                232630
     C**********         ENDIF                                                                232630
 
     C                   ENDIF
 
     C     PLoanRef      READE     ZAAMRTL0
 
      ***Skip*records where cash flow date is equal to period start date                      262632
     C**********         IF        PZEND = PStartDate                                         262632
     C**********         EVAL      PZEND = EPFLDT                                             262632
     C**********         ENDIF                                                                262632
     C                   ENDDO
 
     C**********         IF        WAllCshFlowTdy <> 0                                        262632
     C**********                   And PZEND <> PEndDate                                      262632
     C                   IF        PZEND > PZBEG                                              262632
     C                             AND PZEND < PEndDate                                       262632
     C                   EXSR      SrCalcAcrdInt
     C                   EXSR      SrAmortise
     C                   EVAL      PZBEG = PZEND
     C                   EVAL      PZEND = PEndDate
     C                   EVAL(R)   WAllCshFlowTdy = 0
     C                   EVAL(R)   WAllPFTdy    = 0                                           232630
     C**********         EVAL(R)   WAllFeesTdy    = 0                                         232630
     C**********         EVAL(R)   WAllPcplChgTdy = 0                                         232630
     C                   ELSE
 
      ** If no cashflows are found, amortise from parameter start date
      ** until parameter end date
     C                   EVAL      PZEND = PEndDate
     C                   ENDIF
 
     C                   EXSR      SrCalcAcrdInt
     C                   EXSR      SrAmortise
 
      ** Set output parameters
     C                   EVAL(H)   POutAmrtAmt   = WRunningAmount
     C                   EVAL(H)   PDrtPrcTdy    = WDirtyPrice
     C                   EVAL(H)   PClnPrcTdy    = WCleanPrice
 
     C                   IF        PAccrlIndictr = 'F'
 
     C                   IF        WDirtyPrice <> *ZERO
     C                   EVAL      PStartDate = PStartDate - 1
     C                   ENDIF
 
     C**********         IF        PEndDate < PEIREndDate                                     232630
     C                   IF        WPEndDate < PEIREndDate                                    232630
     C                   EVAL      PEndDate = PEndDate - 1
     C                   ENDIF
 
     C                   ENDIF
 
     C                   MOVEL     PInOutFormat  PParameter
 
      ** Return to calling Program
 
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrAmortise - Calculate amortisation amount                   *
      *****************************************************************
 
     C     SrAmortise    BEGSR
 
     C                   EXSR      SrZINTDY
 
     C                   IF        PZINDY < *ZERO
     C                   EVAL      PZINDY = *ZERO
     C                   ENDIF
 
     C***********        IF        PZINDY = *ZERO                                             232630
     C                   EVAL      WAmrtAmt = 0
     C***********        ELSE                                                                 232630
 
     C                   EVAL(R)   WTime = PZINDY/WDaysInYear
 
      ** Compute for Dirty Price
     C                   IF        WDirtyPrice = *ZERO
     C                   EVAL(R)   WDirtyPrice = WNetPrincipal
     C                                           * ((1 + PEIRRate) ** WTime)
     C                                           - WAllCshFlowTdy
     C                   ELSE
     C                   EVAL(R)   WDirtyPrice  = WDirtyPrice * ((1 + PEIRRate)
     C                                          ** WTime) - WAllCshFlowTdy
     C                   ENDIF
 
      ** Set for Previous Clean Price
     C                   EVAL      WClnPrcPrv = WCleanPrice
 
      ** Compute for Clean Price
     C                   EVAL(R)   WCleanPrice = WDirtyPrice - WAccrdIntrst
 
      ** Finally, compute today's Amortisation Amount
     C                   IF        WClnPrcPrv <> *ZERO
     C                   EVAL(R)   WAmrtAmt = WCleanPrice - WClnPrcPrv
     C                                      + WAllPFTdy                                       232630
     C**********                            + WAllPcplChgTdy                                  232630
     C                   ELSE
     C                   EVAL(R)   WAmrtAmt = WCleanPrice - WNetPrincipal
     C                                      + WAllPFTdy                                       232630
     C**********                            + WAllPcplChgTdy                                  232630
     C                   ENDIF
 
     C                   EVAL(R)   WRunningAmount = WRunningAmount + WAmrtAmt
 
     C**********         ENDIF                                                                232630
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrCalcAcrdInt - Calculate linear accrued interest.           *
      *****************************************************************
     C     SrCalcAcrdInt BEGSR
 
      ** Initialise work accrued interest
     C                   EVAL(R)   WAccrdIntrst = *ZERO
 
      ** Accumulate all cash flows to date except interest payments
 
     C**********         EVAL(R)   WAllFeesTDat   = WAllFeesTDat   +
     C**********                                    WAllFeesTdy                               232630
                                                                                              232630
      ** If process type is discount, accrued interest doesn't to be calculated
      ** since discount loans do not accrue interest
     C                   IF        PProcType = 'D'
 
     C**********         EVAL(R)   WAccrdIntrst = WAllFeesTDat                                232630
 
     C                   ELSE
 
      ** Compute for linear accrued interest from loan value date until
      ** cashflow date using principal and rate from the most recent
      ** loan record from the history files
     C                   EVAL      KDate = PZEND
     C                   IF        CAS016 = 'N'                                              CAS016
     C     KLoanDate     SETGT     HISTSL0
     C     PLoanRef      READPE    HISTSL0
     C                   ELSE                                                                CAS016
     C     KLoanDate     SETGT     ZAHTRNL0                                                  CAS016
     C     PLoanRef      READPE    ZAHTRNL0                                                  CAS016
     C                   ENDIF                                                               CAS016
 
     C                   IF        NOT %EOF(HISTSL0)
     C                             AND CAS016 = 'N'                                          CAS016
     C                             OR NOT %EOF(ZAHTRNL0)                                     CAS016
     C                             AND CAS016 = 'Y'                                          CAS016
     C                   IF        VDAT = KDate
     C                   EVAL(R)   WAccrdIntrst = AITC + AIAP - IPRD
     C                   ELSE
 
      ** If history record's value date is not equal to the cashflow
      ** date, compute for the accrual between those dates and add
      ** this to the computed accrued interest until value date.
     C                   EVAL      WBkPZBEG = PZBEG
     C                   EVAL      PZBEG = VDAT
     C                   EXSR      SrZINTDY
 
      ** Check for the latest record of either one of these Amendment Types                  233612
      ** in the history: Stop Accrual or Restart Accrual                                     233612
      ** If stop accrual, no accrued interest would be computed. If restart                  233612
      ** accrual, do the normal computation. If not found in the history,                    233612
      ** do the normal computation.                                                          233612
                                                                                             233612
     C                   EVAL      WStopAccrual = ' '                                        233612
     C     KLoanDate     SETGT     HISTSL1                                                   233612
     C     PLoanRef      READPE    HISTSL1                                                   233612
     C                   IF        NOT %EOF(HISTSL1) and                                     233612
     C                             AAMTP = 'SA' and                                          233612
     C                             PStopAccrualF = 'Y'                                       233612
     C                   EVAL      WStopAccrual = 'Y'                                        233612
     C                   ENDIF                                                               233612
                                                                                             233612
     C                   IF        WStopAccrual = ' '                                        233612
                                                                                             233612
     C                   EVAL(R)   WAccrdIntrst = (CPAM * INTR / 100 *
     C                                            PZINDY / WDaysInYear) +
     C                                            AITC + AIAP - IPRD
     C                   ELSE                                                                233612
     C                   EVAL(R)   WAccrdIntrst = AITC + AIAP - IPRD                         233612
     C                   ENDIF                                                               233612
 
      ** Set begin date to original value
     C                   EVAL      PZBEG = WBkPZBEG
     C                   ENDIF
     C                   ENDIF
 
      ** Deduct Fee amounts to date from accrued interest (IPRD already deducted)
     C**********         EVAL(R)   WAccrdIntrst = WAccrdIntrst - WAllFeesTDat                 232630
     C**********         EVAL      WAccrdIntrst = WAccrdIntrst - WUnSettledInt         232628 262600
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrZINTDY - Compute number of days between 2 dates            *
      *****************************************************************
     C     SrZINTDY      BEGSR
 
      *                                                                                       CDL093
      ** Calculation type 9                                                                   CDL093
      *                                                                                       CDL093
     C                   Z-ADD     PZBEG         ZZBEG9            5 0                        CDL093
     C                   Z-ADD     PZEND         ZZEND9            5 0                        CDL093
      *                                                                                       CDL093
     C                   CALLB     'ZINTDY'
     C                   PARM                    PRetCdeOut
     C                   PARM                    PZINDY
     C                   PARM                    PZBEG
     C                   PARM                    PZEND
     C                   PARM                    PZCALC
     C                   PARM                    PINT6DY
 
     C                   IF        PIntCalcBasis = 9                                          CDL093
     C                   Z-ADD     ZZBEG9        @@DAYN            5 0                        CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZStartDate                                  CDL093
      *                                                                                       CDL093
     C                   Z-ADD     ZZEND9        @@DAYN                                       CDL093
     C                   EXSR      ZDATE9                                                     CDL093
     C                   Z-ADD     @@VDT         ZZEndDate                                    CDL093
                                                                                              CDL093
      ** Check if the period contains a Feb 29                                                CDL093
                                                                                              CDL093
     C                   EXSR      #FEB29                                                     CDL093
      *                                                                                       CDL093
     C                   ENDIF                                                                CDL093
      *                                                                                       CDL093
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  SrInitialise - Initialise work variables                     *
      *****************************************************************
 
     C     SrInitialise  BEGSR
 
      ** Initialise output parameter
 
     C                   EVAL      POutAmrtAmt   = *ZERO
     C                   EVAL      PDrtPrcTdy    = *ZERO
     C                   EVAL      PClnPrcTdy    = *ZERO
 
      ** Initialise working variables
 
     C                   EVAL      WRunningAmount = *ZERO
     C                   EVAL      WDirtyPrice = PPrevDirtyPrc
     C                   EVAL      WCleanPrice = PPrevCleanPrc
     C                   EVAL      WCashFlowFound = 'N'
     C                   MOVE      PIntCalcBasis PZCALC
 
      ** Determine number of days in a year
     C                   SELECT
     C                   WHEN      PIntCalcBasis = 2 OR
     C                             PIntCalcBasis = 3 OR
     C                             PIntCalcBasis = 5
     C                   Z-ADD     360           WDaysInYear
     C                   WHEN      PIntCalcBasis = 1 OR
     C                             PIntCalcBasis = 4
     C                             OR PIntCalcBasis = 9 AND #29FEB <> 'Y'                     CDL093
     C                   Z-ADD     365           WDaysInYear
     C                   WHEN      PIntCalcBasis = 6
     C                             OR PIntCalcBasis = 9 AND #29FEB =  'Y'                     CDL093
     C                   Z-ADD     366           WDaysInYear
     C                   ENDSL
 
      ** Retrieve Principal/Nominal amount from history file used for
      ** getting the net principal amount
 
     C                   EVAL      WNetPrincipal = *ZERO
     C                   EVAL      KDate = PEIRStartDate
                                                                                              CAS016
     C                   IF        CAS016 = 'N'                                               CAS016
     C     KLoanDate     CHAIN     HISTSL0
     C                   ELSE                                                                 CAS016
     C     KLoanDate     CHAIN     ZAHTRNL0                                                   CAS016
     C                   IF        %FOUND(ZAHTRNL0) = *OFF                                    262600
     C     KLoanDate     SETGT     ZAHTRNL0                                                   262600
     C     PLoanRef      READPE    ZAHTRNL0                                                   262600
     C                   ENDIF                                                                262600
     C                   ENDIF                                                                CAS016
                                                                                              CAS016
     C                   IF        %FOUND(HISTSL0)
     C                             OR %FOUND(ZAHTRNL0)                                        248259
     C                   EVAL      WUnSettledInt = AITC - IPRD                                232628
     C                   IF        CPAM <> 0                                                  232630
     C                             OR  AMTP = 'MA'                                            262600
     C**********                   AND CPAM <> 0                                              232630
     C**********         EVAL      WNetPrincipal = CPAM                                       232628
     C**********         EVAL      WNetPrincipal = CPAM + WUnSettledInt                232628 262600
     C                   EVAL      WNetPrincipal = CPAM                                       262600
     C                   ELSE
     C**********         EVAL      WNetPrincipal = PRAM                                       232628
     C**********         EVAL      WNetPrincipal = PRAM + WUnSettledInt                232628 262600
     C                   EVAL      WNetPrincipal = PRAM                                       262600
     C                   ENDIF
     C                   ENDIF                                                                232630
     C                   EVAL      WNetPrincipal = WNetPrincipal - PTOTI
 
      ** Process present cash flows to obtain total cash flow from EIR
      ** start to date. All compute net principal if cash flow date is
      ** equal to EIR start date.
 
     C**********         EVAL      WAllFeesTDat   = *ZERO                                     232630
     C     PLoanRef      SETLL     ZAAMRTL0
     C     PLoanRef      READE     ZAAMRTL0
 
     C                   DOW       NOT %EOF(ZAAMRTL0)
     C                             AND EPFLDT <= PStartDate
 
      ** Work net principal
     C                   IF        EPFLDT = PEIRStartDate
     C                             AND EPCFTP = 'FEEA'                                        232630
     C                   SELECT                                                               232928
     C                   WHEN      PLoanDepI = 'D'                                            232928
     C                   IF        EPIOIN = 'O'                                               232928
     C                   EVAL(R)   WNetPrincipal = WNetPrincipal - EPCAMT                     232928
     C                   ELSE                                                                 232928
     C                   EVAL(R)   WNetPrincipal = WNetPrincipal + EPCAMT                     232928
     C                   ENDIF                                                                232928
     C                   OTHER                                                                232928
     C                   IF        EPIOIN = 'I'
     C                   EVAL(R)   WNetPrincipal = WNetPrincipal - EPCAMT
     C                   ELSE
     C                   EVAL(R)   WNetPrincipal = WNetPrincipal + EPCAMT
     C                   ENDIF
     C                   ENDSL                                                                232928
     C                   ENDIF
 
      ** All cash flows to date except interest payments.
 
     C**********         IF        EPFLDT > PEIRStartDate                                     232630
     C**********                   AND EPCFTP = 'FEEA'                                        232630
     C**********         IF        EPIOIN = 'I'                                               232630
     C**********         EVAL(R)   WAllFeesTDat   = WAllFeesTDat   + EPCAMT                   232630
     C**********         ELSE                                                                 232630
     C**********         EVAL(R)   WAllFeesTDat   = WAllFeesTDat   - EPCAMT                   232630
     C**********         ENDIF                                                                232630
     C**********         ENDIF                                                                232630
 
     C     PLoanRef      READE     ZAAMRTL0
     C                   ENDDO
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *  *INZSR - Program Initialisation routine                      *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PParameter
 
     C                   MOVEL     PParameter    PInOutFormat
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Check if CAS016 is installed                                                         CAS016
     C                   CALL      'AOSARDR0'                                                 CAS016
     C                   PARM      *BLANKS       PRtCd                                        CAS016
     C                   PARM      '*VERIFY'     POptn                                        CAS016
     C                   PARM      'CAS016'      PSard                                        CAS016
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS016
                                                                                              CAS016
     C                   IF        PRtCd <> *BLANKS AND                                       CAS016
     C                             PRtCd <> '*NRF    '                                        CAS016
     C     *LOCK         IN        LDA                                                        CAS016
     C                   EVAL      DBFILE =  'SCSARDPD'                                       CAS016
     C                   EVAL      DBKEY =  POptn                                             CAS016
     C                   EVAL      DBASE =  001                                               CAS016
     C                   OUT       LDA                                                        CAS016
     C                   EXSR      *PSSR                                                      CAS016
     C                   ENDIF                                                                CAS016
                                                                                              CAS016
      ** Ignore CAS016 for Dealing                                                          BUG17508
     C                   IF        PRtCd = *BLANKS                                            CAS016
     C                             And PCallingPgm <> 'MM004650'                            BUG17508
     C                   EVAL      CAS016 = 'Y'                                               CAS016
     C                   ELSE                                                                 CAS016
     C                   EVAL      CAS016 = 'N'                                               CAS016
     C                   ENDIF                                                                CAS016
                                                                                              CAS016
      ** Set up standard DB error fields
     C     *LOCK         IN        LDA
      /COPY ZACPYSRC,DBFIELDS
     C                   OUT       LDA
 
      ** Key list by loan number and cash flow date
     C     KLoanDate     KLIST
     C                   KFLD                    PLoanRef
     C                   KFLD                    KDate
 
     C                   ENDSR
 
      **********************************************************************
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
 
     C                   IF        @RUN = *BLANK
     C                   EVAL      @RUN = 'Y'
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   RETURN
 
     C                   ENDSR
     C/COPY ZSRSRC,ZFEB29Z2LE                                                                 CDL093
     C/COPY ZSRSRC,ZDATE9Z3LE                                                                 CDL093
 
