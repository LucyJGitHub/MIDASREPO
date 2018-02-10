     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Date Closed')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVPODT   - Validate Portfolio Date Closed                   *
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
      *  Prev Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     FSESCFAPD  IF   E           K DISK    INFSR(*PSSR)
     FSEOCFSL3  IF   E           K DISK    INFSR(*PSSR)
     FPMCHRGL1  IF   E           K DISK    INFSR(*PSSR)
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
      ** Index for arrays of error message ids, etc.
     D IDX             S              3P 0
      *
      ** Index for arrays of warning message ids, etc.
     D WIX             S              3P 0
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
     C                   MOVE      *BLANK        WFLDNMXAR
     C                   MOVE      *BLANK        WMSGIDXAR
     C                   MOVE      *BLANK        WMSGDTXAR
     C                   Z-ADD     0             IDX
     C                   Z-ADD     0             WIX
      *
     C                   Z-ADD     0             WDPCL
      *
      ** Validate Date Closed.
      *
     C                   EXSR      SRDPCL
      *
     C     OKDPCL        IFEQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ELSE
     C                   EVAL      P1PNDPCL = WDPCL
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDPCL - Validate Portfolio Date Closed                      *
      *                                                               *
      *****************************************************************
      *
     C     SRDPCL        BEGSR
      *
      ** Entry is not allowed if action is not Closure.
      *
     C     DDDPCL        IFNE      *BLANKS
     C     DDACTN        ANDNE     'C'
      *
     C                   MOVE      'N'           OKDPCL
     C                   ADD       1             IDX
     C                   MOVEL     'DDDPCL'      FLDNAMXAR(IDX)
     C                   MOVEL     'PMA1005'     MSGIDXAR(IDX)
      *
     C                   goto      ESRDPCL
     C                   ENDIF
      *
      ** Do further validation for closure if entry is not blank.
      *
     C     DDDPCL        IFNE      *BLANKS
      *
     C                   EXSR      SREXTDPCL
     C                   ENDIF
      *
     C     ESRDPCL       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREXTDPCL - Additional Validation for Portfolio Date Closed  *
      *                                                               *
      *****************************************************************
      *
     C     SREXTDPCL     BEGSR
      *
      ** it must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDDPCL        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKDPCL
     C                   ADD       1             IDX
     C                   MOVEL     'DDDPCL'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11226'     MSGIDXAR(IDX)
      *
     C                   goto      ESREXTDPCL
     C                   ENDIF
      *
     C                   MOVE      PDAYNO        WDPCL             5 0
      *
      ** it must be equal to run date.
      *
     C     WDPCL         IFNE      BJRDNB
     C                   MOVE      'N'           OKDPCL
     C                   ADD       1             IDX
     C                   MOVEL     'DDDPCL'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11227'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** it must not be before Date Portfolio Opened.
      *
     C     WDPCL         IFLE      OP1PNDPOP
     C                   MOVE      'N'           OKDPCL
     C                   ADD       1             IDX
     C                   MOVEL     'DDDPCL'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11228'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** it must not be before Pledge Finish Date
      *
     C     OP1PNPDGF     IFNE      0
     C     WDPCL         ANDLT     OP1PNPDGF
     C                   MOVE      'N'           OKDPCL
     C                   ADD       1             IDX
     C                   MOVEL     'DDDPCL'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11232'     MSGIDXAR(IDX)
     C                   ENDIF
      *
      ** If no errors occurred, WARNING if Portfolio Definition has
      ** Accruals or Outstanding Settlements.
      *
     C     OKDPCL        IFNE      'N'
     C                   EXSR      SRWARNDPCL
     C                   ENDIF
      *
     C     ESREXTDPCL    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRWARNDPCL - Check if Portfolio Definition has Accruals or   *
      *               Outstanding Settlements                         *
      *                                                               *
      *****************************************************************
      *
     C     SRWARNDPCL    BEGSR
      *
      ** Update key fields.
      *
     C                   MOVE      BBBRCD        KBRCA
     C                   MOVEL     DDCSNM        KCNUM
     C                   MOVE      DDPREF        KPREF
      *
      ** Send a WARNING message if Accruals or Outstanding
      ** Settlements remain on it.
      *
     C     WKEY1         CHAIN     SESCFAPD                           01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     SDCFAC        IFNE      0
     C     SDOSAJ        ORNE      0
      *
     C                   MOVE      'W'           OKDPCL
     C                   ADD       1             WIX
     C                   MOVEL     'DDDPCL'      WFLDNMXAR(WIX)
     C                   MOVEL     'PM11252'     WMSGIDXAR(WIX)
     C                   MOVE      '1'           *IN01
     C                   ELSE
      *
     C     WKEY1         READE     SESCFAPD                               01
     C                   ENDIF
     C                   ENDDO
      *
     C     WKEY2         CHAIN     SEOCFSL3                           01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     SECFAC        IFNE      0
      *
     C                   MOVE      'W'           OKDPCL
     C                   ADD       1             WIX
     C                   MOVEL     'DDDPCL'      WFLDNMXAR(WIX)
     C                   MOVEL     'PM11252'     WMSGIDXAR(WIX)
     C                   MOVE      '1'           *IN01
     C                   ELSE
      *
     C     WKEY2         READE     SEOCFSL3                               01
     C                   ENDIF
     C                   ENDDO
      *
     C     WKEY2         CHAIN     PMCHRGL1                           01
      *
     C     *IN01         DOWEQ     '0'
      *
     C     POCGAJ        IFNE      0
     C     POCGAD        ORNE      0
      *
     C                   MOVE      'W'           OKDPCL
     C                   ADD       1             WIX
     C                   MOVEL     'DDDPCL'      WFLDNMXAR(WIX)
     C                   MOVEL     'PM11253'     WMSGIDXAR(WIX)
     C                   MOVE      '1'           *IN01
     C                   ELSE
      *
     C     WKEY2         READE     PMCHRGL1                               01
     C                   ENDIF
     C                   ENDDO
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
      ** Portfolio Date Closed - incoming
     C                   PARM                    DDDPCL            6
      *
      ** Action Code - incoming
     C                   PARM                    DDACTN            1
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP         5 0
      *
      ** Original Pledge Finish Date
     C                   PARM                    OP1PNPDGF         5 0
      *
      ** Customer Number - incoming
     C                   PARM                    DDCSNM           10
      *
      ** Portfolio Reference - incoming
     C                   PARM                    DDPREF            4
      *
      ** SDCUST - Branch Code of incoming customer
     C                   PARM                    BBBRCD            3
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
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFLDNMXAR
     C                   PARM                    WMSGIDXAR
     C                   PARM                    WMSGDTXAR
      *
      ** Portfolio Date Closed - OK indicator
     C                   PARM                    OKDPCL            1
      *
      ** Portfolio Date Closed - for file update
     C                   PARM                    P1PNDPCL          5 0
      *
     C     WKEY1         KLIST
     C                   KFLD                    KBRCA             3
     C*****              KFLD                    KCNUM             6 0                        CSD027
     C                   KFLD                    KCNUM             6                          CSD027
     C                   KFLD                    KPREF             4
      *
     C     WKEY2         KLIST
     C                   KFLD                    KCNUM
     C                   KFLD                    KPREF
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
