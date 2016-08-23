     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Validate Trade Trade Date')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SEVTTRDDT - Validate Trade trade date                        *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *  Last Amend No. CAP003  *CREATE    Date 23Jan98               *
      *  Prev Amend No.                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CAP003 - Conversion of SE inputs into modular structure to   *
      *           use as APIs.                                        *
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
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIx             S              3P 0
 
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
     C                   MOVE      *BLANK        WFldNmXAr
     C                   MOVE      *BLANK        WMsgIDXAr
     C                   MOVE      *BLANK        WMsgDtXAr
     C                   Z-ADD     0             WIx
 
      ** Clear output trade fields
 
     C                   Z-ADD     0             TDDT
      *
      ** DEFAULT
      *
     C     Default       IFEQ      'Y'
     C     DDTDDT        ANDEQ     *BLANK
     C                   EXSR      TDDTD
     C                   END
      *
      ** VALIDATION
      *
     C     Validate      IFEQ      'Y'
     C                   EXSR      TDDTV
     C                   END
      *
      ** If an error was found, set the return code appropriately
      *
     C     DDTDDTOK      IFEQ      'N'
     C                   EVAL      RetCodeIn = 'Error'
     C                   ENDIF
      *
      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** DEFAULT
      *****************************************************************
     C     TDDTD         BEGSR
      *
      *  Default Trade date
      *
     C     BJRDNB        IFLE      TDVD
     C                   Z-ADD     BJRDNB        ZDAYNO
     C                   ELSE
     C                   Z-ADD     TDVD          ZDAYNO
     C                   END
 
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM                    BJDFIN
     C                   PARM                    ZDATE             6 0
     C                   PARM                    ZADATE            7
 
     C                   MOVEL     ZDATE         DDTDDT
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VALIDATION
      *****************************************************************
     C     TDDTV         BEGSR
      *
      **  It must be a valid date
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVEL     DDTDDT        ZFIELD
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNok          1
     C                   PARM                    ZFIELD           16
     C                   PARM      0             ZADEC             1 0
     C                   PARM      6             ZADIG             2 0
 
     C     ZALIGNok      IFEQ      'Y'
     C                   MOVE      ZFIELD        ZDATEI
     C                   CALLB     'ZDATE1'
     C                   PARM                    ZDATEI            6
     C                   PARM      *ZEROS        ZDAYNO            5 0
     C                   PARM                    BJDFIN
     C                   PARM                    ErrorFlag         1
     C                   END
 
      * If either ZALIGN and ZDATE1 errors
 
     C     ZALIGNok      IFEQ      'N'
     C     ErrorFlag     OREQ      'Y'
     C                   MOVE      'N'           DDTddtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDDT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0508'     MsgIdXAr(Idx)
     C                   GOTO      ETDDTV
     C                   END
      *
      * Update trade trade date
      *
     C                   Z-ADD     ZDAYNO        TDDT
      *
      *  It must not be greater than run date
      *
     C     TDDT          IFGT      BJRDNB
     C                   MOVE      'N'           DDTddtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDDT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0508'     MsgIdXAr(Idx)
     C                   END
      *
      *  It must not be greater than value date (if value date is ok)
      *
     C     TDDT          IFGT      TDVD
     C                   MOVE      'N'           DDTddtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDDT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0509'     MsgIdXAr(Idx)
     C                   END
      *
      **  It must fall within the back value period
      *
     C     TDDT          IFLT      BckValDte
     C                   MOVE      'N'           DDTddtOK
     C                   ADD       1             Idx
     C                   MOVEL     'DDTDDT'      FldNamXAr(Idx)
     C                   MOVEL     'MMA0510'     MsgIdXAr(Idx)
     C                   END
      *
      * Output warning if it is a holiday in local currency
      *
     C                   CALLB     'ZCHKH'
     C                   PARM      TDDT          ZDAYNO
     C                   PARM                    BJLCCY
     C                   PARM                    BJSLCD
     C                   PARM                    ZIND              1
     C*
     C* If a holiday
     C*
     C     ZIND          IFEQ      'H'
     C     DDTddtOK      IFNE      'N'
     C                   MOVE      'W'           DDTddtOK
     C                   END
     C                   ADD       1             WIx
     C                   MOVEL     'DDTDDT'      WFldNmXAr(WIx)
     C                   MOVEL     'MMA0511'     WMsgIdXAr(WIx)
     C                   END
      *
     C     ETDDTV        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      * INPUTS
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Default & Validate (Y or N)
     C                   PARM                    Default           1
     C                   PARM                    Validate          1
      *
      ** Trade Screen fields
     C                   PARM                    DDTDDT            7
      *
      ** Trade value date
     C                   PARM                    TDVD              5 0
      *
      ** ICD
      ** run date, date format, local currency, system location, bv period
      *
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    BJDFIN            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3
     C                   PARM                    BVBVP             3 0
      *
      * OUTPUTS
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDXAr
     C                   PARM                    WMsgDtXAr
      *
      ** Trade Date - OK
     C                   PARM                    DDTDDTOK          1
      *
      ** Trade Date
      *
     C                   PARM                    TDDT              5 0
      *
      *  Calculate the back value date
      *
     C     BJRDNB        SUB       BVBVP         BckValDte         5 0
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
(c) Misys International Banking Systems Ltd. 2001
