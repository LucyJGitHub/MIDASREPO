     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Total Interest')                *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVTOIT01 - Validate FUND Total Interest Amount              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CGL165             Date 17Feb15               *
      *  Prev Amend No. CDL096             Date 22Sep14               *
      *                 MD026042           Date 28Mar14               *
      *                 MD000091           Date 09May13               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 04Jul06               *
      *                 CDL038             Date 10May05               *
      *                 CSD027             Date 09Dec05               *
      *                 CGL029             Date 01Sep03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP042  *CREATE    Date 08Jan01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  MD026042 - Serious Midas Error during insert of Internal     *
      *             Funding Deal.                                     *
      *           - When calculation basis is 0, the divisor is not   *
      *             setup causing a divide by zero error.             *
      *           - Also increase the attribute of WVERR to handle    *
      *             large amount.                                     *
      *  MD000091 - Event Codes Substitution                          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    06         ADD: Positive Indicator                         *
      *    07         MVR: Zero Indicator                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValTOTI - Validate Total Interest Amount                    *
      * SRCalcInt - Calculate Interest                                *
      * SRCNoDays - Calculate No. of interest Days                    *
      * SRZA0921  - Convert numeric amount to edited alpha            *
      * SRZA0840  - Validate field is numeric                         *
      * SRZDate9  - Convert Midas Day number to YYYYMMDD date format  *
      * *INZSR    - Initialise                                        *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
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
 
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
 
      /COPY ZACPYSRC,ERR_XARRYS
 
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
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** New Deal in Screen Format
     D NwDlScnFmt    E DS                  EXTNAME(ABFUNDPD)
     D                                     Prefix(DD:2)
 
      ** Internal funding deals error indicator file
     D OkFlags       E DS                  EXTNAME(ABEFUNDPD)
 
      ** New Deal in File Format of main deal
     D NwDlFilFmt1   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N1:2)
     D  N1DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N1MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N1DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N1MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N1RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N1PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N1INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** New Deal in File Format of associated deal
     D NwDlFilFmt2   E DS                  EXTNAME(MMVLDNIPD)
     D                                     Prefix(N2:2)
     D  N2DORIQQ     E                     EXTFLD(QQDORI)                                     CGL029
     D  N2MORIQQ     E                     EXTFLD(QQMORI)                                     CGL029
     D  N2DOPIQQ     E                     EXTFLD(QQDOPI)                                     CGL029
     D  N2MOPIQQ     E                     EXTFLD(QQMOPI)                                     CGL029
     D  N2RONSQQ     E                     EXTFLD(QQRONS)                                     CGL029
     D  N2PONSQQ     E                     EXTFLD(QQPONS)                                     CGL029
     D  N2INSAQQ     E                     EXTFLD(QQINSA)                                     CGL029
 
      ** YYYYMMDD date format of Begin Date
     D DSBegDate       DS
     D  WVYY1                  1      4  0
     D  WVMM1                  5      6  0
     D  WVDD1                  7      8  0
 
      ** YYYYMMDD date format of End Date
     D DSEndDate       DS
     D  WVYY2                  1      4  0
     D  WVMM2                  5      6  0
     D  WVDD2                  7      8  0
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  PositiveIn            06     06
     D  ZeroIn                07     07
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Work Variables
     D WTotIntAmt      S             15  0
     D WVDIF           S             15  0
 
      ** SR/CalcInt Work Variables
     D WVWDIV          S             15  5
     D WVYEAR          S              5  0
     D WVW155          S             15  5
     D WVAMTR          S             15  1
     D***WVERR           S             15  9                                                MD026042
     D WVERR           S             23  9                                                  MD026042
 
      ** SR/CNoDays Work Variables
     D WVLPNM          S              5  0
     D WVWDAT          S              5  0
     D WVMDNO          S              5  0
     D WVP1            S              5  0
     D WVP2            S              5  0
     D WVP3            S              5  0
     D WVWN5           S              5  0
     D WVWN5A          S              5  0
 
      ** Work Parameters
     D PValDate        S              5P 0
     D PMatDate        S              5P 0
     D PNtceDay        S              3  0
     D PDecPlace       S              1  0
 
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
     D BNDCSP          S              1A
 
      ** Parameters for ZDATE9
     D PDaynoIn        S              5P 0
     D PDateOutZ9      S              8S 0
     D PRetCodeZ9      S              1  0
 
      ** Parameters for ZA0921
      *(PRetCode)
     D WAmountIn       S             15  0
     D WDecPlcIn       S              1  0
      *(BNDCSP)
     D WAmountOS       S             16A
     D WAmountOU       S             17A
 
      ** Input/Output fields for SR/CalcInt
     D WVAMTW          S             15  0
     D WVCALC          S              1A
     D WVRATE          S             11  7
     D WVINTR          S             15  0
 
      ** Input/Output fields for SR/CNoDays
     D WVBEG           S              5  0
     D WVEND           S              5  0
      *(WVCALC)
     D WVINDY          S              5  0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
 
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
 
      ** Initialise work variables
 
     C                   EVAL      IDx = 0
     C                   EVAL      WTotIntAmt = 0
     C                   EVAL      WVDIF = 0
     C                   EVAL      POAmount = 0
     C                   EVAL      POErrCde = 0
 
     C                   EXSR      SRValTOTI
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKTOTI = 'N'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   IF        DDACTN = 'I'
     C                   EVAL      N1MTTI = WTotIntAmt
     C                   EVAL      N2MTTI = WTotIntAmt
     C                   ENDIF
 
     C                   ENDIF
 
      *                  ======
     C                   RETURN
      *                  ======
 
      *****************************************************************
      *  P R O G R A M   E N D                                        *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValTOTI - Validate Total Interest Amount                   *
      *                                                               *
      *****************************************************************
 
     C     SRValTOTI     BEGSR
 
      ** Check that the input amount is a valid number
 
     C                   IF        OKCCY <> 'N'
 
     C                   Z-ADD     PDecPlace     PIDP
     C     13            SUB       PIDP          PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDTOTI        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
 
     C                   EXSR      SRZA0840
 
     C                   IF        POErrCde <> 0
 
     C                   EVAL      OKTOTI = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1TOTI'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0452'
     C                   GOTO      EndValTOTI
 
     C                   ENDIF
 
     C                   ENDIF
 
      **  If the amount is a valid number, cross validate the actual
      **  amount (Only if all the fields used are valid)
 
     C                   IF        OKNTCE <> 'N' AND
     C                             OKVDAT <> 'N' AND
     C                             OKMDAT <> 'N' AND
     C                             OKCCY <> 'N' AND
     C                             OKAMNP <> 'N' AND
     C                             OKBRTT <> 'N' AND
     C                             OKRTSP <> 'N' AND
     C                             OKICBS <> 'N' AND
     C                             DDACTN = 'I'
 
      ** Begin date is value date
 
     C                   Z-ADD     PValDate      WVBEG
 
      ** Find End date for interest Calculation
 
     C                   IF        DDMDAT = *Blanks
 
     C                   IF        PNtceDay = *Zero
 
     C                   EVAL      WVEND = WVBEG + 1
 
     C                   ELSE
 
     C                   EVAL      WVEND = WVBEG + PNtceday
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   Z-ADD     PMatDate      WVEND
 
     C                   ENDIF
 
      ** Calculate Total Interest
 
     C                   Z-ADD     POAmount      WTotIntAmt
 
     C                   Z-ADD     N1AMNP        WVAMTW
     C                   Z-ADD     N1INTR        WVRATE
     C                   MOVE      N1ICMT        WVCALC
 
     C                   EXSR      SRCalcInt
 
      ** Default Total Interest to Calculated if blank
 
     C                   IF        DDTOTI = *Blanks
 
     C                   Z-ADD     WVINTR        WTotIntAmt
 
     C                   ENDIF
 
      ** Find the difference between the input and calculated interest.
      ** If the difference is greater than 1 currency unit, this is
      ** an error.
 
     C                   EVAL      WVDIF = WTotIntAmt - WVINTR
 
     C                   IF        WVDIF < 0
 
     C                   Z-SUB     WVDIF         WVDIF
 
     C                   ENDIF
 
      ** If there is a difference in the input and calculated interest
      ** amounts, format the calculated figure and output it in a message
 
     C                   IF        WVDIF > 0
 
     C                   Z-ADD     WVINTR        WAmountIn
     C                   Z-ADD     PDecPlace     WDecPlcIn
 
     C                   EXSR      SRZA0921
 
     C                   EVAL      OKTOTI = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1TOTI'
     C                   EVAL      MsgIdXAr(IDx) = 'ABM0453'
     C**********         EVAL      MsgDtaXAr(IDx) = WAmountOU                               MD000091
     C                   EVAL      BLen = %Len(%Trim(WAmountOU))                            MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(WAmountOU)                MD000091
     C                   GOTO      EndValTOTI
 
     C                   ENDIF
 
      ** If the amount is valid, set up the numeric amount on the
      ** Deal format
 
     C                   IF        DDACTN = 'I'
 
     C                   Z-ADD     WTotIntAmt    WAmountIn
     C                   Z-ADD     PDecPlace     WDecPlcIn
 
     C                   EXSR      SRZA0921
 
     C                   MOVE      WAmountOS     DDTOTI
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     EndValTOTI    ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCalcInt - Calculate Interest                               *
      *                                                               *
      *  Input  : WVAMTW 15,0  Principal Amount                       *
      *           WVCALC 1     Interest Calculation method            *
      *           WVRATE 11,7  Interest Rate                          *
      *  Output : WVINTR 15,0  Interest 15,0                          *
      *                                                               *
      *  Interest Calculation Methods :                               *
      *                                                               *
      *    1 - Actual Days / 365                                      *
      *    2 - Actual Days / 360                                      *
      *    3 - 360 Day Year (30 Day Month) / 360                      *
      *    4 - Actual Days (excluding Feb.29th) / 365                 *
      *    5 - Actual Days (excluding Feb.29th) / 360                 *
      *    6 - Actual Days / 366                                      *
      *                                                               *
      *****************************************************************
 
     C     SRCalcInt     BEGSR
 
     C                   EXSR      SRCNoDays
 
      ** Method 2 or 3 or 5
 
     C                   IF        WVCALC = '2' OR
     C                             WVCALC = '3' OR
     C                             WVCALC = '5'
 
     C                   EVAL      WVWDIV = WVAMTW / 36000
     C                   Z-ADD     36000         WVYEAR
 
     C                   ENDIF
 
      ** Method 1 or 4
 
     C                   IF        WVCALC = '1' OR
     C                             WVCALC = '4'
 
     C                   EVAL      WVWDIV = WVAMTW / 36500
     C                   Z-ADD     36500         WVYEAR
 
     C                   ENDIF
 
      ** Method 6
 
     C                   IF        WVCALC = '6'
     C                             OR WVCALC = '0'                                          MD026042
 
     C                   EVAL      WVWDIV = WVAMTW / 36600
     C                   Z-ADD     36600         WVYEAR
 
     C                   ENDIF
 
     C                   EVAL      WVW155 = WVWDIV * WVRATE
 
      **  Multiply WVWDIV BY WVYEAR to get original amount. The result
      **  could differ from the original due to rounding error on
      **  division.
 
     C                   EVAL      WVAMTR = WVWDIV * WVYEAR
 
      **  Calculate the error and do same arithmetical operations as on
      **  WVAMT above
 
     C                   EVAL      WVERR = WVAMTW - WVAMTR
     C                   MULT      WVRATE        WVERR
     C                   DIV       WVYEAR        WVERR
 
      **  Add result from error calculations back to the result from
      **  calculations on principal amount
 
     C                   ADD       WVERR         WVW155
 
      **  Multiply by the period to obtain the interest
 
     C     WVW155        MULT(H)   WVINDY        WVINTR
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCNoDays - Calculate the number of interest days            *
      *                                                               *
      *  Input  : WVBEG  5,0   Start date of period                   *
      *           WVEND  5,0   End date of period                     *
      *           WVCALC 1     Interest Calculation method            *
      *  Output : WVINDY 5,0   Number of Interest Days                *
      *                                                               *
      *****************************************************************
 
     C     SRCNoDays     BEGSR
 
     C                   Z-ADD     *Zeros        WVINDY
     C                   Z-ADD     *Zeros        WVLPNM
 
      ** Actual days - no special processing
 
     C                   IF        WVCALC = '1' OR
     C                             WVCALC = '2' OR
     C                             WVCALC = '6'
 
     C                   EVAL      WVINDY = WVEND - WVBEG
     C                   GOTO      SREXIT
 
     C                   ENDIF
 
     C                   EVAL      WVWDAT = WVEND - WVBEG
 
     C                   Z-ADD     WVBEG         PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSBegDate
 
     C                   Z-ADD     WVEND         PDaynoIn
     C                   EXSR      SRZDate9
     C                   MOVE      PDateOutZ9    DSEndDAte
 
      ** If in same month
 
     C                   IF        WVYY1 = WVYY2
 
     C                   IF        WVMM1 = WVMM2
 
     C                   EVAL      WVINDY = WVDD2 - WVDD1
     C                   GOTO      SREXIT
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        WVCALC = '3'
 
      ** Calculate no. of days in first month
 
     C                   EVAL      WVP1 = 30 - WVDD1
 
      ** If < 0, initialise to 0
 
     C                   IF        WVP1 < 0
 
     C                   Z-ADD     *Zeros        WVP1
 
     C                   ENDIF
 
      ** Calculate  no. of days in last month
 
     C                   IF        WVDD2 <= 30
 
     C                   Z-ADD     WVDD2         WVP2
 
     C                   ELSE
 
     C                   Z-ADD     30            WVP2
 
     C                   ENDIF
 
      ** Calculate no. of days in intervening months
 
     C                   IF        WVYY2 = WVYY1
 
     C                   EVAL      WVP3 = WVMM2 - WVMM1
     C                   SUB       1             WVP3
     C                   MULT      30            WVP3
 
     C                   ELSE
 
     C                   EVAL      WVP3 = WVYY2 - WVYY1
     C                   SUB       1             WVP3
     C                   MULT      360           WVP3
 
      ** Find no. of months for the two partial years
 
     C                   EVAL      WVWN5A = 12 - WVMM1
     C                   MULT      30            WVWN5A
 
     C                   EVAL      WVWN5 = WVMM2 - 1
     C                   EVAL      WVWN5 = WVWN5 * 30
 
      ** Accumulate
 
     C                   EVAL      WVWN5A = WVWN5A + WVWN5
     C                   EVAL      WVP3 = WVP3 + WVWN5A
 
     C                   ENDIF
 
      ** Final sum
 
     C                   EVAL      WVINDY = WVP1 + WVP2
     C                   ADD       WVP3          WVINDY
 
     C                   ENDIF
 
      ** For methods 4 and 5
 
     C                   IF        WVCALC = '4' OR
     C                             WVCALC = '5'
 
      **  Calculate number of leap years between start and end dates
 
     C                   IF        WVMM1 <= 2
 
     C     WVYY1         DIV       4             WVWN5             5 0
     C                   MVR                     WVWN5                    07
 
      ** Add 1 if leap year
 
     C                   IF        ZeroIn = True
 
     C                   EVAL      WVLPNM = 90 + 1
 
     C                   ENDIF
 
     C                   ENDIF
 
      ** Bypass if years are the same
 
     C                   IF        WVYY1 = WVYY2
 
     C                   EVAL      WVINDY = WVWDAT - WVLPNM
     C                   GOTO      SREXIT
 
     C                   ENDIF
 
      ** Loop to calculate no. leap years
 
     C                   DOW       WVYY1 <> WVYY2
 
      ** Increment start year
 
     C                   ADD       1             WVYY1
 
     C                   IF        WVYY1 = WVYY2
 
     C                   IF        WVMM2 > 2
 
     C     WVYY2         DIV       4             WVWN5
     C                   MVR                     WVWN5                    07
 
      ** Increment if leap year
 
     C                   IF        ZeroIn = True
 
     C                   EVAL      WVLPNM = 90 + 1
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   EVAL      WVINDY = WVWDAT - WVLPNM
 
     C                   ENDIF
 
     C                   IF        WVYY1 <> WVYY2
 
     C     WVYY1         DIV       4             WVWN5
     C                   MVR                     WVWN5                    07
 
      ** Add 1 if leap year
 
     C                   IF        ZeroIn = True
 
     C                   EVAL      WVLPNM = 90 + 1
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
 
     C                   ENDIF
 
     C     SREXIT        ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZA0921 - Convert numeric amount to edited alpha            *
      *                                                               *
      *****************************************************************
 
     C     SRZA0921      BEGSR
 
     C                   CALLB     'ZA0921'
     C                   PARM                    PRetCode
     C                   PARM                    WAmountIn
     C                   PARM                    WDecPlcIn
     C                   PARM                    BNDCSP
     C                   PARM                    WAmountOS
     C                   PARM                    WAmountOU
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZA0840 - Validate field is numeric                         *
      *                                                               *
      *****************************************************************
 
     C     SRZA0840      BEGSR
 
     C                   CALLB     'ZA0840'
     C                   PARM                    PRetCode
     C                   PARM                    PAlpha
     C                   PARM                    PIDP
     C                   PARM                    PIINT
     C                   PARM                    PIMTID
     C                   PARM                    POErrCde
     C                   PARM                    POAmount
     C                   PARM                    BNDCSP
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRZDate9 - Convert Midas Day number to YYYYMMDD date format  *
      *                                                               *
      *****************************************************************
 
     C     SRZDate9      BEGSR
 
     C                   CALLB     'ZDATE9'
     C                   PARM                    PDayNoIn
     C                   PARM      *ZERO         PDateOutZ9
     C                   PARM                    PRetCodeZ9
 
     C                   ENDSR
 
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
 
      ** INPUT
      ** =====
 
      ** Return Code
     C                   PARM                    RetCodeIn
 
      ** New Deal in Screen Format
     C                   PARM                    NwDlScnFmt
 
      ** Value Date in Midas Day no. format
     C                   PARM                    PValDate
 
      ** Maturity Date in Midas Day no. format
     C                   PARM                    PMatDate
 
      ** Notice Days
     C                   PARM                    PNtceDay
 
      ** Decimal Place
     C                   PARM                    PDecPlace
 
      ** Standing Data
      ** =============
 
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAr
     C                   PARM                    MsgDtaXAr
 
      ** Internal funding deals error indicator file
     C                   PARM                    OkFlags
 
      ** New Deal in File Format of main deal
     C                   PARM                    NwDlFilFmt1
 
      ** New Deal in File Format of associated deal
     C                   PARM                    NwDlFilFmt2
 
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
