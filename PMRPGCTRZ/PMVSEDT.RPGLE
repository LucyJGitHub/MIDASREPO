     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Settl Date')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVCSETDAT - Validate Portfolio Charges Customer Settlement  *
      *               Frequency, Day in Month and Next Settlement     *
      *               Date                                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
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
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** Standard D-specs
      ** ================
      **
      ** The following /COPY line includes the LDA layout,
      ** the copyright array definition,
      ** and the following named constants:
      **    True       logical = *on (for indcator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
      *
      /COPY ZACPYSRC,STD_D_SPEC
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
      /COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes all the definitions of the
      ** appended error arrays, including the named constant giving the size
      ** of the arrays.
      *
      /COPY ZACPYSRC,ERR_XARRYS
      *
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
      *
      ** Portfolio Charges Settlement Day in Month
      ** - for file update
     D POCSDY          S              2S 0
      *
      ** Portfolio Charges Hidden Next Settlement Date
     D DDCSNH          S              5S 0
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** +--- Start of Main processing -------------------------------+
      ** ¦                                                            ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
     C                   MOVE      *BLANK        RETCODEIN
      *
     C                   MOVE      *BLANK        FLDNAMXAR
     C                   MOVE      *BLANK        MSGIDXAR
     C                   MOVE      *BLANK        MSGDTAXAR
     C                   Z-ADD     0             IDX
      *
     C                   Z-ADD     0             WCSDY             2 0
     C                   Z-ADD     0             WCSND             5 0
     C                   MOVE      *BLANK        W_CSDYZ           1
     C                   MOVE      'Y'           WCALCULATE        1
      *
      ** Validate Portfolio Charges Customer Settlement details.
      *
     C                   EXSR      SRStFDN
      *
     C     OKCSFQ        IFEQ      'N'
     C     OKCSDY        OREQ      'N'
     C     OKCSND        OREQ      'N'
     C                   EVAL      RETCODEIN  = 'ERROR'
     C                   ENDIF
      *
     C     OKCSFQ        IFNE      'N'
     C                   EVAL      POCSFQ = DDCSFQ
     C                   EVAL      DDCSFH = DDCSFQ
     C                   ENDIF
      *
     C     OKCSDY        IFNE      'N'
     C                   EVAL      POCSDY = WCSDY
     C                   EVAL      DDCSDH = DDCSDY
     C                   ENDIF
      *
     C     OKCSND        IFNE      'N'
     C                   EVAL      POCSND = WCSND
     C                   EVAL      DDCSNH = WCSND
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRStFDN - Validate Portfolio Charges Customer Settlement     *
      *            Frequency, Day in Month and Next Settlement Date   *
      *                                                               *
      *****************************************************************
      *
     C     SRStFDN       BEGSR
      *
      ** Validate Portfolio Charges Settlement Frequency.
      *
     C                   EXSR      SRCSFQ
      *
      ** Validate Portfolio Charges Settlement Day in Month.
      *
     C                   EXSR      SRCSDY
      *
      ** Validate Portfolio Charges Next Settlement Date.
      *
     C                   EXSR      SRCSND
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSFQ - Validate Portfolio Charges Settlement Frequency     *
      *                                                               *
      *****************************************************************
      *
     C     SRCSFQ        BEGSR
      *
     C     DDCSFQ        IFEQ      *BLANKS
      *
      ** Entry is mandatory if Charge Code has been entered.
      *
     C     DDCGCO        IFNE      *BLANKS
     C                   MOVE      'N'           OKCSFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11328'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   MOVE      'N'           WCALCULATE
      *
     C                   ELSE
      *
      ** If entered, entry must be  'M', 'Q', 'X' or 'Y'.
      *
     C     DDCSFQ        IFNE      'M'
     C     DDCSFQ        ANDNE     'Q'
     C     DDCSFQ        ANDNE     'X'
     C     DDCSFQ        ANDNE     'Y'
     C                   MOVE      'N'           OKCSFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11327'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
      ** Accruals must occur as frequently or more frequently
      ** than settlements.
      *
     C     DDCGFQ        IFEQ      'Q'
     C     DDCSFQ        ANDNE     'Q'
     C     DDCSFQ        ANDNE     'X'
     C     DDCSFQ        ANDNE     'Y'
     C                   MOVE      'N'           OKCSFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11330'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C     DDCGFQ        IFEQ      'X'
     C     DDCSFQ        ANDNE     'X'
     C     DDCSFQ        ANDNE     'Y'
     C                   MOVE      'N'           OKCSFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11330'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C     DDCGFQ        IFEQ      'Y'
     C     DDCSFQ        ANDNE     'Y'
     C                   MOVE      'N'           OKCSFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11330'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSDY - Validate Portfolio Charges Settlement Day in Month  *
      *                                                               *
      *****************************************************************
      *
     C     SRCSDY        BEGSR
      *
     C     DDCSDY        IFEQ      *BLANKS
      *
      ** If Settlement Frequency has been entered, Settlement
      ** Day in Month must also be specified.
      *
     C     DDCSFQ        IFNE      *BLANKS
     C                   MOVE      'N'           OKCSDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11326'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   MOVE      'N'           WCALCULATE
      *
     C                   ELSE
      *
      ** If Settlement Frequency has not been entered,
      ** Settlement Day in Month must not be specified.
      *
     C     DDCSFQ        IFEQ      *BLANKS
     C                   MOVE      'N'           OKCSDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11331'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
      ** Settlement Day in Month must be a number in the
      ** range 1-31.
      *
     C                   TESTN                   DDCSDY               0102
     C                   MOVE      DDCSDY        W_CSDYZ
     C                   TESTZ                   W_CSDYZ                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDCSDY        WCSDY
      *
     C     WCSDY         IFLT      1
     C     WCSDY         ORGT      31
     C                   MOVE      'N'           OKCSDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11332'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKCSDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11332'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSND - Validate Portfolio Charges Next Settlement Date     *
      *                                                               *
      *****************************************************************
      *
     C     SRCSND        BEGSR
      *
     C     DDCSND        IFNE      *BLANKS
      *
      ** Next Settlement Date must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDCSND        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKCSND
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11333'     MSGIDXAR(IDX)
      *
     C                   goto      ESRCSND
     C                   ENDIF
      *
     C                   Z-ADD     PDAYNO        WCSND
      *
      ** Entry must not be before run date.
      *
     C     WCSND         IFLT      BJRDNB
     C                   MOVE      'N'           OKCSND
     C                   ADD       1             IDX
     C                   MOVEL     'DDCSND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11334'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Next Settlement Date not entered, generate it from
      ** details entered.
      *
     C     WCALCULATE    IFEQ      'Y'
      *
     C                   Z-ADD     0             ZMDAY
      *
     C                   Z-ADD     BJRDNB        ZDAYNO            5 0
     C                   MOVEL     DDCSFQ        ZFREQ             1
     C                   MOVEL     DDCSDY        ZMDAY             2 0
     C                   MOVEL     BJCYCD        ZCCY              3
      *
     C                   CALLB     'ZFRQA'
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZMDAY
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM                    BJDFIN
      *
     C                   Z-ADD     ZDAYNO        WCSND
     C                   ENDIF
      *
      ** If Next Settlement Date day in month is the same as
      ** today's date, default Next Settlement Date to run date.
      *
     C                   Z-ADD     0             WWDAY             2 0
      *
     C                   MOVEL     BJMRDT        WWDAY
     C     WCSDY         IFEQ      WWDAY
     C                   Z-ADD     BJRDNB        WCSND
     C                   ENDIF
      *
      ** Convert Next Settlement Date to screen format.
      *
     C     WCSND         IFNE      0
      *
     C                   Z-ADD     WCSND         ZDAYNO
     C                   Z-ADD     0             ZDATE             6 0
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      ZDATE         DDCSND
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRCSND       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
      *
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Charges Settlement Frequency
      ** - incoming
     C                   PARM                    DDCSFQ            1
      *
      ** Portfolio Charges Settlement Day in Month
      ** - incoming
     C                   PARM                    DDCSDY            2
      *
      ** Portfolio Charges Next Settlement Date
      ** - incoming
     C                   PARM                    DDCSND            6
      *
      ** Portfolio Charges Charges Code
      ** - incoming
     C                   PARM                    DDCGCO            2
      *
      ** Portfolio Charges Accrual Frequency
      ** - incoming
     C                   PARM                    DDCGFQ            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - Base Currency
     C                   PARM                    BJCYCD            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Settlement Frequency
      ** - OK indicator
     C                   PARM                    OKCSFQ            1
      *
      ** Portfolio Charges Settlement Day in Month
      ** - OK indicator
     C                   PARM                    OKCSDY            1
      *
      ** Portfolio Charges Next Settlement Date
      ** - OK indicator
     C                   PARM                    OKCSND            1
      *
      ** Portfolio Charges Settlement Frequency
      ** - for file update
     C                   PARM                    POCSFQ            1
      *
      ** Portfolio Charges Settlement Day in Month
      ** - for file update
     C                   PARM                    POCSDY
      *
      ** Portfolio Charges Next Settlement Date
      ** - for file update
     C                   PARM                    POCSND            5 0
      *
      ** Portfolio Charges Hidden Settlement Frequency
     C                   PARM                    DDCSFH            1
      *
      ** Portfolio Charges Hidden Settlement Day in Month
     C                   PARM                    DDCSDH            2
      *
      ** Portfolio Charges Hidden Next Settlement Date
     C                   PARM                    DDCSNH
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
