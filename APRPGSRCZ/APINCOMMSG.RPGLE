000100200528     H DEBUG
000200200528     H COPYRIGHT('(c) Finastra International Limited 2002')
000300200528      *****************************************************************
000400200528/*S*D****RPGBASEMOD****************************************************                     MD039105
000500200528/*STD *  RPGSQLMOD                                                    *                     MD039105
000600200528/*EXI *  TEXT('Midas AP Process incoming messages')                   *
000700200528      *****************************************************************
000800200528      *                                                               *
000900200528      *  Midas - API Interface Module                                 *
001000200528      *                                                               *
001100200528      *  APINCOMMSG - Midas API Process incoming messages             *
001200200528      *                                                               *
001300200528      *  Function:  This program processes messages received via the  *
001400200528      *             MQSeries queues which exist on the AS/400.        *
001500200528      *             Messages are held on the queue as character       *
001600200528      *             strings, and must be separated into MM fields     *
001700200528      *             using data structures. The program will run in    *
001800200528      *             batch, using an MQGET call to wait indefinitely   *
001900200528      *             for incoming messages. Transaction details are    *
002000200528      *             passed to the relevant API for validation then    *
002100200528      *             storage in the Midas database.                    *
002200200528      *                                                               *
002300200528      *  Calls - APPARSMSG - Set up Transaction and Settlement Data   *                       CAP083
002400200528      *                                                               *                       CAP083
002500200528      *  (c) Finastra International Limited 2001                      *
002600200528      *                                                               *
002700200604      *  Last Amend No. MD039032           Date 22May20               *
002800200604      *  Prev Amend No. 259813             Date 22May20               *
002900200604      *                 MD041126           Date 04May20               *
003000200528      *                 CSD102             Date 08Jan19               *
003100200528      *                 MD046248           Date 27Oct17               *
003200200528      *                 MD039105           Date 06Jun16               *
003300200528      *                 CSW216             Date 14Mar16               *
003400200528      *                 CPK030             Date 11Apr14               *
003500200528      *                 CSW214             Date 25Nov14               *
003600200528      *                 CDL094             Date 11Jun14               *
003700200528      *                 CGL132             Date 01May13               *
003800200528      *                 CSW213             Date 03Jun13               *
003900200528      *                 CFT120             Date 28Sep12               *
004000200528      *                 CFT039             Date 28Sep12               *
004100200528      *                 AR401481           Date 02Oct12               *
004200200528      *                 CSF011A            Date 28Nov11               *
004300200528      *                 CER059             Date 19Jul10               *
004400200528      *                 262664             Date 11Nov09               *
004500200528      *                 BUG25877           Date 03Sep09               *
004600200528      *                 BUG23518A          Date 07Apr09               *
004700200528      *                 CER034             Date 19May08               *
004800200528      * Bank Fusion Midas 1.4 Base -----------------------------------*
004900200528      *                 CSW209             Date 01Apr09               *
005000200528      * Midas Plus 1.4 Base 04 ---------------------------------------*
005100200528      *                 256564             Date 17Sep08               *
005200200528      *                 CAP186C            Date 28Jan08               *
005300200528      *                 248095A            Date 26Jun07               *
005400200528      *                 246730             Date 17Apr07               *
005500200528      *                 248920             Date 05Jul07               *
005600200528      * Midas Plus 1.4 Base ------------------------------------------*
005700200528      *                 245862             Date 21Feb07               *
005800200528      *                 245310             Date 29Jan07               *
005900200528      *                 243084             Date 10Jul06               *
006000200528      * Midas Plus 1.3 ----------- Base ------------------------------*
006100200528      *                 241470             Date 07Sep06               *
006200200528      *                 BUG9887            Date 12Jan06               *
006300200528      *                 CER001             Date 25Apr05               *
006400200528      *                 CGL032             Date 05Jul04               *
006500200528      *                 CLE031             Date 26Apr05               *
006600200528      *                 PB0210             Date 28Mar02               *
006700200528      *                 CDL018             Date 03Feb04               *
006800200528      *                 CAP083             Date 20Feb03               *
006900200528      *                 CSE040             Date 28Mar03               *
007000200528      *                 CAP182             Date 14Mar03               *
007100200528      *                 CSE039             Date 07Mar03               *
007200200528      *                 CAS006             Date 21Jan03               *
007300200528      *                 214637             Date 05Feb03               *
007400200528      *                 CAP043             Date 02May02               *
007500200528      *                 CDL010             Date 02Aug02               *
007600200528      * Midas Release 4.01.03 ----------------------------------------*
007700200528      * Midas Release 4.01.02 ----------------------------------------*
007800200528      *                 209905             Date 25Sep02               *
007900200528      *                 200299             Date 05Jul02               *
008000200528      * Midas Release 4.01 -------------------------------------------*
008100200528      *                 CAP056             Date 13Mar02               *
008200200528      *                 CAP055             Date 13Mar02               *
008300200528      *                 CPK015             Date 17May02               *
008400200528      *                 CSC011             Date 30Apr02               *
008500200528      *                 CAP072             Date 28Mar02               *
008600200528      *                 CAP071             Date 22Mar02               *
008700200528      *                 CAP068             Date 22Mar02               *
008800200528      *                 CAP070             Date 11Mar02               *
008900200528      *                 CSE031             Date 13Dec01               *
009000200528      *                 CAP166             Date  5Mar02               *
009100200528      *                 CAS001             Date 23Nov01               *
009200200528      *                 CAP067             Date 24Sep01               *
009300200528      *                 CSW024             Date 31Aug01               *
009400200528      *                 196570             Date 23Jul01               *
009500200528      * Midas Release 4 --------------- Base -------------------------*
009600200528      *                 CSE022             Date 29Mar01               *
009700200528      *                 175715             Date 08May01               *
009800200528      *                 175717             Date 08May01               *
009900200528      * Midas DBA 3.05 -----------------------------------------------*
010000200528      *                 CAP038             Date 08Jan01               *
010100200528      *                 CAP057             Date 08Jan01               *
010200200528      *                 CAP042             Date 08Jan01               *
010300200528      *                 CSD006             Date 31Oct00               *
010400200528      *                 186715             Date 17Jan01               *
010500200528      *                 CAP140             Date 17Oct00               *
010600200528      *                 188376             Date 08Jan01               *
010700200528      *                 CIR003             Date 13Sep00               *
010800200528      * Midas DBA 3.04 -----------------------------------------------*
010900200528      *                 CFT014             Date 25May00               *
011000200528      * Midas DBA 3.03 -----------------------------------------------*
011100200528      *                 182598             Date 14Aug00               *
011200200528      *                 CAP039             Date 14Jul00               *
011300200528      *                 CAP137             Date 07Feb00               *
011400200528      *                 CAP136             Date 15Nov99               *
011500200528      * Midas DBA 3.02 -----------------------------------------------*
011600200528      *                 CAP035             Date 08Jul99               *
011700200528      *                 CAP034             Date 08Jul99               *
011800200528      *                 CAP031             Date 08Jul99               *
011900200528      *                 CAP051             Date 08Nov99               *
012000200528      *                 CDL007             Date 05Oct99               *
012100200528      *                 CAP032             Date 06Oct99               *
012200200528      *                 CAP033             Date 07Sep99               *
012300200528      * Midas DBA 3.01 -----------------------------------------------*
012400200528      *                 CAP030             Date 12Mar99               *
012500200528      * Midas DBA 3.00 ---------------- Base -------------------------*
012600200528      *                 CPL002             Date 08Mar99               *
012700200528      *                 CAP006             Date 04Dec98               *
012800200528      *                 153108             Date 13Jan99               *
012900200528      *                 CAP005             Date 09Nov98               *
013000200528      *                 CAP004             Date 27Jul98               *
013100200528      *                 CAP003             Date 03Jul98               *
013200200528      *                 138019             Date 30Jun98               *
013300200528      *                 CAP002  *CREATE    Date 20Sep97               *
013400200528      *                                                               *
013500200528      *---------------------------------------------------------------*
013600200528      *                                                               *
013700200528      *  MD039032 - Modified fix 251029 to include checking of the    *
013800200528      *             Front Office ID to make sure that new transactions*
013900200528      *             will be processed.                                *
014000200528      *  251029 - Handle file locking properly.  Applied fix 231306   *
014100200528      *           and added some checking in field ARERRMODE.         *
014200200604      *  259813 - Clear APDUMP before giving it a new value.          *
014300200604      *           Applied for MD-39032                                *
014400200528      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
014500200528      *           - Applied for MD055614                              *
014600200528      *  CSD102 - Password Length Extension                           *
014700200528      *  MD046248 - Finastra Rebranding                               *
014800200528      *  MD039105 - Data truncation encountered when trying to insert *
014900200528      *             CUSD MQ and SOAP transaction with UDF fields      *
015000200528      *           - Applied for MD-39420.                             *
015100200528      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
015200200528      *  CPK030 - Clean up of deliverable data library.               *
015300200528      *  CSW214 - SWIFT Changes 2014                                  *
015400200528      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
015500200528      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
015600200528      *           Classification - Master                             *
015700200528      *  CSW213 - SWIFT Changes 2013                                  *
015800200528      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
015900200528      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
016000200528      *           DS introduced by CSF011A not being passed promperly *
016100200528      *           from APPARSMSG to APCCALLCTL                        *
016200200528      *           Amendment done to accommodate longer data           *
016300200528      *  AR401481 - Some API messages were lost during processing of  *
016400200528      *             APISERVER                                         *
016500200528      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
016600200528      *            (Recompile)                                        *
016700200528      *  CER059 - German Feature Upgrade to Delhi                     *
016800200528      *  262664 - GF Phase 1 - Incorrect parameter - FTIPAYCTL /      *
016900200528      *           FTOPAYCTL.                                          *
017000200528      *         - Corrected the parameters.                           *
017100200528      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
017200200528      *  BUG23518A - Produce Annual Tax Deducted Statement upon       *
017300200528      *              Customer Closure                                 *
017400200528      *  CER034A - LF046 German Features - New Fields and Enquiries   *
017500200528      *  CSW209 - SWIFT 2009 Changes                                  *
017600200528      *  256564 - Recompile due to PF changes done by fix 256330      *
017700200528      *  CAP186C - MQ Enabled CB APIs. Buffer length of APOUTPUTPD    *
017800200528      *           increased to 32000. Renamed buffer field of this    *
017900200528      *           file to avoid conflict with other buffers used in   *
018000200528      *           this program                                        *
018100200528      *  248095A- Ensure connection handle is always valid. Applied   *
018200200528      *           fix 245310B. Monitor for MQ error 2019 as well as   *
018300200528      *           2018 (MQGET). Applied fix 245310C. Re-open queue if *
018400200528      *           connection handle is retrieved. Applied fix 245310D.*
018500200528      *  246730 - Change fix incorporation for 245310.                *
018600200528      *  248920 - Fix OPAY API parameters wh. are too short for two   *
018700200528      *           formats, by creating new API versions with larger   *
018800200528      *           parameter sizes.                                    *
018900200528      *  245862 - To use JOB user as default user instead of MQM user.*
019000200528      *  245310 - Connect to MQ queue manager held on data area       *
019100200528      *           APIMQM and use connection handle from this          *
019200200528      *           connection for other MQ API calls in the program    *
019300200528      *  243084 - Incorrect/missing parsing.                          *
019400200528      *           Remove CGL032 as processing to set up the           *
019500200528      *           Transaction & Settlement Data Structures was moved  *
019600200528      *           to module APPARSMSG by CAP083 (See below).          *
019700200528      *  241470 - Applied fix BUG9887.                                *
019800200528      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
019900200528      *  CER001 - LUX Upgrade to MidasPlus                            *
020000200528      *  CGL032 - Automatic Exchange of Information                   *
020100200528      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
020200200528      *  PB0210 - Additional Customer Details Interface.              *
020300200528      *           Recompiled over changes in SDCUEXPD                 *
020400200528      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
020500200528      *           (Recompile)                                         *
020600200528      *  CAP083 - APISERVER File Adapter.                             *
020700200528      *           Processing to Set up the Transaction & Settlement   *
020800200528      *           Data Structures has been moved to module APPARSMSG. *
020900200528      *  CSE040 - Securities Statement Processing                     *
021000200528      *  CAP182 - Auto Settlement of Trades                           *
021100200528      *         - Conversion of SE Trade Settlement Input maintence   *
021200200528      *           function to modular structure to use as APIs.       *
021300200528      *  CSE039 - Automatic Settlement of Trades                      *
021400200528      *  CAS006 - Hedge Accounting Phase B                            *
021500200528      *  214637 - Incorrect API definition files used                 *
021600200528      *  CAP043 - Additional APIs for IRS Schedules                   *
021700200528      *  CDL010 - Prevent last user that actioned the trade from      *
021800200528      *           authorising it.                                     *
021900200528      *  209905 - Fiduciary API Enhancement                           *
022000200528      *  200299 - Recompile due to change in SETRIFPD                 *
022100200528      *  CAP056 - Automatic Authorisation of Interface Deals          *
022200200528      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
022300200528      *  CPK015 - Prevent APISERVER looping when unknown message type *
022400200528      *           is encountered.                                     *
022500200528      *         - Exit program if record length not found             *
022600200528      *  CSC011 - Midas 24x7 Availability for LE                      *
022700200528      *  CAP072 - Conversion of LE inputs into modular structure to   *
022800200528      *           use as APIs. Fee Settlement and Adjustment input    *
022900200528      *  CAP071 - Conversion of LE inputs into modular structure to   *
023000200528      *           use as APIs. Facility Amendment.                    *
023100200528      *  CAP068 - Conversion of LE inputs into modular structure to   *
023200200528      *           use as APIs. Funding Participants.                  *
023300200528      *  CAP070 - Conversion of LE inputs into modular structure to   *
023400200528      *           use as APIs.                                        *
023500200528      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
023600200528      *  CAP166 - API for Non-Currency OTC                            *
023700200528      *  CAS001 - Net Present Value (NPV) Accounting                  *
023800200528      *  CAP067 - Repurchase Agreements API.                          *
023900200528      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
024000200528      *  196570 - Patch for Market Data Feed                          *
024100200528      *  CSE022 - Depository Definition Enhancement                   *
024200200528      *  175715 - SE Walk In Depot Movements Extra Data files do not  *
024300200528      *           exist. SEWIEXPD and SEWOEXPD replaced by SEDMEXPD   *
024400200528      *  175717 - SE Trades Extra Data file is wrong                  *
024500200528      *  CAP038 - Midas Base Rates API                                *
024600200528      *  CAP057 - Midas Spot Rates API                                *
024700200528      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
024800200528      *           modular structure to use as APIs.                   *
024900200528      *  CSD006 - Market Data Feeds                                   *
025000200528      *  186715 - Customer Settlements Instructions is missing for    *
025100200528      *           FF Currency over-the-counter                        *
025200200528      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
025300200528      *           modular structure to use as APIs.                   *
025400200528      *  188376 - Incorrect data are passed to the controller         *
025500200528      *  CIR003 - FRA/IRS Pay/Receive Messages for Swaps              *
025600200528      *  CFT014 - Straight-through Processing Phase 2 MT103           *
025700200528      *           Messages Generation for FT.                         *
025800200528      *  182598 - Enlarge buffer to cater for Interest Rate Calendars *
025900200528      *           including extra data                                *
026000200528      *  CAP039 - SD Security Customer Details API                    *
026100200528      *  CAP137 - Conversion of SE Securities inputs into modular     *
026200200528      *           structure to use as APIs.                           *
026300200528      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
026400200528      *           modular structure to use as APIs.                   *
026500200528      *  CAP035 - Midas / ToF Interface, GL Accounts maintenance      *
026600200528      *  CAP034 - Midas / ToF Interface, SD Customers details         *
026700200528      *  CAP031 - Midas / ToF Interface, FT Outgoing Payments         *
026800200528      *           Also fixed a problem with the record length         *
026900200528      *           checking: the file name field was not cleared       *
027000200528      *           between uses, and it is being set up with MOVEL, so *
027100200528      *           its content could become corrupted.  It would be    *
027200200528      *           better if EVAL were used instead of MOVEL, but a    *
027300200528      *           fix which avoids changing all the existing lines of *
027400200528      *           code is to clear the field at the end of the        *
027500200528      *           GETRCDLN subroutine.                                *
027600200528      *  CAP051 - Automatic Authorisation                             *
027700200528      *  CDL007 - Deposit Breakdown Penalty                           *
027800200528      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
027900200528      *           modular structure to use as APIs.                   *
028000200528      *  CAP033 - Conversion of PM inputs into modular structure to   *
028100200528      *           use as APIs.                                        *
028200200528      *  CAP030 - APIs for SE Price Input.                            *
028300200528      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
028400200528      *  CAP006 - API structural breakdown: correct text on call      *
028500200528      *           to APCCALLCTL.                                      *
028600200528      *  153108 - Call the program to create all the API data queues, *
028700200528      *           to ensure that they always exist.                   *
028800200528      *  CAP005 - Add APIs phase 4 calls.                             *
028900200528      *  CAP004 - Add APIs phase 3 calls.                             *
029000200528      *  CAP003 - Add APIs phase 2 calls.                             *
029100200528      *  138019 - Module was sending gibberish to QSYSOPR when        *
029200200528      *           an MQSeries call failed.  This was because the      *
029300200528      *           MQError field was being passed to ZAMSGTOOPR as 28  *
029400200528      *           bytes, when ZAMSGTOOPR expects 132.                 *
029500200528      *  CAP002 - Conversion of Midas inputs to modular API structure *
029600200528      *                                                               *
029700200528      *****************************************************************
029800200528      /EJECT
029900200528
030000200528      ** File to log received data
030100200528     F***APOUTPUTPDO*   E           K DISK                                                   CAP186C
030200200528     F***APOUTPUTPDO    E           K DISK    PREFIX(O_)                            CAP186C MD039105
030300200528
030400200528      ** File to log unauthorised access attempts
030500200528     FAPUNAUTHPDO    E           K DISK    USROPN
030600200528
030700200528      ** File to log details of message after exception error
030800200528     FAPEXCPERPDO    E           K DISK
030900200528
031000200528      ** File to log job details
031100200528     FAPIJOBL0  O    E           K DISK    USROPN
031200200528
031300200528     F/COPY WNCPYSRC,APH00044
031400200528      *****************************************************************
031500200528      ** +--------------------------------------+
031600200528      ** ¦ Automatically included D-specs       ¦
031700200528      ** ¦ ==============================       ¦
031800200528      ** +--------------------------------------+
031900200528      **
032000200528      ** Standard D-specs
032100200528      ** ================
032200200528      **
032300200528      ** The following /COPY line includes the LDA layout,
032400200528      ** the copyright array definition,
032500200528      ** and the following named constants:
032600200528      **    True       logical = *on (for indicator processing)
032700200528      **    False      logical = *off (for indicator processing)
032800200528      **    DBErrCtl   10A     = 'DBERRCTL' (the name of the database error
032900200528      **                                    handler)
033000200528      ** and the following variables:
033100200528      **    RunBefore  1A (for the PSSR)
033200200528
033300200528     D/COPY ZACPYSRC,STD_D_SPEC
033400200528
033500200528      ** Program Status Data Structure
033600200528      ** =============================
033700200528      ** The following /COPY line includes all the defined fields in the
033800200528      ** PSDS.  They have meaningful names, prefixed by 'PS'.
033900200528     D/COPY ZACPYSRC,PSDS
034000200528
034100200528      ** +--------------------------------------+
034200200528      ** ¦ End of automatically included D-specs¦
034300200528      ** ¦ =====================================¦
034400200528      ** +--------------------------------------+
034500200528
034600200528      *****************************************************************
034700200528      /EJECT
034800200528      *****************************************************************
034900200528
035000200528      ** +--------------------------------------+
035100200528      ** ¦ Manually included D-specs            ¦
035200200528      ** ¦ =========================            ¦
035300200528      ** +--------------------------------------+
035400200528
035500200528      ** +--------------------------------------+
035600200528      ** ¦ Named constants                      ¦
035700200528      ** ¦ ===============                      ¦
035800200528      ** +--------------------------------------+
035900200528
036000200528      * Constant to hold input parameter for AOSVALR0.                                        245310
036100200528     D MQManager       C                   Const('MQQueueManagerAPI')                         245310
036200200528                                                                                              245310
036300200528      ** Input queue name
036400200528     D RootQueue       C                   CONST('MIDASXX.TRANSACT.Q')
036500200528
036600200528      ** MQSeries error message literals
036700200528     D OpenFailed      C                   CONST('MQSeries MQOPEN failed: ')
036800200528     D ReadFailed      C                   CONST('MQSeries MQGET  failed: ')
036900200528     D ClosFailed      C                   CONST('MQSeries MQCLOS failed: ')
037000200528     D ConnFailed      C                   CONST('MQSeries MQCONN failed: ')                  245310
037100200528     D DiscFailed      C                   CONST('MQSeries MQDISC failed: ')                  245310
037200200528     D ProcErr         C                   CONST('Error in module')                           251029
037300200528
037400200528      ** Do NOT change the following constant values. Alterations
037500200528      ** here require changes to PC applications.
037600200528
037700200528      * Don't need little letters...
037800200528     D CHARSET         C                   'ABCDEFGHIJKLMNOPQRST-
037900200528     D                                     UVWXYZABCDEFGHIJKLMN-
038000200528     D                                     OPQRSTUVWXYZ12345678-
038100200528     D                                     90 '
038200200528     D CIPHER          C                   '156RS2czIj9BY aNDrEw-
038300200528     D                                     JAmesC0oKunlO4G3i-
038400200528     D                                     XhW8pxQftVvTPLHgFdby-
038500200528     D                                     7qkZUM'
038600200528
038700200528      ** +--------------------------------------+
038800200528      ** ¦ Arrays and Data Structures           ¦
038900200528      ** ¦ ==========================           ¦
039000200528      ** +--------------------------------------+
039100200528     D/COPY WNCPYSRC,APH00045
039200200528
039300200528     D SDAPI         E DS                  EXTNAME(SDAPIPD)
039400200528      ** External DS for API ICD
039500200528
039600200528      ***External*DS*for*SAR*Details*******                                            CAS001 CAP083
039700200528     D*SCSARD********E DS                  EXTNAME(SCSARDPD)                           CAS001 CAP083
039800200528     D/COPY WNCPYSRC,APH00046
039900200528                                                                                              CAS001
040000200528     D DSFDY         E DS                  EXTNAME(DSFDY)
040100200528     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
040200200528
040300200528      ** Data area containing system prefix
040400200528     D SDSTAT        E DS                  DTAARA(SDSTAT)
040500200528
040600200528      ** Data area for queue name
040700200528     D                 DS
040800200528     D  QIN                    1     20
040900200528     D  SysPrefix              6      7
041000200528
041100200528      ** Incoming message header format
041200200528     D APHEAD        E DS                  EXTNAME(APHEADPD)
041300200528
041400200528     D/COPY WNCPYSRC,APH00047
041500200528
041600200528      ** Data structure for incoming message formats
041700200528     D*BUFFER****      DS          3000                                         CAP004
041800200528     D*BUFFER******    DS          4000                                                 CAP004182598
041900200528     D*BUFFER***       DS          5000                                                182598 CIR003
042000200528     D*BUFFER********* DS          6000                                                CIR003 CFT039
042100200528     D*BUFFER***       DS         12000                                                CFT039 CSW213
042200200528     D BUFFER          DS         29997                                                       CSW213
042300200528     D  TYPE                   1      8
042400200528     D  USERID                33     42
042500200528     D**PASSWORD              43     52                                                       CSD102
042600200528     D  PASSWORD              43    170                                                       CSD102
042700200528
042800200528      ** Command to update dtaara ZMUSER                                                      CDL010
042900200528     D CHG@            S             45    DIM(1) CTDATA PERRCD(1)                            CDL010
043000200528                                                                                              CDL010
043100200528      ** Data area fo ZMUSER                                                                  CDL010
043200200528     D ZMUSER          DS            17                                                       CDL010
043300200528     D  USRID                  1     10                                                       CDL010
043400200528                                                                                              CDL010
043500200528      ** Dummy Cmd Text                                                                       CDL010
043600200528     D CMDTXT          DS            57                                                       CDL010
043700200528     D ALLTXT                  1     57                                                       CDL010
043800200528     D USRTXT                 46     55                                                       CDL010
043900200528     D QOTTXT                 56     57                                                       CDL010
044000200528                                                                                              CDL010
044100200528      ** Command to reset U7 and U8                                                         AR401481
044200200528     D CJOB@           S             20    DIM(1) CTDATA PERRCD(1)                          AR401481
044300200528                                                                                            AR401481
044400200528      **  Declare MQI structures needed
044500200528      * MQI Constants
044600200528     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
044700200528     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
044800200528
044900200528      ** Object Descriptor
045000200528     D MQOD            DS
045100200528     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
045200200528     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
045300200528
045400200528      ** Message Descriptor
045500200528     D MQMD            DS
045600200528     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD041126
045700200528     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
045800200528
045900200528      ** Get message options
046000200528     D MQGMO           DS
046100200528     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD041126
046200200528     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
046300200528
046400200528      ** Put message options
046500200528     D MQPMO           DS
046600200528     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
046700200528     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
046800200528
046900200528
047000200528      ** The include below brings in the return code structure that
047100200528      ** is used in calls to OS/400 APIs.
047200200528     D/COPY QSYSINC/QRPGLESRC,QUSEC
047300200528      * API Error code parameter
047400200528
047500200528     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
047600200528      * Pay Settlement Instructions
047700200528     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
047800200528      * Receive Settlement Instructions
047900200528     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
048000200528      * FRA/IRS Settlement Instructions
048100200528                                                                                              CIR003
048200200528     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)                       CIR003
048300200528      * Pay Settlement Instructions                                                           CIR003
048400200528     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)                       CIR003
048500200528      * Receive Settlement Instructions                                                       CIR003
048600200528                                                                                              CIR003
048700200528     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)                       CIR003
048800200528      * Pay Settlement Instructions                                                           CIR003
048900200528     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)                       CIR003
049000200528      * Receive Settlement Instructions                                                       CIR003
049100200528
049200200528     D  DLRIS1In     E DS                  EXTNAME(DLRIS1PD)                                  CSW213
049300200528     D  DLRIS2In     E DS                  EXTNAME(DLRIS2PD)                                  CSW213
049400200528     D  DLRIS3In     E DS                  EXTNAME(DLRIS3PD)                                  CSW213
049500200528     D  DLRIS4In     E DS                  EXTNAME(DLRIS4PD)                                  CSW214
049600200528     D  SDSW13In     E DS                  EXTNAME(SDSW13PD)                                  CSW213
049700200528     D                                     PREFIX(S13)                                        CSW213
049800200528                                                                                              CSW213
049900200528     D InSwift2013     DS                                                                     CSW213
050000200528     D   DLRIS1DS                          LIKE(DLRIS1In)                                     CSW213
050100200528     D   DLRIS2DS                          LIKE(DLRIS2In)                                     CSW213
050200200528     D   DLRIS3DS                          LIKE(DLRIS3In)                                     CSW213
050300200528     D   DLRIS4DS                          LIKE(DLRIS4In)                                     CSW214
050400200528      * Reporting Information                                                                 CSW213
050500200528                                                                                              CSW213
050600200528     D Trans9999_2     DS          9999                                                       CSW213
050700200528     D  SDSW13Ds                           LIKE(SDSW13In)                                     CSW213
050800200528     D  Trans2Fil8942              8942                                                       CSW213
050900200528                                                                                              CSW213
051000200528     D Trans9999_3     DS          9999                                                       CSW213
051100200528      ** +--------------------------------------+
051200200528      ** ¦ Declared Variables                   ¦
051300200528      ** ¦ ==================                   ¦
051400200528      ** +--------------------------------------+
051500200528
051600200528      ** The following /COPY line includes definitions for the above fields
051700200528      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
051800200528      ** corresponding fields in the PSDS /COPY member, so that member
051900200528      ** must be included where this one is used.
052000200528     D/COPY ZACPYSRC,PROCPARMS
052100200528
052200200528      ** Dummy message ID and message file fields for use on the calls to
052300200528      ** ZAMSGTOOPR
052400200528     D DummyMsgID      S                   LIKE(#MsgID)
052500200528     D DummyMsgF       S             10A
052600200528
052700200528      ** Real message ID and message file fields for use on the calls to
052800200528      ** ZAMSGTOOPR
052900200528     D MsgID           S                   LIKE(#MsgID)
053000200528     D MsgF            S             10A
053100200528
053200200528     D Object          S             10A   INZ('APISERVER')
053300200528     D Lib             S             10A   INZ('*LIBL')
053400200528     D ObjType         S              7A   INZ('*DTAARA')
053500200528     D LockStateS      S              7A   INZ('*SHRRD')
053600200528     D Member          S             10A
053700200528     D WaitTime        S              6A   INZ('*CLS')
053800200528     D Dlcobj          S              1A
053900200528     D Return          S              7A
054000200528     D Bypass          S              1A                                                      CPK015
054100200528
054200200528      ** Error message for sending to the operator                              138019
054300200528     D MQError         S            132A                                        138019
054400200528                                                                                138019
054500200528      ** Alpha version of the MQSeries reason code                              138019
054600200528     D ReasonA         S              9A                                        138019
054700200528                                                                                138019
054800200528      ** Other Depot Details for Securities Customer.                                         CSE022
054900200528      ** This totals to 150 additional other depot details from the incoming message.         CSE022
055000200528     D OthDData        S           4755A                                                      CSE022
055100200528                                                                                              CSE022
055200200528      ***Work*variables used by CAP042                                                 CAP042 CAP083
055300200528     D*FUNDLn**********S              4P 0                                             CAP042 CAP083
055400200528     D*FUEXLn**********S              4P 0                                             CAP042 CAP083
055500200528      *****************                                                                CAP042 CAP083
055600200528      *                                                                                CAP140 CAP083
055700200528      ***Work*variables used by CAP140.                                                CAP140 CAP083
055800200528     D*SEDELn**********S              4P 0                                             CAP140 CAP083
055900200528     D*SDEXLn**********S              4P 0                                             CAP140 CAP083
056000200528      *****************                                                                CAP140 CAP083
056100200528      ***Work*variables used by CAP182.                                                CAP140 CAP083
056200200528     D*TRSMLn**********S              4P 0                                             CAP140 CAP083
056300200528     D*TREXLn**********S              4P 0                                             CAP140 CAP083
056400200528      ***Work*variable used by CSE022                                                  CSE022 CAP083
056500200528     D*SDSOLn**********S              4P 0                                             CSE022 CAP083
056600200528                                                                                       CSE022 CAP083
056700200528      ***Work*variables*used*by*CAP067                                                 CAP067 CAP083
056800200528     D*REP1Ln**********S              4P 0                                             CAP067 CAP083
056900200528     D*REP2Ln**********S              4P 0                                             CAP067 CAP083
057000200528      ******************                                                               CAP067 CAP083
057100200528      ***Work*variables*used by CAP055/CAP056                                          CAP055 CAP083
057200200528     D*CACFLn**********S              4P 0                                             CAP055 CAP083
057300200528     D*CACXLn**********S              4P 0                                             CAP055 CAP083
057400200528     D*IRRSLn**********S              4P 0                                             CAP056 CAP083
057500200528     D*IRRXLn**********S              4P 0                                             CAP056 CAP083
057600200528     D*IRRPLn**********S              4P 0                                             CAP056 CAP083
057700200528     D*IRFALn**********S              4P 0                                             CAP056 CAP083
057800200528      *****************                                                                CAP055 CAP083
057900200528      ***Work*variable*used by CAS001                                                  CAS001 CAP083
058000200528     D*SDYRLn**********S              4P 0                                             CAS001 CAP083
058100200528     D*YRAT1Ln*********S              4P 0                                             CAS001 CAP083
058200200528     D*YRAT2Ln*********S              4P 0                                             CAS001 CAP083
058300200528     D*YRAT3Ln*********S              4P 0                                             CAS001 CAP083
058400200528     D*YRAT4Ln*********S              4P 0                                             CAS001 CAP083
058500200528     D*PRtCd***********S              7A                                               CAS001 CAP083
058600200528     D*POptn***********S              7A                                               CAS001 CAP083
058700200528     D*PSarD***********S              6A                                               CAS001 CAP083
058800200528     D*CAS001**********S              1A                                               CAS001 CAP083
058900200528                                                                                       CAS001 CAP083
059000200528      ***Work*variables*used by CDL006                                                 209905 CAP083
059100200528     D*CDL006**********S              1A                                               209905 CAP083
059200200528     D*WFIDT1Ln********S              4P 0                                             209905 CAP083
059300200528     D*WFIDT2Ln********S              4P 0                                             209905 CAP083
059400200528     D*WFIDT3Ln********S              4P 0                                             209905 CAP083
059500200528     D*WFIDT4Ln********S              4P 0                                             209905 CAP083
059600200528     D*WFIDT5Ln********S              4P 0                                             209905 CAP083
059700200528     D*WFIDT6Ln********S              4P 0                                             209905 CAP083
059800200528     D*WFIDT7Ln********S              4P 0                                             209905 CAP083
059900200528     D*WFIDT8Ln********S              4P 0                                             209905 CAP083
060000200528     D*WFIDT9Ln********S              4P 0                                             209905 CAP083
060100200528      *****************                                                                209905 CAP083
060200200528      ***Work*variable*used by CAP043                                                  CAP043 CAP083
060300200528     D*CAP043**********S              1A                                               CAP043 CAP083
060400200528     D*WCFSC1OLn*******S              4P 0                                             CAP043 CAP083
060500200528     D*WCFSC2OLn*******S              4P 0                                             CAP043 CAP083
060600200528     D*WCFSC3OLn*******S              4P 0                                             CAP043 CAP083
060700200528     D*WCFSC4OLn*******S              4P 0                                             CAP043 CAP083
060800200528     D*WPCSC1OLn*******S              4P 0                                             CAP043 CAP083
060900200528     D*WPCSC2OLn*******S              4P 0                                             CAP043 CAP083
061000200528     D*WPCSC3OLn*******S              4P 0                                             CAP043 CAP083
061100200528     D*WPCSC4OLn*******S              4P 0                                             CAP043 CAP083
061200200528     D*WCFSC1TLn*******S              4P 0                                             CAP043 CAP083
061300200528     D*WCFSC2TLn*******S              4P 0                                             CAP043 CAP083
061400200528     D*WCFSC3TLn*******S              4P 0                                             CAP043 CAP083
061500200528     D*WCFSC4TLn*******S              4P 0                                             CAP043 CAP083
061600200528     D*WPCSC1TLn*******S              4P 0                                             CAP043 CAP083
061700200528     D*WPCSC2TLn*******S              4P 0                                             CAP043 CAP083
061800200528     D*WPCSC3TLn*******S              4P 0                                             CAP043 CAP083
061900200528     D*WPCSC4TLn*******S              4P 0                                             CAP043 CAP083
062000200528     D*WTRSCLn*********S              4P 0                                             CAP043 CAP083
062100200528                                                                                              CAP043
062200200528     D PSysVal01       S             20A                                                      245310
062300200528     D PCurSet01       S            200A                                                      245310
062400200528     D PSysVal02       S             20A                                                      245310
062500200528     D PCurSet02       S            200A                                                      245310
062600200528     D PSysVal03       S             20A                                                      245310
062700200528     D PCurSet03       S            200A                                                      245310
062800200528     D PSysVal04       S             20A                                                      245310
062900200528     D PCurSet04       S            200A                                                      245310
063000200528     D PSysVal05       S             20A                                                      245310
063100200528     D PCurSet05       S            200A                                                      245310
063200200528     D PSysVal06       S             20A                                                      245310
063300200528     D PCurSet06       S            200A                                                      245310
063400200528     D PSysVal07       S             20A                                                      245310
063500200528     D PCurSet07       S            200A                                                      245310
063600200528     D PSysVal08       S             20A                                                      245310
063700200528     D PCurSet08       S            200A                                                      245310
063800200528     D PSysVal09       S             20A                                                      245310
063900200528     D PCurSet09       S            200A                                                      245310
064000200528     D PSysVal10       S             20A                                                      245310
064100200528     D PCurSet10       S            200A                                                      245310
064200200528                                                                                              245310
064300200528      ***Work*variable*used*by*CGL032**********************************                CGL032 243084
064400200528     D*ACUDLn**********S              4P 0                                             CGL032 243084
064500200528     D*ACEXLn**********S              4P 0                                             CGL032 243084
064600200528     D*SDNALn**********S              4P 0                                             CGL032 243084
064700200528     D*NaEXLn**********S              4P 0                                             CGL032 243084
064800200528     D*CCTXLn**********S              4P 0                                             CGL032 243084
064900200528     D*NATXLn**********S              4P 0                                             CGL032 243084
065000200528     D*JACMLn**********S              4P 0                                             CGL032 243084
065100200528      **********                                                                       CGL032 243084
065200200528     D*Bfp*************S              4P 0                                             CGL032 243084
065300200528     D*RecordLen*******S              5P 0                                             CGL032 243084
065400200528      ** Work variable used by CSW209                                                         CSW209
065500200528     D TRANS9          S            500A                                                      CSW209
065600200528     D TRANS9A         S           1000A                                                      CSW209
065700200528     D TRANS9B         S           1000A                                                      CSW209
065800200528     D TRANS9C         S           3000A                                                      CGL132
065900200528                                                                                              CSW209
066000200528      *                                                                                      CER034A
066100200528      ** Work variable used by CER034                                                        CER034A
066200200528      *                                                                                      CER034A
066300200528     D Trans10         S            500A                                                     CER034A
066400200528     D Trans11         S            500A                                                     CER034A
066500200528     D Trans12         S            500A                                                     CER034A
066600200528     D Trans13         S            500A                                                     CER034A
066700200528     D Trans14         S            500A                                                     CER034A
066800200528     D Trans15         S            500A                                                     CER034A
066900200528     D Trans16         S            500A                                                     CER034A
067000200528     D Trans17         S            500A                                                     CER034A
067100200528     D Trans3A         S           1000A                                                      CFT120
067200200528     D Trans5A         S           1000A                                                      CFT120
067300200528                                                                                              CSW213
067400200528     D RPIFLn          S              4P 0                                                    CSW213
067500200528     D CU13Ln          S              4S 0                                                    CSW213
067600200528     D O_BUFFER        S          32000                                                     MD039105
067700200528                                                                                            MD041126
067800200528      ** MQ Parameters                                                                      MD041126
067900200528     D QMNAME          S             48A                                                    MD041126
068000200528     D HANDLE          S             10I 0                                                  MD041126
068100200528     D OCODE           S             10I 0                                                  MD041126
068200200528     D CCODE           S             10I 0                                                  MD041126
068300200528     D REASON          S             10I 0                                                  MD041126
068400200528     D HCONN           S             10I 0                                                  MD041126
068500200528     D OPTS            S             10I 0                                                  MD041126
068600200528     D HIN             S             10I 0                                                  MD041126
068700200528     D BUFLEN          S             10I 0                                                  MD041126
068800200528     D MESLEN          S             10I 0                                                  MD041126
068900200528      ** +--------------------------------------+
069000200528      ** ¦ End of D-specs                       ¦
069100200528      ** ¦ ==============                       ¦
069200200528      ** +--------------------------------------+
069300200528
069400200528      ****************************************************************
069500200528      *                                                              *
069600200528      *  Main processing                                             *
069700200528      *                                                              *
069800200528      ****************************************************************
069900200528
070000200528      ** If a Queue Manager is specified on system value MQManager, connect                   245310
070100200528      ** to it and retain connection handle for other QMQM calls instead                      245310
070200200528      ** of using the default Queue Manager and connection                                    245310
070300200528                                                                                              245310
070400200528     C                   CALLB     'AOSVALR0'                                                 245310
070500200528     C                   PARM      *BLANKS       PRtCd             7                          245310
070600200528     C                   PARM      MQManager     PSysVal01                                    245310
070700200528     C                   PARM                    PCurSet01                                    245310
070800200528     C                   PARM                    PSysVal02                                    245310
070900200528     C                   PARM                    PCurSet02                                    245310
071000200528     C                   PARM                    PSysVal03                                    245310
071100200528     C                   PARM                    PCurSet03                                    245310
071200200528     C                   PARM                    PSysVal04                                    245310
071300200528     C                   PARM                    PCurSet04                                    245310
071400200528     C                   PARM                    PSysVal05                                    245310
071500200528     C                   PARM                    PCurSet05                                    245310
071600200528     C                   PARM                    PSysVal06                                    245310
071700200528     C                   PARM                    PCurSet06                                    245310
071800200528     C                   PARM                    PSysVal07                                    245310
071900200528     C                   PARM                    PCurSet07                                    245310
072000200528     C                   PARM                    PSysVal08                                    245310
072100200528     C                   PARM                    PCurSet08                                    245310
072200200528     C                   PARM                    PSysVal09                                    245310
072300200528     C                   PARM                    PCurSet09                                    245310
072400200528     C                   PARM                    PSysVal10                                    245310
072500200528     C                   PARM                    PCurSet10                                    245310
072600200528                                                                                              245310
072700200528     C*****PRtCd*        IFNE      *BLANKS                                             245310 246730
072800200528     C     PRtCd         IFEQ      *BLANKS                                                    246730
072900200528     C     PCurSet01     ANDNE     *BLANKS                                                    246730
073000200528     C                   MOVEL     PCurSet01     QMGR             48                          245310
073100200528     C                   EXSR      MQCONNECT                                                  245310
073200200528     C                   Z-ADD     HANDLE        HCONN                                        245310
073300200528     C                   ENDIF                                                                245310
073400200528                                                                                              245310
073500200528     C                   EXSR      OPQIN
073600200528
073700200528      ** Loop until shutdown message received
073800200528     C     TYPE          DOWNE     'SHUTDOWN'
073900200528     C/COPY WNCPYSRC,APH00048
074000200528
074100200528
074200200528      *                                                                                     AR401481
074300200528     C                   CALL      'QCMDEXC'                            9999                AR401481
074400200528     C                   PARM                    CJOB@                                      AR401481
074500200528     C                   PARM      20            LEN                                        AR401481
074600200528      *                                                                                     AR401481
074700200528     C                   EXSR      GETMSG
074800200528
074900200528     C     TYPE          IFEQ      'SHUTDOWN'
075000200528     C                   LEAVE
075100200528     C                   ENDIF
075200200528     C/COPY WNCPYSRC,APH00049
075300200528
075400200528      ** If an exception error occurred when validating the last
075500200528      ** message, then the rollback will cause the same message to
075600200528      ** be retrieved again.
075700200528      ** In this case, read the message, output to an error logging
075800200528      ** file and retrieve the next message.
075900200528      ** The module in error is stored in the return code on the
076000200528      ** APHEAD parameter.
076100200528      ** or in dtaara APDUMP in case of exception error after validation                      251029
076200200528      ** modules in controller                                                                251029
076300200528                                                                                              251029
076400200528     C                   IN        APDUMP                                                     251029
076500200528     C                   MoveL     BUFFER        APHEAD                                     MD039032
076600200528     C*
076700200528     C*****APRETCODE     IFNE      *BLANKS                                                    251029
076800200528     C**********         IF        (APRETCODE <> *BLANKS) OR                         251029 MD039032
076900200528     C                   If        (APRETCODE <> *BLANKS And                                MD039032
077000200528     C                              APFOTRANID = ARFOTRANID) Or                             MD039032
077100200528     C                             (ARERRMOD <> *BLANKS AND                                   251029
077200200528     C                              APFOTRANID = ARFOTRANID And                             MD039032
077300200528     C                             %SUBST(ARERRMOD:1:2) =                                     251029
077400200528     C                             %SUBST(TYPE:1:2))                                          251029
077500200528     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
077600200528     C                   WRITE     APEXCPERD0
077700200528     C                   EVAL      APRETCODE = *BLANKS
077800200528      ** Perform a commit to ensure that message cannot be read again
077900200528     C                   COMMIT
078000200528                                                                                              251029
078100200528      ** If error detected, send message to system operator                                   251029
078200200528                                                                                              251029
078300200528     C     ARERRMOD      IFNE      *BLANK                                                     251029
078400200528     C                   EVAL      MQError = ProcErr + ARERRMOD                               251029
078500200528                                                                                              251029
078600200528     C                   CALLB     'ZAMSGTOOPR'                                               251029
078700200528     C                   PARM                    MQReturn                                     251029
078800200528     C                   PARM                    MQError                                      251029
078900200528     C                   PARM                    DummyMsgID                                   251029
079000200528     C                   PARM                    DummyMsgF                                    251029
079100200528                                                                                              251029
079200200528     C     *LOCK         IN        APDUMP                                                     251029
079300200528     C                   EVAL      ARERRMOD = *BLANK                                          251029
079400200528     C                   OUT       APDUMP                                                     251029
079500200528     C                   ENDIF                                                                251029
079600200528                                                                                              251029
079700200528     C                   ELSE
079800200528     C/COPY WNCPYSRC,APH00075
079900200528
080000200528      ** If required, validate the Profile / Password
080100200528     C                   IF        GHPWCR = 'Y'
080200200528     C                   EXSR      ValPrfPwd
080300200528     C                   ELSE                                                                 CSD102
080400200528     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
080500200528     C                   EVAL      APPASSWORD = *BLANKS                                       CSD102
080600200528     C                   END
080700200528
080800200528      ** QUESI is the Error MSGID from the API call
080900200528      **   N.B. QUESI will always be blank if the checking is off
081000200528     C     QUSEI         IFEQ      *BLANKS
081100200528
081200200528     C                   EXSR      VALID8
081300200528
081400200528      ** The PrfHandle must be released to avoid hitting the job limit:
081500200528      ** 25574 simultaneous handles.
081600200528     C                   IF        GHPWCR = 'Y'
081700200528     C                   CALL      'QSYRLSPH'
081800200528     C                   PARM                    PrfHandle
081900200528     C                   END
082000200528
082100200528     C                   ELSE
082200200528
082300200528      ** Send an error message for the  Profile / Password
082400200528     C                   EXSR      PrfPwdErr
082500200528
082600200528     C                   ENDIF
082700200528
082800200528     C                   ENDIF
082900200528     C/COPY WNCPYSRC,APH00076
083000200528
083100200528     C                   ENDDO
083200200528
083300200528     C                   EXSR      CLQIN
083400200528
083500200528      ** Perform a commit to ensure that the 'Shutdown' message is removed
083600200528      ** from the queue.
083700200528     C                   COMMIT
083800200528                                                                                              245310
083900200528      ** If an explicit connection to a Queue Manager was made, then                          245310
084000200528      ** disconnect from it                                                                   245310
084100200528                                                                                              245310
084200200528     C     QMGR          IFNE      *BLANKS                                                    245310
084300200528     C                   EXSR      MQDISCONNECT                                               245310
084400200528     C                   ENDIF                                                                245310
084500200528
084600200528     C                   SETON                                        LR
084700200528     C                   RETURN
084800200528      ****************************************************************
084900200528      /EJECT                                                                                  245310
085000200528      ****************************************************************                        245310
085100200528      *                                                              *                        245310
085200200528      *  Open connection to the queue manager                        *                        245310
085300200528      *                                                              *                        245310
085400200528      ****************************************************************                        245310
085500200528     C     MQCONNECT     BEGSR                                                                245310
085600200528                                                                                              245310
085700200528      **  Attempt to CONNECT to the MQ Manager                                                245310
085800200528      *              ~~~~~~~                                                                  245310
085900200528     C**********         CALL      'QMQM'                                            245310 MD041126
086000200528     C**********         PARM      MQCONN        CID               9 0               245310 MD041126
086100200528     C**********         PARM      QMGR          QMNAME           48                 245310 MD041126
086200200528     C**********         PARM      *ZERO         HANDLE            9 0               245310 MD041126
086300200528     C**********         PARM      *ZERO         OCODE             9 0               245310 MD041126
086400200528     C**********         PARM      *ZERO         REASON            9 0               245310 MD041126
086500200528      *                                                                                     MD041126
086600200528     C                   EVAL      QMNAME = QMGR                                            MD041126
086700200528     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
086800200528     C                   Z-ADD     *ZERO         OCODE                                      MD041126
086900200528     C                   Z-ADD     *ZERO         REASON                                     MD041126
087000200528     C                   CALLP     MQCONN( QMNAME : HANDLE :                                MD041126
087100200528     C                                     OCODE  : REASON )                                MD041126
087200200528                                                                                              245310
087300200528      ** Error processing                                                                     245310
087400200528     C     REASON        IFNE      RCNONE                                                     245310
087500200528     C     REASON        ANDNE     RC2002                                                     245310
087600200528                                                                                              245310
087700200528     C                   MOVE      REASON        ReasonA                                      245310
087800200528     C                   EVAL      MQError = ConnFailed + ReasonA                             245310
087900200528                                                                                              245310
088000200528     C                   CALLB     'ZAMSGTOOPR'                                               245310
088100200528     C                   PARM                    MQReturn         10                          245310
088200200528     C                   PARM                    MQError                                      245310
088300200528     C                   PARM                    DummyMsgID                                   245310
088400200528     C                   PARM                    DummyMsgF                                    245310
088500200528                                                                                              245310
088600200528      ** Shut down the program                                                                245310
088700200528     C                   EXSR      *pssr                                                      245310
088800200528                                                                                              245310
088900200528     C                   ENDIF                                                                245310
089000200528                                                                                              245310
089100200528     C                   ENDSR                                                                245310
089200200528      ****************************************************************                        245310
089300200528      /EJECT                                                                                  245310
089400200528      ****************************************************************                        245310
089500200528      *                                                              *                        245310
089600200528      *  Disconnect from the queue manager                           *                        245310
089700200528      *                                                              *                        245310
089800200528      ****************************************************************                        245310
089900200528     C     MQDISCONNECT  BEGSR                                                                245310
090000200528                                                                                              245310
090100200528      **  Attempt to DISCONNECT from the MQ Manager                                           245310
090200200528      *                                                                                       245310
090300200528     C**********         CALL      'QMQM'                                            245310 MD041126
090400200528     C**********         PARM      MQDISC        CID               9 0               245310 MD041126
090500200528     C**********         PARM                    HCONN                               245310 MD041126
090600200528     C**********         PARM      *ZERO         OCODE                               245310 MD041126
090700200528     C**********         PARM      *ZERO         REASON                              245310 MD041126
090800200528      *                                                                                     MD041126
090900200528     C                   Z-ADD     *ZERO         OCODE                                      MD041126
091000200528     C                   Z-ADD     *ZERO         REASON                                     MD041126
091100200528     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
091200200528                                                                                              245310
091300200528      ** Error processing                                                                     245310
091400200528     C     REASON        IFNE      RCNONE                                                     245310
091500200528     C     REASON        ANDNE     RC2018                                                    248095A
091600200528     C     REASON        ANDNE     RC2019                                                    248095A
091700200528                                                                                              245310
091800200528     C                   MOVE      REASON        ReasonA                                      245310
091900200528     C                   EVAL      MQError = DiscFailed + ReasonA                             245310
092000200528                                                                                              245310
092100200528     C                   CALLB     'ZAMSGTOOPR'                                               245310
092200200528     C                   PARM                    MQReturn         10                          245310
092300200528     C                   PARM                    MQError                                      245310
092400200528     C                   PARM                    DummyMsgID                                   245310
092500200528     C                   PARM                    DummyMsgF                                    245310
092600200528                                                                                              245310
092700200528      ** Shut down the program                                                                245310
092800200528     C                   EXSR      *pssr                                                      245310
092900200528                                                                                              245310
093000200528     C                   ENDIF                                                                245310
093100200528                                                                                              245310
093200200528     C                   ENDSR                                                                245310
093300200528      ****************************************************************                        245310
093400200528      /EJECT
093500200528      ****************************************************************
093600200528      *                                                              *
093700200528      *  Open receiving queue for input                              *
093800200528      *                                                              *
093900200528      ****************************************************************
094000200528     C     OPQIN         BEGSR
094100200528
094200200528      ** Use input queue
094300200528     C                   MOVEL     QIN           ODON             48
094400200528
094500200528      ** Open options: INPUT and FAIL_IF_QUIESCING
094600200528     C     OOINPQ        ADD       OOFIQ         OPTS
094700200528
094800200528      ** Open queue
094900200528     C**********         Z-ADD     MQOPEN        CID                                        MD041126
095000200528      **********                                                                            MD041126
095100200528     C**********         CALL      'QMQM'                                                   MD041126
095200200528     C**********         PARM                    CID               9 0                      MD041126
095300200528     C**********         PARM                    HCONN             9 0                      MD041126
095400200528     C**********         PARM                    MQOD                                       MD041126
095500200528     C**********         PARM                    OPTS              9 0                      MD041126
095600200528     C**********         PARM                    HIN               9 0                      MD041126
095700200528     C**********         PARM                    OCODE             9 0                      MD041126
095800200528     C**********         PARM                    REASON            9 0                      MD041126
095900200528      *                                                                                     MD041126
096000200528     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
096100200528     C                                     HIN : OCODE : REASON )                           MD041126
096200200528
096300200528      ** Error processing
096400200528     C     REASON        IFNE      RCNONE
096500200528
096600200528      ** Send message to MOPERQ and QSYSOPR before crashing out
096700200528     C****************** MOVEL     OpenFailed    MQError          28            138019
096800200528     C****************** MOVE      REASON        MQError                        138019
096900200528     C                   MOVE      REASON        ReasonA                        138019
097000200528     C                   EVAL      MQError = OpenFailed + ReasonA               138019
097100200528
097200200528     C                   CALLB     'ZAMSGTOOPR'
097300200528     C                   PARM                    MQReturn         10
097400200528     C                   PARM                    MQError
097500200528     C                   PARM                    DummyMsgID
097600200528     C                   PARM                    DummyMsgF
097700200528
097800200528      ** Shut down the program
097900200528     C                   EXSR      *pssr
098000200528
098100200528     C                   ENDIF
098200200528
098300200528     C                   ENDSR
098400200528      ****************************************************************
098500200528      /EJECT
098600200528      ****************************************************************
098700200528      *                                                              *
098800200528      *  Close input queue                                           *
098900200528      *                                                              *
099000200528      ****************************************************************
099100200528     C     CLQIN         BEGSR
099200200528
099300200528      ** Close options: NONE
099400200528     C                   Z-ADD     CONONE        OPTS
099500200528
099600200528      ** Close queue
099700200528     C**********         Z-ADD     MQCLOS        CID                                        MD041126
099800200528     C**********         CALL      'QMQM'                                                   MD041126
099900200528     C**********         PARM                    CID               9 0                      MD041126
100000200528     C**********         PARM                    HCONN             9 0                      MD041126
100100200528     C**********         PARM                    HIN               9 0                      MD041126
100200200528     C**********         PARM                    OPTS              9 0                      MD041126
100300200528     C**********         PARM                    CCODE             9 0                      MD041126
100400200528     C**********         PARM                    REASON            9 0                      MD041126
100500200528      *                                                                                     MD041126
100600200528     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD041126
100700200528     C                                      CCODE : REASON )                                MD041126
100800200528
100900200528      ** Error processing
101000200528     C     REASON        IFNE      RCNONE
101100200528     C     REASON        ANDNE     RC2018                                                    248095A
101200200528     C     REASON        ANDNE     RC2019                                                    248095A
101300200528
101400200528      ** Send message to MOPERQ and QSYSOPR before crashing out
101500200528     C****************** MOVEL     ClosFailed    MQError                        138019
101600200528     C****************** MOVE      REASON        MQError                        138019
101700200528     C                   MOVE      REASON        ReasonA                        138019
101800200528     C                   EVAL      MQError = ClosFailed + ReasonA               138019
101900200528
102000200528     C                   CALLB     'ZAMSGTOOPR'
102100200528     C                   PARM                    MQReturn
102200200528     C                   PARM                    MQError
102300200528     C                   PARM                    DummyMsgID
102400200528     C                   PARM                    DummyMsgF
102500200528
102600200528      ** Shut down the program
102700200528     C                   EXSR      *pssr
102800200528
102900200528     C                   ENDIF
103000200528
103100200528     C                   ENDSR
103200200528      ****************************************************************
103300200528      /EJECT
103400200528      ****************************************************************
103500200528      *                                                              *
103600200528      *  Validate deal type                                          *
103700200528      *                                                              *
103800200528      ****************************************************************
103900200528     C     VALID8        BEGSR
104000200528
104100200528     C                   MOVEL     BUFFER        APHEAD
104200200528
104300200528     C     APMIDUSR      IFEQ      *BLANKS
104400200528     C**********         MOVEL     MDUID         APMIDUSR                                     245862
104500200528     C                   ENDIF
104600200528                                                                                              CDL010
104700200528     ** Get Front Office User, Else default Job User                                          CDL010
104800200528     C                   MOVEA     CHG@          ALLTXT                                       CDL010
104900200528     C                   MOVE      ''')'         QOTTXT                                       CDL010
105000200528     C     APMIDUSR      IFEQ      *BLANKS                                                    CDL010
105100200528     C                   MOVE      PSUser        USRTXT                                       CDL010
105200200528     C                   ELSE                                                                 CDL010
105300200528     C                   MOVE      APMIDUSR      USRTXT                                       CDL010
105400200528     C                   ENDIF                                                                CDL010
105500200528                                                                                              CDL010
105600200528     C                   CALL      'QCMDEXC'                            9999    *             CDL010
105700200528     C                   PARM                    CMDTXT                                       CDL010
105800200528     C                   PARM      57            LEN              15 5                        CDL010
105900200528
106000200528      ** Log incoming data
106100200528     C                   MOVEL     *BLANKS       O_BUFFER                                    CAP186C
106200200528     C                   MOVEL     BUFFER        O_BUFFER                                    CAP186C
106300200528     C**********         WRITE     APOUTPUTD0                                               MD039105
106400200528                                                                                            MD039105
106500200528     C/exec SQL                                                                             MD039105
106600200528     C+ insert into APOUTPUTPD                                                              MD039105
106700200528     C+ (                                                                                   MD039105
106800200528     C+   BUFFER                                                                            MD039105
106900200528     C+ )                                                                                   MD039105
107000200528     C+ values                                                                              MD039105
107100200528     C+ (                                                                                   MD039105
107200200528     C+   :O_BUFFER                                                                         MD039105
107300200528     C+ )                                                                                   MD039105
107400200528     C/end-exec                                                                             MD039105
107500200528
107600200528      ** Set up the Transaction & Settlement DS's
107700200528
107800200528     C*******************EXSR      TRANSETI                                                   CAP083
107900200528     C*******************EXSR      TRANSETI                                            CGL032 243084
108000200528     C                   SELECT                                                               248920
108100200528     C     TYPE          WHENEQ    'FTOPAY'                                                   248920
108200200528     C                   CALLB     'APPARMSGFT'                                               248920
108300200528     C                   PARM                    BUFFER                                       248920
108400200528     C                   PARM                    TRANS1FT       1000                          248920
108500200528     C                   PARM                    TRANS1A                                      248920
108600200528     C                   PARM                    TRANS2                                       248920
108700200528     C                   PARM                    TRANS3                                       248920
108800200528     C                   PARM                    TRANS4                                       248920
108900200528     C                   PARM                    TRANS5                                       248920
109000200528     C                   PARM                    TRANS6FT       1000                          248920
109100200528     C                   PARM                    TRANS7                                       248920
109200200528     C                   PARM                    TRANS8                                       248920
109300200528     C                   PARM                    TRANS9                                       248920
109400200528     C                   PARM                    TRANS9A                                      CFT039
109500200528     C                   PARM                    TRANS9B                                      CFT039
109600200528     C                   PARM                    TRANS10                                      CFT039
109700200528     C                   PARM                    TRANS11                                      CFT039
109800200528     C                   PARM                    PaySttmt                                     248920
109900200528     C                   PARM                    RecSttmt                                     248920
110000200528     C                   PARM                    FRASttmt                                     248920
110100200528     C                   PARM                    PayStmtV                                     248920
110200200528     C                   PARM                    RecStmtV                                     248920
110300200528     C                   PARM                    PayStmtM                                     248920
110400200528     C                   PARM                    RecStmtM                                     248920
110500200528     C                   PARM                    InfData         500                          248920
110600200528     C                   PARM                    RegData         500                          248920
110700200528     C                   PARM                    ExtData         500                          248920
110800200528     C                   PARM                    OthDData                                     248920
110900200528     C                   PARM                    Bypass                                       248920
111000200528     C                   OTHER                                                                248920
111100200528     C                   CALLB     'APPARSMSG'                                                CAP083
111200200528     C                   PARM                    BUFFER                                       CAP083
111300200528     C                   PARM                    TRANS1          500                          CAP083
111400200528     C                   PARM                    TRANS1A        1000                         BUG9887
111500200528     C                   PARM                    TRANS1B        1500                        BUG25877
111600200528     C                   PARM                    TRANS2          500                          CAP083
111700200528     C                   PARM                    TRANS3          500                          CAP083
111800200528     C                   PARM                    TRANS3A                                      CFT120
111900200528     C                   PARM                    TRANS4          500                          CAP083
112000200528     C                   PARM                    TRANS5          500                          CAP083
112100200528     C                   PARM                    TRANS5A                                      CFT120
112200200528     C                   PARM                    TRANS6          500                          CAP083
112300200528     C                   PARM                    TRANS7          500                          CAP083
112400200528     C                   PARM                    TRANS8          500                          CAP083
112500200528     C                   PARM                    TRANS9          500                          CAP083
112600200528     C                   PARM                    TRANS9A                                      CSW209
112700200528     C                   PARM                    TRANS9B                                      CSW209
112800200528     C                   PARM                    TRANS10         500                          262664
112900200528     C                   PARM                    TRANS9C                                      CGL132
113000200528     C**********         PARM                    Trans10                           CER034A BUG23518A
113100200528     C**********         PARM                    Trans11                           CER034A BUG23518A
113200200528     C**********         PARM                    Trans12                           CER034A BUG23518A
113300200528     C**********         PARM                    Trans13                           CER034A BUG23518A
113400200528     C**********         PARM                    Trans14                           CER034A BUG23518A
113500200528     C**********         PARM                    Trans15                           CER034A BUG23518A
113600200528     C**********         PARM                    Trans16                           CER034A BUG23518A
113700200528     C**********         PARM                    Trans17                           CER034A BUG23518A
113800200528     C                   PARM                    PaySttmt                                     CAP083
113900200528     C                   PARM                    RecSttmt                                     CAP083
114000200528     C                   PARM                    FRASttmt                                     CAP083
114100200528     C                   PARM                    PayStmtV                                     CAP083
114200200528     C                   PARM                    RecStmtV                                     CAP083
114300200528     C                   PARM                    PayStmtM                                     CAP083
114400200528     C                   PARM                    RecStmtM                                     CAP083
114500200528     C                   PARM                    InfData         500                          CAP083
114600200528     C                   PARM                    RegData         500                          CER001
114700200528     C                   PARM                    ExtData         500                          CAP083
114800200528     C                   PARM                    OthDData                                     CAP083
114900200528     C                   PARM                    InSwift2013                                  CSW213
115000200528     C                   PARM                    Trans9999_2                                  CSW213
115100200528     C                   PARM                    Trans9999_3                                  CSW213
115200200528     C                   PARM                    Bypass                                       CAP083
115300200528     C                   ENDSL                                                                248920
115400200528                                                                                              CAP083
115500200528     C     Bypass        IFEQ      'Y'                                                        CAP083
115600200528     C                   WRITE     APEXCPERD0                                                 CAP083
115700200528     C                   COMMIT                                                               CAP083
115800200528     C                   ENDIF                                                                CAP083
115900200528
116000200528      ** Load the entire message header into the API Dump data area so that
116100200528      **  dumps in any lower level modules will include the key information
116200200528     C     *Lock         IN        APDump
116300200604     C                   Clear                   APDUMP                                       259813
116400200528     C**********         MOVEL     APHEAD        APDUMP                                       CSD102
116500200528     C                   MOVE      *BLANKS       ARERRMOD                                     251029
116600200528     C                   MOVEL     APTGTTYPE     ARTGTTYPE                                    CSD102
116700200528     C                   MOVEL     APTGTSYS      ARTGTSYS                                     CSD102
116800200528     C                   MOVEL     APSRCTYPE     ARSRCTYPE                                    CSD102
116900200528     C                   MOVEL     APSRCSYS      ARSRCSYS                                     CSD102
117000200528     C                   MOVEL     APUSERID      ARUSERID                                     CSD102
117100200528     C                   MOVEL     *BLANKS       ARPASSWORD                                   CSD102
117200200528     C                   MOVEL     APFORMAT      ARFORMAT                                     CSD102
117300200528     C                   MOVEL     APVERSION     ARVERSION                                    CSD102
117400200528     C                   MOVEL     APRPYQUEUE    ARRPYQUEUE                                   CSD102
117500200528     C                   MOVEL     APRESPMODE    ARRESPMODE                                   CSD102
117600200528     C                   MOVEL     APMAPLOCN     ARMAPLOCN                                    CSD102
117700200528     C                   MOVEL     APFOTRANID    ARFOTRANID                                   CSD102
117800200528     C                   MOVEL     APFOASOCID    ARFOASOCID                                   CSD102
117900200528     C                   MOVEL     APCNFVALFO    ARCNFVALFO                                   CSD102
118000200528     C                   MOVEL     APRPRLOCN     ARRPRLOCN                                    CSD102
118100200528     C                   MOVEL     APRETCODE     ARRETCODE                                    CSD102
118200200528     C                   MOVEL     APMIDUSR      ARMIDUSR                                     CSD102
118300200528     C                   OUT       APDump
118400200528
118500200528     C/COPY WNCPYSRC,APH00050
118600200528      ** Validate
118700200528
118800200528      ***Call*CL*to*apply*override*and*call*appropriate*validation*program******CAP006
118900200528      ** Call submodule to apply override and call appropriate                  CAP006
119000200528      ** validation program                                                     CAP006
119100200528     C     Bypass        IFEQ      'N'                                                        CPK015
119200200528     C                   SELECT                                                               248920
119300200528     C     TYPE          WHENEQ    'FTOPAY'                                                   248920
119400200528     C                   CALLB     'APCALCTLFT'                                               248920
119500200528     C                   PARM                    TYPE                                         248920
119600200528     C                   PARM                    APHEAD                                       248920
119700200528     C                   PARM                    TRANS1FT                                     248920
119800200528     C                   PARM                    TRANS1A                                      248920
119900200528     C**********         PARM                    TRANS2                                248920 CSD102
120000200528     C**********         PARM                    TRANS3                                248920 CSD102
120100200528     C                   PARM                    TRANS2A        1000                          CSD102
120200200528     C                   PARM                    TRANS3A        1000                          CSD102
120300200528     C                   PARM                    TRANS4                                       248920
120400200528     C                   PARM                    TRANS5                                       248920
120500200528     C                   PARM                    TRANS6FT                                     248920
120600200528     C                   PARM                    TRANS7                                       248920
120700200528     C                   PARM                    TRANS8                                       248920
120800200528     C                   PARM                    TRANS9                                       248920
120900200528     C                   PARM                    TRANS9A                                      CFT039
121000200528     C                   PARM                    TRANS9B                                      CFT039
121100200528     C                   PARM                    TRANS10                                      CFT039
121200200528     C                   PARM                    TRANS11                                      CFT039
121300200528     C                   PARM                    PaySttmt                                     248920
121400200528     C                   PARM                    RecSttmt                                     248920
121500200528     C                   PARM                    FRASttmt                                     248920
121600200528     C                   PARM                    PayStmtV                                     248920
121700200528     C                   PARM                    RecStmtV                                     248920
121800200528     C                   PARM                    PayStmtM                                     248920
121900200528     C                   PARM                    RecStmtM                                     248920
122000200528     C                   PARM                    InfData                                      248920
122100200528     C                   PARM                    RegData                                      248920
122200200528     C                   PARM                    ExtData                                      248920
122300200528     C                   PARM                    OthDData                                     248920
122400200528     C                   PARM                    #ProcPgm                                     248920
122500200528     C                   PARM                    #ProcMod                                     248920
122600200528     C                   PARM                    #ProcName                                    248920
122700200528     C                   OTHER                                                                248920
122800200528     C                   CALLB     'APCCALLCTL'
122900200528     C                   PARM                    TYPE
123000200528     C                   PARM                    APHEAD
123100200528     C*******************PARM                    TRANS                          CAP003
123200200528     C                   PARM                    TRANS1                         CAP003
123300200528     C                   PARM                    TRANS1A                                     BUG9887
123400200528     C                   PARM                    TRANS1B                                    BUG25877
123500200528     C                   PARM                    TRANS2                         CAP003
123600200528     C                   PARM                    TRANS3                         CAP003
123700200528     C                   PARM                    TRANS3A                                      CFT120
123800200528     C                   PARM                    TRANS4                         CAP003
123900200528     C                   PARM                    TRANS5                         CAP003
124000200528     C                   PARM                    TRANS5A                                      CFT120
124100200528     C                   PARM                    TRANS6                         CAP003
124200200528     C                   PARM                    TRANS7                         CAP003
124300200528     C                   PARM                    TRANS8                         CAP003
124400200528     C                   PARM                    TRANS9                                       209905
124500200528     C                   PARM                    TRANS9A                                      CSW209
124600200528     C                   PARM                    TRANS9B                                      CSW209
124700200528     C                   PARM                    TRANS10                                      262664
124800200528     C                   PARM                    TRANS9C                                      CGL132
124900200528     C**********         PARM                    Trans10                           CER034A BUG23518A
125000200528     C**********         PARM                    Trans11                           CER034A BUG23518A
125100200528     C**********         PARM                    Trans12                           CER034A BUG23518A
125200200528     C**********         PARM                    Trans13                           CER034A BUG23518A
125300200528     C**********         PARM                    Trans14                           CER034A BUG23518A
125400200528     C**********         PARM                    Trans15                           CER034A BUG23518A
125500200528     C**********         PARM                    Trans16                           CER034A BUG23518A
125600200528     C**********         PARM                    Trans17                           CER034A BUG23518A
125700200528     C                   PARM                    PaySttmt
125800200528     C                   PARM                    RecSttmt
125900200528     C                   PARM                    FRASttmt
126000200528     C                   PARM                    PayStmtV                                     CIR003
126100200528     C                   PARM                    RecStmtV                                     CIR003
126200200528     C                   PARM                    PayStmtM                                     CIR003
126300200528     C                   PARM                    RecStmtM                                     CIR003
126400200528     C                   PARM                    InfData                        CDL007
126500200528     C                   PARM                    RegData                                      CER001
126600200528     C                   PARM                    ExtData                        CAP004
126700200528     C                   PARM                    OthDData                                     CSE022
126800200528     C                   PARM                    InSwift2013                                  CSW213
126900200528     C                   PARM                    Trans9999_2                                  CSW213
127000200528     C                   PARM                    Trans9999_3                                  CSW213
127100200528     C                   PARM                    #ProcPgm
127200200528     C                   PARM                    #ProcMod
127300200528     C                   PARM                    #ProcName
127400200528     C                   ENDSL                                                                248920
127500200528     C                   ENDIF                                                                CPK015
127600200528
127700200528     C                   ENDSR
127800200528      ****************************************************************
127900200528      /EJECT
128000200528      ****************************************************************                        CAP083
128100200528      ******************                                             *                        CAP083
128200200528      ***Set*up*Transaction*and*Settlement*Data*Structures           *                        CAP083
128300200528      ******************                                             *                        CAP083
128400200528      ****************************************************************                        CAP083
128500200528     C*****TRANSETI******BEGSR                                                                CAP083
128600200528     C*****TRANSETI      BEGSR                                                         CGL032 243084
128700200528      *******************                                                                     CAP083
128800200528     C*******************CLEAR                   TRANS           500            CAP003
128900200528     C*******************CLEAR                   TRANS1          500            CAP003        CAP083
129000200528     C*******************CLEAR                   TRANS2          500            CAP003        CAP083
129100200528     C*******************CLEAR                   TRANS3          500            CAP003        CAP083
129200200528     C*******************CLEAR                   TRANS4          500            CAP003        CAP083
129300200528     C*******************CLEAR                   TRANS5          500            CAP003        CAP083
129400200528     C*******************CLEAR                   TRANS6          500            CAP003        CAP083
129500200528     C*******************CLEAR                   TRANS7          500            CAP003        CAP083
129600200528     C*******************CLEAR                   TRANS8          500            CAP003        CAP083
129700200528     C*******************CLEAR                   TRANS9          500            209905        CAP083
129800200528     C*******************CLEAR                   PaySttmt                                     CAP083
129900200528     C*******************CLEAR                   RecSttmt                                     CAP083
130000200528     C*******************CLEAR                   FRASttmt                                     CAP083
130100200528     C*******************CLEAR                   PayStmtV                              CIR003 CAP083
130200200528     C*******************CLEAR                   RecStmtV                              CIR003 CAP083
130300200528     C*******************CLEAR                   PayStmtM                              CIR003 CAP083
130400200528     C*******************CLEAR                   RecStmtM                              CIR003 CAP083
130500200528     C*******************CLEAR                   ExtData         500            CAP004        CAP083
130600200528     C*******************CLEAR                   InfData         500            CDL007        CAP083
130700200528     C*******************CLEAR                   OthDData                              CSE022 CAP083
130800200528      *******************                                                                     CAP083
130900200528     C*******************EVAL      Bypass = 'N'                                        CPK015 CAP083
131000200528      *******************                                                                     CAP083
131100200528      ***Position*Buffer*pointer*to*1st*byte after the header data                            CAP083
131200200528      *******************                                                                     CAP083
131300200528     C*****HEADLn********ADD       1             Bfp               4 0                        CAP083
131400200528                                                                                              CAP083
131500200528      **--- Explanation of BUFFER substringing -----------------------------------------------CAP083
131600200528      ** The following select block extracts the transaction data from          CAP003        CAP083
131700200528      ** the incoming transaction string.  Each WHEN section works as           CAP003        CAP083
131800200528      ** follows:                                                               CAP003        CAP083
131900200528      **                                                                        CAP003        CAP083
132000200528      ** 1. The field BUFFER is substringed from position Bfp by the            CAP003        CAP083
132100200528      **    length of the transaction format definition file, and the           CAP003        CAP083
132200200528      **    result placed in field TRANS. (Bfp = length of header info          CAP003        CAP083
132300200528      **    plus 1; the length of the format definition is determined in        CAP003        CAP083
132400200528      **    *inzsr)                                                             CAP003        CAP083
132500200528      **                                                                        CAP003        CAP083
132600200528      ** 2. Bfp is incremented by the length of the format definition           CAP003        CAP083
132700200528      **                                                                        CAP003        CAP083
132800200528      ** 3. The field BUFFER is substringed from the new value of Bfp           CAP003        CAP083
132900200528      **    by the length of the receive settlement instructions format         CAP003        CAP083
133000200528      **    definition file, and the result placed in RecSttmt.                 CAP003        CAP083
133100200528      **                                                                        CAP003        CAP083
133200200528      ** 4. Bfp is incremented by the length of the receive                     CAP003        CAP083
133300200528      **    settlements format definition.                                      CAP003        CAP083
133400200528      **                                                                        CAP003        CAP083
133500200528      ** 5. Point 3 is repeated for pay settlement instructions, and            CAP003        CAP083
133600200528      **    the result placed in PaySttmt.                                      CAP003        CAP083
133700200528      **                                                                        CAP004        CAP083
133800200528      ** 6. Bfp is incremeted by the length of the pay settlement               CAP004        CAP083
133900200528      **    instructions.                                                       CAP004        CAP083
134000200528      **                                                                        CAP004        CAP083
134100200528      ** 7. The field BUFFER is substringed from the new value of Bfp           CAP004        CAP083
134200200528      **    by the length of the relevant Extra Data file. This file will       CAP004        CAP083
134300200528      **    be supplied with a 50 byte core field. This is a free format        CAP004        CAP083
134400200528      **    narrative text field for transferring instructions to the back      CAP004        CAP083
134500200528      **    office.                                                             CAP004        CAP083
134600200528      **    Custom data coming from the front office will be added to this      CAP004        CAP083
134700200528      **    file.                                                               CAP004        CAP083
134800200528      **                                                                        CAP003        CAP083
134900200528      ** The above applies for most transaction types; FRAs also                CAP003        CAP083
135000200528      ** extract the FRA settlement instructions, and FF includes               CAP003        CAP083
135100200528      ** broker and customer settlement instructions in the transaction         CAP003        CAP083
135200200528      ** structure, and does not have pay or receive settlements.               CAP003        CAP083
135300200528      ** Other variations may occur in the future, but the same                 CAP003        CAP083
135400200528      ** principles will be followed.                                           CAP003        CAP083
135500200528      **--------------------------------------------------------------------------------------CAP083
135600200528                                                                                              CAP083
135700200528     C*******************SELECT                                                               CAP083
135800200528     C*******************SELECT                                                        CGL032 243084
135900200528      **FX*deals                                                                              CAP083
136000200528                                                                                              CAP083
136100200528     C*****TYPE**********WHENEQ    'FXFXDL'                                                   CAP083
136200200528                                                                                              CAP083
136300200528     C*****FXDLLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
136400200528     C*****FXDLLn********SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
136500200528     C*******************ADD       FXDLLn        Bfp                                          CAP083
136600200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
136700200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
136800200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
136900200528     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
137000200528      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
137100200528     C*****FXFILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
137200200528     C*******************ADD       FXFILn        Bfp                            CAP051        CAP083
137300200528     C*****FXFXLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
137400200528                                                                                              CAP083
137500200528      **Loans/Deposits                                                                        CAP083
137600200528                                                                                              CAP083
137700200528     C*****TYPE          WHENEQ    'MMLDNI'                                                   CAP083
137800200528                                                                                              CAP083
137900200528     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS                          CAP003
138000200528     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
138100200528     C*******************ADD       LDNILn        Bfp                                          CAP083
138200200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
138300200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
138400200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
138500200528     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
138600200528      **  Non-Screen Interface Data for Class 1 enhancements                    CDL007        CAP083
138700200528     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                        CDL007        CAP083
138800200528     C*******************ADD       MMLILn        Bfp                            CDL007        CAP083
138900200528     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
139000200528                                                                                              CAP083
139100200528     C*****TYPE          WHENEQ    'MMFIDT'                                     209905        CAP083
139200200528     C*****CDL006        ANDEQ     'Y'                                          209905        CAP083
139300200528                                                                                209905        CAP083
139400200528     C*****WFIDT1Ln      SUBST     BUFFER:Bfp    TRANS1                         209905        CAP083
139500200528     C****************** ADD       WFIDT1Ln      Bfp                            209905        CAP083
139600200528     C*****WFIDT2Ln      SUBST     BUFFER:Bfp    TRANS2                         209905        CAP083
139700200528     C****************** ADD       WFIDT2Ln      Bfp                            209905        CAP083
139800200528     C*****WFIDT3Ln      SUBST     BUFFER:Bfp    TRANS3                         209905        CAP083
139900200528     C****************** ADD       WFIDT3Ln      Bfp                            209905        CAP083
140000200528     C*****WFIDT4Ln      SUBST     BUFFER:Bfp    TRANS4                         209905        CAP083
140100200528     C****************** ADD       WFIDT4Ln      Bfp                            209905        CAP083
140200200528     C*****WFIDT5Ln      SUBST     BUFFER:Bfp    TRANS5                         209905        CAP083
140300200528     C****************** ADD       WFIDT5Ln      Bfp                            209905        CAP083
140400200528     C*****WFIDT6Ln      SUBST     BUFFER:Bfp    TRANS6                         209905        CAP083
140500200528     C****************** ADD       WFIDT6Ln      Bfp                            209905        CAP083
140600200528     C*****WFIDT7Ln      SUBST     BUFFER:Bfp    TRANS7                         209905        CAP083
140700200528     C****************** ADD       WFIDT7Ln      Bfp                            209905        CAP083
140800200528     C*****WFIDT8Ln      SUBST     BUFFER:Bfp    TRANS8                         209905        CAP083
140900200528     C****************** ADD       WFIDT8Ln      Bfp                            209905        CAP083
141000200528     C*****WFIDT9Ln      SUBST     BUFFER:Bfp    TRANS9                         209905        CAP083
141100200528     C****************** ADD       WFIDT9Ln      Bfp                            209905        CAP083
141200200528                                                                                209905        CAP083
141300200528     C*****TYPE          WHENEQ    'MMFITR'                                     209905        CAP083
141400200528     C*****CDL006        ANDEQ     'Y'                                          209905        CAP083
141500200528                                                                                209905        CAP083
141600200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                       209905        CAP083
141700200528     C****************** ADD       ESSRLn        Bfp                            209905        CAP083
141800200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                       209905        CAP083
141900200528     C****************** ADD       ESSPLn        Bfp                            209905        CAP083
142000200528     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                        209905        CAP083
142100200528     C****************** ADD       MMLILn        Bfp                            209905        CAP083
142200200528     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                        209905        CAP083
142300200528                                                                                209905        CAP083
142400200528      **Deal*Amendments                                                                       CAP083
142500200528                                                                                              CAP083
142600200528     C*****TYPE          WHENEQ    'MMDEAM'                                                   CAP083
142700200528                                                                                              CAP083
142800200528     C*****DEAMLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
142900200528     C*****DEAMLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
143000200528     C*******************ADD       DEAMLn        Bfp                                          CAP083
143100200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
143200200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
143300200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
143400200528     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
143500200528      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
143600200528     C*****MMDILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
143700200528     C*******************ADD       MMDILn        Bfp                            CAP051        CAP083
143800200528     C*****MMDALn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
143900200528                                                                                              CAP083
144000200528      **NAs*Purchased                                                                         CAP083
144100200528                                                                                              CAP083
144200200528     C*****TYPE          WHENEQ    'MMNASP'                                                   CAP083
144300200528                                                                                              CAP083
144400200528     C*****NASPLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
144500200528     C*****NASPLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
144600200528     C*******************ADD       NASPLn        Bfp                                          CAP083
144700200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
144800200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
144900200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
145000200528     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
145100200528     C*****MMNPLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
145200200528                                                                                              CAP083
145300200528      **NAs*Sold                                                                              CAP083
145400200528                                                                                              CAP083
145500200528     C*****TYPE          WHENEQ    'MMNASS'                                                   CAP083
145600200528                                                                                              CAP083
145700200528     C*****NASSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
145800200528     C*****NASSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
145900200528     C*******************ADD       NASSLn        Bfp                                          CAP083
146000200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
146100200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
146200200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
146300200528     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
146400200528     C*****MMNSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
146500200528                                                                                              CAP083
146600200528      **Forward*Rate*Agreements                                                               CAP083
146700200528                                                                                              CAP083
146800200528     C*****TYPE          WHENEQ    'IRFRA '                                                   CAP083
146900200528                                                                                              CAP083
147000200528     C*****FRALn         SUBST     BUFFER:Bfp    TRANS                          CAP003
147100200528     C*****FRALn         SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
147200200528     C*******************ADD       FRALn         Bfp                                          CAP083
147300200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
147400200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
147500200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
147600200528     C*******************ADD       ESSPLn        Bfp                                          CAP083
147700200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
147800200528     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
147900200528     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
148000200528     C*****IRFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
148100200528                                                                                CAP056        CAP083
148200200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements                    CAP056        CAP083
148300200528                                                                                CAP056        CAP083
148400200528     C*****IRFALn        SUBST     BUFFER:Bfp    InfData                        CAP056        CAP083
148500200528     C****************** ADD       IRFALn        Bfp                            CAP056        CAP083
148600200528                                                                                CAP056        CAP083
148700200528     C*****IRFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
148800200528
148900200528      **Single*Currency*Interest*Rate*Swaps                                                   CAP083
149000200528                                                                                              CAP083
149100200528     C*****TYPE          WHENEQ    'IRSIRS'                                                   CAP083
149200200528                                                                                              CAP083
149300200528     C*****SIRSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
149400200528     C*****SIRSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
149500200528     C*******************ADD       SIRSLn        Bfp                                          CAP083
149600200528     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
149700200528     C*******************ADD       DTORLn        Bfp                            CAP004        CAP083
149800200528     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
149900200528     C*******************ADD       DTOPLn        Bfp                            CAP004        CAP083
150000200528     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS4                         CAP004        CAP083
150100200528     C*******************ADD       DTTRLn        Bfp                            CAP004        CAP083
150200200528     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS5                         CAP004        CAP083
150300200528     C*******************ADD       DTTPLn        Bfp                            CAP004        CAP083
150400200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
150500200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
150600200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
150700200528     C*******************ADD       ESSPLn        Bfp                                          CAP083
150800200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
150900200528     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
151000200528     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
151100200528                                                                                CAP056        CAP083
151200200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements                    CAP056        CAP083
151300200528                                                                                CAP056        CAP083
151400200528     C*****IRRSLn        SUBST     BUFFER:Bfp    InfData                        CAP056        CAP083
151500200528     C****************** ADD       IRRSLn        Bfp                            CAP056        CAP083
151600200528                                                                                CAP056        CAP083
151700200528     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
151800200528                                                                                       CAP043 CAP083
151900200528      ***Additional*Date*Schedules*(Rate*Change*&*Interest*Payment*Dates - Single Ccy) CAP043 CAP083
152000200528                                                                                       CAP043 CAP083
152100200528     C*****TYPE          WHENEQ    'IRSIRI'                                            CAP043 CAP083
152200200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
152300200528                                                                                       CAP043 CAP083
152400200528     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
152500200528     C****************** ADD       DTORLn        Bfp                                   CAP043 CAP083
152600200528     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
152700200528     C****************** ADD       DTOPLn        Bfp                                   CAP043 CAP083
152800200528     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
152900200528     C****************** ADD       DTTRLn        Bfp                                   CAP043 CAP083
153000200528     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
153100200528     C****************** ADD       DTTPLn        Bfp                                   CAP043 CAP083
153200200528                                                                                       CAP043 CAP083
153300200528      ***Cash*Flow*Schedules*(Single*Ccy)                                              CAP043 CAP083
153400200528                                                                                       CAP043 CAP083
153500200528     C*****TYPE          WHENEQ    'IRSICF'                                            CAP043 CAP083
153600200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
153700200528                                                                                       CAP043 CAP083
153800200528      ***Our*Cash*Flow***                                                              CAP043 CAP083
153900200528                                                                                       CAP043 CAP083
154000200528     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
154100200528     C****************** ADD       WCFSC1OLn     Bfp                                   CAP043 CAP083
154200200528     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
154300200528     C****************** ADD       WCFSC2OLn     Bfp                                   CAP043 CAP083
154400200528     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
154500200528     C****************** ADD       WCFSC3OLn     Bfp                                   CAP043 CAP083
154600200528     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
154700200528     C****************** ADD       WCFSC4OLn     Bfp                                   CAP043 CAP083
154800200528                                                                                       CAP043 CAP083
154900200528      ***Their*Cash*Flow***                                                            CAP043 CAP083
155000200528                                                                                       CAP043 CAP083
155100200528     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
155200200528     C****************** ADD       WCFSC1TLn     Bfp                                   CAP043 CAP083
155300200528     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
155400200528     C****************** ADD       WCFSC2TLn     Bfp                                   CAP043 CAP083
155500200528     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
155600200528     C****************** ADD       WCFSC3TLn     Bfp                                   CAP043 CAP083
155700200528     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
155800200528                                                                                       CAP043 CAP083
155900200528      ***Principal*Change*Schedules*(Single*Ccy)                                       CAP043 CAP083
156000200528                                                                                       CAP043 CAP083
156100200528     C*****TYPE          WHENEQ    'IRSIPC'                                            CAP043 CAP083
156200200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
156300200528                                                                                       CAP043 CAP083
156400200528      ***Principal*Change****                                                          CAP043 CAP083
156500200528                                                                                       CAP043 CAP083
156600200528     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
156700200528     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
156800200528     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
156900200528     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
157000200528     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
157100200528     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
157200200528     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
157300200528     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
157400200528                                                                                       CAP043 CAP083
157500200528      ***Trailer*record*(Single*Ccy)                                                   CAP043 CAP083
157600200528                                                                                       CAP043 CAP083
157700200528     C*****TYPE          WHENEQ    'IRSITR'                                            CAP043 CAP083
157800200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
157900200528                                                                                       CAP043 CAP083
158000200528     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
158100200528     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
158200200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
158300200528     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
158400200528     C*****ESSPLn******* SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
158500200528     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
158600200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
158700200528     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
158800200528     C*****IRRSLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
158900200528     C****************** ADD       IRRSLn        Bfp                                   CAP043 CAP083
159000200528     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
159100200528
159200200528      **Cross*Currency*Interest*Rate*Swaps                                                    CAP083
159300200528                                                                                              CAP083
159400200528     C*****TYPE          WHENEQ    'IRCIRS'                                                   CAP083
159500200528                                                                                              CAP083
159600200528     C*****CIRSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
159700200528     C*****CIRSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
159800200528     C*******************ADD       CIRSLn        Bfp                                          CAP083
159900200528     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
160000200528     C*******************ADD       DTORLn        Bfp                            CAP004        CAP083
160100200528     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
160200200528     C*******************ADD       DTOPLn        Bfp                            CAP004        CAP083
160300200528     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS4                         CAP004        CAP083
160400200528     C*******************ADD       DTTRLn        Bfp                            CAP004        CAP083
160500200528     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS5                         CAP004        CAP083
160600200528     C*******************ADD       DTTPLn        Bfp                            CAP004        CAP083
160700200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
160800200528     C*******************ADD       ESSRLn        Bfp                                          CAP083
160900200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
161000200528     C*******************ADD       ESSPLn        Bfp                                          CAP083
161100200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
161200200528     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
161300200528     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
161400200528                                                                                       CIR003 CAP083
161500200528      **(Extra*Settlements                                                             CIR003 CAP083
161600200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtV                              CIR003 CAP083
161700200528     C*******************ADD       ESSRLn        Bfp                                   CIR003 CAP083
161800200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtV                              CIR003 CAP083
161900200528     C*******************ADD       ESSPLn        Bfp                                   CIR003 CAP083
162000200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtM                              CIR003 CAP083
162100200528     C*******************ADD       ESSRLn        Bfp                                   CIR003 CAP083
162200200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtM                              CIR003 CAP083
162300200528     C*******************ADD       ESSPLn        Bfp                                   CIR003 CAP083
162400200528                                                                                       CAP056 CAP083
162500200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP056 CAP083
162600200528                                                                                       CAP056 CAP083
162700200528     C*****IRRXLn        SUBST     BUFFER:Bfp    InfData                               CAP056 CAP083
162800200528     C****************** ADD       IRRXLn        Bfp                                   CAP056 CAP083
162900200528                                                                                       CAP056 CAP083
163000200528     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
163100200528                                                                                       CAP056 CAP083
163200200528      ***Additional*Date*Schedules*(Rate*Change*&*Interest*Payment*Dates*-*Cross Ccy)  CAP043 CAP083
163300200528                                                                                       CAP043 CAP083
163400200528     C*****TYPE          WHENEQ    'IRCIRI'                                            CAP043 CAP083
163500200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
163600200528                                                                                       CAP043 CAP083
163700200528     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
163800200528     C****************** ADD       DTORLn        Bfp                                   CAP043 CAP083
163900200528     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
164000200528     C****************** ADD       DTOPLn        Bfp                                   CAP043 CAP083
164100200528     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
164200200528     C****************** ADD       DTTRLn        Bfp                                   CAP043 CAP083
164300200528     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
164400200528                                                                                       CAP043 CAP083
164500200528      ***Cash*Flow*Schedules*(Cross*Ccy)***                                            CAP043 CAP083
164600200528                                                                                       CAP043 CAP083
164700200528     C*****TYPE          WHENEQ    'IRCICF'                                            CAP043 CAP083
164800200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
164900200528                                                                                       CAP043 CAP083
165000200528      ***Our*Cash*Flow*****                                                            CAP043 CAP083
165100200528                                                                                       CAP043 CAP083
165200200528     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
165300200528     C****************** ADD       WCFSC1OLn     Bfp                                   CAP043 CAP083
165400200528     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
165500200528     C****************** ADD       WCFSC2OLn     Bfp                                   CAP043 CAP083
165600200528     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
165700200528     C****************** ADD       WCFSC3OLn     Bfp                                   CAP043 CAP083
165800200528     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
165900200528     C****************** ADD       WCFSC4OLn     Bfp                                   CAP043 CAP083
166000200528                                                                                       CAP043 CAP083
166100200528      ***Their*Cash*Flow***                                                            CAP043 CAP083
166200200528                                                                                       CAP043 CAP083
166300200528     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
166400200528     C****************** ADD       WCFSC1TLn     Bfp                                   CAP043 CAP083
166500200528     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
166600200528     C****************** ADD       WCFSC2TLn     Bfp                                   CAP043 CAP083
166700200528     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
166800200528     C****************** ADD       WCFSC3TLn     Bfp                                   CAP043 CAP083
166900200528     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
167000200528                                                                                       CAP043 CAP083
167100200528      ***Principal*Change*Schedules*(Cross*Ccy)**                                      CAP043 CAP083
167200200528                                                                                       CAP043 CAP083
167300200528     C*****TYPE          WHENEQ    'IRCIPC'                                            CAP043 CAP083
167400200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
167500200528                                                                                       CAP043 CAP083
167600200528      ***Our*Principal*Change***                                                       CAP043 CAP083
167700200528                                                                                       CAP043 CAP083
167800200528     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
167900200528     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
168000200528     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
168100200528     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
168200200528     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
168300200528     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
168400200528     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
168500200528     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
168600200528                                                                                       CAP043 CAP083
168700200528      ***Their*Principal*Change**                                                      CAP043 CAP083
168800200528                                                                                       CAP043 CAP083
168900200528     C*****WPCSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
169000200528     C****************** ADD       WPCSC1TLn     Bfp                                   CAP043 CAP083
169100200528     C*****WPCSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
169200200528     C****************** ADD       WPCSC2TLn     Bfp                                   CAP043 CAP083
169300200528     C*****WPCSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
169400200528     C****************** ADD       WPCSC3TLn     Bfp                                   CAP043 CAP083
169500200528     C****************** SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
169600200528                                                                                       CAP043 CAP083
169700200528      ***Trailer*record*(Cross*Ccy)                                                    CAP043 CAP083
169800200528                                                                                       CAP043 CAP083
169900200528     C*****TYPE          WHENEQ    'IRCITR'                                            CAP043 CAP083
170000200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
170100200528                                                                                       CAP043 CAP083
170200200528     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
170300200528     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
170400200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
170500200528     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
170600200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
170700200528     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
170800200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
170900200528     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
171000200528                                                                                       CAP043 CAP083
171100200528      ***Extra*Settlements**                                                           CAP043 CAP083
171200200528                                                                                       CAP043 CAP083
171300200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtV                              CAP043 CAP083
171400200528     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
171500200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtV                              CAP043 CAP083
171600200528     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
171700200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtM                              CAP043 CAP083
171800200528     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
171900200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtM                              CAP043 CAP083
172000200528     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
172100200528     C*****IRRXLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
172200200528     C****************** ADD       IRRXLn        Bfp                                   CAP043 CAP083
172300200528     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
172400200528                                                                                CAP003        CAP083
172500200528      **SE*Trade                                                                CAP003        CAP083
172600200528                                                                                CAP003        CAP083
172700200528     C*****TYPE          WHENEQ    'SETRAD'                                     CAP003        CAP083
172800200528                                                                                CAP003        CAP083
172900200528     C*****TRPRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
173000200528     C*******************ADD       TRPRLn        Bfp                            CAP003        CAP083
173100200528     C*****TRSELn        SUBST     BUFFER:Bfp    TRANS2                         CAP003        CAP083
173200200528     C*******************ADD       TRSELn        Bfp                            CAP003        CAP083
173300200528     C*****TREXLn        SUBST     BUFFER:Bfp    TRANS3                         CAP003        CAP083
173400200528     C*******************ADD       TREXLn        Bfp                            CAP003        CAP083
173500200528     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                         CAP003        CAP083
173600200528     C*******************ADD       TRSTLn        Bfp                            CAP003        CAP083
173700200528     C*****TRCCLn        SUBST     BUFFER:Bfp    TRANS5                         CAP003        CAP083
173800200528     C*******************ADD       TRCCLn        Bfp                            CAP003        CAP083
173900200528     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS6                         CAP003        CAP083
174000200528     C*******************ADD       TRCCLn        Bfp                      CAP003CAP051
174100200528     C*******************ADD       TRSWLn        Bfp                            CAP051        CAP083
174200200528     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS7                         CAP003        CAP083
174300200528     C*******************ADD       TRSWLn        Bfp                            CAP004        CAP083
174400200528     C*****TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                CAS006 CAP083
174500200528     C*****              ADD       TRTHLn        Bfp                                   CAS006 CAP083
174600200528      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
174700200528     C*****SETILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
174800200528     C*******************ADD       SETILn        Bfp                            CAP051        CAP083
174900200528     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
175000200528                                                                                CAP003        CAP083
175100200528      **SE*Walk*In*Depot*Movement                                               CAP003        CAP083
175200200528                                                                                CAP003        CAP083
175300200528     C*****TYPE          WHENEQ    'SEDMWI'                                     CAP003        CAP083
175400200528                                                                                CAP003        CAP083
175500200528     C*****DMWILn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
175600200528     C*******************ADD       DMWILn        Bfp                            CAP004        CAP083
175700200528     C*****SEWILn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
175800200528                                                                                CAP003        CAP083
175900200528      * SE Walk Out Depot Movement                                              CAP003        CAP083
176000200528                                                                                CAP003        CAP083
176100200528     C*****TYPE          WHENEQ    'SEDMWO'                                     CAP003        CAP083
176200200528                                                                                CAP003        CAP083
176300200528     C*****DMWILn        SUBST     BUFFER:Bfp    TRANS1                   CAP003CAP004
176400200528     C*****DMWOLn        SUBST     BUFFER:Bfp    TRANS1                         CAP004        CAP083
176500200528     C*******************ADD       DMWOLn        Bfp                            CAP004        CAP083
176600200528     C*****SEWOLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
176700200528                                                                                CAP004        CAP083
176800200528      **AB*Internal*Contract                                                    CAP004        CAP083
176900200528                                                                                CAP004        CAP083
177000200528     C*****TYPE          WHENEQ    'ABINTC'                                     CAP004        CAP083
177100200528                                                                                CAP004        CAP083
177200200528     C*****INTCLn        SUBST     BUFFER:Bfp    TRANS1                         CAP004        CAP083
177300200528     C*******************ADD       INTCLn        Bfp                            CAP004        CAP083
177400200528     C*****ABICLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
177500200528                                                                                CAP003        CAP083
177600200528      **FF*exchange-traded*futures*and*options                                  CAP003        CAP083
177700200528     C*****TYPE          WHENEQ    'FFEXTR'                                     CAP003        CAP083
177800200528                                                                                CAP003        CAP083
177900200528     C*****EXTRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
178000200528     C*******************ADD       EXTRLn        Bfp                            CAP004        CAP083
178100200528     C*****BSETLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
178200200528     C*******************ADD       BSETLn        Bfp                            CAP004        CAP083
178300200528     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
178400200528     C*******************ADD       CSETLn        Bfp                            CAP004        CAP083
178500200528     C*****FFETLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
178600200528                                                                                CAP003        CAP083
178700200528      **FF*over-the-counter*options                                             CAP003        CAP083
178800200528     C*****TYPE          WHENEQ    'FFOTCC'                                     CAP003        CAP083
178900200528                                                                                CAP003        CAP083
179000200528     C*****OTCCLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
179100200528     C*******************ADD       OTCCLn        Bfp                            CAP004        CAP083
179200200528     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
179300200528     C*******************ADD       CSETLn        Bfp                            CAP004        CAP083
179400200528     C*****FFOTLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
179500200528                                                                                CAP004        CAP083
179600200528      ***FF*non-currency*over-the-counter*options                                      CAP166 CAP083
179700200528                                                                                       CAP166 CAP083
179800200528     C*****TYPE          WHENEQ    'FFOTCO'                                            CAP166 CAP083
179900200528                                                                                       CAP166 CAP083
180000200528     C*****OTCOLn        SUBST     BUFFER:Bfp    TRANS1                                CAP166 CAP083
180100200528     C****************** ADD       OTCOLn        Bfp                                   CAP166 CAP083
180200200528     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS2                                CAP166 CAP083
180300200528     C****************** ADD       CSETLn        Bfp                                   CAP166 CAP083
180400200528     C*****FFOTLn        SUBST     BUFFER:Bfp    ExtData                               CAP166 CAP083
180500200528                                                                                       CAP166 CAP083
180600200528      **Forward*Rates                                                           CAP005        CAP083
180700200528                                                                                CAP005        CAP083
180800200528     C*****TYPE          WHENEQ    'FDFWRT'                                     CAP005        CAP083
180900200528                                                                                CAP005        CAP083
181000200528     C*****FWRTLn        SUBST     BUFFER:Bfp    TRANS1                         CAP005        196570
181100200528     C*******************ADD       FWRTLn        Bfp                            CAP005        196570
181200200528     C*****FWRT1Ln       SUBST     BUFFER:Bfp    TRANS1                                196570 CAP083
181300200528     C****************** ADD       FWRT1Ln       Bfp                                   196570 CAP083
181400200528     C*****FWRT2Ln       SUBST     BUFFER:Bfp    TRANS2                                196570 CAP083
181500200528     C****************** ADD       FWRT2Ln       Bfp                                   196570 CAP083
181600200528     C*****FDFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP005        CAP083
181700200528                                                                                CAP005        CAP083
181800200528      **Money*Market*Rates                                                      CAP005        CAP083
181900200528                                                                                CAP005        CAP083
182000200528     C*****TYPE          WHENEQ    'FDINTR'                                     CAP005        CAP083
182100200528                                                                                CAP005        CAP083
182200200528     C*****INTR1Ln       SUBST     BUFFER:Bfp    TRANS1                         CAP005        CAP083
182300200528     C*******************ADD       INTR1Ln       Bfp                            CAP005        CAP083
182400200528     C*****INTR2Ln       SUBST     BUFFER:Bfp    TRANS2                         CAP005        CAP083
182500200528     C*******************ADD       INTR2Ln       Bfp                            CAP005        CAP083
182600200528     C*****FDIRLn        SUBST     BUFFER:Bfp    ExtData                        CAP005        CAP083
182700200528      *                                                                                CAP033 CAP083
182800200528      ***Portfolio*Definition*Details                                                  CAP033 CAP083
182900200528      *                                                                                CAP033 CAP083
183000200528     C*****TYPE          WHENEQ    'PMPFDM'                                            CAP033 CAP083
183100200528     C*****PFDMLn        SUBST     BUFFER:Bfp    TRANS1                                CAP033 CAP083
183200200528     C*******************ADD       PFDMLn        Bfp                                   CAP033 CAP083
183300200528     C*****PFEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP033 CAP083
183400200528      *                                                                                CAP032 CAP083
183500200528      ***Journal*Entry*Header*Details                                                  CAP032 CAP083
183600200528      *                                                                                CAP032 CAP083
183700200528     C*****TYPE          WHENEQ    'GLBITH'                                            CAP032 CAP083
183800200528     C*****BITHLn        SUBST     BUFFER:Bfp    TRANS1                                CAP032 CAP083
183900200528     C*******************ADD       BITHLn        Bfp                                   CAP032 CAP083
184000200528     C*****BHEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP032 CAP083
184100200528      *                                                                                CAP032 CAP083
184200200528      ***Journal*Entry*Item*Details                                                    CAP032 CAP083
184300200528      *                                                                                CAP032 CAP083
184400200528     C*****TYPE          WHENEQ    'GLBITP'                                            CAP032 CAP083
184500200528     C*****BITPLn        SUBST     BUFFER:Bfp    TRANS1                                CAP032 CAP083
184600200528     C*******************ADD       BITPLn        Bfp                                   CAP032 CAP083
184700200528     C/COPY WNCPYSRC,APINCOMMC3
184800200528     C*****BPEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP032 CAP083
184900200528      *                                                                                CAP032 CAP083
185000200528                                                                                CAP031        CAP083
185100200528      **FT*Outgoing*Payment                                                     CAP031        CAP083
185200200528                                                                                CAP031        CAP083
185300200528     C*****TYPE          WHENEQ    'FTOPAY'                                     CAP031        CAP083
185400200528                                                                                CAP031        CAP083
185500200528     C*****OPY1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP031        CAP083
185600200528     C*******************ADD       OPY1Ln        Bfp                            CAP031        CAP083
185700200528     C*****OPY2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP031        CAP083
185800200528     C*******************ADD       OPY2Ln        Bfp                            CAP031        CAP083
185900200528     C*****OPY3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP031        CAP083
186000200528     C*******************ADD       OPY3Ln        Bfp                            CAP031        CAP083
186100200528     C*****OPY4Ln        SUBST     BUFFER:Bfp    TRANS4                         CAP031        CAP083
186200200528     C*******************ADD       OPY4Ln        Bfp                            CAP031        CAP083
186300200528     C*****OPY5Ln        SUBST     BUFFER:Bfp    TRANS5                         CFT014        CAP083
186400200528     C*******************ADD       OPY5Ln        Bfp                            CFT014        CAP083
186500200528     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                         CFT014        CAP083
186600200528     C*******************ADD       OPY6Ln        Bfp                            CFT014        CAP083
186700200528     C*****OPY7Ln        SUBST     BUFFER:Bfp    TRANS7                         CFT014        CAP083
186800200528     C*******************ADD       OPY7Ln        Bfp                            CFT014        CAP083
186900200528     C*****OPY8Ln        SUBST     BUFFER:Bfp    TRANS8                         CFT014        CAP083
187000200528     C*******************ADD       OPY8Ln        Bfp                            CFT014        CAP083
187100200528     C*****OPEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP031        CAP083
187200200528                                                                                CAP034        CAP083
187300200528      **SD*Customers*Details                                                    CAP034        CAP083
187400200528                                                                                CAP034        CAP083
187500200528     C*****TYPE          WHENEQ    'SDCUSD'                                     CAP034        CAP083
187600200528                                                                                CAP034        CAP083
187700200528     C*****CUPRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP034        CAP083
187800200528     C*******************ADD       CUPRLn        Bfp                            CAP034        CAP083
187900200528     C*****CUSELn        SUBST     BUFFER:Bfp    TRANS2                         CAP034        CAP083
188000200528     C*******************ADD       CUSELn        Bfp                            CAP034        CAP083
188100200528     C*****CUMRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP034 CSW024
188200200528     C**********         ADD       CUMRLn        Bfp                                   CAP034 CSW024
188300200528     C*****CUBR1Ln       SUBST     BUFFER:Bfp    TRANS4                                CAP034 CSW024
188400200528     C**********         ADD       CUBR1Ln       Bfp                                   CAP034 CSW024
188500200528     C*****CUBR2Ln       SUBST     BUFFER:Bfp    TRANS5                                CAP034 CSW024
188600200528     C**********         ADD       CUBR2Ln       Bfp                                   CAP034 CSW024
188700200528     C*****CUPBLn        SUBST     BUFFER:Bfp    TRANS6                                CAP034 CSW024
188800200528     C**********         ADD       CUPBLn        Bfp                                   CAP034 CSW024
188900200528     C*****CUMTLn        SUBST     BUFFER:Bfp    TRANS3                                CSW024 CAP083
189000200528     C*******************ADD       CUMTLn        Bfp                                   CSW024 CAP083
189100200528     C*****CUMRLn        SUBST     BUFFER:Bfp    TRANS4                                CSW024 CAP083
189200200528     C*******************ADD       CUMRLn        Bfp                                   CSW024 CAP083
189300200528     C*****CUBR1Ln       SUBST     BUFFER:Bfp    TRANS5                                CSW024 CAP083
189400200528     C*******************ADD       CUBR1Ln       Bfp                                   CSW024 CAP083
189500200528     C*****CUBR2Ln       SUBST     BUFFER:Bfp    TRANS6                                CSW024 CAP083
189600200528     C*******************ADD       CUBR2Ln       Bfp                                   CSW024 CAP083
189700200528     C*****CUPBLn        SUBST     BUFFER:Bfp    TRANS7                                CSW024 CAP083
189800200528     C*******************ADD       CUPBLn        Bfp                                   CSW024 CAP083
189900200528     C/COPY WNCPYSRC,APINCOMMC5
190000200528     C*****SDCULn        SUBST     BUFFER:Bfp    ExtData                        CAP034        CAP083
190100200528                                                                                CAP034        CAP083
190200200528                                                                                CAP035        CAP083
190300200528      **GL*Accounts*Maintenance                                                 CAP035        CAP083
190400200528                                                                                CAP035        CAP083
190500200528     C*****TYPE          WHENEQ    'GLAMAD'                                     CAP035        CAP083
190600200528                                                                                CAP035        CAP083
190700200528     C*****AMMDLn        SUBST     BUFFER:Bfp    TRANS1                         CAP035        CAP083
190800200528     C*******************ADD       AMMDLn        Bfp                            CAP035        CAP083
190900200528     C*****AMDILn        SUBST     BUFFER:Bfp    TRANS2                         CAP035        CAP083
191000200528     C*******************ADD       AMDILn        Bfp                            CAP035        CAP083
191100200528     C*****AMCILn        SUBST     BUFFER:Bfp    TRANS3                         CAP035        CAP083
191200200528     C*******************ADD       AMCILn        Bfp                            CAP035        CAP083
191300200528     C*****AMCOLn        SUBST     BUFFER:Bfp    TRANS4                         CAP035        CAP083
191400200528     C*******************ADD       AMCOLn        Bfp                            CAP035        CAP083
191500200528     C*****AMODLn        SUBST     BUFFER:Bfp    TRANS5                         CAP035        CAP083
191600200528     C*******************ADD       AMODLn        Bfp                            CAP035        CAP083
191700200528     C*****GLAMLn        SUBST     BUFFER:Bfp    ExtData                        CAP035        CAP083
191800200528                                                                                CAP035        CAP083
191900200528                                                                                CAP030        CAP083
192000200528      **SE*Price*Input                                                          CAP030        CAP083
192100200528                                                                                CAP030        CAP083
192200200528     C*****TYPE          WHENEQ    'SEPRCS'                                     CAP030        CAP083
192300200528                                                                                CAP030        CAP083
192400200528     C*****PRCSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP030        CAP083
192500200528     C*****              ADD       PRCSLn        Bfp                            CAP030        CAP083
192600200528     C*****PRCXLn        SUBST     BUFFER:Bfp    ExtData                        CAP030        CAP083
192700200528      *                                                                         CAP136        CAP083
192800200528      ***Funds*Transfer*-*Incoming*Payments                                     CAP136        CAP083
192900200528      *                                                                         CAP136        CAP083
193000200528     C*****TYPE          WHENEQ    'FTIPAY'                                     CAP136        CAP083
193100200528     C*****IPY1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP136        CAP083
193200200528     C*******************ADD       IPY1Ln        Bfp                            CAP136        CAP083
193300200528     C*****IPY2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP136        CAP083
193400200528     C*******************ADD       IPY2Ln        Bfp                            CAP136        CAP083
193500200528     C*****IPY3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP136        CAP083
193600200528     C*******************ADD       IPY3Ln        Bfp                            CAP136        CAP083
193700200528     C*****IPY4Ln        SUBST     BUFFER:Bfp    TRANS4                         CAP136        CAP083
193800200528     C*******************ADD       IPY4Ln        Bfp                            CAP136        CAP083
193900200528     C*****IPY5Ln        SUBST     BUFFER:Bfp    TRANS5                         CFT014        CAP083
194000200528     C*******************ADD       IPY5Ln        Bfp                            CFT014        CAP083
194100200528     C*****IPY6Ln        SUBST     BUFFER:Bfp    TRANS6                         CFT014        CAP083
194200200528     C*******************ADD       IPY6Ln        Bfp                            CFT014        CAP083
194300200528     C*****IPY7Ln        SUBST     BUFFER:Bfp    TRANS7                         CFT014        CAP083
194400200528     C*******************ADD       IPY7Ln        Bfp                            CFT014        CAP083
194500200528     C*****IPY8Ln        SUBST     BUFFER:Bfp    TRANS8                         CFT014        CAP083
194600200528     C*******************ADD       IPY8Ln        Bfp                            CFT014        CAP083
194700200528     C*****IPEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP136        CAP083
194800200528      *                                                                         CAP137        CAP083
194900200528      ***Securities                                                             CAP137        CAP083
195000200528      *                                                                         CAP137        CAP083
195100200528     C*****TYPE          WHENEQ    'SESECS'                                     CAP137        CAP083
195200200528     C*****SEC1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP137        CAP083
195300200528     C*******************ADD       SEC1Ln        Bfp                            CAP137        CAP083
195400200528     C*****SEC2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP137        CAP083
195500200528     C*******************ADD       SEC2Ln        Bfp                            CAP137        CAP083
195600200528     C*****SEC3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP137        CAP083
195700200528     C*******************ADD       SEC3Ln        Bfp                            CAP137        CAP083
195800200528     C*****SEC4Ln        SUBST     BUFFER:Bfp    TRANS4                         CSE031        CAP083
195900200528     C**********         ADD       SEC4Ln        Bfp                            CSE031        CAP083
196000200528     C*****SEC5Ln        SUBST     BUFFER:Bfp    TRANS5                                CAS006 CAP083
196100200528     C**********         ADD       SEC5Ln        Bfp                                   CAS006 CAP083
196200200528     C*****SEEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP137        CAP083
196300200528      *                                                                                CAP039 CAP083
196400200528      ***SD*Security*Customer*Details                                                  CAP039 CAP083
196500200528      *                                                                                CAP039 CAP083
196600200528     C*****TYPE          WHENEQ    'SDSECD'                                            CAP039 CAP083
196700200528     C*****SECDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP039 CAP083
196800200528     C*******************ADD       SECDLn        Bfp                                   CAP039 CAP083
196900200528     C*****SDSOLn        SUBST     BUFFER:Bfp    OthDData                              CSE022 CAP083
197000200528     C*******************ADD       SDSOLn        Bfp                                   CSE022 CAP083
197100200528     C*****SDSELn        SUBST     BUFFER:Bfp    ExtData                               CAP039 CAP083
197200200528      *                                                                                CAP039 CAP083
197300200528      ***SE*Security*Diary*Events*Detail                                               CAP140 CAP083
197400200528      *                                                                                CAP140 CAP083
197500200528     C*****TYPE          WHENEQ    'SESEDE'                                            CAP140 CAP083
197600200528     C*****SEDELn        SUBST     BUFFER:Bfp    TRANS1                                CAP140 CAP083
197700200528     C*******************ADD       SEDELn        Bfp                                   CAP140 CAP083
197800200528     C*****SDEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP140 CAP083
197900200528      **********                                                                       CGL032 243084
198000200528      ***SD*Additional*Customer*Detail*********************************                CGL032 243084
198100200528      **********                                                                       CGL032 243084
198200200528     C*****TYPE          WHENEQ    'SDACUD'                                            CGL032 243084
198300200528     C*****ACUDLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
198400200528     C*******************ADD       ACEXLn        Bfp                                   CGL032 243084
198500200528     C*****ACEXLn        SUBST     BUFFER:Bfp    ExtData                               CGL032 243084
198600200528      **********                                                                       CGL032 243084
198700200528      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
198800200528      **********                                                                       CGL032 243084
198900200528     C*****TYPE          WHENEQ    'SDNAHL'                                            CGL032 243084
199000200528     C*****SDNALn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
199100200528     C*******************ADD       NaEXLn        Bfp                                   CGL032 243084
199200200528     C*****NaEXLn        SUBST     BUFFER:Bfp    ExtData                               CGL032 243084
199300200528      **********                                                                       CGL032 243084
199400200528      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
199500200528      **********                                                                       CGL032 243084
199600200528     C*****TYPE          WHENEQ    'SDCCTX'                                            CGL032 243084
199700200528     C*****CCTXLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
199800200528      **********                                                                       CGL032 243084
199900200528      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
200000200528      **********                                                                       CGL032 243084
200100200528     C*****TYPE          WHENEQ    'SDNATX'                                            CGL032 243084
200200200528     C*****NATXLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
200300200528      **********                                                                       CGL032 243084
200400200528      ***SD*Joint*A/c*Members*Detail***********************************                CGL032 243084
200500200528      **********                                                                       CGL032 243084
200600200528     C*****TYPE          WHENEQ    'SDJACM'                                            CGL032 243084
200700200528     C*****JACMLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
200800200528      *                                                                                CAP140 CAP083
200900200528      *                                                                                CAP057 CAP083
201000200528      ***SD*Market*Data*Feed*Spot*Rate*Details                                         CAP057 CAP083
201100200528      *                                                                                CAP057 CAP083
201200200528     C*****TYPE          WHENEQ    'SDSPTR'                                            CAP057 CAP083
201300200528     C*****SPTRLn        SUBST     BUFFER:Bfp    TRANS1                                CAP057 CAP083
201400200528     C*******************ADD       SPTRLn        Bfp                                   CAP057 CAP083
201500200528     C*****SDSPLn        SUBST     BUFFER:Bfp    ExtData                               CAP057 CAP083
201600200528      *                                                                                CAP057 CAP083
201700200528      **SD*Base*Rate*Maintenance                                                       CAP038 CAP083
201800200528                                                                                       CAP038 CAP083
201900200528     C*****TYPE          WHENEQ    'SDBSRT'                                           CAP038  196570
202000200528     C*****TYPE          WHENEQ    'SDBSRS'                                           196570  CAP083
202100200528                                                                                       CAP038 CAP083
202200200528     C*****SDBSLn        SUBST     BUFFER:Bfp    TRANS1                                CAP038 CAP083
202300200528     C*******************ADD       SDBSLn        Bfp                                   CAP038 CAP083
202400200528     C*****SDBXLn        SUBST     BUFFER:Bfp    ExtData                               CAP038 CAP083
202500200528                                                                                       CAP038 CAP083
202600200528      ***AB*Internal*Funding*Deals*Detail                                              CAP042 CAP083
202700200528      *                                                                                CAP042 CAP083
202800200528     C*****TYPE          WHENEQ    'ABFUND'                                            CAP042 CAP083
202900200528     C*****FUNDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP042 CAP083
203000200528     C*******************ADD       FUNDLn        Bfp                                   CAP042 CAP083
203100200528     C*****FUEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP042 CAP083
203200200528      *                                                                                CAP042 CAP083
203300200528      ***MM*REPOs*Loans*&*Deposits*Detail***                                           CAP067 CAP083
203400200528      *                                                                                CAP067 CAP083
203500200528     C*****TYPE          WHENEQ    'MMRPLD'                                            CAP067 CAP083
203600200528     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
203700200528     C****************** ADD       LDNILn        Bfp                                   CAP067 CAP083
203800200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP067 CAP083
203900200528     C****************** ADD       ESSRLn        Bfp                                   CAP067 CAP083
204000200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP067 CAP083
204100200528     C****************** ADD       ESSPLn        Bfp                                   CAP067 CAP083
204200200528     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                               CAP067 CAP083
204300200528     C****************** ADD       MMLILn        Bfp                                   CAP067 CAP083
204400200528     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
204500200528      *                                                                                CAP067 CAP083
204600200528      ***MM*REPOs*Depot*Movements*Detail                                               CAP067 CAP083
204700200528      *                                                                                CAP067 CAP083
204800200528     C*****TYPE          WHENEQ    'MMRPDM'                                            CAP067 CAP083
204900200528     C*****REP1Ln        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
205000200528     C****************** ADD       REP1Ln        Bfp                                   CAP067 CAP083
205100200528     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
205200200528      *                                                                                CAP067 CAP083
205300200528      ***MM*REPOs*Trailer*Detail**                                                     CAP067 CAP083
205400200528      *                                                                                CAP067 CAP083
205500200528     C*****TYPE          WHENEQ    'MMRPTR'                                            CAP067 CAP083
205600200528     C*****REP2Ln        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
205700200528     C****************** ADD       REP2Ln        Bfp                                   CAP067 CAP083
205800200528     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
205900200528      *                                                                                CAP067 CAP083
206000200528      ***SE*Buy-Sell*Trade***                                                          CAP067 CAP083
206100200528      *                                                                                CAP067 CAP083
206200200528     C*****TYPE          WHENEQ    'SEBYSL'                                            CAP067 CAP083
206300200528                                                                                       CAP067 CAP083
206400200528     C*****20            SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
206500200528     C****************** ADD       20            Bfp                                   CAP067 CAP083
206600200528     C****************** EVAL      %SUBST(TRANS1:21) = %SUBST(BUFFER:Bfp:TRPRLn)       CAP067 CAP083
206700200528     C****************** ADD       TRPRLn        Bfp                                   CAP067 CAP083
206800200528     C*****TRSELn        SUBST     BUFFER:Bfp    TRANS2                                CAP067 CAP083
206900200528     C****************** ADD       TRSELn        Bfp                                   CAP067 CAP083
207000200528     C*****TREXLn        SUBST     BUFFER:Bfp    TRANS3                                CAP067 CAP083
207100200528     C****************** ADD       TREXLn        Bfp                                   CAP067 CAP083
207200200528     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                                CAP067 CAP083
207300200528     C****************** ADD       TRSTLn        Bfp                                   CAP067 CAP083
207400200528     C*****TRCCLn        SUBST     BUFFER:Bfp    TRANS5                                CAP067 CAP083
207500200528     C****************** ADD       TRCCLn        Bfp                                   CAP067 CAP083
207600200528     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS6                                CAP067 CAP083
207700200528     C****************** ADD       TRSWLn        Bfp                                   CAP067 CAP083
207800200528     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS7                                CAP067 CAP083
207900200528     C****************** ADD       TRSWLn        Bfp                                   CAP067 CAP083
208000200528     C*****TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                CAS006 CAP083
208100200528     C**********         ADD       TRTHLn        Bfp                                   CAS006 CAP083
208200200528      *                                                                                CAP067 CAP083
208300200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP067 CAP083
208400200528      *                                                                                CAP067 CAP083
208500200528     C*****SETILn        SUBST     BUFFER:Bfp    InfData                               CAP067 CAP083
208600200528     C****************** ADD       SETILn        Bfp                                   CAP067 CAP083
208700200528     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
208800200528                                                                                       CAP067 CAP083
208900200528      ***SD*Yield*Rates*Details**                                                      CAS001 CAP083
209000200528                                                                                       CAS001 CAP083
209100200528     C*****TYPE          WHENEQ    'SDYRAT'                                            CAS001 CAP083
209200200528     C*****CAS001        ANDEQ     'Y'                                                 CAS001 CAP083
209300200528                                                                                       CAS001 CAP083
209400200528     C*****YRAT1Ln       SUBST     BUFFER:Bfp    TRANS1                                CAS001 CAP083
209500200528     C****************** ADD       YRAT1Ln       Bfp                                   CAS001 CAP083
209600200528     C*****YRAT2Ln       SUBST     BUFFER:Bfp    TRANS2                                CAS001 CAP083
209700200528     C****************** ADD       YRAT2Ln       Bfp                                   CAS001 CAP083
209800200528     C*****YRAT3Ln       SUBST     BUFFER:Bfp    TRANS3                                CAS001 CAP083
209900200528     C****************** ADD       YRAT3Ln       Bfp                                   CAS001 CAP083
210000200528     C*****YRAT4Ln       SUBST     BUFFER:Bfp    TRANS4                                CAS001 CAP083
210100200528     C****************** ADD       YRAT4Ln       Bfp                                   CAS001 CAP083
210200200528     C*****SDYRLn        SUBST     BUFFER:Bfp    ExtData                               CAS001 CAP083
210300200528                                                                                       CAP070 CAP083
210400200528      **LE*Assignments***                                                              CAP070 CAP083
210500200528                                                                                       CAP070 CAP083
210600200528     C*****TYPE          WHENEQ    'LEASGN'                                            CAP070 CAP083
210700200528                                                                                       CAP070 CAP083
210800200528     C*****ASGNLn        SUBST     BUFFER:Bfp    TRANS1                                CAP070 CAP083
210900200528     C****************** ADD       ASGNLn        Bfp                                   CAP070 CAP083
211000200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP070 CAP083
211100200528     C****************** ADD       ESSRLn        Bfp                                   CAP070 CAP083
211200200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP070 CAP083
211300200528     C****************** ADD       ESSPLn        Bfp                                   CAP070 CAP083
211400200528                                                                                       CAP070 CAP083
211500200528      **LE*Risk*Participants***                                                        CAP070 CAP083
211600200528                                                                                       CAP070 CAP083
211700200528     C*****TYPE          WHENEQ    'LERPRT'                                            CAP070 CAP083
211800200528                                                                                       CAP070 CAP083
211900200528     C*****RPRTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP070 CAP083
212000200528     C****************** ADD       RPRTLn        Bfp                                   CAP070 CAP083
212100200528     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP070 CAP083
212200200528     C****************** ADD       LIAB1Ln       Bfp                                   CAP070 CAP083
212300200528     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP070 CAP083
212400200528     C****************** ADD       LIAB2Ln       Bfp                                   CAP070 CAP083
212500200528     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP070 CAP083
212600200528     C****************** ADD       LIAZLn        Bfp                                   CAP070 CAP083
212700200528                                                                                       CAP068 CAP083
212800200528      **LE*Funding*Participants**                                                      CAP068 CAP083
212900200528                                                                                       CAP068 CAP083
213000200528     C*****TYPE          WHENEQ    'LEFPRT'                                            CAP068 CAP083
213100200528                                                                                       CAP068 CAP083
213200200528     C*****FPRTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP068 CAP083
213300200528     C****************** ADD       FPRTLn        Bfp                                   CAP068 CAP083
213400200528     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP068 CAP083
213500200528     C****************** ADD       LIAB1Ln       Bfp                                   CAP068 CAP083
213600200528     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP068 CAP083
213700200528     C****************** ADD       LIAB2Ln       Bfp                                   CAP068 CAP083
213800200528     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP068 CAP083
213900200528     C****************** ADD       LIAZLn        Bfp                                   CAP068 CAP083
214000200528                                                                                       CAP071 CAP083
214100200528      **LE*Facility*Amendments***                                                      CAP071 CAP083
214200200528                                                                                       CAP071 CAP083
214300200528     C*****TYPE          WHENEQ    'LEFAMD'                                            CAP071 CAP083
214400200528                                                                                       CAP071 CAP083
214500200528     C*****FAMDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP071 CAP083
214600200528     C****************** ADD       FAMDLn        Bfp                                   CAP071 CAP083
214700200528                                                                                       CAP072 CAP083
214800200528      **LE*Fee*Adjustment*input***                                                     CAP072 CAP083
214900200528                                                                                       CAP072 CAP083
215000200528     C*****TYPE          WHENEQ    'LEFEAD'                                            CAP072 CAP083
215100200528                                                                                       CAP072 CAP083
215200200528     C*****FEADLn        SUBST     BUFFER:Bfp    TRANS1                                CAP072 CAP083
215300200528     C****************** ADD       FEADLn        Bfp                                   CAP072 CAP083
215400200528                                                                                       CAP072 CAP083
215500200528      **LE*Fee*Settlement*input                                                        CAP072 CAP083
215600200528                                                                                       CAP072 CAP083
215700200528     C*****TYPE          WHENEQ    'LEFEST'                                            CAP072 CAP083
215800200528                                                                                       CAP072 CAP083
215900200528     C*****FESTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP072 CAP083
216000200528     C****************** ADD       FESTLn        Bfp                                   CAP072 CAP083
216100200528     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP072 CAP083
216200200528     C****************** ADD       LIAB1Ln       Bfp                                   CAP072 CAP083
216300200528     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP072 CAP083
216400200528     C****************** ADD       LIAB2Ln       Bfp                                   CAP072 CAP083
216500200528     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP072 CAP083
216600200528     C****************** ADD       LIAZLn        Bfp                                   CAP072 CAP083
216700200528                                                                                       CSC011 CAP083
216800200528      **LE*Facility*Input***                                                           CSC011 CAP083
216900200528                                                                                       CSC011 CAP083
217000200528     C*****TYPE          WHENEQ    'LEFCTY'                                            CSC011 CAP083
217100200528                                                                                       CSC011 CAP083
217200200528     C*****FCTY1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
217300200528     C****************** ADD       FCTY1Ln       Bfp                                   CSC011 CAP083
217400200528     C*****FCTY2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
217500200528     C****************** ADD       FCTY2Ln       Bfp                                   CSC011 CAP083
217600200528     C*****FCTY3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
217700200528     C****************** ADD       FCTY3Ln       Bfp                                   CSC011 CAP083
217800200528                                                                                       CSC011 CAP083
217900200528      **LE*Loans*Input***                                                              CSC011 CAP083
218000200528                                                                                       CSC011 CAP083
218100200528     C*****TYPE          WHENEQ    'LELOAN'                                            CSC011 CAP083
218200200528                                                                                       CSC011 CAP083
218300200528     C*****LOAN1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
218400200528     C****************** ADD       LOAN1Ln       Bfp                                   CSC011 CAP083
218500200528     C*****LOAN2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
218600200528     C****************** ADD       LOAN2Ln       Bfp                                   CSC011 CAP083
218700200528     C*****LOAN3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
218800200528     C****************** ADD       LOAN3Ln       Bfp                                   CSC011 CAP083
218900200528                                                                                       CSC011 CAP083
219000200528      **LE*Participations*Purchased*Input                                              CSC011 CAP083
219100200528                                                                                       CSC011 CAP083
219200200528     C*****TYPE          WHENEQ    'LEPTPU'                                            CSC011 CAP083
219300200528                                                                                       CSC011 CAP083
219400200528     C*****PTPU1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
219500200528     C****************** ADD       PTPU1Ln       Bfp                                   CSC011 CAP083
219600200528     C*****PTPU2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
219700200528     C****************** ADD       PTPU2Ln       Bfp                                   CSC011 CAP083
219800200528     C*****PTPU3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
219900200528     C****************** ADD       PTPU3Ln       Bfp                                   CSC011 CAP083
220000200528                                                                                       CSC011 CAP083
220100200528      **LE*Participations*Sold*Input                                                   CSC011 CAP083
220200200528                                                                                       CSC011 CAP083
220300200528     C*****TYPE          WHENEQ    'LEPTSO'                                            CSC011 CAP083
220400200528                                                                                       CSC011 CAP083
220500200528     C*****PTSO1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
220600200528     C****************** ADD       PTSO1Ln       Bfp                                   CSC011 CAP083
220700200528     C*****PTSO2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
220800200528     C****************** ADD       PTSO2Ln       Bfp                                   CSC011 CAP083
220900200528     C*****PTSO3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
221000200528     C****************** ADD       PTSO3Ln       Bfp                                   CSC011 CAP083
221100200528                                                                                       CSC011 CAP083
221200200528      **LE*Loan*Amendments*Input*-*Principal*Transfer*To                               CSC011 CAP083
221300200528                                                                                       CSC011 CAP083
221400200528     C*****TYPE          WHENEQ    'LELAPT'                                            CSC011 CAP083
221500200528                                                                                       CSC011 CAP083
221600200528     C*****LAPT1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
221700200528     C****************** ADD       LAPT1Ln       Bfp                                   CSC011 CAP083
221800200528     C*****LAPT2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
221900200528     C****************** ADD       LAPT2Ln       Bfp                                   CSC011 CAP083
222000200528                                                                                       CSC011 CAP083
222100200528      **LE*Loan*Amendments*Input*-*Principal*Transfer*From                             CSC011 CAP083
222200200528                                                                                       CSC011 CAP083
222300200528     C*****TYPE          WHENEQ    'LELAPF'                                            CSC011 CAP083
222400200528                                                                                       CSC011 CAP083
222500200528     C*****LAPF1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
222600200528     C****************** ADD       LAPF1Ln       Bfp                                   CSC011 CAP083
222700200528     C*****LAPF2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
222800200528     C****************** ADD       LAPF2Ln       Bfp                                   CSC011 CAP083
222900200528                                                                                       CSC011 CAP083
223000200528      **LE*Loan*Amendments*Input*-*Principal*Increase                                  CSC011 CAP083
223100200528                                                                                       CSC011 CAP083
223200200528     C*****TYPE          WHENEQ    'LELAPI'                                            CSC011 CAP083
223300200528                                                                                       CSC011 CAP083
223400200528     C*****LAPI1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
223500200528     C****************** ADD       LAPI1Ln       Bfp                                   CSC011 CAP083
223600200528     C*****LAPI2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
223700200528     C****************** ADD       LAPI2Ln       Bfp                                   CSC011 CAP083
223800200528                                                                                       CSC011 CAP083
223900200528      **LE*Loan*Amendments*Input*-*Base*Rate*Change                                    CSC011 CAP083
224000200528                                                                                       CSC011 CAP083
224100200528     C*****TYPE          WHENEQ    'LELABC'                                            CSC011 CAP083
224200200528                                                                                       CSC011 CAP083
224300200528     C*****LABC1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
224400200528     C****************** ADD       LABC1Ln       Bfp                                   CSC011 CAP083
224500200528     C*****LABC2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
224600200528     C****************** ADD       LABC2Ln       Bfp                                   CSC011 CAP083
224700200528                                                                                       CSC011 CAP083
224800200528      **LE*Loan*Amendments*Input*-*Spread*Change                                       CSC011 CAP083
224900200528                                                                                       CSC011 CAP083
225000200528     C*****TYPE          WHENEQ    'LELASC'                                            CSC011 CAP083
225100200528                                                                                       CSC011 CAP083
225200200528     C*****LASC1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
225300200528     C****************** ADD       LASC1Ln       Bfp                                   CSC011 CAP083
225400200528     C*****LASC2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
225500200528     C****************** ADD       LASC2Ln       Bfp                                   CSC011 CAP083
225600200528                                                                                       CSC011 CAP083
225700200528      **LE*Loan*Amendments*Input*-*Stop/Start*Accrual                                  CSC011 CAP083
225800200528                                                                                       CSC011 CAP083
225900200528     C*****TYPE          WHENEQ    'LELASA'                                            CSC011 CAP083
226000200528                                                                                       CSC011 CAP083
226100200528     C*****LASA1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
226200200528     C****************** ADD       LASA1Ln       Bfp                                   CSC011 CAP083
226300200528     C*****LASA2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
226400200528     C****************** ADD       LASA2Ln       Bfp                                   CSC011 CAP083
226500200528                                                                                       CSC011 CAP083
226600200528      **LE*Loan*Amendments*Input*-*Stop/Start*Accrual                                  CSC011 CAP083
226700200528                                                                                       CSC011 CAP083
226800200528     C*****TYPE          WHENEQ    'LELALS'                                            CSC011 CAP083
226900200528                                                                                       CSC011 CAP083
227000200528     C*****LALS1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
227100200528     C****************** ADD       LALS1Ln       Bfp                                   CSC011 CAP083
227200200528     C*****LALS2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
227300200528     C****************** ADD       LALS2Ln       Bfp                                   CSC011 CAP083
227400200528                                                                                       CSC011 CAP083
227500200528      **LE*Rollover*Input***                                                           CSC011 CAP083
227600200528                                                                                       CSC011 CAP083
227700200528     C*****TYPE          WHENEQ    'LEROLL'                                            CSC011 CAP083
227800200528                                                                                       CSC011 CAP083
227900200528     C*****ROLL1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
228000200528     C****************** ADD       ROLL1Ln       Bfp                                   CSC011 CAP083
228100200528     C*****ROLL2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
228200200528     C****************** ADD       ROLL2Ln       Bfp                                   CSC011 CAP083
228300200528                                                                                       CSC011 CAP083
228400200528      **LE*Manual*Repayment***                                                         CSC011 CAP083
228500200528                                                                                       CSC011 CAP083
228600200528     C*****TYPE          WHENEQ    'LELAMR'                                            CSC011 CAP083
228700200528                                                                                       CSC011 CAP083
228800200528     C*****LAMR1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
228900200528     C****************** ADD       LAMR1Ln       Bfp                                   CSC011 CAP083
229000200528     C*****LAMR2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
229100200528     C****************** ADD       LAMR2Ln       Bfp                                   CSC011 CAP083
229200200528                                                                                       CSC011 CAP083
229300200528      **LE*Fees*Input***                                                               CSC011 CAP083
229400200528                                                                                       CSC011 CAP083
229500200528     C*****TYPE          WHENEQ    'LEFEES'                                            CSC011 CAP083
229600200528                                                                                       CSC011 CAP083
229700200528     C*****FEES1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
229800200528     C****************** ADD       FEES1Ln       Bfp                                   CSC011 CAP083
229900200528     C*****FEES2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
230000200528     C****************** ADD       FEES2Ln       Bfp                                   CSC011 CAP083
230100200528                                                                                       CSC011 CAP083
230200200528      ***IR*Caps/Collars/Floors*Details                                                CAP055 CAP083
230300200528                                                                                       CAP055 CAP083
230400200528     C*****TYPE          WHENEQ    'IRCACF'                                            CAP055 CAP083
230500200528                                                                                       CAP055 CAP083
230600200528     C*****CACFLn        SUBST     BUFFER:Bfp    TRANS1                                CAP055 CAP083
230700200528     C****************** ADD       CACFLn        Bfp                                   CAP055 CAP083
230800200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP055 CAP083
230900200528     C****************** ADD       ESSRLn        Bfp                                   CAP055 CAP083
231000200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP055 CAP083
231100200528     C****************** ADD       ESSPLn        Bfp                                   CAP055 CAP083
231200200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP055 CAP083
231300200528     C****************** ADD       ESSFLn        Bfp                                   CAP055 CAP083
231400200528                                                                                       CAP056 CAP083
231500200528      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP056 CAP083
231600200528                                                                                       CAP056 CAP083
231700200528     C*****IRRPLn        SUBST     BUFFER:Bfp    InfData                               CAP056 CAP083
231800200528     C****************** ADD       IRRPLn        Bfp                                   CAP055 CAP083
231900200528     C*****CACXLn        SUBST     BUFFER:Bfp    ExtData                               CAP055 CAP083
232000200528                                                                                       CAP043 CAP083
232100200528      ***Principal*Change*Schedules*(Caps/Collars/Floors)                              CAP043 CAP083
232200200528                                                                                       CAP043 CAP083
232300200528     C*****TYPE          WHENEQ    'IRCAPC'                                            CAP043 CAP083
232400200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
232500200528                                                                                       CAP043 CAP083
232600200528      ***Principal*Change***                                                           CAP043 CAP083
232700200528                                                                                       CAP043 CAP083
232800200528     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
232900200528     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
233000200528     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
233100200528     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
233200200528     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
233300200528     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
233400200528     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
233500200528     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
233600200528                                                                                       CAP043 CAP083
233700200528      ***Trailer*record*(Caps/Collars/Floors)                                          CAP043 CAP083
233800200528                                                                                       CAP043 CAP083
233900200528     C*****TYPE          WHENEQ    'IRCATR'                                            CAP043 CAP083
234000200528     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
234100200528                                                                                       CAP043 CAP083
234200200528     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
234300200528     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
234400200528     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
234500200528     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
234600200528     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
234700200528     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
234800200528     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
234900200528     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
235000200528     C*****IRRPLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
235100200528     C****************** ADD       IRRPLn        Bfp                                   CAP043 CAP083
235200200528     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
235300200528      *                                                                                CAP042 CAP083
235400200528      ***SE*Movements*Details                                                          CSE039 CAP083
235500200528      *                                                                                CSE039 CAP083
235600200528     C*****TYPE          WHENEQ    'SEMVTS'                                            CSE039 CAP083
235700200528     C*****MVTSLn        SUBST     BUFFER:Bfp    TRANS1                                CSE039 CAP083
235800200528     C*******************ADD       MVTSLn        Bfp                                   CSE039 CAP083
235900200528     C*****MVEXLn        SUBST     BUFFER:Bfp    ExtData                               CSE039 CAP083
236000200528      *                                                                                CAP182 CAP083
236100200528      ***SE*Trade*Settlements*Details                                                  CAP182 CAP083
236200200528      *                                                                                CAP182 CAP083
236300200528     C*****TYPE          WHENEQ    'SETRSM'                                            CAP182 CAP083
236400200528     C*****TRSMLn        SUBST     BUFFER:Bfp    TRANS1                                CAP182 CAP083
236500200528     C*******************ADD       TRSMLn        Bfp                                   CAP182 CAP083
236600200528     C*****TREXLn        SUBST     BUFFER:Bfp    ExtData                               CAP182 CAP083
236700200528      *                                                                                CAP182 CAP083
236800200528      ***SE*Statement*Production*Requests                                              CSE040 CAP083
236900200528      *                                                                                CSE040 CAP083
237000200528     C*****TYPE          WHENEQ    'SESTPR'                                            CSE040 CAP083
237100200528     C*****STPRLn        SUBST     BUFFER:Bfp    TRANS1                                CSE040 CAP083
237200200528     C*******************ADD       STPRLn        Bfp                                   CSE040 CAP083
237300200528     C*****SPEXLn        SUBST     BUFFER:Bfp    ExtData                               CSE040 CAP083
237400200528     C*COPY*WNCPYSRC,APINCOMMC1                                                               CAP083
237500200528      *                                                                                CPK015 CAP083
237600200528      ***Any*unrecognised*message*types*are*written*to*the*error*file                  CPK015 CAP083
237700200528      *                                                                                CPK015 CAP083
237800200528     C************       OTHER                                                         CPK015 CAP083
237900200528     C************       WRITE     APEXCPERD0                                          CPK015 CAP083
238000200528     C************       COMMIT                                                        CPK015 CAP083
238100200528     C************       EVAL      Bypass = 'Y'                                        CPK015 CAP083
238200200528     C*******************ENDSL                                                  CAP035        CAP083
238300200528     C*******************ENDSL                                                         CGL032 243084
238400200528                                                                                CAP003
238500200528                                                                                CAP003
238600200528     C****************** ENDSR                                                  CAP003        CAP083
238700200528     C*******************ENDSR                                                         CGL032 243084
238800200528      ****************************************************************          CAP003
238900200528      /EJECT                                                                    CAP003
239000200528      ****************************************************************
239100200528      *                                                              *
239200200528      *  Wait for incoming messages                                  *
239300200528      *                                                              *
239400200528      ****************************************************************
239500200528     C     GETMSG        BEGSR
239600200528
239700200528      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
239800200528      ** Note: the last of these options means that a message longer than
239900200528      ** the buffer length defined in this module (currently 1500 bytes)
240000200528      ** will be read and removed from the queue.  Any data in the message
240100200528      ** after the 1500th byte will be lost.
240200200528     C                   Z-ADD     GMWT          GMOPT
240300200528     C                   ADD       GMCONV        GMOPT
240400200528     C                   ADD       GMATM         GMOPT
240500200528
240600200528      ** Set wait interval to infinite
240700200528     C                   Z-ADD     WIULIM        GMWI
240800200528     C/COPY WNCPYSRC,APH00077
240900200528
241000200528      ** Perform get operation inside commitment control. Commitment
241100200528      ** boundary is at the valid/invalid deals file. Any return
241200200528      ** MQ messages are also inside this commitment cycle.
241300200528     C                   ADD       GMSYP         GMOPT
241400200528
241500200528      ** MsgId and CorrelId are selectors cleared to ensure messages
241600200528      ** are processed in arrival/priority sequence
241700200528     C                   MOVEL     MINONE        MDMID
241800200528     C                   MOVEL     CINONE        MDCID
241900200528
242000200528      ** Clear message buffer
242100200528     C                   MOVEL     *BLANKS       BUFFER
242200200528
242300200528     C/COPY WNCPYSRC,APH00051
242400200528      ** Get message
242500200528     C**********         Z-ADD     MQGET         CID                                        MD041126
242600200528      **********                                                                            MD041126
242700200528     C**********         CALL      'QMQM'                                                   MD041126
242800200528     C**********         PARM                    CID               9 0                      MD041126
242900200528     C**********         PARM                    HCONN             9 0                      MD041126
243000200528     C**********         PARM                    HIN               9 0                      MD041126
243100200528     C**********         PARM                    MQMD                                       MD041126
243200200528     C**********         PARM                    MQGMO                                      MD041126
243300200528     C**********         PARM                    BUFLEN            9 0                      MD041126
243400200528     C**********         PARM                    BUFFER                                     MD041126
243500200528     C**********         PARM                    MESLEN            9 0                      MD041126
243600200528     C**********         PARM                    CCODE             9 0                      MD041126
243700200528     C**********         PARM                    REASON            9 0                      MD041126
243800200528      *                                                                                     MD041126
243900200528     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
244000200528     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
244100200528     C                                    MESLEN : CCODE : REASON )                         MD041126
244200200528      *                                                                                      248095A
244300200528      ** If connection handle not valid error, reconnect and try again                       248095A
244400200528      *                                                                                      248095A
244500200528     C     REASON        IFEQ      RC2018                                                    248095A
244600200528     C     REASON        OREQ      RC2019                                                    248095A
244700200528     C                   EXSR      CLQIN                                                     248095A
244800200528     C                   EXSR      MQDISCONNECT                                              248095A
244900200528     C                   EXSR      MQCONNECT                                                 248095A
245000200528     C/COPY WNCPYSRC,APH00078
245100200528     C                   Z-ADD     HANDLE        HCONN                                       248095A
245200200528     C                   EXSR      OPQIN                                                     248095A
245300200528     C/COPY WNCPYSRC,APH00052
245400200528     C**********         Z-ADD     MQGET         CID                                248095A MD041126
245500200528     C**********         CALL      'QMQM'                                           248095A MD041126
245600200528     C**********         PARM                    CID               9 0              248095A MD041126
245700200528     C**********         PARM                    HCONN             9 0              248095A MD041126
245800200528     C**********         PARM                    HIN               9 0              248095A MD041126
245900200528     C**********         PARM                    MQMD                               248095A MD041126
246000200528     C**********         PARM                    MQGMO                              248095A MD041126
246100200528     C**********         PARM                    BUFLEN            9 0              248095A MD041126
246200200528     C**********         PARM                    BUFFER                             248095A MD041126
246300200528     C**********         PARM                    MESLEN            9 0              248095A MD041126
246400200528     C**********         PARM                    CCODE             9 0              248095A MD041126
246500200528     C**********         PARM                    REASON            9 0              248095A MD041126
246600200528      *                                                                                     MD041126
246700200528     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
246800200528     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
246900200528     C                                    MESLEN : CCODE : REASON )                         MD041126
247000200528     C                   ENDIF                                                               248095A
247100200528
247200200528      ** Error processing
247300200528     C     REASON        IFNE      RCNONE
247400200528     C/COPY WNCPYSRC,APH00053
247500200528
247600200528      ** Send message to MOPERQ and QSYSOPR before crashing out
247700200528     C****************** MOVEL     ReadFailed    MQError                        138019
247800200528     C****************** MOVE      REASON        MQError                        138019
247900200528     C                   MOVE      REASON        ReasonA                        138019
248000200528     C                   EVAL      MQError = ReadFailed + ReasonA               138019
248100200528
248200200528     C                   CALLB     'ZAMSGTOOPR'
248300200528     C                   PARM                    MQReturn
248400200528     C                   PARM                    MQError
248500200528     C                   PARM                    DummyMsgID
248600200528     C                   PARM                    DummyMsgF
248700200528
248800200528      ** Shut down the program
248900200528     C                   EXSR      *pssr
249000200528
249100200528     C/COPY WNCPYSRC,APH00054
249200200528     C                   ENDIF
249300200528
249400200528     C                   ENDSR
249500200528      ****************************************************************
249600200528     C/COPY WNCPYSRC,APH00055
249700200528      /EJECT
249800200528      ****************************************************************
249900200528      *                                                              *
250000200528      *  Validate the profile & password                             *
250100200528      *                                                              *
250200200528      ****************************************************************
250300200528     C     ValPrfPwd     BEGSR
250400200528
250500200528      ** Decode the APPASSWORD field in preparation for the validation
250600200528     C                   EXSR      DECODE
250700200528
250800200528      ** The following call is an OS/400 API which will validate
250900200528      ** the incoming message parameters of UserId and Password.
251000200528      ** If the incoming details were valid, then the field QUSEI
251100200528      ** in the Error Code structure will be blank. The profile
251200200528      ** handle must be explicitly released.
251300200528      ** If the incoming details were invalid, then the message is
251400200528      ** logged to APUNAUTHPD, and a message is sent to QSYSOPR.
251500200528      ** Unauthorised information will not be logged to APOUTPUTPD, as
251600200528      ** this file is updated during the VALID8 subroutine.
251700200528
251800200528     C                   MOVE      *BLANKS       PrfHandle
251900200528     C                   RESET                   QUSEC
252000200528
252100200528     C                   CALL      'QSYGETPH'
252200200528     C                   PARM                    USERID
252300200528     C                   PARM                    PASSWORD
252400200528     C                   PARM                    PrfHandle        12
252500200528     C                   PARM                    QUSEC
252600200528
252700200528      ** The UserID and Password fields are now irrelevant, and are
252800200528      ** starred out to prevent them appearing on log files and dumps.
252900200528     C                   MOVE      '**********'  APPASSWORD
253000200528     C                   MOVE      '**********'  PASSWORD
253100200528
253200200528     C                   ENDSR
253300200528      /EJECT
253400200528      ****************************************************************
253500200528      *                                                              *
253600200528      *  Send Profile / Password error message                       *
253700200528      *                                                              *
253800200528      ****************************************************************
253900200528     C     PrfPwdErr     BEGSR
254000200528
254100200528      ** Send message to QSYSOPR warning of attempted unauthorised
254200200528      ** access to Midas APIs
254300200528
254400200528
254500200528     C                   CLEAR                   MQError
254600200528     C                   EVAL      MsgF = 'APMSGF'
254700200528     C                   IF        APUserID = *Blanks
254800200528     C                   EVAL      MsgID = 'API0002'
254900200528     C                   ELSE
255000200528     C                   EVAL      MsgID = 'API0001'
255100200528     C                   END
255200200528
255300200528     C                   CALLB     'ZAMSGTOOPR'
255400200528     C                   PARM                    MQReturn
255500200528     C                   PARM                    MQError
255600200528     C                   PARM                    MsgID
255700200528     C                   PARM                    MsgF
255800200528
255900200528     C                   OPEN      APUNAUTHPD
256000200528     C                   WRITE     APUNAUTHD0
256100200528     C                   CLOSE     APUNAUTHPD
256200200528
256300200528
256400200528      ** Commit the MQGET operation
256500200528     C                   COMMIT
256600200528
256700200528     C                   ENDSR
256800200528      ****************************************************************
256900200528      /EJECT
257000200528      ****************************************************************
257100200528      *                                                              *
257200200528      *  Decode the password field                                   *
257300200528      *                                                              *
257400200528      ****************************************************************
257500200528     C     DECODE        BEGSR
257600200528
257700200528     C                   MOVE      *BLANK        CURRCHAR          1
257800200528     C                   MOVE      *BLANKS       DECODED          10
257900200528     C                   Z-ADD     0             W                 1 0
258000200528     C                   Z-ADD     0             X                 3 0
258100200528     C                   Z-ADD     0             Y                 2 0
258200200528     C                   Z-ADD     1             Z                 2 0
258300200528      * W is 1 or 0 and says how blanks to pad the CAT to the decoded
258400200528      *  passwork with, depending upon whether the previous char was blank
258500200528      * X is the position in the clear or enciphered constant,
258600200528      * Y is a work field
258700200528      * Z is the position in the incoming (enciphered) password
258800200528
258900200528     C     Z             DOWLT     11
259000200528
259100200528      ** Get the next character in the password
259200200528     C     1             SUBST     PASSWORD:Z    CURRCHAR
259300200528
259400200528      ** Look up the cipher value
259500200528     C     CURRCHAR      SCAN      CIPHER        X
259600200528
259700200528      ** Ignore unrecognised characters
259800200528     C     X             IFNE      0
259900200528
260000200528     C     Z             MULT      2             Y
260100200528     C                   SUB       Y             X
260200200528     C     X             IFLE      0
260300200528     C                   ADD       63            X
260400200528     C                   ENDIF
260500200528
260600200528      ** Substitute in the correct value
260700200528     C     1             SUBST     CHARSET:X     CURRCHAR
260800200528
260900200528      ** Drop out if character is a blank
261000200528     C     CURRCHAR      IFEQ      *BLANK
261100200528     C                   LEAVE
261200200528     C                   ENDIF
261300200528     C                   ENDIF
261400200528
261500200528     C                   CAT       CURRCHAR:W    DECODED
261600200528
261700200528      ** Cater for special case of blanks
261800200528     C     CURRCHAR      IFEQ      *BLANK
261900200528     C                   Z-ADD     1             W
262000200528     C                   ELSE
262100200528     C                   Z-ADD     0             W
262200200528     C                   ENDIF
262300200528
262400200528     C                   ADD       1             Z
262500200528
262600200528     C                   ENDDO
262700200528
262800200528     C                   MOVEL     DECODED       PASSWORD
262900200528     C                   ENDSR
263000200528      ****************************************************************
263100200528      /EJECT
263200200528      ****************************************************************                        CAP083
263300200528      *                                                              *                        CAP083
263400200528      ***Get*Record Lengths of Transaction Data Blocks               *                        CAP083
263500200528      *                                                              *                        CAP083
263600200528      ****************************************************************                        CAP083
263700200528     C*****GETRCDLN      BEGSR                                                                CAP083
263800200528                                                                                              CAP083
263900200528     C*******************CALLB     'UTGETRCDLN'                                               CAP083
264000200528                                                                                              CAP083
264100200528      ***Return*code                                                                          CAP083
264200200528     C*******************PARM                    ReturnCode                                   CAP083
264300200528      ***Record*length                                                                        CAP083
264400200528     C*******************PARM      *ZERO         RecordLen         5 0                        CAP083
264500200528                                                                                              CAP083
264600200528      ***File*name                                                                            CAP083
264700200528     C*******************PARM                    FileName         10                          CAP083
264800200528      ***File*library                                                                         CAP083
264900200528     C*******************PARM      '*LIBL     '  FileLib          10                          CAP083
265000200528                                                                                              CAP083
265100200528      ***If*file not found (or any other error) shut down the program                  CPK015 CAP083
265200200528     C*****ReturnCode    Ifne      *Blanks                                             CPK015 CAP083
265300200528     C**********         EXSR      *pssr                                               CPK015 CAP083
265400200528     C**********         EndIf                                                         CPK015 CAP083
265500200528      **********                                                                       CPK015 CAP083
265600200528      ***Clear*the file name field to prevent it getting corrupted by           CAP031        CAP083
265700200528      ***later*MOVELs.                                                          CAP031        CAP083
265800200528     C*******************CLEAR                   FileName                       CAP031        CAP083
265900200528                                                                                              CAP083
266000200528     C*******************ENDSR                                                                CAP083
266100200528      ****************************************************************                        CAP083
266200200528      /EJECT                                                                                  CAP083
266300200528      ****************************************************************                 CGL032 243084
266400200528      ***Reinstate*GETRCDLN*subroutine********************************                 CGL032 243084
266500200528      ***Get*Record*Lengths*of*Transaction*Data*Blocks****************                 CGL032 243084
266600200528      **********                                                                       CGL032 243084
266700200528      ****************************************************************                 CGL032 243084
266800200528     C*****GETRCDLN      BEGSR                                                         CGL032 243084
266900200528      **********                                                                       CGL032 243084
267000200528     C**********         CALLB     'UTGETRCDLN'                                        CGL032 243084
267100200528      **********                                                                       CGL032 243084
267200200528      ***Return*code**************************************************                 CGL032 243084
267300200528     C**********         PARM                    ReturnCode                            CGL032 243084
267400200528      ***Record*length************************************************                 CGL032 243084
267500200528     C**********         PARM      *ZERO         RecordLen         5 0                 CGL032 243084
267600200528      **********                                                                       CGL032 243084
267700200528      ***File*name****************************************************                 CGL032 243084
267800200528     C**********         PARM                    FileName         10                   CGL032 243084
267900200528      ***File*library*************************************************                 CGL032 243084
268000200528     C**********         PARM      '*LIBL     '  FileLib          10                   CGL032 243084
268100200528      **********                                                                       CGL032 243084
268200200528      ***If*file*not*found*(or*any*other*error)*shut*down*the*program**                CGL032 243084
268300200528     C*****ReturnCode    Ifne      *Blanks                                             CGL032 243084
268400200528     C**********         EXSR      *pssr                                               CGL032 243084
268500200528     C**********         EndIf                                                         CGL032 243084
268600200528      **********                                                                       CGL032 243084
268700200528      ***Clear*the*file*name*field*to*prevent*it*getting*corrupted*by**                CGL032 243084
268800200528      ***later*MOVELs.*************************************************                CGL032 243084
268900200528     C**********         CLEAR                   FileName                              CGL032 243084
269000200528      **********                                                                       CGL032 243084
269100200528     C**********         ENDSR                                                         CGL032 243084
269200200528      *****************************************************************                CGL032 243084
269300200528      /EJECT                                                                           CGL032 243084
269400200528      ****************************************************************
269500200528      *                                                              *
269600200528      *  Initialisation                                              *
269700200528      *                                                              *
269800200528      ****************************************************************
269900200528     C     *INZSR        BEGSR
270000200528
270100200528      *  Lock allocation data area
270200200528
270300200528      *   The data area is allocated *SHRRD here.
270400200528      *   The function to submit this tries to get a *EXCL lock.
270500200528
270600200528      *                         Submitter
270700200528      *                 Lock      Lock     Submitter
270800200528      *      Status    Status   Successful   Action
270900200528      *      ------    ------   ---------- ---------
271000200528      *   Not running  None        Yes      Submit this
271100200528
271200200528      *   Running      *SHRRD      No        None
271300200528
271400200528     C                   CALLB     'APCALCOBJ'
271500200528     C                   PARM                    Object
271600200528     C                   PARM                    Lib
271700200528     C                   PARM                    ObjType
271800200528     C                   PARM                    LockStateS
271900200528     C                   PARM                    Member
272000200528     C                   PARM                    WaitTime
272100200528     C                   PARM                    Dlcobj
272200200528     C                   PARM                    Return
272300200528
272400200528      ** Set up input queue name for transactions
272500200528     C                   MOVEL     RootQueue     QIN
272600200528     C                   IN        SDSTAT
272700200528     C                   MOVE      LIBR          SysPrefix
272800200528
272900200528      ** Set up Midas SPF Environment
273000200528     C                   CALL      'SFC0401'
273100200528
273200200528      ** Create required QTEMP objects
273300200528     C                   CALL      'APCCRTQTO'
273400200528     C                   PARM                    ReturnCde        10
273500200528
273600200528      ** Check for success, else bomb
273700200528     C     ReturnCde     IFNE      *BLANKS
273800200528     C                   ENDIF
273900200528
274000200528      ** Use default connection handle, and implicit connection
274100200528     C                   Z-ADD     HCDEFH        HCONN
274200200528
274300200528      ** Set incoming message length
274400200528     C*******            Z-ADD     3000          BUFLEN                         CAP004
274500200528     C*******            Z-ADD     4000          BUFLEN                   CAP004182598
274600200528     C**********         Z-ADD     5000          BUFLEN                                182598 CIR003
274700200528     C**********         Z-ADD     6000          BUFLEN                                CIR003 CFT039
274800200528     C**********         Z-ADD     12000         BUFLEN                                CFT039 CSW213
274900200528     C                   Z-ADD     29997         BUFLEN                                       CSW213
275000200528
275100200528      ** Log job start-up in jobs file
275200200528     C                   OPEN      APIJOBL0
275300200528     C                   WRITE     JOBRCD
275400200528     C                   CLOSE     APIJOBL0
275500200528
275600200528      ** Set up the procedure/module/program names for calls to the
275700200528      **  validation modules
275800200528     C                   EVAL      #ProcPgm  = PSProcPgm
275900200528     C                   EVAL      #ProcMod  = PSProcMod
276000200528     C                   EVAL      #ProcName = PSProcName
276100200528
276200200528      ** Call CL to start commitment control
276300200528     C                   CALLB     'ZACSCMTCTL'
276400200528
276500200528      ** Access API ICD via access program
276600200528      *  (database error handling done in access program)
276700200528     C                   CALLB     'AOAPIR0'
276800200528     C                   PARM      '*DBERR '     @RTCD             7
276900200528     C                   PARM      '*FIRST '     @OPTN             7
277000200528     C     SDAPI         PARM      SDAPI         DSFDY
277100200528     C/COPY WNCPYSRC,APH00056
277200200528
277300200528      ***Determine*API*Header record lengths                                                  CAP083
277400200528                                                                                              CAP083
277500200528     C*******************MOVEL     'APHEADPD'    FileName                                     CAP083
277600200528     C*******************EXSR      GETRCDLN                                                   CAP083
277700200528     C*******************Z-ADD     RecordLen     HEADLn            4 0                        CAP083
277800200528                                                                                              CAP083
277900200528      ***Determine*transaction data record lengths                                            CAP083
278000200528                                                                                              CAP083
278100200528      ***(Dealing)*Extended Payment Instructions                                              CAP083
278200200528                                                                                              CAP083
278300200528     C*******************MOVEL     'SDESSPPD'    FileName                                     CAP083
278400200528     C*******************EXSR      GETRCDLN                                                   CAP083
278500200528     C*******************Z-ADD     RecordLen     ESSPLn            4 0                        CAP083
278600200528                                                                                              CAP083
278700200528      ***(Dealing)*Extended Receive Instructions                                              CAP083
278800200528                                                                                              CAP083
278900200528     C*******************MOVEL     'SDESSRPD'    FileName                                     CAP083
279000200528     C*******************EXSR      GETRCDLN                                                   CAP083
279100200528     C*******************Z-ADD     RecordLen     ESSRLn            4 0                        CAP083
279200200528                                                                                              CAP083
279300200528      ***(Dealing)*Extended FRA/IRS Instructions                                              CAP083
279400200528                                                                                              CAP083
279500200528     C*******************MOVEL     'SDESSFPD'    FileName                                     CAP083
279600200528     C*******************EXSR      GETRCDLN                                                   CAP083
279700200528     C*******************Z-ADD     RecordLen     ESSFLn            4 0                        CAP083
279800200528                                                                                              CAP083
279900200528      ***FX*deals                                                                             CAP083
280000200528                                                                                              CAP083
280100200528     C*******************MOVEL     'FXFXDLPD'    FileName                                     CAP083
280200200528     C*******************EXSR      GETRCDLN                                                   CAP083
280300200528     C*******************Z-ADD     RecordLen     FXDLLn            4 0                        CAP083
280400200528                                                                                              CAP083
280500200528      ***Loans/deposits                                                                       CAP083
280600200528                                                                                              CAP083
280700200528     C*******************MOVEL     'MMLDNIPD'    FileName                                     CAP083
280800200528     C*******************EXSR      GETRCDLN                                                   CAP083
280900200528     C*******************Z-ADD     RecordLen     LDNILn            4 0                        CAP083
281000200528
281100200528      ***Check*if*CDL006*enhancement*is*installed***                                   209905 CAP083
281200200528                                                                                       209905 CAP083
281300200528     C****************** CALLB     'AOSARDR0'                                          209905 CAP083
281400200528     C****************** PARM      *BLANKS       PRtCd                                 209905 CAP083
281500200528     C****************** PARM      '*VERIFY'     POptn                                 209905 CAP083
281600200528     C****************** PARM      'CDL006'      PSarD                                 209905 CAP083
281700200528     C*****SCSARD        PARM      SCSARD        DSFDY                                 209905 CAP083
281800200528                                                                                       209905 CAP083
281900200528     C*****PRtCd         IFEQ      *BLANK                                              209905 CAP083
282000200528     C****************** MOVEL     'Y'           CDL006                                209905 CAP083
282100200528     C****************** ELSE                                                          209905 CAP083
282200200528     C****************** MOVEL     'N'           CDL006                                209905 CAP083
282300200528     C****************** ENDIF                                                         209905 CAP083
282400200528                                                                                              CAP083
282500200528     C***********        IF        CDL006 = 'Y'                                        209905 CAP083
282600200528                                                                                       209905 CAP083
282700200528     C***********        CLEAR                   FileName                              209905 CAP083
282800200528     C***********        MOVEL     'MMFIDT1PD'   FileName                              209905 CAP083
282900200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
283000200528     C***********        Z-ADD     RecordLen     WFIDT1Ln                              209905 CAP083
283100200528     C***********        MOVEL     'MMFIDT2PD'   FileName                              209905 CAP083
283200200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
283300200528     C***********        Z-ADD     RecordLen     WFIDT2Ln                              209905 CAP083
283400200528     C***********        MOVEL     'MMFIDT3PD'   FileName                              209905 CAP083
283500200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
283600200528     C***********        Z-ADD     RecordLen     WFIDT3Ln                              209905 CAP083
283700200528     C***********        MOVEL     'MMFIDT4PD'   FileName                              209905 CAP083
283800200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
283900200528     C***********        Z-ADD     RecordLen     WFIDT4Ln                              209905 CAP083
284000200528     C***********        MOVEL     'MMFIDT5PD'   FileName                              209905 CAP083
284100200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
284200200528     C***********        Z-ADD     RecordLen     WFIDT5Ln                              209905 CAP083
284300200528     C***********        MOVEL     'MMFIDT6PD'   FileName                              209905 CAP083
284400200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
284500200528     C***********        Z-ADD     RecordLen     WFIDT6Ln                              209905 CAP083
284600200528     C***********        MOVEL     'MMFIDT7PD'   FileName                              209905 CAP083
284700200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
284800200528     C***********        Z-ADD     RecordLen     WFIDT7Ln                              209905 CAP083
284900200528     C***********        MOVEL     'MMFIDT8PD'   FileName                              209905 CAP083
285000200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
285100200528     C***********        Z-ADD     RecordLen     WFIDT8Ln                              209905 CAP083
285200200528     C***********        MOVEL     'MMFIDT9PD'   FileName                              209905 CAP083
285300200528     C***********        EXSR      GETRCDLN                                            209905 CAP083
285400200528     C***********        Z-ADD     RecordLen     WFIDT9Ln                              209905 CAP083
285500200528                                                                                       209905 CAP083
285600200528     C***********        ENDIF                                                         209905 CAP083
285700200528                                                                                       209905 CAP083
285800200528      ***Deal*Amendments                                                                      CAP083
285900200528                                                                                              CAP083
286000200528     C*******************MOVEL     'MMDEAMPD'    FileName                                     CAP083
286100200528     C*******************EXSR      GETRCDLN                                                   CAP083
286200200528     C*******************Z-ADD     RecordLen     DEAMLn            4 0                        CAP083
286300200528                                                                                              CAP083
286400200528      ***NAs*Purchased                                                                        CAP083
286500200528                                                                                              CAP083
286600200528     C*******************MOVEL     'MMNASPPD'    FileName                                     CAP083
286700200528     C*******************EXSR      GETRCDLN                                                   CAP083
286800200528     C*******************Z-ADD     RecordLen     NASPLn            4 0                        CAP083
286900200528                                                                                              CAP083
287000200528      ***NAs*Sold                                                                             CAP083
287100200528                                                                                              CAP083
287200200528     C*******************MOVEL     'MMNASSPD'    FileName                                     CAP083
287300200528     C*******************EXSR      GETRCDLN                                                   CAP083
287400200528     C*******************Z-ADD     RecordLen     NASSLn            4 0                        CAP083
287500200528                                                                                              CAP083
287600200528      ***Forward*Rate Agreements                                                              CAP083
287700200528                                                                                              CAP083
287800200528     C*******************MOVEL     'IRFRAPD '    FileName                                     CAP083
287900200528     C*******************EXSR      GETRCDLN                                                   CAP083
288000200528     C*******************Z-ADD     RecordLen     FRALn             4 0                        CAP083
288100200528                                                                                              CAP083
288200200528      ***Single*Currency Interest Rate Swaps                                                  CAP083
288300200528                                                                                              CAP083
288400200528     C*******************MOVEL     'IRSIRSPD'    FileName                                     CAP083
288500200528     C*******************EXSR      GETRCDLN                                                   CAP083
288600200528     C*******************Z-ADD     RecordLen     SIRSLn            4 0                        CAP083
288700200528     C*******************MOVEL     'IRDTSCPD'    FileName                       CAP004        CAP083
288800200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
288900200528     C*******************Z-ADD     RecordLen     DTORLn            4 0          CAP004        CAP083
289000200528     C*******************Z-ADD     RecordLen     DTOPLn            4 0          CAP004        CAP083
289100200528     C*******************Z-ADD     RecordLen     DTTRLn            4 0          CAP004        CAP083
289200200528     C*******************Z-ADD     RecordLen     DTTPLn            4 0          CAP004        CAP083
289300200528                                                                                              CAP083
289400200528      ***Cross*Currency Interest Rate Swaps                                                   CAP083
289500200528                                                                                              CAP083
289600200528     C*******************MOVEL     'IRCIRSPD'    FileName                                     CAP083
289700200528     C*******************EXSR      GETRCDLN                                                   CAP083
289800200528     C*******************Z-ADD     RecordLen     CIRSLn            4 0                        CAP083
289900200528     C*******************MOVEL     'IRDTSCPD'    FileName                       CAP004        CAP083
290000200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
290100200528     C*******************Z-ADD     RecordLen     DTORLn            4 0          CAP004        CAP083
290200200528     C*******************Z-ADD     RecordLen     DTOPLn            4 0          CAP004        CAP083
290300200528     C*******************Z-ADD     RecordLen     DTTRLn            4 0          CAP004        CAP083
290400200528     C*******************Z-ADD     RecordLen     DTTPLn            4 0          CAP004        CAP083
290500200528                                                                                CAP003        CAP083
290600200528      ***SE*Trade: Primary, Secondary, Exchange Rates, Settlement Details,      CAP003        CAP083
290700200528      **           Charges & Commissions, SWIFT Details                                       CAP083
290800200528                                                                                CAP003        CAP083
290900200528     C*******************MOVEL     'SETRPRPD'    FileName                       CAP003        CAP083
291000200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
291100200528     C*******************Z-ADD     RecordLen     TRPRLn            4 0          CAP003        CAP083
291200200528     C*******************MOVEL     'SETRSEPD'    FileName                       CAP003        CAP083
291300200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
291400200528     C*******************Z-ADD     RecordLen     TRSELn            4 0          CAP003        CAP083
291500200528     C**********         MOVEL     'SETRTHPD'    FileName                              CAS006 CAP083
291600200528     C**********         EXSR      GETRCDLN                                            CAS006 CAP083
291700200528     C**********         Z-ADD     RecordLen     TRTHLn            4 0                 CAS006 CAP083
291800200528     C**********         MOVEL     'SETREXPD'    FileName                 CAP003175717
291900200528     C**********         MOVEL     'SETDEXPD'    FileName                              175717 CAP067
292000200528     C*******************MOVEL     'SETREXPD'    FileName                              CAP067 CAP083
292100200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
292200200528     C*******************Z-ADD     RecordLen     TREXLn            4 0          CAP003        CAP083
292300200528     C*******************MOVEL     'SETRSTPD'    FileName                       CAP003        CAP083
292400200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
292500200528     C*******************Z-ADD     RecordLen     TRSTLn            4 0          CAP003        CAP083
292600200528     C*******************MOVEL     'SETRCCPD'    FileName                       CAP003        CAP083
292700200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
292800200528     C*******************Z-ADD     RecordLen     TRCCLn            4 0          CAP003        CAP083
292900200528     C*******************MOVEL     'SETRSWPD'    FileName                       CAP003        CAP083
293000200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
293100200528     C*******************Z-ADD     RecordLen     TRSWLn            4 0          CAP003        CAP083
293200200528                                                                                CAP003        CAP083
293300200528      ***SE*Walk In Depot Movement                                              CAP003        CAP083
293400200528                                                                                CAP003        CAP083
293500200528     C*******************MOVEL     'SEDMWIPD'    FileName                       CAP003        CAP083
293600200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
293700200528     C*******************Z-ADD     RecordLen     DMWILn            4 0          CAP003        CAP083
293800200528                                                                                CAP003        CAP083
293900200528      ***SE*Walk Out Depot Movement                                             CAP003        CAP083
294000200528                                                                                CAP003        CAP083
294100200528     C*******************MOVEL     'SEDMWOPD'    FileName                       CAP003        CAP083
294200200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
294300200528     C*******************Z-ADD     RecordLen     DMWOLn            4 0          CAP003        CAP083
294400200528                                                                                CAP004        CAP083
294500200528      ***AB*Internal Contracts                                                  CAP004        CAP083
294600200528                                                                                CAP004        CAP083
294700200528     C*******************MOVEL     'ABINTCPD'    FileName                       CAP004        CAP083
294800200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
294900200528     C*******************Z-ADD     RecordLen     INTCLn            4 0          CAP004        CAP083
295000200528                                                                                CAP003        CAP083
295100200528      ***FF*Exchange-traded*futures*and*options:*comprises*the*transactionCAP003CAP004
295200200528      ***length*plus*the*broker*settlements*length*plus*the*customer***   CAP003CAP004
295300200528      ***settlements*length.*******************************************   CAP003CAP004
295400200528      ***FF*Exchange-traded futures and options: comprises transaction          CAP004        CAP083
295500200528      ***details,*broker settlements details and customer settlements           CAP004        CAP083
295600200528      ***details.                                                               CAP004        CAP083
295700200528     C*******************MOVEL     'FFEXTRPD'    FileName                       CAP003        CAP083
295800200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
295900200528     C*******************Z-ADD     RecordLen     EXTRLn            4 0          CAP003        CAP083
296000200528                                                                                CAP003        CAP083
296100200528     C*******************MOVEL     'FFBSETPD'    FileName                       CAP003        CAP083
296200200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
296300200528     C**********         ADD       RecordLen     EXTRLn                   CAP003CAP004
296400200528     C**********         ADD       RecordLen     BSETLn            4 0    CAP004186715
296500200528     C*******************Z-ADD     RecordLen     BSETLn            4 0          186715        CAP083
296600200528                                                                                CAP003        CAP083
296700200528     C*******************MOVEL     'FFCSETPD'    FileName                       CAP003        CAP083
296800200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
296900200528     C**********         ADD       RecordLen     EXTRLn                   CAP003CAP004
297000200528     C**********         ADD       RecordLen     CSETLn            4 0    CAP004186715
297100200528     C*******************Z-ADD     RecordLen     CSETLn            4 0          186715        CAP083
297200200528                                                                                CAP003        CAP083
297300200528      ***FF*Currency*over-the-counter*options*comprises*the*transaction   CAP003CAP004
297400200528      ***length*plus*the*broker*settlements*length*plus*the*customer***   CAP003CAP004
297500200528      ***settlements*length.*******************************************   CAP003CAP004
297600200528      ***FF*Currency over-the-counter options: comprises transaction            CAP004        CAP083
297700200528      ***details*and customer settlements details (the latter length is         CAP004        CAP083
297800200528      ***determined*above).                                                     CAP004        CAP083
297900200528     C*******************MOVEL     'FFOTCCPD'    FileName                       CAP003        CAP083
298000200528     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
298100200528     C*******************Z-ADD     RecordLen     OTCCLn            4 0          CAP003        CAP083
298200200528                                                                                CAP004        CAP083
298300200528     C**********         MOVEL     'FFBSETPD'    FileName                 CAP003CAP004
298400200528     C**********         EXSR      GETRCDLN                               CAP003CAP004
298500200528     C**********         ADD       RecordLen     OTCCLn                   CAP003CAP004
298600200528      **********                                                          CAP003CAP004
298700200528     C**********         MOVEL     'FFCSETPD'    FileName                 CAP003CAP004
298800200528     C**********         EXSR      GETRCDLN                               CAP003CAP004
298900200528     C**********         ADD       RecordLen     OTCCLn                   CAP003CAP004
299000200528                                                                                       CAP166 CAP083
299100200528      ** FF*non-currency*over-the-counter*options:*comprises*transaction               CAP166 CAP083
299200200528      ** details*and*customer*settlements*details*(the*latter*length*is                CAP166 CAP083
299300200528      ***determined*above).****                                                        CAP166 CAP083
299400200528                                                                                       CAP166 CAP083
299500200528     C***********        MOVEL     'FFOTCOPD'    FileName                              CAP166 CAP083
299600200528     C***********        EXSR      GETRCDLN                                            CAP166 CAP083
299700200528     C***********        Z-ADD     RecordLen     OTCOLn            4 0                 CAP166 CAP083
299800200528                                                                                CAP005        CAP083
299900200528      ***Forward*Rates                                                          CAP005        CAP083
300000200528                                                                                CAP005        CAP083
300100200528     C*******************MOVEL     'FDFWRTPD'    FileName                       CAP005        196570
300200200528     C*******************EXSR      GETRCDLN                                     CAP005        196570
300300200528     C*******************Z-ADD     RecordLen     FWRTLn            4 0          CAP005        196570
300400200528     C*******************MOVEL     'FDFWRT1PD'   FileName                              196570 CAP083
300500200528     C*******************EXSR      GETRCDLN                                            196570 CAP083
300600200528     C*******************Z-ADD     RecordLen     FWRT1Ln           4 0                 196570 CAP083
300700200528     C*******************MOVEL     'FDFWRT2PD'   FileName                              196570 CAP083
300800200528     C*******************EXSR      GETRCDLN                                            196570 CAP083
300900200528     C*******************Z-ADD     RecordLen     FWRT2Ln           4 0                 196570 CAP083
301000200528                                                                                CAP005
301100200528      ***Money*Market Rates                                                                   CAP083
301200200528      ***********                                                               CAP005        214637
301300200528     C***********        MOVEL     'FDINTR1PD'   FileName                       CAP005        214637
301400200528     C***********        EXSR      GETRCDLN                                     CAP005        214637
301500200528     C***********        Z-ADD     RecordLen     INTR1Ln           4 0          CAP005        214637
301600200528     C***********        MOVEL     'FDINTR2PD'   FileName                       CAP005        214637
301700200528     C***********        EXSR      GETRCDLN                                     CAP005        214637
301800200528     C***********        Z-ADD     RecordLen     INTR2Ln           4 0          CAP005        214637
301900200528     C***********        MOVEL     'FDINTRPD'    FileName                              214637 CAP083
302000200528     C***********        EXSR      GETRCDLN                                            214637 CAP083
302100200528     C***********        Z-ADD     500           INTR1Ln           4 0                 214637 CAP083
302200200528     C***********Len     SUB       500           INTR2Ln           4 0                 214637 CAP083
302300200528                                                                                              CAP083
302400200528      ***FT*Outgoing Payment : First, Second, Third and Fourth Details          CAP031        CAP083
302500200528      **                     : Fifth, Sixth, Seventh and Eighth                 CFT014        CAP083
302600200528                                                                                CAP031        CAP083
302700200528     C*******************MOVEL     'FTOPY1PD'    FileName                       CAP031        CAP083
302800200528     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
302900200528     C*******************Z-ADD     RecordLen     OPY1Ln            4 0          CAP031        CAP083
303000200528     C***********        MOVEL     'FTOPY2PD'    FileName                       CAP031 CFT014
303100200528     C*******************MOVEL     'FTOPY1APD'   FileName                       CFT014        CAP083
303200200528     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
303300200528     C*******************Z-ADD     RecordLen     OPY2Ln            4 0          CAP031        CAP083
303400200528     C***********        MOVEL     'FTOPY3PD'    FileName                       CAP031 CFT014
303500200528     C*******************MOVEL     'FTOPY2PD'    FileName                       CFT014        CAP083
303600200528     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
303700200528     C*******************Z-ADD     RecordLen     OPY3Ln            4 0          CAP031        CAP083
303800200528     C***********        MOVEL     'FTOPY4PD'    FileName                       CAP031 CFT014
303900200528     C*******************MOVEL     'FTOPY3PD'    FileName                       CFT014        CAP083
304000200528     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
304100200528     C*******************Z-ADD     RecordLen     OPY4Ln            4 0          CAP031        CAP083
304200200528     C*******************MOVEL     'FTOPY4PD'    FileName                       CFT014        CAP083
304300200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
304400200528     C*******************Z-ADD     RecordLen     OPY5Ln            4 0          CFT014        CAP083
304500200528     C*******************MOVEL     'FTOPY5PD'    FileName                       CFT014        CAP083
304600200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
304700200528     C*******************Z-ADD     RecordLen     OPY6Ln            4 0          CFT014        CAP083
304800200528     C*******************MOVEL     'FTOPY6PD'    FileName                       CFT014        CAP083
304900200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
305000200528     C*******************Z-ADD     RecordLen     OPY7Ln            4 0          CFT014        CAP083
305100200528     C*******************MOVEL     'FTOPY7PD'    FileName                       CFT014        CAP083
305200200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
305300200528     C*******************Z-ADD     RecordLen     OPY8Ln            4 0          CFT014        CAP083
305400200528                                                                                CAP031        CAP083
305500200528      ***SD*Customers: Primary, Secondary, Message Routing,                     CAP034        CAP083
305600200528      **               Base Rate Tax details and Private Banking                CAP034        CAP083
305700200528                                                                                CAP034        CAP083
305800200528     C*******************MOVEL     'SDCUPRPD'    FileName                       CAP034        CAP083
305900200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
306000200528     C*******************Z-ADD     RecordLen     CUPRLn            4 0          CAP034        CAP083
306100200528     C*******************MOVEL     'SDCUSEPD'    FileName                       CAP034        CAP083
306200200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
306300200528     C*******************Z-ADD     RecordLen     CUSELn            4 0          CAP034        CAP083
306400200528     C*******************MOVEL     'SDCUMTPD'    FileName                              CSW024 CAP083
306500200528     C*******************EXSR      GETRCDLN                                            CSW024 CAP083
306600200528     C*******************Z-ADD     RecordLen     CUMTLn            4 0                 CSW024 CAP083
306700200528     C*******************MOVEL     'SDCUMRPD'    FileName                       CAP034        CAP083
306800200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
306900200528     C*******************Z-ADD     RecordLen     CUMRLn            4 0          CAP034        CAP083
307000200528     C*******************MOVEL     'SDCUBRPD'    FileName                       CAP034        CAP083
307100200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
307200200528     C*******************Z-ADD     RecordLen     CUBRLn            4 0          CAP034        CAP083
307300200528     C*******************Z-ADD     500           CUBR1Ln           4 0          CAP034        CAP083
307400200528     C*****Recordlen     SUB       CUBR1Ln       CUBR2Ln           4 0          CAP034        CAP083
307500200528     C*******************MOVEL     'SDCUPBPD'    FileName                       CAP034        CAP083
307600200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
307700200528     C*******************Z-ADD     RecordLen     CUPBLn            4 0          CAP034        CAP083
307800200528                                                                                CAP034        CAP083
307900200528      ***GL*Accounts maintenance : Master, Debit interests, Credit interests    CAP035        CAP083
308000200528      **               Commissions & Overdraft charges and Other details        CAP035        CAP083
308100200528                                                                                CAP035        CAP083
308200200528     C*******************MOVEL     'GLAMADPD'    FileName                       CAP035        CAP083
308300200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
308400200528     C*******************Z-ADD     RecordLen     AMMDLn            4 0          CAP035        CAP083
308500200528     C*******************MOVEL     'GLAMDIPD'    FileName                       CAP035        CAP083
308600200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
308700200528     C*******************Z-ADD     RecordLen     AMDILn            4 0          CAP035        CAP083
308800200528     C*******************MOVEL     'GLAMCIPD'    FileName                       CAP035        CAP083
308900200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
309000200528     C*******************Z-ADD     RecordLen     AMCILn            4 0          CAP035        CAP083
309100200528     C*******************MOVEL     'GLAMCOPD'    FileName                       CAP035        CAP083
309200200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
309300200528     C*******************Z-ADD     RecordLen     AMCOLn            4 0          CAP035        CAP083
309400200528     C*******************MOVEL     'GLAMODPD'    FileName                       CAP035        CAP083
309500200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
309600200528     C*******************Z-ADD     RecordLen     AMODLn            4 0          CAP035        CAP083
309700200528                                                                                CAP035        CAP083
309800200528      ***SD*Security Customer Details:                                          CAP039        CAP083
309900200528                                                                                CAP039        CAP083
310000200528     C*******************MOVEL     'SDSECDPD'    FileName                       CAP039        CAP083
310100200528     C*******************EXSR      GETRCDLN                                     CAP039        CAP083
310200200528     C*******************Z-ADD     RecordLen     SECDLn            4 0          CAP039        CAP083
310300200528                                                                                CAP039        CAP083
310400200528     ****SD*Other Depot Details layout file for APIs                                   CSE022 CAP083
310500200528     ****(Set*this to the length of the expected message length)                       CSE022 CAP083
310600200528     C*******************Z-ADD     4755          SDSOLn                                CSE022 CAP083
310700200528      *                                                                                CAP140 CAP083
310800200528      ***Get*record length of Data Layout files for SE Security                        CAP140 CAP083
310900200528      ***Diary*Events API.                                                             CAP140 CAP083
311000200528      *                                                                                CAP140 CAP083
311100200528     C*******************MOVEL     'SESEDEPD'    FileName                              CAP140 CAP083
311200200528     C*******************EXSR      GETRCDLN                                            CAP140 CAP083
311300200528     C*******************Z-ADD     RecordLen     SEDELn                                CAP140 CAP083
311400200528      *                                                                                CAP140 CAP083
311500200528      ***Get*record length of Extra Data Layout file for SE                            CAP140 CAP083
311600200528      ***Security*Diary Events - API                                                   CAP140 CAP083
311700200528      *                                                                                CAP140 CAP083
311800200528     C*******************MOVEL     'SESDEXPD  '  Filename                              CAP140 CAP083
311900200528     C*******************EXSR      GETRCDLN                                            CAP140 CAP083
312000200528     C*******************Z-ADD     Recordlen     SDEXLn                                CAP140 CAP083
312100200528                                                                                       CAP140 CAP083
312200200528      ***Get*record*length*of*Data*Layout*files*for*SD*Additional******                CGL032 243084
312300200528      ***Customer*Details.*Default*Extra*Data*length*to*500.***********                CGL032 243084
312400200528      **********                                                                       CGL032 243084
312500200528     C**********         MOVEL     'SDACUDPD'    FileName                              CGL032 243084
312600200528     C**********         EXSR      GETRCDLN                                            CGL032 243084
312700200528     C**********         Z-ADD     RecordLen     ACUDLn                                CGL032 243084
312800200528     C**********         Z-ADD     500           ACEXLn                                CGL032 243084
312900200528      **********                                                                       CGL032 243084
313000200528      ***Get*record*length*of*Data*Layout*files*for*SD*Non-A/C*********                CGL032 243084
313100200528      ***Holders*API.*Default*Extra*Data*length*to*500.****************                CGL032 243084
313200200528      **********                                                                       CGL032 243084
313300200528     C**********         MOVEL     'SDNAHLPD'    FileName                              CGL032 243084
313400200528     C**********         EXSR      GETRCDLN                                            CGL032 243084
313500200528     C**********         Z-ADD     RecordLen     SDNALn                                CGL032 243084
313600200528     C**********         Z-ADD     500           NaEXLn                                CGL032 243084
313700200528      **********                                                                       CGL032 243084
313800200528      ***Get*record*length*of*Data*Layout*files*for*SD*Customer********                CGL032 243084
313900200528      ***Details*by*Country*of*Tax*API.********************************                CGL032 243084
314000200528      **********                                                                       CGL032 243084
314100200528     C**********         MOVEL     'SDCCTXPD'    FileName                              CGL032 243084
314200200528     C**********         EXSR      GETRCDLN                                            CGL032 243084
314300200528     C**********         Z-ADD     RecordLen     CCTXLn                                CGL032 243084
314400200528      **********                                                                       CGL032 243084
314500200528      ***Get*record*length*of*Data*Layout*files*for*SD*Customer********                CGL032 243084
314600200528      ***Details*by*Country*of*Tax*API.********************************                CGL032 243084
314700200528      **********                                                                       CGL032 243084
314800200528     C**********         MOVEL     'SDNATXPD'    FileName                              CGL032 243084
314900200528     C**********         EXSR      GETRCDLN                                            CGL032 243084
315000200528     C**********         Z-ADD     RecordLen     NATXLn                                CGL032 243084
315100200528      **********                                                                       CGL032 243084
315200200528      ***Get*record*length*of*Data*Layout*files*for*SD*Joint*A/c*******                CGL032 243084
315300200528      ***Member*Details*API.*******************************************                CGL032 243084
315400200528      **********                                                                       CGL032 243084
315500200528     C**********         MOVEL     'SDJACMPD'    FileName                              CGL032 243084
315600200528     C**********         EXSR      GETRCDLN                                            CGL032 243084
315700200528     C**********         Z-ADD     RecordLen     JACMLn                                CGL032 243084
315800200528      **********                                                                       CGL032 243084
315900200528      ***SD*Market Data Feeds Spot Rate Details                                        CAP057 CAP083
316000200528                                                                                       CAP057 CAP083
316100200528     C*******************MOVEL     'SDSPTRPD'    FileName                              CAP057 CAP083
316200200528     C*******************EXSR      GETRCDLN                                            CAP057 CAP083
316300200528     C*******************Z-ADD     RecordLen     SPTRLn            4 0                 CAP057 CAP083
316400200528                                                                                       CAP057 CAP083
316500200528                                                                                       CAP038 CAP083
316600200528      ***SD*Base Rate Details                                                          CAP038 CAP083
316700200528                                                                                       CAP038 CAP083
316800200528     C*******************MOVEL     'SDBSRSPD'    FileName                              CAP038 CAP083
316900200528     C*******************EXSR      GETRCDLN                                            CAP038 CAP083
317000200528     C*******************Z-ADD     RecordLen     SDBSLn            4 0                 CAP038 CAP083
317100200528                                                                                       CAP038 CAP083
317200200528      ***Get*record length of Data Layout files for AB Internal                        CAP042 CAP083
317300200528      ***Funding*Deals API                                                             CAP042 CAP083
317400200528                                                                                       CAP042 CAP083
317500200528     C*******************MOVEL     'ABFUNDPD'    FileName                              CAP042 CAP083
317600200528     C*******************EXSR      GETRCDLN                                            CAP042 CAP083
317700200528     C*******************Z-ADD     RecordLen     FUNDLn                                CAP042 CAP083
317800200528      *                                                                                CAP042 CAP083
317900200528      ***Get*record length of Extra Data Layout file for AB                            CAP042 CAP083
318000200528      ***Internal*Funding Deals - API                                                  CAP042 CAP083
318100200528      *                                                                                CAP042 CAP083
318200200528     C*******************MOVEL     'ABFUEXPD'    Filename                              CAP042 CAP083
318300200528     C*******************EXSR      GETRCDLN                                            CAP042 CAP083
318400200528     C*******************Z-ADD     Recordlen     FUEXLn                                CAP042 CAP083
318500200528                                                                                       CAP042 CAP083
318600200528      ***FX*Extra Data file (50 byte narrative text plus any custom info)       CAP004        CAP083
318700200528                                                                                CAP004        CAP083
318800200528     C*******************MOVEL     'FXFXEXPD'    FileName                       CAP004        CAP083
318900200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
319000200528     C*******************Z-ADD     RecordLen     FXFXLn            4 0          CAP004        CAP083
319100200528                                                                                CAP004        CAP083
319200200528      ***MM*Loan/deposits Extra Data file (50 byte narrative text plus any      CAP004        CAP083
319300200528      ***custom*info)                                                           CAP004        CAP083
319400200528                                                                                CAP004        CAP083
319500200528     C*******************MOVEL     'MMLDEXPD'    FileName                       CAP004        CAP083
319600200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
319700200528     C*******************Z-ADD     RecordLen     MMLDLn            4 0          CAP004        CAP083
319800200528                                                                                CAP004        CAP083
319900200528      ***MM*Deal amendments Extra Data file (50 byte narrative text plus any    CAP004        CAP083
320000200528      ***custom*info)                                                           CAP004        CAP083
320100200528                                                                                CAP004        CAP083
320200200528     C*******************MOVEL     'MMDAEXPD'    FileName                       CAP004        CAP083
320300200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
320400200528     C*******************Z-ADD     RecordLen     MMDALn            4 0          CAP004        CAP083
320500200528                                                                                CAP004        CAP083
320600200528      ***MM*NAs Purchased Extra Data file (50 byte narrative text plus any      CAP004        CAP083
320700200528      ***custom*info)                                                           CAP004        CAP083
320800200528                                                                                CAP004        CAP083
320900200528     C*******************MOVEL     'MMNPEXPD'    FileName                       CAP004        CAP083
321000200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
321100200528     C*******************Z-ADD     RecordLen     MMNPLn            4 0          CAP004        CAP083
321200200528                                                                                CAP004        CAP083
321300200528      ***MM*NAs Sold Extra Data file (50 byte narrative text plus any           CAP004        CAP083
321400200528      ***custom*info)                                                           CAP004        CAP083
321500200528                                                                                CAP004        CAP083
321600200528     C*******************MOVEL     'MMNSEXPD'    FileName                       CAP004        CAP083
321700200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
321800200528     C*******************Z-ADD     RecordLen     MMNSLn            4 0          CAP004        CAP083
321900200528                                                                                CAP004        CAP083
322000200528      ***IR*FRAs Extra Data file (50 byte narrative text plus any               CAP004        CAP083
322100200528      ***custom*info)                                                           CAP004        CAP083
322200200528                                                                                CAP004        CAP083
322300200528     C*******************MOVEL     'IRFREXPD'    FileName                       CAP004        CAP083
322400200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
322500200528     C*******************Z-ADD     RecordLen     IRFRLn            4 0          CAP004        CAP083
322600200528                                                                                CAP004        CAP083
322700200528      ***IR*IRS Cross Ccy Extra Data file (50 byte narrative text plus any      CAP004        CAP083
322800200528      ***custom*info)                                                           CAP004        CAP083
322900200528                                                                                CAP004        CAP083
323000200528     C*******************MOVEL     'IRCSEXPD'    FileName                       CAP004        CAP083
323100200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
323200200528     C*******************Z-ADD     RecordLen     IRCSLn            4 0          CAP004        CAP083
323300200528                                                                                CAP004        CAP083
323400200528      ***IR*IRS Single Ccy Extra Data file (50 byte narrative text plus any     CAP004        CAP083
323500200528      ***custom*info)                                                           CAP004        CAP083
323600200528                                                                                CAP004        CAP083
323700200528     C*******************MOVEL     'IRSSEXPD'    FileName                       CAP004        CAP083
323800200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
323900200528     C*******************Z-ADD     RecordLen     IRSSLn            4 0          CAP004        CAP083
324000200528                                                                                CAP004        CAP083
324100200528      ***SE*Trades Extra Data file (50 byte narrative text plus any             CAP004        CAP083
324200200528      ***custom*info)                                                           CAP004        CAP083
324300200528                                                                                CAP004        CAP083
324400200528     C**********         MOVEL     'SETREXPD'    FileName                 CAP004175717
324500200528     C*******************MOVEL     'SETDEXPD'    FileName                       175717        CAP083
324600200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
324700200528     C*******************Z-ADD     RecordLen     SETRLn            4 0          CAP004        CAP083
324800200528                                                                                CAP004        CAP083
324900200528      ***SE*Walk In Depot Movts Extra Data file (50 byte narrative text         CAP004        CAP083
325000200528      ***plus*any custom info)                                                  CAP004        CAP083
325100200528                                                                                CAP004        CAP083
325200200528     C**********         MOVEL     'SEWIEXPD'    FileName                 CAP004175715
325300200528     C*******************MOVEL     'SEDMEXPD'    FileName                       175715        CAP083
325400200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
325500200528     C*******************Z-ADD     RecordLen     SEWILn            4 0          CAP004        CAP083
325600200528                                                                                CAP004        CAP083
325700200528      ***SE*Walk Out Depot Movts Extra Data file (50 byte narrative text        CAP004        CAP083
325800200528      ***plus*any custom info)                                                  CAP004        CAP083
325900200528                                                                                CAP004        CAP083
326000200528     C**********         MOVEL     'SEWOEXPD'    FileName                 CAP004175715
326100200528     C*******************MOVEL     'SEDMEXPD'    FileName                       175715        CAP083
326200200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
326300200528     C*******************Z-ADD     RecordLen     SEWOLn            4 0          CAP004        CAP083
326400200528                                                                                CAP004        CAP083
326500200528      ***AB*Internal Contracts Extra Data file (50 byte narrative text          CAP004        CAP083
326600200528      ***plus*any custom info)                                                  CAP004        CAP083
326700200528                                                                                CAP004        CAP083
326800200528     C*******************MOVEL     'ABICEXPD'    FileName                       CAP004        CAP083
326900200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
327000200528     C*******************Z-ADD     RecordLen     ABICLn            4 0          CAP004        CAP083
327100200528                                                                                CAP004        CAP083
327200200528      ***FF*Exchange Traded Options Extra Data file (50 byte narrative text     CAP004        CAP083
327300200528      ***plus*any custom info)                                                  CAP004        CAP083
327400200528                                                                                CAP004        CAP083
327500200528     C*******************MOVEL     'FFETEXPD'    FileName                       CAP004        CAP083
327600200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
327700200528     C*******************Z-ADD     RecordLen     FFETLn            4 0          CAP004        CAP083
327800200528                                                                                CAP004        CAP083
327900200528      ***FF*Over the Counter Options Extra Data file (50 byte narrative text    CAP004        CAP083
328000200528      ***plus*any custom info)                                                  CAP004        CAP083
328100200528                                                                                CAP004        CAP083
328200200528     C*******************MOVEL     'FFOTEXPD'    FileName                       CAP004        CAP083
328300200528     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
328400200528     C*******************Z-ADD     RecordLen     FFOTLn            4 0          CAP004        CAP083
328500200528                                                                                CAP005        CAP083
328600200528      ***FD*Forward Rates Extra Data file (50 byte narrative text               CAP005        CAP083
328700200528      ***plus*any custom info)                                                  CAP005        CAP083
328800200528                                                                                CAP005        CAP083
328900200528     C*******************MOVEL     'FDFREXPD'    FileName                       CAP005        CAP083
329000200528     C*******************EXSR      GETRCDLN                                     CAP005        CAP083
329100200528     C*******************Z-ADD     RecordLen     FDFRLn            4 0          CAP005        CAP083
329200200528                                                                                CAP005        CAP083
329300200528      ***FD*MM Interest Rates Extra Data file (50 byte narrative text           CAP005        CAP083
329400200528      ***plus*any custom info)                                                  CAP005        CAP083
329500200528                                                                                CAP005        CAP083
329600200528     C*******************MOVEL     'FDIREXPD'    FileName                       CAP005        CAP083
329700200528     C*******************EXSR      GETRCDLN                                     CAP005        CAP083
329800200528     C*******************Z-ADD     RecordLen     FDIRLn            4 0          CAP005        CAP083
329900200528                                                                                153108        CAP083
330000200528      ***SE*Price Input                                                         CAP030        CAP083
330100200528                                                                                CAP030        CAP083
330200200528     C*******************MOVEL     'SEPRCSPD'    FileName                       CAP030        CAP083
330300200528     C*******************EXSR      GETRCDLN                                     CAP030        CAP083
330400200528     C*******************Z-ADD     RecordLen     PRCSLn            4 0          CAP030        CAP083
330500200528                                                                                CAP030        CAP083
330600200528      ***SE*Price Input  Extra Data file (50 byte narrative text                CAP030        CAP083
330700200528      ***plus*any custom info)                                                  CAP030        CAP083
330800200528                                                                                CDL007        CAP083
330900200528      ***MM*Loan/deposits Interface Data  Format Definition Layout              CDL007        CAP083
331000200528      ***(50*byte narrative text plus any custom info)                          CDL007        CAP083
331100200528                                                                                CDL007        CAP083
331200200528     C*******************MOVEL     'MMLDIFPD'    FileName                       CDL007        CAP083
331300200528     C*******************EXSR      GETRCDLN                                     CDL007        CAP083
331400200528     C*******************Z-ADD     RecordLen     MMLILn            4 0          CDL007        CAP083
331500200528                                                                                CAP051        CAP083
331600200528      ***FX*Foreign Exchange Interface Data  Format Definition Layout           CAP051        CAP083
331700200528      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
331800200528                                                                                CAP051        CAP083
331900200528     C*******************MOVEL     'FXFXIFPD'    FileName                       CAP051        CAP083
332000200528     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
332100200528     C*******************Z-ADD     RecordLen     FXFILn            4 0          CAP051        CAP083
332200200528                                                                                CAP051        CAP083
332300200528      ***MM*Money Market Dealing Interface Data  Format Definition Layout       CAP051        CAP083
332400200528      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
332500200528                                                                                CAP051        CAP083
332600200528     C*******************MOVEL     'MMDAIFPD'    FileName                       CAP051        CAP083
332700200528     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
332800200528     C*******************Z-ADD     RecordLen     MMDILn            4 0          CAP051        CAP083
332900200528                                                                                CAP051        CAP083
333000200528      ***SE*Trades Interface Data  Format Definition Layout                     CAP051        CAP083
333100200528      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
333200200528                                                                                CAP051        CAP083
333300200528     C*******************MOVEL     'SETRIFPD'    FileName                       CAP051        CAP083
333400200528     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
333500200528     C*******************Z-ADD     RecordLen     SETILn            4 0          CAP051        CAP083
333600200528                                                                                       CAP056 CAP083
333700200528      ***IR*Single*Currency*Interface*Data*Format*Definition*Layout                    CAP056 CAP083
333800200528                                                                                       CAP056 CAP083
333900200528     C*******************MOVEL     'IRRSIFPD'    FileName                              CAP056 CAP083
334000200528     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
334100200528     C*******************Z-ADD     RecordLen     IRRSLn                                CAP056 CAP083
334200200528                                                                                       CAP056 CAP083
334300200528      ***IR*Cross*Currency*Interface*Data*Format*Definition*Layout                     CAP056 CAP083
334400200528                                                                                       CAP056 CAP083
334500200528     C*******************MOVEL     'IRRXIFPD'    FileName                              CAP056 CAP083
334600200528     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
334700200528     C*******************Z-ADD     RecordLen     IRRXLn                                CAP056 CAP083
334800200528                                                                                       CAP056 CAP083
334900200528      ***IR*Forward*Rate*Agreement*Interface*Data*Format*Definition*Layout             CAP056 CAP083
335000200528                                                                                       CAP056 CAP083
335100200528     C*******************MOVEL     'IRFRIFPD'    FileName                              CAP056 CAP083
335200200528     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
335300200528     C*******************Z-ADD     RecordLen     IRFALn                                CAP056 CAP083
335400200528                                                                                       CAP056 CAP083
335500200528      ***IR*Caps/Collars/Floors*Interface*Data*Format*Definition*Layout                CAP056 CAP083
335600200528                                                                                       CAP056 CAP083
335700200528     C*******************MOVEL     'IRRPIFPD'    FileName                              CAP056 CAP083
335800200528     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
335900200528     C*******************Z-ADD     RecordLen     IRRPLn                                CAP056 CAP083
336000200528      *                                                                                CAP033 CAP083
336100200528      ***Get*record length of Data Layout file for Portfolio Definition                CAP033 CAP083
336200200528      ***Details*API.                                                                  CAP033 CAP083
336300200528     C*******************MOVEL     'PMPFDMPD'    Filename                              CAP033 CAP083
336400200528     C*******************EXSR      GETRCDLN                                            CAP033 CAP083
336500200528     C*******************Z-ADD     Recordlen     PFDMLn            4 0                 CAP033 CAP083
336600200528      *                                                                                CAP033 CAP083
336700200528      ***Get*record length of Extra Data Layout file for Portfolio                     CAP033 CAP083
336800200528      ***Definition*Details API.                                                       CAP033 CAP083
336900200528     C*******************MOVEL     'PMPFEXPD'    Filename                              CAP033 CAP083
337000200528     C*******************EXSR      GETRCDLN                                            CAP033 CAP083
337100200528     C*******************Z-ADD     Recordlen     PFEXLn            4 0                 CAP033 CAP083
337200200528      *                                                                                CAP032 CAP083
337300200528      ***Get*record length of Data Layout file for Journal                             CAP032 CAP083
337400200528      ***Entry*Header API.                                                             CAP032 CAP083
337500200528     C*******************MOVEL     'GLBITHPD'    Filename                              CAP032 CAP083
337600200528     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
337700200528     C*******************Z-ADD     Recordlen     BITHLn            4 0                 CAP032 CAP083
337800200528      *                                                                                CAP032 CAP083
337900200528      ***Get*record length of Data Layout file for Journal                             CAP032 CAP083
338000200528      ***Entry*Item API.                                                               CAP032 CAP083
338100200528     C*******************MOVEL     'GLBITPPD'    Filename                              CAP032 CAP083
338200200528     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
338300200528     C*******************Z-ADD     Recordlen     BITPLn            4 0                 CAP032 CAP083
338400200528      *                                                                                CAP032 CAP083
338500200528      ***Get*record length of Extra Data Layout file for Journal                       CAP032 CAP083
338600200528      ***Entry*Header API.                                                             CAP032 CAP083
338700200528     C*******************MOVEL     'GLBHEXPD'    Filename                              CAP032 CAP083
338800200528     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
338900200528     C*******************Z-ADD     Recordlen     BHEXLn            4 0                 CAP032 CAP083
339000200528     C/COPY WNCPYSRC,APINCOMMC4
339100200528      *                                                                                CAP032 CAP083
339200200528      ***Get*record length of Extra Data Layout file for Journal                       CAP032 CAP083
339300200528      ***Entry*Item API.                                                               CAP032 CAP083
339400200528     C*******************MOVEL     'GLBPEXPD'    Filename                              CAP032 CAP083
339500200528     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
339600200528     C*******************Z-ADD     Recordlen     BPEXLn            4 0                 CAP032 CAP083
339700200528      *                                                                                CAP032 CAP083
339800200528                                                                                153108        CAP083
339900200528      ***FT*Outgoing Payment Extra Data file (50 byte narrative text            CAP031        CAP083
340000200528      ***plus*any custom info)                                                  CAP031        CAP083
340100200528                                                                                CAP031        CAP083
340200200528     C*******************MOVEL     'FTOPEXPD'    FileName                       CAP031        CAP083
340300200528     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
340400200528     C*******************Z-ADD     RecordLen     OPEXLn            4 0          CAP031        CAP083
340500200528                                                                                CAP031        CAP083
340600200528      ***SD*Customers Extra Data file (50 byte narrative text plus any          CAP034        CAP083
340700200528      ***custom*info)                                                           CAP034        CAP083
340800200528                                                                                CAP034        CAP083
340900200528     C*******************MOVEL     'SDCUEXPD'    FileName                       CAP034        CAP083
341000200528     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
341100200528     C*******************Z-ADD     RecordLen     SDCULn            4 0          CAP034        CAP083
341200200528     C/COPY WNCPYSRC,APINCOMMC6
341300200528                                                                                CAP034        CAP083
341400200528      ***GL*Accounts Extra Data file (50 byte narrative text plus any           CAP035        CAP083
341500200528      ***custom*info)                                                           CAP035        CAP083
341600200528                                                                                CAP035        CAP083
341700200528     C*******************MOVEL     'GLAMEXPD'    FileName                       CAP035        CAP083
341800200528     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
341900200528     C*******************Z-ADD     RecordLen     GLAMLn            4 0          CAP035        CAP083
342000200528                                                                                CAP035        CAP083
342100200528                                                                                CAP030        CAP083
342200200528     C*******************MOVEL     'SEPREXPD'    FileName                       CAP030        CAP083
342300200528     C*******************EXSR      GETRCDLN                                     CAP030        CAP083
342400200528     C*******************Z-ADD     RecordLen     PRCXLn            4 0          CAP030        CAP083
342500200528      *                                                                         CAP136        CAP083
342600200528      ***Get*record length of Data Layout files for FT Incoming                 CAP136        CAP083
342700200528      ***Payments*API*-*first,*second,*third*and*fourth*details.*******  CAP136 CFT014
342800200528      ***Payments*API - first, second, third, fourth, fifth, sixth,             CFT014        CAP083
342900200528      ***seventh*and eighth details.                                            CFT014        CAP083
343000200528      *                                                                         CAP136        CAP083
343100200528     C*******************MOVEL     'FTIPY1PD  '  Filename                       CAP136        CAP083
343200200528     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
343300200528     C*******************Z-ADD     Recordlen     IPY1Ln            4 0          CAP136        CAP083
343400200528      *                                                                         CAP136        CAP083
343500200528     C***********        MOVEL     'FTIPY2PD  '  Filename                CAP136 CFT014
343600200528     C*******************MOVEL     'FTIPY1APD'   FileName                       CFT014        CAP083
343700200528     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
343800200528     C*******************Z-ADD     Recordlen     IPY2Ln            4 0          CAP136        CAP083
343900200528      *                                                                         CAP136        CAP083
344000200528     C***********        MOVEL     'FTIPY3PD  '  Filename                CAP136 CFT014
344100200528     C*******************MOVEL     'FTIPY2PD  '  Filename                       CFT014        CAP083
344200200528     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
344300200528     C*******************Z-ADD     Recordlen     IPY3Ln            4 0          CAP136        CAP083
344400200528      *                                                                         CAP136        CAP083
344500200528     C***********        MOVEL     'FTIPY4PD  '  Filename                CAP136 CFT014
344600200528     C*******************MOVEL     'FTIPY3PD  '  Filename                       CFT014        CAP083
344700200528     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
344800200528     C*******************Z-ADD     Recordlen     IPY4Ln            4 0          CAP136        CAP083
344900200528      *                                                                         CFT014        CAP083
345000200528     C*******************MOVEL     'FTIPY4PD'    FileName                       CFT014        CAP083
345100200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
345200200528     C*******************Z-ADD     RecordLen     IPY5Ln            4 0          CFT014        CAP083
345300200528      *                                                                         CFT014        CAP083
345400200528     C*******************MOVEL     'FTIPY4APD'   FileName                       CFT014        CAP083
345500200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
345600200528     C*******************Z-ADD     RecordLen     IPY6Ln            4 0          CFT014        CAP083
345700200528      *                                                                         CFT014        CAP083
345800200528     C*******************MOVEL     'FTIPY5PD'    FileName                       CFT014        CAP083
345900200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
346000200528     C*******************Z-ADD     RecordLen     IPY7Ln            4 0          CFT014        CAP083
346100200528      *                                                                         CFT014        CAP083
346200200528     C*******************MOVEL     'FTIPY6PD'    FileName                       CFT014        CAP083
346300200528     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
346400200528     C*******************Z-ADD     RecordLen     IPY8Ln            4 0          CFT014        CAP083
346500200528      *                                                                         CAP136        CAP083
346600200528      ***Get*record length of Extra Data Layout file for FT Incoming            CAP136        CAP083
346700200528      ***Payments*API.                                                          CAP136        CAP083
346800200528      *                                                                         CAP136        CAP083
346900200528     C*******************MOVEL     'FTIPEXPD  '  Filename                       CAP136        CAP083
347000200528     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
347100200528     C*******************Z-ADD     Recordlen     IPEXLn            4 0          CAP136        CAP083
347200200528      *                                                                         CAP137        CAP083
347300200528      ***Get*record length of Data Layout files for SE Securities               CAP137        CAP083
347400200528      ***API*- first, second, and third  details.                               CAP137        CAP083
347500200528      *                                                                         CAP137        CAP083
347600200528     C*******************MOVEL     'SESEC1PD  '  Filename                       CAP137        CAP083
347700200528     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
347800200528     C*******************Z-ADD     Recordlen     SEC1Ln            4 0          CAP137        CAP083
347900200528      *                                                                         CAP137        CAP083
348000200528     C*******************MOVEL     'SESEC2PD  '  Filename                       CAP137        CAP083
348100200528     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
348200200528     C*******************Z-ADD     Recordlen     SEC2Ln            4 0          CAP137        CAP083
348300200528      *                                                                         CAP137        CAP083
348400200528     C*******************MOVEL     'SESEC3PD  '  Filename                       CAP137        CAP083
348500200528     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
348600200528     C*******************Z-ADD     Recordlen     SEC3Ln            4 0          CAP137        CAP083
348700200528     C**********         MOVEL     'SESEC4PD  '  Filename                       CSE031        CAP083
348800200528     C**********         EXSR      GETRCDLN                                     CSE031        CAP083
348900200528     C**********         Z-ADD     Recordlen     SEC4Ln            4 0          CSE031        CAP083
349000200528      **********                                                                       CAS006 CAP083
349100200528     C**********         MOVEL     'SESEC5PD  '  Filename                              CAS006 CAP083
349200200528     C**********         EXSR      GETRCDLN                                            CAS006 CAP083
349300200528     C**********         Z-ADD     Recordlen     SEC5Ln            4 0                 CAS006 CAP083
349400200528      *                                                                         CAP137        CAP083
349500200528      ***Get*record length of Extra Data Layout file for SE                     CAP137        CAP083
349600200528      ***Securities*- API.                                                      CAP137        CAP083
349700200528      *                                                                         CAP137        CAP083
349800200528     C*******************MOVEL     'SESEEXPD  '  Filename                       CAP137        CAP083
349900200528     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
350000200528     C*******************Z-ADD     Recordlen     SEEXLn            4 0          CAP137        CAP083
350100200528                                                                                CAP030        CAP083
350200200528      ***SD*Security Customers Details Extra Data file                          CAP039        CAP083
350300200528      ***(50*byte narrative text plus any custom info)                          CAP039        CAP083
350400200528                                                                                CAP039        CAP083
350500200528     C*******************MOVEL     'SDSEEXPD'    FileName                       CAP039        CAP083
350600200528     C*******************EXSR      GETRCDLN                                     CAP039        CAP083
350700200528     C*******************Z-ADD     RecordLen     SDSELn            4 0          CAP039        CAP083
350800200528                                                                                CAP039        CAP083
350900200528      ***SD*Market Data Feed Spot Rate Details                                         CAP057 CAP083
351000200528      ***(50*byte narrative text plus any custom info)                                 CAP057 CAP083
351100200528                                                                                       CAP057 CAP083
351200200528     C*******************MOVEL     'SDSPTXPD'    FileName                              CAP057 CAP083
351300200528     C*******************EXSR      GETRCDLN                                            CAP057 CAP083
351400200528     C*******************Z-ADD     RecordLen     SDSPLn            4 0                 CAP057 CAP083
351500200528                                                                                       CAP057 CAP083
351600200528      ***SD*Base Rates Extra Data file                                                 CAP038 CAP083
351700200528                                                                                       CAP038 CAP083
351800200528     C*******************MOVEL     'SDBSEXPD'    FileName                              CAP038 CAP083
351900200528     C*******************EXSR      GETRCDLN                                            CAP038 CAP083
352000200528     C*******************Z-ADD     RecordLen     SDBXLn            4 0                 CAP038 CAP083
352100200528                                                                                       CAP038 CAP083
352200200528      ***Get*record*length*of*Data*Layout*files*for*MM*REPOs                           CAP067 CAP083
352300200528      ***Depot*Movements*-*API                                                         CAP067 CAP083
352400200528                                                                                       CAP067 CAP083
352500200528     C*******************MOVEL     'MMRPDDPD'    Filename                              CAP067 CAP083
352600200528     C*******************EXSR      GETRCDLN                                            CAP067 CAP083
352700200528     C*******************Z-ADD     Recordlen     REP1Ln                                CAP067 CAP083
352800200528                                                                                       CAP067 CAP083
352900200528      ***Get*record*length*of*Data*Layout*files*for*MM*REPOs                           CAP067 CAP083
353000200528      ***Trailer*-*API                                                                 CAP067 CAP083
353100200528                                                                                       CAP067 CAP083
353200200528     C*******************MOVEL     'MMRPTRPD'    Filename                              CAP067 CAP083
353300200528     C*******************EXSR      GETRCDLN                                            CAP067 CAP083
353400200528     C*******************Z-ADD     Recordlen     REP2Ln                                CAP067 CAP083
353500200528                                                                                       CAP067 CAP083
353600200528      ***Check*if*CAS001*is*installed                                                  CAS001 CAP083
353700200528                                                                                       CAS001 CAP083
353800200528     C*****************  CALLB     'AOSARDR0'                                          CAS001 CAP083
353900200528     C****************** PARM      *BLANKS       PRtCd                                 CAS001 CAP083
354000200528     C****************** PARM      '*VERIFY'     POptn                                 CAS001 CAP083
354100200528     C****************** PARM      'CAS001'      PSarD                                 CAS001 CAP083
354200200528     C*****SCSARD        PARM      SCSARD        DSFDY                                 CAS001 CAP083
354300200528                                                                                       CAS001 CAP083
354400200528     C*****PRtCd         IFEQ      *BLANK                                              CAS001 CAP083
354500200528     C****************** MOVEL     'Y'           CAS001                                CAS001 CAP083
354600200528     C****************** ELSE                                                          CAS001 CAP083
354700200528     C****************** MOVEL     'N'           CAS001                                CAS001 CAP083
354800200528     C****************** ENDIF                                                         CAS001 CAP083
354900200528                                                                                       CAS001 CAP083
355000200528      ***SD*Yield*Rates*Details                                                        CAS001 CAP083
355100200528                                                                                       CAS001 CAP083
355200200528     C*******************IF        CAS001 = 'Y'                                        CAS001 CAP083
355300200528                                                                                       CAS001 CAP083
355400200528     C*******************MOVEL     'SDYRAT1PD'   FileName                              CAS001 CAP083
355500200528     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
355600200528     C*******************Z-ADD     RecordLen     YRAT1Ln                               CAS001 CAP083
355700200528     C*******************MOVEL     'SDYRAT2PD'   FileName                              CAS001 CAP083
355800200528     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
355900200528     C*******************Z-ADD     RecordLen     YRAT2Ln                               CAS001 CAP083
356000200528     C*******************MOVEL     'SDYRAT3PD'   FileName                              CAS001 CAP083
356100200528     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
356200200528     C*******************Z-ADD     RecordLen     YRAT3Ln                               CAS001 CAP083
356300200528     C*******************MOVEL     'SDYRAT4PD'   FileName                              CAS001 CAP083
356400200528     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
356500200528     C*******************Z-ADD     RecordLen     YRAT4Ln                               CAS001 CAP083
356600200528                                                                                       CAS001 CAP083
356700200528      ** SD Yield Rates Extra Data File                                                CAS001 CAP083
356800200528                                                                                       CAS001 CAP083
356900200528     C*******************MOVEL     'SDYREXPD'    FileName                              CAS001 CAP083
357000200528     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
357100200528     C*******************Z-ADD     RecordLen     SDYRLn                                CAS001 CAP083
357200200528                                                                                       CAS001 CAP083
357300200528     C*******************ENDIF                                                         CAS001 CAP083
357400200528                                                                                       CAS001 CAP083
357500200528      ***Check*if*CAP043*(APIs*for*IRS*Schedules)*is*installed                         CAP043 CAP083
357600200528      ******************                                                               CAP043 CAP083
357700200528     C****************** CALLB     'AOSARDR0'                                          CAP043 CAP083
357800200528     C****************** PARM      *BLANKS       PRtCd                                 CAP043 CAP083
357900200528     C****************** PARM      '*VERIFY'     POptn                                 CAP043 CAP083
358000200528     C****************** PARM      'CAP043'      PSarD                                 CAP043 CAP083
358100200528     C*****SCSARD        PARM      SCSARD        DSFDY                                 CAP043 CAP083
358200200528      ******************                                                               CAP043 CAP083
358300200528     C*****PRtCd         IFEQ      *BLANK                                              CAP043 CAP083
358400200528     C****************** MOVEL     'Y'           CAP043                                CAP043 CAP083
358500200528     C****************** ELSE                                                          CAP043 CAP083
358600200528     C****************** MOVEL     'N'           CAP043                                CAP043 CAP083
358700200528     C****************** ENDIF                                                         CAP043 CAP083
358800200528                                                                                       CAP043 CAP083
358900200528     C*******************IF        CAP043 = 'Y'                                        CAP043 CAP083
359000200528                                                                                       CAP043 CAP083
359100200528      ***Cash*Flow*Schedules                                                           CAP043 CAP083
359200200528                                                                                       CAP043 CAP083
359300200528     C*******************CLEAR                   FileName                              CAP043 CAP083
359400200528     C*******************MOVEL     'IRCFSC1PD'   FileName                              CAP043 CAP083
359500200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
359600200528     C*******************Z-ADD     RecordLen     WCFSC1OLn                             CAP043 CAP083
359700200528     C*******************Z-ADD     RecordLen     WCFSC1TLn                             CAP043 CAP083
359800200528     C*******************MOVEL     'IRCFSC2PD'   FileName                              CAP043 CAP083
359900200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
360000200528     C*******************Z-ADD     RecordLen     WCFSC2OLn                             CAP043 CAP083
360100200528     C*******************Z-ADD     RecordLen     WCFSC2TLn                             CAP043 CAP083
360200200528     C*******************MOVEL     'IRCFSC3PD'   FileName                              CAP043 CAP083
360300200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
360400200528     C*******************Z-ADD     RecordLen     WCFSC3OLn                             CAP043 CAP083
360500200528     C*******************Z-ADD     RecordLen     WCFSC3TLn                             CAP043 CAP083
360600200528     C*******************MOVEL     'IRCFSC4PD'   FileName                              CAP043 CAP083
360700200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
360800200528     C*******************Z-ADD     RecordLen     WCFSC4OLn                             CAP043 CAP083
360900200528     C*******************Z-ADD     RecordLen     WCFSC4TLn                             CAP043 CAP083
361000200528                                                                                       CAP043 CAP083
361100200528      ***Principal*Change*Schedules                                                    CAP043 CAP083
361200200528                                                                                       CAP043 CAP083
361300200528     C*******************MOVEL     'IRPCSC1PD'   FileName                              CAP043 CAP083
361400200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
361500200528     C*******************Z-ADD     RecordLen     WPCSC1OLn                             CAP043 CAP083
361600200528     C*******************Z-ADD     RecordLen     WPCSC1TLn                             CAP043 CAP083
361700200528     C*******************MOVEL     'IRPCSC2PD'   FileName                              CAP043 CAP083
361800200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
361900200528     C*******************Z-ADD     RecordLen     WPCSC2OLn                             CAP043 CAP083
362000200528     C*******************Z-ADD     RecordLen     WPCSC2TLn                             CAP043 CAP083
362100200528     C*******************MOVEL     'IRPCSC3PD'   FileName                              CAP043 CAP083
362200200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
362300200528     C*******************Z-ADD     RecordLen     WPCSC3OLn                             CAP043 CAP083
362400200528     C*******************Z-ADD     RecordLen     WPCSC3TLn                             CAP043 CAP083
362500200528     C*******************MOVEL     'IRPCSC4PD'   FileName                              CAP043 CAP083
362600200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
362700200528     C*******************Z-ADD     RecordLen     WPCSC4OLn                             CAP043 CAP083
362800200528     C*******************Z-ADD     RecordLen     WPCSC4TLn                             CAP043 CAP083
362900200528                                                                                       CAP043 CAP083
363000200528      ***Trailer*Record                                                                CAP043 CAP083
363100200528                                                                                       CAP043 CAP083
363200200528     C*******************CLEAR                   FileName                              CAP043 CAP083
363300200528     C*******************MOVEL     'IRTRSCPD'    FileName                              CAP043 CAP083
363400200528     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
363500200528     C*******************Z-ADD     RecordLen     WTRSCLn                               CAP043 CAP083
363600200528     C*******************CLEAR                   FileName                              CAP043 CAP083
363700200528                                                                                       CAP043 CAP083
363800200528     C*******************ENDIF                                                         CAP043 CAP083
363900200528      ***LE*Assignments                                                                CAP070 CAP083
364000200528                                                                                       CAP070 CAP083
364100200528     C*******************MOVEL     'LEASGNPD'    FileName                              CAP070 CAP083
364200200528     C*******************EXSR      GETRCDLN                                            CAP070 CAP083
364300200528     C*******************Z-ADD     RecordLen     ASGNLn            4 0                 CAP070 CAP083
364400200528                                                                                       CAP070 CAP083
364500200528      ***LE*Risk*Participants                                                          CAP070 CAP083
364600200528                                                                                       CAP070 CAP083
364700200528     C*******************MOVEL     'LERPRTPD'    FileName                              CAP070 CAP083
364800200528     C*******************EXSR      GETRCDLN                                            CAP070 CAP083
364900200528     C*******************Z-ADD     RecordLen     RPRTLn            4 0                 CAP070 CAP083
365000200528                                                                                       CAP070 CAP083
365100200528      ***LE*Funding*Participants                                                       CAP068 CAP083
365200200528                                                                                       CAP068 CAP083
365300200528     C*******************MOVEL     'LEFPRTPD'    FileName                              CAP068 CAP083
365400200528     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
365500200528     C*******************Z-ADD     RecordLen     FPRTLn            4 0                 CAP068 CAP083
365600200528                                                                                       CAP068 CAP083
365700200528      ***LE*Facility*Amendments                                                        CAP071 CAP083
365800200528                                                                                       CAP071 CAP083
365900200528     C*******************MOVEL     'LEFAMDPD'    FileName                              CAP071 CAP083
366000200528     C*******************EXSR      GETRCDLN                                            CAP071 CAP083
366100200528     C*******************Z-ADD     RecordLen     FAMDLn            4 0                 CAP071 CAP083
366200200528                                                                                       CAP071 CAP083
366300200528      ***LE*Fee*Adjustment*input                                                       CAP072 CAP083
366400200528                                                                                       CAP072 CAP083
366500200528     C*******************MOVEL     'LEFEADPD'    FileName                              CAP072 CAP083
366600200528     C*******************EXSR      GETRCDLN                                            CAP072 CAP083
366700200528     C*******************Z-ADD     RecordLen     FEADLn            4 0                 CAP072 CAP083
366800200528                                                                                       CAP072 CAP083
366900200528      ***LE*Fee*Settlement*input                                                       CAP072 CAP083
367000200528                                                                                       CAP072 CAP083
367100200528     C*******************MOVEL     'LEFESTPD'    FileName                              CAP072 CAP083
367200200528     C*******************EXSR      GETRCDLN                                            CAP072 CAP083
367300200528     C*******************Z-ADD     RecordLen     FESTLn            4 0                 CAP072 CAP083
367400200528                                                                                       CAP070 CAP083
367500200528      ***LE*Settlement*Details**                                                       CAP068 CAP083
367600200528                                                                                       CAP068 CAP083
367700200528     C*******************MOVEL     'SETLIAB'     FileName                              CAP068 CAP083
367800200528     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
367900200528     C*******************Z-ADD     500           LIAB1Ln           4 0                 CAP068 CAP083
368000200528     C*****Recordlen*****SUB       LIAB1Ln       LIAB2Ln           4 0                 CAP068 CAP083
368100200528                                                                                       CAP068 CAP083
368200200528      ***LE*Settle/Detail*format*(inc*Cont/Parms)                                      CAP068 CAP083
368300200528                                                                                       CAP068 CAP083
368400200528     C*******************MOVEL     'SETLIAZ'     FileName                              CAP068 CAP083
368500200528     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
368600200528     C*******************Z-ADD     RecordLen     LIAZLn            4 0                 CAP068 CAP083
368700200528                                                                                       CSC011 CAP083
368800200528      ***LE*Facility*Input*format                                                      CSC011 CAP083
368900200528                                                                                       CSC011 CAP083
369000200528     C*******************MOVEL     'LEF1MFPD'    FileName                              CSC011 CAP083
369100200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
369200200528     C*******************Z-ADD     500           FCTY1Ln           4 0                 CSC011 CAP083
369300200528     C*******************Z-ADD     500           FCTY2Ln           4 0                 CSC011 CAP083
369400200528     C*****Recordlen*****SUB       1000          FCTY3Ln           4 0                 CSC011 CAP083
369500200528                                                                                       CSC011 CAP083
369600200528      ***LE*Loan*Input*format                                                          CSC011 CAP083
369700200528      ***LE*Participations*Purchased*input*format                                      CSC011 CAP083
369800200528      ***LE*Participations*Sold*Input                                                  CSC011 CAP083
369900200528                                                                                       CSC011 CAP083
370000200528     C*******************MOVEL     'LEN1MFPD'    FileName                              CSC011 CAP083
370100200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
370200200528     C*******************Z-ADD     500           LOAN1Ln           4 0                 CSC011 CAP083
370300200528     C*******************Z-ADD     500           PTPU1Ln           4 0                 CSC011 CAP083
370400200528     C*******************Z-ADD     500           PTSO1Ln           4 0                 CSC011 CAP083
370500200528     C*******************Z-ADD     500           LOAN2Ln           4 0                 CSC011 CAP083
370600200528     C*******************Z-ADD     500           PTPU2Ln           4 0                 CSC011 CAP083
370700200528     C*******************Z-ADD     500           PTSO2Ln           4 0                 CSC011 CAP083
370800200528     C*****Recordlen     SUB       1000          LOAN3Ln           4 0                 CSC011 CAP083
370900200528     C*****Recordlen     SUB       1000          PTPU3Ln           4 0                 CSC011 CAP083
371000200528     C*****Recordlen     SUB       1000          PTSO3Ln           4 0                 CSC011 CAP083
371100200528                                                                                       CSC011 CAP083
371200200528      ***LE*Loan*Amendment*Input                                                       CSC011 CAP083
371300200528      **Principal*Transfer*To                                                          CSC011 CAP083
371400200528      **Principal*Transfer*From                                                        CSC011 CAP083
371500200528      **Principal*Increase****                                                         CSC011 CAP083
371600200528      **Base Rate*Change*****                                                          CSC011 CAP083
371700200528      **Spread*Change********                                                          CSC011 CAP083
371800200528      **Stop/Start*Change*Accrual                                                      CSC011 CAP083
371900200528      **Loan*Subtype*Change******                                                      CSC011 CAP083
372000200528     C****************** MOVEL     'LEA1MFPD'    FileName                              CSC011 CAP083
372100200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
372200200528     C*******************Z-ADD     500           LAPT1Ln           4 0                 CSC011 CAP083
372300200528     C*******************Z-ADD     500           LAPF1Ln           4 0                 CSC011 CAP083
372400200528     C*******************Z-ADD     500           LAPI1Ln           4 0                 CSC011 CAP083
372500200528     C*******************Z-ADD     500           LABC1Ln           4 0                 CSC011 CAP083
372600200528     C*******************Z-ADD     500           LASC1Ln           4 0                 CSC011 CAP083
372700200528     C****************** Z-ADD     500           LASA1Ln           4 0                 CSC011 CAP083
372800200528     C****************** Z-ADD     500           LALS1Ln           4 0                 CSC011 CAP083
372900200528     C*****Recordlen     SUB       LAPT1Ln       LAPT2Ln           4 0                 CSC011 CAP083
373000200528     C*****Recordlen     SUB       LAPF1Ln       LAPF2Ln           4 0                 CSC011 CAP083
373100200528     C*****Recordlen     SUB       LAPI1Ln       LAPI2Ln           4 0                 CSC011 CAP083
373200200528     C*****Recordlen     SUB       LABC1Ln       LABC2Ln           4 0                 CSC011 CAP083
373300200528     C*****Recordlen     SUB       LASC1Ln       LASC2Ln           4 0                 CSC011 CAP083
373400200528     C*****Recordlen     SUB       LASA1Ln       LASA2Ln           4 0                 CSC011 CAP083
373500200528     C*****Recordlen     SUB       LALS1Ln       LALS2Ln           4 0                 CSC011 CAP083
373600200528                                                                                       CSC011 CAP083
373700200528      ***LE*Rollover*Input*format*****                                                 CSC011 CAP083
373800200528                                                                                       CSC011 CAP083
373900200528     C*******************MOVEL     'LEO1MFPD'    FileName                              CSC011 CAP083
374000200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
374100200528     C*******************Z-ADD     500           ROLL1Ln           4 0                 CSC011 CAP083
374200200528     C*****Recordlen     SUB       ROLL1Ln       ROLL2Ln           4 0                 CSC011 CAP083
374300200528                                                                                       CSC011 CAP083
374400200528      ***LE*Manual*Repayment*format***                                                 CSC011 CAP083
374500200528                                                                                       CSC011 CAP083
374600200528     C*******************MOVEL     'LEM1MFPD'    FileName                              CSC011 CAP083
374700200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
374800200528     C*******************Z-ADD     500           LAMR1Ln           4 0                 CSC011 CAP083
374900200528     C*****Recordlen     SUB       LAMR1Ln       LAMR2Ln           4 0                 CSC011 CAP083
375000200528                                                                                       CSC011 CAP083
375100200528      ***LE*Fees*Input*Maintenance*format***                                           CSC011 CAP083
375200200528                                                                                       CSC011 CAP083
375300200528     C*******************MOVEL     'LEF3MFPD'    FileName                              CSC011 CAP083
375400200528     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
375500200528     C*******************Z-ADD     500           FEES1Ln           4 0                 CSC011 CAP083
375600200528     C*****Recordlen     SUB       FEES1Ln       FEES2Ln           4 0                 CSC011 CAP083
375700200528                                                                                       CAP068 CAP083
375800200528      ***Caps/Collars/Floors*Format*Definition*File***                                 CAP055 CAP083
375900200528                                                                                       CAP055 CAP083
376000200528     C*******************EVAL      Filename = 'IRCACFPD'                               CAP055 CAP083
376100200528     C*******************EXSR      GETRCDLN                                            CAP055 CAP083
376200200528     C*******************Z-ADD     RecordLen     CACFLn                                CAP055 CAP083
376300200528                                                                                       CAP055 CAP083
376400200528      ***Caps/Collars/Floors*Extra*Data*File***                                        CAP055 CAP083
376500200528                                                                                       CAP055 CAP083
376600200528     C*******************EVAL      Filename = 'IRCPEXPD'                               CAP055 CAP083
376700200528     C*******************EXSR      GETRCDLN                                            CAP055 CAP083
376800200528     C*******************Z-ADD     RecordLen     CACXLn                                CAP055 CAP083
376900200528                                                                                       CAP038 CAP083
377000200528      ***SE*Movements Status: Primary and Extra Details                                CSE039 CAP083
377100200528      *                                                                                CSE039 CAP083
377200200528     C*******************MOVEL (P) 'SEMVTS1PD'   FileName                              CSE039 CAP083
377300200528     C*******************EXSR      GETRCDLN                                            CSE039 CAP083
377400200528     C*******************Z-ADD     RecordLen     MVTSLn            4 0                 CSE039 CAP083
377500200528      *                                                                                CSE039 CAP083
377600200528     C*******************MOVEL (P) 'SEMVEXPD'    FileName                              CSE039 CAP083
377700200528     C*******************EXSR      GETRCDLN                                            CSE039 CAP083
377800200528     C*******************Z-ADD     RecordLen     MVEXLn            4 0                 CSE039 CAP083
377900200528                                                                                       CAP182 CAP083
378000200528      ***Get*record length of Data Layout files for SE Trade                           CAP182 CAP083
378100200528      ***Settlements*API.                                                              CAP182 CAP083
378200200528     C*******************MOVEL     'SETRSMPD'    FileName                              CAP182 CAP083
378300200528     C*******************EXSR      GETRCDLN                                            CAP182 CAP083
378400200528     C*******************Z-ADD     RecordLen     TRSMLn                                CAP182 CAP083
378500200528                                                                                       CAP182 CAP083
378600200528      ***SE*Statement Production Requests: Primary and Extra Details                   CSE040 CAP083
378700200528      *                                                                                CSE040 CAP083
378800200528     C*******************MOVEL (P) 'SESTPR1PD'   FileName                              CSE040 CAP083
378900200528     C*******************EXSR      GETRCDLN                                            CSE040 CAP083
379000200528     C*******************Z-ADD     RecordLen     STPRLn            4 0                 CSE040 CAP083
379100200528      *                                                                                CSE040 CAP083
379200200528     C*******************MOVEL (P) 'SESPEXPD'    FileName                              CSE040 CAP083
379300200528     C*******************EXSR      GETRCDLN                                            CSE040 CAP083
379400200528     C*******************Z-ADD     RecordLen     SPEXLn            4 0                 CSE040 CAP083
379500200528                                                                                       CAP055 CAP083
379600200528     C/COPY WNCPYSRC,APINCOMMC2
379700200528      ***Ensure*that*all*the*API*data*queues*exist*                                    153108 CPK030
379800200528     C********           CLEAR                   ReturnCode                            153108 CPK030
379900200528     C********           CALL      'APCRTDTAQS'                                        153108 CPK030
380000200528     C********           PARM                    ReturnCode                            153108 CPK030
380100200528                                                                                CAP004
380200200528     C                   ENDSR
380300200528      ****************************************************************
380400200528      /EJECT
380500200528      ****************************************************************
380600200528      **------------------------------------------------------------------------
380700200528      ** The following /COPY contains the standard program status
380800200528      ** subroutine, including a bound call to the DBERRCTL module.
380900200528     C/COPY ZACPYSRC,PSSR_ILE
381000200528      **------------------------------------------------------------------------
381100200528      ****************************************************************
381200200528      /EJECT
381300200528      ****************************************************************
381400200528**  CPY@
381500200528(c) Finastra International Limited 2001
381600200528**  CHG@                                                                                      CDL010
381700200528CHGDTAARA DTAARA(QTEMP/ZMUSER (1 10)) VALUE('                                                 CDL010
381800200528**  CJOB@                                                                                   AR401481
381900200528CHGJOB SWS(XXXXXX00)                                                                        AR401481
