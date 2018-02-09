     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2003')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Securities retrieve a record')                *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SESECSR - SE Securities retrieve a record                    *
      *                                                               *
      *  Function:  This module retrieves a record from the file      *
      *                                                               *
      *  (c) Finastra International Limited 2003                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. LLN022A            Date 03Jun15               *
      *                 LLN022             Date 03Jun15               *
      *                 BUG6218            Date 03Jun15               *
      *                 CRE073             Date 10Dec06               *
      *                 CER059             Date 19Jul10               *
      *                 BUG22120           Date 14Jan09               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CGL032             Date 05Jul04               *
      *                 CSE075             Date 17Nov05               *
      *                 CER001             Date 25Apr05               *
      *                 CSE074             Date 30Aug05               *
      *                 CSE071             Date 26May05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CGL014             Date 20Oct03               *
      *                 TDA035             Date 02Apr04               *
      *                 BUG156             Date 17Mar04               *
      *                 CAP084  *CREATE    Date 07Sep03               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  LLN022A - BOE Upgrade to MidasPlus - incorporate code from   *
      *            /COPY members and add switchability.               *
      *  LLN022 - BOE Upgrade to MidasPlus.                           *
      *           Core hooks added: SESECSAD01,SESECSAC01,SESECSAC02  *
      *                             SESECSAC03                        *
      *  BUG6218 - Extra data must be included in the buffer          *
      *  CRE073 - Interest Rate Rounding (Recompile)                  *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG22120 - Industry code becomes blank after authorisation   *
      *           (Recompile)                                         *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSE074 - Const. Yield Amort. on Mortgage backed assets       *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities                     *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CGL014 - Collaterals Processing                              *
      *  TDA035 - RTS Signon changes for MidasPlus. (Recompile)       *
      *  BUG1569- Stopping user updating the same record at the same  *
      *           time.                                               *
      *  CAP084 - Synchronous calling of APIs                         *
      *                                                               *
      *****************************************************************
 
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
 
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **-----------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY includes the standard API declares:
     D/COPY ZACPYSRC,STDDECLARE
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **-----------------------------------------------------------------------
 
      **-----------------------------------------------------------------------
     D/COPY ZACPYSRC,ERR_ARRAYS
      **-----------------------------------------------------------------------
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
      **-----------------------------------------------------------------------
      ** Screen formats
      **-----------------------------------------------------------------------
 
      * Securities screen format
      ** Securities screen 1 details from incoming transaction
      ** - screen format
     D Sect1ScnFmt   E DS                  EXTNAME(SESEC1PD)
      *
      ** Securities screen 2 details from incoming transaction
      ** - screen format
     D Sect2ScnFmt   E DS                  EXTNAME(SESEC2PD)
      *
      ** Securities screen 3 details from incoming transaction
      ** - screen format
     D Sect3ScnFmt   E DS                  EXTNAME(SESEC3PD)
      *
      ** Securities screen 4 details from incoming transaction
      ** - screen format
     D Sect4ScnFmt   E DS                  EXTNAME(SESEC4PD)
 
      ** Security Screen 5 Details From Incoming Transaction - Screen Format
     D Sect5ScnFmt   E DS                  EXTNAME(SESEC5PD)
                                                                                              CSE071
      ** Security Screen 6 Details From Incoming Transaction - Screen Format                  CSE071
     D Sect6ScnFmt   E DS                  EXTNAME(SESEC6PD)                                  CSE071
 
      **-----------------------------------------------------------------------
      ** File formats
      **-----------------------------------------------------------------------
 
     D SectFilFmt    E DS                  EXTNAME(SECTYD)
      ** Securities Detail file format
                                                                                             BUG6218
     D ExtData       E DS                  EXTNAME(SESEEXPD)                                 BUG6218
      ** Security Extra Data Layout                                                          BUG6218
      *                                                                                      BUG6218
 
      *                                                                                       CER001
      ** External DS for Extension File 1                                                     CER001
      *                                                                                       CER001
     D SecsLUX1FilFmtE DS                  EXTNAME(SESDX1PD)                                  CER001
                                                                                              CER001
      *                                                                                       CER001
      ** External DS for Extension File 2                                                     CER001
      *                                                                                       CER001
     D SecsLUX2FilFmtE DS                  EXTNAME(SESDX2PD)                                  CER001
                                                                                              CER001
      *                                                                                       CER001
      ** External DS for Extension File 3                                                     CER001
      *                                                                                       CER001
     D SecsLUX3FilFmtE DS                  EXTNAME(SESDX3PD)                                  CER001
     D                                     PREFIX(CR)                                         CER001
                                                                                              CER001
      *                                                                                       CER001
      ** External DS for RegData                                                              CER001
      *                                                                                       CER001
     D RegData       E DS                  EXTNAME(SESERXPD)                                  CER001
                                                                                              CER001
      **-----------------------------------------------------------------------
 
      ** Index for arrays of of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of warning message ids etc
     D WIdx            S              3P 0
 
      **-----------------------------------------------------------------------
      *
      ** Externally described DS for bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      *
      ** Externally described DS for securities trading ICD details
     D SDSTRD        E DS                  EXTNAME(SDSTRDPD)
      *
      ** Externally described DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      *
      ** Externally described DS for SAR details
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SLCD          E                     EXTFLD(LCD)
      *
      ** Externally described DS for investment types
     D PINVTP        E DS                  EXTNAME(INVTPD)
     D                                     PREFIX(P)
      *
      ** DS for access programs - short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
      *
      ** DS for access programs - long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SD Data Area
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)
      *
     D/COPY WNCPYSRC,SESECSAD01                                                               LLN022
      *                                                                                      LLN022A
      ** External DS for Securities Details Extension                                        LLN022A
      *                                                                                      LLN022A
     D SecsExFilFmt  E DS                  EXTNAME(BYSECTX0)                                 LLN022A
                                                                                             LLN022A
      ** DS for ZMUSER details
     D ZMUSER          DS            17
     D  PUSRID                 1     10
     D  PDBRN                 11     13
     D  PDPPT                 14     16
      *
     D D@USER        E DS                  EXTNAME(MUSERDD)
     D DRECI         E                     EXTFLD(RECI)
     D DLCD          E                     EXTFLD(LCD)
     D DCHTP         E                     EXTFLD(CHTP)
 
     D @RDFWD          S              1A
     D @RDBCK          S              1A
     D CEU018          S              1A
     D CSE005          S              1A
     D S01401          S              1A
     D CSE023          S              1A
     D CSD006          S              1A
     D CAP060          S              1A
     D CSE031          S              1A
     D CSE037          S              1A
     D CAS006          S              1A
     D CGL032          S              1A                                                      CGL032
     D ASDC1           S              6A
     D ASDC2           S              6A
     D ASDC3           S              6A
     D OKACTN          S              1A
     D OKSESN          S              1A
     D PErrMs          S              7A
     D PLCPN           S              6A
     D PMode           S              6A   INZ('      ')
     D PNCD            S              6A
     D POptn           S              7A
     D PParmLink       S              1A
     D PParmSESN       S             10A
     D PParOSESN       S             10A
     D PPOldSecDtl     S              1A   INZ(*BLANK)
     D PRespMode       S              1A   INZ('S')
     D PRtcd           S              7A
     D PSARd           S              6A
     D PSeSnSel        S             10A
      ** Passed other information
     D POthInf         DS           156
      *
      ** Data structure for key fields and key selections
     D KeyLists        DS
     D  WDSESN                 1     10A
     D  WDSRPN                11     30A
 
     D CGL014          S              1                                                       CGL014
     D CSE071          S              1                                                       CSE071
 
     D ULX610          S              1A                                                      CER001
      ** +--- Start of main processing -----------------------------------+
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
 
      * If the action code is blank, enquire unless authorising
     C                   CLEAR                   SectFilFmt
     C     DDACTN        IFEQ      *BLANK
     C     AuthComp      IFEQ      'X'
     C                   MOVEL     'X'           DDACTN
     C                   ELSE
     C                   MOVEL     'E'           DDACTN
     C                   ENDIF
     C                   ENDIF
 
     C     FwdBck        IFEQ      'F'
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ELSE
     C     FwdBck        IFEQ      'B'
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'N'           @RDFWD
     C                   MOVEL     'N'           @RDBCK
     C                   ENDIF
     C                   ENDIF
 
     C     @RDFWD        IFEQ      'Y'
     C     @RDBCK        OREQ      'Y'
     C                   EXSR      SESECSRED
     C                   MOVEL     PSeSnSel      DDSESN
     C                   ELSE
     C                   MOVEL     DDSESN_In     DDSESN
     C                   MOVEL     *BLANK        PErrMs
     C                   ENDIF
      *
      * If deal read and no error message returned
     C                   IF        ReturnCode = *BLANK and
     C                             DDSESN <> *Blank
      *
      * Retrieve deal details (all key fields required for call to rtv module)
     C                   EXSR      SESECSRTV
      *                                                                                       CER001
     C                   IF        ULX610 = 'Y'                                               CER001
     C                   EXSR      SESECS2RV                                                  CER001
     C                   ENDIF                                                                CER001
      *
     C/COPY WNCPYSRC,SESECSAC01                                                               LLN022
      *                                                                                      LLN022A
      ** If LLN012 installed retrieve BOE fields.                                            LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'SESECSRTV1'                                              LLN022A
     C                   PARM                    ReturnCode                                  LLN022A
     C                   PARM                    DDACTN                                      LLN022A
     C                   PARM                    FRNT                                        LLN022A
     C                   PARM                    DDSESN                                      LLN022A
     C                   PARM                    SecsExFilFmt                                LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
      * Convert to screeen format
     C     Idx           IFEQ      0
     C                   EXSR      SESECSCVT
     C/COPY WNCPYSRC,SESECSAC02                                                               LLN022
      *                                                                                      LLN022A
      ** If LLN012 installed convert BOE fields.                                             LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
                                                                                             LLN022A
     C                   CALLB     'SESECSCVT1'                                              LLN022A
     C                   PARM                    ReturnCode                                  LLN022A
     C                   PARM                    DDSESN                                      LLN022A
     C                   PARM                    SecsExFilFmt                                LLN022A
     C                   PARM                    ExtData                                     LLN022A
                                                                                             LLN022A
     C                   ENDIF                                                               LLN022A
      *                                                                                      LLN022A
     C                   IF        ULX610 = 'Y'                                               CER001
     C                   EXSR      SESECS2CT                                                  CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C                   ENDIF
 
     C                   ENDIF
 
     C                   IF        ReturnCode <> *BLANK
     C                   MOVEL     '0'           APIRetc
     C                   MOVEL     'DDSESN'      FldNameArr(1)
     C                   MOVEL     PErrMs        MsgIDArr(1)
     C                   ENDIF
 
      * Build buffer with required output
     C                   MOVE      PSDC1         ASDC1
     C                   MOVE      PSDC2         ASDC2
     C                   MOVE      PSDC3         ASDC3
     C                   MOVE      STBS          PTRBS
     C                   MOVE      TMST          @TimeStamp       26                         BUG1569
      *                                                                                      BUG6218
      ** Please ensure that when setting up the buffer, new core fields                      BUG6218
      ** are added before the data structure ExtData                                         BUG6218
      *                                                                                      BUG6218
     C                   EVAL      Buffer = Sect1ScnFmt + Sect2ScnFmt
     C                             + Sect3ScnFmt + Sect4ScnFmt
     C************                 + Sect5ScnFmt + PPROT                                     BUG1569
     C************                 + Sect5ScnFmt + @TimeStamp + PPROT                 BUG1569 CSE071
     C************                 + PTRBS + PPRBS +ASDC1 + ASDC2 + ASDC3                     CSE071
     C                             + Sect5ScnFmt + Sect6ScnFmt + @TimeStamp                   CSE071
     C                             + PPROT + PTRBS + PPRBS +ASDC1 + ASDC2                     CSE071
     C**********                   + ASDC3                                            CSE071  CER001
     C                             + ASDC3 + RegData                                          CER001
     C                             + ExtData                                                 BUG6218
 
     C                   SETON                                        LR
     C                   RETURN
      **********************************************************************
     C     SESECSRED     BEGSR
      *
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SESECSRED'
      *
     C                   PARM                    ReturnCode
      ** Security shortname (file pointer)
     C                   PARM                    DDSESN
      *
      ** Read backwards
     C                   PARM                    @RDBCK
      *
      ** Read forwards
     C                   PARM                    @RDFWD
      *
      ** STANDING DATA
      ** =============
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      ** USER - default branch
     C                   PARM                    PDBRN
      ** OUTPUT
      ** ======
      ** Error message
     C                   PARM                    PErrMs
      *
      ** Security shortname read
     C                   PARM                    PSeSnSel
 
     C                   ENDSR
      **********************************************************************
     C     SESECSRTV     BEGSR
 
     C                   RESET                   ReturnCode
     C                   EVAL      Idx = 0
     C                   CLEAR                   FldNameArr
     C                   CLEAR                   MsgIdArr
     C                   CLEAR                   MsgDtaArr
      *
     C                   CALLB     'SESECSRTV'
      *
      ** INPUT
      ** =====
      *
     C                   PARM                    ReturnCode
      *
      ** Mode = '*FRONT' (front office transaction interface)
      ** Mode = '      ' (not front office transaction interface)
      ** Mode = '*RPR  ' (repair function)
      ** Mode = '*SIN  ' (screen input function)
     C                   PARM                    PMode
      *
      ** Response mode
     C                   PARM                    PRespMode
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Front office transaction Id
     C                   PARM                    FRNT
      *
      ** Security shortname
     C                   PARM                    DDSESN
      *
      ** Old security shortname
     C                   PARM                    PParOSESN
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - single branch code
     C                   PARM                    BJSBRC
      *
      ** USER - default branch
     C                   PARM                    PDBRN
      *
      ** OUTPUT
      ** ======
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
     C                   PARM                    IdX
      *
      ** OK action code
     C                   PARM                    OKACTN
      *
      ** OK security shortname
     C                   PARM                    OKSESN
      *
      ** Securities retrieved from file - file format
     C                   PARM                    SectFilFmt
      *
      ** Externally described DS for investment types
     C                   PARM                    PINVTP
 
     C                   ENDSR
                                                                                              CER001
      *****************************************************************                       CER001
      * SESECS2RV - Securities Details LUX Retrieve                   *                       CER001
      *****************************************************************                       CER001
     C     SESECS2RV     BEGSR                                                                CER001
                                                                                              CER001
     C                   RESET                   ReturnCode                                   CER001
     C                   CLEAR                   SecsLUX1FilFmt                               CER001
     C                   CLEAR                   SecsLUX2FilFmt                               CER001
     C                   CLEAR                   SecsLUX3FilFmt                               CER001
                                                                                              CER001
     C                   CALLB     'SESECS2RV'                                                CER001
      *                                                                                       CER001
      ** INPUT                                                                                CER001
      ** =====                                                                                CER001
      *                                                                                       CER001
     C                   PARM                    ReturnCode                                   CER001
      *                                                                                       CER001
      ** Action code                                                                          CER001
      *                                                                                       CER001
     C                   PARM                    DDACTN                                       CER001
      *                                                                                       CER001
      ** Front office transaction Id                                                          CER001
      *                                                                                       CER001
     C                   PARM                    FRNT                                         CER001
      *                                                                                       CER001
      ** Security shortname                                                                   CER001
      *                                                                                       CER001
     C                   PARM                    DDSESN                                       CER001
                                                                                              CER001
      *                                                                                       CER001
      ** OUTPUT                                                                               CER001
      ** ======                                                                               CER001
      *                                                                                       CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Extension file format 1                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX1FilFmt                               CER001
      *                                                                                       CER001
      ** Extension file format 2                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX2FilFmt                               CER001
      *                                                                                       CER001
      ** Extension file format 3                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX3FilFmt                               CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      **********************************************************************
     C     SESECSCVT     BEGSR
 
     C                   RESET                   ReturnCode
      *
     C                   CALLB     'SESECSCVT'
      ** INPUT
      ** =====
      ** Return code
     C                   PARM                    ReturnCode
      *
      ** Securities retrieved from file - file format
     C                   PARM                    SectFilFmt
      *
      ** Processing type - from file INVTPD
     C                   PARM                    PPROT
      *
      ** Action code
     C                   PARM                    DDACTN
      *
      ** Passed other information coming from link programs
     C                   PARM                    POthInf
      *
      ** Process old security details indicator
     C                   PARM                    PPOldSecDtl
      *
      ** STANDING DATA
      ** =============
      *
      ** SDBANK - date format indicator
     C                   PARM                    BJDFIN
      *
      ** SDBANK - midas run day number
     C                   PARM                    BJRDNB
      *
      ** SDMMOD - interest risk management
     C                   PARM                    BGRKMG
      *
      ** SDMMOD - plato interface
     C                   PARM                    BGN2ST
      *
      ** SDMMOD - private banking
     C                   PARM                    BGN4ST
      *
      ** SWITCHABLE FEATURES
      ** ===================
      *
      ** EMU securities decimals on nominals
     C                   PARM                    CEU018
      *
      ** Effect of holidays on FRN coupon dates
     C                   PARM                    CSE005
      *
      ** MT5xx message generation
     C                   PARM                    S01401
      *
      ** US Withholding tax treaty
     C                   PARM                    CSE023
      *
      ** Market Data Feed
     C                   PARM                    CSD006
      *
      ** Midas APIs Sec Prices
     C                   PARM                    CAP060
      *
      ** Coupon Fixing for Floating Rate Notes
     C                   PARM                    CSE031
 
      ** Hedge Accounting Phase B
     C                   PARM                    CAS006
      *
      ** Countervalue rounding
     C                   PARM                    CSE037
                                                                                              CGL014
      ** Collaterals Processing                                                               CGL014
     C                   PARM                    CGL014                                       CGL014
                                                                                              CSE071
      ** Multiple Holidays                                                                    CSE071
     C                   PARM                    CSE071                                       CSE071
                                                                                              CGL032
      ** Automatic Exchange of Information                                                    CGL032
                                                                                              CGL032
     C                   PARM                    CGL032                                       CGL032
      *
      ** OUTPUT
      ** ======
      *
      ** Security screen 1 details retrieved from file - screen format
     C                   PARM                    Sect1ScnFmt
      *
      ** Security screen 2 details retrieved from file - screen format
     C                   PARM                    Sect2ScnFmt
      *
      ** Security screen 3 details retrieved from file - screen format
     C                   PARM                    Sect3ScnFmt
      *
      ** Security screen 4 details retrieved from file - screen format
     C                   PARM                    Sect4ScnFmt
 
      ** Security Screen 5 Details Retrieved From File - Screen Format
     C                   PARM                    Sect5ScnFmt
                                                                                              CSE071
      ** Security Screen 6 Details Retrieved From File - Screen Format                        CSE071
     C                   PARM                    Sect6ScnFmt                                  CSE071
      *
      ** Last coupon date
     C                   PARM                    PLCPN
      *
      ** Next coupon date
     C                   PARM                    PNCD
 
      ** Linked maintenance flag
 
     C                   PARM                    PParmLink
 
     C                   ENDSR
                                                                                              CER001
      *****************************************************************                       CER001
      * SESECS2CT - Securities Details LUX Conversion                 *                       CER001
      *****************************************************************                       CER001
     C     SESECS2CT     BEGSR                                                                CER001
                                                                                              CER001
     C                   RESET                   ReturnCode                                   CER001
                                                                                              CER001
     C                   CALLB     'SESECS2CT'                                                CER001
      *                                                                                       CER001
      ** INPUT                                                                                CER001
      ** =====                                                                                CER001
      *                                                                                       CER001
     C                   PARM                    ReturnCode                                   CER001
      *                                                                                       CER001
      ** Security shortname                                                                   CER001
      *                                                                                       CER001
     C                   PARM                    DDSESN                                       CER001
      *                                                                                       CER001
      ** Extension file format 1                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX1FilFmt                               CER001
      *                                                                                       CER001
      ** Extension file format 2                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX2FilFmt                               CER001
      *                                                                                       CER001
      ** Extension file format 3                                                              CER001
      *                                                                                       CER001
     C                   PARM                    SecsLUX3FilFmt                               CER001
                                                                                              CER001
      *                                                                                       CER001
      ** OUTPUT                                                                               CER001
      ** ======                                                                               CER001
      *                                                                                       CER001
                                                                                              CER001
      *                                                                                       CER001
      ** Extension Screen Format                                                              CER001
      *                                                                                       CER001
     C                   PARM                    RegData                                      CER001
                                                                                              CER001
     C                   ENDSR                                                                CER001
      **********************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  *INZSR - Program initialisation                              *
      *         - This subroutine runs automatically for program      *
      *           initialisation.                                     *
      *                                                               *
      *****************************************************************
 
     C     *INZSR        BEGSR
      *
      ** Entry parameters.
      *
 
     C     *ENTRY        PLIST
     C                   PARM                    AuthComp          1
     C                   PARM                    FwdBck            1
     C                   PARM                    DDSESN_In        10
     C                   PARM                    Buffer         6000
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIDArr
     C                   PARM                    MsgDtaArr
     C                   PARM                    MsgFArray
     C                   PARM                    APIRetc           1
     C/COPY WNCPYSRC,SESECSAC03                                                               LLN022
 
      *                                                                                      LLN022A
      ** Access SAR details file to determine if LLN012                                      LLN022A
      ** FSA Liquidity Report LR extract is installed.                                       LLN022A
      *                                                                                      LLN022A
     C                   MOVE      'N'           LLN012            1                         LLN022A
     C                   CALLB     'AOSARDR0'                                                LLN022A
     C                   PARM      *BLANKS       PRTCD                                       LLN022A
     C                   PARM      '*VERIFY'     POPTN                                       LLN022A
     C                   PARM      'LLN012'      PSARD                                       LLN022A
     C     SCSARD        PARM      SCSARD        DSFDY                                       LLN022A
      *                                                                                      LLN022A
      ** Switchable Feature LLN012 is ON                                                     LLN022A
      *                                                                                      LLN022A
     C                   IF        PRTCD = *Blanks                                           LLN022A
     C                   EVAL      LLN012 = 'Y'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      * Set up the name of the primary and secondary message files from
      * which the message handler will get the messages
     C                   EVAL      MsgFArray(1) = 'SEUSRMSG'
     C                   EVAL      MsgFArray(2) = 'DRSMM'
     C                   EVAL      MsgFArray(3) = 'MEMSG'
     C                   EVAL      MsgFArray(4) = 'WNMSGF'
 
      *  Hook to enable non-core message files to be included
     C/COPY WNCPYSRC,SESECSM01
      *
      **  Add GBBYUSRMSG to MsgFArray if BOE installed                                       LLN022A
      *                                                                                      LLN022A
     C                   IF        LLN012 = 'Y'                                              LLN022A
     C                   EVAL      MsgFArray (%LookUp(*Blanks:MsgFArray)) =                  LLN022A
     C                             'GBBYUSRMSG'                                              LLN022A
     C                   ENDIF                                                               LLN022A
                                                                                             LLN022A
      ** Access bank details.
      *
     C                   CALLB     'AOBANKR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDBANKPD'
     C                   Z-ADD     1             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access ICD details for securities trading.
      *
     C                   CALL      'AOSTRDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDSTRD        PARM      SDSTRD        DSSDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDSTRDPD'
     C                   Z-ADD     2             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access midas modules.
      *
     C                   CALLB     'AOMMODR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*FIRST '     POptn
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      ** Database error
      *
     C                   IF        PRtcd <> *BLANKS
     C                   EVAL      DBKey = POptn
     C                   EVAL      DBFile = 'SDMMODPD'
     C                   Z-ADD     3             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE005 (Effect of holidays on FRN
      ** coupon dates) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE005'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE005'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     4             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CSE005 = 'Y'
     C                   ELSE
     C                   EVAL      CSE005 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CEU018 (EMU securities decimals on
      ** nominals) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CEU018'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CEU018'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     8             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      CEU018 = 'Y'
     C                   ELSE
     C                   EVAL      CEU018 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if S01401 (MT5XX message generation)
      ** is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'S01401'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'S01401'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     9             DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANK
     C                   EVAL      S01401 = 'Y'
     C                   ELSE
     C                   EVAL      S01401 = 'N'
     C                   ENDIF
      *
      ** Access SAR file to determine if CSE023
      ** (US Withholding tax treaty) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE023'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE023'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     11            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE023 = 'Y'
     C                   ELSE
     C                   EVAL      CSE023 = 'N'
     C                   ENDIF
      *
      ** Access SAR details file to determine if CAP060
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAP060'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CAP060
     C                   ELSE
     C                   MOVEL     'N'           CAP060
     C                   END
 
      *
      ** Access SAR details file to determine if Market Data Feed
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSD006'      PSARd
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSD006
     C                   ELSE
     C                   MOVEL     'N'           CSD006
     C                   END
 
      *
      ** Access SAR file to determine if CSE031
      ** (Coupon Fixing for Floating Rate Notes) is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRtcd
     C                   PARM      '*VERIFY'     POptn
     C                   PARM      'CSE031'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** An NRF (No Record Found) return code is valid.
      ** Issue database error only for error return codes.
      *
     C                   IF        PRtcd <> *BLANKS AND
     C                             PRtcd <> '*NRF   '
     C                   EVAL      DBKey = 'CSE031'
     C                   EVAL      DBFile = 'SCSARDPD'
     C                   Z-ADD     12            DBase
     C                   EXSR      *PSSR
     C                   ENDIF
 
     C                   IF        PRtcd = *BLANKS
     C                   EVAL      CSE031 = 'Y'
     C                   ELSE
     C                   EVAL      CSE031 = 'N'
     C                   ENDIF
 
      ** Access SAR details to see if CAS006 is enabled.
 
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CAS006'      PSARD
     C     SCSARD        PARM      SCSARD        DSFDY
 
     C                   IF        @RTCD = *BLANKS
     C                   EVAL      CAS006 = 'Y'
     C                   ELSE
     C                   EVAL      CAS006 = 'N'
     C                   ENDIF
 
      ** Access SAR details file to determine if Countervalue rounding
      ** is switched on
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CSE037'      @SARD
     C     SCSARD        PARM      SCSARD        DSFDY
     C     @RTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSE037            1
     C                   ELSE
     C                   MOVEL     'N'           CSE037
     C                   ENDIF
                                                                                              CGL014
      ** Check if enhancement CGL014 (Collaterals Processing) is on                           CGL014
                                                                                              CGL014
     C                   CALLB     'AOSARDR0'                                                 CGL014
     C                   PARM      *BLANKS       @RTCD                                        CGL014
     C                   PARM      '*VERIFY'     @OPTN                                        CGL014
     C                   PARM      'CGL014'      @SARD                                        CGL014
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL014
                                                                                              CGL014
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CGL014
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CGL014
     C                   EVAL      DBKEY  = 'CGL014'                                          CGL014
     C                   EVAL      DBASE  = 13                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *BLANKS                                            CGL014
     C                   EVAL      CGL014 = 'Y'                                               CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      CGL014 = 'N'                                               CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      *                                                                                       CER001
      ** Access SAR details file to determine if ULX610                                       CER001
      ** is switched on                                                                       CER001
      *                                                                                       CER001
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX610'      PSARd                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS  AND  @RTCD <> '*NRF   '                  CER001
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER001
     C                   EVAL      DBKEY  = 'ULX610'                                          CER001
     C                   EVAL      DBASE  = 14                                                CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     @RTCD         IFEQ      *BLANK                                                     CER001
     C                   MOVEL     'Y'           ULX610                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX610                                       CER001
     C                   END                                                                  CER001
      ** Check if enhancement CSE071 (Multiple Holidays) is on                                CSE071
                                                                                              CSE071
     C                   CALLB     'AOSARDR0'                                                 CSE071
     C                   PARM      *BLANKS       @RTCD                                        CSE071
     C                   PARM      '*VERIFY'     @OPTN                                        CSE071
     C                   PARM      'CSE071'      @SARD                                        CSE071
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSE071
                                                                                              CSE071
     C                   IF        @RTCD = *BLANKS                                            CSE071
     C                   EVAL      CSE071 = 'Y'                                               CSE071
     C                   ELSE                                                                 CSE071
     C                   EVAL      CSE071 = 'N'                                               CSE071
     C                   ENDIF                                                                CSE071
 
      ** Check if CGL032 is enabled.                                                          CGL032
                                                                                              CGL032
     C                   CALLB     'AOSARDR0'                                                 CGL032
     C                   PARM      *BLANKS       PRtCd                                        CGL032
     C                   PARM      '*VERIFY'     POptn                                        CGL032
     C                   PARM      'CGL032'      PSARD                                        CGL032
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL032
                                                                                              CGL032
     C                   EVAL      CGL032 = 'N'                                               CGL032
                                                                                              CGL032
     C                   IF        PRtCd = *BLANKS                                            CGL032
     C                   EVAL      CGL032 = 'Y'                                               CGL032
     C                   ELSE                                                                 CGL032
                                                                                              CGL032
     C                   IF        PRtCd <> '*NRF   '                                         CGL032
     C     *LOCK         IN        LDA                                                        CGL032
     C                   EVAL      DBFile = 'SCSARDPD'                                        CGL032
     C                   EVAL      DBKey = PSARD                                              CGL032
     C                   EVAL      DBase = 101                                                CGL032
     C                   OUT       LDA                                                        CGL032
     C                   EXSR      *PSSR                                                      CGL032
     C                   ENDIF                                                                CGL032
                                                                                              CGL032
     C                   ENDIF                                                                CGL032
      ** Retrieve User details.
 
     C******DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C**********         IN        ZMUSER                                                    BUG7029
      **********                                                                             BUG7029
     C                   ENDSR
 
      *****************************************************************
      /EJECT
      *****************************************************************
      /EJECT
      **********************************************************************
      ** The following /COPY contains the standard program status
      ** subroutine, excluding a bound call to the DBERRCTL module.
      *********************************************************************
     C/COPY ZACPYSRC,PSSR_ILENE
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
**  CPY@
(c) Finastra International Limited 2003
