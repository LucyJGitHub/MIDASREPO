     H DEBUG
     H COPYRIGHT('(c) Misys International Banking System Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SC Data Replication Configurator')               *
      *****************************************************************
      *                                                               *
      *  Midas - System Control Module                                *
      *                                                               *
      *  SCRPCNSIN - Data Replication Configurator Maintenance        *
      *                                                               *
      *  Function:  This module will be the entry module for screen-  *
      *             input function for Data Replication Configurator  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CDL096             Date 22Sep14               *
      *  Prev Amend No. CRE073             Date 06Dec10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 11May06               *
      *                 CSD027             Date 09Dec05               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011  *CREATE    Date 18Seo01               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CDL096 - Business Day Conventions on MM Deals                *
      *           (Recompile)                                         *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSC011 - 24x7 Midas Availability                             *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  S U B R O U T I N E  I N D E X                               *
      *                                                               *
      *  SRScnMain  - Process screen: Main details                    *
      *  SRValMain  - Validate input to Main details screen           *
      *  SRRoll     - Roll backwards and forwards through deals file  *
      *  SRBldBrw   - Build browse subfile                            *
      *  SRRdNBrw   - Read next browse subfile record                 *
      *  SRRtvRec   - Retrieve record                                 *
      *  SRCvtoScn  - Convert from file to screen format              *
      *  SRSetFldS  - Set field status on main details screen         *
      *               according to action code                        *
      *  SRSetKeyS  - Set function key status on main details screen  *
      *               according to action code                        *
      *  SRInzFldS  - Initialise field status on main details screen  *
      *  SRInzKeyS  - Initialise function key status on main details  *
      *               screen                                          *
      *  SRCancM    - Cancel on main details screen                   *
      *  SRSndMsgM  - Send a message to main details screen           *
      *  SRScnConf  - Process screen: Confirmation of input evoked    *
      *               for inputs and amends                           *
      *  SRCancC    - Cancel on confirmation screen                   *
      *  SRExitC    - Exit from confirmation screen                   *
      *  SRUpdate   - Update file                                     *
      *  SREndP     - End program                                     *
      *                                                               *
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
 
      ** The following /COPY line includes the definitions of data
      ** structure used to pass data to window program
 
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
 
      ** Current Data Replication in File Format
     D CrRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
     D                                     Prefix(CR:2)
 
      ** New Data Replication in File Format
     D NwRepFilFmt   E DS                  EXTNAME(SCFDTLPD)
     D                                     Prefix(NW:2)
 
      ** Deal file format use for update
     D UpdDlFilFmt   E DS                  EXTNAME(MMVLDNIPD)
 
      ** Current Data Replication in Screen Format
     D CrRepScnFmt   E DS                  EXTNAME(SCRPCNPD)
     D                                     PREFIX(CS:2)
 
      ** New Data Replication in Screen Format
     D NwRepScnFmt   E DS                  EXTNAME(SCRPCNPD)
 
      ** Data Replication Error indicator file
     D OkRepFlag     E DS                  EXTNAME(SCERPCNPD)
 
      ** Current control indicators for main detail screen
     D WCtlInd         DS
     D  PKeyFld                1      1
     D  PDetFld                2      2
     D  PEINKG                 3      3
     D  PEINKH                 4      4
     D  PEINKJ                 5      5
     D  PEINKP                 6      6
 
      ** Previous control indicators for main detail screen
     D WPrvCtlIn       DS             6
 
      ** AB (FUND) Extra Data - File (D/B) format
     D ExtData       E DS                  EXTNAME(ABFUEXPD)
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
     D PINKC           S              1A
     D PINKG           S              1A
     D PINKH           S              1A
     D PINKJ           S              1A
     D PINKL           S              1A
     D PINKP           S              1A
     D PSIDN           S              6A
     D PAmdOk          S              1A
     D PRstErr         S              1A
     D PModeOfOp       S              6A
     D PDDDLNO         S              6A
     D PDealNum        S              6S 0
     D PMsgID          S              7A
     D PDDSTS          S              7A
     D PPRF1D          S             30A
     D PPRF2D          S             30A
     D PRdFwd          S              1A
     D PRdBck          S              1A
     D PErrMsg         S              7A
     D PRdDeal         S              6A
     D PRdFrntID       S             20A
     D PBdSfl          S              1A
     D PRdSfl          S              1A
     D POpSel          S              1A
     D PDlSel          S              6A
     D PFrntId         S             20A
     D PFrntAsId       S             20A
     D PDaynoIn        S              5P 0
     D PRetCode        S              1  0
     D PReDsp          S              1A
     D PKey            S              1A
     D PPhyFil         S             10
     D PPhySel         S             10
     D PRdPhyF         S             10
     D PConfig         S              1
 
     D WPPHYF          S             10
     D WPACTN          S              1
     D WScrn           S              1
     D WRdnb           S              1
     D WReDisplay      S              1A
     D WIx             S              3P 0
     D WSetFld         S              1A
     D PActCode        S              1
     D WkInit          S              1
     D E               S              3  0
 
      ** Work array for warning message Ids
     D WPrvWarnAr      S                   Dim(ArrayMax)
     D                                     Like(WMsgIDArr)
 
      ** Index for arrays of error message ids etc
     D WkIdx           S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WkWIdx          S              3P 0
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,SCRPCN001
 
      *****************************************************************
      /EJECT
      *****************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
 
      *****************************************************************
      * Main Procedure                                                *
      *****************************************************************
 
      /COPY WNCPYSRC,SCRPCN002
 
      ** Read next browse subfile record
 
     C                   IF        WScrn = 'R'
     C                   EXSR      SRRdNBrw
     C                   ENDIF
 
      /COPY WNCPYSRC,SCRPCN003
 
      ** Do while screen: Main Details
 
     C                   DOW       WScrn = 'M'
     C                   EXSR      SRScnMain
     C                   ENDDO
 
      /COPY WNCPYSRC,SCRPCN004
 
      **  Screen: Confirmation of Input
 
     C                   IF        WScrn = 'C'
     C                   EXSR      SRScnConf
     C                   ENDIF
 
      /COPY WNCPYSRC,SCRPCN005
 
      **  Do file updates
 
     C                   IF        WScrn = 'U'
     C                   EXSR      SRUpdate
     C                   ENDIF
 
      /COPY WNCPYSRC,SCRPCN006
 
      ** Terminate program
 
     C                   IF        WScrn = 'T'
     C                   EVAL      *INLR = *On
     C                   ENDIF
 
      *****************************************************************
 
      ** Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,SCRPCN007
 
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScnMain - Process screen: Main details                     *
      *                                                               *
      *  Called by: Main processing                                   *
      *                                                               *
      *  Calls:     SRResetErr, SRCancM, SREndP, SRRoll, SRBldBrw,    *
      *             SRValMain                                         *
      *                                                               *
      *****************************************************************
     C     SRScnMain     BEGSR
 
      ** Update 'previous' physical file name & screen control indicator
 
     C                   EVAL      WPPHYF = #1PHYF
     C                   EVAL      WPACTN = #1ACTN
     C                   EVAL      WPrvCtlIn = WCtlInd
 
      ** Write/Read Display Screen
 
     C                   CALLB     'SCRPCNDSP'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Replication details in screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Fields in error
 
     C                   PARM                    OkRepFlag
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
 
     C                   PARM                    PKeyFld
     C                   PARM                    PDetFld
     C                   PARM                    PEINKG
     C                   PARM                    PEINKH
     C                   PARM                    PEINKJ
     C                   PARM                    PEINKP
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Called by Data Replication Configurator
 
     C                   PARM      'Y'           PConfig
 
      ** Output Parameters
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Save warning message ids array of this screen.
 
     C                   MOVEA     WMsgIDArr     WPrvWarnAr
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** CK/12 - Cancel on Main Details Screen
 
     C                   IF        PINKL = '1'
     C                   EXSR      SRCancM
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/3 - End Program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/7 - Roll Backwards
 
     C                   IF        PINKG = '1'
     C                   EXSR      SRRoll
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/8 - Roll Forwards
 
     C                   IF        PINKH = '1'
     C                   EXSR      SRRoll
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/15 - Build Browse
 
     C                   IF        PINKP = '1'
     C                   EXSR      SRBldBrw
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** CK/10 - go onto update, delete record
 
     C                   IF        PINKJ = '1'
 
      ** Update Replication Files Format
 
     C                   EVAL      NwRepFilFmt = CrRepFilFmt
     C                   EVAL      WScrn = 'U'
     C                   GOTO      ESCRN@M
     C                   ENDIF
 
      ** Validate input to Main Details Screen
 
     C                   EXSR      SRValMain
 
     C     ESCRN@M       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRValMain - Validate input to Main Details Screen            *
      *                                                               *
      *  Called by: SRScnMain                                         *
      *                                                               *
      *  Calls:     SRRtvRec, SRSetFldS, SRSetKeyS, SRCvtoScn         *
      *             SRResetErrs                                       *
      *                                                               *
      *****************************************************************
     C     SRValMain     BEGSR
 
      ** Retrieve deal details
 
     C                   EXSR      SRRtvRec
 
      ** If action code or physical file name not OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACTN = 'N' OR OKPHYF = 'N'
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** If action code is delete, enquire
      ** or action code is amend and physical file has changed
      ** Put the deal on the main details screen
 
     C                   IF        #1ACTN = 'D' OR  #1ACTN = 'E' OR
     C                             #1ACTN = 'A' and #1PHYF <> WPPHYF or
     C                             #1ACTN = 'A' and #1ACTN <> WPACTN
     C                   EXSR      SRCvtoScn
     C                   ENDIF
 
      ** If physical file name or screen control indicators have changed
      **   Re-output screen
 
     C                   IF        #1PHYF <> WPPHYF AND #1ACTN <> 'I' OR
     C                             WCtlInd <> WPrvCtlIn
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** If Enquire
 
     C                   IF        #1ACTN = 'E'
 
      ** Update Details in File Format
 
     C                   EVAL      NwRepFilFmt = CrRepFilFmt
 
      ** If windows processing on, call window routine
      ** If browse outstanding, read next browse subfile record
 
     C                   IF        WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ENDIF
 
     C                   GOTO      EVAL@M
 
      ** End of Enquire
 
     C                   ENDIF
 
      ** If insert or amend
 
     C                   IF        #1ACTN = 'I' OR #1ACTN = 'A'
 
      ** Prior to validation, initialize error indicators as 'OK'
      ** and clear Deal in File Format
 
     C                   EXSR      SRResetErr
     C                   CLEAR                   NwRepFilFmt
 
      ** If Amemd
 
     C                   IF        #1ACTN = 'A'
 
      ** Update Details in File Format
 
     C                   EVAL      NwRepFilFmt = CrRepFilFmt
 
     C                   ENDIF
 
      ** Validate deal details
      ** =====================
 
     C                   CALLB     'SCRPCNVAL'
 
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Data Replication screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Current Screen Format
 
     C                   PARM                    CrRepScnFmt
 
      ** Output Parameters
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WkIdx
 
      ** Warning flds/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM                    WkWIdx
 
      ** Data Replication Configurator error indicators
 
     C                   PARM                    OkRepFlag
 
      ** Data Replication Configurator file
 
     C                   PARM                    NwRepFilFmt
 
      ** Redisplay Flag
 
     C                   PARM      *BLANK        PReDsp
 
     C     'N'           SCAN      OkRepFlag                              80
     C                   IF        *IN80 = *OFF
     C                   EVAL      WReDisplay = *BLANK
     C                   EVAL      CrRepFilFmt = NwRepFilFmt
     C                   EXSR      SRCvtoScn
     C                   ENDIF
 
      ** If no errors occurred during validation of main screen
      ** fields, check if there are warnings which have not been
      ** displayed yet.
 
     C                   IF        WkIdx = 0
 
     C                   Z-ADD     1             WIx
 
     C                   DOW       WIx <= WkWIdx AND WReDisplay = *BLANK
 
     C                   IF        WMsgIdArr(WIx) <> WPrvWarnAr(WIx)
     C                   EVAL      WReDisplay = 'Y'
     C                   ELSE
     C                   EVAL      WIx = WIx + 1
     C                   ENDIF
 
     C                   ENDDO
 
     C                   IF        WReDisplay <> 'Y'
     C                   EXSR      SRResetErr
     C                   EVAL      WScrn = 'C'
     C                   ENDIF
 
     C                   ENDIF
 
      ** Redisplay main screen if there are errors or if there
      ** are warnings which have not been displayed yet.
 
     C                   IF        WkIdx <> *ZERO OR WReDisplay = 'Y' OR
     C                             PReDsp = 'Y'
     C                   IF        WRedisplay = 'Y'
     C                   EXSR      SRSetFlds
     C                   EXSR      SRSetKeys
     C                   ENDIF
     C                   GOTO      EVAL@M
     C                   ENDIF
 
      ** Continue to confirmation screen
 
     C**                 IF        WPACTN = #1ACTN and WPPHYF = #1PHYF
     C**                 EVAL      WScrn = 'C'
     C**                 ENDIF
 
      ** End of If insert or amend
 
     C                   ENDIF
 
     C     EVAL@M        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRoll - Roll backwards & forwards through deals file        *
      *                                                               *
      *  Called by: SRScnMain                                         *
      *                                                               *
      *  Calls:     SRSndMsgM, SRRtvRec, SRSetFldS, SRSetKeys         *
      *             SRCvtoScn                                         *
      *                                                               *
      *****************************************************************
     C     SRRoll        BEGSR
 
      ** Default action code to enquiry if not valid
 
     C                   IF        #1ACTN <> 'A' AND #1ACTN <> 'D' AND
     C                             #1ACTN <> 'I' AND #1ACTN <> 'C'
     C                   EVAL      #1ACTN = 'E'
     C                   ENDIF
 
      ** Read next or previous record on deals file
      ** according to command key taken (CK/7 or CK/8)
 
     C                   IF        PINKG = '1'
     C                   EVAL      PRdFwd = *BLANK
     C                   EVAL      PRdBck = 'Y'
     C                   ELSE
     C                   EVAL      PRdFwd = 'Y'
     C                   EVAL      PRdBck = *BLANK
     C                   ENDIF
 
     C                   CALLB     'SCRPCNRED'
 
      ** Input Parameters
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal Number Pointer
 
     C                   PARM                    #1PHYF
 
      ** Read Forwards
      ** Read Backwards
 
     C                   PARM                    PRdFwd
     C                   PARM                    PrdBck
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
     C                   PARM      *BLANK        PRdPhyF
 
      ** If error message returned from read, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SRSndMsgM
     C                   GOTO      EROLL
     C                   ENDIF
 
      ** If Physical file read
 
     C                   IF        PRdPhyF <> *BLANK
 
      ** Retrieve deal details
 
     C                   EVAL      #1PHYF = PRdPhyf
     C                   EXSR      SRRtvRec
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** Put the deal on the main details screen
 
     C                   EXSR      SRCvtoScn
     C                   ENDIF
 
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRBldBrw -  Build Browse Subfile                             *
      *                                                               *
      *  Called by: SRScnMain                                         *
      *                                                               *
      *  Calls:     SREndP, SRSndMsgM, SRSetFldS, SRSetKeyS           *
      *             SRInzFldS, SRInzKeyS                              *
      *                                                               *
      *****************************************************************
     C     SRBldBrw      BEGSR
 
      ** Reset read next browse subfile record
 
     C                   EVAL      WRdnb = *BLANK
 
     C                   EVAL      NwRepScnFmt = *Blanks
 
      ** Build browse subfile
 
     C                   CALLB     'SCRPCNBRW'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PActCode
 
      ** Physical File
 
     C                   PARM                    PPhyfil
 
      ** Build sub-file
 
     C                   PARM      'Y'           PBdSfl
 
      ** Read subfile record
 
     C                   PARM      *BLANK        PRdSfl
 
      ** Output Parameters
 
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
 
      ** Option Selected
 
     C                   PARM      *BLANK        POpSel
 
      ** Physical File Selected
 
     C                   PARM      *BLANK        PPhySel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If CK/3 taken in browse, end program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If error message returned from browse, send it to detail screen
 
     C                   IF        PErrMsg <> *BLANK
     C                   EXSR      SRSndMsgM
     C                   GOTO      EBLDBR
     C                   ENDIF
 
      ** If CK/12 not taken in browse
      ** Read next browse subfile record
 
     C                   IF        PINKL <> '1'
     C                   EVAL      WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   GOTO      EBLDBR
 
     C                   ELSE
 
      ** Set NwRepScnFmt
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   IF        #1ACTN <> *BLANK
 
     C                   EVAL      NwRepScnFmt = CrRepScnFmt
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
     C                   ELSE
 
     C                   CLEAR                   NwRepScnFmt
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
     C                   ENDIF
     C                   ENDIF
 
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRdNBrw - Read next browse subfile record                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRRtvRec, SRSetFldS, SRSetKeyS, SRCvtoScn         *
      *                                                               *
      *****************************************************************
     C     SRRdNBrw      BEGSR
 
      ** Read next subfile record
     C                   CALLB     'SCRPCNBRW'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
 
     C                   PARM                    PActCode
 
      ** Physical File
 
     C                   PARM                    PPhyfil
 
      ** Build sub-file
 
     C                   PARM      *Blanks       PBdSfl
 
      ** Read subfile record
 
     C                   PARM      'Y'           PRdSfl
 
      ** Output Parameters
      ** Error Message
 
     C                   PARM      *BLANK        PErrMsg
 
      ** Option Selected
 
     C                   PARM      *BLANK        POpSel
 
      ** Physical File Selected
 
     C                   PARM      *BLANK        PPhySel
 
      ** Command Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKL
 
      ** If Physical file read from subfile
 
     C                   IF        PPhySel <> *BLANK
 
      ** Retrieve deal details
 
     C                   EVAL      #1ACTN = POpSel
     C                   EVAL      #1PHYF = PPhySel
     C                   EXSR      SRRtvRec
 
      ** If action code is not OK
      ** Re-output screen with error messages on it
 
     C                   IF        OKACTN = 'N'
     C                   GOTO      ERdNBrw
     C                   ENDIF
 
      ** Set field and function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetFldS
     C                   EXSR      SRSetKeyS
 
      ** Put the file details to main detail screen
 
     C                   EXSR      SRCvtoScn
 
      ** Else, reset read next browse subfile record
 
     C                   ELSE
     C                   EVAL      WRdnb = *BLANK
     C                   ENDIF
 
      ** Go to main details screen
 
     C                   EVAL      WScrn = 'M'
 
     C     ERdNBrw       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRRtvRec - Retrieve Record                                   *
      *                                                               *
      *  Called by: SRValMain, SRRoll, SRRdNBrw                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRRtvRec      BEGSR
 
      ** Retrieve Deal
 
     C                   CALLB     'SCRPCNRTV'
 
      ** Input Parameters
      ** ================
      ** Return code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Action Code
      ** Physical File Name
 
     C                   PARM                    #1ACTN
     C                   PARM                    #1PHYF
 
      ** Output Parameters
      ** =================
      ** (Current) Replication details in file format
      ** OK - Action code
      ** OK - Physical File
 
     C                   PARM                    CrRepFilFmt
     C                   PARM      *BLANK        OKACTN
     C                   PARM      *BLANK        OKPHYF
 
      ** Error fields/message IDs/message data (arrays) from/to caller
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Array index (3P0) from/to caller
 
     C                   PARM      *ZERO         WkIdx
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCvtoScn - Put a details into screen format                 *
      *                                                               *
      *  Called by: SRValMain, SRRoll, SRRdNBrw                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRCvtoScn     BEGSR
 
      ** Call program to fill screen fields
 
     C                   CALLB     'SCRPCNCVT'
 
      ** Input Parameter
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Deal in file format of deal
 
     C                   PARM                    CrRepFilFmt
 
      ** Output Parameters
      ** =================
      ** Deal in screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Update 'Current' Details with Replication data in screen format
 
     C                   EVAL      CrRepScnFmt = NwRepScnFmt
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetFldS - Set field status on main details screen          *
      *              according to action code                         *
      *                                                               *
      *  Called by: SRValMain, SRRoll, SRBldBrw, SRRdNBrw, SRSetKeyS  *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRSetFldS     BEGSR
 
      ** Enable/disable key & detail fields on main details screen
      ** (key fields = action code & deal number; detail fields = rest)
      ** (Action code can only be 'I', 'A', 'E',  or 'D')
 
     C                   IF        #1ACTN = 'I' or #1ACTN = *Blanks or
     C                             #1ACTN = 'A' and OKACTN <> 'W'
     C                   EVAL      PKeyFld = 'Y'
     C                   EVAL      PDetFld = 'Y'
     C                   ELSE
     C                   EVAL      PKeyFld = 'N'
     C                   EVAL      PDetFld = 'N'
     C                   ENDIF
 
     C     ESETFLD       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSetKeyS - Set function key status on main details screen   *
      *              according to action code                         *
      *                                                               *
      *  Called by: SRValMain, SRRoll, SRBldBrw, SRRdNBrw, SRExitC    *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRSetKeyS     BEGSR
 
      ** Enable/disable function keys on main details screen
      ** KG = Command key 07 = Read Previous
      ** KH = Command key 08 = Read Next
      ** KJ = Command key 10 = Confirm Delete
      ** KP = Command key 15 = Browse
 
     C                   IF        #1ACTN = 'A' and OKACTN = 'W' or
     C                             #1ACTN = 'C' and OKACTN <> 'N' or
     C                             #1ACTN = 'D' and OKACTN <> 'N'
     C                   EVAL      PEINKJ = 'Y'
     C                   EVAL      PEINKG = 'N'
     C                   EVAL      PEINKH = 'N'
     C                   EVAL      PEINKP = 'N'
     C                   ELSE
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKP = 'Y'
     C                   ENDIF
 
     C     ESETKEY       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInzFldS - Initialize field status on main details screen   *
      *                                                               *
      *  Called by: SRBldBrw, SRCancM, SRCancC, SRExitC, SRUpdate     *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRInzFldS     BEGSR
 
      ** Enable key & details fields on main details screen
 
     C                   EVAL      PKeyFld = 'Y'
     C                   EVAL      PDetFld = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRInzKeyS - Initialise function key status on main details   *
      *              screen                                           *
      *                                                               *
      *  Called by: SRBldBrw, SRCancM, SRUpdate                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRInzKeyS     BEGSR
 
      ** Enable/Disable function keys on main details screen
      ** KG = Command key 07 = Read previous
      ** KH = Command Key 08 = Read next
      ** KJ = Command Key 10 = Confirm Delete
      ** KP = Command Key 15 = Browse
 
     C                   EVAL      PEINKG = 'Y'
     C                   EVAL      PEINKH = 'Y'
     C                   EVAL      PEINKJ = 'N'
     C                   EVAL      PEINKP = 'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancM - Cancel on main details screen                      *
      *                                                               *
      *  Called by: SRScnMain                                         *
      *                                                               *
      *  Calls:     SRInzFldS, SRInzKeys                              *
      *                                                               *
      *****************************************************************
     C     SRCancM       BEGSR
 
      ** Reset Read Next Browse Subfile Record (if active)
 
     C                   EVAL      WRdnb = *BLANK
 
      ** Blank the main details screen
 
     C                   EVAL      NwRepScnFmt = *BLANK
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRSndMsgM - Send a message to main details screen            *
      *                                                               *
      *  Called by: SRScnMain, SRRoll, SRBldBrw                       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRSndMsgM     BEGSR
 
      ** Add error message to array passed to detail screen
 
     C                   Z-ADD     1             E
     C     *BLANK        LOOKUP    FldNameArr(E)                          99
     C                   EVAL      FldNameArr(E) = '*ANY'
     C                   EVAL      MsgIdArr(E) = PErrMsg
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRScnConf - Process screen: Confirmation of input            *
      *              evoked for inserts and amends                    *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRResetErr, SREndP, SRCanC, SRExitC               *
      *                                                               *
      *****************************************************************
     C     SRScnConf     BEGSR
 
      ** Output message 'Press enter to accept'
 
     C                   EVAL      WkWIdx = 1
     C                   EVAL      WFldNamArr(WkWIdx) = '*ANY'
     C                   EVAL      WMsgIdArr(WkWIdx) = 'DRC0009'
 
      ** Write/Read display screen
 
     C                   CALLB     'SCRPCNDSP'
 
      ** Input Parameters
      ** ================
      ** Return Code
 
     C                   PARM      *BLANK        RetCodeOut
 
      ** Replication details in screen format
 
     C                   PARM                    NwRepScnFmt
 
      ** Fields in error
 
     C                   PARM                    OkRepFlag
 
      ** Errors
 
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
 
      ** Warnings
 
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
 
      ** Enabled key and detail fields
      ** Enabled function keys
 
     C                   PARM      'N'           PKeyFld
     C                   PARM      'N'           PDetFld
     C                   PARM      'N'           PEINKG
     C                   PARM      'N'           PEINKH
     C                   PARM      'N'           PEINKJ
     C                   PARM      'N'           PEINKP
 
      ** Write screen with no read indicator
 
     C                   PARM      'N'           WriteOnly
 
      ** Called by Data Replication Configurator
 
     C                   PARM      'Y'           PConfig
 
      ** Output Parameters
 
      ** Function Keys
 
     C                   PARM      '0'           PINKC
     C                   PARM      '0'           PINKG
     C                   PARM      '0'           PINKH
     C                   PARM      '0'           PINKJ
     C                   PARM      '0'           PINKL
     C                   PARM      '0'           PINKP
 
      ** Reset Errors
 
     C                   EXSR      SRResetErr
 
      ** CK/3 - End Program
 
     C                   IF        PINKC = '1'
     C                   EXSR      SREndP
     C                   GOTO      ESCRN@C
     C                   ENDIF
 
      ** CK/12 - Cancel on Confirmation Screen
 
     C                   IF        PINKL = '1'
     C                   EXSR      SRCancC
     C                   GOTO      ESCRN@C
     C                   ENDIF
 
      ** Exit confirmation screen
 
     C                   EXSR      SRExitC
 
     C     ESCRN@C       ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRCancC - Cancel on confirmation screen                      *
      *                                                               *
      *  Called by: SRScnMain, SRScnConf                              *
      *                                                               *
      *  Calls:     SRInzFldS, SRSetKeyS                              *
      *                                                               *
      *****************************************************************
     C     SRCancC       BEGSR
 
      ** Return to main details screen
 
     C                   EVAL      WScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SRInzFldS
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetKeyS
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRExitC - Exit from confirmation screen                      *
      *                                                               *
      *  Called by: SRScnMain, SRScnConf                              *
      *                                                               *
      *  Calls:     SRInzFldS, SRSetKeys                              *
      *                                                               *
      *****************************************************************
     C     SRExitC       BEGSR
 
      ** if no errors in validation
 
     C                   IF        WkIdx = 0
 
      ** Continue with updates
 
     C                   EVAL      WScrn = 'U'
 
      ** Else, return to main details screen
 
     C                   ELSE
     C                   EVAL      WScrn = 'M'
 
      ** Initialize field status on main details screen
 
     C                   EXSR      SRInzFldS
 
      ** Set function key status on main details screen
      ** (according to action code)
 
     C                   EXSR      SRSetKeyS
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRUpdate - Updates to file                                   *
      *                                                               *
      *  Called by: Main Processing                                   *
      *                                                               *
      *  Calls:     SRInzFldS, SRInzKeyS                              *
      *                                                               *
      *****************************************************************
     C     SRUpdate      BEGSR
 
      ** If Insert or Amend
 
     C                   IF        #1ACTN = 'I' OR #1ACTN = 'A'
 
     C                   EVAL      WSetFld = '1'
 
     C                   ENDIF
 
      ** Update details
 
     C                   CALLB     'SCRPCNUPD'
 
      ** Return Code
 
     C                   PARM                    RetCodeOut
 
      ** Action Code
 
     C                   PARM                    #1ACTN
 
      ** Replication details Screen fields
 
     C                   PARM                    NwRepFilFmt
 
      ** If there were any errors in the update functions, rollback any
      ** updates and end this program.  Otherwise, commit the updates
 
     C                   IF        RetCodeOut <> *Blanks
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C                   ENDIF
 
      ** Blank the main details screen if insert or delete
 
     C                   IF        #1ACTN = 'I' AND RetCodeOut = *BLANK
     C                   EVAL      NwRepScnFmt = *BLANKS
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'DRC0010'
     C                   ENDIF
 
     C                   IF        #1ACTN = 'D' AND RetCodeOut = *BLANK
     C                   EVAL      NwRepScnFmt = *BLANKS
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'DRC0011'
     C                   ENDIF
 
      ** Leave screen details after amendment of deal
 
     C                   IF        #1ACTN = 'A' AND RetCodeOut = *BLANK
     C                   EVAL      FldNameArr(1) = '*ANY'
     C                   EVAL      MsgIdArr(1)   = 'DRC0012'
     C                   ENDIF
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
     C                   CLEAR                   NwRepScnFmt
 
      ** If records are still to be read from the subfile, read them
 
     C                   IF        WRdnb = 'Y'
     C                   EVAL      WScrn = 'R'
     C                   ELSE
 
      ** else, return to main details screen
 
     C                   EVAL      WScrn = 'M'
     C                   ENDIF
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SREndP - End program                                         *
      *                                                               *
      *  Called by: SRScnMain, SRBldBrw, SRScnConf                    *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SREndP        BEGSR
 
     C                   SELECT
 
      ** CK/12 - set ReturnCode to 'U'
 
     C                   WHEN      PINKL = '1'
     C                   EVAL      ReturnCode = 'U'
 
      ** CK/03 - set ReturnCode to 'Q'
 
     C                   WHEN      PINKC = '1'
     C                   EVAL      ReturnCode = 'Q'
 
     C                   ENDSL
 
     C                   EVAL      WScrn = 'T'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRResetErr - Reset error fields                              *
      *                                                               *
      *  Called by: SRScnMain, SRValMain, SRScnConf                   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRResetErr    BEGSR
 
      ** Reset error fields.
 
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIDArr
     C                   CLEAR                   MsgDtaArr
     C                   Z-ADD     *ZERO         WkIdx
 
     C                   CLEAR                   WFldNamArr
     C                   CLEAR                   WMsgIdArr
     C                   CLEAR                   WMsgDtaArr
     C                   Z-ADD     *ZERO         WkWIdx
 
 
      ** Initialise screen fields error indicators.
 
     C                   EVAL      OkRepFlag = *ALL'Y'
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial Processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
 
      ** Start on Main Details Screen
 
     C                   EVAL      WScrn  =  'M'
 
      ** Initialize field and function key status on main details screen
 
     C                   EXSR      SRInzFldS
     C                   EXSR      SRInzKeyS
 
 
      ** Program, module and procedure names for database error processing
      ** =================================================================
      ** The following /COPY sets these values.
      /COPY ZACPYSRC,DBFIELDS
 
      ** Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,SCRPCN008
 
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
