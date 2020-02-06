     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities read')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSRED - Securities Read                                  *
      *                                                               *
      *  Function: This module reads forwards and backwards           *
      *            through the Securities file.                       *
      *                                                               *
      *  Component of: SESECSSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE037             Date 29Apr02               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137  *CREATE    Date 07Feb00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE037 - Countervalue rounding - recompile only              *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Securities by security shortname
     FSECTY     IF   E           K DISK    INFSR(*PSSR)
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
      ** Indicator array
     D Indicators      DS                  BASED(IndicatorP)
     D  EndOfFile             10     10
     D  StrOfFile             10     10
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Pointer for the indicator array
     D IndicatorP      S               *   INZ(%Addr(*IN))
      *
      ** Parameters for ZVACTU/ZVACTBU
     D PActn           S              1A
     D PBrc            S              3A
     D PError          S              1P 0
      *
      ** Entry parameters
     D DDSESN          S             10A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D PErrMs          S              7A
     D PSeSnSel        S             10A
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
     C                   EVAL      PSeSnSel = *BLANKS
     C                   EVAL      PErrMs = *BLANKS
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Read forwards.
      *
     C                   IF        PRdFwd = 'Y'
     C                   EXSR      SRReadFwd
     C                   ELSE
      *
      ** Read backwards.
      *
     C                   IF        PRdBck = 'Y'
     C                   EXSR      SRReadBck
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Return.
      *
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *                                                               *
      *****************************************************************
 
     C     SRChkAut      BEGSR
 
     C                   CALL      'ZVACTU'
     C                   PARM      'E'           PActn
     C                   PARM      *ZERO         PError
      *
      ** Return error message.
      *
     C     PError        IFEQ      1
     C                   EVAL      PErrMs = 'FXM0292'
     C                   RETURN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadFwd - Read forwards through the securities file        *
      *                                                               *
      *****************************************************************
 
     C     SRReadFwd     BEGSR
      *
      ** Position to current record on file.
      *
     C     DDSESN        SETGT     SECTYDF
      *
      ** Read until end of file or a valid record is found.
      *
     C                   DOU       EndOfFile = True OR PError = *ZERO
 
     C                   READ      SECTYDF                                10
      *
      ** If not end of file.
     C                   IF        EndOfFile = False
      *
      ** If multi-branching, check if authorized to look at security
      ** (based on default branch).  If invalid, continue searching
      ** for until a valid record is read.
     C     BJSBRC        IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM      PDBRN         PBrc
     C                   PARM      *ZERO         PError
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
      *
      ** If end of file was encountered, report this fact.
      *
     C                   IF        EndOfFile = True
 
     C     DDSESN        IFEQ      *BLANKS
     C                   EVAL      PErrMs = 'MMM1006'
     C                   ELSE
     C                   EVAL      PErrMs = 'MMM1002'
     C                   ENDIF
      *
      ** Else, return the security shortname read.
     C                   ELSE
     C                   EVAL      PSeSnSel = SESN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadBck - Read backwards through the securities file       *
      *                                                               *
      *****************************************************************
 
     C     SRReadBck     BEGSR
      *
      ** Position to current record on file.
      *
     C     DDSESN        SETLL     SECTYDF
      *
      ** Read until start of file or a valid record is found.
      *
     C                   DOU       StrOfFile = True OR PError = *ZERO
 
     C                   READP     SECTYDF                                10
      *
      ** Record found.
      *
     C                   IF        StrOfFile = False
      *
      ** If multi-branching, check if authorized to look at security
      ** (based on default branch).  If invalid, continue searching
      ** for until a valid record is read.
      *
     C     BJSBRC        IFEQ      *BLANKS
     C                   CALL      'ZVACTBU'
     C                   PARM      'E'           PActn
     C                   PARM      PDBRN         PBrc
     C                   PARM      *ZERO         PError
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDDO
      *
      ** If start of file was encountered, report this fact.
      *
     C                   IF        StrOfFile = True
     C                   EVAL      PErrMs = 'MMM1003'
      *
      ** Else, return the security shortname read.
     C                   ELSE
     C                   EVAL      PSeSnSel = SESN
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program Initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Security shortname (file pointer)
     C                   PARM                    DDSESN
      *
      ** Read backwards
     C                   PARM                    PRdBck
      *
      ** Read forwards
     C                   PARM                    PRdFwd
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Security shortname read
     C                   PARM                    PSeSnSel
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *
      /COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      *
**  CPY@
(c) Finastra International Limited 2001
