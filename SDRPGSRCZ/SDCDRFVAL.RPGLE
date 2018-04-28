     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Customer Depot Reference Validation 1')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Customer Details                       *
      *                                                               *
      *  SDCDRFVAL - Customer Depot Reference Validation              *
      *                                                               *
      *  Function:  This module will validate the depot and depot     *
      *             reference coming from the Security Customer       *
      *             Details Interface Controller.                     *
      *                                                               *
      *  Component of: SDSECDCTL - Security Customer Details          *
      *                            Interface Controller               *
      *                SDCDRFSFL - Securities Trading Customer Depot  *
      *                            Reference Maintenance              *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. BUG12213           Date 07Dec06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      *  Prev Amend No. CSE022  *CREATE    Date 29Mar01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  BUG12213 - Depot details missing on wholesale customer input *
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
      * SRValDep    - Validate Depot Number                           *
      * SRValDepRef - Validate Depot Reference                        *
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
 
      ** Customer Depository Reference file by Customer Number
     FSDCSDRL0  IF   E           K DISK    INFSR(*PSSR)
 
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
 
      ** Indicator Array
     D Indicators      DS                  BASED(IndicatorP)
     D  RecNotFnd             01     01
 
      ** Customer Depository Reference
     D PSecDetDS     E DS                  EXTNAME(SDSECDPD)
 
      ** Customer Depository Reference
     D PDepRefDS     E DS                  EXTNAME(SDCSDSPD)
     D                                     PREFIX(W)
 
      ** Customer Depository OK Indicators
     D PEDepRefDS    E DS                  EXTNAME(SDECSDRPD)
 
      ** Valid Customer Depository
     D PVDepRefDS    E DS                  EXTNAME(SDVCSDRPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PDepNam         S             10A
     D PClasftn        S              1A
     D PDepRef         S             20A
     D PRespMode       S              1A
 
      ** Index for arrays of error message ids
     D Idx             S              3P 0
 
      ** Pointer for the indicator Array
     D IndicatorP      S               *   INZ(%Addr(*IN))
 
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
 
     C                   EVAL      PRespMode = *BLANK
     C                   EVAL      PEDepRefDS = *ALL'Y'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      Idx = 0
 
      ** Process data from calling program
 
     C                   EXSR      SRProc
 
      ** If no errors found:
      **  move data to valid DS
 
     C                   IF        Idx = 0
     C                   EVAL      DSCUST = WDDCUST
     C                   EVAL      DSDPOT = WDDDPOT
     C                   EVAL      DSREFN = WDDREFN
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
 
      ** Check if record exist in file.
 
     C     KDepot        CHAIN     SDCSDRL0                           01
 
      ** If insert
 
     C                   IF        WDDACTN = 'I'  AND RecNotFnd = False
     C                   EVAL      DDACTNOK = 'N'
     C                   EVAL      DDDPOTOK = 'N'
     C                   EVAL      DDREFNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9112'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
      ** If amend or delete
 
     C                   IF        WDDACTN = 'A'  AND RecNotFnd = True OR
     C                             WDDACTN = 'D'  AND RecNotFnd = True
     C**********         EVAL      DDACTNOK = 'N'                                           BUG12213
     C**********         EVAL      DDDPOTOK = 'N'                                           BUG12213
     C**********         EVAL      DDREFNOK = 'N'                                           BUG12213
     C**********         EVAL      Idx = Idx + 1                                            BUG12213
     C**********         EVAL      FldNameArr(Idx) = 'DDACTN'                               BUG12213
     C**********         EVAL      MsgIdArr(Idx) = 'USR9113'                                BUG12213
     C**********         GOTO      ESRPROC                                                  BUG12213
     C                   ENDIF
 
      ** If not insert, amend , or delete
 
     C                   IF        WDDACTN <> 'I' AND WDDACTN <> 'A' AND
     C                             WDDACTN <> 'D'
     C                   EVAL      DDACTNOK = 'N'
     C                   EVAL      DDDPOTOK = 'N'
     C                   EVAL      DDREFNOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDACTN'
     C                   EVAL      MsgIdArr(Idx) = 'USR7531'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
      ** Validate Depot
 
     C                   EVAL      PDepNam = WDDDPOT
     C                   EXSR      SRValDep
 
      ** Validate Depot Reference
 
     C                   IF        Idx = 0
     C                   EVAL      WDDDPOT = PDepNam
     C                   EVAL      PDepRef = WDDREFN
     C                   EXSR      SRValDepRef
     C                   ENDIF
 
     C     ESRPROC       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDep - Validate Depot Number                              *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValDep      BEGSR
 
      ** Validate Depot
      ** ==============
 
     C                   CALLB     'SDVCSDO01'
 
      ** Input
      ** ======
      ** Return Code
      ** Depot Name
 
     C                   PARM      *BLANK        RetCodeOut
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
 
     C                   PARM                    DDDPOTOK
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * SRValDepRef - Validate Depot Reference                        *
      *                                                               *
      * Called by: SRProc                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SRValDepRef   BEGSR
 
      ** Validate Depot Reference
      ** ========================
 
     C                   CALLB     'SDVDORF01'
 
      ** Input
      ** ======
      ** Return Code
      ** Security Customer Classification
      ** Depot Reference
 
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    DDCLAS
     C                   PARM                    PDepRef
 
      ** Output
      ** ======
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Depot Reference OK Indicator
 
     C                   PARM                    DDREFNOK
 
     C                   ENDSR
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
      ** Response Mode
      ** Customer Depository Reference
      ** Securities Client Details
 
     C                   PARM                    PRespMode
     C                   PARM                    PDepRefDS
     C                   PARM                    PSecDetDs
 
      ** Output
      ** ======
      ** Customer Depository OK Indicators
      ** Error fields/message IDs/message data (arrays) from/to caller
      ** Array index (3P0) from/to caller
 
     C                   PARM                    PEDepRefDS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
 
      ** Valid Customer Depository
 
     C                   PARM                    PVDepRefDS
 
      ** Keylist for accessing SDCSDRL0.
 
     C     KDepot        KLIST
     C                   KFLD                    WDDCUST
     C                   KFLD                    WDDDPOT
 
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
