     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments SSI Maintenance')           *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPSISIN - Outgoing Payments SSI Screen Input               *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Funds Transfer Outgoing Payments              *
      *             Standard Settlement Instructions                  *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2002            *
      *                                                               *
      *  Last Amend No. MD022652           Date 07Oct13                    *
      *  Prev Amend No. CFT120             Date 28Sep12               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 BUG14716           Date 24Aug07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CGL029             Date 01Sep03               *
      *                 CFT018   *CREATE   Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  MD022652 - Excluded Phase Processing                         *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template (Recompile)                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      *
      *****************************************************************
      *  +--------------------------------------+
      *  ¦ Automatically included D-specs       ¦
      *  ¦ ==============================       ¦
      *  +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      *
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      *
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
 
     D/COPY QWINDSRC,FTOPSISDTA
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D  QQDRA1       E                     EXTFLD(QQDRAC)                                     CGL029
     D  QQORB1       E                     EXTFLD(QQORBK)                                     CGL029
     D  QQCDR1       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * External DS for Funds Transfer details
      *
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
      * External data structure for currency codes
      *
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)
      * External data structure for trading ICD data
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
      *
     D SDFONT        E DS                  EXTNAME(SDFONTPD)
      ** FONTIS ICD
      *
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      ** GENERAL LEDGER ICD
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
      *  User / Branch data area
     D ZMUSER          DS            17
     D  WDFBR                 11     13
     D  WDPPT                 14     16
      *
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)
      ** 24X7 Status DataArea Layout
     D  WPRDTE                 5      9  0
      *
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      ** SD Status Data Area Layout
      *
      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
     D ReadSfl         S              1A
     D BldSfl          S              1A
     D RcdSel          S              1A
     D @SCRN           S              1A
      *
      ** Access Object parameter fields
     D PRTCD           S              7A
     D POPTN           S              7A
     D PSARD           S              6A
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
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
      *
      * Issue rollback to clear any possible updates in window functions
     C     @INKL         Ifeq      '1'
     C                   Rolbk
     C                   End
      *
      ** Build sub-file browse
     C     @SCRN         DowEq     'B'
     C                   Exsr      Scrn@B
     C                   EndDo
      *
      *
      ** Read next browse subfile record
     C     @SCRN         DowEq     'R'
     C                   Exsr      Scrn@R
     C                   EndDo
      *
      ** Key screen processing for insert
     C     @SCRN         DowEq     'K'
     C                   Exsr      Scrn@K
     C                   EndDo
      *
      ** Primary screen processing
     C     @SCRN         DowEq     'P'
     C                   Exsr      Scrn@P
     C                   EndDo
      *
      ** Secondary screen processing
     C     @SCRN         DowEq     'S'
     C                   Exsr      Scrn@S
     C                   EndDo
      *
      ** Third detail screen processing
     C     @SCRN         DowEq     'T'
     C                   Exsr      SCRN@T
     C                   EndDo
      *
      * Window Screen Processing
     C     @SCRN         DowEq     'W'
     C                   Exsr      WINDOW
     C                   Enddo
      *
      ** Update Processing
     C     @SCRN         Ifeq      'U'
     C                   Exsr      UPDATS
     C                   EndIf
      *
      /EJECT
      *****************************************************************
      * SCRN@B:- Browse/Build Sub-File Screen
      *
      * Called Module:  FTOPSIBRW
      * Parameters :    Return code (7A)
      *                 Build/Read Browse sub-file (1A)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *                 Record Selected Indicator (1A)
      *                 Transaction file layout (layout of FTOSSIPD)
      *
      *****************************************************************
     C     SCRN@B        Begsr
      *
      ** Set subfile display indicator to rebuild if SSI has been updated
     C     LastActn      Ifeq      'U'
     C                   Move      'B'           BldDspRead
     C                   Else
     C                   Move      'D'           BldDspRead
     C                   Endif
      *
      **  Reset last action update indicator
     C                   Move      ' '           LastActn
      *
      ** Browse/Buile Sub-File Screen
     C                   Callb     'FTOPSIBRW'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Build/Display/Read Sub-File Indicator
     C                   Parm                    BldDspRead        1
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Record Selected Indicator
     C                   Parm      ' '           RcdSel            1
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F9 - Insert request entered
     C     @INKI         Wheneq    '1'
     C                   Movel     'K'           @SCRN
      *
      ** F5 - Refresh screen
     C     @INKE         Wheneq    '1'
     C                   Movel     'B'           @SCRN
      *
      * F12 - Redisplay browse sub-file screen
     C     @INKL         Wheneq    '1'
     C                   Movel     'B'           @SCRN
      *
      * Redisplay browse sub-file screen if rollup requested
     C     @Rollup       Wheneq    'Y'
     C                   Movel     'B'           @SCRN
      *
      * Otherwise set flag to read changed sub-file records
     C                   Other
     C                   Movel     'R'           @SCRN
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SCRN@R:- Read Sub-File Screen
      *
      * Called Module:  FTOPSIBRW
      * Parameters :    Return code (7A)
      *                 Build/Read Browse sub-file (1A)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *                 Record Selected Indicator (1A)
      *                 Transaction file layout (layout of FTOSSIPD)
      *
      *****************************************************************
     C     SCRN@R        Begsr
      *
      ** Reset all work fields prior to processing next SSI details
     C                   Exsr      INITIAL
      *
      ** Browse/Buile Sub-File Screen
     C                   Callb     'FTOPSIBRW'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Build/Display/Read Sub-File Indicator
     C                   Parm      'R'           BldDspRead        1
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Record Selected Indicator
     C                   Parm      ' '           RcdSel
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F12 - Redisplay browse sub-file screen
     C     @INKL         Wheneq    '1'
     C                   Movel     'B'           @SCRN
      *
      * If record selected convert file details to screeen format
      * and set indicator to display primary detail screen
     C     RcdSel        Wheneq    'Y'
     C                   Exsr      CVTSSI
     C                   Exsr      SetValFlds
     C                   Movel     'P'           @SCRN
      *
      * Otherwise redisplay browse sub-file screen
     C                   Other
     C                   Movel     'B'           @SCRN
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SCRN@K - Process Key Insert Screen
      *
      * Called Module:  FTOPSIKDP
      * Parameters :    Return Code (7A)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *
      *****************************************************************
     C     SCRN@K        Begsr
      *
      ** Save details of warning messages
     C                   Z-add     WIdx_PVAL     PrvN_Warn         3 0
      *
      ** Write/Read Primary Detail Screen
     C                   Callb     'FTOPSIKDP'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F12 - Return to previous screen
     C     @INKL         Wheneq    '1'
     C                   Movel     'R'           @SCRN
      *
      * Otherwise validate input to Key screen
     C                   Other
     C                   Exsr      VAL@K
      *
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * VAL@K  - Validate Input to Key Insert Screen
      *****************************************************************
     C     VAL@K         Begsr
      *
      **  Call retrieval module
     C                   Callb     'FTOPSIRTV'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Action Code
     C                   Parm                    SACTION
      *    Transaction key fields
     C                   Parm                    SDRCY                          Debit Ccy
     C                   Parm                    SDRAC                          Debit Account
     C                   Parm                    SREF1                          Reference I
     C                   Parm                    SREF2                          Reference II
     C                   Parm                    SCRCY                          Pay Ccy
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *
      * If errors returned
     C     Idx           Ifne      0
     C                   Goto      EndVAL@K
     C                   End
      *
      * If there are warnings which have not been displayed previously
      * re-output the screen
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     Ifne      PrvN_Warn
     C                   Goto      EndVAL@K
     C                   End
      *
      **  Set key fields on valid file layout and default ordering cutomer
     C                   Exsr      SetValFlds
     C                   Movel     SDRAC         SORC1
      *
      * Set screen indictaor to display primary details screen
     C                   Movel     'P'           @SCRN
      *
      * Clear any warning messages
     C                   Z-add     0             PrvN_Warn
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *BLANK        WFldNamArr
     C                   Movel     *BLANK        WMsgIdArr
     C                   Movel     *BLANK        WMsgDtaArr
      *
     C     EndVAL@K      Endsr
      /EJECT
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * Called Module:  FTOPSI1DP
      * Parameters :    Return Code (7A)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *
      *****************************************************************
     C     SCRN@P        Begsr
      *
      ** Save details of warning messages
     C                   Z-add     WIdx_PVAL     PrvN_Warn         3 0
      *
      ** Write/Read Primary Detail Screen
     C                   Callb     'FTOPSI1DP'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F10 - Delete Requested
     C     SACTION       Wheneq    'D'
     C     @INKJ         andeq     '1'
     C                   Movel     'U'           @SCRN
      *
      * F12 - Return to previous screen
     C     @INKL         Wheneq    '1'
     C     SACTION       Ifeq      'I'
     C                   Movel     'K'           @SCRN
     C                   Else
     C                   Movel     'R'           @SCRN
     C                   Endif
      *
      * Action code is delete but F10 not entered then redisplay screen
     C     SACTION       Wheneq    'D'
     C                   Movel     'P'           @SCRN
      *
      * Action code is enquire or authorise then go to next screen
     C     SACTION       Wheneq    'E'
     C     SACTION       oreq      'X'
     C     BGWDPR        Ifeq      'Y'
     C                   Movel     'W'           @SCRN
     C                   Else
     C                   Movel     'S'           @SCRN
     C                   Endif
      *
      * Otherwise validate input to Primary screen
     C                   Other
     C                   Exsr      VAL@P
      *
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     VAL@P         Begsr
      *
      **  Save previous number of warnings
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format,
     C                   Z-Add     *ZERO         WIdx              3 0
     C                   Z-Add     *ZERO         Idx               3 0
     C                   Z-Add     *ZERO         WIdx_PVAL         3 0
     C                   Move      *ALL'Y'       FTEOPSI
      *
      ** Reset all error indicators
     C                   Move      *All'Y'       FTEOPSI
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      ** Validate Primary Screen details
     C                   Callb     'FTOPSI1VL'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *
      * If errors returned
     C     Idx           Ifne      0
     C                   Goto      EndVAL@P
     C                   End
      *
      * If there are warnings which have not been displayed previously
      * re-output the screen
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     Ifne      PrvN_Warn
     C                   Goto      EndVAL@P
     C                   End
      *
      * Goto next screen Window or secondary screen if no errors
     C     BGWDPR        Ifeq      'Y'
     C                   Movel     'W'           @SCRN
     C                   Else
     C                   Movel     'S'           @SCRN
     C                   Endif
      *
      * Clear any warning messages
     C                   Z-add     0             Widx_PVAL
     C                   Z-add     0             PrvN_Warn
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *BLANK        WFldNamArr
     C                   Movel     *BLANK        WMsgIdArr
     C                   Movel     *BLANK        WMsgDtaArr
      *
     C     EndVAL@P      Endsr
      /EJECT
      *****************************************************************
      * WINDOW - Call WINDOW MANAGER
      *****************************************************************
     C     WINDOW        Begsr
      *
      * Reset erros
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *BLANK        FldNameArr
     C                   Movel     *BLANK        MsgIdArr
     C                   Movel     *BLANK        MsgDtaArr
     C                   Movel     *BLANK        WFldNamArr
     C                   Movel     *BLANK        WMsgIdArr
     C                   Movel     *BLANK        WMsgDtaArr
      *
     C                   Call      'WN0010'
     C                   Parm      'FTOPSISIN'   #PGM             10
     C                   Parm                    FKEY              2
     C                   Parm                    ACTION            1
     C                   Parm                    DATA
     C                   Parm      *BLANKS       #RTRN             7
     C                   Parm                    SPAREW          256
      *
      * Process returned command keys
     C     #RTRN         Ifeq      'Y2U9999'
     C                   Exsr      Sr_Exit
     C                   Endif
      *
      *  If Cmd12 pressed, return to main details screen;
     C     #RTRN         Ifeq      'USR0790'
     C                   Eval      @SCRN = 'P'
     C                   Else
     C                   Eval      @SCRN = 'S'
     C                   Endif
      *
     C     WIND          Endsr
      /EJECT
      *****************************************************************
      * SCRN@S - Process Secondary Detail Screen
      *
      * Called Module:  FTOPSI3DP
      * Parameters :    Return Code (7A)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *
      *****************************************************************
     C     SCRN@S        Begsr
      *
      ** Save details of warning messages
     C                   Z-add     WIdx_PVAL     PrvN_Warn         3 0
      *
      ** Write/Read Secondary Detail Screen
     C                   Callb     'FTOPSI2DP'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F12 - Return to previous screen
     C     @INKL         Wheneq    '1'
     C                   Movel     'P'           @SCRN
      *
      * Action code is delete, enquire or authorise then go to next screen
     C     SACTION       Wheneq    'E'
     C     SACTION       oreq      'D'
     C     SACTION       oreq      'X'
     C                   Movel     'T'           @SCRN
      *
      * Otherwise validate input to secondary screen
     C                   Other
     C                   Exsr      VAL@S
      *
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY DETAIL SCREEN
      *****************************************************************
     C     VAL@S         Begsr
      *
      **  Save previous number of warnings
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format,
     C                   Z-Add     *ZERO         WIdx              3 0
     C                   Z-Add     *ZERO         Idx               3 0
     C                   Z-Add     *ZERO         WIdx_PVAL         3 0
     C                   Move      *ALL'Y'       FTEOPSI
      *
      ** Reset all error indicators
     C                   Move      *All'Y'       FTEOPSI
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      ** Validate Seondary Screen
     C                   Callb     'FTOPSI2VL'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *
      * If errors returned
     C     Idx           Ifne      0
     C                   Goto      EndVAL@S
     C                   End
      *
      * If there are warnings which have not been displayed previously
      * re-output the screen
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     Ifne      PrvN_Warn
     C                   Goto      EndVAL@S
     C                   End
      *
      * Goto next screen if no errors
     C                   Movel     'T'           @SCRN
      *
      * Clear any warning messages
     C                   Z-add     0             Widx_PVAL
     C                   Z-add     0             PrvN_Warn
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *BLANK        WFldNamArr
     C                   Movel     *BLANK        WMsgIdArr
     C                   Movel     *BLANK        WMsgDtaArr
      *
     C     EndVAL@S      Endsr
      /EJECT
      *****************************************************************
      * SCRN@T - Process Third Detail Screen
      *
      * Called Module:  FTOPSI4DP
      * Parameters :    Return Code (7A)
      *                 Transaction screen field (layout of PF/FTOPSIPD)
      *                 Common work fields (layout of FTV@OPSIPD)
      *                 Error Indicators (layout of FTEOPSIPD)
      *
      *****************************************************************
     C     SCRN@T        Begsr
      *
      ** Save details of warning messages
     C                   Z-add     WIdx_PVAL     PrvN_Warn
      *
      ** Write/Read Third Detail Screen
     C                   Callb     'FTOPSI3DP'
      *    Return code
     C                   Parm      *BLANK        RetCodeOut
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *
      *
      ** Process reponse from screen program
     C                   Select
      *
      ** F3 - End Program
     C     @INKC         Wheneq    '1'
     C                   Exsr      Sr_Exit
      *
      * F12 - Return to previous screen
     C     @INKL         Wheneq    '1'
     C                   Movel     'S'           @SCRN
      *
      * Action code is enquire then return to read browse subifle
     C     SACTION       Wheneq    'E'
     C                   Movel     'R'           @SCRN
      *
      * Action code is delete or authorise then perform file updates
     C     SACTION       Wheneq    'D'
     C     SACTION       oreq      'X'
     C                   Movel     'U'           @SCRN
      *
      * Otherwise validate input to third screen
     C                   Other
     C                   Exsr      VAL@T
      *
     C                   EndSl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * VAL@T  - VALIDATE INPUT TO THIRD DETAIL SCREEN
      *****************************************************************
     C     VAL@T         Begsr
      *
      **  Save previous number of warnings
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format,
     C                   Z-Add     *ZERO         WIdx              3 0
     C                   Z-Add     *ZERO         Idx               3 0
     C                   Z-Add     *ZERO         WIdx_PVAL         3 0
     C                   Move      *ALL'Y'       FTEOPSI
      *
      ** Reset all error indicators
     C                   Move      *All'Y'       FTEOPSI
     C                   Movel     *Blank        FldNameArr
     C                   Movel     *Blank        MsgIdArr
     C                   Movel     *Blank        MsgDtaArr
     C                   Movel     *Blank        WFldNamArr
     C                   Movel     *Blank        WMsgIdArr
     C                   Movel     *Blank        WMsgDtaArr
      *
      ** Validate Third Detail Screen
     C                   Callb     'FTOPSI3VL'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNameArr
     C                   Parm                    MsgIDArr
     C                   Parm                    MsgDtaArr
     C                   Parm                    Idx
      *    Warning fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    WFldNamArr
     C                   Parm                    WMsgIDArr
     C                   Parm                    WMsgDtaArr
     C                   Parm                    WIdx
      *    Error flag indicators
     C                   Parm                    FTEOPSI
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *
      * If errors returned
     C     Idx           Ifne      0
     C                   Goto      EndVAL@T
     C                   End
      *
      * If there are warnings which have not been displayed previously
      * re-output the screen
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     Ifne      PrvN_Warn
     C                   Goto      EndVAL@T
     C                   End
      *
      * Goto update if no errors
     C                   Movel     'U'           @SCRN
      *
      * Clear any warning messages
     C                   Z-add     0             Widx_PVAL
     C                   Z-add     0             PrvN_Warn
     C                   Move      *ALL'Y'       FTEOPSI
     C                   Movel     *BLANK        WFldNamArr
     C                   Movel     *BLANK        WMsgIdArr
     C                   Movel     *BLANK        WMsgDtaArr
      *
     C     EndVAL@T      Endsr
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        Begsr
      *
      *
      ** Program entry parameter list
     C                   Callb     'FTOPSIUPD'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Valid file layout
     C                   Parm                    SSIValidFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *
      **  Reset screen indicator to read next sub-file changed record
     C                   Movel     'R'           @SCRN
      *
      **  Set last action update indicator
     C                   Move      'U'           LastActn          1
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * CVTSSI - Convert SSI File Details to screen format
      *****************************************************************
     C     CVTSSI        Begsr
      *
      **  Call convert module
     C                   Callb     'FTOPSICVT'
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Transaction file layout
     C                   Parm                    SSIFileFmt
      *    Common Work Fields
     C                   Parm                    WorkFields
      *    Transaction screen fields
     C                   Parm                    SSIScrnFmt
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * SetValFlds - Set Fields on Valid File Layout
      *****************************************************************
     C     SetValFlds    Begsr
      *
      **  Set key fields on valid file layout for insert
     C     SACTION       Ifeq      'I'
     C                   Move      SDRCY         OVDRCY
     C                   Move      SDRAC         OVDRAC
     C                   Move      SREF1         OVREF1
     C                   Move      SREF2         OVREF2
     C                   Move      SCRCY         OVCRCY
     C                   Move      SDESC         OVDESC
     C     SDESC         Ifeq      *blanks
     C                   Movel     SREF1         OVDESC
     C                   Endif
     C                   Z-add     @BJRDNB       OVORED
     C                   Endif
      *
      **  Initialise valid file layout for amend, delete and authorise
     C     SACTION       Ifeq      'A'
     C     SACTION       oreq      'X'
     C     SACTION       oreq      'D'
     C                   Move      SSIFileFmt    SSIValidFmt
     C                   Endif
      *
      **  Set status field according to action
     C                   Select
     C     SACTION       Wheneq    'I'
     C                   Move      'C'           OVSTAT
     C     SACTION       Wheneq    'A'
     C     OSXUSR        andne     *Blanks
     C                   Move      'R'           OVSTAT
     C     SACTION       Wheneq    'A'
     C     OSXUSR        andeq     *Blanks
     C                   Move      'C'           OVSTAT
     C     SACTION       Wheneq    'X'
     C                   Move      'A'           OVSTAT
     C     SACTION       Wheneq    'D'
     C                   Move      'D'           OVSTAT
     C                   Endsl
      *
      **  Set up last change type and date
     C                   Move      SACTION       OVCHTP
     C                   Z-add     @BJRDNB       OVLCD
      *
      **  Set up user id'd
     C                   Select
     C     SACTION       Wheneq    'I'
     C                   Move      @USRID        OVIUSR
     C                   Move      *Blanks       OVAUSR
     C                   Move      *Blanks       OVXUSR
     C     SACTION       Wheneq    'A'
     C     SACTION       oreq      'D'
     C                   Move      OSIUSR        OVIUSR
     C                   Move      @USRID        OVAUSR
     C                   Move      OSXUSR        OVXUSR
     C     SACTION       Wheneq    'X'
     C                   Move      OSIUSR        OVIUSR
     C                   Move      OSAUSR        OVAUSR
     C                   Move      @USRID        OVXUSR
     C                   Endsl
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * Exit - Exit Program
      *****************************************************************
     C     Sr_Exit       Begsr
      *
      ** Rollback any uncommitted changes
     C                   RolBk
      *
      ** Set on *INLR and return to calling program
     C                   Movel     *ON           *INLR
     C                   Return
      *
     C                   Endsr
      *****************************************************************
      /EJECT
      *****************************************************************
      * Initial Initial Screen Processing
      *****************************************************************
     C     INITIAL       Begsr
      *
      ** Clear screen layout, valid file layout, file layout
     C                   Clear                   SSIScrnFmt
     C                   Clear                   SSIValidFmt
     C                   Clear                   SSIFileFmt
      *
      ** Reset error indicator fields
     C                   Move      *ALL'Y'       FTEOPSI
      *
      ** Reset all error message indicators and arrays
     C                   Movea     *Blanks       MsgIDArr
     C                   Movea     *Blanks       MsgDtaArr
     C                   Movea     *Blanks       WFldNamArr
     C                   Movea     *Blanks       WMsgIDArr
     C                   Movea     *Blanks       WMsgDtaArr
     C                   Z-Add     *ZERO         WIdx              3 0
     C                   Z-Add     *ZERO         Idx               3 0
     C                   Z-Add     *ZERO         WIdx_PVAL         3 0
      *
      ** Reset all work function key indicator settings
     C                   Move      '0'           @INKC
     C                   Move      '0'           @INKI
     C                   Move      '0'           @INKJ
     C                   Move      '0'           @INKL
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        Begsr
      *
      **  Program entry parameter list
     C     *ENTRY        PLIST
     C                   Parm                    @ReturnCde        1
      *
      ** Initialize program name
     C                   Movel     'FTOPSISIN'   DBPGM
      *
      ** GET ZMUSER to access default branch.
     C     *DTAARA       Define                  ZMUSER
     C                   In        ZMUSER
     C                   Unlock    ZMUSER
     C                   Eval      @DFBR = WDFBR
     C                   Eval      @DPPT = WDPPT
      *
      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT
      *
      ** Get Bank Details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDBANKPD'    DBFILE
     C                   Movel     '901'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Get General Ledger ICD Details
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDGELRPD'    DBFILE
     C                   Z-Add     76            DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Get Funds Transfer ICD details
     C                   Call      'AOFTFRR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDFTFR        Parm      SDFTFR        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDFTFRPD'    DBFILE
     C                   Z-Add     76            DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Get Module Details
     C                   Call      'AOMMODR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C     SDMMOD        Parm      SDMMOD        DSFDY
      *
      ** Database error if record not found
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDMMODPD'    DBFILE
     C                   Movel     '904'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      ** Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   Callb     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY
     C                   Eval      @BCDP = A6NBDP
      *
      ** Read SDTRADPD for US dollar currency code
     C                   Callb     'AOTRADR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDTRAD        Parm      SDTRAD        DSFDY
     C     @RTCD         Ifne      *BLANKS
     C                   Movel     'SDTRADPD'    DBFILE
     C                   Movel     '902'         DBASE
     C                   Movel     @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   End
      *
      * Access SAR details file to determine if CEU006 is on.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End
      *
      * Access SAR details file to determine if S01494 is on.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01494
     C                   Else
     C                   Movel     'N'           @01494
     C                   End
      *
      ** Access SAR details file to determine if S01499 is on.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01499
     C                   Else
     C                   Movel     'N'           @01499
     C                   End
      *
      ** Access SAR details file to see if S01506 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01506'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End
      *
      ** Access SAR details file to see if S01508 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01508
     C                   Else
     C                   Movel     'N'           @01508
     C                   End
      *
      ** Access SAR details file to see if CFT002 is installed.
     C                   Call      'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT002'      @SARD
     C     SCSARD        Parm      *BLANKS       DSFDY
     C     @RTCD         Ifeq      *BLANKS
     C                   Movel     'Y'           @CFT002           1
     C                   Else
     C                   Movel     'N'           @CFT002
     C                   EndIf
      *
      ** Access SAR details file to see if CFT003 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End
      *
      ** Access SAR details file to see if CFT004 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT004'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT004
     C                   Else
     C                   Movel     'N'           @CFT004
     C                   End
      *
      ** Access SAR details file to see if CFT007 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT007'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT007           1
     C                   Else
     C                   Movel     'N'           @CFT007
     C                   End
      *
      ** Access SAR details file to see if CFT009 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT009'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT009           1
     C                   Else
     C                   Movel     'N'           @CFT009
     C                   End
      *
      ** Access SAR details file to see if CFT010 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT010'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT010           1
     C                   Else
     C                   Movel     'N'           @CFT010
     C                   End
      *
      ** Access SAR details file to see if CFT012 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT012'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT012           1
     C                   Else
     C                   Movel     'N'           @CFT012
     C                   End
      *
      ** Access SAR details file to see if CFT014 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT014'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT014
     C                   Else
     C                   Movel     'N'           @CFT014
     C                   EndIf
      *
      ** Access SAR details file to see if 24X7 (CSC011) is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       PRTCD
     C                   Parm      '*VERIFY'     POPTN
     C                   Parm      'CSC011'      PSARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   IF        PRTCD = *BLANKS
     C                   Eval      @CSC011 = 'Y'
     C                   In        SDSTAT
     C                   Unlock    SDSTAT
     C                   Else
     C                   Eval      @CSC011 = 'N'
     C                   EndIf
      *
      ** Access SAR details file to see if CGL009 is allowed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*VERIFY'     @OPTN             7
     C                   Parm      'CGL009'      @SARD             6
     C     SCSARD        Parm      *BLANKS       DSFDY
     C     @RTCD         Ifeq      *BLANKS
     C                   Move      'Y'           @CGL009           1
     C                   Else
     C                   Move      'N'           @CGL009
     C                   End
      *
      ** Access SAR details file to see if CSW201 is installed.
     C                   Callb     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CSW201'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CSW201
     C                   Else
     C                   Movel     'N'           @CSW201
     C                   End
      *
      ** If CGL009 is on get Fontis TPP process information
     C     @CGL009       Ifeq      'Y'
     C                   Move      *On           *IN48
     C                   Call      'AOFONTR0'
     C                   Parm                    P@RTCD            7
     C                   Parm      '*FIRST'      @OPTN             7
     C     SDFONT        Parm      SDFONT        DSFDY
     C     P@RTCD        Ifne      *BLANKS
     C                   Movel     'AOFONTR0'    DBFILE
     C                   Movel     *BLANK        DBKEY
     C                   Movel     '*Call'       DBKEY
     C                   Z-Add     75            DBASE
     C                   Exsr      *PSSR
     C                   Endif
     C                   Endif
      *                                                                                     MD022652
      ** Access SAR details file to see if CFT050 is installed.                             MD022652
      *                                                                                     MD022652
     C                   CALLB     'AOSARDR0'                                               MD022652
     C                   PARM      *BLANKS       PRTCD             7                        MD022652
     C                   PARM      '*VERIFY'     POPTN             7                        MD022652
     C                   PARM      'CFT050'      PSARD             6                        MD022652
     C     SCSARD        PARM      SCSARD        DSFDY                                      MD022652
      ** CFT007 process will take place when CFT050 is switched on                          MD022652
     C                   IF        @RTCD = *Blanks                                          MD022652
     C                   EVAL      @CFT007 = 'Y'                                            MD022652
     C                   ENDIF                                                              MD022652
      *
      *
      **  Initialise work fields to pass to other modules via common work
      **  fields data structure ( based on layout of PF/FTV@OPSIPD)
     C                   Eval      @MBIN = WMBIN
     C                   Eval      @RespMode = RespMode
     C                   Eval      @MRDT = BJMRDT
     C                   Eval      @BJRDNB = BJRDNB
     C                   Eval      @BJSBRC = BJSBRC
     C                   Eval      @BKOBRU = BKOBRU
     C                   Eval      @BKPRCU = BKPRCU
      *
      ** Set processing date
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)
     C                   Eval      ZDAYNO = WPRDTE
     C                   Else
     C                   Eval      ZDAYNO = BJRDNB
     C                   EndIf
      *
      ** Determine run date in DDMMYY format
     C                   Callb     'ZDATE2'
     C                   Parm                    ZDAYNO            5 0
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE             6 0
     C                   Parm      *Blanks       ZADATE            7
     C                   Eval      @RUNN = ZDATE
      *
      ** Determine Back Value Date
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)
     C                   Eval      @BVLD = WPRDTE - BJBVPD
     C                   Else
     C                   Eval      @BVLD = BJRDNB - BJBVPD
     C                   EndIf
      *
      ** Set up User id from program status data structure
     C                   Eval      @USRID = PSUSER
      *
      ** Initialise all work fields
     C                   Exsr      INITIAL
      *
      ** Set flag to display subfile browse screen
     C                   Movel     'B'           @SCRN
      *
     C                   Endsr
      /EJECT
      ********************************************************************
      ** *PSSR - Program Eror Handling Routine
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Misys International Banking Systems Ltd. 2002
