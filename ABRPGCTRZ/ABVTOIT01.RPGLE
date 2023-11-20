     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Total Interest')                *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVTOIT01 - Validate FUND Total Interest Amount              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD037749           Date 17Nov23               *
      *  Prev Amend No. MD058448           Date 14Jul21               *
      *                 MD058379           Date 12Jul21               *
      *                 CDL102             Date 01Jun21               *
      *                 CER050             Date 16Jun19               *
      *                 MD046248           Date 27Oct17               *
      *                 CGL165             Date 17Feb15               *
      *                 CDL096             Date 22Sep14               *
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
      *  MD037749 - Incorrect interest calculation                    *
      *  MD058448 - Total Interest is not zero when backward          *
      *             looking rate is entered                           *
      *  MD058379 - Serious midas error encountered in FUND. Correct  *
      *             the placement of reference rate field (Recompile) *
      *  CDL102 - LIBOR Deregulation - Dealing                        *
      *  CER050 - Annualised Percentage Rate (Recompile)              *
      *  MD046248 - Finastra Rebranding                               *
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
      **SRCNoDays*-*Calculate No.*of*interest*Days*********************                     MD037749
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

      ***SR/CNoDays*Work*Variables*                                                         MD037749
     D***WVLPNM*         S              5  0                                                MD037749
     D***WVWDAT*         S              5  0                                                MD037749
     D***WVMDNO*         S              5  0                                                MD037749
     D***WVP1***         S              5  0                                                MD037749
     D***WVP2***         S              5  0                                                MD037749
     D***WVP3***         S              5  0                                                MD037749
     D***WVWN5**         S              5  0                                                MD037749
     D***WVWN5A*         S              5  0                                                MD037749

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

      ** Input/Output fields for ZINTDY                                                     MD037749
     D PvBeg           S              5  0                                                  MD037749
     D PvEnd           S              5  0                                                  MD037749
     D PvCalc          S              1                                                     MD037749
     D PvInDy          S              5  0                                                  MD037749
     D PInt6Dy         S             15  9                                                  MD037749
     D PNLeap          S              5P 0 INZ(0)                                           MD037749
     D PLeap50         S              5P 0 INZ(0)                                           MD037749
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
                                                                                            MD000091
      **                                                                                    MD000091
     D BChar           DS                                                                   MD000091
     D   BLen                  1      2B 0                                                  MD000091
     D   LenStr                1      2                                                     MD000091
     D TranScnBlrt     DS                                                                   MD058448
     D  DDBLRT                        1A                                                    MD058448
     D  DDRFRR                       10A                                                    MD058448
     D  DDCALM                        4A                                                    MD058448
     D  DDBADJ                       13A                                                    MD058448
     D  DDFLOR                       13A                                                    MD058448
     D  DDLBDY                        2A                                                    MD058448
     D  DDLODY                        2A                                                    MD058448
     D  DDOPSH                        1A                                                    MD058448
     D  DDRRDP                        2A                                                    MD058448
     D  DDDBAV                        1A                                                    MD058448
     D  DDRTKN                        1A                                                    MD058448

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

     C                   IF        DDBLRT <> 'Y'                                            MD058448
     C                   EXSR      SRValTOTI
     C                   ENDIF                                                              MD058448

      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.

     C                   IF        OKTOTI = 'N'

     C                   EVAL      RetCodeIn = 'ERROR'

     C                   ELSE

     C                   IF        DDACTN = 'I'
      *                                                                                       CDL102
      ** For transactions using backward looking rate, the calculation of interest will be    CDL102
      ** zero during input because the base rate code is linked to a sero value.              CDL102
      *                                                                                       CDL102
     C**********         IF        N1BLRT = 'Y'                                      CDL102 MD058448
     C                   IF        DDBLRT = 'Y'                                             MD058448
     C                   EVAL      N1MTTI = *ZEROS                                            CDL102
     C                   EVAL      N2MTTI = *ZEROS                                            CDL102
     C                   ELSE                                                                 CDL102
     C                   EVAL      N1MTTI = WTotIntAmt
     C                   EVAL      N2MTTI = WTotIntAmt
     C                   ENDIF                                                                CDL102
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

     C                   IF        DDBLRT = 'Y'                                             MD058448
     C                   Z-ADD     *ZEROS        WAmountIn                                  MD058448
     C                   ELSE                                                               MD058448

     C                   Z-ADD     WTotIntAmt    WAmountIn
     C                   ENDIF                                                              MD058448
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

     C**********         EXSR      SRCNoDays                                                MD037749
     C                   CALLB     'ZINTDY'                                                 MD037749
     C                   PARM                    RetCodeIn                                  MD037749
     C                   PARM      *ZERO         PvInDy                                     MD037749
     C                   PARM      WVBEG         PvBeg                                      MD037749
     C                   PARM      WVEND         PvEnd                                      MD037749
     C                   PARM      WVCALC        PvCalc                                     MD037749
     C                   PARM      *ZERO         PInt6Dy                                    MD037749
     C                   PARM                    PNLeap                                     MD037749
     C                   PARM                    PLeap50                                    MD037749
     C                   Z-ADD     PvInDy        WVINDY                                     MD037749

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

     C                   IF        WVCALC = '6'                                             MD037749
     C     WVW155        MULT(H)   PINT6DY       WVINTR                                     MD037749
     C                   ELSE                                                               MD037749
     C     WVW155        MULT(H)   WVINDY        WVINTR
     C                   ENDIF                                                              MD037749

     C                   ENDSR

      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************                     MD037749
      ***SRCNoDays*-*Calculate*the*number*of*interest*days*************                     MD037749
      *****************************************************************                     MD037749
      ***Input**:*WVBEG**5,0***Start*date*of*period********************                     MD037749
      ************WVEND**5,0***End*date*of*period**********************                     MD037749
      ************WVCALC*1*****Interest*Calculation*method*************                     MD037749
      ***Output*:*WVINDY*5,0***Number*of*Interest*Days*****************                     MD037749
      *****************************************************************                     MD037749
      *****************************************************************
      *****************************************************************                     MD037749
     C*****SRCNoDays     BEGSR                                                              MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     *Zeros        WVINDY                                     MD037749
     C**********         Z-ADD     *Zeros        WVLPNM                                     MD037749
      **********                                                                            MD037749
      ***Actual*days*-*no*special*processing*                                               MD037749
      **********                                                                            MD037749
     C**********         IF        WVCALC = '1' OR                                          MD037749
     C**********                   WVCALC = '2' OR                                          MD037749
     C**********                   WVCALC = '6'                                             MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVINDY = WVEND - WVBEG                                   MD037749
     C**********         GOTO      SREXIT                                                   MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVWDAT = WVEND - WVBEG                                   MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     WVBEG         PDaynoIn                                   MD037749
     C**********         EXSR      SRZDate9                                                 MD037749
     C**********         MOVE      PDateOutZ9    DSBegDate                                  MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     WVEND         PDaynoIn                                   MD037749
     C**********         EXSR      SRZDate9                                                 MD037749
     C**********         MOVE      PDateOutZ9    DSEndDAte                                  MD037749
      **********                                                                            MD037749
      ***If*in*same*month*                                                                  MD037749
      **********                                                                            MD037749
     C**********         IF        WVYY1 = WVYY2                                            MD037749
      **********                                                                            MD037749
     C**********         IF        WVMM1 = WVMM2                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVINDY = WVDD2 - WVDD1                                   MD037749
     C**********         GOTO      SREXIT                                                   MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         IF        WVCALC = '3'                                             MD037749
      **********                                                                            MD037749
      ***Calculate*no.*of*days*in*first*month*                                              MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVP1 = 30 - WVDD1                                        MD037749
      **********                                                                            MD037749
      ***If*<*0,*initialise*to*0*                                                           MD037749
      **********                                                                            MD037749
     C**********         IF        WVP1 < 0                                                 MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     *Zeros        WVP1                                       MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***Calculate**no.*of*days*in*last*month*                                              MD037749
      **********                                                                            MD037749
     C**********         IF        WVDD2 <= 30                                              MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     WVDD2         WVP2                                       MD037749
      **********                                                                            MD037749
     C**********         ELSE                                                               MD037749
      **********                                                                            MD037749
     C**********         Z-ADD     30            WVP2                                       MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***Calculate*no.*of*days*in*intervening*months*                                       MD037749
      **********                                                                            MD037749
     C**********         IF        WVYY2 = WVYY1                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVP3 = WVMM2 - WVMM1                                     MD037749
     C**********         SUB       1             WVP3                                       MD037749
     C**********         MULT      30            WVP3                                       MD037749
      **********                                                                            MD037749
     C**********         ELSE                                                               MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVP3 = WVYY2 - WVYY1                                     MD037749
     C**********         SUB       1             WVP3                                       MD037749
     C**********         MULT      360           WVP3                                       MD037749
      **********                                                                            MD037749
      ***Find*no.*of months*for*the*two*partial years*                                      MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVWN5A = 12 - WVMM1                                      MD037749
     C**********         MULT      30            WVWN5A                                     MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVWN5 = WVMM2 - 1                                        MD037749
     C**********         EVAL      WVWN5 = WVWN5 * 30                                       MD037749
      **********                                                                            MD037749
      ***Accumulate*                                                                        MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVWN5A = WVWN5A + WVWN5                                  MD037749
     C**********         EVAL      WVP3 = WVP3 + WVWN5A                                     MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***Final*sum*                                                                         MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVINDY = WVP1 + WVP2                                     MD037749
     C**********         ADD       WVP3          WVINDY                                     MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***For*methods*4*and*5*                                                               MD037749
      **********                                                                            MD037749
     C**********         IF        WVCALC = '4' OR                                          MD037749
     C**********                   WVCALC = '5'                                             MD037749
      **********                                                                            MD037749
      ****Calculate*number*of*leap*years*between*start*and*end*dates*                       MD037749
      **********                                                                            MD037749
     C**********         IF        WVMM1 <= 2                                               MD037749
      **********                                                                            MD037749
     C*****WVYY1         DIV       4             WVWN5             5 0                      MD037749
     C**********         MVR                     WVWN5                    07                MD037749
      **********                                                                            MD037749
      ***Add*1*if*leap*year*                                                                MD037749
      **********                                                                            MD037749
     C**********         IF        ZeroIn = True                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVLPNM = 90 + 1                                          MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***Bypass*if*years*are*the*same*                                                      MD037749
      **********                                                                            MD037749
     C**********         IF        WVYY1 = WVYY2                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVINDY = WVWDAT - WVLPNM                                 MD037749
     C**********         GOTO      SREXIT                                                   MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
      ***Loop*to*calculate*no.*leap*years*                                                  MD037749
      **********                                                                            MD037749
     C**********         DOW       WVYY1 <> WVYY2                                           MD037749
      **********                                                                            MD037749
      ***Increment*start*year*                                                              MD037749
      **********                                                                            MD037749
     C**********         ADD       1             WVYY1                                      MD037749
      **********                                                                            MD037749
     C**********         IF        WVYY1 = WVYY2                                            MD037749
      **********                                                                            MD037749
     C**********         IF        WVMM2 > 2                                                MD037749
      **********                                                                            MD037749
     C*****WVYY2         DIV       4             WVWN5                                      MD037749
     C**********         MVR                     WVWN5                    07                MD037749
      **********                                                                            MD037749
      ***Increment*if*leap*year*                                                            MD037749
      **********                                                                            MD037749
     C**********         IF        ZeroIn = True                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVLPNM = 90 + 1                                          MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVINDY = WVWDAT - WVLPNM                                 MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         IF        WVYY1 <> WVYY2                                           MD037749
      **********                                                                            MD037749
     C*****WVYY1         DIV       4             WVWN5                                      MD037749
     C**********         MVR                     WVWN5                    07                MD037749
      **********                                                                            MD037749
      ***Add*1*if*leap*year*                                                                MD037749
      **********                                                                            MD037749
     C**********         IF        ZeroIn = True                                            MD037749
      **********                                                                            MD037749
     C**********         EVAL      WVLPNM = 90 + 1                                          MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C**********         ENDDO                                                              MD037749
      **********                                                                            MD037749
     C**********         ENDIF                                                              MD037749
      **********                                                                            MD037749
     C*****SREXIT        ENDSR                                                              MD037749

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
      ** FUND Backward-Looking Rate Screen Fields                                           MD058448
     C                   PARM                    TranScnBlrt                                MD058448

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
(c) Finastra International Limited 2001
