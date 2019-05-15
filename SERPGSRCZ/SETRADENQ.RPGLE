     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas SE Trade enquiry')                               *
      *****************************************************************
      *                                                               *
      *  Midas - Securities Trading Module                            *
      *                                                               *
      *  SETRADENQ - Security Trades Enquiry Screen                   *
      *                                                               *
      *  Function:  This is the main enquiry Screen                   *
      *             for Securities/trades.                            *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD046248           Date 27Oct17               *
      *  Prev Amend No. CSF011A            Date 28Nov11               *
      *                 AR698195B          Date 20Jan11               *
      *                 CSW210             Date 04May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CSD027             Date 09Dec05               *
      *                 CSE075             Date 17Nov05               *
      *                 CGL031             Date 05Jul04               *
      *                 CSE065             Date 08Nov04               *
      *                 CSE071             Date 19Jul05               *
      *                 222373             Date 22Oct03               *
      *                 CSE039             Date 21Jan03               *
      *                 CAS006             Date 21Jan03               *
      *                 216338             Date 21Jan03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209580             Date 28Oct02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSE031             Date 13Dec01               *
      *                 CAP067             Date 24Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE028             Date 06Jun01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CSD006             Date 11Oct00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CSE023             Date 12Jul00               *
      *                 175216             Date 12Sep00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CAP137             Date 07Feb00               *
      *                 177694             Date 12Apr00               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CSE010             Date 21Jun99               *
      *                 CGL007  *Create    Date 26Mar99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD046248 - Finastra Rebranding                               *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR698195B - Added Front Office field on the buffer for TRADS *
      *             (Child: AR698196)                                 *
      *  CSW210 - SWIFT 2010 Changes (Recompile)                      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CSE075 - US Enhanced Treasury Upgrade to MidasPlus           *
      *           (Recompile)                                         *
      *  CGL031 - Taxation for Savings Income                         *
      *  CSE065 - Cost Yield Amort. on Mortgage Backed Assets         *
      *           (Recompile)                                         *
      *  CSE071 - Multiple Holidays Re Securities (recompile)         *
      *  222373 - Parameter Mismatch                                  *
      *  CSE039 - Auto-settlement of trades.                          *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  216338 - Add missing parameter                               *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  209580 - Database error                                      *
      *           wrong parameters on CALLB SETRADEDSP...             *
      *           2 added by 201429 (PUYAT + T1NEW)                   *
      *           1 added by CSE034 (DftFlag)                         *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *           Recompiled due to changes in SECTYD.                *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSE028 - Standing Settlement Instructions Enhancement.       *
      *           (Recompiled).                                       *
      *  CSD006 - Recompiled over changed SECTYD.                     *
      *  CSE023 - Treaty Withholding Tax (Recompiled)                 *
      *  175216 - Add additional field for "Standing Instructions     *
      *           Override" missed at SWIFT 98 change. Compile only.  *
      *  CAP137 - Conversion of SE Security inputs into modular       *
      *           structure to use as APIs.                           *
      *  177694 - The REPI field in SECTY has to be renamed to allow  *
      *           the module to compile.                              *
      *  CSE010 - SE Transactions Enhancements                        *
      *  CGL007 - Account Postings Enquiry                            *
      *                                                               *
      *****************************************************************
      *  S U B R O U T I N E   I N D E X                              *
      *                                                               *
      *  SRP002 - Retrieve the Details of the Deal                    *
      *  SRP003 - Put a Trade on the Secondary Screen                 *
      *  SRP004 - Process Screen: Main/Second Screen                  *
      *  SRP005 - Process Screen: Primary/Initial Screen              *
      *  SRP017 - Process Third Details Screen                        *                       CAS006
      *  SRP006 - Process Other Details Screen                        *
      *  SRP007 - Process Extension (SWIFT) Screen A                  *
      *  SRP008 - Process Extension (SWIFT) Screen B                  *
      *  SRP009 - End Program                                         *
      *  SRP010 - F5 is Selected                                      *
      *  SRP011 - F12 is Selected                                     *
      *  SRP012 - Validate Main/Secondary Screen                      *
      *  SRP013 - Validate Primary/Initial Screen                     *
      *  SRP018 - Validate Third Details Screen                       *                       CAS006
      *  SRP014 - Validate Other Details Screen                       *
      *  SRP015 - Convert details to Screen Format                    *
      *  SRP016 - F14 is Selected                                     *
      *  SRP005 - ValidateeExtension Screen A                         *
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *****************************************************************
                                                                                              CAS006
      ** +--------------------------------------+                                             CAS006
      ** ¦ F-specs                              ¦                                             CAS006
      ** ¦ =======                              ¦                                             CAS006
      ** +--------------------------------------+                                             CAS006
                                                                                              CAS006
     FSECEO     IF   E           K DISK    INFSR(*PSSR)                                       CAS006
     F                                     IGNORE(SNDEVDF)                                    CAS006
     F                                     PREFIX(SE_)                                        CAS006
      ** SE Security Events by Type                                                           CAS006
                                                                                              CAS006
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      *
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
      *
     D/COPY ZACPYSRC,STD_D_SPEC
      *
      ** The following /COPY includes the MM standard declares:
      *
     D/COPY ZACPYSRC,STDDECLARE
      *
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
      *
     D/COPY ZACPYSRC,PSDS
      *
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
      *
     D/COPY ZACPYSRC,ERR_ARRAYS
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
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      *
     D CrTrFilFmt    E DS                  EXTNAME(TRADSD)
     D                                     PREFIX(C_)
      ** Current Trade in File Format
      *
     D CT1AFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CA_)
      ** Current Trade in File Format (Extension File)
      *
     D CT1BFilFmt    E DS                  EXTNAME(TRADSDX1)
     D                                     PREFIX(CB_)
      ** Current Trade in File Format (Extension File)
      *
     D NwTrFilFmt    E DS                  EXTNAME(SEVTRADPD)
      ** New Trade in File Format
      *
     D NT1AFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(A_)
      ** New Trade in File Format (Extension File)
      *
     D NT1BFilFmt    E DS                  EXTNAME(SEVTRX1PD)
     D                                     PREFIX(B_)
      ** New Trade in File Format (Extension File)
      *
     D NewTrPrim     E DS                  EXTNAME(SETRPRPD)
      * New Trade in Screen Format - Primary Details
     D NewTrSeco     E DS                  EXTNAME(SETRSEPD)
      ** New Trade in Screen Format - Secondary Details
      *
     D NewTrThir     E DS                  EXTNAME(SETRTHPD)                                  CAS006
      ** New Trade in Screen Format - Third Screen Details                                    CAS006
      *                                                                                       CAS006
     D NewTrExch     E DS                  EXTNAME(SETREXPD)
      ** New Trade in Screen Format - Exchange Rate Details
      *
     D NewTrSett     E DS                  EXTNAME(SETRSTPD)
      ** New Trade in Screen Format - Settlement Details
      *
     D DDCLTY2       E                     EXTFLD(DDCLTY)
      *
     D NewTrChCm     E DS                  EXTNAME(SETRCCPD)
      ** New Trade in Screen Format - Charge & Commission Details
      *
     D NewTrSwftA    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(A_)
      ** New Trade in Screen Format - SWIFT Details
      *
     D NewTrSwftB    E DS                  EXTNAME(SETRSWPD)
     D                                     PREFIX(B_)
      ** New Trade in Screen Format - SWIFT Details
      *
     D TrExts        E DS                  EXTNAME(SETESDPD)                                  222373
     D NwSEFilFmt    E DS                  EXTNAME(SEVTRX2PD)                                 222373
     D OKTrPrim      E DS                  EXTNAME(SEETRPRPD)
     D OKTrSeco      E DS                  EXTNAME(SEETRSEPD)
     D OKTrThir      E DS                  EXTNAME(SEETRTHPD)                                 CAS006
     D OKTrExch      E DS                  EXTNAME(SEETREXPD)
     D OKTrSett      E DS                  EXTNAME(SEETRSTPD)
     D DDCLTY2OK     E                     EXTFLD(DDCLTYOK)
     D OKTrChcm      E DS                  EXTNAME(SEETRCCPD)
     D OKTrSwft      E DS                  EXTNAME(SEETRSWPD)
     D OKTrExts      E DS                  EXTNAME(SEETESPD)                                  222373
      ** Error indicators
      *
     D PMCWL           DS          9999                                                       CSD015
      ** Additional entry parameter for Midas Compliance Watch                                CSD015
      *                                                                                       CSD015
     D SECTY         E DS                  EXTNAME(SECTYD)
     D SEC_RECI      E                     EXTFLD(RECI)
     D SEC_ZZ005     E                     EXTFLD(ZZ005)
     D SEC_LCD       E                     EXTFLD(LCD)
     D SEC_CHTP      E                     EXTFLD(CHTP)
     D SEC_TNLU      E                     EXTFLD(TNLU)
     D SEC_REPI      E                     EXTFLD(REPI)                                       177694
     D SEC_FRNT      E                     EXTFLD(FRNT)                                       CAP137
     D SEC_REPA      E                     EXTFLD(REPA)                                       CAP137
     D SEC_TMST      E                     EXTFLD(TMST)                                       CAP137
      ** Security Details
      *
     D INVTP         E DS                  EXTNAME(INVTPD)
     D INV_RECI      E                     EXTFLD(RECI)
     D INV_LCD       E                     EXTFLD(LCD)
     D INV_CHTP      E                     EXTFLD(CHTP)
     D INV_TNLU      E                     EXTFLD(TNLU)
     D INV_NDEC      E                     EXTFLD(NDEC)                                       CAS006
      ** Investment Type Details
      *
      ** The following /COPY includes the customer details data structure
      *
     D/COPY SECPYSRC,SE_CUSTDT
      *
      ** The following /COPY includes the currency details data structures
      *
     D/COPY SECPYSRC,SE_CCYDT
      *
     D                 DS
      **  Data structure for date in, to change format.
      *
     D  DateIn                 1      8  0
     D  @@YY                   1      4  0
     D  @@MM                   5      6  0
     D  @@DD                   7      8  0
      *
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** External DS for Bank Details
      *
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** External DS for SAR Details
      *
     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** First DS for Access Programs, Short Data Structure
      *
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
      *
      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
      *
     D RespMode        S              1A   INZ('S')
                                                                                              CAS006
     D CAS006          S              1                                                       CAS006
     D DDHACR          S             13                                                       CAS006
     D DDPRICN         S             17                                                       CAS006
     D WrkNTCR         S             11  7                                                    CAS006
     D ZFLD15          S             15  0                                                    CAS006
     D ZDECS           S              1  0                                                    CAS006
     D ZECODE          S              1                                                       CAS006
     D ZOUT21          S             21                                                       CAS006
     D DDWTAX          S             15                                                       216338
     D PCALL           S              3A                                                      222373
                                                                                              CGL031
      ** Switchable Features                                                                  CGL031
     D CGL031          S              1A                                                      CGL031
      ** Front office id variable.                                                         AR698195B
     D DDFRNT          S             20A                                                   AR698195B
      *
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  P001 - Main Processing                                       *
      *                                                               *
      *  Calls:     SRP002 - Retrieve Transaction                     *
      *             SRP003 - Put a Trade on the Secondary Screen      *
      *             SRP004 - Process Screen: Main/Second Screen       *
      *             SRP005 - Process Screen: Primary/Initial Screen   *
      *             SRP006 - Process Other Details Screen             *
      *             SRP007 - Process Extension (SWIFT) Screen A       *
      *             SRP008 - Process Extension (SWIFT) Screen B       *
      *                                                               *
      *****************************************************************
      *
     C                   EXSR      SRP002
      *
     C     DDACTNOK      IFEQ      'N'
     C     DDTDRFOK      OREQ      'N'
     C                   MOVE      'E'           PRET
     C                   MOVE      'T'           WSCRN
     C                   ELSE
     C                   EXSR      SRP003
     C                   MOVEL     CrTrFilFmt    NwTrFilFmt
     C                   ENDIF
      *
     C     WSCRN         Doweq     'S'
     C                   EXSR      SRP004
     C                   Enddo
      *
     C     WSCRN         Doweq     'P'
     C                   EXSR      SRP005
     C                   Enddo
                                                                                              CAS006
     C                   IF        CAS006 = 'Y'                                               CAS006
     C                   DOW       WSCRN = 'H'                                                CAS006
     C                   EXSR      SRP017                                                     CAS006
     C                   ENDDO                                                                CAS006
     C                   ENDIF                                                                CAS006
      *
     C     WSCRN         Doweq     'O'
     C                   EXSR      SRP006
     C                   Enddo
      *
     C     WSCRN         Doweq     'A'
     C                   EXSR      SRP007
     C                   Enddo
      *
     C     WSCRN         Doweq     'B'
     C                   EXSR      SRP008
     C                   Enddo
      *
     C     WSCRN         IFEQ      'T'
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP002 - Retrieve Transaction                                *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP002        BEGSR
      *
      ** Retrieve Trade
      *
     C                   CALLB     'SETRADRTV'
      *
      ** Inputs : Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Mode = '*FRONT' (Front office transaction interface)
      ** Mode = '      ' (Not Front office Transaction Interface)
      *
     C                   PARM      '      '      @@MODE            6
      *
      ** Response mode
      *
     C                   PARM      'S'           @@RSMD            1
      *
      ** Action Code
      *
     C                   PARM      PACT          DDACTN
      *
      ** Front Office Transaction ID
      *
     C                   PARM                    FOTRID           20
      *
      ** (Midas) Trade Reference
      *
     C                   PARM      PREF          DDTDRF
      *                                                                                 CSE010
      ** MT5XX - Phase 2 Message Generation switchable feature.                         CSE010
      *                                                                                 CSE010
     C                   PARM                    CSW003            1                    CSE010
      *                                                                                       CAP067
      * Buy-sell back                                                                         CAP067
     C                   PARM                    PFBYSL            1                          CAP067
      *                                                                                       CAP067
      * Trade Reference                                                                       CAP067
     C                   PARM                    PFTDRF            6                          CAP067
      *
      ** Outputs :
      ** (Current) Trade in file format
      *
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
      *
      ** OK - Action code
      *
     C                   PARM      *BLANK        DDACTNOK
      *
      ** OK - Trade Reference
      *
     C                   PARM      *BLANK        DDTDRFOK
      *
      ** Error fields/message IDs/message data (arrays) from/to caller
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Array index (3P0) from/to caller
      *
     C                   PARM      *ZERO         Idx               3 0
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP003 - Put a Trade on the Secondary Screen                 *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP003        BEGSR
      *
      ** Call program to fill screen fields with data from TRADSD
      *
     C                   CALLB     'SETRADCVT'
      *
      ** Inputs : Return Code and Trade in file format
      *
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrTrFilFmt
     C                   PARM                    CT1AFilFmt
     C                   PARM                    CT1BFilFmt
                                                                                              CAS006
      ** Hedge Accounting Phase B                                                             CAS006
                                                                                              CAS006
     C                   PARM                    CAS006                                       CAS006
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *
      ** Outputs: Trade - screen formats
      *
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrThir                                    CAS006
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
     C                   PARM                    NewTrSwftA
     C                   PARM                    NewTrSwftB
      *
      ** Security Details
      ** Investment Type Details
      *
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Nominal Currency Details
      *
     C                   PARM                    NomCcyDts
      *
      ** Settlement Currency Details
      *
     C                   PARM                    SetCcyDts
      *
      ** Customer (Counterparty) Details
      *
     C                   PARM                    CustDts
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
      *
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
      *
     C**********         PARM                    DDSRPN           20                          CAP067
     C                   PARM                    DDSRNME          41                          CAP067
     C                   PARM                    DDCRNM           20
      *
      ** Coupon Rate
      ** Current Factor
      ** Margin Amount
      ** Portfolio Exchange Rate
      ** Portfolio M/D Ind
      ** Trade Countervalue
      ** Witholding Tax                                                                       216338
      ** Net Treasury Price                                                                   216338
      *
     C                   PARM                    DDCPNR           13
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
     C                   PARM                    DDTCTR           21
     C                   PARM                    DDWTAX                                       216338
     C                   PARM                    DDPRICN                                      CAS006
      *
      ** Screen A
      ** Destination of Settlement
      ** Destination of Confirmation
      *
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** Screen B
      ** Destination of Settlement
      ** Destination of Confirmation
      *
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
     C                   PARM                    DDFRNT                                    AR698195B
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP004 - Process Screen: Main/Second Screen                  *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP009 - End Program                              *
      *             SRP010 - F5 is Selected                           *
      *             SRP011 - F12 is Selected                          *
      *             SRP012 - Validate Main/Secondary Screen           *
      *                                                               *
      *****************************************************************
     C     SRP004        BEGSR
      *
      ** Write/Read Display Screen - Secondary Details
      *
     C                   CALLB     'SETRADSDSP'
      *
      ** Input Parameters: Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (In Screen Format - Primary / Secondary)
      *
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
      *
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
      *
     C**********         PARM                    DDSRPN           20                          CAP067
     C                   PARM                    DDSRNME                                      CAP067
     C                   PARM                    DDCRNM           20
      *
      ** Current Factor
      ** Coupon Rate
      *
     C                   PARM                    DDCFCT           12
     C                   PARM                    DDCPNR           13
      *
      ** Trade incomplete ind
      *
     C                   PARM                    C_TINC
      *
      ** Fields in error
      *
     C                   PARM                    OKTrPrim
     C                   PARM                    OKTrSeco
      *
      ** Customer classification
      *
     C                   PARM                    CustClass
      *
      ** Security Details
      ** Investment Type Details
      *
     C                   PARM                    SECTY
     C                   PARM                    INVTP
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Enabled Function Keys
      ** KG = Comamnd Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KJ = Command Key 10 = Comfirm Delete
      ** KP = Comamnd Key 15 = Browse
      *
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ            1
     C                   PARM      'N'           @EINKP
      *                                                                                       CAP067
      * Protect book on second leg                                                            CAP067
     C                   PARM                    IN50              1                          CAP067
     C                   PARM                    TRDBK1            2                          CAP067
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
      *
      ** Output Parameters : Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKW             1                          CSE039
     C                   PARM      'N'           @INKWDisp         1                          CSE039
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
      *
      ** Reset Errors ....
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVE      *ALL'Y'       OKTrSeco
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP009
      *
      ** F5 - Go to Initial Screen
      *
     C     @INKE         CASEQ     '1'           SRP010
      *
      ** F12 - Cancel on Secondary Screen
      *
     C     @INKL         CASEQ     '1'           SRP011
      *
      ** Validate Input to Secondary Screen
      *
     C                   CAS                     SRP012
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP005 - Process Screen: Primary/Initial Screen              *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP009 - End Program                              *
      *             SRP011 - F12 is Selected                          *
      *             SRP013 - Validate Primary/Initial Screen          *
      *                                                               *
      *****************************************************************
     C     SRP005        BEGSR
      *
      ** Write/Read Display Screen - Primary Details
      *
     C                   CALLB     'SETRADPDSP'
      *
      ** Input Parameters: Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (In Screen Format - Primary)
      *
     C                   PARM                    NewTrPrim
      *
      ** Trade Status
      ** Trade Authorized/Not Authorized
      *
     C                   PARM                    DDSTAT            9
     C                   PARM                    DDAUTH           14
      *
      ** Security report name
      ** Customer report name
      *
     C**********         PARM                    DDSRPN           20                          CAP067
     C                   PARM                    DDSRNME                                      CAP067
     C                   PARM                    DDCRNM           20
      *
      ** Fields in error
      *
     C                   PARM                    OKTrPrim
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Disable Key Fields
      ** Disable Detail Fields
      *
     C                   PARM      'N'           @EKYFD            1
     C                   PARM      'N'           @EDTFD            1
     C                   PARM                    @FRPGM            1                          CAP067
      *
      ** Disable Function Keys
      ** KG = Command Key 07 = Read Previous
      ** KH = Command Key 08 = Read Next
      ** KP = Command Key 15 = Browse
      *
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
      *
      ** Successful insert Trade
      *
     C                   PARM                    @SITR             6
      *                                                                                       CAP067
      * Protect book on second leg                                                            CAP067
     C                   PARM                    IN50              1                          CAP067
     C                   PARM                    TRDBK1            2                          CAP067
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *                                                                                       CAP067
      ** Successful insert Trade2                                                             CAP067
     C                   PARM                    PSITR             6                          CAP067
      *
      ** Output Parameters: Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrPrim
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP009
      *
      ** F12 - Cancel on Primary Screen
      *
     C     @INKL         CASEQ     '1'           SRP011
      *
      ** Display next Screen
      *
     C                   CAS                     SRP013
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP006 - Process Other Details Screen                        *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP009 - End Program                              *
      *             SRP010 - F5 is Selected                           *
      *             SRP013 - Validate Primary/Initial Screen          *
      *             SRP014 - Validate Other Details Screen            *
      *                                                               *
      *****************************************************************
     C     SRP006        BEGSR
      *
      ** Write/Read Display - Other Details Screen
      *
     C                   CALLB     'SETRADODSP'
      *
      ** Input Parameters: Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Trade (In Screen Format) - Primary/Secondary/Other Details
      *
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrExch
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrChCm
      *
      ** Current trade incomplete ind and date made complete
      *
     C                   PARM                    C_TINC
     C                   PARM                    C_TDMC
      *
      ** Customer classification, Customer PM (Y/N) and nominal currency
      *
     C                   PARM                    CustClass         1
     C                   PARM                    CustPM            1
     C                   PARM                    NMCY              3
     C                   PARM                    CustPB            1                          CAP067
      *                                                                                       CAP067
      ** Withholding tax                                                                      CAP067
      *                                                                                       CAP067
     C                   PARM                    DDWTAX           15                          CAP067
      *
      ** Fields in error
      *
     C                   PARM                    OKTrExch
     C                   PARM                    OKTrSett
     C                   PARM                    OKTrChcm
      *
      ** Security report name
      ** Countervalue
      ** FX Margin Amount
      ** Portfolio exchange rate & M/D ind screen format
      *
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME                                      CAP067
     C                   PARM                    DDTCTR
     C                   PARM                    DDMAMT           18
     C                   PARM                    DDSPXR           14
     C                   PARM                    DDSPMD            1
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * CGL031 Switchable Feature                                                             CGL031
     C                   PARM                    CGL031                                       CGL031
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** Output Parameters: Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrExch
     C                   MOVE      *ALL'Y'       OKTrSett
     C                   MOVE      *ALL'Y'       OKTrChcm
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP009
      *
      ** F5 - Go To Initial Screen
      *
     C     @INKE         CASEQ     '1'           SRP010
      *
      ** F12 - Cancel on Other Details Screen
      *
     C     @INKL         CASEQ     '1'           SRP013
      *
      ** Validate Input to Other Details Screen
      *
     C                   CAS                     SRP014
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP007 - Process Extension (Swift) Screen A                  *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP009 - End Program                              *
      *             SRP010 - F5 is Selected                           *
      *             SRP012 - Validate Main/Secondary Screen           *
      *             SRP015 - F14 is Selected                          *
      *             SRP016 - Validate Extension Screen A              *
      *                                                               *
      *****************************************************************
     C     SRP007        BEGSR
      *
      ** Check whether screen B is required
      *
     C                   MOVE      'N'           Display_B         1
     C     CSW003        IFEQ      'Y'
     C     CustClass     IFEQ      'S'
     C     DELT          ANDNE     DELF
     C     CustClass     OREQ      'D'
     C     DELT          ANDNE     DELF
     C                   MOVE      'Y'           Display_B
     C                   END
     C                   END
      *
      ** Write/Read Display - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *
      ** Input Parameters: Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Screen A/B
      *
     C                   PARM      'A'           Screen            1
      *
      ** Trade (In Screen Format) - Primary/Settlements/SWIFT
      *
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftA
     C                   PARM                    TrExts                                       222373
      *
      ** Trade (file fields)
      *
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *
      ** Process SE1806 flag                                                                  209580
     C                   PARM      'N'           PUYAT             1                          209580
      *                                                                                       209580
      ** ISO15022 indicator - file field                                                      209580
     C                   PARM                    CA_T1NEW                                     209580
      *                                                                                       209580
      ** Default SSI Flag                                                                     209580
     C                   PARM      'N'           DftFlag           1                          209580
      *                                                                                       209580
      ** Fields in error
      *
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Destination of Settlement Text fields
      *
     C                   PARM                    A_DDROUS          6
     C                   PARM                    A_DDROTS         12
      *
      ** Destination of Confirmation Text fields
      *
     C                   PARM                    A_DDROUC          6
     C                   PARM                    A_DDROTC         12
      *
      ** Security report name
      *
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME                                      CAP067
      * Swift 2001 flag                                                                       CAP067
     C                   PARM                    CSW201            1                          CAP067
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL             1                          CAP067
      *
      ** Output Parameters: Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1            140951
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP009
      *
      ** F5 - Go To Initial Screen
      *
     C     @INKE         CASEQ     '1'           SRP010
      *
      ** F12 - Cancel on Extension Screen
      *
     C     @INKL         CASEQ     '1'           SRP012
      *
      ** F14 - Return from F14 Ext. Settlements
      *
     C     @INKN         CASEQ     '1'           SRP015
      *
      ** Validate Input to Extension Screen
      *
     C                   CAS                     SRP016
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP008 - Process Extension (SWIFT) Screen B                  *
      *                                                               *
      *  Called By: P001   - Main Processing                          *
      *                                                               *
      *  Calls:     SRP009 - End Program                              *
      *             SRP010 - F5 is Selected                           *
      *             SRP015 - F14 is Selected                          *
      *             SRP016 - Validate Extension Screen A              *
      *                                                               *
      *****************************************************************
     C     SRP008        BEGSR
      *
      ** Write/Read Display - Extension Screen
      *
     C                   CALLB     'SETRADEDSP'
      *
      ** Input Parameters: Return Code
      *
     C                   PARM      *BLANK        RetCodeOut
      *
      ** Screen A/B
      *
     C                   PARM      'B'           Screen
      *
      ** Trade (In Screen Format) - Primary/Settlements/SWIFT
      *
     C                   PARM                    NewTrPrim
     C                   PARM                    NewTrSeco
     C                   PARM                    NewTrSett
     C                   PARM                    NewTrSwftB
     C                   PARM                    TrExts                                       222373
      *
      ** Trade (file fields)
      *
     C                   PARM                    TCNR
     C                   PARM                    TNMC
     C                   PARM                    NOML
     C                   PARM                    TDVD
     C                   PARM                    DELF
     C                   PARM                    DELT
      *
      ** Process SE1806 flag                                                                  209580
     C                   PARM      'N'           PUYAT                                        209580
      *                                                                                       209580
      ** ISO15022 indicator - file field                                                      209580
     C                   PARM                    CA_T1NEW                                     209580
      *                                                                                       209580
      ** Default SSI Flag                                                                     209580
     C                   PARM      'N'           DftFlag                                      209580
      *                                                                                       209580
      ** Fields in error
      *
     C                   PARM                    OKTrSwft
     C                   PARM                    OkTrExts                                     222373
      *
      ** Errors
      *
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      ** Warnings
      *
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      ** Destination of Settlement Text fields
      *
     C                   PARM                    B_DDROUS          6
     C                   PARM                    B_DDROTS         12
      *
      ** Destination of Confirmation Text fields
      *
     C                   PARM                    B_DDROUC          6
     C                   PARM                    B_DDROTC         12
      *
      ** Security report name
      *
     C**********         PARM                    DDSRPN                                       CAP067
     C                   PARM                    DDSRNME                                      CAP067
      * Swift 2001 flag                                                                       CAP067
     C                   PARM                    CSW201                                       CAP067
     C                   PARM                    PCALL                                        222373
      *                                                                                       CAP067
      ** Buy-sell back                                                                        CAP067
     C                   PARM      'N'           PBYSL                                        CAP067
      *
      ** Output Parameters: Function Keys
      *
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKE             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKN             1
      *
      ** Write screen with no read indicator
      *
     C                   PARM      'N'           WriteOnly         1
                                                                                              CSD015
      **  Extra parameter needed to pass detail for Midas Compliance                          CSD015
      **  Watch Enhancement.                                                                  CSD015
     C                   PARM                    PMCWL                                        CSD015
      * API Trades Extended Settlements                                                       222373
     C                   PARM                    NwSEFilFmt                                   222373
      *
      ** Reset Errors
      *
     C                   MOVE      *ALL'Y'       OKTrSwft
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      ** F3 - End Program
      *
     C     @INKC         CASEQ     '1'           SRP009
      *
      ** F12 - Cancel on Extension Screen
      *
     C     @INKL         CASEQ     '1'           SRP015
      *
      ** F14 - Return from F14 Ext. Settlements
      *
     C     @INKN         CASEQ     '1'           SRP016
      *
      ** Validate Input to Extension Screen
      *
     C                   CAS                     SRP010
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP009 - End Program                                         *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main/Second Screen       *
      *             SRP005 - Process Screen: Primary/Initial Screen   *
      *             SRP006 - Process Other Details Screen             *
      *             SRP007 - Process Extension (SWIFT) Screen A       *
      *             SRP008 - Process Extension (SWIFT) Screen B       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP009        BEGSR
      *
     C                   Eval      PRET = 'Q'
     C                   Eval      WSCRN = 'T'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP010 - F05 is Selected                                     *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main/Second Screen       *
      *             SRP005 - Process Screen: Primary/Initial Screen   *
      *             SRP007 - Process Extension (SWIFT) Screen A       *
      *             SRP008 - Process Extension (SWIFT) Screen B       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP010        BEGSR
      *
     C                   Eval      WSCRN = 'P'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP011 - F12 is Selected                                     *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main/Second Screen       *
      *             SRP005 - Process Screen: Primary/Initial Screen   *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP011        BEGSR
      *
     C                   Eval      WSCRN = 'T'
     C                   Eval      PRET = 'P'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP012 - Validate Main/Secondary Screen                      *
      *                                                               *
      *  Called By: SRP004 - Process Screen: Main/Second Screen       *
      *             SRP007 - Process Extension (SWIFT) Screen A       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP012        BEGSR
      *
     C                   IF        CAS006 = 'Y'  AND  WSCRN = 'S'                             CAS006
     C                   EVAL      WSCRN = 'H'                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   Eval      WSCRN = 'O'
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP013 - Validate Primary/Initial Screen                     *
      *                                                               *
      *  Called By: SRP005 - Process Screen: Primary/Initial Screen   *
      *             SRP006 - Process Other Details Screen             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP013        BEGSR
      *
     C                   IF        CAS006 = 'Y'  AND  WSCRN = 'O'                             CAS006
     C                   EVAL      WSCRN = 'H'                                                CAS006
     C                   ELSE                                                                 CAS006
     C                   Eval      WSCRN = 'S'
     C                   ENDIF                                                                CAS006
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP014 - Validate Other Details Screen                       *
      *                                                               *
      *  Called By: SRP006 - Process Other Details Screen             *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP014        BEGSR
      *
      ** If MT5XX Message Generation is installed, display the extension
      ** (SWIFT) details, Else, Go to initial screen
      *
     C     S01401        IFEQ      'Y'
     C                   MOVEL     'A'           WSCRN
     C                   ELSE
     C                   MOVEL     'P'           WSCRN
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP015 - F14 is Selected                                     *
      *                                                               *
      *  Called By: SRP007 - Process Extension (SWIFT) Screen A       *
      *             SRP008 - Process Extension (SWIFT) Screen B       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP015        BEGSR
      *
     C                   Eval      WSCRN = 'A'
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      *                                                               *
      *  SRP016 - Validate Extension Screen A                         *
      *                                                               *
      *  Called By: SRP007 - Process Extension (SWIFT) Screen A       *
      *             SRP008 - Process Extension (SWIFT) Screen B       *
      *                                                               *
      *  Calls:     None                                              *
      *                                                               *
      *****************************************************************
     C     SRP016        BEGSR
      *
      ** If screen B can't be displayed, go to initial screen
      ** Else, Go to EXTENSION (SWIFT) screen B
      *
     C     Display_B     IFNE      'Y'
     C                   Eval      WSCRN = 'P'
     C                   ELSE
     C                   Eval      WSCRN = 'B'
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRP017 - Process Third Details Screen                        *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRP017        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Get Net Treasury Coupon Rate                                                         CAS006
                                                                                              CAS006
     C                   EVAL      SE_SDSN = DDSESN                                           CAS006
     C                   EVAL      SE_SDET = 'IR'                                             CAS006
     C                   EVAL      SE_SDED = TDVD                                             CAS006
                                                                                              CAS006
     C     KSECEO        SETLL     SECEO                                                      CAS006
     C                   READ      SECEO                                                      CAS006
                                                                                              CAS006
     C                   IF        %FOUND(SECEO)  AND  SE_SDSN = DDSESN  AND                  CAS006
     C                             SE_SDET = 'IR'                                             CAS006
     C                   EVAL      WrkNTCR = SE_SDNN                                          CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      WrkNTCR = CPNN                                             CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Format screen field                                                                  CAS006
                                                                                              CAS006
     C                   IF        WrkNTCR <> 0                                               CAS006
     C                   MOVE      *BLANKS       ZFLD15                                       CAS006
     C                   MOVE      WrkNTCR       ZFLD15                                       CAS006
     C                   EVAL      ZDECS = 7                                                  CAS006
     C                   EVAL      ZECODE = *BLANK                                            CAS006
                                                                                              CAS006
     C                   CALLB     'ZSEDIT'                                                   CAS006
     C                   PARM                    ZFLD15                                       CAS006
     C                   PARM                    ZDECS                                        CAS006
     C                   PARM                    ZECODE                                       CAS006
     C                   PARM                    ZOUT21                                       CAS006
                                                                                              CAS006
     C                   MOVE      ZOUT21        DDHACR                                       CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
      ** Write/Read Display - Other Details Screen                                            CAS006
                                                                                              CAS006
     C                   CALLB     'SETRADTDSP'                                               CAS006
                                                                                              CAS006
      ** INPUTS                                                                               CAS006
      ** Return code                                                                          CAS006
                                                                                              CAS006
     C                   PARM      *BLANKS       RetCodeOut                                   CAS006
                                                                                              CAS006
      ** Trade in screen format                                                               CAS006
                                                                                              CAS006
     C                   PARM                    NewTrPrim                                    CAS006
     C                   PARM                    NewTrThir                                    CAS006
                                                                                              CAS006
      ** Trade status                                                                         CAS006
      ** Security report name                                                                 CAS006
      ** Coupon Rate using Net Treasury Rate                                                  CAS006
      ** Net Treasury Price                                                                   CAS006
                                                                                              CAS006
     C                   PARM                    DDSTAT                                       CAS006
     C                   PARM                    DDSRNME                                      CAS006
     C                   PARM                    DDHACR                                       CAS006
     C                   PARM                    DDPRICN                                      CAS006
                                                                                              CAS006
      ** Trade incomplete ind                                                                 CAS006
                                                                                              CAS006
     C                   PARM                    C_TINC                                       CAS006
                                                                                              CAS006
      ** Security Details                                                                     CAS006
      ** Investment Type Details                                                              CAS006
                                                                                              CAS006
     C                   PARM                    SECTY                                        CAS006
     C                   PARM                    INVTP                                        CAS006
                                                                                              CAS006
      ** Buy-sell back                                                                        CAS006
                                                                                              CAS006
     C                   PARM      'N'           PBYSL                                        CAS006
                                                                                              CAS006
      ** Fields in error                                                                      CAS006
                                                                                              CAS006
     C                   PARM                    OKTrThir                                     CAS006
                                                                                              CAS006
      ** Errors                                                                               CAS006
                                                                                              CAS006
     C                   PARM                    FldNameArr                                   CAS006
     C                   PARM                    MsgIdArr                                     CAS006
     C                   PARM                    MsgDtaArr                                    CAS006
                                                                                              CAS006
      ** Warnings                                                                             CAS006
                                                                                              CAS006
     C                   PARM                    WFldNamArr                                   CAS006
     C                   PARM                    WMsgIdArr                                    CAS006
     C                   PARM                    WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** OUTPUTS                                                                              CAS006
      ** Function keys                                                                        CAS006
                                                                                              CAS006
     C                   PARM      '0'           @INKC                                        CAS006
     C                   PARM      '0'           @INKE                                        CAS006
     C                   PARM      '0'           @INKL                                        CAS006
                                                                                              CAS006
      ** Write screen with no read indicator                                                  CAS006
                                                                                              CAS006
     C                   PARM      'N'           WriteOnly                                    CAS006
                                                                                              CAS006
      ** Reset errors                                                                         CAS006
                                                                                              CAS006
     C                   MOVE      *ALL'Y'       OKTrThir                                     CAS006
     C                   MOVEL     *BLANK        FldNameArr                                   CAS006
     C                   MOVEL     *BLANK        MsgIdArr                                     CAS006
     C                   MOVEL     *BLANK        MsgDtaArr                                    CAS006
     C                   MOVEL     *BLANK        WFldNamArr                                   CAS006
     C                   MOVEL     *BLANK        WMsgIdArr                                    CAS006
     C                   MOVEL     *BLANK        WMsgDtaArr                                   CAS006
                                                                                              CAS006
      ** F3 - End Program                                                                     CAS006
                                                                                              CAS006
     C     @INKC         CASEQ     '1'           SRP009                                       CAS006
                                                                                              CAS006
      ** F5 - Go to Initial Screen                                                            CAS006
                                                                                              CAS006
     C     @INKE         CASEQ     '1'           SRP010                                       CAS006
                                                                                              CAS006
      ** F12 - Cancel on Secondary Screen                                                     CAS006
                                                                                              CAS006
     C     @INKL         CASEQ     '1'           SRP013                                       CAS006
                                                                                              CAS006
      ** Validate Input to Third screen                                                       CAS006
                                                                                              CAS006
     C                   CAS                     SRP018                                       CAS006
                                                                                              CAS006
     C                   ENDCS                                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************                       CAS006
      *                                                               *                       CAS006
      *  SRP018 - Validate Third Screen                               *                       CAS006
      *                                                               *                       CAS006
      *****************************************************************                       CAS006
                                                                                              CAS006
     C     SRP018        BEGSR                                                                CAS006
                                                                                              CAS006
      ** Go to Other Details screen                                                           CAS006
                                                                                              CAS006
     C                   EVAL      WSCRN = 'O'                                                CAS006
                                                                                              CAS006
     C                   ENDSR                                                                CAS006
                                                                                              CAS006
      *****************************************************************                       CAS006
      /EJECT                                                                                  CAS006
      *****************************************************************
      *                                                               *
      *  *INZSR - Initial Processing                                  *
      *                                                               *
      *  Calls:     AOBANKR0 - Bank ICD Access Object                 *
      *             AOSARDR0 - Switchable Features Access Object      *
      *             AOMMODR0 - Midas Module Access Object             *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      ** Initialize program name
      *
     C                   MOVEL     'SETRADSIN'   DBPGM
      *
      ** Access Bank Details
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       PRTCD             7
     C                   PARM      '*FIRST '     POPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     POPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access SAR details file to determine if S01401
      ** (MT5XX Message Generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'S01401'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     'S01401'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           S01401            1
     C                   ELSE
     C                   MOVEL     'N'           S01401
     C                   END
      *
      ** Access SAR details file to determine if CSW003
      ** (MT5XX - Phase 2 message generation) is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   PARM      *BLANKS       PRTCD
     C                   PARM      '*VERIFY'     POPTN
     C                   PARM      'CSW003'      PSARD             6
     C     SCSARD        PARM      SCSARD        DSFDY
      *
      ** Database Error
      *
     C     PRTCD         IFNE      *BLANKS
     C     PRTCD         ANDNE     '*NRF   '
     C                   MOVEL     'SCSARDPD'    DBFILE
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     'CSW003'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
     C     PRTCD         IFEQ      *BLANK
     C                   MOVEL     'Y'           CSW003            1
     C                   ELSE
     C                   MOVEL     'N'           CSW003
     C                   END
                                                                                              CAP067
      ** Check if CSW201 - Swift 2001 Standards Update is installed                           CAP067
                                                                                              CAP067
     C                   CALL      'SWIF2001'                           9090                  CAP067
     C                   PARM      *BLANKS       @RTCD                                        CAP067
                                                                                              CAP067
     C                   IF        *IN90 = *ON                                                CAP067
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP067
     C                   EVAL      DBASE = 912                                                CAP067
     C                   EVAL      DBKEY = 'CSW201'                                           CAP067
     C                   EXSR      *PSSR                                                      CAP067
                                                                                              CAP067
     C                   ELSE                                                                 CAP067
     C                   IF        @RTCD = 'CSW2001'                                          CAP067
     C                   EVAL      CSW201 = 'Y'                                               CAP067
     C                   ELSE                                                                 CAP067
     C                   EVAL      CSW201 = 'N'                                               CAP067
     C                   ENDIF                                                                CAP067
     C                   ENDIF                                                                CAP067
                                                                                              CAS006
      ** Check if enhancement CAS006 (Hedge Accounting Phase B) is installed                  CAS006
                                                                                              CAS006
     C                   CALLB     'AOSARDR0'                                                 CAS006
     C                   PARM      *BLANKS       PRTCD                                        CAS006
     C                   PARM      '*VERIFY'     POPTN                                        CAS006
     C                   PARM      'CAS006'      PSARD                                        CAS006
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAS006
                                                                                              CAS006
     C                   IF        PRTCD <> *BLANKS  AND  PRTCD <> '*NRF   '                  CAS006
     C     *LOCK         IN        LDA                                                        CAS006
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAS006
     C                   EVAL      DBKEY  = 'CAS006'                                          CAS006
     C                   EVAL      DBASE  = 904                                               CAS006
     C                   OUT       LDA                                                        CAS006
     C                   EXSR      *PSSR                                                      CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CAS006
     C                   IF        PRTCD = *BLANKS                                            CAS006
     C                   EVAL      CAS006 = 'Y'                                               CAS006
     C                   ELSE                                                                 CAS006
     C                   EVAL      CAS006 = 'N'                                               CAS006
     C                   ENDIF                                                                CAS006
                                                                                              CGL031
      ** Check if switchable feature CGL031 is switched on.                                   CGL031
                                                                                              CGL031
     C                   CALLB     'AOSARDR0'                                                 CGL031
     C                   PARM      *BLANKS       PRTCD                                        CGL031
     C                   PARM      '*VERIFY'     POPTN                                        CGL031
     C                   PARM      'CGL031'      PSARD                                        CGL031
     C     SCSARD        PARM      SCSARD        DSFDY                                        CGL031
      *                                                                                       CGL031
      ** Database Error                                                                       CGL031
      *                                                                                       CGL031
     C     PRTCD         IFNE      *BLANKS                                                    CGL031
     C     PRTCD         ANDNE     '*NRF   '                                                  CGL031
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CGL031
     C                   MOVEL     '905'         DBASE                                        CGL031
     C                   MOVEL     'CGL031'      DBKEY                                        CGL031
     C                   EXSR      *PSSR                                                      CGL031
     C                   END                                                                  CGL031
      *                                                                                       CGL031
     C     PRTCD         IFEQ      *BLANK                                                     CGL031
     C                   MOVEL     'Y'           CGL031                                       CGL031
     C                   ELSE                                                                 CGL031
     C                   MOVEL     'N'           CGL031                                       CGL031
     C                   END                                                                  CGL031
      *
      ** Entry Parameters
      *
     C     *ENTRY        PLIST
     C                   PARM                    PACT              1
     C                   PARM                    PREF              6
     C                   PARM                    PRET              1
                                                                                              CAS006
      ** Key list for LF/SECEO                                                                CAS006
                                                                                              CAS006
     C     KSECEO        KLIST                                                                CAS006
     C                   KFLD                    SE_SDSN                                      CAS006
     C                   KFLD                    SE_SDET                                      CAS006
     C                   KFLD                    SE_SDED                                      CAS006
      *
      ** Go to Initial Screen
      *
     C                   Move      'S'           WSCRN             1
      *
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
