     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlement validation')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMVAL - Trade Settlement Validation                      *
      *                                                               *
      *  Function: This module validates Security Trade Settlement    *
      *            screen 2 fields for input into the Midas database. *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                SETRSMCTL                                      *
      *                SETRSMRPR                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 CAP182  *CREATE    Date 24Feb03               *
      *                                    Date DDMmmYY               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    99         Use for LOOKUP command                          *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SrNomS      - Nominal Settled Validation Process             *
      *  SrValS      - Value Settled Validation Process               *
      *  SrSRef      - Settlement Reference Validation Process        *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *  SRUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *  *PSSR - Error processing                                     *
      *  *INZSR - Initialise                                          *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRS1V001
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
      **    True       logical = *On (for indicator processing)
      **    False      logical = *Off (for indicator processing)
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
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      ** SE Trade Settlement Details for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** Error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(S_)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids, etc.
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Update error index
     D Ix              S              3P 0
      *
      ** Response Mode, received as a parameter from the common header
     D PResponse       S              1A
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     D PMode           S              6A
      *
      ** Switchable features
     D CSE007          S              1A
     D CEU017          S              1A
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
      /COPY WNCPYSRC,SETRS1V002
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
      ** M A I N  P R O C E S S I N G
      *
      /COPY WNCPYSRC,SETRS1V003
      *
      *
      ** Nominal Settled
      ** ===============
      *
      /COPY WNCPYSRC,SETRS1V004
     C                   Exsr      SrNomS
      /COPY WNCPYSRC,SETRS1V005
      *
      *
      ** Value Settled
      ** =============
      *
      /COPY WNCPYSRC,SETRS1V006
     C                   Exsr      SrValS
      /COPY WNCPYSRC,SETRS1V007
      *
      *
      ** Reference
      ** =========
      *
      /COPY WNCPYSRC,SETRS1V008
     C                   Exsr      SrSRef
      /COPY WNCPYSRC,SETRS1V009
      *
      *
      ** Narrative: No validation required
      *  =========
      *
      /COPY WNCPYSRC,SETRS1V010
     C                   Eval      VTSSNTV = DDNARR
      /COPY WNCPYSRC,SETRS1V011
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      *
      /COPY WNCPYSRC,SESED1V090
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrNomS - Nominal Settled Validation Process                  *
      *                                                               *
      *****************************************************************
     C     SrNomS        BEGSR
      *
      ** Reset variables updated by each module
     C                   EXSR      SrResetErrs
      *
      ** Call validation module
     C                   CALLB     'SEVTSNOMS'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Action
     C                   PARM                    CSE007
      *
      ** Security Redenomination Euro Changes
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** Update error info with that returned from the validation module
     C                   If        RetCodeOut <> *Blanks
     C                   Exsr      SRUpdatErrs
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValS - Value Settled Validation Process                    *
      *                                                               *
      *****************************************************************
 
     C     SrValS        BEGSR
      *
      ** Reset variables updated by each module
      *
     C                   Exsr      SrResetErrs
      *
      ** Call validation module
      *
     C                   CALLB     'SEVTSVALS'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNmXAr
     C                   PARM                    WMsgIDxAr
     C                   PARM                    WMsgDtXAr
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** Update error info with that returned from the validation module
      *
     C                   If        RetCodeOut <> *BLANKS
     C                   Exsr      SrUpdatErrs
     C                   EndIf
 
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSRef - Settlement Reference Validation Process             *
      *                                                               *
      *****************************************************************
 
     C     SrSRef        BEGSR
      *
      ** Reset variables updated by each module
     C                   Exsr      SrResetErrs
      *
      ** Call validation module
     C                   CALLB     'SEVTSSREF'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM                    RetCodeOut
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNamXAr
     C                   PARM                    MsgIDXAr
     C                   PARM                    MsgDtaXAr
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** Update error info with that returned from the validation module
     C                   If        RetCodeOut <> *BLANKS
     C                   Exsr      SrUpdatErrs
     C                   EndIf
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErrs - Routine to reset Error Information that is     *
      *                received from each validation module           *
      *                                                               *
      *****************************************************************
 
     C     SrResetErrs   BEGSR
 
     C                   Eval      RetCodeOut = *Blanks
      *
      ** Reset error and warning fields/message IDs/message
      ** data (arrays).
     C                   Eval      FldNamXAr = *Blanks
     C                   Eval      MsgIDXAr  = *Blanks
     C                   Eval      MsgDtaXAr = *Blanks
 
     C                   Eval      WFldNmXAr = *Blanks
     C                   Eval      WMsgIDXAr = *Blanks
     C                   Eval      WMsgDtXAr = *Blanks
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdatErrs - Routine to update Error Information with that  *
      *                received back from each validation module      *
      *                                                               *
      *****************************************************************
 
     C     SrUpdatErrs   BEGSR
      *
      ** Update error fields/message IDs/message data (arrays).
     C                   Eval      Ix = 1
     C     *BLANK        LOOKUP    FldNameArr(Ix)                         99
     C                   If        *IN99 = *On
     C                   MoveA     FldNamXar     FldNameArr(Ix)
     C                   MoveA     MsgIDXAr      MsgIdArr(Ix)
     C                   MoveA     MsgDtaXAr     MsgDtaArr(Ix)
     C                   EndIf
      *
      ** Set Error Index.
     C                   Eval      Ix = 1
     C     *Blank        LOOKUP    FldNameArr(Ix)                         99
     C     *IN99         Ifeq      '1'
     C     Ix            SUB       1             IDx
     C                   Else
     C                   Eval      Ix = ArrayMax
     C                   Move      *Blanks       FLDNAMEARR(Ix)
     C                   Move      *Blanks       MSGIDARR(Ix)
     C                   Move      *Blanks       MSGDTAARR(Ix)
     C                   Eval      IDx = ArrayMax - 1
     C                   EndIf
      *
      ** Update warning fields/message IDs/message data (arrays).
     C                   Eval      Ix = 1
     C     *Blank        LOOKUP    WFldNamArr(Ix)                         99
     C                   If        *IN99 = *On
     C                   MoveA     WFldNmXAr     WFldNamArr(Ix)
     C                   MoveA     WMsgIDXAr     WMsgIDArr(Ix)
     C                   MoveA     WMsgDtXAr     WMsgDtaArr(Ix)
     C                   EndIf
      *
      ** Set Warning Index.
     C                   Eval      Ix = 1
     C     *BLANK        LOOKUP    WFldNamArr(Ix)                         99
     C     *IN99         Ifeq      '1'
     C     Ix            SUB       1             WIDx
     C                   Else
     C                   Eval      Ix = ArrayMax
     C                   Move      *Blanks       WFLDNAMARR(Ix)
     C                   Move      *Blanks       WMSGIDARR(Ix)
     C                   Move      *Blanks       WMSGDTAARR(Ix)
     C                   Eval      WIDx = ArrayMax - 1
     C                   EndIf
 
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
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      *
      ** INPUT
      ** =====
      *
      ** Return Code
     C                   PARM                    RetCodeIn
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen Input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PResponse
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for security details
     C                   PARM                    PSectyd
      *
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Corporate Action
     C                   PARM                    CSE007
      *
      ** Security Redenomination Euro Changes
     C                   PARM                    CEU017
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    WIDx
      *
      ** Error indicators
     C                   PARM                    SEETRSM
      *
      ** SE Trade Settlement details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      *
      ** Program, module and procedure names for dbase error processing
      ** ==============================================================
      ** The following /COPY sets these values.
      *
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      *
      /COPY WNCPYSRC,SETRS1V012
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
(c) Finastra International Limited 2003
