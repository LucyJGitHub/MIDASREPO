     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Validate trade date')                         *
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVTRDDAT - Validate trade date                              *
      *                                                               *
      *  Function:  This module checks the validity of the trade      *
      *             date on an FF trade.                              *
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
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP208 - F&O Market Instrument API (Recompile)               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  147775 - General FF API fixes - (Pre-release unnanotated)    *
      *  CAP004 - Conversion of Midas inputs to APIs.                 *
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
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
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
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** Midas FF Exchange- traded F & O's OK flags
     D FFEEXTR       E DS                  EXTNAME(FFEEXTRPD)
      ** External DS for BRANCH Details
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
 
      * FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
     D INTYP         E DS                  EXTNAME(INTYPD)
      ** Instrument types data structure
 
     D MARKT         E DS                  EXTNAME(MARKTD) PREFIX(P)
      ** Market centres data structure
 
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Trade date
     D STRSD           S              6A
 
      ** Rundate format , if 'M'= MMDDYY else = DDMMYY
     D PDATF           S              1A
 
      ** Holiday flag
     D ZIND            S                   LIKE(PDATF)
 
      ** If Market instrument field is not blank , this is the Market
      ** instrument date else this is the run date.
     D CTDATE          S              5P 0
 
      ** Historical data period
     D STHDP           S                   LIKE(CTDATE)
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S                   LIKE(PDATF)
 
      ** Transaction date
     D WTRSD           S              5P 0
 
      ** Market centre
     D SMRKT           S              2A
 
      ** Month
     D WMTHN           S              2S 0
 
      ** Year
     D WYRNO           S                   LIKE(WMTHN)
 
      ** Midas day number
     D FFDAY           S                   LIKE(CTDATE)
 
      ** Location code
     D LCCD            S              3A
 
      ** Local currency code
     D LOCY            S              3A
 
 
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
 
      *
      **   Reset Holiday field
      *
     C                   MOVE      *BLANK        ZIND
      **
      **   1. If blank, set equal to Current Trading date
     C     STRSD         IFEQ      *BLANK
     C                   CALLB     'ZDATE2'
     C                   PARM      CTDATE        ZDAYNO            5 0          Value date
     C                   PARM      PDATF         BJDFIN            1            Date format ind
     C                   PARM      *ZEROS        ZDATE             6 0          Value date
     C                   PARM      *BLANK        ZADATE            7            Run-date in DDM
     C                   MOVE      ZDATE         STRSD
     C                   END
      **
      **   Test if date is numeric
      **
     C                   TESTN                   STRSD                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
      **
      **   2. Valid date format
      **
     C                   CALLB     'ZDATE1'
     C                   PARM                    STRSD
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM      PDATF         BJDFIN
     C                   PARM                    ErrorFlag
     C                   END
      **
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STRSD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0417'
 
     C                   GOTO      VTDEND
     C                   END
      **
     C                   Z-ADD     ZDAYNO        WTRSD
      **
      **   3. Must not be greater than Current Trading date
     C     WTRSD         IFGT      CTDATE
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STRSD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0418'
 
     C                   GOTO      VTDEND
     C                   END
      **
      **   4. Must not be before Start of Historical Data Period
     C     WTRSD         IFLT      STHDP
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STRSD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0420'
 
     C                   GOTO      VTDEND
     C                   END
      **
      **   5. Must not be after the instrument's Final Transaction Date
      **   (validate only if instr type, month + year not in error)
      **   (          and if booking branch not in error)
      **   (          or  if instr type, month + year not in error)
      **
     C     OKISTC        IFEQ      'Y'
     C     OKMTHN        ANDEQ     'Y'
     C     OKYRNO        ANDEQ     'Y'
     C     OKBRCD        ANDEQ     'Y'
      **
      **   - If booking branch is valid,
      **     use booking branch location.
      **   - save BICN for settlement details processing.
 
     C     SMRKT         IFNE      '  '
      **    (Final Trans Date  calculated from the Formula for
      **     the instrument)
     C                   Z-ADD     WMTHN         FFMTH             2 0
     C                   Z-ADD     WYRNO         FFYR              2 0
     C                   MOVE      PMKLC         FFCCY1            3
     C                   MOVE      PMLOC         FFLOC             3
     C                   MOVE      ISCY          FFCCY2            3
     C                   MOVE      OTHC          FFCCY3            3
 
      ** Calculate the final transaction date
     C                   CALLB     'FFDATE'
      ** Parameters returned from called procedure
      ** -----------------------------------------
      ** Return code
     C                   PARM                    ReturnCode
      ** Working day
     C                   PARM                    FFDAY
 
      ** Parameters passed to called procedure
      ** -------------------------------------
      ** Date formula
     C                   PARM                    FTDF
      ** Month of required date
     C                   PARM                    FFMTH
      ** Year of required date
     C                   PARM                    FFYR
      ** Market currency (3A)
     C                   PARM                    FFCCY1
      ** Market location
     C                   PARM                    FFLOC
      ** Instrument currency
     C                   PARM                    FFCCY2
      ** Other currency
     C                   PARM                    FFCCY3
      ** Date format indicator
     C                   PARM                    PDATF
 
     C                   Z-ADD     FFDAY         FTDATE            5 0
      **
     C                   ELSE
     C                   Z-ADD     FTDT          FTDATE
     C                   END
      **
     C     WTRSD         IFGT      FTDATE
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STRSD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0421'
 
     C                   GOTO      VTDEND
     C                   END
      **
     C                   END
      **
      **   6. Must not be a Holiday
      **      Perform validation only when no error on branch code
      **
     C     OKBRCD        IFEQ      'Y'
 
     C     SMRKT         IFNE      '  '
     C                   MOVE      PMKLC         ZCCY
     C                   MOVE      PMLOC         ZLOC
     C                   ELSE
     C                   MOVE      LOCY          ZCCY
     C                   MOVE      LCCD          ZLOC
     C                   END
      **
     C                   Z-ADD     WTRSD         ZDAYNO
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM                    ZCCY              3
     C                   PARM                    ZLOC              3
     C                   PARM                    ZIND
      **
     C     ZIND          IFEQ      'H'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'STRSD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0419'
 
     C                   END
      **
     C                   END
      **
     C     VTDEND        TAG
      **        ~~~~~~~~
      **
 
 
 
      **--------------------------------------------------------------------------------------------
      ** The return code is set in the following /COPY:
     C/COPY ZACPYSRC,SETRETCDE
      **--------------------------------------------------------------------------------------------
 
     C                   RETURN
 
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
      ** Trade date in Midas day number format (5,0P)
     C                   PARM                    WTRSD
 
      ** Parameters received from caller
      ** -------------------------------
      ** Trade date (6A, from transaction)
     C                   PARM                    STRSD
      ** Current trading date (5,0P, derived from transaction data)
     C                   PARM                    CTDATE
      ** Run date format (1A, from SDBANKPD)
     C                   PARM                    PDATF
      ** Historical date period (5,0P, derived from transaction data)
     C                   PARM                    STHDP
      ** Market centre  (2A, from transaction)
     C                   PARM                    SMRKT
      ** Month (2,0S, derived from transaction data)
     C                   PARM                    WMTHN
      ** Year (2,0S, derived from transaction data)
     C                   PARM                    WYRNO
      ** Location code (3A, from SDBRCHPD)
     C                   PARM                    LCCD
      ** Local currency code (3A, from SDBANKPD)
     C                   PARM                    LOCY
      ** Instrument types format (DS, from INTYPD)
     C                   PARM                    INTYP
      ** Market centres format (DS, from MARKTD)
     C                   PARM                    MARKT
      ** Midas FF Exchange-traded F & O's OK flags
     C                   PARM                    FFEEXTR
 
 
 
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
