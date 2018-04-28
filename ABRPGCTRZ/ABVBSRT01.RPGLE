     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas AB Validate FUND Base Currency Rate')            *
      *****************************************************************
      *                                                               *
      *  Midas - Internal Funding Module                              *
      *                                                               *
      *  ABVBSRT01 - Validate FUND Base Currency Rate                 *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. MD000091           Date 09May13               *
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
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
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
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRValBCXR - Validate Base Currency Rate                       *
      * SRZA0921  - Convert numeric amount to edited alpha            *
      * SRZA0840  - Validate field is numeric                         *
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
 
      ** Scaling Factor
     D ArrSF           S             10  0 DIM(10) CTDATA PERRCD(1)
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  PositiveIn            06     06
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
 
      ** Work Variables
     D WBCcyRate       S             13P 8
     D WScaleRate      S             13P 8
     D WAmount         S             15  0
     D WX1             S              2  0
     D WVBCXR          S             13P 8
     D WVLLimit        S             15  0
     D WVULimit        S             15  0
 
      ** Work Parameters
     D PSpotRate       S             13P 8
     D PDecPlace       S              1  0
     D PMulDivIn       S              1A
     D PScaleExp       S              1  0
     D BJCYCD          S              3A
 
      ** Parameters for ZA0840
     D PRetCode        S                   LIKE(ReturnCode)
     D PAlpha          S             16A
     D PIDP            S              3  0
     D PIINT           S              3  0
     D PIMTID          S              1A
     D POErrCde        S              1  0
     D POAmount        S             15  0
     D BNDCSP          S              1A
 
      ** Parameters for ZA0921
      *(PRetCode)
     D WAmountIn       S             15  0
     D WDecPlcIn       S              1  0
      *(BNDCSP)
     D WAmountOS       S             16A
     D WAmountOU       S             17A
 
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
     C                   EVAL      WBCcyRate = 0
     C                   EVAL      WScaleRate = 0
     C                   EVAL      WAmount = 0
     C                   EVAL      WX1 = 0
     C                   EVAL      WVBCXR = 0
     C                   EVAL      WVLLimit = 0
     C                   EVAL      WVULimit = 0
     C                   EVAL      POAmount = 0
     C                   EVAL      POErrCde = 0
 
     C                   EXSR      SRValBCXR
 
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
 
     C                   IF        OKBCXR <> 'Y'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C                   EVAL      N1BRAT = WBCcyRate
     C                   EVAL      N1MMDI = PMulDivIn
 
     C                   EVAL      N2BRAT = WBCcyRate
     C                   EVAL      N2MMDI = PMulDivIn
 
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
      *  SRValBCXR - Validate Base Currency Rate                      *
      *                                                               *
      *****************************************************************
 
     C     SRValBCXR     BEGSR
 
      ** Scale the rate for display
 
     C                   EVAL      WX1 = PScaleExp + 1
 
      ** Default screen rate to the rate held on the currency file
      ** for the deal currency
 
     C                   EVAL      WScaleRate = PSpotRate * ArrSF(WX1)
     C                   EVAL      WAmount = PSpotRate * ArrSF(WX1)
 
      ** If the work fields are greater than 9999.99999999, set to
      ** 9999.99999999
 
     C                   IF        WAmount >= 10000
 
     C                   EVAL      WScaleRate = 10000 - .00000001
 
     C                   ENDIF
 
     C                   EVAL      WAmount = WScaleRate * 100000000
 
     C                   Z-ADD     8             WDecPlcIn
 
      ** If Rate entered override and check against the Spot Rate
      ** of the dealt currency
 
     C                   IF        DDBCXR <> *Blanks
 
      ** Check entry is a valid figure with 8 decimal places max
 
     C                   Z-ADD     WDecPlcIn     PIDP
     C                   Z-ADD     4             PIINT
     C                   MOVE      *Blanks       PAlpha
     C                   MOVE      DDBCXR        PAlpha
     C                   Z-ADD     *Zero         POAmount
     C                   MOVE      'N'           PIMTID
     C                   EXSR      SRZA0840
 
      ** Check field size
 
     C                   MOVE      POAmount      WVBCXR
     C                   Z-ADD     *Zero         WVLLimit
     C                   MOVE      WVBCXR        WVLLimit
 
     C                   IF        POErrCde <> 0 OR
     C                             POAmount <> WVLLimit
 
     C                   EVAL      OKBCXR = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BCXR'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0413'
     C                   GOTO      EndValBCXR
 
     C                   ENDIF
 
      ** Calculate the upper and lower limits for the exchange rate
 
     C     WAmount       MULT(H)   .8            WVLLimit
     C     WAmount       MULT(H)   1.2           WVULimit
 
      ** If Deal currency equals the base currency and the base currency
      ** rate is not equal to spot rate, this is an error
 
     C                   IF        DDCCY = BJCYCD AND
     C                             POAmount <> WAmount
 
     C                   EVAL      OKBCXR = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BCXR'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0412'
     C                   GOTO      EndValBCXR
 
     C                   ENDIF
 
      ** If the upper rate is less than the lower limit, or greater than
      ** the upper limit, this is an error.
      ** If there is a difference in the input and calculated interest
      ** amounts, output it in a message.
 
     C                   IF        POAmount < WVLLimit OR
     C                             POAmount > WVULimit
 
     C                   Z-ADD     WAmount       WAmountIn
     C                   EXSR      SRZA0921
 
     C                   EVAL      OKBCXR = 'N'
     C                   EVAL      IDx = IDx + 1
     C                   EVAL      FldNamXAr(IDx)= '#1BCXR'
     C                   EVAL      MsgIdXAr(IDx) = 'MMM0414'
     C**********         EVAL      MsgDtaXAr(IDx) = WAmountOU                               MD000091
     C                   EVAL      BLen = %Len(%Trim(WAmountOU))                            MD000091
     C                   EVAL      MsgDtaXAr(IDx) = LenStr +%TRIM(WAmountOU)                MD000091
     C                   GOTO      EndValBCXR
 
     C                   ELSE
 
     C                   Z-ADD     POAmount      WAmountIn
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   EVAL      WAmountIn = WAmount
 
     C                   ENDIF
 
      ** Format amount for output to screen
 
     C                   EXSR      SRZA0921
 
     C                   MOVE      WAmountOU     DDBCXR
     C                   MOVE      WAmountIn     WScaleRate
     C                   EVAL      WBCcyRate = WScaleRate / ArrSF(WX1)
 
     C     EndValBCXR    ENDSR
 
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
 
      ** Standing Data
      ** =============
      ** SDBANK: Currency Code
     C                   PARM                    BJCYCD
      ** SDDEAL: Decimal Separator
     C                   PARM                    BNDCSP
 
      ** Deal Currency Details
     C                   PARM                    PSpotRate
     C                   PARM                    PDecPlace
     C                   PARM                    PMulDivIn
     C                   PARM                    PScaleExp
 
      ** OUTPUT
      ** ======
 
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIdXAR
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
**  ArrSF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
