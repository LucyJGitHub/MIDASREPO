     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      **********************************************************************
/*STD *  RPGBASEMOD                                                        *
/*EXI *  TEXT('Midas FT Outgoing Payments SSI Screen 1 Validation')   *
      **********************************************************************
      *                                                                    *
      *  Midas - API Funds Transfer Module                                 *
      *                                                                    *
      *  FTOPSI1VL - Outgoing Payments SSI Primary Details Screen          *
      *              validation                                            *
      *                                                                    *
      *  Function:  Primary detail screen validation for Outgoing          *
      *             Payments Standard Settlement Instructions              *
      *                                                                    *
      *  (c) Finastra International Limited 2002                           *
      *                                                                    *
      *  Last Amend No. MD021318           Date 26Jul13               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD035360           Date 06Aug15               *
      *                 MD035030           Date 14Jul15               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 257758             Date 19Nov08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG14716           Date 24Aug07               *
      *                 246034             Date 18Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                                    *
      **********************************************************************
      *                                                                    *
      *  MD021318 - OPAY allowed input of account with block debit    *
      *           - Fix is to condition CSD089 overridable error      *
      *             changes when input is from HATS screen            *
      *  MD046248 - Finastra Rebranding                               *
      *  MD035360 - Database error encountered due to parameter error *
      *             in FTVODCS                                        *
      *  MD035030 - Fields in error are not highlighted               *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hook: CFT148_024                              *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  257758 - Warning message displayed in Outgoing payments. Add *
      *           SDFTFR in the calling parameters of FTVODCS. Pattern*
      *           after fix 257361.                                   *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  BUG14716 - CFT032 pre-req missing CFT018 OPSI Outgoing       *
      *             Payments Template                                 *
      *  246034 - Apply 240689 to FTOPSI1VL and FTOPAY7VL: incorrect       *
      *           parameters on call of FTVDNDN missing fix 240689         *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)           *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                                   *
      *  CSW037 - Additional Field Data on MT300/MT320                     *
      *  CSW036 - Dual SWIFT BIC held on Client Details                    *
      *  CLE025 - Credit Lines (Recompile)                                 *
      *  CGL029 - Increase Account Code to 10 digits                       *
      *  CFT018 - Standard Settlement Instructions for                     *
      *           Outgoing Payments                                        *
      *                                                                    *
      **********************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      *
      ********************************************************************
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
      /EJECT
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Manually included D-specs            ¦
      ** ¦ =========================            ¦
      ** +--------------------------------------+
      *
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
      *
     D #I              S              2  0
                                                                                            MD035360
     D PRTCD           S              7A                                                    MD035360
     D POPTN           S              7A                                                    MD035360
     D PSARD           S              6A                                                    MD035360
     D CFT142          S              1A                                                    MD035360
      *
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
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
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in File Format
      *
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIValidFmt   E DS                  EXTNAME(FTVOPSIPD)
     D QQDRACX       E                     EXTFLD(QQDRAC)                                     CGL029
     D QQORBKX       E                     EXTFLD(QQORBK)                                     CGL029
     D QQCDROX       E                     EXTFLD(QQCDRO)                                     CGL029
      * New Outgoing Payment SSI in File Format
      *
     D WorkFields    E DS                  EXTNAME(FTV@OPSIPD)
      * Common Work Fields
      *
     D FTEOPSI       E DS                  EXTNAME(FTEOPSIPD)
      * Error indicators
      *
     D FldNamXAr       S             10A   DIM(XArrayMax)
      * Array of Fields in error.
      *
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
      * Array of error message IDs
      *
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of error message data.
      *
     D WFldNmXAr       S             10A   DIM(XArrayMax)
      ** Array of Fields with warnings.
      *
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
      ** Array of warning message IDs
      *
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)
      ** Array of warning message data.
      *
     D OPAYDtls1     E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(S)
      *
     D OPAYDtls1x    E DS                  EXTNAME(FTOPY1APD)
     D                                     PREFIX(S)
      * Outgoing Payment Primary Screen Format Extension Details
      *
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)
     D                                     PREFIX(S)
      * Flags to indicate whether transaction fields are valid
      *
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D                                     PREFIX(@)
      * Validation Work Fields
      *
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D DSLDY         E DS                  EXTNAME(DSLDY)
      * Third DS for access programs, Very long data structure
      *
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)
      ** Customer details layout
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      * External DS for Bank details
      *
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * External DS for Funds Transfer details
      *
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
     D PMode           S              6A                                                    MD021318
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      **********************************************************************
      /EJECT
      **********************************************************************
     C
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Validate primary screen details
     C                   Exsr      ValScrn1
      *
      **  Set returned values in screen fields from validation module
     C                   Exsr      SetScrnFld
      *
      **  Set error flags
     C                   Exsr      SetFlags
      *
      **  Set fields on valid file layout if no errors
     C     Idx           Ifeq      *Zero
     C                   Exsr      SetValFlds
     C                   Endif
      *
      **  Return to calling program
     C                   Return
      *
      /EJECT
      **********************************************************************
      * INIT - Initialisation Processing each time module is invoked
      **********************************************************************
     C     INIT          Begsr
      *
      **  If action is 'I' then default branch code if not entered
     C     SACTION       Ifeq      'I'
     C     SBRCA         andeq     *Blanks
     C                   Move      @DFBR         SBRCA
     C                   Endif
      *
      **  Reset all fields in data structure layout of FTOPY1PD
     C                   Clear                   OPAYDtls1
      *
      **  Move value of primary screen fields to layout of FTOPY1PD
     C                   Move      SACTION       SSACTION
     C                   Move      SDRCY         SSSMCY
     C                   Move      SCRCY         SSPCCY
     C                   Move      SBRCA         SSBRCA
     C                   Move      SORBR         SSORBR
     C                   Move      SPYTP         SSPYTP
     C                   Move      SPYST         SSPYST
     C                   Move      SSTMT         SSSTTP
     C                   Move      SSWPC         SSSWPC
     C                   Move      SDST1         SSDST1
     C                   Move      SDST2         SSDST2
     C                   Move      SDST3         SSDST3
     C                   Move      SDST4         SSDST4
     C                   Move      SODMT         SSODMT
     C                   Move      SORC1         SSORC1
     C                   Move      SORC2         SSORC2
     C                   Move      SORC3         SSORC3
     C                   Move      SORC4         SSORC4
     C                   Move      SORC5         SSORC5                                     BUG14716
     C                   Move      SORBK         SSORBK
     C                   Move      SORBB         SSORBB
     C                   Move      SSNCO         SSSNCO
     C                   Move      SSNMT         SSSNMT
     C                   Move      SPDSET        SSPDSET
     C                   Move      SOFCD         SSOFCD
     C                   Move      SADDC         SSADDC
     C                   Move      SBOKC         SSBOKC
     C                   Move      SPRFC         SSPRFC
      *
      ** Reset all error flags on layout of FTEOPY1PD
     C                   Move      *All'Y'       OkFlagsDS
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * ValScrn1 - Validate Primary Detail Screen
      **********************************************************************
     C     ValScrn1      Begsr
      *
      ** If Multi-Branching validate Booking and Originating branch
     C                   If        @MBIN = 'Y'
     C                   Exsr      VBRANCH
     C                   End
      *
      * Validate Payment Type & Sub-Type
     C                   Exsr      VPYTYP
      *
      * Validate Destination
     C                   Exsr      VDESTIN
      *
      * Validate Ordering Customer
     C                   Exsr      VORDCUS
      *
      * Validate MT100 Customer
     C                   Exsr      VODMTX
      *
      * Validate Order Bank
     C                   Exsr      VORDBNK
      *
      * Validate Sender's Correspondent
     C                   Exsr      VSNDCOR
      *
      * Validate Add Deduct Indicator
     C                   Exsr      VPPLCHG
      *
      * Validate Book Code
     C                   Exsr      VBKCODE
      *
      * Validate Profit Centre
     C                   If        @BKPRCU = 'Y'
     C                   Exsr      VPRFCTR
     C                   End
      *
      * Validate Settlement Type
     C                   Exsr      VSETTYP
      *
      * Validate Swift Code anf MT202 Indicator
     C                   Exsr      VSWIFT
      *
      * Validate FX spread set and payment date offset code
     C                   If        @CFT009 = 'Y'
     C                   Exsr      VFXSP
     C                   Exsr      VOFCD
     C                   Endif
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * SetScrnFld - Set Returned Values from Validation in Screen fields
      **********************************************************************
     C     SetScrnFld    Begsr
      *
      **  If '?' was entered the move returned value if selection made
     C                   Move      SSBRCA        SBRCA
     C                   Move      SSORBR        SORBR
     C                   Move      SSPYST        SPYST
     C                   Move      SSBOKC        SBOKC
     C                   Move      SSPRFC        SPRFC
     C                   Move      SSODMT        SODMT
     C                   Move      SSSNCO        SSNCO
      *
      **  Move defauted add/deduct indicator
     C                   Move      SSADDC        SADDC
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * SetFlags - Set error glags for return to calling program
      **********************************************************************
     C     SetFlags      Begsr
      *
      **  Set error flags on data structure layout of FTEOPSIPD
     C                   Move      SOKBRCA       OKBRCA
     C                   Move      SOKORBR       OKORBR
     C                   Move      SOKPYTP       OKPYTP
     C                   Move      SOKPYST       OKPYST
     C                   Move      SOKSTTP       OKSTMT
     C                   Move      SOKSWPC       OKSWPC
     C                   Move      SOKDST1       OKDST1
     C                   Move      SOKDST2       OKDST2
     C                   Move      SOKDST3       OKDST3
     C                   Move      SOKDST4       OKDST4
     C                   Move      SOKODMT       OKODMT
     C                   Move      SOKORC1       OKORC1
     C                   Move      SOKORC2       OKORC2
     C                   Move      SOKORC3       OKORC3
     C                   Move      SOKORC4       OKORC4
     C                   Move      SOKORC5       OKORC5                                     BUG14716
     C                   Move      SOKORBK       OKORBK
     C                   Move      SOKORBB       OKORBB
     C                   Move      SOKSNCO       OKSNCO
     C                   Move      SOKSNMT       OKSNMT
     C                   Move      SOKSPST       OKSPST
     C                   Move      SOKOFCD       OKOFCD
     C                   Move      SOKADDC       OKADDC
     C                   Move      SOKBOKC       OKBOKC
     C                   Move      SOKPRFC       OKPRFC
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * SetValFlds - Set Fields on Valid File Layout
      **********************************************************************
     C     SetValFlds    Begsr
      *
      **  Booking branch code.
     C                   Move      SBRCA         OVBRCA
      *
      **  Originating Branch
     C                   If        @MBIN = 'Y'
     C                   If        @BKOBRU = 'Y'
     C                   Eval      OVORBR = SORBR
     C                   Else
     C                   Eval      OVORBR = SBRCA
     C                   Endif
     C                   Else
     C                   Eval      OVORBR = BJSBRC
     C                   End
      *
      **  Payment type
     C                   Move      SPYTP         OVPYTP
      *
      **  Payment sub-type
     C                   Move      SPYST         OVPYST
      *
      **  Settlement type
     C                   Move      SSTMT         OVSTMT
      *
      **  Swift Priority.
     C                   Move      SSWPC         OVSWPC
      *
      **  Destination
     C                   Move      @@DSTT        OVDSTT
     C                   Move      SDST1         OVDST1
     C                   Move      SDST2         OVDST2
     C                   Move      SDST3         OVDST3
     C                   Move      SDST4         OVDST4
      *
      **  MT100 Customer.
     C                   Movel     SODMT         OVODMT
      *
      **  Ordering Customer.
     C                   Move      @@ORCT        OVORCT
     C                   Move      SORC1         OVORC1
     C                   Move      SORC2         OVORC2
     C                   Move      SORC3         OVORC3
     C                   Move      SORC4         OVORC4
     C                   Move      SORC5         OVORC5                                     BUG14716
      *
      **  Sender's Correspondent
     C                   Move      @@SNCT        OVSNCT
     C                   Move      SSNCO         OVSNCO
      *
      **  Ordering Bank and Branch Code
     C                   Move      @@ORBT        OVORBT
     C                   Move      SORBK         OVORBK
     C     @MBIN         Ifeq      'Y'
     C                   Move      SORBB         OVORBB
     C                   Endif
      *
      **  Send MT202
     C                   Move      SSNMT         OVSNMT
      *
      **  FX Spread set and Offset code
     C                   Move      SPDSET        OVSRSC
     C                   Move      SOFCD         OVOFCD
      *
      **  Add/Deduct Indicator
     C                   Move      SADDC         OVADDC
      *
      **  Book code
     C                   Move      SBOKC         OVBOKC
      *
      **  Profit Centre
     C                   Move      SPRFC         OVPRFC
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      ** VBRANCH  - Validate Booking/Originating Branches
      *****************************************************************
     C     VBRANCH       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVBKBH'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Outgoing Payment Primary Screen fields
     C                   Parm                    OPAYDtls1
      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    @RespMode
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      ** VPYTYP  - Validate Payment Type & Sub-Type
      *****************************************************************
     C     VPYTYP        Begsr
      *
      ** Default Deal Type/Sub type if action is insert
     C     SACTION       Ifeq      'I'
     C     SORC1         andne     *Blanks
      *
      ** Get customer details
     C                   Movel     SORC1         DDCUST            6
     C                   Callb     'AOCUSTR1'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm      DDCUST        @CUST            10
     C                   Parm                    @KEY7             7
     C     SDCUST        Parm      SDCUST        DSLDY
      *
      ** Default if customer is private banking client only
     C     BBPRBA        Ifeq      'Y'
     C     @RTCD         Andeq     *Blanks
     C                   Movel     BBCUST        P_Cust
     C                   Movel     SACTION       P_Action          1
     C                   Call      'PBDFST'
     C                   Parm                    P_Cust            6
     C                   Parm      *Blanks       P_DType           2
     C                   Parm      *Blanks       P_DSType          2
     C                   Parm                    P_Action          1
      *
      * Default Deal Type
     C     P_DType       Ifne      *Blanks
     C                   Eval      SPYTP = P_DType
     C                   Endif
      *
      * Default Deal Sub Type
     C     P_DSType      Ifne      *Blanks
     C                   Eval      SPYST = P_DSType
     C                   Endif
      *
     C                   Endif
     C                   Endif
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVPYTY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VDESTIN  - Validate Destination
      *****************************************************************
     C     VDESTIN       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVDNDN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              246034
     C                   Parm                    WFldNmXAr                                    246034
     C                   Parm                    WMsgIDXAr                                    246034
     C                   Parm                    WMsgDtaXAr                                   246034
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM      *BLANKS       PMode                                      MD021318
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VORDCUS  - Validate Ordering Customer
      *****************************************************************
     C     VORDCUS       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      ** Validate
     C                   CALLB     'FTVODCS'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
     C                   Parm                    OPAYDtls1x                                 BUG14716
     C/COPY OFCPYSRCZ,CFT148_024                                                              CFT148
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      * Warning fields/message IDs/message data (arrays) from/to caller                     BUG14716
     C                   Parm                    WFldNmXAr                                  BUG14716
     C                   Parm                    WMsgIDXAr                                  BUG14716
     C                   Parm                    WMsgDtaXAr                                 BUG14716
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *  Funds Transfer Details                                                               257758
     C                   Parm                    SDFTFR                                       257758
     C                   PARM                    CFT142                                     MD035360
      ** Screen Input Function                                                              MD021318
     C                   PARM      *BLANKS       PMode                                      MD021318
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VSNDCOR  - Validate Sender's Correspondent
      *****************************************************************
     C     VSNDCOR       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      *  Validate
     C                   CALLB     'FTVSNCR'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD035030
     C                   PARM                    WFldNmXAr                                  MD035030
     C                   PARM                    WMsgIDXAr                                  MD035030
     C                   PARM                    WMsgDtaXAr                                 MD035030
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM      *BLANKS       PMode                                      MD021318
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VORDBNK  - Validate Order Bank
      *****************************************************************
     C     VORDBNK       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      * Validate
     C                   CALLB     'FTVODBK'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD035030
     C                   PARM                    WFldNmXAr                                  MD035030
     C                   PARM                    WMsgIDXAr                                  MD035030
     C                   PARM                    WMsgDtaXAr                                 MD035030
      ** OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      ** Screen Input Function                                                              MD021318
     C                   PARM      *BLANKS       PMode                                      MD021318
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VPPLCHG - VALIDATE SETTLE PLUS CHARGES INDOCATOR
      *****************************************************************
     C     VPPLCHG       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVSEIN'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Bank ICD Details
     C                   Parm                    SDBANK
      *
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *  Funds transfer Details
     C                   Parm                    SDFTFR
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBKCODE - Validate Book Code
      *****************************************************************
     C     VBKCODE       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVBKCD'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VPRFCTR - Validate Profit Centre
      *****************************************************************
     C     VPRFCTR       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVPFPF'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VSETTYP - Validate Settlement Type
      *****************************************************************
     C     VSETTYP       Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      *  Validate
     C                   CALLB     'FTVSETY'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
      * OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VSWIFT - Validate Swift Code & MT202 Indicator
      *****************************************************************
     C     VSWIFT        Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      *  Validate
     C                   CALLB     'FTVSFIN'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      * OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      ** VODMTX - Validate MT100 Customer
      *****************************************************************
     C     VODMTX        Begsr
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      *  Validate
     C                   CALLB     'FTVCSNM'
      *  Return Code
     C                   Parm                    RetCodeOut
      *  Screen fields
     C                   Parm                    OPAYDtls1
     C                   PARM                    OPAYDtls1x                                 MD035030
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller                    MD035030
     C                   PARM                    WFldNmXAr                                  MD035030
     C                   PARM                    WMsgIDXAr                                  MD035030
     C                   PARM                    WMsgDtaXAr                                 MD035030
      * OK Flags
     C                   Parm                    OKFlagsDS
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
     C/EJECT
      *****************************************************************
      *                                                               *
      *  VFXSP     - Validate FX Spread Set                           *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVFXSP01  - FX Spread Set Validation Module                 *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
     C     VFXSP         Begsr
      *
      ** Reset variables updated by other modules
     C                   Exsr      RESETERRS
      *
      ** Validate FX Spread Set
     C                   CALLB     'FTVFXSP01'
     C                   PARM                    RETCODEOUT
     C                   PARM                    OPAYDtls1
     C                   PARM                    OPAYDtls1x
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
     C                   PARM                    OKFLAGSDS
     C                   PARM                    VAL@FIELDS
      *
      ** Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      *                                                               *
      *  VOFCD     - Validate Payment Date Offset Code                *
      *                                                               *
      *  Called By: Main Processing                                   *
      *                                                               *
      *  Calls:                                                       *
      *  RESETERRS  - Resets variables updated by each modules        *
      *  FTVPYCD    - Payment Date Offset Code Validation Module      *
      *  UPDATERRS  - Updates error information                       *
      *                                                               *
      *****************************************************************
     C     VOFCD         Begsr
      *
      ** Reset variables updated by other modules
     C                   Exsr      RESETERRS
      *
      ** Validate Payment Date Offset Code
     C                   CALLB     'FTVPYCD'
     C                   PARM                    RETCODEOUT
     C                   PARM                    OPAYDtls1
     C                   PARM                    OPAYDtls1x
     C                   PARM                    FLDNAMXAR
     C                   PARM                    MSGIDXAR
     C                   PARM                    MSGDTAXAR
     C                   PARM                    OKFLAGSDS
     C                   PARM                    VAL@FIELDS
      *
      ** Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************
     C     RESETERRS     Begsr
      *
     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtaXAr = *BlankS
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************
     C     UPDATERRS     Begsr
      *
      * Update error fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     FldNamXar     FldNameArr(#I)
     C                   Movea     MsgIDXAr      MsgIdArr(#I)
     C                   Movea     MsgDtaXAr     MsgDtaArr(#I)
     C                   End
      *
      * Set Error Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    FldNameArr(#I)                         99
     C                   Eval      Idx = #I - 1
      *
      * Update warning fields/message IDs/message data (arrays)
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   If        *IN99 = *On
     C                   Movea     WFldNmXAr     WFldNamArr(#I)
     C                   Movea     WMsgIDXAr     WMsgIDArr(#I)
     C                   Movea     WMsgDtaXAr    WMsgDtaArr(#I)
     C                   End
      *
      * Set Warning Index
     C                   Eval      #I = 1
     C     *Blank        Lookup    WFldNamArr(#I)                         99
     C                   Eval      WIdx = #I - 1
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * InitWrkFld - Initialise work fields passed to validation modules
      *****************************************************************
     C     InitWrkFld    Begsr
      *
      **  Pass switchable feature indicators
     C                   Move      @01494        @@01494
     C                   Move      @01499        @@01499
     C                   Move      @01506        @@01506
     C                   Move      @01508        @@01508
     C                   Move      @CEU006       @@CEU006
     C                   Move      @CFT003       @@CFT003
     C                   Move      @CFT004       @@CFT004
     C                   Move      @CFT007       @@CFT007
     C                   Move      @CFT009       @@CFT009
     C                   Move      @CFT010       @@CFT010
     C                   Move      @CFT014       @@CFT014
     C                   Move      @CSC011       @@CSC011
     C                   Move      @MBIN         @@MBIN
     C                   Move      @DFBR         @@DFBR
     C                   Move      @DPPT         @@DPPT
     C                   Move      @USRID        @@USRID
     C                   Move      @BCDP         @@BCDP
     C                   Move      @BVLD         @@BVLD
     C                   Move      @RUNN         @@RUNN
      *
     C                   Endsr
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        Begsr
      *
      ** Program entry parameter list
     C     *Entry        Plist
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
      ** Initialise program name
     C                   Movel     'FTOPSI1VL'   DBPGM
      *
      ** Initialise work fields to pass to validation modules
     C                   Exsr      InitWrkFld
      *
      ** Access bank details
     C                   Call      'AOBANKR0'
     C                   Parm      *BLANKS       @RTCD             7
     C                   Parm      '*FIRST '     @OPTN             7
     C     SDBANK        Parm      SDBANK        DSFDY
      *
      ** Database error
     C     @RTCD         Ifne      *BLANKS
     C                   Move      'SDBANKPD'    DBFILE
     C                   Move      '901'         DBASE
     C                   Move      @OPTN         DBKEY
     C                   Exsr      *PSSR
     C                   Endif
      *
     C                   EVAL      CFT142 = 'N'                                             MD035360
     C                   CALL      'AOSARDR0'                                               MD035360
     C                   PARM      *BLANKS       PRTCD                                      MD035360
     C                   PARM      '*VERIFY'     POPTN                                      MD035360
     C                   PARM      'CFT142'      PSARD                                      MD035360
     C                   IF        PRTCD = *BLANKS                                          MD035360
     C                   EVAL      CFT142 = 'Y'                                             MD035360
     C                   ENDIF                                                              MD035360
                                                                                            MD035360
     C                   Endsr
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
