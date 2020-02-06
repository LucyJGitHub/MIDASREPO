     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2006')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('End of Tax Year')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module - Country Details Validation    *
      *                                                               *
      *  SDVETXY  - End of Tax Year                                   *
      *                                                               *
      *  (c) Finastra International Limited 2006                      *
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
      *  Prev Amend No. BG12120            Date 04Oct06               *
      *                 CRE026  *CREATE    Date 24May06               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  BG12120 -  Error generated on field weighting code and       *
      *             End of Year Tax.                                  *
      *  CRE026 - Consumer Banking                                    *
      *                                                               *
      *****************************************************************
 
      ** EXTERNAL DS FOR Bank Detail
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
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
     D WIdx            S              3P 0
 
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
      ** VALIDATION
 
     C     DDETXY        IFNE      *BLANKS
      *
      ** Is it a 4-digit number?
      *
     C                   MOVE      *BLANKS       PZFLD            16
     C                   MOVE      DDETXY        PZFLD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM      *BLANK        ZALIGNOK          1
     C                   PARM                    PZFLD            16
     C                   PARM      *ZERO         PZADEC            1 0
     C                   PARM      4             PZADIG            2 0
      *
     C     ZALIGNOK      IFEQ      'N'
      *
      ** End of Tax Year must be numeric.
      *
     C                   EVAL      DDETXYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDETXY    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR4805'
     C                   GOTO      EMAIN
     C                   ENDIF
      *
      ** Is it a valid month & day under the current year and date format?
      *
      ** Get the month, day, and year values.
      *
     C                   MOVE      BJMRDT        WYEAR             2 0
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     DDETXY        WMONTH            2 0
     C                   MOVE      DDETXY        WDAY              2 0
     C                   ELSE
     C                   MOVE      DDETXY        WMONTH
     C                   MOVEL     DDETXY        WDAY
     C                   ENDIF
      *
     C                   MOVEL     DDETXY        WDATE             6
     C                   MOVE      WYEAR         WDATE
     C                   MOVE      WDATE         PZDATE
      *
     C                   CALLB     'ZDATE1'
     C**********         PARM                    PZDATE            6 0                       BG12120
     C                   PARM                    PZDATE            6                         BG12120
     C                   PARM      *ZERO         PZDAYN            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag         1
      *
      ** Recover when a leap year error occurs.
      *
     C     ErrorFlag     IFEQ      'Y'
     C     WMONTH        ANDEQ     2
     C     WDAY          ANDEQ     29
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     WMONTH        WETXY             4
     C                   MOVE      '28'          WETXY
     C                   ELSE
     C                   MOVE      WMONTH        WETXY
     C                   MOVEL     '28'          WETXY
     C                   ENDIF
      *
     C                   MOVE      WETXY         DDETXY
     C                   MOVEL     WETXY         WDATE
     C                   MOVE      WYEAR         WDATE
     C                   MOVE      WDATE         PZDATE
      *
     C                   CALLB     'ZDATE1'
     C**********         PARM                    PZDATE            6 0                       BG12120
     C                   PARM                    PZDATE            6                         BG12120
     C                   PARM      *ZERO         PZDAYN            5 0
     C                   PARM                    BJDFIN
     C                   PARM      *BLANK        ErrorFlag         1
      *
     C                   ENDIF
      *
     C     ErrorFlag     IFEQ      'Y'
      *
      ** End of Tax Year must be valid date.
      *
     C                   EVAL      DDETXYOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNamXAr(Idx) = 'DDETXY    '
     C                   EVAL      MsgIdXAr(Idx) = 'USR4806'
     C                   GOTO      EMAIN
 
     C                   ENDIF
      *
     C                   ENDIF
 
      *
      * RETURN
      *
     C     EMAIN         TAG
     C                   RETURN
      *****************************************************************
     C/EJECT
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
      ** Other parms
      *
      ** Field(s) requiring validation
     C                   PARM                    DDETXY            4
      *
      *
      * OUTPUTS
      *
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      ** End of Tax Year   - OK
     C                   PARM                    DDETXYOK          1
      *
      *
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANK        @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     '*FIRST '     DBKEY
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      ********************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2006
