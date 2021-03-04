     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments validation control 1')      *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY1VL  - FT Outgoing Payments Validation Module          *
      *                                                               *
      *  Function: This Program Validates FT Outgoing Payments for    *
      *            input to the Midas database.                       *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. CSD103             Date 10Aug20               *
      *  Prev Amend No. MD046248           Date 27Oct17               *
      *                 MD042042           Date 14Feb17               *
      *                 MD037529           Date 26Apr16               *
      *                 CFT142             Date 20Feb15               *
      *                 AR900506           Date 04Nov14               *
      *                 CFT157             Date 29Aug14               *
      *                 AR663078           Date 19Aug14               *
      *                 MD024280           Date 08Jan14               *
      *                 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CSD089             Date 07Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23798           Date 23Apr09               *
      *                 CER030             Date 09Jul08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 259767             Date 24Apr09               *
      *                 258229             Date 09Jan09               *
      *                 257361             Date 10Nov08               *
      *                 256919             Date 16Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul30               *
      *                 BUG16036           Date 28Feb08               *
      *                 BUG15510           Date 19Dec07               *
      *                 BUG15032           Date 17Oct07               *
      *                 250600             Date 07Oct07               *
      *                 BUG14771           Date 12Aug07               *
      *                 BUG14538A          Date 02Sep07               *
      *                 BUG14538           Date 03Aug07               *
      *                 CSW207A            Date 25Jul07               *
      *                 247142             Date 01Jun07               *
      *                 248095A            Date 26Jun07               *
      *                 BUG14042           Date 24May07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 246451             Date 16Mar07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 BUG12829           Date 04Dec06               *
      *                 242240             Date 20Oct06               *
      *                 BUG12705           Date 17Nov06               *
      *                 BUG12541           Date 13Nov06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 227538             Date 06Jun06               *
      *                 184008             Date 13Jul05               *
      *                 240689             Date 29Jun06               *
      *                 BUG9608            Date 13Dec05               *
      *                 240054             Date 14Jul06               *
      *                 237423             Date 28Jun06               *
      *                 238062             Date 23Mar06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 BUG6280            Date 15Mar05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4247            Date 14Sep04               *
      *                 CFT118             Date 16Aug04               *
      *                 CFT116             Date 12Jul04               *
      *                 BUG3281            Date 17Jun04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 14Jul03               *
      *                 CRE008             Date 19Feb02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01 -------------------------------------------*
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 01Nov00               *
      *                 190845             Date 12Mar01               *
      *                 CPB002             Date 08Aug00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 22Apr99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CSD103 - LIBOR Deregulation - Common Layer/Standing Data     *
      *           (Recompile)                                         *
      *  MD046248 - Finastra Rebranding                               *
      *  MD042042 - Input Officer 1 and Input Officer 2 are being     *
      *             populated with WIP authoriser. Use the WIP input  *
      *             user profile instead.                             *
      *  MD037529 - Incorrect defaulting of Add/deduct flag           *
      *  CFT142 - OPAY msg validation (LCO044)                        *
      *  AR900506 - Add/Deduct defaulting not occurring through API   *
      *             (Child: AR900507)                                 *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  AR663078 - Funds Check Error. Balance of the accounts used   *
      *           for Outgoing Payment transactions should be checked *
      *           during input.                                       *
      *  MD024280 - A database error was encountered in Messages to   *
      *             be processed thru FT screen                       *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_013 (Recompile)                *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_013, CFT148_014, CFT148_015,    *
      *           CFT148_016                                          *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CSD089 - Overrideable Errors Phase 2                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23798 - ODMTT not being populated correctly               *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  259767 - Fix 258229: in F12 replication, change of           *
      *           Ordering Customer does not pick up new Default Chgs *
      *  258229 - FT fees and charges - Wrong amendment of payment    *
      *           (refreshing commission)                             *
      *  257361 - Pass SDFTFR to FTVODCS in case Warning message      *
      *           ('Network TELEX must be defined in Standing data')  *
      *           which appears for Settlement type '02' (cheques)    *
      *  256919 - Field :52: is incorrectly processed on an MT202.    *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate.                *
      *  BUG16036 - Applied fix of BUG15510                           *
      *  BUG15510 - Charge Codes are set to blank upon completion     *
      *  BUG15032 - Error on Telex Charge Field                       *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  BUG14771 - Amended the input function and the message        *
      *             generation for CFT032                             *
      *  BUG14538A - Remove BUG14538 fix, already covered by 210654   *
      *  BUG14538 - CFT032 errors                                     *
      *  CSW207A - A serious midas error occurred because warning     *
      *  247142 - Funds Transfer allows payments over Blocked &       *
      *           Reffered Accounts without warning. Apply fix 210654.*
      *           Codes already done by 240689.                       *
      *  210654 - Check for blocked and referred accounts.            *
      *  248095A- Recompiled to ensure APISERVER job doesn't fail.    *
      *           Applied fix 245310D.                                *
      *  BUG14042 - CFT032 errors ; applied 13798                     *
      *  246451 - Applied Bugzilla fix 12829 from MP1_3.              *
      *  BUG12829 - ODMTT field not populated                         *
      *  242240 - Base currency fields cannot hold the converted      *
      *           values thus a Serious Midas Error occurs            *
      *  BUG12705 - Error in ordering customer       (Recompile)      *
      * BUG12541- Resolve the problem encountered in Beneficiary Type *
      *           and Ordering Type.                                  *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field                  *
      *  227538 - MT202 keyword data lost during insert of Payment.   *
      *           Applied fix 219470.                                 *
      *  184008 - Recompiled due to changes in FTVPYAM and FTVSECY.   *
      *  240689 - Applied fix 210654 + additional changes by 232151   *
      *  BUG9608- BUG7029 has moved ZMUSER check, should also have    *
      *           moved setup of JAVAUSER otherwise charges entered   *
      *           by user are overwritten by defaulted values         *
      *  240054 - Remove fix 238062.                                  *
      *  237423 - Do recalculations for pay amount if spread set is   *
      *           inserted during amendment of outgoing payment but   *
      *           do not redefault the charges.                       *
      *  238062 - Default Add/Deduct Indicator according to Details   *
      *           of Charges input.  Pass SDTCH to FTVSEIN.           *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  BUG6280- Charges entered by user overwritten by defaulted    *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4247- Format amount correctly when it contains dec.values *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand drafts printing - Upgrade to MidasPlus.      *
      *           Core hooks amended:FTOPA1VD01                       *
      *                              FTOPA1VC05                       *
      *                              FTOPA1VC01                       *
      *  CFT116   Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTOPA1VD01,FTOPA1VC05,FTOPA1VC01 *
      *  BUG3281 - Discrepancies on sources                           *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD                *
      *  CAP084 - MidasPlus                                           *
      *         - Reformat Settle & Pay Amount coming from MidasPlus  *
      *  CRE008 - Cash Management                                     *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Add extra fields for Message Unique Reference and   *
      *           Part Number                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - FONTIS : dealer's reference field                   *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ F-specs                              ¦
      ** ¦ =======                              ¦
      ** +--------------------------------------+
     F/COPY WNCPYSRC,FTOPA1VF01
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
      **    True       logical = *on (for indicator processing)
      **    False      logical = *off (for indicator processing)
      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
      **                                    handler)
      ** and the following variables:
      **    RunBefore  1A (for the PSSR)

     D/COPY ZACPYSRC,STD_D_SPEC

      ** Program Status Data Structure
      ** =============================
      ** The following /COPY line includes all the defined fields in the
      ** PSDS.  They have meaningful names, prefixed by 'PS'.

     D/COPY ZACPYSRC,PSDS
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.

     D/COPY ZACPYSRC,PROCPARMS

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
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

      ** +--------------------------------------+
      ** ¦ Named constants                      ¦
      ** ¦ ===============                      ¦
      ** +--------------------------------------+

      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
                                                                                            AR663078
      ** String for System Values Array                                                     AR663078
     D SysValOne       C                   CONST('FundsCheckOnInsert')                      AR663078
     D SysValTwo       C                   CONST('FundsCheckWarngOnly')                     AR663078

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+

     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)

     D POWER           S              7  3 DIM(7) CTDATA PERRCD(1)              POWERS TABLE

      * Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)

      * Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)

      ** Array of Fields with warnings.
     D WFldNmXAr       S             10A   DIM(XArrayMax)

      ** Array of warning message IDs
     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)

      ** Array of warning message data.
     D WMsgDtaXAr      S                   DIM(XArrayMax) LIKE(#MsgData)

      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D  DDCUST               180    185                                         CPB002

      * Incoming Transaction (previous Values)
     D PrevInPrim    E DS                  EXTNAME(FTOPY1PD)
     D                                     PREFIX(P#)
                                                                                CFT009
      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)   CFT009
     D NEWPMTSCN4    E DS                  EXTNAME(FTOPY6PD)                    CFT009
     D NEWPMTSCN4A   E DS                  EXTNAME(FTOPY6PD)                    BUG6280
     D                                     PREFIX(W#)                           BUG6280
                                                                                CFT014
      ** Payment Extension Details layout                                       CFT014
     D TranInPrmB    E DS                  EXTNAME(FTOPY1APD)                   CFT014
                                                                                CFT014
      ** Previous Payment Extension Details layout                              CFT014
     D PrevInPrmB    E DS                  EXTNAME(FTOPY1APD)                   CFT014
     D                                     PREFIX(P#)                           CFT014
                                                                                CFT014
      ** Valid Outgoing Payments Extension File                                 CFT014
     D ValidPmtX     E DS                  EXTNAME(FTVOPY2PD)                   CFT014

     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
     D/COPY OFCPYSRCZ,CFT148_013                                                              CFT148

      * Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)

      * Flags to indicate whether transaction fields are valid
     D OKFlagsDS     E DS                  EXTNAME(FTEOPY1PD)

      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @CDRO1        E                     EXTFLD(@CDRQQ)                                     CGL029
                                                                                CFT009
     D/COPY WNCPYSRC,FTH00231
      ** Valid Outgoing Payments Extension File (default)                       CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                   CFT009
     D                                     PREFIX(D#)                           CFT009
                                                                                CFT009
      * Valid Payments layout (default)                                         CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                   CFT009
     D                                     PREFIX(D#)                           CFT009

      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)

      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)

      * External DS for General Ledger details
     D SDGELR        E DS                  EXTNAME(SDGELRPD)

      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)

      * Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)

      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)

      * External DS for Customer details                                        CPB002
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CPB002
                                                                                CPB002
      ** For IBAN Customer Number calculations                                              AR663078
     D P@ACCN        E DS                  EXTNAME(ACCNTAB) PREFIX(IB)                      AR663078
                                                                                            AR663078
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)

      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
                                                                                CPB002
      * Third DS for access programs, Very long data structure                  CPB002
     D DSLDY         E DS                  EXTNAME(DSLDY)                       CPB002
      *                                                                                       CFT039
      ** FT OPAY API Ordering Bank Details                                                    CFT039
     D TranInfoFlds  E DS                  EXTNAME(FTOPIFPD)                                  CFT039
      *                                                                                       CFT039

      *  User / Branch data area
     D ZMUSER          DS            17
     D  WUSRID                 1     10                                                       CAP084
     D  WDFBR                 11     13
     D  WDPPT                 14     16

      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13

     D#DATE            DS             6
     D ODD                     1      2
     D OMM                     3      4
     D OYY                     5      6

     D                 DS
     D WZDATE                  1      6  0
     D  ZDD                    1      2
     D  ZMM                    3      4
     D  ZYY                    5      6
     D  ZYN                    5      6  0
     D/COPY WNCPYSRC,FTOPA1VD01
                                                                                CPB002
      **  Front Office (2 First characters determine System Front Office)       CPB002
     D FrontOffice     DS            20                                         CPB002
     D  W_System               1      2                                         CPB002
                                                                                              CGL014
      ** GL006000 parameter account details                                                   CGL014
     D WACCT           DS            24                                                       CGL014
     D   PACNUM                1      6                                                       CGL014
     D   PACCY                 7      9                                                       CGL014
     D   PAACOD               10     19                                                       CGL014
     D   PAACSQ               20     21                                                       CGL014
     D   PABRCA               22     24                                                       CGL014

     D/COPY WNCPYSRC,FTH00238
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

     D/COPY WNCPYSRC,FTH00281
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0

      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0

      * A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
                                                                                              CAP084
      *                                                                                       CAP084
     D*W#SSMAM******   S             14A   varying                                    CAP084 BUG4247
     D W#SSMAM         S             23A   varying                                           BUG4247
     D*W#SPYAM******   S             14A   varying                                    CAP084 BUG4247
     D W#SPYAM         S             23A   varying                                           BUG4247
     D W#SRATE         S             14A   varying                                            CAP084
     D Point@          S              2  0                                                   BUG4247
     D FSSMAM          S             23A                                                     BUG4247
     D FSPYAM          S             23A                                                     BUG4247
     D FMTOK           S              1A                                                     BUG4247

      * Response Mode, received as a parameter from the common header
     D RespMode        S              1A

     D ZDAYNO          S              5  0
     D ZDATE           S              6P 0
     D ZADATE          S              7

     D C#RTCD          S              7
     D C#OPTN          S              7
     D C#K101          S              3

     D WDATE           S              6  0
     D WK15_9          S             15  9
     D WORC115         S             15
     D WDST118         S             18
     D #I              S              2  0
                                                                                              CGL014
     D PTAMNT          S             15  0                                                    CGL014
     D PTCCY           S              3                                                       CGL014
     D PAACNO          S             10  0                                                    CGL014
     D PRTCD           S              7                                                       CGL014
     D Wx              S              2  0                                                    CGL014
     D Wwx             S              2  0                                                    CGL014

      **  Data Structure for input/output parameters                            CFT009
     D/COPY FTCPYSRC,FT0010D001                                                 CFT009
                                                                                CFT009

      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
      * Working Base Currency field                                                           242240
     D WBCQ15          S             15  0                                                    242240
      *                                                                                       242240
                                                                                              CFT032
     D WODMT18         S             18A                                                      CFT032
                                                                                              CFT032
      ** Work fields for ZALIGN                                                             BUG15032
     D ZAlignOk        S              1A                                                    BUG15032
     D ZFIELD          S             16A                                                    BUG15032
     D ZADEC           S              1  0                                                  BUG15032
     D ZADIG           S              2  0                                                  BUG15032
      *                                                                                     BUG15032
     D InputUser       S             10A                                                    MD042042
     D/COPY WNCPYSRC,FTH00239
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
      *****************************************************************
      /EJECT
      ** +--- Start of Main processing -----------------------------------+
      ** ¦                                                                ¦
      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
      ** ¦ executed at program activation.                                ¦
      ** ¦                                                                ¦
      ** +----------------------------------------------------------------+

     ************************** LEVEL ONE ******************************
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
      * If the user is connected via a browser, the job user name is QUSER -                 BUG9608
      * their user name is stored in ZMUSER                                                  BUG9608
                                                                                             BUG9608
     C     WUSRID        IFNE      *BLANKS                                                   BUG9608
     C     WUSRID        ANDNE     PSUser                                                    BUG9608
     C                   MOVE      'Y'           JAVAUSER          1                         BUG9608
     C                   ELSE                                                                BUG9608
     C                   MOVE      'N'           JAVAUSER                                    BUG9608
     C                   ENDIF                                                               BUG9608

     C* SEE IF PAYMENT DETAILS HAVE CHANGED
      * If the payment has been entered by the user, the settlement
      *  cannot be changed, but if the amount, currency, rate or
      *  override ind is changed, then the amounts will be re-calculat-
      *  ed.
      * If the payment has been generated from an incoming payment, the
      *  amounts, currencies, rate and override ind cannot be changed,
      *  but the settlement type must be entered.  This will cause the
      *  receive amount, which is zero when the payment is generated,
      *  to be calculated from the pay amount.
      *
      * Call Validation Modules in Sequence

     C/COPY WNCPYSRC,FTOPA1VC15
     C                   If        SACTION = 'A'
      * If coming from MidasPlus, the settle amount and the pay amount are formatted          CAP084
      * differently so we have to reformat these amounts so that the validation flag          CAP084
      * is correctly setup.                                                                   CAP084
      *                                                                                       CAP084
      **  Format Settlement Amount                                                            CAP084
      *                                                                                       CAP084
     C     JAVAUSER      IFEQ      'Y'                                                        CAP084
     C     SSMCY         IFNE      *BLANKS                                                    CAP084
     C     SSMAM         ANDNE     *BLANKS                                                    CAP084
      *                                                                                      BUG4247
      ** Perform initial format of amount                                                    BUG4247
      ** If amount contains a decimal value then no further formatting is needed             BUG4247
     C                   Eval      FSSMAM = *Blanks                                          BUG4247
     C                   Eval      W#SSMAM = *Blanks                                         BUG4247
     C                   Eval      Point@ = %scan(' ':SSMAM)                                 BUG4247
     C                   If        Point@ <> 0                                               BUG4247
     C                   Eval      W#SSMAM = %trimr(SSMAM)                                   BUG4247
     C                   Eval      %len(W#SSMAM) = Point@ - 1                                BUG4247
     C                   Move      W#SSMAM       FSSMAM                                      BUG4247
     C     '.'           SCAN      FSSMAM                                                    BUG4247
     C                   If        %found                                                    BUG4247
     C                   Eval      FMTOK = 'Y'                                               BUG4247
     C                   Else                                                                BUG4247
     C                   Eval      FMTOK = 'N'                                               BUG4247
     C                   EndIf                                                               BUG4247
     C                   EndIf                                                               BUG4247
                                                                                             BUG4247
      ** Further formatting required as we don't know the number of decimal places           BUG4247
     C                   If        FMTOK = 'N'                                               BUG4247
     C                   MOVE      SSMCY         @AJCD             3                          CAP084
      *                                                                                       CAP084
     C                   CALLB     'AOCURRR0'                                                 CAP084
     C                   PARM      *BLANK        @RTCD             7                          CAP084
     C                   PARM      '*KEY   '     @OPTN             7                          CAP084
     C                   PARM                    @AJCD                                        CAP084
      *                                                                                       CAP084
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP084
      *                                                                                       CAP084
     C**********         eval      W#SSMAM = %trim(SSMAM)                             CAP084 BUG4247
     C                   Z-ADD     0             @@AMTW                                       CAP084
     C                   MOVE      W#SSMAM       @@AMTW                                       CAP084
      *                                                                                       CAP084
     C                   SELECT                                                               CAP084
     C                   WHEN      A6NBDP=1                                                   CAP084
     C     @@AMTW        MULT      10            @@AMTW                                       CAP084
     C                   WHEN      A6NBDP=2                                                   CAP084
     C     @@AMTW        MULT      100           @@AMTW                                       CAP084
     C                   WHEN      A6NBDP=3                                                   CAP084
     C     @@AMTW        MULT      1000          @@AMTW                                       CAP084
     C                   ENDSL                                                                CAP084
                                                                                              CAP084
     C                   Z-ADD     A6NBDP        @@QECN                                       CAP084
                                                                                              CAP084
     C                   CALLB     'ZA0920'                                                   CAP084
     C                   PARM      *BLANK        @@RETC           10                          CAP084
     C                   PARM                    @@AMTW           13 0                        CAP084
     C                   PARM                    @@QECN            1 0                        CAP084
     C                   PARM      '.'           BNDCSP            1                          CAP084
     C                   PARM      *BLANK        @@AMTD           14                          CAP084
      *                                                                                       CAP084
     C                   MOVE      @@AMTD        SSMAM                                        CAP084
     C                   Else                                                                BUG4247
     C                   MOVE      FSSMAM        SSMAM                                       BUG4247
     C                   EndIf                                                               BUG4247
                                                                                             BUG4247
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
      ** Format Pay Amount                                                                    CAP084
      *                                                                                       CAP084
     C     SPCCY         IFNE      *BLANKS                                                    CAP084
     C     SPYAM         ANDNE     *BLANKS                                                    CAP084
      *                                                                                      BUG4247
      ** Perform initial format of amount                                                    BUG4247
      ** If amount contains a decimal value then no further formatting is needed             BUG4247
     C                   Eval      FSPYAM = *Blanks                                          BUG4247
     C                   Eval      W#SPYAM = *Blanks                                         BUG4247
     C                   Eval      Point@ = %scan(' ':SPYAM)                                 BUG4247
     C                   If        Point@ <> 0                                               BUG4247
     C                   Eval      W#SPYAM = %trimr(SPYAM)                                   BUG4247
     C                   Eval      %len(W#SPYAM) = Point@ - 1                                BUG4247
     C                   Move      W#SPYAM       FSPYAM                                      BUG4247
     C     '.'           SCAN      FSPYAM                                                    BUG4247
     C                   If        %found                                                    BUG4247
     C                   Eval      FMTOK = 'Y'                                               BUG4247
     C                   Else                                                                BUG4247
     C                   Eval      FMTOK = 'N'                                               BUG4247
     C                   EndIf                                                               BUG4247
     C                   EndIf                                                               BUG4247
                                                                                             BUG4247
      ** Further formatting required as we don't know the number of decimal places           BUG4247
     C                   If        FMTOK = 'N'                                               BUG4247
     C                   MOVE      SPCCY         @AJCD             3                          CAP084
      *                                                                                       CAP084
     C                   CALLB     'AOCURRR0'                                                 CAP084
     C                   PARM      *BLANK        @RTCD             7                          CAP084
     C                   PARM      '*KEY   '     @OPTN             7                          CAP084
     C                   PARM                    @AJCD                                        CAP084
      *                                                                                       CAP084
     C     SDCURR        PARM      SDCURR        DSSDY                                        CAP084
      *                                                                                       CAP084
     C                   Z-ADD     0             @@AMTW                                       CAP084
     C**********         eval      W#SPYAM = %trim(SPYAM)                             CAP084 BUG4247
     C                   MOVE      W#SPYAM       @@AMTW                                       CAP084
      *                                                                                       CAP084
     C                   SELECT                                                               CAP084
     C                   WHEN      A6NBDP=1                                                   CAP084
     C     @@AMTW        MULT      10            @@AMTW                                       CAP084
     C                   WHEN      A6NBDP=2                                                   CAP084
     C     @@AMTW        MULT      100           @@AMTW                                       CAP084
     C                   WHEN      A6NBDP=3                                                   CAP084
     C     @@AMTW        MULT      1000          @@AMTW                                       CAP084
     C                   ENDSL                                                                CAP084
                                                                                              CAP084
     C                   Z-ADD     A6NBDP        @@QECN                                       CAP084
                                                                                              CAP084
     C                   CALLB     'ZA0920'                                                   CAP084
     C                   PARM      *BLANK        @@RETC           10                          CAP084
     C                   PARM                    @@AMTW           13 0                        CAP084
     C                   PARM                    @@QECN            1 0                        CAP084
     C                   PARM      '.'           BNDCSP            1                          CAP084
     C                   PARM      *BLANK        @@AMTD           14                          CAP084
      *                                                                                       CAP084
     C                   MOVE      @@AMTD        SPYAM                                        CAP084
     C                   Else                                                                BUG4247
     C                   MOVE      FSPYAM        SPYAM                                       BUG4247
     C                   EndIf                                                               BUG4247
     C                   ENDIF                                                                CAP084
      * Format Rate                                                                           CAP084
     C     SRATE         IFNE      *BLANKS                                                    CAP084
     C                   eval      W#SRATE = %trim(SRATE)                                     CAP084
     C                   MOVE      *BLANKS       SRATE                                        CAP084
     C                   MOVE      W#SRATE       SRATE                                        CAP084
     C                   ENDIF                                                                CAP084
      *                                                                                       CAP084
     C                   ENDIF                                                                CAP084
      *
     C                   If        SSMCY = P#SSMCY and
     C                             SPCCY = P#SPCCY and
     C                             SSMAM = P#SSMAM and
     C                             SRATE = P#SRATE and
     C                             SPYAM = P#SPYAM and
     C                             SOVRD = P#SOVRD and
     C                             SSTTP = P#SSTTP
     C                   Eval      @AmtVal = 'N'
     C                   Else
     C                   Eval      @AmtVal = 'Y'
     C                   End

     C                   Else
     C                   Eval      @AmtVal = 'Y'
     C                   End

      * If Multi-Branching validate Booking and Originating branch
     C                   If        @MBIN = 'Y'
     C                   Exsr      VBRANCH
     C                   End

      * Validate Payment / Charge record
     C/COPY WNCPYSRC,FTH00381
     C                   If        OKOrbr = 'Y'
     C                   Exsr      VPYCHG
     C                   End
     C/COPY WNCPYSRC,FTH00382
                                                                                CPB002
      * Defautl Deal Type/Sub type if necessary                                 CPB002
      *                                                                         CPB002
     C                   Eval      P_Cust = *Blanks                             CPB002
     C                   Callb     'AOCUSTR1'                                   CPB002
     C                   Parm      *Blanks       @RTCD                          CPB002
     C                   Parm      '*KEY   '     @OPTN                          CPB002
     C                   Parm      DDCUST        @CUST            10            CPB002
     C                   Parm                    @KEY7             7            CPB002
     C     SDCUST        Parm      SDCUST        DSLDY                          CPB002
      *                                                                         CPB002
     C     BBPRBA        Ifeq      'Y'                                          CPB002
     C     @RTCD         Andeq     *Blanks                                      CPB002
     C                   Movel     BBCUST        P_Cust                         CPB002
     C                   Call      'PBDFST'                                     CPB002
     C                   Parm                    P_Cust            6            CPB002
     C                   Parm      SPYTP         P_DType           2            CPB002
     C                   Parm      SPYST         P_DSType          2            CPB002
     C                   Parm      SACTION       P_Action          1            CPB002
                                                                                CPB002
      * Defautl Deal Type                                                       CPB002
     C     P_DType       Ifne      *Blanks                                      CPB002
     C                   Eval      SPYTP = P_DType                              CPB002
     C                   Endif                                                  CPB002
                                                                                CPB002
      * Defautl Deal Sub Type                                                   CPB002
     C     P_DSType      Ifne      *Blanks                                      CPB002
     C                   Eval      SPYST = P_DSType                             CPB002
     C                   Endif                                                  CPB002
     C                   Endif                                                  CPB002

      * Validate Payment Type & Sub-Type
     C                   Exsr      VPYTYP

     C/COPY WNCPYSRC,FTOPA1VC10
      * Validate Destination
     C                   Exsr      VDESTIN
     C/COPY WNCPYSRC,FTOPA1VC11

      * Validate Ordering Customer
     C                   Exsr      VORDCUS

      * Validate Sender's Correspondent
     C                   Exsr      VSNDCOR

      * Validate Order Bank
     C                   Exsr      VORDBNK

      ** Only validate Notified Delivery currency and amount if SAR             CFT014
      ** CEU006 is installed. Pay Delivery currency and amount must             CFT014
      ** be validated if either of the two switchable feature is                CFT014
      ** ON (CEU006 or CFT014)                                                  CFT014
                                                                                CFT014
     C                   If        @CEU006 = 'Y'
     C                             Or @CFT014 = 'Y'                             CFT014
      * Validate Notified Delivery Currency & Amount
     C                   If        @CEU006 = 'Y'                                CFT014
     C                   Exsr      VNDLCA
     C                   EndIf                                                  CFT014

      * Validate Pay Delivery Currency & Amount
     C                   Exsr      VPDLCA

     C                   End

      * Validate Settle Currency & Amount
     C/COPY WNCPYSRC,FTOPA1VC06
     C                   Exsr      VSETCA
     C/COPY WNCPYSRC,FTOPA1VC07
                                                                                              CGL014
     C                   IF        @CGL014 = 'Y'  AND  OKORC1 <> 'N'  AND                     CGL014
     C                             OKORC2 <> 'N'  AND  OKORC3 <> 'N'  AND                     CGL014
     C                             OKORC4 <> 'N'  AND  OKORBK <> 'N'  AND                     CGL014
     C                             OKSMCY <> 'N'  AND  OKSMAM <> 'N'                          CGL014
     C                   IF        SACTION = 'I'  OR                                         BUG3281
     C                             (SACTION = 'A'  AND  OTOEDT = BJRDNB)                     BUG3281
                                                                                              CGL014
     C/COPY WNCPYSRC,FTOPA1VC14                                                               CGL014
     C                   EXSR      VSETBL                                                     CGL014
     C/COPY WNCPYSRC,FTOPA1VC15                                                               CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                               BUG3281

      * Validate Pay Currency & Amount
     C                   Exsr      VPAYCA
                                                                                CFT014
      ** Validate original exchange rate if MT103 message generation            CFT014
      ** is installed.                                                          CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   ExSr      SrOrRate                                     CFT014
     C                   Else                                                   CFT014
     C                   Eval      SOEXR = *Blanks                              CFT014
     C                   EndIf                                                  CFT014

      * Validate Override indicator
     C                   Exsr      VOVRRDE

      * Validate Settle Date
     C                   Exsr      VSETDAT

      * Validate Settle Plus Charges Indicator
     C                   Exsr      VPPLCHG

      * Validate Pay Date
     C                   Exsr      VPVDTAT
     C/COPY WNCPYSRC,FTH00282

      * Validate entered amounts agree
     C                   If        Idx = 0
     C                   Exsr      VEUXCHK
     C                   End

      * Validate Book Code
     C                   Exsr      VBKCODE

      * Validate Profit Centre
     C                   If        BKPRCU = 'Y'
     C                   Exsr      VPRFCTR
     C                   End

      * Validate Regular Payment flag
     C                   Exsr      VREGPAY

      * Validate Payment Frequency
     C                   Exsr      VPAYFRQ

      * Validate Day in Month
     C                   Exsr      VDAYMTH

      * Validate Final Payment Date
     C                   Exsr      VFINDAT

      * Validate Next Payment Date
     C                   Exsr      VNXTDAT

      * Validate Settlement Type
     C                   Exsr      VSETTYP

      * Validate Swift Code anf MT202 Indicator
     C/COPY WNCPYSRC,FTH00232
     C                   Exsr      VSWIFT
     C/COPY WNCPYSRC,FTH00233

      * Validate MT100 Customer
     C                   Exsr      VODMTX

      * Validate FX spread set and payment date offset code                     CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EXSR      VFXSP                                        CFT009
     C                   EXSR      VOFCD                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CDL049
      * Validate Reference Rate field                                           CDL049
     C                   IF        CDL049 = 'Y'                                 CDL049
     C                   EXSR      VRRAT                                        CDL049
     C                   ENDIF                                                  CDL049

      * Validate Base Currency Equivalent                                                     242240
     C                   EXSR      VBCQ                                                       242240
                                                                                              242240
     C/COPY WNCPYSRC,FTOPA1VC01
      *  *-------------------------------------------------------*
      *  * If no errors set up outstanding fields for valid file *
      *  *-------------------------------------------------------*

     C                   IF        Idx = 0
     C                   EXSR      SetupValid
      *                                                                                     AR663078
     C                   IF        FUNDCHECK = 'Y'                                          AR663078
      *                                                                                     AR663078
      ** If no errors check available balance                                               AR663078
      *                                                                                     AR663078
     C                   IF        Idx = 0                                                  AR663078
      *                                                                                     AR663078
      ** If Ordering Bank exists                                                            AR663078
      *                                                                                     AR663078
     C                   MOVEL     *Blanks       @ACNT                                      AR663078
      *                                                                                     AR663078
     C                   SELECT                                                             AR663078
      *                                                                                     AR663078
     C     OTORBT        WHENEQ    'N'                                                      AR663078
     C                   MOVEL     OTORBK        ##002A            2                        AR663078
     C                   MOVEL     ##002A        @ACNT                                      AR663078
      *                                                                                     AR663078
     C     OTORBT        WHENEQ    'R'                                                      AR663078
     C                   MOVEL     OTORBK        ##010A           10                        AR663078
     C                   MOVEL     ##010A        @ACNT                                      AR663078
      *                                                                                     AR663078
     C     OTORBT        WHENEQ    'P'                                                      AR663078
     C                   MOVEL     OTORBK        @ACNT                                      AR663078
     C                   If        OTORBB <> *Blanks                                        AR663078
     C                   Movel     OTORBB        @BRCA                                      AR663078
     C                   Endif                                                              AR663078
      *                                                                                     AR663078
      ** Otherwise, Ordering Customer                                                       AR663078
      *                                                                                     AR663078
     C     OTORCT        WHENEQ    'P'                                                      AR663078
     C     OTORCT        OREQ      'R'                                                      AR663078
     C                   MOVEL     OTORC1        @ACNT                                      AR663078
      *                                                                                     AR663078
     C     OTORCT        WHENEQ    'I'                                                      AR663078
      *                                                                                     AR663078
      ** Determine corresponding Midas Account of IBAN Account                              AR663078
      *                                                                                     AR663078
     C                   MOVEL     OTORC1        P@IBAN                                     AR663078
     C                   MOVE      *BLANKS       DSSDY                                      AR663078
                                                                                            AR663078
     C                   CALL      'AOIBANR4'                                               AR663078
     C                   PARM      *BLANKS       @RTCD             7                        AR663078
     C                   PARM      '*KEY   '     @OPTN             7                        AR663078
     C                   PARM                    P@IBAN           34                        AR663078
     C     P@ACCN        PARM                    DSSDY                                      AR663078
      *                                                                                     AR663078
      ** Database Error                                                                     AR663078
      *                                                                                     AR663078
     C     @RTCD         IFNE      *BLANKS                                                  AR663078
     C                   MOVEL     'AOIBANR4'    DBFILE                                     AR663078
     C                   MOVEL     '007'         DBASE                                      AR663078
     C                   MOVEL     @OPTN         DBKEY                                      AR663078
     C                   EXSR      *PSSR                                                    AR663078
     C                   ENDIF                                                              AR663078
                                                                                            AR663078
     C                   MOVEL     IBACNO        @ACNT                                      AR663078
      *                                                                                     AR663078
     C                   OTHER                                                              AR663078
      *                                                                                     AR663078
     C                   GOTO      ENDORD                                                   AR663078
     C*                                                                                     AR663078
     C                   ENDSL                                                              AR663078
      *                                                                                     AR663078
      ** Call Funds Check program                                                           AR663078
      *                                                                                     AR663078
     C                   CALL      'FT0805'                                                 AR663078
     C                   PARM                    @ACNT            21                        AR663078
     C                   PARM      OTSMCY        @CCY              3                        AR663078
     C                   PARM                    @BRCA             3                        AR663078
     C                   PARM      OTSMAM        @SMAM            13 0                      AR663078
     C                   PARM      OTSLDT        @SLDT             5 0                      AR663078
     C                   PARM      *BLANKS       @RCD              1                        AR663078
     C                   PARM      *Blanks       @ORETB            5                        AR663078
      *                                                                                     AR663078
      * Check results and send messages                                                     AR663078
      *                                                                                     AR663078
     C     @RCD          IFEQ      'Y'                                                      AR663078
     C                   IF        FWARNING = 'N'                                           AR663078
     C                   MOVE      'N'           OKSmam                                     AR663078
     C                   ADD       1             Idx                                        AR663078
     C                   MOVEL     'SSMAM'       FldNamXAr(Idx)                             AR663078
     C                   MOVEL     'BAW0001'     MsgIdXAr(Idx)                              AR663078
      *                                                                                     AR663078
     C                   ELSE                                                               AR663078
      *                                                                                     AR663078
     C                   EVAL      OKSMAM = 'W'                                             AR663078
     C                   ADD       1             Wwx                                        AR663078
     C                   EVAL      WFldNmXAr(Wwx) = 'SSMAM'                                 AR663078
     C                   EVAL      WMsgIDXAr(Wwx) = 'BAW0001'                               AR663078
     C                   ENDIF                                                              AR663078
      *                                                                                     AR663078
     C                   ENDIF                                                              AR663078
     C     ENDORD        TAG                                                                AR663078
     C                   EXSR      UPDATERRS                                                AR663078
      *                                                                                     AR663078
     C                   ENDIF                                                              AR663078
     C                   ENDIF                                                              AR663078

      * Default charges                                                         CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   IF        SACTION = 'I' OR SACTION = 'A'               CFT009
     C**********         IF        SACTION = 'I'                                       CFT009 237423
      * For Midasplus users                                                                  BUG6280
      * Save charges values, if they have been entered then keep them instead                BUG6280
      * of overwriting with the defaults. Charges are always defaulted first but             BUG6280
      * the user may change them after this.                                                 BUG6280
     C                   Eval      NEWPMTSCN4A = NEWPMTSCN4                                  BUG6280
     C                   If        SACTION = 'I'                                              258229
     C                   Eval      NEWPMTSCN4A = *Blanks                                      259767
     C                   EXSR      DFTCHG                                       CFT009
     C                   EndIf                                                                258229
      * Check if charges fields were entered or previously defaulted                         BUG6280
      * If so then do not default                                                            BUG6280
     C**********         If        JAVAUSER = 'Y'                                     BUG6280 258229
     C                   IF        W#STRCD <> *BLANKS OR W#SCHCD <> *BLANKS OR               BUG6280
     C                             W#STXCD <> *BLANKS OR W#SCQCD <> *BLANKS OR               BUG6280
     C                             W#SCSTD <> *BLANKS OR W#SSPCD <> *BLANKS OR               BUG6280
     C                             W#SMSCD <> *BLANKS OR W#SRCRM <> *BLANKS OR               BUG6280
     C                             W#SSCH1 <> *BLANKS OR W#SSCH2 <> *BLANKS OR               BUG6280
     C                             W#SSCH3 <> *BLANKS OR W#SSCH4 <> *BLANKS OR               BUG6280
     C                             W#SSCH5 <> *BLANKS OR W#STCD <> *BLANKS OR                BUG6280
     C                             W#M1CD <> *BLANKS OR W#M2CD <> *BLANKS OR                 BUG6280
     C                             W#M3CD <> *BLANKS OR W#M4CD <> *BLANKS OR                 BUG6280
     C                             W#M5CD <> *BLANKS OR SACTION = 'A'                         237423
     C**********                   W#M5CD <> *BLANKS                                  BUG6280 237423
     C                   Eval      NEWPMTSCN4 = NEWPMTSCN4A                                  BUG6280
      **  If amend and Ordering Customer or Bank has changed, reperform Default Charges       249767
     C                   If        SACTION  = 'A' And                                         259767
     C                             SORBK  <>  P#SORBK                                         259767
     C                             Or SACTION = 'A' And                                       259767
     C                             SORC1  <>  P#SORC1                                         259767
     C                   EXSR      DFTCHG                                                     259767
     C                   EndIf                                                                259767
     C                   ENDIF                                                               BUG6280
     C**********         ENDIF                                                        BUG6280 258229
     C**********         ENDIF                                                         CFT009 237423
      * Save defaults                                                           CFT009
     C                   CLEAR                   DEFVALID                       CFT009
     C                   CLEAR                   DEFVALIDX                      CFT009
      * Re-validate the defaulted rate, in case it's outside the allowed        CFT009
      * tolerance range                                                         CFT009
                                                                                CFT009
     C                   IF        Idx = 0                                      CFT009
                                                                                CFT009
      * Set up parms for call to FT0010                                         CFT009
                                                                                CFT009
     C                   Clear                   P#0010                         CFT009
                                                                                CFT009
     C                   Movel     'FTVAMAM'     P#PMSQ                         CFT009
                                                                                CFT009
     C                   Eval      P#NDCY = SNDCY                               CFT009
     C                   Eval      P#NDAM = @NDAM                               CFT009
     C                   Eval      P#DBCY = SSMCY                               CFT009
     C                   Eval      P#DBAM = @SMAM                               CFT009
     C                   Eval      P#DBDT = @SLDT                               CFT009
     C                   Eval      P#CRCY = SPCCY                               CFT009
     C                   Eval      P#CRAM = @PYAM                               CFT009
     C                   If        @CFT014 = 'N'                                CFT009
     C                   Eval      P#PDCY = SPDCY                               CFT009
     C                   Eval      P#PDAM = @PDAM                               CFT009
     C                   EndIf                                                  CFT009
     C                   Eval      P#CRDT = @PVDT                               CFT009
     C                   Eval      P#RATE = OTRATE                              CFT009
     C                   Eval      P#OVRT = SOVRD                               CFT009
     C                   Eval      P#SDIN = 'Y'                                 CFT009
     C                   Eval      P#RTDS = @RATDIS                             CFT009
     C                   MoveL     'FTOPAY1VL'   P#PMSQ                         CFT009
                                                                                CFT009
     C                   CallB     'FT0010'                                     CFT009
     C                   Parm                    P#0010                         CFT009
                                                                                CFT009
      * Check indicator for rate problem                                        CFT009
                                                                                CFT009
     C                   If        %subst(P#INDC:5:1) = '1'                     CFT009
     C**********         Move      'N'           OKRate                                CFT009 CSD089
     C**********         Add       1             Idx                                   CFT009 CSD089
     C**********         Movel     'SRATE'       FldNamXAr(Idx)                        CFT009 CSD089
     C**********         Movel     'MMA1019'     MsgIdXAr(Idx)                         CFT009 CSD089
     C                   Move      'W'           OKRate                                       CSD089
     C                   Add       1             WIdx                                         CSD089
     C                   Eval      WFldNmXAr(WIdx) = 'SRATE'                                  CSD089
     C                   Eval      WMsgIdXAr(WIdx) = 'MMA1019'                                CSD089
     C                   End                                                    CFT009
                                                                                CFT009
      * Update error info with that returned from the validation module         CFT009
     C                   Exsr      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
                                                                                CFT009
      * If the payment and settle dates are blank, call FT000983 to             CFT009
      * fill them in.                                                           CFT009
                                                                                CFT009
     C                   IF        SPYDT = *Blanks or SPYVD = *Blanks           CFT009
                                                                                CFT009
      * First, get the location codes                                           CFT009
                                                                                CFT009
     C                   MOVE      VALIDPMNT     P_TransDet                     CFT009
     C                   MOVE      VALIDPMTX     P_TransExt                     CFT009
                                                                                CFT009
     C                   CallB     'FTRTVLOC'                                   CFT009
     C                   Parm                    RetCodeOut                     CFT009
     C                   Parm      'OP'          P_TransType       2            CFT009
     C                   Parm                    P_TransDet     3000            CFT009
     C                   Parm                    P_TransExt     3000            CFT009
     C                   Parm      *Blanks       SettDateLoc       3            CFT009
     C                   Parm      *Blanks       PayDateLoc        3            CFT009
                                                                                CFT009
      * Now get the payment and settlement dates                                CFT009
                                                                                CFT009
     C                   CALLB     'FT000983'                                   CFT009
     C                   PARM                    RETCDE983        10            CFT009
     C                   PARM      SOFCD         SOFCD983          5            CFT009
     C                   PARM      SPYDT         WPYDT983          6            CFT009
     C                   PARM      SPYVD         WPYVD983          6            CFT009
     C                   PARM      SSMCY         SMCY983           3            CFT009
     C                   PARM      SPCCY         PCCY983           3            CFT009
     C                   PARM      SettDateLoc   SETLOC983         3            CFT009
     C                   PARM      PayDateLoc    PAYLOC983         3            CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   EVAL      DEFVALID = VALIDPMNT                         CFT009
     C                   EVAL      DEFVALIDX = VALIDPMTX                        CFT009
                                                                                CFT009
     C                   ENDIF                                                  CFT009
     C                   ENDIF                                                  CFT009

     C                   ENDIF
      *
     ************************** LEVEL ONE END **************************

      * RETURN
      *
     C                   RETURN
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBRANCH  - Validate Booking/Originating Branches
      *****************************************************************
     C     VBRANCH       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

     C/COPY WNCPYSRC,FTH00372
      ** Validate
     C                   CALLB     'FTVBKBH'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      ** Response mode (1A, from caller (A=Asynchronous, S=Synchronous))
     C                   PARM                    RespMode

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTH00373


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPYCHG  - Validate Payment / Change record
      *****************************************************************
     C     VPYCHG        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVPYCH'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      **********                                                                    BUG14042 CSW207A
     C**********         Parm                    WFldNmXAr                          BUG14042 CSW207A
     C**********         Parm                    WMsgIDXAr                          BUG14042 CSW207A
     C**********         Parm                    WMsgDtaXAr                         BUG14042 CSW207A

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPYTYP  - Validate Payment Type & Sub-Type
      *****************************************************************
     C     VPYTYP        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVPYTY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDESTIN  - Validate Destination
      *****************************************************************
     C     VDESTIN       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTOPA1VC12

      ** Validate
     C                   CALLB     'FTVDNDN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC16

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      *****************************************************************
      ** VORDCUS  - Validate Ordering Customer
      *****************************************************************
     C     VORDCUS       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

     C/COPY WNCPYSRC,FTOPA1VC17
     C/COPY OFCPYSRCZ,CFT148_014                                                              CFT148
      ** Validate
     C                   CALLB     'FTVODCS'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                   CFT032
     C/COPY OFCPYSRCZ,CFT148_015                                                              CFT148

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689

      ***Warning*fields/message*IDs/message*data*(arrays)*from/to*caller          BUG14538 BUG14538A
     C**********         Parm                    WFldNmXAr                        BUG14538 BUG14538A
     C**********         Parm                    WMsgIDXAr                        BUG14538 BUG14538A
     C**********         Parm                    WMsgDtaXAr                       BUG14538 BUG14538A
      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
                                                                                              257361
      *  Funds Transfer Details                                                               257361
     C                   Parm                    SDFTFR                                       257361
                                                                                              257361
     C                   Parm                    CFT142            1                          CFT142
                                                                                              CFT142
     C/COPY WNCPYSRC,FTOPA1VC18

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSNDCOR  - Validate Sender's Correspondent
      *****************************************************************
     C     VSNDCOR       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTOPA1VC19

      *  Validate
     C                   CALLB     'FTVSNCR'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC20

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VORDBNK  - Validate Order Bank
      *****************************************************************
     C     VORDBNK       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTOPA1VC21

      * Validate
     C                   CALLB     'FTVODBK'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
                                                                                              240689
     C                   Parm                    WFldNmXAr                                    240689
     C                   Parm                    WMsgIDXAr                                    240689
     C                   Parm                    WMsgDtaXAr                                   240689

      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC22

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNDLCA  - Validate Notified delivery Currency & Amount
      *****************************************************************
     C     VNDLCA        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      * Validate
     C                   CALLB     'FTVCYAM'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPDLCA  - Validate Pay delivery Currency & Amount
      *****************************************************************
     C     VPDLCA        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVPYCY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
     C/COPY WNCPYSRC,FTOPA1VC08
      *****************************************************************
      ** VSETCA  - Validate Settle Currency & Amount
      *****************************************************************
     C     VSETCA        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTH00240

      ** Validate
     C                   CALLB     'FTVSECY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      ** Warning fields/message IDs/message data (arrays) from/to caller                      CRE008
     C                   Parm                    WFldNmXAr                                    CRE008
     C                   Parm                    WMsgIDXAr                                    CRE008
     C                   Parm                    WMsgDtaXAr                                   CRE008
                                                                                              CRE008

      *  Settle currency - OK
      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

     C/COPY WNCPYSRC,FTH00241
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************                       CGL014
      ** VSETBL  - Additional validation on settlement amount                                 CGL014
      *****************************************************************                       CGL014
                                                                                              CGL014
     C     VSETBL        BEGSR                                                                CGL014
                                                                                              CGL014
      ** If ordering bank or ordering customer is retail                                      CGL014
                                                                                              CGL014
     C                   IF        @ORBT = 'R'  OR  @ORCT = 'R'                               CGL014
                                                                                              CGL014
      ** Reset variables updated by each module                                               CGL014
                                                                                              CGL014
     C                   EXSR      RESETERRS                                                  CGL014
     C                   EVAL      Wx = 0                                                     CGL014
     C                   EVAL      Wwx = 0                                                    CGL014
                                                                                              CGL014
     C                   IF        @ORBT = 'R'                                                CGL014
     C                   EVAL      WACCT = @ORBDS                                             CGL014
     C                   ELSE                                                                 CGL014
                                                                                              CGL014
     C                   IF        @ORCT = 'R'                                                CGL014
     C                   EVAL      WACCT = @ORCDS                                             CGL014
     C                   ENDIF                                                                CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   Z-ADD     @SMAM         PTAMNT                                       CGL014
                                                                                              CGL014
     C                   CALLB     'GL006000'                                                 CGL014
     C                   PARM                    PTAMNT                                       CGL014
     C                   PARM      SSMCY         PTCCY                                        CGL014
     C                   PARM                    PABRCA                                       CGL014
     C                   PARM                    PACNUM                                       CGL014
     C                   PARM                    PACCY                                        CGL014
     C                   PARM                    PAACOD                                       CGL014
     C                   PARM                    PAACSQ                                       CGL014
     C                   PARM      0             PAACNO                                       CGL014
     C                   PARM      *BLANKS       PRTCD                                        CGL014
                                                                                              CGL014
      ** Error:  Available balance is not sufficient                                          CGL014
      ** to cover blocked amount                                                              CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*BLKERR'                                          CGL014
     C**********         EVAL      OKSMAM = 'N'                                        CGL014 CSD089
     C**********         ADD       1             Wx                                    CGL014 CSD089
     C**********         EVAL      FldNamXAr(Wx) = 'SSMAM'                             CGL014 CSD089
     C**********         EVAL      MsgIdXAr(Wx) = 'MMA0862'                            CGL014 CSD089
     C                   EVAL      OKSMAM = 'W'                                               CSD089
     C                   ADD       1             Wwx                                          CSD089
     C                   EVAL      WFldNmXAr(Wwx) = 'SSMAM'                                   CSD089
     C                   EVAL      WMsgIDXAr(Wwx) = 'MMA0862'                                 CSD089
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Warning:  Balance is greater than blocked amount but less                            CGL014
      ** than minimum balance; minimum balance will be exceeded                               CGL014
                                                                                              CGL014
     C                   IF        PRTCD = '*WARN  '                                          CGL014
     C                   EVAL      OKSMAM = 'W'                                               CGL014
     C                   ADD       1             Wwx                                          CGL014
     C                   EVAL      WFldNmXAr(Wwx) = 'SSMAM'                                   CGL014
     C                   EVAL      WMsgIDXAr(Wwx) = 'MMA0863'                                 CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
      ** Update error info with that returned from the validation module                      CGL014
                                                                                              CGL014
     C                   EXSR      UPDATERRS                                                  CGL014
                                                                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   ENDSR                                                                CGL014
                                                                                              CGL014
      *****************************************************************                       CGL014
     C/EJECT                                                                                  CGL014
      *****************************************************************
      ** VPAYCA  - Validate Pay Currency & Amount
      *****************************************************************
     C     VPAYCA        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTH00242

      ** Validate
     C                   CALLB     'FTVPYAM'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTH00243

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************         CFT014
      /Title Sr/SrOrRate                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      *  SrOrRate  - Validate Original Rate                           *         CFT014
      *                                                               *         CFT014
      *  Called By: Main Processing                                   *         CFT014
      *                                                               *         CFT014
      *  Calls:                                                       *         CFT014
      *  RESETERRS  - Resets variables updated by each modules        *         CFT014
      *  FTVOEXR    - Original Rate Validation Module                 *         CFT014
      *  UPDATERRS  - Updates error information                       *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrOrRate      BegSr                                                  CFT014
                                                                                CFT014
      ** Reset variables updated by other modules                               CFT014
                                                                                CFT014
     C                   ExSr      ResetErrs                                    CFT014
                                                                                CFT014
      ** Validate original rate entry                                           CFT014
                                                                                CFT014
     C                   CallB     'FTVOEXR'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrmB                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    OKFlagsDS                      CFT014
     C                   Parm                    Val@Fields                     CFT014
                                                                                CFT014
      ** Update error info with that retured from the validation module         CFT014
                                                                                CFT014
     C                   ExSr      UpdatErrs                                    CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VOVRRDE - Validate Override indicator
      *****************************************************************
     C     VOVRRDE       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVODIN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSETDAT - Validate Settle date
      *****************************************************************
     C     VSETDAT       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTH00244

      ** Validate
     C                   CALLB     'FTVSEDT'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

     C/COPY WNCPYSRC,FTH00245
      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPPLCHG - VALIDATE SETTLE PLUS CHARGES INDOCATOR
      *****************************************************************
     C     VPPLCHG       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
      *                                                                                     AR900506
      ** Default Add/Deduct indicator if Details of Charges present                         AR900506
      ** This should only occur with a transaction passed through the                       AR900506
      ** API                                                                                AR900506
      *                                                                                     AR900506
     C                   IF        SADDC = *blank                                           AR900506
     C**********         IF        SDTCH = 'OUR'                                   AR900506 MD037529
     C                   IF        SDTCH = 'OUR' OR SDTCH = 'SHA'                           MD037529
     C                   EVAL      SADDC = 'A'                                  ADD         AR900506
     C                   ENDIF                                                              AR900506
     C**********         IF        SDTCH = 'SHA' or SDTCH = 'BEN'                  AR900506 MD037529
     C                   IF        SDTCH = 'BEN'                                            MD037529
     C                   EVAL      SADDC = 'D'                                  DEDUCT      AR900506
     C                   ENDIF                                                              AR900506
     C                   ENDIF                                                              AR900506

      ** Validate
     C                   CALLB     'FTVSEIN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      *  Bank ICD Details
     C                   Parm                    SDBANK

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
      **********                                                                       238062 240054
      ***Details*of*Charges********************************************                238062 240054
     C**********         Parm                    SDTCH                                 238062 240054


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPVDTAT - Validate Pay date
      *****************************************************************
     C     VPVDTAT       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTOPA1VC23

      ** Validate
     C                   CALLB     'FTVPYDT'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC24

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VEUXCHK - Validate amounts entered agree
      *****************************************************************
     C     VEUXCHK       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      * Validate
     C                   CALLB     'FTVAMAM'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                   CFT014

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
      *  Warning fields/message IDs/message data (arrays) from/to caller                      CSD089
     C                   Parm                    WFldNmXAr                                    CSD089
     C                   Parm                    WMsgIDXAr                                    CSD089
     C                   Parm                    WMsgDtaXAr                                   CSD089
                                                                                              CSD089
      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VBKCODE - Validate Book Code
      *****************************************************************
     C     VBKCODE       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTH00246

      ** Validate
     C                   CALLB     'FTVBKCD'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTH00247

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPRFCTR - Validate Profit Centre
      *****************************************************************
     C     VPRFCTR       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVPFPF'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VREGPAY - Validate Regular Payment flag
      *****************************************************************
     C     VREGPAY       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      ** Validate
     C                   CALLB     'FTVPYIN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VPAYFRQ - Validate Payment Frequency
      *****************************************************************
     C     VPAYFRQ       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      *  Validate
     C                   CALLB     'FTVPYFQ'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      ** OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VDAYMTH - Validate Day in Month
      *****************************************************************
     C     VDAYMTH       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      *  Validate
     C                   CALLB     'FTVPYDM'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      * OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields


      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VFINDAT - Validate Final Payment Date
      *****************************************************************
     C     VFINDAT       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      *  Validate
     C                   CALLB     'FTVFNPY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VNXTDAT - Validate Next Payment Date
      *****************************************************************
     C     VNXTDAT       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      *  Validate
     C                   CALLB     'FTVNXPY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

     C                   Parm                    WFldNmXAr
     C                   Parm                    WMsgIDXAr
     C                   Parm                    WMsgDtaXAr

      *  OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSETTYP - Validate Settlement Type
      *****************************************************************
     C     VSETTYP       BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

     C/COPY WNCPYSRC,FTOPA1VC02
      *  Validate
     C                   CALLB     'FTVSETY'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
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
     C/COPY WNCPYSRC,FTOPA1VC03

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
      *****************************************************************
      ** VSWIFT - Validate Swift Code & MT202 Indicator
      *****************************************************************
     C     VSWIFT        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS
     C/COPY WNCPYSRC,FTOPA1VC25

      *  Validate
     C                   CALLB     'FTVSFIN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      * OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC26

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/COPY WNCPYSRC,FTH00234
     C/EJECT
      *****************************************************************
      ** VODMTX - Validate MT100 Customer
      *****************************************************************
     C     VODMTX        BEGSR

      * Reset variables updated by each module
     C                   Exsr      RESETERRS

      *  Validate
     C                   CALLB     'FTVCSNM'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut

      *  Screen fields
     C                   Parm                    TranInPrim
     C                   Parm                    TranInPrmB                                 BUG12541

      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr

      *                                                                                      CSW207A
      ** Warning message parameters                                                          CSW207A
      *                                                                                      CSW207A
     C**********         Parm                    WFldNmXAr                          CSW207A BUG23798
     C**********         Parm                    WMsgIDXAr                          CSW207A BUG23798
     C**********         Parm                    WMsgDtaXAr                         CSW207A BUG23798
     C                   Parm                    WFldNmXAr                                  MD024280
     C                   Parm                    WMsgIDXAr                                  MD024280
     C                   Parm                    WMsgDtaXAr                                 MD024280
      * OK Flags
     C                   Parm                    OKFlagsDS

      *  Validation Work Fields
     C                   Parm                    Val@Fields

      * Update error info with that returned from the validation module
     C                   Exsr      UPDATERRS

     C                   ENDSR
      *****************************************************************
     C/EJECT
     C/COPY WNCPYSRC,FTOPA1VC27
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  VFXSP     - Validate FX Spread Set                           *         CFT009
      *                                                               *         CFT009
      *  Called By: Main Processing                                   *         CFT009
      *                                                               *         CFT009
      *  Calls:                                                       *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVFXSP01  - FX Spread Set Validation Module                 *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     VFXSP         BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate FX Spread Set                                                 CFT009
                                                                                CFT009
     C                   CALLB     'FTVFXSP01'                                  CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINPRMB                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
     C/EJECT                                                                    CFT009
      *****************************************************************         CFT009
      *                                                               *         CFT009
      *  VOFCD     - Validate Payment Date Offset Code                *         CFT009
      *                                                               *         CFT009
      *  Called By: Main Processing                                   *         CFT009
      *                                                               *         CFT009
      *  Calls:                                                       *         CFT009
      *  RESETERRS  - Resets variables updated by each modules        *         CFT009
      *  FTVPYCD    - Payment Date Offset Code Validation Module      *         CFT009
      *  UPDATERRS  - Updates error information                       *         CFT009
      *                                                               *         CFT009
      *****************************************************************         CFT009
                                                                                CFT009
     C     VOFCD         BEGSR                                                  CFT009
                                                                                CFT009
      ** Reset variables updated by other modules                               CFT009
                                                                                CFT009
     C                   EXSR      RESETERRS                                    CFT009
                                                                                CFT009
      ** Validate Payment Date Offset Code                                      CFT009
                                                                                CFT009
     C                   CALLB     'FTVPYCD'                                    CFT009
     C                   PARM                    RETCODEOUT                     CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINPRMB                     CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
     C/EJECT                                                                    CDL049
      *****************************************************************         CDL049
      *                                                               *         CDL049
      *  VRRAT     - Validate Reference Rate field                    *         CDL049
      *                                                               *         CDL049
      *  Called By: Main Processing                                   *         CDL049
      *                                                               *         CDL049
      *  Calls:                                                       *         CDL049
      *  RESETERRS  - Resets variables updated by each modules        *         CDL049
      *  FTVRRAT    - Reference Rate field Validation Module          *         CDL049
      *  UPDATERRS  - Updates error information                       *         CDL049
      *                                                               *         CDL049
      *****************************************************************         CDL049
                                                                                CDL049
     C     VRRAT         BEGSR                                                  CDL049
                                                                                CDL049
      ** Reset variables updated by other modules                               CDL049
                                                                                CDL049
     C                   EXSR      RESETERRS                                    CDL049
                                                                                CDL049
      ** Validate Reference Rate field                                          CDL049
                                                                                CDL049
     C                   CALLB     'FTVORRAT'                                   CDL049
     C                   PARM                    RETCODEOUT                     CDL049
     C                   PARM                    TRANINPRIM                     CDL049
     C                   PARM                    TranInPrmB                                   255711
     C                   PARM                    FLDNAMXAR                      CDL049
     C                   PARM                    MSGIDXAR                       CDL049
     C                   PARM                    MSGDTAXAR                      CDL049
     C                   PARM                    WFLDNMXAR                      CDL049
     C                   PARM                    WMSGIDXAR                      CDL049
     C                   PARM                    WMSGDTAXAR                     CDL049
     C                   PARM                    VAL@FIELDS                     CDL049
     C                   PARM                    OTRRAT                         CDL049
                                                                                CDL049
      ** Update error info with that returned from the validation module        CDL049
                                                                                CDL049
     C                   EXSR      UPDATERRS                                    CDL049
                                                                                CDL049
     C                   ENDSR                                                  CDL049
     C/COPY WNCPYSRC,FTOPA1VC13
      *****************************************************************
      /EJECT
      *****************************************************************                       242240
      *                                                               *                       242240
      *  VBCQ      - Validate Base Currency Equivalent                *                       242240
      *                                                               *                       242240
      *  Called By: Main Processing                                   *                       242240
      *                                                               *                       242240
      *  Calls:                                                       *                       242240
      *  RESETERRS  - Resets variables updated by each modules        *                       242240
      *  UPDATERRS  - Updates error information                       *                       242240
      *                                                               *                       242240
      *****************************************************************                       242240
                                                                                              242240
     C     VBCQ          BEGSR                                                                242240
                                                                                              242240
      ** Reset variables updated by other modules                                             242240
                                                                                              242240
     C                   EXSR      RESETERRS                                                  242240
                                                                                              242240
      * Validate Settlement Base Currency Equivalent                                          242240
     C                   Eval      #I = 4 + (@PCDP - @BCDP)                                   242240
     C                   If        @PMDIN = 0                                                 242240
     C                   Eval      WK15_9 = @PSPOT * POWER(#I)                                242240
     C                   Eval      WBCQ15 = @SMAM / WK15_9                                    242240
     C                   If        WBCQ15 > 9999999999999                                     242240
     C                   Add       1             Idx                                          242240
     C                   Movel     'SSMAM'       FldNamXAr(Idx)                               242240
     C                   Movel     'MMA2122'     MsgIdXAr(Idx)                                242240
     C                   End                                                                  242240
     C                   Else                                                                 242240
     C                   Eval      WK15_9 = @PSPOT / POWER(#I)                                242240
     C                   Eval      WBCQ15 = @SMAM * WK15_9                                    242240
     C                   If        WBCQ15 > 9999999999999                                     242240
     C                   Add       1             Idx                                          242240
     C                   Movel     'SSMAM'       FldNamXAr(Idx)                               242240
     C                   Movel     'MMA2122'     MsgIdXAr(Idx)                                242240
     C                   End                                                                  242240
     C                   End                                                                  242240
                                                                                              242240
      * Validate Pay Base Currency Equivalent                                                 242240
     C                   Eval      #I = 4 + (@RCDP - @BCDP)                                   242240
     C                   If        @RMDIN = 0                                                 242240
     C                   Eval      WK15_9 = @RSPOT * POWER(#I)                                242240
     C                   Eval      WBCQ15 = OTPYAM / WK15_9                                   242240
     C                   If        WBCQ15 > 9999999999999                                     242240
     C                   Add       1             Idx                                          242240
     C                   Movel     'SPYAM'       FldNamXAr(Idx)                               242240
     C                   Movel     'MMA2122'     MsgIdXAr(Idx)                                242240
     C                   End                                                                  242240
     C                   Else                                                                 242240
     C                   Eval      WK15_9 = @RSPOT / POWER(#I)                                242240
     C                   Eval      WBCQ15 = OTPYAM * WK15_9                                   242240
     C                   If        WBCQ15 > 9999999999999                                     242240
     C                   Add       1             Idx                                          242240
     C                   Movel     'SPYAM'       FldNamXAr(Idx)                               242240
     C                   Movel     'MMA2122'     MsgIdXAr(Idx)                                242240
     C                   End                                                                  242240
     C                   End                                                                  242240
                                                                                              242240
     C                   EXSR      UPDATERRS                                                  242240
                                                                                              242240
     C                   ENDSR                                                                242240
      /EJECT                                                                                  242240
      *****************************************************************
      *                                                               *
      * SETUPVALID - Set up additional fields that are needed on the  *
      *              Valid file record.                               *
      *                                                               *
      *****************************************************************

     C     SETUPVALID    BEGSR

     C* Msg Unique Reference                                                                  190845
     C                   Eval      OTOPMSGR = SHMSGR                                          190845
     C*                                                                                       190845
     C* Part Number                                                                           190845
     C                   Eval      OTOPKPRT = SHPART                                          190845
     C*                                                                                       190845
      * Level 1 Valid Indicator
     C                   Eval      OTLVL1 = 'Y'

      * Psyment Ref
     C                   Eval      OTPREF = SPREF

      * Payment Type / Sub Type
     C                   Eval      OTPYTP = SPYTP
     C                   Eval      OTPYST = SPYST

      * Destination Type / Address
     C                   Eval      OTDSTT = @DSTT
     C                   If        @MBIN = 'N' and
     C                             @DSTT = 'G'
     C                   Movel     SDST1         WDST118
     C                   Move      BJSBRC        WDST118
     C                   Movel     WDST118       OTDST1
     C                   Else
     C                   Eval      OTDST1 = SDST1
     C                   End

     C                   Eval      OTDST2 = SDST2
     C                   Eval      OTDST3 = SDST3
     C                   Eval      OTDST4 = SDST4

      * Senders Correspondent Type / Correspondent
     C                   Eval      OTSNCT = @SNCT
     C                   Move      SSNCO         OTSNCO
     C
      * Ordering Bank Type / Bank / Branch
     C                   Eval      OTORBT = @ORBT
     C                   Move      SORBK         OTORBK
     C                   Eval      OTORBB = SORBB

      * Ordering Customer Type / Address
     C                   Eval      OTORCT = @ORCT
     C                   If        @MBIN = 'N' and
     C                             @ORCT = 'P'
     C                   Movel     SORC1         WORC115
     C                   Move      BJSBRC        WORC115
     C                   Movel     WORC115       OTORC1
     C                   Else
     C                   Eval      OTORC1 = SORC1
     C                   End
      * Set up Ordering Information
     C                   If        OTORC1 = 'MT202'

     C                   If        SORC2 = *Blanks and
     C                             SORC3 = *Blanks and
     C                             SORC4 = *Blanks and
     C                             SORC5 = *Blanks and                                        CFT032
     C                             OTOPIN <> 'Y' and
     C                             OTOPMSGR = 0
     C                   Eval      OTOPORBT = *Blanks
     C                   Eval      OTOPORB1 = *Blanks
     C                   Eval      OTOPORB2 = *Blanks
     C                   Eval      OTOPORB3 = *Blanks
     C                   Eval      OTOPORB4 = *Blanks
     C                   Eval      OTOPORB5 = *Blanks
     C                   End

     C                   If        SORC2 <> *Blanks or
     C                             SORC3 <> *Blanks or
     C**********                   SORC4 <> *Blanks                                           CFT032
     C                             SORC4 <> *Blanks or                                        CFT032
     C                             SORC5 <> *Blanks                                           CFT032

     C                   If        OTOPMSGR = 0                                               256919
     C                   If        SORC2 <> OTOPORB1 or
     C                             SORC3 <> OTOPORB2 or
     C**********                   SORC4 <> OTOPORB3                                          CFT032
     C                             SORC4 <> OTOPORB3 or                                       CFT032
     C                             SORC5 <> OTOPORB4                                          CFT032
     C**********         Eval      OTOPORB4 = *blanks                                         CFT032
     C                   Eval      OTOPORB5 = *blanks
     C                   Eval      OTOPORBT = 'A'
     C                   End
     C                   Endif                                                                256919

     C**********         Eval      OTOPORB1 = OTORC2                                          227538
     C**********         Eval      OTOPORB2 = OTORC3                                          227538
     C**********         Eval      OTOPORB3 = OTORC4                                          227538
     C                   Eval      OTOPORB4 = OTORC5                                          CFT032
     C                   Eval      OTOPORB1 = SORC2                                           227538
     C                   Eval      OTOPORB2 = SORC3                                           227538
     C                   Eval      OTOPORB3 = SORC4                                           227538
     C                   Eval      OTOPORB4 = SORC5                                           CFT032
     C                   Eval      OTORC2 = *Blanks
     C                   Eval      OTORC3 = *Blanks
     C                   Eval      OTORC4 = *Blanks
     C                   Eval      OTORC5 = *Blanks                                           CFT032
     C                   End

     C                   Else
     C                   Eval      OTORC2 = SORC2
     C                   Eval      OTORC3 = SORC3
     C                   Eval      OTORC4 = SORC4
     C                   Eval      OTORC5 = SORC5                                             CFT032

     C                   If        OTOPIN <> 'Y' and
     C                             OTOPMSGR = 0
     C                   Eval      OTOPORBT = *Blanks
     C                   Eval      OTOPORB1 = *Blanks
     C                   Eval      OTOPORB2 = *Blanks
     C                   Eval      OTOPORB3 = *Blanks
     C                   Eval      OTOPORB4 = *Blanks
     C                   Eval      OTOPORB5 = *Blanks
     C                   End

     C                   IF        SOPORBT <> *Blanks or                                      CFT039
     C                             SOPORB1 <> *Blanks or                                      CFT039
     C                             SOPORB3 <> *Blanks or                                      CFT039
     C                             SOPORB3 <> *Blanks or                                      CFT039
     C                             SOPORB4 <> *Blanks or                                      CFT039
     C                             SOPORB5 <> *Blanks                                         CFT039
     C                   EVAL      OTOPORBT = SOPORBT                                         CFT039
     C                   EVAL      OTOPORB1 = SOPORB1                                         CFT039
     C                   EVAL      OTOPORB2 = SOPORB2                                         CFT039
     C                   EVAL      OTOPORB3 = SOPORB3                                         CFT039
     C                   EVAL      OTOPORB4 = SOPORB4                                         CFT039
     C                   EVAL      OTOPORB5 = SOPORB5                                         CFT039
     C                   ENDIF                                                                CFT039
      *                                                                                       CFT039
     C                   End

      * Settlement Amount / Currency
     C                   Eval      OTSMAM = @SMAM
     C                   Eval      OTSMCY = SSMCY

      * Format Settle Amount for DAF field
     C                   Move      SSMCY         C#K101
     C                   Exsr      CURRED

     C                   Eval      OTSMAMD = @SMAM
     C                   Do        A6NBDP
     C                   Eval      OTSMAMD = OTSMAMD / 10
     C                   End

      * Pay Amount / Currency
     C                   Eval      OTPYAM = @PYAM
     C                   Eval      OTPCCY = SPCCY

      * Format Pay Amount for DAF field
     C                   Move      SPCCY         C#K101
     C                   Exsr      CURRED

     C                   Eval      OTPYAMD = @PYAM
     C                   Do        A6NBDP
     C                   Eval      OTPYAMD = OTPYAMD / 10
     C                   End

      * Notified Delivery Amount / Currency
     C                   Eval      OTNDAM = @NDAM
     C                   Eval      OTNDCY = SNDCY

      * Pay Delivery Amount / Currency
     C                   Eval      OTPDAM = @PDAM
     C                   Eval      OTPDCY = SPDCY
                                                                                CFT014
      ** Update original rate                                                   CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      O2OEXR = @OEXR                               CFT014
     C                   Else                                                   CFT014
     C                   Eval      O2OEXR = *Zero                               CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT009
      ** Update FX spread set and payment date offset code                      CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EVAL      O2FXSP = SPDSET                              CFT009
     C                   EVAL      O2PDOF = SOFCD                               CFT009
     C                   ELSE                                                   CFT009
     C                   EVAL      O2FXSP = *BLANKS                             CFT009
     C                   EVAL      O2PDOF = *BLANKS                             CFT009
     C                   ENDIF                                                  CFT009

      * Setup Branch Code & Order Branch
     C                   If        @MBIN = 'Y'
     C                   Eval      OTBRCA = SBRCA

      * If originating branch used
     C                   If        BKOBRU = 'Y'
     C                   Eval      OTORBR = SORBR
     C                   Else
     C                   Eval      OTORBR = SBRCA
     C                   End

     C                   Else
     C                   Eval      OTBRCA = BJSBRC
     C                   Eval      OTORBR = BJSBRC
     C                   End

      * Calculate Settlement Base Currency Equivalent
     C                   Eval      #I = 4 + (@PCDP - @BCDP)
     C                   If        @PMDIN = 0
     C                   Eval      WK15_9 = @PSPOT * POWER(#I)
     C                   Eval      OTSBCQ = @SMAM / WK15_9
     C                   Else
     C                   Eval      WK15_9 = @PSPOT / POWER(#I)
     C                   Eval      OTSBCQ = @SMAM * WK15_9
     C                   End

      * Calculate Pay Base Currency Equivalent
     C                   Eval      #I = 4 + (@RCDP - @BCDP)
     C                   If        @RMDIN = 0
     C                   Eval      WK15_9 = @RSPOT * POWER(#I)
     C                   Eval      OTPBCQ = OTPYAM / WK15_9
     C                   Else
     C                   Eval      WK15_9 = @RSPOT / POWER(#I)
     C                   Eval      OTPBCQ = OTPYAM * WK15_9
     C                   End

     C/COPY WNCPYSRC,FTOPA1VC29
      * Make Base Currency Equivalents Equal
     C                   If        OTPCCY = BJCYCD
     C                   Eval      OTSBCQ = OTPBCQ
     C                   Else
     C                   Eval      OTPBCQ = OTSBCQ
     C                   End

     C/COPY WNCPYSRC,FTOPA1VC30
      * Multiple Divide Indicator
     C                   Eval      OTMDIN = @MDIN

      * Interest / Exchange Rate
     C                   Eval      OTRATE = @RATE

     C                   If        @MDIN = 1
     C                   Eval      OTRATED = @RATE
     C                   Else
     C                   Eval      OTRATED = 1 / @RATE
     C                   End
      * Override Indicator
     C                   Eval      OTOVRD = SOVRD

      * Settlement Value Date
     C                   Eval      OTSLDT = @SLDT
     C                   Eval      OTSLDTD1 = @SLDTD1
     C                   Eval      OTSLDTD2 = @SLDTD2
     C                   Eval      OTSLDTD3 = @SLDTD3

      * Pay Value Date
     C                   Eval      OTPRBD = @PRBD
     C                   Eval      OTPVDT = @PVDT
     C                   Eval      OTPVDTD1 = @PVDTD1
     C                   Eval      OTPVDTD2 = @PVDTD2
     C                   Eval      OTPVDTD3 = @PVDTD3

      * Final Date
     C                   Eval      OTFDAT = @FDAT
     C                   Eval      OTFDATD1 = @FDATD1
     C                   Eval      OTFDATD2 = @FDATD2
     C                   Eval      OTFDATD3 = @FDATD3

      * Next Pay Date
     C                   Eval      OTNPDT = @NPDT
     C                   Eval      OTNPDTD1 = @NPDTD1
     C                   Eval      OTNPDTD2 = @NPDTD2
     C                   Eval      OTNPDTD3 = @NPDTD3

      * Add / Deduct Indicator
     C                   Eval      OTADDC = SADDC

      * Book Code
     C                   Eval      OTBOKC = SBOKC

      * Profit Centre
     C                   Eval      OTPRFC = SPRFC

      * Regular Pay
     C                   Eval      OTRPAY = SRPAY

      * Pay Frequency
     C                   Eval      OTPAYF = SPAYF

      * Day in Month
     C                   Eval      OTDYIM = @DYIM

      * SWIFT PR Code
     C                   Eval      OTSWPC = @SWPC

      * Settlement Type
     C                   Eval      OTSTMT = @STMT

      * Send MT202
     C                   Eval      OTSNMT = SSNMT

      * Fixed Amount Indicator
     C                   Eval      OTFAIN = @FAIN

      * MT100 Ordering Customer
                                                                                              CFT032
     C                   If        @MBIN = 'N' And                                            CFT032
     C                             @ODMTT = 'G'                                               CFT032
     C                   Movel     SORC1         WODMT18                                      CFT032
     C                   Move      BJSBRC        WODMT18                                      CFT032
     C                   Movel     WORC115       OTODMT                                       CFT032
     C                   Else                                                                 CFT032
     C                   Eval      OTODMT = SODMT
     C                   Eval      OTOMDR  = @ODMTT                                         BUG14771
     C                   EndIf                                                                CFT032

      * Input Officer
     C                   Eval      @USRID   = WUSRID                                          CAP084
     C                   IF        InputUser = *BLANKS                                      MD042042
     C                   Eval      OTINUSR1 = @USRID
     C                   ELSE                                                               MD042042
     C                   EVAL      OTINUSR1 = InputUser                                     MD042042
     C                   ENDIF                                                              MD042042

     C                   If        SACTION = 'I'
      * Setup Original Entry date
     C                   Eval      OTOEDT = BJRDNB
     C                   Eval      OTOEDTD1 = @RUNN
     C                   Eval      WZDATE = @RUNN

      * Format Date
     C                   If        BJDFIN <> 'M'
     C                   Eval      OYY = ZDD
     C                   Eval      OMM = ZMM
     C                   Eval      ODD = ZYY
     C                   Else
     C                   Eval      OMM = ZDD
     C                   Eval      OYY = ZMM
     C                   Eval      ODD = ZYY
     C                   End

     C                   Move      #DATE         WDATE
     C                   Eval      OTOEDTD3 = WDATE

     C                   If        ZYN < 72
     C                   Eval      OTOEDTD2 = 20
     C                   Else
     C                   Eval      OTOEDTD2 = 19
     C                   End

     C                   End

      * Reset Authorisation Indicators if amend for Reg Payment
     C                   If        SACTION = 'A' and
     C                             SPYTP = 'RP'
     C                   Eval      OTAUIN = *Blanks
     C                   Eval      OTAUP1 = *Blanks
     C                   Eval      OTAUP2 = *Blanks
     C                   End
                                                                                175479
      * Dealer's reference                                                      175479
     C                   Eval      OTFDLR = SFDLR                               175479

      * MT103 Account Type                                                                  BUG12829
     C                   Eval      OTOMDR = @ODMTT                                          BUG12829
     C                                                                                      BUG12829
      ** Charge Codes                                                                       BUG15510
     C                   Eval      O2TXCD = TXCDE                                           BUG15510
     C                   Eval      O2TFCD = TRCDE                                           BUG15510
     C                   Eval      O2FXCD = FXCDE                                           BUG15510
     C                   Eval      O2CQCD = CQCDE                                           BUG15510
     C                   Eval      O2CACD = CACDE                                           BUG15510
     C                   Eval      O2SSCD = STCDE                                           BUG15510
     C                   Eval      O2SPCD = SPCDE                                           BUG15510
     C                   Eval      O2MSCD = MSCDE                                           BUG15510
     C                   Eval      O2M1CD = M1CDE                                           BUG15510
     C                   Eval      O2M2CD = M2CDE                                           BUG15510
     C                   Eval      O2M3CD = M3CDE                                           BUG15510
     C                   Eval      O2M4CD = M4CDE                                           BUG15510
     C                   Eval      O2M5CD = M5CDE                                           BUG15510
     C                                                                                      BUG15510
      * Telex charge                                                                        BUG15032
     C                   Eval      OTTXCH = 0                                               BUG15032
     C                   If        STXCD <> *Blanks                                         BUG15032
     C                   Move      *Blanks       ZFIELD                                     BUG15032
     C                   Move      STXCD         ZFIELD                                     BUG15032
     C                   Eval      ZADIG = 14 - A6NBDP                                      BUG15032
     C                   CallB     'ZALIGN'                                                 BUG15032
     C                   Parm      *Blanks       ZAlignOk                                   BUG15032
     C                   Parm                    ZFIELD                                     BUG15032
     C                   Parm      A6NBDP        ZADEC                                      BUG15032
     C                   Parm                    ZADIG                                      BUG15032
     C                   If        ZAlignOK = 'Y'                                           BUG15032
     C                   Move      ZField        OTTXCH                                     BUG15032
     C                   EndIf                                                              BUG15032
     C                   EndIf                                                              BUG15032
                                                                                            BUG15032
     C                   ENDSR
      *****************************************************************
      /EJECT                                                                    CFT009
      *****************************************************************         CFT009
      * DFTCHG - Default charges                                                CFT009
      *****************************************************************         CFT009
     C     DFTCHG        BEGSR                                                  CFT009
                                                                                CFT009
      * Reset variables updated by each module                                  CFT009
     C                   EXSR      RESETERRS                                    CFT009
      *                                                                         CFT009
     C                   CALLB     'FTOPAY1DT'                                  CFT009
      *                                                                         CFT009
      ** Return Code                                                            CFT009
     C                   PARM                    RETCODEIN                      CFT009
      *  Screen fields                                                          CFT009
     C                   PARM                    TRANINPRIM                     CFT009
     C                   PARM                    TRANINPRMB                     CFT009
     C                   PARM                    NEWPMTSCN4                     CFT009
      *  Error fields/message IDs/message data (arrays) from/to caller          CFT009
     C                   PARM                    FLDNAMXAR                      CFT009
     C                   PARM                    MSGIDXAR                       CFT009
     C                   PARM                    MSGDTAXAR                      CFT009
                                                                                CFT009
     C                   PARM                    WFLDNMXAR                      CFT009
     C                   PARM                    WMSGIDXAR                      CFT009
     C                   PARM                    WMSGDTAXAR                     CFT009
      *  OK Flags                                                               CFT009
     C                   PARM                    OKFLAGSDS                      CFT009
      * Valid payment layout (DS) from/to caller                                CFT009
     C                   PARM                    VALIDPMNT                      CFT009
     C                   PARM                    VALIDPMTX                      CFT009
      *  Validation Work Fields                                                 CFT009
     C                   PARM                    VAL@FIELDS                     CFT009
                                                                                CFT009
      ** Update error info with that returned from the validation module        CFT009
                                                                                CFT009
     C                   EXSR      UPDATERRS                                    CFT009
                                                                                CFT009
     C                   ENDSR                                                  CFT009
      /EJECT
      *****************************************************************
      * SETUP_OTH - Set Up Other Fields
      *****************************************************************
     C     SETUP_OTH     BEGSR
      *
     C                   ENDSR
     C*******************************************************************
      /EJECT
      *****************************************************************
      * CURRED - READ CURRENCY FILE                                   *
      *****************************************************************
     C*
     C     CURRED        BEGSR

     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     C#RTCD
     C                   Parm      '*KEY   '     C#OPTN
     C                   Parm                    C#K101
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   ENDSR
     C************************************************************
     C* END OF CURRENCY READ
     C************************************************************
     C/EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************

     C     *INZSR        BEGSR
     C/COPY WNCPYSRC,FTH00283

     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
      * Transaction information (DS) from source system (Level 1)
     C                   PARM                    TranInPrim
     C                   PARM                    PrevInPrim
     C                   PARM                    TranInPrmB                     CFT014
     C                   PARM                    PrevInPrmB                     CFT014
     C                   PARM                    FrontOffice                    CPB002
     C                   PARM                    NEWPMTSCN4                     CFT009
     C                   PARM                    TranInfoFlds                                 CFT039
      * Custom Extra Data file data
     C                   PARM                    ExtData

     C/COPY WNCPYSRC,FTOPA1VC09
      * Field OK flags (DS) from/to caller
     C                   PARM                    OKFlagsDS
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
      * Valid payment layout (DS) from/to caller
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmtX                      CFT014
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1VC28
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845

      *  Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
                                                                                              257361
      *  Funds Transfer Details                                                               257361
     C                   PARM                    SDFTFR                                       257361
     C                   PARM                    InputUser                                  MD042042
                                                                                              257361
     C/COPY WNCPYSRC,FTOPA1VC05

      ***Set*up*the*name*of the MSGF from which the message handler will        CFT007
      ****get*the*messages                                                      CFT007
     C*******************EVAL      #MsgFile = 'DRSMM'                           CFT007
      ** Set up the name of the primary and secondary message files from        CFT007
      ** which the message handler will get the messages                        CFT007
     C                   EVAL      #MsgFile     = 'FTUSRMSG'                    CFT007
     C                   EVAL      MsgFArray(1) = 'DRSMM'                       CFT007

      ** ACCESS BANK DETAILS
      *
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                CFT014
     C                   EVAL      @BJSBRC = BJSBRC                             CFT014
      *
      ** ACCESS GENERAL LEDGER DETAILS
      *
     C**********         CALL      'AOGELRR0'                                                 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C*****SDGELR        PARM      SDGELR        DSFDY                                        CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDGELRPD'    DBFILE
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      ** Access Module Details
      *
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     @RTCD         IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBFILE
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     @OPTN         DBKEY
     C                   EXSR      *PSSR
     C                   END
      ** Access switchable features                                                   CDL049
      *                                                                               CDL049
     C/COPY WNCPYSRC,FTH00235
     C                   CALLB     'AOSARDR0'                                         CDL049
     C                   PARM      *Blanks       @RTCD             7                  CDL049
     C                   PARM      '*VERIFY'     @OPTN             7                  CDL049
     C                   PARM      'CDL049'      @SARD             6                  CDL049
     C     SCSARD        PARM      SCSARD        DSFDY                                CDL049
      *                                                                               CDL049
     C     @RTCD         IFEQ      *BLANK                                             CDL049
     C                   MOVEL     'Y'           CDL049            1                  CDL049
     C                   ELSE                                                         CDL049
     C                   MOVEL     'N'           CDL049                               CDL049
     C                   ENDIF                                                        CDL049
                                                                                              CFT142
     C                   Move      'N'           CFT142            1                          CFT142
                                                                                              CFT142
     C                   Call      'AOSARDR0'                                                 CFT142
     C                   Parm      *Blanks       PMReturnCode      7                          CFT142
     C                   Parm      '*VERIFY'     PMOption          7                          CFT142
     C                   Parm      'CFT142'      PMSAR             6                          CFT142
                                                                                              CFT142
     C                   If        PMReturnCode = *Blanks                                     CFT142
     C                   Move      'Y'           CFT142                                       CFT142
     C                   EndIf                                                                CFT142
     C/COPY WNCPYSRC,FTOPA1VC14
      **********                                                                      CAP084 BUG7029
      ***Retrieve*ZMUSER*details.                                                     CAP084 BUG7029
      **********                                                                      CAP084 BUG7029
     C******DTAARA       DEFINE                  ZMUSER                               CAP084 BUG7029
     C**********         IN        ZMUSER                                             CAP084 BUG7029
      **If*the*user is connected via a browser, the job user name is QUSER -          CAP084 BUG9608
      **their*user name is stored in ZMUSER                                           CAP084 BUG9608
      **********                                                                      CAP084 BUG9608
     C*****WUSRID        IFNE      *BLANKS                                            CAP084 BUG9608
     C*****WUSRID        ANDNE     PSUser                                             CAP084 BUG9608
     C**********         MOVE      'Y'           JAVAUSER          1                  CAP084 BUG9608
     C**********         ELSE                                                         CAP084 BUG9608
     C**********         MOVE      'N'           JAVAUSER                             CAP084 BUG9608
     C**********         ENDIF                                                        CAP084 BUG9608
      *                                                                                     AR663078
      ** Access System Values                                                               AR663078
      *                                                                                     AR663078
     C                   EVAL      P@OP01 = *Blanks                                         AR663078
                                                                                            AR663078
     C                   CALL      'AOSVALR0'                                               AR663078
     C                   PARM      *BLANKS       PRetCode          7                        AR663078
     C                   PARM      SysValOne     P@OP01           20                        AR663078
     C                   PARM      *BLANKS       P@VL01          200                        AR663078
     C                   PARM      *BLANKS       P@OP02           20                        AR663078
     C                   PARM      *BLANKS       P@VL02          200                        AR663078
     C                   PARM      *BLANKS       P@OP03           20                        AR663078
     C                   PARM      *BLANKS       P@VL03          200                        AR663078
     C                   PARM      *BLANKS       P@OP04           20                        AR663078
     C                   PARM      *BLANKS       P@VL04          200                        AR663078
     C                   PARM      *BLANKS       P@OP05           20                        AR663078
     C                   PARM      *BLANKS       P@VL05          200                        AR663078
     C                   PARM      *BLANKS       P@OP06           20                        AR663078
     C                   PARM      *BLANKS       P@VL06          200                        AR663078
     C                   PARM      *BLANKS       P@OP07           20                        AR663078
     C                   PARM      *BLANKS       P@VL07          200                        AR663078
     C                   PARM      *BLANKS       P@OP08           20                        AR663078
     C                   PARM      *BLANKS       P@VL08          200                        AR663078
     C                   PARM      *BLANKS       P@OP09           20                        AR663078
     C                   PARM      *BLANKS       P@VL09          200                        AR663078
     C                   PARM      *BLANKS       P@OP10           20                        AR663078
     C                   PARM      *BLANKS       P@VL10          200                        AR663078
      *                                                                                     AR663078
     C                   IF        PRetCode  <> *BLANKS                                     AR663078
     C                   EVAL      DBPGM = 'FTIPAY1VL'                                      AR663078
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR663078
     C                   EVAL      DBKEy = '*KEY   '                                        AR663078
     C                   EVAL      DBase = 880                                              AR663078
     C                   EXSR      *PSSR                                                    AR663078
     C                   ELSE                                                               AR663078
      *                                                                                     AR663078
     C                   IF        P@VL01 = 'Y'                                             AR663078
     C                   MOVEL     'Y'           FUNDCHECK         1                        AR663078
      *                                                                                     AR663078
      ** Access System Values                                                               AR663078
      *                                                                                     AR663078
     C                   EVAL      P@OP01 = *Blanks                                         AR663078
      *                                                                                     AR663078
     C                   CALL      'AOSVALR0'                                               AR663078
     C                   PARM      *BLANKS       PRetCode          7                        AR663078
     C                   PARM      SysValTwo     P@OP01           20                        AR663078
     C                   PARM      *BLANKS       P@VL01          200                        AR663078
     C                   PARM      *BLANKS       P@OP02           20                        AR663078
     C                   PARM      *BLANKS       P@VL02          200                        AR663078
     C                   PARM      *BLANKS       P@OP03           20                        AR663078
     C                   PARM      *BLANKS       P@VL03          200                        AR663078
     C                   PARM      *BLANKS       P@OP04           20                        AR663078
     C                   PARM      *BLANKS       P@VL04          200                        AR663078
     C                   PARM      *BLANKS       P@OP05           20                        AR663078
     C                   PARM      *BLANKS       P@VL05          200                        AR663078
     C                   PARM      *BLANKS       P@OP06           20                        AR663078
     C                   PARM      *BLANKS       P@VL06          200                        AR663078
     C                   PARM      *BLANKS       P@OP07           20                        AR663078
     C                   PARM      *BLANKS       P@VL07          200                        AR663078
     C                   PARM      *BLANKS       P@OP08           20                        AR663078
     C                   PARM      *BLANKS       P@VL08          200                        AR663078
     C                   PARM      *BLANKS       P@OP09           20                        AR663078
     C                   PARM      *BLANKS       P@VL09          200                        AR663078
     C                   PARM      *BLANKS       P@OP10           20                        AR663078
     C                   PARM      *BLANKS       P@VL10          200                        AR663078
      *                                                                                     AR663078
     C                   IF        PRetCode  <> *BLANKS                                     AR663078
     C                   EVAL      DBPGM = 'FTIPAY1VL'                                      AR663078
     C                   EVAL      DBFILE = 'SDSVALPD'                                      AR663078
     C                   EVAL      DBKEy = '*KEY   '                                        AR663078
     C                   EVAL      DBase = 890                                              AR663078
     C                   EXSR      *PSSR                                                    AR663078
     C                   ELSE                                                               AR663078
      *                                                                                     AR663078
     C                   IF        P@VL01 = 'Y'                                             AR663078
     C                   MOVEL     'Y'           FWARNING          1                        AR663078
     C                   ELSE                                                               AR663078
     C                   EVAL      FWARNING = 'N'                                           AR663078
     C                   ENDIF                                                              AR663078
     C                   ENDIF                                                              AR663078
      *                                                                                     AR663078
     C                   ELSE                                                               AR663078
     C                   EVAL      FUNDCHECK = 'N'                                          AR663078
     C                   ENDIF                                                              AR663078
     C                   ENDIF                                                              AR663078
     D/COPY OFCPYSRCZ,CFT148_016                                                              CFT148
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RESETERRS - Reset error information that is received back     *
      *    from each validation module.                               *
      *****************************************************************

     C     RESETERRS     BEGSR

     C                   Eval      RetCodeOut = *Blanks
      *
      * Reset error & warning fields/message IDs/message data (arrays)
     C                   Eval      FldNamXAr = *BlankS
     C                   Eval      MsgIDXAr  = *BlankS
     C                   Eval      MsgDtaXAr = *BlankS
     C                   Eval      WFldNmXAr = *BlankS
     C                   Eval      WMsgIDXAr = *BlankS
     C                   Eval      WMsgDtaXAr = *BlankS

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATERRS - Update error information with that received back  *
      *    from each validation module.                               *
      *****************************************************************

     C     UPDATERRS     BEGSR
      *
      * Update error fields/message IDs/message data (arrays)
      *
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
      *
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
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * #TERM - Termination processing.
      *****************************************************************
     C     #TERM         BEGSR
      *
      **  Terminate program
      *
     C                   MOVE      '1'           *INLR
      *
     C     *INU7         IFEQ      '1'
     C                   DUMP
     C                   END
      *
     C                   RETURN
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C/COPY WNCPYSRC,FTOPA1VC04
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
      ********************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Finastra International Limited 2001
** Scaling factors array - @SF
0000000001
0000000010
0000000100
0000001000
0000010000
0000100000
0001000000
0010000000
0100000000
1000000000
** POWER - Multiply to the power of
0000001
0000010
0000100
0001000
0010000
0100000
1000000
