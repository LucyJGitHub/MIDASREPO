     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements detail screen display')     *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSM2DP - Security Trade Settlement Screen 2 display       *
      *                                                               *
      *  Function: This module will process the Security Trade        *
      *            Settlement Details 2nd Screen                      *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                SETRSMRPR                                      *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      *  Last Amend No. AR689705           Date 03Jan11               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSD027             Date 09Dec05               *
      *                 CSE039  *CREATE    Date 03Jan03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  AR689705 - Nominal and value settled were missing after      *
      *             enter. Applied fix AR656294 (Child: AR689706)     *
      *  AR656294 - HATS issue                                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE039 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  Use of indicators.                                           *
      *                                                               *
      *    20-29    Field Error - highlight screen fields             *
      *                                                               *
      *    67       Display either From or To fields                  *
      *    66       Display either Nominal Settled or Reversed field  *
      *    88       Display Branch Code                               *
      *                                                               *
      *    71       Enable CF05 - Refresh                             *
      *    72       Enable CF07 - Read previous record                *
      *             Enable CF08 - Read next record                    *
      *    74       Enable CF12 - Cancel                              *
      *    75       Enable CF15 - Select record                       *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  Sr_Main - Main processing                                    *
      *  *PSSR   - Error processing                                   *
      *  *INZSR  - Initialise                                         *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Trade Settlement details screen 2
     FSETRSM2DF CF   E             WORKSTN INFSR(*PSSR)
      *
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*PSSR)
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
      /COPY ZACPYSRC,ERR_ARRAYS
      *
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
      *
      /COPY ZACPYSRC,MSGHNDDCL
      *
      ** The following /COPY line declares the arrays for processing that
      ** take place in the *CTL modules.
      *
      /COPY ZACPYSRC,APICTLARR
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
      ** Arrays for screen error indicators
     D WZ0             S              1    DIM(40) CTDATA PERRCD(40)
     D WEI             S              1    DIM(40)
      *
      ** SE Trade Settlement screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
     D                                     PREFIX(S:2)
      *
      ** SE Trade Details retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** SE Trade Settlement screen error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Work Fields
     D Cx              S              2P 0
     D Ex              S              2P 0
      *
      ** Function keys to activate
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
      *
      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** Work parameters
     D PEDtFld         S              1A
     D BJSBRC          S              3A
     D BJMRDT          S              7A
      *
      ** Output screen fields
     D SCUCR           S             12A
     D SSEXR           S             14A
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
      ** Main processing.
     C                   Exsr      Sr_Main
      *
      ** Return.
     C                   Eval      *INLR = *ON
      *
     C                   RETURN
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SR_Main - Main processing                                    *
      *                                                               *
      *****************************************************************
     C     Sr_Main       BEGSR
      *
      ** Move 'OK' flags into array (for checking).
      *
     C                   MoveA     SEETRSM       WEI
      *
      ** Set screen error indicators according to status of 'OK' flags.
      *
     C                   Z-Add     1             Cx
     C                   Z-Add     1             Ex
 
     C                   DOU       Cx > 40
 
     C                   If        WEI(Cx) = 'N' OR WEI(Cx) = 'W'
     C                   Eval      *IN(Ex) = *ON
     C                   EndIF
 
     C                   Eval      Cx = Cx + 1
     C                   Eval      Ex = Ex + 1
     C                   EndDo
      *
      ** The following /COPY line includes processing for the error and
      ** warning messages.
      *
      /COPY ZACPYSRC,MSGHNDDSP1
      *
      ** Enable detail fields.
     C                   If        PEDtFld = 'Y'
     C                   Eval      *IN70 = *OFF
     C                   Else
     C                   Eval      *IN70 = *ON
     C                   EndIF
      *
      ** Display either From or To details
     C                   If        SSLPR = 'Purchase'
     C                   Eval      *IN63 = '1'
     C                   Eval      *IN64 = '0'
     C                   Else
     C                   Eval      *IN63 = '0'
     C                   Eval      *IN64 = '1'
     C                   EndIf
      *
      ** Display either Settled or Reversal details .
      ** Nominal and Value Settled. Protect if Reversal
     C                   If        SREVE = 'Y'
     C                   Eval      *IN66 = '1'
     C                   Eval      *IN65 = '1'
     C                   Else
     C                   Eval      *IN66 = '0'
     C                   Eval      *IN65 = '0'
     C                   EndIf
      *
      ** In repair mode enable the key fields
     C                   If        CallerCode = '*RPR'
     C                   Eval      *IN68 = *ON
     C                   Eval      *IN65 = *OFF
     C                   EndIF
      *
      *
      ** Enable CF05 (Refresh).
     C                   If        PEINKE = 'Y'
     C                   Eval      *IN71 = *ON
     C                   Else
     C                   Eval      *IN71 = *OFF
     C                   EndIf
      *
      ** Enable CF07,CF08 (Read Previous,Next Record)
     C                   If        PEINKG = 'Y' OR PEINKH = 'Y'
     C                   Eval      *IN72 = *ON
     C                   Else
     C                   Eval      *IN72 = *OFF
     C                   EndIf
      *
      ** Enable CF12 (Cancel).
     C                   If        PEINKL = 'Y'
     C                   Eval      *IN74 = *ON
     C                   Else
     C                   Eval      *IN74 = *OFF
     C                   EndIf
      *
      ** Enable CF15 (Browse screen).
     C                   If        PEINKP = 'Y'
     C                   Eval      *IN75 = *ON
     C                   Else
     C                   Eval      *IN75 = *OFF
     C                   EndIf
      *
      ** Write message subfile, details and footer screens.
     C                   TIME                    STIME
      *
     C**********         WRITE     SETRSMD1                                                 AR656294
     C                   WRITE     SETRSMF1
     C                   WRITE     SETRSMS0
     C                   WRITE     SETRSMD1                                                 AR656294
      *
      ** If not Write Only, read details screen.
     C                   If        WriteOnly <> 'Y'
     C                   READ      SETRSMD1                               01
     C                   EndIf
      *
      ** Clear message subfile.
      *
     C                   Call      'ZA0250'
      *
      ** Set screen error indicators off.
      *
     C                   MoveA     WZ0           *IN(1)
      *
      ** Set return keys.
     C                   Eval      PINKC = *INKC
     C                   Eval      PINKE = *INKE
     C                   Eval      PINKG = *INKG
     C                   Eval      PINKH = *INKH
     C                   Eval      PINKL = *INKL
     C                   Eval      PINKP = *INKP
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
      /COPY ZACPYSRC,MSGHNDDSP2
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
      ** Return code
     C                   PARM                    RetCodeIn
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode        4
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** Enable function keys
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Trade Settlement screen error indicators
     C                   PARM                    SEETRSM
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warning fields/message Ids/message data (arrays) from/to
      ** caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Write screen with no read indicator
     C                   PARM                    WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System Runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KE = Command key 05 = Refresh
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KL = Command key 12 = Cancel
      ** KP = Command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
 
     C                   Eval      SUSER = PsUser
     C                   Eval      SWID = PsJobName
      *
      ** Initialise the fixed parameters for ZAMSGHNDLE.
      *
     C                   Eval      ModuleID     = 'SE'
     C                   Eval      APRPRLOCN    = 'S'
     C                   Eval      APCNFVALFO   = 'N'
     C                   Eval      APRespMode   = 'S'
      *
      ** Set up the prime and secondary message files for
      ** finding message IDs.
      *
     C                   Eval      #MsgFile     = 'SEUSRMSG'
     C                   Eval      MsgFArray(1) = 'DRSMM'
     C                   Eval      MsgFArray(2) = 'MEMSG'
      *
      ** Message subfile control and program queue initialisation.
      *
     C                   Move      *ON           *IN97
     C                   MoveL     '*'           SPGMQ
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      /COPY ZACPYSRC,PSSR_ILE
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
**  WZ0
0000000000000000000000000000000000000000
