     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Depot')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Customer Details                       *
      *                                                               *
      *  SDVCSDO01 - Validate Depot                                   *
      *                                                               *
      *  Function:  This module will validate depot.                  *
      *                                                               *
      *  Component of: SDCDRFVAL                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG3122            Date 17Jul04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022  *CREATE    Date 29Mar01               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSE022 - Depository Definition Enhancement                   *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      * SRProc      - Process Subroutine                              *
      *                                                               *
      * *PSSR - Error processing                                      *
      * *INZSR - Initialise                                           *
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
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **
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
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
 
     D/COPY ZACPYSRC,ERR_ARRAYS
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      ** External DS for securities customer details
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
 
      ** External DS for securities client details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PDepNam         S             10A
     D PDepOKInd       S              1A
     D PKeySts         S              7A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *********************************************************************
      * MAIN PROCEDURE                                                    *
      *********************************************************************
 
      ** Initialisation
 
     C                   EVAL      PDepOKInd = 'Y'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      Idx = 0
 
      ** Process data from calling program
 
     C                   EXSR      SRProc
 
      ** If no errors found:
      **  move 'Y' to okflag
 
     C                   IF        Idx = 0
     C                   EVAL      PDepOKInd = 'Y'
     C                   ENDIF
 
      ** Return to calling program
 
     C                   RETURN
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRProc - Process Data from calling program                    *
      *                                                               *
      * Called by: Main                                               *
      *                                                               *
      * Calls: SRValDep, SRValDepRef                                  *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** Check if depot is a valid customer
 
     C                   CALL      'AOCUSTR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    PDepNam
     C                   PARM                    PKeySts
     C     SDCUST        PARM      SDCUST        DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      PDepOKInd = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDPOT'
     C                   EVAL      MsgIdArr(Idx) = 'USR7743'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
      ** Check if depot is a valid security customer
 
     C                   CALL      'AOSECSR0'
     C                   PARM      '*BLANKS'     @RtCd
     C                   PARM      '*KEY   '     @Optn
     C                   PARM                    BBCUST
     C     SDSECS        PARM      SDSECS        DSSDY
 
     C                   IF        @RtCd <> *BLANKS
     C                   EVAL      PDepOKInd = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDPOT'
     C                   EVAL      MsgIdArr(Idx) = 'USR7743'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
      ** Check if security classification is 'M', 'X', 'E' or 'C'
 
     C                   IF        BFCLAS <> 'M' AND BFCLAS <> 'X' AND
     C                             BFCLAS <> 'E' AND BFCLAS <> 'C'
     C                   EVAL      PDepOKInd = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDDPOT'
     C                   EVAL      MsgIdArr(Idx) = 'USR9126'
     C                   ENDIF
 
     C     ESRPROC       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Implicitly on program activation                   *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
 
      ** Input
      ** ======
      ** Return Code
      ** Depot Name
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PDepNam
 
      ** Output
      ** ======
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Depot OK Indicator
 
     C                   PARM                    PDepOKInd
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
 
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
 
     C/COPY ZACPYSRC,PSSR_ILE
 
      *****************************************************************
      /EJECT
      *****************************************************************
 
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
