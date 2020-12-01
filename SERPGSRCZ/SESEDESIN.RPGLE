     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Security diary events input')                 *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESEDESIN - Security Diary Events Input Program              *
      *                                                               *
      *  Function: This module will be the input module for the       *
      *            screen-input function for Security Diary Events    *
      *            maintenance.                                       *
      *                                                               *
      *  Component of: SESEDESIN                                      *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 260331             Date 31Mar16               *
      *                 CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 CSE072             Date 05Apr05               *
      *                 BUG2064            Date 29May04               *
      *                 BUG2604            Date 18May04               *
      *                 CAS006             Date 21Jan03               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 09Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      *                 CAP140  *CREATE    Date 17Oct00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *             (Recompile)                                       *
      *  MD046248 - Finastra Rebranding                               *
      *  260331 - Incorrect posting created due to a deleted diary    *
      *           event. Applied fix 255857.                          *
      *         - Applied for MD-37742.                               *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation of Savings Income                          *
      *  CSE065 - Const. Yield Amort. on Mortgage backed assets       *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  CSE072 - INT-CC3 - Brazilian C-Bonds                         *
      *  BUG2064 - Initialization of CSC022.                          *
      *  BUG2604 - Commitment Control Changes for MidasPlus. (CSC022) *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  CSE031 - Coupon Fixing for Floating Rate Notes               *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
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
      *  SRScrnI - Process initial screen                             *
      *  SRValI - Validate input to initial screen                    *
      *  SRScrnP - Process main screen                                *
      *  SRDefault - Process defaulting of default fields             *
      *  SRValP - Validate input to main screen                       *
      *  SRScrnW - Process Window screen                              *
      *  SRScrnF - Process confirmation screen                        *
      *  SRUpdate - Process file update                               *
      *  SRBldBrw - Build browse subfile record                       *
      *  SRRdNBrw - Read next browse subfile record                   *
      *  SRRtvSEDE - Retrieve security diary events details.          *
      *  SRCvtSEDE - Converts security diary events details from      *
      *              file to screen format.                           *
      *  SRRoll - Roll backward or forward through the security       *
      *           diary events details.                               *
      *  SRSavKey - Save key fields to a temporary variable.          *
      *  SRRstKey - Restore key fields.                               *
      *  SRSetupKey - Setup keys for pointer or selection.            *
      *  SRClearScn - Clear screen data structures                    *
      *  SREndP - Set program to end                                  *
      *  SRSndM - Send error message to screen                        *
      *  SRResetErr - Reset error fields                              *
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
      ** Midas module flag - details
     FMMODF     IF   E             DISK    INFSR(*PSSR)
      *
      ** Hook to enable non-core files to be included
      /COPY WNCPYSRC,SESEDE001
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
      /COPY QWINDSRC,SESEDEDTA
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
                                                                                             BUG2604
      * Array to hold Commitment Job Names                                                   BUG2604
     D CmtJobNArr      S             10A   DIM(10)                                           BUG2604
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     D CrDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
     D                                     PREFIX(O)
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     D NwDE1ScnFmt   E DS                  EXTNAME(SESEDEPD)
      *
      ** SE Diary events screen error indicators
     D SEESEDE       E DS                  EXTNAME(SEESEDEPD)
      *
      ** SE Diary events for file update - file format
     D NwDEFilFmt    E DS                  EXTNAME(SEVSEDEPD)
     D NwDeFilFmt1             1    231                                                       CSE065
      *
      ** SE Diary events retrieved from file - file format
     D CrDEFilFmt    E DS                  EXTNAME(SEDEVD)
     D                                     PREFIX(O)
     D CrDeFilFmt1             1    231                                                       CSE065
      *
      ** Externally described DS for security details
     D PSectyd       E DS                  EXTNAME(SECTYD)
     D                                     PREFIX(D1)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access objects - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                              CSC011
      ** Data structure for data area SC24X7                                                  CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** Data structure for data area SDSTAT                                                  CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      *
      ** Data structure for key fields
     D KeyLists        DS
     D  WDSDSN                 1     10A
     D  WDSDED                11     16A
     D  WDSDET                17     18A
      *
      ** Data structure for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10A
     D  PDBRN                 11     13A
     D  PDPPT                 14     16A
      *
      ** Commitment Control Data Area                                                        BUG2604
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                BUG2604
     D  wComitJob              4    103                                                      BUG2604
                                                                                             BUG2604
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
     D WOACTN          S              1A
     D WDDACTN         S              1A
     D WDDSDSN         S             10A
     D WDDSDED         S              6A
     D WDDSDET         S              2A
     D WScrn           S              1A
     D WRdNBrw         S              1A
     D WProcOnce       S              1A
     D WiX             S              3P 0
      *
      ** Work parameters
     D PReDsp          S              1A
     D CSE010          S              1A
     D S01509          S              1A
     D S01510          S              1A
     D CSE031          S              1A                                                      CSE031
     D CAS006          S              1A                                                      CAS006
     D CSE072          S              1A                                                      CSE072
     D CSE065          S              1A                                                      CSE065
     D CGL031          S              1A                                                      CGL031
     D PPROT           S              1A
     D PEDtFld         S              1A
     D PResetFld       S              1A
     D PAmendOk        S              1A
     D POpSel          S              1A
     D PRdBck          S              1A
     D PRdFwd          S              1A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D PSDETSel        S              2A
     D PPayCcy         S              3A
     D PEvtDno         S              5P 0
     D PSDEDSel        S              6A
     D PSARD           S              6A
     D PRtcd           S              7A
     D POptn           S              7A
     D PErrMS          S              7A
     D PSDSNSel        S             10A
     D PFRNT           S             20A
      *
      ** Output screen fields
     D DDCUCR          S             12A
     D DDSEXR          S             14A
     D DDMATY          S              8A                                                      CSE065
      *
      ** Parameters for WN0010
     D PWPgm           S             10A   INZ('SESEDESIN')
     D PWKey           S              2A
     D PWAction        S              1A
     D PWRtn           S              7A
     D PWSpare         S            256A
                                                                                              CSC011
      ** Define variables for CSC011                                                          CSC011
     D CSC011          S              1A                                                      CSC011
                                                                                              CSC011
      ** Work field for Date to be passed to RTV module                                       CSC011
     D PDate           S                   LIKE(BJRDNB)                                       CSC011
      *
      ** Work variables forBUG2604                                                           BUG2604
     DBUG2604          S              1A   INZ('N')                                          BUG2604
     D wCommitSkip     S              1A   INZ('N')                                          BUG2604
     D CSC022          S              1A                                                     BUG2064
                                                                                             BUG2604
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      /COPY WNCPYSRC,SESEDE002
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
      /COPY WNCPYSRC,SESEDE003
      *
      ** Read next browse subfile record.
      *
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdnBrw
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDE004
      *
      ** Do While screen - Initial details only.
      *
     C                   DOW       WScrn = 'I'
     C                   EXSR      SRScrnI
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESEDE005
      *
      ** Do While screen - Main screen details.
      *
     C                   DOW       WScrn = 'P'
     C                   EXSR      SRScrnP
     C                   ENDDO
      *
      /COPY WNCPYSRC,SESEDE006
      *
      ** Process window screen.
      *
     C                   IF        WScrn = 'W'
     C                   EXSR      SRScrnW
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDE007
      *
      ** Process confirmation.
      *
     C                   IF        WScrn = 'F'
     C                   EXSR      SRScrnF
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDE008
      *
      ** Process file update.
      *
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
      *
      /COPY WNCPYSRC,SESEDE009
      *
      ** Terminate program.
      *
     C                   IF        WScrn = 'E'
     C                   EVAL      *INLR = *ON
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SESEDE010
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnI - Process initial screen                             *
      *                                                               *
      *****************************************************************
     C     SRScrnI       BEGSR
      *
      ** If windows processing is on, clear any possible updates
      ** in window function.
      *
     C                   IF        BGWDPR = 'Y'
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        wCommitSkip = 'N'                                         BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
     C                   ENDIF
      *
      ** Enable all fields on initial screen as well as all function keys.
      *
     C                   EVAL      PEINKE  = 'Y'
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
      *
      ** Display initial screen.
      *
     C                   CALLB     'SESEDEIDP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Action code
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    DDACTN
     C                   PARM                    DDSDSN
     C                   PARM                    DDSDED
     C                   PARM                    DDSDET
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
      ** Action code
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    OKACTN
     C                   PARM                    OKSDSN
     C                   PARM                    OKSDED
     C                   PARM                    OKSDET
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
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh initial screen details.
     C                   WHEN      PINKE = *ON
     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *
      ** F12 - cancel on initial screen.
     C                   WHEN      PINKL = *ON
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   EXSR      SRClearScn
     C                   EVAL      WRdNBrw = *BLANK
     C                   EVAL      WScrn   = 'I'
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRSetupKey
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.  Validate input to initial screen.
     C                   OTHER
 
     C                   EXSR      SRValI
 
     C                   ENDSL
 
     C     ESRScrnI      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValI - Validate input to initial screen                    *
      *                                                               *
      *****************************************************************
     C     SRValI        BEGSR
      *
      ** Validate key fields and retrieve security diary events details.
      *
     C                   EXSR      SRRtvSEDE
      *
     C                   EVAL      WReDisplay = *BLANK
      *
      ** If no errors occurred during validation of key fields, check
      ** if there are warnings which have not been displayed yet.
      *
     C                   IF        IDx = *ZERO
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WReDisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Errors occurred during retrieval of security diary events
      ** details, and/or in the validation of initial key fields.
      *
     C                   IF        IDx <> *ZERO OR WReDisplay = 'Y'
     C                             OR PReDsp = 'Y'
     C                   GOTO      ESRValI
     C                   ENDIF
      *
      ** Move the security diary events details from the master
      ** database file into the update file record.  If no record
      ** has been retrieved (happens on insert mode), fields contain
      ** initial values.
      *
     C**********         EVAL      NwDEFilFmt = CrDEFilFmt
     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** If action code is not insert, convert security diary events
      ** details on main screen.
      *
     C                   IF        DDACTN <> 'I'
     C                   EXSR      SRCvtSEDE
     C                   ENDIF
      *
      ** Initialise work variable for defaulting.
      *
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display the main screen.
      *
     C                   EVAL      WScrn  = 'P'
 
     C     ESRValI       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnP - Process main screen                                *
      *                                                               *
      *****************************************************************
     C     SRScrnP       BEGSR
      *
      ** Windows processing is on.
      *
     C                   IF        BGWDPR = 'Y'
      *
      ** If Action code and Security shortname, diary event date
      ** and event type have changed, clear any possible updates
      ** in window function.
      *
     C                   IF        DDACTN <> WDDACTN OR
     C                             DDSDSN <> WDDSDSN OR
     C                             DDSDED <> WDDSDED OR
     C                             DDSDET <> WDDSDET
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        wCommitSkip = 'N'                                         BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
     C                   ENDIF
      *
      ** Save Action code and Security shortname, event date and
      ** event type.
     C                   MOVEL     DDACTN        WDDACTN
     C                   MOVEL     DDSDSN        WDDSDSN
     C                   MOVEL     DDSDED        WDDSDED
     C                   MOVEL     DDSDET        WDDSDET
 
     C                   ENDIF
      *
      ** Enable all fields on the main screen as well as all function keys.
      *
     C                   EVAL      PEINKG  = 'Y'
     C                   EVAL      PEINKH  = 'Y'
     C                   EVAL      PEINKP  = 'Y'
     C                   EVAL      PEINKL  = 'Y'
      *
      ** Allow details to be amended on Insert or Amend mode.
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      PEdtFld = 'Y'
     C                   EVAL      PEINKE  = 'Y'
     C                   ELSE
     C                   EVAL      PEdtFld = 'N'
     C                   EVAL      PEINKE  = 'N'
     C                   ENDIF
      *
      ** If action made is Delete and no error found when retrieving
      ** details, allow deletion of record.
      *
     C                   IF        DDACTN = 'D' AND IDx = *ZERO
     C                   EVAL      PEINKJ  = 'Y'
     C                   ELSE
     C                   EVAL      PEINKJ  = 'N'
     C                   ENDIF
      *
      ** Process default fields for the next screen.
      *
     C                   EXSR      SRDefault
      *
      ** Display maintenance screen.
      *
     C                   CALLB     'SESEDE1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    DDMATY                                       CSE065
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
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
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
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
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Save warning message ids array of this screen.
      *
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F5 - refresh main screen details.
     C                   WHEN      PINKE = *ON
     C                   EXSR      SRSavKey
     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
     C                   EXSR      SRRstKey
     C                   EVAL      WProcOnce = *BLANK
      *
      ** F7 - roll backwards.
     C                   WHEN      PINKG = *ON
     C                   EXSR      SRRoll
      *
      ** F8 - roll forwards.
     C                   WHEN      PINKH = *ON
     C                   EXSR      SRRoll
      *
      ** F10 - delete record.
     C                   WHEN      PINKJ = *ON
     C                   EVAL      WScrn = 'U'
      *
      ** F12 - cancel on main screen.
     C                   WHEN      PINKL = *ON
      *
      ** Display initial screen with blank fields.
      ** Reset read next browse subfile record indicator.
     C                   EXSR      SRClearScn
     C                   EVAL      WRdNBrw = *BLANK
     C                   EVAL      WScrn   = 'I'
      *
      ** F15 - build browse.
     C                   WHEN      PINKP = *ON
     C                   EXSR      SRBldBrw
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - Validate input to main screen.
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EXSR      SRValP
     C                   GOTO      ESRScrnP
     C                   ENDIF
      *
      ** Action is Enquire
      ** - Display window screen if window processing is on.
      ** - Read next browse subfile record if pending option
      **   still exist.  Otherwise, display initial screen with
      **   blank screen fields.
     C                   IF        DDACTN = 'E'
 
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   GOTO      ESRScrnP
     C                   ENDIF
 
     C                   IF        WRdNBrw = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRScrnP      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRDefault - Process defaulting of default fields             *
      *                                                               *
      *****************************************************************
     C     SRDefault     BEGSR
 
     C     WProcOnce     IFEQ      *BLANK
 
     C                   CALLB     'SESEDE1DT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF  - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Dividend payments
     C                   PARM                    S01510
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    DDMATY                                       CSE065
 
     C                   ENDIF
      *
      ** Set default variable to 'Y' to bypass defaulting the
      ** second time around.
      *
     C                   EVAL      WProcOnce = 'Y'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValP - Validate input to main screen                       *
      *                                                               *
      *****************************************************************
     C     SRValP        BEGSR
      *
      ** Validate whether non-amendable fields have been amended.
      *
     C                   CALLB     'SESEDE1MD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events screen details retrieved from file
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Reset of fields in error required (Y/N)
     C                   PARM      'Y'           PResetFld
      *
      ** Pay currency
     C                   PARM                    PPayCcy
      *
      ** STANDING DATA
      ** =============
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message Ids/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IDx
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** OK Amendments field
     C                   PARM                    PAmendOK
      *
      ** Validate entries made on the screen.
      *
     C                   CALLB     'SESEDE1VL'
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
      ** SE Diary Events screen details from incoming
      ** transaction - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
                                                                                              CSE065
      ** SDBANK - Run day number                                                              CSE065
     C                   PARM                    BJRDNB                                       CSE065
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transactions Enhancement
     C                   PARM                    CSE010
      *
      ** Value CCY to be CCY of Issuer Payment
     C                   PARM                    S01509
      *
      ** Dividend Payments Base on EX-Date
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE072
      ** Brazilian C Bonds                                                                    CSE072
     C                   PARM                    CSE072                                       CSE072
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
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
      ** SE Diary Events screen error indicators
     C                   PARM                    SEESEDE
      *
      ** SE Diary Events for file update - file format
     C                   PARM                    NwDEFilFmt
      *
      ** Redisplay screen
     C                   PARM      *BLANK        PReDsp
 
     C                   EVAL      WReDisplay = *BLANK
      *
      ** If no errors occurred during validation of main screen
      ** fields, check if there are warnings which have not been
      ** displayed yet.
      *
     C                   IF        IDx = *ZERO
 
     C                   Z-ADD     1             WiX
 
     C                   DOW       WiX <= WIDx AND WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WiX) <> WPrvWarnAr(WiX)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WiX = WiX + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WReDisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   ENDIF
 
     C                   ENDIF
      *
      ** Redisplay main screen if there are errors or if there
      ** are warnings which have not been displayed yet.
      *
     C                   IF        IDx <> *ZERO OR WReDisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   GOTO      ESRValP
     C                   ENDIF
      *
      ** If windows processing is installed, process window.
      ** Otherwise process confirmation.
      *
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      WScrn = 'W'
     C                   ELSE
     C                   EVAL      WScrn = 'F'
     C                   ENDIF
 
     C     ESRValP       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnW - Process Window screen                              *
      *                                                               *
      *****************************************************************
     C     SRScrnW       BEGSR
      *
      ** Display window screen.
      *
     C                   CALLB     'SESEDE1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    DDMATY                                       CSE065
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
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
     C                   PARM                    PEINKE
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKL
     C                   PARM                    PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
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
     C                   PARM      'Y'           WriteOnly
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      /COPY WNCPYSRC,SESEDEMV1
      *
      ** Call window manager.
      *
     C                   CALL      'WN0010'
     C                   PARM      'SESEDESIN'   PWPgm
     C                   PARM                    PWKey
     C                   PARM      DDACTN        PWAction
     C                   PARM                    Data
     C                   PARM      *BLANKS       PWRtn
     C                   PARM                    PWSpare
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PWRtn = 'Y2U9999'
     C                   EXSR      SREndP
      *
      ** F12 - cancel.  Display initial screen.
     C                   WHEN      PWRtn = 'USR0790'
     C                   EVAL      WScrn = 'P'
      *
      ** Enter key was pressed.
     C                   OTHER
      *
      ** Action is Amend or Insert - proceed to confirmation screen.
     C                   IF        DDACTN  = 'I' OR DDACTN = 'A'
     C                   EVAL      WScrn = 'F'
     C                   ELSE
      *
      ** Action is Enquire
      ** Read next browse subfile record if pending option
      ** still exist.  Otherwise, display initial screen with
      ** blank screen fields.
     C                   IF        WRdNBrw = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
     C                   ENDIF
 
     C                   ENDIF
 
     C                   ENDSL
 
     C     ESRScrnW      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScrnF - Process confirmation screen                        *
      *                                                               *
      *****************************************************************
     C     SRScrnF       BEGSR
      *
      ** Reset error fields, specifically arrays for warning messages.
      *
     C                   EXSR      SRResetErr
      *
      ** Entries are valid or only warnings exist.  Output message
      ** "Press ENTER to apply transaction to database or F12 to change.".
      *
     C                   EVAL      WFldNamArr(1) = '*ANY'
     C                   EVAL      WMsgIdArr(1) = 'MMM1031'
      *
      ** Display confirmation screen.
      *
     C                   CALLB     'SESEDE1DP'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    NwDE1ScnFmt
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
                                                                                              CAS006
      ** Externally described DS for Security details                                         CAS006
     C                   PARM                    PSectyd                                      CAS006
      *
      ** Cumulative coupon rate
     C                   PARM                    DDCUCR
      *
      ** Current exchange rate
     C                   PARM                    DDSEXR
                                                                                              CSE065
      ** Maturity Date                                                                        CSE065
     C                   PARM                    DDMATY                                       CSE065
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Enable detail fields indicator
     C                   PARM      'N'           PEDtFld
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
     C                   PARM      'N'           PEINKJ
     C                   PARM      'Y'           PEINKL
     C                   PARM      'N'           PEINKP
      *
      ** SE Diary events screen error indicators
     C                   PARM                    SEESEDE
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
      ** SDBANK - System runday
     C                   PARM                    BJMRDT
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** Function keys enabled
      ** KC = command key 03 = Exit
      ** KE = command key 05 = Refresh
      ** KG = command key 07 = Read Previous
      ** KH = command key 08 = Read Next
      ** KJ = command key 10 = Delete
      ** KL = command key 12 = Cancel
      ** KP = command key 15 = Browse
     C                   PARM                    PINKC
     C                   PARM                    PINKE
     C                   PARM                    PINKG
     C                   PARM                    PINKH
     C                   PARM                    PINKJ
     C                   PARM                    PINKL
     C                   PARM                    PINKP
      *
      ** Reset error fields.
      *
     C                   EXSR      SRResetErr
 
     C                   SELECT
      *
      ** F3 - end program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** F12 - cancel.
     C                   WHEN      PINKL = *ON
     C                   EVAL      WScrn  = 'P'
      *
      ** Enter key was pressed.  Update record.
     C                   OTHER
 
     C                   EVAL      WScrn = 'U'
     C                   ENDSL
 
     C     ESRScrnF      ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Process file update                               *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
      *
      ** Action is delete - Update record id to 'C'.
      *
     C                   IF        DDACTN = 'D'
      *                                                                                       260331
      ** If Record Id is 'D', reset SDDT to zero                                              260331
      *                                                                                       260331
     C                   IF        S2RECI = 'D'                                               260331
     C                   IF        S2SDET = 'MP' OR S2SDET = 'DV'                             260331
     C                               OR S2SDET = 'PP'                                         260331
     C                   Z-ADD     0             S2SDDT                                       260331
     C                   ENDIF                                                                260331
     C                   ENDIF                                                                260331
      *                                                                                       260331
     C                   EVAL      S2RECI = 'C'
     C                   ENDIF
      *
      ** Action is insert.
     C                   IF        DDACTN = 'I'
     C                   EVAL      S2RECI = 'D'
     C                   EVAL      S2SDSN = DDSDSN
     C                   EVAL      S2SDED = PEvtDno
     C                   EVAL      S2SDET = DDSDET
     C                   EVAL      S2NMCY = D1NMCY
     C                   ENDIF
      *
      ** Setup last change type according to action done.
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A' OR
     C                             DDACTN = 'D'
     C                   EVAL      S2CHTP = DDACTN
     C                   ENDIF
      *
      ** Update file.
     C                   CALLB     'SESEDEUPD'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events for file update - file format
     C                   PARM                    NwDEFilFmt
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
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE Transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
      *
      ** If errors occurred on update, rollback uncommitted file
      ** changes.
      *
     C                   IF        RetCodeOut <> *BLANKS AND
     C                             RetCodeOut <> '*RECUPD'
 
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
     C                   ROLBK
     C                   EndIf                                                               BUG2604
     C                   EXSR      *PSSR
 
     C                   ELSE
 
     C                   IF        RetCodeOut = '*RECUPD'
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        wCommitSkip = 'N'                                         BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
     C                   ELSE
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                             Or (CSC022 = 'Y') And (wCommitSkip = 'N')                 BUG2604
     C                   COMMIT
     C                   EndIf                                                               BUG2604
     C                   ENDIF
 
     C                   ENDIF
      *
      ** If update not done due to record being updated by another
      ** workstation, display message "The last transaction was not
      ** applied to the database." to the next screen.
      *
     C                   IF        RetCodeOut = '*RECUPD'
     C                   Z-ADD     1             IDx
     C                   Eval      FldNameArr(IDx) = '*ANY'
     C                   Eval      MsgIdArr(IDx) = 'APM1000'
     C                   ENDIF
      *
      ** Read next browse subfile record.
      *
     C                   IF        WRdNBrw = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      ESRUpdate
     C                   ENDIF
      *
      ** Display initial screen with blank screen fields.
      *
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
 
     C     ESRUpdate     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw - Build browse subfile record                       *
      *                                                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
      *
      ** Reset Read Next Browse Subfile Record indicator.
      *
     C                   EVAL      WRdNBrw = *BLANK
      *
      ** Display browse screen.
      *
     C                   CALLB     'SESEDEBRW'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key fields (file pointer)
     C                   PARM                    KeyLists
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
      **  Security shortname
      **  Event date
      **  Event type
     C                   PARM                    PSDSNSel
     C                   PARM                    PSDEDSel
     C                   PARM                    PSDETSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL
 
     C                   SELECT
      *
      ** F3 - End program.
     C                   WHEN      PINKC = *ON
     C                   EXSR      SREndP
      *
      ** Error message returned from browse.
     C                   WHEN      PErrMs <> *BLANKS
     C                   EXSR      SRSndM
      *
      ** F12 - Cancel. Go back to initial screen.
     C                   WHEN      PINKL = *ON
      *
      ** Redisplay Initial screen with blank screen fields.
     C                   EXSR      SRClearScn
     C                   EVAL      WScrn = 'I'
      *
      ** Enter - read selected subfile records.
     C                   OTHER
 
     C                   EVAL      WRdNBrw = 'Y'
     C                   EVAL      WScrn   = 'R'
 
     C                   ENDSL
 
     C     ESRBldBrw     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
      *
      ** Display browse screen.
      *
     C                   CALLB     'SESEDEBRW'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Key fields (file pointer)
     C                   PARM      *BLANKS       KeyLists
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
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    PSDSNSel
     C                   PARM                    PSDEDSel
     C                   PARM                    PSDETSel
      *
      ** Function keys enabled
      ** KC = Command key 03 = Exit
      ** KL = Command key 12 = Cancel
     C                   PARM                    PINKC
     C                   PARM                    PINKL
      *
      ** If no security diary events detail selected from subfile,
      ** reset read next browse subfile record indicator and then
      ** display initial screen with blank key fields.
      *
     C                   IF        POpSel = *BLANK
     C                   EXSR      SRClearScn
     C                   EVAL      WRdNBrw = *BLANK
     C                   EVAL      WScrn   = 'I'
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
      *
      ** Update action code with option selected.
      *
     C                   EVAL      DDACTN = POPSEL
      *
      ** Default action to enquiry if not valid.
      ** Valid entries are A(Amend), D(Delete) and E(Enquire).
      *
     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
      *
      ** Retrieve security diary events details.
      *
     C                   EVAL      DDSDSN = PSDSNSel
     C                   EVAL      DDSDED = PSDEDSel
     C                   EVAL      DDSDET = PSDETSel
 
     C                   EXSR      SRRtvSEDE
      *
      ** If warning or error occurred in the retrieval of security
      ** diary events details, display messages on the initial screen.
      *
     C                   IF        WIDx <> *ZERO OR IDx = 1 OR IDx > 1 AND
     C                             MsgIdArr(1) <> 'APM1000'
     C                   EVAL      WScrn = 'I'
     C                   GOTO      ESRRdNBrw
     C                   ENDIF
      *
      ** Move the security diary events details from the master
      ** database file into the update file record.
      *
     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Put security diary events details on the screen.
      *
     C                   EXSR      SRCvtSEDE
      *
      ** Initialise work variable for defaulting.
      *
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display the main screen.
      *
     C                   EVAL      WScrn  = 'P'
 
     C     ESRRdNBrw     ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvSEDE - Retrieve security diary events details.          *
      *                                                               *
      *****************************************************************
     C     SRRtvSEDE     BEGSR
 
                                                                                              CSC011
      ** Use Proc date in SC24X7 for RTV module if CSC011 is present                          CSC011
      ** and current system is support system.                                                CSC011
     C                   IF        (CSC011 = 'Y') AND (S1SUPP = LIBR)                         CSC011
     C                   EVAL      PDate = S1DATE                                             CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      PDate = BJRDNB                                             CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   CALLB     'SESEDERTV'
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
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM      *BLANK        PFRNT
      *
      ** Security shortname
     C                   PARM                    DDSDSN
      *
      ** Event date
     C                   PARM                    DDSDED
      *
      ** Event type
     C                   PARM                    DDSDET
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Single branch code
     C                   PARM                    BJSBRC
      *
      ***SDBANK*- Run day number                                                              CSC011
     C**********         PARM                    BJRDNB                                       CSC011
      ** Processing Date                                                                      CSC011
     C                   PARM                    PDate                                        CSC011
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDSTRD - Back value period
     C                   PARM                    BVBVP
      *
      ** ZMUSER - Default branch
     C                   PARM                    PDBRN
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** SE transaction enhancement
     C                   PARM                    CSE010
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *                                                                                       CSE031
      ** Coupon Fixing for Floating Rate Notes                                                CSE031
     C                   PARM                    CSE031                                       CSE031
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
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
      ** OK Action code
     C                   PARM                    OKACTN
      *
      ** OK Security shortname
     C                   PARM                    OKSDSN
      *
      ** OK Event date
     C                   PARM                    OKSDED
      *
      ** OK Event type
     C                   PARM                    OKSDET
      *
      ** Security Diary Events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Event date (Day number)
     C                   PARM                    PEvtDno
      *
      ** Redisplay screen
     C
     C                   PARM      *BLANK        PReDsp
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtSEDE - Converts security diary events details from      *
      *              file to screen format.                           *
      *                                                               *
      *****************************************************************
     C     SRCvtSEDE     BEGSR
 
     C                   CALLB     'SESEDECVT'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Retun code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** SE Diary events retrieved from file - file format
     C                   PARM                    CrDEFilFmt
      *
      ** Externally described DS for Security details
     C                   PARM                    PSectyd
      *
      ** Processing type from PF/INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - Date format indicator
     C                   PARM                    BJDFIN
      *
      ** MMODF - Strategic risk management indicator
     C                   PARM                    RMFL
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** Value currency to be currency of issuer payments
     C                   PARM                    S01509
      *
      ** Dividend payments
     C                   PARM                    S01510
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
     C                   PARM                    CAS006                                       CAS006
                                                                                              CSE065
      ** Constant Yield Amortisation on Mortgage backed assets                                CSE065
     C                   PARM                    CSE065                                       CSE065
                                                                                              CGL031
      ** Taxation on Savings Income                                                           CGL031
                                                                                              CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** OUTPUT
      ** ======
      *
      ** SE Diary events screen details from incoming transaction
      ** - screen format
     C                   PARM                    CrDE1ScnFmt
 
     C                   EVAL      NwDE1ScnFmt = CrDE1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backward or forward through the security       *
      *           diary events details.                               *
      *                                                               *
      *****************************************************************
     C     SRRoll        BEGSR
      *
      ** Reset/clear previous error/warning messages for every new record.
      *
     C                   EXSR      SRResetErr
      *
      ** Read next or previous record in the security diary events file
      ** according to function key pressed (F7=INKG or F8=INKH).
      *
     C                   IF        PINKG = *ON
     C                   EVAL      PRdBck = 'Y'
     C                   EVAL      PRdFwd = *BLANK
     C                   ELSE
     C                   EVAL      PRdBck = *BLANK
     C                   EVAL      PRdFwd = 'Y'
     C                   ENDIF
 
     C                   CALLB     'SESEDERED'
      *                             =========
      ** INPUT
      ** =====
      *
      ** Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    DDSDSN
     C                   PARM                    DDSDED
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
      ** Security shortname
      ** Event date
      ** Event type
     C                   PARM                    PSDSNSel
     C                   PARM                    PSDEDSel
     C                   PARM                    PSDETSel
      *
      ** If error message returned from read, send it to screen.
      *
     C                   IF        PErrMs <> *BLANKS
     C                   EXSR      SRSndM
     C                   GOTO      ESRRoll
     C                   ENDIF
      *
      ** Default Action to Enquiry if entry is invalid.  Valid
      ** entries are A(Amend), D(Delete) and E(Enquire).
      *
     C                   IF        DDACTN <> 'A' AND DDACTN <> 'E' AND
     C                             DDACTN <> 'D'
     C                   EVAL      DDACTN = 'E'
     C                   ENDIF
      *
      ** Retrieve security diary events details.
      *
     C                   EVAL      DDSDSN = PSDSNSel
     C                   EVAL      DDSDED = PSDEDSel
     C                   EVAL      DDSDET = PSDETSel
 
     C                   EXSR      SRRtvSEDE
      *
      ** If warning or error occurred in the retrieval of security
      ** diary events details, display messages on the initial screen.
      *
     C                   IF        WIDx <> *ZERO OR IDx <> *ZERO
     C                   EVAL      WScrn = 'I'
     C                   GOTO      ESRRoll
     C                   ENDIF
      *
      ** Move the security diary events details from the master
      ** database file into the update file record.
      *
     C**********         EVAL      NwDEFilFmt = CrDEFilFmt                                    CSE065
     C                   EVAL      NwDeFilFmt1 = CrDeFilFmt1                                  CSE065
      *                                                                                       CSE065
     C                   IF        CSE065 = 'Y'                                               CSE065
     C                   Z-ADD     OSDAL         S2SDAL                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   Z-ADD     *ZEROS        S2SDAL                                       CSE065
     C                   ENDIF                                                                CSE065
      *
      ** Put security diary events details on the screen.
      *
     C                   EXSR      SRCvtSEDE
      *
      ** Initialise work variable for defaulting.
      *
     C                   EVAL      WProcOnce = *BLANK
      *
      ** Display the main screen.
      *
     C                   EVAL      WScrn = 'P'
 
     C     ESRRoll       ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSavKey - Save key fields to a temporary variable.          *
      *                                                               *
      *****************************************************************
     C     SRSavKey      BEGSR
 
     C                   EVAL      WOACTN = DDACTN
     C                   EVAL      WDSDSN = DDSDSN
     C                   EVAL      WDSDED = DDSDED
     C                   EVAL      WDSDET = DDSDET
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRstKey - Restore key fields.                               *
      *                                                               *
      *****************************************************************
     C     SRRstKey      BEGSR
 
     C                   EVAL      DDACTN = WOACTN
     C                   EVAL      DDSDSN = WDSDSN
     C                   EVAL      DDSDED = WDSDED
     C                   EVAL      DDSDET = WDSDET
      *
      ** Initialise keylists for use in browse module.
     C                   CLEAR                   KeyLists
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetupKey - Setup keys for pointer or selection.            *
      *                                                               *
      *****************************************************************
     C     SRSetupKey    BEGSR
 
     C                   EVAL      WDSDSN = DDSDSN
     C                   EVAL      WDSDED = DDSDED
     C                   EVAL      WDSDET = DDSDET
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRClearScn - Clear screen data structures                    *
      *                                                               *
      *****************************************************************
     C     SRClearScn    BEGSR
      *
      ** Clear screen data structures for new processing.
      *
     C                   CLEAR                   CrDE1ScnFmt
     C                   CLEAR                   NwDE1ScnFmt
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - Set program to end                                  *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
      *
      ** Issue rollback to clear any possible updates in lower
      ** level programs.
      *
     C                   If        (CSC022 = 'N')                                            BUG2604
     C                   ROLBK
     C                   Else                                                                BUG2604
     C                   If        wCommitSkip = 'N'                                         BUG2604
     C                   ROLBK                                                               BUG2604
     C                   Else                                                                BUG2604
     C                   Seton                                        U7U8                   BUG2604
     C                   Endif                                                               BUG2604
     C                   Endif                                                               BUG2604
      *
      ** Set processing to end program.
      *
     C                   EVAL      WScrn = 'E'
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndM - Send error message to screen                        *
      *                                                               *
      *****************************************************************
     C     SRSndM        BEGSR
      *
      ** If single branching, user cannot browse file.
      *
     C                   IF        PErrMs = 'FXM0292'
     C                   EVAL      OKACTN = 'N'
     C                   ENDIF
      *
      ** Date format is invalid, user cannot browse file.
      *
     C                   IF        PErrMs = 'SEA0398'
     C                   EVAL      OKSDED = 'N'
     C                   ENDIF
      *
      ** Add error message to array passed to screen.
      *
     C                   Z-ADD     1             Ex
     C     *BLANK        LOOKUP    FldNameArr(Ex)                         99
     C                   EVAL      FldNameArr(Ex) = '*ANY'
     C                   EVAL      MsgIdArr(Ex) = PErrMs
 
     C                   ENDSR
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
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
      *
     C                   EVAL      SEESEDE = *ALL'Y'
 
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
      *
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
      *
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
      *
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
      ** Access SAR file to determine if 'SE Transaction enhancement'
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE010'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'CSE010'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 004
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           CSE010
     C                   ELSE
     C                   MOVEL     'N'           CSE010
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Value currency to be
      ** currency of the issuer payment' is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01509'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01509'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 005
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01509
     C                   ELSE
     C                   MOVEL     'N'           S01509
     C                   ENDIF
      *
      ** Access SAR file to determine if 'Dividend Payments'
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01510'      PSarD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C     *LOCK         IN        LDA
     C                   EVAL      DBKey = 'S01510'
     C                   EVAL      DBFile= 'SCSARDPD'
     C                   EVAL      DBase = 006
     C                   OUT       LDA
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   MOVEL     'Y'           S01510
     C                   ELSE
     C                   MOVEL     'N'           S01510
     C                   ENDIF
                                                                                              CSC011
      ** Determine if CSC011 is installed                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
      ** An NRF (No Record Found) return code is valid.                                       CSC011
      ** Issue database error only for error return codes.                                    CSC011
     C                   IF        PRTCD <> *BLANKS AND PRTCD <> '*NRF   '                    CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBASE = 7                                                  CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      CSC011 = 'N'                                               CSC011
     C                   ENDIF                                                                CSC011
      *                                                                                       CSE031
      ** Access SAR file to determine if 'Coupon Fixing for                                   CSE031
      ** Floating Rate Note' is installed.                                                    CSE031
      *                                                                                       CSE031
     C                   CALLB     'AOSARDR0'                                                 CSE031
     C                   PARM      *BLANKS       PRtcd                                        CSE031
     C                   PARM      '*VERIFY'     POptn                                        CSE031
     C                   PARM      'CSE031'      PSarD                                        CSE031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE031
      *                                                                                       CSE031
      ** An NRF (No Record Found) return code is valid.                                       CSE031
      ** Issue database error only for error return codes.                                    CSE031
     C                   IF        PRtcd <> *BLANKS AND                                       CSE031
     C                             PRtcd <> '*NRF   '                                         CSE031
     C     *LOCK         IN        LDA                                                        CSE031
     C                   EVAL      DBKey = 'CSE031'                                           CSE031
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE031
     C                   EVAL      DBase = 8                                                  CSE031
     C                   OUT       LDA                                                        CSE031
     C                   EXSR      *PSSR                                                      CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CSE031
     C                   IF        PRtcd = *BLANKS                                            CSE031
     C                   MOVEL     'Y'           CSE031                                       CSE031
     C                   ELSE                                                                 CSE031
     C                   MOVEL     'N'           CSE031                                       CSE031
     C                   ENDIF                                                                CSE031
                                                                                              CAS006
      ** Access SAR file to determine if 'Hedge Accounting                                    CAS006
      ** Phase B(CAS006)' is installed.                                                       CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRtcd                                        CAS006
     C                   PARM      '*VERIFY'     POptn                                        CAS006
     C                   PARM      'CAS006'      PSarD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
      ** An NRF (No Record Found) return code is valid.                                       CAS006
      ** Issue database error only for error return codes.                                    CAS006
     C                   IF        PRtcd <> *BLANKS AND                                       CAS006
     C                             PRtcd <> '*NRF   '                                         CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBKey = 'CAS006'                                           CAS006
     C                   EVAL      DBFile= 'SCSARDPD'                                         CAS006
     C                   EVAL      DBase = 009                                                CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRtcd = *BLANKS                                            CAS006
     C                   MOVEL     'Y'           CAS006                                       CAS006
     C                   ELSE                                                                 CAS006
     C                   MOVEL     'N'           CAS006                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CSE065
      ** Access SAR file to determine if CSE065 is installed                                  CSE065
                                                                                              CSE065
     C                   CALL      'AOSARDR0'                                                 CSE065
     C                   PARM      *BLANKS       PRtcd                                        CSE065
     C                   PARM      '*VERIFY'     POptn                                        CSE065
     C                   PARM      'CSE065'      PSarD                                        CSE065
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE065
                                                                                              CSE065
      ** An NRF (No Record Found) return code is valid.                                       CSE065
      ** Issue database error only for error return codes.                                    CSE065
                                                                                              CSE065
     C                   IF        PRtcd <> *BLANKS AND                                       CSE065
     C                             PRtcd <> '*NRF   '                                         CSE065
     C     *LOCK         IN        LDA                                                        CSE065
     C                   EVAL      DBKey = 'CSE065'                                           CSE065
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE065
     C                   EVAL      DBase = 010                                                CSE065
     C                   OUT       LDA                                                        CSE065
     C                   EXSR      *PSSR                                                      CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CSE065
     C                   IF        PRtcd = *BLANKS                                            CSE065
     C                   MOVEL     'Y'           CSE065                                       CSE065
     C                   ELSE                                                                 CSE065
     C                   MOVEL     'N'           CSE065                                       CSE065
     C                   ENDIF                                                                CSE065
                                                                                              CGL031
      ** Access SAR file to determine if 'Taxation on Savings                                 CGL031
      ** Income is installed.                                                                 CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRtcd                                        CGL031
     C                   PARM      '*VERIFY'     POptn                                        CGL031
     C                   PARM      'CGL031'      PSarD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
                                                                                              CGL031
                                                                                              CGL031
      ** An NRF (No Record Found) return code is valid.                                       CGL031
      ** Issue database error only for error return codes.                                    CGL031
                                                                                              CGL031
     C                   IF        PRtcd <> *BLANKS AND                                       CGL031
     C                             PRtcd <> '*NRF   '                                         CGL031
     C     *LOCK         IN        LDA                                                        CGL031
     C                   EVAL      DBKey = 'CGL031'                                           CGL031
     C                   EVAL      DBFile= 'SCSARDPD'                                         CGL031
     C                   EVAL      DBase = 010                                                CGL031
     C                   OUT       LDA                                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   ENDIF                                                                CGL031
                                                                                              CGL031
     C                   IF        PRtcd = *BLANKS                                            CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   ENDIF                                                                CGL031
      *
      ** Retrieve ZMUSER details.
      *
     C     *DTAARA       DEFINE                  ZMUSER
     C                   IN        ZMUSER
      *
      ** Access MMODF to determine if Strategic Risk Man. Ind is on
      *
     C                   READ      MMODF                                  01
 
     C                   EVAL      WScrn = 'I'
      *
      ** Access SAR details file to determine if Commitment Control                          BUG2604
      ** Changes is switched on.                                                             BUG2604
      *                                                                                      BUG2604
     C                   CallB     'AOSARDR0'                                                BUG2604
     C                   Parm      *BLANKS       PRTCD                                       BUG2604
     C                   Parm      '*VERIFY'     POPTN                                       BUG2604
     C                   Parm      'CSC022'      PSARD                                       BUG2604
     C     SCSARD        Parm      SCSARD        DSFDY                                       BUG2604
                                                                                             BUG2604
     C                   If        PRTCD = *BLANKS                                           BUG2604
      *                                                                                      BUG2604
     C                   Eval      CSC022 = 'Y'                                              BUG2604
     C                   In        SCCMTJOB                                                  BUG2604
     C                   If        ComitNum > 0                                              BUG2604
      *                                                                                      BUG2604
      ** Check if Current Job exists in the Commitment Job Names                             BUG2604
      ** Data Area.                                                                          BUG2604
      *                                                                                      BUG2604
     C                   MoveA     wComitJob     CmtJobNArr                                  BUG2604
     C     PSJOBNAME     LookUp    CmtJobNArr                             20                 BUG2604
     C                   If        *IN20                                                     BUG2604
     C                   Eval      wCommitSkip = 'Y'                                         BUG2604
     C                   EndIf                                                               BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   Else                                                                BUG2604
      *                                                                                      BUG2604
      ** Database error                                                                      BUG2604
      *                                                                                      BUG2604
     C                   If        PRTCD <> '*NRF'                                           BUG2604
     C     *LOCK         In        LDA                                                       BUG2604
     C                   Eval      DBKey = 'CSC022'                                          BUG2604
     C                   Eval      DBPgm = 'SESEDECTL'                                       BUG2604
     C                   Eval      DBFile = 'SCSARDPD'                                       BUG2604
     C                   Eval      DBase = 10                                                BUG2604
     C                   Out       LDA                                                       BUG2604
     C                   ExSr      *PSSR                                                     BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
     C                   EndIf                                                               BUG2604
      *                                                                                      BUG2604
                                                                                              CSE072
      ** Access SAR file to determine if 'Brazilian C-Bonds                                   CSE072
      ** (CSE027)' is installed.                                                              CSE072
                                                                                              CSE072
     C                   CALLB     'AOSARDR0'                                                 CSE072
     C                   PARM      *BLANKS       PRtcd                                        CSE072
     C                   PARM      '*VERIFY'     POptn                                        CSE072
     C                   PARM      'CSE072'      PSarD                                        CSE072
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE072
                                                                                              CSE072
      ** An NRF (No Record Found) return code is valid.                                       CSE072
      ** Issue database error only for error return codes.                                    CSE072
     C                   IF        PRtcd <> *BLANKS AND                                       CSE072
     C                             PRtcd <> '*NRF   '                                         CSE072
     C     *LOCK         IN        LDA                                                        CSE072
     C                   EVAL      DBKey = 'CSE072'                                           CSE072
     C                   EVAL      DBFile= 'SCSARDPD'                                         CSE072
     C                   EVAL      DBase = 009                                                CSE072
     C                   OUT       LDA                                                        CSE072
     C                   EXSR      *PSSR                                                      CSE072
     C                   ENDIF                                                                CSE072
                                                                                              CSE072
     C                   IF        PRtcd = *BLANKS                                            CSE072
     C                   MOVEL     'Y'           CSE072                                       CSE072
     C                   ELSE                                                                 CSE072
     C                   MOVEL     'N'           CSE072                                       CSE072
     C                   ENDIF                                                                CSE072
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
      *
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SESEDE011
 
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
(c) Finastra International Limited 2001
