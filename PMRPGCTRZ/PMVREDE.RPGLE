     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Performnce Rpt Details')   *
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVREDE    - Validate Portfolio Performance Report           *
      *               Requirements:                                   *
      *               - Report Past Year Performance ?                *
      *               - Tax Year Start Month                          *
      *               - Additional Performance Period                 *
      *               - Performance Start Date                        *
      *               - Performance Net/Gross of Tax                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *    This source is centrally supported and must ONLY be        *
      *    amended by Core Development Personnel.                     *
      *                                                               *
      *    /COPY, Client or Country amendments must not be            *
      *    applied to this source.                                    *
      *                                                               *
      *  Last Amend No. CLE148             Date 23Jul12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CLE148 - Alpha Loan Reference (Recompile)                    *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
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
     FPMPSTMQ0  IF   E           K DISK    INFSR(*PSSR)
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
      ** DDMMYY Date format
     D WDDMMYY         DS             6
     D   WDDMMDAY              1      2  0
     D   WDDMMMTH              3      4  0
     D   WDDMMYR               5      6  0
      *
      ** MMDDYY Date format
     D WMMDDYY         DS             6
     D   WMMDDMTH              1      2  0
     D   WMMDDDAY              3      4  0
     D   WMMDDYR               5      6  0
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D IDX             S              3P 0
      *
      ** Tax Year Start Month
     D P1PNTYSM        S              2S 0
      *
      ** Date work variable
     D WWDATE          S              6S 0
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
     C                   Z-ADD     0             WTYSM             2 0
     C                   Z-ADD     0             WPSDT             5 0
     C                   MOVE      *BLANK        W_TYSMZ           1
      *
      ** Validate Performance Report Requirements.
      *
     C                   EXSR      SRPERFORM
      *
     C     OKRPYP        IFEQ      'N'
     C     OKTYSM        OREQ      'N'
     C     OKADPP        OREQ      'N'
     C     OKPSDT        OREQ      'N'
     C     OKPMNG        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKRPYP        IFNE      'N'
     C                   EVAL      P1PNRPYP = DDRPYP
     C                   ENDIF
      *
     C     OKTYSM        IFNE      'N'
     C                   MOVE      WTYSM         P1PNTYSM
     C                   ENDIF
      *
     C     OKADPP        IFNE      'N'
     C                   EVAL      P1PNADPP = DDADPP
     C                   ENDIF
      *
     C     OKPSDT        IFNE      'N'
     C                   EVAL      P1PNPSDT = WPSDT
     C                   ENDIF
      *
     C     OKPMNG        IFNE      'N'
     C                   EVAL      P1PNPMNG = DDPMNG
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPERFORM - Validate Portfolio Performance Report            *
      *              Requirements                                     *
      *                                                               *
      *****************************************************************
      *
     C     SRPERFORM     BEGSR
      *
      ** Validate Report Past Year Performance.
      *
     C                   EXSR      SRRPYP
      *
      ** Validate Tax Year Start Month.
      *
     C                   EXSR      SRTYSM
      *
      ** Validate Additional Performance Period.
      *
     C                   EXSR      SRADPP
      *
      ** If no errors in the validation of Performance Periods,
      ** validate Performance Start Date.
      *
     C     OKRPYP        IFNE      'N'
     C     OKTYSM        ANDNE     'N'
     C     OKADPP        ANDNE     'N'
      *
     C                   EXSR      SRPSDT
     C                   ENDIF
      *
      ** Validate Performance Net/Gross of Tax.
      *
     C                   EXSR      SRPMNG
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRPYP - Validate Portfolio Report Past Year Performance     *
      *                                                               *
      *****************************************************************
      *
     C     SRRPYP        BEGSR
      *
     C     DDRPYP        IFNE      'Y'
     C     DDRPYP        ANDNE     'N'
     C                   MOVE      'N'           OKRPYP
     C                   ADD       1             IDX
     C                   MOVEL     'DDRPYP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11271'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRTYSM - Validate Portfolio Tax Year Start Month             *
      *                                                               *
      *****************************************************************
      *
     C     SRTYSM        BEGSR
      *
     C     DDTYSM        IFNE      *BLANKS
      *
      ** Tax Year Start Month must be in the range 01 - 12.
      *
     C                   TESTN                   DDTYSM               0102
     C                   MOVE      DDTYSM        W_TYSMZ
     C                   TESTZ                   W_TYSMZ                  03
      *
     C     *IN01         IFEQ      '1'
     C     *IN03         ANDEQ     '1'
     C     *IN02         OREQ      '1'
     C     *IN03         ANDEQ     '1'
      *
     C                   MOVE      DDTYSM        WTYSM
      *
     C     WTYSM         IFLT      01
     C     WTYSM         ORGT      12
     C                   MOVE      'N'           OKTYSM
     C                   ADD       1             IDX
     C                   MOVEL     'DDTYSM'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11254'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
     C                   MOVE      'N'           OKTYSM
     C                   ADD       1             IDX
     C                   MOVEL     'DDTYSM'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11254'     MSGIDXAR(IDX)
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
      *  SRADPP - Validate Portfolio Additional Performance Period    *
      *                                                               *
      *****************************************************************
      *
     C     SRADPP        BEGSR
      *
     C     DDADPP        IFNE      *BLANKS
      *
      ** If Additional Performance Period is entered, entry must
      ** 'H' or 'Q'.
      *
     C     DDADPP        IFNE      'H'
     C     DDADPP        ANDNE     'Q'
     C                   MOVE      'N'           OKADPP
     C                   ADD       1             IDX
     C                   MOVEL     'DDADPP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11255'     MSGIDXAR(IDX)
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
      *  SRPSDT - Validate Portfolio Performance Start Date           *
      *                                                               *
      *****************************************************************
      *
     C     SRPSDT        BEGSR
      *
      ** If a Performance Period has been selected, entry is
      ** mandatory.
      *
     C     DDRPYP        IFEQ      'Y'
     C     DDTYSM        ORNE      *BLANKS
     C     DDADPP        OREQ      'Q'
     C     DDADPP        OREQ      'H'
      *
     C     DDPSDT        IFEQ      *BLANKS
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11256'     MSGIDXAR(IDX)
      *
      ** No further validation is necessary if field is in error.
      *
     C                   goto      ESRPSDT
     C                   ENDIF
     C                   ENDIF
      *
      ** If no Performance Period has been selected, Performance
      ** Start Date must be blank.
      *
     C     DDRPYP        IFEQ      'N'
     C     DDTYSM        ANDEQ     *BLANKS
     C     DDADPP        ANDEQ     *BLANKS
      *
     C     DDPSDT        IFNE      *BLANKS
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11272'     MSGIDXAR(IDX)
      *
      ** No further validation is necessary if field is in error.
      *
     C                   goto      ESRPSDT
     C                   ENDIF
      *
      ** If no entry, default Performance Start Date to 99999
      ** and bypass remaining validation for this field.
      *
     C                   Z-ADD     99999         WPSDT
     C                   goto      ESRPSDT
     C                   ENDIF
      *
      ** If entry is mandatory and has been supplied, it must
      ** be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDPSDT        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11257'     MSGIDXAR(IDX)
      *
      ** No further validation is necessary if field is in error.
      *
     C                   goto      ESRPSDT
     C                   ENDIF
      *
     C                   Z-ADD     PDAYNO        WPSDT
      *
      ** For insert, entry must be greater than or equal to
      ** rundate (or Date Opened).
      *
     C     DDACTN        IFEQ      'I'
      *
     C     WPSDT         IFLT      BJRDNB
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11267'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** No further validation is necessary.
      *
     C                   goto      ESRPSDT
     C                   ENDIF
      *
      ** For Amend, validate Performance Start Date if it has
      ** been changed.
      *
     C     DDACTN        IFEQ      'A'
     C     WPSDT         ANDNE     OP1PNPSDT
      *
      ** Entry must not be less than rundate.
      *
     C     WPSDT         IFLT      BJRDNB
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11260'     MSGIDXAR(IDX)
      *
      ** No further validation is necessary.
      *
     C                   goto      ESRPSDT
     C                   ENDIF
      *
      ** Entry can be during current month if Performance is not
      ** yet active during this month.
      *
     C     WPSDT         IFLE      WENDMTH
      *
     C                   MOVEL     DDPSDT        WAPSDT            4
     C                   MOVEL     DDCSNM        KCNUM
     C                   MOVE      DDPREF        KPTFR
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     WAPSDT        KMTH
     C                   ELSE
     C                   MOVE      WAPSDT        KMTH
     C                   ENDIF
      *
     C     WKEY          CHAIN     PMPSTMQ0                           01
      *
     C     *IN01         IFEQ      '0'
     C                   MOVE      'N'           OKPSDT
     C                   ADD       1             IDX
     C                   MOVEL     'DDPSDT'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11260'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRPSDT       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPMNG - Validate Portfolio Performance Net/Gross of Tax     *
      *                                                               *
      *****************************************************************
      *
     C     SRPMNG        BEGSR
      *
      ** If Performance Net/Gross of Tax is entered, it must be
      ** 'N' or 'G'.
      *
     C     DDPMNG        IFNE      *BLANKS
      *
     C     DDPMNG        IFNE      'N'
     C     DDPMNG        ANDNE     'G'
     C                   MOVE      'N'           OKPMNG
     C                   ADD       1             IDX
     C                   MOVEL     'DDPMNG'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11258'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Entry is mandatory if one of the Performance Periods
      ** has been defined.
      *
     C     DDRPYP        IFEQ      'Y'
     C     DDTYSM        ORNE      *BLANKS
     C     DDADPP        OREQ      'H'
     C     DDADPP        OREQ      'Q'
      *
     C                   MOVE      'N'           OKPMNG
     C                   ADD       1             IDX
     C                   MOVEL     'DDPMNG'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11269'     MSGIDXAR(IDX)
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
      ** Portfolio Report Past Year Performance - incoming
     C                   PARM                    DDRPYP            1
      *
      ** Portfolio Tax Year Start Month - incoming
     C                   PARM                    DDTYSM            2
      *
      ** Portfolio Additional Performance Period - incoming
     C                   PARM                    DDADPP            1
      *
      ** Portfolio Performance Start Date - incoming
     C                   PARM                    DDPSDT            6
      *
      ** Portfolio Performance Net/Gross of Tax - incoming
     C                   PARM                    DDPMNG            1
      *
      ** Action Code - incoming
     C                   PARM                    DDACTN            1
      *
      ** Customer - incoming
     C                   PARM                    DDCSNM           10
      *
      ** Portfolio Reference - incoming
     C                   PARM                    DDPREF            4
      *
      ** Original Performance Start Date
     C                   PARM                    OP1PNPSDT         5 0
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System Rundate
     C                   PARM                    BJRDNB            5 0
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Report Past Year Performance - OK indicator
     C                   PARM                    OKRPYP            1
      *
      ** Portfolio Tax Year Start Month - OK indicator
     C                   PARM                    OKTYSM            1
      *
      ** Portfolio Additional Performance Period - OK indicator
     C                   PARM                    OKADPP            1
      *
      ** Portfolio Performance Start Date - OK indicator
     C                   PARM                    OKPSDT            1
      *
      ** Portfolio Performance Net/Gross of Tax - OK indicator
     C                   PARM                    OKPMNG            1
      *
      ** Portfolio Report Past Year Performance - for file update
     C                   PARM                    P1PNRPYP          1
      *
      ** Portfolio Tax Year Start Month - for file update
     C                   PARM                    P1PNTYSM
      *
      ** Portfolio Additional Performance Period - for file update
     C                   PARM                    P1PNADPP          1
      *
      ** Portfolio Performance Start Date - for file update
     C                   PARM                    P1PNPSDT          5 0
      *
      ** Portfolio Performance Net/Gross of Tax - for file update
     C                   PARM                    P1PNPMNG          1
      *
      ** Calculate end of the current month.
      *
     C                   MOVE      BJRDNB        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      ZDATE         WMMDDYY
     C                   Z-ADD     WMMDDMTH      WMONTH            2 0
     C                   Z-ADD     WMMDDYR       WYEAR             2 0
     C                   ELSE
     C                   MOVE      ZDATE         WDDMMYY
     C                   Z-ADD     WDDMMMTH      WMONTH
     C                   Z-ADD     WDDMMYR       WYEAR
     C                   ENDIF
      *
      ** Set date to first day of next month.
      *
     C                   Z-ADD     1             WDAY              2 0
     C                   ADD       1             WMONTH
      *
     C     WMONTH        IFEQ      13
     C                   Z-ADD     1             WMONTH
     C                   ADD       1             WYEAR
     C                   ENDIF
      *
      ** Move new values to correct date format.
      *
     C                   MOVE      *BLANKS       WWRK4             4 0
     C     BJDFIN        IFEQ      'M'
     C                   MOVE      WDAY          WWRK4
     C                   MOVEL     WMONTH        WWRK4
     C                   ELSE
     C                   MOVEL     WDAY          WWRK4
     C                   MOVE      WMONTH        WWRK4
     C                   ENDIF
      *
     C                   MOVEL     WWRK4         WDATE             6 0
     C                   MOVE      WYEAR         WDATE
      *
      ** Convert first day of next month to Midas day no.
      *
     C                   Z-ADD     0             PDAYNO
     C                   Z-ADD     WDATE         WWDATE
     C                   MOVE      WWDATE        PDATE
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM                    PDATE
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO
      *
      ** Subtract 1 day to converted date to get end of current
      ** month.
      *
     C     PDAYNO        SUB       1             WENDMTH           5 0
      *
     C     WKEY          KLIST
     C**********         KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KPTFR             4
     C                   KFLD                    KMTH              2
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
