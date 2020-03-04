     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments screen input')              *
      *****************************************************************
      *                                                               *
      *  Midas - API Funds Transfer Module                            *
      *                                                               *
      *  FTOPAY1SN - Outgoing Payments screen input                   *
      *                                                               *
      *  Function:  This is the main screen input function            *
      *             for Funds Transfer Outgoing Payments              *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. JMI113             Date 19Feb20               *
      *  Prev Amend No. JMI106             Date 16May19               *
      *                 MD052529           Date 12Feb19               *
      *                 MD050619           Date 24Apr18               *
      *                 MD050574           Date 20Apr18               *
      *                 MD046248           Date 27Oct17               *
      *                 AR1090283          Date 10Aug16               *
      *                 MD036155           Date 23Oct15               *
      *                 CGL165             Date 17Feb15               *
      *                 MD029067           Date 27Oct14               *
      *                 MD024335           Date 19Aug14               *
      *                 MD023832           Date 28Apr14               *
      *                 CFT151             Date 21Mar14               *
      *                 MD021574           Date 14Aug13               *
      *                 CFT050             Date 03Jun13               *
      *                 MD022446           Date 20Sep13               *
      *                 262724             Date 24Apr13               *
      *                 261152             Date 24Apr13               *
      *                 260045             Date 10Apr13               *
      *                 CFT135             Date 20Feb13               *
      *                 AR402776           Date 20Dec12               *
      *                 260045A            Date 20Dec12               *
      *                 258944             Date 23Jan13               *
      *                 CFT148             Date 23Jan13               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 260419             Date 13Sep12               *
      *                 CSC054             Date 23Feb12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE075             Date 06Dec10               *
      *                 CRE067             Date 05Oct10               *
      *                 262930             Date 01Dec09               *
      *                 262853             Date 15Dec09               *
      *                 BUG26775           Date 27Nov09               *
      *                 262747             Date 18Nov09               *
      *                 CER059             Date 19Jul10               *
      *                 BUG24143           Date 02Jun09               *
      *                 BUG23047           Date 13Apr09               *
      *                 CER030             Date 09Jul08               *
      *                 CER048             Date 19May08               *
      *                 CER043             Date 19May08               *
      *                 CER047             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 BUG26548           Date 23Oct09               *
      *                 260454             Date 25May09               *
      *                 260254             Date 12May09               *
      *                 226920             Date 28Apr04               *
      *                 BUG25902           Date 08Sep09               *
      *                 BUG24998           Date 17Jul09               *
      *                 CSW209             Date 01Apr09               *
      *                 BUG24227           Date 01Apr09               *
      *                 257361             Date 10Nov08               *
      *                 256919             Date 16Oct08               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257664             Date 17Nov08               *
      *                 256564             Date 17Sep08               *
      *                 256862             Date 26Sep08               *
      *                 256192             Date 22Aug08               *
      *                 255711             Date 31Jul08               *
      *                 255763             Date 29Jul08               *
      *                 255350             Date 22Jul08               *
      *                 250600             Date 07Oct07               *
      *                 BUG14716A          Date 04Sep07               *
      *                 233905             Date 27Feb07               *
      *                 242100             Date 09Nov06               *
      *                 CRE026             Date 24May06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 242102             Date 03Oct06               *
      *                 GBO009             Date 15Apr04               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD031             Date 10Apr06               *
      *                 CDL049             Date 06Jul06               *
      *                 240813             Date 06Jul06               *
      *                 240662             Date 27Jun06               *
      *                 222349             Date 06Jun06               *
      *                 225169             Date 06Jun06               *
      *                 227538             Date 06Jun06               *
      *                 226915             Date 06Jun06               *
      *                 219732             Date 06Jun06               *
      *                 220110             Date 06Jun06               *
      *                 222472             Date 06Jun06               *
      *                 222731             Date 06Jun06               *
      *                 219150             Date 27Apr06               *
      *                 219718             Date 26Apr06               *
      *                 210657             Date 26Apr06               *
      *                 208791             Date 26Apr06               *
      *                 237375             Date 28Feb06               *
      *                 237413             Date 08Feb06               *
      *                 CSD027             Date 09Dec05               *
      *                 184008             Date 13Jul05               *
      *                 CER001             Date 25Apr05               *
      *                 CSC024             Date 07Feb05               *
      *                 BUG7029            Date 09Jun05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4776R (Reopen)  Date 22Dec04               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT118             Date 02Sep04               *
      *                 CFT116             Date 12Jul04               *
      *                 CGL014             Date 20Oct03               *
      *                 CLE025             Date 20Oct03               *
      *                 CSC022             Date 24Feb04               *
      *                 CGL029             Date 01Sep03               *
      *                 222373             Date 30Oct03               *
      *                 CGP001             Date 16Oct03               *
      *                 CAP084             Date 01Aug03               *
      *                 CSW203             Date 26May03               *
      *                 CSD015             Date 14Oct02               *
      *                 CFT018             Date 29Nov02               *
      *                 214320             Date 26Jun03               *
      *                 217337             Date 19May03               *
      *                 212575             Date 29Jan03               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 209867             Date 10Jan03               *
      *                 210733             Date 28Nov02               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209067             Date 09Sep02               *
      *                 206893             Date 08JUL02               *
      *                 201852             Date 02May02               *
      *                 204029             Date 26Apr02               *
      *                 204152             Date 10Apr02               *
      *                 204100             Date 26Mar02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CSC011             Date 18Sep01               *
      *                 195220             Date 21Jan02               *
      *                 193883             Date 20Nov01               *
      *                 196813             Date 20Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 195063             Date 17Jul01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 01Mar01               *
      *                 190845             Date 21Mar01               *
      *                 CPB002             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 187056             Date 01Dec00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 CFT012             Date 08Jun00               *
      *                 175477             Date 22May00               *
      *                 175475             Date 22May00               *
      *                 175479             Date 22May00               *
      *                 175474             Date 22May00               *
      *                 175469             Date 22May00               *
      *                 170801             Date 22May00               *
      *                 CGL009             Date 22May00               *
      *                 CFT007             Date 03Dec99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 22Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 11May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  JMI113 - Midas-GCMS Interface. Upgrade to FBM 2.1            *
      *           (It includes SC254598)                              *
      *           Amendment of hook JMI106_009                        *
      *           Amendment of hook JMI106_012                        *
      *           Amendment of hook FTOPA1SC11                        *
      *           Amendment of hook FTOPA1SC12                        *
      *           Addition of hooks JMI113_023 to JMI113_033          *
      *  JMI106 - Split FT Sequence Number based on Settlement Type   *
      *           Use of core hook FTH00064                           *
      *           Addition of hook JMI106_009                         *
      *           Addition of hook JMI106_010                         *
      *           Addition of hook JMI106_011                         *
      *           Addition of hook JMI106_012                         *
      *           (Upgrade to FB Midas)                               *
      *  MD052529 - If incoming pay MT202 message has no 50 field,    *
      *             Ordering Customer lines 2-5 should not be         *
      *             populated with values of field 52A details 1-4.   *
      *           - Initialization of work field ORCFLD should be     *
      *             performed before the OPAY screen mapping.         *
      *  MD050619 - No payment reference generated when routing via   *
      *             Through Payment                                   *
      *  MD050574 - Invalid Input User name for generated Outgoing    *
      *             Payment transaction from Incoming message         *
      *  MD046248 - Finastra Rebranding                               *
      *  AR1090283 - Customer details not visible for enquire.        *
      *              (Child: AR1090284)                               *
      *            - Applied for MD-39986.                            *
      *  MD036155 - FT OUTWARD PAYMENTS - Only Even reference         *
      *              numbers are being produced                       *
      *  CGL165 - Dual Withholding Tax (Recompile)                    *
      *  MD029067 - FT DBERRCTL after replication from F12 due to not *
      *             reading input correctly                           *
      *  MD024335 - FT IN/OP Charges Ind Defaulting                   *
      *  MD023832 - Ordering customer SORC4 incorrectly overwriten    *
      *             for replication by ORC5                           *
      *  CFT151 - FT IN/OP Alphanumeric sequence                      *
      *  MD021574 - Adjust F4/F16 position for Line 1 and Line 2 of   *
      *             Ordering Customer.                                *
      *  CFT050 - SWIFTRef Directories upload                         *
      *  MD022446 - Map 52A from incoming msg to ordering bank screen *
      *             field.                                            *
      *  262724 - PRFlag should be reset if F12 is pressed in the     *
      *           first screen.                                       *
      *  261152 - Payment reference should be blank during Insert.    *
      *           Enhanced fix 242102.                                *
      *  260045 - Remove capability to use any character for enquire. *
      *         - Applied fix for MD019877                            *
      *  CFT135 - MT100 MultiCash Interface                           *
      *           Added hooks:                                        *
      *           OFCPYSRCZ,CFT135_001                                *
      *           OFCPYSRCZ,CFT135_002                                *
      *           OFCPYSRCZ,CFT135_003                                *
      *           OFCPYSRCZ,CFT135_004                                *
      *           OFCPYSRCZ,CFT135_005                                *
      *           OFCPYSRCZ,CFT135_006                                *
      *  AR402776 - Payment reference is not updated when settlement  *
      *             type changes.  Fix is to ensure that whenever     *
      *             settlement type is changed, the PREF is updated.  *
      *             (Child: AR402906)                                 *
      *  260045A- ERZ123 F15 screen enquiry allows all action codes   *
      *           (Recompiled)                                        *
      *  258944 - APISERVER API FTOPAY: correct positions; fix use of *
      *           APNARV in CFT148 which adds one to positions        *
      *           Amended hook: CFT148_010                            *
      *  CFT148 - FT Remove Validation on Field 50F                   *
      *           Added hooks: CFT148_010, CFT148_011, CFT148_012     *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *           (Recompile)                                         *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *  260419 - All charges should be reset following replication   *
      *  CSC054 - Period End Adjustments                              *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00063                                 *
      *             WNCPYSRC,FTH00064                                 *
      *             WNCPYSRC,FTH00065                                 *
      *             WNCPYSRC,FTH00066                                 *
      *  CRE075 - Effective Date for Retail Accounts (Recompile)      *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *           (Recompile)                                         *
      *  262930 - Reverse 256919 as it is causing error.              *
      *  262853 - Only clear Charges to the Debit of field when F12   *
      *           was pressed on the Primary screen.                  *
      *  BUG26775 - Validation error in Outgoing Validation Flag      *
      *  262747 - Error when enquiring payment thru Account Movement  *
      *           Enquiry menu                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG24143 - Extended Narrative fields are unavailable         *
      *  BUG23047 - Extended Narrative not displayed for OPAY         *
      *             generated from IPAY                               *
      *  CER030 - Multicash German Feature                            *
      *  CER048 - German Features - Taxes (Recompile)               *
      *  CER043 - German Features LF041-00 New Fields and Defaulting  *
      *           (Recompile)                                         *
      *  CER047 - German Features LF037-00 Reporting §24c             *
      *           (Recompile)                                         *
      *  BUG26548 - Passed parm does not match entry parm for FTVXVXV *
      *  260454 - Default Branch of User not set up (related BUG7029) *
      *  260254 - Fifth Line Ordering Customer is blank from SWIFT    *
      *  226920 - Payment details should be redefaulted only when     *
      *           the Add/Deduct charges indicator, currencies or     *
      *           Transfer Commission has changed.                    *
      *  BUG25902 - Cannot amend transaction. Changes are overridden  *
      *             with original data.                               *
      *  BUG24998 - Bank operation code is missing (Recompile)        *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  BUG24227 - Message unique reference not initialised to zero  *
      *  257361 - Pass SDFTFR to FTOPAV1VL in case Warning message    *
      *           ('Network TELEX must be defined in Standing data')  *
      *           which appears for Settlement type '02' (cheques)    *
      *  256919 - Field :52: is incorrectly processed on an MT202.    *
      *  257664 - For routed MT103 message, pick-up Related Payment   *
      *           from Field Tag :20: instead of Field Tag :21:.      *
      *           Patterned fix with 255350                           *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  256862 - Set the Settlement and Payment dates to rundate.    *
      *  256192 - Default Outgoing Payment Details.                   *
      *  255711 - Field Ref rate does not record rate. (Recompiled)   *
      *  255763 - Enquiry on OPAY up to 2nd page then F12 with new    *
      *           pay reference resulted to showing details of prev   *
      *           payment.  Corrected part of fix 242102, insert only.*
      *  255350 - For routed MT202 message, pick-up Related Payment   *
      *           from Field Tag :20: instead of Field Tag :21:.      *
      *           Applied 247833 and 220800                           *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  BUG14716A - CFT032 pre-req missing CFT018 OPSI Outgoing      *
      *              Payments Template (Recompile)                    *
      *  233905 - Add window for IBLC on enquiry of charges and       *
      *           commissions screen.                                 *
      *  242100 - Always map field 57A to account with bank.          *
      *           A combination of fix 230699 and DJB005              *
      *  CRE026 - Consumer Banking (Recompile)                        *
      *  242102 - Error with checking of Payment reference when       *
      *           going back to the 1st OP input screen.              *
      *  GBO009 - Funds Transfer Outgoing Payment Reference           *
      *         - Added core hooks: FTOPA1SC62, FTOPA1SC63,           *
      *           FTOPA1SC35.                                         *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  240813 - Where the destination (DSTT) = 'R', determine first *
      *           the corresponding customer number before the swift  *
      *           id is determined.  This will prevent the database   *
      *           error at 082 from occuring.                         *
      *  240662 - Apply fix 212561.                                   *
      *  212561 - When FTOPAY1SN is called from FTMG screen, increment*
      *           OTPAYDA by 1, as it gets reset to prev value when   *
      *           SR/CANC@P is called after update (if linked enquiry)*
      *  222349 - Blank payment reference generated when user returns *
      *           to first screen and blanks out PREF field.          *
      *  225169 - When routed payment contains SWIFT currency code,   *
      *           translate it to Midas currency code.                *
      *  227538 - MT202 data lost during insert of Payment.           *
      *           Applied fixes 219470, 221142 and part of 221089.    *
      *  226915 - When inserting a payment using the details          *
      *           created when first enquiring and then taking F12,   *
      *           the status 'Matured' is not cleared and the SWIFT   *
      *           message reference of the previous payment is not    *
      *           cleared causing DB error in ME1070.                 *
      *  219732 - Value of next payment reference in OTPAYDA is       *
      *           being reset incorrectly when a payment is being     *
      *           generated as a through payment from a swift         *
      *           message. The result is the same payment reference   *
      *           being used for two payments giving a database       *
      *           error.                                              *
      *  220110 - Logic when trying to access SWIFT details of        *
      *           destination incorrectly assumes the first 6 digits  *
      *           of the Account Number are the customer number       *
      *           resulting in database error at 82.                  *
      *  222472 - Charges should be redefaulted only if fields        *
      *           influencing their calculation are amended, not      *
      *           simply if any field is amended.                     *
      *  222731 - Receiver's charges remitted field is taken from     *
      *           the previous transaction. Fix is to corectly        *
      *           initialize necessary work fields for receiver's     *
      *           charges remitted.                                   *
      *  219150 - Do defaulting only during insertion.  Also, apply   *
      *           fix 217337.                                         *
      *  219718 - Amendment on first screen is overidden with original*
      *           data from file.  Fix is re-instate condition to     *
      *           convert during amend if SPREF <> @PSPREF.           *
      *  210657 - Need to clear @RCRM and @RCUS.                      *
      *  208791 - For Through Payments, remove conditions to map      *
      *           Details of Payment and Bank to Bank Information if  *
      *           network is FONTIS.                                  *
      *  237375 - Reinstate some coding made by BUG4776 fix. Since it *
      *           is applicable so blank payment reference will not   *
      *           be generated when user returns to first screen and  *
      *           blanks out PREF field. Due to this, it will also    *
      *           correct skipping of transaction reference.          *
      *           This fix is already catered by fix 222349.          *
      *  237413 - Increase length of DS LFLT due to changes in CGL029.*
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  184008 - Recompiled due to changes in FTVPYAM and FTVSECY.   *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CSC024 - Open Month End                                      *
      *  BUG7029 - Ensure ZMUSER is re-checked on every call,         *
      *            move out of *INZSR.                                *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4776R-Reverse fix since fix only applies to Incoming.     *
      *           (Reopen)                                            *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT118 - Core changes for GBO018.                            *
      *           Demand Drafts Printing - Upgrade to MidasPlus       *
      *           Core hooks amended:FTOPAYS010                       *
      *                              FTOPA1SC13                       *
      *  CFT116   Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *         - Upgrade to Midasplus                                *
      *           Core hooks amended:FTOPA1SC15,FTOPA1SC13,FTOPAYS010 *
      *           Core hooks added:FTOPA1SC60                         *
      *  CGL014 - Collaterals Processing                              *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CSC022 - Commitment Control Changes for MidasPlus            *
      *  CGL029 - Increase Account Code to 10 digits                  *
      *  222373 - Correct parameters on program calls                 *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  CAP084 - MidasPlus Changes                                   *
      *  CSW203 - SWIFT 2003 Standards Update                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  CFT018 - Standard Settlement Instructions for                *
      *           Outgoing Payments                                   *
      *  214320 - Outgoing payment is allowed to be authorised and    *
      *           deleted. Partially applied fix 213045.              *
      *  217337 - Chaps code is taken from the previous transaction.  *
      *           Fix is to initialize the variable @CHAP to prevent  *
      *           this error from happening.                          *
      *  212575 - Map details of payment from incoming message        *
      *           regardless of FONTIS to be consistent with non-API  *
      *           version.                                            *
      *  209867 - No rollback when F3 pressed. Msg ENDCMTCTL not      *
      *           allowed at signoff due to updates in window pgm.    *
      *  210733 - Transaction reference not displayed if SWIFT        *
      *           payments are routed to incoming payments or         *
      *           outgoing payments.                                  *
      *           Pass inserted reference and an 'I return code to    *
      *           display the transaction reference via ME1060        *
      *           program.  Apply fix 197712.                         *
      *  209067 - Amend 204152 to ensure payment number is decremented*
      *           only if a new payment was generated.                *
      *  206893 - when warning received on settle or pay value date,  *
      *           and the new date entered is also a holiday, no      *
      *           warning received anymore                            *
      *  201852 - Pass a parameter to MOD/FTOPAYRTV to know that the  *
      *           requested enquiry of a transaction is from the      *
      *           Account Movements Enquiry (GL4442).                 *
      *  204029 - Data decimal error on fields MISC01,2,3,4,5         *
      *           and SWSCHG when CFT009 is not on (RECOMPILE).       *
      *  204152 - Move SR to set up PREF to before window call        *
      *  204100 - Confirmation scrn should not appear for action = E  *
      *  CSC011 - 24x7 Midas Availability                             *
      *  195220 - Restore unexpanded data on F12.                     *
      *  193883 - Recompile over changed FTOPAYUPD.                   *
      *  196813 - OTOPMSGR and OTOPKPRT lost so no update  done.      *
      *  195063 - Book Code defaults to 'FT' when transaction is      *
      *           coming from an Electronic Message.                  *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  190845 - Add extra fields for Message Unique Reference and   *
      *           Part Number                                         *
      *  CPB002 - Meridian DBA Middleware Replication Customization.  *
      *  187056 - IP and OP do not recalculate screen charges if      *
      *           'Charges to the Debit of a/c' has been changed      *
      *           from blank to non-blank.                            *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  CFT012 - Cross currency transferts                           *
      *  175477 - FONTIS : Map beneficiary bank detail                *
      *  175475 - FONTIS : Settlement ccy defaulted by /ORIG/         *
      *  175479 - FONTIS : dealer's reference field                   *
      *  175474 - FONTIS : Invalid A/C in :53a:                       *
      *  175469 - FONTIS : Euro nostro equivalent                     *
      *  170801 - Midas-Fontis IAT/TPP interface fix.                 *
      *           When redirecting in ccy payments to Euro. default   *
      *           pay delivery currency/amount to the original        *
      *           payment currency.  Also, specify PBRCA to be        *
      *           the ordering customer account branch code.          *
      *  CGL009 - FONTIS IAT/TPP interface                            *
      *  CFT007 - BIC Database Plus Integration                       *
      *  CFT004 - IBAN, International Bank Account Number             *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *                                                               *
      *****************************************************************
      *                                                               *
      *              CFT007 BIC Database Plus Integration             *
      *         //////////////////////////////////////////////////    *
      *        // NOTE: If the destination, ordering customer, //     *
      *       // receiver's correspondent, ordering bank,     //      *
      *      // beneficiary or intermediary bank fields      //       *
      *     // change position, the cursor position test in //        *
      *    // SR BICPrompt will need to be change.         //         *
      *   //////////////////////////////////////////////////          *
      *                                                               *
      *****************************************************************

     FACCNT     IF   E           K DISK
     F                                     IGNORE(ACCNTAAF)
     F                                     IGNORE(ACCNTACF)
     FACCNTL1   IF   E           K DISK    PREFIX(AC)                                         240813
     F                                     RENAME(ACCNTABF:ACCNTBF2)                          240813
     F/COPY WNCPYSRC,FTOPA1SF01
      *                                                                         CGL009
      ** Midas FONTIS TPP nostro defaults                                       CGL009
     FMEFNODL1  IF   E           K DISK    USROPN                               CGL009
      *                                                                         CGL009
      ** Midas Nostro details                                                   CGL009
     FSDNOSTL3  IF   E           K DISK                                         CGL009
     F*FTPREFL1**IF***E****       K DISK                                            BUG4776 BUG4776R
     FSDCURRLD  IF   E           K DISK                                                       225169
      *****************************************************************
      ** +--------------------------------------+
      ** ¦ Automatically included D-specs       ¦
      ** ¦ ==============================       ¦
      ** +--------------------------------------+
      **
      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes (among others) the LDA layout
      ** and the copyright array definition:
     D/COPY ZACPYSRC,STD_D_SPEC
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY includes the MM standard declares:
     D/COPY ZACPYSRC,STDDECLARE
      **--------------------------------------------------------------------------------------------

      **--------------------------------------------------------------------------------------------
      ** The following /COPY line includes all the defined fields in the
      ** Program Status Data Structures.  They have meaningful
      ** names, prefixed by 'PS'.
     D/COPY ZACPYSRC,PSDS
      **--------------------------------------------------------------------------------------------

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
      *                                                                         CGL009
     D @CHK            C                   CONST('0123456789.')                 CGL009
     D @NUL            C                   CONST('123456789')                   CGL009
                                                                                              CSC024
      ** String for System Values Array                                                       CSC024
     D*SysValOME       C                   CONST('OMEIndicator')                       CSC024 CSC054
     D SysValPEA       C                   CONST('PEAIndicator')                              CSC054

      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
      ** Commitment Control Job Array                                                         CSC022
     D WJobs           S             10A   Dim(10)                                            CSC022
      **                                                                                      CSC022

     D CrPtFilFmt    E DS                  EXTNAME(OTPAYDD)
      * Current Payment in File Format
                                                                                CFT014
     D CrPtFilFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
      ** Current Payment in File Format (Extension)                             CFT014


     D CurPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * (Current) Payment in Screen Format (primary screen)
     D                                     PREFIX(@)
     D CurPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * (Current) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@)
     D CurPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * (Current) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@)
     D CurPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * (Current) Payment in Screen Format (Charges/Commissions screen)
     D                                     PREFIX(@)
                                                                                CFT014
     D CurPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** (Current) Payment in Screen Format (Primary Screen definition 2)       CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** (Current) Payment in Screen Format (Lvl 2 Scrn 3 definition 2)         CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** (Current) Payment in Screen Format (Lvl 2 Scrn 4 Chrgs and Comms. scrn)CFT014
     D                                     PREFIX(@)                            CFT014
                                                                                CFT014
     D CurPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** (Current) Payment in Screen Format (Margin Information Screen)         CFT014
     D                                     PREFIX(@)                            CFT014
     D CurPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
      ** (Current) Payment in Screen 1 Format (Cover Message)                                 CSW209
     D CurPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@)                                          CSW209
      ** (Current) Payment in Screen 2 Format (Cover Message)                                 CSW209


     D NwPtFilFmt    E DS                  EXTNAME(FTVOPAYPD)
      * New Payment in File Format
                                                                                CFT014
     D NwPtFilFmx    E DS                  EXTNAME(FTVOPY2PD)                   CFT014
      ** New Payment in File Format (Extension)                                 CFT014
     D/COPY WNCPYSRC,FTH00206


     D NewPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * New Payment in Screen Format (Primary screen)
     D NewPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * New Payment in Screen Format (Secondary screen)
     D NewPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * New Payment in Screen Format (Charges/Commissions screen)
                                                                                CFT014
     D NewPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** New Payment in Screen Format (Primary Screen definition 2)             CFT014
                                                                                CFT014
     D NewPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** New Payment in Screen Format (Lvl 2 Screen 3 definition 2)             CFT014
                                                                                CFT014
     D NewPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** New Payment in Screen Format (Lvl 2 Screen 4 Chrgs and Comms screen)   CFT014
                                                                                CFT014
     D NewPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** New Payment in Screen Format (Margin Information Screen)               CFT014

     D NewPmtScn7    E DS                  EXTNAME(FTOPY8PD) PREFIX(X)          CFT018
      ** New Payment in Screen Format (SSI Insert Screen)                       CFT018
                                                                                CFT018
     D NewPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
      ** New Payment in Screen 1 Format (Cover Messages)                                      CSW209
     D NewPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
      ** New Payment in Screen 2 Format (Cover Messages)                                      CSW209

     D PrvPmtScn1    E DS                  EXTNAME(FTOPY1PD)
      * (Previous) Payment in Screen Format (primary screen)
     D                                     PREFIX(@P)
     D PrvPmtSc2a    E DS                  EXTNAME(FTOPY2PD)
      * (Previous) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@P)
     D PrvPmtSc2b    E DS                  EXTNAME(FTOPY3PD)
      * (Previous) Payment in Screen Format (Secondary screen)
     D                                     PREFIX(@P)
     D PrvPmtScn3    E DS                  EXTNAME(FTOPY4PD)
      * (Previous) Payment in Screen Format (Charges/Commissions screen)
     D                                     PREFIX(@P)
                                                                                CFT014
     D PrvPmtSc1b    E DS                  EXTNAME(FTOPY1APD)                   CFT014
      ** (Previous) Payment in Screen Format (Primary Screen definition 2)      CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtSc3b    E DS                  EXTNAME(FTOPY5PD)                    CFT014
      ** (Previous) Payment in Screen Format (Lvl2 Screen  3 definition 2)      CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtScn4    E DS                  EXTNAME(FTOPY6PD)                    CFT014
      ** (Previous) Payment in Screen Format (Lvl2 Screen  4 Chrgs & Comms scrn)CFT014
     D                                     PREFIX(@P)                           CFT014
                                                                                CFT014
     D PrvPmtScn5    E DS                  EXTNAME(FTOPY7PD)                    CFT014
      ** (Previous) Payment in Screen Format (Margin Information Screen)        CFT014
     D                                     PREFIX(@P)                           CFT014
     D PrvPmtScnA    E DS                  EXTNAME(FTOPYAPD)                                  CSW209
     D                                     PREFIX(@P)                                         CSW209
      ** (Previous) Payment in Screen 1 Format (Margin Information Screen)                    CSW209
     D PrvPmtScnC    E DS                  EXTNAME(FTOPYCPD)                                  CSW209
     D                                     PREFIX(@P)                                         CSW209
      ** (Previous) Payment in Screen 2 Format (Margin Information Screen)                    CSW209
      *                                                                                       CFT039
      ** FT OPAY API Ordering Bank Details                                                    CFT039
     D TranInfoFlds  E DS                  EXTNAME(FTOPIFPD)                                  CFT039
      *                                                                                       CFT039
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
     D @NotDelAmt    E                     EXTFLD(@SNDAM)
     D @PayDelAmt    E                     EXTFLD(@SPDAM)
     D @PayAmount    E                     EXTFLD(@SPYAM)
     D @SettleAmt    E                     EXTFLD(@SSMAM)
     D @CDRO1        E                     EXTFLD(@CDRQQ)                                     CGL029

     D SSIScrnFmt    E DS                  EXTNAME(FTOPSIPD) PREFIX(S)          CFT018
      * Current Outgoing Payment SSI in Screen Format                           CFT018
      *                                                                         CFT018
     D SSIFileFmt    E DS                  EXTNAME(FTOSSIPD) PREFIX(S)          CFT018
      * Current Outgoing Payment SSI in Screen Format                           CFT018
      *                                                                         CFT018

     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
      * Error indicators - Main screen

     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
      * Error indicators - Level 2 details

     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
      * Error indicators - Charges & Commissions screen
                                                                                CFT014
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
      ** Error indicators - Charges & Commissions screen                        CFT014
                                                                                CFT014
     D FTEOPY5       E DS                  EXTNAME(FTEOPY5PD)                   CFT014
      ** Error indicators - Margin Infor screen                                 CFT014
                                                                                CFT018
     D FTEOPY7       E DS                  EXTNAME(FTEOPY7PD) PREFIX(X)         CFT018
      * Error indicators - SSI Payment Insert Screen                            CFT018
                                                                                              CSW209
     D FTEOPYA       E DS                  EXTNAME(FTEOPYAPD)                                 CSW209
      ** Error indicators - Cover Message screen 1                                            CSW209
                                                                                              CSW209
     D FTEOPYC       E DS                  EXTNAME(FTEOPYCPD)                                 CSW209
      ** Error indicators - Cover Message screen 2                                            CSW209

     D*OTPAYD**      E DS                  EXTNAME(OTPAYDA)                                   CFT151
      ***** DATA AREA FOR ORDINARY PAYMENT REF NUMBERING                                      CFT151
      ** DS for next Outgoing Payment Reference Number                                        CFT151
     D OTPAYD          DS             4                                                       CFT151
     D  WOTSQ                  1      4  0                                                    CFT151
     D APRNUM          DS             4                                                       CFT151
     D  NPRNUM                 1      4  0                                                    CFT151

     D RGPAYD        E DS                  EXTNAME(RGPAYDA)
     D*     DATA AREA FOR REGULAR PAYMENT REF NUMBERING
     D*
                                                                                              CFT009
      ** Valid Outgoing Payments Extension File (default)                                     CFT009
     D DEFVALIDX     E DS                  EXTNAME(FTVOPY2PD)                                 CFT009
     D                                     PREFIX(D#)                                         CFT009
                                                                                              CFT009
      * Valid Payments layout (default)                                                       CFT009
     D DEFVALID      E DS                  EXTNAME(FTVOPAYPD)                                 CFT009
     D                                     PREFIX(D#)                                         CFT009
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
      ** EXTERNAL DS FOR BANK DETAILS

     D SDNOST        E DS                  EXTNAME(SDNOSTPD)
      * External DS for Nostro details

     D SDBRCH        E DS                  EXTNAME(SDBRCHPD)
      * External DS for Branch details

     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
      * External DS for Funds Transfer details
     D  WRATDIS               44     48  4

      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                CFT007
     D SDTRAD        E DS                  EXTNAME(SDTRADPD)                    CFT007
     D  QQACC1       E                     EXTFLD(QQACCD)                                     CGL029
      * External data structure for trading ICD data                            CFT007

     D SDFODA        E DS                  EXTNAME(SDFODAPD)
     D  QQACC2       E                     EXTFLD(QQACCD)                                     CGL029
      ** EXTERNAL DS FOR FUNDS TRANSFER ICD DETAILS

     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS

     D SCSARD        E DS                  EXTNAME(SCSARDPD)
     D SCA_LCD       E                     EXTFLD(LCD)
      ** EXTERNAL DS FOR SAR DETAILS
     D SDFONT        E DS                  EXTNAME(SDFONTPD)                    CGL009
      ** FONTIS ICD                                                             CGL009
     D ACCINF        E DS                  EXTNAME(ACCNTAB)                     CGL009
     D  IFRECI       E                     EXTFLD(RECI)                         CGL009
     D  IFCNUM       E                     EXTFLD(CNUM)                         CGL009
     D  IFCCY        E                     EXTFLD(CCY)                          CGL009
     D  IFACOD       E                     EXTFLD(ACOD)                         CGL009
     D  IFACSQ       E                     EXTFLD(ACSQ)                         CGL009
     D  IFZZ06       E                     EXTFLD(ZZ006)                        CGL009
     D  IFBRCA       E                     EXTFLD(BRCA)                         CGL009
     D  IFATYP       E                     EXTFLD(ATYP)                         CGL009
     D  IFSTYP       E                     EXTFLD(STYP)                         CGL009
     D  IFMFFQ       E                     EXTFLD(MFFQ)                         CGL009
     D  IFACST       E                     EXTFLD(ACST)                         CGL009
     D  IFDACO       E                     EXTFLD(DACO)                         CGL009
     D  IFDACC       E                     EXTFLD(DACC)                         CGL009
     D  IFANAM       E                     EXTFLD(ANAM)                         CGL009
     D  IFLDBL       E                     EXTFLD(LDBL)                         CGL009
     D  IFCLBL       E                     EXTFLD(CLBL)                         CGL009
     D  IFSTFQ       E                     EXTFLD(STFQ)                         CGL009
     D  IFSTDY       E                     EXTFLD(STDY)                         CGL009
     D  IFLSTD       E                     EXTFLD(LSTD)                         CGL009
     D  IFNSTD       E                     EXTFLD(NSTD)                         CGL009
     D  IFLSTP       E                     EXTFLD(LSTP)                         CGL009
     D  IFCFSB       E                     EXTFLD(CFSB)                         CGL009
     D  IFLMVD       E                     EXTFLD(LMVD)                         CGL009
     D  IFEPLB       E                     EXTFLD(EPLB)                         CGL009
     D  IFEPCB       E                     EXTFLD(EPCB)                         CGL009
     D  IFYTDB       E                     EXTFLD(YTDB)                         CGL009
     D  IFGLBT       E                     EXTFLD(GLBT)                         CGL009
     D  IFARF1       E                     EXTFLD(ADREF1)                       CGL009
     D  IFPRFC       E                     EXTFLD(PRFC)                         CGL009
     D  IFZZ04       E                     EXTFLD(ZZ004)                        CGL009
     D  IFORED       E                     EXTFLD(ORED)                         CGL009
     D  IFDLIM       E                     EXTFLD(DLIM)                         CGL009
     D  IFLRCR       E                     EXTFLD(LRCR)                         CGL009
     D  IFRTCB       E                     EXTFLD(RTCB)                         CGL009
     D  IFRTLB       E                     EXTFLD(RTLB)                         CGL009
     D  IFDITM       E                     EXTFLD(DITM)                         CGL009
     D  IFCITM       E                     EXTFLD(CITM)                         CGL009
     D  IFREF2       E                     EXTFLD(ADREF2)                       CGL009
     D  IFZZ02       E                     EXTFLD(ZZ002)                        CGL009
     D  IFCDIR       E                     EXTFLD(CDIR)                         CGL009
     D  IFCCIR       E                     EXTFLD(CCIR)                         CGL009
     D  IFACNO       E                     EXTFLD(ACNO)                         CGL009
     D  IFRETB       E                     EXTFLD(RETB)                         CGL009
     D  IFODSC       E                     EXTFLD(ODSC)                         CGL009
     D  IFODLN       E                     EXTFLD(ODLN)                         CGL009
     D  IFODED       E                     EXTFLD(ODED)                         CGL009
     D  IFDIOD       E                     EXTFLD(DIOD)                         CGL009
     D  IFFACT       E                     EXTFLD(FACT)                         CGL009
     D  IFFCNO       E                     EXTFLD(FCNO)                         CGL009
     D  IFEFAC       E                     EXTFLD(EFAC)                         CGL009
     D  IFHELD       E                     EXTFLD(HELD)                         CGL009
     D  IFMINB       E                     EXTFLD(MINB)                         CGL009
     D  IFLACD       E                     EXTFLD(LACD)                         CGL009
     D  IFLISP       E                     EXTFLD(LISP)                         CGL009
     D  IFRRNM       E                     EXTFLD(RRNM)                         CGL009
     D  IFDRIB       E                     EXTFLD(DRIB)                         CGL009
     D  IFDRIS       E                     EXTFLD(DRIS)                         CGL009
     D  IFDRCD       E                     EXTFLD(DRCD)                         CGL009
     D  IFDRIC       E                     EXTFLD(DRIC)                         CGL009
     D  IFDRIF       E                     EXTFLD(DRIF)                         CGL009
     D  IFDRDY       E                     EXTFLD(DRDY)                         CGL009
     D  IFNDID       E                     EXTFLD(NDID)                         CGL009
     D  IFLDID       E                     EXTFLD(LDID)                         CGL009
     D  IFLDIA       E                     EXTFLD(LDIA)                         CGL009
     D  IFSDAP       E                     EXTFLD(SDAP)                         CGL009
     D  IFLPAR       E                     EXTFLD(LPAR)                         CGL009
     D  IFDIIE       E                     EXTFLD(DIIE)                         CGL009
     D  IFDAIC       E                     EXTFLD(DAIC)                         CGL009
     D  IFMADI       E                     EXTFLD(MADI)                         CGL009
     D  IFGADI       E                     EXTFLD(GADI)                         CGL009
     D  IFDDIS       E                     EXTFLD(DDIS)                         CGL009
     D  IFDDIA       E                     EXTFLD(DDIA)                         CGL009
     D  IFOLDR       E                     EXTFLD(OLDR)                         CGL009
     D  IFOLDB       E                     EXTFLD(OLDB)                         CGL009
     D  IFOLDS       E                     EXTFLD(OLDS)                         CGL009
     D  IFCRIB       E                     EXTFLD(CRIB)                         CGL009
     D  IFCRIS       E                     EXTFLD(CRIS)                         CGL009
     D  IFCRCD       E                     EXTFLD(CRCD)                         CGL009
     D  IFCRIC       E                     EXTFLD(CRIC)                         CGL009
     D  IFCRIF       E                     EXTFLD(CRIF)                         CGL009
     D  IFCRDY       E                     EXTFLD(CRDY)                         CGL009
     D  IFNCID       E                     EXTFLD(NCID)                         CGL009
     D  IFLCID       E                     EXTFLD(LCID)                         CGL009
     D  IFLCIA       E                     EXTFLD(LCIA)                         CGL009
     D  IFSCAP       E                     EXTFLD(SCAP)                         CGL009
     D  IFLPAP       E                     EXTFLD(LPAP)                         CGL009
     D  IFCIIE       E                     EXTFLD(CIIE)                         CGL009
     D  IFCAIC       E                     EXTFLD(CAIC)                         CGL009
     D  IFMACI       E                     EXTFLD(MACI)                         CGL009
     D  IFGACI       E                     EXTFLD(GACI)                         CGL009
     D  IFCDIS       E                     EXTFLD(CDIS)                         CGL009
     D  IFDCIA       E                     EXTFLD(DCIA)                         CGL009
     D  IFOLCR       E                     EXTFLD(OLCR)                         CGL009
     D  IFOLCB       E                     EXTFLD(OLCB)                         CGL009
     D  IFOLCS       E                     EXTFLD(OLCS)                         CGL009
     D  IFLCD        E                     EXTFLD(LCD)                          CGL009
     D  IFCHTP       E                     EXTFLD(CHTP)                         CGL009
     D  IFTNLU       E                     EXTFLD(TNLU)                         CGL009
     D  IFBRTA       E                     EXTFLD(BRTCA)                        CGL009
     D  IFNACG       E                     EXTFLD(NACSG)                        CGL009
     D  IFR4AC       E                     EXTFLD(R4ACNT)                       CGL009
     D  IFENOC       E                     EXTFLD(ENOC)                         CGL009
     D  IFEPNO       E                     EXTFLD(EPNO)                         CGL009
     D  IFECFB       E                     EXTFLD(ECFB)                         CGL009
     D  IFLTAB       E                     EXTFLD(LTAB)                         CGL009
     D  IFLTAC       E                     EXTFLD(LTAC)                         CGL009
     D  IFLTAS       E                     EXTFLD(LTAS)                         CGL009
     D  IFHCFB       E                     EXTFLD(HCFB)                         CGL009
     D  IFPTFR       E                     EXTFLD(PTFR)                         CGL009
     D  IFHLEX       E                     EXTFLD(HLEX)                         CGL009
     D  IFA5TA       E                     EXTFLD(A5TIAC)                       CGL009
     D  IFA5TN       E                     EXTFLD(A5TIAN)                       CGL009
     D  IFA5TS       E                     EXTFLD(A5TIAS)                       CGL009
     D  IFEUSB       E                     EXTFLD(EUSB)                         CGL009
     D  IFIBAN       E                     EXTFLD(IBAN)                         CGL009
     D  IFIBSQ       E                     EXTFLD(IBSEQN)                       CGL009
     D  IFRNA        E                     EXTFLD(FRNT)                         CGL009
     D  IAFRT        E                     EXTFLD(AFRT)                         CGL009
     D  IREPA        E                     EXTFLD(REPA)                         CGL009
     D  IREPI        E                     EXTFLD(REPI)                         CGL009
     D  IFTMST       E                     EXTFLD(TMST)                         CGL009
      ** ACCOUNT DETAILS                                                        CGL009
                                                                                CGL009
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                    CGL009
     D  QQDFA1       E                     EXTFLD(QQDFAC)                                     CGL029
      ** CUSTOMER DETAILS                                                       CGL009
                                                                                CGL009
     D SDCNST        E DS                  EXTNAME(SDCNSTPD)                    CGL009
      ** COUNTER PARTY NOSTRO                                                   CGL009
                                                                                CGL009
     D SDPRFC        E DS                  EXTNAME(SDPRFCPD)                    CGL009
      ** PROFIT CENTRE                                                          CGL009
                                                                                CGL009
     D MEBICD        E DS                  EXTNAME(MEBICDPD)                    CGL009
      ** BIC DIRECTORY                                                          CGL009
                                                                                CGL009
     D SDGELR        E DS                  EXTNAME(SDGELRPD)                    CGL009
     D  QQACC3       E                     EXTFLD(QQACCD)                                     CGL029
      ** GENERAL LEDGER                                                         CGL009

     D DSFDY         E DS                  EXTNAME(DSFDY)
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE

     D DSSDY         E DS                  EXTNAME(DSSDY)
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE

     D ExtData       E DS                  EXTNAME(FTOPEXPD)
      * FT (OPAY) Extra Data - File (D/B) format
     D/COPY OFCPYSRCZ,CFT148_010                                                              CFT148
                                                                                              CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D  WPRDTE                 5      9  0                                                    CSC011
                                                                                              CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
      ** SD Status DataArea Layout                                                            CSC011
      ** SCCMTJOB DataArea Layout                                                             CSC022
     D SCCMTJOB      E DS                  EXTNAME(SCCMTJOB) DTAARA(SCCMTJOB)                 CSC022
     D  WDSJobs                4    103A                                                      CSC022
      **                                                                                      CSC022
      *                                                                                       CER030
      ** Current DS for Extended Narrative Debit                                              CER030
      *                                                                                       CER030
     D CurPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
      ** Current DS for Extended Narrative Credit                                             CER030
      *                                                                                       CER030
     D CurPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(O)                                          CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Debit                                                  CER030
      *                                                                                       CER030
     D NewPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
      *                                                                                       CER030
      ** New DS for Extended Narrative Credit                                                 CER030
      *                                                                                       CER030
     D NewPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
      *                                                                                       CER030
      ** Previous DS for Extended Narrative Debit                                             CER030
      *                                                                                       CER030
     D PrvPmtScn5A   E DS                  EXTNAME(FTOPY7APD)                                 CER030
     D                                     PREFIX(P)                                          CER030
      *                                                                                       CER030
      ** Previous DS for Extended Narrative Credit                                            CER030
      *                                                                                       CER030
     D PrvPmtScn5B   E DS                  EXTNAME(FTOPY7BPD)                                 CER030
     D                                     PREFIX(P)                                          CER030
      *                                                                                       CER030

     D @CCI@M          DS
      ** CURRENT CONTROL INDICATORS FOR MAIN DETAIL SCREEN
     D  @EKYFD                 1      1
     D  @EDTFD                 2      2

     D @PCI@M          DS             2
      ** PREVIOUS CONTROL INDICATORS FOR MAIN DETAIL SCREEN

      *  User / Branch data area
     D ZMUSER          DS            17
     D  WDFBR                 11     13
     D  WDPPT                 14     16

      * Data structure to retrieve multi branch indicator
     DRUNDAT           DS
     D WMBIN                  13     13

     D/COPY WNCPYSRC,FTOPA1SD01
     D                 DS
     D*     REDEFINE IPREF FOR INSERTS
     D  IPREF                  1     15
     D  P                      1      1    INZ('P')
     D  RUNDYY                 2      3  0
     D  RUNDMD                 4      7  0
     D**PRNUM                  8     11  0                                                    CFT151
     D  PRNUM                  8     11                                                       CFT151
     D  PmntType              12     13
     D  StmtType              14     15  0
     D*
     D**********       DS                                                           BUG4776 BUG4776R
      ******WIPREF*Work*field*Data*Structure***************************             BUG4776 BUG4776R
     D**WIPREF**               1     13                                             BUG4776 BUG4776R
     D**WPRNUM**               8     11  0                                          BUG4776 BUG4776R

      * Overide file OTPAY in UPD module
     D  OVERRIDE                     47    INZ('OVRDBF FILE(OTPAYOVR)  +
     D                                            TOFILE(OTPAY) SHARE(*NO)')
                                                                                CFT014
      ** Overide file OTPAYXL0 in UPD module.                                   CFT014
     D  OVROPXL0                     49    INZ('OVRDBF FILE(OTXL0)  +           CFT014
     D                                            TOFILE(OTPAYXL0) SHARE(*NO)') CFT014
      **********                                                                    BUG4776 BUG4776R
     D**OVRFTPRF*****                49    INZ('OVRDBF FILE(FTPREFX1) +             BUG4776 BUG4776R
     D**********                                  TOFILE(FTPREFL0) SHARE(*NO)')     BUG4776 BUG4776R

     D/COPY QWINDSRC,FTOPAYSDTA
      *                                                                                       CER001
     D DATALUX         DS          1024                                                       CER001
     D  #1FLD1#                1      6  0                                                    CER001
     D  PREF1                  7     21                                                       CER001
     D  #1FOTR                22     41                                                       CER001
     D  #1TMST                42     67Z                                                      CER001
     D  #1ORCT                68     68                                                       CER001
     D  #1ORBK                69     80                                                       CER001
     D  #1ORC1                81    115                                                       CER001
     D  #1SMCY               116    118                                                       CER001
     D  #1ORBT               119    119                                                       CER001
     D  #1SMAM               120    132P 0                                                    CER001
     D  #1PCCY               133    135                                                       CER001
     D  #1SNCT               136    136                                                       CER001
     D  #1SNCO               137    146                                                       CER001
     D  #1DSTT               147    147                                                       CER001
     D  #1DST1               148    182                                                       CER001

     D***********/COPY FTCPYSRC,SME1100P                                        CGL009
     D/COPY MECPYSRC,ME1100_ILE                                                 CGL009
     D/COPY FTCPYSRC,FT0010D001                                                 CGL009

     D MSGREF          DS
      *  DS to split msg ref when FT0050 called from enquiry function
     D  REFMSG                 1      8  0
     D  REFPRT                 9     11  0

     D                 DS
      *  DS to redefine date
     D  SWDT                   1      6
     D  SYY                    1      2
     D  SMM                    3      4
     D  SDD                    5      6
      *
     D***CSHDTA*         DS           512                                                     CGL029
     D CSHDTA          DS           522                                                       CGL029
      **  Define CASH data area
     D***DACACD*               21     24  0                                                   CGL029
     D  DACACD               513    522  0                                                    CGL029
      *
     D SWDT2           DS             6
      **  Data structure for date change
      *
     D  DDS                    1      2
     D  MM                     3      4
     D  YY                     5      6
     D*
     D TRCDE2          DS
      *  Break down MIDAS equivalent
     D  TRCNUM                 1      6
     D  TRCYCD                 7      9
     D***TRACOD*               10     13                                                      CGL029
     D***TRACSQ*               14     15                                                      CGL029
     D***TRBRCD*               16     18                                                      CGL029
     D***TRCDSQ*               10     15                                                      CGL029
     D***TRCSB**               10     18                                                      CGL029
     D  TRACOD                10     19                                                       CGL029
     D  TRACSQ                20     21                                                       CGL029
     D  TRBRCD                22     24                                                       CGL029
     D  TRCDSQ                10     21                                                       CGL029
     D  TRCSB                 10     24                                                       CGL029
      *
     D                 DS
     D*     DATA STRUCTURE REDEFINING ACCNT KEY FIELDS
     D**CNUM****               1      6  0                                                    CSD027
     D  CNUM                   1      6                                                       CSD027
     D  CNUMA                  1      6
     D  CCY                    7      9
     D***ACOD***               10     13  0                                                   CGL029
     D***ACODA**               10     13                                                      CGL029
     D***ACSQ***               14     15  0                                                   CGL029
     D***ACSQA**               14     15                                                      CGL029
     D***ABRCA**               16     18                                                      CGL029
     D***AKEYF**                1     18                                                      CGL029
     D  ACOD                  10     19  0                                                    CGL029
     D  ACODA                 10     19                                                       CGL029
     D  ACSQ                  20     21  0                                                    CGL029
     D  ACSQA                 20     21                                                       CGL029
     D  ABRCA                 22     24                                                       CGL029
     D  AKEYF                  1     24                                                       CGL029
     D*
     D YA1             S              1    DIM(15)
     D @A              S              1    DIM(15)
      *                                                                         CGL009
      ** Work array for P72 /RATE/ extraction                                   CGL009
      *                                                                         CGL009
     D R1              DS                                                       CGL009
     D  @R1                    1     13                                         CGL009
     D                                     DIM(13)                              CGL009
                                                                                CFT014
      ** Lines of first line of tag                                             CFT014
     D                 DS                                                                     237413
     D  LFLT                   1    355    DIM(5)                                             237413
     D  BG1                    1     30                                                       237413
     D  TV1                   31     71                                                       237413
     D  BG2                   72    101                                                       237413
     D  TV2                  102    142                                                       237413
     D  BG3                  143    172                                                       237413
     D  TV3                  173    213                                                       237413
     D  BG4                  214    243                                                       237413
     D  TV4                  244    284                                                       237413
     D  BG5                  285    314                                                       237413
     D  TV5                  315    355                                                       237413
      *                                                                                       237413
     D*LFLTDS***       DS                                                              CFT014 237413
     D**LFLT****               1    295                                                CFT014 237413
     D**********                           DIM(5)                                      CFT014 237413
     D**BG1*****               1     24                                                CFT014 237413
     D**TV1*****              25     59                                                CFT014 237413
     D**BG2*****              60     83                                                CFT014 237413
     D**TV2*****              84    118                                                CFT014 237413
     D**BG3*****             119    142                                                CFT014 237413
     D**TV3*****             143    177                                                CFT014 237413
     D**BG4*****             178    201                                                CFT014 237413
     D**TV4*****             202    236                                                CFT014 237413
     D**BG5*****             237    260                                                CFT014 237413
     D**TV5*****             261    295                                                CFT014 237413
                                                                                CFT014
      ** Sender's charges amounts in file format                                CFT014
     D DSSCHD          DS                                                       CFT014
     D  CGA                    1     60                                         CFT014
     D                                     DIM(5)                               CFT014
     D  MGSCH1                 1     12                                         CFT014
     D  MGSCH2                13     24                                         CFT014
     D  MGSCH3                25     36                                         CFT014
     D  MGSCH4                37     48                                         CFT014
     D  MGSCH5                49     60                                         CFT014
                                                                                CFT014
      ** Sender's charges currencies                                            CFT014
     D DSSCCD          DS                                                       CFT014
     D  CGC                    1     15                                         CFT014
     D                                     DIM(5)                               CFT014
     D  MGSCC1                 1      3                                         CFT014
     D  MGSCC2                 4      6                                         CFT014
     D  MGSCC3                 7      9                                         CFT014
     D  MGSCC4                10     12                                         CFT014
     D  MGSCC5                13     15                                         CFT014
      *                                                                         CGL009
      ** Work array to determine null amount                                    CGL009
      *                                                                         CGL009
     D @NL             S              1    DIM(15)                              CGL009
      *                                                                         CGL009
      ** Work array to strip off character '/' from field (35 char)             CGL009
      *                                                                         CGL009
     D I35             DS                                                       CGL009
     D  @I35                   1     35                                         CGL009
     D                                     DIM(35)                              CGL009
     D O35             DS                                                       CGL009
     D  @O35                   1     35                                         CGL009
     D                                     DIM(35)                              CGL009
      *                                                                         175479
      ** Work array used in SR CWVAL to store content of tag                    175479
      *                                                                         175479
     D @CW             S              1    DIM(256)                             175479
      *                                                                         175479
      ** Work array used in SR CWVAL to store value extracted                   175479
      *                                                                         175479
     D @VL             S              1    DIM(256)                             175479
     D/COPY WNCPYSRC,FTH00276

      * Output Data Structure for BIC reformatted address                       CFT007
     D @OAddress       DS           175                                         CFT007
     D  OAddress1              1     35                                         CFT007
     D  OAddress2             36     70                                         CFT007
     D  OAddress3             71    105                                         CFT007
     D  OAddress4            106    140                                         CFT007
     D  OAddress5            141    175                                         CFT007
                                                                                CFT007
      * Data Structure for BIC address input flags                              CFT007
     D*BicLines**      DS            12                                         CFT007
     D BicLines        DS            14                                         CFT007
     D  Line1Dest              1      1                                         CFT007
     D  Line2Dest              2      2                                         CFT007
     D  Line1OCus              3      3                                         CFT007
     D  Line2OCus              4      4                                         CFT007
     D  Line1RCor              5      5                                         CFT007
     D  Line2RCor              6      6                                         CFT007
     D  Line1ABnk              7      7                                         CFT007
     D  Line2ABnk              8      8                                         CFT007
     D  Line1Benf              9      9                                         CFT007
     D  Line2Benf             10     10                                         CFT007
     D  Line1IBnk             11     11                                         CFT007
     D  Line2IBnk             12     12                                         CFT007
     D  Line1TRIn             13     13                                         CFT007
     D  Line2TRIn             14     14                                         CFT007
      *                                                                         CGL009
      ** Data Structure to hold NOSTRO number                                   CGL009
      *                                                                         CGL009
     D DSNOST          DS                                                       CGL009
     D  WNOCCY                 1      3                                         CGL009
     D  WNONUM                 4      5                                         CGL009
      *                                                                         CGL009
      ** Data Structure to hold partial account number                          CGL009
      *                                                                         CGL009
     D DSPTAC          DS                                                       CGL009
     D  WPTCST                 1      6                                         CGL009
     D***WPTACD*                7     10                                               CGL009 CGL029
     D***WPTSQN*               11     12                                               CGL009 CGL029
     D***WPTBCH*               13     15                                               CGL009 CGL029
     D  WPTACD                 7     16                                                       CGL029
     D  WPTSQN                17     18                                                       CGL029
     D  WPTBCH                19     21                                                       CGL029
     D/COPY WNCPYSRC,JMI106_009                                                               JMI106
      *                                                                                       187056
      ** Calling parameter DS for FT0035                                                      187056
     D P0DTA           DS           256                                                       187056
     D  WIPT1                  1      1                                                       187056
     D  WIPTY1                 2     36                                                       187056
     D  WIPT2                 37     37                                                       187056
     D  WIPTY2                38     72                                                       187056
     D  WICCY                 73     75                                                       187056
     D  WOCUST                76     81                                                       187056
                                                                                CFT007
      ** +--------------------------------------+
      ** ¦ Declared variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+

      ** Response Mode, passed as a constant parameter to the VAL module
      ** This is always 'S' for Synchronous
     D RespMode        S              1A   INZ('S')

     D ZalignOK        S              1
     D ZFIELD          S             16
     D ZADEC           S              1  0
     D ZADIG           S              2  0

     D WkBlankfld      S             35    INZ(*Blanks)                         CFT007
     D WkCHIPCode      S             14    INZ(*Blanks)                         CFT007
                                                                                CFT007
      * Msg Unique Reference                                                                  190845
     D SHMSGR          S              8  0                                                    190845
     D                                                                                        190845
      * Part Number                                                                           190845
     D SHPART          S              3  0                                                    190845
      *                                                                                       190845
      ** Access Object parameter fields                                                       CSC011
     D PRTCD           S              7A                                                      CSC011
     D POPTN           S              7A                                                      CSC011
     D PSARD           S              6A                                                      CSC011
     D PACCD           S             10A                                                      CGL029
     D P@ACCD          S             10A                                                      CGL029
     D P@IBAN          S             34A                                                      CFT032
     D P@SAR           S              6A                                                      CFT032
                                                                                              CSC011
      ** Flag to indicate if CSW203 is switched on                                            CSW203
     D CSW203          S              1A                                                      CSW203
      ** CSC022 switchable field                                                              CSC022
     D CSC022          S              1A                                                      CSC022
      **                                                                                      CSC022
      ** CSC022 work fields                                                                   CSC022
     D WArrPtr         S              3S 0                                                    CSC022
     D WSkpComtRolbk   S              1A                                                      CSC022
      **                                                                                      CSC022
      ** Payment reference flag                                                               242102
     D PRflag          S              1A                                                      242102
                                                                                              CSW203
     D CSW209          S              1A                                                      CSW209
                                                                                              CSW209
     D CER030          S              1A                                                      CER030
     D CER031          S              1A                                                      CER030
     D CGL013          S              1A                                                      CER030
     D CSC054          S              1A                                                      CSC054
      *                                                                                       CSC054
                                                                                            MD024335
      ** Add-Deduct Indicator                                                               MD024335
     D DftADInd        S              1A   INZ                                              MD024335
                                                                                            MD024335
      ** Parameters for AOSVALR0                                                            MD024335
     D PRetCode        S              7A   INZ                                              MD024335
     D POPT            S             20A   INZ DIM( 10 )                                    MD024335
     D PVAL            S            200A   INZ DIM( 10 )                                    MD024335
                                                                                            MD024335
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+

      ** +----------------------------------------+
      ** ¦ Hook for non-core D-specs (all types)  ¦
      ** ¦ also any I-specs (if necessary)        ¦
      ** ¦ =====================================  ¦
      ** +----------------------------------------+
      /COPY WNCPYSRC,FTOPAYS010
     D STMESTMP        S             26Z                                                      CER001
     D SFOTRANID       S             20                                                       CER001
     D ULX043          S              1A   INZ('N')                                           CER001
     D ACTION          S              1A                                                      CER001
     D #RTRN           S              7A                                                      CER001
     D svOPORBT        S                   LIKE(OTOPORBT)                                     CFT039
     D svOPORB1        S                   LIKE(OTOPORB1)                                     CFT039
     D svOPORB2        S                   LIKE(OTOPORB2)                                     CFT039
     D svOPORB3        S                   LIKE(OTOPORB3)                                     CFT039
     D svOPORB4        S                   LIKE(OTOPORB4)                                     CFT039
     D svOPORB5        S                   LIKE(OTOPORB5)                                     CFT039
     D InputUser       S             10A                                                    MD050574

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
      *                                                                                      BUG7029
      ** Retrieve ZMUSER details.                                                            BUG7029
      *                                                                                      BUG7029
     C     *DTAARA       DEFINE                  ZMUSER                                      BUG7029
     C                   IN        ZMUSER                                                    BUG7029
     C                   UNLOCK    ZMUSER                                                    BUG7029
      **  Set up default user information                                                     260454
     C                   Eval      @DFBR = WDFBR                                              260454
     C                   Eval      @DPPT = WDPPT                                              260454
      *
      /COPY WNCPYSRC,FTOPAYS001
      * Issue rollback to clear any possible updates in window functions
      *
     C     @INKL         IFEQ      '1'
     C     @SORT         ANDNE     'E'                                                      BUG24143
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END
      *
      /COPY WNCPYSRC,FTOPAYS002
      *                                                                          CFT018
      ** Display SSI browse details                                              CFT018
     C     @SCRN         DOWEQ     'A'                                           CFT018
     C                   EXSR      SCRN@A                                        CFT018
     C                   ENDDO                                                   CFT018
      *                                                                          CFT018
      ** Read SSI browse details                                                 CFT018
     C     @SCRN         DOWEQ     'D'                                           CFT018
     C                   EXSR      SCRN@D                                        CFT018
     C                   ENDDO                                                   CFT018
      *                                                                          CFT018
      ** Display payment details insert screen                                   CFT018
     C     @SCRN         DOWEQ     'E'                                           CFT018
     C                   EXSR      SCRN@E                                        CFT018
     C                   ENDDO                                                   CFT018
      *                                                                          CFT018
      ** Display browse sub-file screen                                          CFT018
     C     @SCRN         DOWEQ     'F'                                           CFT018
     C                   EXSR      BLDBRW                                        CFT018
     C                   ENDDO                                                   CFT018
      *
      ** Read next browse subfile record
      *
     C     @SCRN         IFEQ      'R'
     C                   EXSR      RDNBRW
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTOPAYS003
      *
      ** DO WHILE screen: Primary Details Screen (Level 1)
      *
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *Blanks       @FIND
     C                   MOVE      *Blanks       @NDAT
     C                   MOVE      *Blanks       @PYDT
     C                   MOVE      *Blanks       @PYVD
     C                   MOVE      *Blanks       @STTP
     C                   MOVE      *Blanks       @CHAP                                        217337
     C                   MOVE      *Blanks       @RCRM                                        222731
     C     @SCRN         DOWEQ     'P'
     C                   EXSR      Scrn@P
     C                   ENDDO
      *
      /COPY WNCPYSRC,FTOPAYS004
      *
      ** DO WHILE screen: Secondary Details Screen (Level 2)
      *
     C                   Z-ADD     *ZERO         WIdx_SVAL         3 0
     C                   MOVE      *Blanks       @ACB1
     C                   MOVE      *Blanks       @ACB2
     C                   MOVE      *Blanks       @BNC1
     C                   MOVE      *Blanks       @BNC2
     C                   MOVE      *Blanks       @RCO1
     C                   MOVE      *Blanks       @RCO2
     C                   MOVE      *Blanks       @TRI1                          CFT014
     C                   MOVE      *Blanks       @TRI2                          CFT014
     C                   MOVE      *Blanks       @INB1                          CFT014
     C                   MOVE      *Blanks       @INB2                          CFT014
     C     @SCRN         DOWEQ     'S'
     C                   EXSR      Scrn@S
     C                   ENDDO
                                                                                CFT014
      ** Third detail screen level 2                                            CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         WIdx_BVAL         3 0          CFT014
      *                                                                                       222731
      ** Make sure that CHAPS code of previous OP not displayed on new Insert &               222731
      ** entered CHAPS code not blanked out when F12 is pressed on Insert                     222731
      *                                                                                       222731
     C     OTCHAP        IFEQ      *Zeros                                                     222731
     C     SPREF         ANDNE     @PSPREF                                                    222731
     C                   MOVE      *Blanks       SCHAP                                        222731
     C                   ENDIF                                                                222731
                                                                                CFT014
     C                   DoW       @SCRN = 'B'                                  CFT014
     C                   ExSr      SCRN@B                                       CFT014
     C                   Enddo                                                  CFT014
                                                                                CFT014
      ** Default charges & commissions screens                                  CFT014
                                                                                CFT014
     C                   IF        @CFT009 = 'N'                                CFT009
     C**********         If        @SCRN = 'O'                                  CFT014        219150
     C**********         If        (NewPmtScn1 <> PrvPmtScn1) Or                CFT014        219150
     C**********                   (NewPmtSc1b <> PrvPmtSc1b) Or                CFT014        219150
     C**********                   (NewPmtSc2a <> PrvPmtSc2a) Or                CFT014        219150
     C**********                   (NewPmtSc2b <> PrvPmtSc2b) Or                CFT014        219150
     C**********                   (NewPmtScn3 <> PrvPmtScn3) Or                CFT014        219150
     C**********                   (NewPmtSc3b <> PrvPmtSc3b)                   CFT014        219150
     C                   If        @SCRN = 'O' and SACTION = 'I'                              219150
                                                                                222472
      ** Charges should only be defaulted on insert, if screen 1 details or     222472
      ** transfer commission tarif amended.                                     222472
                                                                                222472
     C                   IF        SACTION = 'I' Or                             222472
     C                             (NewPmtScn1 <> PrvPmtScn1) Or                222472
     C                             (SSMCY <> @PSSMCY And SADDC = 'A') Or                      226920
     C                             (SPCCY <> @PSPCCY And SADDC = 'D') Or                      226920
     C                             (SADDC <> @PSADDC) Or                                      226920
     C                             (STRCT <> @PSTRCT)                           222472
     C                                                                          222472
     C                   ExSr      DFT@O                                        CFT014
     C                   EndIf                                                  222472
     C                   EndIf                                                  CFT014
     C**********         EndIf                                                  CFT014        219150
     C                   ENDIF                                                  CFT009
                                                                                CFT014
      *
      /COPY WNCPYSRC,FTOPAYS005
      *
      ** DO WHILE screen: Charges & Commissions Screen
      *
     C                   Z-ADD     *ZERO         WIdx_OVAL         3 0
     C***********        MOVE      *Blanks       @INB1                          CFT014
     C***********        MOVE      *Blanks       @INB2                          CFT014
     C     @SCRN         DOWEQ     'O'
     C                   EXSR      Scrn@O
     C/COPY WNCPYSRC,FTH00277
     C                   ENDDO
                                                                                CFT014
      ** Margin Information                                                     CFT014
                                                                                CFT014
     C     @SCRN         DowEq     'M'                                          CFT014
     C                   ExSr      Scrn@M                                       CFT014
     C                   Enddo                                                  CFT014
      *                                                                                       CSW209
      ** Display Cover Message if SWIFT 2009 is ON                                            CSW209
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
      ** Cover Message screen 1                                                               CSW209
                                                                                              CSW209
     C     @SCRN         DOWEQ     'G'                                                        CSW209
     C                   EXSR      Scrn@G                                                     CSW209
     C                   ENDDO                                                                CSW209
                                                                                              CSW209
      ** Cover Message screen 2                                                               CSW209
                                                                                              CSW209
     C     @SCRN         DOWEQ     'H'                                                        CSW209
     C                   EXSR      Scrn@H                                                     CSW209
     C                   ENDDO                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *
      /COPY WNCPYSRC,FTOPAYS006
      *
      * SCREEN: WINDOW
     C                   Z-ADD     *ZERO         WIdx_WVAL         3 0
     C     @SCRN         IFEQ      'W'
     C/COPY WNCPYSRC,FTH00278
     C                   EXSR      WINDOW
     C                   END

      /COPY WNCPYSRC,FTOPAYS008
      *
      * SCREEN: CONFIRMATION OF INPUT
     C     @SCRN         IFEQ      'C'
     C                   EXSR      SCRN@C
     C                   END

      ** Do File updates
      *
     C     @SCRN         IFEQ      'U'
     C                   EXSR      UPDATS
      *                                                                                       204152
      * Reset First Time through Flag                                                         204152
     C                   EVAL      FirstTime = 'Y'                                            204152
      *                                                                                       204152
     C                   ENDIF
      *
      /COPY WNCPYSRC,FTOPAYS009
      *
      ** Terminate program
      *
     C     @SCRN         IFEQ      'T'
     C                   MOVE      *BLANKS       @RTCDE                                       214320
     C                   MOVE      'FT'          @MODLE                                       214320
     C                   MOVE      *BLANKS       @TREF                                        214320
     C                   MOVE      *BLANKS       @RTINF                                       214320
     C                   CALL      'AOC8000'                                                  214320
     C                   PARM                    @RTCDE                                       214320
     C                   PARM                    @MODLE                                       214320
     C                   PARM                    @TREF                                        214320
     C                   PARM                    @RTINF                                       214320
     C                   MOVE      *ON           *INLR
     C                   ENDIF
      *
      *****************************************************************

      * Hook to enable non-core subroutines to be included
      /COPY WNCPYSRC,FTOPAYS011
     C     WINDOWI       BEGSR                                                                CER001
     C                   MOVEL     SPREF         PREF1                                        CER001
     C                   MOVEL     SFOTRANID     #1FOTR                                       CER001
     C                   MOVEL     STMESTMP      #1TMST                                       CER001
     C                   MOVEL     @ORCT         #1ORCT                                       CER001
     C                   MOVEL     @ORBT         #1ORBT                                       CER001
     C                   MOVEL     SORBK         #1ORBK                                       CER001
     C                   MOVEL     SORC1         #1ORC1                                       CER001
     C                   MOVEL     SSMCY         #1SMCY                                       CER001
     C                   Z-ADD     @SMAM         #1SMAM                                       CER001
     C                   MOVEL     SPCCY         #1PCCY                                       CER001
     C                   MOVEL     @SNCT         #1SNCT                                       CER001
     C                   MOVEL     SSNCO         #1SNCO                                       CER001
     C                   MOVEL     @DSTT         #1DSTT                                       CER001
     C                   MOVEL     SDST1         #1DST1                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FTOPAY3SN'                                                CER001
     C                   PARM      SACTION       ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
      *                                                                                       CER001
      ** Process returned command keys                                                        CER001
      *                                                                                       CER001
     C     #RTRN         IFEQ      'Y2U9999'                                                  CER001
     C                   COMMIT                                                               CER001
     C                   EXSR      ENDP                                                       CER001
      *                                                                                       CER001
      ** Otherwise, go to next screen after UPDATS routine                                    CER001
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     WINDI         ENDSR                                                                CER001

      /EJECT                                                                                  256192
      *****************************************************************                       256192
      * PAYSCM1 - Initialize Details Field                                                    256192
      *****************************************************************                       256192
     C     PAYSCM1       BEGSR                                                                256192
      **                                                                                      256192
      ** Remove payment details required to be reinput.                                       256192
      **                                                                                      256192
     C     SACTION       IFEQ      'E'                                                        256192
     C     PREF          ANDEQ     SPREF                                                      256192
      **                                                                                      256192
      ** Screen 1                                                                             256192
      **                                                                                      256192
      ** Ordering Customer Line 5                                                             256192
     C                   MOVE      *BLANKS       SORC5                                        256192
      ** Settlement Amount                                                                    256192
     C                   MOVE      *BLANKS       SSMAM                                        256192
      ** Pay Currency Amount                                                                  256192
     C                   MOVE      *BLANKS       SPYAM                                        256192
      ** Instructed Amount                                                                    256192
     C                   MOVE      *BLANKS       SPDAM                                        256192
      ** Blank the Charges to Debit Account and Details of Charges fields                     260419
     C                   MOVE      *BLANKS       SCDRO                                        260419
     C                   MOVE      *BLANKS       SCDBR                                        260419
      ** Blank the Details of Charges                                                         260419
     C                   MOVE      *BLANKS       SDTCH                                        260419
      ** Blank all charges for replication                                                    260419
     C                   MOVE      *BLANKS       TRCDE                                        260419
     C                   MOVE      *BLANKS       STRCD                                        260419
     C                   MOVE      *BLANKS       FXCDE                                        260419
     C                   MOVE      *BLANKS       SCHCD                                        260419
     C                   MOVE      *BLANKS       TXCDE                                        260419
     C                   MOVE      *BLANKS       STXCD                                        260419
     C                   MOVE      *BLANKS       CQCDE                                        260419
     C                   MOVE      *BLANKS       SCQCD                                        260419
     C                   MOVE      *BLANKS       CACDE                                        260419
     C                   MOVE      *BLANKS       SCSTD                                        260419
     C                   MOVE      *BLANKS       STCDE                                        260419
     C                   MOVE      *BLANKS       STCD                                         260419
     C                   MOVE      *BLANKS       SPCDE                                        260419
     C                   MOVE      *BLANKS       SSPCD                                        260419
     C                   MOVE      *BLANKS       MSCDE                                        260419
     C                   MOVE      *BLANKS       SMSCD                                        260419
     C                   MOVE      *BLANKS       M1CDE                                        260419
     C                   MOVE      *BLANKS       M1CD                                         260419
     C                   MOVE      *BLANKS       M2CDE                                        260419
     C                   MOVE      *BLANKS       M2CD                                         260419
     C                   MOVE      *BLANKS       M3CDE                                        260419
     C                   MOVE      *BLANKS       M3CD                                         260419
     C                   MOVE      *BLANKS       M4CDE                                        260419
     C                   MOVE      *BLANKS       M4CD                                         260419
     C                   MOVE      *BLANKS       M5CDE                                        260419
     C                   MOVE      *BLANKS       M5CD                                         260419
      ** Receiver's Charges - remitted amount                                                 260419
     C                   MOVE      *BLANKS       SRCRM                                        260419
      ** Other Sender's Charges                                                               260419
     C                   MOVE      *BLANKS       SSCC2                                        260419
     C                   MOVE      *BLANKS       SSCH2                                        260419
     C                   MOVE      *BLANKS       SSCC3                                        260419
     C                   MOVE      *BLANKS       SSCH3                                        260419
     C                   MOVE      *BLANKS       SSCC4                                        260419
     C                   MOVE      *BLANKS       SSCH4                                        260419
     C                   MOVE      *BLANKS       SSCC5                                        260419
     C                   MOVE      *BLANKS       SSCH5                                        260419
      *                                                                                     MD024335
      ** Add/Deduct indicator                                                               MD024335
      *                                                                                     MD024335
     C                   EVAL      SADDC = DftADInd                                         MD024335
      *                                                                                     MD024335
     C/COPY WNCPYSRC,FTH00656
      **                                                                                      256192
      *                                                                                       256862
      ** Set the Settlement and Payment Date to Rundate                                       256862
      *                                                                                       256862
     C                   If        (@CSC011 = 'Y') And (LIBR = S1SUPP)                        256862
     C                   Eval      ZDAYNO = WPRDTE                                            256862
     C                   Else                                                                 256862
     C                   Eval      ZDAYNO = BJRDNB                                            256862
     C                   Endif                                                                256862
      *                                                                                       256862
      ** Calculate Run Date                                                                   256862
      *                                                                                       256862
     C                   CallB     'ZDATE2'                                                   256862
     C                   Parm                    ZDAYNO                                       256862
     C                   Parm                    BJDFIN                                       256862
     C                   Parm      0             ZDATE                                        256862
     C                   Parm      *Blanks       ZADATE                                       256862
      *                                                                                       256862
      ** Set dates to Rundate                                                                 256862
      *                                                                                       256862
     C                   Move      ZDATE         SPYVD                                        256862
     C                   Move      ZDATE         SPYDT                                        256862
      *                                                                                       256862
     C                   ENDIF                                                                256192
     C                   ENDSR                                                                256192
      /EJECT
      *****************************************************************         CFT018
      * SCRN@A - Display SSI Details                                            CFT018
      *****************************************************************         CFT018
     C     SCRN@A        BEGSR                                                  CFT018
      *                                                                         CFT018
      ** Set subfile display indicator to rebuild if SSI has been updated       CFT018
     C     LASTACTN      IFEQ      'U'                                          CFT018
     C                   MOVE      'B'           @BDSFL                         CFT018
     C                   ELSE                                                   CFT018
     C                   MOVE      'D'           @BDSFL                         CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
      **  Reset last action update indicator                                    CFT018
     C                   MOVE      ' '           LastActn                       CFT018
      *                                                                         CFT018
     C                   CALLB     'FTOPAY6DP'                                  CFT018
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                 CFT018
      * Return code                                                             CFT018
     C                   PARM      *BLANK        RetCodeOut                     CFT018
      * Build/Read subfile indicator                                            CFT018
     C                   PARM                    @BDSFL                         CFT018
      * Create new payment from SSI indictaor                                   CFT018
     C                   PARM                    @CRTPMNT          1            CFT018
      * SSI details in screen format                                            CFT018
     C                   PARM                    SSIScrnFmt                     CFT018
      * Screen format details for display by FTOPAY7DP                          CFT018
     C                   Parm                    NewPmtScn7                     CFT018
      * Successful insert Payment                                               CFT018
     C                   Parm                    @SITR                          CFT018
      * Function Keys                                                           CFT018
     C                   PARM      '0'           @INKC                          CFT018
     C                   PARM      '0'           @INKE                          CFT018
     C                   PARM      '0'           @INKP                          CFT018
     C                   PARM      '0'           @INKI             1            CFT018
     C                   PARM                    @ROLLUP           1            CFT018
      *                                                                         CFT018
      **  Process screen response                                               CFT018
     C                   SELECT                                                 CFT018
      *                                                                         CFT018
      ** F3 - End Program                                                       CFT018
     C     @INKC         WHENEQ    '1'                                          CFT018
     C                   EXSR      ENDP                                         CFT018
      *                                                                         CFT018
      ** F5 - Refresh screen and redisplay                                      CFT018
     C     @INKE         Wheneq    '1'                                          CFT018
     C                   Movel     'A'           @SCRN                          CFT018
      *                                                                         CFT018
      ** F15 - Display outgoing payments browse screen                          CFT018
     C     @INKP         WHENEQ    '1'                                          CFT018
     C                   EXSR      BLDBRW                                       CFT018
      *                                                                         CFT018
      ** F9 - Insert payment with no SSI details                                CFT018
     C     @INKI         WHENEQ    '1'                                          CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
     C                   MOVE      'E'           @SCRN                          CFT018
      *                                                                         CFT018
      * Redisplay browse sub-file screen if rollup requested                    CFT018
     C     @ROLLUP       WHENEQ    'Y'                                          CFT018
     C                   MOVEL     'A'           @SCRN                          CFT018
      *                                                                         CFT018
      ** Otherwise read sub-file to check for an insert request                 CFT018
     C                   OTHER                                                  CFT018
     C                   MOVE      'D'           @SCRN                          CFT018
      *                                                                         CFT018
     C                   ENDSL                                                  CFT018
      *                                                                         CFT018
     C                   ENDSR                                                  CFT018
      *****************************************************************         CFT018
      /EJECT                                                                    CFT018
      *****************************************************************         CFT018
      * SCRN@D - Read SSI Sub-File Details                                      CFT018
      *****************************************************************         CFT018
     C     SCRN@D        BEGSR                                                  CFT018
      *                                                                         CFT018
     C                   CALLB     'FTOPAY6DP'                                  CFT018
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                 CFT018
      * Return code                                                             CFT018
     C                   PARM      *BLANK        RetCodeOut                     CFT018
      * Build/Read subfile indicator                                            CFT018
     C                   PARM      'R'           @BDSFL                         CFT018
      * Create new payment from SSI indicator                                   CFT018
     C                   PARM                    @CRTPMNT          1            CFT018
      * SSI details in screen format                                            CFT018
     C                   PARM                    SSIScrnFmt                     CFT018
      * Screen format details for display by FTOPAY7DP                          CFT018
     C                   Parm                    NewPmtScn7                     CFT018
      * Successful insert Payment                                               CFT018
     C                   Parm                    @SITR                          CFT018
      * Function Keys                                                           CFT018
     C                   PARM      '0'           @INKC                          CFT018
     C                   PARM      '0'           @INKE                          CFT018
     C                   PARM      '0'           @INKP                          CFT018
     C                   PARM      '0'           @INKI                          CFT018
     C                   PARM                    @ROLLUP           1            CFT018
      *                                                                         CFT018
      ** Insert payment with SSI details                                        CFT018
     C     @CRTPMNT      IFEQ      'Y'                                          CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
     C                   MOVE      'E'           @SCRN                          CFT018
     C                   ELSE                                                   CFT018
      *                                                                         CFT018
      ** Otherwise redisplay subfile screen                                     CFT018
     C                   MOVE      'A'           @SCRN                          CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
     C                   ENDSR                                                  CFT018
      *****************************************************************         CFT018
      /EJECT                                                                    CFT018
      *****************************************************************         CFT018
      * SCRN@E - Initial Payment Details Insert Screen                          CFT018
      *****************************************************************         CFT018
     C     SCRN@E        BEGSR                                                  CFT018
      *                                                                         CFT018
      **  Reset flag to insert payment with no screen display                   CFT018
      **  unless errors occur in validation                                     CFT018
     C                   Move      'N'           @InsertPay        1            CFT018
      *                                                                         CFT018
     C                   CALLB     'FTOPAY7DP'                                  CFT018
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯                                 CFT018
      * Return code                                                             CFT018
     C                   PARM      *BLANK        RetCodeOut                     CFT018
      * Create new payment from SSI indicator                                   CFT018
     C                   PARM                    @CRTPMNT          1            CFT018
      * Flag to indicate new payment from SSI is valid                          CFT018
     C                   PARM                    @ValidPay                      CFT018
      * Screen format details for display                                       CFT018
     C                   Parm                    NewPmtScn7                     CFT018
      * SSI details in screen format                                            CFT018
     C                   PARM                    SSIScrnFmt                     CFT018
      ** OK inds                                                                CFT018
     C                   PARM                    FTEOPY7                        CFT018
      * Error fields/message IDs/message data (arrays) from/to caller           CFT018
     C                   PARM                    FldNameArr                     CFT018
     C                   PARM                    MsgIDArr                       CFT018
     C                   PARM                    MsgDtaArr                      CFT018
     C                   PARM                    Idx                            CFT018
      * Warning fields/message IDs/message data (arrays) from/to caller         CFT018
     C                   PARM                    WFldNamArr                     CFT018
     C                   PARM                    WMsgIDArr                      CFT018
     C                   PARM                    WMsgDtaArr                     CFT018
     C                   PARM                    WIdx                           CFT018
      * Function Keys                                                           CFT018
     C                   PARM                    @INKC                          CFT018
     C                   PARM                    @INKF             1            CFT018
     C                   PARM                    @INKL                          CFT018
      *                                                                         CFT018
      **  Process screen response                                               CFT018
     C                   SELECT                                                 CFT018
      *                                                                         CFT018
      ** F3 - End Program                                                       CFT018
     C     @INKC         WHENEQ    '1'                                          CFT018
     C                   EXSR      ENDP                                         CFT018
      *                                                                         CFT018
      ** F06 - Insert payment with no further screen displays                   CFT018
     C     @INKF         WHENEQ    '1'                                          CFT018
     C                   MOVE      'Y'           @InsertPay        1            CFT018
     C                   MOVE      'P'           @SCRN                          CFT018
      *                                                                         CFT018
      ** F12 - Redisplay current screen if payment has been validated           CFT018
     C     @INKL         WHENEQ    '1'                                          CFT018
     C     @ValidPay     ANDEQ     'Y'                                          CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
      *                                                                         CFT018
      ** F12 - Previous screen if payment has not been validated                CFT018
     C     @INKL         WHENEQ    '1'                                          CFT018
     C     @ValidPay     ANDNE     'Y'                                          CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
     C                   MOVE      'A'           @SCRN                          CFT018
      *                                                                         CFT018
      ** Screen details already validated and enter pressed                     CFT018
     C     @ValidPay     WHENEQ    'Y'                                          CFT018
     C                   MOVE      'P'           @SCRN                          CFT018
      *                                                                         CFT018
      ** Otherwise validate screen details                                      CFT018
     C                   OTHER                                                  CFT018
     C                   EXSR      VAL@E                                        CFT018
      *                                                                         CFT018
     C                   ENDSL                                                  CFT018
      *                                                                         CFT018
     C                   ENDSR                                                  CFT018
      *****************************************************************         CFT018
      /EJECT                                                                    CFT018
      *****************************************************************         CFT018
      * VAL@E - Validate Payment Details Insert Screen                          CFT018
      *****************************************************************         CFT018
     C     VAL@E         BEGSR                                                  CFT018
      *                                                                         CFT018
      * Set valid payment flag                                                  CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
      *                                                                         CFT018
      *  Reset no of error warnings                                             CFT018
     C                   Z-ADD     0             WIdx_PVAL                      CFT018
      *                                                                         CFT018
     C                   CALLB     'FTOPAY7VL'                                  CFT018
      * Return code                                                             CFT018
     C                   PARM      *BLANK        RetCodeOut                     CFT018
      * Create new payment from SSI indictaor                                   CFT018
     C                   PARM                    @CRTPMNT          1            CFT018
      * Screen format details for display                                       CFT018
     C                   Parm                    NewPmtScn7                     CFT018
      * SSI details in screen format                                            CFT018
     C                   PARM                    SSIScrnFmt                     CFT018
      * Ougoing Payment in screen format                                        CFT018
     C                   PARM                    NewPmtScn1                     CFT018
     C                   PARM                    NewPmtSc1b                     CFT018
     C                   PARM                    NewPmtSc2a                     CFT018
     C                   PARM                    NewPmtSc2b                     CFT018
     C                   PARM                    NewPmtScn3                     CFT018
     C                   PARM                    NewPmtSc3b                     CFT018
     C                   PARM                    NewPmtScn4                     CFT018
      ** OK inds                                                                CFT018
     C                   PARM                    FTEOPY7                        CFT018
      * Error fields/message IDs/message data (arrays) from/to caller           CFT018
     C                   PARM                    FldNameArr                     CFT018
     C                   PARM                    MsgIDArr                       CFT018
     C                   PARM                    MsgDtaArr                      CFT018
     C                   PARM                    Idx                            CFT018
      * Warning fields/message IDs/message data (arrays) from/to caller         CFT018
     C                   PARM                    WFldNamArr                     CFT018
     C                   PARM                    WMsgIDArr                      CFT018
     C                   PARM                    WMsgDtaArr                     CFT018
     C                   PARM                    WIdx                           CFT018
      *  Validation Work Fields from/to caller                                  CFT018
     C                   PARM                    Val@Fields                     CFT018
      *                                                                         CFT018
      *                                                                         CFT018
      * If errors returned                                                      CFT018
     C     Idx           IFNE      0                                            CFT018
     C                   GOTO      EndVAL@E                                     CFT018
     C                   END                                                    CFT018
      *                                                                         CFT018
      * If warning messages which have not been previously displayed            CFT018
     C                   Eval      Widx_PVAL = Widx_PVAL + Widx                 CFT018
     C     WIdx_PVAL     IFNE      PrvN_Warn                                    CFT018
     C                   GOTO      EndVAL@E                                     CFT018
     C                   END                                                    CFT018
      *                                                                         CFT018
      * Clear any warning messages                                              CFT018
     C                   MOVE      *ALL'Y'       FTEOPY7                        CFT018
     C                   MOVEL     *BLANK        WFldNamArr                     CFT018
     C                   MOVEL     *BLANK        WMsgIdArr                      CFT018
     C                   MOVEL     *BLANK        WMsgDtaArr                     CFT018
      *                                                                         CFT018
      * Set valid payment flag                                                  CFT018
     C                   MOVE      'Y'           @ValidPay         1            CFT018
      *                                                                         CFT018
      * Set screen indicator to go to primary screen if payment not             CFT018
      * being created from a template payment                                   CFT018
     C     @CRTPMNT      IFNE      'Y'                                          CFT018
     C                   MOVE      'P'           @SCRN                          CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
     C     ENDVAL@E      ENDSR                                                  CFT018
      *****************************************************************         CFT018
      /EJECT                                                                    CFT018
      *****************************************************************
      * SCRN@P - PROCESS SCREEN: PRIMARY DETAILS
      *****************************************************************
     C     SCRN@P        BEGSR

      * Update 'previous' screen

     C                   MOVEL     NewPmtScn1    PrvPmtScn1
     C                   MOVEL     NewPmtSc1b    PrvPmtSc1b                     CFT014
     C                   Z-ADD     WIdx_PVAL     PrvN_Warn         3 0
     C                   MOVEL     @CCI@M        @PCI@M
      *
      * If not called from linked enquiry enable CMDs 7,8 & 15.
     C     LinkedEnq     IFEQ      *BLANK
     C     SSIMode       ANDNE     'Y'                                          CFT018
     C                   MOVE      'Y'           @EINKG
     C                   MOVE      'Y'           @EINKH
     C                   MOVE      'Y'           @EINKP
     C                   END
                                                                                CFT007
      * If BIC database plus integration is on, set F4 and F16                  CFT007
                                                                                CFT007
     C                   EVAL      @EINKQ = 'N'                                 CFT007
     C                   EVAL      @EINKD = 'N'                                 CFT007
     C                   IF        @CFT007 = 'Y'                                CFT007
     C                   IF        SACTION <> 'D' and SACTION <> 'E'            CFT007
     C                   EVAL      @EINKQ = 'Y'                                 CFT007
     C                   EVAL      @EINKD = 'Y'                                 CFT007
     C                   ENDIF                                                  CFT007
     C                   ENDIF                                                  CFT007
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKG                          CFT018
     C                   Move      '0'           @INKH                          CFT018
     C                   Move      '0'           @INKJ                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKP                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
     C                   Move      '0'           @INKS                          CFT018
     C                   Move      '0'           @INKV                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
      **  and no errors have occurred in validation                             CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
     C     Idx           orne      0                                            CFT018
      *
      ** WRITE/READ DISPLAY SCREEN - Primary Details
      *
     C/COPY WNCPYSRC,FTOPA1SC16
     C                   CALLB     'FTOPAY1DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      * Status
     C                   PARM                    DDSTAT           24
      *
      * Fields in error
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED KEY FIELDS
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS
      * KD = COMMAND KEY 04 = BIC IN-LINE PROMPT                                CFT007
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      * KP = COMMAND KEY 15 = BROWSE
      * KQ = COMMAND KEY 16 = BIC IN-LINE SEARCH                                CFT007
      * KS = COMMAND KEY 18 = READ NEXT (from linked enquiry)
      * KV = COMMAND KEY 21 = ADDITIONAL INFORMATION WINDOW
     C                   PARM                    @EINKD            1            CFT007
     C                   PARM                    @EINKG            1
     C                   PARM                    @EINKH            1
     C                   PARM                    @EINKJ            1
     C                   PARM                    @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM                    @EINKS            1
     C                   PARM                    @EINKV            1
      * Successful insert Payment
     C                   PARM                    @SITR            15
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
      *
      * SWIFT Identifier
     C                   PARM                    XPREF

      * OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc         5 0          CFT007
     C                   PARM                    SSIMode           1            CFT018
     C/COPY WNCPYSRC,FTOPA1SC17
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                                       214320
      ** Release any allocated transaction                                                    214320
      *                                                                                       214320
     C     @INKP         IFEQ      '1'                                                        214320
     C     @INKL         OREQ      '1'                                                        214320
     C     @INKH         OREQ      '1'                                                        214320
     C     @INKG         OREQ      '1'                                                        214320
     C     @INKC         OREQ      '1'                                                        214320
     C                   MOVE      *BLANKS       @RTCDE                                       214320
     C                   MOVE      'FT'          @MODLE                                       214320
     C                   MOVE      *BLANKS       @TREF                                        214320
     C                   MOVE      *BLANKS       @RTINF                                       214320
     C                   CALL      'AOC8000'                                                  214320
     C                   PARM                    @RTCDE                                       214320
     C                   PARM                    @MODLE                                       214320
     C                   PARM                    @TREF                                        214320
     C                   PARM                    @RTINF                                       214320
     C                   ENDIF                                                                214320
      *                                                                         CFT018
     C                   Endif                                                  CFT018
      *                                                                         CFT018
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F7 - Roll Backwards
     C     @INKG         CASEQ     '1'           ROLL
      *
      * F8 - Roll Forwards
     C     @INKH         CASEQ     '1'           ROLL
      *
      * F10 - Delete Processing
     C     @INKJ         CASEQ     '1'           DELETE
      *
      * F12 - Cancel on Primary Screen
     C     @INKL         CASEQ     '1'           CANC@P
      *
      * F15 - Build Browse
     C     @INKP         CASEQ     '1'           BLDBRW
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F18 - Read next linked enquiry subfile record
     C     @INKS         CASEQ     '1'           CANC@P
      *
      * F21 - Redisplay enquiry screen
     C     @INKV         CASEQ     '1'           REDISP
      *
      * Validate input to Primary screen
     C                   CAS                     VAL@P
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@P  - VALIDATE INPUT TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     VAL@P         BEGSR
      *
      * Retrieve Payment details
      *
      * If called from SWIFT enquiry,
     C     @SWIFT        IFEQ      'Y'
     C                   Eval      @RCRM = *Zero                                              210657
     C                   Eval      @RCUS = *Blanks                                            210657
      * blank out SPREF and move message ref. to DS PHEAD
     C                   MOVEL     *BLANKS       SPREF
     C/COPY WNCPYSRC,FTOPA1SC23
     C                   MOVEL     XPREF         MSGREF
     C                   Z-ADD     REFMSG        PHMSGR
     C                   Z-ADD     REFPRT        PHPART
     C                   MOVEL     *BLANKS       PHMIR
     C                   MOVEL     *BLANKS       PHMOR
      * set up the detail screen fields from swift message
     C/COPY WNCPYSRC,FTOPA1SC24
     C                   EXSR      EISWFT
     C/COPY WNCPYSRC,FTOPA1SC25
      * set off switch to prevent message details from being re-read
     C                   MOVE      'N'           @SWIFT
     C                   ELSE
      *
     C     SACTION       IFEQ      'I'                                                        262930
     C                   Z-ADD     0             SHMSGR                                     BUG24227
     C                   Z-ADD     0             SHPART                                     BUG24227
     C                   ENDIF                                                                262930
      * Clear if for manual payment                                                           210657
     C                   IF        OTOPMSGR = 0 and REFMSG = 0                                210657
     C                   Eval      @RCRM = *Zero                                              210657
     C                   Eval      @RCUS = *Blanks                                            210657
     C                   Endif                                                                210657
      *                                                                                     MD029067
     C                   IF        SACTION <> 'I'                                           MD029067
     C                   MOVEL     ' '           PRflag                                     MD029067
     C                   EndIf                                                              MD029067
      *                                                                                     MD029067
     C**********         IF        PRflag <> 'Y'                                       242102 261152
     C                   IF        PRflag <> 'Y' or                                           261152
     C                             SPREF <> IPREF and                                         261152
     C                             SPREF <> *Blanks and                                       261152
     C                             SACTION = 'I'                                              261152
     C                   EXSR      RTVPMT
      *                                                                                       214320
     C     @RTCDE        IFEQ      '*IN USE'                                                  214320
     C                   MOVEL     '*ANY'        FldNameArr(1)                                214320
     C                   MOVEL     'MMM1021'     MsgIdArr(1)                                  214320
     C                   END                                                                  214320
     C                   END                                                                  242102
      *                                                                                       214320
     C                   END
      *
      * If primary fields are NOT OK
      * Re-output screen with error messages on it
      *
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C     OKBRCA        OREQ      'N'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Set field status on PRIMARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *                                                                                       219718
     C*****SACTION       IFEQ      'A'                                               219718 BUG25902
     C*****SPREF         ANDEQ     @PSPREF                                           219718 BUG25902
     C*****@PSPYST       ANDEQ     *BLANKS                                           219718 BUG25902
     C**********         MOVE      *BLANKS       @PSPREF                             219718 BUG25902
     C**********         ENDIF                                                       219718 BUG25902
      *                                                                                       219718
      *
      * If action code is delete, or enquire
      * or action code is amend and payment ref has changed
      *   Put the transaction on the main details screen
      *
     C     SACTION       IFEQ      'D'
     C     SACTION       OREQ      'E'
     C     SACTION       OREQ      'A'
     C     SPREF         ANDNE     @PSPREF
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
     C                   Z-ADD     OPMSGR        SHMSGR                                       262930
     C                   Z-ADD     OPKPRT        SHPART                                       262930
     C                   END
      *
      * If payment ref or screen control indicators have changed
      *   Re-output screen
      *
     C     SPREF         IFNE      @PSPREF
     C     SACTION       ANDNE     'I'
     C     @CCI@M        ORNE      @PCI@M
     C     SACTION       ANDNE     'I'
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Prior to validation, initialize error indicators as 'OK'
      * clear Payment in File Format,
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx_PVAL         3 0
     C                   MOVE      *ALL'Y'       FTEOPY1
     C
     C     SACTION       IFEQ      'I'
     C                   CLEAR                   NwPtFilFmt
     C                   CLEAR                   NwPtFilFmX                     CFT014
     C                   IF        (REFMSG<>0 or REFPRT<>0)                                   CFT039
     C                   Eval      svOPORBT  =   OTOPORBT                                     CFT039
     C                   Eval      svOPORB1  =   OTOPORB1                                     CFT039
     C                   Eval      svOPORB2  =   OTOPORB2                                     CFT039
     C                   Eval      svOPORB3  =   OTOPORB3                                     CFT039
     C                   Eval      svOPORB4  =   OTOPORB4                                     CFT039
     C                   Eval      svOPORB5  =   OTOPORB5                                     CFT039
     C                   ENDIF                                                                CFT039
      *                                                                                       226915
      * Initialize SWIFT Message reference and part.                                          226915
     C                   Z-ADD     PHMSGR        SHMSGR                                       226915
     C                   Z-ADD     PHPART        SHPART                                       226915
     C**********         END                                                                  227538
      *                                                                                       196813
      ** Outgoing message unique number should not be cleared. Reinstated                     196813
      ** OTOPMSGR and OTOPKPRT.                                                               196813
      *                                                                                       196813
     C                   Z-ADD     PHMSGR        OTOPMSGR                                     196813
     C                   Z-ADD     PHPART        OTOPKPRT                                     196813
      *                                                                                       227538
     C                   MOVEL(P)  JFOPORBT      OTOPORBT                                     227538
     C                   MOVEL(P)  JFOPORB1      OTOPORB1                                     227538
     C                   MOVEL(P)  JFOPORB2      OTOPORB2                                     227538
     C                   MOVEL(P)  JFOPORB3      OTOPORB3                                     227538
     C                   MOVEL(P)  JFOPORB4      OTOPORB4                                     227538
     C                   MOVEL(P)  JFOPORB5      OTOPORB5                                     227538
      *                                                                                       CFT039
     C                   IF        (REFMSG<>0 or REFPRT<>0)                                   CFT039
     C                   EVAL      OTOPORBT  =   svOPORBT                                     CFT039
     C                   EVAL      OTOPORB1  =   svOPORB1                                     CFT039
     C                   EVAL      OTOPORB2  =   svOPORB2                                     CFT039
     C                   EVAL      OTOPORB3  =   svOPORB3                                     CFT039
     C                   EVAL      OTOPORB4  =   svOPORB4                                     CFT039
     C                   EVAL      OTOPORB5  =   svOPORB5                                     CFT039
     C                   ENDIF                                                                CFT039
      *                                                                                       CFT039
     C                   ENDIF                                                                227538
      *
      *----------------------------------------------------------------
      * IF DELETE
      *
     C     SACTION       IFEQ      'D'
      *
     C                   GOTO      EndVAL@P
     C                   END
      **********                                                                       256919 262930
     C**********         If        OTOPMSGR > 0                                        256919 262930
     C**********         Movel     WOTOPORBT     OTOPORBT                              256919 262930
     C**********         Movel     WOTOPORB1     OTOPORB1                              256919 262930
     C**********         Movel     WOTOPORB2     OTOPORB2                              256919 262930
     C**********         Movel     WOTOPORB3     OTOPORB3                              256919 262930
     C**********         Movel     WOTOPORB4     OTOPORB4                              256919 262930
     C**********         Movel     WOTOPORB5     OTOPORB5                              256919 262930
     C**********         Endif                                                         256919 262930
      *                                                                                     MD022446
     C                   If        OTOPMSGR > 0                                             MD022446
     C                   Movel     WOTOPORBT     OTOPORBT                                   MD022446
     C                   Movel     WOTOPORB1     OTOPORB1                                   MD022446
     C                   Movel     WOTOPORB2     OTOPORB2                                   MD022446
     C                   Movel     WOTOPORB3     OTOPORB3                                   MD022446
     C                   Movel     WOTOPORB4     OTOPORB4                                   MD022446
     C                   Movel     WOTOPORB5     OTOPORB5                                   MD022446
     C                   Endif                                                              MD022446
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     SACTION       IFEQ      'E'
     C/COPY WNCPYSRC,FTOPA1SC01
      *
      * If windows processing on, call window routine
      * IF BROWSE OUTSTANDING, READ NEXT BROWSE SUBFILE RECORD
      * Else go to Secondary details screen
      *
     C     BGWDPR        IFEQ      'Y'
     C     CER031        ANDEQ     'N'                                                      BUG23047
     C                   MOVEL     'W'           @SCRN
     C                   ELSE
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE

      * If level joiner is on, go to Secondary details, otherwise
      * confirm level 1 details

     C     BTLVJN        IFEQ      'Y'
     C     CER031        OREQ      'Y'                                                      BUG23047
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
     C                   END
     C                   END
     C/COPY WNCPYSRC,FTOPA1SC02
      *
     C                   GOTO      EndVAL@P
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'

     C                   Z-ADD     *ZERO         Idx
     C                   Z-ADD     *ZERO         WIdx
     C                   MOVE      *ALL'Y'       FTEOPY1
      * IF AMEND
      *
     C     SACTION       IFEQ      'A'
      *
      * Validate whether non-amenable fields have been changed
      *
     C                   CALLB     'FTOPAYAMD'
      *
      * INPUTS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * New Payment in Screen Format
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
      *
      * Current Payment in Screen Format
     C                   PARM                    CurPmtScn1
     C                   PARM                    CurPmtSc2a
     C                   PARM                    CurPmtSc2b
     C                   PARM                    CurPmtScn3
     C                   PARM                    CurPmtSc1b                     CFT014
     C                   PARM                    CurPmtSc3b                     CFT014
     C                   PARM                    CurPmtScn4                     CFT014
     C                   PARM                    CurPmtScn5                     CFT014
      *
      * Current Deal in file format
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014
      *
      * OUTPUTS
      *
      * Field OK flags (DS) from/to caller
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
     C                   PARM                    FTEOPY4                        CFT014
     C                   PARM                    FTEOPY5                        CFT014
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
     C                   PARM                    @@AMOK            1
      *
      * Reset of Fields in Error Required (Y/N)
     C                   PARM      'Y'           @@RSTE            1
     C                   END
      *
     C/COPY WNCPYSRC,FTOPA1SC26
     C/COPY OFCPYSRCZ,CFT148_011                                                              CFT148
      *
      * Validate Primary Payment details
      *
     C                   CALLB     'FTOPAY1VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :

      * Response mode
     C                   PARM                    RespMode

      ** Payment Primary Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    PrvPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    PrvPmtSc1b                     CFT014
     C                   PARM      FRNT          FrontOffice      20            CPB002
     C                   PARM                    NEWPMTSCN4                     CFT009
     C                   PARM                    TranInfoFlds                                 CFT039
      * Custom Extra Data file data
     C                   PARM                    ExtData
     C/COPY WNCPYSRC,FTOPA1SC18

      * OUTPUTS :

      ** Payment Primary Details OK inds
     C                   PARM                    FTEOPY1
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
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
     C/COPY WNCPYSRC,FTOPA1SC30
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
     C                   PARM      *BLANKS       InputUser                                  MD050574
                                                                                              257361
     C/COPY WNCPYSRC,FTOPA1SC13

      *
      * If errors returned
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@P
     C                   END
      *
      * if there are warnings which have not been displayed
      * re-output the screen

     C                   Eval      Widx_PVAL = Widx_PVAL + Widx
     C     WIdx_PVAL     IFNE      PrvN_Warn
     C     NewPmtScn1    ORNE      PrvPmtScn1                                                 206893
     C     WIdx_PVAL     ANDEQ     PrvN_Warn                                                  206893
     C     WIdx_PVAL     ANDNE     0                                                          206893
     C     NewPmtSc1b    ORNE      PrvPmtSc1b                                                 206893
     C     WIdx_PVAL     ANDEQ     PrvN_Warn                                                  206893
     C     WIdx_PVAL     ANDNE     0                                                          206893
     C                   GOTO      EndVAL@P
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,FTOPA1SC03
      *
      * If windows processing on, call window routine, otherwise
      * Go to Secondary details screen
      *
     C     BGWDPR        IFEQ      'Y'
     C     CER031        ANDEQ     'N'                                                      BUG23047
     C                   MOVEL     'W'           @SCRN
     C                   ELSE

      * If level joiner is on, go to Secondary details, otherwise
      * confirm level 1 details

     C     BTLVJN        IFEQ      'Y'
     C     CER031        OREQ      'Y'                                                      BUG23047
     C                   MOVEL     'S'           @SCRN
     C                   ELSE
     C                   MOVEL     'C'           @SCRN
     C                   END
     C                   END
     C/COPY WNCPYSRC,FTOPA1SC04
      *
     C                   END
      *
     C     EndVAL@P      ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@S - PROCESS SECOND SCREEN
      *****************************************************************
     C     SCRN@S        BEGSR

      * Update 'previous' screens and previous number of warnings

     C***********        MOVEL     NewPmtScn1    PrvPmtScn1                     CFT014
     C                   MOVEL     NewPmtSc2a    PrvPmtSc2a
     C                   MOVEL     NewPmtSc2b    PrvPmtSc2b
     C                   Z-ADD     WIdx_SVAL     PrvN_Warn         3 0
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKG                          CFT018
     C                   Move      '0'           @INKH                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKP                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
     C                   Move      '0'           @INKS                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
      **  and no errors have occurred in validation                             CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
     C     Idx           orne      0                                            CFT018
      *
      ** WRITE/READ DISPLAY SCREEN - Secondary Details
      *
     C                   CALLB     'FTOPAY2DP'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS :
      * Return code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary / Secondary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
      * Status
     C                   PARM                    DDSTAT
      *
      * Fields in error
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
      *
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      * ENABLED Key fields (not enabled from level one maintenance)
     C                   PARM      'N'           @EKYFD            1
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS (not enabled from level one maintenance)
     C                   PARM                    @EINKD                         CFT007
     C                   PARM      'N'           @EINKG            1
     C                   PARM      'N'           @EINKH            1
     C                   PARM      'N'           @EINKP            1
     C                   PARM                    @EINKQ            1            CFT007
     C                   PARM      'N'           @EINKS            1
      *
      * SUCCESFUL INSERT PAYMENT
     C                   PARM                    @SITR            15
      *
      * OUTPUT PARAMETERS :
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1             CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ             1             CFT007
     C                   PARM      '0'           @INKS             1

      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
                                                                                CFT007
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc         5 0          CFT007
      *                                                                         CFT018
     C                   Endif                                                  CFT018
      *
      * RESET ERRORS ....
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F12 - Cancel on Secondary Screen
     C     @INKL         CASEQ     '1'           CANC@S
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
      *
      * Validate Input to Secondary Screen
     C                   CAS                     VAL@S
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@S  - VALIDATE INPUT TO SECONDARY SCREEN
      *****************************************************************
     C     VAL@S         BEGSR
      *
      * IF ENQUIRE
      *
     C     SACTION       IFEQ      'E'
     C/COPY WNCPYSRC,FTOPA1SC05
      *
      * Go to Other details screen
      *
     C***********        MOVEL     'O'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
     C/COPY WNCPYSRC,FTOPA1SC06
      *
     C                   GOTO      EndVAL@S
     C                   END
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
                                                                                CFT014
      ** Find out if there is a MT103 bilateral agreement exists between        CFT014
      ** the booking branch and the receiver only when CFT014 is setup.         CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      @MT103 = *Blank                              CFT014
     C                   ExSr      SrBMT103                                     CFT014
     C                   EndIf                                                  CFT014
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   Z-ADD     *ZERO         WIdx_SVAL
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
      *
      * Validate Secondary Screen details
      *
     C                   CALLB     'FTOPAY2VL'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary & Secondary Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtScn3                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData

      * OUTPUTS :
      ** Payment Primary Details OK inds
     C                   PARM                    FTEOPY2
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
      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      ***Saved*default*charges*******************************************              CFT009 222373
     C*****              PARM                    DEFVALID                              CFT009 222373
     C*****              PARM                    DEFVALIDX                             CFT009 222373

      *
      * If errors returned
      *
     C     Idx           IFNE      0
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Re-output the screen
      *
     C                   Eval      Widx_SVAL = Widx_SVAL + Widx
     C     WIdx_SVAL     IFNE      PrvN_Warn
     C     NewPmtSc2a    ORNE      PrvPmtSc2a                                   CFT004
     C     WIdx_SVAL     ANDEQ     PrvN_Warn                                    CFT004
     C     WIdx_SVAL     ANDNE     0                                            CFT004
     C     NewPmtSc2b    ORNE      PrvPmtSc2b                                   CFT014
     C     WIdx_SVAL     ANDEQ     PrvN_Warn                                    CFT014
     C     WIdx_SVAL     ANDNE     0                                            CFT014
     C                   GOTO      EndVAL@S
     C                   END
      *
      * Clear any warning messages
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * Level 2 details now set up so  so disable F16 key
     C                   MOVE      'Y'           Level2Dtl

     C/COPY WNCPYSRC,FTOPA1SC07
      **Go*to*Charges*&*Commissions*screen*****************************         CFT014
      *
      ** Goto Third screen                                                      CFT014
                                                                                CFT014
     C***********        MOVEL     'O'           @SCRN                          CFT014
     C                   Movel     'B'           @SCRN                          CFT014
     C/COPY WNCPYSRC,FTOPA1SC08
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@S      ENDSR

      *****************************************************************         CFT014
      /Title Sr/SrBMT103                                                        CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrBMT103   - Check MT103 agreement                         *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@S subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      * AOCUSTR0  - Access Object to get customer details             *         CFT014
      * AOBRCHR0  - Access Object to get branch details               *         CFT014
      * ME1730    - Determines whether an MT103 exists                *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrBMT103      BegSr                                                  CFT014
                                                                                CFT014
     C                   Eval      PSNBRC = *Blank                              CFT014
     C                   Eval      PSBICA = *Blank                              CFT014
     C                   Eval      PSWIFT = *Blank                              CFT014
     C                   Eval      PORDBK = *Blank                              CFT014
     C                   Eval      PORTCD = *Blank                              CFT014
     C                   Eval      WSWIFT = *Blank                              CFT014
     C                   Eval      WCNUM = *Blank                               CFT014
                                                                                CFT014
      ** Get SWIFT-BIC of destination                                           CFT014
                                                                                CFT014
     C                   If        @DSTT = 'S'                                  CFT014
     C     11            SubSt     SDST1:1       WSWIFT           11            CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Destination type is a full nostro 'F', customer number 'C'             CFT014
      ** retail account 'R' or GL account 'G', get SWIFT ID through             CFT014
      ** customer number                                                        CFT014
                                                                                CFT014
     C                   If        (@DSTT = 'F') Or (@DSTT = 'C') Or            CFT014
     C                             (@DSTT = 'R') Or (@DSTT = 'G')               CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
     C                   When      @DSTT = 'F'                                  CFT014
     C     3             SubSt     SDST1:1       @CYCD                          CFT014
     C     2             SubSt     SDST1:4       @NONB                          CFT014
     C                   Call      'AONOSTR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      *Blanks       @CUST                          CFT014
     C                   Parm                    @CYCD                          CFT014
     C**********         Parm      *Blanks       @ACCD                                 CFT014 CGL029
     C                   PARM      *BLANKS       PACCD                                        CGL029
     C                   Parm      *Blanks       @ACSN                          CFT014
     C                   Parm                    @NONB                          CFT014
     C                   Parm      *Blanks       @BRCD                          CFT014
     C                   Parm      *Blanks       @CSSN                          CFT014
     C                   Parm      *Blanks       @PNOI                          CFT014
     C     SDNOST        Parm      SDNOST        DSFDY                          CFT014
                                                                                CFT014
      ** Error on call                                                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks                             CFT014
     C                   Movel     'SDNOSTPD'    DBFILE                         CFT014
     C                   Movel     '081'         DBASE                          CFT014
     C                   Movel     @CYCD         WKEY              5            CFT014
     C                   Move      @NONB         WKEY                           CFT014
     C                   Movel     WKEY          DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     A7CUST        WCNUM            10            CFT014
                                                                                CFT014
     C                   When      @DSTT = 'R'                                                240813
                                                                                              240813
     C     10            SubSt     SDST1:1       WCNUM                                        240813
     C                   MOVE      WCNUM         ACNUM            10 0                        240813
     C     ACNUM         CHAIN     ACCNTBF2                           80                      240813
     C                   MOVE      *BLANKS       WCNUM                                        240813
     C                   MOVEL     ACCNUM        WCNUM                                        240813
     C                   When      @DSTT = 'C'                                  CFT014
     C     10            SubSt     SDST1:1       WCNUM                          CFT014
                                                                                220110
     C                   When      @DSTT = 'R'                                  220110
     C     6             SubSt     @DSTDS:1      WCNUM                          220110
                                                                                CFT014
     C                   Other                                                  CFT014
     C     6             SubSt     SDST1:1       WCNUM                          CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
      ** Access customer's file to get SWIFT id                                 CFT014
                                                                                CFT014
     C                   Call      'AOCUSTR0'                                   CFT014
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      WCNUM         @KEY1            10            CFT014
     C                   Parm      *Blanks       @KYST             7            CFT014
     C     SDCUST        Parm      SDCUST        DSSDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blank                               CFT014
     C                   If        BBCSID <> *Blank                             CFT014
     C                   Movel     BBCSID        WSWIFT                         CFT014
     C                   EndIf                                                  CFT014
     C                   Else                                                   CFT014
     C                   Movel     'SDCUSTPD'    DBFILE                         CFT014
     C                   Movel     '082'         DBASE                          CFT014
     C                   Movel     WCNUM         DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If CSW203 is installed, ME1730 will not be called. Default                           CSW203
      ** @MT103 TO 'Y'                                                                        CSW203
                                                                                              CSW203
     C                   IF        CSW203 = 'Y'                                               CSW203
     C                   EVAL      @MT103 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
                                                                                              CSW203
      ** Setup parameter to ME1730                                              CFT014
                                                                                CFT014
     C                   If        WSWIFT <> *Blank                             CFT014
     C                   Movel     SBRCA         PSNBRC                         CFT014
     C**********         Call      'AOBRCHR0'                                          CFT014 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   Parm      *Blanks       @RTCD                          CFT014
     C                   Parm      '*KEY   '     @OPTN                          CFT014
     C                   Parm      SBRCA         @BRCD                          CFT014
     C*****SDBRCH        Parm      SDBRCH        DSFDY                                 CFT014 CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
                                                                                CFT014
     C                   If        @RTCD <> *Blank                              CFT014
     C                   Movel     'SDBRCHPD'    DBFILE                         CFT014
     C                   Movel     '083'         DBASE                          CFT014
     C                   Movel     SBRCA         DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   Movel     A8BTID        PSBICA                         CFT014
     C                   Movel     WSWIFT        PSWIFT                         CFT014
     C                   Movel     SORBK         PORDBK                         CFT014
                                                                                CFT014
      ** Call ME1730                                                            CFT014
                                                                                CFT014
     C                   Call      'ME1730'                                     CFT014
     C                   Parm                    PSNBRC            3            CFT014
     C                   Parm                    PSBICA           11            CFT014
     C                   Parm                    PSWIFT           11            CFT014
     C                   Parm                    PORDBK          256            CFT014
     C                   Parm                    PBBINF          256            CFT014
     C                   Parm                    PSNCOR          256            CFT014
     C                   Parm                    PRCCOR          256            CFT014
     C                   Parm                    PORTCD            7            CFT014
                                                                                CFT014
     C                   If        PORTCD = '*ERROR '                           CFT014
     C                   Movel     'ME1730'      DBFILE                         CFT014
     C                   Movel     '084'         DBASE                          CFT014
     C                   Movel     '*CALL   '    DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   If        PORTCD = '*CRT103'                           CFT014
     C                   Move      'Y'           @MT103                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                              CSW203
     C                   ENDIF                                                                CSW203
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SCRN@B                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SCRN@B     - Process Third Screen fields                   *         CFT014
      *                                                               *         CFT014
      * Called By: Main processing                                    *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SCRN@B        BegSr                                                  CFT014
                                                                                CFT014
      ** Update 'previous' screens and previous number of warnings              CFT014
                                                                                CFT014
     C                   MOVEL     NewPmtScn3    PrvPmtScn3                     CFT014
     C                   MOVEL     NewPmtSc3b    PrvPmtSc3b                     CFT014
     C                   Z-ADD     WIdx_BVAL     PrvN_Warn                      CFT014
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
      **  and no errors have occurred in validation                             CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
     C     Idx           orne      0                                            CFT018
                                                                                CFT014
      ** Write/Read display screen                                              CFT014
                                                                                CFT014
     C                   Callb     'FTOPAY3DP'                                  CFT014
     C                   Parm      *BLANK        RetCodeOut                     CFT014
     C                   Parm                    NewPmtScn1                     CFT014
     C                   Parm                    NewPmtScn3                     CFT014
     C                   Parm                    NewPmtSc1b                     CFT014
     C                   Parm                    NewPmtSc3b                     CFT014
     C                   Parm                    DDSTAT                         CFT014
     C                   Parm                    FTEOPY1                        CFT014
     C                   Parm                    FTEOPY2                        CFT014
     C                   Parm                    FTEOPY3                        CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIdArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIdArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm      'N'           @EKYFD                         CFT014
     C                   Parm                    @EDTFD                         CFT014
     C                   Parm      'N'           @EINKD                         CFT014
     C                   Parm      'N'           @EINKQ                         CFT014
     C                   Parm      '0'           @INKC                          CFT014
     C                   Parm      '0'           @INKD                          CFT014
     C                   Parm      '0'           @INKL                          CFT014
     C                   Parm      '0'           @INKQ                          CFT014
     C                   Parm      'N'           WriteOnly                      CFT014
     C                   Parm      0             CursorLoc                      CFT014
      *                                                                         CFT018
     C                   Endif                                                  CFT018
                                                                                CFT014
      ** Reset errors                                                           CFT014
                                                                                CFT014
     C                   Move      *All'Y'       FTEOPY1                        CFT014
     C                   Move      *All'Y'       FTEOPY2                        CFT014
     C                   Move      *All'Y'       FTEOPY3                        CFT014
     C                   Movel     *Blank        FldNameArr                     CFT014
     C                   Movel     *Blank        MsgIdArr                       CFT014
     C                   Movel     *Blank        MsgDtaArr                      CFT014
     C                   Movel     *Blank        WFldNamArr                     CFT014
     C                   Movel     *Blank        WMsgIdArr                      CFT014
     C                   Movel     *Blank        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** F3 - End Program                                                       CFT014
                                                                                CFT014
     C     @INKC         CasEq     '1'           ENDP                           CFT014
                                                                                CFT014
      ** F4 - BIC in-line prompt                                                CFT014
                                                                                CFT014
     C     @INKD         CasEq     '1'           BICPrompt                      CFT014
                                                                                CFT014
      ** F12 - Cancel on Secondary Screen                                       CFT014
                                                                                CFT014
     C     @INKL         CasEq     '1'           CANC@B                         CFT014
                                                                                CFT014
      ** F16 - BIC in-line search                                               CFT014
                                                                                CFT014
     C     @INKQ         CasEq     '1'           BICPrompt                      CFT014
                                                                                CFT014
      ** Validate Input to Secondary Screen                                     CFT014
                                                                                CFT014
     C                   Cas                     VAL@B                          CFT014
                                                                                CFT014
     C                   EndCs                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/VAL@B                                                           CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/VAL@B      - Validate Input to Third Screen                *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@B Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     VAL@B         BegSr                                                  CFT014
                                                                                CFT014
      ** If enquire                                                             CFT014
                                                                                CFT014
     C     SACTION       IfEq      'E'                                          CFT014
                                                                                CFT014
      ** Go to Other details screen                                             CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If insert or amend                                                     CFT014
                                                                                CFT014
     C     SACTION       IfEq      'I'                                          CFT014
     C     SACTION       OrEq      'A'                                          CFT014
                                                                                CFT014
      ** Prior to validation, initialize error indicators as 'OK'               CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         Idx                            CFT014
     C                   Z-Add     *Zero         WIdx                           CFT014
     C                   Z-Add     *Zero         WIdx_BVAL                      CFT014
     C                   Move      *ALL'Y'       FTEOPY1                        CFT014
     C                   Move      *ALL'Y'       FTEOPY2                        CFT014
     C                   Move      *ALL'Y'       FTEOPY3                        CFT014
                                                                                CFT014
     C/COPY WNCPYSRC,FTOPA1SC33
      ** Validate Third Screen details                                          CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY3VL'                                  CFT014
     C                   PARM                    RespMode                       CFT014
     C                   PARM                    NewPmtScn1                     CFT014
     C                   PARM                    NewPmtSc2a                     CFT014
     C                   PARM                    NewPmtSc2b                     CFT014
     C                   PARM                    NewPmtScn3                     CFT014
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    ExtData                        CFT014
     C                   PARM                    FTEOPY3                        CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIDArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
     C                   PARM                    Idx                            CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIDArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
     C                   PARM                    WIdx                           CFT014
     C                   PARM                    NwPtFilFmt                     CFT014
     C                   PARM                    NwPtFilFmX                     CFT014
     C                   PARM                    Val@Fields                     CFT014
     C                   PARM      *BLANKS       InputUser                                  MD050574
                                                                                CFT014
      ** If errors returned                                                     CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Re-output the screen                                                   CFT014
                                                                                CFT014
     C                   Eval      Widx_BVAL = Widx_BVAL + Widx                 CFT014
     C     WIdx_BVAL     IfNe      PrvN_Warn                                    CFT014
     C     NewPmtScn3    OrNe      PrvPmtScn3                                   CFT014
     C     WIdx_BVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_BVAL     AndNe     0                                            CFT014
     C     NewPmtSc3b    OrNe      PrvPmtSc3b                                   CFT014
     C     WIdx_BVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_BVAL     AndNe     0                                            CFT014
     C                   Goto      EndVAL@B                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Clear any warning messages                                             CFT014
                                                                                CFT014
     C                   Move      *ALL'Y'       FTEOPY1                        CFT014
     C                   Move      *ALL'Y'       FTEOPY2                        CFT014
     C                   Move      *ALL'Y'       FTEOPY3                        CFT014
     C                   Movel     *BLANK        WFldNamArr                     CFT014
     C                   Movel     *BLANK        WMsgIdArr                      CFT014
     C                   Movel     *BLANK        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** Go to Charges & Commissions screen                                     CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C     EndVAL@B      EndSr                                                  CFT014
                                                                                CFT014

      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@O - PROCESS CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     SCRN@O        BEGSR

      * IF INSERT
      * DO DEFAULTING FOR CHARGES & COMMISSIONS SCREEN
      * (Only do this once per transaction unless details on other screens
      *  have changed)
      *
     C*****SACTION       IFEQ      'I'                                          CFT014
     C*****NewPmtScn1    IFNE      PrvPmtScn1                                   CFT014
     C*****NewPmtSc2a    ORNE      PrvPmtSc2a                                   CFT014
     C*****NewPmtSc2b    ORNE      PrvPmtSc2b                                   CFT014
     C***********        EXSR      DFT@O                                        CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
      *
      * IF AMEND OR ENQUIRE
      * Do charges and VAT calculations only if first time through
      * for transaction.
     C*****SACTION       IFNE      'I'                                          CFT014
     C*****SPREF         IFNE      #SPREF                                       CFT014
     C***********        EXSR      DFT@O                                        CFT014
     C***********        MOVE      SPREF         #SPREF           15            CFT014
     C***********        END                                                    CFT014
     C***********        END                                                    CFT014
                                                                                CFT014
      *                                                                                       CER030
      ** F19 - Margin Information /Extended Narratives                                        CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y')                                             CER030
     C                   EVAL      @EINKT = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
      *                                                                                       CER030
      ** Setup F19 Key for Margin Information when Analytical Accoun -          CFT014
      ** ting is On.                                                            CFT014
                                                                                CFT014
     C                   If        BGN0ST = 'Y'                                 CFT014
     C                   Select                                                 CFT014
     C                   When      SACTION = 'E'                                CFT014
     C                   Eval      @EINKT = 'Y'                                 CFT014
                                                                                CFT014
      ** Margin Info will not be available during insert or amend when          CFT014
      ** payment and settlement currency are equal and the margin               CFT014
      ** info details are blanks.                                               CFT014
                                                                                CFT014
     C                   When      (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   If        (SPCCY = SSMCY) And (SMBSI = *Blank) And     CFT014
     C                             (SMSIG = *Blank)                             CFT014
     C                   Eval      @EINKT = 'N'                                 CFT014
     C                   Else                                                   CFT014
     C                   Eval      @EINKT = 'Y'                                 CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                                       CER030
     C                   ENDIF                                                                CER030

      * Update 'previous' screens and previous number of warnings

     C                   MOVEL     NewPmtScn1    PrvPmtScn1
     C                   MOVEL     NewPmtSc1b    PrvPmtSc1b                     CFT014
     C                   MOVEL     NewPmtSc2a    PrvPmtSc2a
     C                   MOVEL     NewPmtSc2b    PrvPmtSc2b
     C                   MOVEL     NewPmtScn3    PrvPmtScn3
     C                   MOVEL     NewPmtSc3b    PrvPmtSc3b                     CFT014
     C                   MOVEL     NewPmtScn4    PrvPmtScn4                     CFT014
     C                   Z-ADD     WIdx_OVAL     PrvN_Warn         3 0
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
     C                   Move      '0'           @INKT                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
      **  and no errors have occurred in validation                             CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
     C     Idx           orne      0                                            CFT018

      ** WRITE/READ DISPLAY - Charges Commissions Screen
      *
     C***********        CALLB     'FTOPAY3DP'                                  CFT014
     C                   CALLB     'FTOPAY4DP'                                  CFT014
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUT PARAMETERS:
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      * Payment (IN SCREEN FORMAT) - Primary/Secondary/Other Details
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc3b
     C                   PARM                    NewPmtScn4
      *
      * Status
     C                   PARM                    DDSTAT
      *
      * Fields in error
     C                   PARM                    FTEOPY1
     C                   PARM                    FTEOPY2
     C                   PARM                    FTEOPY3
     C                   PARM                    FTEOPY4                        CFT014
      * Errors
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Warnings
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED DETAIL FIELDS
     C                   PARM                    @EKYFD            1
     C                   PARM                    @EDTFD            1
      * ENABLED FUNCTION KEYS                                                   CFT007
      * KD = COMMAND KEYS 04/16 = BIC IN-LINE PROMPT/SEARCH                     CFT007
      ** KT = Command key 19                                                    CFT014
                                                                                CFT014
     C**********         PARM                    @EINKD                                CFT007 CFT014
     C**********         PARM                    @EINKQ                                CFT007 CFT014
     C                   PARM      'N'           @EINKD                                       CFT014
     C                   PARM      'N'           @EINKQ                                       CFT014
     C                   PARM                    @EINKT            1                          CFT014

      ** OUTPUT PARAMETERS :
      * Function Keys
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD             1            CFT007
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKQ             1            CFT007
     C                   PARM      '0'           @INKT             1            CFT014
      * Write screen with no read indicator
     C                   PARM      'N'           WriteOnly         1
      *                                                                         CFT007
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc                      CFT007
      *
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
      *                                                                         CFT018
     C                   ENDIF                                                  CFT018

      * RESET ERRORS ....
      *
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * F3 - End Program
     C     @INKC         CASEQ     '1'           ENDP
      *                                                                         CFT007
      * F4 - BIC in-line prompt                                                 CFT007
     C     @INKD         CASEQ     '1'           BICPrompt                      CFT007
      *
      * F12 - Cancel on Other Details Screen
     C     @INKL         CASEQ     '1'           CANC@O
      *                                                                         CFT007
      * F16 - BIC in-line search                                                CFT007
     C     @INKQ         CASEQ     '1'           BICPrompt                      CFT007
                                                                                CFT014
      ** F19 - Margin Information                                               CFT014
                                                                                CFT014
     C     @INKT         CASEQ     '1'           SCRN@M                         CFT014
      *
      * Validate Input to Charges & Comissions Screen
     C                   CAS                     VAL@O
      *
     C                   ENDCS
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DFT@O   - DEFAULTING FOR CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     DFT@O         BEGSR
      *
     C                   CALLB     'FTOPAY3DT'
      *
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary Details
      ** Payment Secondary Details
      ** Payment Charge & Commissions
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtScn4                     CFT014

      * Transaction information (DS) in file format
     C                   PARM                    CrPtFilFmt

      * Custom Extra Data file data
     C                   PARM                    ExtData
      *
      *  Funds transfer Details
     C                   Parm                    SDFTFR
      *                                                                                       187056
      ** Recalculation flag.                                                                  187056
     C                   PARM                    PReCalc           1                          187056

      * OUTPUTS :

      ** OK inds
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

      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *  Extra rate required for FTVCHPY module                                 CFT009
     C                   Parm                    O2XRTE                         CFT009

     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * VAL@O  - VALIDATE INPUT TO CHARGES & COMMISSIONS SCREEN
      *****************************************************************
     C     VAL@O         BEGSR
      *
      *
      *----------------------------------------------------------------
      * IF ENQUIRE
      *
     C     SACTION       IFEQ      'E'
     C/COPY WNCPYSRC,FTOPA1SC22
      * IL0036 - Review window processing for Insertion                                       233905
      *                                   for other mode except 'D'                           233905
     C                   IF        ULX043 = 'Y'                                               233905
     C                             AND  BTLVJN = 'Y'                                          233905
     C                             AND SACTION <> 'D'                                         233905
      *                                                                                       233905
      ** New Window processing, if F12 or F3                                                  233905
      ** Create a Blank Record without details using call to FT0045XL                         233905
      ** during Close of Business (No ext. details in this case)                              233905
      *                                                                                       233905
     C                   EXSR      WINDOWI                                                    233905
     C                   ENDIF                                                                233905
      *
      *     If Browse outstanding, read next Browse Subfile record
      *
                                                                                              CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      @SCRN = 'G'                                                CSW209
     C                   ELSE                                                                 CSW209
                                                                                              CSW209
   ??C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
      *
      * Else, if called from linked enquiry go back to calling program.
     C                   ELSE
     C     LinkedEnq     IFNE      *BLANKS
     C                   EXSR      CANC@P

      *     Else, Go To Initial screen
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
     C                   END
      *
     C                   GOTO      EndVAL@O
     C                   END
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
      *
      *----------------------------------------------------------------
      * IF INSERT OR AMEND
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
      *
      * Prior to validation, initialize error indicators as 'OK'
      *
     C                   Z-ADD     *ZERO         Idx               3 0
     C                   Z-ADD     *ZERO         WIdx              3 0
     C                   Z-ADD     *ZERO         WIdx_OVAL
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
      *                                                                                       187056
      ** Check if charges needs to be recalculated.                                           187056
      *                                                                                       187056
     C                   IF        @CFT009 = 'N'                                CFT009
     C                   EXSR      SRReCalc                                                   187056
     C                   ENDIF                                                  CFT009
      *
      * Validate "Charges & Comissions" Screen
      *
     C***********        CALLB     'FTOPAY3VL'                                  CFT014
     C                   CALLB     'FTOPAY4VL'                                  CFT014
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Response mode
     C                   PARM                    RespMode
      ** Payment Primary Details
      ** Payment Secondary Details
      ** Payment Charge & Commissions
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
      * Custom Extra Data file data
     C                   PARM                    ExtData
      *                                                                         CFT009
      ** Redisplay screen flag                                                  CFT009
     C                   PARM      'N'           WReDspChg                      CFT009
      *
      * OUTPUTS :

      ** Payment Charge & Commissions OK inds
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

      * Valid Payment layout (DS) from/to caller
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014
      *  Validation Work Fields from/to caller
     C                   PARM                    Val@Fields
      *                                                                         CFT009
      ** Saved default charges                                                  CFT009
     C                   PARM                    DEFVALID                       CFT009
     C                   PARM                    DEFVALIDX                      CFT009
      *                                                                         CFT009
      ** Charges to the debit of - field changed (Y or blank)                   CFT009
     C                   PARM                    PCDROCHG          1            CFT009
     C                   PARM      *BLANKS       InputUser                                  MD050574

      *
      * If errors returned
      *
     C*****Idx***********IFNE      0                                            CFT009
     C*******************GOTO      EndVAL@O                                     CFT009
     C*******************END                                                    CFT009
      *
      * If there are warnings which have not been displayed
      *   re-output the screen
      *
     C                   Eval      Widx_OVAL = Widx_OVAL + Widx
     C     WIdx_OVAL     IFNE      PrvN_Warn
     C*****NewPmtScn3    ORNE      PrvPmtScn3                                   CFT004 CFT014
     C     NewPmtScn4    ORNE      PrvPmtScn4                                   CFT014
     C     WIdx_OVAL     ANDEQ     PrvN_Warn                                    CFT004
     C     WIdx_OVAL     ANDNE     0                                            CFT004
     C     WReDspChg     ORNE      'N'                                                        187056
     C                   GOTO      EndVAL@O
     C                   END
      *
      * Clear any warning messages
      *
     C***********        MOVE      *ALL'Y'       FTEOPY3                        CFT014
      *                                                                         CFT009
      * Just set elements which are 'W' to 'Y' not those set as                 CFT009
      * 'N' as those are errors not warnings in FTEOPY4                         CFT009
      *                                                                         CFT009
     C*******************MOVE      *ALL'Y'       FTEOPY4                  CFT014CFT009
     C                   EVAL      *IN81 = *ON                                  CFT009
                                                                                CFT009
     C                   DOW       *IN81 = *ON                                  CFT009
     C     'W'           SCAN      FTEOPY4:1     @p                3 0    81    CFT009
                                                                                CFT009
     C     *IN81         IFEQ      *ON                                          CFT009
     C                   EVAL      %SUBST(FTEOPY4: @P: 1) = 'Y'                 CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   ENDDO                                                  CFT009
      *                                                                         CFT009
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *                                                                         CFT009
      * If any errors then re-display charges screen else                       CFT009
      * goto confirmation screen.                                               CFT009
      *                                                                         CFT009
     C     Idx           IFNE      0                                            CFT009
     C                   EVAL      WReDspChg = 'Y'                              CFT009
     C                   ELSE                                                   CFT009
      *                                                                                       CSW209
     C                   IF        CSW209 = 'Y'                                               CSW209
     C                   EVAL      @SCRN = 'G'                                                CSW209
     C                   ELSE                                                                 CSW209
      *
      ** If transaction type is not linked to transaction code                                CER030
      ** display screen                                                                       CER030
      *                                                                                       CER030
     C                   IF        (CER030 = 'Y') OR                                          CER030
     C                             (CGL013 = 'Y') OR                                          CER030
     C                             (CER031 = 'Y')                                             CER030
      *                                                                                       CER030
     C                   CALLB     'FTOPAY5VL'                                                CER030
     C                   PARM                    RespMode                                     CER030
     C                   PARM                    NewPmtScn1                                   CER030
     C                   PARM                    NewPmtScn5                                   CER030
      *                                                                                       CER030
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    STRTC                                        CER030
      *                                                                                       CER030
     C                   PARM                    ExtData                                      CER030
     C                   PARM                    FTEOPY5                                      CER030
     C                   PARM                    FldNameArr                                   CER030
     C                   PARM                    MsgIDArr                                     CER030
     C                   PARM                    MsgDtaArr                                    CER030
     C                   PARM                    Idx                                          CER030
     C                   PARM                    WFldNamArr                                   CER030
     C                   PARM                    WMsgIDArr                                    CER030
     C                   PARM                    WMsgDtaArr                                   CER030
     C                   PARM                    WIdx                                         CER030
     C                   PARM                    NwPtFilFmt                                   CER030
     C                   PARM                    Val@Fields                                   CER030
      *                                                                                       CER030
     C                   PARM                    O2TTCD                                       CER030
      *                                                                                       CER030
      ** Update error information.                                                            CER030
      *                                                                                       CER030
     C                   IF        Idx <> *ZEROS                                              CER030
      *                                                                                       CER030
     C                   MOVEL     'M'           @SCRN                                        CER030
      *                                                                                       CER030
     C     @SCRN         DOWEQ     'M'                                                        CER030
     C                   EXSR      SCRN@M                                                     CER030
     C                   ENDDO                                                                CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
     C                   MOVEL     'C'           @SCRN                                        CER030
      *                                                                                       CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** No validation required                                                               CER030
      *                                                                                       CER030
     C                   ELSE                                                                 CER030
      * Go To First screen for confirmation.
      *
     C                   MOVEL     'C'           @SCRN
     C/COPY WNCPYSRC,FTH00341
                                                                                              CSW209
     C                   ENDIF                                                                CSW209
                                                                                              CSW209
     C                   ENDIF                                                                CER030
     C                   ENDIF                                                  CFT009
      *
     C                   END
      *----------------------------------------------------------------
      *
     C     EndVAL@O      ENDSR
      *****************************************************************         CFT014
      /EJECT                                                                                  187056
      *****************************************************************                       187056
      *                                                               *                       187056
      *  SRReCalc - Perform recalculation of charges.                 *                       187056
      *                                                               *                       187056
      *****************************************************************                       187056
      *                                                                                       187056
     C     SRReCalc      BEGSR                                                                187056
      *                                                                                       187056
     C                   MOVE      *BLANKS       W0FCUS            6                          187056
     C                   MOVE      *BLANKS       W0SCUS            6                          187056
     C                   MOVE      'N'           WReDspChg         1                          187056
      *                                                                                       187056
      ** Perform the following only if core feature S01508                                    187056
      ** (BLI Extended Payment Charges) is installed and core                                 187056
      ** feature S01506 (BLI Payment Charges Enhancements)                                    187056
      ** is NOT installed.  Get "Charges to the Debit of"                                     187056
      ** Customer using FT0035 based on Level 2 details.                                      187056
      *                                                                                       187056
     C     @01508        IFEQ      'Y'                                                        187056
     C     @01506        ANDNE     'Y'                                                        187056
      *                                                                                       187056
      ** Get previous "Charges to the Debit of" Customer.                                     187056
      *                                                                                       187056
     C                   CLEAR                   P0DTA                                        187056
      *                                                                                       187056
     C     WPrvCDRT      IFNE      *BLANKS                                                    187056
     C                   MOVE      WPrvCDRT      WIPT1                                        187056
     C     @PSCDRO       CAT(P)    @PSCDBR       WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       @RTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG           256                          187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     @RTCD         ORNE      *BLANKS                                                    187056
     C                   MOVEL     '*CALL'       DBKEY                                        187056
     C                   MOVEL     'FT0035'      DBFILE                                       187056
     C                   Z-ADD     36            DBASE                                        187056
     C                   EXSR      *PSSR                                                      187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   MOVE      WOCUST        W0FCUS                                       187056
      *                                                                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
      ** Get new "Charges to the Debit of" Customer.                                          187056
      *                                                                                       187056
     C                   CLEAR                   P0DTA                                        187056
      *                                                                                       187056
     C     OTCDRT        IFNE      *BLANKS                                                    187056
     C                   MOVE      OTCDRT        WIPT1                                        187056
     C     SCDRO         CAT(P)    SCDBR         WIPTY1                                       187056
     C                   MOVE      BJCYCD        WICCY                                        187056
      *                                                                                       187056
     C                   CALL      'FT0035'                             9090                  187056
     C                   PARM      *BLANKS       @RTCD                                        187056
     C                   PARM                    P0DTA                                        187056
     C                   PARM                    P0MSG                                        187056
      *                                                                                       187056
     C     *IN90         IFEQ      *ON                                                        187056
     C     @RTCD         ORNE      *BLANKS                                                    187056
     C                   MOVEL     '*CALL'       DBKEY                                        187056
     C                   MOVEL     'FT0035'      DBFILE                                       187056
     C                   Z-ADD     37            DBASE                                        187056
     C                   EXSR      *PSSR                                                      187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   MOVE      WOCUST        W0SCUS                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
      ** Call defaulting program to recalculate charges.                                      187056
      *                                                                                       187056
     C     SCDRO         IFNE      @PSCDRO                                                    187056
     C     SCDBR         ORNE      @PSCDBR                                                    187056
     C     W0FCUS        ORNE      W0SCUS                                                     187056
     C                   EVAL      PReCalc = 'Y'                                              187056
     C                   EXSR      DFT@O                                                      187056
     C                   EVAL      PReCalc = 'N'                                              187056
     C                   EVAL      WPrvCDRT = OTCDRT                                          187056
     C                   EVAL      WReDspChg = 'Y'                                            187056
     C                   ENDIF                                                                187056
      *                                                                                       187056
     C                   ENDSR                                                                187056
      *                                                                                       187056
      *****************************************************************                       187056
      /Title Sr/SCRN@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SCRN@M     - Process Margin Information Screen             *         CFT014
      *                                                               *         CFT014
      * Called By: VAL@B Subroutine                                   *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SCRN@M        BegSr                                                  CFT014
                                                                                CFT014
      ** Update 'previous' screens and previous number of warnings              CFT014
                                                                                CFT014
     C                   Movel     NewPmtScn5    PrvPmtScn5                     CFT014
     C                   MOVEL     NewPmtScn5A   PrvPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   PrvPmtScn5B                                  CER030
     C                   Z-Add     WIdx_MVAL     PrvN_Warn                      CFT014
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKE                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
      **  and no errors have occurred in validation                             CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
     C     Idx           orne      0                                            CFT018
                                                                                CFT014
      ** Write/Read display screen                                              CFT014
                                                                                CFT014
     C                   Callb     'FTOPAY5DP'                                  CFT014
     C                   Parm      *BLANK        RetCodeOut                     CFT014
     C                   Parm                    NewPmtScn1                     CFT014
     C                   Parm                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   Parm                    DDSTAT                         CFT014
     C                   Parm                    FTEOPY5                        CFT014
     C                   Parm                    FldNameArr                     CFT014
     C                   Parm                    MsgIdArr                       CFT014
     C                   Parm                    MsgDtaArr                      CFT014
     C                   Parm                    WFldNamArr                     CFT014
     C                   Parm                    WMsgIdArr                      CFT014
     C                   Parm                    WMsgDtaArr                     CFT014
     C                   Parm      'N'           @EKYFD                         CFT014
     C                   Parm                    @EDTFD                         CFT014
     C                   Parm      '0'           @INKC                          CFT014
     C                   Parm      '0'           @INKL                          CFT014
     C                   Parm      '0'           @INKE             1            CFT014
     C                   Parm      'N'           WriteOnly                      CFT014
     C                   Parm      0             CursorLoc                      CFT014
     C                   PARM                    Val@Fields                                   222373
                                                                                CFT018
     C                   Endif                                                  CFT018
                                                                                CFT014
      ** Reset errors                                                           CFT014
                                                                                CFT014
     C                   Move      *All'Y'       FTEOPY5                        CFT014
     C                   Movel     *Blank        FldNameArr                     CFT014
     C                   Movel     *Blank        MsgIdArr                       CFT014
     C                   Movel     *Blank        MsgDtaArr                      CFT014
     C                   Movel     *Blank        WFldNamArr                     CFT014
     C                   Movel     *Blank        WMsgIdArr                      CFT014
     C                   Movel     *Blank        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** F3 - End Program                                                       CFT014
                                                                                CFT014
     C     @INKC         CasEq     '1'           ENDP                           CFT014
                                                                                CFT014
      ** F12 - Cancel on Margin Info Screen                                     CFT014
                                                                                CFT014
     C     @INKL         CasEq     '1'           CANC@M                         CFT014
                                                                                CFT014
      ** F5 - Refresh                                                           CFT014
                                                                                CFT014
     C     @INKE         CasEq     '1'           REFR@M                         CFT014
                                                                                CFT014
      ** Validate Input to Margin Info Screen                                   CFT014
                                                                                CFT014
     C                   Cas                     VAL@M                          CFT014
                                                                                CFT014
     C                   EndCs                                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/VAL@M                                                           CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/VAL@M      - Validate Margin Informations                  *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     VAL@M         BegSr                                                  CFT014
                                                                                CFT014
      ** If enquire                                                             CFT014
                                                                                CFT014
     C     SACTION       IfEq      'E'                                          CFT014
                                                                                CFT014
      ** Go to Other details screen                                             CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If insert or amend                                                     CFT014
                                                                                CFT014
     C     SACTION       IfEq      'I'                                          CFT014
     C     SACTION       OrEq      'A'                                          CFT014
                                                                                CFT014
      ** Prior to validation, initialize error indicators as 'OK'               CFT014
                                                                                CFT014
     C                   Z-Add     *Zero         Idx                            CFT014
     C                   Z-Add     *Zero         WIdx                           CFT014
     C                   Z-Add     *Zero         WIdx_MVAL         3 0          CFT014
     C                   Move      *ALL'Y'       FTEOPY5                        CFT014
                                                                                CFT014
      ** Validate Margin Info details                                           CFT014
                                                                                CFT014
     C                   CallB     'FTOPAY5VL'                                  CFT014
     C                   PARM                    RespMode                       CFT014
     C                   PARM                    NewPmtScn1                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    STRTC                                        CER030
     C                   PARM                    ExtData                        CFT014
     C                   PARM                    FTEOPY5                        CFT014
     C                   PARM                    FldNameArr                     CFT014
     C                   PARM                    MsgIDArr                       CFT014
     C                   PARM                    MsgDtaArr                      CFT014
     C                   PARM                    Idx                            CFT014
     C                   PARM                    WFldNamArr                     CFT014
     C                   PARM                    WMsgIDArr                      CFT014
     C                   PARM                    WMsgDtaArr                     CFT014
     C                   PARM                    WIdx                           CFT014
     C                   PARM                    NwPtFilFmt                     CFT014
     C                   PARM                    Val@Fields                     CFT014
     C                   PARM                    O2TTCD                                       CER030
                                                                                CFT014
      ** If errors returned                                                     CFT014
                                                                                CFT014
     C     Idx           IfNe      0                                            CFT014
     C                   Eval      @SCRN = 'M'                                  CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Re-output the screen                                                   CFT014
                                                                                CFT014
     C                   Eval      Widx_MVAL = Widx_MVAL + Widx                 CFT014
     C     WIdx_MVAL     IfNe      PrvN_Warn                                    CFT014
     C     NewPmtScn5    OrNe      PrvPmtScn5                                   CFT014
     C     NewPmtScn5A   ORNE      PrvPmtScn5A                                                CER030
     C     NewPmtScn5B   ORNE      PrvPmtScn5B                                                CER030
     C     WIdx_MVAL     AndEq     PrvN_Warn                                    CFT014
     C     WIdx_MVAL     AndNe     0                                            CFT014
     C                   Goto      EndVAL@M                                     CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Clear any warning messages                                             CFT014
                                                                                CFT014
     C                   Move      *ALL'Y'       FTEOPY5                        CFT014
     C                   Movel     *BLANK        WFldNamArr                     CFT014
     C                   Movel     *BLANK        WMsgIdArr                      CFT014
     C                   Movel     *BLANK        WMsgDtaArr                     CFT014
                                                                                CFT014
      ** Go back to Charges & Commissions screen                                CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C     EndVAL@M      EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/REFR@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/REFR@M     - Refresh Margin Information Screen             *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls:                                                        *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     REFR@M        BegSr                                                  CFT014
                                                                                CFT014
      ** Clear Margin info detail screen                                        CFT014
                                                                                CFT014
     C                   Clear                   NewPmtScn5                     CFT014
     C                   CLEAR                   NewPmtScn5A                                  CER030
     C                   CLEAR                   NewPmtScn5B                                  CER030
     C                   Eval      @SCRN = 'M'                                  CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      /Title Sr/SCRN@G                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/SCRN@G     - Process Cover Message Screen 1                *                       CSW209
      *                                                               *                       CSW209
      * Called By:                                                    *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     SCRN@G        BegSr                                                                CSW209
                                                                                              CSW209
      ** Update 'previous' screens and previous number of warnings                            CSW209
                                                                                              CSW209
     C                   Movel     NewPmtScnA    PrvPmtScnA                                   CSW209
     C                   Movel     NewPmtScn1    PrvPmtScn1                                   CSW209
     C                   Z-Add     WIdx_AVAL     PrvN_Warn                                    CSW209
                                                                                              CSW209
      ** Write/Read display screen                                                            CSW209
                                                                                              CSW209
     C                   Callb     'FTOPAYADP'                                                CSW209
     C                   Parm      *BLANK        RetCodeOut                                   CSW209
     C                   Parm                    NewPmtScn1                                   CSW209
     C                   Parm                    NwPtFilFmt                                   CSW209
     C                   Parm                    NewPmtScnA                                   CSW209
     C                   Parm                    DDSTAT                                       CSW209
     C                   Parm                    FTEOPYA                                      CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIdArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIdArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm      'N'           @EKYFD                                       CSW209
     C                   Parm                    @EDTFD                                       CSW209
     C                   Parm      'N'           @EINKD                                       CSW209
     C                   Parm      '0'           @INKC                                        CSW209
     C                   Parm      '0'           @INKD                                        CSW209
     C                   Parm      '0'           @INKL                                        CSW209
     C                   Parm      '0'           @INKE                                        CSW209
     C                   Parm      'N'           WriteOnly                                    CSW209
     C                   Parm      0             CursorLoc                                    CSW209
                                                                                              CSW209
      ** Reset errors                                                                         CSW209
                                                                                              CSW209
     C                   Move      *All'Y'       FTEOPYA                                      CSW209
     C                   Movel     *Blank        FldNameArr                                   CSW209
     C                   Movel     *Blank        MsgIdArr                                     CSW209
     C                   Movel     *Blank        MsgDtaArr                                    CSW209
     C                   Clear                   Idx                                          CSW209
     C                   Movel     *Blank        WFldNamArr                                   CSW209
     C                   Movel     *Blank        WMsgIdArr                                    CSW209
     C                   Movel     *Blank        WMsgDtaArr                                   CSW209
     C                   Clear                   WIdx                                         CSW209
                                                                                              CSW209
      ** F3 - End Program                                                                     CSW209
                                                                                              CSW209
     C     @INKC         CasEq     '1'           ENDP                                         CSW209
                                                                                              CSW209
      ** F12 - Cancel on Cover message screen                                                 CSW209
                                                                                              CSW209
     C     @INKL         CasEq     '1'           CANC@G                                       CSW209
                                                                                              CSW209
      ** F5 - Refresh                                                                         CSW209
                                                                                              CSW209
     C     @INKE         CasEq     '1'           REFR@G                                       CSW209
                                                                                              CSW209
      ** Validate Input to Cover message screen                                               CSW209
                                                                                              CSW209
     C                   Cas                     VAL@G                                        CSW209
                                                                                              CSW209
     C                   EndCs                                                                CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/VAL@G                                                                         CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/VAL@G      - Validate Cover message information screen 1   *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@G Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     VAL@G         BegSr                                                                CSW209
                                                                                              CSW209
      ** If enquire                                                                           CSW209
                                                                                              CSW209
     C     SACTION       IfEq      'E'                                                        CSW209
                                                                                              CSW209
      ** Go to Other details screen                                                           CSW209
                                                                                              CSW209
     C                   Movel     'H'           @SCRN                                        CSW209
                                                                                              CSW209
     C                   LeaveSr                                                              CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** If insert or amend                                                                   CSW209
                                                                                              CSW209
     C     SACTION       IfEq      'I'                                                        CSW209
     C     SACTION       OrEq      'A'                                                        CSW209
                                                                                              CSW209
      ** Prior to validation, initialize error indicators as 'OK'                             CSW209
                                                                                              CSW209
     C                   Z-Add     *Zero         Idx                                          CSW209
     C                   Z-Add     *Zero         WIdx                                         CSW209
     C                   Z-Add     *Zero         WIdx_AVAL         3 0                        CSW209
     C                   Move      *ALL'Y'       FTEOPYA                                      CSW209
                                                                                              CSW209
      ** Validate Cover message info details 1                                                CSW209
                                                                                              CSW209
     C                   CallB     'FTOPAYAVL'                                                CSW209
                                                                                              CSW209
     C                   Parm                    RespMode                                     CSW209
                                                                                              CSW209
     C                   Parm                    NewPmtScn1                                   CSW209
     C                   Parm                    NwPtFilFmt                                   CSW209
     C                   Parm                    NwPtFilFmx                                   CSW209
     C                   Parm                    NewPmtScnA                                   CSW209
                                                                                              CSW209
     C                   Parm                    FTEOPYA                                      CSW209
                                                                                              CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIDArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    Idx                                          CSW209
                                                                                              CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIDArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm                    WIdx                                         CSW209
                                                                                              CSW209
      ** Re-output the screen                                                                 CSW209
                                                                                              CSW209
     C                   Eval      Widx_AVAL = Widx_AVAL + Widx                               CSW209
     C     WIdx_AVAL     IfNe      PrvN_Warn                                                  CSW209
     C     NewPmtScnA    OrNe      PrvPmtScnA                                                 CSW209
     C     WIdx_AVAL     AndEq     PrvN_Warn                                                  CSW209
     C     WIdx_AVAL     AndNe     0                                                          CSW209
     C                   LeaveSr                                                              CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** Clear any warning messages                                                           CSW209
                                                                                              CSW209
     C                   Movel     *BLANK        WFldNamArr                                   CSW209
     C                   Movel     *BLANK        WMsgIdArr                                    CSW209
     C                   Movel     *BLANK        WMsgDtaArr                                   CSW209
                                                                                              CSW209
     C                   Eval      *IN81 = *ON                                                CSW209
                                                                                              CSW209
     C                   DoW       *IN81 = *ON                                                CSW209
     C     'W'           Scan      FTEOPYA:1     @p                       81                  CSW209
                                                                                              CSW209
     C     *IN81         IfEq      *ON                                                        CSW209
     C                   Eval      %SUBST(FTEOPYA: @P: 1) = 'Y'                               CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
     C                   EndDo                                                                CSW209
      *                                                                                       CSW209
      ** If any errors then re-display Cover screen 1 else                                    CSW209
      ** goto Cover screen 2                                                                  CSW209
      *                                                                                       CSW209
     C     Idx           IfEq      0                                                          CSW209
     C                   Eval      @SCRN = 'H'                                                CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/CANC@G                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/CANC@G     - Cancel on Cover Message screen 1              *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@G Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls: None                                                   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     CANC@G        BegSr                                                                CSW209
                                                                                              CSW209
      ** Return to Charges and Commissions Screen                                             CSW209
                                                                                              CSW209
     C                   Movel     'O'           @SCRN                                        CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/REFR@G                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/REFR@G     - Refresh Cover Message Information screen 1    *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@G Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     REFR@G        BegSr                                                                CSW209
                                                                                              CSW209
      ** Clear Cover message details screen 1                                                 CSW209
                                                                                              CSW209
     C                   Clear                   NewPmtScnA                                   CSW209
     C                   Eval      @SCRN = 'G'                                                CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      /Title Sr/SCRN@H                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/SCRN@H     - Process Cover Message Screen 2                *                       CSW209
      *                                                               *                       CSW209
      * Called By:                                                    *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     SCRN@H        BegSr                                                                CSW209
                                                                                              CSW209
      ** Update 'previous' screens and previous number of warnings                            CSW209
                                                                                              CSW209
     C                   Movel     NewPmtScnC    PrvPmtScnC                                   CSW209
     C                   Z-Add     WIdx_DVAL     PrvN_Warn                                    CSW209
                                                                                              CSW209
      ** Write/Read display screen                                                            CSW209
                                                                                              CSW209
     C                   Callb     'FTOPAYCDP'                                                CSW209
     C                   Parm      *BLANK        RetCodeOut                                   CSW209
     C                   Parm                    NewPmtScn1                                   CSW209
     C                   Parm                    NwPtFilFmt                                   CSW209
     C                   Parm                    NewPmtScnC                                   CSW209
     C                   Parm                    DDSTAT                                       CSW209
     C                   Parm                    FTEOPYC                                      CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIdArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIdArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm      'N'           @EKYFD                                       CSW209
     C                   Parm                    @EDTFD                                       CSW209
     C                   Parm      'N'           @EINKD                                       CSW209
     C                   Parm      '0'           @INKC                                        CSW209
     C                   Parm      '0'           @INKD                                        CSW209
     C                   Parm      '0'           @INKL                                        CSW209
     C                   Parm      '0'           @INKE                                        CSW209
     C                   Parm      'N'           WriteOnly                                    CSW209
     C                   Parm      0             CursorLoc                                    CSW209
                                                                                              CSW209
      ** Reset errors                                                                         CSW209
                                                                                              CSW209
     C                   Move      *All'Y'       FTEOPYC                                      CSW209
     C                   Movel     *Blank        FldNameArr                                   CSW209
     C                   Movel     *Blank        MsgIdArr                                     CSW209
     C                   Movel     *Blank        MsgDtaArr                                    CSW209
     C                   Clear                   Idx                                          CSW209
     C                   Movel     *Blank        WFldNamArr                                   CSW209
     C                   Movel     *Blank        WMsgIdArr                                    CSW209
     C                   Movel     *Blank        WMsgDtaArr                                   CSW209
     C                   Clear                   WIdx                                         CSW209
                                                                                              CSW209
      ** F3 - End Program                                                                     CSW209
                                                                                              CSW209
     C     @INKC         CasEq     '1'           ENDP                                         CSW209
                                                                                              CSW209
      ** F12 - Cancel on Cover message screen 2                                               CSW209
                                                                                              CSW209
     C     @INKL         CasEq     '1'           CANC@H                                       CSW209
                                                                                              CSW209
      ** F5 - Refresh                                                                         CSW209
                                                                                              CSW209
     C     @INKE         CasEq     '1'           REFR@H                                       CSW209
                                                                                              CSW209
      ** Validate Input to Cover message screen 2                                             CSW209
                                                                                              CSW209
     C                   Cas                     VAL@H                                        CSW209
                                                                                              CSW209
     C                   EndCs                                                                CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/VAL@H                                                                         CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/VAL@H      - Validate Cover message information screen 2   *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@H Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     VAL@H         BegSr                                                                CSW209
                                                                                              CSW209
      ** If enquire                                                                           CSW209
                                                                                              CSW209
     C     SACTION       IfEq      'E'                                                        CSW209
                                                                                              CSW209
      ** Go to Other details screen                                                           CSW209
                                                                                              CSW209
     C     @RDNB         IfEq      'Y'                                                        262747
     C                   MoveL     'R'           @SCRN                                        262747
      *                                                                                       262747
      * Else, if called from linked enquiry go back to calling program.                       262747
     C                   Else                                                                 262747
     C     LinkedEnq     IfNe      *BLANKS                                                    262747
     C                   Exsr      CANC@P                                                     262747
                                                                                              262747
      *     Else, Go To Initial screen                                                        262747
     C                   Else                                                                 262747
     C                   Exsr      Initial                                                    CSW209
     C                   EndIf                                                                262747
     C                   EndIf                                                                262747
                                                                                              CSW209
     C                   LeaveSr                                                              CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** If insert or amend                                                                   CSW209
                                                                                              CSW209
     C     SACTION       IfEq      'I'                                                        CSW209
     C     SACTION       OrEq      'A'                                                        CSW209
                                                                                              CSW209
      ** Prior to validation, initialize error indicators as 'OK'                             CSW209
                                                                                              CSW209
     C                   Z-Add     *Zero         Idx                                          CSW209
     C                   Z-Add     *Zero         WIdx                                         CSW209
     C                   Z-Add     *Zero         WIdx_DVAL         3 0                        CSW209
     C                   Move      *ALL'Y'       FTEOPYC                                      CSW209
                                                                                              CSW209
      ** Validate Cover message info details 2                                                CSW209
                                                                                              CSW209
     C                   CallB     'FTOPAYCVL'                                                CSW209
                                                                                              CSW209
     C                   Parm                    RespMode                                     CSW209
                                                                                              CSW209
     C                   Parm                    NwPtFilFmt                                   CSW209
     C                   Parm                    NwPtFilFmx                                   CSW209
     C                   PARM                    NewPmtScn1                                   CSW209
     C                   PARM                    NewPmtSc1b                                 BUG26775
     C                   PARM                    NewPmtSc2a                                 BUG26548
     C                   PARM                    NewPmtSc2b                                   CSW209
     C                   PARM                    NewPmtScn3                                   CSW209
     C                   Parm                    NewPmtScnA                                   CSW209
     C                   Parm                    NewPmtScnC                                   CSW209
                                                                                              CSW209
     C                   Parm                    FTEOPYC                                      CSW209
                                                                                              CSW209
     C                   Parm                    FldNameArr                                   CSW209
     C                   Parm                    MsgIDArr                                     CSW209
     C                   Parm                    MsgDtaArr                                    CSW209
     C                   Parm                    Idx                                          CSW209
                                                                                              CSW209
     C                   Parm                    WFldNamArr                                   CSW209
     C                   Parm                    WMsgIDArr                                    CSW209
     C                   Parm                    WMsgDtaArr                                   CSW209
     C                   Parm                    WIdx                                         CSW209
                                                                                              CSW209
                                                                                              CSW209
      ** If errors returned                                                                   CSW209
                                                                                              CSW209
     C     Idx           IfNe      0                                                          CSW209
     C                   Eval      @SCRN = 'H'                                                CSW209
     C                   LeaveSr                                                              CSW209
     C                   Else                                                                 CSW209
     C                   Eval      @SCRN = 'C'                                                CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** Re-output the screen                                                                 CSW209
                                                                                              CSW209
     C                   Eval      Widx_DVAL = Widx_DVAL + Widx                               CSW209
     C     WIdx_DVAL     IfNe      PrvN_Warn                                                  CSW209
     C     NewPmtScnC    OrNe      PrvPmtScnC                                                 CSW209
     C     WIdx_DVAL     AndEq     PrvN_Warn                                                  CSW209
     C     WIdx_DVAL     AndNe     0                                                          CSW209
     C                   LeaveSr                                                              CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      ** Clear any warning messages                                                           CSW209
                                                                                              CSW209
     C                   Movel     *BLANK        WFldNamArr                                   CSW209
     C                   Movel     *BLANK        WMsgIdArr                                    CSW209
     C                   Movel     *BLANK        WMsgDtaArr                                   CSW209
      *                                                                                       CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/CANC@H                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/CANC@H     - Cancel on Cover Message screen 2              *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@H Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls: None                                                   *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     CANC@H        BegSr                                                                CSW209
                                                                                              CSW209
      ** Return to Cover message screen 1                                                     CSW209
                                                                                              CSW209
     C                   Movel     'G'           @SCRN                                        CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************                       CSW209
      /Title Sr/REFR@H                                                                        CSW209
      *****************************************************************                       CSW209
      *                                                               *                       CSW209
      * SR/REFR@H     - Refresh Cover Message Information screen 2    *                       CSW209
      *                                                               *                       CSW209
      * Called By: SCRN@H Subroutine                                  *                       CSW209
      *                                                               *                       CSW209
      * Calls:                                                        *                       CSW209
      *                                                               *                       CSW209
      *****************************************************************                       CSW209
                                                                                              CSW209
     C     REFR@H        BegSr                                                                CSW209
                                                                                              CSW209
      ** Clear Cover message screen 2                                                         CSW209
                                                                                              CSW209
     C                   Clear                   NewPmtScnC                                   CSW209
     C                   Eval      @SCRN = 'H'                                                CSW209
                                                                                              CSW209
     C                   EndSr                                                                CSW209
                                                                                              CSW209
      *****************************************************************
      /EJECT
      *****************************************************************
      * WINDOW - CALL WINDOW MANAGER
      *****************************************************************
     C     WINDOW        BEGSR
      *
     C/COPY WNCPYSRC,FTOPA1SC28
      * Reset erros
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVE      *ALL'Y'       FTEOPY2
     C                   MOVE      *ALL'Y'       FTEOPY3
     C                   MOVE      *ALL'Y'       FTEOPY4                        CFT014
     C                   MOVE      *ALL'Y'       FTEOPY5                        CFT014
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   MOVE      *ALL'Y'       FTEOPYA                                      CSW209
     C                   MOVE      *ALL'Y'       FTEOPYC                                      CSW209
     C                   EndIf                                                                CSW209
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
     C/COPY WNCPYSRC,FTOPA1SC09
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKG                          CFT018
     C                   Move      '0'           @INKH                          CFT018
     C                   Move      '0'           @INKJ                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKP                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
     C                   Move      '0'           @INKS                          CFT018
     C                   Move      '0'           @INKV                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
      *
      * Write out screen to remove error messages
      *
     C                   CALLB     'FTOPAY1DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * Payment (IN SCREEN FORMAT - Primary)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * STATUS
     C                   PARM                    DDSTAT           24
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM                    @EKYFD
     C                   PARM                    @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM                    @EINKD                         CFT007
     C                   PARM                    @EINKG
     C                   PARM                    @EINKH
     C                   PARM                    @EINKJ
     C                   PARM                    @EINKP
     C                   PARM                    @EINKQ                         CFT007
     C                   PARM                    @EINKS
     C                   PARM                    @EINKV
      *
      * SUCCESFUL INSERT TRANSACTION
     C                   PARM                    @SITR
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
      *
      * SWIFT Identifier
     C                   PARM                    XPREF

      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD                          CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ                          CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      'Y'           WriteOnly         1
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc                      CFT007
     C                   PARM                    SSIMode           1            CFT018
      *                                                                         CFT018
     C                   Endif                                                  CFT018
      *                                                                         CFT018
      **  NOTE: If a window is added for this function then                     CFT018
      **  consideration should be given to F11 processing                       CFT018
      **  where a payment is to be inserted directly from an SSI                CFT018
      **  with no screen display.                                               CFT018
      * Set up payment Reference for insert.                                                  204152
     C     SACTION       IFEQ      'I'                                                        204152
     C*****FirstTime     ANDEQ     'Y'                                                204152 BUG4776
     C*****FirstTime     ANDEQ     'Y'                                               BUG4776R 222349
     C*****FirstTime     Ifeq      'Y'                                              BUG4776 BUG4776R
     C     FirstTime     IFEQ      'Y'                                                        222349
     C                   EVAL      FirstTime = 'N'                                            204152
                                                                                              CSC024
      ***Suppress*new*payment*reference*generation*if*CSC024*is                        CSC024 CSC054
      ***switched*on*and*this*is*running*on*OME*system.                                       CSC054
      ** Suppress new payment reference generation if CSC054 is                               CSC054
      ** switched on and this is running on PEA system.                                       CSC054
                                                                                              CSC024
     C                   IF        GENPREF = 'Y'                                              CSC024
     C/COPY WNCPYSRC,FTOPA1SC62
     C                   EXSR      SETPAYREF                                                  204152
     C/COPY WNCPYSRC,FTOPA1SC63
      *                                                                                       242102
      ** Set payment reference checking flag                                                  242102
     C                   EVAL      PRflag = 'N'                                               242102
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ELSE                                                                 222349
     C     SPREF         IFEQ      *BLANKS                                                    222349
     C                   MOVE      IPREF         SPREF                                        222349
     C                   ENDIF                                                                222349
     C                   ENDIF                                                                222349
     C**********         Else                                                       BUG4776 BUG4776R
     C*****SPREF         Ifeq      *BLANKS                                          BUG4776 BUG4776R
     C**********         Move      IPREF         SPREF                              BUG4776 BUG4776R
     C**********         Endif                                                      BUG4776 BUG4776R
     C**********         Endif                                                      BUG4776 BUG4776R
     C                   END                                                                  204152
      *                                                                                       204152
      ** If Settlement type changed, Update Pay Reference                                   AR402776
      *                                                                                     AR402776
     C                   MOVEL     *BLANK        STFlag            1                        AR402776
      *                                                                                     AR402776
     C                   IF        SACTION = 'I' OR SACTION = 'A'                           AR402776
     C     2             SUBST     PREF:14       SETT              2                        AR402776
      *                                                                                     AR402776
     C     SSTTP         IFNE      SETT                                                     AR402776
     C                   MOVEL     SPREF         WOSPREF          15                        AR402776
     C                   MOVEL     'Y'           STFlag                                     AR402776
     C                   MOVE      SSTTP         SPREF                                      AR402776
      *                                                                                     AR402776
     C                   IF        SACTION = 'I'                                            AR402776
     C                   MOVE      SSTTP         StmtType                                   AR402776
     C                   ENDIF                                                              AR402776
     C                   ENDIF                                                              AR402776
     C                   ENDIF                                                              AR402776
      *
     C/COPY WNCPYSRC,FTOPAYSMV1
     C     ULX043        IFEQ      'Y'                                                        CER001
     C                   MOVEL     SPREF         PREF1                                        CER001
     C                   MOVEL     SFOTRANID     #1FOTR                                       CER001
     C                   MOVEL     STMESTMP      #1TMST                                       CER001
     C                   MOVEL     @ORCT         #1ORCT                                       CER001
     C                   MOVEL     @ORBT         #1ORBT                                       CER001
     C                   MOVEL     SORBK         #1ORBK                                       CER001
     C                   MOVEL     SORC1         #1ORC1                                       CER001
     C                   MOVEL     SSMCY         #1SMCY                                       CER001
     C                   Z-ADD     @SMAM         #1SMAM                                       CER001
     C                   MOVEL     SPCCY         #1PCCY                                       CER001
     C                   MOVEL     @SNCT         #1SNCT                                       CER001
     C                   MOVEL     SSNCO         #1SNCO                                       CER001
     C                   MOVEL     @DSTT         #1DSTT                                       CER001
     C                   MOVEL     SDST1         #1DST1                                       CER001
      *                                                                                       CER001
     C                   CALLB     'FTOPAY3SN'                                                CER001
     C                   PARM      SACTION       ACTION                                       CER001
     C                   PARM                    DATALUX                                      CER001
     C                   PARM      *BLANKS       #RTRN                                        CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER001
     C     #RTRN         IFNE      'Y2U9999'                                                  CER001
     C     #RTRN         ANDNE     'USR0790'                                                  CER001
     C     ULX043        OREQ      'N'                                                        CER001
      *
     C                   CALL      'WN0010'
     C                   PARM      'FTOPAY1SN'   #PGM             10
     C                   PARM                    FKEY              2
     C                   PARM      SACTION       ACTION            1
     C                   PARM                    DATA
     C                   PARM      *BLANKS       #RTRN             7
     C                   PARM                    SPAREW          256
      *                                                                                       CER001
     C                   ENDIF                                                                CER001
     C/COPY WNCPYSRC,FTOPA1SC27
      *
      * Process returned command keys
      *
     C     #RTRN         IFEQ      'Y2U9999'
     C                   EXSR      ENDP
     C                   ELSE
      *
      *  If Cmd12 pressed, return to main details screen;
      *  otherwise, go to second screen
      *
     C     #RTRN         IFEQ      'USR0790'
     C     @RDNB         IFEQ      'Y'
     C                   EVAL      @SCRN = 'R'
     C                   ELSE
     C                   EVAL      @SCRN = 'P'
     C                   END
     C                   ELSE

      * If level joiner is on, go to Secondary details, otherwise
      * confirm level 1 details

     C/COPY WNCPYSRC,FTOPAY1S01
     C                   IF        BTLVJN = 'Y'
     C                             OR CER031 = 'Y'                                          BUG23047
     C                   EVAL      @SCRN = 'S'
     C                   ELSE
      * if enquiry, go to either Browse subfile or to Intital screen                          204100
     C     SACTION       IFEQ      'E'                                                        204100
     C     @RDNB         IFEQ      'Y'                                                        204100
     C                   EVAL      @SCRN = 'R'                                                204100
     C                   ELSE                                                                 204100
     C                   EXSR      INITIAL                                                    204100
     C                   END                                                                  204100
     C                   ELSE                                                                 204100
     C                   EVAL      @SCRN = 'C'
     C                   ENDIF                                                                204100
     C                   ENDIF
     C/COPY WNCPYSRC,FTOPAY1S02
     C                   ENDIF
     C                   ENDIF
     C/COPY WNCPYSRC,FTOPA1SC10
      *
     C     WIND          ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * ROLL - ROLL BACKWARDS & FORWARDS THROUGH PaymentS FILE
      *****************************************************************
     C     ROLL          BEGSR
      *
      * Default action code to enquiry if not valid
      *
     C     SACTION       IFNE      'A'
     C     SACTION       ANDNE     'D'
     C                   MOVE      'E'           SACTION
     C                   END
      *
      * READ NEXT OR PREVIOUS RECORD ON PaymentS FILE
      * ACCORDING TO COMMAND KEY TAKEN (F7{=INKG} OR F8)
      *
     C     @INKG         IFEQ      '1'
     C                   MOVEL     *BLANK        @RDFWD
     C                   MOVEL     'Y'           @RDBCK
     C                   ELSE
     C                   MOVEL     'Y'           @RDFWD
     C                   MOVEL     *BLANK        @RDBCK
     C                   END
      *
     C                   CALLB     'FTOPAYRED'
      *
      * INPUT PARAMETERS
      *
      * Return Code
     C                   PARM      *BLANK        RetCodeOut
      *
      * Action Code
     C                   PARM                    SACTION
      *
      * Payment REF. POINTER
     C                   PARM                    SPREF            15
      *
      * READ FORWARDS
     C                   PARM                    @RDFWD            1
      *
      * READ BACKWARDS
     C                   PARM                    @RDBCK            1
      *
      * OUTPUT PARAMETERS
      *
      * Error message
     C                   PARM      *BLANK        @ERRMS            7
      *
      * Payment REF. READ
     C                   PARM      *BLANK        @PRRED           15
      *
      * If error message returned from read, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EROLL
     C                   END
      *
      * If Payment read
      *
     C     @PRRED        IFNE      *BLANK
      *
      * Retrieve Payment details
      *
     C                   MOVEL     @PRRED        SPREF
     C                   EXSR      RTVPMT
      *
      * Convert Payment
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
      *
      * Set field status on PRIMARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * put payment it on the PRIMARY screen
      *
     C                   MOVEL     'P'           @SCRN
      *
     C                   ENDIF
      *
     C     EROLL         ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * DELETE - DELETE PROCESSING
      *****************************************************************
     C     DELETE        BEGSR
      *
      * F10 TAKEN, GO ON TO UPDATES
      *
     C                   MOVEL     'U'           @SCRN
     C                   MOVE      'N'           @EINKJ
     C
     C     EndDelete     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * BLDBRW - BUILD BROWSE SUBFILE
      *****************************************************************
     C     BLDBRW        BEGSR
      *
      * Reset Read next browse subfile record
     C                   MOVEL     *BLANK        @RDNB             1
      *
      * Build Browse subfile
     C                   CALLB     'FTOPAYBRW'
      *
      * INPUT PARAMETERS :
      * Return Code
      * Action Code
      * Payment Ref. Pointer
      * Build subfile
      * Read subfile record
      * Level 1/2 indicator
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    SACTION           1
     C                   PARM                    SPREF            15
     C                   PARM      'Y'           @BDSFL            1
     C                   PARM      *BLANK        @RDSFL            1
     C                   PARM                    @Level

      *
      * OUTPUT PARAMETERS :
      * Error message
      * Option Selected
      * Payment Reference Selected
      * Command Keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @PRSEL           15
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If F3 taken in browse, End Program
     C     @INKC         IFEQ      '1'
     C                   EXSR      ENDP
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If error message returned from browse, send it to detail screen
      *
     C     @ERRMS        IFNE      *BLANK
     C                   EXSR      SNDM@P
     C                   GOTO      EndBLDBRW
     C                   END
      *
      * If F12 not taken in browse
      * Read next browse subfile record
      *
     C     @INKL         IFNE      '1'
     C                   MOVE      'Y'           @RDNB
     C                   MOVEL     'R'           @SCRN
     C                   GOTO      EndBLDBRW
     C                   END
      *                                                                         CFT018
      ** F12 - Previous screen                                                  CFT018
     C     @INKL         IFEQ      '1'                                          CFT018
     C     SSIMode       ANDEQ     'Y'                                          CFT018
     C                   MOVE      'A'           @SCRN                          CFT018
     C                   ENDIF                                                  CFT018
      *
     C     EndBLDBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RDNBRW - READ NEXT BROWSE SUBFILE RECORD
      *****************************************************************
     C     RDNBRW        BEGSR
      *
      * Read Next Subfile Record
      *
     C                   CALLB     'FTOPAYBRW'
      * INPUT PARAMETERS :
      * Return code
      * Action code
      * Payment Ref. pointer
      * Build Sub-file
      * Read Sub-file record
      * Level 1/2 indicator
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    SACTION           1
     C                   PARM                    SPREF            15
     C                   PARM      *BLANK        @BDSFL            1
     C                   PARM      'Y'           @RDSFL            1
     C                   PARM                    @Level            1
      * OUTPUT PARAMETERS :
      * Error Message
      * Option Selected
      * Payment Ref. selected
      * Function keys
     C                   PARM      *BLANK        @ERRMS            7
     C                   PARM      *BLANK        @OPSEL            1
     C                   PARM      *BLANK        @PRSEL           15
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKL             1
      *
      * If Payment read from subfile
     C     @PRSEL        IFNE      *BLANK
     C     @OPSEL        IFNE      *BLANK                                                     260045
      *
      * Retrieve Payment details
      *
     C/COPY WNCPYSRC,FTH00657
     C                   MOVEL     @OPSEL        SACTION
     C                   MOVEL     @PRSEL        SPREF
     C                   EXSR      RTVPMT
      *
      * Convert Payment
     C                   EXSR      CVTPMT
     C                   MOVEL     CrPtFilFmt    NwPtFilFmt
     C                   MOVEL     CrPtFilFmX    NwPtFilFmX                     CFT014
      *
      * Set field status on PRIMARY screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      * Put the Payment on the PRIMARY screen
      *
     C                   MOVEL     'P'           @SCRN
     C/COPY WNCPYSRC,FTH00658
      *                                                                                       260045
      ** @OPSEL is blank - an incorrect character has been entered - throw error              260045
      *                                                                                       260045
     C                   ELSE                                                                 260045
     C                   MOVEL     *BLANK        NewPmtScn1                                   260045
     C                   MOVEL     *BLANK        NewPmtSc1b                                   260045
     C                   MOVEL     *BLANK        NewPmtSc2a                                   260045
     C                   MOVEL     *BLANK        NewPmtSc2b                                   260045
     C                   MOVEL     *BLANK        NewPmtScn3                                   260045
     C                   MOVEL     *BLANK        NewPmtSc3b                                   260045
     C                   MOVEL     *BLANK        NewPmtScn4                                   260045
     C                   MOVEL     *BLANK        NewPmtScn5                                   260045
     C                   MOVEL     'Y'           @EKYFD                                       260045
     C                   MOVEL     'Y'           @EDTFD                                       260045
     C                   MOVEL     @PRSEL        SPREF                                        260045
     C                   Z-Add     1             Ix                3 0                        260045
     C                   MOVEL     'DDPREF'      FldNameArr(Ix)                               260045
     C                   MOVEL     'FTX1027'     MsgIDArr(Ix)                                 260045
     C                   MOVEL     'P'           @SCRN                                        260045
     C                   ENDIF                                                                260045
      *
      * No payment selected, go to initial screen
      *
     C                   ELSE
     C                   EXSR      INITIAL
     C                   END
      *
     C     EndRDNBRW     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * RTVPMT - RETRIEVE PAYMENT
      *****************************************************************
     C     RTVPMT        BEGSR
      *                                                                                       201852
      ** If enquiry is from GL4442, move 'Y' to RetCodeOut but                                201852
      ** will be cleared in FTOPAYRTV                                                         201852
      *                                                                                       201852
     C                   MOVE      *BLANKS       RetCodeOut                                   201852
     C     @GL442        IFEQ      'Y'                                                        201852
     C                   MOVEL     'Y'           RetCodeOut                                   201852
     C                   ENDIF                                                                201852
      *
      * RETRIEVE Payment
      *                                                                                       214320
      ** Release any allocated transaction                                                    214320
      *                                                                                       214320
     C                   MOVE      *BLANKS       @RTCDE                                       214320
     C                   MOVE      'FT'          @MODLE                                       214320
     C                   MOVE      *BLANKS       @TREF                                        214320
     C                   MOVE      *BLANKS       @RTINF                                       214320
     C                   CALL      'AOC8000'                                                  214320
     C                   PARM                    @RTCDE                                       214320
     C                   PARM                    @MODLE                                       214320
     C                   PARM                    @TREF                                        214320
     C                   PARM                    @RTINF                                       214320
      *
     C                   CALLB     'FTOPAYRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C**********         PARM      *BLANK        RetCodeOut                                   201852
     C                   PARM                    RetCodeOut                                   201852
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM      '      '      @@MODE            6
      * Response mode
     C                   PARM      'S'           @@RSMD            1
      * Action Code
     C                   PARM                    SACTION
      * Front Office Transaction ID
     C                   PARM                    FOTRID           20
      * (Midas) Payment Reference
     C                   PARM                    SPREF
      * Booking branch
     C                   PARM                    SBRCA             3
      * Level 1/2 indicator
     C                   PARM                    @Level            1
      * @CFT014 workfield                                                       CFT014
     C                   PARM                    Val@Fields                     CFT014

      * OUTPUTS :
      * (Current) Payment in file format
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014
      * OK - Action code
     C                   PARM      *BLANK        OKACTION
      * OK - Payment Reference
     C                   PARM      *BLANK        OKPREF
      * OK - Booking branch
     C                   PARM                    OKBRCA
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C/COPY WNCPYSRC,FTOPA1SC60
      *
      * Set up flag to enable/disable F16
     C                   MOVE      LVL2          Level2Dtl         1
     C/COPY WNCPYSRC,FTH00339

      * If called from GL4442 then return error if record not live
     C     @GL442        IFEQ      'Y'
     C     RECI          ANDNE     'D'
     C                   MOVE      'E'           @ReturnCde
     C                   END
      *                                                                                       214320
      ** Allocate the Payment Reference                                                       214320
      *                                                                                       214320
     C     SACTION       IFEQ      'A'                                                        214320
     C     SACTION       OREQ      'D'                                                        214320
     C                   MOVE      *BLANKS       @RTCDE            7                          214320
     C                   MOVE      'FT'          @MODLE            2                          214320
     C                   MOVE      SPREF         @TREF            15                          214320
     C                   MOVE      *BLANKS       @RTINF           80                          214320
     C                   CALL      'AOC8000'                                                  214320
     C                   PARM                    @RTCDE                                       214320
     C                   PARM                    @MODLE                                       214320
     C                   PARM                    @TREF                                        214320
     C                   PARM                    @RTINF                                       214320
     C                   ENDIF                                                                214320
      *
     C     EndRTVPMT     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CVTPMT - PUT A Payment ON THE MAIN DETAILS SCREEN
      *****************************************************************
     C     CVTPMT        BEGSR
      *
      * Call program to fill screen fields with data from OTPAYDD
      *
     C/COPY WNCPYSRC,FTH00659
     C                   CALLB     'FTOPAYCVT'
      *
      * INPUTS :
      * Return Code
      * Payment in file format
     C                   PARM      *BLANK        RetCodeOut
     C                   PARM                    CrPtFilFmt
     C                   PARM                    CrPtFilFmX                     CFT014

      * OUTPUTS
      * Payment - screen formats
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
     C                   PARM                    NewPmtSc2a
     C                   PARM                    NewPmtSc2b
     C                   PARM                    NewPmtScn3
     C                   PARM                    NewPmtSc3b                     CFT014
     C                   PARM                    NewPmtScn4                     CFT014
     C                   PARM                    NewPmtScn5                     CFT014
     C                   PARM                    NewPmtScnA                                   CSW209
     C                   PARM                    NewPmtScnC                                   CSW209
     C                   PARM                    NewPmtScn5A                                  CER030
     C                   PARM                    NewPmtScn5B                                  CER030
     C                   PARM                    SDFTFR                         CFT014

      *  Validation Work Fields
     C                   PARM                    Val@Fields

      * Payment Status
     C                   PARM                    DDSTAT
      *
     C* Msg Unique Reference                                                                  190845
     C                   PARM                    SHMSGR                                       190845
     C* Part Number                                                                           190845
     C                   PARM                    SHPART                                       190845
     C                   PARM      *BLANKS       BtnPressed       10                       AR1090283
     C/COPY WNCPYSRC,FTH00660
      *                                                                                       190845
      * Update 'Current' Payment with Payment in Screen Format
      *
     C                   MOVEL     NewPmtScn1    CurPmtScn1
     C                   MOVEL     NewPmtSc1b    CurPmtSc1b                     CFT014
     C                   MOVEL     NewPmtSc2a    CurPmtSc2a
     C                   MOVEL     NewPmtSc2b    CurPmtSc2b
     C                   MOVEL     NewPmtScn3    CurPmtScn3
     C                   MOVEL     NewPmtSc3b    CurPmtSc3b                     CFT014
     C                   MOVEL     NewPmtScn4    CurPmtScn4                     CFT014
     C                   MOVEL     NewPmtScn5    CurPmtScn5                     CFT014
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     NewPmtScnA    CurPmtScnA                                   CSW209
     C                   MOVEL     NewPmtScnC    CurPmtScnC                                   CSW209
     C                   EndIf                                                                CSW209
     C                   MOVEL     NewPmtScn5A   CurPmtScn5A                                  CER030
     C                   MOVEL     NewPmtScn5B   CurPmtScn5B                                  CER030
     C                   MOVE      CDRT          WPrvCDRT          1                          187056
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
     C*****************************************************************
      *                                                               *
      *  EISWFT   : To access the swift message and set up the detail *
      *             screen fields from this message                   *
      *                                                               *
      *  CALLED BY: Main section                                      *
      *                                                               *
      *  CALLS    : *NONE                                             *
      *                                                               *
     C*****************************************************************
     C     EISWFT        BEGSR

     ** Clear current payment in file format
     C                   CLEAR                   NwPtFilFmt
     C                   CLEAR                   NwPtFilFmx                     CFT014
      *                                                                         CGL009
      ** Settlement amt currency number of decimal positions                    CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        SCNBDP                         CGL009
                                                                                CFT014
      ** Payment amt currency number of decimal positions                       CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        PCNBDP                         CGL009
                                                                                CFT014
      ** Notify delivery amt currency number of decimal positions               CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        PDNBDP                         CGL009
                                                                                CFT014
      ** Euro currency number of decimal positions                              CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        EUNBDP                         CGL009
                                                                                CFT014
      ** Sender's charges currency number of decimal positions                  CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        CHNBDP                         CFT014
                                                                                CFT014
      ** Receiver's charges currency number of decimal positions                CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        RCNBDP                         CFT014
                                                                                CFT014
      ** Transaction amt currency number of decimal positions                   CFT014
                                                                                CFT014
     C     *LIKE         DEFINE    WCYNDP        TRNBDP                         CFT014
      *
      * Call ME1100 to translate the data of the messages for FT fields
      *
     C                   CALL      'ME1100'                             8080
     C                   PARM      '*TRANS  '    #ACT              8            Action
     C                   PARM                    PHEAD                          General Details
     C                   PARM      *BLANKS       PDATA                          Message Details
     C                   PARM      *BLANKS       PDAT2                          MsgDtls Ext'n CSW209
     C                   PARM      *BLANKS       @RTCD                          Return Code
      *
      *  If call to program resulted in an error then end program.
      *
     C     @RTCD         IFEQ      '*ERROR*'
     C     *IN80         OREQ      '1'
     C                   MOVEL     '50'          DBASE                          ************
     C                   MOVEL     '*CALL   '    DBFILE                         *DB ERR 50 *
     C                   MOVEL     *BLANKS       DBKEY                          ************
     C                   MOVEL     'ME1100'      DBKEY
     C                   EXSR      *PSSR
     C                   END
      *
      * Set up the detail screen fields from the message.
      *
      **Destination*                                                            CGL009
      ***************                                                           CGL009
      **If*Intermediary*Bank*is*blank,*use*'A/c*with*Institution'*****          CGL009
      **details,*otherwise*use*Intermediary*Bank*details**************          CGL009
      ************************                                                  CGL009
     C*****P56           IFEQ      *BLANKS                                      CGL009
      *******************                                                       CGL009
     C*****P57           IFNE      *BLANKS                                      CGL009
     C*******************MOVEL     P57           DSTRAN                         CGL009
     C*******************MOVEL     TMLIN1        SDST1                          CGL009
     C*******************MOVEL     TMLIN2        SDST2                          CGL009
     C*******************MOVEL     TMLIN3        SDST3                          CGL009
     C*******************MOVEL     TMLIN4        SDST4                          CGL009
     C*******************ELSE                                                   CGL009
     C*******************MOVEL     P58           DSTRAN                         CGL009
     C*******************MOVEL     TMLIN1        SDST1                          CGL009
     C*******************MOVEL     TMLIN2        SDST2                          CGL009
     C*******************MOVEL     TMLIN3        SDST3                          CGL009
     C*******************MOVEL     TMLIN4        SDST4                          CGL009
     C*******************END                                                    CGL009
      *****************                                                         CGL009
     C*******************ELSE                                                   CGL009
      *******************                                                       CGL009
      **Intermediary*Bank*entered*********                                      CGL009
      ****************************                                              CGL009
     C*******************MOVEL     P56           DSTRAN                         CGL009
     C*******************MOVEL     TMLIN1        SDST1                          CGL009
     C*******************MOVEL     TMLIN2        SDST2                          CGL009
     C*******************MOVEL     TMLIN3        SDST3                          CGL009
     C*******************MOVEL     TMLIN4        SDST4                          CGL009
      *******************                                                       CGL009
      **Account*with*Bank*(only*filled*if*Intermediary*Bank*exist)              CGL009
      *******************                                                       CGL009
     C*****P57           IFNE      *BLANKS                                      CGL009
     C*******************MOVEL     P57           DSTRAN                         CGL009
     C*******************MOVEL     TMLIN1        SACB1                          CGL009
     C*******************MOVEL     TMLIN2        SACB2                          CGL009
     C*******************MOVEL     TMLIN3        SACB3                          CGL009
     C*******************MOVEL     TMLIN4        SACB4                          CGL009
     C*******************MOVEL     TMLIN5        SACB5                          CGL009
     C*******************END                                                    CGL009
      *******************                                                       CGL009
     C*******************END                                                    CGL009
      *
      * Ordering Customer
      *
     C                   SELECT                                                 CGL009
      ** Special rule for FONTIS                                                CGL009
      ** - Ordering customer is mapped with mapped with the A/C to be           CGL009
      ** debited                                                                CGL009
      ** - Ordering bank is blank                                               CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
     C                   MOVEL     P53           DSTRAN                         CGL009
     C                   MOVEA     TMLIN1        @I35                           CGL009
     C                   EXSR      SLSH35                                       CGL009
     C                   MOVEA     @O35          WAC                            CGL009
     C                   MOVEL     'N'           WACDMP                         CGL009
     C                   EXSR      RTACNT                                       CGL009
     C     WACRTN        IFEQ      *BLANK                                       175474
      ** If it is a G/L account we format it in a way it is                     CGL009
      ** interpreted as a partial account in the validation modules.            CGL009
      ** If it is a retail one, we don't format it                              CGL009
     C     WACLN         IFEQ      10                                           CGL009
     C                   MOVEA     @O35          SORC1                          CGL009
     C                   ELSE                                                   CGL009
     C     3             SUBST     O35:1         WPTBCH                         CGL009
     C     6             SUBST     O35:4         WPTCST                         CGL009
     C*****4****         SUBST     O35:13        WPTACD                                CGL009 CGL029
     C*****2****         SUBST     O35:17        WPTSQN                                CGL009 CGL029
     C     10            SUBST     O35:13        WPTACD                                       CGL029
     C     2             SUBST     O35:23        WPTSQN                                       CGL029
     C                   MOVEL     DSPTAC        SORC1                          CGL009
     C                   ENDIF                                                  CGL009
     C************LIKE     DEFN WACCY     W53CCY                          CGL009175475
     C*********************MOVELWACCY     W53CCY                          CGL009175475
     C                   MOVEL     WACBCH        SBRCA                          CGL009
     C                   MOVEL     WACBCH        PBRCA                          170801
     C                   ELSE                                                   175474
      ** If no valid account in tag 53 we concatenate line of                   175474
      ** 53 (A/C debited)  + first lines of 50 (Ord Cust)                       175474
     C                   MOVEA     @O35          SORC1                          175474
     C                   MOVEL     P50           DSTRAN                         175474
     C                   MOVEL     TMLIN1        SORC2                          175474
     C                   MOVEL     TMLIN2        SORC3                          175474
     C                   MOVEL     TMLIN3        SORC4                          175474
     C                   EVAL      SORC5 = TMLIN4                                             CFT032
     C*********************MOVEL*BLANK    W53CCY                          175474175475
      ** End of account validation                                              175474
     C                   ENDIF                                                  175474
      *                                                                         CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
      *                                                                         CGL009
     C     P50           IFNE      *BLANKS
     C                   MOVEL     P50           DSTRAN
     C                   MOVEL     TMLIN1        SORC1
     C                   MOVEL     TMLIN2        SORC2
     C                   MOVEL     TMLIN3        SORC3
     C                   MOVEL     TMLIN4        SORC4
     C                   MOVEL     TMLIN5        SORC5                                        260254
     C                   END
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
     C/COPY WNCPYSRC,JMI113_023                                                               JMI106
      *
      * Ordering Bank file fields
      *
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      ** Ordering bank is never filled with FONTIS                              CGL009
      *                                                                         CGL009
      ** Other networks                                                         CGL009
     C                   OTHER                                                  CGL009
      * If Ordering Institution not blank, use it
      * otherwise use Sender details
      *
     C     P52           IFNE      *BLANKS
     C                   MOVEL     P52           DSTRAN
     C                   MOVEL     TMLIN1        OTOPORB1
     C                   MOVEL     TMLIN2        OTOPORB2
     C                   MOVEL     TMLIN3        OTOPORB3
     C                   MOVEL     TMLIN4        OTOPORB4
     C                   MOVEL     TMLIN5        OTOPORB5
      *
      * If network is swift, find field type
      * otherwise default it to 'A'.
      *
     C     PNWRK         IFEQ      'SWIFT '
      *
      * Set up field type, if A->S, B->A, D->A
      *
     C     1             SUBST     TRTAG:4       #WK1              1
     C     #WK1          IFEQ      'A'
     C                   MOVEL     'S'           OTOPORBT
     C                   ELSE
      *
     C     #WK1          IFEQ      'B'
     C                   MOVEL     'A'           OTOPORBT
     C                   ELSE
     C                   MOVEL     'A'           OTOPORBT
     C                   END
     C                   END
      *
     C                   ELSE
      *
      * network is not swift
     C                   MOVEL     'A'           OTOPORBT
     C                   END
      *                                                                                     MD022446
      ** Map 52A from incoming message to ordering bank screen field                        MD022446
      *                                                                                     MD022446
     C     OTOPORB1      IFNE      *BLANKS                                                  MD022446
     C                   MOVEL     OTOPORB1      SORBK                                      MD022446
     C                   ENDIF                                                              MD022446
      *
     C                   ELSE
      * Sender details
      *
     C                   MOVEL     PSNDR         OTOPORB1
      *
      * If network is swift, set up field type to 'S'
      * otherwise default it to 'A'.
      *
     C     PNWRK         IFEQ      'SWIFT '
     C                   MOVEL     'S'           OTOPORBT
     C                   ELSE
     C                   MOVEL     'A'           OTOPORBT
     C                   END
      *
     C                   END
      *                                                                                       227538
      ** Save OTOPORB* fields for later use.                                                  227538
      *                                                                                       227538
     C     OTOPORB1      IFNE      *BLANKS                                                    227538
     C                   MOVEL(P)  OTOPORBT      JFOPORBT          1                          227538
     C                   MOVEL(P)  OTOPORB1      JFOPORB1         35                          227538
     C                   MOVEL(P)  OTOPORB2      JFOPORB2         35                          227538
     C                   MOVEL(P)  OTOPORB2      JFOPORB3         35                          227538
     C                   MOVEL(P)  OTOPORB4      JFOPORB4         35                          227538
     C                   MOVEL(P)  OTOPORB5      JFOPORB5         35                          227538
     C                   ENDIF                                                                227538
      *
      * If pay message from SWIFT move MT202 to order cust1
      * and OPORB* fields to fields 2 3 and 4.
      *
     C     P52           IFNE      *BLANKS
     C     SORC1         ANDEQ     *BLANKS
     C     PNWRK         ANDEQ     'SWIFT '
     C     PMTPY         IFEQ      '200'
     C     PMTPY         OREQ      '201'
     C     PMTPY         OREQ      '202'
     C     PMTPY         OREQ      '203'
     C     PMTPY         OREQ      '204'
     C     PMTPY         OREQ      '205'
     C                   MOVEL     ORCFLD        SORC1
     C**********         MOVEL     TMLIN1        SORC2                                      MD052529
     C**********         MOVEL     TMLIN2        SORC3                                      MD052529
     C**********         MOVEL     TMLIN3        SORC4                                      MD052529
     C**********         EVAL      SORC5 = TMLIN4                                    CFT032 MD052529
     C                   END
     C                   END
      *
      **Receiver's*Correspondent***************************************         CFT014
      ** Ordering Bank                                                          CFT014
     C     P52           IFEQ      *BLANKS                                                  MD022446
      *                                                                                     MD022446
                                                                                CFT014
      ** If Third Reimbursement Institution is not blank, use it                CFT014
      ** otherwise                                                              CFT014
      *
      * If Receivers Correspondent is not blank, use it
      * otherwise use Senders Correspondent. If both are blank
      * use Sender details.
      *
     C     P55           IFNE      *BLANKS                                      CFT014
     C                   MOVEL     P55           DSTRAN                         CFT014
     C                   MOVEL     TMLIN1        SORBK                          CFT014
     C                   ELSE                                                   CFT014
                                                                                CFT014
     C     P54           IFNE      *BLANKS
      *
     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     TMLIN1        SORBK
      *
     C                   ELSE
      *
     C     P53           IFNE      *BLANKS
     C                   MOVEL     P53           DSTRAN
     C                   MOVEL     TMLIN1        SORBK
      *
     C                   ELSE
      *
     C                   MOVEL     PSNDR         SORBK
      *
     C                   END
     C                   END
     C                   ENDIF                                                  CFT014
      *                                                                                     MD022446
     C                   ELSE                                                               MD022446
      *                                                                                     MD022446
      ** Map 52A from incoming message to ordering bank screen field                        MD022446
      *                                                                                     MD022446
     C                   MOVEL     P52           DSTRAN                                     MD022446
     C                   MOVEL     TMLIN1        SORBK                                      MD022446
     C                   ENDIF                                                              MD022446
      *                                                                                     MD022446
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
     C/COPY WNCPYSRC,JMI113_024                                                               JMI106
      *
      * Beneficiary
      *
      * If Beneficiary Customer is not blank, use it
      * otherwise use Beneficiary Institution details
      *
     C     P59           IFNE      *BLANKS
      *
     C                   MOVEL     P59           DSTRAN
     C                   MOVEL     TMLIN1        SBNC1
     C                   MOVEL     TMLIN2        SBNC2
     C                   MOVEL     TMLIN3        SBNC3
     C                   MOVEL     TMLIN4        SBNC4
     C                   MOVEL     TMLIN5        SBNC5
      *
     C                   ELSE
      *
     C     P58           IFNE      *BLANKS
     C                   MOVEL     P58           DSTRAN
     C                   MOVEL     TMLIN1        SBNC1
     C                   MOVEL     TMLIN2        SBNC2
     C                   MOVEL     TMLIN3        SBNC3
     C                   MOVEL     TMLIN4        SBNC4
     C                   MOVEL     TMLIN5        SBNC5
     C                   END
      *
     C                   END
      *
      * Msg Unique Reference
     C**********         Z-ADD     PHMSGR        OTOPMSGR                                     190845
     C                   Eval      SHMSGR = PHMSGR                                            190845
      *
      * Part Number
     C**********         Z-ADD     PHPART        OTOPKPRT                                     190845
     C                   Eval      SHPART = PHPART                                            190845
      *
      * Swift Priority Code
     C                   MOVE      PMPRY         SSWPC
      *
      * Branch Code
     C     PBRCA         IFNE      *BLANKS
     C                   MOVEL     PBRCA         SBRCA
     C                   END
      *
      * Related Reference
      *
      * If MT100 type of message use Transaction Reference no.
      * otherwise use related referance.
      *
     C     PMTPY         IFEQ      '100'
     C     PMTPY         OREQ      '103'                                                      257664
     C     PMTPY         OREQ      '202'                                                      255350
      *
     C     P20           IFNE      *BLANKS
     C                   MOVEL     P20           DSTRAN
     C                   MOVEL     TTREF         SRLPR
     C                   END
      *
     C                   ELSE
      *
     C     P21           IFNE      *BLANKS
     C                   MOVEL     P21           DSTRAN
     C                   MOVEL     TTREF         SRLPR
     C                   END
     C/COPY WNCPYSRC,JMI113_025                                                               JMI106
      *
     C                   END
                                                                                CFT014
     C     @CFT014       IFEQ      'Y'                                          CFT014
                                                                                CFT014
      ** Sender's Charge field                                                  CFT014
                                                                                CFT014
     C     P71FX         IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P71FX         DSTRAN                         CFT014
     C                   Z-ADD     1             I                              CFT014
     C                   MOVEL     *BLANK        LFLT                           CFT014
     C                   MOVEL     TMLIN1        TV1                            CFT014
     C                   MOVEL     TMLIN2        TV2                            CFT014
     C                   MOVEL     TMLIN3        TV3                            CFT014
     C                   MOVEL     TMLIN4        TV4                            CFT014
     C                   MOVEL     TMLIN5        TV5                            CFT014
                                                                                CFT014
     C     I             DOWLE     5                                            CFT014
     C     LFLT(I)       ANDNE     *BLANK                                       CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     LFLT(I)       DSTRAN                         CFT014
     C                   EXSR      RTPCA                                        CFT014
                                                                                CFT014
     C                   MOVEL     WCAAM         CGA(I)                         CFT014
     C                   MOVEL     WCACY         CGC(I)                         CFT014
     C                   ADD       1             I                              CFT014
     C                   ENDDO                                                  CFT014
                                                                                CFT014
      ** Update sender's charges valid file fields                              CFT014
                                                                                CFT014
     C                   MOVEL     MGSCC1        SSCC1                          CFT014
     C                   MOVEL     MGSCC2        SSCC2                          CFT014
     C                   MOVEL     MGSCC3        SSCC3                          CFT014
     C                   MOVEL     MGSCC4        SSCC4                          CFT014
     C                   MOVEL     MGSCC5        SSCC5                          CFT014
     C                   MOVE      MGSCH1        SSCH1                          CFT014
     C                   MOVE      MGSCH2        SSCH2                          CFT014
     C                   MOVE      MGSCH3        SSCH3                          CFT014
     C                   MOVE      MGSCH4        SSCH4                          CFT014
     C                   MOVE      MGSCH5        SSCH5                          CFT014

     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Receiver's Charge field                                                CFT014
                                                                                CFT014
     C     P71G          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     'N'           O2RCUS                         CFT014
     C                   MOVEL     P71G          DSTRAN                         CFT014
     C                   EXSR      RTPCA                                        CFT014
     C     *LIKE         DEFINE    WCACY         WRCHCY                         CFT014
     C     *LIKE         DEFINE    WCAAM         WRCHAM                         CFT014
                                                                                CFT014
      ** Memorize receiver's charges currency / amount                          CFT014
      ** to pass as input parameter to S/R OV32AM                               CFT014
                                                                                CFT014
     C                   MOVEL     WCACY         WRCHCY                         CFT014
     C                   MOVEL     WCAAM         WRCHAM                         CFT014
     C                   MOVEL     WCACY         WCYCCY                         CFT014
     C                   MOVEL     'N'           WCYDMP                         CFT014
     C                   EXSR      RTCCYD                                       CFT014
                                                                                CFT014
     C     WCYRTN        IFEQ      *BLANK                                       CFT014
     C                   MOVE      *BLANK        ZFIELD                         CFT014
     C                   MOVE      WCAAM         ZFIELD                         CFT014
     C     13            SUB       WCYNDP        ZADIG                          CFT014
     C                   Z-ADD     WCYNDP        ZADEC                          CFT014
     C                   CALLB     'ZALIGN'                                     CFT014
     C                   PARM                    ZalignOK                       CFT014
     C                   PARM                    ZFIELD                         CFT014
     C                   PARM                    ZADEC                          CFT014
     C                   PARM                    ZADIG                          CFT014
                                                                                CFT014
     C                   MOVE      ZFIELD        WRECCHG          16            CFT014
     C                   MOVE      ZFIELD        @RCRM                          CFT014
     C                   MOVE      'N'           @RCUS                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
      *
      * Value Date/Ccy/Amount
      *
     C     PDCA          IFNE      *BLANKS
     C                   SELECT                                                 CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
     C                   MOVEL     PDCA          DSTRAN                         CGL009
     C                   EXSR      RTPDCA                                       CGL009
     C                   MOVEL     W32CY         SPCCY                          CGL009
     C                   MOVEL     W32AM         WNLAM                          CGL009
     C                   EXSR      TSNULL                                       CGL009
     C     WNLNUL        IFEQ      'N'                                          CGL009
     C                   MOVEL     W32AM         SPYAM                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     *BLANK        SPYAM                          CGL009
     C                   ENDIF                                                  CGL009
     C     *LIKE         DEFINE    W32DYN        WVLDT                          CGL009
     C                   Z-ADD     W32DYN        WVLDT                          CGL009
     C                   MOVE      W32DT         SPYVD                          CGL009
     C                   MOVE      W32DT         SPYDT                          CGL009
      *                                                                         CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
     C                   MOVEL     PDCA          DSTRAN
      *
      * MMDDYY format display
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     TVVDAT        SWDT
     C                   MOVE      SDD           DD                2 0
     C                   MOVE      SYY           SDD
     C                   MOVE      SMM           SYY
     C                   MOVE      DD            SMM
     C                   MOVE      SWDT          SPYDT
     C                   ELSE
      *
      * DDMMYY format display
      *
     C                   MOVEL     TVVDAT        SWDT
     C                   MOVE      SDD           DD
     C                   MOVE      SYY           SDD
     C                   MOVE      DD            SYY
     C                   MOVE      SWDT          SPYDT
     C                   END
      *
      * Currency
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C     @CFT012       IFEQ      'N'                                          CFT012
     C                   MOVEL     TVCCY         SSMCY
     C                   ELSE                                                   CFT012
     C                   MOVEL     TVCCY         SPCCY                          CFT012
     C                   END                                                    CFT012
      * Amount
      *
      * Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     TVAMT         YA1
     C                   Z-ADD     1             C                 3 0
      *
     C     C             DOUGT     15
      *
     C     YA1(C)        IFEQ      ','
     C                   MOVE      '.'           YA1(C)
     C                   Z-ADD     16            C
     C                   ELSE
     C                   ADD       1             C
     C                   END
      *
     C                   END
      *
     C                   MOVEA     YA1           AMT              15
     C     @CFT012       IFEQ      'N'                                          CFT012
     C     @CFT014       IFEQ      'Y'                                          CFT014
     C     P71G          ANDNE     *BLANK                                       CFT014
                                                                                CFT014
      ** Need to overwrite transaction amount to allow for the                  CFT014
      ** receiver's charges                                                     CFT014
                                                                                CFT014
     C                   MOVE      *BLANK        WDATE             6            CFT014
     C                   MOVEL     SWDT          WDATE                          CFT014
                                                                                CFT014
     C                   CALLB     'ZDATE1'                                     CFT014
     C                   PARM                    WDATE                          CFT014
     C                   PARM      *ZEROS        ZDAYNO                         CFT014
     C                   PARM                    BJDFIN                         CFT014
     C                   PARM                    ErrorFlag         1            CFT014
                                                                                CFT014
     C                   Z-ADD     ZDAYNO        WOVVLD                         CFT014
     C                   MOVEL     SSMCY         WOVICY                         CFT014
     C                   MOVEL     AMT           WOVIAM                         CFT014
     C                   MOVEL     WRCHCY        WOVRCY                         CFT014
     C                   MOVEL     WRCHAM        WOVRAM                         CFT014
     C                   MOVEL     '*SUB'        WOVOPR                         CFT014
     C                   EXSR      OV32AM                                       CFT014
     C                   MOVEL     WOVAMT        SSMAM                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     AMT           SSMAM
     C                   ENDIF                                                  CFT014
     C                   ELSE                                                   CFT014
     C     @CFT014       IFEQ      'Y'                                          CFT014
     C     P71G          ANDNE     *BLANK                                       CFT014
     C                   MOVEL     *BLANK        SSMAM                          CFT014
                                                                                CFT014
      ** Need to overwrite transaction amount to allow for the                  CFT014
      ** receiver's charges                                                     CFT014
                                                                                CFT014
     C                   MOVE      *BLANK        WDATE                          CFT014
     C                   MOVEL     SWDT          WDATE                          CFT014
                                                                                CFT014
     C                   CALLB     'ZDATE1'                                     CFT014
     C                   PARM                    WDATE                          CFT014
     C                   PARM      *ZEROS        ZDAYNO                         CFT014
     C                   PARM                    BJDFIN                         CFT014
     C                   PARM                    ErrorFlag         1            CFT014
                                                                                CFT014
     C                   Z-ADD     ZDAYNO        WOVVLD                         CFT014
     C                   MOVEL     SPCCY         WOVICY                         CFT014
     C                   MOVEL     AMT           WOVIAM                         CFT014
     C                   MOVEL     WRCHCY        WOVRCY                         CFT014
     C                   MOVEL     WRCHAM        WOVRAM                         CFT014
     C                   MOVEL     '*SUB'        WOVOPR                         CFT014
     C                   EXSR      OV32AM                                       CFT014
     C                   MOVEL     WOVAMT        SPYAM                          CFT014
     C                   ELSE                                                   CFT012
     C                   MOVEL     AMT           SPYAM                          CFT012
     C                   MOVEL     *BLANK        SSMAM                          CFT012
     C                   ENDIF                                                  CFT014
     C                   END                                                    CFT012
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *                                                                         CGL009
     C                   END
                                                                                CFT014
      ** Convert amount to Pay currency if Receiver's currency is not equal to  CFT014
      ** Pay currency                                                           CFT014
                                                                                CFT014
     C     @CFT014       IFEQ      'Y'                                          CFT014
     C                   IF        (SPCCY <> *BLANK) AND (@CFT012 = 'Y')        CFT014
     C                   MOVE      SPCCY         WPAYCY            3            CFT014
     C                   ELSE                                                   CFT014
     C                   IF        (SSMCY <> *BLANK) AND (@CFT012 = 'N')        CFT014
     C                   MOVE      SSMCY         WPAYCY                         CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     WPAYCY        IFNE      WRCHCY                                       CFT014
     C                   CLEAR                   P#0010                         CFT014
     C                   MOVEL     WRCHCY        P#FRCY                         CFT014
     C                   MOVE      WRECCHG       P#FRAM                         CFT014
     C                   MOVEL     WPAYCY        P#TOCY                         CFT014
     C                   Z-ADD     0             P#TOAM                         CFT014
     C                   Z-ADD     0             P#RATE                         CFT014
     C                   CALL      'FT0010'                                     CFT014
     C                   PARM                    P#0010                         CFT014
                                                                                CFT014
     C     P#RTCD        IFNE      *BLANK                                       CFT014
     C                   Movel     'FT0010  '    DBFILE                         CFT014
     C                   Movel     '*CALL  '     DBKEY                          CFT014
     C                   Z-ADD     86            DBASE                          CFT014
     C                   EXSR      *PSSR                                        CFT014
     C                   ELSE                                                   CFT014
     C                   Z-ADD     P#TOAM        @RCRM                          CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C/COPY WNCPYSRC,JMI113_026                                                               JMI106
      *
      * Details of Charges
      *
     C     P71           IFNE      *BLANKS
     C                   MOVEL     P71           DSTRAN
     C                   MOVEL     TTREF         SDTCH
     C     PNWRK         IFEQ      'FONTIS'                                     CGL009
     C     TTREF         IFEQ      'OUR'                                        CGL009
     C                   MOVEL     'A'           SADDC                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     'D'           SADDC                          CGL009
     C                   ENDIF                                                  CGL009
     C                   ELSE                                                   CFT014
     C     @CFT014       IFEQ      'Y'                                          CFT014
     C     TTREF         IFEQ      'OUR'                                        CFT014
     C                   MOVEL     'A'           SADDC                          CFT014
     C                   ELSE                                                   CFT014
     C                   MOVEL     'D'           SADDC                          CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
     C     PNWRK         IFEQ      'FONTIS'                                     CGL009
     C                   MOVEL     'D'           SADDC                          CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   END
      *
      **  Additional Mapping for CASHIER.
      *
      **  Draft Currency, Draft Amount.
      *
     C     SDCA          IFNE      *BLANKS
     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     SDCA          DSTRAN
      *
     C     TVVDAT        IFNE      0
      *
      **  MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     TVVDAT        SWDT1             6
     C     2             SUBST     SWDT1:5       MM
     C     2             SUBST     SWDT1:3       DDS
     C     2             SUBST     SWDT1:1       YY
     C                   MOVEL     SWDT2         SPYDT
     C                   ELSE
      *
      **  DDMMYY format display.
      *
     C                   MOVEL     TVVDAT        SWDT1             6
     C     2             SUBST     SWDT1:5       DDS
     C     2             SUBST     SWDT1:3       MM
     C     2             SUBST     SWDT1:1       YY
     C                   MOVEL     SWDT2         SPYDT
     C                   END
     C                   END
      *
      **  Currency.
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         SPCCY
      *
      **  Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       YA1
     C                   MOVEA     TVAMT         YA1
     C                   Z-ADD     1             C                 3 0
      *
     C     C             DOUGT     15
     C     YA1(C)        IFEQ      ','
     C                   MOVE      '.'           YA1(C)
     C                   Z-ADD     16            C
     C                   ELSE
     C                   ADD       1             C
     C                   END
     C                   END
      *
     C                   MOVEA     YA1           AMT              15
     C                   MOVEL     AMT           SPYAM
     C                   END
      *
      **  Funding Currency, Funding Amount.
      *
     C     PDC2          IFNE      *BLANKS
     C                   Z-ADD     0             TVVDAT
     C                   MOVEL     PDC2          DSTRAN
      *
     C     TVVDAT        IFNE      0
      *
      **  MMDDYY format display.
      *
     C     BJDFIN        IFEQ      'M'
     C                   MOVEL     TVVDAT        SWDT1             6
     C     2             SUBST     SWDT1:5       MM
     C     2             SUBST     SWDT1:3       DDS
     C     2             SUBST     SWDT1:1       YY
     C                   MOVEL     SWDT2         SPYDT
     C                   ELSE
      *
      **  DDMMYY format display.
      *
     C                   MOVEL     TVVDAT        SWDT1             6
     C     2             SUBST     SWDT1:5       DDS
     C     2             SUBST     SWDT1:3       MM
     C     2             SUBST     SWDT1:1       YY
     C                   MOVEL     SWDT2         SPYDT
     C                   END
     C                   END
      *
      **  Currency.
      *
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         SSMCY
      *
      **  Format amount field (change ',' decimal point to '.').
      *
     C                   MOVEA     *BLANKS       YA1
     C                   MOVEA     TVAMT         YA1
     C                   Z-ADD     1             C                 3 0
      *
     C     C             DOUGT     15
     C     YA1(C)        IFEQ      ','
     C                   MOVE      '.'           YA1(C)
     C                   Z-ADD     16            C
     C                   ELSE
     C                   ADD       1             C
     C                   END
     C                   END
      *
     C                   MOVEA     YA1           AMT              15
     C                   MOVEL     AMT           SSMAM
     C                   END
      *                                                                         CGL009
      * Bank to Bank Information                                                CGL009
      *                                                                         CGL009
     C                   SELECT                                                 CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
     C     P72           IFEQ      *BLANKS                                      CGL009
      ** Should never happen because FONTIS is supposed to send the             175475
      ** settlement currency via :72: /ORIG/                                    175475
      ***Settlement*CCY*will*be*the*same*as*the*account*to*be*debite      CGL009175475
     C*********************MOVELW53CCY    SSMCY                           CGL009175475
     C                   MOVEL     *BLANKS       SBBI1                          CGL009
     C                   MOVEL     *BLANKS       SBBI2                          CGL009
     C                   MOVEL     *BLANKS       SBBI3                          CGL009
     C                   MOVEL     *BLANKS       SBBI4                          CGL009
     C                   MOVEL     *BLANKS       SBBI5                          CGL009
     C                   MOVEL     *BLANKS       SBBI6                          CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
     C                   MOVEL     P72           DSFONT                         CGL009
     C                   MOVEL     '/ORIG/'      WCW                            CGL009
     C                   MOVEL     FONT72        WCWLIN                         CGL009
     C                   EXSR      CWAMCY                                       CGL009
     C     WCWCY         IFNE      *BLANK                                       CGL009
     C                   MOVEL     WCWCY         SSMCY                          CGL009
     C                   ELSE                                                   CGL009
      ** Should never happen because FONTIS is supposed to send the             175475
      ** settlement currency via :72: /ORIG/                                    175475
     C*********************MOVELW53CCY    SSMCY                           CGL009175475
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   MOVEL     '/REF/'       WCW                            175479
     C                   MOVEL     FONT72        WCWLIN                         175479
     C                   Z-ADD     30            WCWLEN                         175479
     C                   EXSR      CWVAL                                        175479
     C     WCWVAL        IFNE      *BLANK                                       175479
     C                   MOVEL     WCWVAL        SFDLR                          175479
     C                   ENDIF                                                  175479
      *                                                                         175479
     C                   MOVEL     WCWAM         WNLAM                          CGL009
     C                   EXSR      TSNULL                                       CGL009
     C     WNLNUL        IFEQ      'N'                                          CGL009
     C                   MOVEL     WCWAM         SSMAM                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     *BLANK        SSMAM                          CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C     @CEU006       IFEQ      'Y'                                          CGL009
      **  Retrieve notified delivery currency and amount                        CGL009
     C                   MOVEL     '/OCMT/'      WCW                            CGL009
     C                   MOVEL     FONT72        WCWLIN                         CGL009
     C                   EXSR      CWAMCY                                       CGL009
     C     WCWCY         IFNE      *BLANK                                       CGL009
     C                   MOVEL     WCWCY         SPDCY                          CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   MOVEL     '/RATE/'      WCW                            CGL009
     C                   MOVEL     FONT72        WCWLIN                         CGL009
     C                   EXSR      CWRATE                                       CGL009
     C                   MOVEL     WCWRT         WNLAM                          CGL009
     C                   EXSR      TSNULL                                       CGL009
     C     WNLNUL        IFEQ      'Y'                                          CGL009
     C                   MOVEL     *BLANK        WCWRT                          CGL009
     C                   ELSE                                                   CGL009
      ** Decimal places in FT are stored on 8 digits                            CGL009
      ** => truncated if greater                                                CGL009
     C     WCWDPT        IFGT      8                                            CGL009
     C     '.'           SCAN      WCWRT         I                 2 0          CGL009
      ** Extract Digits + comma                                                 CGL009
     C     I             SUBST(P)  WCWRT:1       #014A            14            CGL009
     C                   ADD       1             I                 2 0          CGL009
      ** Extract Decimals after comma                                           CGL009
     C     8             SUBST(P)  WCWRT:I       #008A             8            CGL009
     C     #014A         CAT(P)    #008A:0       WCWRT                          CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C     WCWRT         IFNE      *BLANK                                       CGL009
      *                                                                         CGL009
     C                   MOVE(P)   WCWRT         SRATE                          CGL009
      ** code work /RATE/ found in Bank to Bank information                     CGL009
     C                   ENDIF                                                  CGL009
     C*                                                                         CGL009
     C                   EXSR      ICCHK                                        CGL009
     C*                                                                         CGL009
     C     FOUND         IFEQ      'Y'                                          CGL009
     C                   MOVEL     *BLANK        SBBI6                          CGL009
     C                   MOVEL     FN72L2        SBBI1                          CGL009
     C                   MOVEL     FN72L3        SBBI2                          CGL009
     C                   MOVEL     FN72L4        SBBI3                          CGL009
     C                   MOVEL     FN72L5        SBBI4                          CGL009
     C                   MOVEL     FN72L6        SBBI5                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     FN72L1        SBBI1                          CGL009
     C                   MOVEL     FN72L2        SBBI2                          CGL009
     C                   MOVEL     FN72L3        SBBI3                          CGL009
     C                   MOVEL     FN72L4        SBBI4                          CGL009
     C                   MOVEL     FN72L5        SBBI5                          CGL009
     C                   MOVEL     FN72L6        SBBI6                          CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
     C     P72           IFNE      *BLANKS                                                    208791
     C                   MOVEL     P72           DSTRAN                                       208791
     C                   MOVEL     TMLIN1        SBBI1                                        208791
     C                   MOVEL     TMLIN2        SBBI2                                        208791
     C                   MOVEL     TMLIN3        SBBI3                                        208791
     C                   MOVEL     TMLIN4        SBBI4                                        208791
     C                   MOVEL     TMLIN5        SBBI5                                        208791
     C                   MOVEL     TMLIN6        SBBI6                                        208791
     C                   ENDIF                                                                208791
      *                                                                                       208791
      *
      **  Retrieve notified delivery currency and amount
      *
     C*******************MOVEL     '012345'      @CHK             11            CGL009
     C*******************MOVE      '6789.'       @CHK                           CGL009
      *
     C     '/OCMT/'      SCAN      P72:1         @F                3 0    81
      *
     C     *IN81         IFEQ      *ON
      *
      * Map currency code -> SNDCY
     C                   ADD       6             @F
     C     3             SUBST     P72:@F        SNDCY
      *                                                                                       225169
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      SNDCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         SNDCY                                        225169
      *                                                                                       225169
      * Map amount -> NDAMA
      * Move possible 15 chars to work array and work string
     C                   ADD       3             @F
     C     15            SUBST     P72:@F        @S               15
     C                   MOVEA     @S            @A
     C                   CLEAR                   @S
      *
      * If ',' in amount string @S change to '.'
      * Only need to check valid chars till one ',' found
     C                   Z-ADD     1             @C                3 0
     C                   MOVE      *BLANKS       @T                1
      *
     C     1             DO        15            @C
     C                   MOVE      @A(@C)        @T
     C     @T            IFEQ      ','
     C                   MOVE      '.'           @A(@C)
     C                   LEAVE
     C                   ENDIF
     C                   ENDDO
      *
     C                   Z-ADD     1             @C
     C                   MOVE      *BLANKS       @T                1
     C                   MOVEA     @A            @S
      * Get amount - upto 15 chars possible
     C     @C            DOUGT     15
     C                   MOVE      @A(@C)        @T
     C     @CHK          CHECK     @T            @F                       82
      *
      * Char not valid must be end of amount
     C     *IN82         IFEQ      *ON
     C     @C            IFNE      1
     C     @C            SUB       1             @F
     C     @F            SUBST     @S:1          SNDAM
     C                   ENDIF
     C                   LEAVE
     C                   ENDIF
      * All chars in string ok
     C     @C            IFEQ      15
     C                   MOVEL     @S            SNDAM
     C                   ENDIF
      *
     C                   ADD       1             @C
      *
     C                   ENDDO
     C/COPY WNCPYSRC,FTOPA1SC14
      *
     C                   ENDIF
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
     C/COPY WNCPYSRC,JMI113_027                                                               JMI113
      *
      * Destination                                                             CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      *                                                                         CGL009
      ** If 56 present, use this to derive Destination, else 57                 CGL009
     C     P56           IFNE      *BLANK                                       CGL009
     C                   MOVEL     P56           DSTRAN                         CGL009
      ** Also, along the way, always default Int Bank to 56                     CGL009
     C                   MOVEL     TMLIN1        SINB1                          CGL009
     C                   MOVEL     TMLIN2        SINB2                          CGL009
     C                   MOVEL     TMLIN3        SINB3                          CGL009
     C                   MOVEL     TMLIN4        SINB4                          CGL009
     C                   MOVEL     TMLIN5        SINB5                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     P57           DSTRAN                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C     1             SUBST     TRTAG:4       #001A             1            CGL009
      ** Only applicable :56A:                                                  CGL009
     C     #001A         IFEQ      'A'                                          CGL009
     C                   MOVEL     TMLIN1        #001A                          CGL009
     C     #001A         IFEQ      '/'                                          CGL009
     C                   MOVEA     TMLIN2        @I35                           CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEA     TMLIN1        @I35                           CGL009
     C                   ENDIF                                                  CGL009
     C                   EXSR      SLSH35                                       CGL009
     C     8             SUBST     O35:1         W9BICC                         CGL009
     C     3             SUBST     O35:9         W9BICB                         CGL009
      *                                                                         CGL009
     C                   CALL      'ME1400'                                     CGL009
     C                   PARM      *BLANKS       W9RTN             7            CGL009
     C                   PARM                    W9BICC            8            CGL009
     C                   PARM                    W9BICB            3            CGL009
     C                   PARM                    SDCUST                         CGL009
     C                   PARM                    SDCNST                         CGL009
     C                   PARM                    MEBICD                         CGL009
     C                   PARM      *BLANKS       W9CUST            1            CGL009
     C                   PARM      *BLANKS       W9CNST            1            CGL009
     C                   PARM      *BLANKS       W9BICD            1            CGL009
      *                                                                         CGL009
      * If Customer details found                                               CGL009
      *                                                                         CGL009
     C     W9CUST        IFEQ      'Y'                                          CGL009
     C     KNOST3        KLIST                                                  CGL009
     C                   KFLD                    SPCCY                          CGL009
     C                   KFLD                    BBCUST                         CGL009
     C     KNOST3        CHAIN     SDNOSTL3                           90        CGL009
     C     *IN90         IFEQ      '0'                                          CGL009
     C                   MOVEL     A7CYCD        WNOCCY                         CGL009
     C                   MOVEL     A7NONB        WNONUM                         CGL009
     C                   MOVEL     DSNOST        SDST1                          CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C     SDST1         IFEQ      *BLANK                                       CGL009
     C     SPCCY         CHAIN     MEFNODL1                           90        CGL009
     C     *IN90         IFEQ      '0'                                          CGL009
     C     @CEU006       IFEQ      'Y'                                          CGL009
     C     FHEURO        IFEQ      'Y'                                          CGL009
     C***********BKEURO    CHAINMEFNODL1             90                   CGL009175469
     C************IN90     IFEQ '0'                                       CGL009175469
     C     FHEUNO        IFNE      *BLANK                                       175469
      ** The rate in /RATE/ is no longer applicable between Settlmt and         CGL009
      ** Payment amounts (now converted in BKEURO)                              CGL009
     C                   MOVEL     *BLANK        SRATE                          CGL009
      ** /OCMT/ is redundant                                                    CGL009
     C                   MOVEL     *BLANK        SPDCY                          CGL009
     C                   MOVEL     *BLANK        SPDAM                          CGL009
      *                                                                         CGL009
     C     SSMAM         IFNE      *BLANK                                       CGL009
      ** Payment will be computed by the validation programm                    CGL009
     C                   MOVE      *BLANK        SPYAM                          CGL009
      ** Destination changes => payment currency changes                        CGL009
     C                   MOVEL     BKEURO        SPCCY                          CGL009
      *                                                                         CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
      ** Convert the old payment amount into the EURO currency                  CGL009
     C                   CLEAR                   P#0010                         CGL009
      *                                                                         CGL009
      ** Retrieve details of payment currency                                   CGL009
     C                   MOVEL     SPCCY         WCYCCY                         CGL009
     C                   MOVEL     'N'           WCYDMP                         CGL009
     C                   EXSR      RTCCYD                                       CGL009
     C     WCYRTN        IFNE      *BLANK                                       CGL009
      ** Blank the amount to make the validation fail.                          CGL009
      ** (Unknown currency or both amounts null)                                CGL009
     C                   MOVE      *BLANK        SPYAM                          CGL009
     C                   ELSE                                                   CGL009
     C                   Z-ADD     WCYNDP        PCNBDP                         CGL009
      *                                                                         CGL009
      ** Retrieve details of BKEURO currency                                    CGL009
     C                   MOVEL     BKEURO        WCYCCY                         CGL009
     C                   MOVEL     'N'           WCYDMP                         CGL009
     C                   EXSR      RTCCYD                                       CGL009
     C     WCYRTN        IFNE      *BLANK                                       CGL009
     C                   MOVEL     BKEURO        SPCCY                          CGL009
     C                   MOVE      *BLANK        SPYAM                          CGL009
     C                   ELSE                                                   CGL009
     C                   Z-ADD     WCYNDP        EUNBDP                         CGL009
      *                                                                         CGL009
      ** Format payment amount for FT0010                                       CGL009
     C                   MOVEL     *BLANK        ZFIELD                         CGL009
     C                   MOVE      SPYAM         ZFIELD                         CGL009
     C     13            SUB       PCNBDP        ZADIG                          CGL009
     C                   Z-ADD     PCNBDP        ZADEC                          CGL009
     C                   CALLB     'ZALIGN'                                     CGL009
     C                   Parm                    ZalignOK                       CGL009
     C                   Parm                    ZFIELD                         CGL009
     C                   Parm                    ZADEC                          CGL009
     C                   Parm                    ZADIG                          CGL009
     C                   MOVE      ZFIELD        P#FRAM                         CGL009
     C                   MOVEL     SPCCY         P#FRCY                         CGL009
      *                                                                         CGL009
     C                   Z-ADD     WVLDT         P#FRDT                         CGL009
     C                   Z-ADD     WVLDT         P#TODT                         CGL009
     C                   MOVEL     BKEURO        P#TOCY                         CGL009
     C                   Z-ADD     0             P#TOAM                         CGL009
     C                   Z-ADD     0             P#RATE                         CGL009
     C                   CALL      'FT0010'                                     CGL009
     C                   PARM                    P#0010                         CGL009
      *                                                                         CGL009
     C     P#RTCD        IFNE      *BLANK                                       CGL009
     C                   MOVEL     'FT0010  '    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL  '     DBKEY                          CGL009
     C                   Z-ADD     68            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
      * Move the original payment ccy and amount to pay delivery                170801
      * currency and amount                                                     170801
     C                   MOVE      SPCCY         SPDCY                          170801
     C                   MOVE      SPYAM         SPDAM                          170801
     C*                                                                         170801
      ** Format BKEURO amount                                                   CGL009
     C                   MOVEL     *BLANK        ZFIELD                         CGL009
     C                   MOVE      P#TOAM        ZFIELD                         CGL009
     C                   Z-ADD     EUNBDP        ZADEC                          CGL009
     C                   CALLB     'ZEDIT'                                      CGL009
     C                   PARM                    ZFIELD           16            CGL009
     C                   PARM                    ZADEC             1 0          CGL009
     C                   MOVE      ZFIELD        SPYAM                          CGL009
     C                   MOVEL     SPYAM         WNLAM                          CGL009
     C                   EXSR      TSNULL                                       CGL009
     C     WNLNUL        IFEQ      'Y'                                          CGL009
     C                   MOVEL     *BLANK        SPYAM                          CGL009
     C                   ENDIF                                                  CGL009
     C                   MOVEL     BKEURO        SPCCY                          CGL009
      *                                                                         CGL009
      ** The amount has been successfully converted in BKEURO                   CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Details of BKEURO ccy found                                            CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Details of payment currency found                                      CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Settlement amount is not blank                                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Default EURO nostro found                                              CGL009
     C                   MOVEL     BKEURO        WNOCCY                         175469
     C                   MOVEL     FHEUNO        WNONUM                         175469
     C                   ELSE                                                   175469
      ** Default EURO nostro not found                                          175469
     C                   MOVEL     FHCYCD        WNOCCY                         175469
     C                   MOVEL     FHNOSN        WNONUM                         175469
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Default nostro is marked as EURO                                       CGL009
     C                   ELSE                                                   175469
      ** Default nostro is not marked as EURO                                   175469
     C                   MOVEL     FHCYCD        WNOCCY                         175469
     C                   MOVEL     FHNOSN        WNONUM                         175469
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** CEU006 is on                                                           CGL009
     C                   ENDIF                                                  CGL009
     C*********************MOVELFHCYCD    WNOCCY                          CGL009175469
     C*********************MOVELFHNOSN    WNONUM                          CGL009175469
     C                   MOVEL     DSNOST        SDST1                          CGL009
      *                                                                         CGL009
      ** Default nostro found                                                   CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Destination is still not filled                                        CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      * Account with Bank (always filled)                                       CGL009
      *                                                                         CGL009
     C                   MOVEL     P57           DSTRAN                         CGL009
      ** Format FONTIS branch code                                              175477
     C                   EXSR      FONBNK                                       175477
     C                   MOVEL     TMLIN1        SACB1                          CGL009
     C                   MOVEL     TMLIN2        SACB2                          CGL009
     C                   MOVEL     TMLIN3        SACB3                          CGL009
     C                   MOVEL     TMLIN4        SACB4                          CGL009
     C                   MOVEL     TMLIN5        SACB5                          CGL009
      ** Alter the existing tag value in case non translated part is            175477
      ** used in S/R SROSWT SROCLR                                              175477
     C                   MOVEL     DSTRAN        P57                            175477
      *                                                                         CGL009
      ** Other networks                                                         CGL009
     C                   OTHER                                                  CGL009
      *                                                                         CGL009
      * If Intermediary Bank is blank, use 'A/c with Institution'               CGL009
      * details, otherwise use Intermediary Bank details                        CGL009
      *                                                                         CGL009
     C     P56           IFEQ      *BLANKS                                      CGL009
      *                                                                         CGL009
     C     P57           IFNE      *BLANKS                                      CGL009
     C                   MOVEL     P57           DSTRAN                         CGL009
     C                   MOVEL     TMLIN1        SDST1                          CGL009
     C                   MOVEL     TMLIN2        SDST2                          CGL009
     C                   MOVEL     TMLIN3        SDST3                          CGL009
     C                   MOVEL     TMLIN4        SDST4                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     P58           DSTRAN                         CGL009
     C                   MOVEL     TMLIN1        SDST1                          CGL009
     C                   MOVEL     TMLIN2        SDST2                          CGL009
     C                   MOVEL     TMLIN3        SDST3                          CGL009
     C                   MOVEL     TMLIN4        SDST4                          CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
      * Intermediary Bank entered                                               CGL009
      *                                                                         CGL009
     C                   MOVEL     P56           DSTRAN                         CGL009
     C                   MOVEL     TMLIN1        SDST1                          CGL009
     C                   MOVEL     TMLIN2        SDST2                          CGL009
     C                   MOVEL     TMLIN3        SDST3                          CGL009
     C                   MOVEL     TMLIN4        SDST4                          CGL009
      *                                                                         CGL009
      * Account with Bank (only filled if Intermediary Bank exist)              CGL009
      *                                                                         CGL009
     C     P57           IFNE      *BLANKS                                      CGL009
     C                   MOVEL     P57           DSTRAN                         CGL009
     C                   MOVEL     TMLIN1        SACB1                          CGL009
     C                   MOVEL     TMLIN2        SACB2                          CGL009
     C                   MOVEL     TMLIN3        SACB3                          CGL009
     C                   MOVEL     TMLIN4        SACB4                          CGL009
     C                   MOVEL     TMLIN5        SACB5                          CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *                                                                                       242100
     C     P57           IFNE      *BLANKS                                                    242100
     C                   MOVEL     P57           DSTRAN                                       242100
     C                   MOVEL     TMLIN1        SACB1                                        242100
     C                   MOVEL     TMLIN2        SACB2                                        242100
     C                   MOVEL     TMLIN3        SACB3                                        242100
     C                   MOVEL     TMLIN4        SACB4                                        242100
     C                   MOVEL     TMLIN5        SACB5                                        242100
     C                   END                                                                  242100
      *                                                                                       242100
     C/COPY WNCPYSRC,JMI113_028                                                               JMI113
      *                                                                         CGL009
      ****Map*details*of payment for Fontis network only                               CGL009 212575
      *   Map details of payment                                                              212575
      *                                                                         CGL009
     C*****PNWRK         IFEQ      'FONTIS'                                            CGL009 212575
     C*****P70**         ANDNE     *BLANKS                                             CGL009 212575
     C     P70           IFNE      *BLANKS                                                    212575
     C                   MOVEL     P70           DSTRAN                         CGL009
     C                   MOVEL     TMLIN1        SDTP1                          CGL009
     C                   MOVEL     TMLIN2        SDTP2                          CGL009
     C                   MOVEL     TMLIN3        SDTP3                          CGL009
     C                   MOVEL     TMLIN4        SDTP4                          CGL009
     C                   ELSE                                                                 212575
     C                   MOVEL     *BLANKS       SDTP1                                        212575
     C                   MOVEL     *BLANKS       SDTP2                                        212575
     C                   MOVEL     *BLANKS       SDTP3                                        212575
     C                   MOVEL     *BLANKS       SDTP4                                        212575
     C                   END                                                    CGL009
     C/COPY WNCPYSRC,JMI113_029                                                               JMI113
      *                                                                                       CER030
      ** Details of Extended Narrative                                                        CER030
      *                                                                                       CER030
     C     PEXN          IFNE      *BLANKS                                                    CER030
     C                   MOVEL     PEXN          DSTRAN                                       CER030
     C                   MOVEL     TMLIN1        SEXT1                                        CER030
     C                   MOVEL     TMLIN2        SEXT2                                        CER030
     C                   MOVEL     TMLIN3        SEXT3                                        CER030
     C                   MOVEL     TMLIN4        SEXT4                                        CER030
     C                   MOVEL     TMLIN5        SEXT5                                        CER030
     C                   MOVEL     TMLIN6        SEXT6                                        CER030
     C                   ENDIF                                                                CER030
      *
      **  Rate.
      *
     C     SPYAM         IFNE      *BLANKS
     C     SSMAM         ANDNE     *BLANKS
     C     SRATE         ANDEQ     *BLANK                                       CGL009
      *
      **  Get the numeric value of SPYAM.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RETC             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SPCCY         @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RETC         IFNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    DBFILE
     C                   MOVEL     '*CALL'       DBKEY
     C                   Z-ADD     36            DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6NBDP        WPNBDP            1 0
      *
      **  Align amount.
      *
     C                   Z-ADD     WPNBDP        ZADEC
     C     11            SUB       WPNBDP        ZADIG
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      SPYAM         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
      *
     C                   MOVE      ZFIELD        WPYAM2           11 0
      *
      **  Get the numeric value of SSMAM.
      *
     C                   CALL      'AOCURRR0'
     C                   PARM      *BLANKS       @RETC             7
     C                   PARM      '*KEY   '     @OPTN             7
     C                   PARM      SSMCY         @CURR             3
     C     SDCURR        PARM      SDCURR        DSSDY
      *
     C     @RETC         IFNE      *BLANKS
     C                   MOVEL     'AOCURRR0'    DBFILE
     C                   MOVEL     '*CALL'       DBKEY
     C                   Z-ADD     37            DBASE
     C                   EXSR      *PSSR
     C                   END
     C                   Z-ADD     A6NBDP        WSNBDP            1 0
      *
      **  Align amount.
      *
     C                   Z-ADD     WSNBDP        ZADEC
     C     11            SUB       WSNBDP        ZADIG
     C                   MOVEL     *BLANK        ZFIELD
     C                   MOVE      SSMAM         ZFIELD
     C                   CALLB     'ZALIGN'
     C                   Parm                    ZalignOK
     C                   Parm                    ZFIELD
     C                   Parm                    ZADEC
     C                   Parm                    ZADIG
      *
     C                   MOVE      ZFIELD        WSMAM2           11 0
      *
     C     WPYAM2        IFNE      0
     C     WSMAM2        ANDNE     0
      *
      **  Calculate the rate by dividing the larger amt by the smaller amt
      *
     C     WPYAM2        IFGE      WSMAM2
     C     WPYAM2        DIV       WSMAM2        WRATE2           11 7
     C                   MOVE      0             SSMAM
     C                   END
     C     WSMAM2        IFGT      WPYAM2
     C     WPYAM2        DIV       WSMAM2        WRATE2
     C                   MOVE      0             SPYAM
     C                   END
      *
      **  Format rate field.
      *
     C                   MOVE      *BLANKS       ZFIELD
     C                   MOVE      WRATE2        ZFIELD
     C                   Z-ADD     7             ZADEC
     C                   CALLB     'ZEDIT'
     C                   PARM                    ZFIELD           16
     C                   PARM                    ZADEC             1 0
     C                   MOVE      ZFIELD        SRATE
     C                   END
      *
     C                   END
      *
     C     PNWRK         IFEQ      'CASHV8'
      *
      **  Receiver Correspondent and Ordering Bank.
      *
     C     P54           IFNE      *BLANKS
     C                   MOVEL     P54           DSTRAN
     C                   MOVEL     *BLANKS       SRCO1
     C                   MOVEL     TMLIN         SRCO1
     C                   MOVEL     *BLANKS       SORBK
     C                   MOVEL     TMLIN         SORBK
      *
     C                   ELSE
      *
      **  Use the default account code from CASH dataarea and build the
      **  account number.
      *
      **  Get branch internal customer.
      *
     C**********         CALL      'AOBRCHR0'                                                 CGL029
     C                   CALL      'AOBRCHR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      SBRCA         #BRCA             3
     C*****SDBRCH        PARM      SDBRCH        DSFDY                                        CGL029
     C     SDBRCH        PARM      SDBRCH        DSSDY                                        CGL029
      *
      **  If record not found.
      *
     C     @RTCD         IFNE      *BLANK
     C                   MOVEL     'AOBRCHR0'    DBFILE
     C                   MOVEL     '*CALL'       DBKEY
     C                   Z-ADD     38            DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      **  Retrieve retail account number.
      *
     C                   MOVE      A8BICN        CNUM
     C                   MOVEL     SSMCY         CCY
     C                   MOVE      DACACD        ACOD
     C                   Z-ADD     1             ACSQ
     C                   MOVEL     SBRCA         ABRCA
      *
     C     AKEY          CHAIN     ACCNT                              90
      *
      **  If record not found.
      *
     C     *IN90         IFEQ      '1'
     C                   MOVEL     'ACCNT'       DBFILE
     C                   MOVEL     AKEYF         DBKEY
     C                   Z-ADD     39            DBASE
     C                   EXSR      *PSSR
     C                   END
      *
      ** Move retail account number to receiver's correspondent
      *
     C                   MOVEL     *BLANKS       SRCO1
     C                   MOVE      ACNO          SRCO1
      *
     C                   END
      *
      ** Account with Institution and Destination
      *
     C     P57           IFNE      *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     *BLANKS       WREAC            10
     C                   MOVEL     TMLIN         WREAC
     C                   MOVEL     *BLANKS       SACB1
     C                   MOVEL     WREAC         SACB1
     C                   MOVEL     *BLANKS       SDST1
     C                   MOVEL     WREAC         SDST1
     C                   END
      *
     C                   MOVEL     'N'           OTOPIN
      *
     C                   END
      *                                                                         CFT014
     C     @CFT014       IFEQ      'Y'                                          CFT014
                                                                                CFT014
      ** Bank Operation Code                                                    CFT014
                                                                                CFT014
     C     P23B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P23B          DSTRAN                         CFT014
     C                   MOVEL     TTREF         SBOCD                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Instruction Code                                                       CFT014
                                                                                CFT014
     C     P23E          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P23E          DSTRAN                         CFT014
     C                   MOVEL     TMLIN1        SICD1                          CFT014
     C                   MOVEL     TMLIN2        SICD2                          CFT014
     C                   MOVEL     TMLIN3        SICD3                          CFT014
     C                   MOVEL     TMLIN4        SICD4                          CFT014
     C                   MOVEL     TMLIN5        SICD5                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Transaction Code                                                       CFT014
                                                                                CFT014
     C     P26T          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P26T          DSTRAN                         CFT014
     C                   MOVEL     TTREF         STRTC                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Instructed Currency/Amount                                             CFT014
                                                                                CFT014
     C     P33B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P33B          DSTRAN                         CFT014
     C                   EXSR      RTPCA                                        CFT014
     C                   MOVEL     WCACY         SPDCY                          CFT014
     C                   MOVEL     WCAAM         SPDAM                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Original Rate Currency/Amount                                          CFT014
                                                                                CFT014
     C     P36           IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P36           DSTRAN                         CFT014
     C                   EXSR      RT36                                         CFT014
     C                   MOVEL     W36RT         SOEXR                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
      ** Regulatory Reporting                                                   CFT014
                                                                                CFT014
     C     P77B          IFNE      *BLANKS                                      CFT014
     C                   MOVEL     *BLANK        DSTRAN                         CFT014
     C                   MOVEL     P77B          DSTRAN                         CFT014
     C                   MOVEL     TMLIN1        SRRP1                          CFT014
     C                   MOVEL     TMLIN2        SRRP2                          CFT014
     C                   MOVEL     TMLIN3        SRRP3                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ENDIF                                                  CFT014
      *                                                                         CGL009
     C                   SELECT                                                 CGL009
      * DEFAULT MAPPING                                                         CGL009
      *                                                                         CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      *                                                                         CGL009
      *  Payment subtype, Book code & Profit centre                             CGL009
     C                   MOVE      F8OPST        SPYST                          CGL009
     C                   MOVE      F8TBKC        SBOKC                          CGL009
     C                   MOVE      F8TBKC        OTBOKC                         CGL009
      *  Originating branch                                                     CGL009
     C     SORBR         IFEQ      *BLANKS                                      CGL009
     C                   MOVE      SBRCA         SORBR                          CGL009
     C                   END                                                    CGL009
      *  Profit center                                                          CGL009
     C                   MOVEL     'OP'          WPYTP                          CGL009
     C                   MOVEL     F8OPST        WPYST                          CGL009
     C                   MOVEL     F8TBKC        WBOKC                          CGL009
     C                   MOVEL     SBRCA         WBRCA                          CGL009
     C                   EXSR      RTPRFC                                       CGL009
     C     WPRFC         IFNE      *BLANK                                       CGL009
     C                   MOVE      WPRFC         SPRFC                          CGL009
     C                   ELSE                                                   CGL009
     C                   MOVE      F8TPFC        SPRFC                          CGL009
     C                   ENDIF                                                  CGL009
      *  Settlement method                                                      CGL009
     C                   MOVE      F8STMT        SSTTP                          CGL009
      *                                                                         CFT002
      ** Other Network                                                          CGL009
     C                   OTHER                                                  CGL009
      *
      ***Default*in*BOOK*CODE.                                                                195063
     C**********         MOVE      'FT'          OTBOKC                                       195063
     C**********         MOVE      'FT'          SBOKC                                        195063
      *  Default in PAY CURRENCY
     C     @CFT012       IFEQ      'N'                                          CFT012
     C                   MOVE      SSMCY         OTPCCY
     C                   MOVE      SSMCY         SPCCY
     C********           MOVE      SSMCY         OPCCY
     C                   ENDIF                                                  CFT012
      *  Default in VALUE DATE
     C                   MOVE      SPYDT         SPYVD
     C                   MOVE      OTSLDT        OTPVDT
     C/COPY WNCPYSRC,JMI113_030                                                               JMI113
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *                                                                         CGL009
                                                                                              CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
                                                                                              CSW209
      ** Network, Message type and validation flag                                            CSW209
     C                   Eval      SNWRK  = PNWRK                                             CSW209
     C                   Eval      SMTPY  = PMTPY                                             CSW209
     C                   Eval      SVALF  = P119                                              CSW209
     C                   Eval      SOMVLF = *Blanks                                           CSW209
     C                   Eval      SOCVLF = *Blanks                                           CSW209
      ** Ordering Customer (Cover)                                                            CSW209
     C                   If        PB50 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB50                                              CSW209
     C                   Eval      SCOC1  = TMLIN1                                            CSW209
     C                   Eval      SCOC2  = TMLIN2                                            CSW209
     C                   Eval      SCOC3  = TMLIN3                                            CSW209
     C                   Eval      SCOC4  = TMLIN4                                            CSW209
     C                   Eval      SCOC5  = TMLIN5                                            CSW209
     C                   EndIf                                                                CSW209
      ** Ordering Institution (Cover)                                                         CSW209
     C                   If        PB52 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB52                                              CSW209
     C                   Eval      SCOB1  = TMLIN1                                            CSW209
     C                   Eval      SCOB2  = TMLIN2                                            CSW209
     C                   Eval      SCOB3  = TMLIN3                                            CSW209
     C                   Eval      SCOB4  = TMLIN4                                            CSW209
     C                   Eval      SCOB5  = TMLIN5                                            CSW209
     C                   EndIf                                                                CSW209
      ** Intermediary Institution (Cover)                                                     CSW209
     C                   If        PB56 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB56                                              CSW209
     C                   Eval      SCIB1  = TMLIN1                                            CSW209
     C                   Eval      SCIB2  = TMLIN2                                            CSW209
     C                   Eval      SCIB3  = TMLIN3                                            CSW209
     C                   Eval      SCIB4  = TMLIN4                                            CSW209
     C                   Eval      SCIB5  = TMLIN5                                            CSW209
     C                   EndIf                                                                CSW209
      ** Account with Institution (Cover)                                                     CSW209
     C                   If        PB57 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB57                                              CSW209
     C                   Eval      SCAB1  = TMLIN1                                            CSW209
     C                   Eval      SCAB2  = TMLIN2                                            CSW209
     C                   Eval      SCAB3  = TMLIN3                                            CSW209
     C                   Eval      SCAB4  = TMLIN4                                            CSW209
     C                   Eval      SCAB5  = TMLIN5                                            CSW209
     C                   EndIf                                                                CSW209
      ** Beneficiary Customer (Cover)                                                         CSW209
     C                   If        PB59 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB59                                              CSW209
     C                   Eval      SCBC1  = TMLIN1                                            CSW209
     C                   Eval      SCBC2  = TMLIN2                                            CSW209
     C                   Eval      SCBC3  = TMLIN3                                            CSW209
     C                   Eval      SCBC4  = TMLIN4                                            CSW209
     C                   Eval      SCBC5  = TMLIN5                                            CSW209
     C                   EndIf                                                                CSW209
      ** Remittance Information (Cover)                                                       CSW209
     C                   If        PB70 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB70                                              CSW209
     C                   Eval      SCDP1  = TMLIN1                                            CSW209
     C                   Eval      SCDP2  = TMLIN2                                            CSW209
     C                   Eval      SCDP3  = TMLIN3                                            CSW209
     C                   Eval      SCDP4  = TMLIN4                                            CSW209
     C                   EndIf                                                                CSW209
      ** Sender to Reciever Information (Cover B)                                             CSW209
     C                   If        PB72 <> *Blanks                                            CSW209
     C                   Eval      DSTRAN = PB72                                              CSW209
     C                   Eval      SCBB1  = TMLIN1                                            CSW209
     C                   Eval      SCBB2  = TMLIN2                                            CSW209
     C                   Eval      SCBB3  = TMLIN3                                            CSW209
     C                   Eval      SCBB4  = TMLIN4                                            CSW209
     C                   Eval      SCBB5  = TMLIN5                                            CSW209
     C                   Eval      SCBB6  = TMLIN6                                            CSW209
     C                   EndIf                                                                CSW209
      ** Instructed Currency/Amount (Cover)                                                   CSW209
     C                   If        PB33B <> *Blanks                                           CSW209
     C                   Eval      DSTRAN = *Blanks                                           CSW209
     C                   Eval      DSTRAN = PB33B                                             CSW209
     C                   Exsr      RTPCA                                                      CSW209
     C                   Eval      SCICY  = WCACY                                             CSW209
     C                   Eval      SCIAM  = WCAAM                                             CSW209
     C                   EndIf                                                                CSW209
      ** Sender to Reciever Information (Cover A)                                             CSW209
     C                   Eval      SOCBB1 = *Blanks                                           CSW209
     C                   Eval      SOCBB2 = *Blanks                                           CSW209
     C                   Eval      SOCBB3 = *Blanks                                           CSW209
     C                   Eval      SOCBB4 = *Blanks                                           CSW209
     C                   Eval      SOCBB5 = *Blanks                                           CSW209
     C                   Eval      SOCBB6 = *Blanks                                           CSW209
                                                                                              CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      * Default to clearing mapping
     C                   MOVEL     'Y'           ##CLRM            1
      *
      * Decode data if feature installed
      *
     C     @CFT002       IFEQ      'Y'
      *
      * Call ME1580 to translate the data of the messages for FT fields
      *
     C                   CALL      'ME1580'                             8080
     C                   PARM      '*TRANS  '    #ACT              8            Action
     C                   PARM                    PHEAD                          General Datails
     C                   PARM                    PDATA                          Message Datails
     C                   PARM      *BLANKS       PDAT2                          MsgDtls Ext'n CSW209
     C                   PARM      *BLANKS       RTN               7            Return Code
      *
      *  If call to program resulted in an error then end program.
     C     RTN           IFEQ      '*ERROR*'
     C                   MOVEL     '*CALL   '    DBFILE
     C                   MOVEL     *BLANKS       DBKEY
     C                   MOVEL     'ME1580'      DBKEY
     C                   MOVEL     '061'         DBASE
     C                   EXSR      *PSSR
     C                   ENDIF
      *
      *  If Clearing then copy else map like FT0060
      *
     C     ##CLRM        IFEQ      'Y'
     C/COPY OFCPYSRCZ,CFT135_005                                                              CFT135
     C                   EXSR      SROCLR
     C/COPY OFCPYSRCZ,CFT135_006                                                              CFT135
     C                   ELSE
     C                   EXSR      SROSWT
     C                   ENDIF
      *
     C                   ENDIF
      *                                                                         CFT012
      * Default settlement currency for other network than FONTIS               CFT012
      * (provided settlement currency is still blank)                           CFT012
     C     @CFT012       IFEQ      'Y'                                          CFT012
     C     PNWRK         IFNE      'FONTIS'                                     CFT012
     C     SSMCY         IFEQ      *BLANK                                       CFT012
     C                   EXSR      SRDSCY                                       CFT012
     C                   ENDIF                                                  CFT012
     C                   ENDIF                                                  CFT012
     C                   ENDIF                                                  CFT012
      *
      * Update 'Current' Payment with Payment in Screen Format
      *
     C                   MOVEL     NewPmtScn1    CurPmtScn1
     C                   MOVEL     NewPmtSc2a    CurPmtSc2a
     C                   MOVEL     NewPmtSc2b    CurPmtSc2b
     C                   MOVEL     NewPmtScn3    CurPmtScn3
                                                                                              CSW209
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   Eval      CurPmtScnA = NewPmtScnA                                    CSW209
     C                   Eval      CurPmtScnC = NewPmtScnC                                    CSW209
     C                   EndIf                                                                CSW209
                                                                                              CSW209
      *
     C**********         Movel     OTOPORBT      WOTOPORBT         1                   256919 262930
     C**********         Movel     OTOPORB1      WOTOPORB1        35                   256919 262930
     C**********         Movel     OTOPORB2      WOTOPORB2        35                   256919 262930
     C**********         Movel     OTOPORB3      WOTOPORB3        35                   256919 262930
     C**********         Movel     OTOPORB4      WOTOPORB4        35                   256919 262930
     C**********         Movel     OTOPORB5      WOTOPORB5        35                   256919 262930
      **********                                                                       256919 262930
     C                   Movel     OTOPORBT      WOTOPORBT         1                        MD022446
     C                   Movel     OTOPORB1      WOTOPORB1        35                        MD022446
     C                   Movel     OTOPORB2      WOTOPORB2        35                        MD022446
     C                   Movel     OTOPORB3      WOTOPORB3        35                        MD022446
     C                   Movel     OTOPORB4      WOTOPORB4        35                        MD022446
     C                   Movel     OTOPORB5      WOTOPORB5        35                        MD022446
      *                                                                                     MD022446
     C     EXSWFC        TAG
     C/COPY WNCPYSRC,FTOPA1SC29

     C                   ENDSR
      *
     C************************************************************
     C* End of EISWFT Subroutine
     C************************************************************
     C/EJECT
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/OV32AM                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/OV32AM   - Overwrite transaction amount.                   *         CFT014
      *                                                               *         CFT014
      * Called By: EISWFT subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     OV32AM        BegSr                                                  CFT014
                                                                                CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** Input amount                                                           CFT014
                                                                                CFT014
     C     *Like         Define    W32AM         WOVIAM                         CFT014
                                                                                CFT014
      ** Input currency                                                         CFT014
                                                                                CFT014
     C     *Like         Define    W32CY         WOVICY                         CFT014
                                                                                CFT014
      ** Receiver's Charges amount                                              CFT014
                                                                                CFT014
     C     *Like         Define    W32AM         WOVRAM                         CFT014
                                                                                CFT014
      ** Receiver's Charges currency                                            CFT014
                                                                                CFT014
     C     *Like         Define    W32CY         WOVRCY                         CFT014
                                                                                CFT014
      ** Value date                                                             CFT014
                                                                                CFT014
     C     *Like         Define    W32DYN        WOVVLD                         CFT014
                                                                                CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Amount overwritten                                                     CFT014
                                                                                CFT014
     C     *Like         Define    W32AM         WOVAMT                         CFT014
                                                                                CFT014
      ** Temporary variables                                                    CFT014
      ** -------------------                                                    CFT014
      ** Transaction amount numeric format                                      CFT014
                                                                                CFT014
     C     *Like         Define    P#TOAM        WOVTAN                         CFT014
                                                                                CFT014
      ** Receiver's charges amount numeric format                               CFT014
                                                                                CFT014
     C     *Like         Define    P#TOAM        WOVRCN                         CFT014
                                                                                CFT014
      ** Reset output parameters and temporary variables                        CFT014
                                                                                CFT014
     C                   Movel     *BLANK        WOVAMT                         CFT014
     C                   Z-Add     0             WOVTAN                         CFT014
     C                   Z-Add     0             WOVRCN                         CFT014
                                                                                CFT014
      ** If both currencies are the same, we don't need to perform              CFT014
      ** currency conversion before doing operation on the amounts              CFT014
                                                                                CFT014
     C     WOVICY        IfEq      WOVRCY                                       CFT014
                                                                                CFT014
      ** Retrieve details of transaction currency                               CFT014
                                                                                CFT014
     C                   Movel     WOVICY        WCYCCY                         CFT014
     C                   Movel     'N'           WCYDMP                         CFT014
     C                   ExSr      RTCCYD                                       CFT014
     C     WCYRTN        IfEq      *BLANK                                       CFT014
     C                   Z-Add     WCYNDP        TRNBDP                         CFT014
     C                   Z-Add     WCYNDP        RCNBDP                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Format charges amount                                                  CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Movel     WOVRAM        ZFIELD                         CFT014
     C     13            Sub       RCNBDP        ZADIG                          CFT014
     C                   Z-Add     RCNBDP        ZADEC                          CFT014
     C                   CallB     'ZALIGN'                                     CFT014
     C                   Parm                    ZalignOK                       CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
     C                   Parm                    ZADIG                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        WOVRCN                         CFT014
                                                                                CFT014
      ** Format input amount                                                    CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Movel     WOVIAM        ZFIELD                         CFT014
     C     13            Sub       TRNBDP        ZADIG                          CFT014
     C                   Z-Add     TRNBDP        ZADEC                          CFT014
     C                   CallB     'ZALIGN'                                     CFT014
     C                   Parm                    ZalignOK                       CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
     C                   Parm                    ZADIG                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        WOVTAN                         CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
     C     WOVOPR        WhenEq    '*SUB'                                       CFT014
                                                                                CFT014
      ** Final amount = Input amount - Charges amount                           CFT014
                                                                                CFT014
     C     WOVTAN        Sub       WOVRCN        WOVTAN                         CFT014
     C     WOVOPR        WhenEq    '*ADD'                                       CFT014
                                                                                CFT014
      ** Final amount = Input amount + Charges amount                           CFT014
                                                                                CFT014
     C     WOVTAN        Add       WOVRCN        WOVTAN                         CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
      ** Format Final amount                                                    CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Move      WOVTAN        ZFIELD                         CFT014
     C                   Z-Add     TRNBDP        ZADEC                          CFT014
     C                   CallB     'ZEDIT'                                      CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        WOVAMT                         CFT014
     C                   ELSE                                                   CFT014
                                                                                CFT014
      ** Currencies are different                                               CFT014
      ** Begin to fill parameters for FT0010 (currency conversion)              CFT014
                                                                                CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Movel     WOVRCY        P#FRCY                         CFT014
                                                                                CFT014
      ** Retrieve details of transaction currency                               CFT014
                                                                                CFT014
     C                   Movel     WOVICY        P#TOCY                         CFT014
     C                   Movel     WOVICY        WCYCCY                         CFT014
     C                   Movel     'N'           WCYDMP                         CFT014
     C                   ExSr      RTCCYD                                       CFT014
                                                                                CFT014
     C     WCYRTN        IfEq      *BLANK                                       CFT014
     C                   Z-Add     WCYNDP        TRNBDP                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Z-Add     WOVVLD        P#FRDT                         CFT014
     C                   Z-Add     WOVVLD        P#TODT                         CFT014
                                                                                CFT014
      ** Retrieve details of currency of Receiver's Charges                     CFT014
                                                                                CFT014
     C                   Movel     WOVRCY        WCYCCY                         CFT014
     C                   Movel     'N'           WCYDMP                         CFT014
     C                   ExSr      RTCCYD                                       CFT014
                                                                                CFT014
     C     WCYRTN        IfEq      *BLANK                                       CFT014
     C                   Z-Add     WCYNDP        RCNBDP                         CFT014
                                                                                CFT014
      ** Format charges amount                                                  CFT014
                                                                                CFT014
     C                   Movel     *BLANK        ZFIELD                         CFT014
     C                   Movel     WOVRAM        ZFIELD                         CFT014
     C     13            Sub       RCNBDP        ZADIG                          CFT014
     C                   Z-Add     RCNBDP        ZADEC                          CFT014
     C                   CallB     'ZALIGN'                                     CFT014
     C                   Parm                    ZalignOK                       CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
     C                   Parm                    ZADIG                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        P#FRAM                         CFT014
                                                                                CFT014
      ** Convert the :71G: amount into the :32A: currency                       CFT014
                                                                                CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
     C     P#RTCD        IfNe      *Blank                                       CFT014
     C                   Movel     'FT0010  '    DBFILE                         CFT014
     C                   Movel     '*CALL  '     DBKEY                          CFT014
     C                   Z-Add     85            DBASE                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
     C                   Z-Add     P#TOAM        WOVRCN                         CFT014
                                                                                CFT014
      ** Format input amount                                                    CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Movel     WOVIAM        ZFIELD                         CFT014
     C     13            Sub       TRNBDP        ZADIG                          CFT014
     C                   Z-Add     TRNBDP        ZADEC                          CFT014
     C                   CallB     'ZALIGN'                                     CFT014
     C                   Parm                    ZalignOK                       CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
     C                   Parm                    ZADIG                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        WOVTAN                         CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
     C     WOVOPR        WhenEq    '*SUB'                                       CFT014
                                                                                CFT014
      ** Final amount = Input amount - Charges amount                           CFT014
                                                                                CFT014
     C     WOVTAN        Sub       WOVRCN        WOVTAN                         CFT014
     C     WOVOPR        WhenEq    '*ADD'                                       CFT014
                                                                                CFT014
      ** Final amount = Input amount + Charges amount                           CFT014
                                                                                CFT014
     C     WOVTAN        Add       WOVRCN        WOVTAN                         CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
      ** Format Final amount                                                    CFT014
                                                                                CFT014
     C                   Movel     *Blank        ZFIELD                         CFT014
     C                   Move      WOVTAN        ZFIELD                         CFT014
     C                   Z-Add     TRNBDP        ZADEC                          CFT014
     C                   CallB     'ZEDIT'                                      CFT014
     C                   Parm                    ZFIELD                         CFT014
     C                   Parm                    ZADEC                          CFT014
                                                                                CFT014
     C                   Move      ZFIELD        WOVAMT                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Reset input parameters                                                 CFT014
                                                                                CFT014
     C                   Movel     *Blank        WOVIAM                         CFT014
     C                   Movel     *Blank        WOVICY                         CFT014
     C                   Movel     *Blank        WOVRAM                         CFT014
     C                   Movel     *Blank        WOVRCY                         CFT014
     C                   Movel     *Blank        WOVOPR            4            CFT014
     C                   Z-Add     0             WOVVLD                         CFT014
                                                                                CFT014
     C     EXOV32        EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/RTPCA                                                           CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/RTPCA  - Retrieve the amount, currency in P33B (tag:33B:)  *         CFT014
      *                                                               *         CFT014
      * Called By: EISWFT subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     RTPCA         BegSr                                                  CFT014
                                                                                CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** DS for tags  (will NOT be blanked at the end of the S/R)               CFT014
      **                                  DSTRAN                                CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Currency                                                               CFT014
                                                                                CFT014
     C     *Like         Define    TVCCY         WCACY                          CFT014
                                                                                CFT014
      ** Amount                                                                 CFT014
                                                                                CFT014
     C     *Like         Define    SSMAM         WCAAM                          CFT014
      *                                                                         CFT014
     C                   Movel     *Blank        WCACY                          CFT014
     C                   Movel     *Blank        WCAAM                          CFT014
                                                                                CFT014
      ** Currency                                                               CFT014
                                                                                CFT014
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TTCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TTCCY                                        225169
      *                                                                                       225169
     C                   Movel     TTCCY         WCACY                          CFT014
                                                                                CFT014
      ** Amount                                                                 CFT014
      * Format amount field (change ',' decimal point to '.').                  CFT014
                                                                                CFT014
     C                   MoveA     TTAMT         YA1                            CFT014
     C                   Z-Add     1             C                 3 0          CFT014
                                                                                CFT014
     C     C             DoUGt     15                                           CFT014
                                                                                CFT014
     C     YA1(C)        IfEq      ','                                          CFT014
     C                   Move      '.'           YA1(C)                         CFT014
     C                   Z-Add     16            C                              CFT014
     C                   Else                                                   CFT014
     C                   Add       1             C                              CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndDo                                                  CFT014
                                                                                CFT014
     C                   MoveA     YA1           AMT              15            CFT014
     C                   Movel     AMT           WCAAM                          CFT014
                                                                                CFT014
     C     EX33B         EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/RT36                                                            CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/RT36   - Retrieve the rate of tag :36:                     *         CFT014
      *                                                               *         CFT014
      * Called By: EISWFT subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     RT36          BegSr                                                  CFT014
                                                                                CFT014
      ** Inputs                                                                 CFT014
      ** ------                                                                 CFT014
      ** Code work lines                                                        CFT014
      **                                  DSTRAN                                CFT014
      ** Outputs                                                                CFT014
      ** -------                                                                CFT014
      ** Rate                                                                   CFT014
                                                                                CFT014
     C     *Like         Define    SOEXR         W36RT                          CFT014
      ** Decimal Position Truncated                                             CFT014
     C     *Like         Define    A6NBDP        W36DPT                         CFT014
      ** Decimal Position                                                       CFT014
     C     *Like         Define    A6NBDP        W36DP           + 1            CFT014
      *                                                                         CFT014
     C                   Movel     *Blank        W36RT                          CFT014
     C                   Z-Add     0             W36DPT                         CFT014
     C                   Z-Add     0             W36DP                          CFT014
                                                                                CFT014
      ** Map Rate                                                               CFT014
      ** Move possible 12 chars to work array and work string                   CFT014
                                                                                CFT014
     C     12            SubSt     TMLIN1:1      @R               13            CFT014
     C                   MoveA     @R            @R1                            CFT014
     C                   Clear                   @R                             CFT014
                                                                                CFT014
      ** If ',' in rate string @R change to '.'                                 CFT014
      ** Only need to check valid chars till one ',' found                      CFT014
                                                                                CFT014
     C                   Z-Add     1             @C                3 0          CFT014
     C                   Move      *Blanks       @T                1            CFT014
                                                                                CFT014
     C     1             Do        12            @C                             CFT014
     C     @R1(@C)       IfEq      ','                                          CFT014
     C                   Move      '.'           @R1(@C)                        CFT014
                                                                                CFT014
      ** Retrieve the number of decimal position                                CFT014
                                                                                CFT014
     C     @CHK          Check     R1            @F                3 0          CFT014
     C     @F            IfNe      0                                            CFT014
     C     @F            Sub       1             @F                             CFT014
     C     @F            Sub       @C            W36DP                          CFT014
     C                   Else                                                   CFT014
     C     12            Sub       @C            W36DP                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Decimal position can be handled only on one 1 digit                    CFT014
      ** => range 0-9  (otherwise truncated to 9)                               CFT014
                                                                                CFT014
     C     W36DP         IfGt      9                                            CFT014
     C                   Z-Add     9             W36DPT                         CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     W36DP         W36DPT                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Leave                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndDo                                                  CFT014
                                                                                CFT014
     C                   Z-Add     1             @C                             CFT014
     C                   Move      *BLANKS       @T                1            CFT014
     C                   MoveA     @R1           @R                             CFT014
                                                                                CFT014
      ** Get amount - upto 12 chars possible                                    CFT014
                                                                                CFT014
     C     @C            DoUGt     12                                           CFT014
     C                   Move      @R1(@C)       @T                             CFT014
     C     @CHK          Check     @T            @F                       82    CFT014
                                                                                CFT014
      ** Char not valid must be end of rate                                     CFT014
                                                                                CFT014
     C     *IN82         IfEq      *ON                                          CFT014
     C     @C            IfNe      1                                            CFT014
     C     @C            Sub       1             @F                             CFT014
     C     @F            SubSt     @R:1          W36RT                          CFT014
     C                   EndIf                                                  CFT014
     C                   Leave                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** All chars in string ok                                                 CFT014
                                                                                CFT014
     C     @C            IfEq      12                                           CFT014
     C                   Movel     @R            W36RT                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Add       1             @C                             CFT014
                                                                                CFT014
     C                   EndDo                                                  CFT014
                                                                                CFT014
     C     EXRT36        EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      *  Map Translated data for Outgoing BOJ messages
      *****************************************************************
      *
     C     SROCLR        BEGSR
      *                                                                         CFT012
      ** In cross currency transfer the settlement currency is                  CFT012
      ** defaulted therefore, unknown.                                          CFT012
      ** So all the tags candidate for the CR part of the translation           CFT012
      ** need to be tested against the PAYMENT currency.                        CFT012
      ** In all the tags candidate for the DR part of the translation           CFT012
      ** we removed tests against the SETTLEMENT currency                       CFT012
     C     *LIKE         DEFINE    SSMCY         WMGCCY                         CFT012
     C     @CFT012       IFEQ      'Y'                                          CFT012
     C                   MOVEL     SPCCY         WMGCCY                         CFT012
     C                   ELSE                                                   CFT012
     C                   MOVEL     SSMCY         WMGCCY                         CFT012
     C                   ENDIF                                                  CFT012
      *
      * Set up the detail screen fields from the message.
      *
      *                                                                         CGL009
      * Ordering Customer                                                       CGL009
      *                                                                         CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      ** Translation is not working for ordering customer                       CGL009
      ** Use part translated of P53 to map SORC                                 CGL009
      ** Do something                                                           CGL009
     C                   OTHER                                                  CGL009
     C     P50           IFNE      *BLANKS                                      CGL009
      ** Do something                                                           CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDSL                                                  CGL009
      *
      * If no Intermediary Bank then copy over P57 to Account with
      * bank
      *
     C     P56           IFEQ      *BLANKS
     C     P57           ANDNE     *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   MOVEL     TMLIN1        SACB1
     C                   MOVEL     TMLIN2        SACB2
     C                   MOVEL     TMLIN3        SACB3
     C                   MOVEL     TMLIN4        SACB4
     C                   MOVEL     TMLIN5        SACB5
     C                   END
      *
      * If Intermediary Bank then copy over P56 to Intermediary
      * bank
      *
     C     P56           IFNE      *BLANKS
     C                   MOVEL     P56           DSTRAN
     C                   MOVEL     TMLIN1        SINB1
     C                   MOVEL     TMLIN2        SINB2
     C                   MOVEL     TMLIN3        SINB3
     C                   MOVEL     TMLIN4        SINB4
     C                   MOVEL     TMLIN5        SINB5
     C                   END
      *
      * Destination
      *
      * Intermediary Bank
      *
     C     P56           IFNE      *BLANKS
     C                   MOVEL     P56           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     SINB1         INBCH1            1
     C     INBCH1        IFEQ      '/'
     C                   MOVEL     TRCNUM        SINB2
     C                   ELSE
     C                   MOVE      *BLANKS       SINB1
     C                   MOVEL     TRCNUM        SINB1
     C                   MOVE      *BLANKS       SINB2
     C                   END
     C                   MOVE      *BLANKS       SINB3
     C                   MOVE      *BLANKS       SINB4
     C                   END
     C                   END
      *
      * Account with Bank - use A/C with bank if entered else use
      * Intermediary bank if entered else use Beneficiary
      *
     C                   MOVE      *BLANKS       DSTRAN
     C     P57           IFNE      *BLANKS
     C                   MOVEL     P57           DSTRAN
     C                   ELSE
     C     P56           IFNE      *BLANKS
     C                   MOVEL     P56           DSTRAN
     C                   ELSE
     C     P58           IFNE      *BLANKS
     C                   MOVEL     P58           DSTRAN
     C                   END
     C                   END
     C                   END
      *
     C     DSTRAN        IFNE      *BLANKS
     C     TRCODE        ANDNE     *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TMLIN1        ACBCH1            1
     C     ACBCH1        IFEQ      '/'
     C                   MOVEL     TRCNUM        SACB2
     C                   ELSE
     C                   MOVE      *BLANKS       SACB1
     C                   MOVEL     TRCNUM        SACB1
     C                   MOVE      *BLANKS       SACB2
     C                   END
     C                   MOVE      *BLANK        SACB3
     C                   MOVE      *BLANK        SACB4
     C                   MOVE      *BLANK        SACB5
     C                   END
     C/COPY WNCPYSRC,JMI113_031                                                               JMI113
      *
      * Ordering Bank
     C                   SELECT                                                 CGL009
      ** Special case for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      ** Ordering bank is never filled  in FONTIS                               CGL009
      *                                                                         CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
      *                                                                         CFT014
      ** If Third Reimbursement Institution is not blank, use it                CFT014
      ** otherwise                                                              CFT014
      *
      * If Receivers Correspondent is not blank, use it
      * otherwise use Senders Correspondent. If both are blank
      * use Sender details.
      *
      ** Use Third Reimb Institution details                                    CFT014
                                                                                CFT014
     C     P55           IFNE      *BLANKS                                      CFT014
     C                   MOVEL     P55           DSTRAN                         CFT014
     C                   MOVEL     *BLANKS       SORBB                          CFT014
     C     TRCODE        IFNE      *BLANKS                                      CFT014
     C                   MOVE      TRCODE        TRCDE2                         CFT014
     C     TRCYCD        IFEQ      *BLANKS                                      CFT014
     C                   MOVE      *BLANKS       SORBK                          CFT014
     C                   MOVEL     TRCNUM        SORBK                          CFT014
     C                   ELSE                                                   CFT014
                                                                                CFT014
      ** Translate to nostro and retail account numbers                         CFT014
                                                                                CFT014
     C                   EXSR      SRTRAN                                       CFT014
     C                   SELECT                                                 CFT014
                                                                                CFT014
      ** If local and account currency local then use retail number             CFT014
      ** Save if CFT012 is on                                                   CFT014
                                                                                CFT014
     C     BJLCCY        WHENEQ    SSMCY                                        CFT014
     C     TRCYCD        ANDEQ     SSMCY                                        CFT014
     C     ##ACNO        ANDNE     0                                            CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##ACNO        SORBK                          CFT014
                                                                                CFT014
     C     ##ACNO        WHENNE    0                                            CFT014
     C     @CFT012       ANDEQ     'Y'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##ACNO        SORBK                          CFT014
     C                   MOVEL     TRCYCD        SSMCY                          CFT014
                                                                                CFT014
      ** If currency the same as settle and nostro, use nostro                  CFT014
      ** Save if CFT012 on                                                      CFT014
                                                                                CFT014
     C     ##NCCY        WHENEQ    SSMCY                                        CFT014
     C     ##NONB        ANDNE     *BLANKS                                      CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##NONB        SORBK                          CFT014
                                                                                CFT014
     C     ##NONB        WHENNE    *BLANKS                                      CFT014
     C     @CFT012       ANDEQ     'Y'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##NONB        SORBK                          CFT014
     C                   MOVEL     ##NCCY        SSMCY                          CFT014
                                                                                CFT014
      ** If currency the same use GL Account                                    CFT014
      ** Save if CFT012 on                                                      CFT014
                                                                                CFT014
     C     TRCYCD        WHENEQ    SSMCY                                        CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT014
     C     @MBIN         IFEQ      'Y'                                          CFT014
     C                   MOVE      TRBRCD        SORBB                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     @CFT012       WHENEQ    'Y'                                          CFT014
     C     TRCYCD        ANDNE     *BLANK                                       CFT014
     C     TRCDSQ        ANDNE     *BLANK                                       CFT014
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT014
     C     @MBIN         IFEQ      'Y'                                          CFT014
     C                   MOVE      TRBRCD        SORBB                          CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVEL     TRCYCD        SSMCY                          CFT014
                                                                                CFT014
      ** Use customer number                                                    CFT014
                                                                                CFT014
     C                   OTHER                                                  CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     TRCODE        TRCDE2                         CFT014
     C                   MOVEL     TRCNUM        SORBK                          CFT014
     C                   ENDSL                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      * Use Receiver's Correspondant details                                    CFT014
      *                                                                         CFT014
     C     P54           IFNE      *BLANKS
      *
     C                   MOVEL     P54           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVE      TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C     P53           IFNE      *BLANKS
     C                   MOVEL     P53           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   ELSE
      *
      * If TRTAG is :53B: and no account map account from sender
      *
     C     TRTAG         IFEQ      ':53B:'
     C     PNWRK         ANDEQ     'SWIFT'
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     PSNDR         SORBK
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
                                                                                CFT014
      ** Use Sender details                                                     CFT014
      *
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT002
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     PSNDR         SORBK
     C                   END
     C                   END
     C                   END
     C                   ENDIF                                                  CFT014
      *                                                                                     MD022446
      ** Map 52A from incoming message to ordering bank screen field                        MD022446
      *                                                                                     MD022446
     C     P52           IFNE      *BLANKS                                                  MD022446
     C                   MOVEL     P52           DSTRAN                                     MD022446
     C                   MOVEL     TMLIN1        SORBK                                      MD022446
     C     TRCODE        IFNE      *BLANKS                                                  MD022446
     C                   MOVE      TRCODE        TRCDE2                                     MD022446
     C     TRCYCD        IFEQ      *BLANKS                                                  MD022446
     C                   MOVE      *BLANKS       SORBK                                      MD022446
     C                   MOVEL     TRCNUM        SORBK                                      MD022446
     C                   ELSE                                                               MD022446
      *                                                                                     MD022446
      ** Translate to nostro and retail account numbers                                     MD022446
      *                                                                                     MD022446
     C                   EXSR      SRTRAN                                                   MD022446
     C                   SELECT                                                             MD022446
      *                                                                                     MD022446
      ** If local and account currency local then use retail number                         MD022446
      ** Save if CFT012 is on                                                               MD022446
      *                                                                                     MD022446
     C     BJLCCY        WHENEQ    SSMCY                                                    MD022446
     C     TRCYCD        ANDEQ     SSMCY                                                    MD022446
     C     ##ACNO        ANDNE     0                                                        MD022446
     C     @CFT012       ANDEQ     'N'                                                      MD022446
     C                   MOVE      *BLANKS       SORBK                                      MD022446
     C                   MOVEL     ##ACNO        SORBK                                      MD022446
      *                                                                                     MD022446
     C     ##ACNO        WHENNE    0                                                        MD022446
     C     @CFT012       ANDEQ     'Y'                                                      MD022446
     C                   MOVEL     *BLANKS       SORBK                                      MD022446
     C                   MOVEL     ##ACNO        SORBK                                      MD022446
     C                   MOVEL     TRCYCD        SSMCY                                      MD022446
      *                                                                                     MD022446
      ** If currency the same as settle and nostro, use nostro                              MD022446
      ** Save if CFT012 is on                                                               MD022446
      *                                                                                     MD022446
     C     ##NCCY        WHENEQ    SSMCY                                                    MD022446
     C     ##NONB        ANDNE     *BLANKS                                                  MD022446
     C     @CFT012       ANDEQ     'N'                                                      MD022446
     C                   MOVE      *BLANKS       SORBK                                      MD022446
     C                   MOVEL     ##NONB        SORBK                                      MD022446
      *                                                                                     MD022446
     C     ##NONB        WHENNE    *BLANKS                                                  MD022446
     C     @CFT012       ANDEQ     'Y'                                                      MD022446
     C                   MOVEL     *BLANKS       SORBK                                      MD022446
     C                   MOVEL     ##NONB        SORBK                                      MD022446
     C                   MOVEL     ##NCCY        SSMCY                                      MD022446
      *                                                                                     MD022446
      ** If currency the same use GL Account                                                MD022446
      ** Save if CFT012 is on                                                               MD022446
      *                                                                                     MD022446
     C     TRCYCD        WHENEQ    SSMCY                                                    MD022446
     C     @CFT012       ANDEQ     'N'                                                      MD022446
     C     TRCNUM        CAT       TRCDSQ        SORBK                                      MD022446
     C     @MBIN         IFEQ      'Y'                                                      MD022446
     C                   MOVE      TRBRCD        SORBB                                      MD022446
     C                   END                                                                MD022446
      *                                                                                     MD022446
     C     @CFT012       WHENEQ    'Y'                                                      MD022446
     C     TRCYCD        ANDNE     *BLANK                                                   MD022446
     C     TRCDSQ        ANDNE     *BLANK                                                   MD022446
     C     TRCNUM        CAT       TRCDSQ        SORBK                                      MD022446
     C     @MBIN         IFEQ      'Y'                                                      MD022446
     C                   MOVE      TRBRCD        SORBB                                      MD022446
     C                   ENDIF                                                              MD022446
     C                   MOVEL     TRCYCD        SSMCY                                      MD022446
      *                                                                                     MD022446
      ** Use customer number                                                                MD022446
      *                                                                                     MD022446
     C                   OTHER                                                              MD022446
     C                   MOVE      *BLANKS       SORBK                                      MD022446
     C                   MOVE      TRCODE        TRCDE2                                     MD022446
     C                   MOVEL     TRCNUM        SORBK                                      MD022446
     C                   ENDSL                                                              MD022446
     C                   ENDIF                                                              MD022446
     C                   ENDIF                                                              MD022446
     C                   ENDIF                                                              MD022446
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *
      *  Beneficiary Institution/ Beneficiary Customer
      *
     C     P58           IFNE      *BLANKS
     C                   MOVEL     P58           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVEL     TMLIN1        BNCTAG            1
     C     BNCTAG        IFEQ      '/'
     C                   MOVE      *BLANKS       SBNC1
     C                   MOVEL     TMLIN1        SBNC1
     C                   MOVE      *BLANKS       SBNC2
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SBNC2
     C                   ELSE
     C                   MOVE      *BLANKS       SBNC1
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SBNC1
     C                   MOVEL     *BLANKS       SBNC2
     C                   END
     C                   MOVEL     *BLANKS       SBNC3
     C                   MOVEL     *BLANKS       SBNC4
     C                   MOVEL     *BLANKS       SBNC5
     C                   END
     C                   END
      *
     C     P59           IFNE      *BLANKS
     C                   MOVEL     P59           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVEL     TMLIN1        BNCTAG            1
     C     BNCTAG        IFEQ      '/'
     C                   MOVE      *BLANKS       SBNC1
     C                   MOVEL     TMLIN1        SBNC1
     C                   MOVE      *BLANKS       SBNC2
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SBNC2
     C                   ELSE
     C                   MOVE      *BLANKS       SBNC1
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SBNC1
     C                   MOVEL     *BLANKS       SBNC2
     C                   END
     C                   MOVEL     *BLANKS       SBNC3
     C                   MOVEL     *BLANKS       SBNC4
     C                   MOVEL     *BLANKS       SBNC5
     C                   END
     C                   END
      *
      * Bank to Bank Information
      *
      * If through payment, the bank to bank information has to be
      * carried forward to next outgoing message.
      * (For Swift network only)
      * (For Fontis network only)                                               CGL009
      *
     C                   MOVE      *BLANK        W0BTOB            1
     C     PNWRK         IFEQ      'SWIFT'
     C     PNWRK         OREQ      'FONTIS'                                     CGL009
     C                   MOVE      'Y'           W0BTOB
     C                   END
     C/COPY WNCPYSRC,FTOPA1SC11
     C/COPY OFCPYSRCZ,CFT135_002                                                              CFT135
      *
     C     W0BTOB        IFEQ      'Y'
     C     P72           IFNE      *BLANKS
      *
     C                   SELECT                                                 CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
     C*                                                                         CGL009
     C                   EXSR      ICCHK                                        CGL009
     C*                                                                         CGL009
     C                   MOVEL     P72           DSFONT                         CGL009
     C     FOUND         IFEQ      'Y'                                          CGL009
     C                   MOVEL     *BLANK        BBI6                           CGL009
     C                   MOVEL     FN72L2        BBI1                           CGL009
     C                   MOVEL     FN72L3        BBI2                           CGL009
     C                   MOVEL     FN72L4        BBI3                           CGL009
     C                   MOVEL     FN72L5        BBI4                           CGL009
     C                   MOVEL     FN72L6        BBI5                           CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     FN72L1        BBI1                           CGL009
     C                   MOVEL     FN72L2        BBI2                           CGL009
     C                   MOVEL     FN72L3        BBI3                           CGL009
     C                   MOVEL     FN72L4        BBI4                           CGL009
     C                   MOVEL     FN72L5        BBI5                           CGL009
     C                   MOVEL     FN72L6        BBI6                           CGL009
     C                   ENDIF                                                  CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
     C                   MOVEL     P72           DSTRAN
     C                   MOVEL     TMLIN1        SBBI1
     C                   MOVEL     TMLIN2        SBBI2
     C                   MOVEL     TMLIN3        SBBI3
     C                   MOVEL     TMLIN4        SBBI4
     C                   MOVEL     TMLIN5        SBBI5
     C                   MOVEL     TMLIN6        SBBI6
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *
     C                   END
     C     P70           IFNE      *BLANKS
      *
     C                   MOVEL     P70           DSTRAN
     C                   MOVEL     TMLIN1        SDTP1
     C                   MOVEL     TMLIN2        SDTP2
     C                   MOVEL     TMLIN3        SDTP3
     C                   MOVEL     TMLIN4        SDTP4
      *
     C                   END
      *                                                                                       CER030
      ** Details of Extended Narrative                                                        CER030
      *                                                                                       CER030
     C     PEXN          IFNE      *BLANKS                                                    CER030
     C                   MOVEL     PEXN          DSTRAN                                       CER030
     C                   MOVEL     TMLIN1        SEXT1                                        CER030
     C                   MOVEL     TMLIN2        SEXT2                                        CER030
     C                   MOVEL     TMLIN3        SEXT3                                        CER030
     C                   MOVEL     TMLIN4        SEXT4                                        CER030
     C                   MOVEL     TMLIN5        SEXT5                                        CER030
     C                   MOVEL     TMLIN6        SEXT6                                        CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   END
      *
      *
     C     EXOCLR        ENDSR
      *
      /EJECT
      *****************************************************************
      *  Map translated data for Outgoing SWIFT messages
      *****************************************************************
      *
     C     SROSWT        BEGSR
      *                                                                         CFT012
      ** In cross currency transfer the settlement currency is                  CFT012
      ** defaulted therefore, unknown.                                          CFT012
      ** So all the tags candidate for the CR part of the translation           CFT012
      ** need to be tested against the PAYMENT currency.                        CFT012
      ** In all the tags candidate for the DR part of the translation           CFT012
      ** we removed tests against the SETTLEMENT currency                       CFT012
     C     @CFT012       IFEQ      'Y'                                          CFT012
     C                   MOVEL     SPCCY         WMGCCY                         CFT012
     C                   ELSE                                                   CFT012
     C                   MOVEL     SSMCY         WMGCCY                         CFT012
     C                   ENDIF                                                  CFT012
      *
      * Set up the detail screen fields from the message.
     C/COPY WNCPYSRC,JMI113_032                                                               JMI113
      *
      * Destination
      *
     C                   SELECT                                                 CGL009
      ** Special case for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      * If Intermediary Bank is blank, use 'A/c with Institution'               CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
      * Intermediary Bank entered                                               CGL009
      *                                                                         CGL009
     C     P56           WHENNE    *BLANK                                       CGL009
     C                   MOVEL     P56           DSTRAN                         CGL009
     C     TRCODE        IFNE      *BLANKS                                      CGL009
     C                   MOVE      *BLANKS       SDST1                          CGL009
      *                                                                         CGL009
      * Translate to nostro and retail account numbers                          CGL009
      *                                                                         CGL009
     C                   EXSR      SRTRAN                                       CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
      * If local and account currency local then use retail number              CGL009
      *                                                                         CGL009
     C     BJLCCY        WHENEQ    SSMCY                                        CGL009
     C     TRCYCD        ANDEQ     SSMCY                                        CGL009
     C     ##ACNO        ANDNE     0                                            CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C                   MOVEL     ##ACNO        SDST1                          CGL009
      *                                                                         CFT012
     C     BJLCCY        WHENEQ    WMGCCY                                       CFT012
     C     TRCYCD        ANDEQ     WMGCCY                                       CFT012
     C     ##ACNO        ANDNE     0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C                   MOVEL     ##ACNO        SDST1                          CFT012
      *                                                                         CGL009
      * If currency the same as settle and nostro, use nostro                   CGL009
      *                                                                         CGL009
     C     ##NCCY        WHENEQ    SSMCY                                        CGL009
     C     ##NONB        ANDNE     *BLANKS                                      CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CGL009
      *                                                                         CFT012
      * If currency the same as msg and nostro, use nostro                      CFT012
      *                                                                         CFT012
     C     ##NCCY        WHENEQ    WMGCCY                                       CFT012
     C     ##NONB        ANDNE     *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CFT012
      *                                                                         CGL009
      * If currency the same use GL Account                                     CGL009
      *                                                                         CGL009
     C     TRCYCD        WHENEQ    SSMCY                                        CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C     @MBIN         IFNE      'Y'                                          CGL009
     C                   MOVE      '   '         TRCODE                         CGL009
     C                   END                                                    CGL009
     C                   MOVEL     TRCODE        SDST1                          CGL009
      *                                                                         CFT012
     C     TRCYCD        WHENEQ    WMGCCY                                       CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C     BGMBIN        IFNE      'Y'                                          CFT012
     C                   MOVE      '   '         TRCODE                         CFT012
     C                   END                                                    CFT012
     C                   MOVEL     TRCODE        SDST1                          CFT012
      *                                                                         CGL009
      * Use customer number                                                     CGL009
      *                                                                         CGL009
     C                   OTHER                                                  CGL009
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C                   MOVE      TRCODE        TRCDE2                         CGL009
     C                   MOVEL     TRCNUM        SDST1                          CGL009
     C                   ENDSL                                                  CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      * Account w/ Bank entered                                                 CGL009
      *                                                                         CGL009
     C     P57           WHENNE    *BLANK                                       CGL009
     C                   MOVEL     P57           DSTRAN                         CGL009
     C     TRCODE        IFNE      *BLANKS                                      CGL009
      *                                                                         CGL009
      * Translate to nostro and retail account numbers                          CGL009
      *                                                                         CGL009
     C                   EXSR      SRTRAN                                       CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
      * If local and account currency local then use retail number              CGL009
      *                                                                         CGL009
     C     BJLCCY        WHENEQ    SSMCY                                        CGL009
     C     TRCYCD        ANDEQ     SSMCY                                        CGL009
     C     ##ACNO        ANDNE     0                                            CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C                   MOVEL     ##ACNO        SDST1                          CGL009
      *                                                                         CFT012
     C     BJLCCY        WHENEQ    WMGCCY                                       CFT012
     C     TRCYCD        ANDEQ     WMGCCY                                       CFT012
     C     ##ACNO        ANDNE     0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C                   MOVEL     ##ACNO        SDST1                          CFT012
      *                                                                         CGL009
      * If currency the same as settle and nostro, use nostro                   CGL009
      *                                                                         CGL009
     C     ##NCCY        WHENEQ    SSMCY                                        CGL009
     C     ##NONB        ANDNE     *BLANKS                                      CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CGL009
      *                                                                         CFT012
      * If currency the same as msg and nostro, use nostro                      CFT012
      *                                                                         CFT012
     C     ##NCCY        WHENEQ    WMGCCY                                       CFT012
     C     ##NONB        ANDNE     *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CFT012
      *                                                                         CGL009
      * If currency the same use GL Account                                     CGL009
      *                                                                         CGL009
     C     TRCYCD        WHENEQ    SSMCY                                        CGL009
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C     @MBIN         IFNE      'Y'                                          CGL009
     C                   MOVE      '   '         TRCODE                         CGL009
     C                   END                                                    CGL009
     C                   MOVEL     TRCODE        SDST1                          CGL009
      *                                                                         CFT012
     C     TRCYCD        WHENEQ    WMGCCY                                       CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C     BGMBIN        IFNE      'Y'                                          CFT012
     C                   MOVE      '   '         TRCODE                         CFT012
     C                   END                                                    CFT012
     C                   MOVEL     TRCODE        SDST1                          CFT012
      *                                                                         CGL009
      * Use customer number                                                     CGL009
      *                                                                         CGL009
     C                   OTHER                                                  CGL009
     C                   MOVE      *BLANKS       SDST1                          CGL009
     C                   MOVE      *BLANKS       SDST2                          CGL009
     C                   MOVE      *BLANKS       SDST3                          CGL009
     C                   MOVE      *BLANKS       SDST4                          CGL009
     C                   MOVE      TRCODE        TRCDE2                         CGL009
     C                   MOVEL     TRCNUM        SDST1                          CGL009
     C                   ENDSL                                                  CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *                                                                         CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
      * If Intermediary Bank is blank, use 'A/c with Institution'
      * details if not blank, otherwise use Beneficiary  details
      * if not blank, otherwise use Intermediary Bank details
      *
     C     P56           IFEQ      *BLANKS
      *
     C     P57           IFNE      *BLANKS
     C                   MOVEL     P57           DSTRAN
     C     TRCODE        IFNE      *BLANKS
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVEL     ##ACNO        SDST1
      *                                                                         CFT012
     C     BJLCCY        WHENEQ    WMGCCY                                       CFT012
     C     TRCYCD        ANDEQ     WMGCCY                                       CFT012
     C     ##ACNO        ANDNE     0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C                   MOVEL     ##ACNO        SDST1                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     ##NCCY        CAT(P)    ##NONB        SDST1
      *                                                                         CFT012
      * If currency the same as msg and nostro, use nostro                      CFT012
      *                                                                         CFT012
     C     ##NCCY        WHENEQ    WMGCCY                                       CFT012
     C     ##NONB        ANDNE     *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVE      *BLANKS       SDST1                          CFT012
     C                   MOVE      *BLANKS       SDST2                          CFT012
     C                   MOVE      *BLANKS       SDST3                          CFT012
     C                   MOVE      *BLANKS       SDST4                          CFT012
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CFT012
      *
      * If currency the same use GL Account
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     @MBIN         IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   END
     C                   MOVEL     TRCODE        SDST1
      *                                                                         CFT012
     C     TRCYCD        WHENEQ    WMGCCY                                       CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C     BGMBIN        IFNE      'Y'                                          CFT012
     C                   MOVE      '   '         TRCODE                         CFT012
     C                   END                                                    CFT012
     C                   MOVEL     TRCODE        SDST1                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SDST1
     C                   ENDSL
     C                   END
     C                   ELSE
     C                   MOVEL     P58           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      *BLANKS       SDST1
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVEL     ##ACNO        SDST1
      *                                                                         CFT012
     C     BJLCCY        WHENEQ    WMGCCY                                       CFT012
     C     TRCYCD        ANDEQ     WMGCCY                                       CFT012
     C     ##ACNO        ANDNE     0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C                   MOVEL     ##ACNO        SDST1                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     ##NCCY        CAT(P)    ##NONB        SDST1
      *                                                                         CFT012
      * If currency the same as msg and nostro, use nostro                      CFT012
      *                                                                         CFT012
     C     ##NCCY        WHENEQ    WMGCCY                                       CFT012
     C     ##NONB        ANDNE     *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CFT012
      *
      * If currency the same use GL Account
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     @MBIN         IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   END
     C                   MOVEL     TRCODE        SDST1
      *                                                                         CFT012
     C     TRCYCD        WHENEQ    WMGCCY                                       CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C     BGMBIN        IFNE      'Y'                                          CFT012
     C                   MOVE      '   '         TRCODE                         CFT012
     C                   END                                                    CFT012
     C                   MOVEL     TRCODE        SDST1                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SDST1
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ELSE
      *
      * Intermediary Bank entered
      *
     C                   MOVEL     P56           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      *BLANKS       SDST1
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVEL     ##ACNO        SDST1
      *                                                                         CFT012
     C     BJLCCY        WHENEQ    WMGCCY                                       CFT012
     C     TRCYCD        ANDEQ     WMGCCY                                       CFT012
     C     ##ACNO        ANDNE     0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C                   MOVEL     ##ACNO        SDST1                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     ##NCCY        CAT(P)    ##NONB        SDST1
      *                                                                         CFT012
      * If currency the same as msg and nostro, use nostro                      CFT012
      *                                                                         CFT012
     C     ##NCCY        WHENEQ    WMGCCY                                       CFT012
     C     ##NONB        ANDNE     *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C     ##NCCY        CAT(P)    ##NONB        SDST1                          CFT012
      *
      * If currency the same use GL Account
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C     @MBIN         IFNE      'Y'
     C                   MOVE      '   '         TRCODE
     C                   END
     C                   MOVEL     TRCODE        SDST1
      *                                                                         CFT012
     C     TRCYCD        WHENEQ    WMGCCY                                       CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SDST1                          CFT012
     C                   MOVEL     *BLANKS       SDST2                          CFT012
     C                   MOVEL     *BLANKS       SDST3                          CFT012
     C                   MOVEL     *BLANKS       SDST4                          CFT012
     C     BGMBIN        IFNE      'Y'                                          CFT012
     C                   MOVE      '   '         TRCODE                         CFT012
     C                   END                                                    CFT012
     C                   MOVEL     TRCODE        SDST1                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SDST1
     C                   MOVE      *BLANKS       SDST2
     C                   MOVE      *BLANKS       SDST3
     C                   MOVE      *BLANKS       SDST4
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SDST1
     C                   ENDSL
     C                   END
     C                   END
      *                                                                          CGL009
     C                   ENDSL                                                   CGL009
     C/COPY WNCPYSRC,JMI113_033                                                               JMI113
      *
      * Ordering Bank
      *
     C                   SELECT                                                  CGL009
      ** Special case for FONTIS                                                 CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                      CGL009
      ** Ordering bank is never filled  in FONTIS                                CGL009
      *                                                                          CGL009
      ** Other Networks                                                          CGL009
     C                   OTHER                                                   CGL009
      *                                                                         CFT014
      ** If Third Reimbursement Institution is not blank, use it                CFT014
      ** otherwise                                                              CFT014
      *                                                                          CGL009
      * If Receivers Correspondent is not blank, use it
      * otherwise use Senders Correspondent. If both are blank
      * use Sender details.
      *
                                                                                CFT014
      ** Use Third Reimb Institution details                                    CFT014
                                                                                CFT014
     C     P55           IFNE      *BLANKS                                      CFT014
     C                   MOVEL     P55           DSTRAN                         CFT014
     C                   MOVEL     *BLANKS       SORBB                          CFT014
     C     TRCODE        IFNE      *BLANKS                                      CFT014
     C                   MOVE      TRCODE        TRCDE2                         CFT014
     C     TRCYCD        IFEQ      *BLANKS                                      CFT014
     C                   MOVE      *BLANKS       SORBK                          CFT014
     C                   MOVEL     TRCNUM        SORBK                          CFT014
     C                   ELSE                                                   CFT014
                                                                                CFT014
      ** Translate to nostro and retail account numbers                         CFT014
                                                                                CFT014
     C                   EXSR      SRTRAN                                       CFT014
     C                   SELECT                                                 CFT014
                                                                                CFT014
      ** If local and account currency local then use retail number             CFT014
      ** Save if CFT012 is on                                                   CFT014
                                                                                CFT014
     C     BJLCCY        WHENEQ    SSMCY                                        CFT014
     C     TRCYCD        ANDEQ     SSMCY                                        CFT014
     C     ##ACNO        ANDNE     0                                            CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##ACNO        SORBK                          CFT014
                                                                                CFT014
     C     ##ACNO        WHENNE    0                                            CFT014
     C     @CFT012       ANDEQ     'Y'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##ACNO        SORBK                          CFT014
     C                   MOVEL     TRCYCD        SSMCY                          CFT014
                                                                                CFT014
      ** If currency the same as settle and nostro, use nostro                  CFT014
      ** Save if CFT012 on                                                      CFT014
                                                                                CFT014
     C     ##NCCY        WHENEQ    SSMCY                                        CFT014
     C     ##NONB        ANDNE     *BLANKS                                      CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##NONB        SORBK                          CFT014
                                                                                CFT014
     C     ##NONB        WHENNE    *BLANKS                                      CFT014
     C     @CFT012       ANDEQ     'Y'                                          CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     ##NONB        SORBK                          CFT014
     C                   MOVEL     ##NCCY        SSMCY                          CFT014
                                                                                CFT014
      ** If currency the same use GL Account                                    CFT014
      ** Save if CFT012 on                                                      CFT014
                                                                                CFT014
     C     TRCYCD        WHENEQ    SSMCY                                        CFT014
     C     @CFT012       ANDEQ     'N'                                          CFT014
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT014
     C     @MBIN         IFEQ      'Y'                                          CFT014
     C                   MOVE      TRBRCD        SORBB                          CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C     @CFT012       WHENEQ    'Y'                                          CFT014
     C     TRCYCD        ANDNE     *BLANK                                       CFT014
     C     TRCDSQ        ANDNE     *BLANK                                       CFT014
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT014
     C     @MBIN         IFEQ      'Y'                                          CFT014
     C                   MOVE      TRBRCD        SORBB                          CFT014
     C                   ENDIF                                                  CFT014
     C                   MOVEL     TRCYCD        SSMCY                          CFT014
                                                                                CFT014
      ** Use customer number                                                    CFT014
                                                                                CFT014
     C                   OTHER                                                  CFT014
     C                   MOVEL     *BLANKS       SORBK                          CFT014
     C                   MOVEL     TRCODE        TRCDE2                         CFT014
     C                   MOVEL     TRCNUM        SORBK                          CFT014
     C                   ENDSL                                                  CFT014
     C                   ENDIF                                                  CFT014
     C                   ENDIF                                                  CFT014
                                                                                CFT014
     C                   ELSE                                                   CFT014
      *                                                                         CFT014
      * Use Receiver's Correspondent details                                    CFT014
      *                                                                         CFT014
     C                   MOVEL     P54           DSTRAN
     C                   MOVE      TRCODE        TRCDE2
     C     P54           IFNE      *BLANKS
      *
     C                   MOVEL     P54           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 on                                                       CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 on                                                       CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVE      TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   END
      *
     C                   ELSE
      *
     C                   MOVEL     P53           DSTRAN
     C                   MOVE      TRCODE        TRCDE2
     C     P53           IFNE      *BLANKS
     C                   MOVEL     P53           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   ELSE
      *
      * If TRTAG is :53B: and no account map account from sender
      *
     C     TRTAG         IFEQ      ':53B:'
     C     PNWRK         ANDEQ     'SWIFT'
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     PSNDR         SORBK
     C                   END
     C                   END
     C                   END
      *
     C                   ELSE
                                                                                CFT014
      ** Use Sender details                                                     CFT014
      *
     C     PNWRK         IFEQ      'SWIFT '
     C     PSN           IFNE      *BLANKS
     C                   MOVEL     PSN           DSTRAN
     C     TRCODE        IFNE      *BLANKS
     C                   MOVE      TRCODE        TRCDE2
     C     TRCYCD        IFEQ      *BLANKS
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ELSE
      *
      * Translate to nostro and retail account numbers
      *
     C                   EXSR      SRTRAN
     C                   SELECT
      *
      * If local and account currency local then use retail number
      * Save if CFT012 is on                                                    CFT012
      *
     C     BJLCCY        WHENEQ    SSMCY
     C     TRCYCD        ANDEQ     SSMCY
     C     ##ACNO        ANDNE     0
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##ACNO        SORBK
      *                                                                         CFT012
     C     ##ACNO        WHENNE    0                                            CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##ACNO        SORBK                          CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * If currency the same as settle and nostro, use nostro
      * Save if CFT012 is on                                                    CFT012
      *
     C     ##NCCY        WHENEQ    SSMCY
     C     ##NONB        ANDNE     *BLANKS
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     ##NONB        SORBK
      *                                                                         CFT012
     C     ##NONB        WHENNE    *BLANKS                                      CFT012
     C     @CFT012       ANDEQ     'Y'                                          CFT012
     C                   MOVEL     *BLANKS       SORBK                          CFT012
     C                   MOVEL     ##NONB        SORBK                          CFT012
     C                   MOVEL     ##NCCY        SSMCY                          CFT012
      *
      * If currency the same use GL Account
      * Save if CFT012 is on                                                    CFT012
      *
     C     TRCYCD        WHENEQ    SSMCY
     C     @CFT012       ANDEQ     'N'                                          CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK
     C     @MBIN         IFEQ      'Y'
     C                   MOVE      TRBRCD        SORBB
     C                   END
      *                                                                         CFT012
     C     @CFT012       WHENEQ    'Y'                                          CFT012
     C     TRCYCD        ANDNE     *BLANK                                       CFT012
     C     TRCDSQ        ANDNE     *BLANK                                       CFT012
     C     TRCNUM        CAT       TRCDSQ        SORBK                          CFT012
     C     @MBIN         IFEQ      'Y'                                          CFT012
     C                   MOVEL     TRBRCD        SORBB                          CFT012
     C                   ENDIF                                                  CFT012
     C                   MOVEL     TRCYCD        SSMCY                          CFT012
      *
      * Use customer number
      *
     C                   OTHER
     C                   MOVE      *BLANKS       SORBK
     C                   MOVE      TRCODE        TRCDE2
     C                   MOVEL     TRCNUM        SORBK
     C                   ENDSL
     C                   END
     C                   ELSE
     C                   MOVE      *BLANKS       SORBK
     C                   MOVEL     PSNDR         SORBK
     C                   END
     C                   END
     C                   ELSE
      *
     C                   END
     C                   END
     C                   END
     C                   ENDIF                                                  CFT014
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *                                                                         CGL009
      * Ordering Customer                                                       CGL009
      *                                                                         CGL009
     C                   SELECT                                                 CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
      ** Translation is not working for ordering customer                       CGL009
      ** Use part translated of P53 to map S4ORC                                CGL009
      ** Do something                                                           CGL009
     C                   OTHER                                                  CGL009
      ** Do something                                                           CGL009
     C                   SELECT                                                 CGL009
      *                                                                         CGL009
     C     P50           WHENNE    *BLANKS                                      CGL009
     C     P52           WHENNE    *BLANKS                                      CGL009
     C                   ENDSL                                                  CGL009
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *
      * Bank to Bank Information
      *
      * If through payment, the bank to bank information has to be
      * carried forward to next outgoing message.
      * (For Swift network only)
      * (For Fontis network only)                                               CGL009
      *
     C                   MOVE      *BLANK        W0BTOB            1
     C     PNWRK         IFEQ      'SWIFT'
     C     PNWRK         OREQ      'FONTIS'                                     CGL009
     C                   MOVE      'Y'           W0BTOB
     C                   END
     C/COPY WNCPYSRC,FTOPA1SC12
     C/COPY OFCPYSRCZ,CFT135_003                                                              CFT135
      *
     C     W0BTOB        IFEQ      'Y'
     C     P72           IFNE      *BLANKS
     C                   SELECT                                                 CGL009
      ** Special rule for FONTIS                                                CGL009
     C     PNWRK         WHENEQ    'FONTIS'                                     CGL009
     C*                                                                         CGL009
     C                   EXSR      ICCHK                                        CGL009
     C*                                                                         CGL009
     C                   MOVEL     P72           DSFONT                         CGL009
     C     FOUND         IFEQ      'Y'                                          CGL009
     C                   MOVEL     *BLANK        BBI6                           CGL009
     C                   MOVEL     FN72L2        BBI1                           CGL009
     C                   MOVEL     FN72L3        BBI2                           CGL009
     C                   MOVEL     FN72L4        BBI3                           CGL009
     C                   MOVEL     FN72L5        BBI4                           CGL009
     C                   MOVEL     FN72L6        BBI5                           CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     FN72L1        BBI1                           CGL009
     C                   MOVEL     FN72L2        BBI2                           CGL009
     C                   MOVEL     FN72L3        BBI3                           CGL009
     C                   MOVEL     FN72L4        BBI4                           CGL009
     C                   MOVEL     FN72L5        BBI5                           CGL009
     C                   MOVEL     FN72L6        BBI6                           CGL009
     C                   ENDIF                                                  CGL009
      ** Other Networks                                                         CGL009
     C                   OTHER                                                  CGL009
      *
     C                   MOVEL     P72           DSTRAN
     C                   MOVEL     TMLIN1        SBBI1
     C                   MOVEL     TMLIN2        SBBI2
     C                   MOVEL     TMLIN3        SBBI3
     C                   MOVEL     TMLIN4        SBBI4
     C                   MOVEL     TMLIN5        SBBI5
     C                   MOVEL     TMLIN6        SBBI6
      *                                                                         CGL009
     C                   ENDSL                                                  CGL009
      *
     C                   END
     C     P70           IFNE      *BLANKS
      *
     C                   MOVEL     P70           DSTRAN
     C                   MOVEL     TMLIN1        SDTP1
     C                   MOVEL     TMLIN2        SDTP2
     C                   MOVEL     TMLIN3        SDTP3
     C                   MOVEL     TMLIN4        SDTP4
      *
     C                   END
     C                   END
      *
     C     EXOSWT        ENDSR
      *
      /EJECT
      *****************************************************************
      *  Translate to retail and nostro code
      *****************************************************************
      *
     C     SRTRAN        BEGSR
      *
      * Clear Retail number and nostro code
      *
     C     *LIKE         DEFINE    ACNO          ##ACNO
     C                   Z-ADD     0             ##ACNO
     C     *LIKE         DEFINE    A7CYCD        ##NCCY
     C                   MOVEL     *BLANKS       ##NCCY
     C     *LIKE         DEFINE    A7NONB        ##NONB
     C                   MOVEL     *BLANKS       ##NONB
      *
      * If TRCODE has no currency exit
      *
     C                   MOVEL     TRCODE        TRCDE2
     C     TRCYCD        CABEQ     *BLANKS       EXTRAN
      *
      * Find Account details
      *
     C                   MOVEL     TRCODE        AKEYF
     C     AKEY          CHAIN     ACCNTABF                           80
     C     *IN80         IFEQ      '0'
     C     RECI          ANDEQ     'D'
     C     ATYP          ANDEQ     'R'
     C                   Z-ADD     ACNO          ##ACNO
     C                   END
      *
      * Find Nostro details
      *
     C                   CALL      'AONOSTR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*KEY   '     @OPTN
     C                   PARM      CNUMA         @CUST             6
     C                   PARM      CCY           @CYCD             3
     C**********         PARM      ACODA         @ACCD             4                          CGL029
     C                   PARM      ACODA         PACCD                                        CGL029
     C                   PARM      ACSQA         @ACSN             2
     C                   PARM      *BLANKS       @NONB             2
     C                   PARM      ABRCA         @BRCD             3
     C                   PARM      *BLANKS       @CSSN            10
     C                   PARM      *BLANKS       @PNOI             1
     C     SDNOST        PARM      *BLANKS       DSFDY
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     A7CYCD        ##NCCY
     C                   MOVEL     A7NONB        ##NONB
     C                   END
      *
     C     EXTRAN        ENDSR
      *
     C/EJECT
      *****************************************************************
      * SFDS@P - SET FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     SFDS@P        BEGSR
     C/COPY WNCPYSRC,FTH00661
      *
      * Enable/disable fields on primary screen
      *
     C     SACTION       IFEQ      'I'
     C     SACTION       OREQ      'A'
     C                   MOVEL     'Y'           @EKYFD
     C                   MOVEL     'Y'           @EDTFD
     C     SACTION       IFEQ      'I'                                                        226915
     C                   MOVE      *BLANKS       DDSTAT                                       226915
     C                   END                                                                  226915
     C                   ELSE
     C                   MOVEL     'N'           @EKYFD
     C                   MOVEL     'N'           @EDTFD
     C                   END
      *
      * Key fields must always be disabled if called from linked enquiry
     C     LinkedEnq     IFNE      *BLANKS
     C                   MOVEL     'N'           @EKYFD
     C                   END

      * Enable/disable function keys
      *
      * KG = COMMAND KEY 07 = READ PREVIOUS
      * KH = COMMAND KEY 08 = READ NEXT
      *
     C     LinkedEnq     IFEQ      *BLANKS
     C                   MOVEL     'Y'           @EINKG
     C                   MOVEL     'Y'           @EINKH
     C                   ELSE
     C                   MOVEL     'N'           @EINKG
     C                   MOVEL     'N'           @EINKH
     C                   END
      *
      * KJ = COMMAND KEY 10 = CONFIRM DELETE
      *
     C     SACTION       IFEQ      'D'
     C                   MOVEL     'Y'           @EINKJ
     C                   ELSE
     C                   MOVEL     'N'           @EINKJ
     C                   END
      *
      * KP = COMMAND KEY 15 = BROWSE
      *
     C     LinkedEnq     IFEQ      *BLANKS
     C                   MOVEL     'Y'           @EINKP
     C                   ELSE
     C                   MOVEL     'N'           @EINKP
     C                   END
      *
     C* IF CALLED FROM SUB-FILE ENQUIRY PROGRAM ENABLE F18,
     C     LinkedEnq     IFNE      *BLANKS
     C     @GL442        ANDNE     'Y'
     C                   MOVEL     'Y'           @EINKS            1
     C                   ELSE
     C                   MOVEL     'N'           @EINKS
     C                   END
      *
      * KV = COMMAND KEY 21 = Additional Information Window
      *                       (Available in enquiry mode only)
      *
     C     SACTION       IFEQ      'E'
     C                   MOVEL     'Y'           @EINKV
     C                   ELSE
     C                   MOVEL     'N'           @EINKV
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * IFDS@P - INITIALIZE FIELD STATUS ON PRIMARY SCREEN
      *****************************************************************
     C     IFDS@P        BEGSR
      *
      * ENABLE KEY FIELDS ON PRIMARY SCREEN
      *
     C                   MOVEL     'Y'           @EDTFD
     C                   MOVEL     'Y'           @EKYFD
      *                                                                                       195220
      ** F12 key pressed, restore unexpanded data.                                            195220
      *                                                                                       195220
     C     SACTION       IFEQ      'E'                                                        195220
     C     PREF          ANDEQ     SPREF                                                      195220
      *                                                                                       195220
     C                   MOVEL     DST1          SDST1                                        195220
     C                   MOVEL     DST2          SDST2                                        195220
     C                   MOVEL     DST3          SDST3                                        195220
     C                   MOVEL     DST4          SDST4                                        195220
      *                                                                                       195220
     C                   MOVEL     ORC1          SORC1                                        195220
     C                   MOVEL     ORC2          SORC2                                        195220
     C                   MOVEL     ORC3          SORC3                                        195220
     C                   MOVEL     ORC4          SORC4                                        195220
     C**********         EVAL      SORC4 = ORC5                                      CFT032 MD023832
     C                   EVAL      SORC5 = ORC5                                             MD023832
      *                                                                                       195220
     C                   MOVEL     RCO1          SRCO1                                        195220
     C                   MOVEL     RCO2          SRCO2                                        195220
     C                   MOVEL     RCO3          SRCO3                                        195220
     C                   MOVEL     RCO4          SRCO4                                        195220
     C                   MOVEL     RCO5          SRCO5                                        195220
      *                                                                                       195220
     C                   MOVEL     ACB1          SACB1                                        195220
     C                   MOVEL     ACB2          SACB2                                        195220
     C                   MOVEL     ACB3          SACB3                                        195220
     C                   MOVEL     ACB4          SACB4                                        195220
     C                   MOVEL     ACB5          SACB5                                        195220
      *                                                                                       195220
     C                   MOVEL     BNC1          SBNC1                                        195220
     C                   MOVEL     BNC2          SBNC2                                        195220
     C                   MOVEL     BNC3          SBNC3                                        195220
     C                   MOVEL     BNC4          SBNC4                                        195220
     C                   MOVEL     BNC5          SBNC5                                        195220
      *                                                                                       195220
     C                   MOVEL     INB1          SINB1                                        195220
     C                   MOVEL     INB2          SINB2                                        195220
     C                   MOVEL     INB3          SINB3                                        195220
     C                   MOVEL     INB4          SINB4                                        195220
     C                   MOVEL     INB5          SINB5                                        195220
      *                                                                                       195220
     C                   ENDIF                                                                195220
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SNDM@P - SEND A MESSAGE TO PRIMARY DETAILS SCREEN
      *****************************************************************
     C     SNDM@P        BEGSR
      *
      * If single branching, user can't browse file
      *
     C     @ERRMS        IFEQ      'FXM0292'
     C                   MOVE      'N'           OKACTION
     C                   END
      *
      ** Payment reference on screen must be blank or numeric for pointer
      *
     C     @ERRMS        IFEQ      'MMA1066'
     C                   MOVE      'N'           OKPREF
     C                   END
      *
      ** Add error message to array passed to detail screen
      *
     C                   Z-ADD     1             E                 3 0
     C     *BLANK        LOOKUP    FldNameArr(E)                          99          *
     C                   MOVEL     '*ANY'        FldNameArr(E)
     C                   MOVEL     @ERRMS        MsgIdArr(E)
      *
     C     EndSNDM@P     ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@P - CANCEL ON PRIMARY DETAILS SCREEN
      *****************************************************************
     C     CANC@P        BEGSR
      *
      * If F12 pressed from primary details screen, PREF sequence should be                   209067
      * ONLY reduce PREF sequence number if it was incremented.                               209067
     C                   if        FirstTime <> 'Y'                                           209067
      * If F12 pressed reduce PREF sequence number by 1 so that it is back                    209067
      * to what it was.                                                                       209067
     C     PYTP          IFEQ      'RP'                                                       209067
     C     *LOCK         IN        RGPAYD                                                     209067
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C***********        z-add     prnum         svnum             4 0                 209067 CFT151
     C                   z-add     0             svnum             4 0                        CFT151
     C                   eval      aprnum = prnum                                             CFT151
     C                   eval      svnum = nprnum                                             CFT151
     C                   eval      svnum = svnum + 1                                          209067
     C**********         if        svnum = RSQNM                                      209067 BUG4776
     C                   if        svnum = RSQNM                                            BUG4776R
     C*****SVNUM         IFLE      RSQNM                                            BUG4776 BUG4776R
      * No new reference has been generated - so reduce sequence number on data area          209067
     C**********         SUB       1             RSQNM                                209067 BUG4776
     C                   SUB       1             RSQNM                                      BUG4776R
     C**********         EVAL      RSQNM = PRNUM                                    BUG4776 BUG4776R
      * Ensure PREF is generated again if entering a new payment after cance                  209067
     C                   eval      FirstTime = 'Y'                                            209067
     C**********         else                                                         209067 BUG4776
     C                   else                                                               BUG4776R
      * if another number has been generated, the current payment reference                   209067
      *  only if the program is exited, otherwise the pref is re-used.                        209067
     C                   endif                                                                209067
     C                   OUT       RGPAYD                                                     209067
                                                                                              209067
     C                   ELSE                                                                 209067
      *                                                                                       209067
     C     *LOCK         IN        OTPAYD                                                     209067
     C                   IF        CFT151 = 'N'                                               CFT151
     C**************     z-add     prnum         svnum                                 209067 CFT151
     C                   eval      aprnum = prnum                                             CFT151
     C                   eval      svnum = nprnum                                             CFT151
     C                   eval      svnum = svnum + 1                                          209067
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C**********         if        svnum = OSQNM                                      209067 BUG4776
     C**********         if        svnum = OSQNM                                     BUG4776R CFT151
     C                   if        svnum = WOTSQ                                              CFT151
     C*****SVNUM         IFLE      OSQNM                                            BUG4776 BUG4776R
      * No reference has been generated - so reduce sequence number on data                   209067
     C**********         SUB       1             OSQNM                                209067 BUG4776
     C**********         SUB       1             OSQNM                               BUG4776R CFT151
     C                   SUB       1             WOTSQ                                        CFT151
     C/COPY WNCPYSRC,JMI106_010                                                               JMI106
     C**********         EVAL      OSQNM = PRNUM                                    BUG4776 BUG4776R
      * Ensure PREF is generated again if entering a new payment after cance                  209067
     C                   eval      FirstTime = 'Y'                                            209067
     C**********         else                                                         209067 BUG4776
     C                   else                                                               BUG4776R
      * if another number has been generated, the current payment reference                   209067
      *  only if the program is exited, otherwise the pref is re-used.                        209067
     C                   endif                                                                209067
      *                                                                                       209067
     C                   OUT       OTPAYD                                                     209067
     C                   ELSE                                                                 CFT151
     C                   MOVE      PRNUM         svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   if        WNEWSQ = OTPAYD                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   eval      FirstTime = 'Y'                                            CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                CFT151
     C                   END                                                                  209067
     C                   endif                                                                209067
      *                                                                                       209067
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * If input fields are enabled
      * Blank the screens
     C     SSIMode       IFNE      'Y'                                         CFT018
     C     SSIMode       OREQ      'Y'                                         CFT018
     C     SACTION       ANDNE     'I'                                         CFT018
      *
     C     @EKYFD        IFEQ      'Y'
     C     @EDTFD        OREQ      'Y'
     C                   MOVEL     *BLANK        NewPmtScn1
     C                   MOVEL     *BLANK        NewPmtSc1b                     CFT014
     C                   MOVEL     *BLANK        NewPmtSc2a
     C                   MOVEL     *BLANK        NewPmtSc2b
     C                   MOVEL     *BLANK        NewPmtScn3
     C                   MOVEL     *BLANK        NewPmtSc3b                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn4                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5                     CFT014
      *                                                                                       CER030
     C                   MOVEL     *BLANKS       NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANKS       NewPmtScn5B                                  CER030
      *                                                                                       CER030
     C                   MOVEL     *BLANK        DDSTAT
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     *BLANK        NewPmtScnA                                   CSW209
     C                   MOVEL     *BLANK        NewPmtScnC                                   CSW209
     C                   EndIf                                                                CSW209
     C                   END
     C                   EXSR      PAYSCM1                                                    256192
      *                                                                         CFT018
     C                   ENDIF                                                  CFT018
      *
     C                   MOVEL     'N'           @EINKJ
     C                   MOVEL     'N'           @EINKV
      *
      * Initialize field status on Primary Screen
      *
     C                   EXSR      IFDS@P
      *
      ** If called from linked enqiry return to calling program.
     C     LinkedEnq     IFNE      *BLANK
     C                   MOVEL     'T'           @SCRN
      ** F12
     C     @INKL         IFEQ      '1'
     C                   MOVE      '5'           @ReturnCde
      ** F18
     C                   ELSE
     C                   MOVE      '7'           @ReturnCde
      *                                                                                       210733
     C     WInsert       IFEQ      'Y'                                                        210733
     C                   MOVE      @SITR         XPREF                                        210733
     C                   MOVE      'I'           @ReturnCde                                   210733
     C                   ENDIF                                                                210733
      *                                                                                       210733
     C                   END
     C                   END
      *                                                                         CFT018
      ** If called from SSI Payment Input then return to SSI details            CFT018
     C     SSIMode       IFEQ      'Y'                                          CFT018
     C     SACTION       IFEQ      'I'                                          CFT018
     C                   MOVE      'E'           @SCRN                          CFT018
     C                   ELSE                                                   CFT018
     C                   MOVE      'F'           @SCRN                          CFT018
     C                   ENDIF                                                  CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
      **  Reset valid payment flag                                              CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@S - CANCEL ON SECONDARY SCREEN
      *****************************************************************
     C     CANC@S        BEGSR
      *
      * If not called from linked enquiry
      * Initialize field status on Primary Screen
      *
     C     LinkedEnq     IFEQ      *BLANK
     C                   EXSR      IFDS@P
     C                   END
      *****************************************************************                CFT009 262853
      **Ensure*charges*to*the*debit*of*field*is*cleared,*if*CFT009*is*on.              CFT009 262853
      *****************************************************************                CFT009 262853
     C*****@CFT009       IFEQ      'Y'                                                 CFT009 262853
     C**********         EVAL      SCDRO = *BLANKS                                     CFT009 262853
     C**********         ENDIF                                                         CFT009 262853
      *
      * Return to Primary Screen
      *
     C                   MOVEL     'P'           @SCRN
      *
      ** Set flag to indicate that payment reference already set and no                       242102
      ** need to re-check it when trying to proceed from the 1st screen                       242102
     C                   If        SACTION = 'I'                                              255763
     C                   MOVEL     'Y'           PRflag                                       242102
     C                   Endif                                                                255763
      *                                                                                       242102
      ** Return the Payment reference if F12 is pressed                                     AR402776
      *                                                                                     AR402776
     C                   IF        SACTION = 'A' AND STFlag = 'Y'                           AR402776
     C                   MOVEL     WOSPREF       SPREF                                      AR402776
     C                   MOVEL     *BLANK        STFlag                                     AR402776
     C                   ENDIF                                                              AR402776
      *                                                                                     AR402776
     C                   ENDSR
      *****************************************************************         CFT014
      /Title Sr/CANC@B                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/CANC@B     - Cancel on 3rd screen level 2                  *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@B Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     CANC@B        BegSr                                                  CFT014
                                                                                CFT014
      ** Return to second screen level 2                                        CFT014
                                                                                CFT014
     C                   Movel     'S'           @SCRN                          CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/CANC@M                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/CANC@M     - Cancel on Margin Information Screen           *         CFT014
      *                                                               *         CFT014
      * Called By: SCRN@M Subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     CANC@M        BegSr                                                  CFT014
                                                                                CFT014
      ** Return to Charges and Commissions Screen                               CFT014
                                                                                CFT014
     C                   Movel     'O'           @SCRN                          CFT014
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@O - CANCEL ON CHARGES & PAYMENTS SCREEN
      *****************************************************************
     C     CANC@O        BEGSR
      *
      * Return to Secondary Screen
      *
     C***********        MOVEL     'S'           @SCRN                          CFT014
     C                   MOVEL     'B'           @SCRN                          CFT014
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * REDISP  - Redisplay primary screen if cancel on F21 window
      *****************************************************************
     C     REDISP        BEGSR
      *
     C                   MOVE      '0'           @INKV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * LINK - Set up processing for call from linked enqury.
      *****************************************************************
     C     LINK          BEGSR
      *
     C**  If program is called by GL4442, then initialise fields.

     C                   MOVE      *BLANK        @GL442            1
     C     @ReturnCde    IFEQ      'G'
     C                   MOVE      'Y'           @GL442
     C                   MOVE      *BLANK        @ReturnCde
     C                   END
      *
      ** If reference passed...
      *
     C     XPREF         IFNE      *BLANKS
     C                   MOVE      @SORT         SACTION
     C                   MOVE      XPREF         SPREF
      *
      * If action code 'I' and Payment reference not blank
      * set up the detail screen fields from swift message
     C     SACTION       IFEQ      'I'
     C     XPREF         ANDNE     *BLANKS
     C                   MOVE      'Y'           @SWIFT            1
     C                   ELSE
     C                   MOVE      'N'           @SWIFT
     C                   END
      *
      * Retrieve & Validate Payment details prior to display
     C                   EXSR      VAL@P
     C                   END
      *
     C     EndLink       TAG
      *
      ** Disable CMDs 7,8 & 15 and key fields

     C                   MOVE      'N'           @EINKG
     C                   MOVE      'N'           @EINKH
     C                   MOVE      'N'           @EINKP
     C                   MOVE      'N'           @EKYFD
      *
      * If Enquire enable F21 key field
     C     @SORT         IFEQ      'E'
     C                   MOVE      'Y'           @EINKV
     C                   ELSE
     C                   MOVE      'N'           @EINKV
     C                   END
     C
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SCRN@C - PROCESS SCREEN: CONFIRMATION OF INPUT
      *          EVOKED FOR INSERTS, & AMENDS
      *****************************************************************
     C     SCRN@C        BEGSR
      *
      * If transaction is valid output message 'Press enter to accept'
      *
     C     Idx           IFEQ      *ZERO
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1030'     MsgIdArr(1)
     C                   END
      *                                                                         CFT018
      **  Reset function keys prior to display                                  CFT018
     C                   Move      '0'           @INKC                          CFT018
     C                   Move      '0'           @INKD                          CFT018
     C                   Move      '0'           @INKG                          CFT018
     C                   Move      '0'           @INKH                          CFT018
     C                   Move      '0'           @INKJ                          CFT018
     C                   Move      '0'           @INKL                          CFT018
     C                   Move      '0'           @INKP                          CFT018
     C                   Move      '0'           @INKQ                          CFT018
     C                   Move      '0'           @INKS                          CFT018
     C                   Move      '0'           @INKV                          CFT018
      *                                                                         CFT018
      **  Do not display screen if payment to be inserted from SSI              CFT018
     C     @InsertPay    Ifne      'Y'                                          CFT018
      *                                                                         CFT018
      *
      * WRITE/READ DISPLAY SCREEN
      *
     C                   CALLB     'FTOPAY1DP'
      *
      * INPUT PARAMETERS
      *
      * RETURN CODE
     C                   PARM      *BLANK        RetCodeOut
      *
      * DEAL (IN SCREEN FORMAT)
     C                   PARM                    NewPmtScn1
     C                   PARM                    NewPmtSc1b                     CFT014
      *
      * DEAL STATUS
     C                   PARM                    DDSTAT
      *
      * FIELDS IN ERROR
     C                   PARM                    FTEOPY1
      *
      * ERRORS
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      *
      * WARNINGS
     C                   PARM                    WFldNamArr
     C                   PARM                    WMsgIdArr
     C                   PARM                    WMsgDtaArr
      *
      * ENABLED KEY & DETAIL FIELDS
      *
     C                   PARM      'N'           @EKYFD
     C                   PARM      'N'           @EDTFD
      *
      * ENABLED FUNCTION KEYS
     C                   PARM      'N'           @EINKD                         CFT007
     C                   PARM      'N'           @EINKG
     C                   PARM      'N'           @EINKH
     C                   PARM      'N'           @EINKJ
     C                   PARM      'N'           @EINKP
     C                   PARM      'N'           @EINKQ                         CFT007
     C                   PARM      'N'           @EINKS
     C                   PARM      'N'           @EINKV
      *
      * SUCCESFUL INSERT
     C                   PARM                    @SITR
      *
      * Data required for Additional Info window
     C                   PARM                    INUSR1
     C                   PARM                    INUSR2
     C                   PARM                    AUP1
     C                   PARM                    AUP2
     C                   PARM                    OPMSGR
      *
      * SWIFT Identifier
     C                   PARM                    XPREF

      * OUTPUT PARAMETERS
      *
      * FUNCTION KEYS
     C                   PARM      '0'           @INKC             1
     C                   PARM      '0'           @INKD                          CFT007
     C                   PARM      '0'           @INKG             1
     C                   PARM      '0'           @INKH             1
     C                   PARM      '0'           @INKJ             1
     C                   PARM      '0'           @INKL             1
     C                   PARM      '0'           @INKP             1
     C                   PARM      '0'           @INKQ                          CFT007
     C                   PARM      '0'           @INKS             1
     C                   PARM      '0'           @INKV             1
     C                   PARM      'N'           WriteOnly         1
      * Cursor location on screen                                               CFT007
     C                   PARM      0             CursorLoc                      CFT007
     C                   PARM                    SSIMode           1            CFT018
      *                                                                         CFT018
     C                   Endif                                                  CFT018
      *
      * RESET ERRORS
      *
     C                   MOVE      *ALL'Y'       FTEOPY1
     C                   MOVEL     *BLANK        FldNameArr
     C                   MOVEL     *BLANK        MsgIdArr
     C                   MOVEL     *BLANK        MsgDtaArr
     C                   MOVEL     *BLANK        WFldNamArr
     C                   MOVEL     *BLANK        WMsgIdArr
     C                   MOVEL     *BLANK        WMsgDtaArr
      *
      * CK/3 - END PROGRAM
      *
     C     @INKC         CASEQ     '1'           ENDP
      *
      * CK/12 - CANCEL ON CONFIRMATION SCREEN
      *
     C     @INKL         CASEQ     '1'           CANC@C
      *
      * EXIT CONFIRMATION SCREEN
      *
     C                   CAS                     EXIT@C
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * CANC@C - CANCEL ON CONFIRMATION SCREEN
      *****************************************************************
     C     CANC@C        BEGSR
      *
      * RETURN TO MAIN DETAILS SCREEN
      *
     C                   MOVEL     'P'           @SCRN
      *                                                                                       262724
      ** Set flag to indicate that payment reference already set and no                       262724
      ** need to re-check it when trying to proceed from the 1st screen                       262724
     C                   IF        SACTION = 'I'                                              262724
     C                   MOVEL     'Y'           PRflag                                       262724
     C                   ENDIF                                                                262724
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
      *
      ** Return the Payment reference if F12 is pressed                                     AR402776
      *                                                                                     AR402776
     C                   IF        SACTION = 'A' AND STFlag = 'Y'                           AR402776
     C                   MOVEL     WOSPREF       SPREF                                      AR402776
     C                   MOVEL     *BLANK        STFlag                                     AR402776
     C                   ENDIF                                                              AR402776
      *                                                                                     AR402776
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * EXIT@C - EXIT FROM CONFIRMATION SCREEN
      *****************************************************************
     C     EXIT@C        BEGSR
      *
      * IF NO ERRORS IN VALIDATION
      *
     C     Idx           IFEQ      *ZERO
      *
      * CONTINUE WITH UPDATES
      *
     C                   MOVEL     'U'           @SCRN
      *
      * ELSE, RETURN TO MAIN DETAILS SCREEN
      *
     C                   ELSE
     C                   MOVEL     'P'           @SCRN
      *
      * Initialize field status on main details screen
      *
     C                   EXSR      IFDS@P
      *
      * Set function key status on main details screen
      * (according to action code)
      *
     C                   EXSR      SFDS@P
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * UPDATS - UPDATES
      *****************************************************************
     C     UPDATS        BEGSR
      *                                                                                       210733
     C                   MOVE      ' '           WInsert           1                          210733
     C/COPY WNCPYSRC,FTOPA1SC35
      *
     C/COPY WNCPYSRC,FTOPAY1S03
      **Set*up*payment Reference for insert.                                                  204152
     C*****SACTION       IFEQ      'I'                                                        204152
     C**********         EXSR      SETPAYREF                                                  204152
     C**********         END                                                                  204152
                                                                                            MD050619
      ** Set up Payment Reference if Window processing is not done                          MD050619
                                                                                            MD050619
     C                   IF        SPREF = *BLANKS AND                                      MD050619
     C                             GENPREF = 'Y' AND SACTION = 'I'                          MD050619
     C                   EXSR      SETPAYREF                                                MD050619
     C                   ENDIF                                                              MD050619
      *                                                                                     AR402776
      ** Return the previous value of SPREF for updating                                    AR402776
      *                                                                                     AR402776
     C                   IF        SACTION = 'A' and STFlag = 'Y'                           AR402776
     C                   MOVEL     WOSPREF       SPREF                                      AR402776
     C                   ENDIF                                                              AR402776
     C/COPY WNCPYSRC,FTOPAY1S04
      *
      * UPDATE VALID Payment: Payment REFERENCE
      *
     C                   MOVEL     SPREF         OTPREF
      *
      * UPDATE VALID Payment: CHANGE TYPE
      *
     C                   MOVEL     SACTION       OTCHTP
      *
      * UPDATE VALID Payment: RECI
      *
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                   Move      'D'           O2RECI                         CFT014
     C                   Movel     SPREF         O2PREF                         CFT014
                                                                                CFT014
      ** Action is 'I' or 'A'                                                   CFT014
                                                                                CFT014
     C                   If        (SACTION = 'I') Or (SACTION = 'A')           CFT014
     C                   Move      'N'           O2AUTO                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   MOVE      'D'           OTRECI
      *
      * PAYMENTS UPDATES
      *
     C                   CALLB     'FTOPAYUPD'
      *  Return Code
     C                   Parm                    RetCodeOut

      *  OK Flags
     C                   Parm                    FTEOPY1
     C                   Parm                    FTEOPY2
     C                   Parm                    FTEOPY3
     C                   Parm                    FTEOPY4                        CFT014
     C                   Parm                    FTEOPY5                        CFT014

      * New Valid payment layout
     C                   PARM                    NwPtFilFmt
     C                   PARM                    NwPtFilFmX                     CFT014

      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *                                                                                       CAP211
     C                   PARM                    PAuth             1                          CAP211
     C                   PARM                    PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPA1SC15

      *                                                                                       214320
      ** Release any allocated transaction                                                    214320
      *                                                                                       214320
     C                   MOVE      *BLANKS       @RTCDE                                       214320
     C                   MOVE      'FT'          @MODLE                                       214320
     C                   MOVE      *BLANKS       @TREF                                        214320
     C                   MOVE      *BLANKS       @RTINF                                       214320
     C                   CALL      'AOC8000'                                                  214320
     C                   PARM                    @RTCDE                                       214320
     C                   PARM                    @MODLE                                       214320
     C                   PARM                    @TREF                                        214320
     C                   PARM                    @RTINF                                       214320
      *                                                                                       214320
      * IF THERE WERE ANY ERRORS IN THE UPDATE FUNCTIONS, ROLLBACK ANY
      * UPDATES AND END THIS PROGRAM. OTHERWISE, COMMIT THE UPDATES
      *
     C     RetCodeOut    IFNE      *BLANK
     C     RetCodeOut    ANDNE     '*RECUPD'
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   ROLBK
     C                   EndIf                                                                CSC022
     C                   EXSR      *PSSR
     C                   ELSE
      **                                                                                      CSC022
      ** Execute commit if SAR CSC022 is not enrolled or                                      CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                             Or (CSC022 = 'Y' and WSkpComtRolbk = 'N')                  CSC022
     C                   IF        ULX043 = 'Y'                                               CER001
     C                             AND  BTLVJN = 'Y'                                          CER001
     C                             AND SACTION <> 'D'                                         CER001
      *                                                                                       CER001
      ** New Window processing, if F12 or F3                                                  CER001
      ** Create a Blank Record without details using call to FT0045XL                         CER001
      ** during Close of Business (No ext. details in this case)                              CER001
      *                                                                                       CER001
     C                   EXSR      WINDOWI                                                    CER001
     C                   ENDIF                                                                CER001
     C                   COMMIT
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,FTOPA1SC20
     C     SACTION       IFEQ      'I'
     C                   MOVE      SPREF         @SITR
      *                                                                                       210733
     C     LinkedEnq     IFEQ      'Y'                                                        210733
     C                   MOVE      'Y'           WInsert                                      210733
     C                   ENDIF                                                                210733
      *                                                                                       210733
     C                   END
     C                   END
      *
     C** If update not done due to record being updated by another
     C** workstation send message to screen.
     C
     C     RetCodeOut    IFEQ      '*RECUPD'
     C
     C                   MOVEL     '*ANY'        FldNameArr(1)
     C                   MOVEL     'MMM1067'     MsgIdArr(1)
     C/COPY WNCPYSRC,FTH00260
     C
     C                   END
     C/COPY WNCPYSRC,FTH00266
     C
      * IF RECORDS ARE STILL TO BE READ FROM THE SUBFILE, READ THEM
      *
     C     @RDNB         IFEQ      'Y'
     C                   MOVEL     'R'           @SCRN
     C                   ELSE
      *
      * Else, if called from linked enquiry go back to calling program.
     C     LinkedEnq     IFNE      *BLANKS
     C**********         MOVEL     FirstTime     W1stTime          1                BUG4776 BUG4776R
     C**********         EVAL      FirstTime = 'Y'                                  BUG4776 BUG4776R
      *                                                                                       219732
      * Set FirstTime to 'Y' to prevent OTPAYDA from being updated incorrectly                219732
     C                   EVAL      FirstTime = 'Y'                                            219732
     C                   EXSR      CANC@P
     C**********         EVAL      FirstTime = W1stTime                             BUG4776 BUG4776R
      *                                                                                       212561
     C**********     SACTION       IFEQ      'I'                                     212561 MD036155
     C**********         IF        CFT151 = 'N'                                      CFT151 MD036155
     C**********     *LOCK         IN        OTPAYD                                  212561 MD036155
     C******             ADD       1             OSQNM                                 212561 CFT151
     C**********         ADD       1             WOTSQ                               CFT151 MD036155
     C**********         OUT       OTPAYD                                            212561 MD036155
     C**********         ELSE                                                        CFT151 MD036155
     C**********         CALL      'FT000328'                                        CFT151 MD036155
     C**********         PARM                    PRTCD                               CFT151 MD036155
     C**********         PARM      'OT'          W@OTIN            2                 CFT151 MD036155
     C**********         PARM      'A'           WCALC             1                 CFT151 MD036155
     C**********         PARM      'Y'           WUPD              1                 CFT151 MD036155
     C**********         PARM                    svalph                              CFT151 MD036155
     C**********         PARM                    WNEWSQ            4                 CFT151 MD036155
     C**********         ENDIF                                                       CFT151 MD036155
     C**********         ENDIF                                                       212561 MD036155
      *                                                                                       212561
     C                   ELSE

      * ELSE, GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
     C                   END
     C                   END
      *                                                                         CFT018
      **  Set last action update indicator                                      CFT018
     C                   MOVE      'U'           LastActn          1            CFT018
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************
      * SETPAYREF  Set up Payment Reference
      *****************************************************************
     C     SETPAYREF     BEGSR
      *
     C                   MOVE      SPYTP         PmntType
     C                   MOVE      SSTTP         StmtType
                                                                                              CSC011
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011

     **  Convert rundate to YYMMDD format.
     C                   CALLB     'ZDATE2'
     C**********         PARM      BJRDNB        ZDAYNO            5 0                        CSC011
     C                   PARM                    ZDAYNO            5 0                        CSC011
     C                   PARM      'M'           ZDATFM            1
     C                   PARM      *ZEROS        ZDATE             6 0
     C                   PARM      *BLANK        ZADATE            7

     C                   MOVE      ZDATE         RUNDYY
     C                   MOVEL     ZDATE         RUNDMD

     **  Get sequence number from data area.
     C     PYTP          IFEQ      'RP'
     C     *LOCK         IN        RGPAYD
     C**************     Z-ADD     RSQNM         PRNUM                                        CFT151
     C                   MOVEL     RSQNM         PRNUM                                        CFT151
     C                   ADD       1             RSQNM
     C**********         MOVEL     IPREF         WIPREF                             BUG4776 BUG4776R
     C**********         EVAL      WPRNUM = RSQNM                                   BUG4776 BUG4776R
     C**********         EXSR      SETPREFSQ                                        BUG4776 BUG4776R
     C                   OUT       RGPAYD
     C                   ELSE
      *
     C/COPY WNCPYSRC,FTH00063
     C                   IF        CFT151 = 'N'                                               CFT151
     C     *LOCK         IN        OTPAYD
     C**********         Z-ADD     OSQNM         PRNUM                                        CFT151
     C**********         ADD       1             OSQNM                                        CFT151
     C                   MOVEL     WOTSQ         PRNUM                                        CFT151
     C                   ADD       1             WOTSQ                                        CFT151
     C**********         MOVEL     IPREF         WIPREF                             BUG4776 BUG4776R
     C**********         EVAL      WPRNUM = OSQNM                                   BUG4776 BUG4776R
     C**********         EXSR      SETPREFSQ                                        BUG4776 BUG4776R
     C                   OUT       OTPAYD
     C                   ELSE                                                                 CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C**********         PARM      'A'           WCALC                               CFT151 MD036155
     C                   PARM      'A'           WCALC             1                        MD036155
     C                   PARM      'Y'           WUPD              1                          CFT151
     C                   PARM                    PRNUM                                        CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C/COPY WNCPYSRC,FTH00064
     C                   END
     C/COPY WNCPYSRC,FTH00065

     C                   MOVE      IPREF         SPREF
     C/COPY WNCPYSRC,FTH00066

      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************             BUG4776 BUG4776R
      **SETPPREFSQ*Set*up*Next*Payment*Reference*sequence**************             BUG4776 BUG4776R
      *****************************************************************             BUG4776 BUG4776R
     C*****SETPREFSQ     BEGSR                                                      BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         MOVE      'N'           WUREF1            1                BUG4776 BUG4776R
     C*****WUREF1        DOWEQ     'N'                                              BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C*****WIPREF        CHAIN     FTPREFL1                           83            BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      ****If*Payment*Reference*is*found,*increment*RSQNM/OSQNM*sequence             BUG4776 BUG4776R
      ****number*by*1*depending*on*payment*type*of*transaction.********             BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C******IN83         IFEQ      '0'                                              BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C*****PYTP          IFEQ      'RP'                                             BUG4776 BUG4776R
     C**********         EVAL      RSQNM = RSQNM + 1                                BUG4776 BUG4776R
     C**********         EVAL      WPRNUM = RSQNM                                   BUG4776 BUG4776R
     C**********         ELSE                                                       BUG4776 BUG4776R
     C**********         EVAL      OSQNM = OSQNM + 1                                BUG4776 BUG4776R
     C**********         EVAL      WPRNUM = OSQNM                                   BUG4776 BUG4776R
     C**********         ENDIF                                                      BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         ELSE                                                       BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      ****Else*move*'Y'*to*WUREF*to*stop*the*loop.*********************             BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         MOVE      'Y'           WUREF1                             BUG4776 BUG4776R
     C**********         ENDIF                                                      BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         ENDDO                                                      BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         ENDSR                                                      BUG4776 BUG4776R
      *****************************************************************             BUG4776 BUG4776R
      */EJECT***                                                                    BUG4776 BUG4776R
      *****************************************************************
      * ENDP - End Program
      *****************************************************************
     C     ENDP          BEGSR
      * ONLY reduce PREF sequence number if it was incremented.                               209067
     C                   IF        FirstTime <> 'Y'                                           209067
      * If F3 pressed reduce PREF sequence number by 1 so that it is back                     204152
      * to what it was.                                                                       204152
     C     PYTP          IFEQ      'RP'                                                       204152
     C     *LOCK         IN        RGPAYD                                                     204152
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C**************     z-add     prnum         svnum             4 0                 209067 CFT151
     C                   eval      aprnum = prnum                                             CFT151
     C                   eval      svnum = nprnum                                             CFT151
     C                   eval      svnum = svnum + 1                                          209067
     C**********         if        svnum = RSQNM                                      209067 BUG4776
     C                   if        svnum = RSQNM                                            BUG4776R
     C*****SVNUM         IFLE      RSQNM                                            BUG4776 BUG4776R
      * No new reference has been generated - so reduce sequence number on data area          209067
     C**********         SUB       1             RSQNM                                204152 BUG4776
     C                   SUB       1             RSQNM                                      BUG4776R
     C**********         EVAL      RSQNM = PRNUM                                    BUG4776 BUG4776R
     C                   endif                                                                209067
     C                   OUT       RGPAYD                                                     204152
     C                   ELSE                                                                 204152
      *                                                                                       204152
     C     *LOCK         IN        OTPAYD                                                     204152
     C                   IF        CFT151 = 'N'                                               CFT151
     C*************      z-add     prnum         svnum                                 209067 CFT151
     C                   eval      aprnum = prnum                                             CFT151
     C                   eval      svnum = nprnum                                             CFT151
     C                   eval      svnum = svnum + 1                                          209067
      *                                                                                       209067
      * Check to see if another pref has been generated by another function                   209067
      *                                                                                       209067
     C**********         if        svnum = OSQNM                                      209067 BUG4776
     C**********         if        svnum = OSQNM                                     BUG4776R CFT151
     C                   if        svnum = WOTSQ                                              CFT151
     C*****SVNUM         IFLE      OSQNM                                            BUG4776 BUG4776R
      * No reference has been generated - so reduce sequence number on data                   209067
     C**********         SUB       1             OSQNM                                204152 BUG4776
     C**********         SUB       1             OSQNM                               BUG4776R CFT151
     C                   SUB       1             WOTSQ                                        CFT151
     C/COPY WNCPYSRC,JMI106_011                                                               JMI106
     C**********         EVAL      OSQNM = PRNUM                                    BUG4776 BUG4776R
     C                   endif                                                                209067
      *                                                                                       209067
     C                   OUT       OTPAYD                                                     204152
     C                   ELSE                                                                 CFT151
     C                   MOVE      PRNUM         svalph            4                          CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'A'           WCALC                                        CFT151
     C                   PARM      'N'           WUPD              1                          CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   if        WNEWSQ = OTPAYD                                            CFT151
     C                   CALL      'FT000328'                                                 CFT151
     C                   PARM                    PRTCD                                        CFT151
     C                   PARM      'OT'          W@OTIN            2                          CFT151
     C                   PARM      'S'           WCALC                                        CFT151
     C                   PARM      'Y'           WUPD                                         CFT151
     C                   PARM                    svalph                                       CFT151
     C                   PARM                    WNEWSQ            4                          CFT151
     C                   ENDIF                                                                CFT151
     C                   ENDIF                                                                CFT151
     C                   END                                                                  204152
     C                   ENDIF                                                                209067
      *                                                                                       204152
      ** Issue rollback to clear any possible updates in window function                      209867
      *                                                                                       209867
     C     BGWDPR        IFEQ      'Y'                                                        209867
     C     @SORT         ANDNE     'E'                                                      BUG24143
      **                                                                                      CSC022
      ** Execute rollback if SAR CSC022 is not enrolled or                                    CSC022
      **   job is not currently running in batch mode                                         CSC022
      **                                                                                      CSC022
     C                   If        CSC022 = 'N'                                               CSC022
     C                   ROLBK                                                                209867
     C                   Else                                                                 CSC022
     C                   If        WSkpComtRolbk = 'N'                                        CSC022
     C                   RolBk                                                                CSC022
     C                   Else                                                                 CSC022
     C                   SetOn                                        U7U8                    CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C                   END                                                                  209867
      *
     C                   MOVEL     'T'           @SCRN
      *
      ** If called from linked enqiry return to calling program.
     C     LinkedEnq     IFNE      *BLANK
     C                   MOVE      '1'           @ReturnCde
     C                   END
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         CFT007
      * BIC Database Plus Integration                                           CFT007
      *****************************************************************         CFT007
     C     BICPrompt     BEGSR                                                  CFT007
                                                                                CFT007
      * BIC Database update prompt and search processing                        CFT007
                                                                                CFT007
      * Determine whether the cursor is on an allowed field                     CFT007
                                                                                CFT007
      * Note: If these screen fields move then these values                     CFT007
      *       will need changing                                                CFT007
                                                                                CFT007
      *       The formula is (cursor row number * 256) + column number          CFT007
                                                                                CFT007
     C                   EVAL      BICLines = *Zeros                            CFT007
     C                   EVAL      @ICriteria = *Blanks                         CFT007
                                                                                CFT007
     C                   SELECT                                                 CFT007
                                                                                CFT007
      * Destination line 1                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 1794 and CursorLoc <= 1828      CFT007
     C                   EVAL      Line1Dest = *On                              CFT007
     C                   EVAL      @ICriteria = SDST1                           CFT007
                                                                                CFT007
      * Destination line 2                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C                             CursorLoc >= 1837 and CursorLoc <= 1871      CFT007
     C                   EVAL      Line2Dest = *On                              CFT007
     C                   EVAL      @ICriteria = SDST2                           CFT007
                                                                                CFT007
      * Ordering customer line 1                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C**********                   CursorLoc >= 2562 and CursorLoc <= 2596           CFT007 MD021574
     C                             CursorLoc >= 2349 and CursorLoc <= 2383                  MD021574
     C                   EVAL      Line1OCus = *On                              CFT007
     C                   Eval      @ICriteria = SORC1                           CFT007
                                                                                CFT007
      * Ordering customer line 2                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'P' and                              CFT007
     C**********                   CursorLoc >= 2605 and CursorLoc <= 2639           CFT007 MD021574
     C                             CursorLoc >= 2562 and CursorLoc <= 2596                  MD021574
     C                   EVAL      Line2OCus = *On                              CFT007
     C                   EVAL      @ICriteria = SORC2                           CFT007
                                                                                CFT007
      * Receiver's correspondent line 1                                         CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C                             CursorLoc >= 1325 and CursorLoc <= 1359      CFT007
     C                   EVAL      Line1RCor = *On                              CFT007
     C                   EVAL      @ICriteria = SRCO1                           CFT007
                                                                                CFT007
      * Receiver's correspondent line 2                                         CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C                             CursorLoc >= 1538 and CursorLoc <= 1572      CFT007
     C                   EVAL      Line2RCor = *On                              CFT007
     C                   EVAL      @ICriteria = SRCO2                           CFT007
                                                                                CFT007
      * Account with bank line 1                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2093 and CursorLoc <= 2127      CFT007 CFT014
     C                             CursorLoc >= 3629 and CursorLoc <= 3663      CFT014
     C                   EVAL      Line1ABnk = *On                              CFT007
     C                   EVAL      @ICriteria = SACB1                           CFT007
                                                                                CFT007
      * Account with bank line 2                                                CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2306 and CursorLoc <= 2340      CFT007 CFT014
     C                             CursorLoc >= 3842 and CursorLoc <= 3876      CFT014
     C                   EVAL      Line2ABnk = *On                              CFT007
     C                   EVAL      @ICriteria = SACB2                           CFT007
                                                                                CFT007
      * Beneficiary line 1                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 2861 and CursorLoc <= 2895      CFT007 CFT014
     C                             CursorLoc >= 4397 and CursorLoc <= 4431      CFT014
     C                   EVAL      Line1Benf = *On                              CFT007
     C                   EVAL      @ICriteria = SBNC1                           CFT007
                                                                                CFT007
      * Beneficiary line 2                                                      CFT007
                                                                                CFT007
     C                   WHEN      @SCRN = 'S' and                              CFT007
     C***********                  CursorLoc >= 3074 and CursorLoc <= 3108      CFT007 CFT014
     C                             CursorLoc >= 4610 and CursorLoc <= 4644      CFT014
     C                   EVAL      Line2Benf = *On                              CFT007
     C                   EVAL      @ICriteria = SBNC2                           CFT007
                                                                                CFT007
      * Intermediary bank line 1                                                CFT007
                                                                                CFT007
     C***********        WHEN      @SCRN = 'O' and                              CFT007 CFT014
     C***********                  CursorLoc >= 1050 and CursorLoc <= 1084      CFT007 CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2861) And (CursorLoc <= 2895)  CFT014
     C                   EVAL      Line1IBnk = *On                              CFT007
     C                   EVAL      @ICriteria = SINB1                           CFT007
                                                                                CFT007
      * Intermediary bank line 2                                                CFT007
                                                                                CFT007
     C***********        WHEN      @SCRN = 'O' and                              CFT007 CFT014
     C***********                  CursorLoc >= 1306 and CursorLoc <= 1340      CFT007 CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 3074) And (CursorLoc <= 3108)  CFT014
     C                   EVAL      Line2IBnk = *On                              CFT007
     C                   EVAL      @ICriteria = SINB2                           CFT007
                                                                                CFT014
      ** Third reimbursement institution line 1                                 CFT014
                                                                                CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2093) And (CursorLoc <= 2127)  CFT014
     C                   Eval      Line1TRIn = *On                              CFT014
     C                   Eval      @ICriteria = STRI1                           CFT014
                                                                                CFT014
      ** Third reimbursement institution line 2                                 CFT014
                                                                                CFT014
     C                   When      (@SCRN = 'S') And                            CFT014
     C                             (CursorLoc >= 2306) And (CursorLoc <= 2340)  CFT014
     C                   Eval      Line2TRIn = *On                              CFT014
     C                   Eval      @ICriteria = STRI2                           CFT014
                                                                                CFT007
     C                   OTHER                                                  CFT007
                                                                                CFT007
      * Error: Cursor outside permitted fields when F4 or F16 pressed           CFT007
                                                                                CFT007
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Eval      @ERRMS = 'FTM3261'                           CFT014
     C                   Else                                                   CFT014
     C                   EVAL      @ERRMS = 'FTM2620'                           CFT007
     C                   Endif                                                  CFT014
     C                   EXSR      SNDM@P                                       CFT007
                                                                                CFT007
     C                   ENDSL                                                  CFT007
                                                                                CFT007
      * If F4 or F16 pressed on a permitted line                                CFT007
                                                                                CFT007
     C                   IF        BICLines <> *Zeros                           CFT007
                                                                                CFT007
      * Set up prompt mode                                                      CFT007
     C                   IF        @INKD = *On                                  CFT007
     C                   EVAL      @IMode = 'P'                                 CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Set up search mode                                                      CFT007
     C                   IF        @INKQ = *On                                  CFT007
     C                   EVAl      @IMode = 'F'                                 CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Call BIC Plus enquiry program                                           CFT007
                                                                                CFT007
     C                   CALL      'FT0900'                                     CFT007
     C                   PARM                    @IMode            1            CFT007
     C                   PARM                    @ICriteria       35            CFT007
     C                   PARM      *Blanks       @OAddress       175            CFT007
     C                   PARM      *Blanks       @OCHIPCode       10            CFT007
     C                   PARM      *Blanks       @OOutCode         2            CFT007
     C                   PARM      *Blanks       @RTCD                          CFT007
                                                                                CFT007
      * F3 pressed, exit program                                                CFT007
                                                                                CFT007
     C                   IF        @RTCD = 'F3'                                 CFT007
     C                   EVAL      @SCRN = 'T'                                  CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   IF        @RTCD = *Blanks                              CFT007
                                                                                CFT007
      * If a CHIPS code exists and data returned is not BIC code with           CFT007
      * clearing code ('AC')                                                    CFT007
                                                                                CFT007
     C                   IF        @OChipCode <> *Blanks and                    CFT007
     C                             @OOutCode <> 'AC'                            CFT007
                                                                                CFT007
      * If settlement currency for ordering customer or payment currency        CFT007
      * for all other organisations, matches USD dollar code                    CFT007
                                                                                CFT007
     C                   IF        SSMCY=BLUSCY and Line1OCus = *On or          CFT007
     C                             SPCCY=BLUSCY and                             CFT007
     C                             (Line1Dest = *On or                          CFT007
     C                              Line1RCor = *On or                          CFT007
     C                              Line1ABnk = *On or                          CFT007
     C                              Line1Benf = *On or                          CFT007
     C***********                   Line1IBnk = *On)                            CFT007 CFT014
     C                              Line1IBnk = *On or                          CFT014
     C                              (Line1TRIn = *On And @CFT014 = 'Y'))        CFT014
                                                                                CFT007
      * If returned data is not branch with clearing code ('BC') or address     CFT007
      * with clearing code ('DC'), shift data along to make room for CHIPS      CFT007
                                                                                CFT007
     C                   IF        @OOutCode <> 'BC' and @OOutCode <> 'DC'      CFT007
     C                   EVAL      @OAddress = WkBlankfld + @OAddress           CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Write CHIPS code to first line, overwriting clearing code if present    CFT007
                                                                                CFT007
     C                   EVAL      WkCHIPCode = '//CH' + @OCHIPCode             CFT007
     C                   EVAL      OAddress1 = WkCHIPCode                       CFT007
     C                                                                          CFT007
     C                   ENDIF                                                  CFT007
     C                                                                          CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * If return data is BIC code with clearing code 'AC' or (branch           CFT007
      * or address with clearing code 'BC'/'DC' and cursor is on                CFT007
      * a 2nd line)...                                                          CFT007
                                                                                CFT007
     C                   IF          @OOutCode = 'AC' or                        CFT007
     C                             ((@OOutCode = 'BC' or                        CFT007
     C                               @OOutCode = 'DC') and                      CFT007
     C                              (Line2OCus = *On or                         CFT007
     C                               Line2Dest = *On or                         CFT007
     C                               Line2RCor = *On or                         CFT007
     C                               Line2ABnk = *On or                         CFT007
     C                               Line2Benf = *On or                         CFT007
     C***********                    Line2IBnk = *On ))                         CFT007 CFT014
     C                              Line2IBnk = *On or                          CFT014
     C                              (Line2TRIn = *On And @CFT014 = 'Y')))       CFT014
                                                                                CFT007
      * Remove clearing code                                                    CFT007
                                                                                CFT007
     C                   MOVE      @OAddress     WkAddress       140            CFT007
     C                   MOVEL     WkAddress     @OAddress                      CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
      * Move details to screen                                                  CFT007
                                                                                CFT007
     C                   SELECT                                                 CFT007
                                                                                CFT007
      * Destination line 1                                                      CFT007
     C                   WHEN      Line1Dest = *On                              CFT007
     C                   EVAL      SDST1 = OAddress1                            CFT007
     C                   EVAL      SDST2 = OAddress2                            CFT007
     C                   EVAL      SDST3 = OAddress3                            CFT007
     C                   EVAL      SDST4 = OAddress4                            CFT007
                                                                                CFT007
      * Destination line 2                                                      CFT007
     C                   WHEN      Line2Dest = *On                              CFT007
     C                   EVAL      SDST2 = OAddress1                            CFT007
     C                   EVAL      SDST3 = OAddress2                            CFT007
     C                   EVAL      SDST4 = OAddress3                            CFT007
                                                                                CFT007
      * Ordering customer line 1                                                CFT007
     C                   WHEN      Line1OCus = *On                              CFT007
     C                   EVAL      SORC1 = OAddress1                            CFT007
     C                   EVAL      SORC2 = OAddress2                            CFT007
     C                   EVAL      SORC3 = OAddress3                            CFT007
     C                   EVAL      SORC4 = OAddress4                            CFT007
     C                   EVAL      SORC5 = OAddress5                                          CFT032
                                                                                CFT007
      * Ordering customer line 2                                                CFT007
     C                   WHEN      Line2OCus = *On                              CFT007
     C                   EVAL      SORC2 = OAddress1                            CFT007
     C                   EVAL      SORC3 = OAddress2                            CFT007
     C                   EVAL      SORC4 = OAddress3                            CFT007
     C                   EVAL      SORC5 = OAddress4                                          CFT032
                                                                                CFT007
      * Receiver's correspondent line 1                                         CFT007
     C                   WHEN      Line1RCor = *On                              CFT007
     C                   EVAL      SRCO1 = OAddress1                            CFT007
     C                   EVAL      SRCO2 = OAddress2                            CFT007
     C                   EVAL      SRCO3 = OAddress3                            CFT007
     C                   EVAL      SRCO4 = OAddress4                            CFT007
     C                   EVAL      SRCO5 = OAddress5                            CFT007
                                                                                CFT007
      * Receiver's correspondent line 2                                         CFT007
     C                   WHEN      Line2RCor = *On                              CFT007
     C                   EVAL      SRCO2 = OAddress1                            CFT007
     C                   EVAL      SRCO3 = OAddress2                            CFT007
     C                   EVAL      SRCO4 = OAddress3                            CFT007
     C                   EVAL      SRCO5 = OAddress4                            CFT007
                                                                                CFT007
      * Account with bank line 1                                                CFT007
     C                   WHEN      Line1ABnk = *On                              CFT007
     C                   EVAL      SACB1 = OAddress1                            CFT007
     C                   EVAL      SACB2 = OAddress2                            CFT007
     C                   EVAL      SACB3 = OAddress3                            CFT007
     C                   EVAL      SACB4 = OAddress4                            CFT007
     C                   EVAL      SACB5 = OAddress5                            CFT007
                                                                                CFT007
      * Account with bank line 2                                                CFT007
     C                   WHEN      Line2ABnk = *On                              CFT007
     C                   EVAL      SACB2 = OAddress1                            CFT007
     C                   EVAL      SACB3 = OAddress2                            CFT007
     C                   EVAL      SACB4 = OAddress3                            CFT007
     C                   EVAL      SACB5 = OAddress4                            CFT007
                                                                                CFT007
      * Beneficiary line 1                                                      CFT007
     C                   WHEN      Line1Benf = *On                              CFT007
     C                   EVAL      SBNC1 = OAddress1                            CFT007
     C                   EVAL      SBNC2 = OAddress2                            CFT007
     C                   EVAL      SBNC3 = OAddress3                            CFT007
     C                   EVAL      SBNC4 = OAddress4                            CFT007
     C                   EVAL      SBNC5 = OAddress5                            CFT007
                                                                                CFT007
      * Beneficiary line 2                                                      CFT007
     C                   WHEN      Line2Benf = *On                              CFT007
     C                   EVAL      SBNC2 = OAddress1                            CFT007
     C                   EVAL      SBNC3 = OAddress2                            CFT007
     C                   EVAL      SBNC4 = OAddress3                            CFT007
     C                   EVAL      SBNC5 = OAddress4                            CFT007
                                                                                CFT007
      * Intermediary bank line 1                                                CFT007
     C                   WHEN      Line1IBnk = *On                              CFT007
     C                   EVAL      SINB1 = OAddress1                            CFT007
     C                   EVAL      SINB2 = OAddress2                            CFT007
     C                   EVAL      SINB3 = OAddress3                            CFT007
     C                   EVAL      SINB4 = OAddress4                            CFT007
     C                   EVAL      SINB5 = OAddress5                            CFT007
                                                                                CFT007
      * Intermediary bank line 2                                                CFT007
     C                   WHEN      Line2IBnk = *On                              CFT007
     C                   EVAL      SINB2 = OAddress1                            CFT007
     C                   EVAL      SINB3 = OAddress2                            CFT007
     C                   EVAL      SINB4 = OAddress3                            CFT007
     C                   EVAL      SINB5 = OAddress4                            CFT007
                                                                                CFT014
      ** Third Reimbursement Institution Line 1                                 CFT014
                                                                                CFT014
     C                   When      (Line1TRIn = *On) And (@CFT014 = 'Y')        CFT014
     C                   Eval      STRI1 = OAddress1                            CFT014
     C                   Eval      STRI2 = OAddress2                            CFT014
     C                   Eval      STRI3 = OAddress3                            CFT014
     C                   Eval      STRI4 = OAddress4                            CFT014
     C                   Eval      STRI5 = OAddress5                            CFT014
                                                                                CFT014
      ** Third Reimbursement Institution Line 2                                 CFT014
                                                                                CFT014
     C                   When      (Line2TRIn = *On) And (@CFT014 = 'Y')        CFT014
     C                   Eval      STRI2 = OAddress1                            CFT014
     C                   Eval      STRI3 = OAddress2                            CFT014
     C                   Eval      STRI4 = OAddress3                            CFT014
     C                   Eval      STRI5 = OAddress4                            CFT014
                                                                                CFT007
     C                   ENDSL                                                  CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   ENDIF                                                  CFT007
                                                                                CFT007
     C                   ENDSR                                                  CFT007
      *****************************************************************         CFT007
      /EJECT                                                                    CFT007
      *****************************************************************
      * INITIAL Go To Initial Screen
      *****************************************************************
     C     INITIAL       BEGSR
      *
      * Reset Read Next Browse Subfile Record (if active)
      *
     C                   MOVEL     *BLANK        @RDNB
      *
      * Blank the screens
      *
     C                   MOVEL     *BLANK        NewPmtScn1
     C                   MOVEL     *BLANK        NewPmtSc1b                     CFT014
     C                   MOVEL     *BLANK        NewPmtSc2a
     C                   MOVEL     *BLANK        NewPmtSc2b
     C                   MOVEL     *BLANK        NewPmtScn3
     C                   MOVEL     *BLANK        NewPmtSc3b                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn4                     CFT014
     C                   MOVEL     *BLANK        NewPmtScn5                     CFT014
     C                   If        CSW209 = 'Y'                                               CSW209
     C                   MOVEL     *BLANK        NewPmtScnA                                   CSW209
     C                   MOVEL     *BLANK        NewPmtScnC                                   CSW209
     C                   EndIf                                                                CSW209
     C                   MOVEL     *BLANKS       NewPmtScn5A                                  CER030
     C                   MOVEL     *BLANKS       NewPmtScn5B                                  CER030
     C                   MOVEL     *BLANK        DDSTAT
      *                                                                                       210657
     C                   Eval      @RCRM = *Zero                                              210657
     C                   Eval      @RCUS = *Blanks                                            210657
     C/COPY WNCPYSRC,FTOPA1SC31
      *
      * Primary Details Screen
      *
     C                   MOVEL     'P'           @SCRN             1
      *                                                                         CFT018
      ** Set screen indicator if CFT018 is on and SSI's to be displayed         CFT018
     C     SSIMode       IFEQ      'Y'                                          CFT018
     C                   MOVEL     'A'           @SCRN                          CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
      **  Reset flag to insert payment with no screen display                   CFT018
     C                   Move      'N'           @InsertPay        1            CFT018
      *                                                                         CFT018
      **  Reset valid payment flag                                              CFT018
     C                   MOVE      'N'           @ValidPay         1            CFT018
      *
      * Initialize field status on Primary Screen
      *
     C                   EXSR      IFDS@P
      *
      * Initialize F10 & F21 key fields
     C                   MOVE      'N'           @EINKJ
     C                   MOVE      'N'           @EINKV
      *
     C                   ENDSR
      *****************************************************************
      /EJECT
      *****************************************************************         CGL009
      * RTPDCA Retrieve the amount , currency and date in tag :32:              CGL009
      *****************************************************************         CGL009
     C     RTPDCA        BEGSR                                                  CGL009
      *                                                                         CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      ** DS for tags  (will NOT be blanked at the end of the S/R)               CGL009
      **                                  DSTRAN                                CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      ** Currency                                                               CGL009
     C     *LIKE         DEFINE    TVCCY         W32CY                          CGL009
      ** Amount                                                                 CGL009
     C     *LIKE         DEFINE    SSMAM         W32AM                          CGL009
      ** Date                                                                   CGL009
     C     *LIKE         DEFINE    SWDT          W32DT                          CGL009
      ** Day Number                                                             CGL009
     C     *LIKE         DEFINE    ZDAYNO        W32DYN                         CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        W32CY                          CGL009
     C                   MOVEL     *BLANK        W32AM                          CGL009
     C                   MOVEL     *BLANK        W32DT                          CGL009
     C                   Z-ADD     0             W32DYN                         CGL009
      *                                                                         CGL009
      * MMDDYY format display                                                   CGL009
      *                                                                         CGL009
     C     BJDFIN        IFEQ      'M'                                          CGL009
     C                   MOVEL     TVVDAT        SWDT                           CGL009
     C                   MOVE      SDD           DD                             CGL009
     C                   MOVE      SYY           SDD                            CGL009
     C                   MOVE      SMM           SYY                            CGL009
     C                   MOVE      SWDT          W32DT                          CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
      * DDMMYY format display                                                   CGL009
      *                                                                         CGL009
     C                   MOVEL     TVVDAT        SWDT                           CGL009
     C                   MOVE      SDD           DD                             CGL009
     C                   MOVE      SYY           SDD                            CGL009
     C                   MOVE      DD            SYY                            CGL009
     C                   MOVE      SWDT          W32DT                          CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   MOVE      W32DT         ZDATE                          CGL009
      * Convert it in Midas day number                                          CGL009
     C                   CALL      'ZDATE1'                             9090    CGL009
     C                   PARM      *BLANKS       ZERR              7            CGL009
     C                   PARM                    ZDATE             6 0          CGL009
     C                   PARM      BJDFIN        ZDATFM            1            CGL009
     C                   PARM      *ZEROS        ZDAYNO            5 0          CGL009
      *                                                                         CGL009
      *  If error on call                                                       CGL009
      *                                                                         CGL009
     C     *IN90         IFEQ      '1'                                          CGL009
     C                   MOVEL     'ZDATE1  '    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL'       DBKEY                          CGL009
     C                   Z-ADD     69            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      * Date invalid => default it (Will be rejected by validation pgm)         CGL009
      *                                                                         CGL009
     C     ZERR          IFEQ      '*ERROR*'                                    CGL009
     C                   Z-ADD     BJRDNB        W32DYN                         CGL009
     C                   ELSE                                                   CGL009
     C                   Z-ADD     ZDAYNO        W32DYN                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      * Currency                                                                CGL009
      *                                                                         CGL009
      ** Translate currency to Midas currency if it is a different                            225169
      ** SWIFT currency code.                                                                 225169
      *                                                                                       225169
     C                   MOVE      TVCCY         W_CCY                                        225169
     C                   EXSR      WTRNCY                                                     225169
     C                   MOVE      W_CCY         TVCCY                                        225169
      *                                                                                       225169
     C                   MOVEL     TVCCY         W32CY                          CGL009
      * Amount                                                                  CGL009
      *                                                                         CGL009
      * Format amount field (change ',' decimal point to '.').                  CGL009
      *                                                                         CGL009
     C                   MOVEA     TVAMT         YA1                            CGL009
     C                   Z-ADD     1             C                 3 0          CGL009
      *                                                                         CGL009
     C     C             DOUGT     15                                           CGL009
      *                                                                         CGL009
     C     YA1(C)        IFEQ      ','                                          CGL009
     C                   MOVE      '.'           YA1(C)                         CGL009
     C                   Z-ADD     16            C                              CGL009
     C                   ELSE                                                   CGL009
     C                   ADD       1             C                              CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   MOVEA     YA1           AMT              15            CGL009
     C                   MOVEL     AMT           W32AM                          CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************
      /EJECT
      *****************************************************************         CGL009
      *  CWAMCY Retrieve the amount and currency for a given                    CGL009
      *  code work /XXXX/ inside multiple code work lines                       CGL009
      *****************************************************************         CGL009
     C     CWAMCY        BEGSR                                                  CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      ** Code work lines                                                        CGL009
      **                                  WCWLIN                                CGL009
      ** Code work                                                              CGL009
      **                                  WCW                                   CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      ** Currency                                                               CGL009
     C     *LIKE         DEFINE    SNDCY         WCWCY                          CGL009
      ** Amount                                                                 CGL009
     C     *LIKE         DEFINE    SPDAM         WCWAM                          CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        WCWCY                          CGL009
     C                   MOVEL     *BLANK        WCWAM                          CGL009
      *                                                                         CGL009
     C     WCW           SCAN      WCWLIN:1      @F                3 0    81    CGL009
     C     *IN81         IFEQ      *ON                                          CGL009
      *                                                                         CGL009
     C                   ADD       6             @F                             CGL009
     C     3             SUBST     WCWLIN:@F     WCWCY                          CGL009
      * Map amount                                                              CGL009
      * Move possible 15 chars to work array and work string                    CGL009
     C                   ADD       3             @F                             CGL009
     C     15            SUBST     WCWLIN:@F     @S               15            CGL009
     C                   MOVEA     @S            @A                             CGL009
     C                   CLEAR                   @S                             CGL009
      *                                                                         CGL009
      * If ',' in amount string @S change to '.'                                CGL009
      * Only need to check valid chars till one ',' found                       CGL009
     C                   Z-ADD     1             @C                3 0          CGL009
     C                   MOVE      *BLANKS       @T                1            CGL009
      *                                                                         CGL009
     C     1             DO        15            @C                             CGL009
     C                   MOVE      @A(@C)        @T                             CGL009
     C     @T            IFEQ      ','                                          CGL009
     C                   MOVE      '.'           @A(@C)                         CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDDO                                                  CGL009
      *                                                                         CGL009
     C                   Z-ADD     1             @C                             CGL009
     C                   MOVE      *BLANKS       @T                1            CGL009
     C                   MOVEA     @A            @S                             CGL009
      * Get amount - upto 15 chars possible                                     CGL009
     C     @C            DOUGT     15                                           CGL009
     C                   MOVE      @A(@C)        @T                             CGL009
     C     @CHK          CHECK     @T            @F                       82    CGL009
      *                                                                         CGL009
      * Char not valid must be end of amount                                    CGL009
     C     *IN82         IFEQ      *ON                                          CGL009
     C     @C            IFNE      1                                            CGL009
     C     @C            SUB       1             @F                             CGL009
     C     @F            SUBST     @S:1          WCWAM                          CGL009
     C                   ENDIF                                                  CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
      * All chars in string ok                                                  CGL009
     C     @C            IFEQ      15                                           CGL009
     C                   MOVEL     @S            WCWAM                          CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   ADD       1             @C                             CGL009
      *                                                                         CGL009
     C                   ENDDO                                                  CGL009
      *                                                                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Reset input variables                                                  CGL009
     C                   MOVEL     *BLANKS       WCWLIN          256            CGL009
     C                   MOVEL     *BLANKS       WCW               6            CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************         CGL009
      /EJECT                                                                    CGL009
      *****************************************************************         CGL009
      * TSNULL Test if an amount is null                                        CGL009
      *****************************************************************         CGL009
     C     TSNULL        BEGSR                                                  CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      ** Amount                                                                 CGL009
      **                                  WNLAM                                 CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      ** Flag Null ? (Y/N)                                                      CGL009
      **                                  WNLNUL                                CGL009
      *                                                                         CGL009
     C                   MOVEL     'Y'           WNLNUL            1            CGL009
      *                                                                         CGL009
     C     WNLAM         IFNE      *BLANK                                       CGL009
     C                   MOVEA     WNLAM         @NL                            CGL009
     C                   DO        15            I                              CGL009
     C     @NUL          CHECK     @NL(I)                                 82    CGL009
     C     *IN82         IFEQ      *OFF                                         CGL009
     C                   MOVEL     'N'           WNLNUL                         CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDDO                                                  CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        WNLAM            15            CGL009
     C                   MOVEL     *BLANK        @NL               1            CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************         CGL009
      /EJECT                                                                    CGL009
      *****************************************************************         CGL009
      *  CWRATE Retrieve the rate and the multiply/divide                       CGL009
      *  indicator /XXXX/ inside multiple code work lines                       CGL009
      *****************************************************************         CGL009
     C     CWRATE        BEGSR                                                  CGL009
      *                                                                         CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      ** Code work lines                                                        CGL009
      **                                  WCWLIN                                CGL009
      ** Code work                                                              CGL009
      **                                  WCW                                   CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      ** Rate                                                                   CGL009
     ***                                  WCWRT                                 CGL009
      ** Decimal Position Truncated                                             CGL009
     C     *LIKE         DEFINE    A6NBDP        WCWDPT                         CGL009
      ** Decimal Position                                                       CGL009
     C     *LIKE         DEFINE    A6NBDP        WCWDP           + 1            CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        WCWRT            14            CGL009
     C                   Z-ADD     0             WCWDPT                         CGL009
     C                   Z-ADD     0             WCWDP                          CGL009
      *                                                                         CGL009
     C     WCW           SCAN      WCWLIN:1      @F                3 0    81    CGL009
     C     *IN81         IFEQ      *ON                                          CGL009
      *                                                                         CGL009
     C                   ADD       6             @F                             CGL009
      * Map Rate                                                                CGL009
      * Move possible 13 chars to work array and work string                    CGL009
     C     13            SUBST     WCWLIN:@F     @R               13            CGL009
     C                   MOVEA     @R            @R1                            CGL009
     C                   CLEAR                   @R                             CGL009
      *                                                                         CGL009
      * If ',' in rate string @R change to '.'                                  CGL009
      * Only need to check valid chars till one ',' found                       CGL009
     C                   Z-ADD     1             @C                3 0          CGL009
     C                   MOVE      *BLANKS       @T                1            CGL009
      *                                                                         CGL009
     C     1             DO        13            @C                             CGL009
     C     @R1(@C)       IFEQ      ','                                          CGL009
     C                   MOVE      '.'           @R1(@C)                        CGL009
      * Retrieve the number of decimal position                                 CGL009
     C     @CHK          CHECK     R1            @F                3 0          CGL009
     C     @F            IFNE      0                                            CGL009
     C     @F            SUB       1             @F                             CGL009
     C     @F            SUB       @C            WCWDP                          CGL009
     C                   ELSE                                                   CGL009
     C     13            SUB       @C            WCWDP                          CGL009
     C                   ENDIF                                                  CGL009
      ** Decimal position can be handled only on one 1 digit                    CGL009
      ** => range 0-9  (otherwise truncated to 9)                               CGL009
     C     WCWDP         IFGT      9                                            CGL009
     C                   Z-ADD     9             WCWDPT                         CGL009
     C                   ELSE                                                   CGL009
     C                   Z-ADD     WCWDP         WCWDPT                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDDO                                                  CGL009
      *                                                                         CGL009
     C                   Z-ADD     1             @C                             CGL009
     C                   MOVE      *BLANKS       @T                1            CGL009
     C                   MOVEA     @R1           @R                             CGL009
      * Get amount - upto 13 chars possible                                     CGL009
     C     @C            DOUGT     13                                           CGL009
     C                   MOVE      @R1(@C)       @T                             CGL009
     C     @CHK          CHECK     @T            @F                       82    CGL009
      *                                                                         CGL009
      * Char not valid must be end of rate                                      CGL009
     C     *IN82         IFEQ      *ON                                          CGL009
     C     @C            IFNE      1                                            CGL009
     C     @C            SUB       1             @F                             CGL009
     C     @F            SUBST     @R:1          WCWRT                          CGL009
     C                   ENDIF                                                  CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
      * All chars in string ok                                                  CGL009
     C     @C            IFEQ      13                                           CGL009
     C                   MOVEL     @R            WCWRT                          CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   ADD       1             @C                             CGL009
      *                                                                         CGL009
     C                   ENDDO                                                  CGL009
      *                                                                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Reset input variables                                                  CGL009
     C                   MOVEL     *BLANKS       WCWLIN                         CGL009
     C                   MOVEL     *BLANKS       WCW                            CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************         CGL009
      /EJECT                                                                    CGL009
      *****************************************************************         175479
      *  CWVAL Retrieve FONTIS alphanumeric field identified by                 175479
      *  presence of codework /XXXX/                                            175479
      *****************************************************************         175479
     C     CWVAL         BEGSR                                                  175479
      ** Inputs                                                                 175479
      ** ------                                                                 175479
      ** Code work lines                                                        175479
      **                                  WCWLIN                                175479
      ** Code work                                                              175479
      **                                  WCW                                   175479
      ** Code work length                                                       175479
      **                                  WCWLEN                                175479
      ** Outputs                                                                175479
      ** -------                                                                175479
      ** An alphanumeric field of max 256 length                                175479
     C     *LIKE         DEFINE    WCWLIN        WCWVAL                         175479
      *                                                                         175479
      ** Reset temporary variables                                              175479
     C                   MOVEL     *BLANK        @CW                            175479
     C                   MOVEL     *BLANK        @VL                            175479
     C                   MOVEL     *BLANK        WCWVAL                         175479
     C                   Z-ADD     0             LN                2 0          175479
     C                   Z-ADD     0             VL                3 0          175479
     C     *LIKE         DEFINE    VL            LNCW                           175479
     C     *LIKE         DEFINE    VL            WT                             175479
     C                   Z-ADD     0             WT                             175479
     C                   Z-ADD     0             LNCW                           175479
      *                                                                         175479
      ** Length of tag containing the code works                                175479
     C     ' '           CHECKR    WCWLIN        LNCW                           175479
      *                                                                         175479
      ** Length of search argument                                              175479
     C     ' '           CHECKR    WCW           LN                             175479
      *                                                                         175479
     C     WCW:LN        SCAN      WCWLIN:1      VL                       81    175479
     C     *IN81         IFEQ      *ON                                          175479
     C                   MOVEA     WCWLIN        @CW                            175479
     C     VL            ADD       LN            VL                             175479
      *                                                                         175479
      ** We start to extract the value right after the code work                175479
      ** (so we need to know the length of the code work)                       175479
      ** We stop extracting when                                                175479
      ** - another / (and therefore another code work) has been found           175479
      ** - we reached the length to extract                                     175479
      ** - we reached the length of the tag                                     175479
     C     WT            DOWLT     WCWLEN                                       175479
     C     VL            ANDLE     LNCW                                         175479
     C     @CW(VL)       ANDNE     '/'                                          175479
     C                   ADD       1             WT                             175479
     C                   MOVEL     @CW(VL)       @VL(WT)                        175479
     C                   ADD       1             VL                             175479
     C                   ENDDO                                                  175479
     C                   MOVEA     @VL           WCWVAL                         175479
     C                   ENDIF                                                  175479
      *                                                                         175479
      ** Reset input variables                                                  175479
     C                   MOVEL     *BLANKS       WCWLIN          256            175479
     C                   MOVEL     *BLANKS       WCW               6            175479
     C                   Z-ADD     0             WCWLEN            3 0          175479
      *                                                                         175479
     C                   ENDSR                                                  175479
      *****************************************************************         175479
      /EJECT                                                                    175479
      **********************************************************************    175477
      *  FONBNK Format FONTIS branch bank information                           175477
      **********************************************************************    175477
     C     FONBNK        BEGSR                                                  175477
      *                                                                         175477
      ** Inputs                                                                 175477
      ** ------                                                                 175477
      ****                                DSTRAN                                175477
      ** Outputs                                                                175477
      ** -------                                                                175477
      ****                                DSTRAN                                175477
      *                                                                         175477
     C                   MOVEL     *BLANK        @I35                           175477
      *                                                                         175477
      * If first line is blank we shift the rest of the lines to the            175477
      * top                                                                     175477
     C     TMLIN1        IFEQ      *BLANK                                       175477
     C                   MOVEL     TMLIN2        TMLIN1                         175477
     C                   MOVEL     TMLIN3        TMLIN2                         175477
     C                   MOVEL     TMLIN4        TMLIN3                         175477
     C                   MOVEL     TMLIN5        TMLIN4                         175477
     C                   MOVEL     TMLIN6        TMLIN5                         175477
     C                   ENDIF                                                  175477
      *                                                                         175477
      ** Check if the first line can be a swift adress                          175477
      ** If not we leave the procedure                                          175477
     C     ' '           CHECKR    TMLIN1        WTMLEN            2 0          175477
     C     WTMLEN        IFGT      11                                           175477
     C                   GOTO      EXFNBK                                       175477
     C                   ENDIF                                                  175477
      *                                                                         175477
     C                   MOVEA     TMLIN1        @I35                           175477
     C     8             SUBST     I35:1         W9BICC                         175477
     C     3             SUBST     I35:9         W9BICB                         175477
      *                                                                         175477
     C     W9BICB        IFEQ      'XXX'                                        175477
     C                   MOVEL     *BLANK        W9BICB                         175477
     C                   ENDIF                                                  175477
      *                                                                         175477
     C                   CALL      'ME1400'                                     175477
     C                   PARM      *BLANKS       W9RTN             7            175477
     C                   PARM                    W9BICC            8            175477
     C                   PARM                    W9BICB            3            175477
     C                   PARM                    SDCUST                         175477
     C                   PARM                    SDCNST                         175477
     C                   PARM                    MEBICD                         175477
     C                   PARM      *BLANKS       W9CUST            1            175477
     C                   PARM      *BLANKS       W9CNST            1            175477
     C                   PARM      *BLANKS       W9BICD            1            175477
      *                                                                         175477
      ** If SWIFT ID found, drop the name and address                           175477
      *                                                                         175477
     C     W9RTN         IFEQ      *BLANKS                                      175477
     C                   MOVEL     *BLANK        TMLIN1                         175477
     C                   MOVEL     W9BICC        TMLIN1                         175477
     C                   MOVEL     *BLANK        TMLIN2                         175477
     C                   MOVEL     *BLANK        TMLIN3                         175477
     C                   MOVEL     *BLANK        TMLIN4                         175477
     C                   MOVEL     *BLANK        TMLIN5                         175477
     C                   MOVEL     *BLANK        TMLIN6                         175477
     C                   ENDIF                                                  175477
      *                                                                         175477
     C     EXFNBK        ENDSR                                                  175477
      *****************************************************************         175477
      /EJECT                                                                    175477
      *********************************************************************     CGL009
      *  RTPRFC Profit center retrieval                                         CGL009
      *********************************************************************     CGL009
     C     RTPRFC        BEGSR                                                  CGL009
      *                                                                         CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
     C     *LIKE         DEFINE    U#TRTP        WPYTP                          CGL009
     C     *LIKE         DEFINE    U#SUTP        WPYST                          CGL009
     C     *LIKE         DEFINE    U#BOKC        WBOKC                          CGL009
     C     *LIKE         DEFINE    U#BRAN        WBRCA                          CGL009
     C     *LIKE         DEFINE    U#DEPT        WDEPT                          CGL009
     C     *LIKE         DEFINE    U#USER        WUSER                          CGL009
     C     *LIKE         DEFINE    U#ACOF        WACOF                          CGL009
     C     *LIKE         DEFINE    U#CUST        WCUST                          CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
     C     *LIKE         DEFINE    U#PRFC        WPRFC                          CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        WPRFC                          CGL009
      *                                                                         CGL009
      *  If the profit centre field is blank set to a default only if           CGL009
      *  the Profit Centre Defaults Used flag is set to 'Y'.                    CGL009
      *                                                                         CGL009
     C     BKPCDU        IFEQ      'Y'                                          CGL009
      *                                                                         CGL009
      *  Determine parameters to be passed                                      CGL009
      *                                                                         CGL009
      *  For Outgoing Payments the Customer and Account Officer will            CGL009
      *  be blank.                                                              CGL009
      *                                                                         CGL009
      *  Get default profit centre                                              CGL009
      *                                                                         CGL009
     C                   CALL      'AOPRFMR0'                           90      CGL009
     C                   PARM      *BLANKS       U#RTCD            7            CGL009
     C                   PARM      WBOKC         U#BOKC            2            CGL009
     C                   PARM      WPYTP         U#TRTP            5            CGL009
     C                   PARM      WPYST         U#SUTP            2            CGL009
     C                   PARM      WBRCA         U#BRAN            3            CGL009
     C                   PARM      WDEPT         U#DEPT            3            CGL009
     C                   PARM      WUSER         U#USER           10            CGL009
     C                   PARM      WACOF         U#ACOF            2            CGL009
     C                   PARM      WCUST         U#CUST            6            CGL009
     C     WPRFC         PARM      *BLANKS       U#PRFC            4            CGL009
      *                                                                         CGL009
      *  If error on CALL - process as database error                           CGL009
      *                                                                         CGL009
     C     *IN90         IFEQ      '1'                                          CGL009
     C                   MOVEL     'AOPRFMR0'    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL  '     DBKEY                          CGL009
     C                   Z-ADD     70            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      * If return code is not blank - exit                                      CGL009
      * If no error then the screen field is filled by passed parameter         CGL009
      *                                                                         CGL009
     C     U#RTCD        IFEQ      '2'                                          CGL009
     C                   MOVEL     *BLANK        WPRFC                          CGL009
     C                   GOTO      EXRTPC                                       CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      *  Validate Profit Centre                                                 CGL009
      *                                                                         CGL009
     C                   CALL      'AOPRFCR0'                           90      CGL009
     C                   PARM      *BLANKS       U#RTCD            7            CGL009
     C                   PARM      '*KEY'        U#OPTN            7            CGL009
     C                   PARM      WPRFC         U#PRFC            4            CGL009
     C     SDPRFC        PARM      *BLANKS       DSFDY                          CGL009
      *                                                                         CGL009
      *  If error on CALL - process as database error                           CGL009
      *                                                                         CGL009
     C     *IN90         IFEQ      '1'                                          CGL009
     C                   MOVEL     'AOPRFCR0'    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL  '     DBKEY                          CGL009
     C                   Z-ADD     71            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      * If return code is not blank - exit                                      CGL009
      *                                                                         CGL009
     C     U#RTCD        IFNE      *BLANKS                                      CGL009
     C                   MOVEL     *BLANK        WPRFC                          CGL009
     C                   GOTO      EXRTPC                                       CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   MOVEL     DSPCCD        WPRFC                          CGL009
      *                                                                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C     EXRTPC        TAG                                                    CGL009
      *                                                                         CGL009
      ** Reset input variables                                                  CGL009
     C                   MOVEL     *BLANK        WPYTP                          CGL009
     C                   MOVEL     *BLANK        WPYST                          CGL009
     C                   MOVEL     *BLANK        WBOKC                          CGL009
     C                   MOVEL     *BLANK        WBRCA                          CGL009
     C                   MOVEL     *BLANK        WDEPT                          CGL009
     C                   MOVEL     *BLANK        WUSER                          CGL009
     C                   MOVEL     *BLANK        WACOF                          CGL009
     C                   MOVEL     *BLANK        WCUST                          CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************         CGL009
      /EJECT                                                                    CGL009
      *****************************************************************         CGL009
      *  RTCCYD Retrieve currency details                                       CGL009
      *****************************************************************         CGL009
     C     RTCCYD        BEGSR                                                  CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      ** Currency                                                               CGL009
     C     *LIKE         DEFINE    A6CYCD        WCYCCY                         CGL009
      ** Dump flag (Y/N)                                                        CGL009
     C     *LIKE         DEFINE    WACDMP        WCYDMP                         CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      ** Decimal positions                                                      CGL009
     C     *LIKE         DEFINE    A6NBDP        WCYNDP                         CGL009
      ** Return code                                                            CGL009
     C     *LIKE         DEFINE    P@RTCD        WCYRTN                         CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        WCYNDP                         CGL009
     C                   MOVEL     *BLANK        WCYRTN                         CGL009
      *                                                                         CGL009
     C                   CALL      'AOCURRR0'                           9090    CGL009
     C                   PARM      *BLANKS       RTCD              7            CGL009
     C                   PARM      '*KEY   '     @OPTN                          CGL009
     C                   PARM      WCYCCY        @K101             3            CGL009
     C     SDCURR        PARM      *BLANKS       DSSDY                          CGL009
      *                                                                         CGL009
      *  If error on call                                                       CGL009
      *                                                                         CGL009
     C     *IN90         IFEQ      '1'                                          CGL009
     C     RTCD          ORNE      *BLANKS                                      CGL009
     C                   MOVEL     '*ERROR'      WCYRTN                         CGL009
      *                                                                         CGL009
     C     WCYDMP        IFNE      'Y'                                          CGL009
     C                   GOTO      EXRCYD                                       CGL009
     C                   ELSE                                                   CGL009
      *                                                                         CGL009
     C     *IN90         IFEQ      '1'                                          CGL009
     C                   MOVEL     'AOCURRR0'    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL'       DBKEY                          CGL009
     C                   Z-ADD     72            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C     RTCD          IFNE      *BLANKS                                      CGL009
     C                   MOVEL     'AOCURRR0'    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     WCYCCY        DBKEY                          CGL009
     C                   Z-ADD     73            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
     C                   END                                                    CGL009
      *                                                                         CGL009
      *  Move new standing data field into field used in program                CGL009
      *                                                                         CGL009
      *                                                                         CGL009
      * Store Decimal Places Spot Rate                                          CGL009
      *                                                                         CGL009
     C                   Z-ADD     A6NBDP        WCYNDP                         CGL009
      *                                                                         CGL009
     C     EXRCYD        TAG                                                    CGL009
      *                                                                         CGL009
      ** Reset input variables                                                  CGL009
     C                   MOVEL     *BLANK        WCYCCY                         CGL009
     C                   MOVEL     *BLANK        WCYDMP                         CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      **********************************************************************    CGL009
      /EJECT                                                                    CGL009
      **********************************************************************    CGL009
      *  Remove character '/' (for 35 chars)                                    CGL009
      **********************************************************************    CGL009
     C     SLSH35        BEGSR                                                  CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
      **                                  @I35                                  CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
      **                                  @O35                                  CGL009
      *                                                                         CGL009
      ** The field must begin with a '/'                                        CGL009
     C     @I35(1)       IFNE      '/'                                          CGL009
     C                   MOVEA     @I35          @O35                           CGL009
     C                   GOTO      EXSH35                                       CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
     C                   MOVEL     *BLANK        @O35                           CGL009
     C                   Z-ADD     1             I                 2 0          CGL009
     C     *LIKE         DEFINE    I             J                              CGL009
      *                                                                         CGL009
     C                   DO        34                                           CGL009
     C     I             ADD       1             J                              CGL009
     C                   MOVEA     @I35(J)       @O35(I)                        CGL009
     C                   ADD       1             I                              CGL009
      ** 10 chars : retail account                                              CGL009
      ** 18 chars : GL account                                                  CGL009
     C     @I35(I)       IFEQ      *BLANK                                       CGL009
     C                   LEAVE                                                  CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDDO                                                  CGL009
      *                                                                         CGL009
     C     EXSH35        TAG                                                    CGL009
     C                   MOVEL     *BLANK        @I35                           CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      **********************************************************************    CGL009
      /EJECT                                                                    CGL009
      **********************************************************************    CGL009
      *  Retrieve the data of an account                                        CGL009
      **********************************************************************    CGL009
     C     RTACNT        BEGSR                                                  CGL009
      *                                                                         CGL009
      ** Inputs                                                                 CGL009
      ** ------                                                                 CGL009
     C     *LIKE         DEFINE    TRCODE        WAC                            CGL009
      ****                                WACDMP                                CGL009
      ** Outputs                                                                CGL009
      ** -------                                                                CGL009
     C     *LIKE         DEFINE    IFCCY         WACCY                          CGL009
     C     *LIKE         DEFINE    IFBRCA        WACBCH                         CGL009
      **                                  WACLN                                 CGL009
     C     *LIKE         DEFINE    P@RTCD        WACRTN                         CGL009
      *                                                                         CGL009
      ** If the account starts with a '/' strip it.                                           CFT032
                                                                                              CFT032
     C                   IF        %SUBST(WAC:1:1) = '/'                                      CFT032
     C                   EVAL      WAC = %SUBST(WAC:2)                                        CFT032
     C                   ENDIF                                                                CFT032
                                                                                              CFT032
      ** Check if feature CFT014 is installed                                                 CFT032
      ** If so, access AOIBANR2 and retrieve values for currency and branch;                  CFT032
      ** If not found in AOIBANR2, process as usual.                                          CFT032
                                                                                              CFT032
     C                   CALL      'AOSARSR0'                                                 CFT032
     C                   PARM      *Blanks       @RTCD                                        CFT032
     C                   PARM      '*VERIFY'     @OPTN                                        CFT032
     C                   PARM      'CFT014'      P@SAR                                        CFT032
     C                   PARM                    DSSDY                                        CFT032
                                                                                              CFT032
     C                   IF        @RTCD = *Blanks                                            CFT032
     C                   CLEAR                   ACCINF                                       CFT032
     C                   CALL      'AOIBANR2'                                                 CFT032
     C                   PARM      *Blanks       @RTCD                                        CFT032
     C                   PARM      WAC           P@IBAN                                       CFT032
     C     ACCINF        PARM      ACCINF        DSSDY                                        CFT032
     C                   IF        @RTCD  = *Blanks                                           CFT032
     C                   EVAL      WACCY = IFCCY                                              CFT032
     C                   EVAL      WACBCH = IFBRCA                                            CFT032
     C                   LEAVESR                                                              CFT032
     C                   ENDIF                                                                CFT032
     C                   ENDIF                                                                CFT032
                                                                                              CFT032
     C                   MOVEL     *BLANK        WACCY                          CGL009
     C                   MOVEL     *BLANK        WACBCH                         CGL009
     C                   Z-ADD     0             WACLN             2 0          CGL009
     C                   MOVEL     *BLANK        WACRTN                         CGL009
      ** Compute length                                                         CGL009
     C     ' '           CHECKR    WAC           WACLN                          CGL009
      ** It is a retail number                                                  CGL009
     C     WACLN         IFEQ      10                                           CGL009
     C                   MOVEL     WAC           P@RETL                         CGL009
     C                   MOVEL     *BLANK        P@CNUM                         CGL009
     C                   MOVEL     *BLANK        P@CUCD                         CGL009
     C                   MOVEL     *BLANK        P@ACCD                         CGL009
     C                   MOVEL     *BLANK        P@ACSQ                         CGL009
     C                   MOVEL     *BLANK        P@BRCA                         CGL009
     C                   ELSE                                                   CGL009
      ** It is a G/L account number                                             CGL009
     C                   MOVEL     *BLANK        P@RETL                         CGL009
     C     3             SUBST     WAC:1         P@BRCA                         CGL009
     C     6             SUBST     WAC:4         P@CNUM                         CGL009
     C     3             SUBST     WAC:10        P@CUCD                         CGL009
     C*****4****         SUBST     WAC:13        P@ACCD                                CGL009 CGL029
     C*****2****         SUBST     WAC:17        P@ACSQ                                CGL009 CGL029
     C     10            SUBST     WAC:13        P@ACCD                                       CGL029
     C     2             SUBST     WAC:23        P@ACSQ                                       CGL029
     C                   ENDIF                                                  CGL009
     C                   CALL      'AOACCTR0'                           90      CGL009
     C                   PARM                    P@RTCD            7            CGL009
     C                   PARM      '*KEY   '     P@OPTN            7            CGL009
     C                   PARM                    P@RETL           10            CGL009
     C                   PARM                    P@CNUM            6            CGL009
     C                   PARM                    P@CUCD            3            CGL009
     C**********         PARM                    P@ACCD            4                   CGL009 CGL029
     C                   PARM                    P@ACCD                                       CGL029
     C                   PARM                    P@ACSQ            2            CGL009
     C                   PARM                    P@BRCA            3            CGL009
     C                   PARM                    ACCINF                         CGL009
      *                                                                         CGL009
     C     P@RTCD        IFNE      *BLANK                                       CGL009
     C     *IN90         OREQ      '1'                                          CGL009
     C                   MOVEL     '*ERROR'      WACRTN                         CGL009
     C     WACDMP        IFEQ      'Y'                                          CGL009
     C                   MOVEL     'AOACCTR0'    DBFILE                         CGL009
      ** It is a retail number                             ***************      CGL009
     C     WACLN         IFEQ      10                                           CGL009
     C                   MOVEL(P)  P@RETL        DBKEY                          CGL009
      ** It is a G/L account number                                             CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C     DBKEY         CAT       P@BRCA:0      DBKEY                          CGL009
     C     DBKEY         CAT       P@CNUM:0      DBKEY                          CGL009
     C     DBKEY         CAT       P@CUCD:0      DBKEY                          CGL009
     C     DBKEY         CAT       P@ACCD:0      DBKEY                          CGL009
     C     DBKEY         CAT       P@ACSQ:0      DBKEY                          CGL009
     C                   ENDIF                                                  CGL009
     C                   Z-ADD     74            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   ENDIF                                                  CGL009
     C                   ELSE                                                   CGL009
     C                   MOVEL     IFCCY         WACCY                          CGL009
     C                   MOVEL     IFBRCA        WACBCH                         CGL009
     C                   ENDIF                                                  CGL009
      *                                                                         CGL009
      ** Reset input variables                                                  CGL009
     C     EXRTAC        TAG                                                    CGL009
     C                   MOVEL     *BLANK        WAC                            CGL009
     C                   MOVEL     *BLANK        WACDMP            1            CGL009
      *                                                                         CGL009
     C                   ENDSR                                                  CGL009
      **********************************************************************    CGL009
      /EJECT                                                                    CGL009
      **********************************************************************    CGL009
      *  Scan for /OCMT/, /ORIG/, /RATE/                                        CGL009
      **********************************************************************    CGL009
     C     ICCHK         BEGSR                                                  CGL009
     C*                                                                         CGL009
     C                   MOVEL     *BLANKS       FOUND             1            CGL009
     C*                                                                         CGL009
     C     '/RATE/'      SCAN      P72:1         @X                3 0    81    CGL009
     C     *IN81         IFEQ      *OFF                                         CGL009
     C     '/ORIG/'      SCAN      P72:1         @X                       81    CGL009
     C     *IN81         IFEQ      *OFF                                         CGL009
     C     '/OCMT/'      SCAN      P72:1         @X                       81    CGL009
     C                   ENDIF                                                  CGL009
     C                   ENDIF                                                  CGL009
     C*                                                                         CGL009
     C     *IN81         IFEQ      *ON                                          CGL009
     C                   MOVE      'Y'           FOUND                          CGL009
     C                   ENDIF                                                  CGL009
     C*                                                                         CGL009
     C                   ENDSR                                                  CGL009
      *****************************************************************
      /EJECT
      *****************************************************************         CFT012
      *  Default the Settlement Currency                                        CFT012
      *****************************************************************         CFT012
      *                                                                         CFT012
     C     SRDSCY        BEGSR                                                  CFT012
      *                                                                         CFT012
     C     SSMCY         IFEQ      *BLANK                                       CFT012
     C                   MOVEL     SORC1         WAC                            CFT012
     C                   MOVEL     'N'           WACDMP                         CFT012
     C                   EXSR      RTACNT                                       CFT012
     C     WACRTN        IFEQ      *BLANK                                       CFT012
     C                   MOVEL     IFCCY         SSMCY                          CFT012
     C                   ENDIF                                                  CFT012
     C                   ENDIF                                                  CFT012
      *                                                                         CFT012
     C     SSMCY         IFEQ      *BLANK                                       CFT012
     C                   MOVEL     OPORB1        WAC                            CFT012
     C                   MOVEL     'N'           WACDMP                         CFT012
     C                   EXSR      RTACNT                                       CFT012
     C     WACRTN        IFEQ      *BLANK                                       CFT012
     C                   MOVEL     IFCCY         SSMCY                          CFT012
     C                   ENDIF                                                  CFT012
     C                   ENDIF                                                  CFT012
      *                                                                         CFT012
     C     SSMCY         IFEQ      *BLANK                                       CFT012
     C                   MOVEL     SPCCY         SSMCY                          CFT012
     C                   ENDIF                                                  CFT012
      *                                                                         CFT012
     C                   ENDSR                                                  CFT012
      *****************************************************************         CFT012
      /EJECT
      *****************************************************************
      * *INZSR - INITIAL PROCESSING
      *****************************************************************
     C     *INZSR        BEGSR
      *
     C     *ENTRY        PLIST
     C                   PARM                    @SORT             1
     C                   PARM                    XPREF            15
     C                   PARM                    @ReturnCde        1
      *
     C     AKEY          KLIST
     C                   KFLD                    CNUM
     C                   KFLD                    CCY
     C                   KFLD                    ACOD
     C                   KFLD                    ACSQ
     C                   KFLD                    ABRCA
     C/COPY WNCPYSRC,FTH00662
     C*
      ** Initialize program name
      *
     C                   MOVEL     'FTOPAY1SN'   DBPGM

      ** If parameters are not blank then the program has been called
      ** from one of the linked enquiries:
      ** FT0150, FT0160, GL4442, or ME1200
      *
     C     @SORT         IFNE      *BLANKS
     C     @SORT         ANDNE     'S'                                          CFT018
     C     XPREF         ORNE      *BLANKS
     C                   MOVE      'Y'           LinkedEnq         1
     C                   END

      * Clear fields used invalidation
     C                   Clear                   Val@Fields
      **********                                                                             BUG7029
      **GET*ZMUSER*to*access*default*branch.                                                 BUG7029
     C******DTAARA       Define                  ZMUSER                                      BUG7029
     C**********         In        ZMUSER                                                    BUG7029
     C**********         Unlock    ZMUSER                                                    BUG7029

     C                   Eval      @DFBR = WDFBR
     C                   Eval      @DPPT = WDPPT

      * Get RUNDAT to access Multi Branch Indicator
     C     *DTAARA       Define                  RUNDAT
     C                   In        RUNDAT
     C                   Unlock    RUNDAT

     C                   Eval      @MBIN = WMBIN

      *  Move program name into *LDA field.
     C     *LOCK         In        LDA
     C                   Movel     'FTPYOTVAL'   DBPGM
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
                                                                                CGL009
      ** EXTRACT GENERAL LEDGER DETAILS                                         CGL009
      *                                                                         CGL009
     C**********         CALL      'AOGELRR0'                                          CGL009 CGL029
     C                   CALL      'AOGELRR1'                                                 CGL029
     C                   PARM      *BLANKS       @RTCD             7            CGL009
     C                   PARM      '*FIRST '     @OPTN             7            CGL009
     C*****SDGELR        PARM      SDGELR        DSFDY                                 CGL009 CGL029
     C     SDGELR        PARM      SDGELR        DSSDY                                        CGL029
      *                                                                         CGL009
      * DATABASE ERROR                                                          CGL009
      *                                                                         CGL009
     C     @RTCD         IFNE      *BLANKS                                      CGL009
     C                   MOVEL     'SDGELRPD'    DBFILE                         CGL009
     C                   Z-ADD     76            DBASE                          CGL009
     C                   MOVEL     @OPTN         DBKEY                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *
      * Access Funds Transfer details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOFTFRR0'
     C                   Parm      '*DBERR'      @RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDFTFR        Parm      SDFTFR        DSFDY

     C                   Eval      @RATDIS = WRATDIS

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
      *
     C/COPY WNCPYSRC,FTOPA1SC34
      * Access SAR details file to determine if CEU006 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CEU006'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 002 *
     C                   Movel     '002'         DBASE
     C                   Movel     'CEU006'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CEU006           1
     C                   Else
     C                   Movel     'N'           @CEU006
     C                   End

      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01494'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 062 *
     C                   Movel     '062'         DBASE
     C                   Movel     'S01494'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01494
     C                   Else
     C                   Movel     'N'           @01494
     C                   End

      * Access SAR details file to determine if S01494 is on.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01499'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C     *LOCK         In        LDA
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 063 *
     C                   Movel     '063'         DBASE
     C                   Movel     'S01499'      DBKEY
     C                   Out       LDA
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01499
     C                   Else
     C                   Movel     'N'           @01499
     C                   End

      * Access SAR details file to see if CFT002 is installed.
      *
     C                   CALL      'AOSARDR0'
     C                   PARM      *BLANKS       @RTCD
     C                   PARM      '*VERIFY'     @OPTN
     C                   PARM      'CFT002'      @SARD
     C     SCSARD        PARM      *BLANKS       DSFDY
      *
     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 064 *
     C                   Movel     '064'         DBASE
     C                   Movel     'CFT002'      DBKEY
     C                   Exsr      *PSSR
     C                   End

      * Allow decode processing
      *
     C     @RTCD         IFEQ      *BLANKS
     C                   MOVEL     'Y'           @CFT002           1
     C                   Else
     C                   Movel     'N'           @CFT002
     C                   ENDIF
      *
      * Access SAR details file to see if CFT003 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'CFT003'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 065 *
     C                   Movel     '065'         DBASE
     C                   Movel     'CFT003'      DBKEY
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @CFT003
     C                   Else
     C                   Movel     'N'           @CFT003
     C                   End

      * Access SAR details file to see if S01508 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01508'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 066 *
     C                   Movel     '066'         DBASE
     C                   Movel     'S01508'      DBKEY
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01508
     C                   Else
     C                   Movel     'N'           @01508
     C                   End

      * Access SAR details file to see if S01506 is installed.
      *
     C                   CALLB     'AOSARDR0'
     C                   Parm      *BLANKS       @RTCD
     C                   Parm      '*VERIFY'     @OPTN
     C                   Parm      'S01506'      @SARD
     C     SCSARD        Parm      SCSARD        DSFDY

     C                   If        @RTCD <> *Blanks and
     C                             @RTCD <> '*NRF   '
     C                   Movel     'SCSARDPD'    DBFILE                         * DBERROR 067 *
     C                   Movel     '067'         DBASE
     C                   Movel     'S01506'      DBKEY
     C                   Exsr      *PSSR
     C                   End

     C                   If        @RTCD = *Blanks
     C                   Movel     'Y'           @01506
     C                   Else
     C                   Movel     'N'           @01506
     C                   End
                                                                                CFT004
      * Access SAR details file to see if CFT004 is installed.                  CFT004
      *                                                                         CFT004
     C                   CALLB     'AOSARDR0'                                   CFT004
     C                   Parm      *BLANKS       @RTCD                          CFT004
     C                   Parm      '*VERIFY'     @OPTN                          CFT004
     C                   Parm      'CFT004'      @SARD                          CFT004
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT004
                                                                                CFT004
     C                   If        @RTCD = *Blanks                              CFT004
     C                   Movel     'Y'           @CFT004                        CFT004
     C                   Else                                                   CFT004
     C                   Movel     'N'           @CFT004                        CFT004
     C                   End                                                    CFT004

      * Retrieve Base Currency Details
     C                   Move      BJCYCD        @K101
     C                   CALLB     'AOCURRR0'
     C                   Parm      '*DBERR '     @RTCD
     C                   Parm      '*KEY   '     @OPTN
     C                   Parm                    @K101             3
     C     SDCURR        Parm      SDCURR        DSSDY

     C                   Eval      @BCDP = A6NBDP
                                                                                CFT007
      * Access SAR details file to see if CFT007 is installed.                  CFT007
      *                                                                         CFT007
     C                   CALLB     'AOSARDR0'                                   CFT007
     C                   Parm      *BLANKS       @RTCD                          CFT007
     C                   Parm      '*VERIFY'     @OPTN                          CFT007
     C                   Parm      'CFT007'      @SARD                          CFT007
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT007
                                                                                CFT007
     C                   If        @RTCD = *Blanks                              CFT007
     C                   Movel     'Y'           @CFT007           1            CFT007
     C                   Else                                                   CFT007
     C                   Movel     'N'           @CFT007                        CFT007
     C                   End                                                    CFT007
      *                                                                                       CFT050
      ** Access SAR file to determine if CFT050 (SWIFTRef Directories                         CFT050
      ** upload) is installed.                                                                CFT050
      *                                                                                       CFT050
     C                   CALLB     'AOSARDR0'                                                 CFT050
     C                   PARM      *BLANKS       PRTCD                                        CFT050
     C                   PARM      '*VERIFY'     POPTN                                        CFT050
     C                   PARM      'CFT050'      PSARD                                        CFT050
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT050
      *                                                                                       CFT050
      ** CFT007 process will take place when CFT050 is switched on                            CFT050
      *                                                                                       CFT050
     C                   IF        PRTCD = *BLANKS                                            CFT050
     C                   EVAL      @CFT007 = 'Y'                                              CFT050
     C                   ENDIF                                                                CFT050
                                                                                CFT012
      * Access SAR details file to see if CFT012 is installed.                  CFT012
      *                                                                         CFT012
     C                   CALLB     'AOSARDR0'                                   CFT012
     C                   Parm      *BLANKS       @RTCD                          CFT012
     C                   Parm      '*VERIFY'     @OPTN                          CFT012
     C                   Parm      'CFT012'      @SARD                          CFT012
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT012
                                                                                CFT012
     C                   If        @RTCD = *Blanks                              CFT012
     C                   Movel     'Y'           @CFT012           1            CFT012
     C                   Else                                                   CFT012
     C                   Movel     'N'           @CFT012                        CFT012
     C                   End                                                    CFT012
                                                                                CFT014
      ** Access SAR details file to see if CFT014 is installed.                 CFT014
                                                                                CFT014
     C                   Callb     'AOSARDR0'                                   CFT014
     C                   Parm      *BLANKS       @RTCD                          CFT014
     C                   Parm      '*VERIFY'     @OPTN                          CFT014
     C                   Parm      'CFT014'      @SARD                          CFT014
     C     SCSARD        Parm      SCSARD        DSFDY                          CFT014
                                                                                CFT014
     C                   If        @RTCD <> *Blanks and                         CFT014
     C                             @RTCD <> '*NRF   '                           CFT014
     C                   Movel     'SCSARDPD'    DBFILE                         CFT014
     C                   Movel     '080'         DBASE                          CFT014
     C                   Movel     'CFT014'      DBKEY                          CFT014
     C                   Exsr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   If        @RTCD = *Blanks                              CFT014
     C                   Movel     'Y'           @CFT014                        CFT014
     C                   Else                                                   CFT014
     C                   Movel     'N'           @CFT014                        CFT014
     C                   EndIf                                                  CFT014
                                                                                              CFT151
      * Access SAR details file to see if CFT151 is installed.                                CFT151
      *                                                                                       CFT151
     C                   CALLB     'AOSARDR0'                                                 CFT151
     C                   Parm      *BLANKS       @RTCD                                        CFT151
     C                   Parm      '*VERIFY'     @OPTN                                        CFT151
     C                   Parm      'CFT151'      @SARD                                        CFT151
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT151
                                                                                              CFT151
     C                   If        @RTCD = *Blanks                                            CFT151
     C                   Movel     'Y'           CFT151            1                          CFT151
     C                   Else                                                                 CFT151
     C                   Movel     'N'           CFT151                                       CFT151
     C                   End                                                                  CFT151
                                                                                              CSC011
      ** Access SAR details file to see if 24X7 (CSC011) is installed.                        CSC011
                                                                                              CSC011
     C                   CALLB     'AOSARDR0'                                                 CSC011
     C                   PARM      *BLANKS       PRTCD                                        CSC011
     C                   PARM      '*VERIFY'     POPTN                                        CSC011
     C                   PARM      'CSC011'      PSARD                                        CSC011
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSC011
                                                                                              CSC011
     C                   IF        PRTCD <> *BLANKS AND                                       CSC011
     C                             PRTCD <> '*NRF   '                                         CSC011
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC011
     C                   EVAL      DBASE = 40                                                 CSC011
     C                   EVAL      DBKEY = 'CSC011'                                           CSC011
     C                   EXSR      *PSSR                                                      CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        PRTCD = *BLANKS                                            CSC011
     C                   EVAL      @CSC011 = 'Y'                                              CSC011
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C                   IN        SDSTAT                                                     CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      @CSC011 = 'N'                                              CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSD015
      ** Check if CSD015 - Watch List checking is installed                                   CSD015
                                                                                              CSD015
     C                   EVAL      @CSD015 = 'N'                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @Sard                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RtCd <> *BLANKS) and                                     CSD015
     C                             (@RtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKEY = 'CSD015'                                           CSD015
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBASE = 003                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CSD015 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      @CCF001 = 'N'                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *Blanks  and                                      CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 004                                                CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CCF001 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                CGL009
      * Access SAR details file to see if CGL009 is allowed.                    CGL009
      *                                                                         CGL009
     C                   CALLB     'AOSARDR0'                                   CGL009
     C                   Parm      *BLANKS       @RTCD             7            CGL009
     C                   Parm      '*VERIFY'     @OPTN             7            CGL009
     C                   Parm      'CGL009'      @SARD             6            CGL009
     C     SCSARD        Parm      *BLANKS       DSFDY                          CGL009
      *                                                                         CGL009
     C     @RTCD         Ifeq      *BLANKS                                      CGL009
     C                   OPEN      MEFNODL1                                     CGL009
      *  Show Deal reference field                                              175479
     C                   SETON                                        48        175479
     C                   MOVE      'Y'           @CGL009           1            CGL009
      *                                                                         CGL009
      *  Get Fontis TPP process information                                     CGL009
      *                                                                         CGL009
     C                   CALL      'AOFONTR0'                                   CGL009
     C                   PARM                    P@RTCD            7            CGL009
     C                   PARM      '*FIRST'      @OPTN             7            CGL009
     C     SDFONT        PARM      SDFONT        DSFDY                          CGL009
     C     P@RTCD        IFNE      *BLANKS                                      CGL009
     C                   MOVEL     'AOFONTR0'    DBFILE                         CGL009
     C                   MOVEL     *BLANK        DBKEY                          CGL009
     C                   MOVEL     '*CALL'       DBKEY                          CGL009
     C                   Z-ADD     75            DBASE                          CGL009
     C                   EXSR      *PSSR                                        CGL009
     C                   END                                                    CGL009
      *  CGL009 not found                                                       CGL009
     C                   ELSE                                                   CGL009
     C                   MOVE      'N'           @CGL009                        CGL009
      *  Hide Deal reference field                                              175479
     C                   SETOFF                                       48        175479
     C                   END                                                    CGL009
     C/COPY WNCPYSRC,FTOPA1SC32
                                                                                CFT009
      ** Access SAR details file to see if CFT009 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT009'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '081'         DBASE                          CFT009
     C                   MOVEL     'CFT009'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT009                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT009                        CFT009
     C                   ENDIF                                                  CFT009
     C/COPY WNCPYSRC,FTH00340
                                                                                CFT009
      ** Access SAR details file to see if CFT010 is installed.                 CFT009
                                                                                CFT009
     C                   CALLB     'AOSARDR0'                                   CFT009
     C                   PARM      *BLANKS       @RTCD                          CFT009
     C                   PARM      '*VERIFY'     @OPTN                          CFT009
     C                   PARM      'CFT010'      @SARD                          CFT009
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT009
                                                                                CFT009
     C                   IF        @RTCD <> *BLANKS AND                         CFT009
     C                             @RTCD <> '*NRF   '                           CFT009
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT009
     C                   MOVEL     '082'         DBASE                          CFT009
     C                   MOVEL     'CFT010'      DBKEY                          CFT009
     C                   EXSR      *PSSR                                        CFT009
     C                   ENDIF                                                  CFT009
                                                                                CFT009
     C                   IF        @RTCD = *BLANKS                              CFT009
     C                   MOVEL     'Y'           @CFT010                        CFT009
     C                   ELSE                                                   CFT009
     C                   MOVEL     'N'           @CFT010                        CFT009
     C                   ENDIF                                                  CFT009
      *                                                                         CFT018
      ** Access SAR details file to see if CFT018 is installed.                 CFT018
     C                   CALLB     'AOSARDR0'                                   CFT018
     C                   PARM      *BLANKS       @RTCD                          CFT018
     C                   PARM      '*VERIFY'     @OPTN                          CFT018
     C                   PARM      'CFT018'      @SARD                          CFT018
     C     SCSARD        PARM      SCSARD        DSFDY                          CFT018
     C                   IF        @RTCD <> *BLANKS AND                         CFT018
     C                             @RTCD <> '*NRF   '                           CFT018
     C                   MOVEL     'SCSARDPD'    DBFILE                         CFT018
     C                   MOVEL     '085'         DBASE                          CFT018
     C                   MOVEL     'CFT018'      DBKEY                          CFT018
     C                   EXSR      *PSSR                                        CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
     C                   IF        @RTCD = *BLANKS                              CFT018
     C                   MOVEL     'Y'           CFT018            1            CFT018
     C                   ELSE                                                   CFT018
     C                   MOVEL     'N'           CFT018                         CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
      **  Set flag to indicate program ha sbeen called in SSI mode              CFT018
     C                   IF        CFT018 = 'Y'  AND @SORT = 'S'                CFT018
     C                   EVAL      SSIMode     = 'Y'                            CFT018
     C                   ELSE                                                   CFT018
     C                   EVAL      SSIMode     = 'N'                            CFT018
     C                   ENDIF                                                  CFT018
      *                                                                         CFT018
      **                                                                                      CSC022
      ** Access SAR details to see if CSC022 is switched on                                   CSC022
      **                                                                                      CSC022
     C                   CallB     'AOSARDR0'                                                 CSC022
     C                   Parm      *Blanks       PRtCd                                        CSC022
     C                   Parm      '*VERIFY'     POptn                                        CSC022
     C                   Parm      'CSC022'      PSard                                        CSC022
     C     SCSARD        Parm      SCSARD        DSFDY                                        CSC022
      ** Initialize CSC022 and Skip Commit Flags                                              CSC022
     C                   Eval      CSC022 = 'N'                                               CSC022
     C                   IF        @SORT = 'E'                                              BUG24143
     C                   Eval      WSkpComtRolbk = 'Y'                                      BUG24143
     C                   ELSE                                                               BUG24143
     C                   Eval      WSkpComtRolbk = 'N'                                        CSC022
     C                   ENDIF                                                              BUG24143
      **                                                                                      CSC022
     C                   If        PRtCd = *BLANKS                                            CSC022
     C                   Eval      CSC022 = 'Y'                                               CSC022
      **                                                                                      CSC022
      ** Get Jobs currently running i batch mode using SCCMRJOB dataarea                      CSC022
      **                                                                                      CSC022
     C                   In        SCCMTJOB                                                   CSC022
     C                   If        ComitNum > 0                                               CSC022
      ** Move committed jobs to arrary for checking                                           CSC022
     C                   MoveA     WDSJobs       WJobs                                        CSC022
      ** Verify if job running exists in array                                                CSC022
     C                   Eval      WArrPtr = %LookUp(PSJobName:WJobs)                         CSC022
     C                   If        WArrPtr > 0                                                CSC022
     C                   Eval      WSkpComtRolbk = 'Y'                                        CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
      **                                                                                      CSC022
     C                   Else                                                                 CSC022
      ** Execute *PSSR if CSC022 is not found or Database error                               CSC022
     C                   If        PRtCd <> '*NRF'                                            CSC022
     C     *Lock         In        LDA                                                        CSC022
     C                   Eval      DBFile = 'SCSARDPD'                                        CSC022
     C                   Eval      DBPgm  = 'FTOPAY1SN'                                       CSC022
     C                   Eval      DBKey  = 'CSC022'                                          CSC022
     C                   Eval      DBase  = 900                                               CSC022
     C                   Out       LDA                                                        CSC022
     C                   Exsr      *PSSR                                                      CSC022
     C                   EndIf                                                                CSC022
     C                   EndIf                                                                CSC022
     C/COPY WNCPYSRC,FTH00207
      **                                                                                      CSC022
      ** Call SWIF2003 to check if CSW203 is installed                                        CSW203
                                                                                              CSW203
     C                   CALL      'SWIF2003'                                                 CSW203
     C                   PARM      *BLANKS       PRTCD                                        CSW203
                                                                                              CSW203
      ** If ret. code is "CSW203", set CSW203 flag to "Y", else set it to "N"                 CSW203
                                                                                              CSW203
     C                   IF        PRTCD = 'CSW2003'                                          CSW203
     C                   EVAL      CSW203 = 'Y'                                               CSW203
     C                   ELSE                                                                 CSW203
     C                   EVAL      CSW203 = 'N'                                               CSW203
     C                   ENDIF                                                                CSW203
                                                                                              CSW203
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
     C                   EVAL      DBASE  = 41                                                CGL014
     C                   EXSR      *PSSR                                                      CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C                   IF        @RTCD = *BLANKS                                            CGL014
     C                   EVAL      @CGL014 = 'Y'                                              CGL014
     C                   ELSE                                                                 CGL014
     C                   EVAL      @CGL014 = 'N'                                              CGL014
     C                   ENDIF                                                                CGL014
                                                                                              CGL014
     C/COPY WNCPYSRC,FTOPA1SC19
                                                                                              CSC024
      ***Check*if*enhancement*CSC024*(Open*Month*End)*is on                            CSC024 CSC054
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
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSC024
     C**********         EVAL      DBKEY  = 'CSC024'                                   CSC024 CSC054
     C                   EVAL      DBKEY  = 'CSC054'                                          CSC054
     C                   EVAL      DBASE  = 87                                                CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   IF        @RTCD = *BLANKS                                            CSC024
     C**********         MOVEL     'Y'           CSC024            1                   CSC024 CSC054
     C                   MOVEL     'Y'           CSC054            1                          CSC054
                                                                                              CSC024
      ** Access System values                                                                 CSC024
                                                                                              CSC024
     C                   CALL      'AOSVALR0'                                                 CSC024
     C                   PARM      *BLANKS       PRetCode          7                          CSC024
     C**********         PARM      SysValOME     P@OP01           20                   CSC024 CSC054
     C                   PARM      SysValPEA     P@OP01           20                          CSC054
     C                   PARM      *BLANKS       P@VL01          200                          CSC024
     C                   PARM      *BLANKS       P@OP02           20                          CSC024
     C                   PARM      *BLANKS       P@VL02          200                          CSC024
     C                   PARM      *BLANKS       P@OP03           20                          CSC024
     C                   PARM      *BLANKS       P@VL03          200                          CSC024
     C                   PARM      *BLANKS       P@OP04           20                          CSC024
     C                   PARM      *BLANKS       P@VL04          200                          CSC024
     C                   PARM      *BLANKS       P@OP05           20                          CSC024
     C                   PARM      *BLANKS       P@VL05          200                          CSC024
     C                   PARM      *BLANKS       P@OP06           20                          CSC024
     C                   PARM      *BLANKS       P@VL06          200                          CSC024
     C                   PARM      *BLANKS       P@OP07           20                          CSC024
     C                   PARM      *BLANKS       P@VL07          200                          CSC024
     C                   PARM      *BLANKS       P@OP08           20                          CSC024
     C                   PARM      *BLANKS       P@VL08          200                          CSC024
     C                   PARM      *BLANKS       P@OP09           20                          CSC024
     C                   PARM      *BLANKS       P@VL09          200                          CSC024
     C                   PARM      *BLANKS       P@OP10           20                          CSC024
     C                   PARM      *BLANKS       P@VL10          200                          CSC024
                                                                                              CSC024
     C                   IF        PRetCode  <> *BLANKS                                       CSC024
     C                   EVAL      DBPGM = 'FTIPAYSIN'                                        CSC024
     C                   EVAL      DBFILE = 'SDSVALPD'                                        CSC024
     C                   EVAL      DBKEy = '*KEY   '                                          CSC024
     C                   EVAL      DBase = 88                                                 CSC024
     C                   EXSR      *PSSR                                                      CSC024
     C                   ELSE                                                                 CSC024
     C                   IF        P@VL01 = 'Y'                                               CSC024
     C                   MOVEL     'N'           GENPREF           1                          CSC024
     C                   ELSE                                                                 CSC024
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
     C                   ELSE                                                                 CSC024
     C**********         EVAL      CSC024 = 'N'                                        CSC024 CSC054
     C                   EVAL      CSC054 = 'N'                                               CSC054
     C                   EVAL      GENPREF = 'Y'                                              CSC024
     C                   ENDIF                                                                CSC024
                                                                                              CSC024
                                                                                CFT007
      * Read SDTRADPD for US dollar currency code                               CFT007
                                                                                CFT007
     C                   CALLB     'AOTRADR0'                                   CFT007
     C                   PARM      *BLANKS       @RTCD                          CFT007
     C                   PARM      '*FIRST'      @OPTN                          CFT007
     C     SDTRAD        PARM      SDTRAD        DSFDY                          CFT007
                                                                                CFT007
     C     @RTCD         IFNE      *BLANKS                                      CFT007
     C                   MOVEL     'SDTRADPD'    DBFILE                         CFT007
     C                   MOVEL     '902'         DBASE                          CFT007
     C                   MOVEL     @OPTN         DBKEY                          CFT007
     C                   EXSR      *PSSR                                        CFT007
     C                   END                                                    CFT007
                                                                                CFT007
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      ZDAYNO = WPRDTE                                            CSC011
     C                   ELSE                                                                 CSC011
     C                   EVAL      ZDAYNO = BJRDNB                                            CSC011
     C                   ENDIF                                                                CSC011

      * Calculate Run Date
     C                   CALLB     'ZDATE2'
     C**********         Parm      BJRDNB        ZDAYNO                                       CSC011
     C                   PARM                    ZDAYNO                                       CSC011
     C                   Parm                    BJDFIN
     C                   Parm      0             ZDATE
     C                   Parm      *Blanks       ZADATE

     C                   Eval      @RUNN = ZDATE

      * Calculate Back Value Date
      ** Use processing date defined in SC24X7 dataarea when support system                   CSC011
      ** is active.                                                                           CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   EVAL      @BVLD = WPRDTE - BJBVPD                                    CSC011
     C                   ELSE                                                                 CSC011
     C                   Eval      @BVLD = BJRDNB - BJBVPD
     C                   ENDIF                                                                CSC011
      *                                                                                       CSW209
      ** Check if SWIFT2009 is installed                                                      CSW209
      *                                                                                       CSW209
     C                   Eval      CSW209 = 'N'                                               CSW209
     C                   Call      'SWIF2009'                                                 CSW209
     C                   Parm      *BLANKS       PRTCD                                        CSW209
                                                                                              CSW209
     C                   If        PRTCD = 'CSW2009'                                          CSW209
     C                   Eval      CSW209 = 'Y'                                               CSW209
     C                   EndIf                                                                CSW209
      *                                                                                       CSW209

      * Set up User id
     C                   Eval      @USRID = PSUSER

      *
      * GO TO INITIAL SCREEN
      *
     C                   EXSR      INITIAL
      *                                                                                     MD052529
      ** Set up MT202 compare variable                                                      MD052529
      *                                                                                     MD052529
     C                   MOVEL     *BLANKS       ORCFLD                                     MD052529
     C                   MOVEL     'MT202'       ORCFLD           35                        MD052529
      *
      *  Data areas for Payment reference numbering.
     C     *DTAARA       DEFINE    OTPAYDA       OTPAYD
     C     *DTAARA       DEFINE    RGPAYDA       RGPAYD

      * Override file 'OTPAY' in UPD module to 'OTPAYOVR'
     C                   CALL      'QCMDEXC'
     C                   PARM                    OVERRIDE
     C                   PARM      47            OvrLen           15 5
                                                                                CFT014
      ** Override file 'OTPAYXL0' in UPD module with SHARE(*NO)                 CFT014
                                                                                CFT014
     C                   CALL      'QCMDEXC'                                    CFT014
     C                   PARM                    OVROPXL0                       CFT014
     C                   PARM      49            OvrLen1          15 5          CFT014

      ***Override*file*'FTPREFL0'*in*UPD*module*with*SHARE(*NO)********             BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         CALL      'QCMDEXC'                                        BUG4776 BUG4776R
     C**********         PARM                    OVRFTPRF                           BUG4776 BUG4776R
     C**********         PARM      49            OvrLen1          15 5              BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
      * Set level 1/2 flag to '1'
     C                   MOVE      '1'           @Level            1

      * If called from linked enquiry set up screen details
     C     LinkedEnq     IFNE      *BLANK
     C                   EXSR      LINK
     C                   END
      *
     C     *DTAARA       DEFINE    CASH          CSHDTA
     C                   IN        CSHDTA
      *
      **Set*up*MT202*compare*variable                                                       MD052529
      **********                                                                            MD052529
     C**********         MOVEL     *BLANKS       ORCFLD                                     MD052529
     C**********         MOVEL     'MT202'       ORCFLD           35                        MD052529
      * Initialise flag to show first time through                                            204152
     C                   MOVE      'Y'           FirstTime         1                          204152
      *                                                                                       204152
      *
      *  Hook to enable non-core initial processing to be included
      /COPY WNCPYSRC,FTOPAYS012
     C/COPY OFCPYSRCZ,CFT135_001                                                              CFT135
     C                   CALLB     'AOSARDR0'                                                 CER001
     C                   PARM      *BLANKS       @RTCD                                        CER001
     C                   PARM      '*VERIFY'     @OPTN                                        CER001
     C                   PARM      'ULX043'      @SARD                                        CER001
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER001
      *                                                                                       CER001
     C                   IF        @RTCD <> *BLANKS AND                                       CER001
     C                             @RTCD <> '*NRF   '                                         CER001
     C     *LOCK         IN        LDA                                                        CER001
     C                   MOVEL     'SCSARDPD'    DBFILE                                       CER001
     C                   MOVEL     '100'         DBASE                                        CER001
     C                   MOVEL     'ULX043'      DBKEY                                        CER001
     C                   OUT       LDA                                                        CER001
     C                   EXSR      *PSSR                                                      CER001
     C                   END                                                                  CER001
      *                                                                                       CER001
     C                   IF        @RTCD = *BLANKS                                            CER001
     C                   MOVEL     'Y'           ULX043                                       CER001
     C                   ELSE                                                                 CER001
     C                   MOVEL     'N'           ULX043                                       CER001
     C                   ENDIF                                                                CER001
      *                                                                                       CER030
      ** CER030 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER030'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER030'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     905           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER030 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER030 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CER031 - Multicash German Feature                                                    CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CER031'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CER031'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     906           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CER031 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CER031 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
      ** CGL013 - SWIFT Feature                                                               CER030
      *                                                                                       CER030
     C                   CALL      'AOSARDR0'                                                 CER030
     C                   PARM      *BLANKS       PRtCd                                        CER030
     C                   PARM      '*VERIFY'     POptn                                        CER030
     C                   PARM      'CGL013'      PSard                                        CER030
     C     SCSARD        PARM      SCSARD        DSFDY                                        CER030
      *                                                                                       CER030
      ** An NRF (No Record Found) return code is valid.                                       CER030
      ** Issue database error only for error return codes.                                    CER030
      *                                                                                       CER030
     C                   IF        PRtCd <> *BLANKS AND                                       CER030
     C                             PRtCd <> '*NRF   '                                         CER030
     C                   EVAL      DBKEY = 'CGL013'                                           CER030
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CER030
     C                   Z-ADD     907           DBASE                                        CER030
     C                   EXSR      *PSSR                                                      CER030
     C                   ENDIF                                                                CER030
      *                                                                                       CER030
     C                   IF        PRtCd = *BLANKS                                            CER030
     C                   EVAL      CGL013 = 'Y'                                               CER030
     C                   ELSE                                                                 CER030
     C                   EVAL      CGL013 = 'N'                                               CER030
     C                   ENDIF                                                                CER030
     C/COPY WNCPYSRC,JMI106_012                                                               JMI106
      *                                                                                     MD024335
      ** Get Default for Charges Indicator                                                  MD024335
      *                                                                                     MD024335
     C                   EVAL      POPT( 1 ) = 'DefaultChargesInd'                          MD024335
                                                                                            MD024335
     C                   CALL      'AOSVALR0'                                               MD024335
     C                   PARM      *BLANKS       PRetCode                                   MD024335
     C                   PARM                    POPT( 1 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 1 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 2 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 2 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 3 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 3 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 4 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 4 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 5 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 5 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 6 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 6 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 7 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 7 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 8 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 8 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 9 )                                  MD024335
     C                   PARM      *BLANKS       PVAL( 9 )                                  MD024335
     C                   PARM      *BLANKS       POPT( 10 )                                 MD024335
     C                   PARM      *BLANKS       PVAL( 10 )                                 MD024335
                                                                                            MD024335
     C                   IF        PRetCode  <> *BLANKS                                     MD024335
     C                   EVAL      DBFile = 'SDSVALPD'                                      MD024335
     C                   EVAL      DBKEy = POPT( 1 )                                        MD024335
     C                   EVAL      DBase = 2                                                MD024335
     C                   EXSR      *PSSR                                                    MD024335
     C                   ENDIF                                                              MD024335
                                                                                            MD024335
     C                   EVAL      DftADInd = PVAL( 1 )                                     MD024335
     C/COPY OFCPYSRCZ,CFT148_012                                                              CFT148

     C/COPY WNCPYSRC,FTH00279
     C                   ENDSR
     C/COPY WNCPYSRC,FTOPA1SC21
     C/COPY OFCPYSRCZ,CFT135_004                                                              CFT135
      *****************************************************************                       225169
      *                                                               *                       225169
      *  WTRNCY   :  Translate SWIFT ccy to Midas ccy if needed.      *                       225169
      *                                                               *                       225169
      *  CALLED BY:  RTPCA, RTPDCA, EISWFT                            *                       225169
      *                                                               *                       225169
      *****************************************************************                       225169
     C     WTRNCY        BEGSR                                                                225169
     C     W_CCY         IFNE      *BLANKS                                                    225169
     C                   CALL      'AOCURRR0'                                                 225169
     C                   PARM      *BLANKS       @RETC                                        225169
     C                   PARM      '*KEY   '     @OPTN                                        225169
     C                   PARM      W_CCY         @CURR                                        225169
     C     SDCURR        PARM      SDCURR        DSSDY                                        225169
      *                                                                                       225169
     C     @RETC         IFNE      *BLANKS                                                    225169
      *                                                                                       225169
      ** Access SDCURRLD keyed by SWIFT currency code, in case this is                        225169
      ** different from Midas currency code.                                                  225169
      *                                                                                       225169
     C     W_CCY         CHAIN     SDCURRLD                           90                      225169
     C     *IN90         IFEQ      *ON                                                        225169
     C                   MOVEL     W_CCY         DBKEY                                        225169
     C                   MOVEL     'SDCURRPD'    DBFILE                                       225169
     C                   Z-ADD     87            DBASE                                        225169
     C                   EXSR      *PSSR                                                      225169
     C                   ENDIF                                                                225169
     C                   ENDIF                                                                225169
     C                   MOVE      A6CYCD        W_CCY             3                          225169
     C                   ENDIF                                                                225169
      *                                                                                       225169
     C                   ENDSR                                                                225169
     C/EJECT                                                                                  225169
     C/COPY WNCPYSRC,FTH00280
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
