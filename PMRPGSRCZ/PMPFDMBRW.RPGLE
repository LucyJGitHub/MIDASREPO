     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Portfolio Definitions Browse')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMPFDMBRW - Portfolio Definitions Browse                     *
      *                                                               *
      *  Function: This module runs in two modes:                     *
      *            - displays a list of Portfolio Definitions for     *
      *              selection                                        *
      *            - picks off the selection made                     *
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
      ** Browse screen
     FPMPFDMBDF CF   E             WORKSTN
     F                                     SFILE(PMPFDMS0:W_RRN)
     F                                     SFILE(PMPFDMS1:W_RRN)
      *
      ** Portfolio Definitions file by front office ID
     FPMPORTL0  IF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(PMPORTP0:PMPORTX0)
      *
      ** Portfolio Definitions file by customer and portfolio reference
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
      **    True       logical = *on (for indicator processing)
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
      ** Array containing error message
     D ErrorText       S             75    DIM(3) CTDATA PERRCD(1)
      *
      ** Data area of menu user
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
     C                   EXSR      SRInit
      *
      ** Build subfile.
      *
     C     PBDSFL        IFEQ      'Y'
      *
      ** Validate Portfolio Definition key passed to this module
      ** (Customer and Portfolio Reference).
      *
     C                   EXSR      SRKEYSIN
      *
      ** If First time in or subfile by back office key was previously being
      ** run, then build subfile keyed on customer number & portfolio reference.
      ** Stay in loop while F11 toggle key is used.
      *
     C     WDEFS         IFNE      'F'
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      SRBldSfl1
      *
      ** If F11, switch to Front Office Portfolio Definitions subfile.
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      SRBldSfl2
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ELSE
      *
      ** If the subfile by Front Office Identifier was previously
      ** being run, then build subfile keyed on Front Office ID.
      ** Stay in loop while F11 toggle key is used.
      *
     C     *INKK         DOUEQ     '0'
     C                   EXSR      SRBldSfl2
      *
      ** If F11, switch to Midas Portfolio Definitions subfile.
      *
     C     *INKK         IFEQ      '1'
     C                   EXSR      SRBldSfl1
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Read subfile record.
      *
     C     PRDSFL        IFEQ      'Y'
     C                   EXSR      SRRdSflR
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
      *  SRInit - Initialisation                                      *
      *                                                               *
      *****************************************************************
      *
     C     SRInit        BEGSR
      *
      ** Clear output.
      *
     C                   MOVE      *BLANKS       PERRMS
     C                   MOVE      *BLANKS       POPSEL
     C                   MOVE      *BLANKS       PCSSEL
     C                   MOVE      *BLANKS       PPRSEL
     C                   MOVE      '0'           PINKC
     C                   MOVE      '0'           PINKL
      *
     C                   MOVEL     'N'           VALIDSELECT       1
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRKEYSIN - Validate Portfolio Definition key passed to this  *
      *             module                                            *
      *                                                               *
      *****************************************************************
      *
     C     SRKEYSIN      BEGSR
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
     c                   RETURN
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
      *
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
      *  SRBldSfl1 - Build the subfile for the browse screen          *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl1     BEGSR
      *
      ** Set flag for Midas (back) office Portfolio Definition key used.
      *
     C                   MOVE      'B'           WDEFS             1
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRChAutN
     C                   ENDIF
      *
      ** Rebuild subfile until F11 toggle is used.
      *
     C     *INKK         DOUEQ     '1'
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN             5 0
      *
      ** Clear subfile before refilling by writing control
      ** record with SFLCLR active.
      *
     C                   MOVE      '1'           *IN92
     C                   MOVE      '1'           *IN97
     C                   WRITE     PMPFDMC0
     C                   MOVE      '0'           *IN92
     C                   MOVE      '0'           *IN97
      *
      ** Set file pointer.
      *
     C     KLRVWB        SETLL     PMPORTPD
      *
      ** Read a Portfolio Definition from file.
      *
     C                   EXSR      SRRdDefs
      *
      ** If no records exist - set up an error message.
      ** Display message 'End of file reached; F15 may no
      ** longer be used' and then return.
      *
     C     W_EOF         IFEQ      'Y'
     C*****WCSNM         ANDEQ     *ZEROS                                                     CSD027
     C     WCSNM         ANDEQ     *BLANKS                                                    CSD027
     C                   MOVEL     'FXM1007'     PERRMS
     C                   MOVE      *BLANKS       DDPNP8
     C                   MOVE      *BLANKS       DDPORT
     C                   RETURN
     C                   ENDIF
      *
      ** Reset REVIEW FROM fields to first record in the
      ** subfile.
      *
     C     W_EOF         IFNE      'Y'
     C**********         Z-ADD     PNCNUM        WCSNM                                        CSD027
     C                   EVAL      WCSNM =       PNCNUM                                       CSD027
     C                   MOVEL     PNPTFR        WPREF
     C                   ENDIF
      *
      ** Reset REVIEW FROM fields.
      *
     C                   MOVEL     WCSNM         DDPNP8
     C                   MOVEL     WPREF         DDPORT
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ** While ROLLUP, build a subfile page.
      *
     C     *IN98         DOWEQ     '1'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_CNT             3 0
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     W_EOF         DOWNE     'Y'
     C     W_CNT         ANDLT     12
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_RRN
     C                   ADD       1             W_CNT
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDf
      *
      ** Write the Portfolio Definition to the subfile.
      *
     C                   MOVE      *BLANK        DDOPTN
     C                   Z-ADD     W_RRN         DDSFRN
     C                   WRITE     PMPFDMS0
      *
      ** Read next Portfolio Definition.
      *
     C                   EXSR      SRRdDefs
      *
     C                   ENDDO
      *
      ** If no records read for selection, display appropriate
      ** message on screen.
      *
     C     W_RRN         IFEQ      0
     C                   MOVEL     Errortext(3)  ERRORMSG
     C                   EVAL      *IN10 = '1'
     C                   ENDIF
      *
      ** Write subfile control until REVIEW FROM is valid or an
      ** option has been selected or ROLLUP has been pressed or
      ** F11 or F3 or F12 has been pressed.
      *
     C     ERRORMSG      DOUEQ     *BLANKS
     C     VALIDSELECT   OREQ      'Y'
     C     *IN98         OREQ      '1'
     C     *INKK         OREQ      '1'
      *
      ** If error exists (no record read or key fields in error),
      ** display error message on the screen without displaying
      ** the subfile.
      *
     C     ERRORMSG      IFNE      *BLANKS
     C                   WRITE     PMPFDMCH
     C                   MOVE      '1'           *IN92
     C                   ENDIF
      *
      ** Write the screen footer to the screen.
      *
     C                   WRITE     PMPFDMF1
     C                   MOVEL     *BLANKS       ERRORMSG
      *
      ** Write and read subfile control.  If records read, subfile is
      ** displayed.
      *
     C                   TIME                    DDTIME
     C                   EXFMT     PMPFDMC0
     C                   EVAL      *IN10 = '0'
      *
      ** If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           PINKC
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           PINKL
     C                   RETURN
     C                   ENDIF
      *
      ** Continue processing if F11/ROLLUP has not been pressed.
      *
     C     *INKK         IFEQ      '0'
     C     *IN98         ANDEQ     '0'
      *
      ** Check if an option has been selected.
      *
     C     W_RRN         IFNE      0
     C                   EXSR      SRCHKOPTION
     C                   ENDIF
      *
      ** If no option has been selected, validate key.
      *
     C     VALIDSELECT   IFEQ      'N'
     C                   EXSR      SRKEYBRW
     C                   ELSE
      *
      ** Exit module if an option has been selected.
      *
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldSfl2 - Build the subfile for the browse screen          *
      *              showing the front office transaction ID          *
      *                                                               *
      *****************************************************************
      *
     C     SRBldSfl2     BEGSR
      *
      ** Set flag for front office Portfolio Definition key used.
      *
     C                   MOVE      'F'           WDEFS
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRChAutN
     C                   ENDIF
      *
      ** Initialise subfile relative record number.
      *
     C                   Z-ADD     0             W_RRN
      *
      ** Clear subfile before refilling by writing control record
      ** with SFLCLR active.
      *
     C                   MOVE      '1'           *IN92
     C                   MOVE      '1'           *IN97
     C                   WRITE     PMPFDMC1
     C                   MOVE      '0'           *IN92
     C                   MOVE      '0'           *IN97
      *
      ** Set file pointer.
      *
     C     KLRVWB        SETLL     PMPORTPD
      *
     C                   READ      PMPORTP0                               96
      *
      ** If end of file, blank out front office field to
      ** position pointer to first record on file
      ** (keyed by Front Office Transaction ID).
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     *BLANKS       PNFRNT
     C                   ENDIF
      *
      ** Set file pointer.
      *
     C     PNFRNT        SETLL     PMPORTL0
      *
      ** Read a Portfolio Definition on file.
      *
     C                   EXSR      SRRdDefs
      *
      ** If no records exist - set up an error message.
      ** Display message 'End of file reached; F15 may no longer
      ** be used' and then return.
      *
     C     W_EOF         IFEQ      'Y'
     C                   MOVEL     'FXM1007'     PERRMS
     C                   MOVE      *BLANKS       DDPNP8
     C                   MOVE      *BLANKS       DDPORT
     C                   RETURN
      *
     C                   ELSE
      *
      ** Reset REVIEW FROM fields to first record in the
      ** subfile.
      *
     C**********         Z-ADD     PNCNUM        WCSNM                                        CSD027
     C                   EVAL      WCSNM =       PNCNUM                                       CSD027
     C                   MOVEL     PNPTFR        WPREF
     C                   ENDIF
      *
      ** Set on ROLLUP indicator to drive initial loop.
      *
     C                   MOVE      '1'           *IN98
      *
      ** While ROLLUP, build a subfile page.
      *
     C     *IN98         DOWEQ     '1'
      *
      ** Initialise count of records written to subfile page.
      *
     C                   Z-ADD     0             W_CNT
      *
      ** For each record read, write it to the subfile.
      ** Do this until end of file or the subfile page is full.
      *
     C     W_EOF         DOWNE     'Y'
     C     W_CNT         ANDLT     12
      *
      ** Increment the subfile record no. and records written fields.
      *
     C                   ADD       1             W_RRN
     C                   ADD       1             W_CNT
      *
      ** Format fields for output.
      *
     C                   EXSR      SRFmtDf
      *
      ** Write the Portfolio Definition to the subfile.
      *
     C                   MOVE      *BLANK        DDOPTN
     C                   Z-ADD     W_RRN         DDSFRN
     C                   WRITE     PMPFDMS1
      *
      ** Read a Portfolio Definition.
      *
     C                   EXSR      SRRdDefs
      *
     C                   ENDDO
      *
      ** Write the screen footer to the screen.
      *
     C                   WRITE     PMPFDMF1
      *
      ** Write and read subfile control.
      *
     C                   TIME                    DDTIME
     C                   EXFMT     PMPFDMC1
     C                   EVAL      *IN10 = '0'
      *
      ** If F3, bypass further processing.
      *
     C     *INKC         IFEQ      '1'
     C                   MOVEL     '1'           PINKC
     C                   EVAL      *INLR = *ON
     C                   RETURN
     C                   ENDIF
      *
      ** If F12, bypass further processing.
      *
     C     *INKL         IFEQ      '1'
     C                   MOVEL     '1'           PINKL
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDDO
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdSflR - Read details of the selected subfile record       *
      *                                                               *
      *****************************************************************
      *
     C     SRRdSflR      BEGSR
      *
      ** Read the subfile for selected records.
      ** Only process those for which the option field is not blank.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPTN        ORNE      *BLANK
      *
     C     WDEFS         IFNE      'F'
     C                   READC     PMPFDMS0                               99
     C                   ELSE
     C                   READC     PMPFDMS1                               99
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** Return the selected option, Customer Number and
      ** Portfolio Reference.
      *
     C     *IN99         IFNE      '1'
     C     DDOPTN        ANDNE     *BLANK
      *
     C     DDOPTN        IFEQ      'A'
     C     DDOPTN        OREQ      'E'
     C     DDOPTN        OREQ      'C'
     C                   MOVE      DDOPTN        POPSEL
     C                   ELSE
     C                   MOVE      'E'           POPSEL
     C                   ENDIF
      *
     C                   MOVEL     DDCNUM        PCSSEL
     C                   MOVE      DDPTFR        PPRSEL
      *
     C                   ENDIF
      *
     C                   ENDSR
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
     C
     C     P_ERR         IFEQ      1
     C                   MOVEL     'FXM0292'     PERRMS
     C                   MOVE      *BLANKS       DDPNP8
     C                   MOVE      *BLANKS       DDPORT
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdDefs - Read a Portfolio Definition from the file         *
      *                                                               *
      *****************************************************************
      *
     C     SRRdDefs      BEGSR
      *
      ** Reset End of File indicator.
      *
     C                   MOVE      *BLANK        W_EOF             1
      *
      ** Read the file initially - if W_EOF is set on, then the end of
      ** the file has been reached.  Read until a valid record is
      ** found or until no more records exist.
      *
     C     W_EOF         DOUEQ     'Y'
     C     P_ERR         OREQ      *ZERO
      *
      ** Read the file by Back Office or Front Office key.
      *
     C     WDEFS         IFEQ      'B'
     C                   READ      PMPORTP0                               96
     C                   ELSE
     C                   READ      PMPORTX0                               96
     C                   ENDIF
      *
      ** End of File
      *
     C     *IN96         IFEQ      '1'
     C                   MOVEL     'Y'           W_EOF
     C                   ENDIF
      *
      ** If Portfolio Definition read, check whether user can see it.
      *
     C     W_EOF         IFNE      'Y'
      *
     C     BJSBRC        IFEQ      *BLANKS
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
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRFmtDf - Format Portfolio Definition fields for browse      *
      *                                                               *
      *****************************************************************
      *
     C     SRFmtDf       BEGSR
      *
     C                   MOVE      PNFRNT        DDFRNT
      *
     C     PNRECI        IFEQ      '*'
     C                   MOVEL     'CL'          DDSTAT
     C                   ELSE
      *
     C     PNDPCL        IFNE      0
     C                   MOVEL     'CR'          DDSTAT
     C                   ELSE
     C                   MOVEL     '  '          DDSTAT
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   MOVE      PNCNUM        DDCNUM
     C                   MOVE      PNPTFR        DDPTFR
     C                   MOVE      PNPTCY        DDPCCY
     C                   MOVE      PNPTFN        DDPTFN
      *
     C     PNDPCL        IFNE      0
     C                   Z-ADD     PNDPCL        ZDAYNO
     C                   Z-ADD     0             ZDATE
      *
     C                   CALLB     'ZDATE2'
     C                   PARM                    ZDAYNO            5 0
     C                   PARM      BJDFIN        PFMT              1
     C                   PARM                    ZDATE             6 0
     C                   PARM      *BLANKS       ZADATE            7
      *
     C                   MOVE      ZDATE         DDDATE
     C                   ELSE
     C                   MOVEL     *BLANKS       DDDATE
     C                   ENDIF
      *                                                                         CPB002
     C                   MOVE      PNMGTP        DDMGTP                         CPB002
     C                   MOVE      PNINTP        DDINTP                         CPB002
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCHKOPTION - Check if an option has been selected           *
      *                                                               *
      *****************************************************************
      *
     C     SRCHKOPTION   BEGSR
      *
      ** Read subfile if an option has been selected.
      *
     C     *IN99         DOUEQ     '1'
     C     DDOPTN        ORNE      *BLANK
      *
     C                   READC     PMPFDMS0                               99
      *
     C                   ENDDO
      *
      ** Activate SFLNXTCHG for the record to be read in the
      ** get-next-changed operation.
      *
     C     *IN99         IFEQ      '0'
     C                   EVAL      *IN93 = '1'
     C                   UPDATE    PMPFDMS0
     C                   EVAL      *IN93 = '0'
     C                   WRITE     PMPFDMC0
      *
     C                   EVAL      VALIDSELECT = 'Y'
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRKEYBRW  - Validate key entered from this browse module     *
      *                                                               *
      *****************************************************************
      *
     C     SRKEYBRW      BEGSR
      *
     C                   MOVEL     *BLANKS       ERRORMSG
      *
      ** If one of the REVIEW FROM details is entered,
      *
     C     DDPNP8        IFNE      *BLANK
     C     DDPORT        ORNE      *BLANK
      *
      ** REVIEW FROM Customer must not be blank.
      *
     C     DDPNP8        IFEQ      *BLANK
      *
     C                   MOVEL     Errortext(1)  ERRORMSG
     C                   EVAL      *IN10 = '1'
      *
     C                   ELSE
      *
      ** Validate that the REVIEW FROM Customer entered is numeric.
      *
     C                   MOVEL     DDPNP8        WDCSNM
     C**********         TESTN                   WDCSNM               80                      CSD027
     C**********         MOVE      WDCSNM        W_TEST                                       CSD027
     C**********         TESTZ                   W_TEST                   81                  CSD027
      *
     C******IN80         IFEQ      '1'                                                        CSD027
     C******IN81         ANDEQ     '1'                                                        CSD027
     C                   MOVEL     WDCSNM        WCSNM
     C                   MOVEL     DDPORT        WPREF
     C**********         ELSE                                                                 CSD027
     C**********         MOVEL     Errortext(2)  ERRORMSG                                     CSD027
     C**********         EVAL      *IN10 = '1'                                                CSD027
     C**********         ENDIF                                                                CSD027
      *
     C                   ENDIF
      *
     C                   ELSE
      *
     C**********         Z-ADD     *ZERO         WCSNM                                        CSD027
     C                   EVAL      WCSNM =       *BLANKS                                      CSD027
     C                   MOVEL     *BLANKS       WPREF
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
      ** Build subfile
     C                   PARM                    PBDSFL            1
      *
      ** Read subfile record
     C                   PARM                    PRDSFL            1
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date Format
     C                   PARM                    BJDFIN            1
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT            7
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
      ** Option selected
     C                   PARM                    POPSEL            1
      *
      ** Customer Number selected
     C                   PARM                    PCSSEL           10
      *
      ** Portfolio Reference selected
     C                   PARM                    PPRSEL            4
      *
      ** Command keys
     C                   PARM                    PINKC             1
     C                   PARM                    PINKL             1
      *
      ** Access data area ZMUSER to get default branch of user.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Define key list for file PMPORTPD.
      *
     C     KLRVWB        KLIST
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
**  Array of error messages - ErrorText
REVIEW FROM Customer must be input as REVIEW FROM Portfolio entered
REVIEW FROM Customer must be a valid 6-digit input
No record found for this selection
