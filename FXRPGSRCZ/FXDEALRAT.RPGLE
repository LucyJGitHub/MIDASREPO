     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FX Deal range authorization')                    *
      *****************************************************************
      *                                                               *
      *  Midas - Money Market Dealing Module                          *
      *                                                               *
      *  FXDEALRAT - FX DEAL RANGE AUTHORIZATION                      *
      *                                                               *
      *  Function:  This input function allows range authorization    *
      *             of all FX deals.                                  *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CDL099             Date 06Oct17               *
      *                 CSW212             Date 03May12               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CDL049             Date 07Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 CFX114             Date 15Jun04               *
      *                 CLE025             Date 20Oct03               *
      *                 BUG2113            Date 07May04               *
      *                 CGL029             Date 01Sep03               *
      *                 CAS004             Date 26Jun02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209009             Date 03Sep02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAS001             Date 23Nov01               *
      *                 CSC011             Date 18Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CDL008             Date 02May00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP052             Date 22Nov99               *
      *                 CAP051             Date 12Nov99               *
      *                 CPB001             Date 01Jun99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CAP002  *CREATE    Date 01May98               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CDL099 - Split Value Date (Recompile)                        *
      *  CSW212 - SWIFT 2012 Changes (Recompile)                      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  CFX114 - Core changes for GBO014                             *
      *         - Perform Override when Exchange Rate Tolerance is    *
      *           exceeded.                                           *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FXDEALGC05                       *
      *           Core hooks added:FXDEALGD02                         *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  BUG2113- Midasplus webfacing changes. Recompile due          *
      *           to changes in FXDEALRDF.                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAS004 - Hedge Accounting Phase A                            *
      *  209009 - STDDECLARE should be in ZACPYSRC and not in         *
      *           FXCPYSRC.                                           *
      *  CAS001 - Net Present Value (NPV) Accounting (Recompile)      *
      *  CSC011 - 24x7 Midas Availability                             *
      *  CDL008 - Continuous Linked Settlement                        *
      *  CAP052 - Deal Range Authorisation (By Front Office Id)       *
      *  CAP051 - Automatic Authorisation (FX Part)                   *
      *           Recompiled due to changes in FXDEALPP               *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to changes in FXDEALPP               *
      *  CAP002 - Conversion of FX inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************

     FFXDEALRDF CF   E             WORKSTN INFSR(*PSSR)

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

      ** Include the FX standard declares
     D*/COPY*FXCPYSRC,STDDECLARE***                                                           209009
     D/COPY ZACPYSRC,STDDECLARE                                                               209009

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS

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

      ** The maximum size of the error arrays
     D ArrayMax        C                   CONST(75)

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

      ** data structure for data to output 'authorized' message
     D @ADAT           DS            45
     D  @ADAT1                 1      6
     D  @ADAT2                 7     12
     D  @ADAT3                13     18

      ** data structure for data to output 'failed' message
     D @FDTA           DS            45
     D  @FDT1                  1      6
     D  @FDT2                  7     12
     D  @FDT3                 13     18
     D  @FDT4                 19     24
      *                                                                         CDL008
      ** Data structure for time                                                CDL008
     D                 DS                                                       CDL008
     D  Whhmmss                1      6  0                                      CDL008
     D  Whhmm                  1      4  0                                      CDL008
      *                                                                         CDL008
      ** Data structure for Date                                                CDL008
     D                 DS                                                       CDL008
     D  WDate                  1      6                                         CDL008
     D  WDD                    1      2                                         CDL008
     D  WMM                    3      4                                         CDL008
     D  WYY                    5      6                                         CDL008


      ** Array of Fields in error.
     D FldNameArr      S             10A   DIM(ArrayMax)

      ** Array of error message IDs
     D MsgIDArr        S                   DIM(ArrayMax) LIKE(#MsgID)

      ** Array of error message data.
     D MsgDtaArr       S                   DIM(ArrayMax) LIKE(#MsgData)

      ** Array of fields in with warning                                                      CAS004
     D WFldNamArr      S             10A   DIM(ArrayMax)                                      CAS004
                                                                                              CAS004
      ** Array of warning error message IDs                                                   CAS004
     D WMsgIDArr       S                   DIM(ArrayMax) LIKE(#MsgID)                         CAS004
                                                                                              CAS004
      ** Array of warning error message data                                                  CAS004
     D WMsgDtaArr      S                   DIM(ArrayMax) LIKE(#MsgData)                       CAS004

     D DEALFilFmt    E DS                  EXTNAME(FXDEALPP)


     D SDDEAL        E DS                  EXTNAME(SDDEALPD)
      ** EXTERNAL DS FOR DEALING DETAILS
      *                                                                         CDL008
      ** Externally described DS for bank details                               CDL008
     D SDBANK        E DS                  EXTNAME(SDBANKPD)                    CDL008
      *                                                                         CDL008
      ** Externally described DS for branch details                             CDL008
     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)                    CDL008
      *                                                                         CDL008
      ** Externally described DS for currency details                           CDL008
     D SDCURR        E DS                  EXTNAME(SDCURRPD)                    CDL008
      *                                                                         CDL008
      ** Externally described DS for customer details                           CDL008
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CDL008
     D SDCUSTDFAC    E                     EXTFLD(QQDFAC)                                     CGL029
      *                                                                         CDL008
      ** Externally described DS for switchable feature                         CDL008
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                    CDL008
      *                                                                         CDL008
      ** DS for access objects - Long data structure                            CDL008
     D DSSDY         E DS                  EXTNAME(DSSDY)                       CDL008
      *                                                                         CDL008
      ** DS for access objects - Very long data structure                       CDL008
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CDL008
                                                                                CDL008
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 status dataarea                                                                 CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD data area                                                                         CSC011
     D/COPY WNCPYSRC,FXDEALGD01

      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *                                                                         CDL008
     D ZDATIN          S              6A                                        CDL008
     D ZDAYNO          S              5P 0                                      CDL008
     D ZERR            S              1A                                        CDL008
     D WValDat         S              5P 0                                      CDL008
     D Wauthorised     S              1A                                        CDL008
     D PRtCd           S              7A                                        CDL008
     D POptn           S              7A                                        CDL008
     D PCcy            S              3A                                        CDL008
     D PKey1           S             10A                                        CDL008
     D PKyST           S              7A                                        CDL008
     D PBrCd           S              3A                                        CDL008
     D FWDNB           S              5P 0                                      CDL008
     D PEffDat         S              2  0                                      CDL008

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')
                                                                                              CSC011
     D CSC011          S              1A   INZ('N')                                           CSC011
     D WProcDate       S                   LIKE(BJRDNB)                                       CSC011
     D PSARD           S              6A                                                      CSC011

     D WIdx            S              3P 0                                                    CAS004
                                                                                              CAS004
     D/COPY WNCPYSRC,FXDEALGD02
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

      ** If authorizations are not required

     C     BNFXAU        IFEQ      'N'
     C                   EXSR      NOINPUT
     C                   END

      **  Main processing
      **  Loop until CK/3 taken

     C     *INKC         DOWEQ     '0'
     C                   EXSR      MAIN
     C                   END
      *
      * TERMINATE PROGRAM
      *
     C                   MOVE      '1'           *INLR

      *****************************************************************
      /EJECT
      *****************************************************************
      * MAIN - MAIN PROCESSING
      *****************************************************************
     C     MAIN          BEGSR

      ** Selection screen

     C                   TIME                    DDTIME
     C                   WRITE     FXDEALS0
     C                   WRITE     FXDEALD1
     C                   WRITE     FXDEALF1
     C                   READ      FXDEALD1                               99

      ** If CK/3 taken, bypass

     C     *INKC         CABEQ     '1'           EMAIN

      ** Validate screen input

     C                   EXSR      VALSIN

      ** If validation not OK, bypass

     C     *IN50         CABEQ     '1'           EMAIN

      ** Initialize count of authorizattions and failed authorizations

     C                   Z-ADD     0             @CNTAU            6 0
     C                   Z-ADD     0             @CNTFL            6 0

      ** Authorize all unauthorized FX deals

     C                   EXSR      AUTHFXDL

      ** Output authorized count message

     C                   MOVEL     'MMM0265'     @MSGID
     C                   MOVE      @CNTAU        @ADAT1
     C                   MOVE      @FSTDLNO      @ADAT2
     C                   MOVE      @LSTDLNO      @ADAT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @ADAT

      ** Output failure count message

     C     @CNTFL        IFNE      0
     C                   MOVEL     'MMM1047'     @MSGID
     C                   MOVE      @CNTFL        @FDT1
     C                   MOVE      @FSTDLNO      @FDT2
     C                   MOVE      @LSTDLNO      @FDT3
     C                   CALL      'ZA0440'
     C                   PARM                    @MSGID
     C                   PARM                    @FDTA
     C                   END
      *
     C     EMAIN         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * AUTHFXDL - Authorize all unauthorized FX deals
      *****************************************************************
     C     AUTHFXDL      BEGSR

      * Read FX deals

     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READFXDL

      ** Do while not EOF

     C     @ERRMS        DOWEQ     *BLANK

      ** If deal is not deleted

     C     FHDDLT        IFNE      'D'

      ** Error in retrieve

     C     Idx           IFNE      *ZERO
     C                   ADD       1             @CNTFL
     C                   ELSE
      *                                                                         CDL008
      ** If feature CDL008 is installed, perform extra validation               CDL008
      ** needed for CLS.                                                        CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
                                                                                CDL008
     C                   EVAL      Wauthorised = 'Y'                            CDL008
     C                   EXSR      ZCLSSVL                                      CDL008
                                                                                CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Bypass update if feature CDL008 is installed and deal cannot           CDL008
      ** be authorised.                                                         CDL008
     C                   IF        CDL008 = 'Y'                                 CDL008
     C                   IF        Wauthorised = 'Y'                            CDL008
      *                                                                         CDL008
      ** Update Fx deal                                                         CDL008
     C                   EXSR      UPDTFXDL                                     CDL008
     C                   ENDIF                                                  CDL008
     C                   ELSE                                                   CDL008

      ** Update Fx deal

     C                   EXSR      UPDTFXDL
     C                   ENDIF                                                  CDL008
     C                   END
     C                   END

      * Read FX Deals

     C                   EXSR      READFXDL
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CDL008
      *****************************************************************         CDL008
      *                                                               *         CDL008
      *  ZCLSSVL - Validation subroutine for CLS settlement.          *         CDL008
      *                                                               *         CDL008
      *****************************************************************         CDL008
     C     ZCLSSVL       BEGSR                                                  CDL008
                                                                                CDL008
     C                   IF        FHCLSS = 'Y'                                 CDL008
      *                                                                         CDL008
      ** Convert FX deal value date to midas day number.                        CDL008
     C                   MOVE      *BLANKS       ZDATIN                         CDL008
     C                   MOVE      FHVDYY        WYY                            CDL008
     C                   MOVE      FHVDDD        WDD                            CDL008
     C                   MOVE      FHVDMM        WMM                            CDL008
                                                                                CDL008
     C                   CALLB     'ZDATE1'                                     CDL008
     C                   PARM      WDate         ZDATIN                         CDL008
     C                   PARM      0             ZDAYNO                         CDL008
     C                   PARM                    BJDFIN                         CDL008
     C                   PARM      ' '           ZERR                           CDL008
                                                                                CDL008
     C                   Z-ADD     ZDAYNO        WValDat                        CDL008
      *                                                                         CDL008
      ** Buy currency.                                                          CDL008
     C                   CALLB     'AOCURRR0'                                   CDL008
     C                   PARM      *BLANKS       PRtCd                          CDL008
     C                   PARM      '*KEY   '     POptn                          CDL008
     C                   PARM      FHCCY1        PCcy                           CDL008
     C     SDCURR        PARM      SDCURR        DSSDY                          CDL008
                                                                                CDL008
     C                   IF        PRtCd = *BLANKS                              CDL008
      *                                                                         CDL008
      ** Currency is not CLS supported, issue error.                            CDL008
     C                   IF        A6CLSC <> 'Y'                                CDL008
     C                   MOVEL     'FXM2001'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Deal value date is less than the effectivity date of the               CDL008
      ** buy currency.                                                          CDL008
     C                   IF        WValDat < A6EFDT                             CDL008
     C                   MOVEL     'FXM2002'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   ENDIF                                                  CDL008
                                                                                CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Sell currency.                                                         CDL008
     C                   CALLB     'AOCURRR0'                                   CDL008
     C                   PARM      *BLANKS       PRtCd                          CDL008
     C                   PARM      '*KEY   '     POptn                          CDL008
     C                   PARM      FHCCY2        PCcy                           CDL008
     C     SDCURR        PARM      SDCURR        DSSDY                          CDL008
                                                                                CDL008
     C                   IF        PRtCd = *BLANKS                              CDL008
      *                                                                         CDL008
      ** Currency is not CLS supported, issue error.                            CDL008
     C                   IF        A6CLSC <> 'Y'                                CDL008
     C                   MOVEL     'FXM2003'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Deal value date is less than the effectivity date of the               CDL008
      ** sell  currency.                                                        CDL008
     C                   IF        WValDat < A6EFDT                             CDL008
     C                   MOVEL     'FXM2004'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   ENDIF                                                  CDL008
                                                                                CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Access deal's customer details.                                        CDL008
     C                   MOVEL     FHDCNO        PKey1                          CDL008
     C                   CALLB     'AOCUSTR1'                                   CDL008
     C                   PARM      *BLANKS       PRtCd                          CDL008
     C                   PARM      '*KEY   '     POptn                          CDL008
     C                   PARM                    PKey1                          CDL008
     C                   PARM      *BLANKS       PKyST                          CDL008
     C     SDCUST        PARM      SDCUST        DSLDY                          CDL008
                                                                                CDL008
     C                   IF        PRtCd = *BLANKS                              CDL008
      *                                                                         CDL008
      ** If effectivity date of the customer has not been reached,              CDL008
      ** issue error.                                                           CDL008
     C                   IF        WValDat < BBEFDT                             CDL008
     C                   MOVEL     'FXM2005'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   ENDIF                                                  CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Access deal's booking branch details.                                  CDL008
     C                   CALL      'AOBRCHR1'                                   CDL008
     C                   PARM      *BLANKS       PRtCd                          CDL008
     C                   PARM      '*KEY   '     POptn                          CDL008
     C                   PARM      FHDBRC        PBrCd                          CDL008
     C     SDBRCH        PARM      SDBRCH        DSSDY                          CDL008
                                                                                CDL008
     C                   IF        PRtCd = *BLANKS                              CDL008
     C                   Z-ADD     A8EDAT        PEffDat                        CDL008
     C                   CALLB     'ZFWDT'                                      CDL008
     C**********         PARM                    BJRDNB                                CDL008 CSC011
     C                   PARM                    WProcDate                                    CSC011
     C                   PARM                    PEffDat                        CDL008
     C                   PARM                    FWDNB                          CDL008
     C                   PARM                    BJLCCY                         CDL008
     C                   PARM                    BJSLCD                         CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Eligible date for CLS deal has not been reached, deal                  CDL008
      ** cannot be authorised.                                                  CDL008
     C                   IF        FWDNB > WValDat                              CDL008
     C                   MOVEL     'FXM2016'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   EVAL      Wauthorised = 'N'                            CDL008
     C                   ENDIF                                                  CDL008
      *                                                                         CDL008
      ** Time of authorisation for the deal is later than the                   CDL008
      ** CLS cut-off time. Deal cannot be authorised.                           CDL008
     C                   TIME                    Whhmmss                        CDL008
     C                   IF        FWDNB = WValDat AND                          CDL008
     C                             Whhmm > A8COTI                               CDL008
     C                   MOVEL     'FXM2017'     @MSGID                         CDL008
     C                   CALL      'ZA0240'                                     CDL008
     C                   PARM                    @MSGID                         CDL008
     C                   MOVE      '1'           *IN10                          CDL008
     C                   MOVE      '1'           *IN11                          CDL008
     C                   EVAL      Wauthorised = 'N'                            CDL008
     C                   ENDIF                                                  CDL008
                                                                                CDL008
     C                   ENDIF                                                  CDL008
                                                                                CDL008
     C                   ENDSR                                                  CDL008
      *                                                                         CDL008
      *****************************************************************         CDL008
      /EJECT
      *****************************************************************
      * UPDTFXDL - UPDATE FX DEAL
      *****************************************************************
     C     UPDTFXDL      BEGSR
      *
      * UPDATE VALID DEAL: LAST ACTION CODE
      *
     C                   MOVEL     DDACTN        FHLACT
      *
      * FOREIGN EXCHANGE DATABASE UPDATES
      *
     C                   CALLB     'FXFXDLUPF'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM                    DEALFilFmt
     C/COPY WNCPYSRC,FXDEALGC05
      *
      * DEALS UPDATES
      *
     C     @RTCD         IFEQ      *BLANK
     C                   CALLB     'FXFXDLUPD'
     C                   PARM                    @RTCD
     C                   PARM                    DEALFilFmt
     C                   END
     C/COPY WNCPYSRC,FXDEALGC01
      *
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     @RTCD         IFNE      *BLANK
     C                   ROLBK
     C                   EXSR      *PSSR
     C                   ELSE
     C                   COMMIT
     C/COPY WNCPYSRC,FXDEALGC04
     C                   ADD       1             @CNTAU
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * READFXDL - READ THROUGH FX DEALS
      *****************************************************************
     C     READFXDL      BEGSR
      *
     C                   CALLB     'FXFXDLRED'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *                                                                         CAP052
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)                    CAP052
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)                CAP052
      *                                                                         CAP052
     C                   PARM      '      '      @@MODE            6            CAP052
      *
      * ACTION CODE
     C                   PARM      'X'           DDACTN            1
      *
      * DEAL NUMBER POINTER
     C                   PARM                    DDDLNO            6
      *                                                                         CAP052
      * Front Office ID                                                         CAP052
     C                   PARM                    DDFRTN           20            CAP052
      *
      * READ FORWARDS
     C                   PARM      'Y'           @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM      *BLANK        @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * ERROR MESSAGE
     C                   PARM      *BLANK        @ERRMS            7
      *
      * DEAL NUMBER READ
     C                   PARM      *BLANK        @DLRED            6
      *                                                                         CAP052
      * Front Office ID READ                                                    CAP052
     C                   PARM      *BLANK        @FTRED           20            CAP052
      *
      * If no deal read, treat like EOF
      *
     C     @DLRED        IFEQ      *BLANK
     C                   MOVEL     '*EOF'        @ERRMS
     C                   END
      *
      * If error message returned from read, then it is EOF
      *
     C     @ERRMS        CABNE     *BLANK        EREADFXDL
      *
      * Check whether past last deal number
      *
     C                   MOVEL     @DLRED        @CURDLNO          6 0
     C     @CURDLNO      IFGT      @LSTDLNO
     C                   MOVEL     '*EOF'        @ERRMS
      *
      * Retrieve deal details
      *
     C                   ELSE
     C                   MOVEL     @DLRED        DDDLNO
     C                   EXSR      RTVFXDL
     C                   END
      *
     C     EREADFXDL     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVFXDL - RETRIEVE FX DEAL
      *****************************************************************
     C     RTVFXDL       BEGSR
      *
      * RETRIEVE DEAL
      *
     C                   CALLB     'FXFXDLRTV'
      *
      * INPUTS
      *
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
      *
     C                   PARM      '      '      @@MODE            6
      *
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      *
      * Action Code
     C                   PARM                    DDACTN
      *
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      *
      * Front Office Associated Transaction Id
     C                   PARM                    FOASID           20
      *
      * (Midas) Deal Number
     C                   PARM                    DDDLNO            6
      *
      * (Midas) Swap/Option Deal Number
     C                   PARM                    DDSDNO            6
      *
      * Booking branch
     C                   PARM                    DDBRSN            3
      *
      * Originating branch
     C                   PARM                    DDORBR            3
      *
      * OUTPUTS
      *
      * Deal in file format
     C                   PARM                    DEALFilFmt
      *
      * OK - Action code
     C                   PARM      *BLANK        OKACTN            1
      *
      * OK - Deal Number
     C                   PARM      *BLANK        OKDLNO            1
      *
      * OK - Booking branch
     C                   PARM      *BLANK        OKBRSN            1
      *
      * OK - Originating branch
     C                   PARM      *BLANK        OKORBR            1
      *
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx               3 0
     C/COPY WNCPYSRC,FXDEALGC02
                                                                                              CAS004
      ** Warning error fields/message IDs/message data (arrays) from/to caller                CAS004
                                                                                              CAS004
     C                   PARM      *BLANKS       WFldNamArr                                   CAS004
     C                   PARM      *BLANKS       WMsgIdArr                                    CAS004
     C                   PARM      *BLANKS       WMsgDtaArr                                   CAS004
                                                                                              CAS004
      ** Warning array index (3P0) from/to caller                                             CAS004
                                                                                              CAS004
     C                   PARM      *ZEROS        WIdx                                         CAS004
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VALSIN   - VALIDATE SCREEN INPUT
      *****************************************************************
     C     VALSIN        BEGSR
      *
      ** Clear the message queue & init error indicators
      *
     C                   CALL      'ZA0250'
     C                   MOVE      '0'           *IN50
     C                   MOVE      '0'           *IN10
     C                   MOVE      '0'           *IN11
      *
      ** First deal number must be numeric
      *
     C                   TESTN                   DDFDLN               9697
     C     DDFDLN        IFEQ      *BLANKS
     C     *IN96         ORNE      '1'
     C     *IN97         ANDNE     '1'
     C                   MOVEL     'FXM0262'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN10
     C                   END
      *
      ** Second deal number must be numeric
      *
     C                   TESTN                   DDLDLN               9697
     C     DDLDLN        IFEQ      *BLANKS
     C     *IN96         ORNE      '1'
     C     *IN97         ANDNE     '1'
     C                   MOVEL     'FXM0262'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN11
     C                   END
      *
      ** Numeric errors, no more checking
      *
     C     *IN50         CABEQ     '1'           EVALSI
      *
      ** Second number not less than first number
      *
     C                   MOVE      DDLDLN        @LSTDLNO          6 0
     C                   MOVE      DDFDLN        @FSTDLNO          6 0
     C     @LSTDLNO      IFLT      @FSTDLNO
     C                   MOVEL     'FXM0263'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN11
     C                   GOTO      EVALSI
     C                   END
      *
      ** Look for at least one deal
      *
     C     @FSTDLNO      SUB       1             @F_1DLNO          6 0
     C                   MOVEL     @F_1DLNO      DDDLNO
     C                   EXSR      READFXDL
      *
      ** Error if not at least one record to authorize
      *
     C     @ERRMS        IFNE      *BLANK
     C                   MOVEL     'MMM1029'     @MSGID
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID
     C                   MOVE      '1'           *IN50
     C                   MOVE      '1'           *IN10
     C                   END
      *
     C     EVALSI        ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * NOINPUT - NO INPUT SCREEN
      *****************************************************************
     C     NOINPUT       BEGSR
      *
      ** Write message, present screen and end program
      *
     C                   MOVEL     'MMM0159'     @MSGID           10
     C                   CALL      'ZA0240'
     C                   PARM                    @MSGID

     C                   MOVE      '1'           *IN13
     C                   TIME                    DDTIME
     C                   WRITE     FXDEALS0
     C                   WRITE     FXDEALD1
     C                   WRITE     FXDEALF1
     C                   READ      FXDEALD1                               99

     C                   SETON                                        LR
     C                   RETURN

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'FXDEALRAT'   DBPGM
      *
      ** Set up subfile message queue information
      *
     C                   MOVEL     '*'           DDPGMQ
     C                   MOVE      '1'           *IN40
      *
      ** Move workstation ID to screen field.
      *
     C                   MOVEL     PsJobName     DDWID
      *
      ** Get DEALING ICD
      *
     C**********         CALLB     'AODEALR0'                                                 CGL029
     C                   CALLB     'AODEALR1'                                                 CGL029
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDDEAL        PARM      SDDEAL        DSFDY                                        CGL029
     C     SDDEAL        PARM      SDDEAL        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDDEALPD'    DBFILE                         ************
     C                   MOVEL     '900'         DBASE                          * DBERR 901*
     C                   MOVEL     @OPTN         DBKEY                          ************
     C                   EXSR      *PSSR
     C                   END
      *                                                                         CDL008
      ** Access bank details                                                    CDL008
      *                                                                         CDL008
     C                   CALL      'AOBANKR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*FIRST '     @OPTN                          CDL008
     C     SDBANK        PARM      SDBANK        DSFDY                          CDL008
      *                                                                         CDL008
      ** Database error                                                         CDL008
      *                                                                         CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C                   MOVEL     'SDBANKPD'    DBFILE                         CDL008
     C                   MOVEL     '901'         DBASE                          CDL008
     C                   MOVEL     @OPTN         DBKEY                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   END                                                    CDL008
      *                                                                         CDL008
      ** Access SAR details file to determine if CDL008 is on.                  CDL008
      ** (Continuous Linked Settlement)                                         CDL008
      *                                                                         CDL008
     C                   CALLB     'AOSARDR0'                                   CDL008
     C                   PARM      *BLANKS       @RTCD                          CDL008
     C                   PARM      '*VERIFY'     @OPTN                          CDL008
     C                   PARM      'CDL008'      @SARD                          CDL008
     C     SCSARD        PARM      SCSARD        DSFDY                          CDL008
     C     @RTCD         IFNE      *BLANKS                                      CDL008
     C     @RTCD         ANDNE     '*NRF   '                                    CDL008
     C                   MOVEL     'SCSARDPD'    DBFILE                         CDL008
     C                   MOVEL     '902'         DBASE                          CDL008
     C                   MOVEL     'CDL008'      DBKEY                          CDL008
     C                   EXSR      *PSSR                                        CDL008
     C                   ENDIF                                                  CDL008
     C     @RTCD         IFEQ      *BLANKS                                      CDL008
     C                   MOVEL     'Y'           CDL008            1            CDL008
     C                   ELSE                                                   CDL008
     C                   MOVEL     'N'           CDL008                         CDL008
     C                   ENDIF                                                  CDL008
                                                                                              CSC011
      ** Check if CSC011 is installed                                                         CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *Blanks                                            CSC011
                                                                                              CSC011
     C                   EVAL      CSC011 = 'Y'                                               CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
                                                                                              CSC011
     C                   ELSE                                                                 CSC011
                                                                                              CSC011
      ** Database error                                                                       CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> '*NRF'                                            CSC011
     C     *LOCK         IN        LDA                                                        CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 903                                                CSC011
     C                   OUT       LDA                                                        CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If 24X7 Midas availability is installed and support system is                        CSC011
      ** active, used processing date from dataarea SC24X7 as the                             CSC011
      ** rundate.                                                                             CSC011
                                                                                              CSC011
     C                   IF        CSC011 = 'Y' AND                                           CSC011
     C                             S1SUPP = LIBR                                              CSC011
     C                   EVAL      WProcDate = S1DATE                                         CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      WProcDate = BJRDNB                                         CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FXDEALGC03

     C                   ENDSR
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
(c) Finastra International Limited 2001
