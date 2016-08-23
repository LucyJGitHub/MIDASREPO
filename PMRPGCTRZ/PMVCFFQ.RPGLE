     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Cash Flow Freq/Day/Dat')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVCFFQ    - Validate Portfolio Cash Flow Frequency,         *
      *               Day in Month and Next Report Date               *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Last Amend No. CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
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
      ** Portfolio Cashflow Day in Month - for file update
     D P1PNCASD        S              2S 0
      *
      ** Cashflow Day in Month work variable
     D WCASD           S              2S 0
      *
      ** Day portion of Runday
     D WDAYMRDT        S              2S 0
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
     C                   Z-ADD     0             WCASD
     C                   Z-ADD     0             WCASN             5 0
     C                   MOVE      *BLANK        W_CASDZ           1
      *
      ** Validate Portfolio Cashflow Frequency, Day in Month
      ** and Next Report Date.
      *
     C                   EXSR      SRCSHFLOW
      *
     C     OKCASF        IFEQ      'N'
     C     OKCASD        OREQ      'N'
     C     OKCASN        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKCASF        IFNE      'N'
     C                   EVAL      P1PNCASF = DDCASF
     C                   ENDIF
      *
     C     OKCASD        IFNE      'N'
     C                   EVAL      P1PNCASD = WCASD
     C                   ENDIF
      *
     C     OKCASN        IFNE      'N'
     C                   EVAL      P1PNCASN = WCASN
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCSHFLOW - Validate Portfolio Cashflow Frequency, Day in    *
      *              Month and Next Report Date                       *
      *                                                               *
      *****************************************************************
      *
     C     SRCSHFLOW     BEGSR
      *
      ** Validate Cashflow Frequency.
      *
     C                   EXSR      SRCASF
      *
      ** Validate Cashflow Day in Month.
      *
     C                   EXSR      SRCASD
      *
      ** Validate Next Report Date.
      *
     C                   EXSR      SRCASN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCASF - Validate Portfolio Cashflow Frequency               *
      *                                                               *
      *****************************************************************
      *
     C     SRCASF        BEGSR
      *
     C     DDCASF        IFNE      *BLANKS
      *
      ** Entry must be 'W' if Cashflow Day in Month is blank.
      *
     C     DDCASF        IFNE      'W'
     C     DDCASD        ANDEQ     *BLANKS
      *
     C                   MOVE      'N'           OKCASF
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASF'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11234'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDCASF        IFNE      'W'
     C     DDCASF        ANDNE     'M'
     C     DDCASF        ANDNE     'Q'
     C     DDCASF        ANDNE     'X'
     C     DDCASF        ANDNE     'Y'
      *
     C                   MOVE      'N'           OKCASF
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASF'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11235'     MSGIDXAR(IDX)
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
      *  SRCASD - Validate Portfolio Cashflow Day in Month            *
      *                                                               *
      *****************************************************************
      *
     C     SRCASD        BEGSR
      *
     C     DDCASD        IFNE      *BLANKS
      *
      ** Cashflow Day in Month must not be entered if Cashflow
      ** Frequency is not supplied.
      *
     C     DDCASF        IFEQ      *BLANKS
     C                   MOVE      'N'           OKCASD
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASD'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11236'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** It must be in the range 1 - 31.
      *
     C                   TESTN                   DDCASD               0102
     C                   MOVE      DDCASD        W_CASDZ
     C                   TESTZ                   W_CASDZ                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDCASD        WCASD
      *
     C     WCASD         IFLT      1
     C     WCASD         ORGT      31
     C                   MOVE      'N'           OKCASD
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASD'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11237'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKCASD
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASD'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11237'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** Entry must be blank if Cashflow Frequency is 'W'.
      *
     C     DDCASF        IFEQ      'W'
     C                   MOVE      'N'           OKCASD
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASD'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11240'     MSGIDXAR(IDX)
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
      *  SRCASN - Validate Portfolio Next Report Date                 *
      *                                                               *
      *****************************************************************
      *
     C     SRCASN        BEGSR
      *
     C     DDCASN        IFNE      *BLANKS
      *
      ** Next Report Date must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDCASN        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKCASN
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11238'     MSGIDXAR(IDX)
      *
     C                   goto      ESRCASN
     C                   ENDIF
      *
     C                   Z-ADD     PDAYNO        WCASN
      *
      ** Entry must not be before rundate.
      *
     C     WCASN         IFLT      BJRDNB
     C                   MOVE      'N'           OKCASN
     C                   ADD       1             IDX
     C                   MOVEL     'DDCASN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11239'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Determine Next Report Date from rundate based on Cashflow
      ** Frequency and Day in Month if there is no entry for this
      ** field.
      *
     C     DDCASF        IFNE      *BLANKS
     C     DDCASD        ANDNE     *BLANKS
     C     OKCASF        ANDEQ     'Y'
     C     OKCASD        ANDEQ     'Y'
      *
     C                   MOVEL     BJMRDT        WDAYMRDT
      *
      ** If Cashflow Day in Month is equal to Day of rundate,
      ** default Next Report Date to rundate.
      *
     C     WCASD         IFEQ      WDAYMRDT
      *
     C                   Z-ADD     BJRDNB        WCASN
      *
     C                   ELSE
      *
      ** Calculate Next Report Date.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO            5 0
     C                   MOVEL     DDCASF        ZFREQ             1
     C                   MOVE      WCASD         ZMDAY             2 0
     C                   MOVEL     BJLCCY        ZCCY              3
      *
     C                   CALLB     'ZFRQA'
     C                   PARM                    ZFREQ
     C                   PARM                    ZDAYNO
     C                   PARM                    ZMDAY
     C                   PARM                    ZCCY
     C                   PARM      *BLANKS       ZLOC              3
     C                   PARM                    BJDFIN
      *
     C                   Z-ADD     ZDAYNO        WCASN
      *
     C                   ENDIF
      *
      ** Convert Next Report Date to screen format.
      *
     C                   MOVE      WCASN         ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      ZDATE         DDCASN
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRCASN       ENDSR
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
      ** Return Code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Cashflow Frequency - incoming
     C                   PARM                    DDCASF            1
      *
      ** Portfolio Cashflow Day in Month - incoming
     C                   PARM                    DDCASD            2
      *
      ** Portfolio Next Report Date - incoming
     C                   PARM                    DDCASN            6
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
      ** SDBANK - Local Currency Code
     C                   PARM                    BJLCCY            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Cashflow Frequency - OK indicator
     C                   PARM                    OKCASF            1
      *
      ** Portfolio Cashflow Day in Month - OK indicator
     C                   PARM                    OKCASD            1
      *
      ** Portfolio Next Report Date - OK indicator
     C                   PARM                    OKCASN            1
      *
      ** Portfolio Cashflow Frequency - for file update
     C                   PARM                    P1PNCASF          1
      *
      ** Portfolio Cashflow Day in Month - for file update
     C                   PARM                    P1PNCASD
      *
      ** Portfolio Next Report Date - for file update
     C                   PARM                    P1PNCASN          5 0
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
(c) Misys International Banking Systems Ltd. 2001
