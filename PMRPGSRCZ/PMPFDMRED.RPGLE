     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definition Read')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMRED - Portfolio Definition Read                        *
      *                                                               *
      *  Function: This module reads forwards and backwards           *
      *            through the Portfolio Definitions file.            *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD027             Date 09Dec05               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CPB002             Date 13Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CPB002 - New Private Banking Customer Processing.            *
      *           Just recompile over changes in PMPORTPD.            *
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
      ** Portfolio Definitions by customer and portfolio reference
     FPMPORTPD  IF   E           K DISK    INFSR(*PSSR)
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
      **    False      logical = *off (for indcator processing)
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
      ** Menu user
     D ZMUSER          DS            17
     D  USRBCH                11     13
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      ** Initialisation
      *
     C                   MOVEL     *BLANKS       PCNUM
     C                   MOVEL     *BLANKS       PPTFR
     C                   MOVEL     *BLANKS       PERRMS
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANK
     C                   EXSR      SRChAutN
     C                   ENDIF
      *
      ** Validate Customer and Portfolio Reference (for pointer).
      *
     C                   EXSR      SRVALKEY
      *
      ** Read forwards.
      *
     C     PRDFWD        IFEQ      'Y'
     C                   EXSR      SRRdFwd
     C                   ELSE
      *
      ** Read backwards.
      *
     C     PRDBCK        IFEQ      'Y'
     C                   EXSR      SRRdBck
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChAutN - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRChAutN      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           ZACTN             1
     C                   PARM                    P_ERR             1 0
      *
      ** Return error message.
      *
     C     P_ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRVALKEY - Validate Portfolio Definition pointer             *
      *                                                               *
      *****************************************************************
      *
     C     SRVALKEY      BEGSR
      *
     C**********         Z-ADD     *ZERO         WCSNM             6 0                        CSD027
     C                   MOVE      *BLANKS       WCSNM             6                          CSD027
     C                   MOVEL     *BLANKS       WPREF             4
      *
      ** If one of the REVIEW FROM details is entered,
      *
     C     DDPNP8        IFNE      *BLANK
     C     DDPORT        ORNE      *BLANK
      *
      ** Customer and Portfolio Reference should not be entered.
      *
     C     DDCSNM        IFNE      *BLANK
     C     DDPREF        ORNE      *BLANK
     C                   MOVEL     'PMA1007'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** REVIEW FROM Customer must not be blank.
      *
     C     DDPNP8        IFEQ      *BLANK
     C                   MOVEL     'PM11102'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Validate that the REVIEW FROM Customer entered is numeric.
      *
     C                   MOVEL     DDPNP8        WDCSNM            6
     C**********         TESTN                   WDCSNM               80                      CSD027
     C**********         MOVE      WDCSNM        W_TEST            1                          CSD027
     C**********         TESTZ                   W_TEST                   81                  CSD027
      **********                                                                              CSD027
     C******IN80         IFEQ      '1'                                                        CSD027
     C******IN81         ANDEQ     '1'                                                        CSD027
     C                   MOVEL     WDCSNM        WCSNM
     C                   MOVEL     DDPORT        WPREF
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     'PMA1006'     PERRMS                                       CSD027
     C**********         RETURN                                                               CSD027
     C**********         ENDIF                                                                CSD027
      *
     C                   ELSE
      *
      ** If REVIEW FROM details are not entered, validate
      ** Customer and Portfolio Reference if entered.
      *
     C     DDCSNM        IFNE      *BLANK
     C     DDPREF        ORNE      *BLANK
      *
      ** Customer must not be blank.
      *
     C     DDCSNM        IFEQ      *BLANK
     C                   MOVEL     'PMA1009'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
      ** Validate that the Customer entered is numeric.
      *
     C                   MOVEL     DDCSNM        WDCSNM
     C**********         TESTN                   WDCSNM               80                      CSD027
     C**********         MOVE      WDCSNM        W_TEST                                       CSD027
     C**********         TESTZ                   W_TEST                   81                  CSD027
     C                   MOVE      DDCSNM        WEXTRA            4
      *
     C     WEXTRA        IFEQ      *BLANKS
     C******IN80         ANDEQ     '1'                                                        CSD027
     C******IN81         ANDEQ     '1'                                                        CSD027
     C                   MOVEL     WDCSNM        WCSNM
     C                   MOVEL     DDPREF        WPREF
     C                   ELSE
     C                   MOVEL     'PMA1008'     PERRMS
     C                   RETURN
     C                   ENDIF
      *
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
      *  SRRdFwd - Read forwards through the Portfolio Definitions    *
      *            file                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRRdFwd       BEGSR
      *
      ** Position to current record on file.
      *
     C     KLDFCR        SETGT     PMPORTP0
      *
      ** Read until end of file or a valid record is found.
      *
     C     *IN99         DOUEQ     '1'
     C     P_ERR         OREQ      *ZERO
      *
     C                   READ      PMPORTP0                               99
      *
      ** If multi-branching, check if authorized to look at Portfolio
      ** Definition (based on branch).  If invalid, continue searching
      ** for until a valid record is read.
      *
     C     *IN99         IFEQ      '0'
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    USRBCH
     C                   PARM                    P_ERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If end of file was encountered, report this fact.
      *
     C     *IN99         IFEQ      '1'
      *
     C     DDCSNM        IFEQ      *BLANKS
     C     DDPREF        ANDEQ     *BLANKS
     C     DDPNP8        ANDEQ     *BLANKS
     C     DDPORT        ANDEQ     *BLANKS
      *
     C                   MOVEL     'FXM1006'     PERRMS
     C                   ELSE
     C                   MOVEL     'FXM1002'     PERRMS
     C                   ENDIF
      *
      ** Else, return the Portfolio Definition read.
      *
     C                   ELSE
     C                   MOVE      PNPTFR        PPTFR
     C                   MOVEL     PNCNUM        PCNUM
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdBck - Read backwards through the Portfolio Definitions   *
      *            file                                               *
      *                                                               *
      *****************************************************************
      *
     C     SRRdBck       BEGSR
      *
      ** Position to current record on file.
      *
     C     KLDFCR        SETLL     PMPORTP0
      *
      ** Read until end of file or a valid record is found.
      *
     C     *IN99         DOUEQ     '1'
     C     P_ERR         OREQ      *ZERO
      *
     C                   READP     PMPORTP0                               99
      *
      ** If multi-branching, check if authorized to look at Portfolio
      ** Definition (based on branch).  If invalid, continue searching
      ** for until a valid record is read.
      *
     C     *IN99         IFEQ      '0'
      *
     C     BJSBRC        IFEQ      *BLANK
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           ZACTN
     C                   PARM                    USRBCH
     C                   PARM                    P_ERR
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If start of file was encountered, report this fact.
      *
     C     *IN99         IFEQ      '1'
     C                   MOVEL     'FXM1003'     PERRMS
      *
      ** Else, return the Portfolio Definition read.
      *
     C                   ELSE
     C                   MOVE      PNPTFR        PPTFR
     C                   MOVEL     PNCNUM        PCNUM
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
     C                   PARM                    RetCodeIn
      *
      ** Customer (file pointer)
     C                   PARM                    DDCSNM           10
      *
      ** Portfolio Reference (file pointer)
     C                   PARM                    DDPREF            4
      *
      ** REVIEW FROM Customer (file pointer)
     C                   PARM                    DDPNP8            6
      *
      ** REVIEW FROM Portfolio Reference (file pointer)
     C                   PARM                    DDPORT            4
      *
      ** Read forwards
     C                   PARM                    PRDFWD            1
      *
      ** Read backwards
     C                   PARM                    PRDBCK            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC            3
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PERRMS            7
      *
      ** Portfolio Definition read
      ** - Customer Number and Portfolio Reference
     C                   PARM                    PCNUM             6
     C                   PARM                    PPTFR             4
      *
      ** Access data area ZMUSER to get default branch of user.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Key List
      *
     C     KLDFCR        KLIST
     C                   KFLD                    WCSNM
     C                   KFLD                    WPREF
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
