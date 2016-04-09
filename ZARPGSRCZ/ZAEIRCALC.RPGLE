     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2004')
      *****************************************************************
/*S*D****RPGBASEBND****************************************************                       CAS016
/*STD *  RPGBASEMOD                                                   *                       CAS016
/*EXI *  TEXT('Midas ZA Effective Interest Rate Calculator')          *
      *****************************************************************
      *                                                               *
      *  Midas - Common Function Module                               *
      *                                                               *
      *  ZAEIRCALC - Effective Interest Rate Calculator               *
      *                                                               *
      *  Function:  This program will compute for the Effective       *
      *             Interest Rate(EIR) using direct computation for   *
      *             single-dated future cashflow or iteration method, *
      *             either Newton-Raphson Method or Successive        *
      *             Bisection Method, for cashflows that occur in     *
      *             different dates.                                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2004            *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      *  Prev Amend No. 262654             Date 11May09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CAS019             Date 24Mar07               *
      *                 240094             Date 28Feb06               *
      *                 CAS016             Date 28Feb06               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 233545             Date 18May05               *
      *                 CAS009  *CREATE    Date 04May04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference                                *
      *  262654 - Fixes to ZAEIRCALC:                                 *
      *           a) Enlarge EIR output field to match size of EIR    *
      *           field on LE and MM files.                           *
      *           b) If Newton-Raphson method fails due to overflow   *
      *           then try with Successive Bisection method.          *
      *           c) Monitor for overflow in subroutine SrSuccBisec   *
      *           (fixed under reference 262654 in Midas Plus)        *
      *           d) Monitor for overflow in subroutine SrEIR.        *
      *  CAS019 - Upgrade of CAS016 to Midas Plus                     *
      *  240094 - Monitor error msg to handle program dump.           *
      *  CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over      *
      *           Whole Period)                                       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  233545 - Cut-off Date (Recompile)                            *
      *  CAS009 - Effective Interest Rate/Amortised Cost Accounting   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    01         CHAIN/READ indicator                            *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrInit      - Initialisation                                 *
      *  SrNoIteratn - Calculation method without iteration           *
      *  SrNewtnRaph - Newton-Raphson Method                          *
      *  SrSuccBisec - Successive Bisection Method                    *
      *  SrEIR       - Compute for Effective Interest Rate            *
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
 
      ** EIR Future Cash Flow File
     FZAEIRFL0  IF   E           K DISK    INFSR(*PSSR) USROPN
 
      ** EIR Present Cash Flow File
     FZAEIRPL0  IF   E           K DISK    INFSR(*PSSR) USROPN
 
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
      ** Program Exception                                                                    240094
     D PSException            40     46                                                       240094
      **--------------------------------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for Hedging ICD
     D SDHEDG        E DS                  EXTNAME(SDHEDGPD)
 
      ** First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Input Parameter
     D*PInpTNRF*       S              6S 0                                                    CLE148
     D PInpTNRF        S              6A                                                      CLE148
     D PInpStartEff    S              5P 0
     D PInpEndEff      S              5P 0
 
      ** Output Parameter
     D*POutEIR**       S             14P12                                                    262654
     D POutEIR         S             15P10                                                    262654
     D PReturnCode     S              7A
 
      ** Parameter for access object
     D PRtCd           S              7A
     D POptn           S              7A
 
      ** Work Variables
     D WValX           S              8F
     D WNoDayAYr       S              3P 0
     D WCFAmount       S             15P 0
     D WIteration      S              1A
     D WRootFnd        S              1A
 
     D WNISumPC        S              8F
     D WNISumFC        S              8F
 
     D WNRFailed       S              1A
     D WNRNoIter       S              5S 0
     D WNRSumPCFFx     S              8F
     D WNRSumPCFdFx    S              8F
     D WNRSumFCFFx     S              8F
     D WNRSumFCFdFx    S              8F
     D WNRFx           S              8F
     D WNRdFx          S              8F
     D WNRPrevX        S              8F
     D WNRTmpFx        S             30P 3
 
     D WSBValX1        S              8F
     D WSBValX2        S              8F
     D WSBMean         S              8F
     D WSBSumPCFFx1    S              8F
     D WSBSumPCFFx2    S              8F
     D WSBSumPCFFxM    S              8F
     D WSBSumFCFFx1    S              8F
     D WSBSumFCFFx2    S              8F
     D WSBSumFCFFxM    S              8F
     D WSBFx1          S              8F
     D WSBFx2          S              8F
     D WSBFxM          S              8F
     D WSBFx1Tmp       S             30P 3
     D WSBFx2Tmp       S             30P 3
 
     D @RUN            S              1A
 
     D wERR104         S              1A   INZ('N')                                           240094
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
 
     C                   OPEN      ZAEIRFL0                                                   CAS016
     C                   OPEN      ZAEIRPL0                                                   CAS016
                                                                                              CAS016
     C                   EXSR      SrInit
 
      ** Check if future cashflow/s occurs only on the end of
      ** effectivity date for the given period
 
     C     PInpTNRF      CHAIN     ZAEIRFL0                           01
     C                   DOW       *IN01 = *OFF AND
     C                             WIteration = 'N'
     C                   IF        EFFLDT > PInpStartEff AND
     C                             EFFLDT < PInpEndEff
     C                   EVAL      WIteration = 'Y'
     C                   ELSE
     C     PInpTNRF      READE     ZAEIRFL0                               01
     C                   ENDIF
     C                   ENDDO
 
      ** Compute for WValX without iteration
 
     C                   IF        WIteration = 'N'
     C                   EXSR      SrNoIteratn
     C                   ENDIF
 
      ** Newton-Raphson Method
 
     C                   IF        WRootFnd = 'N'
     C                   EXSR      SrNewtnRaph
     C                   ENDIF
 
      ** If Newton-Raphson failed or No root found perform
      ** Successive Bisection Method
 
     C                   IF        WRootFnd = 'N'
     C                   EXSR      SrSuccBisec
     C                   ENDIF
 
      ** Calculate Effective Interest Rate
 
     C                   EXSR      SrEIR
 
      ** Return to calling Program
                                                                                              CAS016
     C                   CLOSE     ZAEIRFL0                                                   CAS016
     C                   CLOSE     ZAEIRPL0                                                   CAS016
 
     C                   RETURN
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
 
     C     SrInit        BEGSR
 
      ** Initialise Output parameters
 
     C                   EVAL      POutEIR      = *ZERO
     C                   EVAL      PReturnCode  = *BLANKS
 
      ** Initialise working variables
 
     C                   EVAL      WValX        = *ZERO
     C                   EVAL      WCFAmount    = *ZERO
     C                   EVAL      WNoDayAYr    = *ZERO
 
      ** Initialise numeric fields for no iteration calculation method
 
     C                   EVAL      WNISumPC     = *ZERO
     C                   EVAL      WNISumFC     = *ZERO
 
      ** Initialise numeric fields for Newton-Raphson Method
 
     C                   EVAL      WNRNoIter    = *ZERO
     C                   EVAL      WNRSumPCFFx  = *ZERO
     C                   EVAL      WNRSumPCFdFx = *ZERO
     C                   EVAL      WNRSumFCFFx  = *ZERO
     C                   EVAL      WNRSumFCFdFx = *ZERO
     C                   EVAL      WNRFx        = *ZERO
     C                   EVAL      WNRdFx       = *ZERO
     C                   EVAL      WNRPrevX     = *ZERO
 
      ** Initialise numeric fields for Successive Bisection Method
 
     C                   EVAL      WSBValX1     = *ZERO
     C                   EVAL      WSBValX2     = *ZERO
     C                   EVAL      WSBMean      = *ZERO
     C                   EVAL      WSBSumPCFFx1 = *ZERO
     C                   EVAL      WSBSumPCFFx2 = *ZERO
     C                   EVAL      WSBSumPCFFxM = *ZERO
     C                   EVAL      WSBSumFCFFx1 = *ZERO
     C                   EVAL      WSBSumFCFFx2 = *ZERO
     C                   EVAL      WSBSumFCFFxM = *ZERO
     C                   EVAL      WSBFx1       = *ZERO
     C                   EVAL      WSBFx2       = *ZERO
     C                   EVAL      WSBFxM       = *ZERO
     C                   EVAL      WSBFx1Tmp    = *ZERO
     C                   EVAL      WSBFx2Tmp    = *ZERO
 
      ** Initialise flag indicators
 
     C                   EVAL      WNRFailed    = 'N'
     C                   EVAL      WRootFnd     = 'N'
     C                   EVAL      WIteration   = 'N'
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNoIteratn - Calculation method without iteration           *
      *                                                               *
      *****************************************************************
 
     C     SrNoIteratn   BEGSR
 
      ** Procees all EIR present cash flow of a given transaction
      ** with cash flow date equal to start of effectivity period
 
     C     KInpPCF       CHAIN     ZAEIRPL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EPIOIN = 'I'
     C                   EVAL      WCFAmount = -(EPCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EPCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Present Cash Flows
 
     C                   EVAL(R)   WNISumPC = WNISumPC + WCFAMount
 
     C     KInpPCF       READE     ZAEIRPL0                               01
     C                   ENDDO
 
      ** Process all EIR future cash flow of a given transaction
      ** with cash flow date equal to end of effectivity period
 
     C     KInpFCF       CHAIN     ZAEIRFL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EFIOIN = 'O'
     C                   EVAL      WCFAmount = -(EFCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EFCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Future Cash Flows
 
     C                   EVAL(R)   WNISumFC = WNISumFC + WCFAMount
 
     C     KInpFCF       READE     ZAEIRFL0                               01
     C                   ENDDO
 
     C                   IF        WNISumPC <> *ZERO
     C                   IF        %REM(EPNDEI:2) = 1 OR
     C                             WNISumPC <  *ZERO AND
     C                             WNISumFC <  *ZERO OR
     C                             WNISumPC >  *ZERO AND
     C                             WNISumFC >  *ZERO
 
     C                   EVAL(R)   WValX = (WNISumFC/WNISumPC) ** (1/EPNDEI)
     C                   EVAL      WRootFnd = 'Y'
     C                   ENDIF
 
     C                   ELSE
     C                   EVAL      PReturnCode = '*ERROR '
     C                   CLOSE     ZAEIRFL0                                                   CAS016
     C                   CLOSE     ZAEIRPL0                                                   CAS016
                                                                                              CAS016
     C                   RETURN
 
     C                   ENDIF
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNewtnRaph - Newton-Raphson Method                          *
      *                                                               *
      *****************************************************************
 
     C     SrNewtnRaph   BEGSR
 
     C                   EVAL      WValX = FSNRSV
 
      ** Execute the following commands until root is found or
      ** Number of iterations done is already equal to the value of
      ** of Newton-Raphson Method Number of Iterations defined in
      ** SDHEDGPD or Newton-Raphson Method Failed
 
     C                   DOW       WRootFnd <> 'Y'      AND
     C                             WNRNoIter  <> FSNRNI AND
     C                             WNRFailed  <> 'Y'
 
      ** Initialise summation variables
 
     C                   EVAL      WNRSumPCFFx  = *ZERO
     C                   EVAL      WNRSumPCFdFx = *ZERO
     C                   EVAL      WNRSumFCFFx  = *ZERO
     C                   EVAL      WNRSumFCFdFx = *ZERO
 
      ** Procees all EIR present cash flow of a given transaction
 
     C     KInpPCF       CHAIN     ZAEIRPL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EPIOIN = 'I'
     C                   EVAL      WCFAmount = -(EPCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EPCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Present Cash Flows
 
     C                   MONITOR                                                              240094
     C                   EVAL(R)   WNRSumPCFFx = WNRSumPCFFx + WCFAMount *
     C                               (WValX ** EPNDEI)
     C                   EVAL(R)   WNRSumPCFdFx = WNRSumPCFdFx +
     C                               (EPNDEI * WCFAMount) * (WValX **
     C                               (EPNDEI - 1))
 
      ** If Program error occurs (00103 or 00104) and encounter CEE2025/2024                  240094
      ** set EIR to Zero                                                                      240094
     C                   ON-ERROR  00103                                                      240094
     C**********         EXSR      SrMON                                               240094 262654
     C                   EVAL      WNRFailed = 'Y'                                            262654
     C                   ON-ERROR  00104                                                      240094
     C**********         EXSR      SrMON                                               240094 262654
     C                   EVAL      WNRFailed = 'Y'                                            262654
     C                   ON-ERROR                                                             240094
     C                   EXSR      *PSSR                                                      240094
     C                   ENDMON                                                               240094
                                                                                              240094
     C     KInpPCF       READE     ZAEIRPL0                               01
     C                   ENDDO
 
      ** Process all EIR future cash flow of a given transaction
 
     C     PInpTNRF      CHAIN     ZAEIRFL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EFFLDT  > PInpStartEff AND
     C                             EFFLDT <= PInpEndEff
 
     C                   IF        EFIOIN = 'O'
     C                   EVAL      WCFAmount = -(EFCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EFCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Future Cash Flows
 
     C                   MONITOR                                                              240094
     C                   EVAL(R)   WNRSumFCFFx = WNRSumFCFFx + WCFAMount *
     C                               (WValX ** EFNDEI)
     C                   EVAL(R)   WNRSumFCFdFx = WNRSumFCFdFx +
     C                               (EFNDEI * WCFAMount) * (WValX **
     C                               (EFNDEI - 1))
                                                                                              240094
      ** If Program error occurs (00103 or 00104) and encounter CEE2025/2024                  240094
      ** set EIR to Zero                                                                      240094
     C                   ON-ERROR  00103                                                      240094
     C**********         EXSR      SrMON                                               240094 262654
     C                   EVAL      WNRFailed = 'Y'                                            262654
     C                   ON-ERROR  00104                                                      240094
     C**********         EXSR      SrMON                                               240094 262654
     C                   EVAL      WNRFailed = 'Y'                                            262654
     C                   ON-ERROR                                                             240094
     C                   EXSR      *PSSR                                                      240094
     C                   ENDMON                                                               240094
 
     C                   ENDIF
 
     C     PInpTNRF      READE     ZAEIRFL0                               01
     C                   ENDDO
 
      ** Compute for f(x) = WNRFx and f'(x) = WNRdFx
 
     C                   EVAL(R)   WNRFx  = WNRSumPCFFx  - WNRSumFCFFx
     C                   EVAL(R)   WNRdFx = WNRSumPCFdFx - WNRSumFCFdFx
 
      ** Store the previous value of x
 
     C                   EVAL      WNRPrevX = WValX
 
      ** If derivative of function of previous value of x is not
      ** equal to zero, generate the next iterated value of x.
      ** Otherwise, set the Newton-Raphson Failed Flag to 'Y'.
 
     C                   IF        WNRdFx <> *ZERO
     C                   EVAL(R)   WValX  =  WNRPrevX - (WNRFx/WNRdFx)
     C                   ELSE
     C                   EVAL      WNRFailed = 'Y'
     C                   ENDIF
 
      ** If Newton Raphson Method Iteration did not fail, increment
      ** no. of iteration by 1.
 
     C                   IF        WNRFailed <> 'Y'
     C                   EVAL      WNRNoIter = WNRNoIter + 1
 
      ** If f(x) converges, root of f(x) is found
 
     C                   IF        WValX = WNRPrevX
     C                   EVAL      WNRTmpFx = WNRFx
     C                   IF        WNRTmpFx = *ZERO
     C                   EVAL      WRootFnd = 'Y'
     C                   ELSE
     C                   EVAL      WNRFailed = 'Y'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSuccBisec - Successive Bisection Method                    *
      *                                                               *
      *****************************************************************
 
     C     SrSuccBisec   BEGSR
 
      ** Initialise first and second starting values
 
     C                   EVAL      WSBValX1 = FSSB1S
     C                   EVAL      WSBValX2 = FSSB2S
 
      ** Execute the following commands until root of f(x) is found
 
     C                   DOW       WRootFnd <> 'Y'
 
      ** Get the Mean of the test values
 
     C                   EVAL(R)   WSBMean = (WSBValX1+WSBValX2)/2
 
      ** Initialise summation variables
 
     C                   EVAL      WSBSumPCFFx1 = *ZERO
     C                   EVAL      WSBSumPCFFx2 = *ZERO
     C                   EVAL      WSBSumPCFFxM = *ZERO
     C                   EVAL      WSBSumFCFFx1 = *ZERO
     C                   EVAL      WSBSumFCFFx2 = *ZERO
     C                   EVAL      WSBSumFCFFxM = *ZERO
 
      ** Process all EIR present cash flow of a given transaction
 
     C     KInpPCF       CHAIN     ZAEIRPL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EPIOIN = 'I'
     C                   EVAL      WCFAmount = -(EPCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EPCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Present Cash Flows
 
     C                   MONITOR                                                              CAS019
     C                   EVAL(R)   WSBSumPCFFx1 = WSBSumPCFFx1 + WCFAMount
     C                               * (WSBValX1 ** EPNDEI)
     C                   EVAL(R)   WSBSumPCFFx2 = WSBSumPCFFx2 + WCFAMount
     C                               * (WSBValX2 ** EPNDEI)
     C                   EVAL(R)   WSBSumPCFFxM = WSBSumPCFFxM + WCFAMount
     C                               * (WSBMean  ** EPNDEI)
 
      ** If Program error occurs (00103 or 00104) and encounter CEE2025/2024                  CAS019
      ** set EIR to Zero                                                                      CAS019
     C                   ON-ERROR  00103                                                      CAS019
     C                   EXSR      SrMON                                                      CAS019
     C                   ON-ERROR  00104                                                      CAS019
     C                   EXSR      SrMON                                                      CAS019
     C                   ON-ERROR                                                             CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDMON                                                               CAS019
                                                                                              CAS019
     C     KInpPCF       READE     ZAEIRPL0                               01
     C                   ENDDO
 
      ** Process all EIR future cash flow of a given transaction
 
     C     PInpTNRF      CHAIN     ZAEIRFL0                           01
     C                   DOW       *IN01 = *OFF
 
     C                   IF        EFFLDT  > PInpStartEff AND
     C                             EFFLDT <= PInpEndEff
 
     C                   IF        EFIOIN = 'O'
     C                   EVAL      WCFAmount = -(EFCAMT)
     C                   ELSE
     C                   EVAL      WCFAmount = EFCAMT
     C                   ENDIF
 
      ** Accumulate all future values of Future Cash Flows
 
     C                   MONITOR                                                              CAS019
     C                   EVAL(R)   WSBSumFCFFx1 = WSBSumFCFFx1 + WCFAMount
     C                               * (WSBValX1 ** EFNDEI)
     C                   EVAL(R)   WSBSumFCFFx2 = WSBSumFCFFx2 + WCFAMount
     C                               * (WSBValX2 ** EFNDEI)
     C                   EVAL(R)   WSBSumFCFFxM = WSBSumFCFFxM + WCFAMount
     C                               * (WSBMean  ** EFNDEI)
 
      ** If Program error occurs (00103 or 00104) and encounter CEE2025/2024                  CAS019
      ** set EIR to Zero                                                                      CAS019
     C                   ON-ERROR  00103                                                      CAS019
     C                   EXSR      SrMON                                                      CAS019
     C                   ON-ERROR  00104                                                      CAS019
     C                   EXSR      SrMON                                                      CAS019
     C                   ON-ERROR                                                             CAS019
     C                   EXSR      *PSSR                                                      CAS019
     C                   ENDMON                                                               CAS019
                                                                                              CAS019
     C                   ENDIF
 
     C     PInpTNRF      READE     ZAEIRFL0                               01
     C                   ENDDO
 
      ** Compute for the function of WSBValX1, WSBValX2 and WSBMean
 
     C                   EVAL(R)   WSBFx1 = WSBSumPCFFx1 - WSBSumFCFFx1
     C                   EVAL(R)   WSBFx2 = WSBSumPCFFx2 - WSBSumFCFFx2
     C                   EVAL(R)   WSBFxM = WSBSumPCFFxM - WSBSumFCFFxM
 
      ** Verify if root has already been generated
 
     C                   SELECT
     C                   WHEN      WSBFx1 = *ZERO
     C                   EVAL      WValX = WSBValX1
     C                   EVAL      WRootFnd = 'Y'
 
     C                   WHEN      WSBFx2 = *ZERO
     C                   EVAL      WValX = WSBValX2
     C                   EVAL      WRootFnd = 'Y'
 
     C                   WHEN      WSBFxM = *ZERO
     C                   EVAL      WValX = WSBMean
     C                   EVAL      WRootFnd = 'Y'
 
     C                   WHEN      WSBMean = WSBValX1  OR
     C                             WSBMean = WSBValX2
 
     C                   EVAL      WSBFx1Tmp = WSBFx1
     C                   EVAL      WSBFx2Tmp = WSBFx2
 
     C                   SELECT
     C                   WHEN      WSBFx1Tmp = *ZERO
     C                   EVAL      WValX = WSBValX1
     C                   EVAL      WRootFnd = 'Y'
     C                   WHEN      WSBFx2Tmp = *ZERO
     C                   EVAL      WValX = WSBValX2
     C                   EVAL      WRootFnd = 'Y'
     C                   ENDSL
 
     C                   ENDSL
 
      ** Execute the following commands if root has not been found
 
     C                   IF        WRootFnd <> 'Y'
 
     C                   IF        WSBFx1 > *ZERO AND WSBFx2 > *ZERO OR
     C                             WSBFx1 < *ZERO AND WSBFx2 < *ZERO
     C                   EVAL      PReturnCode = '*ERROR '
     C                   CLOSE     ZAEIRFL0                                                   CAS016
     C                   CLOSE     ZAEIRPL0                                                   CAS016
     C                   RETURN
     C                   ENDIF
 
      ** Choose either WSBValX1 or WSBValX2 as one of the starting
      ** values such that WSBFxM and the choice of WSBFx1 or WSBFx2
      ** are of opposite sign.
 
     C                   IF        WSBFxM > *ZERO AND WSBFx2 < *ZERO OR
     C                             WSBFxM < *ZERO AND WSBFx2 > *ZERO
     C                   EVAL      WSBValX1 = WSBValX2
     C                   ENDIF
 
      ** Choose WSBMean as one of the starting values
 
     C                   EVAL      WSBValX2 = WSBMean
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDSR
 
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEIR - Compute for Effective Interest Rate                  *
      *                                                               *
      *****************************************************************
 
     C     SrEIR         BEGSR
 
      ** The Cash Flow frequency used is daily. That means number of
      ** Cash flows in a year is also the number of days in a year.
      ** EPNDYY considers the Interest Calculation Basis used.
 
     C                   EVAL      WNoDayAYr = EPNDYY
     C                   MONITOR                                                              262654
     C                   EVAL(R H) POutEIR = (WValX ** WNoDayAYr) - 1
     C                   ON-ERROR  00103                                                      262654
     C                   EVAL      POutEIR = 0                                                262654
     C                   ENDMON                                                               262654
 
     C                   ENDSR
 
      **********************************************************************                  240094
      /EJECT                                                                                  240094
      *****************************************************************                       240094
      *                                                               *                       240094
      *  SrMON - Handle Monitor errors                                *                       240094
      *                                                               *                       240094
      *****************************************************************                       240094
                                                                                              240094
     C     SrMON         BEGSR                                                                240094
                                                                                              240094
      ** If Program error occurs (00103 or 00104) and encounter CEE2025/CE2024                240094
      ** set EIR to zero                                                                      240094
     C                   IF        PSException = 'CEE2025'                                    240094
     C                             OR PSException = 'CEE2024'                                 240094
     C                   EVAL      POutEIR = 0                                                240094
     C                   EVAL      wERR104 = 'Y'                                              240094
     C                   EXSR      *PSSR                                                      240094
     C                   ENDIF                                                                240094
                                                                                              240094
     C                   ENDSR                                                                240094
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation routine                      *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
     C                   PARM                    PInpTNRF
     C                   PARM                    PInpStartEff
     C                   PARM                    PInpEndEff
     C                   PARM                    POutEIR
     C                   PARM                    PReturnCode
 
      ** Initialise Program name
 
     C                   EVAL      DBPGM  =  'ZAEIRCALC'
 
      ** Define data area
 
     C     *DTAARA       DEFINE                  LDA
 
      ** Define Key List
 
     C     KInpPCF       KLIST
     C                   KFLD                    PInpTNRF
     C                   KFLD                    PInpStartEff
 
     C     KInpFCF       KLIST
     C                   KFLD                    PInpTNRF
     C                   KFLD                    PInpEndEff
 
      ** Open input files
 
     C**********         OPEN      ZAEIRFL0                                                   CAS016
     C**********         OPEN      ZAEIRPL0                                                   CAS016
 
      ** Access Midas SD Hedging ICD File
 
     C                   CALL      'AOHEDGR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST  '    POptn
     C     SDHEDG        PARM      SDHEDG        DSFDY
 
      ** Database Error
 
     C                   IF        PRtCd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKEY  =  POptn
     C                   EVAL      DBFILE =  'SDHEDGPD'
     C                   EVAL      DBASE  =  1
     C                   EVAL      DBPROC =  'SR/*INZSR'
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
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
     C                   IF        wERR104 = 'N'                                              240094
     C                   DUMP
     C                   CALL      'DBERRCTL'
     C                   ENDIF                                                                240094
     C                   ENDIF
 
     C                   EVAL      *INU7 = *ON
     C                   EVAL      *INU8 = *ON
     C                   EVAL      *INLR = *ON
     C                   CLOSE     ZAEIRFL0                                                   CAS016
     C                   CLOSE     ZAEIRPL0                                                   CAS016
     C                   RETURN
 
     C                   ENDSR
 
