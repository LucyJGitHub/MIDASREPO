     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SD Validate Depot Reference')
      *****************************************************************
      *                                                               *
      *  Midas - Standing Data Customer Details                       *
      *                                                               *
      *  SDVDORF01 - Validate Depot Reference                         *
      *                                                               *
      *  Function:  This module will validate depot reference.        *
      *                                                               *
      *  Component of: SDCDRFVL1                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      *  Prev Amend No. 205542             Date 03Mar02               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022  *CREATE    Date 29Mar01               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  205542 - Remove reference validation.                        *
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
 
      ** External DS for securities client details
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
 
      ** Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PClasftn        S              1A
     D PDepRef         S             20A
     D PDepRefOK       S              1A
     D PDepCust        S              6A
 
     D WDepRef         S              5A
     D WRefNum         S              5S 0
     D WRefChar        S              5A
 
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
 
     C                   EVAL      PDepRefOK = 'Y'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr = *BLANK
     C                   EVAL      MsgDtaArr = *BLANK
     C                   EVAL      Idx = 0
 
      ** Process data from calling program
 
     C                   EXSR      SRProc
 
      ** If no errors found:
      **  move 'Y' to okflag
 
     C                   IF        Idx = 0
     C                   EVAL      PDepRefOk = 'Y'
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
      * Calls:                                                        *
      *                                                               *
      *****************************************************************
     C     SRProc        BEGSR
 
      ** Validate depot reference field if security customer classification
      ** is 'I', 'S', 'D', 'C', or 'E'.
 
     C                   MOVEL     PDepRef       WDepRef
     C                   MOVEL     WDepRef       WRefNum
     C                   MOVEL     WRefNum       WRefChar
     C                   IF        WDepRef <> WRefChar AND PClasftn = 'E' OR
     C                             WDepRef <> WRefChar AND PClasftn = 'C'
     C                   EVAL      PDepRefOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDREFN'
     C                   EVAL      MsgIdArr(Idx) = 'USR0268'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
     C                   SELECT
 
     C                   WHEN      PClasftn = 'E'
 
      ** Check if depot is in ranges 60000-69999 or 90000-99999
 
 b5  C                   IF        NOT(
     C                             (WRefNum >= 60000 AND WRefNum <= 69999) OR
     C                             (WRefNum >= 90000 AND WRefNum <= 99999))
     C                   EVAL      PDepRefOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDREFN'
     C                   EVAL      MsgIdArr(Idx) = 'USR9127'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
     C                   WHEN      PClasftn = 'C'
 
      ** Check if depot is in range 1-99999
 
 b4  C                   IF        WRefNum < 1 or WRefNum > 99999
     C                   EVAL      PDepRefOK = 'N'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = 'DDREFN'
     C                   EVAL      MsgIdArr(Idx) = 'USR0626'
     C                   GOTO      ESRPROC
     C                   ENDIF
 
     C**********         WHEN      PClasftn = 'I' OR PClasftn = 'S' OR                        205542
     C**********                   PClasftn = 'D'                                             205542
 
      ***Check*if*depot*is*a*valid*security*customer*******************                       205542
 
     C**********         MOVEL     PDepRef       PDepCust                                     205542
     C**********         CALL      'AOSECSR0'                                                 205542
     C**********         PARM      '*BLANKS'     @RtCd                                        205542
     C**********         PARM      '*KEY   '     @Optn                                        205542
     C**********         PARM                    PDepCust                                     205542
     C*****SDSECS        PARM      SDSECS        DSSDY                                        205542
 
     C**********         IF        @RtCd <> *BLANKS                                           205542
     C**********         EVAL      PDepRefOK = 'N'                                            205542
     C**********         EVAL      Idx = Idx + 1                                              205542
     C**********         EVAL      FldNameArr(Idx) = 'DDREFN'                                 205542
     C**********         EVAL      MsgIdArr(Idx) = 'USR9125'                                  205542
     C**********         GOTO      ESRPROC                                                    205542
     C**********         ENDIF                                                                205542
 
      ***Check*if*security*classification*is*'M',*'X',*'E'*or*'C'******                       205542
 
     C**********         IF        BFCLAS <> 'M' AND BFCLAS <> 'X' AND                        205542
     C**********                   BFCLAS <> 'E' AND BFCLAS <> 'C'                            205542
     C**********         EVAL      PDepRefOK = 'N'                                            205542
     C**********         EVAL      Idx = Idx + 1                                              205542
     C**********         EVAL      FldNameArr(Idx) = 'DDREFN'                                 205542
     C**********         EVAL      MsgIdArr(Idx) = 'USR9126'                                  205542
     C**********         GOTO      ESRPROC                                                    205542
     C**********         ENDIF                                                                205542
 
     C                   OTHER
 
      ** No validation done for depot reference.
 
     C                   GOTO      ESRPROC
     C                   ENDSL
 
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
      ** Security Customer Classification
      ** Depot Reference
 
     C                   PARM                    RetCodeIn
     C                   PARM                    PClasftn
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
 
     C                   PARM                    PDepRefOK
 
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
(c) Finastra International Limited 2001
