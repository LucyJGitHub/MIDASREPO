     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Case Management Retrieve  + Actn/Key Val')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Module                                 *
      *                                                               *
      *  SDMCMGRTV - Case Management Retrieve and Action Code/Key     *
      *              Validation                                       *
      *                                                               *
      *  Function: This module retrieves held items in Compliance     *
      *            Watch Hit List File database.  As it does, it      *
      *            validates the action code and key fields.          *
      *                                                               *
      *  Component of: SDMCMGSIN                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD019             Date 02Jun03               *
      *  Prev Amend No. CSD015  *CREATE    Date 14Oct02               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD019 - Midas Compliance Watch - Entry Level Watch List     *
      *           Checking                                            *
      *  CSD015 - Midas Compliance Watch                              *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRInit    - Routine to initialise fields                     *
      *  SrValAct  - Routine to validate Action Code and Key fields   *
      *  SRValRun  - Routine to validate Action Code 'W'              *
      *  SRValUnr  - Routine to validate Action Code 'R'              *
      *  SrValTemR - Routine to validate Action Code 'X'              *
      *  SrFalsPos - Routine to validate Action Code 'Y'              *
      *  SrTruePos - Routine to validate Action Code 'Y'              *
      *  SrWLMatch - Routine to validate Action Code 'E'              *                       CSD019
      *  SRAcsSec  - Access Security Checking                         *
      *  *PSSR     - Error processing                                 *
      *  *INZSR    - Program Initialisation                           *
      *                                                               *
      *    The *INZSR subroutine will only get called automatically   *
      *    on entry to the module the first time it is run            *
      *    (unless you end the program with LR on).  Similarly        *
      *    D-spec initialisation only happens the first time.  Use    *
      *    RESET for subsequent passes.                               *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FSDCWHTL1  IF   E           K DISK    INFSR(*PSSR)
      ** Midas SD Compliance Watch Hit List(FType/Identifier/Branch)
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
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
 
      ** Held Item Details retrieved from file - file format
     D CWHTFmt       E DS                  EXTNAME(SDCWHTPD)
 
      ** Held Item Details retrieved from file - file format
      ** This DS will be passed to the calling module.
     D CrCWFilFmt    E DS                  EXTNAME(SDCWHTPD)
     D                                     PREFIX(CR:2)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Entry parameter list definition
 
      ** Input
     D PRetCodeIn      S             10A
     D PResponse       S              1A
     D PAction         S              1A
     D PFunt           S              8A
     D PIden           S             40A
     D PBrch           S              3A
 
      ** Standing Data
     D BJSBRC          S              3A
     D DBRN            S              3A
 
      ** Switchable Features                                                                  CSD019
     D CSD019          S              1A                                                      CSD019
                                                                                              CSD019
      ** Output
 
      ** Action/Key Field Error Indicators
     D OKOPTN          S              1A
     D OKITEM          S              1A
 
      ** Index for arrays of error message ids etc.
     D PIDx            S              3P 0
 
      ** Parameter list for Access Security Checking
     D PActn           S              1A
     D PError          S              1P 0
     D PBrc            S              3A
 
      ** Key Fields for SDCWHTL1
     D KFunt           S              8A
     D KIden           S             40A
     D KBrch           S              3A
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
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
 
      ** Initialise.
 
     C                   EXSR      SRInit
 
      ** Validate action code and key fields.
 
     C                   EXSR      SRValAct
 
      ** No further validation if errors occurred.
 
     C                   IF        OKOPTN = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   SELECT
 
      ** Additional validation for W (Run WL Checker)
 
     C                   WHEN      PAction = 'W'
     C                   EXSR      SRValRun
 
      ** Additional validation for R (Unrealeased)
 
     C                   WHEN      PAction = 'R'
     C                   EXSR      SRValUnr
 
      ** Additional validation for X (Temp Release)
 
     C                   WHEN      PAction = 'X'
     C                   EXSR      SRValTemR
 
      ** Additional validation for Y (False Positive)
 
     C                   WHEN      PAction = 'Y'
     C                   EXSR      SRFalsPos
 
      ** Additional validation for Z (True Positive)
 
     C                   WHEN      PAction = 'Z'
     C                   EXSR      SRTruePos
 
      ** Additional validation for E (Watch List Match)                                       CSD019
                                                                                              CSD019
     C                   WHEN      CSD019 = 'Y' AND PAction = 'E'                             CSD019
     C                   EXSR      SRWLMatch                                                  CSD019
                                                                                              CSD019
     C                   ENDSL
 
      ** No further validation if errors occurred.
 
     C                   IF        OKOPTN = 'N' OR OKITEM = 'N'
     C                   RETURN
     C                   ENDIF
 
     C                   EVAL      CrCWFilFmt = CWHTFmt
 
      ** Access security checking.
 
     C                   IF        PResponse = 'S'
     C                   EXSR      SRAcsSec
     C                   ENDIF
 
      ** Return.
 
     C                   RETURN
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInit - Routine to initialise fields                        *
      *                                                               *
      *****************************************************************
     C     SRInit        BEGSR
 
      ** Initialise output fields.
 
     C                   CLEAR                   CrCWFilFmt
     C                   EVAL      CrLWCD = *ZERO
 
     C                   CLEAR                   CWHTFmt
     C                   EVAL      W3LWCD = *ZERO
 
     C                   MOVEL     'Y'           OKOPTN
     C                   MOVEL     'Y'           OKITEM
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValAct - Routine to validate Action Code and Key fields    *
      *                                                               *
      *****************************************************************
     C     SrValAct      BEGSR
 
      ** Error if action code is not W(Run WL Checker), R(Unreleased),
      ** X(Temp Release), Y(False Positive) and Z(True Positive)
 
     C                   IF        PAction <> 'W' AND PAction <> 'R' AND
     C                             PAction <> 'X' AND PAction <> 'Y' AND
     C                             PAction <> 'Z'
                                                                                              CSD019
      ** E(Watch List Match) is a valid action code if Midas Compliance                       CSD019
      ** Watch - Entry Level Watch List Checking (CSD019) is installed.                       CSD019
                                                                                              CSD019
     C                   IF        CSD019 = 'Y' AND PAction = 'E'                             CSD019
     C                   LEAVESR                                                              CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   EVAL      OKOPTN = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
                                                                                              CSD019
     C                   IF        CSD019 = 'Y'                                               CSD019
     C                   EVAL      MsgIdArr(PIdx) = 'USR9162'                                 CSD019
     C                   ELSE                                                                 CSD019
     C                   EVAL      MsgIdArr(PIdx) = 'USR9627'
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValRun - Routine to validate Action Code 'W'               *
      *                                                               *
      *****************************************************************
     C     SRValRun      BEGSR
 
     C                   MOVEL     PFunt         KFunt
     C                   MOVEL     PIden         KIden
     C                   MOVEL     PBrch         KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL1
 
      ** Item must exist.
 
     C                   IF        NOT %FOUND(SDCWHTL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'
     C                   ELSE
 
     **  Option 'W' is not available for function 'MGOREF'
 
     C                   IF        W3FUNT = 'MGOREF'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9678'
     C                   ENDIF
 
      ** Option 'W' is only allowed for items with 'Hit Unconfirmed Flag' of 'Y'.
 
     C                   IF        W3UNCF <> 'Y'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9628'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValUnr - Routine to validate Action Code 'R'               *
      *                                                               *
      *****************************************************************
     C     SRValUnr      BEGSR
 
     C                   MOVEL     PFunt         KFunt
     C                   MOVEL     PIden         KIden
     C                   MOVEL     PBrch         KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL1
 
      ** Item must exist.
 
     C                   IF        NOT %FOUND(SDCWHTL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'
     C                   ELSE
 
      ** Option 'R' is only allowed for items with 'Temporary Release Flag' equal to 'Y'.
 
     C                   IF        W3TREL <> 'Y'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9635'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValTemR - Routine to validate Action Code 'X'              *
      *                                                               *
      *****************************************************************
     C     SrValTemR     BEGSR
 
     C                   MOVEL     PFunt         KFunt
     C                   MOVEL     PIden         KIden
     C                   MOVEL     PBrch         KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL1
 
      ** Item must exist.
 
     C                   IF        NOT %FOUND(SDCWHTL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'
     C                   ELSE
 
      ** Option 'X' is only allowed for items with 'Temporary Release Flag' equal to blank.
 
     C                   IF        W3TREL  <> *BLANKS
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9637'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrFalsPos - Routine to validate Action Code 'Y'              *
      *                                                               *
      *****************************************************************
     C     SrFalsPos     BEGSR
 
     C                   MOVEL     PFunt         KFunt
     C                   MOVEL     PIden         KIden
     C                   MOVEL     PBrch         KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL1
 
      ** Item must exist.
 
     C                   IF        NOT %FOUND(SDCWHTL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrTruePos - Routine to validate Action Code 'Y'              *
      *                                                               *
      *****************************************************************
     C     SrTruePos     BEGSR
 
     C                   MOVEL     PFunt         KFunt
     C                   MOVEL     PIden         KIden
     C                   MOVEL     PBrch         KBrch
 
     C     KSDCWHT       CHAIN     SDCWHTL1
 
      ** Item must exist.
 
     C                   IF        NOT %FOUND(SDCWHTL1)
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'
     C                   ELSE
 
      ** Option 'Z' is only allowed for items with Hit Status not equal to 'TRUEPOSITV'.
 
     C                   IF        W3HSTS = 'TRUEPOSITV'
     C                   EVAL      OKITEM = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'USR9638'
     C                   ENDIF
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************                       CSD019
      /EJECT                                                                                  CSD019
      *****************************************************************                       CSD019
      *                                                               *                       CSD019
      *  SrWLMatch - Routine to validate Action Code 'E'              *                       CSD019
      *                                                               *                       CSD019
      *****************************************************************                       CSD019
     C     SrWLMatch     BEGSR                                                                CSD019
                                                                                              CSD019
     C                   MOVEL     PFunt         KFunt                                        CSD019
     C                   MOVEL     PIden         KIden                                        CSD019
     C                   MOVEL     PBrch         KBrch                                        CSD019
                                                                                              CSD019
     C     KSDCWHT       CHAIN     SDCWHTL1                                                   CSD019
                                                                                              CSD019
      ** Item must exist.                                                                     CSD019
                                                                                              CSD019
     C                   IF        NOT %FOUND(SDCWHTL1)                                       CSD019
     C                   EVAL      OKITEM = 'N'                                               CSD019
     C                   EVAL      PIDx = PIDx + 1                                            CSD019
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'                                CSD019
     C                   EVAL      MsgIdArr(PIdx) = 'USR9629'                                 CSD019
     C                   ENDIF                                                                CSD019
                                                                                              CSD019
     C                   ENDSR                                                                CSD019
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRAcsSec - Access Security Checking                          *
      *                                                               *
      *****************************************************************
     C     SRAcsSec      BEGSR
 
      ** If not multi-branching, check authority to only action code.
 
     C                   IF        BJSBRC <> *BLANK
 
     C                   CALL      'ZVACTU'
     C                   PARM      PAction       PActn
     C                   PARM                    PError
 
     C                   IF        PError <> *ZERO
     C                   EVAL      OKOPTN = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'CSF9006'
     C                   ENDIF
 
     C                   ELSE
 
      ** If multi-branching, check authority to user's default branch.
 
     C                   CALL      'ZVACTBU'
     C                   PARM      PAction       PActn
     C                   PARM      DBRN          PBrc
     C                   PARM                    PError
 
     C                   IF        PError = 1
     C                   EVAL      OKOPTN = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'CSF9007'
     C                   ENDIF
 
     C                   IF        PError = 2
     C                   EVAL      OKOPTN = 'N'
     C                   EVAL      PIDx = PIDx + 1
     C                   EVAL      FldNameArr(PIdx) = '#1OPTN'
     C                   EVAL      MsgIdArr(PIdx) = 'CSF9008'
     C                   ENDIF
 
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
 
      ** INPUT
      ** =====
 
      ** Return Code
 
     C                   PARM                    PRetCodeIn
 
      ** Response Mode
 
     C                   PARM                    PResponse
 
      ** Action Code
 
     C                   PARM                    PAction
 
      ** Function Type
 
     C                   PARM                    PFunt
 
      ** Identifier
 
     C                   PARM                    PIden
 
      ** Branch
 
     C                   PARM                    PBrch
 
      ** STANDING DATA
 
      ** Single Branch Code from SDBANKPD
 
     C                   PARM                    BJSBRC
 
      ** Default Branch ZMUSER
 
     C                   PARM                    DBRN
 
      ** SWITCHABLE FEATURES                                                                  CSD019
      ** ===================                                                                  CSD019
                                                                                              CSD019
     C                   PARM                    CSD019                                       CSD019
                                                                                              CSD019
      ** OUTPUT
      ** ======
 
      ** Current HELD ITEM IN THE CASE MANAGEMENT retrieved from file - file format
 
     C                   PARM                    CrCWFilFmt
 
      ** OK Action Code
 
     C                   PARM                    OKOPTN
 
      ** OK Account Code
 
     C                   PARM                    OKITEM
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PIDx
 
      ** Initialize module name
 
     C                   EVAL      DBMOD = 'SDMCMGRTV'
 
      ** Key fields for LF/SDCWHTL1
      ** Compliance Watch Hit List(FType/Identifier/Branch)
 
     C     KSDCWHT       KLIST
     C                   KFLD                    KFunt
     C                   KFLD                    KIden
     C                   KFLD                    KBrch
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
(c) Misys International Banking Systems Ltd. 2002
