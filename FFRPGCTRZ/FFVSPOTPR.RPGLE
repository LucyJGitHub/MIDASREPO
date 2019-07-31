     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Exchange traded spot price')                  *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVSPOTPR - Validate Spot Price for Exchange-Traded FF       *
      *                                                               *
      *  Function:  This module confirms that the strike price        *
      *             entered for an FF trade is a legitimate value.    *
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
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 193759             Date 25Jun01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002  *CREATE    Date 08Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  193759 - Fixed to display correct error message for Spot     *
      *           Price field.                                        *
      *  CPL002 - Midas-Plato Interface.                              *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      ** Alternative version of instruments file to get underlying
      ** future details
     FINTYP2    IF   E           K DISK    PREFIX(F_)
     FPRISP1    IF   E           K DISK    PREFIX(P_)
 
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
 
      ** Spot price
     D SSPTP           S             16A
 
      ** Ticks denominator
     D FFTKDM          S              3P 0
 
      ** Minimum price fluctuation
     D FFMNPF          S             15P 8
 
      ** Market
     D SMRKT           S              2A
 
      ** --- End of parameters not declared elsewhere ----------------------------------------------
 
      ** Work version of strike price in file format
     D WSPTP           S             15P 8
 
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
      ** Get Default value if Spot Price not enter
      *
     C                   EXSR      SetDft
 
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
 
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SetDft  - Set Default value if Spot Price is Blank            *
      *                                                               *
      *****************************************************************
 
     C     SetDft        BEGSR
 
      ** If Spot Price not being entered, then check if spot price
      ** can be find on File
     C                   IF        SSPTP = *blanks
 
     C     ISTT          CHAIN     PRISP1                             99
 
     C                   IF        NoRecFound = False AND P_RECI = 'D'
 
     C                   EVAL      WSPTP = P_NSPR
 
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
 
     C                   ENDIF
 
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
     C                   PARM                    WSPTP
 
      ** Parameters received from caller
      ** -------------------------------
      ** Strike price (16A, from transaction)
     C                   PARM                    SSPTP
      ** The INTYPD format (DS, several fields required)
     C                   PARM                    InstTypes
      ** Market (2A, from transaction if exchange-traded, passed as
      ** blank for OTCs)
     C                   PARM                    SMRKT
 
 
 
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
