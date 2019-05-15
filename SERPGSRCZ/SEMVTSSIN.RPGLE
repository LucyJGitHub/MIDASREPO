     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Screen Input')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSSIN - Movements Status - Screen Input            *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for the Movements Status file.                    *
      *                                                               *
      *  Note: The window processing occurs after the main update,    *
      *        because in insert mode, we need to know which sequence *
      *        number was affected to the new record by the updater.  *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. CSC022             Date 24Feb04               *
      *                 CSE039  *CREATE    Date 25Feb03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F/COPY WNCPYSRC,SEMVTSS001
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
 
      **---------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **---------------------------------------------------------------
 
      **---------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **---------------------------------------------------------------
 
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
                                                                                              CSC022
     D WCmtJobArr      S             10A   DIM(10)                                            CSC022
      ** Array for commitment job names                                                       CSC022
 
     D/COPY QWINDSRC,SEMVTSDTA
      ** Fields to pass data to the window program
 
     D SEMVTS        E DS                  EXTNAME(SEMVTSPD)
      ** Movement Status in file format
 
     D NewSEMVTS     E DS                  EXTNAME(SEVMVTSPD)
      ** New Movement Status in file format
 
     D NewScnIFld    E DS                  EXTNAME(SEMVTS1PD)
      ** Movement Status, in screen format - Input/output fields
 
     D NewScnOFld    E DS                  EXTNAME(SEMVTS2PD)
      ** Movement Status, in screen format - Output only fields
 
     D CurScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(C_)
      ** Very first state of the screen input/output fields
 
     D CurScnOFld    E DS                  EXTNAME(SEMVTS2PD) PREFIX(C_)
      ** Very first state of the screen output only fields
 
     D PrvScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(P_)
      ** Previous state of the screen input/output fields
 
     D PrvScnOFld    E DS                  EXTNAME(SEMVTS2PD) PREFIX(P_)
      ** Previous state of the screen output only fields
 
     D OKMvtFlags    E DS                  EXTNAME(SEEMVTSPD)
      ** Error indicators flags
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long
                                                                                              CSC022
     D SCCMTJOB      E DS           256    DTAARA(SCCMTJOB)                                   CSC022
     D  ComitJob               4    103                                                       CSC022
      ** Midas SC Jobs handling commitment control data area                                  CSC022
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CSC022
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
                                                                                              CSC022
     D CSC022          S              1A                                                      CSC022
                                                                                              CSC022
     D WCommitSkip     S              1A                                                      CSC022
      ** Commitment Skip Field                                                                CSC022
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     D/COPY WNCPYSRC,SEMVTSS002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
     C/COPY WNCPYSRC,SEMVTSS003
 
      ** Issue rollback to clear any possible updates in window functions
      *
     C                   IF        @INKL = '1'
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSS004
 
      ** Build browse subfile and write/read the browse screen
      *
     C                   IF        @Scrn = 'B'
     C                   EXSR      BldBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSS005
 
      ** Process the last user's action on the browse screen
      ** (Returns a function key, or the database record to process
      **  and an action code, according with the next modified browse
      **  subfile record)
      *
     C                   IF        @Scrn = 'R'
     C                   EXSR      RdNBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSS006
 
      ** Do while screen: Movement Status Details Screen
      *
     C                   DOW       @Scrn = 'D'
     C                   EXSR      Scrn@D
     C                   ENDDO
 
     C/COPY WNCPYSRC,SEMVTSS007
 
      ** File updates
      *
     C                   IF        @Scrn = 'U'
     C                   EXSR      Updats
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSS008
 
      ** Do while screen: Movement Status Extension(s) Details Screen(s)
      *
     C                   DOW       @Scrn = 'W'
     C                   EXSR      Window
     C                   ENDDO
 
     C/COPY WNCPYSRC,SEMVTSS009
 
      ** Terminate module
      *
     C                   IF        @Scrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSS010
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * Scrn@D - Process detail screen
      *****************************************************************
     C     Scrn@D        BEGSR
      *
      ** Set up parameters
      *
      ** Enables F5
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      @EINKE = 'Y'
     C                   ELSE
     C                   EVAL      @EINKE = 'N'
     C                   ENDIF
      *
      ** Enables F10
      *
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
      *
      ** Enables F22
      *
     C                   EVAL      @EINKW = 'N'
      *
 B1  C                   IF        DDINOR <> 'MANUAL' AND DDMSGK <> *Blanks
      *
      ** The user must be allowed to view messages
      *
      ** If not multi-branching
      *
 B2  C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      'M'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** If multi-branching
      *
 X2  C                   ELSE
     C                   CALL      'ZVACTBU'
     C                   PARM      'M'           ZACTN
     C                   PARM      VTMTRBB       ZBR               3
     C                   PARM                    @@ERR
 E2  C                   ENDIF
      *
 B2  C                   IF        @@ERR = 0
     C                   EVAL      @EINKW = 'Y'
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Write/Read display screen
      *------------------
     C                   CALLB     'SEMVTSDSP'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Calling Module Code (*SIN or *RPR)
     C                   PARM      '*SIN'        CallerCode        4
      ** Movement Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOfld
      ** Error Indicators Flags
     C                   PARM                    OKMvtFlags
      ** Write only indicator
     C                   PARM      'N'           WriteOnly         1
      ** Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      ** Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Enabled Function Keys
     C                   PARM                    @EINKE            1            F5
     C                   PARM                    @EINKJ            1            F10
     C                   PARM                    @EINKW            1            F22
      *
      ** OUTPUT PARAMETERS:
      ** Function Keys
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKJ             1            F10
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKW             1            F22
      *------------------
      ** Store image of input screen and current number of warnings
      *
     C                   EVAL      PrvScnIFld = NewScnIFld
     C                   EVAL      PrvScnOFld = NewScnOFld
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
      *
      ** Reset Errors
      *
     C                   EVAL      OKMvtFlags = *ALL'Y'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      Idx  = *ZERO
     C                   EVAL      WFldNamArr = *BLANK
     C                   EVAL      WMsgIDArr  = *BLANK
     C                   EVAL      WMsgDtaArr = *BLANK
     C                   EVAL      WIdx = *ZERO
      *
      ** Test the function key used and process accordingly
      *
     C                   SELECT
      ** F3 - End Module
     C                   WHEN      @INKC = '1'
     C                   EVAL      O@INKC = @INKC
     C                   EXSR      EndMod
      ** F5 - Refresh
     C                   WHEN      @INKE = '1'
     C                   EVAL      NewScnIFld = CurScnIFld
     C                   EVAL      NewScnOFld = CurScnOFld
      ** F12 - Previous Screen (i.e. the browse subfile)
     C                   WHEN      @INKL = '1'
     C                   EXSR      Initial
      ** F22 - View linked SWIFT Messages
     C                   WHEN      @INKW = '1'
     C                   EXSR      ViewMsg
      ** ------> F3 while viewing
     C                   IF        @RtCd = 'Y2U9999'
     C                   EVAL      O@INKC = '1'
     C                   EXSR      EndMod
     C                   ENDIF
      ** Enter or F10 - Validate inputs
     C                   OTHER
     C                   EXSR      Val@D
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Val@D  - Validate input to details screen
      *****************************************************************
     C     Val@D         BEGSR
      *----------------------------------------------------------------
      ** If Delete
      *
     C                   IF        DDACTN = 'D'
      *
      ** If F10 taken, execute updates
      *
     C                   IF        @INKJ = '1'
     C                   MOVEL     'U'           @Scrn             1
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
      ** If Enquire, continue with window or with the next action from browse
      *
     C                   IF        DDACTN = 'E'
      *
     C                   IF        BGWDPR = 'Y'
     C                   EVAL      @Scrn = 'W'
     C                   ELSE
     C                   EVAL      @Scrn = 'R'
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
      ** If Insert or Amend / Change
      *
 B1  C                   IF        DDACTN = 'I' OR
     C                             DDACTN = 'A'
      *
      ** Validate Movement details
      *------------------
     C                   CALLB     'SEMVTSVAL'
      ** INPUT PARAMETERS
      ** Movement Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOFld
      ** Current Transaction Details in screen format
     C                   PARM                    CurScnIfld
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM      '*SIN'        CallerCode
      ** Date of the linked Transaction (thru the browse, from the RTT module)
     C                   PARM                    P@TRDT
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details OK inds
     C                   PARM                    OKMvtFlags
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    Idx               3 0
      ** Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      ** Array index (3P0) from/to caller
     C                   PARM                    WIdx              3 0
      ** Valid Transaction details layout (DS) from/to caller
     C                   PARM                    NewSEMVTS
      *------------------
      ** If errors returned
      *
 B2  C                   IF        Idx <> 0
     C                   GOTO      EndVal@D
 E2  C                   ENDIF
      *
      ** If any screen defaulting or reformatting has occurred in validation
      ** or if the number of warnings has changed, re-display the screen
      *
 B2  C                   IF        NewScnIFld <> PrvScnIFld OR
     C                             NewScnOFld <> PrvScnOFld OR
     C                             WIdx       <> PrvN_Warn
     C                   GOTO      EndVal@D
 E2  C                   ENDIF
      *
      ** Execute updates
      *
     C                   EVAL      @Scrn = 'U'
 E1  C                   ENDIF
      *
     C     EndVal@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ViewMsg - View the linked SWIFT messages
      *****************************************************************
     C     ViewMsg       BEGSR
      *
      ** Call the SWIFT Message Enquiry
      ** Note that the parameters can not be changed by this input,
      ** as F22 is only available for non-"manual" origins, and the
      ** message reference is thus non-amendable. So the parameters
      ** could have been taken from NewScnIFld, CurScnIFld or SEMVTS
      ** as well.
      *
     C                   CALL      'SE4410'
     C                   PARM      VTMTRRF       P@TRRF            6
     C                   PARM      VTMTRTY       P@TRTY            1
     C                   PARM      VTMMSGK       P@MSGK           40
     C                   PARM      *Blanks       @RtCd
      *
     C     EndViewMsg    ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Updats - Updates the database
      *****************************************************************
     C     Updats        BEGSR
      *
      ** Call the Movement details update
      *------------------
     C                   CALLB     'SEMVTSUPD'
     C                   PARM      *Blanks       @RtCd
     C                   PARM                    NewSEMVTS
      *------------------
      ** If there were any errors in the update functions, roll back any
      ** updates and end this program when severe errors
      *
 B1  C                   IF        @RtCd <> *BLANK
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
 B2  C                   IF        @RtCd <> '*RECUPD'
     C                   EXSR      *PSSR
      *
      ** If update not done due to record being updated by another
      ** workstation send message to screen and continue with the
      ** next action from browse
      *
 X2  C                   ELSE
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'MMM1067'
     C                   MOVEL     'R'           @Scrn
 E2  C                   ENDIF
      *
      ** Update OK: if no window processing, commit updates and continue
      **                         with the next action from browse
      **            Else, execute the window processing
      *
 X1  C                   ELSE
      *
 B2  C                   IF        BGWDPR <> 'Y'
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   MOVEL     'R'           @Scrn
 X2  C                   ELSE
     C                   MOVEL     'W'           @Scrn
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Window - Window Manager
      *****************************************************************
     C     Window        BEGSR
      *
      ** Set up the Movement Status record key
      *
     C                   EVAL      #1TRRF = VTMTRRF
     C                   EVAL      #1TRTY = VTMTRTY
     C                   EVAL      #1NTDT = VTMNTDT
     C                   EVAL      #1SQNR = VTMSQNR
      *
     C/COPY WNCPYSRC,SEMVTSSMOV
      *
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SEMVTSSIN'   PPgm
     C                   PARM      *Blanks       PKey
     C                   PARM      DDACTN        PAction
     C                   PARM                    PData
     C                   PARM      *Blanks       PRtcd
     C                   PARM      *Blanks       PSpareW
      *
      ** Process returned command keys
      *
      ** F3, exit and return to calling program (roll back in EndMod)
      *
     C                   IF        PRtcd = 'Y2U9999'
     C                   EVAL      O@INKC = '1'
     C                   EXSR      EndMod
     C                   GOTO      EndWindow
     C                   ENDIF
      *
      ** F12, roll back any updates (including the Core ones)
      **            and return to detail screen
      ** otherwise, commit all updates (including the Core ones)
      **            and continue with the next action from browse
      *
     C                   IF        PRtcd = 'USR0790'
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   MOVEL     'D'           @Scrn
     C                   ELSE
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                             or (CSC022 = 'Y' and WCommitSkip <> 'Y')                   CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   MOVEL     'R'           @Scrn
     C                   ENDIF
      *
     C     EndWindow     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BldBrw - Build browse subfile and write/read the browse screen
      *****************************************************************
     C     BldBrw        BEGSR
      *
      ** Call the browse module
      *------------------
     C                   CALLB     'SEMVTSBRW'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Processing Mode (E/Enquiry or M/Maintenance)
     C                   PARM                    I@ProcMode
      ** Build Subfile
     C                   PARM      'Y'           @BDSFL            1
      ** Read Subfile Record
     C                   PARM      *Blank        @RDSFL            1
      *
      ** INPUT/OUTPUT PARAMETERS
      ** In/out=Movement Reference - Out=Movement record to process
     C                   PARM                    SEMVTS
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA            3
     C                   PARM                    P@TRDT            5 0
      ** Command Keys
     C                   PARM                    @INKC             1
     C                   PARM                    @INKL             1
      *------------------
      ** Process the last user's action on the browse screen
      *
     C                   EVAL      @Scrn = 'R'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RdNBrw - Process the last user's action on the browse screen
      *****************************************************************
     C     RdNBrw        BEGSR
      *
      ** Call the browse module
      *------------------
     C                   CALLB     'SEMVTSBRW'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Processing Mode (E/Enquiry or M/Maintenance)
     C                   PARM                    I@ProcMode
      ** Build Subfile
     C                   PARM      *Blank        @BDSFL
      ** Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      *
      ** INPUT/OUTPUT PARAMETERS
      ** In/out=Movement Reference - Out=Movement record to process
     C                   PARM                    SEMVTS
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA
     C                   PARM                    P@TRDT
      ** Command Keys
     C                   PARM                    @INKC
     C                   PARM                    @INKL
      *------------------
      ** End the module if F3 or F12 selected on browse
      *
     C                   IF        @INKC = '1' OR @INKL = '1'
     C                   EVAL      O@INKC = @INKC
     C                   EVAL      O@INKL = @INKL
     C                   EXSR      EndMod
     C                   GOTO      EndRdNBrw
     C                   ENDIF
      *
      ** If an action was selected
      *
     C                   IF        @OPSEL <> *Blank
     C                   EVAL      DDACTN = @OPSEL
      *
      ** Set up the new file record format,
      ** which will be updated by the screen fields
      *
     C                   EVAL      NewSEMVTS = SEMVTS
     C                   EVAL      VTMLCTP = DDACTN
      *
      ** Convert Movement Details to Screen Format, do defaulting if
      ** insert mode and save the current fields values
      *
     C                   EXSR      CvtMvts
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      Defaults
     C                   ENDIF
      *
     C                   EVAL      CurScnIFld = NewScnIFld
     C                   EVAL      CurScnOFld = NewScnOFld
      *
      ** Reset error indicators flags
      *
     C                   EVAL      OKMvtFlags = *All'Y'
      *
      ** Goto the details screen
      *
     C                   EVAL      @Scrn = 'D'
      *
      ** Else, rebuild subfile browse
      *
     C                   ELSE
     C                   EXSR      Initial
     C                   ENDIF
      *
     C     EndRdNBrw     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CvtMvts - Move fields from file to screen
      *****************************************************************
     C     CvtMvts       BEGSR
      *
      ** Call the conversion module
      *------------------
     C                   CALLB     'SEMVTSCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Movement Details in file format
     C                   PARM                    SEMVTS
      *
      ** OUTPUT PARAMETERS
      ** Movement Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOFld
      *------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Defaults - Defaults screen/file fields in insert mode
      *****************************************************************
     C     Defaults      BEGSR
      *
      ** Screen: Input Origin
      *
     C                   EVAL      DDINOR = 'MANUAL'
      *
      ** File: Booking Branch (thru the browse, from the RTT module)
      *
     C                   EVAL      VTMTRBB = P@BRCA
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initial - Set up the program variables to go to the initial screen
      *****************************************************************
     C     Initial       BEGSR
      *
      ** Clear all the data structures (to avoid decimal data exception errors)
      *
     C                   CLEAR                   SEMVTS
     C                   CLEAR                   NewSEMVTS
     C                   CLEAR                   NewScnIFld
     C                   CLEAR                   NewScnOFld
     C                   CLEAR                   CurScnIFld
     C                   CLEAR                   CurScnOFld
     C                   CLEAR                   PrvScnIFld
     C                   CLEAR                   PrvScnOFld
      *
      ** The first screen will be the browse subfile
      *
     C                   MOVEL     'B'           @Scrn
      *
      ** Input parameters to be passed to the browse module to build the subfile
      *
     C                   EVAL      TMTRRF = I@TRRF
     C                   EVAL      TMTRTY = I@TRTY
      *
     C/COPY WNCPYSRC,SEMVTSS011
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EndMod - End Module
      *****************************************************************
     C     EndMod        BEGSR
      *
      ** Always issue a rollback to clear any possible not committed updates
      *
     C                   If        (CSC022 <> 'Y')                                            CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        (WCommitSkip <> 'Y')                                       CSC022
     C                   ROLBK                                                                CSC022
     C                   Else                                                                 CSC022
     C                   Seton                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *
      ** Screen code to "Terminate"
      *
     C                   EVAL      @Scrn = 'T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Parameters
      *
     C     *ENTRY        PLIST
      *
      ** INPUT PARAMETERS:
      ** Transaction Reference and Type of which events are to be processed
      ** (All blank when called from a menu)
     C                   PARM                    I@TRRF            6
     C                   PARM                    I@TRTY            1
      ** Processing Mode (E/Enquiry or M/Maintenance)
     C                   PARM                    I@ProcMode        1
      *
      ** OUTPUT PARAMETERS:
      ** Return indicators, respectively for end of module by F3 or by F12
     C                   PARM                    O@INKC            1
     C                   PARM                    O@INKL            1
      *
      ** Program, module and procedure names for database error processing.
      *
     C                   EVAL      DBPgm  = PSProcPgm
     C                   EVAL      DBMod  = PSProcMod
     C                   EVAL      DBProc = PSProcName
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDBANKPD'                           ************
     C                   EVAL      DBASE  = 900                                  * DBERR 900*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDMMODPD'                           ************
     C                   EVAL      DBASE  = 901                                  * DBERR 901*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Clear the ouput parameters
      *
     C                   EVAL      O@INKC = ' '
     C                   EVAL      O@INKL = ' '
      *
      ** Prepare the initial screen
      *
     C                   EXSR      Initial
      *
      ** Access Switchable Features File, for CSC022                                          CSC022
      *                                                                                       CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      @SARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
     C                   Eval      WCommitSkip = 'N'                                          CSC022
      *                                                                                       CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
     C                   MoveA     ComitJob      WCmtJobArr                                   CSC022
      *                                                                                       CSC022
     C     PSJOBNAME     LOOKUP    WCmtJobArr                             87                  CSC022
     C                   If        *IN87 = *ON                                                CSC022
     C                   Eval      WCommitSkip = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** If return code <> *NRF, call program exception error routine                         CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF'                                            CSC022
     C     *LOCK         IN        LDA                                                        CSC022
     C                   EVAL      DBKEY = 'CSC022'                                           CSC022
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC022
     C                   EVAL      DBASE = 902                                                CSC022
     C                   OUT       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C/COPY WNCPYSRC,SEMVTSS012
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
      *****************************************************************
      /COPY ZACPYSRC,PSSR_ILE
      *****************************************************************
**CTDATA CPY@
(c) Finastra International Limited 2003
