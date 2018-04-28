     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Receivers and Intermediary Charges')
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FT000327   - Maintain Receivers and intermediary Charges     *
      *                                                               *
      *  Function:  This program allows the input, review and         *
      *             maintenance of Receivers and Intermediaries       *
      *             charges.                                          *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *  Last Amend No. CSD031             Date 10Apr06               *
      *  Prev Amend No. BUG433             Date 05Dec05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6198            Date 04Apr05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009   *CREATE   Date 01Jun00               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  BUG433 - Recompiled due to change in FTPCHGPD                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6198- Cannot save new Details for CUSD (Recompile)        *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CFT009 - Funds Transfer Fees and Charge Development          *
      *                                                               *
      *****************************************************************
      * Displau File
     FFT000327DFCF   E             WORKSTN SFILE(FT327S1:SFLRRN)
 
      * Receivers and Intermedaries File
     FFTRICHL0  UF A E           K DISK    Commit Infds(RiDs) InFsr(RiSr)
     FFTRICHL2  IF A E           K DISK    Rename(FTRICHD0:FileRd)
 
      * Transaction Type File
     FFTTRNTL0  IF   E           K DISK
 
      * Charge Code File
     FFTPCHGL0  IF   E           K DISK
 
      * Customer S.W.I.F.T. codes
     FSDCUSTL7  IF   E           K DISK
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
      **    False      logical = *off (for indcator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)
 
     D/COPY ZACPYSRC,STD_D_SPEC
 
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
 
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
 
     D/COPY ZACPYSRC,PSDS
 
      ** Program, procedure and module names for parameters
      ** ==================================================
 
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_XARRYS
      **--------------------------------------------------------------------------------------------
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
     D  Reload         S              1
     D  ValidOK        S              1
 
     DMSGDS            DS
     D  Msgid                  1      7
     D  Msgf                   8     17    Inz('FTUSRMSG')
     D  Msglib                18     27    Inz('*LIBL')
     D  MsgDta                28    283    Inz(' ')
     D  MsgRel               284    288    Inz('*SAME')
 
     D D@FMT         E DS                  EXTNAME(DSSDY)
      *  External Data structure to hold the outgoing record format
 
     D D@BIC         E DS                  EXTNAME(MEBICDPD)
      *  BIC details
 
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      *  Customer Details
 
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      ** External DS for Currency details
 
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D RiDS            DS
     D  RiStatus         *Status
 
     D DSfDY         E DS                  EXTNAME(DSfDY)
 
      ** External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+
     D Record_Locked   C                   Const(01218)
     D No_Desc         C                   Const('No Description Found')
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D  @Type                              Like(@Rtcd)
     D  IdIn           S             18
 
     D RiLocked        S              1
     D ReturnPt        S              6
 
     D Warning         S              1
 
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
 
     C                   Dow       *Inkc = *Off
 
     C                   If        RiLocked = 'Y'
     C                   Eval      RiLocked = 'N'
     C                   Eval      Reload   = 'Y'
     C                   Write     MsgCtl
     C                   Write     FT327T1
     C                   Exfmt     FT327C1
 
     C                   Else
 
     C                   If        Reload = 'Y'
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
     C                   Endif
 
      * Display subfile data
     C                   Write     MsgCtl
     C                   Write     FT327T1
     C                   Exfmt     FT327C1
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
 
     C                   Select
 
      * When positioner changed, reload subfile
     C                   When      *In60
     C                   Exsr      Clr@Sf
     C                   Exsr      Load@Sf
 
      * F9 pressed : Add Record
     C                   When      *InkI  = *On
     C                   Eval      #Act   = 'I'
     C                   Eval      *In44  = *Off
     C                   Eval      *In49  = *Off
     C                   Eval      *In50  = *Off
     C                   Eval      *In51  = *Off
 
      * Clear Screen Data
     C                   Exsr      Clr_Dta
 
     C                   Exsr      DtlRcd
 
     C                   Other
 
      * Sfldsp = 30.  ie records exist, then can process
     C                   If        *In30 = *On
     C                   Exsr      Prc@Sf
     C                   Endif
 
     C                   Endsl
 
      * End Record Locked
     C                   Endif
 
      * End *INKC
     C                   Enddo
 
     C                   Commit
 
     C                   Eval      *Inlr = *On
 
     C                   Return
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      * Clr@Sf - Clear Subfile                                        *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr@Sf        Begsr
      * Clear Subfile
     C                   Seton                                          3031
     C                   Write     FT327C1
     C                   Setoff                                         3031
      *
      * Reset Warning flag
     C                   Eval      Warning = 'N'
 
      *
      * Reset SFLRRN
     C                   Eval      Sflrrn = *Zero
     C                   Endsr
      *****************************************************************
      *                                                               *
      * Load@sf - Load subfile data                                   *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Load@sf       Begsr
 
     C                   If        PosCde <> *Blanks
     C     PosCde        Setll     FTRICHL2                           75  77
     C                   Select
     C                   When      *In75
     C                   ReadP     FTRICHL2                               77
     C     PTYID         Setll     FTRICHL2
     C                   Endsl
     C                   Else
     C     *Loval        Setll     FTRICHL2
     C                   Endif
 
      * Read Records into Subfile
     C                   Read      FTRICHL2                               32
     C                   Dow       *In32 = *Off
     C                   Eval      Sflrrn = Sflrrn + 1
 
     C                   Exsr      Get_Name
     C                   Eval      WBBCNA1 = BBCNA1
 
     C                   Write     FT327S1
     C                   Read      FTRICHL2                               32
     C                   Enddo
      *
      * Compare SFLRRN with 0 to see if there is anything to display
     C                   If        Sflrrn > 0
     C                   Eval      *in30 = *On
     C                   Else
     C                   Eval      Msgid = 'GEN0001'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Prc@Sff - Process Subfile                                     *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Prc@Sf        Begsr
 
      * Set switch not to reload subfile
     C                   Eval      ReLoad = 'N'
 
      *
      * Read subfile for any subfile select records
     C                   Eval      *In33 = *Off
     C                   Readc     FT327S1                                33
     C                   Dow       *In33 = *Off
 
     C     SflRrn        Chain     FT327S1                            44
     C                   Eval      *In43 = *Off
     C                   Update    FT327S1
 
     C                   Setoff                                         1012
     C                   Select
 
      * Change current record
     C                   When      SflSel = 'A'
     C                   Eval      #Act = 'A'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In51 = *Off
     C     KeyRich1      Chain     FTRICHL0                           97
     C                   IF        Not *In97
     C                   Exsr      MovFil2
     C                   Exsr      Get_Name
     C                   Eval      WBBCNA1 = BBCNA1
 
     C                   Exsr      DtlRcd
     C                   Endif
 
      * Delete current record
     C                   When      SflSel = 'D'
 
     C                   Eval      #Act = 'D'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In51 = *On
     C     KeyRich1      Chain     FTRICHL0                           97
     C                   IF        Not *In97
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
     C                   Endif
 
      * Enquire on current record
     C                   When      SflSel = 'E'
 
     C                   Eval      #Act = 'E'
     C                   Eval      *In49 = *On
     C                   Eval      *In50 = *On
     C                   Eval      *In51 = *On
     C                   Exsr      MovFil2
 
     C                   Exsr      DtlRcd
      *
      * If subfile select != A or D then Error Message
     C                   Other
     C     SflSel        Ifne      *BLANK
     C                   Eval      *in34 = *On
     C                   Eval      MsgDta = SflSel
     C                   Eval      Msgid = 'FTM1001'
     C                   Exsr      SndMsg
     C                   Eval      *in43 = *On
     C     SflRrn        Chain     FT327S1                            44
     C                   Update    FT327S1
     C                   Endif
      *
     C                   Endsl
      *
     C                   Readc     FT327S1                                33
     C                   Enddo
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * DtlRcd - Add / Amend / Delete a record                        *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     DtlRcd        Begsr
 
      * Setof display indicators
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In47 = *Off
     C                   Eval      *In48 = *Off
 
     C                   Eval      XPTYID  = WPTYID
     C                   Eval      XCURCCY = WCURCCY
     C                   Eval      XTRANTY = WTRANTY
 
     C                   Eval      *In12 = *Off
 
      * Loop until some valid action taken
     C                   Dow       *In03 = *Off And *In12 = *Off
     C                   If        SflSel <> 'D'
     C                   Eval      *In44 = *Off
     C                   Else
     C                   Eval      *In44 = *On
     C                   Endif
 
     C                   Write     MsgCtl
     C                   Exfmt     FT327X1
 
      * Has party Id Changed ?
     C                   IF        *In61 or ValidOK = 'N'
     C                   Eval      Warning = 'N'
     C                   Endif
 
      * Setof display indicators
     C                   Eval      *In44 = *Off
     C                   Eval      *In45 = *Off
     C                   Eval      *In46 = *Off
     C                   Eval      *In47 = *Off
     C                   Eval      *In48 = *Off
 
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   If        SflSel = 'A' and not *IN12
     C                   Eval      ValidOK = 'Y'
     C                   Eval      Warning = 'N'
     C                   Exsr      Validate
     C                   Else
     C                   Eval      ValidOK = 'N'
     C                   Endif
 
      * All validated OK.  Seton F10 Confirm.
 
     C                   If        SflSel <> 'E'
     C                   Eval      *In44 = *On
     C                   Endif
 
     C                   Select
 
     C                   When      SflSel = *Blank
     C
     C                   If        not *IN12
     C                   Eval      ValidOK = 'Y'
     C                   EXSR      Validate
     C                   EndIf
     C                   If        ValidOK = 'Y'
     C                   Exsr      MovFil
     C                   Write     FTRICHD0
     C                   Eval      *In12 = *On
     C                   Eval      Reload = 'Y'
     C                   Endif
 
     C                   When      SflSel = 'A' and ValidOK = 'Y'
     C     KeyRichOld    Chain     FTRICHL0                           97
     C                   If        Not *In97
     C                   Exsr      MovFil
     C                   Eval      *In12 = *On
     C                   Update    FTRICHD0
     C     *Loval        Setll     FTRICHL0
     C                   Unlock    FTRICHL0
     C                   Commit
     C                   Endif
 
     C     SflRrn        Chain     FT327S1                            97
     C                   Eval      SflSel = *Blanks
     C                   Exsr      MovFil
     C                   Update    FT327S1
 
 
     C                   When      SflSel = 'D'
     C                   If        *IN10
     C     Delete_Key    KList
     C                   KFld                    WPTYID
     C                   KFld                    WCURCCY
     C                   KFld                    WTRANTY
     C     Delete_Key    Delete    FTRICHL0                           97
     C                   Eval      SflSel = *Blanks
     C                   Eval      Reload = 'Y'
     C                   EndIf
 
     C                   Endsl
 
     C                   If        *In12 And SflRrn > 0
     C     SflRrn        Chain     FT327S1                            97
     C                   Eval      *In34 = *On
     C                   If        SflSel = 'A' or SflSel = 'E'
     C                             or SflSel = 'D'
     C                   Eval      SflSel = *Blank
     C                   Endif
     C                   Update    FT327S1
     C                   Endif
 
     C                   If        *In10
     C                   Leave
     C                   Endif
 
     C                   Enddo
 
      * Clear old messages
     C                   CALL      'ZA0250'
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Validate Data Items                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Validate      Begsr
 
 
      * Party Identifier must be a valid BIC, customer number or shortname.
     C                   Eval      IdIn = WPTYID
 
     C                   If        SflSel = ' '
 
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    IdIn
     C                   Parm                    @Type
     C     D@Fmt         Parm                    D@Fmt
 
      ** Save type of party ID
     C                   MoveL(P)  @Type         Name_Type         7
     C                   Eval      WBBCNA1  =  *Blanks
 
      ** Also check that the party ID is not a S.W.I.F.T. address of a
      ** customer.
 
     C                   If        @Type <> '*BIC   ' and @Type <> '*NUMBER'
     C                             and @Type <> '*SHNAME'
     C                   MoveL     WPTYID        SWFTKY           12
     C     SWFTKY        Chain     SDCUSTL7                           80
 
     C                   If        not *IN80
     C                   Eval      @Type = '*SWIFT '
     C                   EndIf
 
     C                   EndIf
 
     C                   If        @Type <> '*BIC   ' And @Type <> '*NUMBER' And
     C                             @Type <> '*SHNAME' and @Type <> '*SWIFT ' And
     C                             Warning = 'N'
 
 
      *                  (If 8 or 11 characters, assume BIC)
 
     C                   If        %Subst(IdIn:1:1) <> *Blanks   And
     C                             %Subst(IdIn:2:1)  <> *Blanks   And
     C                             %Subst(IdIn:3:1)  <> *Blanks   And
     C                             %Subst(IdIn:4:1)  <> *Blanks   And
     C                             %Subst(IdIn:5:1)  <> *Blanks   And
     C                             %Subst(IdIn:6:1)  <> *Blanks   And
     C                             %Subst(IdIn:7:1)  <> *Blanks   And
     C                             %Subst(IdIn:8:1)  <> *Blanks
 
     C                   If        %Subst(IdIn:9:10) =  *Blanks   OR
     C                             %Subst(IdIn:9:1)  <> *Blanks   And
     C                             %Subst(IdIn:10:1) <> *Blanks  And
     C                             %Subst(IdIn:11:1) <> *Blanks  And
     C                             %Subst(IdIn:12:7) =  *Blanks
 
      * Send Warning Message
     C                   Eval      Msgid = 'FTF3275'
     C                   Eval      MsgDta = WPTYID
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
     C                   Eval      *in52 = *On
     C                   Eval      *in44 = *Off
 
     C                   IF        Warning = 'N'
     C                   Write     MsgCtl
     C                   Exfmt     FT327X1
 
     C                   CALL      'ZA0250'
     C                   Eval      Warning = 'Y'
 
     C                   Eval      *in52 = *Off
 
     C                   If        *In12
     C                   Eval      ValidOK = 'N'
     C                   ELSE
     C                   Eval      ValidOK = 'Y'
     C                   Eval      @Type = 'X*BIC'
      * End F12
     C                   Endif
      * End Warning
     C                   Endif
      * End check positions 10, 11, 12
     C                   Endif
      * End check positions 1 - 8
     C                   Endif
      * End check @Type
     C                   Endif
 
     C                   If        @Type <> '*BIC   ' And @Type <> '*NUMBER' And
     C                             @Type <> '*SHNAME' and @Type <> '*SWIFT ' And
     C                             @Type <> 'X*BIC'
 
     C                   Eval      Msgid = 'FTF3128'
     C                   Eval      MsgDta = WPTYID
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Else
 
     C                   Select
 
     C                   When      @Type    = '*BIC   '
     C                   Eval      D@Bic    = D@Fmt
     C                   Eval      WBBCNA1  =  BDINS1
 
     C                   When      @Type    = '*NUMBER'
     C                   If        %Subst(WPTYID:7:5) <> *Blanks
     C                   Eval      Msgid = 'FTF3137'
     C                   Eval      MsgDta = WPTYID
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Else
     C                   Eval      SdCust   = D@Fmt
     C                   Eval      WBBCNA1  =  BBCNA1
     C                   Endif
 
     C                   When      @Type    = '*SHNAME'
     C                   If        %Subst(WPTYID:11:1) <> *Blanks
     C                   Eval      Msgid = 'FTF3138'
     C                   Eval      MsgDta = WPTYID
     C                   Eval      *in45 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Else
     C                   Eval      SdCust   = D@Fmt
     C                   Eval      WBBCNA1  =  BBCNA1
     C                   Endif
 
      ** Do extra processing required for S.W.I.F.T. ID, to set up
      ** work field.
     C                   When      @Type    = '*SWIFT '
     C                   Eval      WBBCNA1  =  BBCNA1
 
     C                   Endsl
 
     C                   Endif
 
      * Validate Currency Code
     C     '?'           Scan      WCURCCY:1                              99
     C                   If        *In99
     C                   Eval      ValidOK = 'N'
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Type
     C                   Parm      '?'           WCurCcy
     C     SdCurr        Parm      SdCurr        D@Fmt
     C                   Endif
 
      *  Optional field.  Can be blank.
     C                   If        WCURCCY <> *Blanks
 
     C                   CallB     'AOCURRR0'
     C                   Parm      *Blanks       @Rtcd
     C                   Parm      '*KEY   '     @Type
     C                   Parm                    WCurCcy
     C     SdCurr        Parm      SdCurr        D@Fmt
 
     C                   If        @Rtcd <> *Blanks
     C                   Eval      Msgid = 'FTF3109'
     C                   Eval      MsgDta = WCurCcy
     C                   Eval      *in46 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
 
     C                   Endif
 
      * Validate Transaction Type.  Optional.  Can be blank.
     C     '?'           Scan      WTranty:1                              99
     C                   If        *In99
     C                   Eval      ValidOK = 'N'
 
     C                   CallB     'FT000970'
     C                   Parm                    WTranTy
     C                   If        WTranTy = '?'
     C                   Eval      WTranTy = ' '
     C                   Endif
 
     C                   Endif
 
     C                   If        WTRANTY <> *Blanks
 
      *  Does it exist
     C     WTRANTY       Chain     FTTRNTL0                           98
     C                   If        *In98
     C                   Eval      Msgid = 'FTF3132'
     C                   Eval      MsgDta = WTRANTY
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Else
 
      *  If exists, flag Available for Rcv / Int Chgs must be 'Y'
     C                   If        RCVINT <> 'Y'
     C                   Eval      Msgid = 'FTF3136'
     C                   Eval      MsgDta = WTRANTY
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif
 
     C                   Endif
 
     C                   Endif
 
      * Validate Charge Code.  Mandatory.  Cannot be blanks.
     C     '?'           Scan      WChgCd:1                               99
     C                   If        *In99
     C                   Eval      ValidOK = 'N'
 
     C                   CallB     'FT000940'
     C                   Parm                    WChgCd
     C                   If        WChgCd = '?'
     C                   Eval      WChgCd = ' '
     C                   Endif
 
     C                   Endif
 
     C                   If        WChgCd = *Blanks
     C                   Eval      Msgid = 'FTF3133'
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
 
     C                   Else
      *  Does it exist
     C     WChgCd        Chain     FTPCHGL0                           98
     C                   If        *In98
     C                   Eval      Msgid = 'FTF3134'
     C                   Eval      MsgDta = WChgCd
     C                   Eval      *in48 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif
 
      *
      * Additional validation
      * 1. Ensure that the party identifier plus currency plus transaction type are unique within
      *     the file.  This includes blank currency and blank transaction type code
      *
      * 2. If the party identifier and currency code are entered with a blank transaction type
      *     code, ensure that the party identifier and currency are unique.
      *
      * 3. If the party identifier, currency code and transaction type are all entered, ensure
      *     this is unique within the receivers and intermediaries charges table.
      *
      ** Only do this check if inserting - amendment can only change charge
      ** code.
 
     C                   If        SflSel <> 'A'
     C     KeyRich       Setll     FtRichL2                               97
     C                   If        *In97
     C                   Eval      Msgid = 'FTF3135'
     C                   Eval      MsgDta = WChgCd
     C                   Eval      *in46 = *On
     C                   Eval      *in47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Exsr      SndMsg
     C                   Endif
     C                   Endif
 
      * Additional validation
      *
      * Ensure that if the transaction type has been entered, the currency
      * and party ID have also been entered.
 
     C                   If        WTRANTY <> *Blanks and
     C                             WCURCCY = *Blanks
     C                   Eval      *IN47 = *On
     C                   Eval      ValidOK = 'N'
     C                   Eval      Msgid = 'FTF3271'
     C                   Exsr      SndMsg
     C                   EndIf
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Clear Screen Date                                             *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Clr_Dta       Begsr
     C                   Eval      WPTYID  = *Blanks
     C                   Eval      WBBCNA1 = *Blanks
     C                   Eval      WCURCCY = *Blanks
     C                   Eval      WTRANTY = *Blanks
     C                   Eval      WCHGCD  = *Blanks
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Move file to screen                                           *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil2       Begsr
     C                   Eval      WPTYID  = PTYID
     C                   Eval      WCURCCY = CURCCY
     C                   Eval      WTRANTY = TRANTY
     C                   Eval      WCHGCD  = CHGCD
     C                   Eval      WBBCNA1 = BBCNA1
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Mov File Move data to File structure                          *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     MovFil        Begsr
      *
      ** If the customer shortname is entered, write the customer number
      ** to file, not the shortname.
      *
     C                   If        Name_type = '*SHNAME'
     C                   Eval      PTYID  = BBCUST
     C                   Else
     C                   Eval      PTYID  = WPTYID
     C                   EndIf
      *
     C                   Eval      CURCCY = WCURCCY
     C                   Eval      TRANTY = WTRANTY
     C                   Eval      CHGCD  = WCHGCD
     C                   Endsr
      *****************************************************************
      *                                                               *
      * RiSr - Record Locking                                         *
      *                                                               *
      * Called by: *Error                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     RiSr          Begsr
     C                   Eval      RiLocked = 'N'
     C                   If        RiStatus = Record_Locked
     C                   Eval      RiLocked = 'Y'
     C                   Eval      Msgid = 'FTF3151'
     C                   CALL      'ZA0250'
     C                   Exsr      SndMsg
     C                   Eval      ReturnPt = '*GETIN'
     C                   Eval      SflSel = *Blanks
     C                   Endif
     C                   Endsr     ReturnPt
      /EJECT
      *****************************************************************
      *                                                               *
      * SndMsg - Send Program Message                                 *
      *                                                               *
      * Called by: Prc@Sf                                             *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     SndMsg        Begsr
      *
      * Only write message if requested
     C                   If        Msgid <> *Blanks
     C                   CallB     'AOCREPT'
     C                   Parm                    Msgid
     C                   Parm                    Msgf
     C                   Parm                    MsgLib
     C                   Parm                    MsgDta
     C                   Parm                    MsgRel
     C                   Parm                    #Pgm
     C                   PARM      *Blanks       FTMSGQ           10
     C                   PARM      *Blanks       FTMSGT            7
     C                   Endif
      *
      * Reset message Id
     C                   Reset                   Msgds
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * Get_Name                                                      *
      *                                                               *
      * Called by: Load@Sf                                            *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     Get_Name      Begsr
 
     C                   Clear                   D@Fmt
     C                   Clear                   SdCust
 
     C                   Eval      IdIn = PTYID
     C                   CallB     'AOBICDV0'
     C                   Parm      *Blanks       RetCodeIn
     C                   Parm                    IdIn
     C                   Parm                    @Type
     C     D@Fmt         Parm                    D@Fmt
 
     C                   Select
     C                   When      @Type    = '*BIC   '
     C                   Eval      D@Bic    = D@Fmt
     C                   Eval      BBCNA1   =  BDINS1
     C                   When      @Type    = '*NUMBER' or @Type = '*SHNAME'
     C                   Eval      SdCust   = D@Fmt
     C                   Other
 
     C                   MoveL     WPTYID        SWFTKY           12
     C     SWFTKY        Chain     SdCustL7                           97
     C                   If        *In97
     C                   Eval      BBCNA1   =  No_Desc
     C                   Endif
 
     C                   Endsl
 
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C                   Eval      #WrkSt = PsJobName
     C                   Eval      #Pgm = PsProcPgm
      *
      ** Access Bank details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * Database error
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         ************
     C                   MOVEL     '001'         DBASE                          * DBERR 001*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   Eval      ReLoad = 'Y'
 
     C     KeyRich       Klist
     C                   Kfld                    WPTYID
     C                   Kfld                    WCURCCY
     C                   Kfld                    WTRANTY
 
     C     KeyRich1      Klist
     C                   Kfld                    PTYID
     C                   Kfld                    CURCCY
     C                   Kfld                    TRANTY
 
     C     KeyRichOld    Klist
     C                   Kfld                    XPTYID
     C                   Kfld                    XCURCCY
     C                   Kfld                    XTRANTY
 
 
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
 
     C/COPY ZACPYSRC,DBFIELDS
 
     C                   ENDSR                                                  *** InzEnd ***
 
      *****************************************************************
      /EJECT
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
