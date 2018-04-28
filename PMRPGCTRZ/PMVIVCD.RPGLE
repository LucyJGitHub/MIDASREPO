     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Invst Policy Code/Inds')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVIVCD   - Validate:                                        *
      *              - Portfolio Bank Investment Policy Code          *
      *              - Instrument Investment Policy Indicator         *
      *              - Currency Investment Policy Indicator           *
      *              - Country of Risk Investment Policy Indicator    *
      *              - Industry Investment Policy Indicator           *
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
     FPMBIPNPD  IF   E           K DISK    INFSR(*PSSR)
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
      ** Validate Portfolio Investment Policy Code and Indicators.
      *
     C                   EXSR      SRINVEST
      *
     C     OKPOLC        IFEQ      'N'
     C     OKIPIN        OREQ      'N'
     C     OKCYIN        OREQ      'N'
     C     OKYPIN        OREQ      'N'
     C     OKNPIN        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKPOLC        IFNE      'N'
     C                   EVAL      P1PNPOLC = DDPOLC
     C                   ENDIF
      *
     C     OKIPIN        IFNE      'N'
     C                   EVAL      P1PNIPIN = DDIPIN
     C                   ENDIF
      *
     C     OKCYIN        IFNE      'N'
     C                   EVAL      P1PNCYIN = DDCYIN
     C                   ENDIF
      *
     C     OKYPIN        IFNE      'N'
     C                   EVAL      P1PNYPIN = DDYPIN
     C                   ENDIF
      *
     C     OKNPIN        IFNE      'N'
     C                   EVAL      P1PNNPIN = DDNPIN
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRINVEST - Validate Portfolio Investment Policy Code and     *
      *             Indicators                                        *
      *                                                               *
      *****************************************************************
      *
     C     SRINVEST      BEGSR
      *
      ** Default Investment Policy Indicators to 'N' if these
      ** fields are blanks.
      *
     C     DDIPIN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDIPIN
     C                   ENDIF
      *
     C     DDCYIN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDCYIN
     C                   ENDIF
      *
     C     DDYPIN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDYPIN
     C                   ENDIF
      *
     C     DDNPIN        IFEQ      *BLANKS
     C                   MOVE      'N'           DDNPIN
     C                   ENDIF
      *
      ** Validate Portfolio Bank Investment Policy Code.
      *
     C                   EXSR      SRPOLC
      *
      ** Validate Instrument Investment Policy Indicator.
      *
     C                   EXSR      SRIPIN
      *
      ** Validate Currency Investment Policy Indicator.
      *
     C                   EXSR      SRCYIN
      *
      ** Validate Country of Risk Investment Policy Indicator.
      *
     C                   EXSR      SRYPIN
      *
      ** Validate Industry Investment Policy Indicator.
      *
     C                   EXSR      SRNPIN
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPOLC - Validate Portfolio Bank Investment Policy Code      *
      *                                                               *
      *****************************************************************
      *
     C     SRPOLC        BEGSR
      *
      ** Bank Investment Policy Code must not be entered if
      ** an investment policy already exists.
      *
     C     DDPOLC        IFNE      *BLANKS
      *
     C     DDIPIN        IFNE      'N'
     C     DDCYIN        ORNE      'N'
     C     DDYPIN        ORNE      'N'
     C     DDNPIN        ORNE      'N'
      *
     C                   MOVE      'N'           OKPOLC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPOLC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11220'     MSGIDXAR(IDX)
      *
     C                   IF        DDIPIN <> 'N'
     C                   MOVE      'N'           OKIPIN
     C                   ENDIF
      *
     C                   IF        DDCYIN <> 'N'
     C                   MOVE      'N'           OKCYIN
     C                   ENDIF
      *
     C                   IF        DDYPIN <> 'N'
     C                   MOVE      'N'           OKYPIN
     C                   ENDIF
      *
     C                   IF        DDNPIN <> 'N'
     C                   MOVE      'N'           OKNPIN
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Bank Investment Policy Code must be existing.
      *
     C     DDPOLC        CHAIN     PMBIPNPD                           01
      *
     C     *IN01         IFEQ      '1'
     C     PSRECI        ORNE      'D'
      *
     C                   MOVE      'N'           OKPOLC
     C                   ADD       1             IDX
     C                   MOVEL     'DDPOLC'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11221'     MSGIDXAR(IDX)
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
      *  SRIPIN - Validate Portfolio Instrument Investment Policy     *
      *           Indicator                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRIPIN        BEGSR
      *
     C     DDIPIN        IFNE      'Y'
     C     DDIPIN        ANDNE     'N'
     C     DDIPIN        ANDNE     'A'
      *
     C                   MOVE      'N'           OKIPIN
     C                   ADD       1             IDX
     C                   MOVEL     'DDIPIN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11222'     MSGIDXAR(IDX)
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCYIN - Validate Portfolio Currency Investment Policy       *
      *           Indicator                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRCYIN        BEGSR
      *
     C     DDCYIN        IFNE      'Y'
     C     DDCYIN        ANDNE     'N'
     C     DDCYIN        ANDNE     'A'
      *
     C                   MOVE      'N'           OKCYIN
     C                   ADD       1             IDX
     C                   MOVEL     'DDCYIN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11223'     MSGIDXAR(IDX)
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRYPIN - Validate Portfolio Country of Risk Investment       *
      *           Policy Indicator                                    *
      *                                                               *
      *****************************************************************
      *
     C     SRYPIN        BEGSR
      *
     C     DDYPIN        IFNE      'Y'
     C     DDYPIN        ANDNE     'N'
     C     DDYPIN        ANDNE     'A'
      *
     C                   MOVE      'N'           OKYPIN
     C                   ADD       1             IDX
     C                   MOVEL     'DDYPIN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11224'     MSGIDXAR(IDX)
      *
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRNPIN - Validate Portfolio Industry Investment Policy       *
      *           Indicator                                           *
      *                                                               *
      *****************************************************************
      *
     C     SRNPIN        BEGSR
      *
     C     DDNPIN        IFNE      'Y'
     C     DDNPIN        ANDNE     'N'
     C     DDNPIN        ANDNE     'A'
      *
     C                   MOVE      'N'           OKNPIN
     C                   ADD       1             IDX
     C                   MOVEL     'DDNPIN'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11225'     MSGIDXAR(IDX)
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
      ** Portfolio Bank Investment Policy Code - incoming
     C                   PARM                    DDPOLC            2
      *
      ** Portfolio Instrument Investment Policy Indicator - incoming
     C                   PARM                    DDIPIN            1
      *
      ** Portfolio Currency Investment Policy Indicator - incoming
     C                   PARM                    DDCYIN            1
      *
      ** Portfolio Country of Risk Investment Policy Indicator - incoming
     C                   PARM                    DDYPIN            1
      *
      ** Portfolio Industry Investment Policy Indicator - incoming
     C                   PARM                    DDNPIN            1
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Bank Investment Policy Code - OK indicator
     C                   PARM                    OKPOLC            1
      *
      ** Portfolio Instrument Investment Policy Indicator - OK indicator
     C                   PARM                    OKIPIN            1
      *
      ** Portfolio Currency Investment Policy Indicator - OK indicator
     C                   PARM                    OKCYIN            1
      *
      ** Portfolio Country of Risk Investment Policy Indicator - OK indicator
     C                   PARM                    OKYPIN            1
      *
      ** Portfolio Industry Investment Policy Indicator - OK indicator
     C                   PARM                    OKNPIN            1
      *
      ** Portfolio Bank Investment Policy Code - for file update
     C                   PARM                    P1PNPOLC          2
      *
      ** Portfolio Instrument Investment Policy Indicator - for file update
     C                   PARM                    P1PNIPIN          1
      *
      ** Portfolio Currency Investment Policy Indicator - for file update
     C                   PARM                    P1PNCYIN          1
      *
      ** Portfolio Country of Risk Investment Policy Indicator - for file update
     C                   PARM                    P1PNYPIN          1
      *
      ** Portfolio Industry Investment Policy Indicator - for file update
     C                   PARM                    P1PNNPIN          1
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
