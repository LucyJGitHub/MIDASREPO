/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Average Balance Accumulation')                *
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000040 -  Average Balance Accumulation                     *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CER059             Date 19Jul10               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     D POWER           S              8  0 DIM(8) CTDATA PERRCD(1)
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
 
     C     *ENTRY        PLIST
 
     C                   PARM                    ModeOfOp         11
     C                   PARM                    Audit             1
      *INPUTS
     C                   PARM                    Currency          3
     C                   PARM                    StrPeriodDat      5 0
     C                   PARM                    EndPeriodDat      5 0
     C                   PARM                    EndPeriodBal     18 3
     C                   PARM                    DRMoveInPeriod   18 3
     C                   PARM                    CRMoveInPeriod   18 3
 
     C                   PARM                    PostingDate       5 0
     C                   PARM                    PostingAmount    18 3
 
      *OUTPUTS
     C                   PARM                    CurrentDate       5 0
     C                   PARM                    FinalDate         5 0
 
     C                   PARM                    CurrentBalance   18 3
 
     C                   PARM                    NTAvgeBalance    18 3
     C                   PARM                    DRAvgeBalance    18 3
     C                   PARM                    CRAvgeBalance    18 3
 
     C                   PARM                    DRWeightedBal    21 3
     C                   PARM                    CRWeightedBal    21 3
 
     C                   PARM                    FLNoOfDays        3 0
     C                   PARM                    DRNoOfDays        3 0
     C                   PARM                    CRNoOfDays        3 0
 
     C                   PARM                    MaxBalance       18 3
     C                   PARM                    MinBalance       18 3
 
     C                   PARM                    NoOfDays          3 0
     C                   PARM                    WeightedBalanc   21 3
     C                   PARM                    FromDate          7
     C                   PARM                    ToDate            7
 
     C                   SELECT
 
     C     ModeOfOp      WHENEQ    'PeriodStart'
     C                   EXSR      PERIOD_START
 
     C     ModeOfOp      WHENEQ    'NewDate    '
     C                   EXSR      NEW_DATE
 
     C     ModeOfOp      WHENEQ    'Posting    '
     C                   EXSR      POSTING
 
     C     ModeOfOp      WHENEQ    'PeriodEnd  '
     C                   EXSR      PERIOD_END
     C                   ENDSL
 
     C                   RETURN
 
      /SPACE 5
     C**********************************************************************************
     C     PERIOD_START  BEGSR
 
     C                   Z-ADD     StrPeriodDat  CurrentDate
     C     EndPeriodDat  ADD       1             FinalDate
 
     C     EndPeriodBal  SUB       DRMoveInPeriodCurrentBalance
     C                   SUB       CRMoveInPeriodCurrentBalance
 
     C                   Z-ADD     *ZERO         NTAvgeBalance
     C                   Z-ADD     *ZERO         DRAvgeBalance
     C                   Z-ADD     *ZERO         CRAvgeBalance
 
     C                   Z-ADD     *ZERO         DRWeightedBal
     C                   Z-ADD     *ZERO         CRWeightedBal
 
     C                   Z-ADD     *ZERO         FLNoOfDays
     C                   Z-ADD     *ZERO         DRNoOfDays
     C                   Z-ADD     *ZERO         CRNoOfDays
 
     C                   Z-SUB     *HIVAL        MaxBalance
     C                   Z-ADD     *HIVAL        MinBalance
 
     C                   Z-ADD     *ZERO         NoOfDays
     C                   Z-ADD     *ZERO         WeightedBalanc
     C                   MOVE      *Blank        FromDate
     C                   MOVE      *Blank        ToDate
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     NEW_DATE      BEGSR
 
      * Accumulate averages up to the new posting date
 
     C     PostingDate   SUB       CurrentDate   NoofDays
     C     CurrentBalanceMULT      NoOfDays      WeightedBalanc
 
      * FLAT
     C     CurrentBalanceIFEQ      0
     C                   ADD       NoofDays      FLNoofDays
     C                   ENDIF
 
      * DR
     C     CurrentBalanceIFGT      0
     C                   ADD       NoofDays      DRNoofDays
     C                   ADD       WeightedBalancDRWeightedBal
     C                   ENDIF
 
      * CR
     C     CurrentBalanceIFLT      0
     C                   ADD       NoofDays      CRNoofDays
     C                   ADD       WeightedBalancCRWeightedBal
     C                   ENDIF
 
      * Maximum balance
 
     C     CurrentBalanceIFGT      MaxBalance
     C                   Z-ADD     CurrentBalanceMaxBalance
     C                   ENDIF
 
      * Minimum balance
 
     C     CurrentBalanceIFLT      MinBalance
     C                   Z-ADD     CurrentBalanceMinBalance
     C                   ENDIF
 
     C     Audit         IFEQ      'Y'
 
     C                   Z-ADD     CurrentDate   ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        FromDate          7
 
     C                   Z-ADD     PostingDate   ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        ToDate            7
 
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     POSTING       BEGSR
 
      * Update balance with effect of posting
 
     C                   Z-ADD     PostingDate   CurrentDate
 
     C                   ADD       PostingAmount CurrentBalance
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     PERIOD_END    BEGSR
 
      * Accumulate averages up to the final date in the period
 
     C     FinalDate     SUB       CurrentDate   NoofDays
     C     CurrentBalanceMULT      NoOfDays      WeightedBalanc
 
      * FLAT
     C     CurrentBalanceIFEQ      0
     C                   ADD       NoofDays      FLNoofDays
     C                   ENDIF
 
      * DR
     C     CurrentBalanceIFGT      0
     C                   ADD       NoofDays      DRNoofDays
     C                   ADD       WeightedBalancDRWeightedBal
     C                   ENDIF
 
      * CR
     C     CurrentBalanceIFLT      0
     C                   ADD       NoofDays      CRNoofDays
     C                   ADD       WeightedBalancCRWeightedBal
     C                   ENDIF
 
      * Maximum balance
 
     C     CurrentBalanceIFGT      MaxBalance
     C                   Z-ADD     CurrentBalanceMaxBalance
     C                   ENDIF
 
      * Minimum balance
 
     C     CurrentBalanceIFLT      MinBalance
     C                   Z-ADD     CurrentBalanceMinBalance
     C                   ENDIF
 
      * NET Average Balance
 
     C     DRNoOfDays    ADD       CRNoOfDays    TotDays           4 0
     C     DRWeightedBal ADD       CRWeightedBal TotWBl           22 3
     C     TotDays       IFNE      0
     C     TotWBl        DIV(H)    TotDays       AvgeBal          18 3
     C                   EXSR      ADJUST_BAL
     C                   Z-ADD     AdjAvgeBal    NTAvgeBalance
     C                   ENDIF
 
      * DR Average Balance
 
     C     DRNoOfDays    IFNE      0
     C     DRWeightedBal DIV       DRNoOfDays    AvgeBal
     C                   EXSR      ADJUST_BAL
     C                   Z-ADD     AdjAvgeBal    DRAvgeBalance
     C                   ENDIF
 
      * CR Average Balance
 
     C     CRNoOfDays    IFNE      0
     C     CRWeightedBal DIV       CRNoOfDays    AvgeBal
     C                   EXSR      ADJUST_BAL
     C                   Z-ADD     AdjAvgeBal    CRAvgeBalance
     C                   ENDIF
 
     C     Audit         IFEQ      'Y'
 
     C                   Z-ADD     CurrentDate   ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        FromDate
 
     C                   Z-ADD     FinalDate     ZDAYNO
     C                   EXSR      ZDATE2
     C                   MOVEL     ZADATE        ToDate
 
     C                   ENDIF
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ZDATE2        BEGSR
     C                   CALL      'ZDATE2'
     C                   PARM                    ZDAYNO            5 0          Value date
     C                   PARM      'D'           ZDATFM            1            Date format ind
     C                   PARM      *zero         ZDATE             6 0          Value date
     C                   PARM      *blank        ZADATE            7            Run-date in DDM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ADJUST_BAL    BEGSR
 
      * Get Account Currency Details
     C                   CALL      'MR000101'
     C                   PARM      Currency      I#CCY             3
     C                   PARM                    SDCURR
     C                   Z-ADD     A6NBDP        AcctCDP           1 0
 
      * Adjust balance for account currency decimal places  (to round it)
 
     C                   EVAL      CA = AcctCDP + 1
     C     AvgeBal       MULT(H)   POWER(CA)     WorkBal          15 0
     C     WorkBal       DIV       POWER(CA)     AdjAvgeBal       18 3
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
 
     C                   Z-ADD     0             CA                1 0
 
     C                   ENDSR
     C**********************************************************************************
**  POWER8 - ARRAY OF POWERS FOR CURRENCY CONVERSION
00000001
00000010
00000100
00001000
00010000
00100000
01000000
10000000
