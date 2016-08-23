     H DEBUG
     H COPYRIGHT('(c) Misys International Banking Systems Ltd. 2001')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments screen 3 defaults')         *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAY3DT  - FT Outgoing Payments Default Module (scrn 3)    *
      *                                                               *
      *  Function: This Program Defaults VAT flags and charges        *
      *            for the charges and commissions screen             *
      *                                                               *
      *  (c) Misys International Banking Systems Ltd. 2001            *
      *                                                               *
      *  Last Amend No. CFT157             Date 29Aug14               *
      *  Prev Amend No. AR1080200          Date 24Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 CER030             Date 09Jul08               *
      *                 CER043             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 250600             Date 07Oct07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 CFT032             Date 11Sep06               *
      *                 CDL049             Date 06Jul06               *
      *                 222731             Date 06Jun06               *
      *                 CSD031             Date 10Apr06               *
      *                 227243             Date 26Apr06               *
      *                 CSD027             Date 09Dec05               *
      *                 CDL038             Date 10May05               *
      *                 BUG4331            Date 24Sep04               *
      *                 CGL014             Date 20Oct03               *
      *                 CGL029             Date 01Sep03               *
      *                 CAP084             Date 01Aug03               *
      *                 219241             Date 01Jul03               *
      *                 210873             Date 18Dec02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 196562             Date 20Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 03Mar01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 15Jun99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  CFT157 - Stop FT Transaction after Authorisation             *
      *            (Recompile)                                        *
      *  AR1080200 - In Charge details 2 tab, charges on the left and *
      *              right hand side of the screen is incorrect       *
      *            - Partially applied fix 222568                     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  222731 - The Receiver's Charges Remitted should only be      *
      *           initialized during insert and if the value is zero. *
      *           Appled fix annotated as 227243.                     *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  227243 - Charge amount fields not reset. Fix is to initialize*
      *           the Receiver's Charges Remitted field only during   *
      *           insert and value is zero. Applied fix 223133.       *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
      *  BUG4331- Do not overwrite charges entered with defaults      *
      *           during amendement or insert.                        *
      *  CGL014 - Collaterals Processing (Recompile)                  *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  CAP084 - MidasPlus Changes                                   *
      *  219241 - Defaulting of "Details of Charges" assign a         *
      *           system value                                        *
      *  210873 - Initialise customer parameter to calculate correct  *
      *           default charges.                                    *
      *  196562 - Transfer Commission Charge should recalculate after *
      *           settlement amount is amended.                       *
      *  CFT009 - Funds Transfer Fees and Charges.                    *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *           Note that this module is now called from            *
      *           the fourth screen where all charges have been       *
      *           moved.                                              *
      *  175479 - Recompile over changes in outgoing payment file     *
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
      *****************************************************************
 
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
 
      *                                                                                       210873
     D P0DTA           DS           256                                                       210873
      ** Calling parameter DS for FT0035                                                      210873
     D  WIPT1                  1      1                                                       210873
     D  WIPTY1                 2     36                                                       210873
     D  WIPT2                 37     37                                                       210873
     D  WIPTY2                38     72                                                       210873
     D  WICCY                 73     75                                                       210873
     D  WOCUST                76     81                                                       210873
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
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
 
 
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
     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Incoming Transaction (screen formats)
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
 
      * Incoming Transaction (file format)
     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
 
     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
 
      * Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
 
      * Flags to indicate whether transaction fields are valid
 
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      * Error indicators - Main screen
 
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      * Error indicators - Level 2 details
 
     D*FTEOPY3***    E DS                  EXTNAME(FTEOPY3PD)                   CFT014
      **Error*indicators*-*Charges*&*Commissions*screen****************         CFT014
                                                                                CFT014
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
      ** Error indicators - Charges & Commissions screen                        CFT014
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * External DS for Bank details
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      * External DS for Midas modules details
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
      * External DS for Currency details
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
 
      * Switchable Features File
     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D XLCD          E                     EXTFLD(LCD)
 
      ** External DS for Midas Message Management ICD                                         219241
     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
                                                                                              219241
      * First DS for access programs, short data structure
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      * Second DS for access programs, long data structure
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
      * Valid Deals layout
 
     D TranIn        E DS                  EXTNAME(FXFXDLPD)
      * Incoming Transaction
 
      ** FT0010 input parameters                                                              CFT014
     D/COPY FTCPYSRC,FT0010D001                                                               CFT014
 
     D TCNTRL          DS           256
     D  WPDTI                  1      1
     D  WGLUI                  4      4
     D  WVATF                  6      6
 
      * Data structure to retrieve VAT rate
     DVATDS            DS
     D WVATR                  10     12P 4
 
     D W7DATA          DS           321
      * Data structure for calculation of default charges (FT0320)
     D  W7PYTP                 1      2
     D  W7PYST                 3      4
      *
      * Input currency and charge currency
     D  W7ICCY                 5      7
     D  W7CCCY                 8     10
      *
      * Settlement method
     D  W7STMT                11     12
      *
      * Defaults required
     D  W7DFRQ                13     13
      *
      * Charges branch
     D  W7BRCA                14     16
      *
      * Charge currency amount
     D  W7CAMT                17     29  0
      *
      * Transfer Commission type
     D  W7TRCT                30     30
      *
      * SWIFT priority code
     D  W7SWPC                31     31
      *
      * Transfer Commission amount
     D  W7TRCD                32     42  0
     D  W7TRCH                43     53  0
      *
      * Telex charge
     D  W7TXCD                54     64  0
     D  W7TXCH                65     75  0
      *
      * Cheque Charge
     D  W7CQCD                76     86  0
     D  W7CQCH                87     97  0
      *
      * Costs Abroad
     D  W7CSTD                98    108  0
     D  W7CSTA               109    119  0
      *
      * SWIFT Priority Charge
     D  W7SPCD               120    130  0
     D  W7SPCH               131    141  0
      *
      * Miscellaneous charge
     D  W7MSCD               142    152  0
     D  W7MSCH               153    163  0
      *
      * Advice Charge
     D  W7ADCD               164    174  0
     D  W7ADCH               175    185  0
      *
      * Telephone Charge
     D  W7TLCD               186    196  0
     D  W7TLCH               197    207  0
      *
      * Collection Charge
     D  W7COLD               208    218  0
     D  W7COLL               219    229  0
      *
      * Payment amount currency
     D  W7PCCY               230    232
     D*
     D** Other currency
     D  W7OCCY               233    235
     D*
     D** FX/Change commission (input ccy)
     D  W7CHCD               236    246  0
     D*
     D** FX/Change commission (charge ccy)
     D  W7CHCM               247    257  0
     D*
     D** Our deductions (input ccy)
     D  W7DEDD               258    268  0
     D*
     D** Our deductions (charge ccy)
     D  W7DEDS               269    279  0
     D*
     D** Correspondent charge (input ccy)
     D  W7COCD               280    290  0
     D*
     D** Correspondent charge (charge ccy)
     D  W7COCH               291    301  0
     D*
     D** Default type (HDR or DET or " ")
     D  W7DFTT               302    304
     D*
     D** Customer to be debited the charge
     D  W7CUST               305    310
      *
     D** Settle Date
     D  W7SLDT               311    315  0
     D** Pay Date
     D  W7PVDT               316    320  0
     D** Add/Deduct Charges
     D  W7ADDC               321    321
 
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
      ** Index for arrays of of warning message ids etc
     D WIdx            S              3P 0
 
 
      * A code to indicate the calling function to the lower level modules
     D OPAY            S              4A   INZ('OPAY')
 
      * Response Mode, received as a parameter from the common header
     D RespMode        S              1A
 
     D I               S              3  0
     D PRTCD           S              7                                                       219241
     D POPTN           S              7                                                       219241
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
 
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
 
      * Initial Processing
     C                   EXSR      INIT
 
      ***If*action*code*is*enquiry*no*validation*has*been*done,*************    CFT014
      ***therefore*fields*@CCCY*&*@PCCY*will*not*have*been*set*up.**********    CFT014
      ***Call*relevent*modules*to*initialise*these*fields.******************    CFT014
      ***********                                                               CFT014
     C*****SACTION       IFEQ      'E'                                          CFT014
     C***********        EXSR      DFTCCYS                                      CFT014
     C***********        END                                                    CFT014
                                                                                CFT014
      ** Action taken is 'I' or 'A', default @CCCY and @RCCY.                   CFT014
                                                                                CFT014
     C                   If        (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   ExSr      SrDFTCY                                      CFT014
     C                   EndIf                                                  CFT014
 
      *  Calculate Default charges
     C                   Exsr      DFTCHARGES
 
      *  Default VAT Flags
     C                   If        @VATP = 'Y'
     C                   Exsr      DFTVATFLG
     C                   End
                                                                                CFT014
      ** Set OKFLAG to 'Y' if the action taken is 'E'                           CFT014
                                                                                CFT014
     C                   If        SACTION = 'E'                                CFT014
     C                   Move      *All'Y'       FTEOPY1                        CFT014
     C                   Move      *All'Y'       FTEOPY2                        CFT014
     C                   Move      *All'Y'       FTEOPY4                        CFT014
     C                   EndIf                                                  CFT014
 
      * RETURN
     C                   RETURN
 
      *****************************************************************         CFT014
     C***/EJECT*                                                                CFT014
      *****************************************************************         CFT014
      ***DFTCCYS***-*Default*Charges*and*Payment*Currency*fields.******         CFT014
      ***************Calls*FTVSEIN*************************************         CFT014
      *********************FTVCSRF*************************************         CFT014
      *****************************************************************         CFT014
     C*****DFTCCYS       BEGSR                                                  CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      **Validate*******************************************************         CFT014
     C***********        CALLB     'FTVSEIN'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
      ***********                                                               CFT014
      ***Bank*ICD*Details**********************************************         CFT014
     C***********        Parm                    SDBANK                         CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags*(screen*1)*******************************************         CFT014
     C***********        Parm                    FTEOPY1                        CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
      ***Funds*transfer*Details****************************************         CFT014
     C***********        Parm                    SDFTFR                         CFT014
      ***********                                                               CFT014
      ***********                                                               CFT014
      **Reset*variables*updated*by*each*module*************************         CFT014
     C***********        Exsr      RESETERRS                                    CFT014
      ***********                                                               CFT014
      ***Validate******************************************************         CFT014
     C***********        CALLB     'FTVCSRF'                                    CFT014
      **INPUTS*********************************************************         CFT014
      ***Return*Code***************************************************         CFT014
     C***********        Parm                    RetCodeOut                     CFT014
      ***********                                                               CFT014
      ***Screen*fields*************************************************         CFT014
     C***********        Parm                    TranInPrim                     CFT014
     C***********        Parm                    TranInSecA                     CFT014
      ***********                                                               CFT014
      **OUTPUTS********************************************************         CFT014
      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
     C***********        Parm                    FldNamXAr                      CFT014
     C***********        Parm                    MsgIDXAr                       CFT014
     C***********        Parm                    MsgDtaXAr                      CFT014
      ***********                                                               CFT014
      ***OK*Flags*(screen*2)*******************************************         CFT014
     C***********        Parm                    FTEOPY2                        CFT014
      ***********                                                               CFT014
      ***Validation*Work*Fields****************************************         CFT014
     C***********        Parm                    Val@Fields                     CFT014
      ***********                                                               CFT014
     C***********        ENDSR                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrDFTCY                                                         CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrDFTCY   - Default @CCCY and @RCCY for Insert or Amend    *         CFT014
      *                                                               *         CFT014
      * Called By: Main Routine                                       *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrDFTCY       BegSr                                                  CFT014
                                                                                CFT014
      ** Default @CCCY                                                          CFT014
                                                                                CFT014
     C**********         If        BTCHCY = 'C'                                        CFT014 187056
     C**********         If        SADDC = 'A'                                         CFT014 187056
     C**********         Eval      @CCCY = SSMCY                                       CFT014 187056
     C**********         Else                                                          CFT014 187056
     C**********         Eval      @CCCY = SPCCY                                       CFT014 187056
     C**********         EndIf                                                         CFT014 187056
      **********                                                                       CFT014 187056
     C**********         Else                                                          CFT014 187056
     C**********         If        BTCHCY = 'L'                                        CFT014 187056
     C**********         Eval      @CCCY = BJLCCY                                      CFT014 187056
     C**********         Else                                                          CFT014 187056
     C**********         Eval      @CCCY = BJCYCD                                      CFT014 187056
     C**********         EndIf                                                         CFT014 187056
     C**********         EndIf                                                         CFT014 187056
                                                                                              187056
     C                   SELECT                                                               187056
     C                   WHEN      BTCHCY = 'B' OR SCDRO <> *BLANKS                           187056
     C**********                   AND CFT120 = 'N'                                 CFT120 AR1080200
     C                             AND CFT120 = 'N' AND BTCHCY = 'C'                       AR1080200
     C                   EVAL      @CCCY = BJCYCD                                             187056
     C                   WHEN      CFT120 = 'Y' AND SCDRO <> *BLANKS                       AR1080200
     C                             AND BTCHCY = 'C'                                        AR1080200
     C                   EVAL      @CCCY = SCDRC                                           AR1080200
     C                   WHEN      BTCHCY = 'L'                                               187056
     C                   EVAL      @CCCY = BJLCCY                                             187056
     C                   WHEN      BTCHCY = 'C' AND SADDC = 'A'                               187056
     C                   EVAL      @CCCY = SSMCY                                              187056
     C                   OTHER                                                                187056
     C                   EVAL      @CCCY = SPCCY                                              187056
     C                   ENDSL                                                                187056
                                                                                CFT014
      ** Default @RCCY                                                          CFT014
                                                                                CFT014
     C                   If        (SCDRO <> *Blank) And (OKCDRO = 'Y')         CFT014
      *                                                                                       CFT120
     C                   If        SCDRC = *Blanks AND CFT120 = 'Y'                           CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   Eval      @RCCY = BJCYCD                               CFT014
     C                   Else                                                                 CFT120
     C                   Eval      @RCCY = SCDRC                                              CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Else                                                   CFT014
     C                   If        SADDC = 'A'                                  CFT014
     C                   Eval      @RCCY = SSMCY                                CFT014
     C                   Else                                                   CFT014
     C                   Eval      @RCCY = SPCCY                                CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DFTCHARGES- Default Charges
      **  calls - FT0320
      *****************************************************************
     C     DFTCHARGES    BEGSR
 
     C                   CLEAR                   W7DATA
 
     C** Payment type and subtype
     C*
     C                   MOVEL     SPYTP         W7PYTP
     C                   MOVEL     SPYST         W7PYST
     C*
     C** Input currency and charge currency
     C*
     C                   MOVE      @CCCY         W7ICCY                                       187056
     C                   MOVEL     @RCCY         W7CCCY                                       187056
     C**********         SELECT                                                               187056
     C*****BTCHCY        WHENEQ    'C'                                                        187056
     C*****SADDC         IFEQ      'A'                                                        187056
     C**********         MOVE      SSMCY         W7ICCY                                       187056
     C**********         ELSE                                                                 187056
     C**********         MOVE      SPCCY         W7ICCY                                       187056
     C**********         END                                                                  187056
     C*****BTCHCY        WHENEQ    'L'                                                        187056
     C**********         MOVE      BJLCCY        W7ICCY                                       187056
     C**********         OTHER                                                                187056
     C**********         MOVE      BJCYCD        W7ICCY                                       187056
     C**********         ENDSL                                                                187056
     C**********                                                                              187056
     C*****SADDC         IFEQ      'A'                                                        187056
     C**********         MOVEL     SSMCY         W7CCCY                                       187056
     C**********         ELSE                                                                 187056
     C**********         MOVEL     SPCCY         W7CCCY                                       187056
     C**********         END                                                                  187056
     C*
     C** Settlement method
     C*
     C                   MOVEL     SSTTP         W7STMT
     C*
     C** Defaults required
     C*
     C                   MOVEL     'Y'           W7DFRQ
     C*
     C* Charges branch
     C                   MOVEL     @PYBR         W7BRCA
     C*
     C* Charge currency amount
     C*
     C                   SELECT
     C*
     C     SADDC         WHENEQ    'A'
     C                   Z-ADD     @SMAM         W7CAMT
     C                   MOVEL     SSMCY         W7PCCY
     C*
     C                   OTHER
     C                   Z-ADD     @PYAM         W7CAMT
     C                   MOVEL     SPCCY         W7PCCY
     C                   ENDSL
     C*
     C** Transfer Commission type
     C*
     C                   MOVEL     STRCT         W7TRCT
     C*
     C** SWIFT priority code
     C*
     C     SSWPC         IFEQ      'U'
     C                   MOVEL     'U'           W7SWPC
     C                   ELSE
     C                   MOVEL     'N'           W7SWPC
     C                   END
     C*
      ** For Amend or Enquiry set up current charges from file.
 
     C     SACTION       IFNE      'I'
 
      * Transfer Commission amount
     C                   Z-ADD     DUMA1         W7TRCD
     C                   Z-ADD     DUMA1         @TRCD
     C                   Z-ADD     TRCM          W7TRCH
     C                   Z-ADD     TRCM          @TRCM
      *
      * Telex charge
     C                   Z-ADD     DUMA2         W7TXCD
     C                   Z-ADD     DUMA2         @TXCD
     C                   Z-ADD     TXCH          W7TXCH
     C                   Z-ADD     TXCH          @TXCH
      *
      * Cheque Charge
     C                   Z-ADD     DUMA3         W7CQCD
     C                   Z-ADD     DUMA3         @CQCD
     C                   Z-ADD     CQCH          W7CQCH
     C                   Z-ADD     CQCH          @CQCH
      *
      * Costs Abroad
     C                   Z-ADD     DUMA4         W7CSTD
     C                   Z-ADD     DUMA4         @CSTD
     C                   Z-ADD     CSTA          W7CSTA
     C                   Z-ADD     CSTA          @CSTA
      *
      * SWIFT Priority Charge
     C                   Z-ADD     DUMA5         W7SPCD
     C                   Z-ADD     DUMA5         @SPCD
     C                   Z-ADD     SPCH          W7SPCH
     C                   Z-ADD     SPCH          @SPCH
      *
      * Miscellaneous charge
     C                   Z-ADD     DUMA6         W7MSCD
     C                   Z-ADD     DUMA6         @MSCD
     C                   Z-ADD     MSCH          W7MSCH
     C                   Z-ADD     MSCH          @MSCH
     C*
     C** FX/Change Commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     OPDUM7        W7CHCD
     C                   Z-ADD     OPDUM7        @CHCD
     C                   Z-ADD     OPCHCM        W7CHCM
     C                   Z-ADD     OPCHCM        @CHCM
     C                   END
      *
     C                   END
 
     C                   MOVEL     *BLANKS       W7ACT
     C                   MOVEL     'OP'          W7ACT
     C*
     C**  Other currency
     C*
     C                   SELECT
     C*
     C     SCDRO         WHENNE    *BLANK
     C     SSMCY         ANDNE     SPCCY
     C                   MOVE      '***'         W7OCCY
     C*
     C     SCDRO         WHENNE    *BLANK
     C     SSMCY         ANDEQ     SPCCY
     C                   MOVE      W7PCCY        W7OCCY
     C*
     C     SADDC         WHENEQ    'D'
     C                   MOVE      SSMCY         W7OCCY
     C*
     C     SADDC         WHENEQ    'A'
     C                   MOVE      SPCCY         W7OCCY
     C*
     C                   ENDSL
     C*
      * Set up EMU fields for default calculations
      *
      * Settle Value Date
     C                   Z-ADD     @SLDT         W7SLDT
      *
      * Pay Value Date
     C                   Z-ADD     @PVDT         W7PVDT
      *
      * Add/Deduct Indicator
     C                   MOVEL     SADDC         W7ADDC
      *                                                                                       210873
      ** Get Customer                                                                         210873
      *                                                                                       210873
     C                   MOVE      *BLANKS       P0DTA                                        210873
     C                   SELECT                                                               210873
                                                                                              210873
      * Only use ordering customer if S01506                                                  210873
     C     @01506        WHENEQ    'Y'                                                        210873
     C                   MOVEL     OTORCT        WIPT1                                        210873
     C                   MOVEL     SORC1         WIPTY1                                       210873
     C                   MOVEL     SSMCY         WICCY                                        210873
                                                                                              210873
      * If add use ordering side                                                              210873
     C     OTADDC        WHENEQ    'A'                                                        210873
     C                   MOVEL     OTORCT        WIPT1                                        210873
     C                   MOVEL     SORC1         WIPTY1                                       210873
     C                   MOVEL     SSMCY         WICCY                                        210873
     C     OTORBT        IFNE      *BLANKS                                                    210873
     C                   MOVE      *BLANKS       WORBKC           15                          210873
     C                   MOVEL     OTORBK        WFLDO            12                          210873
     C     WFLDO         CAT       OTORBB        WORBKC                                       210873
     C                   MOVEL     OTORBT        WIPT2                                        210873
     C                   MOVEL     WORBKC        WIPTY2                                       210873
     C                   END                                                                  210873
                                                                                              210873
      * If deduct use pay to instructions                                                     210873
     C     OTADDC        WHENEQ    'D'                                                        210873
     C                   MOVEL     OTDSTT        WIPT1                                        210873
     C                   MOVEL     OTDST1        WIPTY1                                       210873
     C                   MOVEL     OTPCCY        WICCY                                        210873
     C     OTSNCT        IFNE      *BLANKS                                                    210873
     C                   MOVEL     OTSNCT        WIPT2                                        210873
     C                   MOVEL     OTSNCO        WIPTY2                                       210873
     C                   END                                                                  210873
     C                   ENDSL                                                                210873
      ** Call FT0035 to get customer number to be debited the charges.                        210873
      *                                                                                       210873
     C                   CALL      'FT0035'                             9090                  210873
     C                   PARM      *BLANKS       PRTCD             7                          210873
     C                   PARM                    P0DTA                                        210873
     C                   PARM                    P0MSG           256                          210873
      *                                                                                       210873
     C     OTODMT        IFNE      *BLANKS                                                    210873
     C     OTADDC        ANDEQ     'A'                                                        210873
     C                   MOVE      OTODMT        W7CUST                                       210873
     C                   ELSE                                                                 210873
     C                   IF        (PRTCD = *BLANKS)                                          210873
     C                   MOVE      WOCUST        W7CUST                                       210873
     C                   ELSE                                                                 210873
     C                   MOVE      *BLANKS       W7CUST                                       210873
     C                   ENDIF                                                                210873
     C                   ENDIF                                                                210873
      *                                                                                       210873
      *
     C** Call defaults program
     C*
     C                   CALL      'FT0320'                             9090
     C                   PARM      *BLANKS       W7RTN             7
     C                   PARM                    W7ACT             8
     C                   PARM                    W7DATA
      *
     C     *IN90         IFEQ      '1'
     C     W7RTN         ORNE      *BLANKS
     C                   MOVEL     'FT0320'      DBKEY
     C                   MOVEL     '35'          DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C*
      ** Get Input Currency decimal places
     C*
     C                   MOVE      W7ICCY        @AJCD             3
     C                   CALLB     'AOCURRR0'
     C                   PARM      *BLANK        @RTCD             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM                    @AJCD
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C** Set up the screen fields with default values only if no value
     C** already input.
 
     C** Transfer Commission amount (input currency)
      ** Fix 196562 is invalid, as user cannot overwrite the system                          BUG4331
      ** value.                                                                              BUG4331
      ** To get the system to recalculate, user should blank out the                         BUG4331
      ** the field.                                                                          BUG4331
     C*
     C*****STRCD         IFEQ      *BLANKS                                                    196562
     C*****PReCalc       OREQ      'Y'                                                 187056 196562
     C     STRCD         IFEQ      *BLANKS                                                   BUG4331
     C                   Z-ADD     W7TRCD        @TRCD
     C                   Z-ADD     W7TRCH        @TRCM
     C**********         END                                                                  196562
     C*
     C     @TRCD         IFNE      0
     C                   Z-ADD     @TRCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STRCD
     C                   END
     C                   END                                                                 BUG4331
      *
     C**Telex charge (input currency)
     C*
     C     STXCD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7TXCD        @TXCD
     C                   Z-ADD     W7TXCH        @TXCH
     C***************    END                                                                 BUG4331
     C*
     C     @TXCD         IFNE      0
     C                   Z-ADD     @TXCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        STXCD
     C                   END
     C                   END                                                                 BUG4331
      *
     C** Cheque Charge (input currency)
     C*
     C     SCQCD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7CQCD        @CQCD
     C                   Z-ADD     W7CQCH        @CQCH
     C***************    END                                                                 BUG4331
     C*
     C     @CQCD         IFNE      0
     C                   Z-ADD     @CQCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCQCD
     C                   END
     C                   END                                                                 BUG4331
      *
     C** Costs Abroad (input currency)
     C*
     C     SCSTD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7CSTD        @CSTD
     C                   Z-ADD     W7CSTA        @CSTA
     C***************    END                                                                 BUG4331
     C*
     C     @CSTD         IFNE      0
     C                   Z-ADD     @CSTD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCSTD
     C                   END
     C                   END                                                                 BUG4331
      *
     C** SWIFT Priority Charge (input currency)
     C*
     C     SSPCD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7SPCD        @SPCD
     C                   Z-ADD     W7SPCH        @SPCH
     C***************    END                                                                 BUG4331
     C*
     C     @SPCD         IFNE      0
     C                   Z-ADD     @SPCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SSPCD
     C                   END
     C                   END                                                                 BUG4331
      *
     C** Miscellaneous charge (input currency)
     C*
     C     SMSCD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7MSCD        @MSCD
     C                   Z-ADD     W7MSCH        @MSCH
     C***************    END                                                                 BUG4331
      *
     C     @MSCD         IFNE      0
     C                   Z-ADD     @MSCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SMSCD
     C                   END
     C                   END                                                                 BUG4331
     C*
     C** FX/Change Commission (input currency)
     C*
     C     @01494        IFEQ      'Y'
     C     SCHCD         IFEQ      *BLANKS
     C     PReCalc       OREQ      'Y'                                                        187056
     C                   Z-ADD     W7CHCD        @CHCD
     C                   Z-ADD     W7CHCM        @CHCM
     C                   END
      *
     C*****@TXCD*        IFNE      0                                            CFT014
     C     @CHCD         IFNE      0                                            CFT014
     C                   Z-ADD     @CHCD         @@AMTW
     C                   Z-ADD     A6NBDP        @@QECN
     C                   EXSR      FMTAMT
     C                   MOVE      @@AMTD        SCHCD
     C                   END
     C
     C                   END
                                                                                CFT014
      ** Default Details of Charges                                             CFT014
                                                                                CFT014
     C                   If        SDTCH = *Blanks                              CFT014
                                                                                              219241
      ** If CFT014 is installed, retrieve the default value from the                          219241
      ** Message Management ICD                                                               219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
     C                   EVAL      SDTCH = ENDCHG                                             219241
     C                   ELSE                                                                 219241
     C                   Eval      SDTCH = 'BEN'                                CFT014
     C/COPY WNCPYSRC,FTOPA3TC01
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Calculate fields @TRCM, @TXCH, and other charges fields                CFT014
                                                                                CFT014
     C                   CallB     'FTVCHPY'                                    CFT014
     C                   Parm                    ReTCodeOut                     CFT014
     C                   Parm                    TranInPrim                     CFT014
     C                   Parm                    TranInFour                     CFT014
     C                   Parm                    FldNamXAr                      CFT014
     C                   Parm                    MsgIDXAr                       CFT014
     C                   Parm                    MsgDtaXAr                      CFT014
     C                   Parm                    FTEOPY4                        CFT014
     C                   Parm                    Val@Fields                     CFT014
     C                   Parm                    O2XRTE                         CFT009
                                                                                CFT014
      ** If CFT014 is on and the network used indicator is 'N', subtract the    CFT014
      ** total charges from the receiver's charges                              CFT014
                                                                                CFT014
     C     @CFT014       IfEq      'Y'                                          CFT014
                                                                                CFT014
     C     @RCUS         IfEq      'N'                                          CFT014
                                                                                CFT014
      ** If charge currency is not equal to pay currency, convert charges to    CFT014
      ** pay currency                                                           CFT014
                                                                                CFT014
     C                   ExSr      SrCvtChg                                     CFT014
     C                   Eval      @RCRM = @RCRM - @PTOTCH                      CFT014
     C                   Eval      @RCUS = 'Y'                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Format Receiver's Charges                                              CFT014
                                                                                CFT014
     C     @RCRM         IfNe      *Zero                                        CFT014
     C                   CallB     'AOCURRR0'                                   CFT014
     C                   Parm      *Blank        @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      SPCCY         @AJCD                          CFT014
     C     SDCURR        Parm      SDCURR        DSSDY                          CFT014
                                                                                CFT014
     C     @RTCD         IfNe      *Blank                                       CFT014
     C                   Movel     'SDCURRPD'    DBKEY                          CFT014
     C                   Z-Add     21            DBASE                          CFT014
     C                   Movel     SPCCY         DBFILE                         CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Move      @RCRM         ZFIELD                         CFT014
     C                   Z-Add     A6NBDP        ZADEC                          CFT014
     C                   CallB     'ZEDIT'                                      CFT014
     C                   Parm                    ZFIELD           16            CFT014
     C                   Parm                    ZADEC             1 0          CFT014
     C                   Move      ZFIELD        SRCRM                          CFT014
     C                   Else                                                   CFT014
     C     SACTION       Ifeq      'I'                                                        227243
     C                   Move      *Blanks       SRCRM                          CFT014
     C                   Endif                                                                227243
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C*
     C*
     C                   ENDSR
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrCvtChg                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrCvtChg   - Convert Charges to Pay Currency               *         CFT014
      *                                                               *         CFT014
      * Called By: DFTCHARGES                                         *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * FT0010     - Validate and Calculate currencies.               *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrCvtChg      BegSr                                                  CFT014
                                                                                CFT014
      ** Pay Currency is equal to charge currency                               CFT014
                                                                                CFT014
     C     SPCCY         IfEq      @CCCY                                        CFT014
     C                   Z-Add     @TOTCHG       @PTOTCH          13 0          CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
      ** Otherwise, convert charge amount                                       CFT014
                                                                                CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Eval      P#FRCY = @CCCY                               CFT014
     C                   Eval      P#TOCY = SPCCY                               CFT014
     C                   Eval      P#FRAM = @TOTCHG                             CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
     C                   If        P#RTCD <> *Blank                             CFT014
     C                   Eval      DBFILE = 'FT0010'                            CFT014
     C                   Eval      DBKEY = P#TOCY                               CFT014
     C                   Eval      DBASE = 1                                    CFT014
     C                   ExSr      *PSSR                                         CFT014
     C                   EndIf                                                   CFT014
                                                                                 CFT014
     C                   Z-Add     P#TOAM        @PTOTCH                         CFT014
     C                   EndIf                                                   CFT014
                                                                                 CFT014
     C                   EndSr                                                   CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      ** DFTVATFLG - Default  VAT Flags & calculate VAT totals
      **             (uses the validation module FTVVTIN to default)
      *****************************************************************
     C     DFTVATFLG     BEGSR
 
      * Reset variables updated by each module
     C                   Exsr      RESETERRS
 
      * Validate
     C                   CALLB     'FTVVTIN'
      * INPUTS
      *  Return Code
     C                   Parm                    RetCodeOut
 
      *  Screen fields
     C***********        Parm                    TranInThir                     CFT014
     C                   Parm                    TranInFour                     CFT014
 
      * OUTPUTS
      *  Error fields/message IDs/message data (arrays) from/to caller
     C                   Parm                    FldNamXAr
     C                   Parm                    MsgIDXAr
     C                   Parm                    MsgDtaXAr
 
      *  OK Flags (screen 3)
     C***********        Parm                    FTEOPY3                        CFT014
     C                   Parm                    FTEOPY4                        CFT014
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
      *****************************************************************
     C     FMTAMT        BEGSR
      *
     C                   CALLB     'ZA0920'
     C                   PARM      *BLANK        @@RETC           10
     C                   PARM                    @@AMTW           13 0
     C                   PARM                    @@QECN            1 0
     C                   PARM      '.'           BNDCSP            1
     C                   PARM      *BLANK        @@AMTD           14
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INZSR - Program Initialisation routine                       *
      *****************************************************************
 
     C     *INZSR        BEGSR
 
     C     *ENTRY        PLIST
      * Response mode (1A), from source system common header
     C                   PARM                    RespMode
 
      * Transaction information (DS) in screen format from source system
     C                   PARM                    TranInPrim
     C                   PARM                    TranInSecA
     C                   PARM                    TranInSecB
     C                   PARM                    TranInThir
     C                   PARM                    TranInFour                     CFT014
 
      * Transaction information (DS) in file format
     C                   PARM                    CrPtFilFmt
 
      * Custom Extra Data file data
     C                   PARM                    ExtData
 
      *  Funds transfer Details
     C                   Parm                    SDFTFR
      *                                                                                       187056
      ** Recalcution flag.                                                                    187056
     C                   PARM                    PReCalc           1                          187056
 
      * OUTPUTS :
 
      * Field OK flags (DS) from/to caller
     C                   PARM                    FTEOPY1
     C***********        PARM                    FTEOPY2                        CFT014
     C***********        PARM                    FTEOPY3                        CFT014
     C                   PARM                    FTEOPY4                        CFT014
 
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
 
      * Valid Deals layout (DS) from/to caller
     C                   PARM                    ValidPmnt
 
      *  Validation Work Fields from/to caller
     C                   Parm                    Val@Fields
 
      *  Extra rate required for FTVCHPY module                                 CFT009
     C                   Parm                    O2XRTE           13 8          CFT009
                                                                                CFT009
      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FTOPAY3DT'   DBPGM
     C                   Out       LDA
 
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
                                                                                              219241
      ** Get Message Management Details if CFT014 is installed                                219241
                                                                                              219241
     C                   IF        @CFT014 = 'Y'                                              219241
                                                                                              219241
     C                   CALL      'AOMGMER1'                                                 219241
     C                   PARM      *BLANKS       PRTCD                                        219241
     C                   PARM      '*FIRST'      POPTN                                        219241
     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
                                                                                              219241
     C                   IF        PRTCD <> *BLANKS                                           219241
     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
     C                   EVAL      DBASE = 905                                                219241
     C                   EVAL      DBKEY = POPTN                                              219241
     C                   EXSR      *PSSR                                                      219241
     C                   ENDIF                                                                219241
                                                                                              219241
     C                   ENDIF                                                                219241
      *
      ***Set*up*the*name*of the MSGF from which the message handler will        CFT007
      ****get*the*messages                                                      CFT007
     C*******************EVAL      #MsgFile = 'DRSMM'                           CFT007
      ** Set up the name of the primary and secondary message files from        CFT007
      ** which the message handler will get the messages                        CFT007
     C                   EVAL      #MsgFile     = 'FTUSRMSG'                    CFT007
     C                   EVAL      MsgFArray(1) = 'DRSMM'                       CFT007
 
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * *INIT - Initial Processing                                    *
      *****************************************************************
 
     C     INIT          BEGSR
 
      * Access FT Control data
     C                   CALL      'FT0005'                             9090
     C                   Parm      *BLANKS       @RTCD
     C     TCNTRL        Parm      TCNTRL        DSFDY
      *
     C                   If        *IN90 = *ON or
     C                             @RTCD = '*ERROR*'
     C                   Move      'FTOPAY3DT'   DBPGM
     C                   Move      'FT0005'      DBFILE
     C                   Eval      DBASE = 20
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        WGLUI = 'I'
     C                   Eval      @FTOV = 'Y'
     C                   Else
     C                   Eval      @FTOV = *Blanks
     C                   End
     C                   Eval      @PDTI =WPDTI
     C                   Eval      @VATF =WVATF
 
      ** Access SAR details file to determine if CEU006 is on.
     C                   CALLB     'AOSARDR0'
     C                   Parm      *Blanks       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY
 
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Move      'FTOPAY3DT'   DBPGM
     C                   Move      'AOSARDR0'    DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
     C                   End
 
     C                   If        @RTCD = *Blanks
     C                   Eval      @CEU006 = 'Y'
     C                   Else
     C                   Eval      @CEU006 = 'N'
     C                   End
      *                                                                                       CFT120
      ** Access SAR details file to determine if CEU006 is on.                                CFT120
      *                                                                                       CFT120
     C                   CALLB     'AOSARDR0'                                                 CFT120
     C                   Parm      *Blanks       @RTCD                                        CFT120
     C                   Parm      '*VERIFY'     @OPTN                                        CFT120
     C                   Parm      'CFT120'      @SARD                                        CFT120
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT120
                                                                                              CFT120
     C                   If        @RTCD <> *Blanks and                                       CFT120
     C                             @RTCD <> '*NRF   '                                         CFT120
     C                   Move      'FTOPAY3DT'   DBPGM                                        CFT120
     C                   Move      'SCSARDPD'    DBFILE                                       CFT120
     C                   Eval      DBASE = 3                                                  CFT120
     C                   Movel     'CFT120'      DBKEY                                        CFT120
     C                   Exsr      *PSSR                                                      CFT120
     C                   End                                                                  CFT120
                                                                                              CFT120
     C                   If        @RTCD = *Blanks                                            CFT120
     C                   Eval      CFT120 = 'Y'                                               CFT120
     C                   Else                                                                 CFT120
     C                   Eval      CFT120 = 'N'                                               CFT120
     C                   End                                                                  CFT120
      *
      * Read V.A.T. details if S01499 switched ON
     C                   If        @01499 = 'Y'
     C                   CALL      'AOVATR0'                            9090
     C                   Parm      '*MSG   '     @RTCD
     C                   Parm      '*FIRST '     @OPTN
     C                   Parm                    VATDS
 
     C                   If        *IN90 = *ON or
     C                             @RTCD = '*ERROR*'
     C                   Move      'FTOPAY3DT'   DBPGM
     C                   Move      'AOVATR0'     DBFILE
     C                   Eval      DBASE = 2
     C                   Movel     '*CALL'       DBKEY
     C                   Exsr      *PSSR
 
     C                   Else
     C                   Eval      @VATR = WVATR
     C                   Eval      @VATP = 'Y'
     C                   End
     C                   End
     C/COPY WNCPYSRC,FTOPA3TC02
 
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
     C                   Eval      WMsgDtXAr = *BlankS
 
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
      ********************************************************************
      ** =================================================================
      ** Program, module and procedure names for database error processing.
      ** =================================================================
      ** The following /COPY sets these values, and also defines LDA as
      ** an external data area
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
      /EJECT
**  CPY@
(c) Misys International Banking Systems Ltd. 2001
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
