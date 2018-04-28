     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security Diary Events Read')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDERED - Security Diary Events Read                       *
      *                                                               *
      *  Function: This module reads forwards and backwards           *
      *            through the Security Diary Events file.            *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CGL031             Date 05Jul04               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *  Prev Amend No. CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CGL031 - Taxation of Savings Income (Recompile)              *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    10         Use for chaining to file                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRChkAut - Check for user authority if not multi-branching   *
      *  SRValKey - Validate Event Date                               *
      *  SRReadFwd - Read forwards through the security diary         *
      *              events file                                      *
      *  SRReadBck - Read backwards through the security diary        *
      *              events file                                      *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Security Diary Events by Security Shortname, Event Date
      ** and Event Type.
     FSEDEVL3   IF   E           K DISK    INFSR(*PSSR)
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
     D DDSDSN          S             10A
     D DDSDED          S              6A
     D DDSDET          S              2A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D BJSBRC          S              3A
     D PDBRN           S              3A
     D PErrMs          S              7A
     D PSDSN           S             10A
     D PSDED           S              6A
     D PSDET           S              2A
      *
      ** Work Variables
     D WSDED           S              5P 0
      *
      ** Parameters for ZDATE1
     D PDaynoOut       S              5P 0
     D BJDFIN          S              1A
     D PErrorFlag      S              1A
      *
      ** Parameters for ZDATE2
     D PZDate          S              6P 0
     D PZaDate         S              7A
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
      ** ¦ Initial processing is performed automatically.             ¦
      ** ¦ *INZSR is executed at program activation.                  ¦
      ** ¦                                                            ¦
      ** +------------------------------------------------------------+
      *
      *****************************************************************
      * MAIN PROCEDURE                                                *
      *****************************************************************
      *
      ** Initialisation.
      *
     C                   EVAL      PSDSN  = *BLANKS
     C                   EVAL      PSDED  = *BLANKS
     C                   EVAL      PSDET  = *BLANKS
     C                   EVAL      PErrMs = *BLANKS
      *
      ** Check for user authority to browse if not multi-branching.
      *
     C                   IF        BJSBRC <> *BLANKS
     C                   EXSR      SRChkAut
     C                   ENDIF
      *
      ** Validate event date (for pointer).
      *
     C                   EXSR      SRValKey
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
      *  SRValKey - Validate Event Date                               *
      *                                                               *
      *****************************************************************
 
     C     SRValKey      BEGSR
      *
      ** Access ZDATE1 to validate and convert date to midas day number.
      *
     C                   IF        DDSDED <> *BLANKS
      *
     C                   IF        DDSDED <> '999999'
     C                   CALLB     'ZDATE1'
     C                   PARM                    DDSDED
     C                   PARM                    PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM      *BLANKS       PErrorFlag
      *
     C                   IF        PErrorFlag = 'Y'
     C                   EVAL      PErrMs = 'SEA0380'
     C                   RETURN
     C                   ENDIF
      *
     C                   EVAL      WSDED = PDaynoOut
      *
     C                   ELSE
     C                   Z-ADD     99999         WSDED
     C                   ENDIF
      *
     C                   ELSE
     C                   Z-ADD     *ZERO         WSDED
     C                   ENDIF
      *
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadFwd - Read forwards through the security diary         *
      *              events file                                      *
      *                                                               *
      *****************************************************************
 
     C     SRReadFwd     BEGSR
      *
      ** Position to current record on file.
      *
     C     WKey1         SETGT     SEDEVL3
      *
      ** Read until end of file or a valid record is found.
      *
     C                   DOU       EndOfFile = True OR PError = *ZERO
 
     C                   READ      SEDEVL3                                10
      *
      ** If not end of file.
     C                   IF        EndOfFile = False
      *
      ** If multi-branching, check if authorized to look at security
      ** (based on default branch).  If invalid, continue searching
      ** for until a valid record is read.
     C                   IF        BJSBRC = *BLANKS
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
 
     C                   IF        DDSDSN = *BLANKS AND DDSDED = *BLANKS
     C                             AND DDSDET = *BLANKS
     C                   EVAL      PErrMs = 'MMM1006'
     C                   ELSE
     C                   EVAL      PErrMs = 'MMM1002'
     C                   ENDIF
      *
      ** Else, return the security diary event read.
      *
     C                   ELSE
      *
      ** Security shortname.
     C                   EVAL      PSDSN = SDSN
      *
      ** If event day number is 99999, set event date to '999999'.
      ** Otherwise, convert event day number to event date format.
     C                   IF        SDED = 99999
     C                   EVAL      PSDED = *ALL'9'
     C                   ELSE
 
     C                   Z-ADD     SDED          PDaynoOut
     C                   CALL      'ZDATE2'
     C                   PARM                    PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZaDate
 
     C                   MOVE      PZDate        PSDED
     C                   ENDIF
      *
      ** Event type.
     C                   EVAL      PSDET = SDET
     C                   ENDIF
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRReadBck - Read backwards through the security diary        *
      *              events file                                      *
      *                                                               *
      *****************************************************************
 
     C     SRReadBck     BEGSR
      *
      ** Position to current record on file.
      *
     C     WKey1         SETLL     SEDEVL3
      *
      ** Read until start of file or a valid record is found.
      *
     C                   DOU       StrOfFile = True OR PError = *ZERO
 
     C                   READP     SEDEVL3                                10
      *
      ** Record found.
      *
     C                   IF        StrOfFile = False
      *
      ** If multi-branching, check if authorized to look at security
      ** diary event (based on default branch). If invalid, continue
      ** searching for until a valid record is read.
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
      ** Else, return the security diary event read.
      *
     C                   ELSE
      *
      ** Security shortname.
     C                   EVAL      PSDSN = SDSN
      *
      ** If event day number is 99999, set event date to '999999'.
      ** Otherwise, convert event day number to event date format.
     C                   IF        SDED = 99999
     C                   EVAL      PSDED = *ALL'9'
     C                   ELSE
 
     C                   Z-ADD     SDED          PDaynoOut
     C                   CALL      'ZDATE2'
     C                   PARM                    PDaynoOut
     C                   PARM                    BJDFIN
     C                   PARM                    PZDate
     C                   PARM                    PZaDate
 
     C                   MOVE      PZDate        PSDED
     C                   ENDIF
      *
      ** Event type.
     C                   EVAL      PSDET = SDET
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
      ** Security Shortname
     C                   PARM                    DDSDSN
      *
      ** Event Date
     C                   PARM                    DDSDED
      *
      ** Event Type
     C                   PARM                    DDSDET
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
      ** SDBANK - Date Format Indicator
     C                   PARM                    BJDFIN
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
      ** Security Shortname Read
     C                   PARM                    PSDSN
      *
      ** Event Date
     C                   PARM                    PSDED
      *
      ** Event Type
     C                   PARM                    PSDET
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
 
      ** Key list
 
     C     Wkey1         KLIST
     C                   KFLD                    DDSDSN
     C                   KFLD                    WSDED
     C                   KFLD                    DDSDET
 
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
(c) Misys International Banking Systems Ltd. 2001
