     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Statmts Prod. Requests - Screen Input')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SESTPRSIN - Statement Production Requests - Screen Input
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for the Statement Production Requests file.       *
      *                                                               *
      *  Note: The window processing occurs after the main update,    *
      *        because in insert mode, we need to know which sequence *
      *        number was affected to the new record by the updater.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *  Last Amend No. CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Prev Amend No. TDA035             Date 02Apr04               *
      *                 CSE040   *CREATE   Date 25Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  CSE040 - Securities Statement Processing                     *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     F/COPY WNCPYSRC,SESTPRS001
 
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
 
     D/COPY QWINDSRC,SESTPRDTA
      ** Fields to pass data to the window program
 
     D SESTPR        E DS                  EXTNAME(SESTPRPD)
      ** Statement Production Request in file format
 
     D NewSEStPR     E DS                  EXTNAME(SEVSTPRPD)
      ** New Statement Production Request in file format
 
     D NewScnIFld    E DS                  EXTNAME(SESTPR1PD)
      ** Statement Production Request, in screen format - Input/output fields
 
     D NewScnOFld    E DS                  EXTNAME(SESTPR2PD)
      ** Statement Production Request, in screen format - Output only fields
 
     D CurScnIFld    E DS                  EXTNAME(SESTPR1PD) PREFIX(C_)
      ** Very first state of the screen input/output fields
 
     D CurScnOFld    E DS                  EXTNAME(SESTPR2PD) PREFIX(C_)
      ** Very first state of the screen output only fields
 
     D PrvScnIFld    E DS                  EXTNAME(SESTPR1PD) PREFIX(P_)
      ** Previous state of the screen input/output fields
 
     D PrvScnOFld    E DS                  EXTNAME(SESTPR2PD) PREFIX(P_)
      ** Previous state of the screen output only fields
 
     D OKStPRFlags   E DS                  EXTNAME(SEESTPRPD)
      ** Error indicators flags
 
     D SDUSER        E DS                  EXTNAME(MUSERDD) PREFIX(US_)
      ** External DS for User Details
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     D/COPY WNCPYSRC,SESTPRS002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
     C/COPY WNCPYSRC,SESTPRS003
 
      ** Issue rollback to clear any possible updates in window functions
      *
     C                   IF        @INKL = '1'
     C                   ROLBK
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESTPRS004
 
      ** Build browse subfile and write/read the browse screen
      *
     C                   IF        @Scrn = 'B'
     C                   EXSR      BldBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESTPRS005
 
      ** Process the last user's action on the browse screen
      ** (Returns a function key, or the database record to process
      **  and an action code, according with the next modified browse
      **  subfile record)
      *
     C                   IF        @Scrn = 'R'
     C                   EXSR      RdNBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESTPRS006
 
      ** Do while screen: Statement Production Request Details Screen
      *
     C                   DOW       @Scrn = 'D'
     C                   EXSR      Scrn@D
     C                   ENDDO
 
     C/COPY WNCPYSRC,SESTPRS007
 
      ** Do while screen: Statement Production Request View Only Screen
      *
     C                   DOW       @Scrn = 'V'
     C                   EXSR      Scrn@V
     C                   ENDDO
 
     C/COPY WNCPYSRC,SESTPRS008
 
      ** File updates
      *
     C                   IF        @Scrn = 'U'
     C                   EXSR      Updats
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESTPRS009
 
      ** Do while screen: Statement Production Request Extension(s) Details Screen(s)
      *
     C                   DOW       @Scrn = 'W'
     C                   EXSR      Window
     C                   ENDDO
 
     C/COPY WNCPYSRC,SESTPRS010
 
      ** Terminate module
      *
     C                   IF        @Scrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C/COPY WNCPYSRC,SESTPRS011
 
      *****************************************************************
      /EJECT
      *****************************************************************
      * Scrn@D - Process detail screen (only when 'A' or 'I' action codes)
      *****************************************************************
     C     Scrn@D        BEGSR
      *
      ** Set up parameters
      *
      ** Enables key fields change
      *
     C                   IF        DDACTN = 'I'    AND
     C                             (I@CUST = '*PGM' OR I@CUST = *Blanks)
     C                   EVAL      @EdtKeyFld = 'Y'
     C                   ELSE
     C                   EVAL      @EdtKeyFld = 'N'
     C                   ENDIF
      *
      ** Write/Read display screen
      *------------------
     C                   CALLB     'SESTPRDSP'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Request Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOfld
      ** Error Indicators Flags
     C                   PARM                    OKStPRFlags
      ** Editing of Key Fields (Y/N)
     C                   PARM                    @EdtKeyFld        1
      ** Editing of Other Fields (Y/N)
     C                   PARM      'Y'           @EdtOthFld        1
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
      ** Enables Function Keys (Y/N)
     C                   PARM      'Y'           @EINKE            1            F5
     C                   PARM      'N'           @EINKJ            1            F10
     C                   PARM      'N'           @EINKY            1            F24
      *
      ** OUTPUT PARAMETERS:
      ** Used Function Keys (1/0)
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKJ             1            F10
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKY             1            F24
      *------------------
      ** Store image of input screen and current number of warnings
      *
     C                   EVAL      PrvScnIFld = NewScnIFld
     C                   EVAL      PrvScnOFld = NewScnOFld
     C                   Z-ADD     WIdx          PrvN_Warn         3 0
      *
      ** Reset Errors
      *
     C                   EVAL      OKStPRFlags = *ALL'Y'
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
      ** Enter - Validate inputs
     C                   OTHER
     C                   EXSR      Val@D
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Val@D  - Validate input to details screen (only when 'A' or 'I' action codes)
      *****************************************************************
     C     Val@D         BEGSR
      *
      ** Validate Request details
      *------------------
     C                   CALLB     'SESTPRVAL'
      ** INPUT PARAMETERS
      ** Request Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOFld
      ** Current Transaction Details in screen format
     C                   PARM                    CurScnIfld
      ** Calling Module Code (*SIN, *RPR, etc...)
     C                   PARM      '*SIN'        CallerCode        4
      *
      ** OUTPUT PARAMETERS
      ** Transaction Details OK inds
     C                   PARM                    OKStPRFlags
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
     C                   PARM                    NewSEStPR
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
      ** Go to view only screen, for confirmation
      *
     C                   EVAL      @Scrn = 'V'
      *
     C     EndVal@D      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Scrn@V - Process View Only screen
      *****************************************************************
     C     Scrn@V        BEGSR
      *
      ** Note: At this point, SPF validation has been done
      **       .For insert, by the validation module called in Val@D
      **       .For other action codes, by the retrieve module called
      **        in the browse module
      *
      ** Set up parameters
      *
      ** Enables F10 + Information message
      *
     C                   IF        DDACTN = 'D'
     C                   EVAL      @EINKJ = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'ST00001'
     C                   ELSE
     C                   EVAL      @EINKJ = 'N'
     C                   ENDIF
      *
      ** Enables F24 + Information message
      ** -- Default value
      *
     C                   EVAL      @EINKY = 'N'
      *
      ** -- Validation has been done in the retrieve module for action 'X'
      *
     C                   IF        DDACTN = 'X'
     C                   EVAL      @EINKY = 'Y'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'ST00073'
     C                   ENDIF
      *
      ** -- Validation of action code 'X' when confirmation of insert or amend
      *
 B1  C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      Idx = Idx + 1
     C                   EVAL      FldNameArr(Idx) = '*ANY'
     C                   EVAL      MsgIdArr(Idx) = 'ST00074'
      *
      ** If not multi-branching
      *
 B2  C                   IF        BJSBRC <> *BLANK
     C                   CALL      'ZVACTU'
     C                   PARM      'X'           ZACTN             1
     C                   PARM                    @@ERR             1 0
      *
      ** If multi-branching (do checking for sending AND originating branches)
      *
 X2  C                   ELSE
     C                   EVAL      ZBR = DDSNDR
      *
 B3  C                   DO        2
     C                   CALL      'ZVACTBU'
     C                   PARM      'X'           ZACTN
     C                   PARM                    ZBR               3
     C                   PARM                    @@ERR
      *
 B4  C                   IF        @@ERR > 0
     C                   LEAVE
 E4  C                   ENDIF
      *
     C                   EVAL      ZBR = DDORIG
 E3  C                   ENDDO
      *
 E2  C                   ENDIF
      *
 B2  C                   IF        @@ERR = 0 AND US_ROUF = 'Y'                  Routing Officer
     C                   EVAL      @EINKY = 'Y'
     C                   EVAL      MsgIdArr(Idx) = 'ST00075'                    Override previous
 E2  C                   ENDIF
      *
 E1  C                   ENDIF
      *
      ** Write/Read display screen
      *------------------
     C                   CALLB     'SESTPRDSP'
      ** INPUT PARAMETERS:
      ** Return code
     C                   PARM                    RetCodeOut
      ** Request Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOfld
      ** Error Indicators Flags
     C                   PARM                    OKStPRFlags
      ** Editing of Key Fields (Y/N)
     C                   PARM      'N'           @EdtKeyFld        1
      ** Editing of Other Fields (Y/N)
     C                   PARM      'N'           @EdtOthFld        1
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
      ** Enables Function Keys (Y/N)
     C                   PARM      'N'           @EINKE            1            F5
     C                   PARM                    @EINKJ            1            F10
     C                   PARM                    @EINKY            1            F24
      *
      ** OUTPUT PARAMETERS:
      ** Used Function Keys (1/0)
     C                   PARM                    @INKC             1            F3
     C                   PARM                    @INKE             1            F5
     C                   PARM                    @INKJ             1            F10
     C                   PARM                    @INKL             1            F12
     C                   PARM                    @INKY             1            F24
      *------------------
      ** Reset Errors
      *
     C                   EVAL      OKStPRFlags = *ALL'Y'
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
      ** F12 - Previous Screen (detail screen or browse subfile)
     C                   WHEN      @INKL = '1'
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      @Scrn = 'D'
     C                   ELSE
     C                   EXSR      Initial
     C                   ENDIF
      ** Enter, F10 or F24 - Execute required action
     C                   OTHER
     C                   EXSR      Act@V
     C                   ENDSL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Act@V  - Execute action required from View Only screen
      *****************************************************************
     C     Act@V         BEGSR
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
      ** If Authorise
      *
     C                   IF        DDACTN = 'X'
      *
      ** If F24 taken, execute updates
      *
     C                   IF        @INKY = '1'
     C                   MOVEL     'U'           @Scrn
     C                   ENDIF
      *
     C                   ENDIF
      *----------------------------------------------------------------
      ** If Insert or Amend
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
      *
      ** If F24 taken, change last change type
      *
     C                   IF        @INKY = '1'
     C                   EVAL      VSPCHTP = 'X'
     C                   ENDIF
      *
      ** Execute updates
      *
     C                   EVAL      @Scrn = 'U'
     C                   ENDIF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Updats - Updates the database
      *****************************************************************
     C     Updats        BEGSR
      *
      ** Call the Statement Production Request details update
      *------------------
     C                   CALLB     'SESTPRUPD'
     C                   PARM      *Blanks       @RtCd
     C                   PARM                    DDACTN
     C                   PARM                    NewSEStPR
      *------------------
      ** If there were any errors in the update functions, roll back any
      ** updates and end this module when severe errors
      *
 B1  C                   IF        @RtCd <> *BLANK
     C                   ROLBK
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
     C                   COMMIT
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
      ** Set up the Statement Production Request record key
      *
     C                   EVAL      #1DATE = VSPDATE
     C                   EVAL      #1RSEQ = VSPRSEQ
      *
     C/COPY WNCPYSRC,SESTPRSMOV
      *
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SESTPRSIN'   PPgm
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
      **            and return to the view only screen
      ** otherwise, commit all updates (including the Core ones)
      **            and continue with the next action from browse
      *
     C                   IF        PRtcd = 'USR0790'
     C                   ROLBK
     C                   MOVEL     'V'           @Scrn
     C                   ELSE
     C                   COMMIT
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
     C                   CALLB     'SESTPRBRW'
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
      ** In/out=Request Reference - Out=Request record to process
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
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
     C                   CALLB     'SESTPRBRW'
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
      ** In/out=Request Reference - Out=Request record to process
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL
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
     C                   EVAL      NewSEStPR = SESTPR
      *
      ** Do defaulting if insert mode, convert Request Details to
      ** Screen Format, restore the current record values and
      ** save the current fields values
      *
     C                   IF        DDACTN = 'I'
     C                   EXSR      Defaults
     C                   ENDIF
      *
     C                   EXSR      CvtStPR
      *
     C                   EVAL      SESTPR = NewSEStPR
     C                   EVAL      VSPCHTP = DDACTN
      *
     C                   EVAL      CurScnIFld = NewScnIFld
     C                   EVAL      CurScnOFld = NewScnOFld
      *
      ** Reset error indicators flags
      *
     C                   EVAL      OKStPRFlags = *All'Y'
      *
      ** Goto the details or view only screen
      *
     C                   IF        DDACTN = 'I' OR DDACTN = 'A'
     C                   EVAL      @Scrn = 'D'
     C                   ELSE
     C                   EVAL      @Scrn = 'V'
     C                   ENDIF
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
      * CvtStPR - Move fields from file to screen
      *****************************************************************
     C     CvtStPR       BEGSR
      *
      ** Call the conversion module
      *------------------
     C                   CALLB     'SESTPRCVT'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Statement Production Request in file format
     C                   PARM                    SESTPR
      *
      ** OUTPUT PARAMETERS
      ** Request Details in screen format
     C                   PARM                    NewScnIFld
      ** Output only Screen Fields
     C                   PARM                    NewScnOFld
      *------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Defaults - Defaults file fields in insert mode
      *****************************************************************
     C     Defaults      BEGSR
      *
      ** Message Priority
      *
     C                   EVAL      SPPRTY = 'N'
      *
      ** Delivery Notification
      *
     C                   EVAL      SPNOTF = '2'
      *
      ** Sending & Originating Branches
      *
     C                   EVAL      SPSNDR = US_DBRN
     C                   EVAL      SPORIG = US_DBRN
      *
      ** Frequency
      *
     C                   EVAL      SPFREQ = 'Z'
      *
      ** Recipient (Customer is passed to BRW, returned by it and set up by CVT)
      *
     C                   EVAL      SPRECP = SPCUST
      *
      ** Start Date
      *
     C                   EVAL      SPMSTD = BJRDNB
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
     C                   CLEAR                   SESTPR
     C                   CLEAR                   NewSEStPR
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
     C                   EVAL      SPCUST = I@CUST
      *
     C/COPY WNCPYSRC,SESTPRS012
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
     C                   ROLBK
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
      ** Safekeeping Customer for whom requests are to be processed
      ** (Blank when called from a menu)
      ** ("*PGM" or Customer Number when called from a program)
     C                   PARM                    I@CUST            6
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
      *                                                               >><<==
     C     BJDFIN        COMP      'M'                                    98
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
      ** Access User Details
      *
     C                   CALL      'AOUSERR0'
     C                   PARM      *Blanks       @RtCd
     C                   PARM      '*KEY'        @Optn
     C                   PARM      PSUser        @USRP            10
     C     SDUSER        PARM      SDUSER        DSSDY
      *
      ** Database error
      *
     C                   IF        @RtCd <> *Blanks
     C                   MOVEL     'MUSERDD'     DBFILE                          ************
     C                   Z-ADD     902           DBASE                           * DBERR 902*
     C                   MOVEL     PSUser        DBKEY                           ************
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
     C/COPY WNCPYSRC,SESTPRS013
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
(c) Misys International Banking Systems Ltd. 2003
