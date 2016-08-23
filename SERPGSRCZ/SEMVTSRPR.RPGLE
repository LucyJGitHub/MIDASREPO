     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Movements Status - Repair')
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  RPGLE/SEMVTSRPR - Movements Status - Repair                  *
      *                                                               *
      *  Function:  This function allows invalid Movement details to  *
      *             be 'repaired' and applied to the Midas database.  *
      *                                                               *
      *  Note: The window processing occurs after the main update,    *
      *        because in insert mode, we need to know which sequence *
      *        number was affected to the new record by the updater.  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2003            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSE039   *CREATE   Date 05Mar03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSE039 - Automatic Settlement of Trades                      *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
     FZATRNERRL0IF   E           K DISK    INFSR(*PSSR)
      ** Midas ZA Transaction errors file
 
     FSEIMVTSL1 UF   E           K DISK    INFSR(*PSSR)
     F                                     RENAME(SEIMVTSD0:SEIMVTSD1)
     F                                     COMMIT
      ** Midas SE Movements Status - Invalid by FOId/TmSt
 
      /COPY WNCPYSRC,SEMVTSR001
 
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
 
     D/COPY QWINDSRC,SEMVTSDTA
      ** Fields to pass data to the window program
 
     D SEMVTS        E DS                  EXTNAME(SEMVTSPD)
      ** Movement Status in file format
 
     D NewSEMVTS     E DS                  EXTNAME(SEVMVTSPD)
      ** New Movement Status in file format
 
     D NewScnIFld    E DS                  EXTNAME(SEMVTS1PD)
      ** New Movement Status, in screen format - Input/output fields
 
     D NewScnOFld    E DS                  EXTNAME(SEMVTS2PD)
      ** New Movement Status, in screen format - Output only fields
 
     D CurScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(C_)
      ** Current Movement Status, in screen format - Input/output fields
 
     D PrvScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(P_)
      ** Previous state of the screen input/output fields
 
     D PrvScnOFld    E DS                  EXTNAME(SEMVTS2PD) PREFIX(P_)
      ** Previous state of the screen output only fields
 
     D InwScnIFld    E DS                  EXTNAME(SEMVTS1PD) PREFIX(I_)
      ** Initial values from "invalid" screen input/output fields
 
     D InwScnOFld    E DS                  EXTNAME(SEMVTS2PD) PREFIX(I_)
      ** Initial values from "invalid" screen output only fields
 
     D OKMvtFlags    E DS                  EXTNAME(SEEMVTSPD)
      ** Error indicators flags
 
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
 
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** External DS for Midas Modules Details
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short
 
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** Second DS for Access Programs, Long
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Offsets of the first Core & Extension fields in the member
      ** SEMVTS1PD of ZAFLDNPD
     D FlOffsetD       S              5P 0
     D FlOffsetW       S              5P 0
 
      ** Timestamp
     D @TMST           S               Z
 
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
 
     D/COPY WNCPYSRC,SEMVTSR002
 
      *****************************************************************
      /EJECT
      *****************************************************************
      ** +--- Start of Main processing -----------------------------------+
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** +----------------------------------------------------------------+
 
     C/COPY WNCPYSRC,SEMVTSR003
 
      ** Issue rollback to clear any possible updates in window functions
      *
     C                   IF        @INKL = '1'
     C                   ROLBK
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSR004
 
      ** Build browse subfile and write/read the browse screen
      *
     C                   IF        @Scrn = 'B'
     C                   EXSR      BldBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSR005
 
      ** Process the last user's action on the browse screen
      ** (Returns a function key, or an action code, the current
      **  database record and the references of the invalid record
      **  to process, according with the next modified browse
      **  subfile record)
      *
     C                   IF        @Scrn = 'R'
     C                   EXSR      RdNBrw
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSR006
 
      ** Do while screen: Movement Status Details Screen
      *
     C                   DOW       @Scrn = 'D'
     C                   EXSR      Scrn@D
     C                   ENDDO
 
     C/COPY WNCPYSRC,SEMVTSR007
 
      ** File updates
      *
     C                   IF        @Scrn = 'U'
     C                   EXSR      Updats
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSR008
 
      ** Do while screen: Movement Status Extension(s) Details Screen(s)
      *
     C                   DOW       @Scrn = 'W'
     C                   EXSR      Window
     C                   ENDDO
 
     C/COPY WNCPYSRC,SEMVTSR009
 
      ** Terminate module
      *
     C                   IF        @Scrn = 'T'
     C                   EVAL      *INLR = *On
     C                   RETURN
     C                   ENDIF
 
     C/COPY WNCPYSRC,SEMVTSR010
 
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
     C                   PARM      '*RPR'        CallerCode        4
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
     C                   EXSR      EndMod
      ** F5 - Refresh
     C                   WHEN      @INKE = '1'
     C                   EVAL      NewScnIFld = InwScnIFld
     C                   EVAL      NewScnOFld = InwScnOFld
      ** F12 - Previous Screen (i.e. the browse subfile)
     C                   WHEN      @INKL = '1'
     C                   EXSR      Initial
      ** F22 - View linked SWIFT Messages
     C                   WHEN      @INKW = '1'
     C                   EXSR      ViewMsg
      ** ------> F3 while viewing
     C                   IF        @RtCd = 'Y2U9999'
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
     C                   PARM      '*RPR'        CallerCode
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
      ** Update OK: delete the invalid transaction record
      **            if no window processing, commit updates and continue
      **                         with the next action from browse
      **            Else, execute the window processing
      *
 X1  C                   ELSE
     C     KSEIMVTSL1    CHAIN     SEIMVTSD1                          99
     C  N99              DELETE    SEIMVTSD1
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
      ** Set up the Movement Status record key
      *
     C                   EVAL      #1TRRF = VTMTRRF
     C                   EVAL      #1TRTY = VTMTRTY
     C                   EVAL      #1NTDT = VTMNTDT
     C                   EVAL      #1SQNR = VTMSQNR
      *
     C/COPY WNCPYSRC,SEMVTSRMOV
      *
      ** Call the window manager
      *
     C                   CALL      'WN0010'
     C                   PARM      'SEMVTSRPR'   PPgm
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
     C                   ROLBK
     C                   MOVEL     'D'           @Scrn
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
     C                   CALLB     'SEMVTSRPB'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Build Subfile
     C                   PARM      'Y'           @BDSFL            1
      ** Read Subfile Record
     C                   PARM      *Blank        @RDSFL            1
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL            1
      ** Identification of the Invalid Movement to Process
     C                   PARM                    @FOID            20
     C                   PARM                    @TMST
      ** (Current) Movement Record to Process
     C                   PARM                    SEMVTS
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA            3
     C                   PARM                    P@TRDT            5 0
      ** Command Keys
     C                   PARM                    @INKC             1
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
     C                   CALLB     'SEMVTSRPB'
      ** INPUT PARAMETERS
      ** Return Code
     C                   PARM                    RetCodeOut
      ** Build Subfile
     C                   PARM      *Blank        @BDSFL
      ** Read Subfile Record
     C                   PARM      'Y'           @RDSFL
      *
      ** OUTPUT PARAMETERS
      ** Option Selected
     C                   PARM                    @OPSEL
      ** Identification of the Invalid Movement to Process
     C                   PARM                    @FOID
     C                   PARM                    @TMST
      ** (Current) Movement Record to Process
     C                   PARM                    SEMVTS
      ** Booking Branch and Date of the retrieved Transaction
     C                   PARM                    P@BRCA
     C                   PARM                    P@TRDT
      ** Command Keys
     C                   PARM                    @INKC
      *------------------
      ** End the module if F3 selected on browse
      *
     C                   IF        @INKC = '1'
     C                   EXSR      EndMod
     C                   GOTO      EndRdNBrw
     C                   ENDIF
      *
      ** If an action was selected
      *
 B1  C                   IF        @OPSEL <> *Blank
      *
      ** Convert the current database record into screen fields and store them
      *
     C                   EVAL      NewSEMVTS = SEMVTS
     C                   EXSR      CvtMvts
     C                   EVAL      CurScnIFld = InwScnIFld
      *
      ** Equate the new screen fields with the current ones
      ** Override them in reading the invalid record to process
      ** Restore the key fields (may have been found in the current
      ** record by Front Office Id. - retrieve in the browse module -)
      *
     C                   EVAL      NewScnIFld = InwScnIFld
     C                   EVAL      NewScnOFld = InwScnOFld
      *
 B2  C                   IF        @OPSEL <> 'D'
     C     KSEIMVTSL1    CHAIN (N) SEIMVTSD1
      *
     C                   EVAL      DDTRRF = I_DDTRRF
     C                   EVAL      DDTRTY = I_DDTRTY
     C                   EVAL      DDWIOR = I_DDWIOR
     C                   EVAL      DDNTDT = I_DDNTDT
     C                   EVAL      DDSQNR = I_DDSQNR
 E2  C                   ENDIF
      *
      ** Do data substitution if necessary
      *
 B2  C                   IF        @OPSEL = 'A' AND GHSUBS <> *BLANK AND
     C                             %Scan(GHSUBS:NewScnIFld) > 0
     C                   EXSR      DtaSubs
 E2  C                   ENDIF
      *
      ** Update the new output only fields according with the new values
      ** of the input fields (NewSEMVTS initialised just above)
      *
 B2  C                   IF        @OPSEL <> 'D'
     C                   EVAL      VTMSWSC = DDSWSC
     C                   EVAL      VTMSWRC = DDSWRC
     C                   EXSR      CvtMvts
     C                   EVAL      NewScnOFld = InwScnOFld
 E2  C                   ENDIF
      *
      ** Defaults fields of NewSEMVTS that are not updated by the
      ** validation module
      *
 B2  C                   IF        @OPSEL <> 'E'
     C                   EXSR      Defaults
 E2  C                   ENDIF
      *
      ** Setup error indicators flags and messages arrays
      *
     C                   EXSR      SetupErrs
      *
      ** Save the initial values of the new screen fields
      ** Goto the details screen
      *
     C                   EVAL      InwScnIFld = NewScnIFld
     C                   EVAL      InwScnOFld = NewScnOFld
      *
     C                   EVAL      DDACTN = @OPSEL
     C                   EVAL      @Scrn  = 'D'
      *
      ** Else, rebuild subfile browse
      *
 X1  C                   ELSE
     C                   EXSR      Initial
 E1  C                   ENDIF
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
     C                   PARM                    NewSEMVTS
      *
      ** OUTPUT PARAMETERS
      ** Movement Details in screen format
     C                   PARM                    InwScnIFld
      ** Output only Screen Fields
     C                   PARM                    InwScnOFld
      *------------------
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DtaSubs - Data Substitution
      *****************************************************************
     C     DtaSubs       BEGSR
      *
      ** Substitute the data for the various parts of the movement,
      *
     C                   CLEAR                   IncData
     C                   CLEAR                   CurData
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'APDTASUBS'
      ** Return Code
     C                   PARM                    ReturnCode
      ** Substitution character
     C                   PARM                    GHSUBS
      ** Incoming Data
     C                   PARM      NewScnIfld    IncData        2000
      ** Current Data
     C                   PARM      CurScnIFld    CurData        2000
      *
     C                   MOVEL     IncData       NewScnIFld
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * Defaults - Defaults new file fields
      *****************************************************************
     C     Defaults      BEGSR
      *
      ** Booking Branch (thru the browse, from the RTT module)
      *
     C                   IF        @OPSEL = 'I'
     C                   EVAL      VTMTRBB = P@BRCA
     C                   ENDIF
      *
      ** API related fields
      *
     C                   EVAL      VTMFRNT = DDFOTRANID
     C                   EVAL      VTMAFRT = DDFOASOCID
     C                   EVAL      VTMREPA = DDRPRLOCN
      *
      ** Last Change Type
      *
     C                   EVAL      VTMLCTP = @OPSEL
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SetupErrs - Setup error indicators flags and messages arrays
      *****************************************************************
     C     SetupErrs     BEGSR
      *
      ** Reset errors
      *
     C                   EVAL      OKMvtFlags = *All'Y'
     C                   EVAL      FldNameArr = *BLANK
     C                   EVAL      MsgIdArr   = *BLANK
     C                   EVAL      MsgDtaArr  = *BLANK
     C                   EVAL      Idx  = *ZERO
      *
      ** Setup errors
      *
     C     KZATRNERL0    SETLL     ZATRNERRD0
     C     KZATRNERL0    READE     ZATRNERRD0
      *
     C                   DOW       NOT %Eof(ZATRNERRL0)
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *Blank        ReturnCode
     C                   PARM      'SEMVTS1PD'   APIFormat        10
     C                   PARM      ABFIELDNAM    FieldName        10
     C                   PARM      0             FieldNo           5 0
      *
      ** Process only messages relating to the Core screen
      *
     C                   IF        ReturnCode = *Blank    AND
     C                             ABFIELDID >  FlOffsetD AND
     C                             ABFIELDID <= FlOffsetW
     C                   ADD       1             Idx
     C                   EVAL      FldNameArr(Idx) = ABFIELDNAM
     C                   EVAL      MsgIdArr(Idx)   = ABMSGID
     C                   EVAL      %Subst(OKMvtFlags:(ABFIELDID-FlOffsetD):1) =
     C                                                'N'
     C                   ENDIF
      *
     C     KZATRNERL0    READE     ZATRNERRD0
     C                   ENDDO
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
     C                   CLEAR                   PrvScnIFld
     C                   CLEAR                   PrvScnOFld
     C                   CLEAR                   InwScnIFld
     C                   CLEAR                   InwScnOFld
      *
      ** The first screen will be the browse subfile
      *
     C                   MOVEL     'B'           @Scrn
      *
     C/COPY WNCPYSRC,SEMVTSR011
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
      ** Klist's
      *
     C     KSEIMVTSL1    KLIST
     C                   KFLD                    @FOID
     C                   KFLD                    @TMST
      *
     C     KZATRNERL0    KLIST
     C                   KFLD                    @FOID
     C                   KFLD                    @TMST
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
      ** Access API ICD via access program
      *
     C                   CALLB     'AOAPIR0'
     C                   PARM      *BLANKS       @RtCd
     C                   PARM      '*FIRST '     @Optn
     C     SDAPI         PARM      SDAPI         DSFDY
      *
      ** Database Error
      *
     C                   IF        @RtCd <> *Blanks
     C                   EVAL      DBFILE = 'SDAPIPD'                            ************
     C                   EVAL      DBASE  = 902                                  * DBERR 902*
     C                   EVAL      DBKEY = @Optn                                 ************
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Get the field number for the action code field; the Core
      ** screen fields start from that number.  Subtract one from it
      ** to give the value to subtract from each field's number.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *Blank        ReturnCode
     C                   PARM      'SEMVTS1PD'   APIFormat
     C                   PARM      'DDACTN'      FieldName
     C                   PARM      0             FieldNo
      *
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      FlOffsetD = FieldNo - 1
     C                   ELSE
     C                   EVAL      FlOffsetD = 17
     C                   ENDIF
      *
      ** Get the field number for the narrative field; the Core
      ** screen fields end at that number.  It will be the offset
      ** of the first field of the first extension file.
      *
     C                   CALLB     'ZACGTFLDNO'
     C                   PARM      *Blank        ReturnCode
     C                   PARM      'SEMVTS1PD'   APIFormat
     C                   PARM      'DDNARR'      FieldName
     C                   PARM      0             FieldNo
      *
     C                   IF        ReturnCode = *Blanks
     C                   EVAL      FlOffsetW = FieldNo
     C                   ELSE
     C                   EVAL      FlOffsetW = 30
     C                   ENDIF
      *
      ** Prepare the initial screen
      *
     C                   EXSR      Initial
      *
     C/COPY WNCPYSRC,SEMVTSR012
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
