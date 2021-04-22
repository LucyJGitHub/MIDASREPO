     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade settlements maintenance input')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRSMSIN - Security Trade Settlement Input Program          *
      *                                                               *
      *  Function: This module will be the input module for the       *
      *            screen-input function for Security Trade           *
      *            Settlement maintenance.                            *
      *                                                               *
      *  Component of: SETRSMSIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CSE071             Date 19Jul05               *
      *                 BUG3122            Date 17Jul04               *
      *                 CAP182  *CREATE    Date 03Jan03               *
      *                                    Date ddmmmyy               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  BUG3122 - Recompiled due to changes in SDSECSPD.             *
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
      *  SrScreen1  - Process initial screen                          *
      *  SrValScrn1 - Validate input to initial screen                *
      *  SrScreen2  - Process main screen                             *
      *  SrValScrn2 - Validate input to main screen                   *
      *  SrDefault  - Process defaulting of default fields            *
      *  SrScrnW    - Process Window screen                           *
      *  SrScrnF    - Process confirmation screen                     *
      *  SrUpdate   - Process file update                             *
      *  SrBldBrw   - Build browse subfile record                     *
      *  SrRdNBrw   - Read next browse subfile record                 *
      *  SrRtvTRSM  - Retrieve Trade Settlement Details.              *
      *  SrCvtTRSM  - Converts Trade Settlement Details from file     *
      *               to screen format.                               *
      *  SrRoll     - Roll backward or forward through the Trade      *
      *               Settlement Details file                         *
      *  SrSavKey   - Save key fields to a temporary variable.        *
      *  SrRstKey   - Restore key fields.                             *
      *  SrSetupKey - Setup keys for pointer or selection.            *
      *  SrClearScn - Clear screen data structures                    *
      *  SrEndP     - Set program to end                              *
      *  SrSndM     - Send error message to screen                    *
      *  SrZDate1   - Validate and convert date to day number         *
      *  SrZDate2   - Convert Midas Date into DDMMYY or MMDDYY        *
      *  SrResetErr - Reset error fields                              *
      *  *PSSR      - Error processing                                *
      *  *INZSR     - Initialise                                      *
      *                                                               *
      *****************************************************************
      *
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SETRSM001
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
      ** The following /COPY line includes the definitions of data
      ** structure used to pass data to window program
      *
      /COPY QWINDSRC,SETRSMDTA
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
      ** SE Trade Settlement details retrieved from file
      ** - screen format
     D CrTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
     D                                     PREFIX(O)
      *
      ** SE Trade Settlement Screen details from incoming transaction
      ** - screen format
     D NwTS1ScnFmt   E DS                  EXTNAME(SETRSMPD)
      *
      *
      ** SE Trade Settlement Details for file update - file format
     D NwTSFilFmt    E DS                  EXTNAME(SEVTRSMPD)
      *
      * Error indicators
     D SEETRSM       E DS                  EXTNAME(SEETRSMPD)
      *
      ** SE Trade Details information retrieved from file - file format
     D CrTDFilFmt    E DS                  EXTNAME(TRADS)
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(SE_)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      *
      ** Externally described DS for Securities Customers
     D SDSECS        E DS                  EXTNAME(SDSECSPD)
      *
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      *
      ** Data structure for key fields
     D KeyLists        DS
     D  WDTRAD                 1      6A
     D  WDSECS                 7     16A
     D  WDCLNT                17     22A
     D  WDMDAT                23     29A
      *
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Response mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for synchronous.
     D PRespMode       S              1A   INZ('S')
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     D PMode           S              6A   INZ('*SIN  ')
      *
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
      *
      ** Index for arrays of error message ids, etc.
     D Ex              S              3P 0
     D IDx             S              3P 0
      *
      ** Index for arrays of warning error message ids, etc.
     D WIDx            S              3P 0
      *
      ** Function keys to activate
     D PEINKE          S              1A
     D PEINKG          S              1A
     D PEINKH          S              1A
     D PEINKJ          S              1A
     D PEINKL          S              1A
     D PEINKP          S              1A
      *
      ** Function keys activated
     D PINKC           S              1A
     D PINKE           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
      *
      ** Work variables
     D WReDisplay      S              1A
     D WDTRDR          S              6A
     D WDMVDT          S              6A
     D WDFSET          S              1A
     D WDREVE          S              1A
     D WDDTRDR         S              6A
     D WDDMVDT         S              6A
     D WDDFSET         S              1A
     D WDDREVE         S              1A
     D WScrn           S              1A
     D WRdNBrw         S              1A
     D WProcOnce       S              1A
     D WiX             S              3P 0
      *
      ** Work parameters
     D PReDsp          S              1A
     D CSE007          S              1A
     D CEU017          S              1A
     D PPROT           S              1A
     D PEDtFld         S              1A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D POpSel          S              1A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PPayCcy         S              3A
     D PEvtDno         S              5P 0
     D PSARD           S              6A
     D PErrMS          S              7A
     D PFRNT           S             20A
     D PTRADSel        S              6A
     D PMVDTSel        S              6A
     D PFSETSel        S              1A
     D PREVESel        S              1A
     D PSEQNSel        S              3  0
     D PSSEQN          S              3  0
     D DDACTN          S              1A
      *
      ** Parameters for AOCURRR0
     D PRtCd           S              7A
     D POptn           S              7A
     D PCyCd           S              3A
      *
     D PSCnum          S              6A
      *
      ** Output screen fields
     D DDCUCR          S             12A
     D DDSEXR          S             14A
      *
      ** Parameters for WN0010
     D PWPgm           S             10A   INZ('SETRSMSIN')
     D PWKey           S              2A
     D PWAction        S              1A
     D PWRtn           S              7A
     D PWSpare         S            256A
      *
      ** Parameters for ZDATE1
     D PDateAIn        S              6A
     D PDayNoOut       S              5P 0
     D PErrorFlag      S              1A
      *
      ** Parameters for ZDATE2
     D PDateIn         S              5P 0
     D PDateOut        S              6P 0
     D PADateOut       S              7A
      *
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      /COPY WNCPYSRC,SETRSM002
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
      /COPY WNCPYSRC,SETRSM003
      *
      ** Read next browse subfile record.
      *
     C                   If        WScrn = 'R'
     C                   Exsr      SrRdnBrw
     C                   EndIf
      *
      /COPY WNCPYSRC,SETRSM004
      *
      ** Do While screen - Initial details only.
      *
     C                   Dow       WScrn = 'I'
     C                   Exsr      SrScreen1
     C                   EndDo
      *
      /COPY WNCPYSRC,SETRSM005
      *
      ** Do While screen - Main screen details.
      *
     C                   Dow       WScrn = 'P'
     C                   Exsr      SrScreen2
     C                   EndDo
      *
      /COPY WNCPYSRC,SETRSM006
      *
      ** Process window screen.
      *
     C                   If        WScrn = 'W'
     C                   Exsr      SrScrnW
     C                   EndIf
      *
      /COPY WNCPYSRC,SETRSM007
      *
      ** Process confirmation.
     C                   If        WScrn = 'F'
     C                   Exsr      SrScrnF
     C                   EndIF
      *
      /COPY WNCPYSRC,SETRSM008
      *
      ** Process file update.
     C                   If        WScrn = 'U'
     C                   Exsr      SrUpdate
     C                   EndIf
      *
      /COPY WNCPYSRC,SETRSM009
      *
      ** Terminate program.
     C                   If        WScrn = 'E'
     C                   Eval      *INLR = *ON
     C                   EndIf
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SETRSM010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScreen1 -  Process initial screen                          *
      *                                                               *
      *****************************************************************
     C     SrScreen1     BEGSR
      *
      ** If windows processing is on, clear any possible updates
      ** in window function.
     C                   If        BGWDPR = 'Y'
     C                   Rolbk
     C                   EndIf
      *
      ** Enable all fields on initial screen as well as all function keys.
     C                   Eval      PEINKE  = 'Y'
     C                   Eval      PEINKG  = 'Y'
     C                   Eval      PEINKH  = 'Y'
     C                   Eval      PEINKP  = 'Y'
     C                   Eval      PEINKL  = 'Y'
      *
      ** Default the Movement Date to todays date.
     C                   If        DDMVDT = *Blanks
     C                   Z-add     BJRDNB        PDateIn
     C                   Exsr      SrZDate2
     C                   Move      PDateOut      DDMVDT
     C                   EndIf
      *
      *
      ** Display initial screen.
     C                   CallB     'SETRSM1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
      *
      ** Enable function keys
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** OK field error indicators
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
     C                   PARM                    OKTRDR
     C                   PARM                    OKMVDT
     C                   PARM                    OKFSET
     C                   PARM                    OKREVE
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
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Save warning message ids array of this screen.
     C                   MoveA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   Exsr      SrResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   When      PINKC = *ON
     C                   Exsr      SrEndP
      *
      ** F5 - refresh initial screen details.
     C                   When      PINKE = *ON
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
      *
      ** F7 - roll backwards.
     C                   When      PINKG = *ON
     C                   Exsr      SrRoll
      *
      ** F8 - roll forwards.
     C                   When      PINKH = *ON
     C                   Exsr      SrRoll
      *
      ** F12 - cancel on initial screen.
     C                   When      PINKL = *ON
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   Exsr      SrClearScn
     C                   Eval      WRdNBrw = *BLANK
     C                   Eval      WScrn   = 'I'
      *
      ** F15 - build browse.
     C                   When      PINKP = *ON
     C                   Exsr      SRSetupKey
     C                   Exsr      SrBldBrw
      *
      ** Enter key was pressed.  Validate input to initial screen.
     C                   OTHER
 
     C                   Exsr      SrValScrn1
 
     C                   ENDSL
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValScrn1 - Validate input to initial screen                *
      *                                                               *
      *****************************************************************
     C     SrValScrn1    BEGSR
      *
      ** Allow details to be amended on Insert
     C                   Eval      PEdtFld = 'Y'
      *
      ** Validate key fields and retrieve Trades Details.
     C                   Exsr      SrRtvTRSM
      *
     C                   Eval      WReDisplay = *BLANK
      *
      ** If no errors occurred during validation of key fields, check
      ** if there are warnings which have not been displayed yet.
      *
     C                   If        IDx = *ZERO
 
     C                   Z-Add     1             WiX
 
     C                   Dow       WiX <= WIDx AND WReDisplay = *BLANK
 
     C                   If        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   Eval      WReDisplay = 'Y'
     C                   Else
     C                   Eval      WiX = WiX + 1
     C                   EndIf
 
     C                   Enddo
 
     C                   If        WReDisplay <> 'Y'
     C                   Exsr      SrResetErr
     C                   EndIf
 
     C                   EndIf
      *
      ** Errors occurred during retrieval of security Trade Settlement
      ** details, and/or in the validation of initial key fields.
      *
     C                   If        IDx <> *ZERO OR WReDisplay = 'Y'
     C                   GoTo      EndValScrn1
     C                   EndIf
      *
      ** Convert Security Trade Settlement Details from file to screen
      *  format
     C                   Exsr      SrCvtTRSM
      *
      ** Initialise work variable for defaulting.
     C                   Eval      WProcOnce = *BLANK
      *
      ** Display the main screen.
     C                   Eval      WScrn  = 'P'
 
     C     EndValScrn1   EndSr
      *
      *****************************************************************
      *                                                               *
      *  SrScreen2 - Process main screen                              *
      *                                                               *
      *****************************************************************
     C     SrScreen2     BEGSR
      *
      ** Windows processing is on.
     C                   If        BGWDPR = 'Y'
      *
      ** If Trade Number, Movement Date, Full Settlement or Reversal
      ** have changed, clear any possible updates in window function
      *
     C                   If        DDTRDR <> WDDTRDR OR
     C                             DDMVDT <> WDDMVDT OR
     C                             DDFSET <> WDDFSET OR
     C                             DDREVE <> WDDREVE
     C                   ROLBK
     C                   EndIf
      *
      ** Save Key Fields
     C                   Movel     DDTRDR        WDDTRDR
     C                   Movel     DDMVDT        WDDMVDT
     C                   Movel     DDFSET        WDDFSET
     C                   Movel     DDREVE        WDDREVE
 
     C                   EndIf
      *
      ** Enable all fields on the main screen as well as all function keys.
     C                   If        PEdtFld = 'Y'
     C                   Eval      PEINKE  = 'Y'
     C                   Else
     C                   Eval      PEINKE  = 'N'
     C                   EndIf
      *
     C                   Eval      PEINKG  = 'Y'
     C                   Eval      PEINKH  = 'Y'
     C                   Eval      PEINKP  = 'Y'
     C                   Eval      PEINKL  = 'Y'
      *
      ** Set Calling module to *SIN
     C                   Move      '*SIN'        CallerCode        4
      *
      ** Display maintenance screen.
     C                   CALLB     'SETRSM2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *Blanks       RetCodeOut
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode
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
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
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
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Save warning message ids array of this screen.
     C                   MoveA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
     C                   Exsr      SrResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   When      PINKC = *ON
     C                   Exsr      SrEndP
      *
      ** F5 - refresh main screen details.
     C                   When      PINKE = *ON
     C                   Exsr      SrSavKey
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
     C                   Exsr      SRRstKey
     C                   Eval      WProcOnce = *BLANK
      *
      ** F7 - roll backwards.
     C                   When      PINKG = *ON
     C                   Exsr      SRRoll
      *
      ** F8 - roll forwards.
     C                   When      PINKH = *ON
     C                   Exsr      SRRoll
      *
      ** F12 - cancel on main screen.
     C                   When      PINKL = *ON
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   Exsr      SrClearScn
     C                   Eval      WRdNBrw = *BLANK
     C                   Eval      WScrn   = 'I'
      *
      ** F15 - build browse.
     C                   When      PINKP = *ON
     C                   Exsr      SrBldBrw
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - Validate input to main screen.
     C                   If        PEdtFld = 'Y'
     C                   Exsr      SrValScrn2
     C                   Else
      *
      ** Action is Enquire
      ** - Display window screen if window processing is on.
      ** - Read next browse subfile record if pending option
      **   still exist.  Otherwise, display initial screen with
      **   blank screen fields.
     C                   If        BGWDPR = 'Y'
     C                   Eval      WScrn = 'W'
     C                   Goto      EndScreen2
     C                   EndIf
      *
     C                   If        WRdNBrw = 'Y'
     C                   Eval      WScrn = 'R'
     C                   Else
     C                   Exsr      SrClearScn
     C                   Eval      WScrn = 'I'
     C                   EndIf
      *
     C                   EndIf
      *
     C                   EndSL
 
     C     EndScreen2    ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrValScrn2 - Validate input to main screen                   *
      *                                                               *
      *****************************************************************
     C     SrValScrn2    BEGSR
      *
      ** Validate entries made on the screen.
     C                   CALLB     'SETRSMVAL'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** SE Trade Settlement screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwTS1ScnFmt
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
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
      ** Warning flds/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
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
     C                   Eval      WReDisplay = *BLANK
      *
      ** If no errors occurred during validation of main screen
      ** fields, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   If        IDx = *ZERO
 
     C                   Z-Add     1             WiX
 
     C                   Dow       WiX <= WIDx AND WReDisplay = *BLANK
 
     C                   If        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   Eval      WReDisplay = 'Y'
     C                   Else
     C                   Eval      WiX = WiX + 1
     C                   EndIf
 
     C                   Enddo
 
     C                   If        WReDisplay <> 'Y'
     C                   Exsr      SrResetErr
     C                   EndIf
 
     C                   EndIF
      *
      ** Redisplay main screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   If        IDx <> *ZERO Or WReDisplay = 'Y'
     C                   Goto      EndValP
     C                   EndIf
      *
      ** If windows processing is installed, process window.
      ** Otherwise process confirmation.
     C                   If        BGWDPR = 'Y'
     C                   Eval      WScrn = 'W'
     C                   Else
     C                   Eval      WScrn = 'F'
     C                   EndIf
 
     C     EndValP       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnW - Process Window screen                              *
      *                                                               *
      *****************************************************************
     C     SrScrnW       BEGSR
      *
      ** Display window screen.
      *
      /COPY WNCPYSRC,SETRSMMV1
      *
      ** Call window manager.
      *
     C                   CALL      'WN0010'
     C                   Parm      'SETRSMSIN'   PWPgm
     C                   Parm                    PWKey
     C                   Parm                    PWAction
     C                   Parm                    Data
     C                   Parm      *BLANKS       PWRtn
     C                   Parm                    PWSpare
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   When      PWRtn = 'Y2U9999'
     C                   Exsr      SrEndP
      *
      ** F12 - cancel.  Display main details screen.
     C                   When      PWRtn = 'USR0790'
     C                   Eval      WScrn = 'P'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Proceed to confirmation screen if Action is amend or Insert
     C                   If        PEdtFld = 'Y'
     C                   Eval      WScrn = 'F'
     C                   Else
      *
      ** Action is Enquire
      ** Read next browse subfile record if pending option
      ** still exist.  Otherwise, display initial screen with
      ** blank screen fields.
     C                   If        WRdNBrw = 'Y'
     C                   Eval      WScrn = 'R'
     C                   Else
     C                   Exsr      SrClearScn
     C                   Eval      WScrn = 'I'
     C                   EndIf
      *
     C                   EndIf
 
     C                   EndSl
      *
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrScrnF - Process confirmation screen                        *
      *                                                               *
      *****************************************************************
     C     SrScrnF       BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
     C                   Exsr      SrResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   Eval      WFldNamArr(1) = '*ANY'
     C                   Eval      WMsgIdArr(1) = 'MMM1031'
      *
     C                   Eval      PEDtFld = 'N'
      *
      ** Display confirmation screen.
     C                   CALLB     'SETRSM2DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM                    CallerCode
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
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM      'N'           PEINKE
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
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
     C                   PARM      'N'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single Branch Code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Reset error fields.
     C                   EXSR      SrResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   When      PINKC = *ON
     C                   Exsr      SrEndP
      *
      ** F12 - cancel.
     C                   When      PINKL = *ON
     C                   Eval      WScrn  = 'P'
      *
      ** Enter key was pressed.  Update record.
     C                   OTHER
 
     C                   Eval      WScrn = 'U'
     C                   EndSl
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrUpdate - Process file update                               *
      *                                                               *
      *****************************************************************
     C     SrUpdate      BEGSR
      *
      ** Update all the remainig data required for file SETLED
      *
      ** Initialise fields
     C                   Z-Add     *Zeros        TotalValSet
     C                   Z-Add     *Zeros        WValSet
     C                   Z-Add     *Zeros        VTSSSQN
     C                   Z-Add     *Zeros        VTSSDAM
     C                   Eval      VTSSSSN = *Blanks
     C                   Eval      VTSSCPN = *Blanks
      *
     C                   Eval      VTSRECI = 'D'
      *
      ** Trade Reference
     C                   Eval      VTSSTDR = DDTRAD
      *
      ** Settlement Sequence
     C     TSSQ          Add       1             VTSSSQN
      *
      ** Branch Code
     C                   Eval      VTSSBCA = DDBRCD
      *
      ** Movement Date
     C                   Eval      PDateAIn = DDMDAT
     C                   Exsr      SrZDate1
     C                   If        PErrorFlag = 'N'
     C                   Z-Add     PDaynoOut     VTSSEDE
     C                   EndIf
      *
      ** Settlement Indicator
     C                   If        DDFSET = *Blanks
     C                   Eval      VTSSFSI = 'N'
     C                   Else
     C                   Eval      VTSSFSI = DDFSET
     C                   EndIf
      *
      ** Reversal Indicator
     C                   If        DDREVR = *Blanks
     C                   Eval      VTSSRIN = 'N'
     C                   Else
     C                   Eval      VTSSRIN = DDREVR
     C                   EndIf
      *
      ** Reported on Security Ledger
     C                   Eval      VTSSRSL = *Blanks
      *
      ** Value Fully Settled Indicator
     C                   Select
     C     TOSV          WhenGt    0
     C                   Eval      VTSSFSL = 'P'
     C     TOSV          WhenLt    0
     C                   Eval      VTSSFSL = 'O'
     C     TOSV          Wheneq    0
     C                   Eval      VTSSFSL = 'F'
     C                   Endsl
      *
      ** Nominal fully settled indicator
     C                   Select
     C     TOSN          WhenGt    0
     C                   Eval      VTSSNFS = 'P'
     C     TOSN          WhenLt    0
     C                   Eval      VTSSNFS = 'O'
     C     TOSN          Wheneq    0
     C                   Eval      VTSSNFS = 'F'
     C                   Endsl
      *
      ** Over-settlement indicator
     C                   If        TOSV < 0
     C                   Eval      VTSSOSI = 'Y'
     C                   Else
     C                   Eval      VTSSOSI = *Blanks
     C                   EndIf
      *
      ** Discrepancy amount
     C                   If        DDFSET = 'Y'
     C                   Eval      PCyCd = SETC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPO
     C                   Eval      PCyCd = TNMC
     C                   Exsr      SrAOCurr
     C                   Z-Add     A6NBDP        ZCDPI
     C                   Z-Add     TCTR          ZAMTCI
     C                   Z-Add     TDER          ZEXCH
     C                   Move      TMDI          ZMD
     C                   Move      TNMC          ZCCYI
     C                   Move      SETC          ZCCYO
     C                   Exsr      SrZconv
     C     TVSN          Add       TVSP          WValSet          15 0
     C     WValSet       Add       TOSV          TotalValSet      15 0
     C     TotalValSet   Sub       ZAMTCO        VTSSDAM
     C                   Else
     C                   Z-Add     0             VTSSDAM
     C                   EndIf
      *
      ** Discrepancy indicator
     C                   If        VTSSDAM <> *Zeros
     C                   Eval      VTSSDSI = 'Y'
     C                   Else
     C                   Eval      VTSSDSI = ' '
     C                   EndIf
      *
      ** Security shortname
     C                   Move      TDSS          VTSSSSN
      ** Counterparty number
     C                   Move      TCNR          VTSSCPN
      ** Market indicator
     C                   Move      TDMI          VTSSMKI
      ** Trade type
     C                   Move      TDTP          VTSSTET
      ** Settlement currency
     C                   Move      SETC          VTSSSCY
      ** Book Code
     C                   Move      TDBK          VTSSBOC
      ** Auto-Settled
     C                   Move      AUTS          VTSAUTS
      ** Last Change Date
     C                   Z-Add     BJRDNB        VTSLCD
      ** Change Type
     C                   Move      'I'           VTSCHTP
      *
      ** Process Agency
     C                   Eval      VTSSPAG = *Blanks
      *
      ** Access Securities Clients Details
     C                   If        DDFSET = 'Y'
     C                             Or DDREVR = 'Y' and TDFS <> 0
     C                   Move      TCNR          PSCnum
     C                   CallB     'AOSECSR0'
     C                   Parm      *BLANKS       PRtcd
     C                   Parm      '*KEY'        POptn
     C                   Parm                    PSCnum
     C     SDSECS        Parm      SDSECS        DSSDY
     C                   If        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   Eval      DBKey = POptn
     C                   Eval      DBFile= 'SDSECSPD'
     C                   Eval      DBase = 005
     C                   OUT       LDA
     C                   Exsr      *PSSR
     C                   EndIf
      *
     C                   If        BFCLAS = 'M'
     C                   If        ORDE <> *Zeros And ORDE <> 999999
     C                             Or ATRD = 'M'
     C                   If        DDFSET = 'Y'
     C                   Eval      VTSSPAG = 'P'
     C                   Endif
     C                   If        DDREVR = 'Y' and TDFS <> 0
     C                   Eval      VTSSPAG = 'R'
     C                   Endif
     C                   Endif
     C                   Endif
      *
     C                   Endif
      *
      ** Update file.
     C                   CALLB     'SETRSMUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Trade Settlement Details for file update - file format
     C                   PARM                    NwTSFilFmt
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   If        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
 
     C                   ROLBK
     C                   Exsr      *PSSR
 
     C                   Else
 
     C                   If        RetCodeOut = '*RECUPD'
     C                   ROLBK
     C                   Else
     C                   COMMIT
     C                   EndIf
 
     C                   EndIf
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
      *
     C                   If        RetCodeOut = '*RECUPD'
     C                   Z-Add     1             IDx
     C                   Eval      FldNameArr(IDx) = '*ANY'
     C                   Eval      MsgIdArr(IDx) = 'APM1000'
     C                   EndIf
      *
      ** Read next browse subfile record.
     C                   If        WRdNBrw = 'Y'
     C                   Eval      WScrn = 'R'
     C                   Goto      EndUpdate
     C                   EndIf
      *
      ** Display initial screen with blank screen fields.
     C                   Exsr      SrClearScn
     C                   Eval      WScrn = 'I'
 
     C     EndUpdate     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
     C     SrBldBrw      BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   EVAL      WRdNBrw = *BLANK
      *
      ** Display browse screen.
      *
     C                   CALLB     'SETRSMBRW'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build subfile
     C                   PARM      'Y'           PBdSfl
      *
      ** Read subfile record
     C                   PARM      *BLANK        PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - Default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Key fields selected
      **  Trade Reference Number
      **  Movement Date
      **  Full Settlement
      **  Reversal
      **  Sequence Number
     C                   PARM                    PTRADSel
     C                   PARM                    PMVDTSel
     C                   PARM                    PFSETSel
     C                   PARM                    PREVESel
     C                   PARM                    PSEQNSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
     C                   SELECT
      *
      ** F3 - End program.
     C                   When      PINKC = *ON
     C                   Exsr      SrEndP
      *
      ** Error message returned from browse.
     C                   When      PErrMs <> *BLANKS
     C                   Exsr      SrSndM
      *
      ** F12 - Cancel. Go back to initial screen.
     C                   When      PINKL = *ON
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   Exsr      SrClearScn
     C                   Eval      WScrn = 'I'
      *
      ** Enter - read selected subfile records.
     C                   OTHER
 
     C                   Eval      WRdNBrw = 'Y'
     C                   Eval      WScrn   = 'R'
 
     C                   ENDSL
 
     C     ESrBldBrw     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
     C     SrRdNBrw      BEGSR
      *
      ** Display browse screen.
      *
     C                   CALLB     'SETRSMBRW'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Build subfile
     C                   PARM      *BLANK        PBdSfl
      *
      ** Read subfile record
     C                   PARM      'Y'           PRdSfl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** ZMUSER - Default user branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Option selected
     C                   PARM                    POpSel
      *
      ** Key fields selected
      **  Trade Reference Number
      **  Movement Date
      **  Full Settlement
      **  Reversal
      **  Sequence Number
     C                   PARM                    PTRADSel
     C                   PARM                    PMVDTSel
     C                   PARM                    PFSETSel
     C                   PARM                    PREVESel
     C                   PARM                    PSEQNSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL
      *
      ** If no Trade Settlement record selected from subfile,
      ** reset read next browse subfile record indicator and then
      ** display initial screen with blank key fields.
      *
     C                   If        POpSel = *BLANK
     C                   Exsr      SrClearScn
     C                   Eval      WRdNBrw = *BLANK
     C                   Eval      WScrn   = 'I'
     C                   GoTo      ESrRdNBrw
     C                   EndIf
      *
      ** Update action code with option selected.
      *
     C                   Eval      DDACTN = POpSel
      *
      ** Default action to enquiry if not valid.
     C                   Eval      DDACTN = 'E'
     C                   Eval      PEdtFld = 'N'
      *
      ** Retrieve Trade Settlement details form File.
     C                   Eval      DDTRDR = PTRADSel
     C                   Eval      DDMVDT = PMVDTSel
     C                   Eval      DDFSET = PFSETSel
     C                   Eval      DDREVE = PREVESel
 
     C                   Exsr      SrRtvTRSM
      *
      ** If warning or error occurred in the retrieval of Security Trade
      ** Settlement details, display messages on the initial screen.
      *
     C                   If        WIDx <> *ZERO OR IDx = 1 OR IDx > 1 AND
     C                             MsgIdArr(1) <> 'APM1000'
     C                   Eval      WScrn = 'I'
     C                   GoTo      ESrRdNBrw
     C                   EndIf
      *
      ** Put Security Trade Settlement Details on the screen.
      *
     C                   Z-Add     PSEQNSel      PSSEQN
      *
     C                   Exsr      SrCvtTRSM
      *
      ** Initialise work variable for defaulting.
     C                   Eval      WProcOnce = *BLANK
      *
      ** Display the main screen.
     C                   Eval      WScrn  = 'P'
 
     C     ESrRdNBrw     ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrRtvTRSM - Retrieve Security Trade Settlement Details       *
      *                                                               *
      *****************************************************************
     C     SrRtvTRSM     BEGSR
 
     C                   CALLB     'SETRSMRTV'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*FRONT' (Front Office Transaction Interface)
      ** Mode = '      ' (Not Front Office Transaction Interface)
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Front office transaction Id
     C                   PARM      *BLANK        PFRNT
      *
      ** Trade Reference
     C                   PARM                    DDTRDR
      *
      ** Movement Date
     C                   PARM                    DDMVDT
      *
      ** Full Settlement
     C                   PARM                    DDFSET
      *
      ** Reversal
     C                   PARM                    DDREVE
      *
      ** Enable detail fields indicator
     C                   PARM                    PEDtFld
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ** SDBANK - Run day number
     C                   PARM                    BJRDNB
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
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
      ** OK Trade Reference
     C                   PARM                    OKTRDR
      *
      ** OK Movement Date
     C                   PARM                    OKMVDT
      *
      ** OK Full Settlement
     C                   PARM                    OKFSET
      *
      ** OK Reversal
     C                   PARM                    OKREVE
      *
      ** Security Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrCvtTRSM - Converts Security Trade Settlement details from  *
      *              file to screen format.                           *
      *                                                               *
      *****************************************************************
     C     SrCvtTRSM     BEGSR
 
     C                   CALLB     'SETRSMCVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Mode = '*RPR  ' (Repair function)
      ** Mode = '*SIN  ' (Screen input function)
     C                   PARM                    PMode
      *
      ** Enable detail fields indicator
     C                   PARM                    PEdtFld
      *
      ** SE Trade Details retrieved from file - file format
     C                   PARM                    CrTDFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
      ** Settlement Sequence Number
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
     C                   PARM                    PSSEQN
      *
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** OUTPUT
      ** ======
      *
      ** SE Trade Settlement screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrTS1ScnFmt
 
     C                   Eval      NwTS1ScnFmt = CrTS1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrRoll - Roll backward or forward through the Security       *
      *           Trade Settlement Details                            *
      *                                                               *
      *****************************************************************
     C     SrRoll        BEGSR
      *
      ** Reset/clear previous error/warning messages for every new record.
      *
     C                   Exsr      SrResetErr
      *
      ** Read next or previous record in the Trade Settlement details file
      ** according to function key pressed (F7=INKG or F8=INKH).
      *
     C                   If        PINKG = *ON
     C                   Eval      PRdBck = 'Y'
     C                   Eval      PRdFwd = *BLANK
     C                   Else
     C                   Eval      PRdBck = *BLANK
     C                   Eval      PRdFwd = 'Y'
     C                   EndIf
 
     C                   CallB     'SETRSMRED'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Trade Number
      ** Movement Date
      ** Full Settlement
      ** Reversal
     C                   PARM                    DDTRDR
     C                   PARM                    DDMVDT
     C                   PARM                    DDFSET
     C                   PARM                    DDREVE
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
      ** SDBANK - Date format indicator
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
      **  Trade Reference Number
      **  Movement Date
      **  Full Settlement
      **  Reversal
      **  Sequence Number
     C                   PARM                    PTRADSel
     C                   PARM                    PMVDTSel
     C                   PARM                    PFSETSel
     C                   PARM                    PREVESel
     C                   PARM                    PSEQNSel
      *
      ** If error message returned from read, send it to screen.
      *
     C                   If        PErrMs <> *BLANKS
     C                   Exsr      SrSndM
     C                   GoTo      ESrRoll
     C                   EndIf
      *
      ** Default Action to Enquiry.
      *
     C                   Eval      DDACTN = 'E'
     C                   Eval      PEdtFld = 'N'
      *
      ** Retrieve Trade Settlement details form File.
     C                   Eval      DDTRDR = PTRADSel
     C                   Eval      DDMVDT = PMVDTSel
     C                   Eval      DDFSET = PFSETSel
     C                   Eval      DDREVE = PREVESel
 
     C                   Exsr      SrRtvTRSM
      *
      ** If warning or error occurred in the retrieval of Trade
      ** Settlements details, display messages on the initial screen.
      *
     C                   If        WIDx <> *ZERO OR IDx <> *ZERO
     C                   Eval      WScrn = 'I'
     C                   GoTo      ESrRoll
     C                   EndIf
      *
      ** Put Security Trade Settlement details on the screen.
      *
     C                   Z-Add     PSEQNSel      PSSEQN
      *
     C                   EXSR      SrCvtTRSM
      *
      ** Initialise work variable for defaulting.
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display the main screen.
     C                   EVAL      WScrn = 'P'
 
     C     ESrRoll       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSavKey - Save key fields to a temporary variable.          *
      *                                                               *
      *****************************************************************
     C     SrSavKey      BEGSR
 
     C                   Eval      WDTRDR = DDTRDR
     C                   Eval      WDMVDT = DDMVDT
     C                   Eval      WDFSET = DDFSET
     C                   Eval      WDREVE = DDREVE
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrRstKey - Restore key fields.                               *
      *                                                               *
      *****************************************************************
     C     SrRstKey      BEGSR
 
     C                   Eval      DDTRDR = WDTRDR
     C                   Eval      DDMVDT = WDMVDT
     C                   Eval      DDFSET = WDFSET
     C                   Eval      DDREVE = WDREVE
      *
      ** Initialise keylists for use in browse module.
     C                   CLEAR                   KeyLists
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSetupKey - Setup keys for pointer or selection.            *
      *                                                               *
      *****************************************************************
     C     SrSetupKey    BEGSR
 
     C                   Eval      WDTRDR = DDTRDR
     C                   Eval      WDMVDT = DDMVDT
     C                   Eval      WDFSET = DDFSET
     C                   Eval      WDREVE = DDREVE
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrClearScn - Clear screen data structures                    *
      *                                                               *
      *****************************************************************
     C     SrClearScn    BEGSR
      *
      ** Clear screen data structures for new processing.
      *
     C                   CLEAR                   CrTS1ScnFmt
     C                   CLEAR                   NwTS1ScnFmt
     C                   CLEAR                   CrTDFilFmt
     C                   CLEAR                   Psectyd
     C                   CLEAR                   NwTSFilFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrEndP - Set program to end                                  *
      *                                                               *
      *****************************************************************
     C     SrEndP        BEGSR
      *
      ** Issue rollback to clear any possible updates in lower
      ** level programs.
     C                   RolBk
      *
      ** Set processing to end program.
     C                   Eval      WScrn = 'E'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
     C     SrSndM        BEGSR
      *
      ** If single branching, user cannot browse file.
     C                   If        PErrMs = 'FXM0292'
     C                   Eval      OKTRDR = 'N'
     C                   EndIf
      *
      ** Date format is invalid, user cannot browse file.
     C                   If        PErrMs = 'USR2031'
     C                   Eval      OKMVDT = 'N'
     C                   EndIf
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-Add     1             Ex
     C     *Blank        LookUp    FldNameArr(Ex)                         99
     C                   Eval      FldNameArr(Ex) = '*ANY'
     C                   Eval      MsgIdArr(Ex) = PErrMs
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
     C     SrResetErr    BEGSR
      *
      ** Reset error fields.
      *
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   CLEAR                   IDx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   CLEAR                   WIDx
      *
      ** Initialise screen fields error indicators.
     C                   Eval      SEETRSM = *ALL'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrAOCurr - Check currency details                            *
      *                                                               *
      *****************************************************************
     C     SrAOCurr      BEGSR
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *BLANKS       PRtCd
     C                   Parm      '*KEY   '     POptn
     C                   Parm                    PCyCd
     C     SDCURR        Parm      SDCURR        DSSDY
 
     C                   If        PRtCd <> *BLANKS
     C                   Eval      DBKey = PCyCd
     C                   Eval      DBFile = 'SDCURRPD'
     C                   Z-Add     1             DBASE
     C                   Exsr      *PSSR
     C                   EndIf
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZconv - Convert an amount from one currency to another     *
      *                                                               *
      *****************************************************************
     C     SrZconv       Begsr
 
     C                   CallB     'ZCONV'
     C                   Parm                    ZAMTCI           15 0
     C                   Parm                    ZEXCH            13 8
     C                   Parm                    ZMD               1
     C                   Parm                    ZCCYI             3
     C                   Parm                    ZCCYO             3
     C                   Parm                    ZCDPI             1 0
     C                   Parm                    ZCDPO             1 0
     C                   Parm                    ZAMTCO           15 0
      *
     C                   Endsr
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SrZDate1 - Validate and convert date to day number           *
      *                                                               *
      *****************************************************************
     C     SrZDate1      BEGSR
 
     C                   CallB     'ZDATE1'
     C                   Parm                    PDateAIn
     C                   Parm      *ZERO         PDaynoOut
     C                   Parm                    BJDFIN
     C                   Parm      *Blanks       PErrorFlag
 
     C                   ENDSR
      *
      *****************************************************************
      *                                                               *
      *  SrZDate2 - Convert Midas Date into DDMMYY or MMDDYY          *
      *                                                               *
      *****************************************************************
     C     SrZDate2      BEGSR
      *
     C                   CallB     'ZDATE2'
     C                   Parm                    PDateIn
     C                   Parm                    BJDFIN
     C                   Parm      *ZERO         PDateOut
     C                   Parm      *BLANKS       PADateOut
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
     C     *INZSR        BEGSR
      *
      ** Access bank details.
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDBANKPD'
     C                   EVAL      DBase = 001
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access securities trading ICD details.
     C                   CALLB     'AOSTRDR0'
     C                   PARM      '*DBERR '     PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDSTRDPD'
     C                   EVAL      DBase = 002
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Midas modules details.
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtCd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error.
     C                   IF        PRtcd <> *BLANKS
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile= 'SDMMODPD'
     C                   EVAL      DBase = 003
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Corporate Actions' feature
      ** is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE007'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE007
     C                   ELSE
     C                   MOVEL     'N'           CSE007
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Securities Redenomination'
      ** feature is installed.
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU017'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CEU017
     C                   ELSE
     C                   MOVEL     'N'           CEU017
     C                   ENDIF
      *
      ** Retrieve ZMUSER details.
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
     C                   EVAL      WScrn = 'I'
      *
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SETRSM011
 
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
(c) Finastra International Limited 2003
