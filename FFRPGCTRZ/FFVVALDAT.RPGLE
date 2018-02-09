     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FF Value date')
      *****************************************************************
      *                                                               *
      *  Midas - Financial Futures and Options module                 *
      *                                                               *
      *  FFVVALDAT - Value Date                                       *
      *                                                               *
      *  Function:  This module checks the validity of the value      *
      *             date on an FF transaction.                        *
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
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Prev Amend No. 147775             Date 16Nov98               *
      *                 CAP004  *CREATE    Date 01Jun98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Value date, alpha
     D SVALD           S              6A
 
      ** Value date in Midas day number format, zone
     D WVALD           S              5S 0
 
      ** Midas day number, packed
     D ZDAYNO          S              5P 0
 
      ** Final Transaction Date
     D WFTDT           S              5P 0
 
      ** Trade date
     D STRSD           S              6A
 
      ** Trade date in Midas day number format
     D WTRSD           S              5P 0
 
      ** Trade date error flag
     D OKTRSD          S              1A
 
      ** Instrument/ O.T.C type error flag
     D OKISTT          S              1A
 
      ** Initial Margin error flag
     D OKFTDT          S              1A
 
      ** Value date error flag
     D OKVALD          S              1A
 
      ** Branch Code error flag
     D OKBRCD          S              1A
 
      ** Premium Currency
     D SISCY           S              3A
 
      ** Location code
     D LCCD            S              3A
 
      ** Rundate format , if 'M'= MMDDYY else = DDMMYY
     D PDATF           S              1A
 
      ** Holiday flag
     D ZIND            S              1A
 
      ** Error flag passed back from ZDATE1
     D ErrorFlag       S              1A
 
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
      ** MsgDtaXArr, XIdx; and to warning message handling: WarnFound,
      ** FldNamWArr, MsgIDWArr, MsgDtaWArr, WIdx.
      ** It therefore requires FVAL_ARRAY and STD_D_SPEC.
     C/COPY ZACPYSRC,FVAL_RESET
      **--------------------------------------------------------------------------------------------
 
      **   1. If blank, set value date equal to trade (transaction) date
      **      (only if trade date not in error)
     C     SVALD         IFEQ      *BLANK
     C     OKTRSD        ANDEQ     'Y'
     C                   MOVEL     STRSD         SVALD
     C                   END
 
      **   2. Valid date format
      **
      **      Test if date is numeric
      **
     C                   TESTN                   SVALD                9798
     C     *IN97         IFEQ      '1'
     C     *IN98         OREQ      '1'
     C                   CALLB     'ZDATE1'
     C                   PARM                    SVALD
     C                   PARM      *ZEROS        ZDAYNO
     C                   PARM                    PDATF
     C                   PARM                    ErrorFlag
     C                   END
 
      **   - invalid format or not numeric
     C     ErrorFlag     IFEQ      'Y'
     C     *IN97         OREQ      '0'
     C     *IN98         ANDEQ     '0'
 
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0427'
     C                   EVAL      OKVALD     = 'N'
     C                   GOTO      VVDEND
     C                   ELSE
     C                   Z-ADD     ZDAYNO        WVALD
     C                   END
 
 
      **   3. Must not be less than the trade (transaction) date
      **      (only if trade date not in error)
     C     WVALD         IFLT      WTRSD
     C     OKTRSD        ANDEQ     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0428'
     C                   EVAL      OKVALD     = 'N'
     C                   GOTO      VVDEND
     C                   END
 
      **   4. Must not be after the instrument's final transaction date
      **     (only if final transaction date - expiry date - not in error)
 
     C     WVALD         IFGT      WFTDT
     C     OKISTT        ANDEQ     'Y'
     C     OKFTDT        ANDEQ     'Y'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0429'
     C                   EVAL      OKVALD     = 'N'
     C                   GOTO      VVDEND
     C                   END
 
      **   5. Must not be a holiday in premium currency
      **     (only if branch code not in error)
 
     C     OKBRCD        IFEQ      'Y'
     C                   Z-ADD     WVALD         ZDAYNO
     C                   MOVE      *BLANK        ZIND
     C                   CALLB     'ZCHKH'
     C                   PARM                    ZDAYNO
     C                   PARM                    SISCY
     C                   PARM                    LCCD
     C                   PARM                    ZIND
     C     ZIND          IFEQ      'H'
     C                   EVAL      ErrorFound = 'Y'
     C                   EVAL      XIdx = XIdx + 1
     C                   EVAL      FldNamXArr(XIdx) = 'SVALD'
     C                   EVAL      MsgIDXArr(XIdx) = 'MMA0430'
     C                   EVAL      OKVALD     = 'N'
     C                   END
 
     C                   END
 
 
     C     VVDEND        TAG
 
      ********************************************************************
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
      ** Value Date in Midas Day Number format (5S,0)
     C                   PARM                    WVALD
 
      ** Parameters received from caller
      ** -------------------------------
      ** Value Date (6A)
     C                   PARM                    SVALD
      ** Trade date in Midas day number format (5P,0)
     C                   PARM                    WTRSD
      ** Expiry Date (5P,0)
     C                   PARM                    WFTDT
      ** Trade date (6A)
     C                   PARM                    STRSD
      ** Run date format (1A)
     C                   PARM                    PDATF
      ** Premium Currency (3A)
     C                   PARM                    SISCY
      ** Location code (3A)
     C                   PARM                    LCCD
      ** Trade date error flag (1A)
     C                   PARM                    OKTRSD
      ** Instrument/ O.T.C type error flag (1A)
     C                   PARM                    OKISTT
      ** Initial Margin error flag (1A)
     C                   PARM                    OKFTDT
      ** Branch Code error flag (1A)
     C                   PARM                    OKBRCD
 
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
