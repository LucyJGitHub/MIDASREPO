     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas PM Validate Portfolio Pledge Start & Finish')
      *****************************************************************
      *                                                               *
      *  Midas - Portfolio Management Module                          *
      *                                                               *
      *  PMVPLPL    - Validate Portfolio Pledge Start and Finish      *
      *               Dates                                           *
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
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.02 -----------------------------------------------*
      *  Prev Amend No. CAP033  *CREATE    Date 26Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
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
     C                   Z-ADD     0             WPDGS
     C                   Z-ADD     0             WPDGF
      *
      ** Validate Pledge Start and Finish Dates.
      *
     C                   EXSR      SRPLEDATES
      *
     C     OKPDGS        IFEQ      'N'
     C     OKPDGF        OREQ      'N'
     C                   EVAL      RETCODEIN = 'ERROR'
     C                   ENDIF
      *
     C     OKPDGS        IFNE      'N'
     C                   EVAL      P1PNPDGS = WPDGS
     C                   ENDIF
      *
     C     OKPDGF        IFNE      'N'
     C                   EVAL      P1PNPDGF = WPDGF
     C                   ENDIF
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPLEDATES - Validate Pledge Start and Finish Dates          *
      *                                                               *
      *****************************************************************
      *
     C     SRPLEDATES    BEGSR
      *
      ** Validate Pledge Start Date.
      *
     C                   EXSR      SRPDGS
      *
      ** Validate Pledge Finish Date.
      *
     C                   EXSR      SRPDGF
      *
      ** Further validation of Pledge Start and Finish Dates
      ** if both are valid dates.
      *
     C     WVALIDPDGS    IFEQ      'Y'
     C     WVALIDPDGF    ANDEQ     'Y'
      *
      ** Pledge Finish Date must be after Pledge Start Date.
      *
     C     WPDGF         IFLE      WPDGS
     C                   MOVE      'N'           OKPDGF
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGF'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11211'     MSGIDXAR(IDX)
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
      *  SRPDGS - Validate Pledge Start Date                          *
      *                                                               *
      *****************************************************************
      *
     C     SRPDGS        BEGSR
      *
     C                   MOVEL     ' '           WVALIDPDGS        1
      *
     C     DDPDGS        IFNE      *BLANKS
      *
      ** If Pledge Start Date is entered, it must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDPDGS        PDATE             6
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO            5 0
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKPDGS
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGS'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11207'     MSGIDXAR(IDX)
      *
     C                   goto      ESRPDGS
     C                   ENDIF
      *
     C                   MOVE      PDAYNO        WPDGS             5 0
      *
     C                   MOVEL     'Y'           WVALIDPDGS
      *
      ** Pledge Start Date cannot be before Date Portfolio Opened.
      *
     C     WPDGS         IFLT      OP1PNDPOP
     C                   MOVE      'N'           OKPDGS
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGS'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11208'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ELSE
      *
      ** If Pledge Start Date is not entered, error if Pledge Finish
      ** Date is entered.
      *
     C     DDPDGF        IFNE      *BLANKS
     C                   MOVE      'N'           OKPDGS
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGS'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11209'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRPDGS       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRPDGF - Validate Pledge Finish Date                         *
      *                                                               *
      *****************************************************************
      *
     C     SRPDGF        BEGSR
      *
     C                   MOVEL     ' '           WVALIDPDGF        1
      *
     C     DDPDGF        IFNE      *BLANKS
      *
      ** If Pledge Finish Date is entered, it must be a valid date.
      *
     C                   Z-ADD     0             PDAYNO
      *
     C                   CALLB     'ZAVDATE'
     C                   PARM      *BLANK        RETCODEOUT
     C                   PARM      DDPDGF        PDATE
     C                   PARM                    BJDFIN
     C                   PARM                    PDAYNO
      *
     C     RETCODEOUT    IFEQ      'Error'
     C                   MOVE      'N'           OKPDGF
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGF'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11210'     MSGIDXAR(IDX)
      *
     C                   goto      ESRPDGF
     C                   ENDIF
      *
     C                   MOVE      PDAYNO        WPDGF             5 0
      *
     C                   MOVEL     'Y'           WVALIDPDGF
      *
     C                   ELSE
      *
      ** If Pledge Finish Date is not entered, error if Pledge Start
      ** Date is entered.
      *
     C     DDPDGS        IFNE      *BLANKS
     C                   MOVE      'N'           OKPDGF
     C                   ADD       1             IDX
     C                   MOVEL     'DDPDGF'      FLDNAMXAR(IDX)
     C                   MOVEL     'PM11206'     MSGIDXAR(IDX)
     C                   ENDIF
      *
     C                   ENDIF
      *
     C     ESRPDGF       ENDSR
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
      ** Portfolio Pledge Start Date - incoming
     C                   PARM                    DDPDGS            6
      *
      ** Portfolio Pledge Finish Date - incoming
     C                   PARM                    DDPDGF            6
      *
      ** Original Date Opened
      ** - for insert, rundate
      ** - for other action codes, value retrieved from file
     C                   PARM                    OP1PNDPOP         5 0
      *
      ** STANDING DATA
      ** =============
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
      ** Portfolio Pledge Start Date - OK indicator
     C                   PARM                    OKPDGS            1
      *
      ** Portfolio Pledge Finish Date - OK indicator
     C                   PARM                    OKPDGF            1
      *
      ** Portfolio Pledge Start Date - for file update
     C                   PARM                    P1PNPDGS          5 0
      *
      ** Portfolio Pledge Finish Date - for file update
     C                   PARM                    P1PNPDGF          5 0
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
