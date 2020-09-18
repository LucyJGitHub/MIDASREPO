     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing Payments Insert Screen Validn')      *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY7VL - Outgoing Payments SSI Initial Insert validation  *
      *                                                               *
      *                                                               *
      *  (c) Finastra International Limited 2002                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 CFT157             Date 29Aug14               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 246034             Date 18Apr07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CFT018  *CREATE    Date 29Nov02               *
      *                                                               *
      *****************************************************************
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  246034 - Apply 240689 to FTOPSI1VL and FTOPAY7VL: incorrect  *
      *           parameters on call of FTVDNDN missing fix 240689    *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
      ** Table of field numbers and names
     FZAFLDNPD  IT   F   15        DISK    INFSR(*pssr)
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
      ** The following /COPY line includes all the definitions of the error
      ** arrays, including the named constant giving the size of
      ** the arrays.  Note that it uses #MsgID and *MsgData, and so requires
      ** STD_D_SPEC.
     D/COPY ZACPYSRC,FVAL_ARRAY
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,APICTLARR
      **                                                                    ------------------------
      ** The following /COPY line includes the definitions for fields
      ** required by the message handler.
     D/COPY ZACPYSRC,MSGHNDDCL
      **                                                                    ------------------------
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
     D Idx             S              3P 0
      *
     D #I              S              2  0
      *
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
      *
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
     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD) PREFIX(X)
      * Current Outgoing Payment SSI in Screen Format
      *
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD)
      * Current Outgoing Payment SSI in Screen Format
      *
     D FTEOPY7       E DS                  EXTNAME(FTEOPY7PD)
      * Error indicators - SSI Payment Insert Screen
      *
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD) PREFIX(S)
      * Flags to indicate whether transaction fields are valid
      *
     D NewPmtScn1    E DS                  EXTNAME(FTOPY1PD) PREFIX(S)
      * New Payment in Screen Format (Primary screen)
     D NewPmtSc1b    E DS                  EXTNAME(FTOPY1APD)PREFIX(S)
      ** New Payment in Screen Format (Primary Screen definition 2)
     D NewPmtSc2a    E DS                  EXTNAME(FTOPY2PD) PREFIX(S)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtSc2b    E DS                  EXTNAME(FTOPY3PD) PREFIX(S)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtScn3    E DS                  EXTNAME(FTOPY4PD) PREFIX(S)
      * New Payment in Screen Format (Charges/Commissions screen)
     D NewPmtSc3b    E DS                  EXTNAME(FTOPY5PD) PREFIX(S)
      ** New Payment in Screen Format (Lvl 2 Screen 3 definition 2)
     D NewPmtScn4    E DS                  EXTNAME(FTOPY6PD) PREFIX(S)
      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)
     D NewPmtScn5    E DS                  EXTNAME(FTOPY7PD) PREFIX(S)
      ** New Payment in Screen Format (Margin Information Screen)
     D NewPmtScn7    E DS                  EXTNAME(FTOPY8PD)
      *  New Payment in Screen Format (SSI Insert Screen)
      *
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
      * Validation Work Fields
      *
     D ACCNT         E DS                  EXTNAME(ACCNTAB )
      * External data structure for currency codes
     D                                     PREFIX(AC)
      *
     D W@DRAC          DS
      * Data structure for debit acount
     D W@Retl                  1     10
     D*W@Blnks**              11     15                                                       CGL029
     D W@Blnks                11     21                                                       CGL029
     D W@Cust                  1      6
     D W@Acod                  7     16                                                       CGL029
     D W@Acsq                 17     18                                                       CGL029
     D W@Brch                 19     21                                                       CGL029
     D*W@Acod***               7     10                                                       CGL029
     D*W@Acsq***              11     12                                                       CGL029
     D*W@Brch***              13     15                                                       CGL029
      *
     D/COPY WNCPYSRC,FTH00376
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
      *
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CFT120
      *                                                                                       CFT120
      ** Switchable Features File                                                             CFT120
      *                                                                                       CFT120
     D PAcod           S             10A                                                      CGL029
                                                                                              CFT120
     D CFT120          S              1A                                                      CFT120
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
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
      *
      **  Initialisation
     C                   Exsr      INIT
      *
      **  Validate primary screen details
     C                   Exsr      ValScrn
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
      **  Clear OPAY screen layouts
     C                   Clear                   NewPmtScn1
     C                   Clear                   NewPmtSc1b
     C                   Clear                   NewPmtSc2a
     C                   Clear                   NewPmtSc2b
     C                   Clear                   NewPmtScn3
     C                   Clear                   NewPmtSc3b
     C                   Clear                   NewPmtScn4
     C                   Clear                   NewPmtScn5
      *
      **   Move SSI details to Outgoing Payment fields
     C                   Exsr      SetOpay
      *
      **  Move value of screen fields to equivalent field in
      **  FTOPY1PD/FTOPY4PD for calls to validation modules
     C                   Move      'I'           SSACTION
     C                   Move      SDRCY         SSSMCY
     C                   Move      SCRCY         SSPCCY
     C                   Move      SSMAM         SSSMAM
     C                   Move      SPYAM         SSPYAM
     C                   Move      SPYDT         SSPYDT
     C                   Move      SPYVD         SSPYVD
     C                   Move      SRATE         SSRATE
     C                   Move      SOVRD         SSOVRD
     C                   Move      SDTP1         SSDTP1
     C                   Move      SDTP2         SSDTP2
     C                   Move      SDTP3         SSDTP3
     C                   Move      SDTP4         SSDTP4
     C                   Move      SBBI1         SSBBI1
     C                   Move      SBBI2         SSBBI2
     C                   Move      SBBI3         SSBBI3
     C                   Move      SBBI4         SSBBI4
     C                   Move      SBBI5         SSBBI5
     C                   Move      SBBI6         SSBBI6
      *
      ** Reset all error flags on layout of FTEOPY1PD/FTEOPY7PD
     C                   Move      *All'Y'       FTEOPY1
     C                   Move      *All'Y'       FTEOPY7
      *
     C                   Endsr
      /EJECT
      **********************************************************************
      * ValScrn - Validate Detail Screen
      **********************************************************************
     C     ValScrn       Begsr
      *
      * Validate Debit Account if payment not to be created from SSI
     C     @CrtPmnt      Ifne      'Y'
     C                   Exsr      VDRAC
     C                   Endif
      *
      * Validate Credit Account if payment not to be created from SSI
     C     @CrtPmnt      Ifne      'Y'
     C                   Exsr      VCRAC
     C                   Endif
      *
      * Validate Settle Currency & Amount
     C                   Exsr      VSETCA
      *
      * Validate Pay Currency & Amount
     C                   Exsr      VPAYCA
      *
      * Validate Settle Date
     C                   Exsr      VSETDAT
      *
      * Validate Pay Date
     C                   Exsr      VPVDTAT
      *
      * Validate Override indicator
     C                   Exsr      VOVRRDE
      *
      * Validate entered amounts and rate agree
     C     Idx           Ifeq      0
     C                   Exsr      VEUXCHK
     C                   End
      *
     C                   Endsr
      /EJECT
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDRAC - Validate Settlement Account
      *****************************************************************
     C     VDRAC         BEGSR
 
      * Reset variables updated by each module
     C                   Z-add     0             Ix                3 0
      *
      **  Debit Account must be entered
     C     SDRAC         Ifeq      *Blanks
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0153'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  Determine if retail account number or Midas account reference
     C                   Movel     SDRAC         W@DRAC
     C     W@Blnks       Ifeq      *Blanks
     C                   Movel     W@Retl        @Retl
     C                   Movel     *Blanks       @Cust
     C                   Movel     *Blanks       @Cycd
     C**********         Movel     *Blanks       @Acod                                        CGL029
     C                   MOVE      *BLANKS       PAcod                                        CGL029
     C                   Movel     *Blanks       @Acsq
     C                   Movel     *Blanks       @Brch
     C                   Else
     C                   Movel     *Blanks       @Retl
     C                   Movel     W@Cust        @Cust
     C                   Movel     SDRCY         @Cycd
     C**********         Movel     W@Acod        @Acod                                        CGL029
     C                   MOVEL     W@Acod        PAcod                                        CGL029
     C                   Movel     W@Acsq        @Acsq
     C                   Movel     W@Brch        @Brch
     C                   Endif
      *
      **  Debit account must reference Midas Account
     C                   Call      'AOACCTR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*KEY    '    @OPTN
     C                   Parm                    @Retl            10
     C                   Parm                    @Cust             6
     C                   Parm                    @Cycd             3
     C**********         Parm                    @Acod             4                          CGL029
     C                   PARM                    PAcod                                        CGL029
     C                   Parm                    @Acsq             2
     C                   Parm                    @Brch             3
     C     ACCNT         Parm      ACCNT         DSSDY
     C     @RTCD         Ifne      *Blanks
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0157'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  If retail account number entered must be same ccy as debit ccy
     C     W@RETL        Ifne      *Blanks
     C     ACCCY         andne     SDRCY
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0158'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      **  Must be a live account
     C     ACRECI        Ifne      'D'
     C                   Move      'N'           OKDRAC
     C                   Add       1             Ix
     C                   Movel     'SDRAC'       FldNameArr(Ix)
     C                   Movel     'FTA0159'     MsgIdArr(Ix)
     C                   Goto      EndValDRAC
     C                   Endif
      *
      * Update error info with that returned from the validation module
     C                   Add       Ix            Idx
      *
     C     EndValDRAC    ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VCRAC - Validate Credit Account
      *****************************************************************
     C     VCRAC         BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      * Move credit account to destination
     C                   Movel     SCRAC         SSDST1
      *
      ** Validate destination
     C/COPY WNCPYSRC,FTH00377
     C                   CALLB     'FTVDNDN'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              246034
     C                   Parm                    WFldNmXAr                                    246034
     C                   Parm                    WMsgIDXAr                                    246034
     C                   Parm                    WMsgDtaXAr                                   246034
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTH00378
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKDST1       OKCRAC
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
     C     EndValCRAC    ENDSR
      *****************************************************************
      *****************************************************************
      ** VSETCA  - Validate Settle Currency & Amount
      *****************************************************************
     C     VSETCA        BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVSECY'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr                                    222373
     C                   Parm                    WMsgIDXAr                                    222373
     C                   Parm                    WMsgDtaXAr                                   222373
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKSMCY       OKDRCY
     C                   Move      SOKSMAM       OKSMAM
      *
      **  Reset screen fields with values returned from validation
     C     OKDRCY        Ifeq      'Y'
     C                   Move      SSSMCY        SDRCY
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPAYCA  - Validate Pay Currency & Amount
      *****************************************************************
     C     VPAYCA        BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVPYAM'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKPCCY       OKCRCY
     C                   Move      SOKPYAM       OKPYAM
      *
      **  Reset screen fields with values returned from validation
     C     OKDRCY        Ifeq      'Y'
     C                   Move      SSPCCY        SCRCY
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      ** VOVRRDE - Validate Override indicator
      *****************************************************************
     C     VOVRRDE       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVODIN'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKOVRD       OKOVRD
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSETDAT - Validate Settle date
      *****************************************************************
     C     VSETDAT       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVSEDT'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKPYDT       OKPYDT
      *
      **  Reset screen fields with values returned from validation
     C     OKPYDT        Ifeq      'Y'
     C                   Move      SSPYDT        SPYDT
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPVDTAT - Validate Pay date
      *****************************************************************
     C     VPVDTAT       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      ** Validate
     C                   CALLB     'FTVPYDT'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKPYVD       OKPYVD
      *
      **  Reset screen fields with values returned from validation
     C     OKPYVD        Ifeq      'Y'
     C                   Move      SSPYVD        SPYVD
     C                   Endif
      *
     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEUXCHK - Validate amounts entered agree
      *****************************************************************
     C     VEUXCHK       BEGSR
      *
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *
      * Validate
     C                   CALLB     'FTVAMAM'
     C                   Parm                    RetCodeOut
     C                   Parm                    NewPmtScn1
     C                   Parm                    NewPmtSc1b
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
     C                   Parm                    FTEOPY1
     C                   Parm                    Val@Fields
      *
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS
      *
      **  Set error indicator flag on FTOPY7PD
     C                   Move      SOKPYAM       OKPYAM
     C                   Move      SOKSMAM       OKSMAM
     C                   Move      SOKRATE       OKRATE
      *
      **  Reset screen fields with values returned from validation
     C     OKSMAM        Ifeq      'Y'
     C                   Move      SSSMAM        SSMAM
     C                   Endif
     C     OKPYAM        Ifeq      'Y'
     C                   Move      SSPYAM        SPYAM
     C                   Endif
     C     OKRATE        Ifeq      'Y'
     C     OKSMAM        andeq     'Y'
     C     OKPYAM        andeq     'Y'
     C                   Move      SSRATE        SRATE
     C                   Move      SSOVRD        SOVRD
     C                   Endif
      *
     C                   Endsr
      *****************************************************************
     C/EJECT
      *****************************************************************
      * SetOpay - Move SSI Screen Format Fields to OPAY Screen Fields
      *****************************************************************
     C     SetOpay       Begsr
      *
      **  Set action code to insert
     C                   Move      'I'           SSACTION
      *
      **  If payment to be created from SSI then default fields
     C     @CrtPmnt      Ifeq      'Y'
      *
      **  Move SSI details to layout of FTOPY1PD/FTOPY1APD
     C                   Move      XSDRCY        SSSMCY
     C                   Move      XSCRCY        SSPCCY
     C                   Move      XSBRCA        SSBRCA
     C                   Move      XSORBR        SSORBR
     C                   Move      XSPYTP        SSPYTP
     C                   Move      XSPYST        SSPYST
     C                   Move      XSSTMT        SSSTTP
     C                   Move      XSSWPC        SSSWPC
     C                   Move      XSDST1        SSDST1
     C                   Move      XSDST2        SSDST2
     C                   Move      XSDST3        SSDST3
     C                   Move      XSDST4        SSDST4
     C                   Move      XSODMT        SSODMT
     C                   Move      XSORC1        SSORC1
     C                   Move      XSORC2        SSORC2
     C                   Move      XSORC3        SSORC3
     C                   Move      XSORC4        SSORC4
     C                   Move      XSORBK        SSORBK
     C                   Move      XSORBB        SSORBB
     C                   Move      XSSNCO        SSSNCO
     C                   Move      XSSNMT        SSSNMT
     C                   Move      XSADDC        SSADDC
     C                   Move      XSBOKC        SSBOKC
     C                   Move      XSPRFC        SSPRFC
     C                   Move      XSOFCD        SSOFCD
      *
      **  Move SSI screen 2 fields to layout of FTOPY2PD
     C                   Move      XSBOCD        SSBOCD
     C                   Move      XSTTCD        SSTRTC
     C                   Move      XSRCO1        SSRCO1
     C                   Move      XSRCO2        SSRCO2
     C                   Move      XSRCO3        SSRCO3
     C                   Move      XSRCO4        SSRCO4
     C                   Move      XSRCO5        SSRCO5
     C                   Move      XSTRI1        SSTRI1
     C                   Move      XSTRI2        SSTRI2
     C                   Move      XSTRI3        SSTRI3
     C                   Move      XSTRI4        SSTRI4
     C                   Move      XSTRI5        SSTRI5
     C                   Move      XSINB1        SSINB1
     C                   Move      XSINB2        SSINB2
     C                   Move      XSINB3        SSINB3
     C                   Move      XSINB4        SSINB4
      *
      **  Move SSI screen 2 fields to layout of FTOPY3PD
     C                   Move      XSINB5        SSINB5
     C                   Move      XSACB1        SSACB1
     C                   Move      XSACB2        SSACB2
     C                   Move      XSACB3        SSACB3
     C                   Move      XSACB4        SSACB4
     C                   Move      XSACB5        SSACB5
     C                   Move      XSBNC1        SSBNC1
     C                   Move      XSBNC2        SSBNC2
     C                   Move      XSBNC3        SSBNC3
     C                   Move      XSBNC4        SSBNC4
     C                   Move      XSBNC5        SSBNC5
      *
      **  Move SSI screen 3 fields to layout of FTOPY4PD
     C                   Move      XSDTP1        SSDTP1
     C                   Move      XSDTP2        SSDTP2
     C                   Move      XSDTP3        SSDTP3
     C                   Move      XSDTP4        SSDTP4
     C                   Move      XSBBI1        SSBBI1
     C                   Move      XSBBI2        SSBBI2
     C                   Move      XSBBI3        SSBBI3
     C                   Move      XSBBI4        SSBBI4
     C                   Move      XSBBI5        SSBBI5
     C                   Move      XSBBI6        SSBBI6
     C                   Move      XSDNBC        SSDNBC
     C                   Move      XSCHAP        SSCHAP
     C                   Move      XSTRCT        SSTRCT
     C                   Movel     XSICD1        SSICD1
     C                   Movel     XSICD2        SSICD2
     C                   Movel     XSICD3        SSICD3
      *
      **  Move SSI screen 3 fields to layout of FTOPY5PD
     C                   Movel     XSICD4        SSICD4
     C                   Movel     XSICD5        SSICD5
     C                   Movel     XSRRP1        SSRRP1
     C                   Movel     XSRRP2        SSRRP2
     C                   Movel     XSRRP3        SSRRP3
      *
      **  Move SSI screen 3 fields to layout of FTOPY6PD
     C                   Move      XSCDRO        SSCDRO
     C                   Move      XSCDBR        SSCDBR
     C                   Move      XSDTCH        SSDTCH
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Move      XSCDRC        SSCDRC                                       CFT120
     C                   ENDIF                                                                CFT120
      *
     C                   Endif
      *
      *
      **  If payment not created from SSI then default debit account and
      **  credit account into the appropriate field on outgoing payment
     C     @CrtPmnt      Ifne      'Y'
     C                   Movel     SDRAC         SSORC1
     C                   Movel     SCRAC         SSDST1
     C                   Endif
      *
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
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Program entry parameter list
     C     *Entry        Plist
      *    Return code
     C                   Parm      *Blank        RetCodeOut
      *    Create new payment from SSI indictaor
     C                   Parm                    @CrtPmnt          1
      *    Screen format details for display
     C                   Parm                    NewPmtScn7
      *    SSI details in screen fields
     C                   Parm                    SSIScrnFmt
      *    Outgoing Payment in screen format
     C                   Parm                    NewPmtScn1
     C                   Parm                    NewPmtSc1b
     C                   Parm                    NewPmtSc2a
     C                   Parm                    NewPmtSc2b
     C                   Parm                    NewPmtScn3
     C                   Parm                    NewPmtSc3b
     C                   Parm                    NewPmtScn4
      **   OK inds
     C                   Parm                    FTEOPY7
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
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
      *
      ** Initialize program name
     C                   Movel     'FTOPAY7VL'   DBPGM
      *                                                                                       CFT120
      ** Check if CFT120 is switched on                                                       CFT120
      *                                                                                       CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       @RTCD             7                          CFT120
     C                   PARM      '*VERIFY'     @OPTN             7                          CFT120
     C                   PARM      'CFT120'      @SARD             6                          CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
      *                                                                                       CFT120
     C                   IF        @RTCD <> '*NRF '                                           CFT120
      *                                                                                       CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 001                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
     C/COPY WNCPYSRC,FTH00379
      *
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line sets up the fixed data for SD *DSP
      ** functions for the message handler, ZAMSGHNDLE.
      /COPY FTCPYSRC,MSGHNDDATA
      **--------------------------------------------------------------------------------------------
      *
     C                   ENDSR
      /EJECT
      *****************************************************************
      ** The following /COPY line includes the ProcMsgs subroutine
      ** to process error and warning messages.
     D/COPY ZACPYSRC,MSGHNDDSP2
      **                                                                    ------------------------
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
