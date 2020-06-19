000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*STD *  RPGBASEMOD                                                   *
000500200528/*EXI *  TEXT('Midas FT Outgoing payments screen 3 defaults')         *
000600200528      *****************************************************************
000700200528      *                                                               *
000800200528      *  Midas - Funds Transfer Module                                *
000900200528      *                                                               *
001000200528      *  FTOPAY3DT  - FT Outgoing Payments Default Module (scrn 3)    *
001100200528      *                                                               *
001200200528      *  Function: This Program Defaults VAT flags and charges        *
001300200528      *            for the charges and commissions screen             *
001400200528      *                                                               *
001500200528      *  (c) Finastra International Limited 2001                      *
001600200528      *                                                               *
001700200604      *  Last Amend No. 250041             Date 22May20               *
001800200528      *  Prev Amend No. MD046248           Date 27Oct17               *
001900200528      *                 CDL099             Date 06Oct17               *
002000200528      *                 CFT157             Date 29Aug14               *
002100200528      *                 AR1080200          Date 24Jan13               *
002200200528      *                 CFT120             Date 28Sep12               *
002300200528      *                 CSF011A            Date 28Nov11               *
002400200528      *                 CRE067             Date 05Oct10               *
002500200528      *                 CER059             Date 19Jul10               *
002600200528      *                 CER030             Date 09Jul08               *
002700200528      *                 CER043             Date 19May08               *
002800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
002900200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
003000200528      *                 256564             Date 17Sep08               *
003100200528      *                 255711             Date 31Jul08               *
003200200528      *                 250600             Date 07Oct07               *
003300200528      * Midas Plus 1.4 Base ------------------------------------------*
003400200528      * Midas Plus 1.3 ----------- Base ------------------------------*
003500200528      *                 CFT032             Date 11Sep06               *
003600200528      *                 CDL049             Date 06Jul06               *
003700200528      *                 222731             Date 06Jun06               *
003800200528      *                 CSD031             Date 10Apr06               *
003900200528      *                 227243             Date 26Apr06               *
004000200528      *                 CSD027             Date 09Dec05               *
004100200528      *                 CDL038             Date 10May05               *
004200200528      *                 BUG4331            Date 24Sep04               *
004300200528      *                 CGL014             Date 20Oct03               *
004400200528      *                 CGL029             Date 01Sep03               *
004500200528      *                 CAP084             Date 01Aug03               *
004600200528      *                 219241             Date 01Jul03               *
004700200528      *                 210873             Date 18Dec02               *
004800200528      * Midas Release 4.01 -------------------------------------------*
004900200528      *                 196562             Date 20Sep01               *
005000200528      * Midas Release 4 --------------- Base -------------------------*
005100200528      * Midas DBA 3.05 -----------------------------------------------*
005200200528      *                 CFT009             Date 03Mar01               *
005300200528      * Midas DBA 3.04 -----------------------------------------------*
005400200528      *                 187056             Date 01Dec00               *
005500200528      *                 CFT014             Date 25May00               *
005600200528      * Midas DBA 3.03 -----------------------------------------------*
005700200528      *                 175479             Date 23May00               *
005800200528      *                 CFT007             Date 03Dec99               *
005900200528      * Midas DBA 3.02 -----------------------------------------------*
006000200528      *                 CFT004             Date 01Dec99               *
006100200528      *                 CPB001             Date 23Aug99               *
006200200528      *                 CAP031  *CREATE    Date 15Jun99               *
006300200528      *                                                               *
006400200528      *---------------------------------------------------------------*
006500200528      *                                                               *
006600200528      *  250041 - Receiver's Charges remitted value is initialised    *
006700200528      *           during insert and when @RCRM = zero.                *
006800200528      *  MD046248 - Finastra Rebranding                               *
006900200528      *  CDL099 - Split Value Date (Recompile)                        *
007000200528      *  CFT157 - Stop FT Transaction after Authorisation             *
007100200528      *            (Recompile)                                        *
007200200528      *  AR1080200 - In Charge details 2 tab, charges on the left and *
007300200528      *              right hand side of the screen is incorrect       *
007400200528      *            - Partially applied fix 222568                     *
007500200528      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
007600200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
007700200528      *            (Recompile)                                        *
007800200528      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
007900200528      *           (Recompile)                                         *
008000200528      *  CER059 - German Feature Upgrade to Delhi                     *
008100200528      *  CER030 - Multicash German Feature (Recompile)                *
008200200528      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
008300200528      *           (Recompile)                                         *
008400200528      *  256564 - Recompile due to PF changes done by fix 256330      *
008500200528      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
008600200528      *  250600 - Recompiled for change in FTV@OPAYPD                 *
008700200528      *           to fix CFT032/CSW207 errors                         *
008800200528      *  CFT032 - Account Line in Field 50X in MT103 (Recompile)      *
008900200528      *  CDL049 - Addition of a Reference Rate field (recompile)      *
009000200528      *  222731 - The Receiver's Charges Remitted should only be      *
009100200528      *           initialized during insert and if the value is zero. *
009200200528      *           Appled fix annotated as 227243.                     *
009300200528      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
009400200528      *  227243 - Charge amount fields not reset. Fix is to initialize*
009500200528      *           the Receiver's Charges Remitted field only during   *
009600200528      *           insert and value is zero. Applied fix 223133.       *
009700200528      *  CSD027 - Conversion Of Customer Number to Alpha              *
009800200528      *  CDL038 - Extended Deal Sub Type (Recompile)                  *
009900200528      *  BUG4331- Do not overwrite charges entered with defaults      *
010000200528      *           during amendement or insert.                        *
010100200528      *  CGL014 - Collaterals Processing (Recompile)                  *
010200200528      *  CGL029 - Increase Account Code to 10 digits                  *
010300200528      *  CAP084 - MidasPlus Changes                                   *
010400200528      *  219241 - Defaulting of "Details of Charges" assign a         *
010500200528      *           system value                                        *
010600200528      *  210873 - Initialise customer parameter to calculate correct  *
010700200528      *           default charges.                                    *
010800200528      *  196562 - Transfer Commission Charge should recalculate after *
010900200528      *           settlement amount is amended.                       *
011000200528      *  CFT009 - Funds Transfer Fees and Charges.                    *
011100200528      *  187056 - IP and OP do not recalculate screen charges if      *
011200200528      *           'Charges to the Debit of a/c' has been changed      *
011300200528      *           from blank to non-blank.                            *
011400200528      *  CFT014 - Straight-through Processing Phase 2 MT103           *
011500200528      *           Messages Generation for FT.                         *
011600200528      *           Note that this module is now called from            *
011700200528      *           the fourth screen where all charges have been       *
011800200528      *           moved.                                              *
011900200528      *  175479 - Recompile over changes in outgoing payment file     *
012000200528      *  CFT007 - BIC Database Plus Integration                       *
012100200528      *  CFT004 - Recompile, IBAN - International Bank Account Number *
012200200528      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
012300200528      *           Recompiled due to database changes                  *
012400200528      *  CAP031 - Conversion of FT inputs into modular structure to   *
012500200528      *           use as APIs.                                        *
012600200528      *                                                               *
012700200528      *****************************************************************
012800200528      ** +--------------------------------------+
012900200528      ** ¦ F-specs                              ¦
013000200528      ** ¦ =======                              ¦
013100200528      ** +--------------------------------------+
013200200528      *****************************************************************
013300200528
013400200528      *****************************************************************
013500200528      ** +--------------------------------------+
013600200528      ** ¦ Automatically included D-specs       ¦
013700200528      ** ¦ ==============================       ¦
013800200528      ** +--------------------------------------+
013900200528      **
014000200528      ** Standard D-specs
014100200528      ** ================
014200200528      **
014300200528      ** The following /COPY line includes the LDA layout,
014400200528      ** the copyright array definition,
014500200528      ** and the following named constants:
014600200528      **    True       logical = *on (for indicator processing)
014700200528      **    False      logical = *off (for indicator processing)
014800200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
014900200528      **                                    handler)
015000200528      ** and the following variables:
015100200528      **    RunBefore  1A (for the PSSR)
015200200528
015300200528     D/COPY ZACPYSRC,STD_D_SPEC
015400200528
015500200528      ** Program Status Data Structure
015600200528      ** =============================
015700200528      ** The following /COPY line includes all the defined fields in the
015800200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
015900200528
016000200528     D/COPY ZACPYSRC,PSDS
016100200528      ** The following /COPY line includes definitions for the above fields
016200200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
016300200528      ** corresponding fields in the PSDS /COPY member, so that member
016400200528      ** must be included where this one is used.
016500200528
016600200528     D/COPY ZACPYSRC,PROCPARMS
016700200528
016800200528      **--------------------------------------------------------------------------------------------
016900200528      ** The following /COPY line includes the definitions for error and
017000200528      ** warning message arrays.
017100200528     D/COPY ZACPYSRC,ERR_ARRAYS
017200200528      **--------------------------------------------------------------------------------------------
017300200528
017400200528      ** +--------------------------------------+
017500200528      ** ¦ End of automatically included D-specs¦
017600200528      ** ¦ =====================================¦
017700200528      ** +--------------------------------------+
017800200528
017900200528      *                                                                                       210873
018000200528     D P0DTA           DS           256                                                       210873
018100200528      ** Calling parameter DS for FT0035                                                      210873
018200200528     D  WIPT1                  1      1                                                       210873
018300200528     D  WIPTY1                 2     36                                                       210873
018400200528     D  WIPT2                 37     37                                                       210873
018500200528     D  WIPTY2                38     72                                                       210873
018600200528     D  WICCY                 73     75                                                       210873
018700200528     D  WOCUST                76     81                                                       210873
018800200528      *****************************************************************
018900200528      /EJECT
019000200528      *****************************************************************
019100200528
019200200528      ** +--------------------------------------+
019300200528      ** ¦ Manually included D-specs            ¦
019400200528      ** ¦ =========================            ¦
019500200528      ** +--------------------------------------+
019600200528
019700200528      ** +--------------------------------------+
019800200528      ** ¦ Named constants                      ¦
019900200528      ** ¦ ===============                      ¦
020000200528      ** +--------------------------------------+
020100200528
020200200528      ** The maximum size of the appended error arrays
020300200528     D XArrayMax       C                   CONST(20)
020400200528
020500200528      ** +--------------------------------------+
020600200528      ** ¦ Arrays and Data Structures           ¦
020700200528      ** ¦ ==========================           ¦
020800200528      ** +--------------------------------------+
020900200528
021000200528     D @SF             S             10  0 DIM(10) CTDATA PERRCD(1)
021100200528
021200200528
021300200528      * Array of Fields in error.
021400200528     D FldNamXAr       S             10A   DIM(XArrayMax)
021500200528
021600200528      * Array of error message IDs
021700200528     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
021800200528
021900200528      ** Array of error message data.
022000200528     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
022100200528
022200200528      ** Array of Fields with warnings.
022300200528     D WFldNmXAr       S             10A   DIM(XArrayMax)
022400200528
022500200528      ** Array of warning message IDs
022600200528     D WMsgIDXAr       S                   DIM(XArrayMax) LIKE(#MsgId)
022700200528
022800200528      ** Array of warning message data.
022900200528     D WMsgDtXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
023000200528
023100200528      * Incoming Transaction (screen formats)
023200200528     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
023300200528     D TranInSecA    E DS                  EXTNAME(FTOPY2PD)
023400200528     D TranInSecB    E DS                  EXTNAME(FTOPY3PD)
023500200528     D TranInThir    E DS                  EXTNAME(FTOPY4PD)
023600200528     D TranInFour    E DS                  EXTNAME(FTOPY6PD)                    CFT014
023700200528
023800200528      * Incoming Transaction (file format)
023900200528     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
024000200528
024100200528     D ExtData       E DS                  EXTNAME(FTOPEXPD)
024200200528      * FT (OPAY) Extra Data - File (D/B) format
024300200528
024400200528      * Valid Payments layout
024500200528     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
024600200528
024700200528      * Flags to indicate whether transaction fields are valid
024800200528
024900200528     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
025000200528      * Error indicators - Main screen
025100200528
025200200528     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
025300200528      * Error indicators - Level 2 details
025400200528
025500200528     D*FTEOPY3***    E DS                  EXTNAME(FTEOPY3PD)                   CFT014
025600200528      **Error*indicators*-*Charges*&*Commissions*screen****************         CFT014
025700200528                                                                                CFT014
025800200528     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
025900200528      ** Error indicators - Charges & Commissions screen                        CFT014
026000200528
026100200528      * Validation Work Fields
026200200528     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
026300200528
026400200528      * External DS for Bank details
026500200528     D SDBANK        E DS                  EXTNAME(SDBANKPD)
026600200528
026700200528      * External DS for Midas modules details
026800200528     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
026900200528
027000200528      * External DS for Funds Transfer details
027100200528     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
027200200528
027300200528      * External DS for Currency details
027400200528     D SDCURR        E DS                  EXTNAME(SDCURRPD)
027500200528
027600200528      * Switchable Features File
027700200528     D SCSARD        E DS                  EXTNAME(SCSARDPD)
027800200528     D XLCD          E                     EXTFLD(LCD)
027900200528
028000200528      ** External DS for Midas Message Management ICD                                         219241
028100200528     D SDMGME        E DS                  EXTNAME(SDMGMEPD)                                  219241
028200200528                                                                                              219241
028300200528      * First DS for access programs, short data structure
028400200528     D DSFDY         E DS                  EXTNAME(DSFDY)
028500200528
028600200528      * Second DS for access programs, long data structure
028700200528     D DSSDY         E DS                  EXTNAME(DSSDY)
028800200528
028900200528     D ValidDeal     E DS                  EXTNAME(FXVFXDLPD)
029000200528      * Valid Deals layout
029100200528
029200200528     D TranIn        E DS                  EXTNAME(FXFXDLPD)
029300200528      * Incoming Transaction
029400200528
029500200528      ** FT0010 input parameters                                                              CFT014
029600200528     D/COPY FTCPYSRC,FT0010D001                                                               CFT014
029700200528
029800200528     D TCNTRL          DS           256
029900200528     D  WPDTI                  1      1
030000200528     D  WGLUI                  4      4
030100200528     D  WVATF                  6      6
030200200528
030300200528      * Data structure to retrieve VAT rate
030400200528     DVATDS            DS
030500200528     D WVATR                  10     12P 4
030600200528
030700200528     D W7DATA          DS           321
030800200528      * Data structure for calculation of default charges (FT0320)
030900200528     D  W7PYTP                 1      2
031000200528     D  W7PYST                 3      4
031100200528      *
031200200528      * Input currency and charge currency
031300200528     D  W7ICCY                 5      7
031400200528     D  W7CCCY                 8     10
031500200528      *
031600200528      * Settlement method
031700200528     D  W7STMT                11     12
031800200528      *
031900200528      * Defaults required
032000200528     D  W7DFRQ                13     13
032100200528      *
032200200528      * Charges branch
032300200528     D  W7BRCA                14     16
032400200528      *
032500200528      * Charge currency amount
032600200528     D  W7CAMT                17     29  0
032700200528      *
032800200528      * Transfer Commission type
032900200528     D  W7TRCT                30     30
033000200528      *
033100200528      * SWIFT priority code
033200200528     D  W7SWPC                31     31
033300200528      *
033400200528      * Transfer Commission amount
033500200528     D  W7TRCD                32     42  0
033600200528     D  W7TRCH                43     53  0
033700200528      *
033800200528      * Telex charge
033900200528     D  W7TXCD                54     64  0
034000200528     D  W7TXCH                65     75  0
034100200528      *
034200200528      * Cheque Charge
034300200528     D  W7CQCD                76     86  0
034400200528     D  W7CQCH                87     97  0
034500200528      *
034600200528      * Costs Abroad
034700200528     D  W7CSTD                98    108  0
034800200528     D  W7CSTA               109    119  0
034900200528      *
035000200528      * SWIFT Priority Charge
035100200528     D  W7SPCD               120    130  0
035200200528     D  W7SPCH               131    141  0
035300200528      *
035400200528      * Miscellaneous charge
035500200528     D  W7MSCD               142    152  0
035600200528     D  W7MSCH               153    163  0
035700200528      *
035800200528      * Advice Charge
035900200528     D  W7ADCD               164    174  0
036000200528     D  W7ADCH               175    185  0
036100200528      *
036200200528      * Telephone Charge
036300200528     D  W7TLCD               186    196  0
036400200528     D  W7TLCH               197    207  0
036500200528      *
036600200528      * Collection Charge
036700200528     D  W7COLD               208    218  0
036800200528     D  W7COLL               219    229  0
036900200528      *
037000200528      * Payment amount currency
037100200528     D  W7PCCY               230    232
037200200528     D*
037300200528     D** Other currency
037400200528     D  W7OCCY               233    235
037500200528     D*
037600200528     D** FX/Change commission (input ccy)
037700200528     D  W7CHCD               236    246  0
037800200528     D*
037900200528     D** FX/Change commission (charge ccy)
038000200528     D  W7CHCM               247    257  0
038100200528     D*
038200200528     D** Our deductions (input ccy)
038300200528     D  W7DEDD               258    268  0
038400200528     D*
038500200528     D** Our deductions (charge ccy)
038600200528     D  W7DEDS               269    279  0
038700200528     D*
038800200528     D** Correspondent charge (input ccy)
038900200528     D  W7COCD               280    290  0
039000200528     D*
039100200528     D** Correspondent charge (charge ccy)
039200200528     D  W7COCH               291    301  0
039300200528     D*
039400200528     D** Default type (HDR or DET or " ")
039500200528     D  W7DFTT               302    304
039600200528     D*
039700200528     D** Customer to be debited the charge
039800200528     D  W7CUST               305    310
039900200528      *
040000200528     D** Settle Date
040100200528     D  W7SLDT               311    315  0
040200200528     D** Pay Date
040300200528     D  W7PVDT               316    320  0
040400200528     D** Add/Deduct Charges
040500200528     D  W7ADDC               321    321
040600200528
040700200528      ** +--------------------------------------+
040800200528      ** ¦ Declared variables                   ¦
040900200528      ** ¦ ==================                   ¦
041000200528      ** +--------------------------------------+
041100200528
041200200528      ** Index for arrays of error message ids etc
041300200528     D Idx             S              3P 0
041400200528
041500200528      ** Index for arrays of of warning message ids etc
041600200528     D WIdx            S              3P 0
041700200528
041800200528
041900200528      * A code to indicate the calling function to the lower level modules
042000200528     D OPAY            S              4A   INZ('OPAY')
042100200528
042200200528      * Response Mode, received as a parameter from the common header
042300200528     D RespMode        S              1A
042400200528
042500200528     D I               S              3  0
042600200528     D PRTCD           S              7                                                       219241
042700200528     D POPTN           S              7                                                       219241
042800200528      *                                                                                       CFT120
042900200528      ** CFT120 switchable field                                                              CFT120
043000200528      *                                                                                       CFT120
043100200528     D CFT120          S              1A                                                      CFT120
043200200528
043300200528      ** +--------------------------------------+
043400200528      ** ¦ End of D-specs                       ¦
043500200528      ** ¦ ==============                       ¦
043600200528      ** +--------------------------------------+
043700200528      *****************************************************************
043800200528      /EJECT
043900200528      ** +--- Start of Main processing -----------------------------------+
044000200528      ** ¦                                                                ¦
044100200528      ** ¦ Initial processing is performed automatically: the *INZSR is   ¦
044200200528      ** ¦ executed at program activation.                                ¦
044300200528      ** ¦                                                                ¦
044400200528      ** +----------------------------------------------------------------+
044500200528
044600200528      * Initial Processing
044700200528     C                   EXSR      INIT
044800200528
044900200528      ***If*action*code*is*enquiry*no*validation*has*been*done,*************    CFT014
045000200528      ***therefore*fields*@CCCY*&*@PCCY*will*not*have*been*set*up.**********    CFT014
045100200528      ***Call*relevent*modules*to*initialise*these*fields.******************    CFT014
045200200528      ***********                                                               CFT014
045300200528     C*****SACTION       IFEQ      'E'                                          CFT014
045400200528     C***********        EXSR      DFTCCYS                                      CFT014
045500200528     C***********        END                                                    CFT014
045600200528                                                                                CFT014
045700200528      ** Action taken is 'I' or 'A', default @CCCY and @RCCY.                   CFT014
045800200528                                                                                CFT014
045900200528     C                   If        (SACTION = 'I') Or (SACTION = 'A')           CFT014
046000200528     C                   ExSr      SrDFTCY                                      CFT014
046100200528     C                   EndIf                                                  CFT014
046200200528
046300200528      *  Calculate Default charges
046400200528     C                   Exsr      DFTCHARGES
046500200528
046600200528      *  Default VAT Flags
046700200528     C                   If        @VATP = 'Y'
046800200528     C                   Exsr      DFTVATFLG
046900200528     C                   End
047000200528                                                                                CFT014
047100200528      ** Set OKFLAG to 'Y' if the action taken is 'E'                           CFT014
047200200528                                                                                CFT014
047300200528     C                   If        SACTION = 'E'                                CFT014
047400200528     C                   Move      *All'Y'       FTEOPY1                        CFT014
047500200528     C                   Move      *All'Y'       FTEOPY2                        CFT014
047600200528     C                   Move      *All'Y'       FTEOPY4                        CFT014
047700200528     C                   EndIf                                                  CFT014
047800200528
047900200528      * RETURN
048000200528     C                   RETURN
048100200528
048200200528      *****************************************************************         CFT014
048300200528     C***/EJECT*                                                                CFT014
048400200528      *****************************************************************         CFT014
048500200528      ***DFTCCYS***-*Default*Charges*and*Payment*Currency*fields.******         CFT014
048600200528      ***************Calls*FTVSEIN*************************************         CFT014
048700200528      *********************FTVCSRF*************************************         CFT014
048800200528      *****************************************************************         CFT014
048900200528     C*****DFTCCYS       BEGSR                                                  CFT014
049000200528      ***********                                                               CFT014
049100200528      **Reset*variables*updated*by*each*module*************************         CFT014
049200200528     C***********        Exsr      RESETERRS                                    CFT014
049300200528      ***********                                                               CFT014
049400200528      **Validate*******************************************************         CFT014
049500200528     C***********        CALLB     'FTVSEIN'                                    CFT014
049600200528      **INPUTS*********************************************************         CFT014
049700200528      ***Return*Code***************************************************         CFT014
049800200528     C***********        Parm                    RetCodeOut                     CFT014
049900200528      ***********                                                               CFT014
050000200528      ***Screen*fields*************************************************         CFT014
050100200528     C***********        Parm                    TranInPrim                     CFT014
050200200528      ***********                                                               CFT014
050300200528      ***Bank*ICD*Details**********************************************         CFT014
050400200528     C***********        Parm                    SDBANK                         CFT014
050500200528      ***********                                                               CFT014
050600200528      **OUTPUTS********************************************************         CFT014
050700200528      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
050800200528     C***********        Parm                    FldNamXAr                      CFT014
050900200528     C***********        Parm                    MsgIDXAr                       CFT014
051000200528     C***********        Parm                    MsgDtaXAr                      CFT014
051100200528      ***********                                                               CFT014
051200200528      ***OK*Flags*(screen*1)*******************************************         CFT014
051300200528     C***********        Parm                    FTEOPY1                        CFT014
051400200528      ***********                                                               CFT014
051500200528      ***Validation*Work*Fields****************************************         CFT014
051600200528     C***********        Parm                    Val@Fields                     CFT014
051700200528      ***********                                                               CFT014
051800200528      ***Funds*transfer*Details****************************************         CFT014
051900200528     C***********        Parm                    SDFTFR                         CFT014
052000200528      ***********                                                               CFT014
052100200528      ***********                                                               CFT014
052200200528      **Reset*variables*updated*by*each*module*************************         CFT014
052300200528     C***********        Exsr      RESETERRS                                    CFT014
052400200528      ***********                                                               CFT014
052500200528      ***Validate******************************************************         CFT014
052600200528     C***********        CALLB     'FTVCSRF'                                    CFT014
052700200528      **INPUTS*********************************************************         CFT014
052800200528      ***Return*Code***************************************************         CFT014
052900200528     C***********        Parm                    RetCodeOut                     CFT014
053000200528      ***********                                                               CFT014
053100200528      ***Screen*fields*************************************************         CFT014
053200200528     C***********        Parm                    TranInPrim                     CFT014
053300200528     C***********        Parm                    TranInSecA                     CFT014
053400200528      ***********                                                               CFT014
053500200528      **OUTPUTS********************************************************         CFT014
053600200528      ***Error*fields/message*IDs/message*data*(arrays)*from/to*caller*         CFT014
053700200528     C***********        Parm                    FldNamXAr                      CFT014
053800200528     C***********        Parm                    MsgIDXAr                       CFT014
053900200528     C***********        Parm                    MsgDtaXAr                      CFT014
054000200528      ***********                                                               CFT014
054100200528      ***OK*Flags*(screen*2)*******************************************         CFT014
054200200528     C***********        Parm                    FTEOPY2                        CFT014
054300200528      ***********                                                               CFT014
054400200528      ***Validation*Work*Fields****************************************         CFT014
054500200528     C***********        Parm                    Val@Fields                     CFT014
054600200528      ***********                                                               CFT014
054700200528     C***********        ENDSR                                                  CFT014
054800200528                                                                                CFT014
054900200528      *****************************************************************         CFT014
055000200528      /Title Sr/SrDFTCY                                                         CFT014
055100200528      *****************************************************************         CFT014
055200200528      *                                                               *         CFT014
055300200528      * SR/SrDFTCY   - Default @CCCY and @RCCY for Insert or Amend    *         CFT014
055400200528      *                                                               *         CFT014
055500200528      * Called By: Main Routine                                       *         CFT014
055600200528      *                                                               *         CFT014
055700200528      * Calls: None                                                   *         CFT014
055800200528      *                                                               *         CFT014
055900200528      *****************************************************************         CFT014
056000200528                                                                                CFT014
056100200528     C     SrDFTCY       BegSr                                                  CFT014
056200200528                                                                                CFT014
056300200528      ** Default @CCCY                                                          CFT014
056400200528                                                                                CFT014
056500200528     C**********         If        BTCHCY = 'C'                                        CFT014 187056
056600200528     C**********         If        SADDC = 'A'                                         CFT014 187056
056700200528     C**********         Eval      @CCCY = SSMCY                                       CFT014 187056
056800200528     C**********         Else                                                          CFT014 187056
056900200528     C**********         Eval      @CCCY = SPCCY                                       CFT014 187056
057000200528     C**********         EndIf                                                         CFT014 187056
057100200528      **********                                                                       CFT014 187056
057200200528     C**********         Else                                                          CFT014 187056
057300200528     C**********         If        BTCHCY = 'L'                                        CFT014 187056
057400200528     C**********         Eval      @CCCY = BJLCCY                                      CFT014 187056
057500200528     C**********         Else                                                          CFT014 187056
057600200528     C**********         Eval      @CCCY = BJCYCD                                      CFT014 187056
057700200528     C**********         EndIf                                                         CFT014 187056
057800200528     C**********         EndIf                                                         CFT014 187056
057900200528                                                                                              187056
058000200528     C                   SELECT                                                               187056
058100200528     C                   WHEN      BTCHCY = 'B' OR SCDRO <> *BLANKS                           187056
058200200528     C**********                   AND CFT120 = 'N'                                 CFT120 AR1080200
058300200528     C                             AND CFT120 = 'N' AND BTCHCY = 'C'                       AR1080200
058400200528     C                   EVAL      @CCCY = BJCYCD                                             187056
058500200528     C                   WHEN      CFT120 = 'Y' AND SCDRO <> *BLANKS                       AR1080200
058600200528     C                             AND BTCHCY = 'C'                                        AR1080200
058700200528     C                   EVAL      @CCCY = SCDRC                                           AR1080200
058800200528     C                   WHEN      BTCHCY = 'L'                                               187056
058900200528     C                   EVAL      @CCCY = BJLCCY                                             187056
059000200528     C                   WHEN      BTCHCY = 'C' AND SADDC = 'A'                               187056
059100200528     C                   EVAL      @CCCY = SSMCY                                              187056
059200200528     C                   OTHER                                                                187056
059300200528     C                   EVAL      @CCCY = SPCCY                                              187056
059400200528     C                   ENDSL                                                                187056
059500200528                                                                                CFT014
059600200528      ** Default @RCCY                                                          CFT014
059700200528                                                                                CFT014
059800200528     C                   If        (SCDRO <> *Blank) And (OKCDRO = 'Y')         CFT014
059900200528      *                                                                                       CFT120
060000200528     C                   If        SCDRC = *Blanks AND CFT120 = 'Y'                           CFT120
060100200528     C                             OR CFT120 = 'N'                                            CFT120
060200200528     C                   Eval      @RCCY = BJCYCD                               CFT014
060300200528     C                   Else                                                                 CFT120
060400200528     C                   Eval      @RCCY = SCDRC                                              CFT120
060500200528     C                   Endif                                                                CFT120
060600200528      *                                                                                       CFT120
060700200528     C                   Else                                                   CFT014
060800200528     C                   If        SADDC = 'A'                                  CFT014
060900200528     C                   Eval      @RCCY = SSMCY                                CFT014
061000200528     C                   Else                                                   CFT014
061100200528     C                   Eval      @RCCY = SPCCY                                CFT014
061200200528     C                   EndIf                                                  CFT014
061300200528     C                   EndIf                                                  CFT014
061400200528                                                                                CFT014
061500200528     C                   EndSr                                                  CFT014
061600200528                                                                                CFT014
061700200528      *****************************************************************
061800200528      /EJECT
061900200528      *****************************************************************
062000200528      ** DFTCHARGES- Default Charges
062100200528      **  calls - FT0320
062200200528      *****************************************************************
062300200528     C     DFTCHARGES    BEGSR
062400200528
062500200528     C                   CLEAR                   W7DATA
062600200528
062700200528     C** Payment type and subtype
062800200528     C*
062900200528     C                   MOVEL     SPYTP         W7PYTP
063000200528     C                   MOVEL     SPYST         W7PYST
063100200528     C*
063200200528     C** Input currency and charge currency
063300200528     C*
063400200528     C                   MOVE      @CCCY         W7ICCY                                       187056
063500200528     C                   MOVEL     @RCCY         W7CCCY                                       187056
063600200528     C**********         SELECT                                                               187056
063700200528     C*****BTCHCY        WHENEQ    'C'                                                        187056
063800200528     C*****SADDC         IFEQ      'A'                                                        187056
063900200528     C**********         MOVE      SSMCY         W7ICCY                                       187056
064000200528     C**********         ELSE                                                                 187056
064100200528     C**********         MOVE      SPCCY         W7ICCY                                       187056
064200200528     C**********         END                                                                  187056
064300200528     C*****BTCHCY        WHENEQ    'L'                                                        187056
064400200528     C**********         MOVE      BJLCCY        W7ICCY                                       187056
064500200528     C**********         OTHER                                                                187056
064600200528     C**********         MOVE      BJCYCD        W7ICCY                                       187056
064700200528     C**********         ENDSL                                                                187056
064800200528     C**********                                                                              187056
064900200528     C*****SADDC         IFEQ      'A'                                                        187056
065000200528     C**********         MOVEL     SSMCY         W7CCCY                                       187056
065100200528     C**********         ELSE                                                                 187056
065200200528     C**********         MOVEL     SPCCY         W7CCCY                                       187056
065300200528     C**********         END                                                                  187056
065400200528     C*
065500200528     C** Settlement method
065600200528     C*
065700200528     C                   MOVEL     SSTTP         W7STMT
065800200528     C*
065900200528     C** Defaults required
066000200528     C*
066100200528     C                   MOVEL     'Y'           W7DFRQ
066200200528     C*
066300200528     C* Charges branch
066400200528     C                   MOVEL     @PYBR         W7BRCA
066500200528     C*
066600200528     C* Charge currency amount
066700200528     C*
066800200528     C                   SELECT
066900200528     C*
067000200528     C     SADDC         WHENEQ    'A'
067100200528     C                   Z-ADD     @SMAM         W7CAMT
067200200528     C                   MOVEL     SSMCY         W7PCCY
067300200528     C*
067400200528     C                   OTHER
067500200528     C                   Z-ADD     @PYAM         W7CAMT
067600200528     C                   MOVEL     SPCCY         W7PCCY
067700200528     C                   ENDSL
067800200528     C*
067900200528     C** Transfer Commission type
068000200528     C*
068100200528     C                   MOVEL     STRCT         W7TRCT
068200200528     C*
068300200528     C** SWIFT priority code
068400200528     C*
068500200528     C     SSWPC         IFEQ      'U'
068600200528     C                   MOVEL     'U'           W7SWPC
068700200528     C                   ELSE
068800200528     C                   MOVEL     'N'           W7SWPC
068900200528     C                   END
069000200528     C*
069100200528      ** For Amend or Enquiry set up current charges from file.
069200200528
069300200528     C     SACTION       IFNE      'I'
069400200528
069500200528      * Transfer Commission amount
069600200528     C                   Z-ADD     DUMA1         W7TRCD
069700200528     C                   Z-ADD     DUMA1         @TRCD
069800200528     C                   Z-ADD     TRCM          W7TRCH
069900200528     C                   Z-ADD     TRCM          @TRCM
070000200528      *
070100200528      * Telex charge
070200200528     C                   Z-ADD     DUMA2         W7TXCD
070300200528     C                   Z-ADD     DUMA2         @TXCD
070400200528     C                   Z-ADD     TXCH          W7TXCH
070500200528     C                   Z-ADD     TXCH          @TXCH
070600200528      *
070700200528      * Cheque Charge
070800200528     C                   Z-ADD     DUMA3         W7CQCD
070900200528     C                   Z-ADD     DUMA3         @CQCD
071000200528     C                   Z-ADD     CQCH          W7CQCH
071100200528     C                   Z-ADD     CQCH          @CQCH
071200200528      *
071300200528      * Costs Abroad
071400200528     C                   Z-ADD     DUMA4         W7CSTD
071500200528     C                   Z-ADD     DUMA4         @CSTD
071600200528     C                   Z-ADD     CSTA          W7CSTA
071700200528     C                   Z-ADD     CSTA          @CSTA
071800200528      *
071900200528      * SWIFT Priority Charge
072000200528     C                   Z-ADD     DUMA5         W7SPCD
072100200528     C                   Z-ADD     DUMA5         @SPCD
072200200528     C                   Z-ADD     SPCH          W7SPCH
072300200528     C                   Z-ADD     SPCH          @SPCH
072400200528      *
072500200528      * Miscellaneous charge
072600200528     C                   Z-ADD     DUMA6         W7MSCD
072700200528     C                   Z-ADD     DUMA6         @MSCD
072800200528     C                   Z-ADD     MSCH          W7MSCH
072900200528     C                   Z-ADD     MSCH          @MSCH
073000200528     C*
073100200528     C** FX/Change Commission
073200200528     C*
073300200528     C     @01494        IFEQ      'Y'
073400200528     C                   Z-ADD     OPDUM7        W7CHCD
073500200528     C                   Z-ADD     OPDUM7        @CHCD
073600200528     C                   Z-ADD     OPCHCM        W7CHCM
073700200528     C                   Z-ADD     OPCHCM        @CHCM
073800200528     C                   END
073900200528      *
074000200528     C                   END
074100200528
074200200528     C                   MOVEL     *BLANKS       W7ACT
074300200528     C                   MOVEL     'OP'          W7ACT
074400200528     C*
074500200528     C**  Other currency
074600200528     C*
074700200528     C                   SELECT
074800200528     C*
074900200528     C     SCDRO         WHENNE    *BLANK
075000200528     C     SSMCY         ANDNE     SPCCY
075100200528     C                   MOVE      '***'         W7OCCY
075200200528     C*
075300200528     C     SCDRO         WHENNE    *BLANK
075400200528     C     SSMCY         ANDEQ     SPCCY
075500200528     C                   MOVE      W7PCCY        W7OCCY
075600200528     C*
075700200528     C     SADDC         WHENEQ    'D'
075800200528     C                   MOVE      SSMCY         W7OCCY
075900200528     C*
076000200528     C     SADDC         WHENEQ    'A'
076100200528     C                   MOVE      SPCCY         W7OCCY
076200200528     C*
076300200528     C                   ENDSL
076400200528     C*
076500200528      * Set up EMU fields for default calculations
076600200528      *
076700200528      * Settle Value Date
076800200528     C                   Z-ADD     @SLDT         W7SLDT
076900200528      *
077000200528      * Pay Value Date
077100200528     C                   Z-ADD     @PVDT         W7PVDT
077200200528      *
077300200528      * Add/Deduct Indicator
077400200528     C                   MOVEL     SADDC         W7ADDC
077500200528      *                                                                                       210873
077600200528      ** Get Customer                                                                         210873
077700200528      *                                                                                       210873
077800200528     C                   MOVE      *BLANKS       P0DTA                                        210873
077900200528     C                   SELECT                                                               210873
078000200528                                                                                              210873
078100200528      * Only use ordering customer if S01506                                                  210873
078200200528     C     @01506        WHENEQ    'Y'                                                        210873
078300200528     C                   MOVEL     OTORCT        WIPT1                                        210873
078400200528     C                   MOVEL     SORC1         WIPTY1                                       210873
078500200528     C                   MOVEL     SSMCY         WICCY                                        210873
078600200528                                                                                              210873
078700200528      * If add use ordering side                                                              210873
078800200528     C     OTADDC        WHENEQ    'A'                                                        210873
078900200528     C                   MOVEL     OTORCT        WIPT1                                        210873
079000200528     C                   MOVEL     SORC1         WIPTY1                                       210873
079100200528     C                   MOVEL     SSMCY         WICCY                                        210873
079200200528     C     OTORBT        IFNE      *BLANKS                                                    210873
079300200528     C                   MOVE      *BLANKS       WORBKC           15                          210873
079400200528     C                   MOVEL     OTORBK        WFLDO            12                          210873
079500200528     C     WFLDO         CAT       OTORBB        WORBKC                                       210873
079600200528     C                   MOVEL     OTORBT        WIPT2                                        210873
079700200528     C                   MOVEL     WORBKC        WIPTY2                                       210873
079800200528     C                   END                                                                  210873
079900200528                                                                                              210873
080000200528      * If deduct use pay to instructions                                                     210873
080100200528     C     OTADDC        WHENEQ    'D'                                                        210873
080200200528     C                   MOVEL     OTDSTT        WIPT1                                        210873
080300200528     C                   MOVEL     OTDST1        WIPTY1                                       210873
080400200528     C                   MOVEL     OTPCCY        WICCY                                        210873
080500200528     C     OTSNCT        IFNE      *BLANKS                                                    210873
080600200528     C                   MOVEL     OTSNCT        WIPT2                                        210873
080700200528     C                   MOVEL     OTSNCO        WIPTY2                                       210873
080800200528     C                   END                                                                  210873
080900200528     C                   ENDSL                                                                210873
081000200528      ** Call FT0035 to get customer number to be debited the charges.                        210873
081100200528      *                                                                                       210873
081200200528     C                   CALL      'FT0035'                             9090                  210873
081300200528     C                   PARM      *BLANKS       PRTCD             7                          210873
081400200528     C                   PARM                    P0DTA                                        210873
081500200528     C                   PARM                    P0MSG           256                          210873
081600200528      *                                                                                       210873
081700200528     C     OTODMT        IFNE      *BLANKS                                                    210873
081800200528     C     OTADDC        ANDEQ     'A'                                                        210873
081900200528     C                   MOVE      OTODMT        W7CUST                                       210873
082000200528     C                   ELSE                                                                 210873
082100200528     C                   IF        (PRTCD = *BLANKS)                                          210873
082200200528     C                   MOVE      WOCUST        W7CUST                                       210873
082300200528     C                   ELSE                                                                 210873
082400200528     C                   MOVE      *BLANKS       W7CUST                                       210873
082500200528     C                   ENDIF                                                                210873
082600200528     C                   ENDIF                                                                210873
082700200528      *                                                                                       210873
082800200528      *
082900200528     C** Call defaults program
083000200528     C*
083100200528     C                   CALL      'FT0320'                             9090
083200200528     C                   PARM      *BLANKS       W7RTN             7
083300200528     C                   PARM                    W7ACT             8
083400200528     C                   PARM                    W7DATA
083500200528      *
083600200528     C     *IN90         IFEQ      '1'
083700200528     C     W7RTN         ORNE      *BLANKS
083800200528     C                   MOVEL     'FT0320'      DBKEY
083900200528     C                   MOVEL     '35'          DBASE
084000200528     C                   MOVEL     '*CALL   '    DBFILE
084100200528     C                   EXSR      *PSSR
084200200528     C                   END
084300200528     C*
084400200528      ** Get Input Currency decimal places
084500200528     C*
084600200528     C                   MOVE      W7ICCY        @AJCD             3
084700200528     C                   CALLB     'AOCURRR0'
084800200528     C                   PARM      *BLANK        @RTCD             7
084900200528     C                   PARM      '*KEY   '     @OPTN             7
085000200528     C                   PARM                    @AJCD
085100200528     C     SDCURR        PARM      SDCURR        DSSDY
085200200528     C*
085300200528     C** Set up the screen fields with default values only if no value
085400200528     C** already input.
085500200528
085600200528     C** Transfer Commission amount (input currency)
085700200528      ** Fix 196562 is invalid, as user cannot overwrite the system                          BUG4331
085800200528      ** value.                                                                              BUG4331
085900200528      ** To get the system to recalculate, user should blank out the                         BUG4331
086000200528      ** the field.                                                                          BUG4331
086100200528     C*
086200200528     C*****STRCD         IFEQ      *BLANKS                                                    196562
086300200528     C*****PReCalc       OREQ      'Y'                                                 187056 196562
086400200528     C     STRCD         IFEQ      *BLANKS                                                   BUG4331
086500200528     C                   Z-ADD     W7TRCD        @TRCD
086600200528     C                   Z-ADD     W7TRCH        @TRCM
086700200528     C**********         END                                                                  196562
086800200528     C*
086900200528     C     @TRCD         IFNE      0
087000200528     C                   Z-ADD     @TRCD         @@AMTW
087100200528     C                   Z-ADD     A6NBDP        @@QECN
087200200528     C                   EXSR      FMTAMT
087300200528     C                   MOVE      @@AMTD        STRCD
087400200528     C                   END
087500200528     C                   END                                                                 BUG4331
087600200528      *
087700200528     C**Telex charge (input currency)
087800200528     C*
087900200528     C     STXCD         IFEQ      *BLANKS
088000200528     C     PReCalc       OREQ      'Y'                                                        187056
088100200528     C                   Z-ADD     W7TXCD        @TXCD
088200200528     C                   Z-ADD     W7TXCH        @TXCH
088300200528     C***************    END                                                                 BUG4331
088400200528     C*
088500200528     C     @TXCD         IFNE      0
088600200528     C                   Z-ADD     @TXCD         @@AMTW
088700200528     C                   Z-ADD     A6NBDP        @@QECN
088800200528     C                   EXSR      FMTAMT
088900200528     C                   MOVE      @@AMTD        STXCD
089000200528     C                   END
089100200528     C                   END                                                                 BUG4331
089200200528      *
089300200528     C** Cheque Charge (input currency)
089400200528     C*
089500200528     C     SCQCD         IFEQ      *BLANKS
089600200528     C     PReCalc       OREQ      'Y'                                                        187056
089700200528     C                   Z-ADD     W7CQCD        @CQCD
089800200528     C                   Z-ADD     W7CQCH        @CQCH
089900200528     C***************    END                                                                 BUG4331
090000200528     C*
090100200528     C     @CQCD         IFNE      0
090200200528     C                   Z-ADD     @CQCD         @@AMTW
090300200528     C                   Z-ADD     A6NBDP        @@QECN
090400200528     C                   EXSR      FMTAMT
090500200528     C                   MOVE      @@AMTD        SCQCD
090600200528     C                   END
090700200528     C                   END                                                                 BUG4331
090800200528      *
090900200528     C** Costs Abroad (input currency)
091000200528     C*
091100200528     C     SCSTD         IFEQ      *BLANKS
091200200528     C     PReCalc       OREQ      'Y'                                                        187056
091300200528     C                   Z-ADD     W7CSTD        @CSTD
091400200528     C                   Z-ADD     W7CSTA        @CSTA
091500200528     C***************    END                                                                 BUG4331
091600200528     C*
091700200528     C     @CSTD         IFNE      0
091800200528     C                   Z-ADD     @CSTD         @@AMTW
091900200528     C                   Z-ADD     A6NBDP        @@QECN
092000200528     C                   EXSR      FMTAMT
092100200528     C                   MOVE      @@AMTD        SCSTD
092200200528     C                   END
092300200528     C                   END                                                                 BUG4331
092400200528      *
092500200528     C** SWIFT Priority Charge (input currency)
092600200528     C*
092700200528     C     SSPCD         IFEQ      *BLANKS
092800200528     C     PReCalc       OREQ      'Y'                                                        187056
092900200528     C                   Z-ADD     W7SPCD        @SPCD
093000200528     C                   Z-ADD     W7SPCH        @SPCH
093100200528     C***************    END                                                                 BUG4331
093200200528     C*
093300200528     C     @SPCD         IFNE      0
093400200528     C                   Z-ADD     @SPCD         @@AMTW
093500200528     C                   Z-ADD     A6NBDP        @@QECN
093600200528     C                   EXSR      FMTAMT
093700200528     C                   MOVE      @@AMTD        SSPCD
093800200528     C                   END
093900200528     C                   END                                                                 BUG4331
094000200528      *
094100200528     C** Miscellaneous charge (input currency)
094200200528     C*
094300200528     C     SMSCD         IFEQ      *BLANKS
094400200528     C     PReCalc       OREQ      'Y'                                                        187056
094500200528     C                   Z-ADD     W7MSCD        @MSCD
094600200528     C                   Z-ADD     W7MSCH        @MSCH
094700200528     C***************    END                                                                 BUG4331
094800200528      *
094900200528     C     @MSCD         IFNE      0
095000200528     C                   Z-ADD     @MSCD         @@AMTW
095100200528     C                   Z-ADD     A6NBDP        @@QECN
095200200528     C                   EXSR      FMTAMT
095300200528     C                   MOVE      @@AMTD        SMSCD
095400200528     C                   END
095500200528     C                   END                                                                 BUG4331
095600200528     C*
095700200528     C** FX/Change Commission (input currency)
095800200528     C*
095900200528     C     @01494        IFEQ      'Y'
096000200528     C     SCHCD         IFEQ      *BLANKS
096100200528     C     PReCalc       OREQ      'Y'                                                        187056
096200200528     C                   Z-ADD     W7CHCD        @CHCD
096300200528     C                   Z-ADD     W7CHCM        @CHCM
096400200528     C                   END
096500200528      *
096600200528     C*****@TXCD*        IFNE      0                                            CFT014
096700200528     C     @CHCD         IFNE      0                                            CFT014
096800200528     C                   Z-ADD     @CHCD         @@AMTW
096900200528     C                   Z-ADD     A6NBDP        @@QECN
097000200528     C                   EXSR      FMTAMT
097100200528     C                   MOVE      @@AMTD        SCHCD
097200200528     C                   END
097300200528     C
097400200528     C                   END
097500200528                                                                                CFT014
097600200528      ** Default Details of Charges                                             CFT014
097700200528                                                                                CFT014
097800200528     C                   If        SDTCH = *Blanks                              CFT014
097900200528                                                                                              219241
098000200528      ** If CFT014 is installed, retrieve the default value from the                          219241
098100200528      ** Message Management ICD                                                               219241
098200200528                                                                                              219241
098300200528     C                   IF        @CFT014 = 'Y'                                              219241
098400200528     C                   EVAL      SDTCH = ENDCHG                                             219241
098500200528     C                   ELSE                                                                 219241
098600200528     C                   Eval      SDTCH = 'BEN'                                CFT014
098700200528     C/COPY WNCPYSRC,FTOPA3TC01
098800200528     C                   ENDIF                                                                219241
098900200528                                                                                              219241
099000200528     C                   EndIf                                                  CFT014
099100200528                                                                                CFT014
099200200528      ** Calculate fields @TRCM, @TXCH, and other charges fields                CFT014
099300200528                                                                                CFT014
099400200528     C                   CallB     'FTVCHPY'                                    CFT014
099500200528     C                   Parm                    ReTCodeOut                     CFT014
099600200528     C                   Parm                    TranInPrim                     CFT014
099700200528     C                   Parm                    TranInFour                     CFT014
099800200528     C                   Parm                    FldNamXAr                      CFT014
099900200528     C                   Parm                    MsgIDXAr                       CFT014
100000200528     C                   Parm                    MsgDtaXAr                      CFT014
100100200528     C                   Parm                    FTEOPY4                        CFT014
100200200528     C                   Parm                    Val@Fields                     CFT014
100300200528     C                   Parm                    O2XRTE                         CFT009
100400200528                                                                                CFT014
100500200528      ** If CFT014 is on and the network used indicator is 'N', subtract the    CFT014
100600200528      ** total charges from the receiver's charges                              CFT014
100700200528                                                                                CFT014
100800200528     C     @CFT014       IfEq      'Y'                                          CFT014
100900200528                                                                                CFT014
101000200528     C     @RCUS         IfEq      'N'                                          CFT014
101100200528                                                                                CFT014
101200200528      ** If charge currency is not equal to pay currency, convert charges to    CFT014
101300200528      ** pay currency                                                           CFT014
101400200528                                                                                CFT014
101500200528     C                   ExSr      SrCvtChg                                     CFT014
101600200528     C                   Eval      @RCRM = @RCRM - @PTOTCH                      CFT014
101700200528     C                   Eval      @RCUS = 'Y'                                  CFT014
101800200528     C                   EndIf                                                  CFT014
101900200528                                                                                CFT014
102000200528      ** Format Receiver's Charges                                              CFT014
102100200528                                                                                CFT014
102200200528     C     @RCRM         IfNe      *Zero                                        CFT014
102300200528     C                   CallB     'AOCURRR0'                                   CFT014
102400200528     C                   Parm      *Blank        @RTCD                          CFT014
102500200528     C                   Parm      '*KEY   '     @OPTN                          CFT014
102600200528     C                   Parm      SPCCY         @AJCD                          CFT014
102700200528     C     SDCURR        Parm      SDCURR        DSSDY                          CFT014
102800200528                                                                                CFT014
102900200528     C     @RTCD         IfNe      *Blank                                       CFT014
103000200528     C                   Movel     'SDCURRPD'    DBKEY                          CFT014
103100200528     C                   Z-Add     21            DBASE                          CFT014
103200200528     C                   Movel     SPCCY         DBFILE                         CFT014
103300200528     C                   ExSr      *PSSR                                        CFT014
103400200528     C                   EndIf                                                  CFT014
103500200528                                                                                CFT014
103600200528     C                   Movel     *Blank        ZFIELD                         CFT014
103700200528     C                   Move      @RCRM         ZFIELD                         CFT014
103800200528     C                   Z-Add     A6NBDP        ZADEC                          CFT014
103900200528     C                   CallB     'ZEDIT'                                      CFT014
104000200528     C                   Parm                    ZFIELD           16            CFT014
104100200528     C                   Parm                    ZADEC             1 0          CFT014
104200200528     C                   Move      ZFIELD        SRCRM                          CFT014
104300200528     C**********         Else                                                          CFT014 250041
104400200528     C*****SACTION       IFEQ      'I'                                                 222731 250041
104500200528     C**********         Move      *Blanks       SRCRM                                 CFT014 250041
104600200528     C**********         ENDIF                                                         222731 250041
104700200528     C                   EndIf                                                  CFT014
104800200528     C                   EndIf                                                  CFT014
104900200528     C*
105000200528     C*
105100200528     C                   ENDSR
105200200528                                                                                CFT014
105300200528      *****************************************************************         CFT014
105400200528      /Title Sr/SrCvtChg                                                        CFT014
105500200528      *****************************************************************         CFT014
105600200528      *                                                               *         CFT014
105700200528      * SR/SrCvtChg   - Convert Charges to Pay Currency               *         CFT014
105800200528      *                                                               *         CFT014
105900200528      * Called By: DFTCHARGES                                         *         CFT014
106000200528      *                                                               *         CFT014
106100200528      * Calls:                                                        *         CFT014
106200200528      * FT0010     - Validate and Calculate currencies.               *         CFT014
106300200528      *                                                               *         CFT014
106400200528      *****************************************************************         CFT014
106500200528                                                                                CFT014
106600200528     C     SrCvtChg      BegSr                                                  CFT014
106700200528                                                                                CFT014
106800200528      ** Pay Currency is equal to charge currency                               CFT014
106900200528                                                                                CFT014
107000200528     C     SPCCY         IfEq      @CCCY                                        CFT014
107100200528     C                   Z-Add     @TOTCHG       @PTOTCH          13 0          CFT014
107200200528     C                   Else                                                   CFT014
107300200528                                                                                CFT014
107400200528      ** Otherwise, convert charge amount                                       CFT014
107500200528                                                                                CFT014
107600200528     C                   Clear                   P#0010                         CFT014
107700200528     C                   Eval      P#FRCY = @CCCY                               CFT014
107800200528     C                   Eval      P#TOCY = SPCCY                               CFT014
107900200528     C                   Eval      P#FRAM = @TOTCHG                             CFT014
108000200528     C                   Call      'FT0010'                                     CFT014
108100200528     C                   Parm                    P#0010                         CFT014
108200200528                                                                                CFT014
108300200528     C                   If        P#RTCD <> *Blank                             CFT014
108400200528     C                   Eval      DBFILE = 'FT0010'                            CFT014
108500200528     C                   Eval      DBKEY = P#TOCY                               CFT014
108600200528     C                   Eval      DBASE = 1                                    CFT014
108700200528     C                   ExSr      *PSSR                                         CFT014
108800200528     C                   EndIf                                                   CFT014
108900200528                                                                                 CFT014
109000200528     C                   Z-Add     P#TOAM        @PTOTCH                         CFT014
109100200528     C                   EndIf                                                   CFT014
109200200528                                                                                 CFT014
109300200528     C                   EndSr                                                   CFT014
109400200528      *****************************************************************
109500200528      /EJECT
109600200528      *****************************************************************
109700200528      ** DFTVATFLG - Default  VAT Flags & calculate VAT totals
109800200528      **             (uses the validation module FTVVTIN to default)
109900200528      *****************************************************************
110000200528     C     DFTVATFLG     BEGSR
110100200528
110200200528      * Reset variables updated by each module
110300200528     C                   Exsr      RESETERRS
110400200528
110500200528      * Validate
110600200528     C                   CALLB     'FTVVTIN'
110700200528      * INPUTS
110800200528      *  Return Code
110900200528     C                   Parm                    RetCodeOut
111000200528
111100200528      *  Screen fields
111200200528     C***********        Parm                    TranInThir                     CFT014
111300200528     C                   Parm                    TranInFour                     CFT014
111400200528
111500200528      * OUTPUTS
111600200528      *  Error fields/message IDs/message data (arrays) from/to caller
111700200528     C                   Parm                    FldNamXAr
111800200528     C                   Parm                    MsgIDXAr
111900200528     C                   Parm                    MsgDtaXAr
112000200528
112100200528      *  OK Flags (screen 3)
112200200528     C***********        Parm                    FTEOPY3                        CFT014
112300200528     C                   Parm                    FTEOPY4                        CFT014
112400200528
112500200528      *  Validation Work Fields
112600200528     C                   Parm                    Val@Fields
112700200528
112800200528     C                   ENDSR
112900200528      *****************************************************************
113000200528      /EJECT
113100200528      *****************************************************************
113200200528      * FMTAMT - FORMAT AMOUNT FOR DISPLAY                            *
113300200528      *****************************************************************
113400200528     C     FMTAMT        BEGSR
113500200528      *
113600200528     C                   CALLB     'ZA0920'
113700200528     C                   PARM      *BLANK        @@RETC           10
113800200528     C                   PARM                    @@AMTW           13 0
113900200528     C                   PARM                    @@QECN            1 0
114000200528     C                   PARM      '.'           BNDCSP            1
114100200528     C                   PARM      *BLANK        @@AMTD           14
114200200528      *
114300200528     C                   ENDSR
114400200528      *****************************************************************
114500200528      /EJECT
114600200528      *****************************************************************
114700200528      * *INZSR - Program Initialisation routine                       *
114800200528      *****************************************************************
114900200528
115000200528     C     *INZSR        BEGSR
115100200528
115200200528     C     *ENTRY        PLIST
115300200528      * Response mode (1A), from source system common header
115400200528     C                   PARM                    RespMode
115500200528
115600200528      * Transaction information (DS) in screen format from source system
115700200528     C                   PARM                    TranInPrim
115800200528     C                   PARM                    TranInSecA
115900200528     C                   PARM                    TranInSecB
116000200528     C                   PARM                    TranInThir
116100200528     C                   PARM                    TranInFour                     CFT014
116200200528
116300200528      * Transaction information (DS) in file format
116400200528     C                   PARM                    CrPtFilFmt
116500200528
116600200528      * Custom Extra Data file data
116700200528     C                   PARM                    ExtData
116800200528
116900200528      *  Funds transfer Details
117000200528     C                   Parm                    SDFTFR
117100200528      *                                                                                       187056
117200200528      ** Recalcution flag.                                                                    187056
117300200528     C                   PARM                    PReCalc           1                          187056
117400200528
117500200528      * OUTPUTS :
117600200528
117700200528      * Field OK flags (DS) from/to caller
117800200528     C                   PARM                    FTEOPY1
117900200528     C***********        PARM                    FTEOPY2                        CFT014
118000200528     C***********        PARM                    FTEOPY3                        CFT014
118100200528     C                   PARM                    FTEOPY4                        CFT014
118200200528
118300200528      * Error fields/message IDs/message data (arrays) from/to caller
118400200528     C                   PARM                    FldNameArr
118500200528     C                   PARM                    MsgIDArr
118600200528     C                   PARM                    MsgDtaArr
118700200528      * Array index (3P0) from/to caller
118800200528     C                   PARM                    Idx
118900200528
119000200528      * Warning fields/message IDs/message data (arrays) from/to caller
119100200528     C                   PARM                    WFldNamArr
119200200528     C                   PARM                    WMsgIDArr
119300200528     C                   PARM                    WMsgDtaArr
119400200528      * Array index (3P0) from/to caller
119500200528     C                   PARM                    WIdx
119600200528
119700200528      * Valid Deals layout (DS) from/to caller
119800200528     C                   PARM                    ValidPmnt
119900200528
120000200528      *  Validation Work Fields from/to caller
120100200528     C                   Parm                    Val@Fields
120200200528
120300200528      *  Extra rate required for FTVCHPY module                                 CFT009
120400200528     C                   Parm                    O2XRTE           13 8          CFT009
120500200528                                                                                CFT009
120600200528      *  Move program name into *LDA field.
120700200528     C     *LOCK         In        LDA
120800200528     C                   Movel     'FTOPAY3DT'   DBPGM
120900200528     C                   Out       LDA
121000200528
121100200528      ** ACCESS BANK DETAILS
121200200528      *
121300200528     C                   CALL      'AOBANKR0'
121400200528     C                   PARM      *BLANKS       @RTCD             7
121500200528     C                   PARM      '*FIRST '     @OPTN             7
121600200528     C     SDBANK        PARM      SDBANK        DSFDY
121700200528      *
121800200528      * DATABASE ERROR
121900200528      *
122000200528     C     @RTCD         IFNE      *BLANKS
122100200528     C                   MOVEL     'SDBANKPD'    DBFILE
122200200528     C                   MOVEL     '901'         DBASE
122300200528     C                   MOVEL     @OPTN         DBKEY
122400200528     C                   EXSR      *PSSR
122500200528     C                   END
122600200528      *
122700200528      ** Access Module Details
122800200528      *
122900200528     C                   CALL      'AOMMODR0'
123000200528     C                   PARM      *BLANKS       @RTCD
123100200528     C                   PARM      '*FIRST '     @OPTN
123200200528     C     SDMMOD        PARM      SDMMOD        DSFDY
123300200528      *
123400200528      * DATABASE ERROR
123500200528      *
123600200528     C     @RTCD         IFNE      *BLANKS
123700200528     C                   MOVEL     'SDMMODPD'    DBFILE
123800200528     C                   MOVEL     '904'         DBASE
123900200528     C                   MOVEL     @OPTN         DBKEY
124000200528     C                   EXSR      *PSSR
124100200528     C                   END
124200200528                                                                                              219241
124300200528      ** Get Message Management Details if CFT014 is installed                                219241
124400200528                                                                                              219241
124500200528     C                   IF        @CFT014 = 'Y'                                              219241
124600200528                                                                                              219241
124700200528     C                   CALL      'AOMGMER1'                                                 219241
124800200528     C                   PARM      *BLANKS       PRTCD                                        219241
124900200528     C                   PARM      '*FIRST'      POPTN                                        219241
125000200528     C     SDMGME        PARM      SDMGME        DSSDY                                        219241
125100200528                                                                                              219241
125200200528     C                   IF        PRTCD <> *BLANKS                                           219241
125300200528     C                   EVAL      DBFILE = 'SDMGMEPD'                                        219241
125400200528     C                   EVAL      DBASE = 905                                                219241
125500200528     C                   EVAL      DBKEY = POPTN                                              219241
125600200528     C                   EXSR      *PSSR                                                      219241
125700200528     C                   ENDIF                                                                219241
125800200528                                                                                              219241
125900200528     C                   ENDIF                                                                219241
126000200528      *
126100200528      ***Set*up*the*name*of the MSGF from which the message handler will        CFT007
126200200528      ****get*the*messages                                                      CFT007
126300200528     C*******************EVAL      #MsgFile = 'DRSMM'                           CFT007
126400200528      ** Set up the name of the primary and secondary message files from        CFT007
126500200528      ** which the message handler will get the messages                        CFT007
126600200528     C                   EVAL      #MsgFile     = 'FTUSRMSG'                    CFT007
126700200528     C                   EVAL      MsgFArray(1) = 'DRSMM'                       CFT007
126800200528
126900200528     C                   ENDSR
127000200528      *****************************************************************
127100200528      /EJECT
127200200528      *****************************************************************
127300200528      * *INIT - Initial Processing                                    *
127400200528      *****************************************************************
127500200528
127600200528     C     INIT          BEGSR
127700200528
127800200528      * Access FT Control data
127900200528     C                   CALL      'FT0005'                             9090
128000200528     C                   Parm      *BLANKS       @RTCD
128100200528     C     TCNTRL        Parm      TCNTRL        DSFDY
128200200528      *
128300200528     C                   If        *IN90 = *ON or
128400200528     C                             @RTCD = '*ERROR*'
128500200528     C                   Move      'FTOPAY3DT'   DBPGM
128600200528     C                   Move      'FT0005'      DBFILE
128700200528     C                   Eval      DBASE = 20
128800200528     C                   Movel     '*CALL'       DBKEY
128900200528     C                   Exsr      *PSSR
129000200528     C                   End
129100200528
129200200528     C                   If        WGLUI = 'I'
129300200528     C                   Eval      @FTOV = 'Y'
129400200528     C                   Else
129500200528     C                   Eval      @FTOV = *Blanks
129600200528     C                   End
129700200528     C                   Eval      @PDTI =WPDTI
129800200528     C                   Eval      @VATF =WVATF
129900200528
130000200528      ** Access SAR details file to determine if CEU006 is on.
130100200528     C                   CALLB     'AOSARDR0'
130200200528     C                   Parm      *Blanks       @RTCD
130300200528     C                   Parm      '*VERIFY'     @OPTN
130400200528     C                   Parm      'CEU006'      @SARD
130500200528     C     SCSARD        Parm      SCSARD        DSFDY
130600200528
130700200528     C                   If        @RTCD <> *Blanks and
130800200528     C                             @RTCD <> '*NRF   '
130900200528     C                   Move      'FTOPAY3DT'   DBPGM
131000200528     C                   Move      'AOSARDR0'    DBFILE
131100200528     C                   Eval      DBASE = 2
131200200528     C                   Movel     '*CALL'       DBKEY
131300200528     C                   Exsr      *PSSR
131400200528     C                   End
131500200528
131600200528     C                   If        @RTCD = *Blanks
131700200528     C                   Eval      @CEU006 = 'Y'
131800200528     C                   Else
131900200528     C                   Eval      @CEU006 = 'N'
132000200528     C                   End
132100200528      *                                                                                       CFT120
132200200528      ** Access SAR details file to determine if CEU006 is on.                                CFT120
132300200528      *                                                                                       CFT120
132400200528     C                   CALLB     'AOSARDR0'                                                 CFT120
132500200528     C                   Parm      *Blanks       @RTCD                                        CFT120
132600200528     C                   Parm      '*VERIFY'     @OPTN                                        CFT120
132700200528     C                   Parm      'CFT120'      @SARD                                        CFT120
132800200528     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT120
132900200528                                                                                              CFT120
133000200528     C                   If        @RTCD <> *Blanks and                                       CFT120
133100200528     C                             @RTCD <> '*NRF   '                                         CFT120
133200200528     C                   Move      'FTOPAY3DT'   DBPGM                                        CFT120
133300200528     C                   Move      'SCSARDPD'    DBFILE                                       CFT120
133400200528     C                   Eval      DBASE = 3                                                  CFT120
133500200528     C                   Movel     'CFT120'      DBKEY                                        CFT120
133600200528     C                   Exsr      *PSSR                                                      CFT120
133700200528     C                   End                                                                  CFT120
133800200528                                                                                              CFT120
133900200528     C                   If        @RTCD = *Blanks                                            CFT120
134000200528     C                   Eval      CFT120 = 'Y'                                               CFT120
134100200528     C                   Else                                                                 CFT120
134200200528     C                   Eval      CFT120 = 'N'                                               CFT120
134300200528     C                   End                                                                  CFT120
134400200528      *
134500200528      * Read V.A.T. details if S01499 switched ON
134600200528     C                   If        @01499 = 'Y'
134700200528     C                   CALL      'AOVATR0'                            9090
134800200528     C                   Parm      '*MSG   '     @RTCD
134900200528     C                   Parm      '*FIRST '     @OPTN
135000200528     C                   Parm                    VATDS
135100200528
135200200528     C                   If        *IN90 = *ON or
135300200528     C                             @RTCD = '*ERROR*'
135400200528     C                   Move      'FTOPAY3DT'   DBPGM
135500200528     C                   Move      'AOVATR0'     DBFILE
135600200528     C                   Eval      DBASE = 2
135700200528     C                   Movel     '*CALL'       DBKEY
135800200528     C                   Exsr      *PSSR
135900200528
136000200528     C                   Else
136100200528     C                   Eval      @VATR = WVATR
136200200528     C                   Eval      @VATP = 'Y'
136300200528     C                   End
136400200528     C                   End
136500200528     C/COPY WNCPYSRC,FTOPA3TC02
136600200528
136700200528     C                   ENDSR
136800200528      *****************************************************************
136900200528      /EJECT
137000200528      *****************************************************************
137100200528      * RESETERRS - Reset error information that is received back     *
137200200528      *    from each validation module.                               *
137300200528      *****************************************************************
137400200528
137500200528     C     RESETERRS     BEGSR
137600200528
137700200528     C                   Eval      RetCodeOut = *Blanks
137800200528      *
137900200528      * Reset error & warning fields/message IDs/message data (arrays)
138000200528     C                   Eval      FldNamXAr = *BlankS
138100200528     C                   Eval      MsgIDXAr  = *BlankS
138200200528     C                   Eval      MsgDtaXAr = *BlankS
138300200528     C                   Eval      WFldNmXAr = *BlankS
138400200528     C                   Eval      WMsgIDXAr = *BlankS
138500200528     C                   Eval      WMsgDtXAr = *BlankS
138600200528
138700200528     C                   ENDSR
138800200528      *****************************************************************
138900200528      /EJECT
139000200528      *****************************************************************
139100200528      * #TERM - Termination processing.
139200200528      *****************************************************************
139300200528     C     #TERM         BEGSR
139400200528      *
139500200528      **  Terminate program
139600200528      *
139700200528     C                   MOVE      '1'           *INLR
139800200528      *
139900200528     C     *INU7         IFEQ      '1'
140000200528     C                   DUMP
140100200528     C                   END
140200200528      *
140300200528     C                   RETURN
140400200528      *
140500200528     C                   ENDSR
140600200528      *****************************************************************
140700200528      /EJECT
140800200528      ********************************************************************
140900200528      ** =================================================================
141000200528      ** Program, module and procedure names for database error processing.
141100200528      ** =================================================================
141200200528      ** The following /COPY sets these values, and also defines LDA as
141300200528      ** an external data area
141400200528     C/COPY ZACPYSRC,PSSR_ILE
141500200528      ********************************************************************
141600200528      /EJECT
141700200528**  CPY@
141800200528(c) Finastra International Limited 2001
141900200528** Scaling factors array - @SF
1420002005280000000001
1421002005280000000010
1422002005280000000100
1423002005280000001000
1424002005280000010000
1425002005280000100000
1426002005280001000000
1427002005280010000000
1428002005280100000000
1429002005281000000000
