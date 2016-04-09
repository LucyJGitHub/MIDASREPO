     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Charges Charge Code')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVCHCD    - Validate Portfolio Charges Charge Code          *
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
     D MaxChrgArr      C                   CONST(10)
      *
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
      ** Charge Codes array
     D ChrgCodeArr     S              2    DIM(MaxChrgArr)
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
     C                   Z-ADD     1             W                 2 0
     C                   Z-ADD     1             WCHK              2 0
     C                   MOVE      'Y'           OKCGCO2
      *
      ** Validate Portfolio Charges Charge Code.
      *
     C                   EXSR      SRCGCO
      *
     C     OKCGCO        IFEQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ELSE
     C                   EVAL      POCGCO = DDCGCO
     C                   EVAL      DDCGCH = DDCGCO
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCGCO - Validate Portfolio Charges Charge Code              *
      *                                                               *
      *****************************************************************
      *
     C     SRCGCO        BEGSR
      *
     C     DDCGCO        IFNE      *BLANKS
      *
      ** If Charge Code has been entered, it must be a valid charge
      ** code on file.
      *
     C     PMCODE        CHAIN     PMCGCDPD                           01
      *
     C     *IN01         IFEQ      '1'
     C     P5RECI        ORNE      'D'
     C                   MOVE      'N'           OKCGCO
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGCO'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11305'     MSGIDXAR(IDX)
     C                   MOVE      'N'           OKCGCO2
     C                   ENDIF
      *
      ** If Charge Code has been amended, entry must be unique.
      *
     C     DDCGCO        IFNE      DDCGCH
      *
     C     *IN01         DOUEQ     '1'
     C     WCHK          ORGT      MAXCHRGARR
      *
     C     DDCGCO        LOOKUP    ChrgCodeArr(W)                         01
      *
      ** Ignore SUCCESSFUL LOOKUP if pointer is pointing to the
      ** record currently being processed.
      *
     C     *IN01         IFEQ      '1'
     C     W             ANDEQ     PCNTR
     C                   MOVE      '0'           *IN01
     C                   Z-ADD     W             WCHK
     C                   ENDIF
      *
     C                   ADD       1             WCHK
     C                   Z-ADD     WCHK          W
      *
     C                   ENDDO
      *
     C     *IN01         IFEQ      '1'
     C                   MOVE      'N'           OKCGCO
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGCO'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11306'     MSGIDXAR(IDX)
     C                   MOVE      'N'           OKCGCO2
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ELSE
      *
      ** Entry is mandatory if any charge details have been
      ** entered.
      *
     C     DDSCRN        IFNE      *BLANKS
     C                   MOVE      'N'           OKCGCO
     C                   ADD       1             IDX
     C                   MOVEL     'DDCGCO'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11308'     MSGIDXAR(IDX)
     C                   MOVE      'N'           OKCGCO2
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
      ** Return code
     C                   PARM                    RETCODEIN
      *
      ** Portfolio Charges Charge Code - incoming
     C                   PARM                    DDCGCO            2
      *
      ** Portfolio Charges Hidden Charge Code
     C                   PARM                    DDCGCH            2
      *
      ** Portfolio Charges Charging Currency - incoming
     C                   PARM                    DDBCGY            3
      *
      ** Portfolio Charges details - incoming
     C                   PARM                    DDSCRN           41
      *
      ** New Portfolio Charges details array pointer
     C                   PARM                    PCNTR             2 0
      *
      ** Charge Codes array
     C                   PARM                    ChrgCodeArr
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
      *
      ** Portfolio Charges Charge Code - OK indicator
     C                   PARM                    OKCGCO            1
      *
      ** Portfolio Charges Charge Code - for file update
     C                   PARM                    POCGCO            2
      *
      ** Portfolio Charges Charge Code - OK indicator2
     C                   PARM                    OKCGCO2           1
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
