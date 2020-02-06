     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Incoming payments read')                      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTIPAYRED - Incoming Payments Read                           *
      *                                                               *
      *  Function: This module reads forwards and backwards           *
      *            through the Incoming Payments file.                *
      *                                                               *
      *  Component of: FTIPAYSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. AR787620           Date 10Jun11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 13Jan01               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP136  *CREATE    Date 15Nov99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00039                                 *
      *             WNCPYSRC,FTH00040                                 *
      *             WNCPYSRC,FTH00041                                 *
      *             WNCPYSRC,FTH00042                                 *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CFT009 - Funds Transfer Fees and Charges (recompile)         *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Incoming Payments by Payment Reference
     FINPAY     IF   E           K DISK    INFSR(*PSSR)
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
      ** DS for Payment Reference
     D                 DS
     D WPREF                   1     15
     D  WP                     1      1
     D  WDate                  2      7
     D  WPmtRef                8     11
     D  WPmtTyp               12     13
     D  WStmTyp               14     15
     D/COPY WNCPYSRC,FTH00043
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
     D PBrca           S              3A
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
      ** Initialisation.
      *
     C                   MOVEL     *BLANKS       PPRefSel
     C                   MOVEL     *BLANKS       PErrMs
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C     BJSBRC        IFNE      *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Validate Payment Reference.
      *
     C                   EXSR      SRValRef
      *
      ** Read forwards.
      *
     C     PRdFwd        IFEQ      'Y'
     C                   EXSR      SRReadFwd
     C                   ELSE
      *
      ** Read backwards.
      *
     C     PRdBck        IFEQ      'Y'
     C                   EXSR      SRReadBck
     C                   ENDIF
      *
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
      *
     C     SRChkAut      BEGSR
      *
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PActn             1
     C                   PARM      *ZERO         PError            1 0
      *
      ** Return error message.
      *
     C     PError        IFEQ      1
     C                   MOVEL     'FTA0114'     PErrMs
     C                   RETURN
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRef - Validate Payment Reference pointer                *
      *                                                               *
      *****************************************************************
      *
     C     SRValRef      BEGSR
      *
      ** Validate if the Payment Ref is in correct format or blank.
      *
     C     DDPREF        IFNE      *BLANKS
      *
     C                   MOVE      DDPREF        WPREF
      *
     C/COPY WNCPYSRC,FTH00044
     C                   TESTN                   WDate                01
     C                   TESTN                   WPmtRef              02
     C                   TESTN                   WStmTyp              03
      *
     C     WP            IFNE      'P'
     C     WPmtTyp       ORNE      'IN'
     C     *IN01         ORNE      *ON
     C     *IN02         ORNE      *ON
     C     *IN03         ORNE      *ON
     C                   MOVEL     'FTA0108'     PErrMs
     C                   RETURN
     C                   ENDIF
     C/COPY WNCPYSRC,FTH00045
      *
     C                   ENDIF
      *
     C                   MOVE      DDPREF        KPREF            15
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadFwd - Read forwards through the Incoming Payments      *
      *              file                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRReadFwd     BEGSR
      *
      ** Position to current record on file.
      *
     C     KPREF         SETGT     INPAYDDF
      *
      ** Read until end of file or a valid record is found.
      *
     C     *IN04         DOUEQ     *ON
     C     PError        OREQ      *ZERO
      *
     C                   READ      INPAYDDF                               04
      *
      ** If not end of file.
      *
     C     *IN04         IFEQ      *OFF
      *
     C                   MOVEL     BRCA          PBrca
      *
      ** If multi-branching, check if authorized to look at Incoming
      ** Payment (based on branch).  If invalid, continue searching
      ** for until a valid record is read.
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM                    PBrca
     C                   PARM      *ZERO         PError
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If end of file was encountered, report this fact.
      *
     C     *IN04         IFEQ      *ON
      *
     C     DDPREF        IFEQ      *BLANKS
     C                   MOVEL     'FTA0117'     PErrMs
     C                   ELSE
     C                   MOVEL     'FTA0115'     PErrMs
     C                   ENDIF
      *
      ** Else, return the Payment Reference read.
      *
     C                   ELSE
     C                   MOVE      PREF          PPrefSel
     C                   ENDIF
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadBck - Read backwards through the Incoming Payments     *
      *              file                                             *
      *                                                               *
      *****************************************************************
      *
     C     SRReadBck     BEGSR
      *
      ** Position to current record on file.
      *
     C     KPREF         SETLL     INPAYDDF
      *
      ** Read until end of file or a valid record is found.
      *
     C     *IN04         DOUEQ     *ON
     C     PError        OREQ      *ZERO
      *
     C                   READP     INPAYDDF                               04
      *
      ** Record found.
      *
     C     *IN04         IFEQ      *OFF
      *
     C                   MOVEL     BRCA          PBrca
      *
      ** If multi-branching, check if authorized to look at Incoming
      ** Payment (based on branch).  If invalid, continue searching
      ** for until a valid record is read.
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM                    PBrca
     C                   PARM      *ZERO         PError
     C                   ENDIF
      *
     C                   ENDIF
      *
     C                   ENDDO
      *
      ** If start of file was encountered, report this fact.
      *
     C     *IN04         IFEQ      *ON
     C                   MOVEL     'FTA0116'     PErrMs
      *
      ** Else, return the Payment Reference read.
      *
     C                   ELSE
     C                   MOVE      PREF          PPrefSel
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
     C                   PARM                    RetCodeIn
      *
      ** Payment Reference (file pointer)
     C                   PARM                    DDPREF           15
      *
      ** Read backwards
     C                   PARM                    PRdBck            1
      *
      ** Read forwards
     C                   PARM                    PRdFwd            1
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
     C                   PARM                    PErrMs            7
      *
      ** Payment Reference read
     C                   PARM                    PPrefSel         15
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
     C/COPY WNCPYSRC,FTH00046
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
