     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validation of OTC spot price')                *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVOTCSPT - Validate OTC Spot Price                          *
      *                                                               *
      *  Function:  This module confirms that the spot Price          *
      *             entered for an FF trade is a legitimate value.    *
      *             For FX Future, if Spot Price not enter, it will   *
      *             try to work out the default value from Spot Rate  *
      *             table.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 246527             Date 19Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245129             Date 22Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 193759             Date 25Jun01               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196780             Date 28Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002  *CREATE    Date 08Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246527 - Correct Premium calculation. Review 245129.         *
      *  245129 - Contract price can only accommodate up to 6 decimal *
      *           places. Amend module and change default of field    *
      *           Minimun Price Flactuation (WMNPF) to '0.00000001'   *
      *           if processing type is '5'.  Apply fix 231795.       *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  193759 - Fixed to display correct error message for Spot     *
      *           Price field.                                        *
      *  196780 - Do not condition on the End of Transition date.     *
      *  CPL002 - Midas-Plato Interface                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and #MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      **--------------------------------------------------------------------------------------------
 
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
 
     D InstTypes     E DS                  EXTNAME(INTYPD)
      ** Instrument types
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for CURRENCY Details
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
 
 
      ** +--- Named indicators -------------------------------------------+
      ** ¦                                                                ¦
      ** ¦ Map variable names to indicators to allow use of names instead ¦
      ** ¦ of numbers; base the following data structure on a pointer to  ¦
      ** ¦ the indicator array.                                           ¦
     D Indicators      DS                  BASED(pIndicator)
      ** ¦                                                                ¦
     D  NoRecFound            99     99
      ** ¦                                                                ¦
      ** ¦                                                                ¦
      ** ¦ Set the indicator array pointer                                ¦
     D pIndicator      S               *   INZ(%Addr(*In))
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** --- Start of parameters not declared elsewhere --------------------------------------------
 
      ** SPot Price
     D SSPTP           S             16A
 
      ** Ticks denominator
     D FFTKDM          S              3P 0
 
      ** Minimum price fluctuation
     D FFMNPF          S             15P 8
 
      ** Strike price in file format
     D WSTRP           S             15P 8
 
      ** Counter amount
     D WCCAM           S             13P 0
 
      ** Delivery amount
     D WCTAM           S                   LIKE(WCCAM)
 
      ** Delivery Currency Code
     D SDCCY           S              3A
 
      ** Counter Currency Code
     D SCTCY           S              3A
 
      ** Euro Currency Code
     D EUCCY           S              3A
 
      ** Transaction Value Date
     D TvDate          S              5S 0
 
      ** --- End of parameters not declared elsewhere ----------------------------------------------
 
      ** Work version of Spot price in file format
     D WSPTP           S             15P 8
 
      ** Multiply and Divide Indicator for Strike price
     D SMDInd          S              1A
 
      ** Multiply and Divide Indicator for Delivery Currency
     D DMDInd          S              1A
 
      ** Multiply and Divide Indicator for Counter Currency
     D CMDInd          S              1A
 
      ** Multiply and Divide Indicator for Euro
     D EMDInd          S              1A
 
      ** In Currency Indicator for Delivery Currency
     D DI_Ind          S              1A
 
      ** In Currency Indicator for Counter Currency
     D CI_Ind          S              1A
 
      ** Counter currency decimal places
     D CCDP            S              1S 0
 
      ** Delivery currency decimal places
     D DCDP            S                   LIKE(CCDP)
 
      ** Spot Rate for Delivery Currency
     D DsRate          S             15S 8
 
      ** Spot Rate for Counter Currency
     D CsRate          S                   LIKE(DsRate)
 
      ** Spot Rate for Euro
     D EsRate          S                   LIKE(DsRate)
 
     ** --- Fields for ZAMCON procedure ------------------------------------------------------------
     D ZAMFR           S             15P 0
     D ZEXR            S             15P 9
 
      ** Output (converted) amount
     D ZAMTO           S             20P 5
     ** --- End of fields for ZAMCON procedure -----------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
     C     Start         TAG
      ** Note: the above tag is only there to force the first comments in
      ** the C-specs to appear after the D- or I-specs in compiled listings.
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *inzsr is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Reset error fields
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line resets the fields related to error
      ** handling: ReturnCode, ErrorFound, FldNamXArr, MsgIDXArr,
      ** MsgDtaXArr, XIdx.  It therefore requires FVAL_ARRAY and STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      **   'Futures' (Instr. Process Type = 1,2,3,7) - must be blank      AUS022
 
     C     ISPT          IFLE      3
     C     ISPT          OREQ      7                                                           AUS02
 
     C     SSPTP         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSPTP'
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA1000'                                193759
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1240'                                193759
 
     C                   ENDIF
 
     C                   ELSE
 
      ** Set the ticks denominator and minimum price fluctuation.
     C                   EXSR      SetTick
      *
      ** Set up Default if Spot Price is not enter for Process Type 5
      *
     C     ISPT          IFEQ      5
     C     SSPTP         ANDEQ     *BLANKS
     C                   EXSR      SetDft
     C                   ENDIF
 
      **   'Options' (Instr. Process Type = 4,5,6) - must be entered
 
     C     SSPTP         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSPTP'
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA1001'                                193759
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1241'                                193759
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRVL'
      ** Parameters returned from called procedure
      ** -----------------------------------------
     C                   PARM                    ReturnCode
      ** File version of price (15,8P)
     C                   PARM                    WSPTP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** Screen version of price (16A)
     C                   PARM                    SSPTP
      ** Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minmum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
      **   - invalid format
     C                   IF        ReturnCode = 'Error'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSPTP'
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA1002'                                193759
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1242'                                193759
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
      **   - cannot be zero
     C     WSPTP         IFEQ      0
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSPTP'
     C**********         EVAL      MsgIDXArr(XIdx) = 'MMA1003'                                193759
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA1243'                                193759
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
      **   - format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    SSPTP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
     C                   PARM                    WSPTP
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   END
 
     C     VSPEND        TAG
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetTick - Set ticks denominator and minimu price fluctuation  *
      *                                                               *
      *****************************************************************
 
     C     SetTick       BEGSR
 
      ** For OTC, if the fields from INTYPD are not set up,
      ** use default values.
 
     C                   IF        TKDM = 0
     C                   EVAL      TKDM = 100
     C                   ENDIF
 
     C**********         IF        MNPF = 0                                                   245129
     C                   IF        MNPF = 0                                                   246527
     C     MNPF          IFEQ      0                                                          245129
     C     ISPT          ANDNE     5                                                          245129
     C                   EVAL      MNPF = 0.000001
     C                   ELSE                                                                 245129
     C                   EVAL      MNPF = 0.00000001                                          245129
     C                   ENDIF
     C                   ENDIF                                                                246527
 
     C                   EVAL      FFTKDM = TKDM
     C                   EVAL      FFMNPF = MNPF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetDft - Set default value for Spot Price                     *
      *                                                               *
      *****************************************************************
 
     C     SetDft        BEGSR
 
      ** Get Spot Rate for Delivery Currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SDCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SDCCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0390'
 
     C                   ELSE
 
      ** Setup Spot Rate information for Deliver Currency
     C                   IF        TvDate >=  A6TPSD
     C**********                   AND TvDate <= A6TPED                         196780
     C                             AND A6INCY = 'Y'
     C                             AND SDCCY <> EUCCY
 
     C                   EVAL      DsRate = A6EUER
     C                   EVAL      DMDInd = A6EUMD
     C                   EVAL      DI_Ind = 'Y'
 
     C                   ELSE
 
     C                   EVAL      DsRate = A6SPRT
     C                   EVAL      DMDInd = A6MDIN
     C                   EVAL      DI_Ind = 'N'
 
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        DCDP
     C                   END
 
      ** Get Spot Rate for Counter Currency
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SCTCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SCTCY'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0390'
 
     C                   ELSE
 
      ** Setup Spot Rate information for Counter Currency
     C                   IF        TvDate >=  A6TPSD
     C**********                   AND TvDate <= A6TPED                         196780
     C                             AND A6INCY = 'Y'
     C                             AND SCTCY <> EUCCY
 
     C                   EVAL      CsRate = A6EUER
     C                   EVAL      CMDInd = A6EUMD
     C                   EVAL      CI_Ind = 'Y'
 
     C                   ELSE
 
     C                   EVAL      CsRate = A6SPRT
     C                   EVAL      CMDInd = A6MDIN
     C                   EVAL      CI_Ind = 'N'
 
     C                   ENDIF
 
     C                   Z-ADD     A6NBDP        CCDP
     C                   END
 
      ** If one of the Currency is IN currency for Euro,
      ** Then get Spot Rate for Euro.
 
     C                   IF        CI_Ind = 'Y' OR DI_Ind = 'Y'
 
     C                   CALLB     'AOCURRR0'
     C                   PARM      '*MSG   '     @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      EUCCY         @AJCD             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RTCD         IFNE      *BLANK
 
     C                   EVAL      EsRate = 0
     C                   EVAL      EMDInd = 'M'
 
     C                   ELSE
 
      ** Setup Spot Rate information for Euro
 
     C                   EVAL      EsRate = A6SPRT
     C                   EVAL      EMDInd = A6MDIN
 
     C                   ENDIF
     C                   END                                                                   07371
 
      ** Get the Mutliply and Divide Indicator from the Strike Price
 
     C                   Z-ADD     WCTAM         ZAMFR                                         07371
     C                   Z-ADD     WSTRP         ZEXR                                          07371
 
     C                   CALLB     'FFZAMCON'                                                  07371
     C                   PARM                    ZAMTO                                         07371
     C                   PARM                    ZAMFR                                         07371
     C                   PARM                    ZEXR                                          07371
     C                   PARM                    DCDP                                          07371
     C                   PARM                    CCDP                                          07371
 
     C     ZAMTO         ADD       1             ZAMTA1           20 5                         07371
     C     ZAMTO         SUB       1             ZAMTS1           20 5                         07371
 
     C     WCCAM         IFGT      ZAMTA1                                                      07371
     C     WCCAM         ORLT      ZAMTS1                                                      07371
 
     C                   EVAL      SMDInd = 'D'                                                07371
 
     C                   ELSE                                                                  07371
 
     C                   EVAL      SMDInd = 'M'
 
     C                   END                                                                   07371
      *
      ** If no error found the calculate cross rate
      *
     C                   IF        ErrorFound <> 'Y'
     C                   EXSR      X_Rate
     C                   END
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * X_Rate - Calculate Cross Rate                                 *
      *                                                               *
      *****************************************************************
 
     C     X_Rate        BEGSR
 
      ** If One Currency is Euro and the other is IN Currency
      ** then the spot rate is the Euro rate.
 
     C                   IF        SDCCY = EUCCY
     C                             AND CI_Ind = 'Y'
     C                   IF        SMDInd = CMDInd
     C                   EVAL      WSPTP = 1 / CsRate
     C                   ELSE
     C                   EVAL      WSPTP = CsRate
     C                   ENDIF
 
     C                   ELSE
 
     C                   IF        SCTCY = EUCCY
     C                             AND DI_Ind = 'Y'
     C                   IF        SMDInd <> DMDInd
     C                   EVAL      WSPTP = 1 / DsRate
     C                   ELSE
     C                   EVAL      WSPTP = DsRate
     C                   ENDIF
 
     C                   ELSE
 
      ** Calculate Cross Rate if Delivery Currency is an IN Currency
 
     C                   IF        DI_Ind = 'Y' AND CI_Ind <> 'Y'
 
     C                   IF        EMDInd = DMDInd
     C                   EVAL      DsRate = DsRate * EsRate
 
     C                   ELSE
 
     C                   IF        EMDInd <> DMDInd
     C                   EVAL      DsRate = EsRate / DsRate
     C                   EVAL      DMDInd = EMDInd
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
      ** Calculate Cross Rate if Counter Currency is an IN Currency
 
     C                   IF        CI_Ind = 'Y' AND DI_Ind <> 'Y'
 
     C                   IF        EMDInd = CMDInd
     C                   EVAL      CsRate = CsRate * EsRate
 
     C                   ELSE
 
     C                   IF        EMDInd <> CMDInd
     C                   EVAL      CsRate = EsRate / CsRate
     C                   EVAL      CMDInd = EMDInd
     C                   ENDIF
 
     C                   ENDIF
     C                   ENDIF
 
     C                   IF        SMDInd = DMDInd  AND DMDInd = CMDInd
     C                   EVAL      WSPTP = DsRate / CsRate
     C                   ENDIF
 
     C                   IF        SMDInd = DMDInd AND DMDInd <> CMDInd
     C                   EVAL      WSPTP = DsRate * CsRate
     C                   ENDIF
 
     C                   IF        SMDInd <> DMDInd  AND DMDInd = CMDInd
     C                   EVAL      WSPTP = CsRate / DsRate
     C                   ENDIF
 
     C                   IF        SMDInd <> DMDInd AND DMDInd <> CMDInd
     C                   EVAL      WSPTP = 1 / (DsRate * CsRate)
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
      **   - format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    SSPTP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
     C                   PARM                    WSPTP
      ** Tick denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minimum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *inzsr - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *inzsr        BEGSR
 
     C     *entry        PLIST
      ** Parameters returned to caller
      ** -----------------------------
      ** Return code (10A, returned to caller)
     C                   PARM                    ReturnCode
      ** Field name array (<ErrArrMax> x 10A, returned to caller)
     C                   PARM                    FldNamXArr
      ** Error message ID array (<ErrArrMax> x 7A, returned to caller)
     C                   PARM                    MsgIDXArr
      ** Error message data array (<ErrArrMax> x 45A, returned to caller)
     C                   PARM                    MsgDtaXArr
      ** Numeric (file) version of spot price (15,8P)
     C                   PARM                    WSPTP
 
      ** Parameters received from caller
      ** -------------------------------
      ** Spot price (16A, from transaction)
     C                   PARM                    SSPTP
      ** The INTYPD format (DS, several fields required)
     C                   PARM                    InstTypes
      ** Strike price (15,8)
     C                   PARM                    WSTRP
      ** Counter amount (13,0S, from transaction)
     C                   PARM                    WCCAM
      ** Delivery amount (13,0S, from transaction)
     C                   PARM                    WCTAM
      ** Delivery Currency (3A, from transaction)
     C                   PARM                    SDCCY
      ** Counter  Currency (3A, from transaction)
     C                   PARM                    SCTCY
      ** Euro Currency Code (3A, from SDGELRPD)
     C                   PARM                    EUCCY
      ** Transaction Value Date (5,0 in Midas date Format)
     C                   PARM                    TvDate
 
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY sets the values of program, module and
      ** procedure names for database error processing.
     C/COPY ZACPYSRC,DBFIELDS
      **--------------------------------------------------------------------------------------------
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      **--------------------------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **--------------------------------------------------------------------------------------------
      ********************************************************************
      /EJECT
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
