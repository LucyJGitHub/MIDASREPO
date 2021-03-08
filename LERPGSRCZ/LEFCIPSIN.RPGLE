     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas LE Facility input')                              *
      *****************************************************************
      *                                                               *
      *  Midas - Customer Lending ILE Module                          *
      *                                                               *
      *  LEFCIPSIN - LE Facility  Input                               *
      *                                                               *
      *  Function:  This is the screens input function for Facility   *
      *             Input.                                            *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. MD039655           Date 03Sep19               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 CLE134             Date 01Aug12               *
      *                 CSC054             Date 23Feb12               *
      *                 AR937578A          Date 04Apr12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CLE147             Date 17Oct11               *
      *                 AR787620           Date 10Jun11               *
      *                 CLE064             Date 06Dec10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23786           Date 21Apr09               *
      *                 CER020             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 239211             Date 31Aug06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE042             Date 06Sep05               *
      *                 CLE106             Date 01Aug04               *
      *                 CLE034             Date 05May03               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG3723 (CLE028)   Date 19Jul04               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 CLE029             Date 04Sep02               *
      *                 CAP073  *CREATE    Date 180302                *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD039655 - Facility cannot be rejected.                      *
      *             Pattern fix from MD-29208 and MD-34908.           *
      *           - Applied for MD052591.                             *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus                            *
      *           Core hooks added:LEFCIPSD01,LEFCIPDTA,LEFCIPSC01    *
      *                            LEFCIPSC02,LEFCIPSMV1              *
      *  CLE134 - Past Due Call Loan Processing (Recompile)           *
      *  CSC054 - Period End Adjustments                              *
      *  AR937578A - In Collateral and Credit Lines Enquiry, availed  *
      *              loans are both in reservation and exposure       *
      *              columns                                          *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CLE147 - Aggregate Facility                                  *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,LEH00358                                 *
      *             WNCPYSRC,LEH00320                                 *
      *  CLE064 - Enhancement of Lending Frequencies (Recompile)      *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23786 - Incorrect values in Previous and Penultimate Date *
      *             fields when Facility amended in WIP (Recompile)   *
      *  CER020 - Enhanced Rollover Window: Upgrade FGE089 to         *
      *           Midas Plus (Recompile)                              *
      *  239211 - Recompile over changes in LEFCSPPD.                 *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE042 - Extended Loan Sub Type (Recompile)                  *
      *  CLE106 - Syndications Manager                                *
      *  CLE034 - Lending Enhancements Phase 1 Priority 1A            *
      *           (Recompiled)                                        *
      *  CSC024 - Open Month End                                      *
      *  BUG3723 - Recompile due to changes to LEFCSPPD.              *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CLE029 - Addition of Severity code and Limit ID to FCLTYFM   *
      *  CAP073 - Conversion of MN inputs into modular structure to   *
      *           use as APIs. Facility input Transaction Details     *
      *                                                               *
      *****************************************************************
      ***  FILES  ***
      *
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
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** Include the MM standard declares
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
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
     D*PSysVal1*       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D PSysVal1        C                   CONST('PEAIndicator')                              CSC054
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     DValidFCIPEx    E DS                  EXTNAME(LEVFCIPX0)                                LLN022A
                                                                                             LLN022A
     D WArrCmtJob      S             10A   DIM(10)                                            CSC022
      ** Array for Commitment Job Names                                                       CSC022
                                                                                              CSC022
      ** Data structure for SCCMTJOB data area                                                CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  COMITNO                1      3S 0                                                    CSC022
     D  COMITJOBS              4    103                                                       CSC022
                                                                                              CSC022
     D FacmFilFmt    E DS                  EXTNAME(FCLTYFM)
      ***  Current Fclty in File Format FM
     D                                     PREFIX(FM)
      *
     D FacnFilFmt    E DS                  EXTNAME(FCLTYFN)
      ***  Current Fclty in File Format FN
     D                                     PREFIX(FN)
 
      * (Current) Facility in Screen Format - Primary Details
     D CurPriScn     E DS                  EXTNAME(LEFCPPPD)
     D                                     PREFIX(@)
      * (Current) Facility in Screen Format - Secondary Details
     D CurSecScn     E DS                  EXTNAME(LEFCSPPD)
     D                                     PREFIX(@)
 
      * Valid Facility FM layout
     D ValidFacm     E DS                  EXTNAME(LEVFCIMPD)
     D                                     PREFIX(V_)
      * Valid Facility FN layout
     D ValidFacn     E DS                  EXTNAME(LEVFCINPD)
     D                                     PREFIX(V_)
 
      *
     D FcipNwPrim    E DS                  EXTNAME(LEFCPPPD)
      ***  New Fclty in Screen Format - Screen 1
      *
     D FcipNwSeco    E DS                  EXTNAME(LEFCSPPD)
      ***  New Fclty in Screen Format - Screen 2
      *
     D OKFcPrim      E DS                  EXTNAME(LEEFCIPPD)
      ***  Error indicators Screen 1
      *
     D OKFcSeco      E DS                  EXTNAME(LEEFCISPD)
      ***  Error indicators Screen 2
      *
     D @CCI@           DS
      ***  Current control indicators for details screens 1, 2
      *
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2
     D  @EINKG                 3      3
     D  @EINKH                 4      4
     D  @EINKJ                 5      5
     D  @EINKP                 6      6
     D  @EINKV                 7      7
     D  @EINKW                 8      8
     D  @EINKX                 9      9
      *
     D @PCI@           DS             9
      ***  Previous control indicators for details screens 1, 2
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
      ** EXTERNAL DS FOR SAR DETAILS
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ***  External DS for bank details
      *
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ***  Midas modules details accessed via access program
 
     D SDGELR        E DS                  EXTNAME(SDGELRPD)
      ** EXTERNAL DS FOR GENERAL LEDGER DETAILS
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ***  First DS for access programs, short data structure
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)                                     CGL029
      ***  Second DS for access programs, long data structure                                 CGL029
      *                                                                                       CGL029
     D ExtData       E DS                  EXTNAME(LEFCEXPD)
      ***  LE (FCIP) Extra Data - File (D/B) format
      *
     D  TransData      DS           500
      ***  Shared data
 
      ** IN Message Format
     D P#INMF        E DS                  EXTNAME(LER1MFPD)
 
      ** OUT Message Format
     D P#OUMF        E DS                  EXTNAME(LER2MFPD)
 
      /COPY QWINDSRC,LEFCIPDTA                                                                LLN022
     D                 DS
     D  @SIFACR                1     11
     D  @SICSSN                1      6
     D  @SIFACT                7      9
     D  @SIFCNO               10     11
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PSARD           S              6A                                                      CSC022
     D CSC022          S              1A   Inz                                                CSC022
     D WSkipCommit     S              1A   Inz                                                CSC022
     D WPtr            S              2S 0 Inz                                                CSC022
                                                                                              CSC024
     D PRetCode        S              7A                                                      CSC024
     D P@OP01          S             20A                                                      CSC024
     D P@VL01          S            200A                                                      CSC024
     D P@OP02          S             20A                                                      CSC024
     D P@VL02          S            200A                                                      CSC024
     D P@OP03          S             20A                                                      CSC024
     D P@VL03          S            200A                                                      CSC024
     D P@OP04          S             20A                                                      CSC024
     D P@VL04          S            200A                                                      CSC024
     D P@OP05          S             20A                                                      CSC024
     D P@VL05          S            200A                                                      CSC024
     D P@OP06          S             20A                                                      CSC024
     D P@VL06          S            200A                                                      CSC024
     D P@OP07          S             20A                                                      CSC024
     D P@VL07          S            200A                                                      CSC024
     D P@OP08          S             20A                                                      CSC024
     D P@VL08          S            200A                                                      CSC024
     D P@OP09          S             20A                                                      CSC024
     D P@VL09          S            200A                                                      CSC024
     D P@OP10          S             20A                                                      CSC024
     D P@VL10          S            200A                                                      CSC024
                                                                                              CSC024
     D*CSC024***       S              1A                                               CSC024 CSC054
     D*WOMEInd**       S              1A                                               CSC024 CSC054
     D CSC054          S              1A                                                      CSC054
     D WPEAInd         S              1A                                                      CSC054
                                                                                              CSC024
      *
      ***  Response Mode, passed as a constant parameter to the VAL module
      ***  This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      *
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
      ***  Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   END
      *
      ***  Do while screen: Screen details 1
      *
     C     @SCRN         DOWEQ     '1'
     C                   EXSR      SCRN@1
     C                   END
      *
      ***  Do while screen: Screen details 2
      *
     C     @SCRN         DOWEQ     '2'
     C                   EXSR      SCRN@2
     C                   END
      *                                                                                       LLN022
      **  Handle window processing                                                            LLN022
      *                                                                                       LLN022
     C     @SCRN         IFEQ      'W'                                                        LLN022
     C                   EXSR      WINDOW                                                     LLN022
     C                   ENDIF                                                                LLN022
      *
      ***  Screen: Confirmation of input
      *
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END
      *
      ***  Do file updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
     C                   END
      *
      ***  Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      '1'           *INLR
     C                   END
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@1 - Process screen 1 details                             *
      *****************************************************************
     C     SCRN@1        BEGSR
      *
      ***  Update 'previous' Facility & screen control indicator
      *
     C                   MOVEL     DDCSSN        @PCSSN           10
     C                   MOVEL     DDFACT        @PFACT            3
     C                   MOVEL     DDFCNO        @PFCNO            2
     C                   MOVEL     DDACTN        @PACTN            1
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen
      *
     C                   CALLB     'LEFCIP1DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty (in screen format)
     C                   PARM                    FcipNwPrim
      *
      ***  Fields in error
      *
     C                   PARM                    OkFcPrim
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
     C                   PARM                    @EINKV
     C                   PARM                    @EINKW
     C                   PARM                    @EINKX
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFACR          11
      *
      * General ledger details used for Profit center validation
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
      * Switchable features
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE007
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      '0'           @INKW             1
     C                   PARM      '0'           @INKX             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OkFcPrim
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@2 - Process screen 2 details                             *
      *****************************************************************
     C     SCRN@2        BEGSR
      *
      ***  Update 'previous' Loan number & screen control indicator
      *
     C                   MOVEL     DDCSSN        @PCSSN
     C                   MOVEL     DDFACT        @PFACT
     C                   MOVEL     DDFCNO        @PFCNO
     C                   MOVEL     DDACTN        @PACTN
     C                   MOVEL     @CCI@         @PCI@
      *
      ***  Write/Read display screen 2
      *
     C                   CALLB     'LEFCIP2DP'
      *
      ***  INPUT PARAMETERS
      *
      ***  Return code
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty (in screen format 1)
     C                   PARM                    FcipNwPrim
      *
      ***  Fclty (in screen format 2)
     C                   PARM                    FcipNwSeco
      *
      ***  Fields in error
      *
     C                   PARM                    OkFcSeco
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM                    @EINKI            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKN            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKV            1
     C                   PARM                    @EINKW            1
     C                   PARM                    @EINKX            1
      *
      ***  Action code
      *
     C                   PARM      DDACTN        PActionCode       1
      *
      ***  Switchable features
      *
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE008
 
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    H#PRTR            1
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC
     C                   PARM      '0'           @INKJ
     C                   PARM      '0'           @INKL
     C                   PARM                    @INKP             1
     C                   PARM                    @INKV             1
     C                   PARM                    @INKW             1
     C                   PARM                    @INKX             1
     C                   PARM      'N'           WriteOnly
 
     C                   Z-ADD     WIDX          PRVWARN           3 0
      *
      ***  Reset errors file and check function keys
      *
     C                   MOVE      *ALL'Y'       OkFcSeco
      *
     C                   EXSR      RESET
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESET  - Reset errors                                         *
      *****************************************************************
     C     RESET         BEGSR
      *
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/7 - Roll Backwards
      *
     C     @INKG         CASEQ     '1'           ROLL
      *
      ***  CK/8 - Roll Forwards
      *
     C     @INKH         CASEQ     '1'           ROLL
      *
      ***  CK/12 - Cancel
      *
     C     @INKL         CASEQ     '1'           CANC@A
      *
      ***  CK/15 - Browse
      *
     C     @INKP         CASEQ     '1'           BLDBRW
      *
      ***  CK/21 - Funding participant
      *
     C     @INKV         CASEQ     '1'           FUND
      *
      ***  CK/22 - Rsik Participant
      *
     C     @INKW         CASEQ     '1'           PART
      *
      ***  CK/23 - Assignement
      *
     C     @INKX         CASEQ     '1'           ASSI
      *
      ***  Validate input to 1, 2 details screen
      *
     C                   CAS                     VAL@A
      *
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@A  - Validate input to details screen 1, 2                *
      *          first part                                           *
      *****************************************************************
     C     VAL@A         BEGSR
      *
      ***  If action code and Facilt ref  are blank
      ***  Re-output screen
      *
     C     DDACTN        IFEQ      *BLANKS
     C     DDCSSN        ANDEQ     *BLANKS
     C     DDFACT        ANDEQ     *BLANKS
     C     DDFCNO        ANDEQ     *BLANKS
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Retrieve Fclty details
      *
     C     @SCRN         IFEQ      '1'
     C                   EXSR      RTVFCLTY
      *
      ***  If action code or Fclty ref are NOT OK
      ***  Re-output screen with error messages on it
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDCSSNOK      OREQ      'N'
     C     DDFACTOK      OREQ      'N'
     C     DDFCNOOK      OREQ      'N'
     C                   GOTO      EVAL@A
     C                   END
     C                   END
      *
      ***  Set field and function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  If action code is delete, close, enquire or authorize
      ***  or action code is amend and Fclty ref has changed
      ***  Put the Fclty on the details screen 1
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C     DDACTN        OREQ      'E'
     C     DDACTN        OREQ      'X'
     C     DDACTN        OREQ      'A'
     C     DDCSSN        ANDNE     @PCSSN
     C     DDACTN        OREQ      'A'
     C     DDFACT        ANDNE     @PFACT
     C     DDACTN        OREQ      'A'
     C     DDFCNO        ANDNE     @PFCNO
     C     DDACTN        OREQ      'A'
     C     DDACTN        ANDNE     @PACTN
      *
     C                   EXSR      PUTD@1
     C                   END
      *
      ***  If Fclty ref or screen control indicators have changed
      ***  Re-output screen
      *
     C     DDCSSN        IFNE      @PCSSN
     C     DDACTN        ANDNE     'I'
     C     DDFACT        ORNE      @PFACT
     C     DDACTN        ANDNE     'I'
     C     DDFCNO        ORNE      @PFCNO
     C     DDACTN        ANDNE     'I'
     C     DDACTN        ORNE      @PACTN
     C     DDACTN        ANDNE     'I'
     C                   GOTO      EVAL@B
     C                   END
      *
      *----------------------------------------------------------------
      ***  If reverse or close
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     FacmFilFmt    ValidFacm
     C                   MOVEL     FacnFilFmt    ValidFacn
      *
      ***  If CK/10 taken, go onto updates
      *
     C     @INKJ         IFEQ      '1'
     C                   MOVEL     'U'           @SCRN
     C                   END
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If enquire
      *
     C     DDACTN        IFEQ      'E'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     FacmFilFmt    ValidFacm
     C                   MOVEL     FacnFilFmt    ValidFacn
      *
      ***  If browse outstanding, read next browse subfile record
      *
     C     @RDNB         IFEQ      'Y'
     C     @SCRN         ANDEQ     '2'
     C                   MOVEL     'R'           @SCRN
     C                   END
      *
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If authorize
      *
     C     DDACTN        IFEQ      'X'
      *
      ***  Update Fclty in File Format
      *
     C                   MOVEL     FacmFilFmt    ValidFacm
     C                   MOVEL     FacnFilFmt    ValidFacn
      *
     C                   GOTO      EVAL@A
     C                   END
      *
      *----------------------------------------------------------------
      ***  If insert or amend
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
      *
      ***  Prior to validation, initialize error indicators as 'OK'
      ***  and clear Loan in File Format
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVE      *ALL'Y'       OkFcPrim
     C     @SCRN         WHENEQ    '2'
     C                   MOVE      *ALL'Y'       OkFcSeco
     C                   END
      *
      ***  Update Fclty in valid file format
      *
     C                   MOVEL     FacmFilFmt    ValidFacm
     C                   MOVEL     FacnFilFmt    ValidFacn
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   EXSR      VAL@1
     C     @SCRN         WHENEQ    '2'
     C                   EXSR      VAL@2
     C                   END
      *
      ***  Update Fclty in file format
      *
     C                   MOVEL     ValidFacm     FacmFilFmt
     C                   MOVEL     ValidFacn     FacnFilFmt
      *
     C                   END
      *
     C     EVAL@A        TAG
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C     WIdx          ORNE      0
     C     WIDX          ANDNE     PRVWARN
     C                   GOTO      EVAL@B
     C                   END
      *
      ***  Continue
      *
     C                   SELECT
     C     @SCRN         WHENEQ    '1'
     C                   MOVEL     '2'           @SCRN
     C     @SCRN         WHENEQ    '2'
     C                   SELECT
     C     DDACTN        WHENEQ    'E'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     '1'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'I'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'C'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'A'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'X'
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   MOVEL     'W'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   MOVEL     'U'           @SCRN
     C                   ENDIF                                                                LLN022
     C                   END
     C                   END
      *
      *----------------------------------------------------------------
     C     EVAL@B        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@1  - Validate input to details screen 1                   *
      *****************************************************************
     C     VAL@1         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
     C                   CALLB     'LEFCIPAMD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Facility in Screen Format
     C                   PARM                    FcipNwPrim
     C                   PARM                    FcipNwSeco
      *
      * Current Facility in Screen Format
     C                   PARM                    CurPriScn
     C                   PARM                    CurSecScn
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * Switchable features
     C                   PARM                    CLE005            1
     C                   PARM                    CLE006            1
     C                   PARM                    CLE007            1
     C                   PARM                    CLE008            1
      *
      * Screen to validate
     C                   PARM      '1'           SCREEN            1
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk           1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs         1
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@1
     C                   END
 
     C                   END
      *
      ***  Validate Fclty details
      *
     C                   CALLB     'LEFCIP1VL'
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Mode
     C                   PARM                    ModeOfop          6
      ** Customer Primary Details
     C                   PARM                    FcipNwPrim
      ** Customer Secondaru Details                                                           CLE106
     C                   PARM                    FcipNwSeco                                   CLE106
      ** Current Facility FM file
     C                   PARM                    FacmFilFmt
      ** Current Facility FN file
     C                   PARM                    FacnFilFmt
      * Front Office ID
     C                   PARM                    APFOTranID       20
      * CLE002
     C                   PARM                    CLE002            1
      * CLE005
     C                   PARM                    CLE005            1
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
 
      * Front office inputs (if mode = 'B' or ModeOfop = FRONT)
     C                   PARM                    F1PCOB            3
     C                   PARM                    F1TNRF           15
     C                   PARM                    F1IUSR           10
     C                   PARM                    F1XUSR           10
     C                   PARM                    F1AUSR           10
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV                                     MD039655
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcPrim
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
      * Start date used in another module
     C                   PARM                    WWDTAP            5
      * Expiry date used in another module
     C                   PARM                    WWDTEX
      * Decimal places
     C                   PARM                    WWNBDP            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facility amount
     C                   PARM                    W#FAMT
      * Account officer to default
     C                   PARM                    WBLACF
      * Credit Agreement Change Flag                                                          CLE147
     C                   PARM                    CADetails        33                          CLE147
      *
      ** Blank out the field FCNO as error message sent during insert mode
     C     DDACTN        IFEQ      'I'
     C     DDFCNO        ANDNE     '  '
                                                                                              CSC024
      ***Allow*entry*for*Facility*Seq.*No.*for*Insert*if*CSC024*is                     CSC024 CSC054
      ***switched*on*and*running*on*OME*system.                                        CSC024 CSC054
      ** Allow entry for Facility Seq. No. for Insert if CSC054 is                            CSC054
      ** switched on and running on PEA system.                                               CSC054
                                                                                              CSC024
     C*****CSC024        IFNE      'Y'                                                 CSC024 CSC054
     C*****WOMEInd       ORNE      'Y'                                                 CSC024 CSC054
     C     CSC054        IFNE      'Y'                                                        CSC054
     C     WPEAInd       ORNE      'Y'                                                        CSC054
     C                   MOVEL     DDFCNO        WWFCNO            2
     C                   MOVEL     *BLANKS       DDFCNO
     C                   ENDIF                                                                CSC024
     C                   END
 
      *----------------------------------------------------------------
     C     EVAL@1        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@2  - Validate input to details screen 2                   *
      *****************************************************************
     C     VAL@2         BEGSR
      *
      ***  Validate whether non-amenable fields have been changed
      *
     C     DDACTN        IFEQ      'A'
      *
     C                   CALLB     'LEFCIPAMD'
      *
      ***  Inputs
      *
      ***  Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Facility in Screen Format
     C                   PARM                    FcipNwPrim
     C                   PARM                    FcipNwSeco
      *
      * Current Facility in Screen Format
     C                   PARM                    CurPriScn
     C                   PARM                    CurSecScn
      *
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      *
      * Switchable features
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE007
     C                   PARM                    CLE008
      *
      * Screen to validate
     C                   PARM      '2'           SCREEN
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcPrim
     C                   PARM                    OKFcSeco
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
      * Amendments OK
     C                   PARM                    AmendOk
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           ResetErrs
      *
      ***  If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EVAL@2
     C                   END
     C                   END
      *
      ***  Validate Fclty details
     C                   CALLB     'LEFCIP2VL'
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      ** Facility Primary   Details
     C                   PARM                    FcipNwPrim
      ** Facility Secondary Details
     C                   PARM                    FcipNwSeco
      * Facility - file formats
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      * Front Office ID
     C                   PARM                    APFOTranID       20
      * Start date
     C                   PARM                    WWDTAP            5
      * Expiry date
     C                   PARM                    WWDTEX            5
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * Next expiry date
     C                   PARM                    WNDTEX            5
      * Facility decimal places
     C                   PARM                    WWNBDP            1
      * OK indicator - filed TRCA
     C                   PARM                    OKTRCA            1
 
      * OK indicator - filed CAFT
     C                   PARM                    OKCAFT            1
      * OK indicator - filed CAFN
     C                   PARM                    OKCAFN            1
      * CA currency
     C                   PARM                    WCACCY            3
      * Facilty amount
     C                   PARM                    W#FAMT           13 0
      * Account officer to default
     C                   PARM                    WBLACF            1
      * Participant Facility ind. from FCLTYFM file
     C                   PARM                    H#PRTR            1
 
      * Customer Extra Data file data
     C                   PARM                    ExtData         500
      * CLE005
     C                   PARM                    CLE005            1
      * CLE006
     C                   PARM                    CLE006
      * CLE007
     C                   PARM                    CLE007            1
      * CLE014
     C                   PARM                    CLE014            1
      * CSC011
     C                   PARM                    CSC011            1
      * CEU013
     C                   PARM                    CEU013            1
                                                                                            MD039655
      ** Reject Action Code                                                                 MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV                                     MD039655
 
      * OUTPUTS
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFcSeco
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      * Warning fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    WIdx
      * Valid Facility FM layout (DS) from/to caller
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
      * Facility amount has changed
     C                   PARM                    FacAmChg          1
      * Table OAM to be updated
     C                   PARM                    UpdOam            1
      *
      *----------------------------------------------------------------
     C     EVAL@2        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - Roll backwards & forwards through Fclty file
      *****************************************************************
     C     ROLL          BEGSR
      *
      ***  Default action code to enquiry if not valid
      *
     C     DDACTN        IFNE      'A'
     C     DDACTN        ANDNE     'R'
     C     DDACTN        ANDNE     'C'
     C     DDACTN        ANDNE     'X'
     C                   MOVE      'E'           DDACTN
     C                   END
      *
      ***  Read next or previous record on Fclty file
      ***  according to command key taken (CK/7 OR CK/8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'LEFCIPRED'
      *
      ***  INPUT PARAMETERS
      *
      ***  RETURN CODE
     C                   PARM                    RetCodeIn
      *
      ***  Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      ***  Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM                    ModeofOp          6
      *
      ***  Action code
     C                   PARM                    DDACTN            1
      *
      ***  Facility ref pointer
     C                   PARM                    DDCSSN           10
      *
      ***  Facility ref pointer
     C                   PARM                    DDFACT            3
      *
      ***  Facility ref pointer
     C                   PARM                    DDFCNO            2
      *
      ***  Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      ***  Read forwards
     C                   PARM                    @RDFWD            1
      *
      ***  Read backwards
     C                   PARM                    @RDBCK            1
      *
      ***  Output parameters
      *
      ***  Error message
     C                   PARM                    @ERRMS            7
      *
      ***  Facility ref pointer
     C                   PARM                    @CNUMR            6
      *
      ***  Facility ref pointer
     C                   PARM                    @FACTR            3
      *
      ***  Facility ref pointer
     C                   PARM                    @FCNOR            2
      *
      ***  Front Office Fclty Read
     C                   PARM                    @FTRED           20
      *
      *
      ***  If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@A
     C                   GOTO      EROLL
     C                   END
      *
      ***  If Fclty read
      *
     C     @CNUMR        IFNE      *BLANK
      *
      ***  Retrieve Fclty details
      *
     C                   MOVEL     @CNUMR        DDCSSN
     C                   MOVEL     @FACTR        DDFACT
     C                   MOVEL     @FCNOR        DDFCNO
     C                   EXSR      RTVFCLTY
      *
      ***  Set field and function key status on main details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  Put the Fclty on the main details screen
      *
     C                   EXSR      PUTD@1
      *
      ***  Go to first details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - Build browse subfile                                 *
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      ***  Reset read next browse subfile record
      *
     C                   MOVEL     *BLANK        @RDNB             1
      *
      ***  Save the screen fields
      *
     C                   MOVEL     DDACTN        StoreAC           1
     C                   MOVEL(P)  DDCSSN        WSDDCSSN         10
     C                   MOVEL(P)  DDFACT        WSDDFACT          3
     C                   MOVEL(P)  DDFCNO        WSDDFCNO          2
      *
      ***  Build browse subfile
      *
     C                   CALLB     'LEFCIPBRW'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
      *
     C                   PARM                    DDACTN            1
      *
      ***  Facility pointer.
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
      *
      ***  Build subfile
      *
     C                   PARM      'Y'           @BDSFL            1
      *
      ***  Read subfile record
      *
     C                   PARM      *BLANK        @RDSFL            1
      *
      ***  Output parameters
      *
      ***  Error message
      *
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
      *
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Fclty selected.
     C                   PARM                    @CUSEL            6
     C                   PARM                    @FASEL            3
     C                   PARM                    @FCSEL            2
      *
      ***  Command keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  Restore the screen fields
      *
     C                   MOVEL     StoreAC       DDACTN
     C                   MOVEL(P)  WSDDCSSN      DDCSSN
     C                   MOVEL(P)  WSDDFACT      DDFACT
     C                   MOVEL(P)  WSDDFCNO      DDFCNO
      *
      ***  If CK/3 taken in browse, end program
      *
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@A
     C                   GOTO      EBLDBR
     C                   END
      *
      ***  If CK/12 not taken in browse
      ***  Read next browse subfile record
      *
     C     @INKL         IFEQ      '0'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
     C                   MOVE      '0'           @INKL
     C                   END
      *
     C     EBLDBR        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FUND   - Funding participant                                  *
      *****************************************************************
     C     FUND          BEGSR
      *
     C**                 CALLB     'LEFPRTSIN'
     C**                 PARM                    P#MODE            1
     C**                 PARM                    P#INMF
     C**                 PARM                    P#OUMF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PART   - Risk participant                                     *
      *****************************************************************
     C     PART          BEGSR
      *
     C**                 CALLB     'LERPRTSIN'
     C**                 PARM                    P#MODE            1
     C**                 PARM                    P#INMF
     C**                 PARM                    P#OUMF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ASSI   - Assignment                                           *
      *****************************************************************
     C     ASSI          BEGSR
      *
     C**                 CALLB     'LEASGNSIN'
     C**                 PARM                    P#MODE            1
     C**                 PARM                    P#INMF
     C**                 PARM                    P#OUMF
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - Read next browse subfile record                      *
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      ***  Read next subfile record
      *
     C                   CALLB     'LEFCIPBRW'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ***  Action code
      *
     C                   PARM                    DDACTN            1
      *
      ***  Facility pointer.
     C                   PARM                    DDCSSN           10
     C                   PARM                    DDFACT            3
     C                   PARM                    DDFCNO            2
      *
      ***  Build subfile
      *
     C                   PARM      *BLANK        @BDSFL            1
      *
      ***  Read subfile record
      *
     C                   PARM      'Y'           @RDSFL            1
      *
      ***  Output parameters
      *
      ***  Error message
      *
     C                   PARM      *BLANK        @ERRMS            7
      *
      ***  Option selected
      *
     C                   PARM      *BLANK        @OPSEL            1
      *
      ***  Fclty selected.
     C                   PARM                    @CUSEL            6
     C                   PARM                    @FASEL            3
     C                   PARM                    @FCSEL            2
      *
      ***  Command keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      ***  If Fclty read from subfile
      *
     C     @CUSEL        IFNE      *BLANKS
     C     @OPSEL        ANDNE     *BLANKS
      *
      ***  Retrieve Fclty details
      *
     C                   MOVEL     @OPSEL        DDACTN
     C                   MOVEL     @CUSEL        DDCSSN
     C                   MOVEL     @FASEL        DDFACT
     C                   MOVEL     @FCSEL        DDFCNO
     C                   EXSR      RTVFCLTY
      *
      ***  Set field and function key status on first details screen
      ***  (according to action code)
      *
     C                   EXSR      SFDS@A
     C                   EXSR      SFKS@A
      *
      ***  Put the Fclty on the appropriate details screen
      *
     C                   EXSR      PUTD@1
      *
      ***  Else, reset read next browse subfile record
      *
     C                   ELSE
     C                   MOVEL     *BLANK        @RDNB
     C                   END
      *
      ***  Go to appropriate details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   MOVE      *OFF          @INKP
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFCLTY- Retrieve Facility                                   *
      *****************************************************************
     C     RTVFCLTY      BEGSR
      *
      ***  Retrieve Fclty
      *
     C     @SCRN         IFEQ      '1'
     C                   ENDIF
     C                   CALLB     'LEFCIPRTV'
      * INPUTS
      * Return code
     C                   PARM                    RetCodeIn
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * Mode = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    ModeofOp          6
      * Response mode
     C                   PARM                    RespMode          1
      * Action Code
     C                   PARM                    DDACTN            1
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * Front Office User
     C                   PARM                    FOUSER           16
      * (Midas) Customer Number
     C                   PARM                    DDCSSN           10
      * (Midas) Facility Type
     C                   PARM                    DDFACT            3
      * (Midas) Facility number
     C                   PARM                    DDFCNO            2
      * (Midas) Branch
     C                   PARM                    DDBRCA            3
                                                                                            MD039655
      ** Reject action                                                                      MD039655
                                                                                            MD039655
     C                   PARM      *BLANK        @ACTRV            1                        MD039655
     C/COPY WNCPYSRC,LEH00358
 
      * OUTPUTS
      * (Current) Facility FM in file format
     C                   PARM                    FacmFilFmt
      * (Current) Facility FN in file format
     C                   PARM                    FacnFilFmt
      * OK - Action code
     C                   PARM                    DDACTNOK          1
      * OK - Customer number
     C                   PARM                    DDCSSNOK          1
      * OK - Facility type
     C                   PARM                    DDFACTOK          1
      * OK - Facility number
     C                   PARM                    DDFCNOOK          1
     C/COPY WNCPYSRC,LEH00320
      * Reactivation indicator
     C                   PARM                    WREAC             1
      * New expiry date
     C                   PARM                    WNDTEX            5
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM                    Idx
      *
     C                   Z-ADD     FMTNLU        H#TNLU            5 0
     C                   MOVE      FMPRTR        H#PRTR            1
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * PUTD@1 - Put a Fclty on the first details screen              *
      *****************************************************************
     C     PUTD@1        BEGSR
      *
      ***  Call program to fill screen fields with data from FCLTYFM and FCLTYFN
      *
     C                   CALLB     'LEFCIPCVT'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM                    RetCodeIn
      *
      * Facility FM in file formats
     C                   PARM                    FacmFilFmt
      * Facility FN in file formats
     C                   PARM                    FacnFilFmt
      *
      * Output parameters
      *
      * Facility in screen format
     C                   PARM                    FcipNwPrim
     C                   PARM                    FcipNwSeco
      *
      ***  Update 'Current' Fclty with Fclty in Screen Format
      *
     C                   MOVEL     FcipNwPrim    CurPriScn
     C                   MOVEL     FcipNwSeco    CurSecScn
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFDS@A - Set field status on details screens 1, 2             *
      *          according to action code                             *
      *****************************************************************
     C     SFDS@A        BEGSR
      *
      ***  Enable/disable key & detail fields on details screen
      ***  (key fields = action code & Fclty ref; detail fields = rest)
      *
     C     DDACTN        IFEQ      'I'
     C     DDACTN        OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SFKS@A - Set function key status on details screens 1, 2      *
      *                according to action code                       *
      *****************************************************************
     C     SFKS@A        BEGSR
      *
      ***  Enable/disable function keys on details screen
      *
      ***  KG = Command key 07 = Previous
      *
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     'Y'           @EINKG
      *
      ***  KH = Command key 08 = Next
      *
     C                   MOVEL     'Y'           @EINKH
     C                   END
      *
      ***  KJ = Command Key 10 = Reverse or Close
      *
     C     DDACTN        IFEQ      'R'
     C     DDACTN        OREQ      'C'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      ***  KP = Command key 15 = Browse
      *
     C                   MOVEL     'Y'           @EINKP
      *
      ***  KV = Command key 21 = Funding
      *
     C                   MOVEL     'Y'           @EINKV
      *
      ***  KW = Command key 22 = Risk Parti
      *
     C                   MOVEL     'Y'           @EINKW
      *
      ***  KX = Command key 23 = Assign
      *
     C                   MOVEL     'Y'           @EINKX
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@A - Initialize field status on details screens 1, 2      *
      *****************************************************************
     C     IFDS@A        BEGSR
      *
      ***  Enable key & details fields
      *
     C                   MOVEL     'Y'           @EKYFD
     C     DDACTN        IFEQ      'A'
     C     DDACTN        OREQ      'I'
     C     DDACTN        OREQ      *BLANKS
     C                   MOVEL     'Y'           @EDTFD
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFKS@A - Initialize function key status on details screens    *
      *          1, 2                                                 *
      *****************************************************************
     C     IFKS@A        BEGSR
      *
      ***  Enable/disable function keys on details screens
      *
      * KG = Command key 07 = Read previous
      * KH = Command key 08 = Read next
      * KJ = Command key 10 = Delete
      * KP = Command key 15 = Browse
      * KV = Command key 21 = Fund
      * KW = Command key 22 = Risk Part
      * KX = Command key 23 = Assign
      *
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   MOVEL     'Y'           @EINKV
     C                   MOVEL     'Y'           @EINKW
     C                   MOVEL     'Y'           @EINKX
     C                   END
      *
     C     DDACTN        IFNE      'E'
     C     DDACTN        ANDNE     'A'
     C                   MOVEL     'Y'           @EINKP
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@A - Cancel on details screens 1, 2                       *
      *****************************************************************
     C     CANC@A        BEGSR
      *
      ***  Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      ***  If input fields are enabled
      ***  Blank the first details screen
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C     @SCRN         IFEQ      '1'
     C                   MOVEL     *BLANK        FcipNwPrim
     C                   MOVEL     *BLANK        DDNAME           10
     C                   END
     C                   END
      *
     C     @SCRN         IFEQ      '2'
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
      ***  Initialize field and function key status on details screen
      *
     C     @SCRN         IFEQ      '1'
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@A - Send a message to details screens 1, 2               *
      *****************************************************************
     C     SNDM@A        BEGSR
      *
      ***  If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'LEF0009'
     C                   MOVE      'N'           DDACTNOK
     C                   END
      *
      ***  Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - Process screen: Confirmation of input                *
      *          evoked for inserts, amends & authorizations          *
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      ***  Output message 'Press enter to accept'
      *
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEF0425'     MsgIdArr(1)
      *
      ***  Write/read display screen
      *
     C                   CALLB     'LEFCIP1DP'
      *
      ***  Input parameters
      *
      ***  Return code
      *
     C                   PARM      *BLANKS       RetCodeOut
      *
      ***  Fclty (in screen format)
     C                   PARM                    FcipNwPrim
      *
      ***  Fields in error
 
     C                   PARM                    OkFcPrim
      *
      ***  Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ***  Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ***  Enabled key & detail fields
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      ***  Enabled function keys
      *
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKV
     C                   PARM      'N'           @EINKW
     C                   PARM      'N'           @EINKX
      *
      ***  Succesful insert
      *
     C                   PARM                    @SIFACR          11
      *
      * General ledger details used for Profit center validation
     C                   PARM                    BKPRCU
     C                   PARM                    BKPRCA
      * Switchable features
     C                   PARM                    CLE005
     C                   PARM                    CLE006
     C                   PARM                    CLE007
      *
      ***  Record Id
      *
      ***  OUTPUT PARAMETERS
      *
      ***  Function keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      '0'           @INKW             1
     C                   PARM      '0'           @INKX             1
     C                   PARM      'N'           WriteOnly         1
      *
      ***  Reset errors
      *
     C                   MOVE      *ALL'Y'       OkFcPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
      *
      ***  CK/3 - End program
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      ***  CK/12 - Cancel on confirmation screen
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      ***  Exit confirmation screen
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - Cancel on confirmation screen                        *
      *****************************************************************
     C     CANC@C        BEGSR
      *
      ***  Return to first detail screen
      *
     C                   MOVEL     '1'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@A
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@A
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - Exit from confirmation screen                        *
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      ***  If no errors in validation
      *
     C     Idx           IFEQ      *ZERO
     C     WIdx          ANDEQ     *ZERO
      *
      ***  Continue with updates
      *
     C                   MOVEL     'U'           @SCRN
      *
      ***  else, return to first details screen
      *
     C                   ELSE
     C                   MOVEL     '1'           @SCRN
      *
      ***  Initialize field status on details screen
      *
     C                   EXSR      IFDS@A
      *
      ***  Set function key status on details screen
      ***  (according to action code)
      *
     C                   EXSR      SFKS@A
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - Updates                                              *
      *****************************************************************
     C     UPDATS        BEGSR
      *
      ***  Update valid Fclty: Facility Ref
      *
     C                   MOVEL     DDCSSN        V_FPCNUM
     C                   MOVEL     DDCSSN        V_FNCNUM
     C                   MOVEL     DDFACT        V_FPFACT
     C                   MOVEL     DDFACT        V_FNFACT
      *
      ** Restore Seq.number if Insert mode
     C     DDACTN        IFEQ      'I'
     C     DDFCNO        ANDEQ     *BLANKS
     C                   MOVEL     WWFCNO        DDFCNO
     C                   END
 
     C                   MOVEL     DDFCNO        V_FPFCNO
     C                   MOVEL     DDFCNO        V_FNFCNO
      *
      ***  Update valid Fclty: Last action code
      *
     C                   MOVEL     DDACTN        V_FPCHTP
     C                   MOVEL     DDACTN        V_FNCHTP
      *
      ** Send the confirmation message only in Insert mode
     C     DDACTN        IFEQ      'I'
     C                   MOVEL     DDCSSN        @SICSSN
     C                   MOVEL     DDFACT        @SIFACT
     C                   MOVEL     DDFCNO        @SIFCNO
     C                   END
      *
      ***  Fclty updates
      *
     C     @RTCD         IFEQ      *BLANK
      *
     C                   CALLB     'LEFCIPUPD'
     C                   PARM                    @@RTCD            7
     C                   PARM                    P#MODE            1
     C                   PARM                    ValidFacm
     C                   PARM                    ValidFacn
     C                   PARM                    CLE008            1
     C                   PARM                    CSC011            1
     C                   PARM                    BJLCCY            3
     C                   PARM                    BJSLCD            3                       AR937578A
     C                   PARM                    BJRDNB            5 0
     C                   PARM                    H#TNLU            5 0
      *
      * OUTPUTS
      *
     C                   PARM                    OKFcPrim
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    Idx
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIDArr
     C                   PARM                    WMsgDtaArr
     C                   PARM                    WIdx
 
     C                   END
      *
      ***  If there were any errors in the update functions ROLLBACK any
      ***  updates and end this program. Otherwise, COMMIT the updates
      *
     C     @RTCD         IFNE      *BLANKS
     C     @RTCD         ANDNE     '*RECUPD'
      *   ROLLBACK data if either of the following is true:                                   CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      *                                                                                      LLN022A
      ** If BOE installed access the valid file LEVCLIPY0 using the front office             LLN022A
      ** identifier as key                                                                   LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
      *                                                                                      LLN022A
     C                   EVAL      ACTN = DDACTN                                             LLN022A
     C                   EVAL      LVCNUM = BYCNUM                                           LLN022A
     C                   EVAL      LVFACT = BYFACT                                           LLN022A
     C                   EVAL      LVFCNO = BYFCNO                                           LLN022A
     C                   EVAL      LVEURO = BYEURO                                           LLN022A
     C                   EVAL      LVFCNO = V_FPFCNO                                         LLN022A
                                                                                             LLN022A
     C                   CALLB     'LEFCIPUPD1'                                              LLN022A
     C                   PARM                    PRTCD            10                         LLN022A
     C                   PARM                    ACTN              1                         LLN022A
     C                   PARM                    ValidFCIPEx                                 LLN022A
      *                                                                                      LLN022A
      ** If errors in update, rollback any update and end pgm else commit update             LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFNE      *BLANK                                                    LLN022A
     C     @RTCD         ANDNE     '*RECUPD'                                                 LLN022A
     C     @RTCD         ANDNE     '*RECLCK'                                                 LLN022A
     C                   ROLBK                                                               LLN022A
     C                   EXSR      *PSSR                                                     LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** If update not done due to record has been updated by other workstation              LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFEQ      '*RECUPD'                                                 LLN022A
     C                   MOVEL     '*ANY'        FldNameArr(1)                               LLN022A
     C                   MOVEL     'ER99919'     #MsgID                                      LLN022A
     C                   MOVEL     #MsgID        MsgIdArr(1)                                 LLN022A
     C                   MOVE      'N'           WProcess          1                         LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      ** If update not done due to record being locked by other workstation                  LLN022A
      *                                                                                      LLN022A
     C     @RTCD         IFEQ      '*RECLCK'                                                 LLN022A
     C                   MOVEL     '*ANY'        FldNameArr(1)                               LLN022A
     C                   MOVEL     'ERL0950'     #MsgID                                      LLN022A
     C                   MOVEL     #MsgID        MsgIdArr(1)                                 LLN022A
     C                   MOVE      'N'           WProcess                                    LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      *   COMMIT data if either of the following is true:                                     CSC022
      *     1. Commitment Control Changes switch is OFF; or                                   CSC022
      *     2. Commitment Control Changes switch is ON and                                    CSC022
      *        this particular job is not included in the                                     CSC022
      *        commitment jobs in data area SCCMTJOB                                          CSC022
     C                   If        CSC022  = 'N' or                                           CSC022
     C                             (CSC022 = 'Y' and WSkipCommit = 'N')                       CSC022
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C                   END
      *
      ***  If update not done due to record being updated by another
      ***  workstation send message to screen.
      *
     C
     C     @RTCD         IFEQ      '*RECUPD'
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'LEF0426'     MsgIdArr(1)
     C                   END
     C
      * Blank all details screen
      *
     C                   MOVEL     *BLANKS       FcipNwPrim
     C                   MOVEL     *BLANKS       DDNAME
     C                   MOVEL     *BLANKS       FcipNwSeco
     C                   MOVE      *ALL'Y'       OkFcSeco
     C                   MOVE      *ALL'Y'       OkFcPrim
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
      *
      ***  If records are still to be read from the subfile, read them
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      ***  Else, return to first details screen
      *
     C                   MOVEL     '1'           @SCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ENDP - End program                                            *
      *****************************************************************
     C     ENDP          BEGSR
      *
     C     BGWDPR        IFEQ      'Y'                                                        LLN022
     C                   ROLBK                                                                LLN022
     C                   ENDIF                                                                LLN022
     C                   MOVEL     'T'           @SCRN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Initial processing                                   *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize SAR work flag and Commit flag                                             CSC022
     C                   Eval      CSC022      = 'N'                                          CSC022
     C                   Eval      WSkipCommit = ' '                                          CSC022
      *                                                                                       CSC022
      ** Determine if Commitment Control Changes for MidasPlus                                CSC022
      ** (CSC022) is installed                                                                CSC022
      *                                                                                       CSC022
     C                   Call      'AOSARDR0'                                                 CSC022
     C                   Parm      *BLANKS       @RTCD                                        CSC022
     C                   Parm      '*VERIFY'     @OPTN                                        CSC022
     C                   Parm      'CSC022'      PSARD                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      **                                                                                      CSC022
      *                                                                                       CSC022
      ** If feature is on, set up SAR work flag                                               CSC022
      *                                                                                       CSC022
     C                   If        @RTCD = *Blanks                                            CSC022
     C                   Eval      CSC022      = 'Y'                                          CSC022
     C                   Eval      WSkipCommit = 'N'                                          CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        COMITNO  <> 0                                              CSC022
     C                   MoveA     COMITJOBS     WArrCmtJob                                   CSC022
     C                   Eval      WPtr = %LookUp(PSJobName:WArrCmtJob)                       CSC022
     C                   If        WPtr > 0                                                   CSC022
     C                   Eval      WSkipCommit = 'Y'                                          CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   Else                                                                 CSC022
      *                                                                                       CSC022
      ** else, database error (return code other than *NRF)                                   CSC022
      *                                                                                       CSC022
     C                   If        @RTCD <> '*NRF   '                                         CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   MoveL     'LEFCIPSIN'   DBPGM                                        CSC022
     C                   MoveL     'SCSARDPD'    DBFILE                                       CSC022
     C                   MoveL     'CSC022'      DBKEY                          ************* CSC022
     C                   Z-Add     900           DBASE                          * DBASE 900 * CSC022
     C                   Out       LDA                                          ************* CSC022
     C                   ExSR      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
      *                                                                                       CSC022
     C                   EndIf                                                                CSC022
      ** Receive entry parameters
      *
      ***  Initialize program name
      *
     C                   MOVEL     'LEFCIPSIN'   DBPGM
      *
      ***  Access bank details
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE                         *************
     C                   MOVEL     '002'         DBASE                          * DBERR 002 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ***  Access Module Details
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ***  Database error
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE                         *************
     C                   MOVEL     '003'         DBASE                          * DBERR 003 *
     C                   MOVEL     @OPTN         DBKEY                          *************
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access General Ledger details via access program
      *  (database error handling done in access program)
     C**********         CALLB     'AOGELRR0'                                                 CGL029
     C                   CALLB     'AOGELRR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
 
      ** Determine if CLE002 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE002'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE002            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE002
     C                   ENDIF
 
      ** Determine if CLE005 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE005'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE005            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE005
     C                   ENDIF
 
      ** Determine if CLE006 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE006'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE006            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE006
     C                   ENDIF
      *
      ** Determine if CLE007 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE007'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE007            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE007
     C                   ENDIF
 
      ** Determine if CLE008 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE008'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE008            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE008
     C                   ENDIF
      *
      ** Determine if CLE014 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CLE014'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CLE014            1
     C                   ELSE
     C                   MOVEL     'Y'           CLE014
     C                   ENDIF
      *
      ** Determine if CSC011 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSC011'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CSC011            1
     C                   ELSE
     C                   MOVEL     'Y'           CSC011
     C                   ENDIF
      *
      ** Determine if CEU013 is installed
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CEU013'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'N'           CEU013            1
     C                   ELSE
     C                   MOVEL     'Y'           CEU013
     C                   ENDIF
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN007                                      LLN022A
      ** Bank of England Yellow Book Changes is installed.                                   LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN007            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       @RTCD                                       LLN022A
     C                   PARM      '*VERIFY'     @OPTN                                       LLN022A
     C                   PARM      'LLN007'      @SARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN007 is *ON                                                    LLN022A
      *                                                                                      LLN022A
     C                   IF        @RTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN007 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is*on*                           CSC024 CSC054
      ** Check if enhancement CSC054 (Period End Adjustments) is on                           CSC054
                                                                                              CSC024
     C                   CALLB     'AOSARDR0'                                                 CSC024
     C                   PARM      *BLANKS       @RTCD                                        CSC024
     C                   PARM      '*VERIFY'     @OPTN                                        CSC024
     C**********         PARM      'CSC024'      @SARD                                 CSC024 CSC054
     C                   PARM      'CSC054'      @SARD                                        CSC054
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC024
                                                                                              CSC024
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CSC024
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKey  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKey  = 'CSC054'                                          CSC054
     C                   EVAL      DBase  = 4                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C**********         EVAL      WOMEInd = 'N'                                       CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      WPEAInd = 'N'                                              CSC054
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         EVAL      CSC024 = 'Y'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'Y'                                               CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode                                     CSC024
     C                   PARM      PSysVal1      P@OP01                                       CSC024
     C                   PARM      *BLANKS       P@VL01                                       CSC024
     C                   PARM      *BLANKS       P@OP02                                       CSC024
     C                   PARM      *BLANKS       P@VL02                                       CSC024
     C                   PARM      *BLANKS       P@OP03                                       CSC024
     C                   PARM      *BLANKS       P@VL03                                       CSC024
     C                   PARM      *BLANKS       P@OP04                                       CSC024
     C                   PARM      *BLANKS       P@VL04                                       CSC024
     C                   PARM      *BLANKS       P@OP05                                       CSC024
     C                   PARM      *BLANKS       P@VL05                                       CSC024
     C                   PARM      *BLANKS       P@OP06                                       CSC024
     C                   PARM      *BLANKS       P@VL06                                       CSC024
     C                   PARM      *BLANKS       P@OP07                                       CSC024
     C                   PARM      *BLANKS       P@VL07                                       CSC024
     C                   PARM      *BLANKS       P@OP08                                       CSC024
     C                   PARM      *BLANKS       P@VL08                                       CSC024
     C                   PARM      *BLANKS       P@OP09                                       CSC024
     C                   PARM      *BLANKS       P@VL09                                       CSC024
     C                   PARM      *BLANKS       P@OP10                                       CSC024
     C                   PARM      *BLANKS       P@VL10                                       CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBFile = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 5                                                  CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C**********         EVAL      WOMEInd = 'Y'                                       CSC024 CSC054
     C                   EVAL      WPEAInd = 'Y'                                              CSC054
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
      *
      ***  Start with the details screen '1'
      *
     C                   MOVEL     '1'           @SCRN             1
      *
      ***  Initialize field and function key status on details screen
      *
     C                   EXSR      IFDS@A
     C                   EXSR      IFKS@A
 
     C                   MOVE      *BLANKS       @RTCD
 
      *
      ***  Hook to enable non-core initial processing to be included
      *
     C                   ENDSR
                                                                                              LLN022
      *****************************************************************                       LLN022
      ** WINDOW - Process Window for Facility input                   *                       LLN022
      *****************************************************************                       LLN022
                                                                                              LLN022
     C     WINDOW        BEGSR                                                                LLN022
      *                                                                                      LLN022A
     C                   IF        LLN007 = 'Y'                                              LLN022A
     C                   MOVE      FMCNUM        BYCNUM                                      LLN022A
     C                   MOVE      DDFACT        BYFACT                                      LLN022A
     C                   MOVE      WWFCNO        BYFCNO                                      LLN022A
     C                   MOVE      DDFCCY        BYFCCY                                      LLN022A
     C                   IF        DDACTN <> 'I'                                             LLN022A
     C                   MOVE      DDFCNO        BYFCNO                                      LLN022A
     C                   ENDIF                                                               LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   CALL      'WN0010'                                                   LLN022
     C                   PARM      'LEFCIPSIN'   #PGM             10                          LLN022
     C                   PARM                    FKEY              2                          LLN022
     C                   PARM      DDACTN        ACTION            1                          LLN022
     C                   PARM                    DATA                                         LLN022
     C                   PARM      *BLANKS       #RTRN             7                          LLN022
     C                   PARM                    SPAREW          256                          LLN022
      *                                                                                       LLN022
     C                   SELECT                                                               LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'Y2U9999'                                          LLN022
     C                   EXSR      ENDP                                                       LLN022
      *                                                                                       LLN022
     C                   WHEN      #RTRN = 'USR0790'                                          LLN022
     C                   EVAL      @SCRN = '2'                                                LLN022
      *                                                                                       LLN022
     C                   OTHER                                                                LLN022
     C                   SELECT                                                               LLN022
     C     DDACTN        WHENEQ    'E'                                                        LLN022
     C                   IF        @RDNB = 'Y'                                                LLN022
     C                   MOVEL     'R'           @SCRN                                        LLN022
     C                   ELSE                                                                 LLN022
     C                   EVAL      @SCRN = '1'                                                LLN022
     C                   ENDIF                                                                LLN022
     C     DDACTN        WHENEQ    'I'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
     C     DDACTN        WHENEQ    'A'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
     C     DDACTN        WHENEQ    'X'                                                        LLN022
     C                   MOVEL     'C'           @SCRN                                        LLN022
     C                   ENDSL                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSL                                                                LLN022
      *                                                                                       LLN022
     C                   ENDSR                                                                LLN022
                                                                                              LLN022
      *****************************************************************
      /EJECT
      *****************************************************************
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2002
