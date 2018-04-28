     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas ZA Determine Deal Amendment Settle Interest')    *
      *****************************************************************
      *                                                               *
      *  Midas - Standard Subroutines                                 *
      *                                                               *
      *  ZADEAMSINT - DETERMINE DEAL AMENDMENT SETTLE INTEREST        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CDL094             Date 11Jun14               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CDL028             Date 07Feb05               *
      *                 CDL022             Date 03Feb04               *
      *                 CDL020             Date 03Feb04               *
      *                 CDL017             Date 03Feb04               *
      *                 CAP076             Date 03Jun02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01Nov97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CDL094 - Enhance  Receive Settlement Instructions            *
      *           (Recompiled)                                        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CDL028 - Automatic Rate Interpolations (Recompile)           *
      *  CDL022 - Deal Amendment Changes (Recompile)                  *
      *  CDL020 - Apply Base Rate at Value Date (Recompile)           *
      *  CDL017 - Penalty Fee & Early Maturity of Fixed Term Loan/Dep *
      *           (Recompile)                                         *
      *  CAP076 - Lending API enhancements - Rollover details         *
      *           Recompile due to change in MM1030                   *
      *           (new parameter to ZINTDY)                           *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
     FMMDEAMLL  IF   E           K DISK
     FDEALS     IF   E           K DISK
     F                                     INCLUDE(DEALSDCF: DEALSDDF)
 
      ** DEFINE FIELDS FOR ZDATE9 & ZDATE10
     D @DAYN           S              5P 0
     D @YMD            S              8S 0
     D @RETN           S              1A
 
      * YEAR/MONTH/DAY
     D                 DS
     D  W#VYMD                 1      8  0
     D  W#VDYY                 1      4  0
     D  W#VDMM                 5      6  0
     D  W#VDDD                 7      8  0
     D                 DS
     D  @HNVDY                 1      8  0
     D  HNVDYY                 1      4  0
     D  HNVDMM                 5      6  0
     D  HNVDDD                 7      8  0
      /EJECT
     C*****************************************************************
      *
      ** INITIALIZE WORK FIELDS
      *
     C     ##AMT         IFLT      *ZERO
     C                   Z-SUB     ##AMT         W#AMT            13 0
     C                   ELSE
     C                   Z-ADD     ##AMT         W#AMT
     C                   END
     C                   Z-ADD     ##INTR        W#INTR           11 7
     C                   MOVEL     ##CALC        W#CALC            1
     C                   MOVEL     ##RDFC        W#RDFC            1
      *
      ** INITIALIZE OUTPUT
      *
     C                   Z-ADD     *ZERO         ##SINT
      *
      ** ACCESS RELATED DEAL INFORMATION
      *
     C                   EXSR      ACDEAL
      *
      ** CALCULATE DEAL AMENDMENT SETTLEMENT INTEREST
      *
     C                   EXSR      DEMSEI
      *
      ** SIGN SETTLEMENT INTEREST ACCORDING TO RELATED DEAL TYPE
      *
     C     ##MTYP        IFEQ      'IT'
     C     ##MTYP        OREQ      'TD'
     C     ##MTYP        OREQ      'CI'
     C     ##MTYP        OREQ      'CD'
     C                   Z-SUB     ##SINT        ##SINT
     C                   ELSE
     C                   Z-ADD     ##SINT        ##SINT
     C                   END
      *
      * RETURN
      *
     C                   RETURN
     C*****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* DEMSEI - CALCULATE DEAL AMENDMENT SETTLEMENT INTEREST         *
     C*                                                               *
     C*****************************************************************
     C     DEMSEI        BEGSR
      *
      * Look for deal amendments against deal
      *
     C     DEAMK         SETLL     MMDEAMLL
     C     DEAMKP        READE     MMDEAMLL                               99
      *
      * CONVERT VALUE DATE OF AMENDMENT IN Y/M/D TO MIDAS DAY NUMBER
      *
     C     *IN99         IFNE      '1'
     C                   CALLB     'ZDATE10'
     C                   PARM      @HNVDY        @YMD
     C                   PARM      *ZERO         @DAYN
     C                   Z-ADD     @DAYN         W#VDAM            5 0
     C                   END
      *
      * WHILST A DEAL AMENDMENT CAN BE FOUND,
      * APPLY THE CHANGES
      *
     C     *IN99         DOWNE     '1'
     C     W#VDAM        ANDLT     ##VDAT
      *
      * CALCULATE THE INTEREST BETWEEN THE CONTROL DATE AND
      * THE VALUE DATE OF THE DEAL AMENDMENT OFF THE FILE
      *
     C     HNDDLT        IFNE      'D'
      *
      * START DATE = INT ACCRUAL DATE, END DATE = VALUE DATE OF AMEND
      *
     C                   Z-ADD     W#IACD        @@BEG
     C                   Z-ADD     W#VDAM        @@END
      *
      * PRINCIPAL, RATE, CALCULATION METHOD, ROUND DOWN INTEREST
      *
     C                   Z-ADD     W#AMT         @@AMT
     C                   Z-ADD     W#INTR        @@RATE
     C                   MOVEL     W#CALC        @@CALC
     C                   MOVEL     W#RDFC        @@RDFC
     C                   EXSR      CALPIN
     C                   ADD       @@INTR        W#AITC
     C                   Z-ADD     W#VDAM        W#IACD
      *
      * DEAL AMENDMENT AMOUNT IS SIGNED -VE FOR PAY, +VE FOR RECEIVE
      *
     C     HNAMNP        IFLT      *ZEROS
     C                   Z-SUB     HNAMNP        HNAMNP
     C                   END
      *
      * IF THE DEAL AMENDMENT IS A RATE CHANGE,
      * CHANGE THE RATE USED
      *
     C     HNMTYP        IFEQ      'SC'
     C                   Z-ADD     HNINTR        W#INTR
     C                   END
      *
      * IF THE DEAL AMENDMENT IS A SETTLE INTEREST,
      * UPDATE INTEREST PAID/RECD TODAY FIELD
      *
     C     HNMTYP        IFEQ      'SI'
     C                   ADD       HNAMNP        W#IPRD
     C                   END
      *
      * IF THE DEAL AMENDMENT IS A PRINCIPAL INCREASE,
      * UPDATE AMOUNT
      *
     C     HNMTYP        IFEQ      'PI'
     C                   ADD       HNAMNP        W#AMT
     C                   END
      *
      * IF THE DEAL AMENDMENT IS A PRINCIPAL DECREASE,
      * UPDATE AMOUNT
      *
     C     HNMTYP        IFEQ      'PD'
     C                   SUB       HNAMNP        W#AMT
     C                   END
      *
      * IF THE DEAL AMENDMENT IS A CAPITALISED INTEREST,
      * UPDATE AMOUNT AND INT CAPITALISED TO DATE FIELDS
      *
     C     HNMTYP        IFEQ      'CI'
     C                   ADD       HNAMNP        W#ICTD
     C                   ADD       HNAMNP        W#AMT
     C                   END
     C                   END
      *
      * READ NEXT RECORD OFF FILE
      *
     C     DEAMKP        READE     MMDEAMLL                               99
      *
      * CONVERT VALUE DATE OF AMENDMENT IN Y/M/D TO MIDAS DAY NUMBER
      *
     C     *IN99         IFNE      '1'
     C                   CALLB     'ZDATE10'
     C                   PARM      @HNVDY        @YMD
     C                   PARM      *ZERO         @DAYN
     C                   Z-ADD     @DAYN         W#VDAM            5 0
     C                   END
      *
     C                   END
      *
      * IF STILL HAVE NOT COVERED ALL THE PERIOD BETWEEN
      * INITIAL CONTROL DATE AND VALUE DATE OF THE DEAL
      * AMENDMENT, CALCULATE INTEREST ACCRUED DURING
      * THE REMAINING PERIOD
      *
     C     W#IACD        IFLT      ##VDAT
     C                   Z-ADD     W#IACD        @@BEG
     C                   Z-ADD     ##VDAT        @@END
     C                   Z-ADD     W#AMT         @@AMT
     C                   Z-ADD     W#INTR        @@RATE
     C                   MOVEL     W#CALC        @@CALC
     C                   MOVEL     W#RDFC        @@RDFC
     C                   EXSR      CALPIN
     C                   ADD       @@INTR        W#AITC
     C                   Z-ADD     ##VDAT        W#IACD
     C                   END
      *
      * THE FINAL INTEREST AMOUNT IS THE AMOUNT ACCRUED SO FAR
      * MINUS INTEREST PAID/RECD AND INTEREST CAPITALISED TO DATE
      *
     C                   Z-ADD     W#AITC        ##SINT
     C                   SUB       W#IPRD        ##SINT
     C                   SUB       W#ICTD        ##SINT
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* CALPIN - CALCULATE PARTIAL INTEREST                          *
     C*                                                              *
     C****************************************************************
     C     CALPIN        BEGSR
      *
     C                   CALLB     'MM1030'
     C                   PARM                    @@BEG             5 0
     C                   PARM                    @@END             5 0
     C                   PARM                    @@CALC            1
     C                   PARM                    @@AMT            15 0
     C                   PARM                    @@RATE           11 7
     C                   PARM                    @@RDFC            1
     C                   PARM      *ZERO         @@INTR           15 0
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* ACDEAL - ACCESS RELATED DEAL INFORMATION                      *
     C*                                                               *
     C*****************************************************************
     C     ACDEAL        BEGSR
      *
      * ACCESS RELATED DEAL FOR ACCRUED TO DATE INFORMATION
      *
     C     ##DA38        CHAIN     DEALS                              99
      *
      ** IF DEAL NOT FOUND (AS DEAL NOT YET AUTHORIZED)
      *
     C     *IN99         IFEQ      '1'
      *
     C                   Z-ADD     ##RVDY        @YMD
     C                   CALLB     'ZDATE10'
     C                   PARM                    @YMD
     C                   PARM      *ZERO         @DAYN
     C                   Z-ADD     @DAYN         W#IACD
      *
     C                   Z-ADD     *ZERO         W#AITC
     C                   Z-ADD     *ZERO         W#IPRD
     C                   Z-ADD     *ZERO         W#ICTD
     C                   ELSE
     C                   Z-ADD     IACD          W#IACD            5 0
     C     AITC          ADD       AIAN          W#AITC           13 0
     C                   ADD       AIAP          W#AITC
     C                   Z-ADD     IPRD          W#IPRD           13 0
     C                   Z-ADD     ICTD          W#ICTD           13 0
     C                   END
      *
      *  CHANGE ACCRUAL CONTROL DATE TO YYYYMMDD
      *
     C                   Z-ADD     W#IACD        @DAYN
     C                   CALLB     'ZDATE9'
     C                   PARM                    @DAYN
     C                   PARM                    @YMD
     C                   PARM                    @RETN
     C                   Z-ADD     @YMD          W#VYMD
      *
     C                   ENDSR
     C*****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** PARAMETERS
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      *
      ** Deal number
     C                   PARM                    ##DA38            6 0
      *
      ** Value date of deal amendment - Midas day number
     C                   PARM                    ##VDAT            5 0
      *
      ** Deal type of related deal
     C                   PARM                    ##MTYP            2
      *
      ** Value date of related deal - YYYYMMDD
     C                   PARM                    ##RVDY            8 0
      *
      ** Principal of related deal
     C                   PARM                    ##AMT            15 0
      *
      ** Interest rate of related deal
     C                   PARM                    ##INTR           11 7
      *
      ** Calculation method of related deal
     C                   PARM                    ##CALC            1
      *
      ** Round down interest indicator of related deal
     C                   PARM                    ##RDFC            1
      *
      ** OUTPUT
      *
      ** Settle Interest
     C                   PARM                    ##SINT           13 0
      *
      * KEY LISTS
      *
     C     DEAMK         KLIST
     C                   KFLD                    ##DA38
     C                   KFLD                    W#VDYY
     C                   KFLD                    W#VDMM
     C                   KFLD                    W#VDDD
      *
     C     DEAMKP        KLIST
     C                   KFLD                    ##DA38
      *
     C                   ENDSR
      *****************************************************************
