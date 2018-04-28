     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate strike price')                       *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVSTRKPR - Validate strike price                            *
      *                                                               *
      *  Function:  This module confirms that the strike price        *
      *             entered for an FF trade is a legitimate value.    *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CAP208             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Prev Amend No. 256564             Date 17Sep08               *
      *                 246527             Date 19Mar07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245129             Date 22Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 16Nov98               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  246527 - Correct Premium calculation. Review 245129.         *
      *  245129 - Contract price can only accommodate up to 6 decimal *
      *           places. Amend module and change default of field    *
      *           Minimun Price Flactuation (WMNPF) to '0.00000001'   *
      *           if processing type is '5'.  Apply fix 218004.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs                  *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Alternative version of instruments file to get underlying
      ** future details
     FINTYP2    IF   E           K DISK    PREFIX(F_)
 
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
 
      ** Strike price
     D SSTRP           S             16A
 
      ** Ticks denominator
     D FFTKDM          S              3P 0
 
      ** Minimum price fluctuation
     D FFMNPF          S             15P 8
 
      ** Market
     D SMRKT           S              2A
 
      ** Counter amount
     D WCCAM           S             13P 0
 
      ** Delivery amount
     D WCTAM           S                   LIKE(WCCAM)
 
      ** Counter currency decimal places
     D CCDP            S              1S 0
 
      ** Delivery currency decimal places
     D DCDP            S                   LIKE(CCDP)
 
      ** --- End of parameters not declared elsewhere ----------------------------------------------
 
      ** Work version of strike price in file format
     D WSTRP           S             15P 8
 
     ** --- Fields for ZAMCON procedure ------------------------------------------------------------
     D ZAMFR           S             15P 0
     D ZEXR            S             15P 9
 
      ** Output (converted) amount
     D ZAMTO           S             20P 5
     ** --- End of fields for ZAMCON procedure -----------------------------------------------------
 
      ** Key field for getting the underlying future details
     D Futurekey       S              5A
 
 
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
 
     C     SSTRP         IFNE      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSTRP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0346'
 
     C                   ENDIF
 
     C                   ELSE
 
      **   'Options' (Instr. Process Type = 4,5,6) - must be entered
 
     C     SSTRP         IFEQ      *BLANK
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSTRP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0347'
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
 
      ** Set the ticks denominator and minimum price fluctuation.
     C                   EXSR      SetTick
 
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRVL'
      ** Parameters returned from called procedure
      ** -----------------------------------------
     C                   PARM                    ReturnCode
      ** File version of price (15,8P)
     C                   PARM                    WSTRP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** Screen version of price (16A)
     C                   PARM                    SSTRP
      ** Ticks denominator (3,0P)
     C                   PARM                    FFTKDM
      ** Minmum price fluctuation (15,8P)
     C                   PARM                    FFMNPF
 
      **   - invalid format
     C                   IF        ReturnCode = 'Error'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSTRP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0352'
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
      **   - cannot be zero
     C     WSTRP         IFEQ      0
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSTRP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0353'
 
     C                   GOTO      VSPEND
 
     C                   ENDIF
 
      **   - If FX OTC, must match exchange rate between deal amounts     073714
     C     ISPT          IFEQ      5                                                           07371
     C     SMRKT         ANDEQ     '  '                                                        07371
 
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
 
     C                   Z-ADD     WCCAM         ZAMFR                                         07371
     C                   Z-ADD     WSTRP         ZEXR                                          07371
 
     C                   CALLB     'FFZAMCON'                                                  07371
     C                   PARM                    ZAMTO                                         07371
     C                   PARM                    ZAMFR                                         07371
     C                   PARM                    ZEXR                                          07371
     C                   PARM                    CCDP                                          07371
     C                   PARM                    DCDP                                          07371
 
     C     ZAMTO         ADD       1             ZAMTA1                                        07371
     C     ZAMTO         SUB       1             ZAMTS1                                        07371
     C     WCTAM         IFGT      ZAMTA1                                                      07371
     C     WCTAM         ORLT      ZAMTS1                                                      07371
      **   - invalid format                                               073714
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SSTRP'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0352'
 
     C                   GOTO      VSPEND                                                      07371
     C                   END                                                                   07371
     C                   END                                                                   07371
     C                   END                                                                   07371
      **   - format price
     C                   RESET                   ReturnCode
     C                   CALLB     'FFPRCS'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Screen version of price (16A)
     C                   PARM                    SSTRP
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** File version of price (15,8P)
     C                   PARM                    WSTRP
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
 
      ** If a Market Instrument Trade, access the underlying Future
      ** for Minimum Price Fluctuation + Ticks Denominator.
     C                   IF        SMRKT <> *blanks
 
     C                   EVAL      FutureKey = SMRKT + FTRF
 
     C     FutureKey     CHAIN     INTYP2                             99
 
     C                   IF        NoRecFound = True OR F_RECI <> 'D'
 
     C     *LOCK         IN        LDA
     C                   Z-ADD     6             DBASE                          ** DBERR  06 **S0111
     C                   MOVE      'INTYP'       DBFILE
     C                   MOVEL     FutureKey     DBKEY
     C                   EVAL      ReturnCode = 'Error'
     C                   EXSR      *pssr
 
     C                   ENDIF
 
     C                   EVAL      FFTKDM = F_TKDM
     C                   EVAL      FFMNPF = F_MNPF
 
      ** Otherwise it is an OTC.  If the fields from INTYPD are not set up,
      ** use default values.
     C                   ELSE
 
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
 
     C                   ENDIF
 
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
      ** Numeric (file) version of strike price (15,8P)
     C                   PARM                    WSTRP
 
      ** Parameters received from caller
      ** -------------------------------
      ** Strike price (16A, from transaction)
     C                   PARM                    SSTRP
      ** The INTYPD format (DS, several fields required)
     C                   PARM                    InstTypes
      ** Market (2A, from transaction if exchange-traded, passed as
      ** blank for OTCs)
     C                   PARM                    SMRKT
      ** Counter amount (13,0S, from transaction)
     C                   PARM                    WCCAM
      ** Delivery amount (13,0S, from transaction)
     C                   PARM                    WCTAM
      ** Counter currency decimal places (1,0P, from currencies file)
     C                   PARM                    CCDP
      ** Delivery currency decimal places (1,0P, from currencies file)
     C                   PARM                    DCDP
 
 
 
 
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
(c) Misys International Banking Systems Ltd. 2001
