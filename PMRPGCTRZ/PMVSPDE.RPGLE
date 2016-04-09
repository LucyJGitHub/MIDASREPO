     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Spread Details')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVSPDE    - Validate Portfolio Charges Spread and           *
      *               Spread Indicator                                *
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
      ** Portfolio Charge Codes file
     FPMCGCDPD  IF   E           K DISK    INFSR(*PSSR)
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
      ** Portfolio Charges Hidden Charge Spread
     D DDCGSH          S             13S 0
      *
      ** Portfolio Charges Charging Currency number of decimal
      ** positions
     D P1PNBCGD        S              1S 0
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
     C                   Z-ADD     0             WCGSP            14 0
      *
      ** Validate Portfolio Charges Charge Details.
      *
     C                   EXSR      SRCgSpsI
      *
     C     OKCGSP        IFEQ      'N'
     C     OKCGSI        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKCGSP        IFNE      'N'
     C                   EVAL      POCGSP = WCGSP
     C                   EVAL      DDCGSH = WCGSP
     c                   ENDIF
      *
     C     OKCGSI        IFNE      'N'
     C                   EVAL      POCGSI = DDCGSI
     c                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRCgSpsI - Validate Portfolio Charges Charge Spread Details   *
      *                                                               *
      *****************************************************************
      *
     C     SRCgSpsI      BEGSR
      *
      ** Validate Portfolio Charges Charge Spread if entered.
      *
     C     DDCGSP        IFNE      *BLANKS
     C                   EXSR      SRCGSP
     C                   ENDIF
      *
      ** Validate Portfolio Charges Charge Spread Indicator.
      *
     C                   EXSR      SRCGSI
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCGSP - Validate Portfolio Charges Charge Spread            *
      *                                                               *
      *****************************************************************
      *
     C     SRCGSP        BEGSR
      *
      ** Charge Spread may not be entered if Charge Code is blank.
      *
     C     DDCGCO        IFEQ      *BLANKS
     C                   MOVE      'N'           OKCGSP
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11309'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** Continue validation of Charge Spread entry if Charge
      ** Code has been entered and is valid.
      *
     C     DDCGCO        IFNE      *BLANKS
     C     OKCGCO2       ANDEQ     'Y'
      *
      ** Retrieve Charge Basis from Charge Codes file and
      ** calculate number of decimals and integers for rate.
      *
     C                   EXSR      SRDecP
      *
      ** Validate for flat rate.
      *
     C     P5CGBS        IFEQ      'F'
     C                   EXSR      SRCHRGFLAT
     C                   ENDIF
      *
      ** Validate for percentage rate.
      *
     C     P5CGBS        IFEQ      'P'
     C                   EXSR      SRCHRGPCENT
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
      *  SRCHRGFLAT - Validation routine for flat Charge Basis        *
      *                                                               *
      *****************************************************************
      *
     C     SRCHRGFLAT    BEGSR
      *
      ** Check that a valid amount has been input.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCGSP        ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOk          1
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   PARM                    ZADIG             2 0
      *
     C     ZALIGNOk      IFEQ      'N'
     C                   MOVE      'N'           OKCGSP
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11310'     MSGIDXAR(IDX)
      *
     C                   goto      ESRCHRGFLAT
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WCGSP
      *
      ** If Charge Spread Indicator is '-', entry must be less
      ** than or equal to the smallest of the flat charge level
      ** on Charge Codes file.
      *
     C     DDCGSI        IFEQ      '-'
      *
     C     P5FLC1        IFLT      WCGSP
     C     P5CRU1        ORNE      0
     C     P5FLC2        ANDLT     WCGSP
     C     P5CRU2        ORNE      0
     C     P5FLC3        ANDLT     WCGSP
     C     P5CRU3        ORNE      0
     C     P5FLC4        ANDLT     WCGSP
     C     P5CRU4        ORNE      0
     C     P5FLC5        ANDLT     WCGSP
     C     P5CRU5        ORNE      0
     C     P5FLC6        ANDLT     WCGSP
     C     P5CRU6        ORNE      0
     C     P5FLC7        ANDLT     WCGSP
     C     P5CRU7        ORNE      0
     C     P5FLC8        ANDLT     WCGSP
     C     P5CRU8        ORNE      0
     C     P5FLC9        ANDLT     WCGSP
     C     P5CRU9        ORNE      0
     C     P5FL10        ANDLT     WCGSP
     C     P5CR10        ORNE      0
     C     P5FL11        ANDLT     WCGSP
     C     P5CR11        ORNE      0
     C     P5FL12        ANDLT     WCGSP
     C     P5CR12        ORNE      0
     C     P5FL13        ANDLT     WCGSP
     C     P5CR13        ORNE      0
     C     P5FL14        ANDLT     WCGSP
     C     P5CR14        ORNE      0
     C     P5FL15        ANDLT     WCGSP
     C                   MOVE      'N'           OKCGSP
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11311'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRCHRGFLAT   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHRGPCENT - Validation routine for percentage Charge Basis *
      *                                                               *
      *****************************************************************
      *
     C     SRCHRGPCENT   BEGSR
      *
      ** Check that a valid amount has been input.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      DDCGSP        ZFIELD
      *
     C                   CALLB     'ZALIGN'
     C                   PARM                    ZALIGNOk
     C                   PARM                    ZFIELD
     C                   PARM                    ZADEC
     C                   PARM                    ZADIG
      *
     C     ZALIGNOk      IFEQ      'N'
     C                   MOVE      'N'           OKCGSP
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11312'     MSGIDXAR(IDX)
      *
     C                   goto      ESRCHRGPCENT
     C                   ENDIF
      *
     C                   MOVE      ZFIELD        WCGSP
      *
      ** If Charge Spread Indicator is '-', entry must be less
      ** than or equal to the smallest of the percentage level
      ** on Charge Codes file.
      *
     C     DDCGSI        IFEQ      '-'
      *
      ** First, convert percentage level fields.
      *
     C     P5PCL1        MULT      10000000      WWPCL1           14 0
     C     P5PCL2        MULT      10000000      WWPCL2           14 0
     C     P5PCL3        MULT      10000000      WWPCL3           14 0
     C     P5PCL4        MULT      10000000      WWPCL4           14 0
     C     P5PCL5        MULT      10000000      WWPCL5           14 0
     C     P5PCL6        MULT      10000000      WWPCL6           14 0
     C     P5PCL7        MULT      10000000      WWPCL7           14 0
     C     P5PCL8        MULT      10000000      WWPCL8           14 0
     C     P5PCL9        MULT      10000000      WWPCL9           14 0
     C     P5PC10        MULT      10000000      WWPC10           14 0
     C     P5PC11        MULT      10000000      WWPC11           14 0
     C     P5PC12        MULT      10000000      WWPC12           14 0
     C     P5PC13        MULT      10000000      WWPC13           14 0
     C     P5PC14        MULT      10000000      WWPC14           14 0
     C     P5PC15        MULT      10000000      WWPC15           14 0
      *
     C     WWPCL1        IFLT      WCGSP
     C     P5CRU1        ORNE      0
     C     WWPCL2        ANDLT     WCGSP
     C     P5CRU2        ORNE      0
     C     WWPCL3        ANDLT     WCGSP
     C     P5CRU3        ORNE      0
     C     WWPCL4        ANDLT     WCGSP
     C     P5CRU4        ORNE      0
     C     WWPCL5        ANDLT     WCGSP
     C     P5CRU5        ORNE      0
     C     WWPCL6        ANDLT     WCGSP
     C     P5CRU6        ORNE      0
     C     WWPCL7        ANDLT     WCGSP
     C     P5CRU7        ORNE      0
     C     WWPCL8        ANDLT     WCGSP
     C     P5CRU8        ORNE      0
     C     WWPCL9        ANDLT     WCGSP
     C     P5CRU9        ORNE      0
     C     WWPC10        ANDLT     WCGSP
     C     P5CR10        ORNE      0
     C     WWPC11        ANDLT     WCGSP
     C     P5CR11        ORNE      0
     C     WWPC12        ANDLT     WCGSP
     C     P5CR12        ORNE      0
     C     WWPC13        ANDLT     WCGSP
     C     P5CR13        ORNE      0
     C     WWPC14        ANDLT     WCGSP
     C     P5CR14        ORNE      0
     C     WWPC15        ANDLT     WCGSP
     C                   MOVE      'N'           OKCGSP
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSP'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11313'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRCHRGPCENT  ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCGSI - Validate Portfolio Charges Charge Spread Indicator  *
      *                                                               *
      *****************************************************************
      *
     C     SRCGSI        BEGSR
      *
     C     DDCGSI        IFEQ      *BLANKS
      *
      ** Charge Spread Indicator must be entered if Charge
      ** Spread has been entered.
      *
     C     DDCGSP        IFNE      *BLANKS
     C                   MOVE      'N'           OKCGSI
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSI'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11314'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Charge Spread Indicator cannot be entered if Charge
      ** Spread has not been entered.
      *
     C     DDCGSP        IFEQ      *BLANKS
     C                   MOVE      'N'           OKCGSI
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSI'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11336'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** If Charge Spread has been entered, entry must be
      ** '+' or '-'.
      *
     C     DDCGSI        IFNE      '+'
     C     DDCGSI        ANDNE     '-'
     C                   MOVE      'N'           OKCGSI
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGSI'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11315'     MSGIDXAR(IDX)
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
      *  SRDecP - Calculate number of decimals and integers           *
      *                                                               *
      *****************************************************************
      *
     C     SRDecP        BEGSR
      *
      ** Retrieve Charge Basis from Charge Codes file.
      *
     C     PMCODE        CHAIN     PMCGCDPD                           01
      *
     C     *IN01         IFEQ      '1'
     C     P5RECI        ORNE      'D'
     C                   MOVEL     DDBCGY        WKEY              5
     C                   MOVE      DDCGCO        WKEY
     C                   MOVEL     WKEY          DBKEY
     C                   MOVE      'PMCGCDPD'    DBFILE
     C                   Z-ADD     001           DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Calculate number of decimals and integers for flat rate.
      *
     C     P5CGBS        IFEQ      'F'
     C                   Z-ADD     P1PNBCGD      ZADEC
     C     13            SUB       ZADEC         ZADIG
     C                   ENDIF
      *
      ** Calculate number of decimals and integers for percentage
      ** rate.
      *
     C     P5CGBS        IFEQ      'P'
     C                   Z-ADD     7             ZADEC
     C                   Z-ADD     6             ZADIG
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
      ** Return code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Charges Charge Spread - incoming
     C                   PARM                    DDCGSP           14
      *
      ** Portfolio Charges Charge Spread Indicator - incoming
     C                   PARM                    DDCGSI            1
      *
      ** Portfolio Charges Charge Code - incoming
     C                   PARM                    DDCGCO            2
      *
      ** Portfolio Charges Charge Code - OK indicator
     C                   PARM                    OKCGCO2           1
      *
      ** Portfolio Charges Charging Currency - incoming
     C                   PARM                    DDBCGY            3
      *
      ** Portfolio Charges Charging Currency number of decimal
      ** positions - for file update
     C                   PARM                    P1PNBCGD
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charge Spread
      ** - OK indicator
     C                   PARM                    OKCGSP            1
      *
      ** Portfolio Charges Charge Spread Indicator
      ** - OK indicator
     C                   PARM                    OKCGSI            1
      *
      ** Portfolio Charges Charge Spread
      ** - for file update
     C                   PARM                    POCGSP           13 0
      *
      ** Portfolio Charges Charge Spread Indicator
      ** - for file update
     C                   PARM                    POCGSI            1
      *
      ** Portfolio Charges Hidden Charge Spread
     C                   PARM                    DDCGSH
      *
      ** Key list
      *
     C     PMCODE        KLIST
     C                   KFLD                    DDBCGY
     C                   KFLD                    DDCGCO
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
