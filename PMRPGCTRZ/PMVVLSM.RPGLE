     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Valuation Stmt Details')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVVLSM    - Validate Portfolio Valuation Statement Section  *
      *               Indicators:                                     *
      *               - (S9) Instrument Summary Section               *
      *               - (S0) Currency Summary Section                 *
      *               - (S1) Position Details                         *
      *               - (S2) Sector Breakdown                         *
      *               - (S3) Performance for Past Year                *
      *               - (S4) Tax Year to Date                         *
      *               - (S5) Additional Period                        *
      *               - (S6) Daily Cashflows                          *
      *               - (S7) Monthly Cashflows                        *
      *               - (S8) Yearly Cashflows                         *
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
      ** DS for Valuation Statement Sections S0-S9 - incoming
     D PDDSTMTS0S9     DS            10
     D   DDS9VR                1      1
     D   DDS0VR                2      2
     D   DDS1VR                3      3
     D   DDS2VR                4      4
     D   DDS3VR                5      5
     D   DDS4VR                6      6
     D   DDS5VR                7      7
     D   DDS6VR                8      8
     D   DDS7VR                9      9
     D   DDS8VR               10     10
      *
      ** DS for Valuation Statement Sections S0-S9 - OK indicators
     D POKSTMTS0S9     DS            10
     D   OKS9VR                1      1
     D   OKS0VR                2      2
     D   OKS1VR                3      3
     D   OKS2VR                4      4
     D   OKS3VR                5      5
     D   OKS4VR                6      6
     D   OKS5VR                7      7
     D   OKS6VR                8      8
     D   OKS7VR                9      9
     D   OKS8VR               10     10
      *
      ** DS for Valuation Statement Sections S1-S8 - for file update
     D PP1PNSTMTS1S8   DS             8
     D   P1PNS1VR              1      1
     D   P1PNS2VR              2      2
     D   P1PNS3VR              3      3
     D   P1PNS4VR              4      4
     D   P1PNS5VR              5      5
     D   P1PNS6VR              6      6
     D   P1PNS7VR              7      7
     D   P1PNS8VR              8      8
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
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
      ** Validate Valuation Statement Section Indicators.
      *
     C                   EXSR      SRSTMT
      *
     C     OKS9VR        IFEQ      'N'
     C     OKS0VR        OREQ      'N'
     C     OKS1VR        OREQ      'N'
     C     OKS2VR        OREQ      'N'
     C     OKS3VR        OREQ      'N'
     C     OKS4VR        OREQ      'N'
     C     OKS5VR        OREQ      'N'
     C     OKS6VR        OREQ      'N'
     C     OKS7VR        OREQ      'N'
     C     OKS8VR        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKS9VR        IFNE      'N'
     C                   EVAL      P1PNS9VR = DDS9VR
     C                   ENDIF
      *
     C     OKS0VR        IFNE      'N'
     C                   EVAL      P1PNS0VR = DDS0VR
     C                   ENDIF
      *
     C     OKS1VR        IFNE      'N'
     C                   EVAL      P1PNS1VR = DDS1VR
     C                   ENDIF
      *
     C     OKS2VR        IFNE      'N'
     C                   EVAL      P1PNS2VR = DDS2VR
     C                   ENDIF
      *
     C     OKS3VR        IFNE      'N'
     C                   EVAL      P1PNS3VR = DDS3VR
     C                   ENDIF
      *
     C     OKS4VR        IFNE      'N'
     C                   EVAL      P1PNS4VR = DDS4VR
     C                   ENDIF
      *
     C     OKS5VR        IFNE      'N'
     C                   EVAL      P1PNS5VR = DDS5VR
     C                   ENDIF
      *
     C     OKS6VR        IFNE      'N'
     C                   EVAL      P1PNS6VR = DDS6VR
     C                   ENDIF
      *
     C     OKS7VR        IFNE      'N'
     C                   EVAL      P1PNS7VR = DDS7VR
     C                   ENDIF
      *
     C     OKS8VR        IFNE      'N'
     C                   EVAL      P1PNS8VR = DDS8VR
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRSTMT - Validate Statement Section Indicators                *
      *                                                               *
      *****************************************************************
      *
     C     SRSTMT        BEGSR
      *
      ** If any of Valuation Frequency, Day in Month or
      ** Next Valuation Date is entered, Section Indicators
      ** must be entered.
      *
     C     DDVLFQ        IFNE      *BLANKS
     C     DDVLND        ORNE      *BLANKS
     C     DDVLDM        ORNE      *BLANKS
      *
     C                   EXSR      SRSECTIND1
     C                   ENDIF
      *
      ** If all Valuation Statement Date details are blank, Section
      ** Indicators must all be blank.
      *
     C     DDVLFQ        IFEQ      *BLANKS
     C     DDVLND        ANDEQ     *BLANKS
     C     DDVLDM        ANDEQ     *BLANKS
      *
     C                   EXSR      SRSECTIND2
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSECTIND1 - Check if Section Indicators are blanks          *
      *                                                               *
      *****************************************************************
      *
     C     SRSECTIND1    BEGSR
      *
     C     DDS9VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS9VR
     C                   ELSE
      *
     C     DDS9VR        IFNE      'Y'
     C     DDS9VR        ANDNE     'N'
     C                   MOVE      'N'           OKS9VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS9VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS0VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS0VR
     C                   ELSE
      *
     C     DDS0VR        IFNE      'Y'
     C     DDS0VR        ANDNE     'N'
     C                   MOVE      'N'           OKS0VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS0VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS1VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS1VR
     C                   ELSE
      *
     C     DDS1VR        IFNE      'Y'
     C     DDS1VR        ANDNE     'N'
     C                   MOVE      'N'           OKS1VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS1VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS2VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS2VR
     C                   ELSE
      *
     C     DDS2VR        IFNE      'Y'
     C     DDS2VR        ANDNE     'N'
     C                   MOVE      'N'           OKS2VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS2VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS3VR        IFEQ      *BLANKS
      *
      ** Default according to whether Report Past Year
      ** Performance is required.
      *
     C     DDRPYP        IFEQ      'Y'
     C                   MOVE      'Y'           DDS3VR
     C                   ELSE
     C                   MOVE      'N'           DDS3VR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDS3VR        IFNE      'Y'
     C     DDS3VR        ANDNE     'N'
     C                   MOVE      'N'           OKS3VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS3VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** This Section Indicator may only be set to 'Y' if
      ** field Report Past Year Performance is 'Y'.
      *
     C     DDS3VR        IFEQ      'Y'
     C     DDRPYP        ANDNE     'Y'
     C                   MOVE      'N'           OKS3VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS3VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11261'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDS4VR        IFEQ      *BLANKS
      *
      ** Default according to the value of field Tax Year
      ** Start Month.
      *
     C     DDTYSM        IFNE      *BLANKS
     C                   MOVE      'Y'           DDS4VR
     C                   ELSE
     C                   MOVE      'N'           DDS4VR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDS4VR        IFNE      'Y'
     C     DDS4VR        ANDNE     'N'
     C                   MOVE      'N'           OKS4VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS4VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** This Section Indicator may only be set to 'Y' if
      ** field Tax Year Start Month is supplied.
      *
     C     DDS4VR        IFEQ      'Y'
     C     DDTYSM        ANDEQ     *BLANKS
     C                   MOVE      'N'           OKS4VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS4VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11262'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDS5VR        IFEQ      *BLANKS
      *
      ** Default according to the value of field Additional
      ** Performance Period.
      *
     C     DDADPP        IFEQ      'Q'
     C     DDADPP        OREQ      'H'
     C                   MOVE      'Y'           DDS5VR
     C                   ELSE
     C                   MOVE      'N'           DDS5VR
     C                   ENDIF
      *
     C                   ELSE
      *
     C     DDS5VR        IFNE      'Y'
     C     DDS5VR        ANDNE     'N'
     C                   MOVE      'N'           OKS5VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS5VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** This Section Indicator may only be set to 'Y' if
      ** Additional Performance Period has been defined.
      *
     C     DDS5VR        IFEQ      'Y'
     C     DDADPP        ANDEQ     *BLANKS
     C                   MOVE      'N'           OKS5VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS5VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11263'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     DDS6VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS6VR
     C                   ELSE
      *
     C     DDS6VR        IFNE      'Y'
     C     DDS6VR        ANDNE     'N'
     C                   MOVE      'N'           OKS6VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS6VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS7VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS7VR
     C                   ELSE
      *
     C     DDS7VR        IFNE      'Y'
     C     DDS7VR        ANDNE     'N'
     C                   MOVE      'N'           OKS7VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS7VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C     DDS8VR        IFEQ      *BLANKS
     C                   MOVE      'Y'           DDS8VR
     C                   ELSE
      *
     C     DDS8VR        IFNE      'Y'
     C     DDS8VR        ANDNE     'N'
     C                   MOVE      'N'           OKS8VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS8VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSECTIND2 - Check if Section Indicators are non-blanks      *
      *                                                               *
      *****************************************************************
      *
     C     SRSECTIND2    BEGSR
      *
     C     DDS9VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS9VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS9VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS0VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS0VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS0VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS1VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS1VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS1VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS2VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS2VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS2VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS3VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS3VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS3VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS4VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS4VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS4VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS5VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS5VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS5VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS6VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS6VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS6VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS7VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS7VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS7VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C     DDS8VR        IFNE      *BLANKS
     C                   MOVE      'N'           OKS8VR
     C                   ADD       1             IDX
     C                   MOVEL     'DDS8VR'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11219'     MSGIDXAR(IDX)
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
      ** Portfolio Valuation Statement Section Indicators S0-S9
      ** - incoming
     C                   PARM                    PDDSTMTS0S9
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
      ** Portfolio Report Past Year Performance - incoming
     C                   PARM                    DDRPYP            1
      *
      ** Portfolio Tax Year Start Month - incoming
     C                   PARM                    DDTYSM            2
      *
      ** Portfolio Additional Performance Period - incoming
     C                   PARM                    DDADPP            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Valuation Statement Section Indicators S0-S9
      ** - OK indicators
     C                   PARM                    POKSTMTS0S9
      *
      ** Portfolio Instrument Summary Section (S9) - for file update
     C                   PARM                    P1PNS9VR          1
      *
      ** Portfolio Currency Summary Section (S0) - for file update
     C                   PARM                    P1PNS0VR          1
      *
      ** Portfolio Valuation Statement Section Indicators S1-S8
      ** - for file update
     C                   PARM                    PP1PNSTMTS1S8
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
