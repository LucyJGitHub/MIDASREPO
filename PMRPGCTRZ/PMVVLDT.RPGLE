     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Valuation Freq/Day/Dat')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVVLDT    - Validate Portfolio Valuation Frequency,         *
      *               Day in Month and Next Valuation Date            *
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
      ** Portfolio Valuation Day in Month - for file update
     D P1PNVLDM        S              2S 0
      *
      ** Valuation Day in Month work variable
     D WVLDM           S              2S 0
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
     C                   Z-ADD     0             WVLDM
     C                   Z-ADD     0             WVLND             5 0
     C                   MOVE      *BLANK        W_VLDMZ           1
      *
      ** Validate Portfolio Valuation Frequency, Day in Month
      ** and Next Valuation Date.
      *
     C                   EXSR      SRVALUADET
      *
     C     OKVLFQ        IFEQ      'N'
     C     OKVLDM        OREQ      'N'
     C     OKVLND        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKVLFQ        IFNE      'N'
     C                   EVAL      P1PNVLFQ = DDVLFQ
     C                   ENDIF
      *
     C     OKVLDM        IFNE      'N'
     C                   EVAL      P1PNVLDM = WVLDM
     C                   ENDIF
      *
     C     OKVLND        IFNE      'N'
     C                   EVAL      P1PNVLND = WVLND
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALUADET - Validate Portfolio Valuation Frequency,         *
      *               Day in Month and Next Valuation Date            *
      *                                                               *
      *****************************************************************
      *
     C     SRVALUADET    BEGSR
      *
      ** Validate Valuation Frequency.
      *
     C                   EXSR      SRVLFQ
      *
      ** Validate Valuation Day in Month.
      *
     C                   EXSR      SRVLDM
      *
      ** Validate Next Valuation Date.
      *
     C                   EXSR      SRVLND
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVLFQ - Validate Portfolio Valuation Frequency              *
      *                                                               *
      *****************************************************************
      *
     C     SRVLFQ        BEGSR
      *
     C     DDVLFQ        IFNE      *BLANKS
      *
      ** Valuation Frequency must be equal to M(Monthly), Q(Quarterly),
      ** X(Semi-Annually), or Y(Yearly) if entered.
      *
     C     DDVLFQ        IFNE      'M'
     C     DDVLFQ        ANDNE     'Q'
     C     DDVLFQ        ANDNE     'X'
     C     DDVLFQ        ANDNE     'Y'
      *
     C                   MOVE      'N'           OKVLFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11213'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Valuation Frequency must not be equal to blank if
      ** Valuation Day in Month is entered.
      *
     C     DDVLDM        IFNE      *BLANKS
      *
     C                   MOVE      'N'           OKVLFQ
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLFQ'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11214'     MSGIDXAR(IDX)
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
      *  SRVLDM - Validate Portfolio Valuation Day in Month           *
      *                                                               *
      *****************************************************************
      *
     C     SRVLDM        BEGSR
      *
     C     DDVLDM        IFNE      *BLANKS
      *
      ** If Valuation Day in Month is entered, it must in the
      ** range 1 - 31.
      *
     C                   TESTN                   DDVLDM               0102
     C                   MOVE      DDVLDM        W_VLDMZ
     C                   TESTZ                   W_VLDMZ                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDVLDM        WVLDM
      *
     C     WVLDM         IFLT      1
     C     WVLDM         ORGT      31
     C                   MOVE      'N'           OKVLDM
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLDM'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11215'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKVLDM
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLDM'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11215'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Valuation Day in Month must not be equal to blanks if
      ** Valuation Frequency is entered.
      *
     C     DDVLFQ        IFNE      *BLANKS
      *
     C                   MOVE      'N'           OKVLDM
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLDM'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11212'     MSGIDXAR(IDX)
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
      *  SRVLND - Validate Portfolio Next Valuation Date              *
      *                                                               *
      *****************************************************************
      *
     C     SRVLND        BEGSR
      *
     C     DDVLND        IFNE      *BLANKS
      *
      ** Next Valuation Date must be a valid date if entered.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDVLND        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKVLND
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11216'     MSGIDXAR(IDX)
      *
     C                   goto      ESRVLND
     C                   ENDIF
      *
     C                   Z-ADD     PDAYNO        WVLND
      *
      ** Entry must not be before rundate.
      *
     C     WVLND         IFLT      BJRDNB
     C                   MOVE      'N'           OKVLND
     C                   ADD       1             IDX
     C                   MOVEL     'DDVLND'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11217'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Determine Next Valuation Date from rundate based on Valuation
      ** Frequency and Day in Month if there is no entry for this
      ** field.
      *
     C     DDVLFQ        IFNE      *BLANK
     C     DDVLDM        ANDNE     *BLANK
     C     OKVLFQ        ANDEQ     'Y'
     C     OKVLDM        ANDEQ     'Y'
      *
      ** Default Next Valuation Date to rundate if Valuation
      ** Day in Month is equal to Day portion of system runday.
      *
     C                   MOVEL     BJMRDT        WDAYMRDT
      *
      ** If Valuation Day in Month is equal to Day of rundate,
      ** default Next Valuation Date to rundate.
      *
     C     WVLDM         IFEQ      WDAYMRDT
      *
     C                   Z-ADD     BJRDNB        WVLND
      *
     C                   ELSE
      *
      ** Calculate Next Valuation Date.
      *
     C                   Z-ADD     BJRDNB        ZDAYNO            5 0
     C                   MOVEL     DDVLFQ        ZFREQ             1
     C                   MOVEL     WVLDM         ZMDAY             2 0
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
     C                   Z-ADD     ZDAYNO        WVLND
      *
     C                   ENDIF
      *
      ** Convert Next Valuation Date to screen format.
      *
     C                   Z-ADD     WVLND         ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      ZDATE         DDVLND
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRVLND       ENDSR
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
      ** Portfolio Valuation Frequency - incoming
     C                   PARM                    DDVLFQ            1
      *
      ** Portfolio Valuation Day in Month - incoming
     C                   PARM                    DDVLDM            2
      *
      ** Portfolio Next Valuation Date - incoming
     C                   PARM                    DDVLND            6
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
      ** Portfolio Valuation Frequency - OK indicator
     C                   PARM                    OKVLFQ            1
      *
      ** Portfolio Valuation Day in Month - OK indicator
     C                   PARM                    OKVLDM            1
      *
      ** Portfolio Next Valuation Date - OK indicator
     C                   PARM                    OKVLND            1
      *
      ** Portfolio Valuation Frequency - for file update
     C                   PARM                    P1PNVLFQ          1
      *
      ** Portfolio Valuation Day in Month - for file update
     C                   PARM                    P1PNVLDM
      *
      ** Portfolio Next Valuation Date - for file update
     C                   PARM                    P1PNVLND          5 0
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
