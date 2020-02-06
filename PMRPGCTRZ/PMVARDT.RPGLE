     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Accrual Date')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVARDT    - Validate Portfolio Charges Accrual Frequency,   *
      *               Day in Month and Next Accrual Date              *
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
      ** Portfolio Charges Accrual Day in Month
      ** - for file update
     D POCGDY          S              2S 0
      *
      ** Portfolio Charges Hidden Next Accrual Date
     D DDCGNH          S              5S 0
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
     C                   Z-ADD     0             WCGDY             2 0
     C                   Z-ADD     0             WCGND             5 0
     C                   MOVE      *BLANK        W_CGDYZ           1
     C                   MOVE      'Y'           WCALCULATE        1
      *
      ** Validate Portfolio Charges Accrual Frequency,
      ** Day in Month and Next Accrual Date.
      *
     C                   EXSR      SRAcFDN
      *
     C     OKCGFQ        IFEQ      'N'
     C     OKCGDY        OREQ      'N'
     C     OKCGND        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKCGFQ        IFNE      'N'
     C                   EVAL      POCGFQ = DDCGFQ
     C                   EVAL      DDCGFH = DDCGFQ
     C                   ENDIF
      *
     C     OKCGDY        IFNE      'N'
     C                   EVAL      POCGDY = WCGDY
     C                   EVAL      DDCGDH = DDCGDY
     C                   ENDIF
      *
     C     OKCGND        IFNE      'N'
     C                   EVAL      POCGND = WCGND
     C                   EVAL      DDCGNH = WCGND
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcFDN - Validate Portfolio Charges Accrual Frequency,      *
      *            Day in Month and Next Accrual Date                 *
      *                                                               *
      *****************************************************************
      *
     C     SRAcFDN       BEGSR
      *
      ** Validate Portfolio Charges Accrual Frequency.
      *
     C                   EXSR      SRCGFQ
      *
      ** Validate Portfolio Charges Accrual Day in Month.
      *
     C                   EXSR      SRCGDY
      *
      ** Validate Portfolio Charges Next Accrual Date.
      *
     C                   EXSR      SRCGND
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCGFQ - Validate Portfolio Charges Accrual Frequency        *
      *                                                               *
      *****************************************************************
      *
     C     SRCGFQ        BEGSR
      *
     C     DDCGFQ        IFEQ      *BLANKS
      *
      ** Entry is mandatory if Charge Code has been entered.
      *
     C     DDCGCO        IFNE      *BLANKS
     C                   MOVE      'N'           OKCGFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11317'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   MOVE      'N'           WCALCULATE
      *
     C                   ELSE
      *
      ** If Accrual Frequency has been entered, entry must be
      ** 'W', 'F', 'M', 'Q', 'X' or 'Y'.
      *
     C     DDCGFQ        IFNE      'W'
     C     DDCGFQ        ANDNE     'F'
     C     DDCGFQ        ANDNE     'M'
     C     DDCGFQ        ANDNE     'Q'
     C     DDCGFQ        ANDNE     'X'
     C     DDCGFQ        ANDNE     'Y'
     C                   MOVE      'N'           OKCGFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11318'     MSGIDXAR(IDX)
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
      *  SRCGDY - Validate Portfolio Charges Accrual Day in Month     *
      *                                                               *
      *****************************************************************
      *
     C     SRCGDY        BEGSR
      *
     C     DDCGDY        IFEQ      *BLANKS
      *
      ** Accrual Day in Month must be entered if Accrual Frequency
      ** is 'M', 'Q', 'X' or 'Y'.
      *
     C     DDCGFQ        IFEQ      'M'
     C     DDCGFQ        OREQ      'Q'
     C     DDCGFQ        OREQ      'X'
     C     DDCGFQ        OREQ      'Y'
     C                   MOVE      'N'           OKCGDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11319'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Accrual Day in Month must not be entered if Accrual
      ** Frequency is not 'M', 'Q', 'X' or 'Y'.
      *
     C     DDCGFQ        IFNE      'M'
     C     DDCGFQ        ANDNE     'Q'
     C     DDCGFQ        ANDNE     'X'
     C     DDCGFQ        ANDNE     'Y'
      *
     C                   MOVE      'N'           OKCGDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11321'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
      ** Accrual Day in Month must be a number in the
      ** range 1-31.
      *
     C                   TESTN                   DDCGDY               0102
     C                   MOVE      DDCGDY        W_CGDYZ
     C                   TESTZ                   W_CGDYZ                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDCGDY        WCGDY
      *
     C     WCGDY         IFLT      1
     C     WCGDY         ORGT      31
     C                   MOVE      'N'           OKCGDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11322'     MSGIDXAR(IDX)
     C                   MOVE      'N'           WCALCULATE
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKCGDY
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGDY'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11322'     MSGIDXAR(IDX)
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
      *  SRCGND - Validate Portfolio Charges Next Accrual Date        *
      *                                                               *
      *****************************************************************
      *
     C     SRCGND        BEGSR
      *
     C     DDCGND        IFNE      *BLANKS
      *
      ** Next Accrual Date must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDCGND        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKCGND
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11323'     MSGIDXAR(IDX)
      *
     C                   goto      ESRCGND
     C                   ENDIF
      *
     C                   Z-ADD     PDAYNO        WCGND
      *
      ** Entry must not be before run date.
      *
     C     WCGND         IFLT      BJRDNB
     C                   MOVE      'N'           OKCGND
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11324'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Generate Next Accrual Date.
      *
     C     WCALCULATE    IFEQ      'Y'
      *
     C                   Z-ADD     0             ZMDAY
      *
     C                   Z-ADD     BJRDNB        ZDAYNO            5 0
     C                   MOVEL     DDCGFQ        ZFREQ             1
     C                   MOVEL     DDCGDY        ZMDAY             2 0
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
     C                   Z-ADD     ZDAYNO        WCGND
     C                   ENDIF
      *
      ** If Next Accrual Date day in month is the same as
      ** today's date, default next accrual date to run date.
      *
     C                   Z-ADD     0             WWDAY             2 0
      *
     C                   MOVEL     BJMRDT        WWDAY
     C     WCGDY         IFEQ      WWDAY
     C     DDCGDY        OREQ      *BLANKS
     C     DDCGFQ        ANDEQ     'W'
     C                   Z-ADD     BJRDNB        WCGND
     C                   ENDIF
      *
      ** Convert Next Accrual Date to screen format.
      *
     C     WCGND         IFNE      0
      *
     C                   Z-ADD     WCGND         ZDAYNO
     C                   Z-ADD     0             ZDATE             6 0
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      ZDATE         DDCGND
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRCGND       ENDSR
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
      ** Portfolio Charges Accrual Frequency
      ** - incoming
     C                   PARM                    DDCGFQ            1
      *
      ** Portfolio Charges Accrual Day in Month
      ** - incoming
     C                   PARM                    DDCGDY            2
      *
      ** Portfolio Charges Next Accrual Date
      ** - incoming
     C                   PARM                    DDCGND            6
      *
      ** Portfolio Charges Charges Code
      ** - incoming
     C                   PARM                    DDCGCO            2
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
      ** Portfolio Charges Accrual Frequency
      ** - OK indicator
     C                   PARM                    OKCGFQ            1
      *
      ** Portfolio Charges Accrual Day in Month
      ** - OK indicator
     C                   PARM                    OKCGDY            1
      *
      ** Portfolio Charges Next Accrual Date
      ** - OK indicator
     C                   PARM                    OKCGND            1
      *
      ** Portfolio Charges Accrual Frequency
      ** - for file update
     C                   PARM                    POCGFQ            1
      *
      ** Portfolio Charges Accrual Day in Month
      ** - for file update
     C                   PARM                    POCGDY
      *
      ** Portfolio Charges Next Accrual Date
      ** - for file update
     C                   PARM                    POCGND            5 0
      *
      ** Portfolio Charges Hidden Accrual Frequency
     C                   PARM                    DDCGFH            1
      *
      ** Portfolio Charges Hidden Accrual Day in Month
     C                   PARM                    DDCGDH            2
      *
      ** Portfolio Charges Hidden Next Accrual Date
     C                   PARM                    DDCGNH
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
