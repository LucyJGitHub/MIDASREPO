     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas IR Validate Buy-Out Value Date')
      *****************************************************************
      *                                                               *
      *  Midas - FRA/IRS Dealing ILE Module                           *
      *                                                               *
      *  IRVBOVD01 - Validate Buy-Out Value Date                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel                      *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Last Amend No. CAP041  *CREATE    Date 07Jan02               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP041 - APIs for IRS Fees/Buy-Outs/Processing Method/Next   *
      *           Principal Change Date.                              *
      *                                                               *
      *****************************************************************
 
 
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
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
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
      *
      ** Transaction Details in screen format
     D NwFBScnFmt    E DS                  EXTNAME(IRFEBOPD)
      *
      ** Transaction Details OK indicators
     D OKFEBO        E DS                  EXTNAME(IREFEBOPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
     D WIdx            S              3P 0
 
     D WBOVD           S              5P 0
 
     D DateIn          S              6A
     D DaynoOut        S              5P 0
     D BJDFIN          S              1A
     D BJRDNB          S              5P 0
     D ErrorFlag       S              1A
 
     D/COPY QWINDSRC,IRCIRSGDTA
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      ** Initialization
 
     C                   MOVE      *BLANK        RetCodeIn
 
     C                   MOVE      *BLANK        FldNamXAr
     C                   MOVE      *BLANK        MsgIDXAr
     C                   MOVE      *BLANK        MsgDtaXAr
     C                   Z-ADD     0             Idx
     C                   Z-ADD     0             WIdx
      *
      ** Validate Buy-Out Value date
      *
     C                   EXSR      SRValBOVD
      *
      ** If an error has been found, set return code appropriately.
      ** Otherwise, update valid file fields.
      *
     C                   IF        OKBOVD = 'N'
 
     C                   EVAL      RetCodeIn = 'ERROR'
 
     C                   ELSE
 
     C     WBOVD         IFEQ      0
     C                   Z-ADD     0             #1BODD
     C                   ELSE
     C     #1BOVD        IFEQ      0
     C                   Z-ADD     BJRDNB        #1BODD
     C                   ENDIF
     C                   ENDIF
 
     C                   Z-ADD     WBOVD         #1BOVD
 
     C                   ENDIF
      *
      ** RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRValBOVD - Validation for Buy-Out Value Date                *
      *                                                               *
      *****************************************************************
     C     SRValBOVD     BEGSR
 
     C                   Z-ADD     0             WBOVD
 
     C                   IF        SBOVD = *BLANKS
      *
      ** If Buy-Out amount and pay/rec indicator
      ** are not blank, the value date cannot be blank.
      *
     C                   IF        SBUYA <> *BLANKS or SBOPR <> *BLANKS
 
     C                   EVAL      OKBOVD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SBOVD     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00049'
 
     C                   GOTO      ESRValBOVD
 
     C                   ENDIF
 
     C                   ELSE
 
     C                   TESTN                   SBOVD                01
 
     C                   IF        *IN01
 
     C                   MOVE      SBOVD         DateIn
     C                   CALLB     'ZDATE1'
     C                   PARM                    DateIn
     C                   PARM      *ZERO         DaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       ErrorFlag
 
     C                   ENDIF
      *
      ** Must be a valid date
      *
     C                   IF        ErrorFlag = 'Y' or *IN01 = '0'
 
     C                   EVAL      OKBOVD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SBOVD     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00050'
 
     C                   GOTO      ESRValBOVD
 
     C                   ELSE
 
     C                   Z-ADD     DaynoOut      WBOVD
      *
      ** Must be greater than or equal to deal date of deal
      ** AND less than maturity date.
      *
     C                   IF        WBOVD < #1DDAT or WBOVD >= #1MDAT
 
     C                   EVAL      OKBOVD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SBOVD     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00051'
 
     C                   GOTO      ESRValBOVD
 
     C                   ENDIF
      *
      ** Must be greater than or equal to Our/Their
      ** Interest Accrual Control Date.
      *
     C                   IF        WBOVD < #1UIAC or WBOVD < #1TIAC
 
     C                   EVAL      OKBOVD = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'SBOVD     '
     C                   EVAL      MsgIdXAr(Idx) = 'RS00052'
 
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDIF
 
     C     ESRValBOVD    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUTS
      ** ======
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Transaction Details
     C                   PARM                    NwFBScnFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Midas rundate
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUTS
      ** =======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Transaction Details OK inds
     C                   PARM                    OKFEBO
      *
      ** Deal info passed from calling programs
     C                   PARM                    Data
 
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
