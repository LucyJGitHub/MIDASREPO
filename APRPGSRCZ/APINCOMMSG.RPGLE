     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*S*D****RPGBASEMOD****************************************************                     MD039105
/*STD *  RPGSQLMOD                                                    *                     MD039105
/*EXI *  TEXT('Midas AP Process incoming messages')                   *
      *****************************************************************
      *                                                               *
      *  Midas - API Interface Module                                 *
      *                                                               *
      *  APINCOMMSG - Midas API Process incoming messages             *
      *                                                               *
      *  Function:  This program processes messages received via the  *
      *             MQSeries queues which exist on the AS/400.        *
      *             Messages are held on the queue as character       *
      *             strings, and must be separated into MM fields     *
      *             using data structures. The program will run in    *
      *             batch, using an MQGET call to wait indefinitely   *
      *             for incoming messages. Transaction details are    *
      *             passed to the relevant API for validation then    *
      *             storage in the Midas database.                    *
      *                                                               *
      *  Calls - APPARSMSG - Set up Transaction and Settlement Data   *                       CAP083
      *                                                               *                       CAP083
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. MD041126           Date 02Dec19               *
      *  Prev Amend No. CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD039105           Date 06Jun16               *
      *                 CSW216             Date 14Mar16               *
      *                 CPK030             Date 11Apr14               *
      *                 CSW214             Date 25Nov14               *
      *                 CDL094             Date 11Jun14               *
      *                 CGL132             Date 01May13               *
      *                 CSW213             Date 03Jun13               *
      *                 CFT120             Date 28Sep12               *
      *                 CFT039             Date 28Sep12               *
      *                 AR401481           Date 02Oct12               *
      *                 CSF011A            Date 28Nov11               *
      *                 CER059             Date 19Jul10               *
      *                 262664             Date 11Nov09               *
      *                 BUG25877           Date 03Sep09               *
      *                 BUG23518A          Date 07Apr09               *
      *                 CER034             Date 19May08               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 256564             Date 17Sep08               *
      *                 CAP186C            Date 28Jan08               *
      *                 248095A            Date 26Jun07               *
      *                 246730             Date 17Apr07               *
      *                 248920             Date 05Jul07               *
      * Midas Plus 1.4 Base ------------------------------------------*
      *                 245862             Date 21Feb07               *
      *                 245310             Date 29Jan07               *
      *                 243084             Date 10Jul06               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241470             Date 07Sep06               *
      *                 BUG9887            Date 12Jan06               *
      *                 CER001             Date 25Apr05               *
      *                 CGL032             Date 05Jul04               *
      *                 CLE031             Date 26Apr05               *
      *                 PB0210             Date 28Mar02               *
      *                 CDL018             Date 03Feb04               *
      *                 CAP083             Date 20Feb03               *
      *                 CSE040             Date 28Mar03               *
      *                 CAP182             Date 14Mar03               *
      *                 CSE039             Date 07Mar03               *
      *                 CAS006             Date 21Jan03               *
      *                 214637             Date 05Feb03               *
      *                 CAP043             Date 02May02               *
      *                 CDL010             Date 02Aug02               *
      * Midas Release 4.01.03 ----------------------------------------*
      * Midas Release 4.01.02 ----------------------------------------*
      *                 209905             Date 25Sep02               *
      *                 200299             Date 05Jul02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 CAP056             Date 13Mar02               *
      *                 CAP055             Date 13Mar02               *
      *                 CPK015             Date 17May02               *
      *                 CSC011             Date 30Apr02               *
      *                 CAP072             Date 28Mar02               *
      *                 CAP071             Date 22Mar02               *
      *                 CAP068             Date 22Mar02               *
      *                 CAP070             Date 11Mar02               *
      *                 CSE031             Date 13Dec01               *
      *                 CAP166             Date  5Mar02               *
      *                 CAS001             Date 23Nov01               *
      *                 CAP067             Date 24Sep01               *
      *                 CSW024             Date 31Aug01               *
      *                 196570             Date 23Jul01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 CSE022             Date 29Mar01               *
      *                 175715             Date 08May01               *
      *                 175717             Date 08May01               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CAP038             Date 08Jan01               *
      *                 CAP057             Date 08Jan01               *
      *                 CAP042             Date 08Jan01               *
      *                 CSD006             Date 31Oct00               *
      *                 186715             Date 17Jan01               *
      *                 CAP140             Date 17Oct00               *
      *                 188376             Date 08Jan01               *
      *                 CIR003             Date 13Sep00               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 182598             Date 14Aug00               *
      *                 CAP039             Date 14Jul00               *
      *                 CAP137             Date 07Feb00               *
      *                 CAP136             Date 15Nov99               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CAP035             Date 08Jul99               *
      *                 CAP034             Date 08Jul99               *
      *                 CAP031             Date 08Jul99               *
      *                 CAP051             Date 08Nov99               *
      *                 CDL007             Date 05Oct99               *
      *                 CAP032             Date 06Oct99               *
      *                 CAP033             Date 07Sep99               *
      * Midas DBA 3.01 -----------------------------------------------*
      *                 CAP030             Date 12Mar99               *
      * Midas DBA 3.00 ---------------- Base -------------------------*
      *                 CPL002             Date 08Mar99               *
      *                 CAP006             Date 04Dec98               *
      *                 153108             Date 13Jan99               *
      *                 CAP005             Date 09Nov98               *
      *                 CAP004             Date 27Jul98               *
      *                 CAP003             Date 03Jul98               *
      *                 138019             Date 30Jun98               *
      *                 CAP002  *CREATE    Date 20Sep97               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  MD041126 - Certify WebSphere MQ 9 with Midas product line    *
      *           - Applied for MD-53992                              *
      *  CSD102 - Password Length Extension                           *
      *  MD046248 - Finastra Rebranding                               *
      *  MD039105 - Data truncation encountered when trying to insert *
      *             CUSD MQ and SOAP transaction with UDF fields      *
      *           - Applied for MD-39420.                             *
      *  CSW216 - SWIFT Changes 2016 (Recompile)                      *
      *  CPK030 - Clean up of deliverable data library.               *
      *  CSW214 - SWIFT Changes 2014                                  *
      *  CDL094 - Enhance Receive Settlement Instructions (Recompile) *
      *  CGL132 - FATCA Phase 1 - Customers' Identification and       *
      *           Classification - Master                             *
      *  CSW213 - SWIFT Changes 2013                                  *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CFT039 - SWIFT Mapping of Field Ordering Bank                *
      *           DS introduced by CSF011A not being passed promperly *
      *           from APPARSMSG to APCCALLCTL                        *
      *           Amendment done to accommodate longer data           *
      *  AR401481 - Some API messages were lost during processing of  *
      *             APISERVER                                         *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  262664 - GF Phase 1 - Incorrect parameter - FTIPAYCTL /      *
      *           FTOPAYCTL.                                          *
      *         - Corrected the parameters.                           *
      *  BUG25877 - Data is always truncated and ends in ACUD repair  *
      *  BUG23518A - Produce Annual Tax Deducted Statement upon       *
      *              Customer Closure                                 *
      *  CER034A - LF046 German Features - New Fields and Enquiries   *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  CAP186C - MQ Enabled CB APIs. Buffer length of APOUTPUTPD    *
      *           increased to 32000. Renamed buffer field of this    *
      *           file to avoid conflict with other buffers used in   *
      *           this program                                        *
      *  248095A- Ensure connection handle is always valid. Applied   *
      *           fix 245310B. Monitor for MQ error 2019 as well as   *
      *           2018 (MQGET). Applied fix 245310C. Re-open queue if *
      *           connection handle is retrieved. Applied fix 245310D.*
      *  246730 - Change fix incorporation for 245310.                *
      *  248920 - Fix OPAY API parameters wh. are too short for two   *
      *           formats, by creating new API versions with larger   *
      *           parameter sizes.                                    *
      *  245862 - To use JOB user as default user instead of MQM user.*
      *  245310 - Connect to MQ queue manager held on data area       *
      *           APIMQM and use connection handle from this          *
      *           connection for other MQ API calls in the program    *
      *  243084 - Incorrect/missing parsing.                          *
      *           Remove CGL032 as processing to set up the           *
      *           Transaction & Settlement Data Structures was moved  *
      *           to module APPARSMSG by CAP083 (See below).          *
      *  241470 - Applied fix BUG9887.                                *
      *  BUG9887 - No information passed to IRCIRSCTL at all...       *
      *  CER001 - LUX Upgrade to MidasPlus                            *
      *  CGL032 - Automatic Exchange of Information                   *
      *  CLE031 - Lending Enhancements - Settlement Currency Recompile*
      *  PB0210 - Additional Customer Details Interface.              *
      *           Recompiled over changes in SDCUEXPD                 *
      *  CDL018 - Multiple Settlement Accounts on Loans/Deposits      *
      *           (Recompile)                                         *
      *  CAP083 - APISERVER File Adapter.                             *
      *           Processing to Set up the Transaction & Settlement   *
      *           Data Structures has been moved to module APPARSMSG. *
      *  CSE040 - Securities Statement Processing                     *
      *  CAP182 - Auto Settlement of Trades                           *
      *         - Conversion of SE Trade Settlement Input maintence   *
      *           function to modular structure to use as APIs.       *
      *  CSE039 - Automatic Settlement of Trades                      *
      *  CAS006 - Hedge Accounting Phase B                            *
      *  214637 - Incorrect API definition files used                 *
      *  CAP043 - Additional APIs for IRS Schedules                   *
      *  CDL010 - Prevent last user that actioned the trade from      *
      *           authorising it.                                     *
      *  209905 - Fiduciary API Enhancement                           *
      *  200299 - Recompile due to change in SETRIFPD                 *
      *  CAP056 - Automatic Authorisation of Interface Deals          *
      *  CAP055 - APIs for FRA/IRS Caps/Collars/Floors                *
      *  CPK015 - Prevent APISERVER looping when unknown message type *
      *           is encountered.                                     *
      *         - Exit program if record length not found             *
      *  CSC011 - Midas 24x7 Availability for LE                      *
      *  CAP072 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Fee Settlement and Adjustment input    *
      *  CAP071 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Facility Amendment.                    *
      *  CAP068 - Conversion of LE inputs into modular structure to   *
      *           use as APIs. Funding Participants.                  *
      *  CAP070 - Conversion of LE inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CSE031 - Coupon Fixing for Floating Rate Notes.              *
      *  CAP166 - API for Non-Currency OTC                            *
      *  CAS001 - Net Present Value (NPV) Accounting                  *
      *  CAP067 - Repurchase Agreements API.                          *
      *  CSW024 - S.W.I.F.T. MT3xx Field 82/83/87.                    *
      *  196570 - Patch for Market Data Feed                          *
      *  CSE022 - Depository Definition Enhancement                   *
      *  175715 - SE Walk In Depot Movements Extra Data files do not  *
      *           exist. SEWIEXPD and SEWOEXPD replaced by SEDMEXPD   *
      *  175717 - SE Trades Extra Data file is wrong                  *
      *  CAP038 - Midas Base Rates API                                *
      *  CAP057 - Midas Spot Rates API                                *
      *  CAP042 - Conversion of Internal Funding Deal inputs into     *
      *           modular structure to use as APIs.                   *
      *  CSD006 - Market Data Feeds                                   *
      *  186715 - Customer Settlements Instructions is missing for    *
      *           FF Currency over-the-counter                        *
      *  CAP140 - Conversion of SE Security Diary Event inputs into   *
      *           modular structure to use as APIs.                   *
      *  188376 - Incorrect data are passed to the controller         *
      *  CIR003 - FRA/IRS Pay/Receive Messages for Swaps              *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  182598 - Enlarge buffer to cater for Interest Rate Calendars *
      *           including extra data                                *
      *  CAP039 - SD Security Customer Details API                    *
      *  CAP137 - Conversion of SE Securities inputs into modular     *
      *           structure to use as APIs.                           *
      *  CAP136 - Conversion of FT Incoming Payment inputs into       *
      *           modular structure to use as APIs.                   *
      *  CAP035 - Midas / ToF Interface, GL Accounts maintenance      *
      *  CAP034 - Midas / ToF Interface, SD Customers details         *
      *  CAP031 - Midas / ToF Interface, FT Outgoing Payments         *
      *           Also fixed a problem with the record length         *
      *           checking: the file name field was not cleared       *
      *           between uses, and it is being set up with MOVEL, so *
      *           its content could become corrupted.  It would be    *
      *           better if EVAL were used instead of MOVEL, but a    *
      *           fix which avoids changing all the existing lines of *
      *           code is to clear the field at the end of the        *
      *           GETRCDLN subroutine.                                *
      *  CAP051 - Automatic Authorisation                             *
      *  CDL007 - Deposit Breakdown Penalty                           *
      *  CAP032 - Conversion of Journal Batch Entry inputs into       *
      *           modular structure to use as APIs.                   *
      *  CAP033 - Conversion of PM inputs into modular structure to   *
      *           use as APIs.                                        *
      *  CAP030 - APIs for SE Price Input.                            *
      *  CPL002 - Midas-Plato Interface (Recompiled)                  *
      *  CAP006 - API structural breakdown: correct text on call      *
      *           to APCCALLCTL.                                      *
      *  153108 - Call the program to create all the API data queues, *
      *           to ensure that they always exist.                   *
      *  CAP005 - Add APIs phase 4 calls.                             *
      *  CAP004 - Add APIs phase 3 calls.                             *
      *  CAP003 - Add APIs phase 2 calls.                             *
      *  138019 - Module was sending gibberish to QSYSOPR when        *
      *           an MQSeries call failed.  This was because the      *
      *           MQError field was being passed to ZAMSGTOOPR as 28  *
      *           bytes, when ZAMSGTOOPR expects 132.                 *
      *  CAP002 - Conversion of Midas inputs to modular API structure *
      *                                                               *
      *****************************************************************
      /EJECT
 
      ** File to log received data
     F***APOUTPUTPDO*   E           K DISK                                                   CAP186C
     F***APOUTPUTPDO    E           K DISK    PREFIX(O_)                            CAP186C MD039105
 
      ** File to log unauthorised access attempts
     FAPUNAUTHPDO    E           K DISK    USROPN
 
      ** File to log details of message after exception error
     FAPEXCPERPDO    E           K DISK
 
      ** File to log job details
     FAPIJOBL0  O    E           K DISK    USROPN
 
     F/COPY WNCPYSRC,APH00044
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
 
      * Constant to hold input parameter for AOSVALR0.                                        245310
     D MQManager       C                   Const('MQQueueManagerAPI')                         245310
                                                                                              245310
      ** Input queue name
     D RootQueue       C                   CONST('MIDASXX.TRANSACT.Q')
 
      ** MQSeries error message literals
     D OpenFailed      C                   CONST('MQSeries MQOPEN failed: ')
     D ReadFailed      C                   CONST('MQSeries MQGET  failed: ')
     D ClosFailed      C                   CONST('MQSeries MQCLOS failed: ')
     D ConnFailed      C                   CONST('MQSeries MQCONN failed: ')                  245310
     D DiscFailed      C                   CONST('MQSeries MQDISC failed: ')                  245310
 
      ** Do NOT change the following constant values. Alterations
      ** here require changes to PC applications.
 
      * Don't need little letters...
     D CHARSET         C                   'ABCDEFGHIJKLMNOPQRST-
     D                                     UVWXYZABCDEFGHIJKLMN-
     D                                     OPQRSTUVWXYZ12345678-
     D                                     90 '
     D CIPHER          C                   '156RS2czIj9BY aNDrEw-
     D                                     JAmesC0oKunlO4G3i-
     D                                     XhW8pxQftVvTPLHgFdby-
     D                                     7qkZUM'
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
     D/COPY WNCPYSRC,APH00045
 
     D SDAPI         E DS                  EXTNAME(SDAPIPD)
      ** External DS for API ICD
 
      ***External*DS*for*SAR*Details*******                                            CAS001 CAP083
     D*SCSARD********E DS                  EXTNAME(SCSARDPD)                           CAS001 CAP083
     D/COPY WNCPYSRC,APH00046
                                                                                              CAS001
     D DSFDY         E DS                  EXTNAME(DSFDY)
     D* FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
 
      ** Data area containing system prefix
     D SDSTAT        E DS                  DTAARA(SDSTAT)
 
      ** Data area for queue name
     D                 DS
     D  QIN                    1     20
     D  SysPrefix              6      7
 
      ** Incoming message header format
     D APHEAD        E DS                  EXTNAME(APHEADPD)
 
     D/COPY WNCPYSRC,APH00047
 
      ** Data structure for incoming message formats
     D*BUFFER****      DS          3000                                         CAP004
     D*BUFFER******    DS          4000                                                 CAP004182598
     D*BUFFER***       DS          5000                                                182598 CIR003
     D*BUFFER********* DS          6000                                                CIR003 CFT039
     D*BUFFER***       DS         12000                                                CFT039 CSW213
     D BUFFER          DS         29997                                                       CSW213
     D  TYPE                   1      8
     D  USERID                33     42
     D**PASSWORD              43     52                                                       CSD102
     D  PASSWORD              43    170                                                       CSD102
 
      ** Command to update dtaara ZMUSER                                                      CDL010
     D CHG@            S             45    DIM(1) CTDATA PERRCD(1)                            CDL010
                                                                                              CDL010
      ** Data area fo ZMUSER                                                                  CDL010
     D ZMUSER          DS            17                                                       CDL010
     D  USRID                  1     10                                                       CDL010
                                                                                              CDL010
      ** Dummy Cmd Text                                                                       CDL010
     D CMDTXT          DS            57                                                       CDL010
     D ALLTXT                  1     57                                                       CDL010
     D USRTXT                 46     55                                                       CDL010
     D QOTTXT                 56     57                                                       CDL010
                                                                                              CDL010
      ** Command to reset U7 and U8                                                         AR401481
     D CJOB@           S             20    DIM(1) CTDATA PERRCD(1)                          AR401481
                                                                                            AR401481
      **  Declare MQI structures needed
      * MQI Constants
     D***/COPY*QMQM/QRPGLESRC,CMQR                                                          MD041126
     D/COPY QMQM/QRPGLESRC,CMQG                                                             MD041126
 
      ** Object Descriptor
     D MQOD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQODR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQODG                                                           MD041126
 
      ** Message Descriptor
     D MQMD            DS
     D***/COPY*QMQM/QRPGLESRC,CMQMDR                                                        MD041126
     D/COPY QMQM/QRPGLESRC,CMQMDG                                                           MD041126
 
      ** Get message options
     D MQGMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQGMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQGMOG                                                          MD041126
 
      ** Put message options
     D MQPMO           DS
     D***/COPY*QMQM/QRPGLESRC,CMQPMOR                                                       MD041126
     D/COPY QMQM/QRPGLESRC,CMQPMOG                                                          MD041126
 
 
      ** The include below brings in the return code structure that
      ** is used in calls to OS/400 APIs.
     D/COPY QSYSINC/QRPGLESRC,QUSEC
      * API Error code parameter
 
     D PaySttmt      E DS                  EXTNAME(SDESSPPD)
      * Pay Settlement Instructions
     D RecSttmt      E DS                  EXTNAME(SDESSRPD)
      * Receive Settlement Instructions
     D FRASttmt      E DS                  EXTNAME(SDESSFPD)
      * FRA/IRS Settlement Instructions
                                                                                              CIR003
     D PayStmtV      E DS                  EXTNAME(SDESSPPD)  PREFIX(V)                       CIR003
      * Pay Settlement Instructions                                                           CIR003
     D RecStmtV      E DS                  EXTNAME(SDESSRPD)  PREFIX(V)                       CIR003
      * Receive Settlement Instructions                                                       CIR003
                                                                                              CIR003
     D PayStmtM      E DS                  EXTNAME(SDESSPPD)  PREFIX(M)                       CIR003
      * Pay Settlement Instructions                                                           CIR003
     D RecStmtM      E DS                  EXTNAME(SDESSRPD)  PREFIX(M)                       CIR003
      * Receive Settlement Instructions                                                       CIR003
 
     D  DLRIS1In     E DS                  EXTNAME(DLRIS1PD)                                  CSW213
     D  DLRIS2In     E DS                  EXTNAME(DLRIS2PD)                                  CSW213
     D  DLRIS3In     E DS                  EXTNAME(DLRIS3PD)                                  CSW213
     D  DLRIS4In     E DS                  EXTNAME(DLRIS4PD)                                  CSW214
     D  SDSW13In     E DS                  EXTNAME(SDSW13PD)                                  CSW213
     D                                     PREFIX(S13)                                        CSW213
                                                                                              CSW213
     D InSwift2013     DS                                                                     CSW213
     D   DLRIS1DS                          LIKE(DLRIS1In)                                     CSW213
     D   DLRIS2DS                          LIKE(DLRIS2In)                                     CSW213
     D   DLRIS3DS                          LIKE(DLRIS3In)                                     CSW213
     D   DLRIS4DS                          LIKE(DLRIS4In)                                     CSW214
      * Reporting Information                                                                 CSW213
                                                                                              CSW213
     D Trans9999_2     DS          9999                                                       CSW213
     D  SDSW13Ds                           LIKE(SDSW13In)                                     CSW213
     D  Trans2Fil8942              8942                                                       CSW213
                                                                                              CSW213
     D Trans9999_3     DS          9999                                                       CSW213
      ** +--------------------------------------+
      ** ¦ Declared Variables                   ¦
      ** ¦ ==================                   ¦
      ** +--------------------------------------+
 
      ** The following /COPY line includes definitions for the above fields
      ** as #ProcPgm, #ProcMod and #ProcName.  They are based on the
      ** corresponding fields in the PSDS /COPY member, so that member
      ** must be included where this one is used.
     D/COPY ZACPYSRC,PROCPARMS
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      ** Real message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D MsgID           S                   LIKE(#MsgID)
     D MsgF            S             10A
 
     D Object          S             10A   INZ('APISERVER')
     D Lib             S             10A   INZ('*LIBL')
     D ObjType         S              7A   INZ('*DTAARA')
     D LockStateS      S              7A   INZ('*SHRRD')
     D Member          S             10A
     D WaitTime        S              6A   INZ('*CLS')
     D Dlcobj          S              1A
     D Return          S              7A
     D Bypass          S              1A                                                      CPK015
 
      ** Error message for sending to the operator                              138019
     D MQError         S            132A                                        138019
                                                                                138019
      ** Alpha version of the MQSeries reason code                              138019
     D ReasonA         S              9A                                        138019
                                                                                138019
      ** Other Depot Details for Securities Customer.                                         CSE022
      ** This totals to 150 additional other depot details from the incoming message.         CSE022
     D OthDData        S           4755A                                                      CSE022
                                                                                              CSE022
      ***Work*variables used by CAP042                                                 CAP042 CAP083
     D*FUNDLn**********S              4P 0                                             CAP042 CAP083
     D*FUEXLn**********S              4P 0                                             CAP042 CAP083
      *****************                                                                CAP042 CAP083
      *                                                                                CAP140 CAP083
      ***Work*variables used by CAP140.                                                CAP140 CAP083
     D*SEDELn**********S              4P 0                                             CAP140 CAP083
     D*SDEXLn**********S              4P 0                                             CAP140 CAP083
      *****************                                                                CAP140 CAP083
      ***Work*variables used by CAP182.                                                CAP140 CAP083
     D*TRSMLn**********S              4P 0                                             CAP140 CAP083
     D*TREXLn**********S              4P 0                                             CAP140 CAP083
      ***Work*variable used by CSE022                                                  CSE022 CAP083
     D*SDSOLn**********S              4P 0                                             CSE022 CAP083
                                                                                       CSE022 CAP083
      ***Work*variables*used*by*CAP067                                                 CAP067 CAP083
     D*REP1Ln**********S              4P 0                                             CAP067 CAP083
     D*REP2Ln**********S              4P 0                                             CAP067 CAP083
      ******************                                                               CAP067 CAP083
      ***Work*variables*used by CAP055/CAP056                                          CAP055 CAP083
     D*CACFLn**********S              4P 0                                             CAP055 CAP083
     D*CACXLn**********S              4P 0                                             CAP055 CAP083
     D*IRRSLn**********S              4P 0                                             CAP056 CAP083
     D*IRRXLn**********S              4P 0                                             CAP056 CAP083
     D*IRRPLn**********S              4P 0                                             CAP056 CAP083
     D*IRFALn**********S              4P 0                                             CAP056 CAP083
      *****************                                                                CAP055 CAP083
      ***Work*variable*used by CAS001                                                  CAS001 CAP083
     D*SDYRLn**********S              4P 0                                             CAS001 CAP083
     D*YRAT1Ln*********S              4P 0                                             CAS001 CAP083
     D*YRAT2Ln*********S              4P 0                                             CAS001 CAP083
     D*YRAT3Ln*********S              4P 0                                             CAS001 CAP083
     D*YRAT4Ln*********S              4P 0                                             CAS001 CAP083
     D*PRtCd***********S              7A                                               CAS001 CAP083
     D*POptn***********S              7A                                               CAS001 CAP083
     D*PSarD***********S              6A                                               CAS001 CAP083
     D*CAS001**********S              1A                                               CAS001 CAP083
                                                                                       CAS001 CAP083
      ***Work*variables*used by CDL006                                                 209905 CAP083
     D*CDL006**********S              1A                                               209905 CAP083
     D*WFIDT1Ln********S              4P 0                                             209905 CAP083
     D*WFIDT2Ln********S              4P 0                                             209905 CAP083
     D*WFIDT3Ln********S              4P 0                                             209905 CAP083
     D*WFIDT4Ln********S              4P 0                                             209905 CAP083
     D*WFIDT5Ln********S              4P 0                                             209905 CAP083
     D*WFIDT6Ln********S              4P 0                                             209905 CAP083
     D*WFIDT7Ln********S              4P 0                                             209905 CAP083
     D*WFIDT8Ln********S              4P 0                                             209905 CAP083
     D*WFIDT9Ln********S              4P 0                                             209905 CAP083
      *****************                                                                209905 CAP083
      ***Work*variable*used by CAP043                                                  CAP043 CAP083
     D*CAP043**********S              1A                                               CAP043 CAP083
     D*WCFSC1OLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC2OLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC3OLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC4OLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC1OLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC2OLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC3OLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC4OLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC1TLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC2TLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC3TLn*******S              4P 0                                             CAP043 CAP083
     D*WCFSC4TLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC1TLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC2TLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC3TLn*******S              4P 0                                             CAP043 CAP083
     D*WPCSC4TLn*******S              4P 0                                             CAP043 CAP083
     D*WTRSCLn*********S              4P 0                                             CAP043 CAP083
                                                                                              CAP043
     D PSysVal01       S             20A                                                      245310
     D PCurSet01       S            200A                                                      245310
     D PSysVal02       S             20A                                                      245310
     D PCurSet02       S            200A                                                      245310
     D PSysVal03       S             20A                                                      245310
     D PCurSet03       S            200A                                                      245310
     D PSysVal04       S             20A                                                      245310
     D PCurSet04       S            200A                                                      245310
     D PSysVal05       S             20A                                                      245310
     D PCurSet05       S            200A                                                      245310
     D PSysVal06       S             20A                                                      245310
     D PCurSet06       S            200A                                                      245310
     D PSysVal07       S             20A                                                      245310
     D PCurSet07       S            200A                                                      245310
     D PSysVal08       S             20A                                                      245310
     D PCurSet08       S            200A                                                      245310
     D PSysVal09       S             20A                                                      245310
     D PCurSet09       S            200A                                                      245310
     D PSysVal10       S             20A                                                      245310
     D PCurSet10       S            200A                                                      245310
                                                                                              245310
      ***Work*variable*used*by*CGL032**********************************                CGL032 243084
     D*ACUDLn**********S              4P 0                                             CGL032 243084
     D*ACEXLn**********S              4P 0                                             CGL032 243084
     D*SDNALn**********S              4P 0                                             CGL032 243084
     D*NaEXLn**********S              4P 0                                             CGL032 243084
     D*CCTXLn**********S              4P 0                                             CGL032 243084
     D*NATXLn**********S              4P 0                                             CGL032 243084
     D*JACMLn**********S              4P 0                                             CGL032 243084
      **********                                                                       CGL032 243084
     D*Bfp*************S              4P 0                                             CGL032 243084
     D*RecordLen*******S              5P 0                                             CGL032 243084
      ** Work variable used by CSW209                                                         CSW209
     D TRANS9          S            500A                                                      CSW209
     D TRANS9A         S           1000A                                                      CSW209
     D TRANS9B         S           1000A                                                      CSW209
     D TRANS9C         S           3000A                                                      CGL132
                                                                                              CSW209
      *                                                                                      CER034A
      ** Work variable used by CER034                                                        CER034A
      *                                                                                      CER034A
     D Trans10         S            500A                                                     CER034A
     D Trans11         S            500A                                                     CER034A
     D Trans12         S            500A                                                     CER034A
     D Trans13         S            500A                                                     CER034A
     D Trans14         S            500A                                                     CER034A
     D Trans15         S            500A                                                     CER034A
     D Trans16         S            500A                                                     CER034A
     D Trans17         S            500A                                                     CER034A
     D Trans3A         S           1000A                                                      CFT120
     D Trans5A         S           1000A                                                      CFT120
                                                                                              CSW213
     D RPIFLn          S              4P 0                                                    CSW213
     D CU13Ln          S              4S 0                                                    CSW213
     D O_BUFFER        S          32000                                                     MD039105
                                                                                            MD041126
      ** MQ Parameters                                                                      MD041126
     D QMNAME          S             48A                                                    MD041126
     D HANDLE          S             10I 0                                                  MD041126
     D OCODE           S             10I 0                                                  MD041126
     D CCODE           S             10I 0                                                  MD041126
     D REASON          S             10I 0                                                  MD041126
     D HCONN           S             10I 0                                                  MD041126
     D OPTS            S             10I 0                                                  MD041126
     D HIN             S             10I 0                                                  MD041126
     D BUFLEN          S             10I 0                                                  MD041126
     D MESLEN          S             10I 0                                                  MD041126
      ** +--------------------------------------+
      ** ¦ End of D-specs                       ¦
      ** ¦ ==============                       ¦
      ** +--------------------------------------+
 
      ****************************************************************
      *                                                              *
      *  Main processing                                             *
      *                                                              *
      ****************************************************************
 
      ** If a Queue Manager is specified on system value MQManager, connect                   245310
      ** to it and retain connection handle for other QMQM calls instead                      245310
      ** of using the default Queue Manager and connection                                    245310
                                                                                              245310
     C                   CALLB     'AOSVALR0'                                                 245310
     C                   PARM      *BLANKS       PRtCd             7                          245310
     C                   PARM      MQManager     PSysVal01                                    245310
     C                   PARM                    PCurSet01                                    245310
     C                   PARM                    PSysVal02                                    245310
     C                   PARM                    PCurSet02                                    245310
     C                   PARM                    PSysVal03                                    245310
     C                   PARM                    PCurSet03                                    245310
     C                   PARM                    PSysVal04                                    245310
     C                   PARM                    PCurSet04                                    245310
     C                   PARM                    PSysVal05                                    245310
     C                   PARM                    PCurSet05                                    245310
     C                   PARM                    PSysVal06                                    245310
     C                   PARM                    PCurSet06                                    245310
     C                   PARM                    PSysVal07                                    245310
     C                   PARM                    PCurSet07                                    245310
     C                   PARM                    PSysVal08                                    245310
     C                   PARM                    PCurSet08                                    245310
     C                   PARM                    PSysVal09                                    245310
     C                   PARM                    PCurSet09                                    245310
     C                   PARM                    PSysVal10                                    245310
     C                   PARM                    PCurSet10                                    245310
                                                                                              245310
     C*****PRtCd*        IFNE      *BLANKS                                             245310 246730
     C     PRtCd         IFEQ      *BLANKS                                                    246730
     C     PCurSet01     ANDNE     *BLANKS                                                    246730
     C                   MOVEL     PCurSet01     QMGR             48                          245310
     C                   EXSR      MQCONNECT                                                  245310
     C                   Z-ADD     HANDLE        HCONN                                        245310
     C                   ENDIF                                                                245310
                                                                                              245310
     C                   EXSR      OPQIN
 
      ** Loop until shutdown message received
     C     TYPE          DOWNE     'SHUTDOWN'
     C/COPY WNCPYSRC,APH00048
 
 
      *                                                                                     AR401481
     C                   CALL      'QCMDEXC'                            9999                AR401481
     C                   PARM                    CJOB@                                      AR401481
     C                   PARM      20            LEN                                        AR401481
      *                                                                                     AR401481
     C                   EXSR      GETMSG
 
     C     TYPE          IFEQ      'SHUTDOWN'
     C                   LEAVE
     C                   ENDIF
     C/COPY WNCPYSRC,APH00049
 
      ** If an exception error occurred when validating the last
      ** message, then the rollback will cause the same message to
      ** be retrieved again.
      ** In this case, read the message, output to an error logging
      ** file and retrieve the next message.
      ** The module in error is stored in the return code on the
      ** APHEAD parameter.
 
     C     APRETCODE     IFNE      *BLANKS
     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
     C                   WRITE     APEXCPERD0
     C                   EVAL      APRETCODE = *BLANKS
      ** Perform a commit to ensure that message cannot be read again
     C                   COMMIT
     C                   ELSE
     C/COPY WNCPYSRC,APH00075
 
      ** If required, validate the Profile / Password
     C                   IF        GHPWCR = 'Y'
     C                   EXSR      ValPrfPwd
     C                   ELSE                                                                 CSD102
     C                   EVAL      PASSWORD = *BLANKS                                         CSD102
     C                   EVAL      APPASSWORD = *BLANKS                                       CSD102
     C                   END
 
      ** QUESI is the Error MSGID from the API call
      **   N.B. QUESI will always be blank if the checking is off
     C     QUSEI         IFEQ      *BLANKS
 
     C                   EXSR      VALID8
 
      ** The PrfHandle must be released to avoid hitting the job limit:
      ** 25574 simultaneous handles.
     C                   IF        GHPWCR = 'Y'
     C                   CALL      'QSYRLSPH'
     C                   PARM                    PrfHandle
     C                   END
 
     C                   ELSE
 
      ** Send an error message for the  Profile / Password
     C                   EXSR      PrfPwdErr
 
     C                   ENDIF
 
     C                   ENDIF
     C/COPY WNCPYSRC,APH00076
 
     C                   ENDDO
 
     C                   EXSR      CLQIN
 
      ** Perform a commit to ensure that the 'Shutdown' message is removed
      ** from the queue.
     C                   COMMIT
                                                                                              245310
      ** If an explicit connection to a Queue Manager was made, then                          245310
      ** disconnect from it                                                                   245310
                                                                                              245310
     C     QMGR          IFNE      *BLANKS                                                    245310
     C                   EXSR      MQDISCONNECT                                               245310
     C                   ENDIF                                                                245310
 
     C                   SETON                                        LR
     C                   RETURN
      ****************************************************************
      /EJECT                                                                                  245310
      ****************************************************************                        245310
      *                                                              *                        245310
      *  Open connection to the queue manager                        *                        245310
      *                                                              *                        245310
      ****************************************************************                        245310
     C     MQCONNECT     BEGSR                                                                245310
                                                                                              245310
      **  Attempt to CONNECT to the MQ Manager                                                245310
      *              ~~~~~~~                                                                  245310
     C**********         CALL      'QMQM'                                            245310 MD041126
     C**********         PARM      MQCONN        CID               9 0               245310 MD041126
     C**********         PARM      QMGR          QMNAME           48                 245310 MD041126
     C**********         PARM      *ZERO         HANDLE            9 0               245310 MD041126
     C**********         PARM      *ZERO         OCODE             9 0               245310 MD041126
     C**********         PARM      *ZERO         REASON            9 0               245310 MD041126
      *                                                                                     MD041126
     C                   EVAL      QMNAME = QMGR                                            MD041126
     C                   Z-ADD     *ZERO         HANDLE                                     MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQCONN( QMNAME : HANDLE :                                MD041126
     C                                     OCODE  : REASON )                                MD041126
                                                                                              245310
      ** Error processing                                                                     245310
     C     REASON        IFNE      RCNONE                                                     245310
     C     REASON        ANDNE     RC2002                                                     245310
                                                                                              245310
     C                   MOVE      REASON        ReasonA                                      245310
     C                   EVAL      MQError = ConnFailed + ReasonA                             245310
                                                                                              245310
     C                   CALLB     'ZAMSGTOOPR'                                               245310
     C                   PARM                    MQReturn         10                          245310
     C                   PARM                    MQError                                      245310
     C                   PARM                    DummyMsgID                                   245310
     C                   PARM                    DummyMsgF                                    245310
                                                                                              245310
      ** Shut down the program                                                                245310
     C                   EXSR      *pssr                                                      245310
                                                                                              245310
     C                   ENDIF                                                                245310
                                                                                              245310
     C                   ENDSR                                                                245310
      ****************************************************************                        245310
      /EJECT                                                                                  245310
      ****************************************************************                        245310
      *                                                              *                        245310
      *  Disconnect from the queue manager                           *                        245310
      *                                                              *                        245310
      ****************************************************************                        245310
     C     MQDISCONNECT  BEGSR                                                                245310
                                                                                              245310
      **  Attempt to DISCONNECT from the MQ Manager                                           245310
      *                                                                                       245310
     C**********         CALL      'QMQM'                                            245310 MD041126
     C**********         PARM      MQDISC        CID               9 0               245310 MD041126
     C**********         PARM                    HCONN                               245310 MD041126
     C**********         PARM      *ZERO         OCODE                               245310 MD041126
     C**********         PARM      *ZERO         REASON                              245310 MD041126
      *                                                                                     MD041126
     C                   Z-ADD     *ZERO         OCODE                                      MD041126
     C                   Z-ADD     *ZERO         REASON                                     MD041126
     C                   CALLP     MQDISC( HCONN : OCODE : REASON )                         MD041126
                                                                                              245310
      ** Error processing                                                                     245310
     C     REASON        IFNE      RCNONE                                                     245310
     C     REASON        ANDNE     RC2018                                                    248095A
     C     REASON        ANDNE     RC2019                                                    248095A
                                                                                              245310
     C                   MOVE      REASON        ReasonA                                      245310
     C                   EVAL      MQError = DiscFailed + ReasonA                             245310
                                                                                              245310
     C                   CALLB     'ZAMSGTOOPR'                                               245310
     C                   PARM                    MQReturn         10                          245310
     C                   PARM                    MQError                                      245310
     C                   PARM                    DummyMsgID                                   245310
     C                   PARM                    DummyMsgF                                    245310
                                                                                              245310
      ** Shut down the program                                                                245310
     C                   EXSR      *pssr                                                      245310
                                                                                              245310
     C                   ENDIF                                                                245310
                                                                                              245310
     C                   ENDSR                                                                245310
      ****************************************************************                        245310
      /EJECT
      ****************************************************************
      *                                                              *
      *  Open receiving queue for input                              *
      *                                                              *
      ****************************************************************
     C     OPQIN         BEGSR
 
      ** Use input queue
     C                   MOVEL     QIN           ODON             48
 
      ** Open options: INPUT and FAIL_IF_QUIESCING
     C     OOINPQ        ADD       OOFIQ         OPTS
 
      ** Open queue
     C**********         Z-ADD     MQOPEN        CID                                        MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    MQOD                                       MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    OCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQOPEN( HCONN : MQOD : OPTS :                            MD041126
     C                                     HIN : OCODE : REASON )                           MD041126
 
      ** Error processing
     C     REASON        IFNE      RCNONE
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
     C****************** MOVEL     OpenFailed    MQError          28            138019
     C****************** MOVE      REASON        MQError                        138019
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      MQError = OpenFailed + ReasonA               138019
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn         10
     C                   PARM                    MQError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
      ** Shut down the program
     C                   EXSR      *pssr
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Close input queue                                           *
      *                                                              *
      ****************************************************************
     C     CLQIN         BEGSR
 
      ** Close options: NONE
     C                   Z-ADD     CONONE        OPTS
 
      ** Close queue
     C**********         Z-ADD     MQCLOS        CID                                        MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    OPTS              9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQCLOSE( HCONN : HIN : OPTS :                            MD041126
     C                                      CCODE : REASON )                                MD041126
 
      ** Error processing
     C     REASON        IFNE      RCNONE
     C     REASON        ANDNE     RC2018                                                    248095A
     C     REASON        ANDNE     RC2019                                                    248095A
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
     C****************** MOVEL     ClosFailed    MQError                        138019
     C****************** MOVE      REASON        MQError                        138019
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      MQError = ClosFailed + ReasonA               138019
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
      ** Shut down the program
     C                   EXSR      *pssr
 
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Validate deal type                                          *
      *                                                              *
      ****************************************************************
     C     VALID8        BEGSR
 
     C                   MOVEL     BUFFER        APHEAD
 
     C     APMIDUSR      IFEQ      *BLANKS
     C**********         MOVEL     MDUID         APMIDUSR                                     245862
     C                   ENDIF
                                                                                              CDL010
     ** Get Front Office User, Else default Job User                                          CDL010
     C                   MOVEA     CHG@          ALLTXT                                       CDL010
     C                   MOVE      ''')'         QOTTXT                                       CDL010
     C     APMIDUSR      IFEQ      *BLANKS                                                    CDL010
     C                   MOVE      PSUser        USRTXT                                       CDL010
     C                   ELSE                                                                 CDL010
     C                   MOVE      APMIDUSR      USRTXT                                       CDL010
     C                   ENDIF                                                                CDL010
                                                                                              CDL010
     C                   CALL      'QCMDEXC'                            9999    *             CDL010
     C                   PARM                    CMDTXT                                       CDL010
     C                   PARM      57            LEN              15 5                        CDL010
 
      ** Log incoming data
     C                   MOVEL     *BLANKS       O_BUFFER                                    CAP186C
     C                   MOVEL     BUFFER        O_BUFFER                                    CAP186C
     C**********         WRITE     APOUTPUTD0                                               MD039105
                                                                                            MD039105
     C/exec SQL                                                                             MD039105
     C+ insert into APOUTPUTPD                                                              MD039105
     C+ (                                                                                   MD039105
     C+   BUFFER                                                                            MD039105
     C+ )                                                                                   MD039105
     C+ values                                                                              MD039105
     C+ (                                                                                   MD039105
     C+   :O_BUFFER                                                                         MD039105
     C+ )                                                                                   MD039105
     C/end-exec                                                                             MD039105
 
      ** Set up the Transaction & Settlement DS's
 
     C*******************EXSR      TRANSETI                                                   CAP083
     C*******************EXSR      TRANSETI                                            CGL032 243084
     C                   SELECT                                                               248920
     C     TYPE          WHENEQ    'FTOPAY'                                                   248920
     C                   CALLB     'APPARMSGFT'                                               248920
     C                   PARM                    BUFFER                                       248920
     C                   PARM                    TRANS1FT       1000                          248920
     C                   PARM                    TRANS1A                                      248920
     C                   PARM                    TRANS2                                       248920
     C                   PARM                    TRANS3                                       248920
     C                   PARM                    TRANS4                                       248920
     C                   PARM                    TRANS5                                       248920
     C                   PARM                    TRANS6FT       1000                          248920
     C                   PARM                    TRANS7                                       248920
     C                   PARM                    TRANS8                                       248920
     C                   PARM                    TRANS9                                       248920
     C                   PARM                    TRANS9A                                      CFT039
     C                   PARM                    TRANS9B                                      CFT039
     C                   PARM                    TRANS10                                      CFT039
     C                   PARM                    TRANS11                                      CFT039
     C                   PARM                    PaySttmt                                     248920
     C                   PARM                    RecSttmt                                     248920
     C                   PARM                    FRASttmt                                     248920
     C                   PARM                    PayStmtV                                     248920
     C                   PARM                    RecStmtV                                     248920
     C                   PARM                    PayStmtM                                     248920
     C                   PARM                    RecStmtM                                     248920
     C                   PARM                    InfData         500                          248920
     C                   PARM                    RegData         500                          248920
     C                   PARM                    ExtData         500                          248920
     C                   PARM                    OthDData                                     248920
     C                   PARM                    Bypass                                       248920
     C                   OTHER                                                                248920
     C                   CALLB     'APPARSMSG'                                                CAP083
     C                   PARM                    BUFFER                                       CAP083
     C                   PARM                    TRANS1          500                          CAP083
     C                   PARM                    TRANS1A        1000                         BUG9887
     C                   PARM                    TRANS1B        1500                        BUG25877
     C                   PARM                    TRANS2          500                          CAP083
     C                   PARM                    TRANS3          500                          CAP083
     C                   PARM                    TRANS3A                                      CFT120
     C                   PARM                    TRANS4          500                          CAP083
     C                   PARM                    TRANS5          500                          CAP083
     C                   PARM                    TRANS5A                                      CFT120
     C                   PARM                    TRANS6          500                          CAP083
     C                   PARM                    TRANS7          500                          CAP083
     C                   PARM                    TRANS8          500                          CAP083
     C                   PARM                    TRANS9          500                          CAP083
     C                   PARM                    TRANS9A                                      CSW209
     C                   PARM                    TRANS9B                                      CSW209
     C                   PARM                    TRANS10         500                          262664
     C                   PARM                    TRANS9C                                      CGL132
     C**********         PARM                    Trans10                           CER034A BUG23518A
     C**********         PARM                    Trans11                           CER034A BUG23518A
     C**********         PARM                    Trans12                           CER034A BUG23518A
     C**********         PARM                    Trans13                           CER034A BUG23518A
     C**********         PARM                    Trans14                           CER034A BUG23518A
     C**********         PARM                    Trans15                           CER034A BUG23518A
     C**********         PARM                    Trans16                           CER034A BUG23518A
     C**********         PARM                    Trans17                           CER034A BUG23518A
     C                   PARM                    PaySttmt                                     CAP083
     C                   PARM                    RecSttmt                                     CAP083
     C                   PARM                    FRASttmt                                     CAP083
     C                   PARM                    PayStmtV                                     CAP083
     C                   PARM                    RecStmtV                                     CAP083
     C                   PARM                    PayStmtM                                     CAP083
     C                   PARM                    RecStmtM                                     CAP083
     C                   PARM                    InfData         500                          CAP083
     C                   PARM                    RegData         500                          CER001
     C                   PARM                    ExtData         500                          CAP083
     C                   PARM                    OthDData                                     CAP083
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    Trans9999_2                                  CSW213
     C                   PARM                    Trans9999_3                                  CSW213
     C                   PARM                    Bypass                                       CAP083
     C                   ENDSL                                                                248920
                                                                                              CAP083
     C     Bypass        IFEQ      'Y'                                                        CAP083
     C                   WRITE     APEXCPERD0                                                 CAP083
     C                   COMMIT                                                               CAP083
     C                   ENDIF                                                                CAP083
 
      ** Load the entire message header into the API Dump data area so that
      **  dumps in any lower level modules will include the key information
     C     *Lock         IN        APDump
     C**********         MOVEL     APHEAD        APDUMP                                       CSD102
     C                   MOVEL     APTGTTYPE     ARTGTTYPE                                    CSD102
     C                   MOVEL     APTGTSYS      ARTGTSYS                                     CSD102
     C                   MOVEL     APSRCTYPE     ARSRCTYPE                                    CSD102
     C                   MOVEL     APSRCSYS      ARSRCSYS                                     CSD102
     C                   MOVEL     APUSERID      ARUSERID                                     CSD102
     C                   MOVEL     *BLANKS       ARPASSWORD                                   CSD102
     C                   MOVEL     APFORMAT      ARFORMAT                                     CSD102
     C                   MOVEL     APVERSION     ARVERSION                                    CSD102
     C                   MOVEL     APRPYQUEUE    ARRPYQUEUE                                   CSD102
     C                   MOVEL     APRESPMODE    ARRESPMODE                                   CSD102
     C                   MOVEL     APMAPLOCN     ARMAPLOCN                                    CSD102
     C                   MOVEL     APFOTRANID    ARFOTRANID                                   CSD102
     C                   MOVEL     APFOASOCID    ARFOASOCID                                   CSD102
     C                   MOVEL     APCNFVALFO    ARCNFVALFO                                   CSD102
     C                   MOVEL     APRPRLOCN     ARRPRLOCN                                    CSD102
     C                   MOVEL     APRETCODE     ARRETCODE                                    CSD102
     C                   MOVEL     APMIDUSR      ARMIDUSR                                     CSD102
     C                   OUT       APDump
 
     C/COPY WNCPYSRC,APH00050
      ** Validate
 
      ***Call*CL*to*apply*override*and*call*appropriate*validation*program******CAP006
      ** Call submodule to apply override and call appropriate                  CAP006
      ** validation program                                                     CAP006
     C     Bypass        IFEQ      'N'                                                        CPK015
     C                   SELECT                                                               248920
     C     TYPE          WHENEQ    'FTOPAY'                                                   248920
     C                   CALLB     'APCALCTLFT'                                               248920
     C                   PARM                    TYPE                                         248920
     C                   PARM                    APHEAD                                       248920
     C                   PARM                    TRANS1FT                                     248920
     C                   PARM                    TRANS1A                                      248920
     C**********         PARM                    TRANS2                                248920 CSD102
     C**********         PARM                    TRANS3                                248920 CSD102
     C                   PARM                    TRANS2A        1000                          CSD102
     C                   PARM                    TRANS3A        1000                          CSD102
     C                   PARM                    TRANS4                                       248920
     C                   PARM                    TRANS5                                       248920
     C                   PARM                    TRANS6FT                                     248920
     C                   PARM                    TRANS7                                       248920
     C                   PARM                    TRANS8                                       248920
     C                   PARM                    TRANS9                                       248920
     C                   PARM                    TRANS9A                                      CFT039
     C                   PARM                    TRANS9B                                      CFT039
     C                   PARM                    TRANS10                                      CFT039
     C                   PARM                    TRANS11                                      CFT039
     C                   PARM                    PaySttmt                                     248920
     C                   PARM                    RecSttmt                                     248920
     C                   PARM                    FRASttmt                                     248920
     C                   PARM                    PayStmtV                                     248920
     C                   PARM                    RecStmtV                                     248920
     C                   PARM                    PayStmtM                                     248920
     C                   PARM                    RecStmtM                                     248920
     C                   PARM                    InfData                                      248920
     C                   PARM                    RegData                                      248920
     C                   PARM                    ExtData                                      248920
     C                   PARM                    OthDData                                     248920
     C                   PARM                    #ProcPgm                                     248920
     C                   PARM                    #ProcMod                                     248920
     C                   PARM                    #ProcName                                    248920
     C                   OTHER                                                                248920
     C                   CALLB     'APCCALLCTL'
     C                   PARM                    TYPE
     C                   PARM                    APHEAD
     C*******************PARM                    TRANS                          CAP003
     C                   PARM                    TRANS1                         CAP003
     C                   PARM                    TRANS1A                                     BUG9887
     C                   PARM                    TRANS1B                                    BUG25877
     C                   PARM                    TRANS2                         CAP003
     C                   PARM                    TRANS3                         CAP003
     C                   PARM                    TRANS3A                                      CFT120
     C                   PARM                    TRANS4                         CAP003
     C                   PARM                    TRANS5                         CAP003
     C                   PARM                    TRANS5A                                      CFT120
     C                   PARM                    TRANS6                         CAP003
     C                   PARM                    TRANS7                         CAP003
     C                   PARM                    TRANS8                         CAP003
     C                   PARM                    TRANS9                                       209905
     C                   PARM                    TRANS9A                                      CSW209
     C                   PARM                    TRANS9B                                      CSW209
     C                   PARM                    TRANS10                                      262664
     C                   PARM                    TRANS9C                                      CGL132
     C**********         PARM                    Trans10                           CER034A BUG23518A
     C**********         PARM                    Trans11                           CER034A BUG23518A
     C**********         PARM                    Trans12                           CER034A BUG23518A
     C**********         PARM                    Trans13                           CER034A BUG23518A
     C**********         PARM                    Trans14                           CER034A BUG23518A
     C**********         PARM                    Trans15                           CER034A BUG23518A
     C**********         PARM                    Trans16                           CER034A BUG23518A
     C**********         PARM                    Trans17                           CER034A BUG23518A
     C                   PARM                    PaySttmt
     C                   PARM                    RecSttmt
     C                   PARM                    FRASttmt
     C                   PARM                    PayStmtV                                     CIR003
     C                   PARM                    RecStmtV                                     CIR003
     C                   PARM                    PayStmtM                                     CIR003
     C                   PARM                    RecStmtM                                     CIR003
     C                   PARM                    InfData                        CDL007
     C                   PARM                    RegData                                      CER001
     C                   PARM                    ExtData                        CAP004
     C                   PARM                    OthDData                                     CSE022
     C                   PARM                    InSwift2013                                  CSW213
     C                   PARM                    Trans9999_2                                  CSW213
     C                   PARM                    Trans9999_3                                  CSW213
     C                   PARM                    #ProcPgm
     C                   PARM                    #ProcMod
     C                   PARM                    #ProcName
     C                   ENDSL                                                                248920
     C                   ENDIF                                                                CPK015
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************                        CAP083
      ******************                                             *                        CAP083
      ***Set*up*Transaction*and*Settlement*Data*Structures           *                        CAP083
      ******************                                             *                        CAP083
      ****************************************************************                        CAP083
     C*****TRANSETI******BEGSR                                                                CAP083
     C*****TRANSETI      BEGSR                                                         CGL032 243084
      *******************                                                                     CAP083
     C*******************CLEAR                   TRANS           500            CAP003
     C*******************CLEAR                   TRANS1          500            CAP003        CAP083
     C*******************CLEAR                   TRANS2          500            CAP003        CAP083
     C*******************CLEAR                   TRANS3          500            CAP003        CAP083
     C*******************CLEAR                   TRANS4          500            CAP003        CAP083
     C*******************CLEAR                   TRANS5          500            CAP003        CAP083
     C*******************CLEAR                   TRANS6          500            CAP003        CAP083
     C*******************CLEAR                   TRANS7          500            CAP003        CAP083
     C*******************CLEAR                   TRANS8          500            CAP003        CAP083
     C*******************CLEAR                   TRANS9          500            209905        CAP083
     C*******************CLEAR                   PaySttmt                                     CAP083
     C*******************CLEAR                   RecSttmt                                     CAP083
     C*******************CLEAR                   FRASttmt                                     CAP083
     C*******************CLEAR                   PayStmtV                              CIR003 CAP083
     C*******************CLEAR                   RecStmtV                              CIR003 CAP083
     C*******************CLEAR                   PayStmtM                              CIR003 CAP083
     C*******************CLEAR                   RecStmtM                              CIR003 CAP083
     C*******************CLEAR                   ExtData         500            CAP004        CAP083
     C*******************CLEAR                   InfData         500            CDL007        CAP083
     C*******************CLEAR                   OthDData                              CSE022 CAP083
      *******************                                                                     CAP083
     C*******************EVAL      Bypass = 'N'                                        CPK015 CAP083
      *******************                                                                     CAP083
      ***Position*Buffer*pointer*to*1st*byte after the header data                            CAP083
      *******************                                                                     CAP083
     C*****HEADLn********ADD       1             Bfp               4 0                        CAP083
                                                                                              CAP083
      **--- Explanation of BUFFER substringing -----------------------------------------------CAP083
      ** The following select block extracts the transaction data from          CAP003        CAP083
      ** the incoming transaction string.  Each WHEN section works as           CAP003        CAP083
      ** follows:                                                               CAP003        CAP083
      **                                                                        CAP003        CAP083
      ** 1. The field BUFFER is substringed from position Bfp by the            CAP003        CAP083
      **    length of the transaction format definition file, and the           CAP003        CAP083
      **    result placed in field TRANS. (Bfp = length of header info          CAP003        CAP083
      **    plus 1; the length of the format definition is determined in        CAP003        CAP083
      **    *inzsr)                                                             CAP003        CAP083
      **                                                                        CAP003        CAP083
      ** 2. Bfp is incremented by the length of the format definition           CAP003        CAP083
      **                                                                        CAP003        CAP083
      ** 3. The field BUFFER is substringed from the new value of Bfp           CAP003        CAP083
      **    by the length of the receive settlement instructions format         CAP003        CAP083
      **    definition file, and the result placed in RecSttmt.                 CAP003        CAP083
      **                                                                        CAP003        CAP083
      ** 4. Bfp is incremented by the length of the receive                     CAP003        CAP083
      **    settlements format definition.                                      CAP003        CAP083
      **                                                                        CAP003        CAP083
      ** 5. Point 3 is repeated for pay settlement instructions, and            CAP003        CAP083
      **    the result placed in PaySttmt.                                      CAP003        CAP083
      **                                                                        CAP004        CAP083
      ** 6. Bfp is incremeted by the length of the pay settlement               CAP004        CAP083
      **    instructions.                                                       CAP004        CAP083
      **                                                                        CAP004        CAP083
      ** 7. The field BUFFER is substringed from the new value of Bfp           CAP004        CAP083
      **    by the length of the relevant Extra Data file. This file will       CAP004        CAP083
      **    be supplied with a 50 byte core field. This is a free format        CAP004        CAP083
      **    narrative text field for transferring instructions to the back      CAP004        CAP083
      **    office.                                                             CAP004        CAP083
      **    Custom data coming from the front office will be added to this      CAP004        CAP083
      **    file.                                                               CAP004        CAP083
      **                                                                        CAP003        CAP083
      ** The above applies for most transaction types; FRAs also                CAP003        CAP083
      ** extract the FRA settlement instructions, and FF includes               CAP003        CAP083
      ** broker and customer settlement instructions in the transaction         CAP003        CAP083
      ** structure, and does not have pay or receive settlements.               CAP003        CAP083
      ** Other variations may occur in the future, but the same                 CAP003        CAP083
      ** principles will be followed.                                           CAP003        CAP083
      **--------------------------------------------------------------------------------------CAP083
                                                                                              CAP083
     C*******************SELECT                                                               CAP083
     C*******************SELECT                                                        CGL032 243084
      **FX*deals                                                                              CAP083
                                                                                              CAP083
     C*****TYPE**********WHENEQ    'FXFXDL'                                                   CAP083
                                                                                              CAP083
     C*****FXDLLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****FXDLLn********SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       FXDLLn        Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
     C*****FXFILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
     C*******************ADD       FXFILn        Bfp                            CAP051        CAP083
     C*****FXFXLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                              CAP083
      **Loans/Deposits                                                                        CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'MMLDNI'                                                   CAP083
                                                                                              CAP083
     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       LDNILn        Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
      **  Non-Screen Interface Data for Class 1 enhancements                    CDL007        CAP083
     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                        CDL007        CAP083
     C*******************ADD       MMLILn        Bfp                            CDL007        CAP083
     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'MMFIDT'                                     209905        CAP083
     C*****CDL006        ANDEQ     'Y'                                          209905        CAP083
                                                                                209905        CAP083
     C*****WFIDT1Ln      SUBST     BUFFER:Bfp    TRANS1                         209905        CAP083
     C****************** ADD       WFIDT1Ln      Bfp                            209905        CAP083
     C*****WFIDT2Ln      SUBST     BUFFER:Bfp    TRANS2                         209905        CAP083
     C****************** ADD       WFIDT2Ln      Bfp                            209905        CAP083
     C*****WFIDT3Ln      SUBST     BUFFER:Bfp    TRANS3                         209905        CAP083
     C****************** ADD       WFIDT3Ln      Bfp                            209905        CAP083
     C*****WFIDT4Ln      SUBST     BUFFER:Bfp    TRANS4                         209905        CAP083
     C****************** ADD       WFIDT4Ln      Bfp                            209905        CAP083
     C*****WFIDT5Ln      SUBST     BUFFER:Bfp    TRANS5                         209905        CAP083
     C****************** ADD       WFIDT5Ln      Bfp                            209905        CAP083
     C*****WFIDT6Ln      SUBST     BUFFER:Bfp    TRANS6                         209905        CAP083
     C****************** ADD       WFIDT6Ln      Bfp                            209905        CAP083
     C*****WFIDT7Ln      SUBST     BUFFER:Bfp    TRANS7                         209905        CAP083
     C****************** ADD       WFIDT7Ln      Bfp                            209905        CAP083
     C*****WFIDT8Ln      SUBST     BUFFER:Bfp    TRANS8                         209905        CAP083
     C****************** ADD       WFIDT8Ln      Bfp                            209905        CAP083
     C*****WFIDT9Ln      SUBST     BUFFER:Bfp    TRANS9                         209905        CAP083
     C****************** ADD       WFIDT9Ln      Bfp                            209905        CAP083
                                                                                209905        CAP083
     C*****TYPE          WHENEQ    'MMFITR'                                     209905        CAP083
     C*****CDL006        ANDEQ     'Y'                                          209905        CAP083
                                                                                209905        CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                       209905        CAP083
     C****************** ADD       ESSRLn        Bfp                            209905        CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                       209905        CAP083
     C****************** ADD       ESSPLn        Bfp                            209905        CAP083
     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                        209905        CAP083
     C****************** ADD       MMLILn        Bfp                            209905        CAP083
     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                        209905        CAP083
                                                                                209905        CAP083
      **Deal*Amendments                                                                       CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'MMDEAM'                                                   CAP083
                                                                                              CAP083
     C*****DEAMLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****DEAMLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       DEAMLn        Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
     C*****MMDILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
     C*******************ADD       MMDILn        Bfp                            CAP051        CAP083
     C*****MMDALn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                              CAP083
      **NAs*Purchased                                                                         CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'MMNASP'                                                   CAP083
                                                                                              CAP083
     C*****NASPLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****NASPLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       NASPLn        Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
     C*****MMNPLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                              CAP083
      **NAs*Sold                                                                              CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'MMNASS'                                                   CAP083
                                                                                              CAP083
     C*****NASSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****NASSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       NASSLn        Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                            CAP004        CAP083
     C*****MMNSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                              CAP083
      **Forward*Rate*Agreements                                                               CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'IRFRA '                                                   CAP083
                                                                                              CAP083
     C*****FRALn         SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****FRALn         SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       FRALn         Bfp                                          CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                                          CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
     C*****IRFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP056        CAP083
      ****Non-Screen*Interface*Data*for*Class*1*enhancements                    CAP056        CAP083
                                                                                CAP056        CAP083
     C*****IRFALn        SUBST     BUFFER:Bfp    InfData                        CAP056        CAP083
     C****************** ADD       IRFALn        Bfp                            CAP056        CAP083
                                                                                CAP056        CAP083
     C*****IRFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
 
      **Single*Currency*Interest*Rate*Swaps                                                   CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'IRSIRS'                                                   CAP083
                                                                                              CAP083
     C*****SIRSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****SIRSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       SIRSLn        Bfp                                          CAP083
     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
     C*******************ADD       DTORLn        Bfp                            CAP004        CAP083
     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
     C*******************ADD       DTOPLn        Bfp                            CAP004        CAP083
     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS4                         CAP004        CAP083
     C*******************ADD       DTTRLn        Bfp                            CAP004        CAP083
     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS5                         CAP004        CAP083
     C*******************ADD       DTTPLn        Bfp                            CAP004        CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                                          CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
                                                                                CAP056        CAP083
      ****Non-Screen*Interface*Data*for*Class*1*enhancements                    CAP056        CAP083
                                                                                CAP056        CAP083
     C*****IRRSLn        SUBST     BUFFER:Bfp    InfData                        CAP056        CAP083
     C****************** ADD       IRRSLn        Bfp                            CAP056        CAP083
                                                                                CAP056        CAP083
     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                       CAP043 CAP083
      ***Additional*Date*Schedules*(Rate*Change*&*Interest*Payment*Dates - Single Ccy) CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRSIRI'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       DTORLn        Bfp                                   CAP043 CAP083
     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       DTOPLn        Bfp                                   CAP043 CAP083
     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       DTTRLn        Bfp                                   CAP043 CAP083
     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       DTTPLn        Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Cash*Flow*Schedules*(Single*Ccy)                                              CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRSICF'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Our*Cash*Flow***                                                              CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WCFSC1OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       WCFSC2OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       WCFSC3OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       WCFSC4OLn     Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Their*Cash*Flow***                                                            CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
     C****************** ADD       WCFSC1TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
     C****************** ADD       WCFSC2TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
     C****************** ADD       WCFSC3TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change*Schedules*(Single*Ccy)                                       CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRSIPC'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change****                                                          CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Trailer*record*(Single*Ccy)                                                   CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRSITR'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
     C*****ESSPLn******* SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
     C*****IRRSLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
     C****************** ADD       IRRSLn        Bfp                                   CAP043 CAP083
     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
 
      **Cross*Currency*Interest*Rate*Swaps                                                    CAP083
                                                                                              CAP083
     C*****TYPE          WHENEQ    'IRCIRS'                                                   CAP083
                                                                                              CAP083
     C*****CIRSLn        SUBST     BUFFER:Bfp    TRANS                          CAP003
     C*****CIRSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       CIRSLn        Bfp                                          CAP083
     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
     C*******************ADD       DTORLn        Bfp                            CAP004        CAP083
     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
     C*******************ADD       DTOPLn        Bfp                            CAP004        CAP083
     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS4                         CAP004        CAP083
     C*******************ADD       DTTRLn        Bfp                            CAP004        CAP083
     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS5                         CAP004        CAP083
     C*******************ADD       DTTPLn        Bfp                            CAP004        CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                                     CAP083
     C*******************ADD       ESSRLn        Bfp                                          CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                                     CAP083
     C*******************ADD       ESSPLn        Bfp                                          CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                                     CAP083
     C**********         ADD       ESSPLn        Bfp                            CAP004 188376
     C*******************ADD       ESSFLn        Bfp                                   188376 CAP083
                                                                                       CIR003 CAP083
      **(Extra*Settlements                                                             CIR003 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtV                              CIR003 CAP083
     C*******************ADD       ESSRLn        Bfp                                   CIR003 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtV                              CIR003 CAP083
     C*******************ADD       ESSPLn        Bfp                                   CIR003 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtM                              CIR003 CAP083
     C*******************ADD       ESSRLn        Bfp                                   CIR003 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtM                              CIR003 CAP083
     C*******************ADD       ESSPLn        Bfp                                   CIR003 CAP083
                                                                                       CAP056 CAP083
      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP056 CAP083
                                                                                       CAP056 CAP083
     C*****IRRXLn        SUBST     BUFFER:Bfp    InfData                               CAP056 CAP083
     C****************** ADD       IRRXLn        Bfp                                   CAP056 CAP083
                                                                                       CAP056 CAP083
     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                       CAP056 CAP083
      ***Additional*Date*Schedules*(Rate*Change*&*Interest*Payment*Dates*-*Cross Ccy)  CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCIRI'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****DTORLn        SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       DTORLn        Bfp                                   CAP043 CAP083
     C*****DTOPLn        SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       DTOPLn        Bfp                                   CAP043 CAP083
     C*****DTTRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       DTTRLn        Bfp                                   CAP043 CAP083
     C*****DTTPLn        SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Cash*Flow*Schedules*(Cross*Ccy)***                                            CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCICF'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Our*Cash*Flow*****                                                            CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WCFSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WCFSC1OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       WCFSC2OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       WCFSC3OLn     Bfp                                   CAP043 CAP083
     C*****WCFSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       WCFSC4OLn     Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Their*Cash*Flow***                                                            CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WCFSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
     C****************** ADD       WCFSC1TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
     C****************** ADD       WCFSC2TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
     C****************** ADD       WCFSC3TLn     Bfp                                   CAP043 CAP083
     C*****WCFSC4TLn     SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change*Schedules*(Cross*Ccy)**                                      CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCIPC'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Our*Principal*Change***                                                       CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Their*Principal*Change**                                                      CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WPCSC1TLn     SUBST     BUFFER:Bfp    TRANS5                                CAP043 CAP083
     C****************** ADD       WPCSC1TLn     Bfp                                   CAP043 CAP083
     C*****WPCSC2TLn     SUBST     BUFFER:Bfp    TRANS6                                CAP043 CAP083
     C****************** ADD       WPCSC2TLn     Bfp                                   CAP043 CAP083
     C*****WPCSC3TLn     SUBST     BUFFER:Bfp    TRANS7                                CAP043 CAP083
     C****************** ADD       WPCSC3TLn     Bfp                                   CAP043 CAP083
     C****************** SUBST     BUFFER:Bfp    TRANS8                                CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Trailer*record*(Cross*Ccy)                                                    CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCITR'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Extra*Settlements**                                                           CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtV                              CAP043 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtV                              CAP043 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecStmtM                              CAP043 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PayStmtM                              CAP043 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
     C*****IRRXLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
     C****************** ADD       IRRXLn        Bfp                                   CAP043 CAP083
     C*****IRCSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
                                                                                CAP003        CAP083
      **SE*Trade                                                                CAP003        CAP083
                                                                                CAP003        CAP083
     C*****TYPE          WHENEQ    'SETRAD'                                     CAP003        CAP083
                                                                                CAP003        CAP083
     C*****TRPRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       TRPRLn        Bfp                            CAP003        CAP083
     C*****TRSELn        SUBST     BUFFER:Bfp    TRANS2                         CAP003        CAP083
     C*******************ADD       TRSELn        Bfp                            CAP003        CAP083
     C*****TREXLn        SUBST     BUFFER:Bfp    TRANS3                         CAP003        CAP083
     C*******************ADD       TREXLn        Bfp                            CAP003        CAP083
     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                         CAP003        CAP083
     C*******************ADD       TRSTLn        Bfp                            CAP003        CAP083
     C*****TRCCLn        SUBST     BUFFER:Bfp    TRANS5                         CAP003        CAP083
     C*******************ADD       TRCCLn        Bfp                            CAP003        CAP083
     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS6                         CAP003        CAP083
     C*******************ADD       TRCCLn        Bfp                      CAP003CAP051
     C*******************ADD       TRSWLn        Bfp                            CAP051        CAP083
     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS7                         CAP003        CAP083
     C*******************ADD       TRSWLn        Bfp                            CAP004        CAP083
     C*****TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                CAS006 CAP083
     C*****              ADD       TRTHLn        Bfp                                   CAS006 CAP083
      **  Non-Screen Interface Data for Class 1 enhancements                    CAP051        CAP083
     C*****SETILn        SUBST     BUFFER:Bfp    InfData                        CAP051        CAP083
     C*******************ADD       SETILn        Bfp                            CAP051        CAP083
     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP003        CAP083
      **SE*Walk*In*Depot*Movement                                               CAP003        CAP083
                                                                                CAP003        CAP083
     C*****TYPE          WHENEQ    'SEDMWI'                                     CAP003        CAP083
                                                                                CAP003        CAP083
     C*****DMWILn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       DMWILn        Bfp                            CAP004        CAP083
     C*****SEWILn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP003        CAP083
      * SE Walk Out Depot Movement                                              CAP003        CAP083
                                                                                CAP003        CAP083
     C*****TYPE          WHENEQ    'SEDMWO'                                     CAP003        CAP083
                                                                                CAP003        CAP083
     C*****DMWILn        SUBST     BUFFER:Bfp    TRANS1                   CAP003CAP004
     C*****DMWOLn        SUBST     BUFFER:Bfp    TRANS1                         CAP004        CAP083
     C*******************ADD       DMWOLn        Bfp                            CAP004        CAP083
     C*****SEWOLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP004        CAP083
      **AB*Internal*Contract                                                    CAP004        CAP083
                                                                                CAP004        CAP083
     C*****TYPE          WHENEQ    'ABINTC'                                     CAP004        CAP083
                                                                                CAP004        CAP083
     C*****INTCLn        SUBST     BUFFER:Bfp    TRANS1                         CAP004        CAP083
     C*******************ADD       INTCLn        Bfp                            CAP004        CAP083
     C*****ABICLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP003        CAP083
      **FF*exchange-traded*futures*and*options                                  CAP003        CAP083
     C*****TYPE          WHENEQ    'FFEXTR'                                     CAP003        CAP083
                                                                                CAP003        CAP083
     C*****EXTRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       EXTRLn        Bfp                            CAP004        CAP083
     C*****BSETLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
     C*******************ADD       BSETLn        Bfp                            CAP004        CAP083
     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS3                         CAP004        CAP083
     C*******************ADD       CSETLn        Bfp                            CAP004        CAP083
     C*****FFETLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP003        CAP083
      **FF*over-the-counter*options                                             CAP003        CAP083
     C*****TYPE          WHENEQ    'FFOTCC'                                     CAP003        CAP083
                                                                                CAP003        CAP083
     C*****OTCCLn        SUBST     BUFFER:Bfp    TRANS1                         CAP003        CAP083
     C*******************ADD       OTCCLn        Bfp                            CAP004        CAP083
     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS2                         CAP004        CAP083
     C*******************ADD       CSETLn        Bfp                            CAP004        CAP083
     C*****FFOTLn        SUBST     BUFFER:Bfp    ExtData                        CAP004        CAP083
                                                                                CAP004        CAP083
      ***FF*non-currency*over-the-counter*options                                      CAP166 CAP083
                                                                                       CAP166 CAP083
     C*****TYPE          WHENEQ    'FFOTCO'                                            CAP166 CAP083
                                                                                       CAP166 CAP083
     C*****OTCOLn        SUBST     BUFFER:Bfp    TRANS1                                CAP166 CAP083
     C****************** ADD       OTCOLn        Bfp                                   CAP166 CAP083
     C*****CSETLn        SUBST     BUFFER:Bfp    TRANS2                                CAP166 CAP083
     C****************** ADD       CSETLn        Bfp                                   CAP166 CAP083
     C*****FFOTLn        SUBST     BUFFER:Bfp    ExtData                               CAP166 CAP083
                                                                                       CAP166 CAP083
      **Forward*Rates                                                           CAP005        CAP083
                                                                                CAP005        CAP083
     C*****TYPE          WHENEQ    'FDFWRT'                                     CAP005        CAP083
                                                                                CAP005        CAP083
     C*****FWRTLn        SUBST     BUFFER:Bfp    TRANS1                         CAP005        196570
     C*******************ADD       FWRTLn        Bfp                            CAP005        196570
     C*****FWRT1Ln       SUBST     BUFFER:Bfp    TRANS1                                196570 CAP083
     C****************** ADD       FWRT1Ln       Bfp                                   196570 CAP083
     C*****FWRT2Ln       SUBST     BUFFER:Bfp    TRANS2                                196570 CAP083
     C****************** ADD       FWRT2Ln       Bfp                                   196570 CAP083
     C*****FDFRLn        SUBST     BUFFER:Bfp    ExtData                        CAP005        CAP083
                                                                                CAP005        CAP083
      **Money*Market*Rates                                                      CAP005        CAP083
                                                                                CAP005        CAP083
     C*****TYPE          WHENEQ    'FDINTR'                                     CAP005        CAP083
                                                                                CAP005        CAP083
     C*****INTR1Ln       SUBST     BUFFER:Bfp    TRANS1                         CAP005        CAP083
     C*******************ADD       INTR1Ln       Bfp                            CAP005        CAP083
     C*****INTR2Ln       SUBST     BUFFER:Bfp    TRANS2                         CAP005        CAP083
     C*******************ADD       INTR2Ln       Bfp                            CAP005        CAP083
     C*****FDIRLn        SUBST     BUFFER:Bfp    ExtData                        CAP005        CAP083
      *                                                                                CAP033 CAP083
      ***Portfolio*Definition*Details                                                  CAP033 CAP083
      *                                                                                CAP033 CAP083
     C*****TYPE          WHENEQ    'PMPFDM'                                            CAP033 CAP083
     C*****PFDMLn        SUBST     BUFFER:Bfp    TRANS1                                CAP033 CAP083
     C*******************ADD       PFDMLn        Bfp                                   CAP033 CAP083
     C*****PFEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP033 CAP083
      *                                                                                CAP032 CAP083
      ***Journal*Entry*Header*Details                                                  CAP032 CAP083
      *                                                                                CAP032 CAP083
     C*****TYPE          WHENEQ    'GLBITH'                                            CAP032 CAP083
     C*****BITHLn        SUBST     BUFFER:Bfp    TRANS1                                CAP032 CAP083
     C*******************ADD       BITHLn        Bfp                                   CAP032 CAP083
     C*****BHEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP032 CAP083
      *                                                                                CAP032 CAP083
      ***Journal*Entry*Item*Details                                                    CAP032 CAP083
      *                                                                                CAP032 CAP083
     C*****TYPE          WHENEQ    'GLBITP'                                            CAP032 CAP083
     C*****BITPLn        SUBST     BUFFER:Bfp    TRANS1                                CAP032 CAP083
     C*******************ADD       BITPLn        Bfp                                   CAP032 CAP083
     C/COPY WNCPYSRC,APINCOMMC3
     C*****BPEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP032 CAP083
      *                                                                                CAP032 CAP083
                                                                                CAP031        CAP083
      **FT*Outgoing*Payment                                                     CAP031        CAP083
                                                                                CAP031        CAP083
     C*****TYPE          WHENEQ    'FTOPAY'                                     CAP031        CAP083
                                                                                CAP031        CAP083
     C*****OPY1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP031        CAP083
     C*******************ADD       OPY1Ln        Bfp                            CAP031        CAP083
     C*****OPY2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP031        CAP083
     C*******************ADD       OPY2Ln        Bfp                            CAP031        CAP083
     C*****OPY3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP031        CAP083
     C*******************ADD       OPY3Ln        Bfp                            CAP031        CAP083
     C*****OPY4Ln        SUBST     BUFFER:Bfp    TRANS4                         CAP031        CAP083
     C*******************ADD       OPY4Ln        Bfp                            CAP031        CAP083
     C*****OPY5Ln        SUBST     BUFFER:Bfp    TRANS5                         CFT014        CAP083
     C*******************ADD       OPY5Ln        Bfp                            CFT014        CAP083
     C*****OPY6Ln        SUBST     BUFFER:Bfp    TRANS6                         CFT014        CAP083
     C*******************ADD       OPY6Ln        Bfp                            CFT014        CAP083
     C*****OPY7Ln        SUBST     BUFFER:Bfp    TRANS7                         CFT014        CAP083
     C*******************ADD       OPY7Ln        Bfp                            CFT014        CAP083
     C*****OPY8Ln        SUBST     BUFFER:Bfp    TRANS8                         CFT014        CAP083
     C*******************ADD       OPY8Ln        Bfp                            CFT014        CAP083
     C*****OPEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP031        CAP083
                                                                                CAP034        CAP083
      **SD*Customers*Details                                                    CAP034        CAP083
                                                                                CAP034        CAP083
     C*****TYPE          WHENEQ    'SDCUSD'                                     CAP034        CAP083
                                                                                CAP034        CAP083
     C*****CUPRLn        SUBST     BUFFER:Bfp    TRANS1                         CAP034        CAP083
     C*******************ADD       CUPRLn        Bfp                            CAP034        CAP083
     C*****CUSELn        SUBST     BUFFER:Bfp    TRANS2                         CAP034        CAP083
     C*******************ADD       CUSELn        Bfp                            CAP034        CAP083
     C*****CUMRLn        SUBST     BUFFER:Bfp    TRANS3                                CAP034 CSW024
     C**********         ADD       CUMRLn        Bfp                                   CAP034 CSW024
     C*****CUBR1Ln       SUBST     BUFFER:Bfp    TRANS4                                CAP034 CSW024
     C**********         ADD       CUBR1Ln       Bfp                                   CAP034 CSW024
     C*****CUBR2Ln       SUBST     BUFFER:Bfp    TRANS5                                CAP034 CSW024
     C**********         ADD       CUBR2Ln       Bfp                                   CAP034 CSW024
     C*****CUPBLn        SUBST     BUFFER:Bfp    TRANS6                                CAP034 CSW024
     C**********         ADD       CUPBLn        Bfp                                   CAP034 CSW024
     C*****CUMTLn        SUBST     BUFFER:Bfp    TRANS3                                CSW024 CAP083
     C*******************ADD       CUMTLn        Bfp                                   CSW024 CAP083
     C*****CUMRLn        SUBST     BUFFER:Bfp    TRANS4                                CSW024 CAP083
     C*******************ADD       CUMRLn        Bfp                                   CSW024 CAP083
     C*****CUBR1Ln       SUBST     BUFFER:Bfp    TRANS5                                CSW024 CAP083
     C*******************ADD       CUBR1Ln       Bfp                                   CSW024 CAP083
     C*****CUBR2Ln       SUBST     BUFFER:Bfp    TRANS6                                CSW024 CAP083
     C*******************ADD       CUBR2Ln       Bfp                                   CSW024 CAP083
     C*****CUPBLn        SUBST     BUFFER:Bfp    TRANS7                                CSW024 CAP083
     C*******************ADD       CUPBLn        Bfp                                   CSW024 CAP083
     C/COPY WNCPYSRC,APINCOMMC5
     C*****SDCULn        SUBST     BUFFER:Bfp    ExtData                        CAP034        CAP083
                                                                                CAP034        CAP083
                                                                                CAP035        CAP083
      **GL*Accounts*Maintenance                                                 CAP035        CAP083
                                                                                CAP035        CAP083
     C*****TYPE          WHENEQ    'GLAMAD'                                     CAP035        CAP083
                                                                                CAP035        CAP083
     C*****AMMDLn        SUBST     BUFFER:Bfp    TRANS1                         CAP035        CAP083
     C*******************ADD       AMMDLn        Bfp                            CAP035        CAP083
     C*****AMDILn        SUBST     BUFFER:Bfp    TRANS2                         CAP035        CAP083
     C*******************ADD       AMDILn        Bfp                            CAP035        CAP083
     C*****AMCILn        SUBST     BUFFER:Bfp    TRANS3                         CAP035        CAP083
     C*******************ADD       AMCILn        Bfp                            CAP035        CAP083
     C*****AMCOLn        SUBST     BUFFER:Bfp    TRANS4                         CAP035        CAP083
     C*******************ADD       AMCOLn        Bfp                            CAP035        CAP083
     C*****AMODLn        SUBST     BUFFER:Bfp    TRANS5                         CAP035        CAP083
     C*******************ADD       AMODLn        Bfp                            CAP035        CAP083
     C*****GLAMLn        SUBST     BUFFER:Bfp    ExtData                        CAP035        CAP083
                                                                                CAP035        CAP083
                                                                                CAP030        CAP083
      **SE*Price*Input                                                          CAP030        CAP083
                                                                                CAP030        CAP083
     C*****TYPE          WHENEQ    'SEPRCS'                                     CAP030        CAP083
                                                                                CAP030        CAP083
     C*****PRCSLn        SUBST     BUFFER:Bfp    TRANS1                         CAP030        CAP083
     C*****              ADD       PRCSLn        Bfp                            CAP030        CAP083
     C*****PRCXLn        SUBST     BUFFER:Bfp    ExtData                        CAP030        CAP083
      *                                                                         CAP136        CAP083
      ***Funds*Transfer*-*Incoming*Payments                                     CAP136        CAP083
      *                                                                         CAP136        CAP083
     C*****TYPE          WHENEQ    'FTIPAY'                                     CAP136        CAP083
     C*****IPY1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP136        CAP083
     C*******************ADD       IPY1Ln        Bfp                            CAP136        CAP083
     C*****IPY2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP136        CAP083
     C*******************ADD       IPY2Ln        Bfp                            CAP136        CAP083
     C*****IPY3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP136        CAP083
     C*******************ADD       IPY3Ln        Bfp                            CAP136        CAP083
     C*****IPY4Ln        SUBST     BUFFER:Bfp    TRANS4                         CAP136        CAP083
     C*******************ADD       IPY4Ln        Bfp                            CAP136        CAP083
     C*****IPY5Ln        SUBST     BUFFER:Bfp    TRANS5                         CFT014        CAP083
     C*******************ADD       IPY5Ln        Bfp                            CFT014        CAP083
     C*****IPY6Ln        SUBST     BUFFER:Bfp    TRANS6                         CFT014        CAP083
     C*******************ADD       IPY6Ln        Bfp                            CFT014        CAP083
     C*****IPY7Ln        SUBST     BUFFER:Bfp    TRANS7                         CFT014        CAP083
     C*******************ADD       IPY7Ln        Bfp                            CFT014        CAP083
     C*****IPY8Ln        SUBST     BUFFER:Bfp    TRANS8                         CFT014        CAP083
     C*******************ADD       IPY8Ln        Bfp                            CFT014        CAP083
     C*****IPEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP136        CAP083
      *                                                                         CAP137        CAP083
      ***Securities                                                             CAP137        CAP083
      *                                                                         CAP137        CAP083
     C*****TYPE          WHENEQ    'SESECS'                                     CAP137        CAP083
     C*****SEC1Ln        SUBST     BUFFER:Bfp    TRANS1                         CAP137        CAP083
     C*******************ADD       SEC1Ln        Bfp                            CAP137        CAP083
     C*****SEC2Ln        SUBST     BUFFER:Bfp    TRANS2                         CAP137        CAP083
     C*******************ADD       SEC2Ln        Bfp                            CAP137        CAP083
     C*****SEC3Ln        SUBST     BUFFER:Bfp    TRANS3                         CAP137        CAP083
     C*******************ADD       SEC3Ln        Bfp                            CAP137        CAP083
     C*****SEC4Ln        SUBST     BUFFER:Bfp    TRANS4                         CSE031        CAP083
     C**********         ADD       SEC4Ln        Bfp                            CSE031        CAP083
     C*****SEC5Ln        SUBST     BUFFER:Bfp    TRANS5                                CAS006 CAP083
     C**********         ADD       SEC5Ln        Bfp                                   CAS006 CAP083
     C*****SEEXLn        SUBST     BUFFER:Bfp    ExtData                        CAP137        CAP083
      *                                                                                CAP039 CAP083
      ***SD*Security*Customer*Details                                                  CAP039 CAP083
      *                                                                                CAP039 CAP083
     C*****TYPE          WHENEQ    'SDSECD'                                            CAP039 CAP083
     C*****SECDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP039 CAP083
     C*******************ADD       SECDLn        Bfp                                   CAP039 CAP083
     C*****SDSOLn        SUBST     BUFFER:Bfp    OthDData                              CSE022 CAP083
     C*******************ADD       SDSOLn        Bfp                                   CSE022 CAP083
     C*****SDSELn        SUBST     BUFFER:Bfp    ExtData                               CAP039 CAP083
      *                                                                                CAP039 CAP083
      ***SE*Security*Diary*Events*Detail                                               CAP140 CAP083
      *                                                                                CAP140 CAP083
     C*****TYPE          WHENEQ    'SESEDE'                                            CAP140 CAP083
     C*****SEDELn        SUBST     BUFFER:Bfp    TRANS1                                CAP140 CAP083
     C*******************ADD       SEDELn        Bfp                                   CAP140 CAP083
     C*****SDEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP140 CAP083
      **********                                                                       CGL032 243084
      ***SD*Additional*Customer*Detail*********************************                CGL032 243084
      **********                                                                       CGL032 243084
     C*****TYPE          WHENEQ    'SDACUD'                                            CGL032 243084
     C*****ACUDLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
     C*******************ADD       ACEXLn        Bfp                                   CGL032 243084
     C*****ACEXLn        SUBST     BUFFER:Bfp    ExtData                               CGL032 243084
      **********                                                                       CGL032 243084
      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
      **********                                                                       CGL032 243084
     C*****TYPE          WHENEQ    'SDNAHL'                                            CGL032 243084
     C*****SDNALn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
     C*******************ADD       NaEXLn        Bfp                                   CGL032 243084
     C*****NaEXLn        SUBST     BUFFER:Bfp    ExtData                               CGL032 243084
      **********                                                                       CGL032 243084
      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
      **********                                                                       CGL032 243084
     C*****TYPE          WHENEQ    'SDCCTX'                                            CGL032 243084
     C*****CCTXLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
      **********                                                                       CGL032 243084
      ***SD*Non-A/C*Holders*Detail*************************************                CGL032 243084
      **********                                                                       CGL032 243084
     C*****TYPE          WHENEQ    'SDNATX'                                            CGL032 243084
     C*****NATXLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
      **********                                                                       CGL032 243084
      ***SD*Joint*A/c*Members*Detail***********************************                CGL032 243084
      **********                                                                       CGL032 243084
     C*****TYPE          WHENEQ    'SDJACM'                                            CGL032 243084
     C*****JACMLn        SUBST     BUFFER:Bfp    TRANS1                                CGL032 243084
      *                                                                                CAP140 CAP083
      *                                                                                CAP057 CAP083
      ***SD*Market*Data*Feed*Spot*Rate*Details                                         CAP057 CAP083
      *                                                                                CAP057 CAP083
     C*****TYPE          WHENEQ    'SDSPTR'                                            CAP057 CAP083
     C*****SPTRLn        SUBST     BUFFER:Bfp    TRANS1                                CAP057 CAP083
     C*******************ADD       SPTRLn        Bfp                                   CAP057 CAP083
     C*****SDSPLn        SUBST     BUFFER:Bfp    ExtData                               CAP057 CAP083
      *                                                                                CAP057 CAP083
      **SD*Base*Rate*Maintenance                                                       CAP038 CAP083
                                                                                       CAP038 CAP083
     C*****TYPE          WHENEQ    'SDBSRT'                                           CAP038  196570
     C*****TYPE          WHENEQ    'SDBSRS'                                           196570  CAP083
                                                                                       CAP038 CAP083
     C*****SDBSLn        SUBST     BUFFER:Bfp    TRANS1                                CAP038 CAP083
     C*******************ADD       SDBSLn        Bfp                                   CAP038 CAP083
     C*****SDBXLn        SUBST     BUFFER:Bfp    ExtData                               CAP038 CAP083
                                                                                       CAP038 CAP083
      ***AB*Internal*Funding*Deals*Detail                                              CAP042 CAP083
      *                                                                                CAP042 CAP083
     C*****TYPE          WHENEQ    'ABFUND'                                            CAP042 CAP083
     C*****FUNDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP042 CAP083
     C*******************ADD       FUNDLn        Bfp                                   CAP042 CAP083
     C*****FUEXLn        SUBST     BUFFER:Bfp    ExtData                               CAP042 CAP083
      *                                                                                CAP042 CAP083
      ***MM*REPOs*Loans*&*Deposits*Detail***                                           CAP067 CAP083
      *                                                                                CAP067 CAP083
     C*****TYPE          WHENEQ    'MMRPLD'                                            CAP067 CAP083
     C*****LDNILn        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
     C****************** ADD       LDNILn        Bfp                                   CAP067 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP067 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP067 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP067 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP067 CAP083
     C*****MMLILn        SUBST     BUFFER:Bfp    InfData                               CAP067 CAP083
     C****************** ADD       MMLILn        Bfp                                   CAP067 CAP083
     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
      *                                                                                CAP067 CAP083
      ***MM*REPOs*Depot*Movements*Detail                                               CAP067 CAP083
      *                                                                                CAP067 CAP083
     C*****TYPE          WHENEQ    'MMRPDM'                                            CAP067 CAP083
     C*****REP1Ln        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
     C****************** ADD       REP1Ln        Bfp                                   CAP067 CAP083
     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
      *                                                                                CAP067 CAP083
      ***MM*REPOs*Trailer*Detail**                                                     CAP067 CAP083
      *                                                                                CAP067 CAP083
     C*****TYPE          WHENEQ    'MMRPTR'                                            CAP067 CAP083
     C*****REP2Ln        SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
     C****************** ADD       REP2Ln        Bfp                                   CAP067 CAP083
     C*****MMLDLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
      *                                                                                CAP067 CAP083
      ***SE*Buy-Sell*Trade***                                                          CAP067 CAP083
      *                                                                                CAP067 CAP083
     C*****TYPE          WHENEQ    'SEBYSL'                                            CAP067 CAP083
                                                                                       CAP067 CAP083
     C*****20            SUBST     BUFFER:Bfp    TRANS1                                CAP067 CAP083
     C****************** ADD       20            Bfp                                   CAP067 CAP083
     C****************** EVAL      %SUBST(TRANS1:21) = %SUBST(BUFFER:Bfp:TRPRLn)       CAP067 CAP083
     C****************** ADD       TRPRLn        Bfp                                   CAP067 CAP083
     C*****TRSELn        SUBST     BUFFER:Bfp    TRANS2                                CAP067 CAP083
     C****************** ADD       TRSELn        Bfp                                   CAP067 CAP083
     C*****TREXLn        SUBST     BUFFER:Bfp    TRANS3                                CAP067 CAP083
     C****************** ADD       TREXLn        Bfp                                   CAP067 CAP083
     C*****TRSTLn        SUBST     BUFFER:Bfp    TRANS4                                CAP067 CAP083
     C****************** ADD       TRSTLn        Bfp                                   CAP067 CAP083
     C*****TRCCLn        SUBST     BUFFER:Bfp    TRANS5                                CAP067 CAP083
     C****************** ADD       TRCCLn        Bfp                                   CAP067 CAP083
     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS6                                CAP067 CAP083
     C****************** ADD       TRSWLn        Bfp                                   CAP067 CAP083
     C*****TRSWLn        SUBST     BUFFER:Bfp    TRANS7                                CAP067 CAP083
     C****************** ADD       TRSWLn        Bfp                                   CAP067 CAP083
     C*****TRTHLn        SUBST     BUFFER:Bfp    TRANS8                                CAS006 CAP083
     C**********         ADD       TRTHLn        Bfp                                   CAS006 CAP083
      *                                                                                CAP067 CAP083
      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP067 CAP083
      *                                                                                CAP067 CAP083
     C*****SETILn        SUBST     BUFFER:Bfp    InfData                               CAP067 CAP083
     C****************** ADD       SETILn        Bfp                                   CAP067 CAP083
     C*****SETRLn        SUBST     BUFFER:Bfp    ExtData                               CAP067 CAP083
                                                                                       CAP067 CAP083
      ***SD*Yield*Rates*Details**                                                      CAS001 CAP083
                                                                                       CAS001 CAP083
     C*****TYPE          WHENEQ    'SDYRAT'                                            CAS001 CAP083
     C*****CAS001        ANDEQ     'Y'                                                 CAS001 CAP083
                                                                                       CAS001 CAP083
     C*****YRAT1Ln       SUBST     BUFFER:Bfp    TRANS1                                CAS001 CAP083
     C****************** ADD       YRAT1Ln       Bfp                                   CAS001 CAP083
     C*****YRAT2Ln       SUBST     BUFFER:Bfp    TRANS2                                CAS001 CAP083
     C****************** ADD       YRAT2Ln       Bfp                                   CAS001 CAP083
     C*****YRAT3Ln       SUBST     BUFFER:Bfp    TRANS3                                CAS001 CAP083
     C****************** ADD       YRAT3Ln       Bfp                                   CAS001 CAP083
     C*****YRAT4Ln       SUBST     BUFFER:Bfp    TRANS4                                CAS001 CAP083
     C****************** ADD       YRAT4Ln       Bfp                                   CAS001 CAP083
     C*****SDYRLn        SUBST     BUFFER:Bfp    ExtData                               CAS001 CAP083
                                                                                       CAP070 CAP083
      **LE*Assignments***                                                              CAP070 CAP083
                                                                                       CAP070 CAP083
     C*****TYPE          WHENEQ    'LEASGN'                                            CAP070 CAP083
                                                                                       CAP070 CAP083
     C*****ASGNLn        SUBST     BUFFER:Bfp    TRANS1                                CAP070 CAP083
     C****************** ADD       ASGNLn        Bfp                                   CAP070 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP070 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP070 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP070 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP070 CAP083
                                                                                       CAP070 CAP083
      **LE*Risk*Participants***                                                        CAP070 CAP083
                                                                                       CAP070 CAP083
     C*****TYPE          WHENEQ    'LERPRT'                                            CAP070 CAP083
                                                                                       CAP070 CAP083
     C*****RPRTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP070 CAP083
     C****************** ADD       RPRTLn        Bfp                                   CAP070 CAP083
     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP070 CAP083
     C****************** ADD       LIAB1Ln       Bfp                                   CAP070 CAP083
     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP070 CAP083
     C****************** ADD       LIAB2Ln       Bfp                                   CAP070 CAP083
     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP070 CAP083
     C****************** ADD       LIAZLn        Bfp                                   CAP070 CAP083
                                                                                       CAP068 CAP083
      **LE*Funding*Participants**                                                      CAP068 CAP083
                                                                                       CAP068 CAP083
     C*****TYPE          WHENEQ    'LEFPRT'                                            CAP068 CAP083
                                                                                       CAP068 CAP083
     C*****FPRTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP068 CAP083
     C****************** ADD       FPRTLn        Bfp                                   CAP068 CAP083
     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP068 CAP083
     C****************** ADD       LIAB1Ln       Bfp                                   CAP068 CAP083
     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP068 CAP083
     C****************** ADD       LIAB2Ln       Bfp                                   CAP068 CAP083
     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP068 CAP083
     C****************** ADD       LIAZLn        Bfp                                   CAP068 CAP083
                                                                                       CAP071 CAP083
      **LE*Facility*Amendments***                                                      CAP071 CAP083
                                                                                       CAP071 CAP083
     C*****TYPE          WHENEQ    'LEFAMD'                                            CAP071 CAP083
                                                                                       CAP071 CAP083
     C*****FAMDLn        SUBST     BUFFER:Bfp    TRANS1                                CAP071 CAP083
     C****************** ADD       FAMDLn        Bfp                                   CAP071 CAP083
                                                                                       CAP072 CAP083
      **LE*Fee*Adjustment*input***                                                     CAP072 CAP083
                                                                                       CAP072 CAP083
     C*****TYPE          WHENEQ    'LEFEAD'                                            CAP072 CAP083
                                                                                       CAP072 CAP083
     C*****FEADLn        SUBST     BUFFER:Bfp    TRANS1                                CAP072 CAP083
     C****************** ADD       FEADLn        Bfp                                   CAP072 CAP083
                                                                                       CAP072 CAP083
      **LE*Fee*Settlement*input                                                        CAP072 CAP083
                                                                                       CAP072 CAP083
     C*****TYPE          WHENEQ    'LEFEST'                                            CAP072 CAP083
                                                                                       CAP072 CAP083
     C*****FESTLn        SUBST     BUFFER:Bfp    TRANS1                                CAP072 CAP083
     C****************** ADD       FESTLn        Bfp                                   CAP072 CAP083
     C*****LIAB1Ln       SUBST     BUFFER:Bfp    TRANS2                                CAP072 CAP083
     C****************** ADD       LIAB1Ln       Bfp                                   CAP072 CAP083
     C*****LIAB2Ln       SUBST     BUFFER:Bfp    TRANS3                                CAP072 CAP083
     C****************** ADD       LIAB2Ln       Bfp                                   CAP072 CAP083
     C*****LIAZLn        SUBST     BUFFER:Bfp    TRANS3                                CAP072 CAP083
     C****************** ADD       LIAZLn        Bfp                                   CAP072 CAP083
                                                                                       CSC011 CAP083
      **LE*Facility*Input***                                                           CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LEFCTY'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****FCTY1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       FCTY1Ln       Bfp                                   CSC011 CAP083
     C*****FCTY2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       FCTY2Ln       Bfp                                   CSC011 CAP083
     C*****FCTY3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
     C****************** ADD       FCTY3Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loans*Input***                                                              CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELOAN'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LOAN1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LOAN1Ln       Bfp                                   CSC011 CAP083
     C*****LOAN2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LOAN2Ln       Bfp                                   CSC011 CAP083
     C*****LOAN3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
     C****************** ADD       LOAN3Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Participations*Purchased*Input                                              CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LEPTPU'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****PTPU1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       PTPU1Ln       Bfp                                   CSC011 CAP083
     C*****PTPU2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       PTPU2Ln       Bfp                                   CSC011 CAP083
     C*****PTPU3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
     C****************** ADD       PTPU3Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Participations*Sold*Input                                                   CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LEPTSO'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****PTSO1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       PTSO1Ln       Bfp                                   CSC011 CAP083
     C*****PTSO2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       PTSO2Ln       Bfp                                   CSC011 CAP083
     C*****PTSO3Ln       SUBST     BUFFER:Bfp    TRANS3                                CSC011 CAP083
     C****************** ADD       PTSO3Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Principal*Transfer*To                               CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELAPT'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LAPT1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LAPT1Ln       Bfp                                   CSC011 CAP083
     C*****LAPT2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LAPT2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Principal*Transfer*From                             CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELAPF'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LAPF1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LAPF1Ln       Bfp                                   CSC011 CAP083
     C*****LAPF2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LAPF2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Principal*Increase                                  CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELAPI'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LAPI1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LAPI1Ln       Bfp                                   CSC011 CAP083
     C*****LAPI2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LAPI2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Base*Rate*Change                                    CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELABC'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LABC1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LABC1Ln       Bfp                                   CSC011 CAP083
     C*****LABC2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LABC2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Spread*Change                                       CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELASC'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LASC1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LASC1Ln       Bfp                                   CSC011 CAP083
     C*****LASC2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LASC2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Stop/Start*Accrual                                  CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELASA'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LASA1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LASA1Ln       Bfp                                   CSC011 CAP083
     C*****LASA2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LASA2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Loan*Amendments*Input*-*Stop/Start*Accrual                                  CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELALS'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LALS1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LALS1Ln       Bfp                                   CSC011 CAP083
     C*****LALS2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LALS2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Rollover*Input***                                                           CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LEROLL'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****ROLL1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       ROLL1Ln       Bfp                                   CSC011 CAP083
     C*****ROLL2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       ROLL2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Manual*Repayment***                                                         CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LELAMR'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****LAMR1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       LAMR1Ln       Bfp                                   CSC011 CAP083
     C*****LAMR2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       LAMR2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      **LE*Fees*Input***                                                               CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****TYPE          WHENEQ    'LEFEES'                                            CSC011 CAP083
                                                                                       CSC011 CAP083
     C*****FEES1Ln       SUBST     BUFFER:Bfp    TRANS1                                CSC011 CAP083
     C****************** ADD       FEES1Ln       Bfp                                   CSC011 CAP083
     C*****FEES2Ln       SUBST     BUFFER:Bfp    TRANS2                                CSC011 CAP083
     C****************** ADD       FEES2Ln       Bfp                                   CSC011 CAP083
                                                                                       CSC011 CAP083
      ***IR*Caps/Collars/Floors*Details                                                CAP055 CAP083
                                                                                       CAP055 CAP083
     C*****TYPE          WHENEQ    'IRCACF'                                            CAP055 CAP083
                                                                                       CAP055 CAP083
     C*****CACFLn        SUBST     BUFFER:Bfp    TRANS1                                CAP055 CAP083
     C****************** ADD       CACFLn        Bfp                                   CAP055 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP055 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP055 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP055 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP055 CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP055 CAP083
     C****************** ADD       ESSFLn        Bfp                                   CAP055 CAP083
                                                                                       CAP056 CAP083
      ****Non-Screen*Interface*Data*for*Class*1*enhancements                           CAP056 CAP083
                                                                                       CAP056 CAP083
     C*****IRRPLn        SUBST     BUFFER:Bfp    InfData                               CAP056 CAP083
     C****************** ADD       IRRPLn        Bfp                                   CAP055 CAP083
     C*****CACXLn        SUBST     BUFFER:Bfp    ExtData                               CAP055 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change*Schedules*(Caps/Collars/Floors)                              CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCAPC'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change***                                                           CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WPCSC1OLn     SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WPCSC1OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC2OLn     SUBST     BUFFER:Bfp    TRANS2                                CAP043 CAP083
     C****************** ADD       WPCSC2OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC3OLn     SUBST     BUFFER:Bfp    TRANS3                                CAP043 CAP083
     C****************** ADD       WPCSC3OLn     Bfp                                   CAP043 CAP083
     C*****WPCSC4OLn     SUBST     BUFFER:Bfp    TRANS4                                CAP043 CAP083
     C****************** ADD       WPCSC4OLn     Bfp                                   CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Trailer*record*(Caps/Collars/Floors)                                          CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****TYPE          WHENEQ    'IRCATR'                                            CAP043 CAP083
     C*****CAP043        ANDEQ     'Y'                                                 CAP043 CAP083
                                                                                       CAP043 CAP083
     C*****WTRSCLn       SUBST     BUFFER:Bfp    TRANS1                                CAP043 CAP083
     C****************** ADD       WTRSCLn       Bfp                                   CAP043 CAP083
     C*****ESSRLn        SUBST     BUFFER:Bfp    RecSttmt                              CAP043 CAP083
     C****************** ADD       ESSRLn        Bfp                                   CAP043 CAP083
     C*****ESSPLn        SUBST     BUFFER:Bfp    PaySttmt                              CAP043 CAP083
     C****************** ADD       ESSPLn        Bfp                                   CAP043 CAP083
     C*****ESSFLn        SUBST     BUFFER:Bfp    FRASttmt                              CAP043 CAP083
     C****************** ADD       ESSFLn        Bfp                                   CAP043 CAP083
     C*****IRRPLn        SUBST     BUFFER:Bfp    InfData                               CAP043 CAP083
     C****************** ADD       IRRPLn        Bfp                                   CAP043 CAP083
     C*****IRSSLn        SUBST     BUFFER:Bfp    ExtData                               CAP043 CAP083
      *                                                                                CAP042 CAP083
      ***SE*Movements*Details                                                          CSE039 CAP083
      *                                                                                CSE039 CAP083
     C*****TYPE          WHENEQ    'SEMVTS'                                            CSE039 CAP083
     C*****MVTSLn        SUBST     BUFFER:Bfp    TRANS1                                CSE039 CAP083
     C*******************ADD       MVTSLn        Bfp                                   CSE039 CAP083
     C*****MVEXLn        SUBST     BUFFER:Bfp    ExtData                               CSE039 CAP083
      *                                                                                CAP182 CAP083
      ***SE*Trade*Settlements*Details                                                  CAP182 CAP083
      *                                                                                CAP182 CAP083
     C*****TYPE          WHENEQ    'SETRSM'                                            CAP182 CAP083
     C*****TRSMLn        SUBST     BUFFER:Bfp    TRANS1                                CAP182 CAP083
     C*******************ADD       TRSMLn        Bfp                                   CAP182 CAP083
     C*****TREXLn        SUBST     BUFFER:Bfp    ExtData                               CAP182 CAP083
      *                                                                                CAP182 CAP083
      ***SE*Statement*Production*Requests                                              CSE040 CAP083
      *                                                                                CSE040 CAP083
     C*****TYPE          WHENEQ    'SESTPR'                                            CSE040 CAP083
     C*****STPRLn        SUBST     BUFFER:Bfp    TRANS1                                CSE040 CAP083
     C*******************ADD       STPRLn        Bfp                                   CSE040 CAP083
     C*****SPEXLn        SUBST     BUFFER:Bfp    ExtData                               CSE040 CAP083
     C*COPY*WNCPYSRC,APINCOMMC1                                                               CAP083
      *                                                                                CPK015 CAP083
      ***Any*unrecognised*message*types*are*written*to*the*error*file                  CPK015 CAP083
      *                                                                                CPK015 CAP083
     C************       OTHER                                                         CPK015 CAP083
     C************       WRITE     APEXCPERD0                                          CPK015 CAP083
     C************       COMMIT                                                        CPK015 CAP083
     C************       EVAL      Bypass = 'Y'                                        CPK015 CAP083
     C*******************ENDSL                                                  CAP035        CAP083
     C*******************ENDSL                                                         CGL032 243084
                                                                                CAP003
                                                                                CAP003
     C****************** ENDSR                                                  CAP003        CAP083
     C*******************ENDSR                                                         CGL032 243084
      ****************************************************************          CAP003
      /EJECT                                                                    CAP003
      ****************************************************************
      *                                                              *
      *  Wait for incoming messages                                  *
      *                                                              *
      ****************************************************************
     C     GETMSG        BEGSR
 
      ** Get options: WAIT, CONVERT and ALLOW TRUNCATION.
      ** Note: the last of these options means that a message longer than
      ** the buffer length defined in this module (currently 1500 bytes)
      ** will be read and removed from the queue.  Any data in the message
      ** after the 1500th byte will be lost.
     C                   Z-ADD     GMWT          GMOPT
     C                   ADD       GMCONV        GMOPT
     C                   ADD       GMATM         GMOPT
 
      ** Set wait interval to infinite
     C                   Z-ADD     WIULIM        GMWI
     C/COPY WNCPYSRC,APH00077
 
      ** Perform get operation inside commitment control. Commitment
      ** boundary is at the valid/invalid deals file. Any return
      ** MQ messages are also inside this commitment cycle.
     C                   ADD       GMSYP         GMOPT
 
      ** MsgId and CorrelId are selectors cleared to ensure messages
      ** are processed in arrival/priority sequence
     C                   MOVEL     MINONE        MDMID
     C                   MOVEL     CINONE        MDCID
 
      ** Clear message buffer
     C                   MOVEL     *BLANKS       BUFFER
 
     C/COPY WNCPYSRC,APH00051
      ** Get message
     C**********         Z-ADD     MQGET         CID                                        MD041126
      **********                                                                            MD041126
     C**********         CALL      'QMQM'                                                   MD041126
     C**********         PARM                    CID               9 0                      MD041126
     C**********         PARM                    HCONN             9 0                      MD041126
     C**********         PARM                    HIN               9 0                      MD041126
     C**********         PARM                    MQMD                                       MD041126
     C**********         PARM                    MQGMO                                      MD041126
     C**********         PARM                    BUFLEN            9 0                      MD041126
     C**********         PARM                    BUFFER                                     MD041126
     C**********         PARM                    MESLEN            9 0                      MD041126
     C**********         PARM                    CCODE             9 0                      MD041126
     C**********         PARM                    REASON            9 0                      MD041126
      *                                                                                     MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
      *                                                                                      248095A
      ** If connection handle not valid error, reconnect and try again                       248095A
      *                                                                                      248095A
     C     REASON        IFEQ      RC2018                                                    248095A
     C     REASON        OREQ      RC2019                                                    248095A
     C                   EXSR      CLQIN                                                     248095A
     C                   EXSR      MQDISCONNECT                                              248095A
     C                   EXSR      MQCONNECT                                                 248095A
     C/COPY WNCPYSRC,APH00078
     C                   Z-ADD     HANDLE        HCONN                                       248095A
     C                   EXSR      OPQIN                                                     248095A
     C/COPY WNCPYSRC,APH00052
     C**********         Z-ADD     MQGET         CID                                248095A MD041126
     C**********         CALL      'QMQM'                                           248095A MD041126
     C**********         PARM                    CID               9 0              248095A MD041126
     C**********         PARM                    HCONN             9 0              248095A MD041126
     C**********         PARM                    HIN               9 0              248095A MD041126
     C**********         PARM                    MQMD                               248095A MD041126
     C**********         PARM                    MQGMO                              248095A MD041126
     C**********         PARM                    BUFLEN            9 0              248095A MD041126
     C**********         PARM                    BUFFER                             248095A MD041126
     C**********         PARM                    MESLEN            9 0              248095A MD041126
     C**********         PARM                    CCODE             9 0              248095A MD041126
     C**********         PARM                    REASON            9 0              248095A MD041126
      *                                                                                     MD041126
     C                   CALLP     MQGET( HCONN : HIN : MQMD : MQGMO :                      MD041126
     C                                    BUFLEN : %ADDR(BUFFER) :                          MD041126
     C                                    MESLEN : CCODE : REASON )                         MD041126
     C                   ENDIF                                                               248095A
 
      ** Error processing
     C     REASON        IFNE      RCNONE
     C/COPY WNCPYSRC,APH00053
 
      ** Send message to MOPERQ and QSYSOPR before crashing out
     C****************** MOVEL     ReadFailed    MQError                        138019
     C****************** MOVE      REASON        MQError                        138019
     C                   MOVE      REASON        ReasonA                        138019
     C                   EVAL      MQError = ReadFailed + ReasonA               138019
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
 
      ** Shut down the program
     C                   EXSR      *pssr
 
     C/COPY WNCPYSRC,APH00054
     C                   ENDIF
 
     C                   ENDSR
      ****************************************************************
     C/COPY WNCPYSRC,APH00055
      /EJECT
      ****************************************************************
      *                                                              *
      *  Validate the profile & password                             *
      *                                                              *
      ****************************************************************
     C     ValPrfPwd     BEGSR
 
      ** Decode the APPASSWORD field in preparation for the validation
     C                   EXSR      DECODE
 
      ** The following call is an OS/400 API which will validate
      ** the incoming message parameters of UserId and Password.
      ** If the incoming details were valid, then the field QUSEI
      ** in the Error Code structure will be blank. The profile
      ** handle must be explicitly released.
      ** If the incoming details were invalid, then the message is
      ** logged to APUNAUTHPD, and a message is sent to QSYSOPR.
      ** Unauthorised information will not be logged to APOUTPUTPD, as
      ** this file is updated during the VALID8 subroutine.
 
     C                   MOVE      *BLANKS       PrfHandle
     C                   RESET                   QUSEC
 
     C                   CALL      'QSYGETPH'
     C                   PARM                    USERID
     C                   PARM                    PASSWORD
     C                   PARM                    PrfHandle        12
     C                   PARM                    QUSEC
 
      ** The UserID and Password fields are now irrelevant, and are
      ** starred out to prevent them appearing on log files and dumps.
     C                   MOVE      '**********'  APPASSWORD
     C                   MOVE      '**********'  PASSWORD
 
     C                   ENDSR
      /EJECT
      ****************************************************************
      *                                                              *
      *  Send Profile / Password error message                       *
      *                                                              *
      ****************************************************************
     C     PrfPwdErr     BEGSR
 
      ** Send message to QSYSOPR warning of attempted unauthorised
      ** access to Midas APIs
 
 
     C                   CLEAR                   MQError
     C                   EVAL      MsgF = 'APMSGF'
     C                   IF        APUserID = *Blanks
     C                   EVAL      MsgID = 'API0002'
     C                   ELSE
     C                   EVAL      MsgID = 'API0001'
     C                   END
 
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MQReturn
     C                   PARM                    MQError
     C                   PARM                    MsgID
     C                   PARM                    MsgF
 
     C                   OPEN      APUNAUTHPD
     C                   WRITE     APUNAUTHD0
     C                   CLOSE     APUNAUTHPD
 
 
      ** Commit the MQGET operation
     C                   COMMIT
 
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      *                                                              *
      *  Decode the password field                                   *
      *                                                              *
      ****************************************************************
     C     DECODE        BEGSR
 
     C                   MOVE      *BLANK        CURRCHAR          1
     C                   MOVE      *BLANKS       DECODED          10
     C                   Z-ADD     0             W                 1 0
     C                   Z-ADD     0             X                 3 0
     C                   Z-ADD     0             Y                 2 0
     C                   Z-ADD     1             Z                 2 0
      * W is 1 or 0 and says how blanks to pad the CAT to the decoded
      *  passwork with, depending upon whether the previous char was blank
      * X is the position in the clear or enciphered constant,
      * Y is a work field
      * Z is the position in the incoming (enciphered) password
 
     C     Z             DOWLT     11
 
      ** Get the next character in the password
     C     1             SUBST     PASSWORD:Z    CURRCHAR
 
      ** Look up the cipher value
     C     CURRCHAR      SCAN      CIPHER        X
 
      ** Ignore unrecognised characters
     C     X             IFNE      0
 
     C     Z             MULT      2             Y
     C                   SUB       Y             X
     C     X             IFLE      0
     C                   ADD       63            X
     C                   ENDIF
 
      ** Substitute in the correct value
     C     1             SUBST     CHARSET:X     CURRCHAR
 
      ** Drop out if character is a blank
     C     CURRCHAR      IFEQ      *BLANK
     C                   LEAVE
     C                   ENDIF
     C                   ENDIF
 
     C                   CAT       CURRCHAR:W    DECODED
 
      ** Cater for special case of blanks
     C     CURRCHAR      IFEQ      *BLANK
     C                   Z-ADD     1             W
     C                   ELSE
     C                   Z-ADD     0             W
     C                   ENDIF
 
     C                   ADD       1             Z
 
     C                   ENDDO
 
     C                   MOVEL     DECODED       PASSWORD
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************                        CAP083
      *                                                              *                        CAP083
      ***Get*Record Lengths of Transaction Data Blocks               *                        CAP083
      *                                                              *                        CAP083
      ****************************************************************                        CAP083
     C*****GETRCDLN      BEGSR                                                                CAP083
                                                                                              CAP083
     C*******************CALLB     'UTGETRCDLN'                                               CAP083
                                                                                              CAP083
      ***Return*code                                                                          CAP083
     C*******************PARM                    ReturnCode                                   CAP083
      ***Record*length                                                                        CAP083
     C*******************PARM      *ZERO         RecordLen         5 0                        CAP083
                                                                                              CAP083
      ***File*name                                                                            CAP083
     C*******************PARM                    FileName         10                          CAP083
      ***File*library                                                                         CAP083
     C*******************PARM      '*LIBL     '  FileLib          10                          CAP083
                                                                                              CAP083
      ***If*file not found (or any other error) shut down the program                  CPK015 CAP083
     C*****ReturnCode    Ifne      *Blanks                                             CPK015 CAP083
     C**********         EXSR      *pssr                                               CPK015 CAP083
     C**********         EndIf                                                         CPK015 CAP083
      **********                                                                       CPK015 CAP083
      ***Clear*the file name field to prevent it getting corrupted by           CAP031        CAP083
      ***later*MOVELs.                                                          CAP031        CAP083
     C*******************CLEAR                   FileName                       CAP031        CAP083
                                                                                              CAP083
     C*******************ENDSR                                                                CAP083
      ****************************************************************                        CAP083
      /EJECT                                                                                  CAP083
      ****************************************************************                 CGL032 243084
      ***Reinstate*GETRCDLN*subroutine********************************                 CGL032 243084
      ***Get*Record*Lengths*of*Transaction*Data*Blocks****************                 CGL032 243084
      **********                                                                       CGL032 243084
      ****************************************************************                 CGL032 243084
     C*****GETRCDLN      BEGSR                                                         CGL032 243084
      **********                                                                       CGL032 243084
     C**********         CALLB     'UTGETRCDLN'                                        CGL032 243084
      **********                                                                       CGL032 243084
      ***Return*code**************************************************                 CGL032 243084
     C**********         PARM                    ReturnCode                            CGL032 243084
      ***Record*length************************************************                 CGL032 243084
     C**********         PARM      *ZERO         RecordLen         5 0                 CGL032 243084
      **********                                                                       CGL032 243084
      ***File*name****************************************************                 CGL032 243084
     C**********         PARM                    FileName         10                   CGL032 243084
      ***File*library*************************************************                 CGL032 243084
     C**********         PARM      '*LIBL     '  FileLib          10                   CGL032 243084
      **********                                                                       CGL032 243084
      ***If*file*not*found*(or*any*other*error)*shut*down*the*program**                CGL032 243084
     C*****ReturnCode    Ifne      *Blanks                                             CGL032 243084
     C**********         EXSR      *pssr                                               CGL032 243084
     C**********         EndIf                                                         CGL032 243084
      **********                                                                       CGL032 243084
      ***Clear*the*file*name*field*to*prevent*it*getting*corrupted*by**                CGL032 243084
      ***later*MOVELs.*************************************************                CGL032 243084
     C**********         CLEAR                   FileName                              CGL032 243084
      **********                                                                       CGL032 243084
     C**********         ENDSR                                                         CGL032 243084
      *****************************************************************                CGL032 243084
      /EJECT                                                                           CGL032 243084
      ****************************************************************
      *                                                              *
      *  Initialisation                                              *
      *                                                              *
      ****************************************************************
     C     *INZSR        BEGSR
 
      *  Lock allocation data area
 
      *   The data area is allocated *SHRRD here.
      *   The function to submit this tries to get a *EXCL lock.
 
      *                         Submitter
      *                 Lock      Lock     Submitter
      *      Status    Status   Successful   Action
      *      ------    ------   ---------- ---------
      *   Not running  None        Yes      Submit this
 
      *   Running      *SHRRD      No        None
 
     C                   CALLB     'APCALCOBJ'
     C                   PARM                    Object
     C                   PARM                    Lib
     C                   PARM                    ObjType
     C                   PARM                    LockStateS
     C                   PARM                    Member
     C                   PARM                    WaitTime
     C                   PARM                    Dlcobj
     C                   PARM                    Return
 
      ** Set up input queue name for transactions
     C                   MOVEL     RootQueue     QIN
     C                   IN        SDSTAT
     C                   MOVE      LIBR          SysPrefix
 
      ** Set up Midas SPF Environment
     C                   CALL      'SFC0401'
 
      ** Create required QTEMP objects
     C                   CALL      'APCCRTQTO'
     C                   PARM                    ReturnCde        10
 
      ** Check for success, else bomb
     C     ReturnCde     IFNE      *BLANKS
     C                   ENDIF
 
      ** Use default connection handle, and implicit connection
     C                   Z-ADD     HCDEFH        HCONN
 
      ** Set incoming message length
     C*******            Z-ADD     3000          BUFLEN                         CAP004
     C*******            Z-ADD     4000          BUFLEN                   CAP004182598
     C**********         Z-ADD     5000          BUFLEN                                182598 CIR003
     C**********         Z-ADD     6000          BUFLEN                                CIR003 CFT039
     C**********         Z-ADD     12000         BUFLEN                                CFT039 CSW213
     C                   Z-ADD     29997         BUFLEN                                       CSW213
 
      ** Log job start-up in jobs file
     C                   OPEN      APIJOBL0
     C                   WRITE     JOBRCD
     C                   CLOSE     APIJOBL0
 
      ** Set up the procedure/module/program names for calls to the
      **  validation modules
     C                   EVAL      #ProcPgm  = PSProcPgm
     C                   EVAL      #ProcMod  = PSProcMod
     C                   EVAL      #ProcName = PSProcName
 
      ** Call CL to start commitment control
     C                   CALLB     'ZACSCMTCTL'
 
      ** Access API ICD via access program
      *  (database error handling done in access program)
     C                   CALLB     'AOAPIR0'
     C                   PARM      '*DBERR '     @RTCD             7
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDAPI         PARM      SDAPI         DSFDY
     C/COPY WNCPYSRC,APH00056
 
      ***Determine*API*Header record lengths                                                  CAP083
                                                                                              CAP083
     C*******************MOVEL     'APHEADPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     HEADLn            4 0                        CAP083
                                                                                              CAP083
      ***Determine*transaction data record lengths                                            CAP083
                                                                                              CAP083
      ***(Dealing)*Extended Payment Instructions                                              CAP083
                                                                                              CAP083
     C*******************MOVEL     'SDESSPPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     ESSPLn            4 0                        CAP083
                                                                                              CAP083
      ***(Dealing)*Extended Receive Instructions                                              CAP083
                                                                                              CAP083
     C*******************MOVEL     'SDESSRPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     ESSRLn            4 0                        CAP083
                                                                                              CAP083
      ***(Dealing)*Extended FRA/IRS Instructions                                              CAP083
                                                                                              CAP083
     C*******************MOVEL     'SDESSFPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     ESSFLn            4 0                        CAP083
                                                                                              CAP083
      ***FX*deals                                                                             CAP083
                                                                                              CAP083
     C*******************MOVEL     'FXFXDLPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     FXDLLn            4 0                        CAP083
                                                                                              CAP083
      ***Loans/deposits                                                                       CAP083
                                                                                              CAP083
     C*******************MOVEL     'MMLDNIPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     LDNILn            4 0                        CAP083
 
      ***Check*if*CDL006*enhancement*is*installed***                                   209905 CAP083
                                                                                       209905 CAP083
     C****************** CALLB     'AOSARDR0'                                          209905 CAP083
     C****************** PARM      *BLANKS       PRtCd                                 209905 CAP083
     C****************** PARM      '*VERIFY'     POptn                                 209905 CAP083
     C****************** PARM      'CDL006'      PSarD                                 209905 CAP083
     C*****SCSARD        PARM      SCSARD        DSFDY                                 209905 CAP083
                                                                                       209905 CAP083
     C*****PRtCd         IFEQ      *BLANK                                              209905 CAP083
     C****************** MOVEL     'Y'           CDL006                                209905 CAP083
     C****************** ELSE                                                          209905 CAP083
     C****************** MOVEL     'N'           CDL006                                209905 CAP083
     C****************** ENDIF                                                         209905 CAP083
                                                                                              CAP083
     C***********        IF        CDL006 = 'Y'                                        209905 CAP083
                                                                                       209905 CAP083
     C***********        CLEAR                   FileName                              209905 CAP083
     C***********        MOVEL     'MMFIDT1PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT1Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT2PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT2Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT3PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT3Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT4PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT4Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT5PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT5Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT6PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT6Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT7PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT7Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT8PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT8Ln                              209905 CAP083
     C***********        MOVEL     'MMFIDT9PD'   FileName                              209905 CAP083
     C***********        EXSR      GETRCDLN                                            209905 CAP083
     C***********        Z-ADD     RecordLen     WFIDT9Ln                              209905 CAP083
                                                                                       209905 CAP083
     C***********        ENDIF                                                         209905 CAP083
                                                                                       209905 CAP083
      ***Deal*Amendments                                                                      CAP083
                                                                                              CAP083
     C*******************MOVEL     'MMDEAMPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     DEAMLn            4 0                        CAP083
                                                                                              CAP083
      ***NAs*Purchased                                                                        CAP083
                                                                                              CAP083
     C*******************MOVEL     'MMNASPPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     NASPLn            4 0                        CAP083
                                                                                              CAP083
      ***NAs*Sold                                                                             CAP083
                                                                                              CAP083
     C*******************MOVEL     'MMNASSPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     NASSLn            4 0                        CAP083
                                                                                              CAP083
      ***Forward*Rate Agreements                                                              CAP083
                                                                                              CAP083
     C*******************MOVEL     'IRFRAPD '    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     FRALn             4 0                        CAP083
                                                                                              CAP083
      ***Single*Currency Interest Rate Swaps                                                  CAP083
                                                                                              CAP083
     C*******************MOVEL     'IRSIRSPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     SIRSLn            4 0                        CAP083
     C*******************MOVEL     'IRDTSCPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTORLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTOPLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTTRLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTTPLn            4 0          CAP004        CAP083
                                                                                              CAP083
      ***Cross*Currency Interest Rate Swaps                                                   CAP083
                                                                                              CAP083
     C*******************MOVEL     'IRCIRSPD'    FileName                                     CAP083
     C*******************EXSR      GETRCDLN                                                   CAP083
     C*******************Z-ADD     RecordLen     CIRSLn            4 0                        CAP083
     C*******************MOVEL     'IRDTSCPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTORLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTOPLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTTRLn            4 0          CAP004        CAP083
     C*******************Z-ADD     RecordLen     DTTPLn            4 0          CAP004        CAP083
                                                                                CAP003        CAP083
      ***SE*Trade: Primary, Secondary, Exchange Rates, Settlement Details,      CAP003        CAP083
      **           Charges & Commissions, SWIFT Details                                       CAP083
                                                                                CAP003        CAP083
     C*******************MOVEL     'SETRPRPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TRPRLn            4 0          CAP003        CAP083
     C*******************MOVEL     'SETRSEPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TRSELn            4 0          CAP003        CAP083
     C**********         MOVEL     'SETRTHPD'    FileName                              CAS006 CAP083
     C**********         EXSR      GETRCDLN                                            CAS006 CAP083
     C**********         Z-ADD     RecordLen     TRTHLn            4 0                 CAS006 CAP083
     C**********         MOVEL     'SETREXPD'    FileName                 CAP003175717
     C**********         MOVEL     'SETDEXPD'    FileName                              175717 CAP067
     C*******************MOVEL     'SETREXPD'    FileName                              CAP067 CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TREXLn            4 0          CAP003        CAP083
     C*******************MOVEL     'SETRSTPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TRSTLn            4 0          CAP003        CAP083
     C*******************MOVEL     'SETRCCPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TRCCLn            4 0          CAP003        CAP083
     C*******************MOVEL     'SETRSWPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     TRSWLn            4 0          CAP003        CAP083
                                                                                CAP003        CAP083
      ***SE*Walk In Depot Movement                                              CAP003        CAP083
                                                                                CAP003        CAP083
     C*******************MOVEL     'SEDMWIPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     DMWILn            4 0          CAP003        CAP083
                                                                                CAP003        CAP083
      ***SE*Walk Out Depot Movement                                             CAP003        CAP083
                                                                                CAP003        CAP083
     C*******************MOVEL     'SEDMWOPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     DMWOLn            4 0          CAP003        CAP083
                                                                                CAP004        CAP083
      ***AB*Internal Contracts                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'ABINTCPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     INTCLn            4 0          CAP004        CAP083
                                                                                CAP003        CAP083
      ***FF*Exchange-traded*futures*and*options:*comprises*the*transactionCAP003CAP004
      ***length*plus*the*broker*settlements*length*plus*the*customer***   CAP003CAP004
      ***settlements*length.*******************************************   CAP003CAP004
      ***FF*Exchange-traded futures and options: comprises transaction          CAP004        CAP083
      ***details,*broker settlements details and customer settlements           CAP004        CAP083
      ***details.                                                               CAP004        CAP083
     C*******************MOVEL     'FFEXTRPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     EXTRLn            4 0          CAP003        CAP083
                                                                                CAP003        CAP083
     C*******************MOVEL     'FFBSETPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C**********         ADD       RecordLen     EXTRLn                   CAP003CAP004
     C**********         ADD       RecordLen     BSETLn            4 0    CAP004186715
     C*******************Z-ADD     RecordLen     BSETLn            4 0          186715        CAP083
                                                                                CAP003        CAP083
     C*******************MOVEL     'FFCSETPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C**********         ADD       RecordLen     EXTRLn                   CAP003CAP004
     C**********         ADD       RecordLen     CSETLn            4 0    CAP004186715
     C*******************Z-ADD     RecordLen     CSETLn            4 0          186715        CAP083
                                                                                CAP003        CAP083
      ***FF*Currency*over-the-counter*options*comprises*the*transaction   CAP003CAP004
      ***length*plus*the*broker*settlements*length*plus*the*customer***   CAP003CAP004
      ***settlements*length.*******************************************   CAP003CAP004
      ***FF*Currency over-the-counter options: comprises transaction            CAP004        CAP083
      ***details*and customer settlements details (the latter length is         CAP004        CAP083
      ***determined*above).                                                     CAP004        CAP083
     C*******************MOVEL     'FFOTCCPD'    FileName                       CAP003        CAP083
     C*******************EXSR      GETRCDLN                                     CAP003        CAP083
     C*******************Z-ADD     RecordLen     OTCCLn            4 0          CAP003        CAP083
                                                                                CAP004        CAP083
     C**********         MOVEL     'FFBSETPD'    FileName                 CAP003CAP004
     C**********         EXSR      GETRCDLN                               CAP003CAP004
     C**********         ADD       RecordLen     OTCCLn                   CAP003CAP004
      **********                                                          CAP003CAP004
     C**********         MOVEL     'FFCSETPD'    FileName                 CAP003CAP004
     C**********         EXSR      GETRCDLN                               CAP003CAP004
     C**********         ADD       RecordLen     OTCCLn                   CAP003CAP004
                                                                                       CAP166 CAP083
      ** FF*non-currency*over-the-counter*options:*comprises*transaction               CAP166 CAP083
      ** details*and*customer*settlements*details*(the*latter*length*is                CAP166 CAP083
      ***determined*above).****                                                        CAP166 CAP083
                                                                                       CAP166 CAP083
     C***********        MOVEL     'FFOTCOPD'    FileName                              CAP166 CAP083
     C***********        EXSR      GETRCDLN                                            CAP166 CAP083
     C***********        Z-ADD     RecordLen     OTCOLn            4 0                 CAP166 CAP083
                                                                                CAP005        CAP083
      ***Forward*Rates                                                          CAP005        CAP083
                                                                                CAP005        CAP083
     C*******************MOVEL     'FDFWRTPD'    FileName                       CAP005        196570
     C*******************EXSR      GETRCDLN                                     CAP005        196570
     C*******************Z-ADD     RecordLen     FWRTLn            4 0          CAP005        196570
     C*******************MOVEL     'FDFWRT1PD'   FileName                              196570 CAP083
     C*******************EXSR      GETRCDLN                                            196570 CAP083
     C*******************Z-ADD     RecordLen     FWRT1Ln           4 0                 196570 CAP083
     C*******************MOVEL     'FDFWRT2PD'   FileName                              196570 CAP083
     C*******************EXSR      GETRCDLN                                            196570 CAP083
     C*******************Z-ADD     RecordLen     FWRT2Ln           4 0                 196570 CAP083
                                                                                CAP005
      ***Money*Market Rates                                                                   CAP083
      ***********                                                               CAP005        214637
     C***********        MOVEL     'FDINTR1PD'   FileName                       CAP005        214637
     C***********        EXSR      GETRCDLN                                     CAP005        214637
     C***********        Z-ADD     RecordLen     INTR1Ln           4 0          CAP005        214637
     C***********        MOVEL     'FDINTR2PD'   FileName                       CAP005        214637
     C***********        EXSR      GETRCDLN                                     CAP005        214637
     C***********        Z-ADD     RecordLen     INTR2Ln           4 0          CAP005        214637
     C***********        MOVEL     'FDINTRPD'    FileName                              214637 CAP083
     C***********        EXSR      GETRCDLN                                            214637 CAP083
     C***********        Z-ADD     500           INTR1Ln           4 0                 214637 CAP083
     C***********Len     SUB       500           INTR2Ln           4 0                 214637 CAP083
                                                                                              CAP083
      ***FT*Outgoing Payment : First, Second, Third and Fourth Details          CAP031        CAP083
      **                     : Fifth, Sixth, Seventh and Eighth                 CFT014        CAP083
                                                                                CAP031        CAP083
     C*******************MOVEL     'FTOPY1PD'    FileName                       CAP031        CAP083
     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
     C*******************Z-ADD     RecordLen     OPY1Ln            4 0          CAP031        CAP083
     C***********        MOVEL     'FTOPY2PD'    FileName                       CAP031 CFT014
     C*******************MOVEL     'FTOPY1APD'   FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
     C*******************Z-ADD     RecordLen     OPY2Ln            4 0          CAP031        CAP083
     C***********        MOVEL     'FTOPY3PD'    FileName                       CAP031 CFT014
     C*******************MOVEL     'FTOPY2PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
     C*******************Z-ADD     RecordLen     OPY3Ln            4 0          CAP031        CAP083
     C***********        MOVEL     'FTOPY4PD'    FileName                       CAP031 CFT014
     C*******************MOVEL     'FTOPY3PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
     C*******************Z-ADD     RecordLen     OPY4Ln            4 0          CAP031        CAP083
     C*******************MOVEL     'FTOPY4PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     OPY5Ln            4 0          CFT014        CAP083
     C*******************MOVEL     'FTOPY5PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     OPY6Ln            4 0          CFT014        CAP083
     C*******************MOVEL     'FTOPY6PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     OPY7Ln            4 0          CFT014        CAP083
     C*******************MOVEL     'FTOPY7PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     OPY8Ln            4 0          CFT014        CAP083
                                                                                CAP031        CAP083
      ***SD*Customers: Primary, Secondary, Message Routing,                     CAP034        CAP083
      **               Base Rate Tax details and Private Banking                CAP034        CAP083
                                                                                CAP034        CAP083
     C*******************MOVEL     'SDCUPRPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     CUPRLn            4 0          CAP034        CAP083
     C*******************MOVEL     'SDCUSEPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     CUSELn            4 0          CAP034        CAP083
     C*******************MOVEL     'SDCUMTPD'    FileName                              CSW024 CAP083
     C*******************EXSR      GETRCDLN                                            CSW024 CAP083
     C*******************Z-ADD     RecordLen     CUMTLn            4 0                 CSW024 CAP083
     C*******************MOVEL     'SDCUMRPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     CUMRLn            4 0          CAP034        CAP083
     C*******************MOVEL     'SDCUBRPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     CUBRLn            4 0          CAP034        CAP083
     C*******************Z-ADD     500           CUBR1Ln           4 0          CAP034        CAP083
     C*****Recordlen     SUB       CUBR1Ln       CUBR2Ln           4 0          CAP034        CAP083
     C*******************MOVEL     'SDCUPBPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     CUPBLn            4 0          CAP034        CAP083
                                                                                CAP034        CAP083
      ***GL*Accounts maintenance : Master, Debit interests, Credit interests    CAP035        CAP083
      **               Commissions & Overdraft charges and Other details        CAP035        CAP083
                                                                                CAP035        CAP083
     C*******************MOVEL     'GLAMADPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     AMMDLn            4 0          CAP035        CAP083
     C*******************MOVEL     'GLAMDIPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     AMDILn            4 0          CAP035        CAP083
     C*******************MOVEL     'GLAMCIPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     AMCILn            4 0          CAP035        CAP083
     C*******************MOVEL     'GLAMCOPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     AMCOLn            4 0          CAP035        CAP083
     C*******************MOVEL     'GLAMODPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     AMODLn            4 0          CAP035        CAP083
                                                                                CAP035        CAP083
      ***SD*Security Customer Details:                                          CAP039        CAP083
                                                                                CAP039        CAP083
     C*******************MOVEL     'SDSECDPD'    FileName                       CAP039        CAP083
     C*******************EXSR      GETRCDLN                                     CAP039        CAP083
     C*******************Z-ADD     RecordLen     SECDLn            4 0          CAP039        CAP083
                                                                                CAP039        CAP083
     ****SD*Other Depot Details layout file for APIs                                   CSE022 CAP083
     ****(Set*this to the length of the expected message length)                       CSE022 CAP083
     C*******************Z-ADD     4755          SDSOLn                                CSE022 CAP083
      *                                                                                CAP140 CAP083
      ***Get*record length of Data Layout files for SE Security                        CAP140 CAP083
      ***Diary*Events API.                                                             CAP140 CAP083
      *                                                                                CAP140 CAP083
     C*******************MOVEL     'SESEDEPD'    FileName                              CAP140 CAP083
     C*******************EXSR      GETRCDLN                                            CAP140 CAP083
     C*******************Z-ADD     RecordLen     SEDELn                                CAP140 CAP083
      *                                                                                CAP140 CAP083
      ***Get*record length of Extra Data Layout file for SE                            CAP140 CAP083
      ***Security*Diary Events - API                                                   CAP140 CAP083
      *                                                                                CAP140 CAP083
     C*******************MOVEL     'SESDEXPD  '  Filename                              CAP140 CAP083
     C*******************EXSR      GETRCDLN                                            CAP140 CAP083
     C*******************Z-ADD     Recordlen     SDEXLn                                CAP140 CAP083
                                                                                       CAP140 CAP083
      ***Get*record*length*of*Data*Layout*files*for*SD*Additional******                CGL032 243084
      ***Customer*Details.*Default*Extra*Data*length*to*500.***********                CGL032 243084
      **********                                                                       CGL032 243084
     C**********         MOVEL     'SDACUDPD'    FileName                              CGL032 243084
     C**********         EXSR      GETRCDLN                                            CGL032 243084
     C**********         Z-ADD     RecordLen     ACUDLn                                CGL032 243084
     C**********         Z-ADD     500           ACEXLn                                CGL032 243084
      **********                                                                       CGL032 243084
      ***Get*record*length*of*Data*Layout*files*for*SD*Non-A/C*********                CGL032 243084
      ***Holders*API.*Default*Extra*Data*length*to*500.****************                CGL032 243084
      **********                                                                       CGL032 243084
     C**********         MOVEL     'SDNAHLPD'    FileName                              CGL032 243084
     C**********         EXSR      GETRCDLN                                            CGL032 243084
     C**********         Z-ADD     RecordLen     SDNALn                                CGL032 243084
     C**********         Z-ADD     500           NaEXLn                                CGL032 243084
      **********                                                                       CGL032 243084
      ***Get*record*length*of*Data*Layout*files*for*SD*Customer********                CGL032 243084
      ***Details*by*Country*of*Tax*API.********************************                CGL032 243084
      **********                                                                       CGL032 243084
     C**********         MOVEL     'SDCCTXPD'    FileName                              CGL032 243084
     C**********         EXSR      GETRCDLN                                            CGL032 243084
     C**********         Z-ADD     RecordLen     CCTXLn                                CGL032 243084
      **********                                                                       CGL032 243084
      ***Get*record*length*of*Data*Layout*files*for*SD*Customer********                CGL032 243084
      ***Details*by*Country*of*Tax*API.********************************                CGL032 243084
      **********                                                                       CGL032 243084
     C**********         MOVEL     'SDNATXPD'    FileName                              CGL032 243084
     C**********         EXSR      GETRCDLN                                            CGL032 243084
     C**********         Z-ADD     RecordLen     NATXLn                                CGL032 243084
      **********                                                                       CGL032 243084
      ***Get*record*length*of*Data*Layout*files*for*SD*Joint*A/c*******                CGL032 243084
      ***Member*Details*API.*******************************************                CGL032 243084
      **********                                                                       CGL032 243084
     C**********         MOVEL     'SDJACMPD'    FileName                              CGL032 243084
     C**********         EXSR      GETRCDLN                                            CGL032 243084
     C**********         Z-ADD     RecordLen     JACMLn                                CGL032 243084
      **********                                                                       CGL032 243084
      ***SD*Market Data Feeds Spot Rate Details                                        CAP057 CAP083
                                                                                       CAP057 CAP083
     C*******************MOVEL     'SDSPTRPD'    FileName                              CAP057 CAP083
     C*******************EXSR      GETRCDLN                                            CAP057 CAP083
     C*******************Z-ADD     RecordLen     SPTRLn            4 0                 CAP057 CAP083
                                                                                       CAP057 CAP083
                                                                                       CAP038 CAP083
      ***SD*Base Rate Details                                                          CAP038 CAP083
                                                                                       CAP038 CAP083
     C*******************MOVEL     'SDBSRSPD'    FileName                              CAP038 CAP083
     C*******************EXSR      GETRCDLN                                            CAP038 CAP083
     C*******************Z-ADD     RecordLen     SDBSLn            4 0                 CAP038 CAP083
                                                                                       CAP038 CAP083
      ***Get*record length of Data Layout files for AB Internal                        CAP042 CAP083
      ***Funding*Deals API                                                             CAP042 CAP083
                                                                                       CAP042 CAP083
     C*******************MOVEL     'ABFUNDPD'    FileName                              CAP042 CAP083
     C*******************EXSR      GETRCDLN                                            CAP042 CAP083
     C*******************Z-ADD     RecordLen     FUNDLn                                CAP042 CAP083
      *                                                                                CAP042 CAP083
      ***Get*record length of Extra Data Layout file for AB                            CAP042 CAP083
      ***Internal*Funding Deals - API                                                  CAP042 CAP083
      *                                                                                CAP042 CAP083
     C*******************MOVEL     'ABFUEXPD'    Filename                              CAP042 CAP083
     C*******************EXSR      GETRCDLN                                            CAP042 CAP083
     C*******************Z-ADD     Recordlen     FUEXLn                                CAP042 CAP083
                                                                                       CAP042 CAP083
      ***FX*Extra Data file (50 byte narrative text plus any custom info)       CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'FXFXEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     FXFXLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***MM*Loan/deposits Extra Data file (50 byte narrative text plus any      CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'MMLDEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     MMLDLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***MM*Deal amendments Extra Data file (50 byte narrative text plus any    CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'MMDAEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     MMDALn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***MM*NAs Purchased Extra Data file (50 byte narrative text plus any      CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'MMNPEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     MMNPLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***MM*NAs Sold Extra Data file (50 byte narrative text plus any           CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'MMNSEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     MMNSLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***IR*FRAs Extra Data file (50 byte narrative text plus any               CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'IRFREXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     IRFRLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***IR*IRS Cross Ccy Extra Data file (50 byte narrative text plus any      CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'IRCSEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     IRCSLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***IR*IRS Single Ccy Extra Data file (50 byte narrative text plus any     CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'IRSSEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     IRSSLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***SE*Trades Extra Data file (50 byte narrative text plus any             CAP004        CAP083
      ***custom*info)                                                           CAP004        CAP083
                                                                                CAP004        CAP083
     C**********         MOVEL     'SETREXPD'    FileName                 CAP004175717
     C*******************MOVEL     'SETDEXPD'    FileName                       175717        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     SETRLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***SE*Walk In Depot Movts Extra Data file (50 byte narrative text         CAP004        CAP083
      ***plus*any custom info)                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C**********         MOVEL     'SEWIEXPD'    FileName                 CAP004175715
     C*******************MOVEL     'SEDMEXPD'    FileName                       175715        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     SEWILn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***SE*Walk Out Depot Movts Extra Data file (50 byte narrative text        CAP004        CAP083
      ***plus*any custom info)                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C**********         MOVEL     'SEWOEXPD'    FileName                 CAP004175715
     C*******************MOVEL     'SEDMEXPD'    FileName                       175715        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     SEWOLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***AB*Internal Contracts Extra Data file (50 byte narrative text          CAP004        CAP083
      ***plus*any custom info)                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'ABICEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     ABICLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***FF*Exchange Traded Options Extra Data file (50 byte narrative text     CAP004        CAP083
      ***plus*any custom info)                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'FFETEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     FFETLn            4 0          CAP004        CAP083
                                                                                CAP004        CAP083
      ***FF*Over the Counter Options Extra Data file (50 byte narrative text    CAP004        CAP083
      ***plus*any custom info)                                                  CAP004        CAP083
                                                                                CAP004        CAP083
     C*******************MOVEL     'FFOTEXPD'    FileName                       CAP004        CAP083
     C*******************EXSR      GETRCDLN                                     CAP004        CAP083
     C*******************Z-ADD     RecordLen     FFOTLn            4 0          CAP004        CAP083
                                                                                CAP005        CAP083
      ***FD*Forward Rates Extra Data file (50 byte narrative text               CAP005        CAP083
      ***plus*any custom info)                                                  CAP005        CAP083
                                                                                CAP005        CAP083
     C*******************MOVEL     'FDFREXPD'    FileName                       CAP005        CAP083
     C*******************EXSR      GETRCDLN                                     CAP005        CAP083
     C*******************Z-ADD     RecordLen     FDFRLn            4 0          CAP005        CAP083
                                                                                CAP005        CAP083
      ***FD*MM Interest Rates Extra Data file (50 byte narrative text           CAP005        CAP083
      ***plus*any custom info)                                                  CAP005        CAP083
                                                                                CAP005        CAP083
     C*******************MOVEL     'FDIREXPD'    FileName                       CAP005        CAP083
     C*******************EXSR      GETRCDLN                                     CAP005        CAP083
     C*******************Z-ADD     RecordLen     FDIRLn            4 0          CAP005        CAP083
                                                                                153108        CAP083
      ***SE*Price Input                                                         CAP030        CAP083
                                                                                CAP030        CAP083
     C*******************MOVEL     'SEPRCSPD'    FileName                       CAP030        CAP083
     C*******************EXSR      GETRCDLN                                     CAP030        CAP083
     C*******************Z-ADD     RecordLen     PRCSLn            4 0          CAP030        CAP083
                                                                                CAP030        CAP083
      ***SE*Price Input  Extra Data file (50 byte narrative text                CAP030        CAP083
      ***plus*any custom info)                                                  CAP030        CAP083
                                                                                CDL007        CAP083
      ***MM*Loan/deposits Interface Data  Format Definition Layout              CDL007        CAP083
      ***(50*byte narrative text plus any custom info)                          CDL007        CAP083
                                                                                CDL007        CAP083
     C*******************MOVEL     'MMLDIFPD'    FileName                       CDL007        CAP083
     C*******************EXSR      GETRCDLN                                     CDL007        CAP083
     C*******************Z-ADD     RecordLen     MMLILn            4 0          CDL007        CAP083
                                                                                CAP051        CAP083
      ***FX*Foreign Exchange Interface Data  Format Definition Layout           CAP051        CAP083
      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
                                                                                CAP051        CAP083
     C*******************MOVEL     'FXFXIFPD'    FileName                       CAP051        CAP083
     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
     C*******************Z-ADD     RecordLen     FXFILn            4 0          CAP051        CAP083
                                                                                CAP051        CAP083
      ***MM*Money Market Dealing Interface Data  Format Definition Layout       CAP051        CAP083
      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
                                                                                CAP051        CAP083
     C*******************MOVEL     'MMDAIFPD'    FileName                       CAP051        CAP083
     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
     C*******************Z-ADD     RecordLen     MMDILn            4 0          CAP051        CAP083
                                                                                CAP051        CAP083
      ***SE*Trades Interface Data  Format Definition Layout                     CAP051        CAP083
      ***(50*byte narrative text plus any custom info)                          CAP051        CAP083
                                                                                CAP051        CAP083
     C*******************MOVEL     'SETRIFPD'    FileName                       CAP051        CAP083
     C*******************EXSR      GETRCDLN                                     CAP051        CAP083
     C*******************Z-ADD     RecordLen     SETILn            4 0          CAP051        CAP083
                                                                                       CAP056 CAP083
      ***IR*Single*Currency*Interface*Data*Format*Definition*Layout                    CAP056 CAP083
                                                                                       CAP056 CAP083
     C*******************MOVEL     'IRRSIFPD'    FileName                              CAP056 CAP083
     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
     C*******************Z-ADD     RecordLen     IRRSLn                                CAP056 CAP083
                                                                                       CAP056 CAP083
      ***IR*Cross*Currency*Interface*Data*Format*Definition*Layout                     CAP056 CAP083
                                                                                       CAP056 CAP083
     C*******************MOVEL     'IRRXIFPD'    FileName                              CAP056 CAP083
     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
     C*******************Z-ADD     RecordLen     IRRXLn                                CAP056 CAP083
                                                                                       CAP056 CAP083
      ***IR*Forward*Rate*Agreement*Interface*Data*Format*Definition*Layout             CAP056 CAP083
                                                                                       CAP056 CAP083
     C*******************MOVEL     'IRFRIFPD'    FileName                              CAP056 CAP083
     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
     C*******************Z-ADD     RecordLen     IRFALn                                CAP056 CAP083
                                                                                       CAP056 CAP083
      ***IR*Caps/Collars/Floors*Interface*Data*Format*Definition*Layout                CAP056 CAP083
                                                                                       CAP056 CAP083
     C*******************MOVEL     'IRRPIFPD'    FileName                              CAP056 CAP083
     C*******************EXSR      GETRCDLN                                            CAP056 CAP083
     C*******************Z-ADD     RecordLen     IRRPLn                                CAP056 CAP083
      *                                                                                CAP033 CAP083
      ***Get*record length of Data Layout file for Portfolio Definition                CAP033 CAP083
      ***Details*API.                                                                  CAP033 CAP083
     C*******************MOVEL     'PMPFDMPD'    Filename                              CAP033 CAP083
     C*******************EXSR      GETRCDLN                                            CAP033 CAP083
     C*******************Z-ADD     Recordlen     PFDMLn            4 0                 CAP033 CAP083
      *                                                                                CAP033 CAP083
      ***Get*record length of Extra Data Layout file for Portfolio                     CAP033 CAP083
      ***Definition*Details API.                                                       CAP033 CAP083
     C*******************MOVEL     'PMPFEXPD'    Filename                              CAP033 CAP083
     C*******************EXSR      GETRCDLN                                            CAP033 CAP083
     C*******************Z-ADD     Recordlen     PFEXLn            4 0                 CAP033 CAP083
      *                                                                                CAP032 CAP083
      ***Get*record length of Data Layout file for Journal                             CAP032 CAP083
      ***Entry*Header API.                                                             CAP032 CAP083
     C*******************MOVEL     'GLBITHPD'    Filename                              CAP032 CAP083
     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
     C*******************Z-ADD     Recordlen     BITHLn            4 0                 CAP032 CAP083
      *                                                                                CAP032 CAP083
      ***Get*record length of Data Layout file for Journal                             CAP032 CAP083
      ***Entry*Item API.                                                               CAP032 CAP083
     C*******************MOVEL     'GLBITPPD'    Filename                              CAP032 CAP083
     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
     C*******************Z-ADD     Recordlen     BITPLn            4 0                 CAP032 CAP083
      *                                                                                CAP032 CAP083
      ***Get*record length of Extra Data Layout file for Journal                       CAP032 CAP083
      ***Entry*Header API.                                                             CAP032 CAP083
     C*******************MOVEL     'GLBHEXPD'    Filename                              CAP032 CAP083
     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
     C*******************Z-ADD     Recordlen     BHEXLn            4 0                 CAP032 CAP083
     C/COPY WNCPYSRC,APINCOMMC4
      *                                                                                CAP032 CAP083
      ***Get*record length of Extra Data Layout file for Journal                       CAP032 CAP083
      ***Entry*Item API.                                                               CAP032 CAP083
     C*******************MOVEL     'GLBPEXPD'    Filename                              CAP032 CAP083
     C*******************EXSR      GETRCDLN                                            CAP032 CAP083
     C*******************Z-ADD     Recordlen     BPEXLn            4 0                 CAP032 CAP083
      *                                                                                CAP032 CAP083
                                                                                153108        CAP083
      ***FT*Outgoing Payment Extra Data file (50 byte narrative text            CAP031        CAP083
      ***plus*any custom info)                                                  CAP031        CAP083
                                                                                CAP031        CAP083
     C*******************MOVEL     'FTOPEXPD'    FileName                       CAP031        CAP083
     C*******************EXSR      GETRCDLN                                     CAP031        CAP083
     C*******************Z-ADD     RecordLen     OPEXLn            4 0          CAP031        CAP083
                                                                                CAP031        CAP083
      ***SD*Customers Extra Data file (50 byte narrative text plus any          CAP034        CAP083
      ***custom*info)                                                           CAP034        CAP083
                                                                                CAP034        CAP083
     C*******************MOVEL     'SDCUEXPD'    FileName                       CAP034        CAP083
     C*******************EXSR      GETRCDLN                                     CAP034        CAP083
     C*******************Z-ADD     RecordLen     SDCULn            4 0          CAP034        CAP083
     C/COPY WNCPYSRC,APINCOMMC6
                                                                                CAP034        CAP083
      ***GL*Accounts Extra Data file (50 byte narrative text plus any           CAP035        CAP083
      ***custom*info)                                                           CAP035        CAP083
                                                                                CAP035        CAP083
     C*******************MOVEL     'GLAMEXPD'    FileName                       CAP035        CAP083
     C*******************EXSR      GETRCDLN                                     CAP035        CAP083
     C*******************Z-ADD     RecordLen     GLAMLn            4 0          CAP035        CAP083
                                                                                CAP035        CAP083
                                                                                CAP030        CAP083
     C*******************MOVEL     'SEPREXPD'    FileName                       CAP030        CAP083
     C*******************EXSR      GETRCDLN                                     CAP030        CAP083
     C*******************Z-ADD     RecordLen     PRCXLn            4 0          CAP030        CAP083
      *                                                                         CAP136        CAP083
      ***Get*record length of Data Layout files for FT Incoming                 CAP136        CAP083
      ***Payments*API*-*first,*second,*third*and*fourth*details.*******  CAP136 CFT014
      ***Payments*API - first, second, third, fourth, fifth, sixth,             CFT014        CAP083
      ***seventh*and eighth details.                                            CFT014        CAP083
      *                                                                         CAP136        CAP083
     C*******************MOVEL     'FTIPY1PD  '  Filename                       CAP136        CAP083
     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
     C*******************Z-ADD     Recordlen     IPY1Ln            4 0          CAP136        CAP083
      *                                                                         CAP136        CAP083
     C***********        MOVEL     'FTIPY2PD  '  Filename                CAP136 CFT014
     C*******************MOVEL     'FTIPY1APD'   FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
     C*******************Z-ADD     Recordlen     IPY2Ln            4 0          CAP136        CAP083
      *                                                                         CAP136        CAP083
     C***********        MOVEL     'FTIPY3PD  '  Filename                CAP136 CFT014
     C*******************MOVEL     'FTIPY2PD  '  Filename                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
     C*******************Z-ADD     Recordlen     IPY3Ln            4 0          CAP136        CAP083
      *                                                                         CAP136        CAP083
     C***********        MOVEL     'FTIPY4PD  '  Filename                CAP136 CFT014
     C*******************MOVEL     'FTIPY3PD  '  Filename                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
     C*******************Z-ADD     Recordlen     IPY4Ln            4 0          CAP136        CAP083
      *                                                                         CFT014        CAP083
     C*******************MOVEL     'FTIPY4PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     IPY5Ln            4 0          CFT014        CAP083
      *                                                                         CFT014        CAP083
     C*******************MOVEL     'FTIPY4APD'   FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     IPY6Ln            4 0          CFT014        CAP083
      *                                                                         CFT014        CAP083
     C*******************MOVEL     'FTIPY5PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     IPY7Ln            4 0          CFT014        CAP083
      *                                                                         CFT014        CAP083
     C*******************MOVEL     'FTIPY6PD'    FileName                       CFT014        CAP083
     C*******************EXSR      GETRCDLN                                     CFT014        CAP083
     C*******************Z-ADD     RecordLen     IPY8Ln            4 0          CFT014        CAP083
      *                                                                         CAP136        CAP083
      ***Get*record length of Extra Data Layout file for FT Incoming            CAP136        CAP083
      ***Payments*API.                                                          CAP136        CAP083
      *                                                                         CAP136        CAP083
     C*******************MOVEL     'FTIPEXPD  '  Filename                       CAP136        CAP083
     C*******************EXSR      GETRCDLN                                     CAP136        CAP083
     C*******************Z-ADD     Recordlen     IPEXLn            4 0          CAP136        CAP083
      *                                                                         CAP137        CAP083
      ***Get*record length of Data Layout files for SE Securities               CAP137        CAP083
      ***API*- first, second, and third  details.                               CAP137        CAP083
      *                                                                         CAP137        CAP083
     C*******************MOVEL     'SESEC1PD  '  Filename                       CAP137        CAP083
     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
     C*******************Z-ADD     Recordlen     SEC1Ln            4 0          CAP137        CAP083
      *                                                                         CAP137        CAP083
     C*******************MOVEL     'SESEC2PD  '  Filename                       CAP137        CAP083
     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
     C*******************Z-ADD     Recordlen     SEC2Ln            4 0          CAP137        CAP083
      *                                                                         CAP137        CAP083
     C*******************MOVEL     'SESEC3PD  '  Filename                       CAP137        CAP083
     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
     C*******************Z-ADD     Recordlen     SEC3Ln            4 0          CAP137        CAP083
     C**********         MOVEL     'SESEC4PD  '  Filename                       CSE031        CAP083
     C**********         EXSR      GETRCDLN                                     CSE031        CAP083
     C**********         Z-ADD     Recordlen     SEC4Ln            4 0          CSE031        CAP083
      **********                                                                       CAS006 CAP083
     C**********         MOVEL     'SESEC5PD  '  Filename                              CAS006 CAP083
     C**********         EXSR      GETRCDLN                                            CAS006 CAP083
     C**********         Z-ADD     Recordlen     SEC5Ln            4 0                 CAS006 CAP083
      *                                                                         CAP137        CAP083
      ***Get*record length of Extra Data Layout file for SE                     CAP137        CAP083
      ***Securities*- API.                                                      CAP137        CAP083
      *                                                                         CAP137        CAP083
     C*******************MOVEL     'SESEEXPD  '  Filename                       CAP137        CAP083
     C*******************EXSR      GETRCDLN                                     CAP137        CAP083
     C*******************Z-ADD     Recordlen     SEEXLn            4 0          CAP137        CAP083
                                                                                CAP030        CAP083
      ***SD*Security Customers Details Extra Data file                          CAP039        CAP083
      ***(50*byte narrative text plus any custom info)                          CAP039        CAP083
                                                                                CAP039        CAP083
     C*******************MOVEL     'SDSEEXPD'    FileName                       CAP039        CAP083
     C*******************EXSR      GETRCDLN                                     CAP039        CAP083
     C*******************Z-ADD     RecordLen     SDSELn            4 0          CAP039        CAP083
                                                                                CAP039        CAP083
      ***SD*Market Data Feed Spot Rate Details                                         CAP057 CAP083
      ***(50*byte narrative text plus any custom info)                                 CAP057 CAP083
                                                                                       CAP057 CAP083
     C*******************MOVEL     'SDSPTXPD'    FileName                              CAP057 CAP083
     C*******************EXSR      GETRCDLN                                            CAP057 CAP083
     C*******************Z-ADD     RecordLen     SDSPLn            4 0                 CAP057 CAP083
                                                                                       CAP057 CAP083
      ***SD*Base Rates Extra Data file                                                 CAP038 CAP083
                                                                                       CAP038 CAP083
     C*******************MOVEL     'SDBSEXPD'    FileName                              CAP038 CAP083
     C*******************EXSR      GETRCDLN                                            CAP038 CAP083
     C*******************Z-ADD     RecordLen     SDBXLn            4 0                 CAP038 CAP083
                                                                                       CAP038 CAP083
      ***Get*record*length*of*Data*Layout*files*for*MM*REPOs                           CAP067 CAP083
      ***Depot*Movements*-*API                                                         CAP067 CAP083
                                                                                       CAP067 CAP083
     C*******************MOVEL     'MMRPDDPD'    Filename                              CAP067 CAP083
     C*******************EXSR      GETRCDLN                                            CAP067 CAP083
     C*******************Z-ADD     Recordlen     REP1Ln                                CAP067 CAP083
                                                                                       CAP067 CAP083
      ***Get*record*length*of*Data*Layout*files*for*MM*REPOs                           CAP067 CAP083
      ***Trailer*-*API                                                                 CAP067 CAP083
                                                                                       CAP067 CAP083
     C*******************MOVEL     'MMRPTRPD'    Filename                              CAP067 CAP083
     C*******************EXSR      GETRCDLN                                            CAP067 CAP083
     C*******************Z-ADD     Recordlen     REP2Ln                                CAP067 CAP083
                                                                                       CAP067 CAP083
      ***Check*if*CAS001*is*installed                                                  CAS001 CAP083
                                                                                       CAS001 CAP083
     C*****************  CALLB     'AOSARDR0'                                          CAS001 CAP083
     C****************** PARM      *BLANKS       PRtCd                                 CAS001 CAP083
     C****************** PARM      '*VERIFY'     POptn                                 CAS001 CAP083
     C****************** PARM      'CAS001'      PSarD                                 CAS001 CAP083
     C*****SCSARD        PARM      SCSARD        DSFDY                                 CAS001 CAP083
                                                                                       CAS001 CAP083
     C*****PRtCd         IFEQ      *BLANK                                              CAS001 CAP083
     C****************** MOVEL     'Y'           CAS001                                CAS001 CAP083
     C****************** ELSE                                                          CAS001 CAP083
     C****************** MOVEL     'N'           CAS001                                CAS001 CAP083
     C****************** ENDIF                                                         CAS001 CAP083
                                                                                       CAS001 CAP083
      ***SD*Yield*Rates*Details                                                        CAS001 CAP083
                                                                                       CAS001 CAP083
     C*******************IF        CAS001 = 'Y'                                        CAS001 CAP083
                                                                                       CAS001 CAP083
     C*******************MOVEL     'SDYRAT1PD'   FileName                              CAS001 CAP083
     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
     C*******************Z-ADD     RecordLen     YRAT1Ln                               CAS001 CAP083
     C*******************MOVEL     'SDYRAT2PD'   FileName                              CAS001 CAP083
     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
     C*******************Z-ADD     RecordLen     YRAT2Ln                               CAS001 CAP083
     C*******************MOVEL     'SDYRAT3PD'   FileName                              CAS001 CAP083
     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
     C*******************Z-ADD     RecordLen     YRAT3Ln                               CAS001 CAP083
     C*******************MOVEL     'SDYRAT4PD'   FileName                              CAS001 CAP083
     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
     C*******************Z-ADD     RecordLen     YRAT4Ln                               CAS001 CAP083
                                                                                       CAS001 CAP083
      ** SD Yield Rates Extra Data File                                                CAS001 CAP083
                                                                                       CAS001 CAP083
     C*******************MOVEL     'SDYREXPD'    FileName                              CAS001 CAP083
     C*******************EXSR      GETRCDLN                                            CAS001 CAP083
     C*******************Z-ADD     RecordLen     SDYRLn                                CAS001 CAP083
                                                                                       CAS001 CAP083
     C*******************ENDIF                                                         CAS001 CAP083
                                                                                       CAS001 CAP083
      ***Check*if*CAP043*(APIs*for*IRS*Schedules)*is*installed                         CAP043 CAP083
      ******************                                                               CAP043 CAP083
     C****************** CALLB     'AOSARDR0'                                          CAP043 CAP083
     C****************** PARM      *BLANKS       PRtCd                                 CAP043 CAP083
     C****************** PARM      '*VERIFY'     POptn                                 CAP043 CAP083
     C****************** PARM      'CAP043'      PSarD                                 CAP043 CAP083
     C*****SCSARD        PARM      SCSARD        DSFDY                                 CAP043 CAP083
      ******************                                                               CAP043 CAP083
     C*****PRtCd         IFEQ      *BLANK                                              CAP043 CAP083
     C****************** MOVEL     'Y'           CAP043                                CAP043 CAP083
     C****************** ELSE                                                          CAP043 CAP083
     C****************** MOVEL     'N'           CAP043                                CAP043 CAP083
     C****************** ENDIF                                                         CAP043 CAP083
                                                                                       CAP043 CAP083
     C*******************IF        CAP043 = 'Y'                                        CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Cash*Flow*Schedules                                                           CAP043 CAP083
                                                                                       CAP043 CAP083
     C*******************CLEAR                   FileName                              CAP043 CAP083
     C*******************MOVEL     'IRCFSC1PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC1OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC1TLn                             CAP043 CAP083
     C*******************MOVEL     'IRCFSC2PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC2OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC2TLn                             CAP043 CAP083
     C*******************MOVEL     'IRCFSC3PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC3OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC3TLn                             CAP043 CAP083
     C*******************MOVEL     'IRCFSC4PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC4OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WCFSC4TLn                             CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Principal*Change*Schedules                                                    CAP043 CAP083
                                                                                       CAP043 CAP083
     C*******************MOVEL     'IRPCSC1PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC1OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC1TLn                             CAP043 CAP083
     C*******************MOVEL     'IRPCSC2PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC2OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC2TLn                             CAP043 CAP083
     C*******************MOVEL     'IRPCSC3PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC3OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC3TLn                             CAP043 CAP083
     C*******************MOVEL     'IRPCSC4PD'   FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC4OLn                             CAP043 CAP083
     C*******************Z-ADD     RecordLen     WPCSC4TLn                             CAP043 CAP083
                                                                                       CAP043 CAP083
      ***Trailer*Record                                                                CAP043 CAP083
                                                                                       CAP043 CAP083
     C*******************CLEAR                   FileName                              CAP043 CAP083
     C*******************MOVEL     'IRTRSCPD'    FileName                              CAP043 CAP083
     C*******************EXSR      GETRCDLN                                            CAP043 CAP083
     C*******************Z-ADD     RecordLen     WTRSCLn                               CAP043 CAP083
     C*******************CLEAR                   FileName                              CAP043 CAP083
                                                                                       CAP043 CAP083
     C*******************ENDIF                                                         CAP043 CAP083
      ***LE*Assignments                                                                CAP070 CAP083
                                                                                       CAP070 CAP083
     C*******************MOVEL     'LEASGNPD'    FileName                              CAP070 CAP083
     C*******************EXSR      GETRCDLN                                            CAP070 CAP083
     C*******************Z-ADD     RecordLen     ASGNLn            4 0                 CAP070 CAP083
                                                                                       CAP070 CAP083
      ***LE*Risk*Participants                                                          CAP070 CAP083
                                                                                       CAP070 CAP083
     C*******************MOVEL     'LERPRTPD'    FileName                              CAP070 CAP083
     C*******************EXSR      GETRCDLN                                            CAP070 CAP083
     C*******************Z-ADD     RecordLen     RPRTLn            4 0                 CAP070 CAP083
                                                                                       CAP070 CAP083
      ***LE*Funding*Participants                                                       CAP068 CAP083
                                                                                       CAP068 CAP083
     C*******************MOVEL     'LEFPRTPD'    FileName                              CAP068 CAP083
     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
     C*******************Z-ADD     RecordLen     FPRTLn            4 0                 CAP068 CAP083
                                                                                       CAP068 CAP083
      ***LE*Facility*Amendments                                                        CAP071 CAP083
                                                                                       CAP071 CAP083
     C*******************MOVEL     'LEFAMDPD'    FileName                              CAP071 CAP083
     C*******************EXSR      GETRCDLN                                            CAP071 CAP083
     C*******************Z-ADD     RecordLen     FAMDLn            4 0                 CAP071 CAP083
                                                                                       CAP071 CAP083
      ***LE*Fee*Adjustment*input                                                       CAP072 CAP083
                                                                                       CAP072 CAP083
     C*******************MOVEL     'LEFEADPD'    FileName                              CAP072 CAP083
     C*******************EXSR      GETRCDLN                                            CAP072 CAP083
     C*******************Z-ADD     RecordLen     FEADLn            4 0                 CAP072 CAP083
                                                                                       CAP072 CAP083
      ***LE*Fee*Settlement*input                                                       CAP072 CAP083
                                                                                       CAP072 CAP083
     C*******************MOVEL     'LEFESTPD'    FileName                              CAP072 CAP083
     C*******************EXSR      GETRCDLN                                            CAP072 CAP083
     C*******************Z-ADD     RecordLen     FESTLn            4 0                 CAP072 CAP083
                                                                                       CAP070 CAP083
      ***LE*Settlement*Details**                                                       CAP068 CAP083
                                                                                       CAP068 CAP083
     C*******************MOVEL     'SETLIAB'     FileName                              CAP068 CAP083
     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
     C*******************Z-ADD     500           LIAB1Ln           4 0                 CAP068 CAP083
     C*****Recordlen*****SUB       LIAB1Ln       LIAB2Ln           4 0                 CAP068 CAP083
                                                                                       CAP068 CAP083
      ***LE*Settle/Detail*format*(inc*Cont/Parms)                                      CAP068 CAP083
                                                                                       CAP068 CAP083
     C*******************MOVEL     'SETLIAZ'     FileName                              CAP068 CAP083
     C*******************EXSR      GETRCDLN                                            CAP068 CAP083
     C*******************Z-ADD     RecordLen     LIAZLn            4 0                 CAP068 CAP083
                                                                                       CSC011 CAP083
      ***LE*Facility*Input*format                                                      CSC011 CAP083
                                                                                       CSC011 CAP083
     C*******************MOVEL     'LEF1MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           FCTY1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           FCTY2Ln           4 0                 CSC011 CAP083
     C*****Recordlen*****SUB       1000          FCTY3Ln           4 0                 CSC011 CAP083
                                                                                       CSC011 CAP083
      ***LE*Loan*Input*format                                                          CSC011 CAP083
      ***LE*Participations*Purchased*input*format                                      CSC011 CAP083
      ***LE*Participations*Sold*Input                                                  CSC011 CAP083
                                                                                       CSC011 CAP083
     C*******************MOVEL     'LEN1MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           LOAN1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           PTPU1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           PTSO1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           LOAN2Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           PTPU2Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           PTSO2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       1000          LOAN3Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       1000          PTPU3Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       1000          PTSO3Ln           4 0                 CSC011 CAP083
                                                                                       CSC011 CAP083
      ***LE*Loan*Amendment*Input                                                       CSC011 CAP083
      **Principal*Transfer*To                                                          CSC011 CAP083
      **Principal*Transfer*From                                                        CSC011 CAP083
      **Principal*Increase****                                                         CSC011 CAP083
      **Base Rate*Change*****                                                          CSC011 CAP083
      **Spread*Change********                                                          CSC011 CAP083
      **Stop/Start*Change*Accrual                                                      CSC011 CAP083
      **Loan*Subtype*Change******                                                      CSC011 CAP083
     C****************** MOVEL     'LEA1MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           LAPT1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           LAPF1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           LAPI1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           LABC1Ln           4 0                 CSC011 CAP083
     C*******************Z-ADD     500           LASC1Ln           4 0                 CSC011 CAP083
     C****************** Z-ADD     500           LASA1Ln           4 0                 CSC011 CAP083
     C****************** Z-ADD     500           LALS1Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LAPT1Ln       LAPT2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LAPF1Ln       LAPF2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LAPI1Ln       LAPI2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LABC1Ln       LABC2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LASC1Ln       LASC2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LASA1Ln       LASA2Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LALS1Ln       LALS2Ln           4 0                 CSC011 CAP083
                                                                                       CSC011 CAP083
      ***LE*Rollover*Input*format*****                                                 CSC011 CAP083
                                                                                       CSC011 CAP083
     C*******************MOVEL     'LEO1MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           ROLL1Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       ROLL1Ln       ROLL2Ln           4 0                 CSC011 CAP083
                                                                                       CSC011 CAP083
      ***LE*Manual*Repayment*format***                                                 CSC011 CAP083
                                                                                       CSC011 CAP083
     C*******************MOVEL     'LEM1MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           LAMR1Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       LAMR1Ln       LAMR2Ln           4 0                 CSC011 CAP083
                                                                                       CSC011 CAP083
      ***LE*Fees*Input*Maintenance*format***                                           CSC011 CAP083
                                                                                       CSC011 CAP083
     C*******************MOVEL     'LEF3MFPD'    FileName                              CSC011 CAP083
     C*******************EXSR      GETRCDLN                                            CSC011 CAP083
     C*******************Z-ADD     500           FEES1Ln           4 0                 CSC011 CAP083
     C*****Recordlen     SUB       FEES1Ln       FEES2Ln           4 0                 CSC011 CAP083
                                                                                       CAP068 CAP083
      ***Caps/Collars/Floors*Format*Definition*File***                                 CAP055 CAP083
                                                                                       CAP055 CAP083
     C*******************EVAL      Filename = 'IRCACFPD'                               CAP055 CAP083
     C*******************EXSR      GETRCDLN                                            CAP055 CAP083
     C*******************Z-ADD     RecordLen     CACFLn                                CAP055 CAP083
                                                                                       CAP055 CAP083
      ***Caps/Collars/Floors*Extra*Data*File***                                        CAP055 CAP083
                                                                                       CAP055 CAP083
     C*******************EVAL      Filename = 'IRCPEXPD'                               CAP055 CAP083
     C*******************EXSR      GETRCDLN                                            CAP055 CAP083
     C*******************Z-ADD     RecordLen     CACXLn                                CAP055 CAP083
                                                                                       CAP038 CAP083
      ***SE*Movements Status: Primary and Extra Details                                CSE039 CAP083
      *                                                                                CSE039 CAP083
     C*******************MOVEL (P) 'SEMVTS1PD'   FileName                              CSE039 CAP083
     C*******************EXSR      GETRCDLN                                            CSE039 CAP083
     C*******************Z-ADD     RecordLen     MVTSLn            4 0                 CSE039 CAP083
      *                                                                                CSE039 CAP083
     C*******************MOVEL (P) 'SEMVEXPD'    FileName                              CSE039 CAP083
     C*******************EXSR      GETRCDLN                                            CSE039 CAP083
     C*******************Z-ADD     RecordLen     MVEXLn            4 0                 CSE039 CAP083
                                                                                       CAP182 CAP083
      ***Get*record length of Data Layout files for SE Trade                           CAP182 CAP083
      ***Settlements*API.                                                              CAP182 CAP083
     C*******************MOVEL     'SETRSMPD'    FileName                              CAP182 CAP083
     C*******************EXSR      GETRCDLN                                            CAP182 CAP083
     C*******************Z-ADD     RecordLen     TRSMLn                                CAP182 CAP083
                                                                                       CAP182 CAP083
      ***SE*Statement Production Requests: Primary and Extra Details                   CSE040 CAP083
      *                                                                                CSE040 CAP083
     C*******************MOVEL (P) 'SESTPR1PD'   FileName                              CSE040 CAP083
     C*******************EXSR      GETRCDLN                                            CSE040 CAP083
     C*******************Z-ADD     RecordLen     STPRLn            4 0                 CSE040 CAP083
      *                                                                                CSE040 CAP083
     C*******************MOVEL (P) 'SESPEXPD'    FileName                              CSE040 CAP083
     C*******************EXSR      GETRCDLN                                            CSE040 CAP083
     C*******************Z-ADD     RecordLen     SPEXLn            4 0                 CSE040 CAP083
                                                                                       CAP055 CAP083
     C/COPY WNCPYSRC,APINCOMMC2
      ***Ensure*that*all*the*API*data*queues*exist*                                    153108 CPK030
     C********           CLEAR                   ReturnCode                            153108 CPK030
     C********           CALL      'APCRTDTAQS'                                        153108 CPK030
     C********           PARM                    ReturnCode                            153108 CPK030
                                                                                CAP004
     C                   ENDSR
      ****************************************************************
      /EJECT
      ****************************************************************
      **------------------------------------------------------------------------
      ** The following /COPY contains the standard program status
      ** subroutine, including a bound call to the DBERRCTL module.
     C/COPY ZACPYSRC,PSSR_ILE
      **------------------------------------------------------------------------
      ****************************************************************
      /EJECT
      ****************************************************************
**  CPY@
(c) Finastra International Limited 2001
**  CHG@                                                                                      CDL010
CHGDTAARA DTAARA(QTEMP/ZMUSER (1 10)) VALUE('                                                 CDL010
**  CJOB@                                                                                   AR401481
CHGJOB SWS(XXXXXX00)                                                                        AR401481
