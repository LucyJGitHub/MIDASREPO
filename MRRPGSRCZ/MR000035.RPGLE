/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas MR Write Average Balances - FinancialMonthly')
     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2004')
      *****************************************************************
      *                                                               *
      *  Midas - MidasPlus Reporting Module                           *
      *                                                               *
      *  MR000035 -  Write Average Balances - Financial Monthly       *
      *                                                               *
      *  (c) Finastra International Limited 2004                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CMR001             Date 01Sep04               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CMR001 - MidasPlus Reporting                                 *
      *                                                               *
      *****************************************************************
 
     FMRHIBLL1  IP  AE           K DISK
     FMRPOSTXL2 IS  AE           K DISK
     FMRAVBLPD  O    E             DISK
     FMRAVBAPD  O    E             DISK    USROPN
 
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
 
     IMRHIBLD0      01
     I                                          BRCA          L1M7
     I                                          CNUM          L1M6
     I                                          CCY           L1M5
     I                                          ACOD          L1M4
     I                                          ACSQ          L1M3
     I                                          YR            L1M2
     I                                          PR            L1M1
     IMRPOSTD0      02
     I                                          BRCA          L1M7
     I                                          CNUM          L1M6
     I                                          CCY           L1M5
     I                                          ACOD          L1M4
     I                                          ACSQ          L1M3
     I              FY                          YR            L1M2
     I              FM                          PR            L1M1
 
 
     C   01              SETON                                        10
     C   01              EXSR      PERIOD_START
 
     C   02
     CAN MR              EXSR      POSTING
 
     CL1 10              EXSR      OUTPUT
     CL1 10              SETOFF                                       10
      /SPACE 5
     C**********************************************************************************
     C     PERIOD_START  BEGSR
     C                   MOVEL     'PeriodStart' ModeOfOp
     C                   Z-ADD     SPDAT         StrPeriodDat
     C                   Z-ADD     EPDAT         EndPeriodDat
     C                   Z-ADD     EPBLAC        EndPeriodBal
     C                   Z-ADD     DRMAAC        DRMoveInPeriod
     C                   Z-ADD     CRMAAC        CRMoveInPeriod
     C                   EXSR      ACCUM
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     POSTING       BEGSR
 
      * If a new posting date
 
     C     PSTD          IFNE      CurrentDate
     C                   MOVEL     'NewDate    ' ModeOfOp
     C                   Z-ADD     PSTD          PostingDate
     C                   EXSR      ACCUM
     C     Audit         IFEQ      'Y'
     C                   EXSR      WRITE_AUDIT
     C                   ENDIF
     C                   ENDIF
 
     C                   MOVEL     'Posting    ' ModeOfOp
     C                   Z-ADD     PSTD          PostingDate
     C                   Z-ADD     PSTAAC        PostingAmount
     C                   EXSR      ACCUM
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     OUTPUT        BEGSR
 
     C                   MOVEL     'PeriodEnd  ' ModeOfOp
     C                   EXSR      ACCUM
 
     C     Audit         IFEQ      'Y'
     C                   EXSR      WRITE_AUDIT
     C                   ENDIF
 
     C                   Z-ADD     StrPeriodDat  SPADAT
     C                   Z-ADD     EndPeriodDat  EPADAT
     C                   Z-ADD     NTAvgeBalance AVBLNT
     C                   Z-ADD     DRAvgeBalance AVBLDR
     C                   Z-ADD     CRAvgeBalance AVBLCR
     C                   Z-ADD     DRWeightedBal TWBLDR
     C                   Z-ADD     CRWeightedBal TWBLCR
     C                   Z-ADD     FLNoOfDays    NODYFL
     C                   Z-ADD     DRNoOfDays    NODYDR
     C                   Z-ADD     CRNoOfDays    NODYCR
     C                   Z-ADD     MaxBalance    MAXBAL
     C                   Z-ADD     MinBalance    MINBAL
     C                   WRITE     MRAVBLD0
 
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     ACCUM         BEGSR
     C                   CALLB     'MR000040'
 
     C                   PARM                    ModeOfOp         11
     C                   PARM                    Audit             1
      *INPUTS
     C                   PARM      CCY           Currency          3
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
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     WRITE_AUDIT   BEGSR
     C                   MOVEL     FromDate      FRDATE
     C                   MOVEL     ToDate        TODATE
     C                   Z-ADD     NoOfDays      NODYS
     C                   Z-ADD     CurrentBalanceBALANC
     C                   Z-ADD     WeightedBalancWEIBAL
     C                   WRITE     MRAVBAD0
     C                   ENDSR
     C**********************************************************************************
      /SPACE 5
     C**********************************************************************************
     C     *INZSR        BEGSR
     C     *ENTRY        PLIST
     C                   PARM                    I#CAFI            1
     C                   PARM                    Audit             1
 
     C                   MOVEL     I#CAFI        CAFI
     C                   MOVEL     'M'           PERTYP
 
     C     Audit         IFEQ      'Y'
     C                   OPEN      MRAVBAPD
     C                   ENDIF
 
     C                   ENDSR
     C**********************************************************************************
