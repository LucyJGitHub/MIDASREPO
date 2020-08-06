     H DEBUG
     H COPYRIGHT('(c) Finastra International Limited 2002')
      *****************************************************************
/*XBIA*  OVRDBF FILE(OTPAYOVR) TOFILE(OTPAY) SHARE(*NO)               *
/*XBIB*  OVRDBF FILE(OTXL0) TOFILE(OTPAYXL0) SHARE(*NO)               *         CFT014
/*XBIC***OVRDBF*FILE(FTPREFX1)*TOFILE(FTPREFL0)*SHARE(*NO)*************             BUG4776 BUG4776R
/*STD *  RPGBASEMOD                                                   *
/*EXI *  TEXT('Midas FT Outgoing payments database update')           *
      *****************************************************************
      *                                                               *
      *  Midas - Funds Transfer Module                                *
      *                                                               *
      *  FTOPAYUPD - Outgoing Payments Database Update                *
      *                                                               *
      *  (c) Finastra International Limited 2001                      *
      *                                                               *
      *  Last Amend No. ERZ248             Date 18Nov19               *
      *  Prev Amend No. CSW220             Date 09Mar20               *
      *                 MD054037           Date 23Sep19               *
      *                 CSD102             Date 08Jan19               *
      *                 MD046248           Date 27Oct17               *
      *                 MD044588           Date 09Mar17               *
      *                 CFT049             Date 20Feb15               *
      *                 AR898165           Date 10Nov14               *
      *                 MD030940           Date 08Oct14               *
      *                 CFT157             Date 29Aug14               *
      *                 MD029681           Date 12Aug14               *
      *                 AR1091503          Date 30Sep13               *
      *                 MD019850           Date 06Apr13               *
      *                 AR1084524          Date 13Feb13               *
      *                 AR402776           Date 20Dec12               *
      *                 262786             Date 20Dec12               *
      *                 CFT120             Date 28Sep12               *
      *                 CAP211             Date 28Sep12               *
      *                 CLE134             Date 01Aug12               *
      *                 CSF011A            Date 28Nov11               *
      *                 AR787620           Date 10Jun11               *
      *                 CRE067             Date 05Oct10               *
      *                 CER059             Date 19Jul10               *
      *                 BUG23088A          Date 05Mar09               *
      *                 BUG23088           Date 26Feb09               *
      *                 CER030             Date 09Jul08               *
      *                 CSD083             Date 27May10               *
      * Bank Fusion Midas 1.4 Base -----------------------------------*
      *                 CAP205             Date 03Mar10               *
      *                 CAP204             Date 09Feb10               *
      *                 260233             Date 14May09               *
      *                 BUG24776           Date 09Jul09               *
      *                 CSW209             Date 01Apr09               *
      * Midas Plus 1.4 Base 04 ---------------------------------------*
      *                 257487             Date 04Nov08               *
      *                 256564             Date 17Sep08               *
      *                 255711             Date 31Jul08               *
      *                 BUG18500           Date 05May08               *
      *                 BUG15042A          Date 23Oct07               *
      *                 BUG15042           Date 17Oct07               *
      *                 250600             Date 07Oct07               *
      *                 247314             Date 25Apr07               *
      *                 BUG13029           Date 11Jan07               *
      * Midas Plus 1.3 ----------- Base ------------------------------*
      *                 241810A            Date 04Sep06               *
      *                 241810             Date 28Aug06               *
      *                 CFT032             Date 11Sep06               *
      *                 CSD027C            Date 06Jul06               *
      *                 CSD031             Date 10Apr06               *
      *                 221478             Date 06Jun06               *
      *                 240008             Date 23May06               *
      *                 227243             Date 26Apr06               *
      *                 223737             Date 05Feb04               *
      *                 CDL049             Date 06Jul06               *
      *                 CSD027             Date 09Dec05               *
      *                 BUG9071            Date 27Jul05               *
      *                 CSW037A            Date 02May05               *
      *                 CSD025             Date 11Jan05               *
      *                 BUG4449            Date 20Jan04               *
      *                 CSW037             Date 15Dec04               *
      *                 CSW036             Date 15Dec04               *
      *                 BUG4776R (Reopen)  Date 22Dec04               *
      *                 BUG4776            Date 15Nov04               *
      *                 CFT116             Date 12Jul04               *
      *                 BUG3854            Date 27Jul04               *
      *                 BUG3821            Date 27Jul04               *
      *                 BUG3191            Date 02Jul04               *
      *                 CLE025             Date 20Oct03               *
      *                 CRE020             Date 20Jan04               *
      *                 CGL029             Date 01Sep03               *
      *                 CGP001             Date 16Oct03               *
      *                 221778             Date 01Oct03               *
      *                 CAP084             Date 18Jul03               *
      *                 220004             Date 24Jul03               *
      *                 210873             Date 23Jun03               *
      *                 CSD015             Date 14Oct02               *
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213004             Date 15Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      * Midas Release 4.01.03 ----------------------------------------*
      *                 213004             Date 15Jan03               *
      * Midas Release 4.01.02 ----------------------------------------*
      *                 204029             Date 26Apr02               *
      * Midas Release 4.01 -------------------------------------------*
      *                 201577             Date 22Jan02               *
      *                 200217             Date 16Nov01               *
      *                 CSC011             Date 18Sep01               *
      *                 196378             Date 28Nov01               *
      *                 193883             Date 20Nov01               *
      *                 196813             Date 20Sep01               *
      *                 195566             Date 10Sep01               *
      * Midas Release 4 --------------- Base -------------------------*
      *                 202150             Date 21Jan02               *
      * Midas DBA 3.05 -----------------------------------------------*
      *                 CFT009             Date 01Nov00               *
      *                 189451             Date 09Feb01               *
      * Midas DBA 3.04 -----------------------------------------------*
      *                 185764             Date 01Nov00               *
      *                 CFT014             Date 25May00               *
      * Midas DBA 3.03 -----------------------------------------------*
      *                 175479             Date 23May00               *
      *                 CFT007             Date 16Mar00               *
      * Midas DBA 3.02 -----------------------------------------------*
      *                 CFT004             Date 01Dec99               *
      *                 CAP013             Date 22Nov99               *
      *                 CPB001             Date 23Aug99               *
      *                 CAP031  *CREATE    Date 19May99               *
      *                                                               *
      *---------------------------------------------------------------*
      *                                                               *
      *  ERZ248 - SWIFT UETR via OPAY API                             *
      *           Add new hook ERZ248_044                             *
      *           Amended hooks FTH00422, FTOPAYDC08, FTOPAYDC12,     *
      *           FTOPAYDC31                                          *
      *  CSW220 - SWIFT Changes 2020                                  *
      *  MD054037 - Outward payment routing from incoming (OPIN = Y)  *
      *             via API                                           *
      *  CSD102 - Password Length Extension (Recompile)               *
      *  MD046248 - Finastra Rebranding                               *
      *  MD044588 - Transactions sent via SOAP that falls under       *
      *             CFT049 contains 'N' in the Authorise field        *
      *             instead of 'No'.                                  *
      *  CFT049 - Account with Bank validation if EU/EEA Payment      *
      *  AR898165 - Message unique reference is zeroized on amend     *
      *             (Child: AR898166)                                 *
      *  MD030940 - (CFT157) Error when inserting new payment.        *
      *  CFT157 - Stop FT Transaction after Authorisation.            *
      *  MD029681 - Serious Midas Error occurreddue to *LDA lock      *
      *             being not granted                                 *
      *  AR1091503 - No online movements should be created for RP     *
      *              (Child: AR1091504)                               *
      *  MD019850 - Posting to the first account was not reversed     *
      *             during amend of 'Charges to the Debit of A/c'     *
      *  AR1084524 - Performance issue on IPAY & OPAY listview        *
      *              (Recompile)                                      *
      *  AR402776 - Payment reference is not updated when settlement  *
      *             type changes.  Fix is to remove the unnecessary   *
      *             OPIN condition.                                   *
      *             (Child: AR402906)                                 *
      *  262786 - Prevent Payment Reference field to be highlighted   *
      *           after successful insert of outgoing payments        *
      *           transaction.                                        *
      *  CFT120 - FT IN/OP - Charges to DR of Account Currency        *
      *  CAP211 - FT IN_OP APIs - Auto-Authorization of Payment       *
      *  CLE134 - Past Due Call Loan Processing                       *
      *  CSF011A - CCR015: Display Order in Confirmation Pages        *
      *            (Recompile)                                        *
      *  AR787620 - Hooks Incorporation                               *
      *             WNCPYSRC,FTH00105                                 *
      *             WNCPYSRC,FTH00103                                 *
      *             WNCPYSRC,FTH00111                                 *
      *             WNCPYSRC,FTH00109                                 *
      *  CRE067 - Midas Plus/Teller Interface via Bankfusion          *
      *  CER059 - German Feature Upgrade to Delhi                     *
      *  BUG23088A - Transactions using non-retail A/C format did     *
      *           not apprear in the postings (RE-OPEN)               *
      *  BUG23088- Transactions using non-retail A/C format did not   *
      *           appear in the postings                              *
      *  CER030 - Multicash German Feature (Recompile)                *
      *  CSD083 - Watch List Compliance Upgrade                       *
      *  CAP205 - Teller Related APIs - Account Balance Check         *
      *  CAP204 - Teller Related APIs - Account Transfer              *
      *  260233 - Apply GEMS 245712 parts missing from GEMS 256169    *
      *  245712 - When CFT009 is ON and extra charges (i.e. SWIFT     *
      *           Standard) are specified, wrong amount is added to   *
      *           Total Charge causing wrong Projected A/c Movement.  *
      *           Instead of MISCC1-MISCC5, SWSCCC, the values of     *
      *           MISC01-MISC05, SWSCHG should be added to ##CHGS.    *
      *  BUG24776 - Settlement type may not be amended                *
      *  CSW209 - SWIFT 2009 Changes                                  *
      *  257487 - Write to Incoming Payments extension file OTPAYDQD  *
      *  256564 - Recompile due to PF changes done by fix 256330      *
      *  255711 - Field Ref rate does not record rate. (Recompile)    *
      *  BUG18500 - Unable to authorize amended data                  *
      *  BUG15042A- Codes are partially incorrect.                    *
      *  BUG15042 - Settlement (ordering customer) shadow postings    *
      *             incorrectly written.                              *
      *  250600 - Recompiled for change in FTV@OPAYPD                 *
      *           to fix CFT032/CSW207 errors                         *
      *  247314 - DB 36 in FTOPAYUPD due to CFT014 switch being On    *
      *  BUG13029 - Outgoing payment error: Unable to find retail     *
      *             account                                           *
      *  241810A- Reverse fix 241810.                                 *
      *  241810 - Authorise indicator and authorising user are not    *
      *           updated when transaction has been authorised.       *
      *  CFT032 - Account line in field 50X in MT103                  *
      *  CSD027C - Further customer number changes                    *
      *  CSD031 - Enhanced Centralised Static Data (Recompile)        *
      *  221478 - Call of FTOPAYUPD to FT0035 ends in DBERR as field  *
      *           I#PTY2 contains zeroes.  Need to add extra          *
      *           condition to ensure OTSNCO or OTORBK is not zero    *
      *           before moving into I#PTY2.                          *
      *  240008 - Proj Ac update for partial a/c nos still wrong      *
      *  227243 - Charge amount fields not reset. Fix is to default   *
      *           only during insert. Applied fix 223133.             *
      *  223737 - Do not allow the database to be updated during      *
      *           amendment if the transaction is already authorised. *
      *  CDL049 - Addition of a Reference Rate field (recompile)      *
      *  CSD027 - Conversion Of Customer Number to Alpha              *
      *  BUG9071- Error on payment reference when this module was     *
      *           called via meridian and the action is 'I'.          *
      *  CSW037A- Additional Field extended to 40 chars (recompile)   *
      *  CSD025 - Customer De-Activation                              *
      *  BUG4449-  *INZSR is not being executed, thus  causing the    *
      *            CSD015 and CSC011 to be set to ' '.                *
      *  CSW037 - Additional Field Data on MT300/MT320                *
      *  CSW036 - Dual SWIFT BIC held on Client Details               *
      *  BUG4776R-Reverse fix since fix only applies to Incoming.     *
      *           (Reopen)                                            *
      *  BUG4776- Correct skipping of transaction reference.          *
      *  CFT116 - Core changes for GBO016.                            *
      *         - MT110 Generation in Funds Transfer                  *
      *           Core hooks amended:FTOPAYDC12,FTOPAYDD02,FTOPAYDF01,*
      *                              FTOPAYDC21,FTOPAYDC09            *
      *           Core hooks added:FTOPAYDC31                         *
      *  BUG3854 - Shadow postings to partial accounts incorrect      *
      *  BUG3821 - Shadow postings incorrect due to 10 digit a/c code *
      *  BUG3191 - Set-up parameter before calling AOSPOSU0. Pattern- *
      *            ed from BUG3194.                                   *
      *  CLE025 - Credit Lines (Recompile)                            *
      *  CRE020 - Midas Plus Online Printing of Advices (GE7)         *
      *  CGL029 - Increase Account Code to 10 digits (Recompile)      *
      *  CGP001 - Global Processing.                                  *
      *         - Recompile due to change in FTVOPY2PD.               *
      *  221778 - Ordering Customer erreneously expanded for Comp     *
      *           Watch.                                              *
      *  CAP084 - MidasPlus Changes.                                  *
      *  220004 - Change call to AOCURRR0 to use DSSDY not DSFDY.     *
      *  210873 - Ensure that correct customer will be saved for      *
      *           retrieving default charges.                         *
      *  CSD015 - Midas Compliance Watch - Watch List Checking        *
      *  213004 - Amendment of Outgoing Payment does not reverse      *
      *           properly the previous entry in RSACMTPD.            *
      *  204029 - Data decimal error on fields MISC01,2,3,4,5         *
      *           and SWSCHG when CFT009 is not on.                   *
      *  201577 - Call AOC8000 for deallocation of dataarea TREF.     *
      *  200217 - Error updating records coming from FTVOPAYPD when   *
      *           action code is not equal to 'I'.                    *
      *  CSC011 - 24x7 Midas Availability                             *
      *  196378 - Transaction's data area should only be allocated on *
      *           Amend and Delete.                                   *
      *  193883 - To avoid DBerr set-up Front ID correctly.           *
      *  196813 - Routed payment not removed from selection file.     *
      *  195566 - If CFT014 is not switched on and you then amend a   *
      *           payment the code is trying to update file OTPAYXPD. *
      *           Need to move ENDIF so that CFT014 code is           *
      *           conditioned on CFT014 being switched on.            *
      *  202150 - Initialise WRTVD to prevent decimal data error      *
      *           deletion and amend of transaction.  Also, extension *
      *           file OTPAYXPD should only be maintained if either   *
      *           CFT003, CFT009 or CFT014 is switched on.            *
      *  CFT009 - Funds Transfer Fees and Charges                     *
      *  189451 - Removal of hook FT0040MOV1 as is an OPM hook name   *
      *           from FT0040.                                        *
      *  185764 - No shadow posting for principal amounts and charges *
      *  CFT014 - Straight-through Processing Phase 2 MT103           *
      *           Messages Generation for FT.                         *
      *  175479 - Recompile over changes in outgoing payment file     *
      *  CFT007 - Recompile - BIC Database Plus Integration           *
      *  CFT004 - Recompile, IBAN - International Bank Account Number *
      *  CAP013 - Allow access by Midas transaction ID if not insert  *
      *  CPB001 - Meridian DBA Middleware Replication Customization.  *
      *           Recompiled due to database changes                  *
      *  CAP031 - Conversion of FT inputs into modular structure to   *
      *           use as APIs.                                        *
      *****************************************************************
 
      * Outgoing payments Detail file
     FOTPAYOVR  UF A E           K DISK
     F                                     COMMIT
 
      * Outgoing payment extension file
     F***OTPAYXL0  UF A E           K DISK    COMMIT                            CFT014
     FOTXL0     UF A E           K DISK    COMMIT                               CFT014
     F****OTPAYDQD  O    E             DISK    COMMIT                                257487 MD054037
     FOTPAYQL0  UF A E           K DISK    COMMIT                                           MD054037
 
      * Outgoing payments Trailer file
     FOTPAYZZ   UF   E             DISK    COMMIT
 
      ** Compliance Watch Hit List file                                                       CSD015
     FSDCWHTL1  IF   E           K DISK    COMMIT                                             CSD015
                                                                                              CSD015
     F*FTPREFX1**UF*A*E********     DISK    COMMIT                                  BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     F/COPY WNCPYSRC,FTOPAYDF01
 
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
      ** The following /COPY line includes the definitions for error and
      ** warning message arrays.
     D/COPY ZACPYSRC,ERR_ARRAYS
      **--------------------------------------------------------------------------------------------
 
 
      ** +--------------------------------------+
      ** ¦ End of automatically included D-specs¦
      ** ¦ =====================================¦
      ** +--------------------------------------+
 
 
      * Current Payment in File Format
     D ChkOPAYFmt    E DS                  EXTNAME(OTPAYDD)
      ** Rename fields for Timestamp checking
     D                                     PREFIX(CH)
                                                                                CFT014
      ** Current Payment Extension in file format                               CFT014
     D ChkOPAYFmX    E DS                  EXTNAME(OTPAYXPD)                    CFT014
     D                                     PREFIX(CH)                           CFT014
                                                                                CFT014
     D/COPY WNCPYSRC,FTH00105
      ** Midas Switchable features file accessed via access program                           CRE020
     D SCSARD        E DS                  EXTNAME(SCSARDPD)                                  CRE020
     D  SCLCD        E                     EXTFLD(LCD)                                        CRE020
                                                                                              CRE020
      ** The maximum size of the appended error arrays
     D XArrayMax       C                   CONST(20)
 
      ** +--------------------------------------+
      ** ¦ Arrays and Data Structures           ¦
      ** ¦ ==========================           ¦
      ** +--------------------------------------+
 
      * Array of Fields in error.
     D FldNamXAr       S             10A   DIM(XArrayMax)
 
      * Array of error message IDs
     D MsgIDXAr        S                   DIM(XArrayMax) LIKE(#MsgId)
 
      * Array of error message data.
     D MsgDtaXAr       S                   DIM(XArrayMax) LIKE(#MsgData)
 
      * Validation Work Fields
     D Val@Fields    E DS                  EXTNAME(FTV@OPAYPD)
 
      * Incoming Transaction
     D TranInPrim    E DS                  EXTNAME(FTOPY1PD)
 
      * Flags to indicate whether transaction fields are valid
     D FTEOPY1       E DS                  EXTNAME(FTEOPY1PD)
     D FTEOPY2       E DS                  EXTNAME(FTEOPY2PD)
     D FTEOPY3       E DS                  EXTNAME(FTEOPY3PD)
     D FTEOPY4       E DS                  EXTNAME(FTEOPY4PD)                   CFT014
     D FTEOPY5       E DS                  EXTNAME(FTEOPY5PD)                   CFT014
 
      * New Valid Payments layout
     D ValidPmnt     E DS                  EXTNAME(FTVOPAYPD)
     D/COPY WNCPYSRC,FTH00197
     D ValidPmntB    E DS                  EXTNAME(FTVOPY2PD)                   CFT014
 
      * Data structure for payment to be updated
     D NewPmnt       E DS                  EXTNAME(OTPAYDD)
     D NewPmntB      E DS                  EXTNAME(OTPAYXPD)                    CFT014
 
     D/COPY WNCPYSRC,FTOPAYDD03
      ** EXTERNAL DS FOR BANK DETAILS
     D SDBANK        E DS                  EXTNAME(SDBANKPD)
 
      ** EXTERNAL DS FOR MIDAS MODULES DETAILS
     D SDMMOD        E DS                  EXTNAME(SDMMODPD)
 
      * External DS for Funds Transfer details
     D SDFTFR        E DS                  EXTNAME(SDFTFRPD)
 
     D/COPY WNCPYSRC,FTOPAYDD01
      * External data structure for currency codes
     D SDCURR        E DS                  EXTNAME(SDCURRPD)
                                                                                              CSD015
      ** External DS for Customer Details                                                     CSD015
     D SDCUST        E DS                  EXTNAME(SDCUSTPD)                                  CSD015
                                                                                              CSD015
      ** Midas Functions for Watch List Checking Details File                                 CSD015
     D SDWLCC        E DS                  EXTNAME(SDWLCCPD)                                  CSD015
                                                                                              CSD015
      ** Data structure for 1st parameter of Watchlist Engine (SDCWLCHK)                      CSD015
     D SDWLTD        E DS                  EXTNAME(SDWLTDPD)                                  CSD015
                                                                                              CSD015
      ** External DS for Watch List Configuration Data File                                   CSD015
     D SDCWCD        E DS                  EXTNAME(SDCWCDPD)                                  CSD015
 
      ** FIRST DS FOR ACCESS PROGRAMS, SHORT DATA STRUCTURE
     D DSFDY         E DS                  EXTNAME(DSFDY)
 
      ** SECOND DS FOR ACCESS PROGRAMS, LONG DATA STRUCTURE
     D DSSDY         E DS                  EXTNAME(DSSDY)
 
      ** Dummy message ID and message file fields for use on the calls to
      ** ZAMSGTOOPR
     D DummyMsgID      S                   LIKE(#MsgID)
     D DummyMsgF       S             10A
 
      * Like Field Definitions
     D FOTRID          S                   LIKE(OTFRNT)
 
      *  Parameters to be passed for FT IMM update
     D INFT          E DS                  EXTNAME(MEINFTPD)
                                                                                              CSC011
      ** Message Header Data Layout                                                           CSC011
     D APHEAD        E DS                  EXTNAME(APHEADPD)                                  CSC011
                                                                                              CSC011
      ** 24X7 Status DataArea Layout                                                          CSC011
     D SC24X7        E DS                  EXTNAME(SC24X7) DTAARA(SC24X7)                     CSC011
                                                                                              CSC011
      ** SD Status DataArea Layout                                                            CSC011
     D SDSTAT        E DS                  EXTNAME(SDSTAT) DTAARA(SDSTAT)                     CSC011
 
     D/COPY QWINDSRC,FTOPAYDTAD
 
     D P@ACCT          DS                                                                   BUG15042
     D  P@CNUM                 2      7                                                     BUG15042
     D  P@CCY                  8     10                                                     BUG15042
     D  P@ACOD               554    563                                                    BUG15042A
     D  P@ACSQ                15     16                                                    BUG15042A
     D  P@BRCA                23     25                                                    BUG15042A
     D**P@ACOD**              11     20                                           BUG15042 BUG15042A
     D**P@ACSQ**              21     22                                           BUG15042 BUG15042A
     D**P@BRCA**              29     31                                           BUG15042 BUG15042A
     D/COPY WNCPYSRC,FTH00418
                                                                                            BUG15042
      *  Calling parameter data structure for AOSPOSU0
     D C#DTA           DS           256
     D  C#ATYP                 1      1
     D***C#ACCT                 2     19                                                      CGL029
     D**C#CNU1**               2      7  0                                                    CSD027
     D  C#CNU1                 2      7                                                       CSD027
     D  C#CCY1                 8     10
     D***C#ACO1                11     14  0                                                   CGL029
     D  C#ACS1                15     16  0
     D  C#BRC1                17     19
     D  C#NOSN                 2      3  0
     D  C#NOS                  2      6
     D  C#ACNO                 2     11  0
     D**C#CNUM**               2      7  0                                                    CSD027
     D  C#CNUM                 2      7                                                       CSD027
     D***C#ACOD                 8     11  0                                                   CGL029
     D  C#ACSQ                12     13  0
     D  C#BRCA                14     16
     D  C#IO                  24     24
     D  C#CCY                 25     27
     D  C#TRYP                28     29
     D  C#NARR                30     59
     D  C#CHQN                60     67  0
     D  C#PREF                68     82
     D  C#TRN                 83     88
     D  C#AMT                 89     96P 0
     D  C#PRON                97     97
     D  C#OLPS                98     98
     D  C#MEMS                99     99
     D  C#RSAC               100    100
     D  C#MOD                101    102
     D  C#OLRC               103    104
     D  C#FTOV               105    105
     D  C#VDAT               106    108P 0
     D  C#PSTD               109    111P 0
     D  C#PSTO               112    112
     D  C#RPST               113    113
     D  C#RPNB               114    116  0
     D  C#RTYP               117    117
     D C#BBRN                118    120  0                                                    CGL029
     D C#ACO1                121    130  0                                                    CGL029
     D C#ACOD                131    140  0                                                    CGL029
     D C#OTR1                141    160                                                       CAP204
     D C#MTYP                161    161                                                       CAP205
      *                                                                                       CLE134
      ** Exception Reference Id/Number                                                        CLE134
      *                                                                                       CLE134
     D C#XRFI                162    164                                                       CLE134
     D C#XRFN                165    174  0                                                    CLE134
                                                                                              CGL029
      ** Full General Ledger - CNUM/CCY/ACOD/ACSQ                                             CGL029
     D                 DS                                                                     CGL029
     D C#ACCT                  1     24                                                       CGL029
     D W#ACNO                  1     10  0                                                   BUG3821
     D W#NOS                   1      5                                                      BUG3821
     D W#NOSN                  1      2  0                                                   BUG3821
     D*W#CNU1***               1      6  0                                             CGL029 CSD027
     D W#CNU1                  1      6                                                       CSD027
     D W#CCY1                  7      9                                                       CGL029
     D W#ACOD                  7     16  0                                                   BUG3854
     D W#ACSQ                 17     18  0                                                   BUG3854
     D W#ACO1                 10     19  0                                                    CGL029
     D W#ACS1                 20     21  0                                                    CGL029
     D W#BRC1                 22     24                                                       CGL029
                                                                                              CGL029
      * Partial Account - CNUM/ACOD/ACSQ/BRCA                                                 240008
     D**P#CNUM**               1      6  0                                             240008 CSD031
     D  P#CNUM                 1      6A                                                      CSD031
     D  P#ACOD                 7     16  0                                                    240008
     D  P#ACSQ                17     18  0                                                    240008
     D  P#BRCA                19     21                                                       240008
     D/COPY WNCPYSRC,FTOPAYDD02
      *
     D* Payment type and subtype
     D W7DATA          DS           310
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
     D** Calling parameter to AOVATR0
     D VATDS           DS
     D  I#BRCA                 1      3
     D  I#CUST                 4      9
     D  O#VATR                10     12P 4
     D*
     D** Calling parameter data structure for FT0035
     D W0DTA           DS           256
     D  I#PT1                  1      1
     D  I#PTY1                 2     36
     D  I#PT2                 37     37
     D  I#PTY2                38     72
     D  I#CCY                 73     75
     D  O#CUST                76     81
 
     D                 DS                                                                     CSD015
      **  Ordering Bank                                                                       CSD015
     D**OrderingBank           1     12                                               CSD015 CSD027C
     D  OrderingBank           1     18                                                      CSD027C
     D  ORBKNostro             1      2                                                       CSD015
     D  ORBKRetail             1     10                                                       CSD015
                                                                                              CSD015
      ** Data structure for 2nd parameter of SDCWLCHK                                         CSD015
     D PString         DS         30000                                                       CSD015
                                                                                              CSD015
      ** ZACVTDATE Parameters                                                                 CSD015
     D PZADayNo        S              5                                                       CSD015
     D PZADDT          S               D                                                      CSD015
     D PConvtDate      S             10                                                       CSD015
                                                                                              CSD015
      ** ZACVTAMT Parameters                                                                  CSD015
     D PZARtCd         S             10                                                       CSD015
     D PZACcy          S              3                                                       CSD015
     D PZAAmt          S             15                                                       CSD015
     D PZOutAmt        S             18  3                                                    CSD015
     D PZCvtAmt        S             16                                                       CSD015
                                                                                              CSD015
      ** SRConvert Parameters                                                                 CSD015
     D PInput          S             35                                                       CSD015
     D PInput1         S             35                                                       CSD015
     D PInput2         S             35                                                       CSD015
     D PInput3         S             35                                                       CSD015
     D PInput4         S             35                                                       CSD015
     D PInput5         S             35                                                       CSD015
     D PInCcy          S              3                                                       CSD015
     D OutFmt          S            216                                                       CSD015
     D OutFmt2         S              6                                                       CSD015
                                                                                              CSD015
      ** Work Variables                                                                       CSD015
     D WDDT            S               D                                                      CSD015
     D WFPDT           S              8F                                                      CSD015
     D Fld1            S             35                                                       CSD015
     D Fld2            S             35                                                       CSD015
     D Fld3            S             35                                                       CSD015
     D Fld4            S             35                                                       CSD015
     D Fld5            S             35                                                       CSD015
     D @Func           S              8                                                       CSD015
     D WCtrpRpt        S             30                                                       CSD015
     D WCtrpTyp        S              1                                                       CSD015
     D PCustNo         S             10A                                                      CSD015
     D PErrInf         S              7A                                                      CSD015
     D U               S              2  0                                                    CSD015
                                                                                              CSD015
     D WRevAst         S              1                                                       CRE020
     D CRE020          S              1                                                       CRE020
     D PRTCD           S              7                                                       CRE020
     D POPTN           S              7                                                       CRE020
     D PSARD           S              6                                                       CRE020
                                                                                              CRE020
     D UM#CCY          S              3A                                                      CFT120
      *                                                                                       CFT120
      * Factors table
     D FCTR            S              4  0 DIM(4) CTDATA PERRCD(1)
      * Powers table
     D POWERS          S              7  0 DIM(6) CTDATA PERRCD(1)
                                                                                              CSD015
      ** Watch List Description Array                                                         CSD015
     D***WLARR***         S             35    DIM(22) CTDATA PERRCD(2)                 CSD015 CSW209
     DWLARR            S             35    DIM(34) CTDATA PERRCD(2)                           CSW209
 
      ** Index for arrays of error message ids etc
     D Idx             S              3P 0
 
     D C#K101          S              3
     D C#OPTN          S              7
     D C#RTCD          S              7
 
     D Paymnref        S             15
     D Action          S              1
     D BookBrch        S              3
     D WLevel          S              1
     D FTTOWR          S             24A                                                      CGL029
     D FTFRWR          S             24A                                                      CGL029
     D WORBKC          S             21A                                                      CGL029
     D WORBK           S             18A                                                      CGL029
     D WFLDO           S             18A                                                      CGL029
     D WFLD1           S             21A                                                      CGL029
     D WFLD2           S             24A                                                      CGL029
     D CSW209          S              1A                                                      CSW209
      *                                                                                       CFT120
      ** CFT120 switchable field                                                              CFT120
      *                                                                                       CFT120
     D CFT120          S              1A                                                      CFT120
      *                                                                                       CSW220
      ** CSW220 switchable field                                                              CSW220
      *                                                                                       CSW220
     D CSW220          S              1A                                                      CSW220
     D PSWIFT          S              6A                                                      CSW220
     D PRTNCD          S              7A                                                      CSW220
 
     D CAP205          S              1A                                                      CAP205
     D/COPY WNCPYSRC,FTH00560
                                                                                              CAP205
      ** Timestamp for the tranaction
     D Timestamp       S               Z
                                                                                              CSC011
      ** Transaction Detail Field                                                             CSC011
     D TRANSDTL        S           5800A                                                      CSC011
                                                                                              CSC011
      ** Payment Reference                                                                    CSC011
     D***PREFERENCE      S             18A                                             CSC011 CGL029
     D***PAREFERENCE     S             18A                                             CSC011 CGL029
     D PREFERENCE      S             24A                                                      CGL029
     D PAREFERENCE     S             24A                                                      CGL029
                                                                                              CSC011
      ** Log Time Stamp field                                                                 CSC011
     D PTIMESTMP       S             26A                                                      CSC011
                                                                                              200217
      ** Original access type field                                                           200217
     D WType           S              1A                                                      200217
                                                                                              221778
      ** Ordering Customer (with first 10 char removed)                                       221778
     D OTORCX          S             25A                                                      221778
                                                                                CFT014
      **  Data Structure for input/output parameters                            CFT014
     D/COPY FTCPYSRC,FT0010D001                                                 CFT014
 
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* MAIN - MAIN BODY                                              *
     C*                                                               *
     C*****************************************************************
 
     C                   EXSR      INSSR                                                     BUG4449
      *  Clear stored values
     C/COPY WNCPYSRC,FTH00472
     C     OTCHTP        IFNE      'S'                                                        CFT157
     C                   Exsr      SRCLR
     C/COPY WNCPYSRC,FTH00473
     C                   Endif                                                                CFT157
 
      ** Ensure transaction has not been updated by another workstation
      ** - if so, bypass updating and return to calling program.
     C                   EXSR      CHKOTHUPD
 
     C     RetCodeIn     IFNE      *BLANKS
     C                   GOTO      EXIT
     ******************************************************************               241810 241810A
     ***Update*authorising*user*and*authorising*indicator**************               241810 241810A
     ******************************************************************               241810 241810A
     C**********         ELSE                                                         241810 241810A
     C**********         IF        OTAUP1 = *Blanks                                   241810 241810A
     C**********         EVAL      OTAUP1 = @USRID                                    241810 241810A
     C**********         EVAL      OTAUIN = 'Y'                                       241810 241810A
     C**********         ELSE                                                         241810 241810A
     C**********         EVAL      OTAUP2 = @USRID                                    241810 241810A
     C**********         EVAL      OTAUIN = 'Y'                                       241810 241810A
     C**********         ENDIF                                                        241810 241810A
     C                   END
 
      *                                                                                       CFT120
      ** Store the Charges to the DR of Currency and                                          CFT120
      ** Store Receiver's charges Currency from Valid Values for later use                    CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVE      *BLANKS       UMCCCY            3                          CFT120
     C                   MOVE      *BLANKS       UMCCY2            3                          CFT120
     C                   MOVE      OTCDRC        UMCCCY                                       CFT120
     C                   MOVE      @RCCY         UMCCY2                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C/COPY WNCPYSRC,FTOPAYDC01
 
      ** INSERT, AMEND, DELETE
 
     C     OTCHTP        CASEQ     'I'           INSERT
     C     OTCHTP        CASEQ     'A'           AMEND
     C     OTCHTP        CASEQ     'D'           AMEND
     C/COPY WNCPYSRC,FTH00474
     C     OTCHTP        CASEQ     'S'           STOP                                         CFT157
     C                   END
                                                                                              CSC011
      ** Log transaction by calling the LOG module                                            CSC011
                                                                                              CSC011
     C                   IF        (@CSC011 = 'Y') AND (LIBR = S1SUPP)                        CSC011
     C                   IF        (OTCHTP = 'I') OR (OTCHTP = 'A') OR                        CSC011
     C                             (OTCHTP = 'D')                                             CSC011
     C/COPY WNCPYSRC,FTH00475
     C                             OR (OTCHTP = 'S' and @CFT157 = 'Y')                        CFT157
     C                   EXSR      SRLOGTRAN                                                  CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
     C/COPY WNCPYSRC,FTOPAYDC11
 
     C     #NOUPD        CABEQ     'N'           UPDEND
      *
     C/COPY WNCPYSRC,FTH00476
     C                   IF        OTPYTP <> 'RP'                                          AR1091503
     C                   EXSR      SRUPD
     C                   ENDIF                                                             AR1091503
     C/COPY WNCPYSRC,FTOPAYDC02
      *
     C* NOT DELETE UPDATE TRAILER
     C     OTCHTP        IFNE      'D'
     C/COPY WNCPYSRC,FTH00477
     C     OTCHTP        ANDNE     'S'                                                        CFT157
     C     1             CHAIN     OTPAYZZF                           99
     C   99              DO
     C                   MOVE      'FTOPAYUPD'   DBPGM
     C                   MOVE      'OTPAY'       DBFILE
     C                   Z-ADD     6             DBASE
     C                   MOVEL     '1'           DBKEY
     C                   EXSR      *PSSR
     C                   END
 
     C                   Z-ADD     HRWN          ZZTOTI
     C                   Z-ADD     HRDC          ZZTOTD
     C     OTCHTP        IFEQ      'I'
     C                   ADD       1             NORE1
     C     OTSMAM        DIV       1000          ZZAMT
     C                   END
 
     C     OTCHTP        IFEQ      'A'
     C     OTSMAM        DIV       1000          ZZAMT1           15 3
     C     OSMAM         DIV       -1000         ZZAMT
     C                   ADD       ZZAMT1        ZZAMT
     C                   END
 
     C                   EXSR      GLZADD
     C                   Z-ADD     ZZTOTI        HRWN
     C                   Z-ADD     ZZTOTD        HRDC
     C                   UPDATE    OTPAYZZF
     C                   END
 
      *  Clear stored values
     C     UPDEND        TAG
     C/COPY WNCPYSRC,FTH00478
     C     OTCHTP        IFNE      'S'                                                        CFT157
     C                   EXSR      SRCLR
     C/COPY WNCPYSRC,FTH00479
     C                   Endif                                                                CFT157
                                                                                              201577
      ** Call CL program to deallocate this reference to a dataarea                           201577
                                                                                              201577
     C                   EVAL      C#RTCD = *Blanks                                           201577
     C                   EVAL      @MODLE = 'FT'                                              201577
     C                   EVAL      @TREF  = *Blanks                                           201577
     C                   EVAL      @RTINF = *Blanks                                           201577
      *                                                                                       201577
     C                   CALL      'AOC8000'                                                  201577
     C                   PARM                    C#RTCD                                       201577
     C                   PARM                    @MODLE                                       201577
     C                   PARM                    @TREF                                        201577
     C                   PARM                    @RTINF                                       201577
     C*
      ** Deallocate the transaction's data area after update by passing                       196378
      ** a blank transaction reference to CL program that is used for                         196378
      ** allocation/deallocation of data area.                                                196378
      *                                                                                       196378
     C                   Eval      C#RTCD = *Blanks                                           196378
     C                   Eval      @MODLE = 'FT'                                              196378
     C                   Move      *Blanks       @TREF                                        196378
     C                   Eval      @RTINF = *Blanks                                           196378
      *                                                                                       196378
     C                   CALL      'AOC8000'                                                  196378
     C                   Parm                    C#RTCD            7                          196378
     C                   Parm                    @MODLE            2                          196378
     C                   Parm                    @TREF            15                          196378
     C                   Parm                    @RTINF           80                          196378
     C*                                                                                       196378
      * EXIT FROM PROGRAM
     C     EXIT          TAG
 
     C                   RETURN
     C****************************************************************
      /EJECT
     C*****************************************************************
     C*                                                               *
     C* CHKOTHUPD - Check for update by another workstation           *
     C*                                                               *
     C*****************************************************************
     C     CHKOTHUPD     BEGSR
 
      ** Retrieve current FT Outgoing Payment Transaction Details
 
     C                   MOVE      OTPREF        MidasTrNum       15
 
      ** Determine whether program is running interactively or in batch
      **  ( 0 = batch   1 = interactive)
      *
     C                   CALLB     'ZARTVJOBA'
     C                   PARM                    @Return           6
     C                   PARM                    @type             1
                                                                                              200217
      ** Save the original @type field to work field.                                         200217
                                                                                              200217
     C                   MOVE      @type         WType                                        200217
      *                                                                         CAP013
      * Set retrieve mode to '*FRONT' (Access using Front Office ID)            CAP013
      *  if insert                                                              CAP013
      * Otherwise                                                               CAP013
      *  Set retrieve mode to blank  (Access using Midas transaction ID).       CAP013
      *                                                                         CAP013
     C*****OTCHTP        IFne      'I'                                    CAP013193883
     C**********         MOVEL     '1'           @TYPE                    CAP013193883
     C**********         ENDIF                                            CAP013193883
      *
     C     @Type         IFEQ      '1'                                          193883
     C     OTCHTP        ANDEQ     'I'                                          193883
     C     OTFRNT        ANDNE     *BLANKS                                      193883
     C                   MOVE      '*FRONT'      @@MODE                         193883
     C                   ELSE                                                   193883
      *                                                                         193883
      * Otherwise, if running in batch use Front-Office ID (if insert)          193883
      * else, use Midas Deal Number                                             193883
      *                                                                         193883
     C     @Type         IFEQ      '0'
     C     OTCHTP        ANDEQ     'I'                                          193883
     C                   MOVE      '*FRONT'      @@MODE
     C**********         EVAL      FOTRID = OTFRNT                              193883
     C                   ELSE
     C                   MOVE      *BLANKS       @@MODE
     C**********         EVAL      FOTRID = *blanks                             193883
     C                   END
     C                   END                                                    193883
 
      * Set level 1/2 flag to '1'
     C                   MOVE      '1'           WLevel
      *                                                                                      BUG9071
      ** Only set the respmode to 'S' when the front office is blank                         BUG9071
      *                                                                                      BUG9071
     C                   IF        OTFRNT = *BLANK                                           BUG9071
     C                   EVAL      RespMode = 'S'                                            BUG9071
     C                   ENDIF                                                               BUG9071
      *
      * Retrieve FT Outgoing Payment Details
      *
     C/COPY WNCPYSRC,FTH00343
     C                   CALLB     'FTOPAYRTV'
      *                  ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
      * INPUTS :
      * Return code
     C/COPY WNCPYSRC,FTH00344
     C                   PARM      *BLANK        RetCodeOut
     C/COPY WNCPYSRC,FTH00345
      * Mode = '*FRONT' (FRONT OFFICE TRANSACTION INTERFACE)
      * MODE = '      ' (NOT FRONT OFFICE TRANSACTION INTERFACE)
     C                   PARM                    @@MODE            6
      * Response mode
     C**********         PARM                    RespMode          1                          CAP084
     C**********         PARM      'S'           RespMode          1                  CAP084 BUG9071
     C                   PARM                    RespMode          1                         BUG9071
      * Action Code
     C                   PARM      OTCHTP        Action
      * Front Office Transaction ID
     C*********          PARM                    FOTRID                         193883
     C                   PARM      OTFRNT        FOTRID                         193883
      * (Midas) Payment Reference
     C                   PARM                    MidasTrNum
      * Booking branch
     C                   PARM      OTBRCA        Bookbrch
      * Level 1/2 indicator
     C                   PARM                    WLevel
      * @CFT014 workfield                                                       CFT014
     C                   PARM                    Val@Fields                     CFT014
      * OUTPUTS :
      * (Current) Outgoing Payment in file format
     C                   PARM                    ChkOPAYFmt
     C                   PARM                    ChkOPAYFmX                     CFT014
      * OK - Action code
     C                   PARM      *BLANK        OKACTION
      * OK - Payment Reference
     C                   PARM                    OKPREF
      * OK - Booking branch
     C                   PARM                    OKBRCA
      * Error fields/message IDs/message data (arrays) from/to caller
     C                   PARM                    FldNameArr
     C                   PARM                    MsgIdArr
     C                   PARM                    MsgDtaArr
      * Array index (3P0) from/to caller
     C                   PARM      *ZERO         Idx
     C/COPY WNCPYSRC,FTOPAYDC31
      *
      ** Error if Timestamp is not the same (record has been changed
      **  by another workstation)
 
      ** Processing varies according to mode program is running in.
      ** In interacive mode simply check whether the timestamp field
      ** has been updated since the original Trade was fetched by this
      ** program.
      ** In batch (API input) check return parameters from Retrieve
      ** module for errors, and send message to system operator.
 
      ** Interactive mode:
 
     C*****@TYPE         IFEQ      '1'                                                        200217
     C     WType         IFEQ      '1'                                                        200217
 
     C     CHTMST        IFNE      OTTMESTMP
     C     OTCHTP        OREQ      'A'                                                        223737
     C     CHAUIN        ANDEQ     'Y'                                                        223737
     C     OTCHTP        OREQ      'D'                                                        223737
     C     CHAUIN        ANDEQ     'Y'                                                        223737
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   ELSE                                                                 262786
     C                   MOVE      'Y'           OKPREF                                       262786
     C                   END
 
      ** Batch mode:
     C                   ELSE
     C     OKACTION      IFEQ      'N'
     C     OKPREF        OREQ      'N'
     C                   MOVEL     '*RECUPD'     RetCodeIn
     C                   Z-ADD     1             C                 2 0
 
     C     C             DOWLE     ArrayMax
     C     FldNameArr(C) ANDNE     *BLANKS
     C                   MOVEL     *BLANKS       DBError          28
     C                   MOVEL     MsgIDArr(C)   DBError
     C                   CALLB     'ZAMSGTOOPR'
     C                   PARM                    MsgSndRtn        10
     C                   PARM                    DBError
     C                   PARM                    DummyMsgID
     C                   PARM                    DummyMsgF
     C                   ADD       1             C
     C                   END
 
     C                   END
 
     C                   END
 
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* INSERT - INSERT A PAYMENT                                    *
     C*                                                              *
     C****************************************************************
     C     INSERT        BEGSR
 
      *  If Batch Authorsation update/add record
     C                   If        @CFT003 = 'Y'
     C                             Or (@CFT014 = 'Y')                           CFT014
     C                             Or (@CFT009 = 'Y')                           CFT009
     C*****OTPREF        CHAIN     OTPAYXL0                           99        CFT014
     C     OTPREF        CHAIN     OTPAYXDF                           99        CFT014
 
     C                   If        *IN99 = *On
                                                                                CFT014
      ** Set MT103 fields                                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   If        OTADDC = 'A'                                 CFT014
     C                   If        (O2RCUS = 'N') And (O2RCNW <> *Zero)         CFT014
                                                                                CFT014
      ** Receiver's charges = :71G: received - our charges                      CFT014
      ** Result holds in pay currency                                           CFT014
                                                                                CFT014
     C                   ExSr      SUBRCG                                       CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   Eval      O2RCUS = 'Y'                                 CFT014
     C                   Eval      NewPmntB = ValidPmntB                        CFT014
     C                   Else                                                   CFT014
     C                   ExSr      SrSetField                                   CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT009
      *                                                                         CFT009
      ** Fees & Charges                                                         CFT009
      *                                                                         CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C                   EVAL      NEWPMNTB = VALIDPMNTB                        CFT009
     C                   Eval      DATNED = *Zero                               CFT009
     C                   Eval      DATNAO = *Zero                               CFT009
     C                   ELSE                                                   CFT009
     C                   Eval      MISCC1 = *Zero                               CFT009
     C                   Eval      MISCC2 = *Zero                               CFT009
     C                   Eval      MISCC3 = *Zero                               CFT009
     C                   Eval      MISCC4 = *Zero                               CFT009
     C                   Eval      MISCC5 = *Zero                               CFT009
     C                   Eval      SWSCCC = *Zero                               CFT009
     C                   Eval      DATNED = *Zero                               CFT009
     C                   Eval      DATNAO = *Zero                               CFT009
     C                   Eval      OPCHRT = *Zero                               CFT009
     C                   Eval      FXSRSC = *BLANKS                             CFT009
     C                   Eval      OTPDOF = *BLANKS                             CFT009
     C                   Eval      MISC01 = *Zero                               204029
     C                   Eval      MISC02 = *Zero                               204029
     C                   Eval      MISC03 = *Zero                               204029
     C                   Eval      MISC04 = *Zero                               204029
     C                   Eval      MISC05 = *Zero                               204029
     C                   Eval      SWSCHG = *Zero                               204029
     C                   ENDIF                                                  CFT009
 
     C                   Eval      OPRECI = 'D'
     C                   Eval      OPPREF = OTPREF
     C                   Eval      OPBJPR = *Blanks
     C                   Eval      OPAUTO = 'N'
     C/COPY WNCPYSRC,FTH00198
     C                   Move      OTSTMT        OPSETM
     C***********        Write     OTPAYXDF                                     CFT014
                                                                                CFT014
      ** Generate timestamp                                                     CFT014
                                                                                CFT014
     C                   CallB     'ZAGENTMSTM'                                 CFT014
     C                   Parm                    Timestamp                      CFT014
     C                   Eval      OPTMST = Timestamp                           CFT014
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        @CSC011 = 'Y'                                              CSC011
     C                   IF        OPFRNT = *BLANKS                                           CSC011
     C                   EVAL      OPFRNT = 'MD' + OPPREF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing                                CSD015
                                                                                              CSD015
     C                   IF        @CSD015 = 'Y'  and  W1EWLC = 'Y'                           CSD015
                                                                                              CSD015
     C                   IF        (@CSC011 = 'Y' and S1MAIN = LIBR)                          CSD015
     C                             or @CSC011 = 'N'                                           CSD015
     C                   EXSR      SrWatch                                                    CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   Write     OTPAYXDF                             98      CFT014
                                                                                CFT014
      ** Error writing record                                                   CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '038'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Movel     OTPREF        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
 
     C                   Else
      * If existing extension record, update
     C                   If        @CFT014 <> 'Y'                               CFT014
     C/COPY WNCPYSRC,FTH00419
     C                   Eval      OPAUTO = 'N'
     C/COPY WNCPYSRC,FTH00199
     C                   ExSr      SrSetField                                   CFT014
     C***********        Update    OTPAYXDF                                     CFT014
                                                                                CFT014
      ** Generate timestamp                                                     CFT014
                                                                                CFT014
     C                   CallB     'ZAGENTMSTM'                                 CFT014
     C                   Parm                    Timestamp                      CFT014
     C                   Eval      OPTMST = Timestamp                           CFT014
                                                                                              CSD015
      ** If compliance watch is installed, and entry watch list checking                      CSD015
      ** is being applied, perform compliance watch processing for amend mode                 CSD015
                                                                                              CSD015
     C                   IF        @CSD015 = 'Y'  and  W1EWLC = 'Y'                           CSD015
     C                             and OTCHTP = 'A'                                           CSD015
                                                                                              CSD015
     C                   IF        (@CSC011 = 'Y' and S1MAIN = LIBR)                          CSD015
     C                             or @CSC011 = 'N'                                           CSD015
                                                                                              CSD015
     C                   EVAL      W3UNCF = ' '                                               CSD015
     C                   EVAL      WFUNT = 'OTPAYDD'                                          CSD015
     C                   EVAL      WIDEN = PREF                                               CSD015
     C     CWHTKY        CHAIN     SDCWHTL1                                                   CSD015
                                                                                              CSD015
     C                   IF        %FOUND(SDCWHTL1) and W3UNCF = 'Y'                          CSD015
     C                             or NOT %FOUND(SDCWHTL1)                                    CSD015
     C                   EXSR      SrWatch                                                    CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
     C                   Update    OTPAYXDF                             98      CFT014
                                                                                CFT014
      ** Error updating record                                                  CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '039'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Movel     OTPREF        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C****************** Else                                                   CFT014        247314
     C****************** Movel     'OTPAYXL0'    DBFILE                         CFT014        247314
     C****************** Movel     '036'         DBASE                          CFT014        247314
     C****************** Movel     'OTPREF'      DBKEY                          CFT014        247314
     C****************** ExSr      *PSSR                                        CFT014        247314
     C                   EndIf                                                  CFT014
     C                   End
 
     C                   End
 
      * Write OTPAY record
     C                   Move      ValidPmnt     NewPmnt
 
      ** Generate timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    Timestamp
 
     C                   Eval      TMST = Timestamp
     C                   Eval      OTTMESTMP = TimeStamp                                    BUG18500
 
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        @CSC011 = 'Y'                                              CSC011
     C                   IF        FRNT = *BLANKS                                             CSC011
     C                   EVAL      FRNT = 'MD' + PREF                                         CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
      *                                                                                       CAP211
     C                   IF        PUser = *Blanks                                            CAP211
     C                   EVAL      AUP1 = INUSR1                                              CAP211
     C                   ELSE                                                                 CAP211
     C                   EVAL      AUP1 = PUser                                               CAP211
     C                   ENDIF                                                                CAP211
     C                   EVAL      AUIN = 'Y'                                                 CAP211
      *                                                                                       CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                     MD030940
     C                   EVAL      DATE = 0                                                 MD030940
      *                                                                                       CAP211
      *                                                                                       CFT049
      ** Set Auto Auth to 'N' if Account with Bank is not SWIFT BIC                           CFT049
      *                                                                                       CFT049
     C                   If        CFT049 = 'Y'                                               CFT049
     C                   Movel     OTACB1        WCHK              4                          CFT049
      *                                                                                       CFT049
     C                   If        AUIN = 'Y' AND                                             CFT049
     C                             @ACBT <> 'S' AND                                           CFT049
     C                             WCHK  <> '//FW'                                            CFT049
     C**********         Move      'N'           AUIN                                CFT049 MD044588
     C                   Move      ' '           AUIN                                       MD044588
     C                   Endif                                                                CFT049
      *                                                                                       CFT049
     C                   Endif                                                                CFT049
     C/COPY WNCPYSRC,FTH00430
     C                   Write     OTPAYDDF                             99
 
     C                   If        *IN99 = *ON
     C                   Movel     'FTOPAYUPD'   DBFILE
     C                   Z-add     4             DBASE
     C                   Movel     OTPREF        DBKEY
     C                   Exsr      *PSSR
     C                   End
     C/COPY WNCPYSRC,FTH00420
      *                                                                                       257487
      ** Move valid file details to extension file details                                    257487
      *                                                                                       257487
     C                   EVAL      OTFRID = OTFRNT                                            257487
     C/COPY WNCPYSRC,ERZ248_044                                                               ERZ248
     C                   Write     OTPAYQD0                             99                    257487
                                                                                              257487
     C                   If        *IN99 = *ON                                                257487
     C                   Movel     'OTPAYDQD'    DBFILE                                       257487
     C                   Z-add     32            DBASE                                        257487
     C                   Movel     OTPREF        DBKEY                                        257487
     C                   Exsr      *PSSR                                                      257487
     C                   End                                                                  257487
      **********                                                                    BUG4776 BUG4776R
      ****If*new*record*was*successfully*writen*to*OTPAYDD,*add*new*record*to***    BUG4776 BUG4776R
      ****FT*Payment*Reference*Control*file*-*FTPREFPD**************************    BUG4776 BUG4776R
      **********                                                                    BUG4776 BUG4776R
     C**********         If        *IN99 = *OFF                                     BUG4776 BUG4776R
     C**********         EVAL      MLRECI = OTRECI                                  BUG4776 BUG4776R
     C**********         MOVEL     OTPREF        MLPREF                             BUG4776 BUG4776R
     C**********         EVAL      MLPYTP = OTPYTP                                  BUG4776 BUG4776R
     C**********         Write     FTPREFDF                             70          BUG4776 BUG4776R
     C**********         If        *IN70 = *ON                                      BUG4776 BUG4776R
     C**********         Movel     'FTPREFL0'    DBFILE                             BUG4776 BUG4776R
     C**********         Z-add     7             DBASE                              BUG4776 BUG4776R
     C**********         Movel     MLPREF        DBKEY                              BUG4776 BUG4776R
     C**********         Exsr      *PSSR                                            BUG4776 BUG4776R
     C**********         Endif                                                      BUG4776 BUG4776R
     C**********         Endif                                                      BUG4776 BUG4776R
      *
     C/COPY WNCPYSRC,FTOPAYDC09
      * Call CL program to allocate this reference to a dataarea
     C                   Eval      C#RTCD = *Blanks
     C                   Eval      @MODLE = 'FT'
     C                   Move      OTPREF        @TREF
     C                   Eval      @RTINF = *Blanks
      *
     C                   CALL      'AOC8000'
     C                   Parm                    C#RTCD            7
     C                   Parm                    @MODLE            2
     C                   Parm                    @TREF            15
     C                   Parm                    @RTINF           80
 
      *  Process shadow post if new addition and not regular payment
      *  Or level incomplete i.e. insert of generated payment
     C                   If        OTPYTP <> 'RP'
     C                   Eval      ##SMAM = OTSMAM
     C                   Eval      ##PYAM = OTPYAM
     C                   If        (@CFT014 = 'Y') And (OPRCRM <> 0)            CFT014
     C                   Eval      ##PYAM = ##PYAM + OPRCRM                     CFT014
     C                   EndIf                                                  CFT014
     C                   Exsr      SRADD
     C                   End
      *                                                                         185764
      * Calculate charge amount (always debit)                                  185764
      *                                                                         185764
     C     TXCH          ADD       CQCH          ##CHGS                         185764
     C                   ADD       CSTA          ##CHGS                         185764
     C                   ADD       SPCH          ##CHGS                         185764
     C                   ADD       MSCH          ##CHGS                         185764
     C                   ADD       TRCM          ##CHGS                         185764
     C*                                                                         185764
     C     @01494        IFEQ      'Y'                                          185764
     C                   ADD       OPCHCM        ##CHGS                         185764
     C                   END                                                    185764
     C*                                                                         185764
     C     @01499        IFEQ      'Y'                                          185764
     C     @CFT009       ANDEQ     'N'                                          CFT009
     C     @CFT010       OREQ      'Y'                                          CFT009
     C                   ADD       OPVATT        ##CHGS                         185764
     C                   END                                                    185764
                                                                                CFT014
      * Extra charges                                                           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C**********         ADD       MISCC1        ##CHGS                                CFT009 CFT120
     C**********         ADD       MISCC2        ##CHGS                                CFT009 CFT120
     C**********         ADD       MISCC3        ##CHGS                                CFT009 CFT120
     C**********         ADD       MISCC4        ##CHGS                                CFT009 CFT120
     C**********         ADD       MISCC5        ##CHGS                                CFT009 CFT120
     C**********         ADD       SWSCCC        ##CHGS                                CFT009 CFT120
      ** Apply 245712 fix to Insert Action                                                    CFT120
     C                   ADD       MISC01        ##CHGS                                       CFT120
     C                   ADD       MISC02        ##CHGS                                       CFT120
     C                   ADD       MISC03        ##CHGS                                       CFT120
     C                   ADD       MISC04        ##CHGS                                       CFT120
     C                   ADD       MISC05        ##CHGS                                       CFT120
     C                   ADD       SWSCHG        ##CHGS                                       CFT120
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Include Receiver's Charges remitted, if present.                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Select                                                 CFT014
     C***********        When      CDRO <> *Zero                                CFT014        CSD027
     C                   When      CDRO <> *BLANKS                              CFT014        CSD027
     C                   Eval      ##CHGS = ##CHGS + OPRBCQ                     CFT014
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
      *                                                                                       CFT120
     C     UMCCY2        IFNE      BJCYCD                                                     CFT120
     C     *LIKE         DEFINE    C#AMT         UMRCRM                                       CFT120
     C                   EVAL      ##CHGS = ##CHGS - OPRBCQ                                   CFT120
      *                                                                                       CFT120
      ** Convert Receiver's charges remitted from pay ccy to charge ccy                       CFT120
      *                                                                                       CFT120
     C                   Clear                   P#0010                                       CFT120
     C                   Z-Add     OTPVDT        P#FRDT                                       CFT120
     C                   Z-Add     OTSLDT        P#TODT                                       CFT120
     C                   Movel     OTPCCY        P#FRCY                                       CFT120
     C                   Z-Add     OPRCRM        P#FRAM                                       CFT120
     C                   Movel     UMCCY2        P#TOCY                                       CFT120
     C                   Z-Add     0             P#TOAM                                       CFT120
     C                   Z-Add     0             P#RATE                                       CFT120
     C                   Call      'FT0010'                                                   CFT120
     C                   Parm                    P#0010                                       CFT120
      *                                                                                       CFT120
     C     P#RTCD        IfNe      *Blank                                                     CFT120
     C                   Movel     'FT0010  '    DBFILE                                       CFT120
     C                   Movel     '*CALL  '     DBKEY                                        CFT120
     C                   Z-Add     90            DBASE                                        CFT120
     C                   ExSr      *PSSR                                                      CFT120
     C                   Else                                                                 CFT120
     C                   Z-Add     P#TOAM        UMRCRM                                       CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Eval      ##CHGS = ##CHGS + UMRCRM                                   CFT120
      *                                                                                       CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   When      ADDC = 'A'                                   CFT014
     C                   Eval      ##CHGS = ##CHGS + OPRCSC                     CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
      *                                                                         185764
     C     ##CHGS        IFNE      0                                            185764
     C     OTPYTP        ANDNE     'RP'                                                    AR1091503
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     UMCCY2        UM#CCY                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   EXSR      SRSCHG                                       185764
     C                   END                                                    185764
 
      * Update Incoming Message FT Transaction Status File record
     C                   If        OTOPMSGR <> 0
      *                                                                                       196813
      ** Remove the electronic message from the Outstanding Reserved                          196813
      ** Messages file.                                                                       196813
      *                                                                                       196813
     C                   EXSR      SRMsgDel                                                   196813
      *                                                                                       196813
     C/COPY WNCPYSRC,FTH00200
     C                   Movel     'MIN0030'     W0FLAG            7
     C/COPY WNCPYSRC,FTH00201
     C                   Movel     'MIN0190'     W0LMSG            7
 
     C                   Exsr      SRINFT
     C/COPY WNCPYSRC,FTH00397
 
     C                   End
      *
     C                   ENDSR
     C****************************************************************
      /EJECT
     C****************************************************************
     C*                                                              *
     C* AMEND  - AMEND A TRADE                                       *
     C*                                                              *
     C****************************************************************
     C     AMEND         BEGSR
 
     C                   Move      'N'           WRTVD                                        202150
                                                                                              202150
     C     OTPREF        CHAIN     OTPAYDDF                           99
     C   99              DO
     C                   MOVE      'FTOPAYUPD'   DBPGM
     C                   MOVE      'OTPAY'       DBFILE
     C                   Z-ADD     5             DBASE
     C                   MOVEL     OTPREF        DBKEY
     C                   EXSR      *PSSR
     C                   END
                                                                                CFT014
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')           CFT014
     C                             OR (@CFT009 = 'Y')                           CFT009
     C     OTPREF        CHAIN     OTPAYXDF                           99        CFT014
                                                                                CFT014
      ** Record found, set retrieved work field to 'Y' otherwise, 'N'.          CFT014
                                                                                CFT014
     C                   If        *IN99 = *Off                                 CFT014
     C                   Move      'Y'           WRTVD             1            CFT014
     C                   Else                                                   CFT014
     C                   Move      'N'           WRTVD                          CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** If CFT014 is installed, and the record is not found, dberr.            CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   If        (WRTVD = 'N') Or (WRTVD = 'Y') And           CFT014
     C                             (OPRECI <> 'D')                              CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '037'         DBASE                          CFT014
     C                   Movel     'OTPREF'      DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
 
      * If S01508 is installed, check if debit customer has changed
     C     @01508        IFEQ      'Y'
     C     OTCHTP        ANDEQ     'A'
     C                   MOVE      *BLANKS       WDCUS1
     C                   MOVE      *BLANKS       WDCUS2
     C                   MOVE      *BLANKS       WRDFTC
     C*
     C** Determine the original debit customer by calling FT0035
     C** ...if S01506 is intalled, use ordering customer details
     C** ... if add/deduct is 'A', use ordering customer and bank
     C** ... if add/deduct is 'D', use destination and sender's corres.
     C*
     C                   CLEAR                   W0DTA
     C                   SELECT
 
     C     @01506        WHENEQ    'Y'
     C                   MOVEL     ORCT          I#PT1
     C                   IF        %SUBST(ORC1:1:1) = '/'                                     CFT032
     C                   IF        ORCT = 'A' OR                                              CFT032
     C                             ORCT = 'C' OR                                              CFT032
     C                             ORCT = 'S'                                                 CFT032
     C                   EVAL      I#PTY1 = ORC2                                              CFT032
     C                   ELSE                                                                 CFT032
     C**********         MOVEL     ORC1          I#PTY1                                       CFT032
     C                   EVAL      I#PTY1 = %SUBST(ORC1:2)                                    CFT032
     C                   ENDIF                                                                CFT032
     C                   ELSE                                                               BUG13029
     C                   EVAL      I#PTY1 = ORC1                                            BUG13029
     C                   ENDIF                                                                CFT032
     C                   MOVEL     SMCY          I#CCY
     C*
     C     OTADDC        WHENEQ    'A'
     C                   MOVEL     ORCT          I#PT1
     C                   MOVEL     ORC1          I#PTY1
     C                   MOVEL     SMCY          I#CCY
     C*****ORBK**        IFNE      *ZEROS                                                     CSD027
     C     ORBK          IFNE      *BLANKS                                                    CSD027
     C**********         MOVE      *BLANKS       WORBKC           15                          CGL029
     C**********         MOVEL     ORBK          WFLDO            12                          CGL029
     C                   MOVE      *BLANKS       WORBKC                                       CGL029
     C                   MOVEL     ORBK          WFLDO                                        CGL029
     C     WFLDO         CAT       ORBB          WORBKC
     C                   MOVEL     ORBT          I#PT2
     C                   MOVEL     WORBKC        I#PTY2
     C                   END
     C*
     C     ADDC          WHENEQ    'D'
     C                   MOVEL     DSTT          I#PT1
     C                   MOVEL     DST1          I#PTY1
     C                   MOVEL     PCCY          I#CCY
     C*****SNCO**        IFNE      *ZEROS                                                     CSD027
     C     SNCO          IFNE      *BLANKS                                                    CSD027
     C                   MOVEL     SNCT          I#PT2
     C                   MOVEL     SNCO          I#PTY2
     C                   END
     C                   ENDSL
     C*
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM                    W0DTA
     C                   PARM                    W0MSG           256
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'FT0035 '     DBFILE
     C                   MOVEL     '33'          DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   ELSE
     C     ODMT          IFNE      *BLANKS                                                    210873
     C     ADDC          ANDEQ     'A'                                                        210873
     C                   MOVE      OTODMT        WDCUS1                                       210873
     C                   ELSE                                                                 210873
     C                   MOVEL     O#CUST        WDCUS1            6
     C                   ENDIF                                                                210873
     C                   END
     C*
     C** Determine the new debit customer by calling FT0035
     C** ... if S01506 is intalled, use ordering customer details
     C** ... if add/deduct is 'A', use ordering customer and bank
     C** ... if add/deduct is 'D', use destination and sender's corres.
     C*
     C                   CLEAR                   W0DTA
     C                   SELECT
     C*
     C     @01506        WHENEQ    'Y'
     C                   MOVEL     OTORCT        I#PT1
     C     @MBIN         IFEQ      'N'
     C     OTORCT        ANDEQ     'P'
     C**********         MOVE      *BLANKS       WFLD1            15                          CGL029
     C                   MOVE      *BLANKS       WFLD1                                        CGL029
     C                   MOVEL     OTORC1        WFLD1
     C                   MOVE      BJSBRC        WFLD1
     C                   MOVEL     WFLD1         I#PTY1
     C                   ELSE
     C                   IF        %SUBST(OTORC1:1:1) = '/'                                   CFT032
     C                   EVAL      I#PTY1 = %SUBST(OTORC1:2)                                  CFT032
     C                   ELSE                                                                 CFT032
     C                   MOVEL     OTORC1        I#PTY1
     C                   ENDIF                                                                CFT032
     C                   END
     C                   MOVEL     OTSMCY        I#CCY
     C*
     C     OTADDC        WHENEQ    'A'
     C                   MOVEL     OTORCT        I#PT1
     C     @MBIN         IFEQ      'N'
     C     OTORCT        ANDEQ     'P'
     C**********         MOVE      *BLANKS       WFLD1            15                          CGL029
     C                   MOVE      *BLANKS       WFLD1                                        CGL029
     C                   MOVEL     OTORC1        WFLD1
     C                   MOVE      BJSBRC        WFLD1
     C                   MOVEL     WFLD1         I#PTY1
     C                   ELSE
     C                   IF        %SUBST(OTORC1:1:1) = '/'                                   CFT032
     C                   EVAL      I#PTY1 = %SUBST(OTORC1:2)                                  CFT032
     C                   ELSE                                                                 CFT032
     C                   MOVEL     OTORC1        I#PTY1
     C                   ENDIF                                                                CFT032
     C                   END
     C                   MOVEL     OTSMCY        I#CCY
     C*****OTORBK        IFNE      *ZEROS                                              221478 CSD031
     C     OTORBK        IFNE      *BLANKS                                                    CSD031
     C**********         MOVE      OTORBK        WORBK            12                          CGL029
     C                   MOVE      OTORBK        WORBK                                        CGL029
     C                   MOVE      *BLANKS       WORBKC
     C     WORBK         CAT       OTORBB        WORBKC
     C                   MOVEL     OTORBT        I#PT2
     C                   MOVEL     WORBKC        I#PTY2
     C                   ENDIF                                                                221478
     C*
     C     OTADDC        WHENEQ    'D'
     C                   MOVEL     OTDSTT        I#PT1
     C     @MBIN         IFEQ      'N'
     C     OTDSTT        ANDEQ     'G'
     C**********         MOVE      *BLANKS       WFLD2            18                          CGL029
     C                   MOVE      *BLANKS       WFLD2                                        CGL029
     C                   MOVEL     OTDST1        WFLD2
     C                   MOVE      BJSBRC        WFLD2
     C                   MOVEL     WFLD2         I#PTY1
     C                   ELSE
     C                   MOVEL     OTDST1        I#PTY1
     C                   END
     C                   MOVEL     OTPCCY        I#CCY
     C*****OTSNCO        IFNE      *ZEROS                                              221478 CSD031
     C     OTSNCO        IFNE      *BLANKS                                                    CSD031
     C                   MOVEL     OTSNCT        I#PT2
     C                   MOVEL     OTSNCO        I#PTY2
     C                   ENDIF                                                                221478
     C                   ENDSL
 
     C                   CALL      'FT0035'                             9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM                    W0DTA
     C                   PARM                    W0MSG           256
 
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'FT0035'      DBFILE
     C                   MOVEL     '34'          DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
 
     C                   ELSE
     C     OTODMT        IFNE      *BLANKS                                                    210873
     C     OTADDC        ANDEQ     'A'                                                        210873
     C                   MOVE      OTODMT        WDCUS2                                       210873
     C                   ELSE                                                                 210873
     C                   MOVEL     O#CUST        WDCUS2            6
     C                   ENDIF                                                                210873
     C                   END
 
     C** Check if recalculation of charges must take place
     C     @01506        IFEQ      'Y'
     C     SACTION       IFEQ      'I'                                                        227243
     C     WDCUS1        IFNE      WDCUS2
     C     OTSMCY        ORNE      SMCY
     C     OTSMAM        ORNE      SMAM
     C                   MOVE      'Y'           WRDFTC            1
     C                   END
     C                   ENDIF                                                                227243
 
     C                   ELSE
     C     SACTION       IFEQ      'I'                                                        227243
     C     WDCUS1        IFNE      WDCUS2
     C     OTPYTP        ORNE      PYTP
     C     OTPYST        ORNE      PYST
     C     OTSMAM        ORNE      SMAM
     C                   MOVE      'Y'           WRDFTC            1
     C                   END
     C                   ENDIF                                                                227243
     C                   END
 
     C                   END
 
      *  Process shadow post if new addition and not regular payment
      *  Or level incomplete i.e. insert of generated payment
      *
     C                   MOVEL     *BLANKS       ##ACHG
      *
     C     PYTP          IFNE      'RP'
     C     LVL1          ANDEQ     'Y'
     C                   Z-SUB     SMAM          ##SMAM
     C                   Z-SUB     PYAM          ##PYAM
     C                   If        (@CFT014 = 'Y') And (OPRCRM <> 0)            CFT014
     C                   Eval      ##PYAM = ##PYAM - OPRCRM                     CFT014
     C                   EndIf                                                  CFT014
     C**********         EXSR      SRADD                                                      213004
     C                   EXSR      SRADDRev                                                   213004
      *                                                                         185764
      * Reversal of charges are not done in all cases. Remove these conditions  185764
      * and allow reversal of charges for each  amend . Anyway,                 185764
      * if the same details are updated on the second call to SRSCHG, the       185764
      * Shadow posting update modules will cancel them out.                     185764
      *******************                                                       185764
      **If*charges*to*be*recalulated then reverse them out                      185764
      *******************                                                       185764
     C*****CDRO**********IFEQ      0                                            185764
     C*****OTCHTP********OREQ      'D'                                          185764
     C*****OTCHTP********IFEQ      'D'                                          185764
     C*****OTADDC********ORNE      ADDC                                         185764
     C*****OTSMCY********ANDNE     PCCY                                         185764
     C*****OTADDC********ORNE      ADDC                                         185764
     C*****OTSMCY********ANDNE     SPCCY                                        185764
     C*****OTPCCY********ORNE      PCCY                                         185764
     C*****OTADDC********ANDEQ     'D'                                          185764
     C*****OTSMCY********ORNE      SMCY                                         185764
     C*****OTADDC********ANDEQ     'A'                                          185764
     C*****WRDFTC********OREQ      'Y'                                          185764
      *
      *  Only mark as add charges after update if not delete
      *
     C     OTCHTP        IFNE      'D'
     C                   MOVEL     'Y'           ##ACHG            1
     C                   END
      *
      * Calculate charge amount (always debit)
      *
     C     TXCH          ADD       CQCH          ##CHGS
     C                   ADD       CSTA          ##CHGS
     C                   ADD       SPCH          ##CHGS
     C                   ADD       MSCH          ##CHGS
     C                   ADD       TRCM          ##CHGS
     C*
     C     @01494        IFEQ      'Y'
     C                   ADD       OPCHCM        ##CHGS
     C                   END
     C*
     C     @01499        IFEQ      'Y'
     C     @CFT009       ANDEQ     'N'                                          CFT009
     C     @CFT010       OREQ      'Y'                                          CFT009
     C                   ADD       OPVATT        ##CHGS
     C                   END
                                                                                CFT014
      * Extra charges                                                           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C**********         ADD       MISCC1        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC2        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC3        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC4        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC5        ##CHGS                         CFT009        245712
     C**********         ADD       SWSCCC        ##CHGS                         CFT009        245712
     C                   ADD       MISC01        ##CHGS                                       245712
     C                   ADD       MISC02        ##CHGS                                       245712
     C                   ADD       MISC03        ##CHGS                                       245712
     C                   ADD       MISC04        ##CHGS                                       245712
     C                   ADD       MISC05        ##CHGS                                       245712
     C                   ADD       SWSCHG        ##CHGS                                       245712
     C                   ENDIF                                                  CFT009
      *                                                                         CFT009
      ** Include Receiver's Charges remitted, if present.                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Select                                                 CFT014
     C***********        When      CDRO <> *Zero                                CFT014        CSD027
     C                   When      CDRO <> *BLANKS                              CFT014        CSD027
     C                   Eval      ##CHGS = ##CHGS + OPRBCQ                     CFT014
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     UMCCY2        IfNe      BJCYCD                                                     CFT120
     C                   Eval      ##CHGS = ##CHGS - OPRBCQ                                   CFT120
      *                                                                                       CFT120
      ** Convert Receiver's charges remitted from pay ccy to charge ccy                       CFT120
     C                   Clear                   P#0010                                       CFT120
     C                   Z-Add     OTPVDT        P#FRDT                                       CFT120
     C                   Z-Add     OTSLDT        P#TODT                                       CFT120
     C                   Movel     OTPCCY        P#FRCY                                       CFT120
     C                   Z-Add     OPRCRM        P#FRAM                                       CFT120
     C                   Movel     UMCCY2        P#TOCY                                       CFT120
     C                   Z-Add     0             P#TOAM                                       CFT120
     C                   Z-Add     0             P#RATE                                       CFT120
     C                   Call      'FT0010'                                                   CFT120
     C                   Parm                    P#0010                                       CFT120
      *                                                                                       CFT120
     C     P#RTCD        IfNe      *Blank                                                     CFT120
     C                   Movel     'FT0010  '    DBFILE                                       CFT120
     C                   Movel     '*CALL  '     DBKEY                                        CFT120
     C                   Z-Add     91            DBASE                                        CFT120
     C                   ExSr      *PSSR                                                      CFT120
     C                   Else                                                                 CFT120
     C                   Z-Add     P#TOAM        UMRCRM                                       CFT120
      *                                                                                       CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Eval      ##CHGS = ##CHGS + UMRCRM                                   CFT120
     C                   Endif                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   When      ADDC = 'A'                                   CFT014
     C                   Eval      ##CHGS = ##CHGS + OPRCSC                     CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
      *
     C     ##CHGS        IFNE      0
     C                   Z-SUB     ##CHGS        ##CHGS
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   EVAL      WRevAst = 'Y'                                              CRE020
     C                   ENDIF                                                                CRE020
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     OTCDRO        IFNE      *BLANKS                                                    CFT120
     C     OTCDRC        ANDNE     *BLANKS                                                    CFT120
     C**********         MOVEL     UMCCCY        UM#CCY                              CFT120 MD019850
     C                   MOVEL     OPCDRC        UM#CCY                                     MD019850
     C                   ENDIF                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C     OTPYTP        IFNE      'RP'                                                    AR1091503
     C                   EXSR      SRSCHG
     C                   ENDIF                                                             AR1091503
     C                   END
     C*******************END                                                    185764
     C*******************END                                                    185764
      *
     C                   END
      *
     C* IF AMEND AND ADD/DEDUCT INDICATOR HAS CHANGED,THEN
     C* CONVERT CHARGE VALUES IF NEEDED(ONLY IF CDRO BLANK) AND PAY
     C* AND SETTLE CCY DIFFER.
     C*
     C     OTCHTP        IFEQ      'A'
     C*****CDRO*****     ANDEQ     0                                                          CSD027
     C     CDRO          ANDEQ     *BLANKS                                                    CSD027
     C     OTADDC        IFNE      ADDC
     C     SMCY          ANDNE     PCCY
 
     C     OTPCCY        ORNE      PCCY
     C     OTADDC        ANDEQ     'D'
 
     C     OTSMCY        ORNE      SMCY
     C     OTADDC        ANDEQ     'A'
 
     C     WRDFTC        OREQ      'Y'
     C     OTSMAM        ORNE      SMAM
     C                   EXSR      CHARGE
     C                   END
     C                   END
 
      *****/copy*to*move*data*into*the*data*structure*fields*passed********                   189451
      ******as*a*parameter*to*the*window*controller************************                   189451
      *C*P**QWINDSRC*FT0040MOV1********************************************                   189451
      *
      *  /COPY for additional processing before updating OTPAYDD
      *
     C/COPY WNCPYSRC,FTOPAYUPDT
      *
      * Save original Settle amount for trailer update
     C                   Z-ADD     SMAM          OSMAM            13 0
      *
      * Update OTPAY record
     C                   Move      OPMSGR        OTOPMSGR                                   AR898165
     C                   Move      OPKPRT        OTOPKPRT                                   AR898165
     C                   Move      ValidPmnt     NewPmnt
      *                                                                                     BUG24776
      ** Check whether Settlement type was changed, if yes then update Pay Ref              BUG24776
      *                                                                                     BUG24776
     C     2             SUBST     PREF:14       SETT              2                        BUG24776
     C                   MOVE      STMT          STMTE             2                        BUG24776
     C*****OPIN*         IFEQ      'Y'                                             BUG24776 AR402776
     C*****STMTE         ANDNE     SETT                                            BUG24776 AR402776
     C     STMTE         IFNE      SETT                                                     AR402776
     C                   MOVE      STMTE         PREF                                       BUG24776
                                                                                            MD054037
      ** Update pay ref on OTPAYDQD                                                         MD054037
     C     OTPREF        CHAIN     OTPAYQD0                           99                    MD054037
                                                                                            MD054037
     C                   IF        *IN99 = *OFF                                             MD054037
     C                   MOVE      STMTE         OTPREF                                     MD054037
     C                   UPDATE    OTPAYQD0                                                 MD054037
     C                   ELSE                                                               MD054037
     C                   MOVEL     'OTPAYDQD'    DBFILE                                     MD054037
     C                   MOVEL     '438'         DBASE                                      MD054037
     C                   MOVEL     'OTPREF'      DBKEY                                      MD054037
     C                   EXSR      *PSSR                                                    MD054037
     C                   ENDIF                                                              MD054037
     C                   ENDIF                                                              BUG24776
 
     C/COPY WNCPYSRC,FTH00546
     C* IF AMEND CLEAR AUTHORISE PROF 1
     C     OTCHTP        IFEQ      'A'
     C                   MOVE      *BLANK        AUP1
     C                   END
     C*
     C/COPY WNCPYSRC,FTH00547
      * If delete
     C     OTCHTP        IFEQ      'D'
     C                   MOVE      'C'           RECI
      ** Front Office ID                                                        CAP013
     C                   EVAL      FRNT=OTFRNT                                  CAP013
     C                   END
 
      ** Generate timestamp
     C                   CALLB     'ZAGENTMSTM'
     C                   PARM                    Timestamp
 
     C                   Eval      TMST = Timestamp
     C                   Eval      OTTMESTMP = TimeStamp                                    BUG18500
 
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CAP211
      *                                                                                       CAP211
     C                   IF        PUser = *Blanks                                            CAP211
     C                   EVAL      AUP1 = INUSR1                                              CAP211
     C                   ELSE                                                                 CAP211
     C                   EVAL      AUP1 = PUser                                               CAP211
     C                   ENDIF                                                                CAP211
     C                   EVAL      AUIN = 'Y'                                                 CAP211
      *                                                                                       CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                     MD030940
     C                   EVAL      DATE = 0                                                 MD030940
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPAYDC21
     C                   UPDATE    OTPAYDDF
     C/COPY WNCPYSRC,FTH00103
                                                                                CFT014
      ** If Batch Authorsation update/add record                                CFT014
                                                                                CFT014
      ** Only maintain OTPAYXPD if either CFT003, CFT009 and CFT014 is on.                    202150
                                                                                              202150
     C                   If        @CFT003 = 'Y'                                              202150
     C                             OR @CFT009 = 'Y'                                           202150
     C                             OR @CFT014 = 'Y'                                           202150
                                                                                              202150
     C                   If        WRTVD = 'N'                                  CFT014
     C                   Eval      OPPREF = OTPREF                              CFT014
     C                   Eval      OPBJPR = *Blanks                             CFT014
     C                   Eval      OPAUTO = 'N'                                 CFT014
     C/COPY WNCPYSRC,FTH00202
     C                   Move      OTSTMT        OPSETM                         CFT014
                                                                                CFT014
      ** Set MT103 fields                                                       CFT014
                                                                                CFT014
     C                   If        @CFT014 <> 'Y'                               CFT014
     C                             AND @CFT009 <> 'Y'                           CFT009
     C                   ExSr      SrSetField                                   CFT014
                                                                                CFT014
      ** Generate timestamp                                                     CFT014
                                                                                CFT014
     C                   CallB     'ZAGENTMSTM'                                 CFT014
     C                   Parm                    Timestamp                      CFT014
     C                   Eval      OPTMST = Timestamp                           CFT014
                                                                                              CSC011
      ** If CSC011 is installed, supply a Front Office ID for the                             CSC011
      ** transaction even if it originated from SIN module.                                   CSC011
                                                                                              CSC011
     C                   IF        @CSC011 = 'Y'                                              CSC011
     C                   IF        OPFRNT = *BLANKS                                           CSC011
     C                   EVAL      OPFRNT = 'MD' + OPPREF                                     CSC011
     C                   ENDIF                                                                CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   Write     OTPAYXDF                             98      CFT014
                                                                                CFT014
      ** Error writing record                                                   CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '040'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Movel     OTPREF        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   Else                                                   CFT014
                                                                                CFT014
      ** If existing extension record, update                                   CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                             OR @CFT009 = 'Y'                             CFT009
     C                   Eval      O2PREF = OTPREF                                          MD054037
     C                   MOVE      STMT          O2SETM                                     MD054037
     C                   Eval      NewPmntB = ValidPmntB                        CFT014
     C**********         EndIf                                                  CFT014 195566
     C/COPY WNCPYSRC,FTH00421
     C                   Eval      OPAUTO = 'N'                                 CFT014
     C/COPY WNCPYSRC,FTH00203
                                                                                CFT014
      ** If delete                                                              CFT014
                                                                                CFT014
     C                   If        OTCHTP = 'D'                                 CFT014
     C                   Eval      OPRECI = 'C'                                 CFT014
     C                   Eval      OPFRNT = O2FRNT                              CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Generate timestamp                                                     CFT014
                                                                                CFT014
     C                   CallB     'ZAGENTMSTM'                                 CFT014
     C                   Parm                    Timestamp                      CFT014
     C                   Eval      OPTMST = Timestamp                           CFT014
     C     2             SUBST     OPPREF:14     SETT                                       BUG24776
     C                   MOVE      STMT          STMTE                                      BUG24776
     C*****OPIN*         IFEQ      'Y'                                             BUG24776 AR402776
     C*****STMTE         ANDNE     SETT                                            BUG24776 AR402776
     C     STMTE         IFNE      SETT                                                     AR402776
     C                   MOVE      STMTE         OPPREF                                     BUG24776
     C                   MOVE      OTSTMT        OPSETM                                     AR402776
     C                   ENDIF                                                              BUG24776
     C                   Update    OTPAYXDF                             98      CFT014
                                                                                CFT014
      ** Error updating record                                                  CFT014
                                                                                CFT014
     C                   If        *IN98 = True                                 CFT014
     C                   Movel     'OTPAYXL0'    DBFILE                         CFT014
     C                   Movel     '041'         DBASE                          CFT014
     C                   Movel     *Blanks       DBKEY                          CFT014
     C                   Movel     OTPREF        DBKEY                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  195566
                                                                                              202150
     C                   Endif                                                                202150
     C/COPY WNCPYSRC,FTH00422
      *
      *  Process shadow post if not reversal and not regular payment
      *
     C     OTPYTP        IFNE      'RP'
     C     OTCHTP        ANDNE     'D'
     C                   Z-ADD     OTSMAM        ##SMAM
     C                   Z-ADD     OTPYAM        ##PYAM
     C                   If        (@CFT014 = 'Y') And (OPRCRM <> 0)            CFT014
     C                   Eval      ##PYAM = ##PYAM + OPRCRM                     CFT014
     C                   EndIf                                                  CFT014
     C                   EXSR      SRADD
      *
      * If charges to be recalulated then add them in
      *
     C     ##ACHG        IFEQ      'Y'
      *
      * Calculate charge amount (always debit)
      *
     C     OTTXCH        ADD       OTCQCH        ##CHGS
     C                   ADD       OTCSTA        ##CHGS
     C                   ADD       OTSPCH        ##CHGS
     C                   ADD       OTMSCH        ##CHGS
     C                   ADD       OTTRCM        ##CHGS
     C*
     C     @01494        IFEQ      'Y'
     C                   ADD       OTOPCHCM      ##CHGS
     C                   END
     C*
     C     @01499        IFEQ      'Y'
     C     @CFT009       ANDEQ     'N'                                          CFT009
     C     @CFT010       OREQ      'Y'                                          CFT009
     C                   ADD       OTOPVATT      ##CHGS
     C                   END
                                                                                CFT009
      * Extra charges                                                           CFT009
                                                                                CFT009
     C                   IF        @CFT009 = 'Y'                                CFT009
     C**********         ADD       MISCC1        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC2        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC3        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC4        ##CHGS                         CFT009        245712
     C**********         ADD       MISCC5        ##CHGS                         CFT009        245712
     C**********         ADD       SWSCCC        ##CHGS                         CFT009        245712
     C                   ADD       MISC01        ##CHGS                                       245712
     C                   ADD       MISC02        ##CHGS                                       245712
     C                   ADD       MISC03        ##CHGS                                       245712
     C                   ADD       MISC04        ##CHGS                                       245712
     C                   ADD       MISC05        ##CHGS                                       245712
     C                   ADD       SWSCHG        ##CHGS                                       245712
     C                   ENDIF                                                  CFT009
                                                                                CFT014
      ** Include Receiver's Charges remitted, if present.                       CFT014
                                                                                CFT014
     C                   If        @CFT014 = 'Y'                                CFT014
     C                   Select                                                 CFT014
     C***********        When      CDRO <> *Zero                                CFT014        CSD027
     C                   When      CDRO <> *BLANKS                              CFT014        CSD027
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     UMCCY2        IfNe      BJCYCD                                                     CFT120
     C                   Eval      ##CHGS = ##CHGS - OPRBCQ                                   CFT120
      *                                                                                       CFT120
      ** Convert Receiver's charges remitted from pay ccy to charge ccy                       CFT120
     C                   Clear                   P#0010                                       CFT120
     C                   Z-Add     OTPVDT        P#FRDT                                       CFT120
     C                   Z-Add     OTSLDT        P#TODT                                       CFT120
     C                   Movel     OTPCCY        P#FRCY                                       CFT120
     C                   Z-Add     OPRCRM        P#FRAM                                       CFT120
     C                   Movel     UMCCY2        P#TOCY                                       CFT120
     C                   Z-Add     0             P#TOAM                                       CFT120
     C                   Z-Add     0             P#RATE                                       CFT120
     C                   Call      'FT0010'                                                   CFT120
     C                   Parm                    P#0010                                       CFT120
      *                                                                                       CFT120
     C     P#RTCD        IfNe      *Blank                                                     CFT120
     C                   Movel     'FT0010  '    DBFILE                                       CFT120
     C                   Movel     '*CALL  '     DBKEY                                        CFT120
     C                   Z-Add     91            DBASE                                        CFT120
     C                   ExSr      *PSSR                                                      CFT120
     C                   Else                                                                 CFT120
     C                   Z-Add     P#TOAM        UMRCRM                                       CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C                   Eval      ##CHGS = ##CHGS + UMRCRM                                   CFT120
     C                   Endif                                                                CFT120
     C                   ENDIF                                                                CFT120
      *                                                                                       CFT120
     C                   Eval      ##CHGS = ##CHGS + OPRBCQ                     CFT014
     C                   When      ADDC = 'A'                                   CFT014
     C                   Eval      ##CHGS = ##CHGS + OPRCSC                     CFT014
     C                   EndSl                                                  CFT014
     C                   EndIf                                                  CFT014
      *
     C     ##CHGS        IFNE      0
     C     OTPYTP        ANDNE     'RP'                                                    AR1091503
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   MOVEL     UMCCY2        UM#CCY                                       CFT120
     C                   ENDIF                                                                CFT120
     C                   EXSR      SRSCHG
     C                   END
     C                   END
      *
     C                   END
      *
      * Update Incoming Message FT Trans
      *
     C     OTOPMSGR      IFNE      0
      *
     C     OTCHTP        IFEQ      'A'
     C/COPY WNCPYSRC,FTH00204
     C                   MOVEL     'MIN0030'     W0FLAG
     C/COPY WNCPYSRC,FTH00205
     C                   MOVEL     'MIN0191'     W0LMSG
     C                   ELSE
     C                   MOVEL     'MIN0031'     W0FLAG
     C                   MOVEL     'MIN0192'     W0LMSG
     C                   END
     C                   MOVEL     *BLANKS       PNWRK             6
      *
     C                   EXSR      SRINFT
      *
     C                   END
      *
     C     AMDEND        ENDSR
      *****************************************************************                       CSC011
      /Title SR/SRLOGTRAN                                                                     CSC011
      *****************************************************************                       CSC011
      *                                                               *                       CSC011
      * SRLOGTRAN  - Write Transaction to Log file.                   *                       CSC011
      *                                                               *                       CSC011
      * Called By: Main Routine                                       *                       CSC011
      *                                                               *                       CSC011
      * Calls:                                                        *                       CSC011
      * APLOGTRAN   - AP Log Transactions from the Support Database   *                       CSC011
      *                                                               *                       CSC011
      *****************************************************************                       CSC011
                                                                                              CSC011
     C     SRLOGTRAN     BEGSR                                                                CSC011
                                                                                              CSC011
      ** Call log module.                                                                     CSC011
                                                                                              CSC011
     C                   CALLB     'FTOPAYLOG'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    NewPmnt                                      CSC011
     C                   PARM                    NewPmntB                                     CSC011
     C                   PARM                    SDFTFR                                       CSC011
     C                   PARM                    Val@Fields                                   CSC011
     C                   PARM      *BLANKS       TRANSDTL                                     CSC011
                                                                                              CSC011
      ** No error, write the transaction via APLOGTRAN module.                                CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut = *BLANKS                                       CSC011
     C                   EVAL      APTGTTYPE = 'FTOPAY'                                       CSC011
     C                   EVAL      APFOTRANID = OTFRNT                                        CSC011
     C                   EVAL      APRPRLOCN = OTREPA                                         CSC011
     C                   EVAL      APUSERID   = PSUser                                        CSC011
     C                   EVAL      APMIDUSR   = PSUser                                        CSC011
                                                                                              CSC011
     C                   CALLB     'APLOGTRAN'                                                CSC011
     C                   PARM      *BLANKS       RetCodeOut                                   CSC011
     C                   PARM                    APHEAD                                       CSC011
     C                   PARM                    TRANSDTL                                     CSC011
     C                   PARM      *BLANKS       PTIMESTMP                                    CSC011
     C                   PARM      OTPREF        PREFERENCE                                   CSC011
     C                   PARM      *BLANKS       PAREFERENCE                                  CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Error encountered.                                                                   CSC011
                                                                                              CSC011
     C                   IF        RetCodeOut <> *BLANKS                                      CSC011
     C                   EVAL      RetCodeIn = '*ERROR'                                       CSC011
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
     C                   ENDSR                                                                CSC011
      *****************************************************************         CFT014
      /Title Sr/SUBRCG                                                          CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SUBRCG   - Default Receiver's Charges Remitted in Pay Ccy  *         CFT014
      *               from network                                    *         CFT014
      *                                                               *         CFT014
      * Called By: INSERT subroutine                                  *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SUBRCG        BegSr                                                  CFT014
      *                                                                                       CFT120
      ** Use CDRO currency if present, if not then use settlement currency                    CFT120
      *                                                                                       CFT120
     C                   IF        CFT120 = 'Y'                                               CFT120
     C     OTCDRO        IfNe      *Blanks                                                    CFT120
     C                   Move      UMCCY2        UM#CCY                                       CFT120
     C                   Else                                                                 CFT120
     C                   Move      OTSMCY        UM#CCY                                       CFT120
     C                   Endif                                                                CFT120
     C                   ENDIF                                                                CFT120
                                                                                CFT014
     C                   Z-Add     0             W#PCHG           12 0          CFT014
                                                                                CFT014
      ** Convert sum of charges to pay currency                                 CFT014
                                                                                CFT014
     C     O2RCCN        IfNe      OTSMCY                                       CFT014
     C     @TOTCHG       AndGt     0                                            CFT014
                                                                                CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Z-Add     OTSLDT        P#FRDT                         CFT014
     C                   Z-Add     OTSLDT        P#TODT                         CFT014
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Movel     UM#CCY        P#FRCY                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   Movel     OTSMCY        P#FRCY                         CFT014
     C                   ENDIF                                                                CFT120
     C                   Z-Add     @TOTCHG       P#FRAM                         CFT014
     C                   Movel     OTPCCY        P#TOCY                         CFT014
     C                   Z-Add     0             P#TOAM                         CFT014
     C                   Z-Add     0             P#RATE                         CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
     C     P#RTCD        IfNe      *Blank                                       CFT014
     C                   Movel     'FT0010  '    DBFILE                         CFT014
     C                   Movel     '*CALL  '     DBKEY                          CFT014
     C                   Z-Add     42            DBASE                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     P#TOAM        W#PCHG                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Select                                                 CFT014
                                                                                CFT014
      ** Network Receiver's Charges currency is = to pay currency               CFT014
                                                                                CFT014
     C     O2RCCN        WhenEq    OTPCCY                                       CFT014
     C                   Z-Add     O2RCNW        O2RCRM                         CFT014
                                                                                CFT014
      ** If receiver's charges is greater than our charges,                     CFT014
                                                                                CFT014
     C     O2RCRM        IfGt      W#PCHG                                       CFT014
     C     O2RCRM        Sub       W#PCHG        O2RCRM                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Network Receiver's Charges currency is = to settle ccy                 CFT014
                                                                                CFT014
     C     O2RCCN        WhenEq    OTSMCY                                       CFT014
     C     CFT120        ANDEQ     'N'                                                        CFT120
      *                                                                                       CFT120
      ** Network Receiver's Charges currency is = charge currency                             CFT120
      *                                                                                       CFT120
     C     O2RCCN        OREQ      UM#CCY                                                     CFT120
     C     CFT120        ANDEQ     'Y'                                                        CFT120
     C                   Z-Add     O2RCNW        O2RCSC                         CFT014
     C     O2RCSC        IfGt      @TOTCHG                                      CFT014
     C     O2RCSC        Sub       @TOTCHG       O2RCSC                         CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
      ** Convert to pay currency,                                               CFT014
                                                                                CFT014
     C     O2RCSC        IfGt      0                                            CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Z-Add     OTSLDT        P#FRDT                         CFT014
     C                   Z-ADD     OTSLDT        P#TODT                         CFT014
     C                   IF        CFT120 = 'Y'                                               CFT120
     C                   Movel     UM#CCY        P#FRCY                                       CFT120
     C                   ELSE                                                                 CFT120
     C                   Movel     OTSMCY        P#FRCY                         CFT014
     C                   ENDIF                                                                CFT120
     C                   Z-Add     O2RCSC        P#FRAM                         CFT014
     C                   Movel     OTPCCY        P#TOCY                         CFT014
     C                   Z-Add     0             P#TOAM                         CFT014
     C                   Z-Add     0             P#RATE                         CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
     C     P#RTCD        IfNe      *Blank                                       CFT014
     C                   Movel     'FT0010  '    DBFILE                         CFT014
     C                   Movel     '*CALL  '     DBKEY                          CFT014
     C                   Z-Add     43            DBASE                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     P#TOAM        O2RCRM                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   Other                                                  CFT014
                                                                                CFT014
      ** Calculate receiver's charges network in payment currency               CFT014
                                                                                CFT014
     C                   Clear                   P#0010                         CFT014
     C                   Z-Add     OTSLDT        P#FRDT                         CFT014
     C                   Z-Add     OTPVDT        P#TODT                         CFT014
     C                   Movel     O2RCCN        P#FRCY                         CFT014
     C                   Z-Add     O2RCNW        P#FRAM                         CFT014
     C                   Movel     OTPCCY        P#TOCY                         CFT014
     C                   Z-Add     0             P#TOAM                         CFT014
     C                   Z-Add     0             P#RATE                         CFT014
     C                   Call      'FT0010'                                     CFT014
     C                   Parm                    P#0010                         CFT014
                                                                                CFT014
     C     P#RTCD        IfNe      *Blank                                       CFT014
     C                   Movel     'FT0010  '    DBFILE                         CFT014
     C                   Movel     '*CALL  '     DBKEY                          CFT014
     C                   Z-Add     44            DBASE                          CFT014
     C                   ExSr      *PSSR                                        CFT014
     C                   Else                                                   CFT014
     C                   Z-Add     P#TOAM        O2RCRM                         CFT014
                                                                                CFT014
      ** If receiver's charges is greater than our charges,                     CFT014
                                                                                CFT014
     C     O2RCRM        IfGt      W#PCHG                                       CFT014
     C     O2RCRM        Sub       W#PCHG        O2RCRM                         CFT014
     C                   EndIf                                                  CFT014
     C                   EndIf                                                  CFT014
                                                                                CFT014
     C                   EndSl                                                  CFT014
                                                                                CFT014
     C     ExSBRC        EndSr                                                  CFT014
                                                                                CFT014
      *****************************************************************         CFT014
      /Title Sr/SrSetField                                                      CFT014
      *****************************************************************         CFT014
      *                                                               *         CFT014
      * SR/SrSetField - Setup MT103 fields before update              *         CFT014
      *                                                               *         CFT014
      * Called By: INSERT and AMEND subroutines                       *         CFT014
      *                                                               *         CFT014
      * Calls: None                                                   *         CFT014
      *                                                               *         CFT014
      *****************************************************************         CFT014
                                                                                CFT014
     C     SrSetField    BegSr                                                  CFT014
                                                                                CFT014
     C                   Eval      OPBOCD = *Blank                              CFT014
     C                   Eval      OPICD1 = *Blank                              CFT014
     C                   Eval      OPICD2 = *Blank                              CFT014
     C                   Eval      OPICD3 = *Blank                              CFT014
     C                   Eval      OPICD4 = *Blank                              CFT014
     C                   Eval      OPICD5 = *Blank                              CFT014
     C                   Eval      OPTTCD = *Blank                              CFT014
     C                   Eval      OPTRIT = *Blank                              CFT014
     C                   Eval      OPTRI1 = *Blank                              CFT014
     C                   Eval      OPTRI2 = *Blank                              CFT014
     C                   Eval      OPTRI3 = *Blank                              CFT014
     C                   Eval      OPTRI4 = *Blank                              CFT014
     C                   Eval      OPTRI5 = *Blank                              CFT014
     C                   Eval      OPRRP1 = *Blank                              CFT014
     C                   Eval      OPRRP2 = *Blank                              CFT014
     C                   Eval      OPRRP3 = *Blank                              CFT014
     C                   Eval      OPFRNT = *Blank                              CFT014
     C                   Eval      OPREPA = *Blank                              CFT014
     C                   Eval      OPSCC1 = *Blank                              CFT014
     C                   Eval      OPSCC2 = *Blank                              CFT014
     C                   Eval      OPSCC3 = *Blank                              CFT014
     C                   Eval      OPSCC4 = *Blank                              CFT014
     C                   Eval      OPSCC5 = *Blank                              CFT014
     C                   Eval      OPSCH1 = *Zero                               CFT014
     C                   Eval      OPSCH2 = *Zero                               CFT014
     C                   Eval      OPSCH3 = *Zero                               CFT014
     C                   Eval      OPSCH4 = *Zero                               CFT014
     C                   Eval      OPSCH5 = *Zero                               CFT014
     C                   Eval      OPOEXR = *Zero                               CFT014
     C                   Eval      OPRCRM = *Zero                               CFT014
     C                   Eval      OPRBCQ = *Zero                               CFT014
     C                   Eval      OPRCSC = *Zero                               CFT014
     C                   Eval      OPRCSQ = *Zero                               CFT014
     C                   Eval      OPRCNW = *Zero                               CFT014
     C                   Eval      OPSCLE = *Zero                               CFT009
                                                                                CFT014
     C                   EndSr                                                  CFT014
                                                                                CFT014
     C****************************************************************
      /EJECT
      *****************************************************************
      *  SRCLR    : Clear all positions in store                      *
      *****************************************************************
     CSR   SRCLR         BEGSR
 
     C                   MOVE      'Y'           #NOUPD            1
      *  Clear arrays in AOSPOSU0
     C                   CLEAR                   C#DTA
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*CLEAR  '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBFILE
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     '*CALL   '    DBKEY
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTOPAYDC03
 
     CSR                 ENDSR
     C****************************************************************
     C/EJECT                                                                                  196813
      *****************************************************************                       196813
      *                                                               *                       196813
      *   SRMsgDel - Remove electronic message from the Outstanding   *                       196813
      *              Reserved Messages file after it has been         *                       196813
      *              inserted                                         *                       196813
      *                                                               *                       196813
      *****************************************************************                       196813
      *                                                                                       196813
     C     SRMsgDel      BEGSR                                                                196813
      *                                                                                       196813
      ** The electronic message that was just inserted must be removed                        196813
      ** from the file.                                                                       196813
      ** Set up message ref. and part nbr.                                                    196813
      *                                                                                       196813
     C                   Z-ADD     OTOPMSGR      PMsgr                                        196813
     C                   Z-ADD     OTOPKPRT      PKprt                                        196813
      *                                                                                       196813
     C                   CALL      'ME1070'                             9090                  196813
     C                   PARM      '*DEL   '     PActC             7                          196813
     C                   PARM                    PMsgr             8 0                        196813
     C                   PARM                    PKprt             3 0                        196813
     C                   PARM                    PMor             28                          196813
     C                   PARM                    PMir             28                          196813
     C                   PARM      *BLANKS       PRtn              7                          196813
      *                                                                                       196813
      ** Error occurred.                                                                      196813
      *                                                                                       196813
     C                   IF        *IN90 = '1' OR PRtn = '*ERROR*'                            196813
     C                   MOVEL     '*CALL'       DBKey                                        196813
     C                   MOVEL     'ME1070'      DBFile                                       196813
     C                   MOVEL     012           DBase                                        196813
     C                   EXSR      *PSSR                                                      196813
     C                   ENDIF                                                                196813
      *                                                                                       196813
     C                   ENDSR                                                                196813
      *                                                                                       196813
     C/EJECT
      *****************************************************************
      *  SRINFT   : Update Incoming Message FT Transaction Status     *
      *             File record                                       *
      *****************************************************************
     CSR   SRINFT        BEGSR
 
     C                   CLEAR                   INFT
 
     C     OTORBT        IFNE      *BLANKS
     C**********         MOVEL     @ORBDS        FTFRWR           18                          CGL029
     C                   MOVEL     @ORBDS        FTFRWR                                       CGL029
     C                   ELSE
     C                   MOVEL     @ORCDS        FTFRWR
     C                   END
     C     OTSNCT        IFNE      *BLANKS
     C**********         MOVEL     @SNCDS        FTTOWR           18                          CGL029
     C                   MOVEL     @SNCDS        FTTOWR                                       CGL029
     C                   ELSE
     C                   MOVEL     @DSTDS        FTTOWR
     C                   END
 
     C                   Z-ADD     OTOPMSGR      FTMSGR                         Unique Ref.
     C                   Z-ADD     OTOPKPRT      FTKPRT                         Part No.
     C                   MOVEL     OTBRCA        FTBRCA                         Branch Code
     C                   MOVEL     W0FLAG        FTOTFG                         Outgoing Flag
     C                   MOVEL     OTPREF        FTOPRF                         Outg. Pay. Ref
     C                   MOVEL     FTFRWR        FTFRGL                         Funds From
     C                   MOVEL     FTTOWR        FTTOGL                         Funds To
 
     C                   MOVEL     W0LMSG        W2LMSG                         Log file Msg ID
     C                   MOVEL     PNWRK         W2NWRK                         Network
     C                   MOVEL     'FTOPAYUPD'   ##PGM            10
      *                                                                                       CSW220
      ** Update MT199 Flag on reverse                                                         CSW220
      *                                                                                       CSW220
     C                   IF        CSW220 = 'Y' AND                                           CSW220
     C                             OTCHTP = 'D' AND                                           CSW220
     C                             FTM199 <> 'Z'                                              CSW220
     C                   EVAL      FTM199 = *BLANKS                                           CSW220
     C                   ENDIF                                                                CSW220
 
      *  N.B. Audit Stamp details are determined in called program
      *  Set up data to be passed using the rcd format data structure
 
     C                   CALL      'ME1050'                             90
     C                   PARM      '*FT OUT '    W2ACT             8
     C                   PARM      ##PGM         W2CPGM           10
     C                   PARM                    W2NWRK            6
     C                   PARM                    W2LMSG            7
     C                   PARM                    INFT
     C                   PARM      *BLANKS       W2RTN             7
      *
      *  If return with an error (LR seton in called program) then
      *  process for database error.
      *
     C     *IN90         IFEQ      '1'
     C     W2RTN         OREQ      '*ERROR*'
     C                   MOVEL     'ME1050'      DBKEY
     C                   MOVEL     '905'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
      *
     CSR                 ENDSR
     C/EJECT
      *****************************************************************
      *  SRADD    : Add shadow positions to store                     *
      *****************************************************************
     CSR   SRADD         BEGSR
 
      *  Define settle and pay amounts
     C     *LIKE         DEFINE    SMAM          ##SMAM
     C     *LIKE         DEFINE    PYAM          ##PYAM
      *
      *  Move fields to C#DTA structure and call AOSPOSU0
      *
      *         S E T T L E    I N S T R U C T I O N S
      *
      *  Only execute if Outgoing Payment not generated
      *
     C     OTOPIN        IFNE      'Y'
     C                   CLEAR                   C#DTA
     C                   MOVE      *BLANKS       PIBAN            34                        BUG15042
     C     OTORBT        IFNE      *BLANKS
     C                   MOVEL     OTORBT        C#ATYP
     C                   MOVEL     OTORBK        C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     OTORBB        C#BRCA
     C                   ELSE
     C                   MOVEL     OTORCT        C#ATYP
     C                   IF        %SUBST(OTORC1:1:1) = '/'                                   CFT032
     C**********         EVAL      C#ACCT = %SUBST(OTORC1:2)                         CFT032 BUG15042
     C                   EVAL      PIBAN = %SUBST(OTORC1:2)                                 BUG15042
     C                   ELSE                                                                 CFT032
     C**********         MOVEL     OTORC1        C#ACCT                                     BUG15042
     C                   MOVEL     OTORC1        PIBAN                                      BUG15042
     C                   ENDIF                                                                CFT032
      *                                                                                     BUG15042
     C     OTORCT        IFEQ      'I'                                                      BUG15042
     C                   CALL      'AOIBANR4'                                               BUG15042
     C                   PARM                    @RTCD             7                        BUG15042
     C                   PARM      '*KEY   '     @OPTN             7                        BUG15042
     C                   PARM                    PIBAN                                      BUG15042
     C     P@ACCT        PARM      *BLANKS       DSSDY                                      BUG15042
      *                                                                                     BUG15042
     C     @RTCD         IFEQ      *BLANKS                                                  BUG15042
     C     P@CNUM        CAT(P)    P@CCY         PIBAN                                      BUG15042
     C                   CAT       P@ACOD:0      PIBAN                                      BUG15042
     C                   CAT       P@ACSQ:0      PIBAN                                      BUG15042
     C                   CAT       P@BRCA:0      PIBAN                                      BUG15042
     C                   ENDIF                                                              BUG15042
     C                   ENDIF                                                              BUG15042
      *                                                                                     BUG15042
     C                   MOVEL     PIBAN         C#ACCT                                     BUG15042
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END
     C                   Z-ADD     OTSLDT        C#VDAT
      *
      * Set posting date according to FT Control Data
      *
     C     @PDTI         IFEQ      'I'
     C                   Z-ADD     BJRDNB        C#PSTD
     C                   ELSE
     C     @PDTI         IFEQ      'E'
     C                   Z-ADD     OTSLDT        C#PSTD
     C                   ELSE
     C     OTSLDT        IFLT      OTPVDT
     C                   Z-ADD     OTSLDT        C#PSTD
     C                   ELSE
     C                   Z-ADD     OTPVDT        C#PSTD
     C                   END
     C                   END
     C                   END
      *
     C                   MOVEL     'I'           C#IO
     C                   MOVEL     OTSMCY        C#CCY
     C                   MOVEL     OTPYTP        C#TRYP
     C                   MOVEL     OTPREF        C#PREF
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     OTPREF        C#NARR                                       CRE020
     C                   Z-ADD     1             C#CHQN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-ADD     ##SMAM        C#AMT
     C                   MOVEL     'FT'          C#MOD
     C                   MOVEL     '01'          C#OLRC
     C                   MOVEL     @FTOV         C#FTOV
     C                   MOVEL     'Y'           C#RPST
     C                   Z-ADD     10            C#RPNB
     C                   MOVEL     'D'           C#RTYP
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTH00393
      *
      *  Call AOSPOSU0
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBKEY
     C                   MOVEL     '902'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTH00423
     C                   END
     C/COPY WNCPYSRC,FTOPAYDC04
      *
      *         P A Y          I N S T R U C T I O N S
      *
     C                   CLEAR                   C#DTA
     C     OTSNCT        IFNE      *BLANKS
     C                   MOVEL     OTSNCT        C#ATYP
     C                   MOVEL     OTSNCO        C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ELSE
     C                   MOVEL     OTDSTT        C#ATYP
     C                   MOVEL     OTDST1        C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END
     C                   Z-ADD     OTPVDT        C#VDAT
      *
      * Set posting date according to FT Control Data
      *
     C     @PDTI         IFEQ      'I'
     C                   Z-ADD     BJRDNB        C#PSTD
     C                   ELSE
     C     @PDTI         IFEQ      'E'
     C                   Z-ADD     OTPVDT        C#PSTD
     C                   ELSE
     C     OTSLDT        IFLT      OTPVDT
     C                   Z-ADD     OTSLDT        C#PSTD
     C                   ELSE
     C                   Z-ADD     OTPVDT        C#PSTD
     C                   END
     C                   END
     C                   END
      *
     C                   MOVEL     'O'           C#IO
     C                   MOVEL     OTPCCY        C#CCY
     C                   MOVEL     OTPYTP        C#TRYP
     C                   MOVEL     OTPREF        C#PREF
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     OTPREF        C#NARR                                       CRE020
     C                   Z-ADD     2             C#CHQN                                       CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-SUB     ##PYAM        C#AMT
     C                   MOVEL     'FT'          C#MOD
     C                   MOVEL     '01'          C#OLRC
     C                   MOVEL     @FTOV         C#FTOV
     C                   MOVEL     'Y'           C#RPST
     C                   Z-ADD     20            C#RPNB
     C                   MOVEL     'C'           C#RTYP
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTH00508
      *
      *  Call AOSPOSU0
      *
     C                   CALLB     'AOSPOSU0'                           9090
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBKEY
     C                   MOVEL     '903'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTOPAYDC05
 
     CSR                 ENDSR
      *****************************************************************
     C/EJECT                                                                                  213004
      *****************************************************************                       213004
      *  SRADDRev : For Reversal processing, use Original Fields      *                       213004
      *             from OTPAYDD.                                     *                       213004
      *****************************************************************                       213004
     CSR   SRADDRev      BEGSR                                                                213004
                                                                                              213004
      *  Define settle and pay amounts                                                        213004
     C     *LIKE         DEFINE    SMAM          ##SMAM                                       213004
     C     *LIKE         DEFINE    PYAM          ##PYAM                                       213004
      *                                                                                       213004
      *  Move fields to C#DTA structure and call AOSPOSU0                                     213004
      *                                                                                       213004
      *         S E T T L E    I N S T R U C T I O N S                                        213004
      *                                                                                       213004
      *  Only execute if Outgoing Payment not generated                                       213004
      *                                                                                       213004
     C     OPIN          IFNE      'Y'                                                        213004
     C                   CLEAR                   C#DTA                                        213004
     C                   MOVE      *BLANKS       PIBAN            34                        BUG15042
     C     ORBT          IFNE      *BLANKS                                                    213004
     C                   MOVEL     ORBT          C#ATYP                                       213004
     C                   MOVEL     ORBK          C#ACCT                                       213004
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     ORBB          C#BRCA                                       213004
     C                   ELSE                                                                 213004
     C                   MOVEL     ORCT          C#ATYP                                       213004
     C                   IF        %SUBST(ORC1:1:1) = '/'                                   BUG15042
     C                   EVAL      PIBAN = %SUBST(ORC1:2)                                   BUG15042
     C                   ELSE                                                               BUG15042
     C**********         MOVEL     ORC1          C#ACCT                             213004  BUG15042
     C                   MOVEL     ORC1          PIBAN                                      BUG15042
     C                   ENDIF                                                              BUG15042
      *                                                                                     BUG15042
     C     ORCT          IFEQ      'I'                                                      BUG15042
     C                   CALL      'AOIBANR4'                                               BUG15042
     C                   PARM                    @RTCD             7                        BUG15042
     C                   PARM      '*KEY   '     @OPTN             7                        BUG15042
     C                   PARM                    PIBAN                                      BUG15042
     C     P@ACCT        PARM      *BLANKS       DSSDY                                      BUG15042
      *                                                                                     BUG15042
     C     @RTCD         IFEQ      *BLANKS                                                  BUG15042
     C     P@CNUM        CAT(P)    P@CCY         PIBAN                                      BUG15042
     C                   CAT       P@ACOD:0      PIBAN                                      BUG15042
     C                   CAT       P@ACSQ:0      PIBAN                                      BUG15042
     C                   CAT       P@BRCA:0      PIBAN                                      BUG15042
     C                   ENDIF                                                              BUG15042
     C                   ENDIF                                                              BUG15042
      *                                                                                     BUG15042
     C                   MOVEL     PIBAN         C#ACCT                                     BUG15042
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END                                                                  213004
     C                   Z-ADD     SLDT          C#VDAT                                       213004
      *                                                                                       213004
      * Set posting date according to FT Control Data                                         213004
      *                                                                                       213004
     C     @PDTI         IFEQ      'I'                                                        213004
     C                   Z-ADD     BJRDNB        C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C     @PDTI         IFEQ      'E'                                                        213004
     C                   Z-ADD     SLDT          C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C     SLDT          IFLT      PVDT                                                       213004
     C                   Z-ADD     SLDT          C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C                   Z-ADD     PVDT          C#PSTD                                       213004
     C                   END                                                                  213004
     C                   END                                                                  213004
     C                   END                                                                  213004
      *                                                                                       213004
     C                   MOVEL     'I'           C#IO                                         213004
     C                   MOVEL     SMCY          C#CCY                                        213004
     C                   MOVEL     PYTP          C#TRYP                                       213004
     C                   MOVEL     PREF          C#PREF                                       213004
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C#NARR                                       CRE020
     C                   Z-ADD     1             C#CHQN                                       CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-ADD     ##SMAM        C#AMT                                        213004
     C                   MOVEL     'FT'          C#MOD                                        213004
     C                   MOVEL     '01'          C#OLRC                                       213004
     C                   MOVEL     @FTOV         C#FTOV                                       213004
     C                   MOVEL     'Y'           C#RPST                                       213004
     C                   Z-ADD     10            C#RPNB                                       213004
     C                   MOVEL     'D'           C#RTYP                                       213004
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *                                                                                       213004
      *  Call AOSPOSU0                                                                        213004
      *                                                                                       213004
     C                   CALLB     'AOSPOSU0'                           9090                  213004
     C                   PARM      *BLANKS       C#RTCD                                       213004
     C                   PARM      '*ADD    '    W0ACT             8                          213004
     C                   PARM      C#DTA         O#DTA           256                          213004
      *                                                                                       213004
     C     *IN90         IFEQ      '1'                                                        213004
     C     C#RTCD        ORNE      *BLANKS                                                    213004
     C                   MOVEL     'AOSPOSU0'    DBKEY                                        213004
     C                   MOVEL     '902'         DBASE                                        213004
     C                   MOVEL     '*CALL   '    DBFILE                                       213004
     C                   EXSR      *PSSR                                                      213004
     C                   END                                                                  213004
     C                   END                                                                  213004
      *                                                                                       213004
      *         P A Y          I N S T R U C T I O N S                                        213004
      *                                                                                       213004
     C/COPY WNCPYSRC,FTH00488
     C                   CLEAR                   C#DTA                                        213004
     C     SNCT          IFNE      *BLANKS                                                    213004
     C                   MOVEL     SNCT          C#ATYP                                       213004
     C                   MOVEL     SNCO          C#ACCT                                       213004
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ELSE                                                                 213004
     C                   MOVEL     DSTT          C#ATYP                                       213004
     C                   MOVEL     DST1          C#ACCT                                       213004
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END                                                                  213004
     C                   Z-ADD     PVDT          C#VDAT                                       213004
      *                                                                                       213004
      * Set posting date according to FT Control Data                                         213004
      *                                                                                       213004
     C     @PDTI         IFEQ      'I'                                                        213004
     C                   Z-ADD     BJRDNB        C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C     @PDTI         IFEQ      'E'                                                        213004
     C                   Z-ADD     PVDT          C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C     SLDT          IFLT      PVDT                                                       213004
     C                   Z-ADD     SLDT          C#PSTD                                       213004
     C                   ELSE                                                                 213004
     C                   Z-ADD     PVDT          C#PSTD                                       213004
     C                   END                                                                  213004
     C                   END                                                                  213004
     C                   END                                                                  213004
      *                                                                                       213004
     C                   MOVEL     'O'           C#IO                                         213004
     C                   MOVEL     PCCY          C#CCY                                        213004
     C                   MOVEL     PYTP          C#TRYP                                       213004
     C                   MOVEL     PREF          C#PREF                                       213004
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C#NARR                                       CRE020
     C                   Z-ADD     2             C#CHQN                                       CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   Z-SUB     ##PYAM        C#AMT                                        213004
     C                   MOVEL     'FT'          C#MOD                                        213004
     C                   MOVEL     '01'          C#OLRC                                       213004
     C                   MOVEL     @FTOV         C#FTOV                                       213004
     C                   MOVEL     'Y'           C#RPST                                       213004
     C                   Z-ADD     20            C#RPNB                                       213004
     C                   MOVEL     'C'           C#RTYP                                       213004
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
     C/COPY WNCPYSRC,FTH00509
      *                                                                                       213004
      *  Call AOSPOSU0                                                                        213004
      *                                                                                       213004
     C                   CALLB     'AOSPOSU0'                           9090                  213004
     C                   PARM      *BLANKS       C#RTCD                                       213004
     C                   PARM      '*ADD    '    W0ACT             8                          213004
     C                   PARM      C#DTA         O#DTA           256                          213004
      *                                                                                       213004
     C     *IN90         IFEQ      '1'                                                        213004
     C     C#RTCD        ORNE      *BLANKS                                                    213004
     C                   MOVEL     'AOSPOSU0'    DBKEY                                        213004
     C                   MOVEL     '903'         DBASE                                        213004
     C                   MOVEL     '*CALL   '    DBFILE                                       213004
     C                   EXSR      *PSSR                                                      213004
     C                   END                                                                  213004
     C/COPY WNCPYSRC,FTH00489
                                                                                              213004
     CSR                 ENDSR                                                                213004
                                                                                              213004
      *                                                                                       213004
      *****************************************************************                       213004
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRSCHG   : Reverse charges from database                     *
      *                                                               *
      *****************************************************************
     CSR   SRSCHG        BEGSR
      *
      *  Move fields to C#DTA structure and call AOSPOSU0
     C                   CLEAR                   C#DTA
     C                   MOVE      *BLANKS       PIBAN            34                        BUG15042
      *
      *  If add use Receiver's Correspondent and Sender
     C                   SELECT
     C     CDRT          WHENNE    *BLANKS
     C                   MOVEL     CDRT          C#ATYP
     C                   MOVEL     CDRO          C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     CDBR          C#BRCA
      *                                                                                       CFT120
     C                   If        OPCDRC = *Blanks AND CFT120 = 'Y'                          CFT120
     C                             OR CFT120 = 'N'                                            CFT120
     C                   MOVEL     BJCYCD        C#CCY
     C                   Else                                                                 CFT120
     C                   MOVEL     UM#CCY        C#CCY                                        CFT120
     C                   Endif                                                                CFT120
      *                                                                                       CFT120
     C     ADDC          IFEQ      'A'
     C                   Z-ADD     SLDT          C#VDAT
     C                   ELSE
     C                   Z-ADD     PVDT          C#VDAT
     C                   END
     C     ADDC          WHENEQ    'A'
     C                   MOVEL     SMCY          C#CCY
     C     ORBT          IFNE      *BLANKS
     C                   MOVEL     ORBT          C#ATYP
     C                   MOVEL     ORBK          C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   MOVEL     ORBB          C#BRCA
     C                   ELSE
     C                   MOVEL     ORCT          C#ATYP
     C                   IF        %SUBST(ORC1:1:1) = '/'                                     CFT032
     C**********         EVAL      C#ACCT = %SUBST(ORC1:2)                           CFT032 BUG15042
     C                   EVAL      PIBAN = %SUBST(ORC1:2)                                   BUG15042
     C                   ELSE                                                                 CFT032
     C**********         MOVEL     ORC1          C#ACCT                                     BUG15042
     C                   MOVEL     ORC1          PIBAN                                      BUG15042
     C                   ENDIF                                                                CFT032
      *                                                                                     BUG15042
     C     ORCT          IFEQ      'I'                                                      BUG15042
     C                   CALL      'AOIBANR4'                                               BUG15042
     C                   PARM                    @RTCD             7                        BUG15042
     C                   PARM      '*KEY   '     @OPTN             7                        BUG15042
     C                   PARM                    PIBAN                                      BUG15042
     C     P@ACCT        PARM      *BLANKS       DSSDY                                      BUG15042
      *                                                                                     BUG15042
     C     @RTCD         IFEQ      *BLANKS                                                  BUG15042
     C     P@CNUM        CAT(P)    P@CCY         PIBAN                                      BUG15042
     C                   CAT       P@ACOD:0      PIBAN                                      BUG15042
     C                   CAT       P@ACSQ:0      PIBAN                                      BUG15042
     C                   CAT       P@BRCA:0      PIBAN                                      BUG15042
     C                   ENDIF                                                              BUG15042
     C                   ENDIF                                                              BUG15042
      *                                                                                     BUG15042
     C                   MOVEL     PIBAN         C#ACCT                                     BUG15042
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END
     C                   Z-ADD     SLDT          C#VDAT
     C                   OTHER
      *
      *  If deduct use Account with Bank and Beneficiary
      *
     C                   MOVEL     PCCY          C#CCY
     C     SNCT          IFNE      *BLANKS
     C                   MOVEL     SNCT          C#ATYP
     C                   MOVEL     SNCO          C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   ELSE
     C                   MOVEL     DSTT          C#ATYP
     C                   MOVEL     DST1          C#ACCT
     C                   EXSR      SRFLGL                                                     CGL029
     C                   END
     C                   Z-ADD     PVDT          C#VDAT
     C                   END
      *
      * Set posting date according to FT Control Data
      *
     C     @PDTI         IFEQ      'I'
     C                   Z-ADD     BJRDNB        C#PSTD
     C                   ELSE
     C     @PDTI         IFEQ      'E'
     C     ADDC          IFEQ      'A'
     C                   Z-ADD     SLDT          C#PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C#PSTD
     C                   END
     C                   ELSE
     C     SLDT          IFLT      PVDT
     C                   Z-ADD     SLDT          C#PSTD
     C                   ELSE
     C                   Z-ADD     PVDT          C#PSTD
     C                   END
     C                   END
     C                   END
      *
     C                   MOVEL     'I'           C#IO
     C                   MOVEL     PYTP          C#TRYP
     C                   MOVEL     PREF          C#PREF
     C                   IF        CRE020 = 'Y'                                               CRE020
     C                   MOVEL     PREF          C#NARR                                       CRE020
     C                   Z-ADD     3             C#CHQN                                       CRE020
     C                   IF        WRevAst = 'Y'                                              CRE020
     C                   EVAL      WRevAst = ' '                                              CRE020
     C                   EVAL      %SUBST(C#NARR:30:1) = '*'                                  CRE020
     C                   ENDIF                                                                CRE020
     C                   ENDIF                                                                CRE020
     C                   MOVEL     'FT'          C#MOD
     C                   MOVEL     '01'          C#OLRC
     C                   MOVEL     @FTOV         C#FTOV
     C     *LIKE         DEFINE    C#AMT         ##CHGS
     C                   Z-ADD     ##CHGS        C#AMT
     C                   MOVEL     'Y'           C#RPST
     C                   Z-ADD     30            C#RPNB
     C                   MOVEL     'D'           C#RTYP
     C     CAP205        IFEQ      'Y'                                                        CAP205
     C                   MOVEL     'F'           C#MTYP                                       CAP205
     C                   ENDIF                                                                CAP205
      *
      *  Call AOSPOSU0
     C/COPY WNCPYSRC,FTOPAYDC10
      *
     C*******************CALL      'AOSPOSU0'                           9090    185764
     C                   CALLB     'AOSPOSU0'                           9090    185764
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*ADD    '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
      *
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'SPOSUPD'     DBKEY
     C                   MOVEL     '942'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTOPAYDC06
      *
     CSR                 ENDSR
     C************************************************************
     C/EJECT
     C************************************************************
     C* CHARGE CONVERSION SUBROUTINE
     C************************************************************
     C     CHARGE        BEGSR
     C*
     C** If recalculation for extended payments is necessary, set up
     C** parameters for FT0320
     C*
     C     WRDFTC        IFEQ      'Y'
     C                   CLEAR                   W7DATA
     C*
     C** Payment type and subtype
     C*
     C                   MOVEL     OTPYTP        W7PYTP
     C                   MOVEL     OTPYST        W7PYST
     C*
     C** Input currency and charge currency
     C*
     C                   SELECT
     C     BTCHCY        WHENEQ    'C'
     C     OTADDC        IFEQ      'A'
     C                   MOVE      OTSMCY        W7ICCY
     C                   ELSE
     C                   MOVE      OTPCCY        W7ICCY
     C                   END
     C     BTCHCY        WHENEQ    'L'
     C                   MOVE      BJLCCY        W7ICCY
     C                   OTHER
     C                   MOVE      BJCYCD        W7ICCY
     C                   ENDSL
     C*
     C     OTADDC        IFEQ      'A'
     C                   MOVEL     OTSMCY        W7CCCY
     C                   ELSE
     C                   MOVEL     OTPCCY        W7CCCY
     C                   END
     C*
     C** Settlement method
     C*
     C                   MOVEL     OTSTMT        W7STMT
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
     C     OTADDC        WHENEQ    'A'
     C                   Z-ADD     SMAM          W7CAMT
     C     OTCHTP        IFEQ      'A'
     C                   Z-ADD     OTSMAM        W7CAMT
     C                   END
     C                   MOVEL     OTSMCY        W7PCCY
     C*
     C                   OTHER
     C                   Z-ADD     PYAM          W7CAMT
     C     OTCHTP        IFEQ      'A'
     C                   Z-ADD     OTPYAM        W7CAMT
     C                   END
     C                   MOVEL     OTPCCY        W7PCCY
     C                   ENDSL
     C*
     C** Transfer Commission type
     C*
     C                   MOVEL     TRCT          W7TRCT
     C*
     C** SWIFT priority code
     C*
     C     SWPC          IFEQ      1
     C                   MOVEL     'U'           W7SWPC
     C                   ELSE
     C                   MOVEL     'N'           W7SWPC
     C                   END
     C*
     C** Transfer Commission amount
     C*
     C                   Z-ADD     DUMA1         W7TRCD
     C                   Z-ADD     TRCM          W7TRCH
     C*
     C** Telex charge
     C*
     C                   Z-ADD     DUMA2         W7TXCD
     C                   Z-ADD     TXCH          W7TXCH
     C*
     C** Cheque Charge
     C*
     C                   Z-ADD     DUMA3         W7CQCD
     C                   Z-ADD     CQCH          W7CQCH
     C*
     C** Costs Abroad
     C*
     C                   Z-ADD     DUMA4         W7CSTD
     C                   Z-ADD     CSTA          W7CSTA
     C*
     C** SWIFT Priority Charge
     C*
     C                   Z-ADD     DUMA5         W7SPCD
     C                   Z-ADD     SPCH          W7SPCH
     C*
     C** Miscellaneous charge
     C*
     C                   Z-ADD     DUMA6         W7MSCD
     C                   Z-ADD     MSCH          W7MSCH
     C*
     C** FX/Change Commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     OPDUM7        W7CHCD
     C                   Z-ADD     OPCHCM        W7CHCM
     C                   END
     C*
     C** Advice Charge
     C*
     C                   Z-ADD     0             W7ADCD
     C                   Z-ADD     0             W7ADCH
     C*
     C** Telephone Charge
     C*
     C                   Z-ADD     0             W7TLCD
     C                   Z-ADD     0             W7TLCH
     C*
     C** Collection Charge
     C*
     C                   Z-ADD     0             W7COLD
     C                   Z-ADD     0             W7COLL
     C*
     C                   MOVEL     *BLANKS       W7ACT
     C                   MOVEL     'OP'          W7ACT
     C*
     C**  Other currency
     C*
     C     OTADDC        IFEQ      'D'
     C                   MOVE      OTSMCY        W7OCCY
     C                   ELSE
     C                   MOVE      OTPCCY        W7OCCY
     C                   END
     C*
     C** Customer to be debited
     C*
     C                   MOVEL     WDCUS2        W7CUST
     C*
     C** Call defaults program
     C*
     C                   CALL      'FT0320'                             9090
     C                   PARM      *BLANKS       W7RTN             7
     C                   PARM                    W7ACT             8
     C                   PARM                    W7DATA
      *
      ** Re-apply old charges if only sett.amt has changed
     C     OTPCCY        IFEQ      PCCY
     C     OTSMCY        ANDEQ     SMCY
     C     WRDFTC        ANDEQ     'Y'
     C     OTSMAM        ANDNE     SMAM
     C                   Z-ADD     DUMA2         W7TXCD
     C                   Z-ADD     DUMA3         W7CQCD
     C                   Z-ADD     DUMA4         W7CSTD
     C                   Z-ADD     DUMA5         W7SPCD
     C                   Z-ADD     DUMA6         W7MSCD
     C                   END
     C*
     C     *IN90         IFEQ      '1'
     C     W7RTN         ORNE      *BLANKS
     C                   MOVEL     'FT0320'      DBKEY
     C                   MOVEL     '35'          DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C*
     C** Transfer Commission amount
     C*
     C                   Z-ADD     W7TRCD        OTDUMA1
     C                   Z-ADD     W7TRCH        OTTRCM
     C*
     C* Telex charge
     C*
     C                   Z-ADD     W7TXCD        OTDUMA2
     C                   Z-ADD     W7TXCH        OTTXCH
     C*
     C** Cheque Charge
     C*
     C                   Z-ADD     W7CQCD        OTDUMA3
     C                   Z-ADD     W7CQCH        OTCQCH
     C*
     C** Costs Abroad
     C*
     C                   Z-ADD     W7CSTD        OTDUMA4
     C                   Z-ADD     W7CSTA        OTCSTA
     C*
     C** SWIFT Priority Charge
     C*
     C                   Z-ADD     W7SPCD        OTDUMA5
     C                   Z-ADD     W7SPCH        OTSPCH
     C*
     C** Miscellaneous charge
     C*
     C                   Z-ADD     W7MSCD        OTDUMA6
     C                   Z-ADD     W7MSCH        OTMSCH
     C*
     C** FX/Change Commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     W7CHCD        OTOPDUM7
     C                   Z-ADD     W7CHCM        OTOPCHCM
     C                   END
     C*
     C                   END
     C*
     C* IF CHARGES TO THE DEBIT OF IS 0,USE PAY OR SETTLE
     C* BASED ON FTCC (BTCHCY) INDICATOR
     C*
     C     BTCHCY        IFEQ      'C'
     C*
     C     ADDC          IFEQ      'A'
     C                   MOVE      SMCY          @CCCY
     C                   ELSE
     C                   MOVE      PCCY          @CCCY
     C                   END
     C*
     C                   ELSE
     C*
     C     BTCHCY        IFEQ      'L'
     C                   MOVE      BJLCCY        @CCCY
     C                   ELSE
     C                   MOVE      BJCYCD        @CCCY
     C                   END
     C*
     C                   END
     C*
     C* ONLY CONVERT IF ENTRY CHARGE CCY NOT BASE
     C*
     C     @CCCY         IFNE      BJCYCD
     C*
     C* ACCESS DETAILS OF FILE CHARGE CCY FOR CHARGE CALCULATIONS
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      @CCCY         C#K101
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C** Move new standing data field into field used in program
     C*
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             OTMDIN
     C                   ELSE
     C                   Z-ADD     0             OTMDIN
     C                   END
     C*
     C*
     C* N IS DIFFERENCE BETWEEN DECIMALS FOR BASE AND DECIMALS FOR FILE
     C* CURRENCY - FOLLOWING CALCS FIND TRUE RATE(TSPOT)TO CONVERT FILE
     C* CURRENCY TO BASE
     C*
     C     @BCDP         SUB       A6NBDP        N                 1 0
     C     OTMDIN        IFEQ      1
     C     N             IFGT      0
     C     A6SPRT        MULT      POWERS(N)     TSPOT            15 9
     C                   ELSE
     C     N             IFLT      0
     C                   Z-SUB     N             N
     C     A6SPRT        DIV       POWERS(N)     TSPOT
     C                   ELSE
     C                   Z-ADD     A6SPRT        TSPOT
     C                   END
     C                   END
     C                   END
     C     OTMDIN        IFEQ      0
     C     N             IFGT      0
     C     A6SPRT        DIV       POWERS(N)     TSPOT
     C                   ELSE
     C     N             IFLT      0
     C                   Z-SUB     N             N
     C     A6SPRT        MULT      POWERS(N)     TSPOT
     C                   ELSE
     C                   Z-ADD     A6SPRT        TSPOT
     C                   END
     C                   END
     C                   END
     C*
     C* NOW USE RATE TO CALCULATE VALUE FOR AMENDMENT IN BASE
     C*
     C     OTMDIN        IFEQ      1
     C* TRANSFER COMMISSION
     C     OTDUMA1       MULT(H)   TSPOT         TRCMB            11 0
     C* TELEX CHARGE
     C     OTDUMA2       MULT(H)   TSPOT         TXCHB            11 0
     C* CHEQUE CHARGE
     C     OTDUMA3       MULT(H)   TSPOT         CQCHB            11 0
     C* COSTS ABROAD
     C     OTDUMA4       MULT(H)   TSPOT         CSTAB            11 0
     C* SWIFT PRIORITY CHARGE
     C     OTDUMA5       MULT(H)   TSPOT         SPCHB            11 0
     C* MISCELLANEOUS CHARGE
     C     OTDUMA6       MULT(H)   TSPOT         MSCHB            11 0
     C*
     C     @01494        IFEQ      'Y'
     C     OTOPDUM7      MULT(H)   TSPOT         CHCMB            11 0
     C                   END
     C*
     C     @01499        IFEQ      'Y'
     C     OTOPDUM8      MULT(H)   TSPOT         VATTB            11 0
     C                   END
     C                   END
     C*
     C     OTMDIN        IFEQ      0
     C* TRANSFER COMMISSION
     C     OTDUMA1       DIV(H)    TSPOT         TRCMB
     C* TELEX CHARGE
     C     OTDUMA2       DIV(H)    TSPOT         TXCHB
     C* CHEQUE CHARGE
     C     OTDUMA3       DIV(H)    TSPOT         CQCHB
     C* COSTS ABROAD
     C     OTDUMA4       DIV(H)    TSPOT         CSTAB
     C* SWIFT PRIORITY CHARGE
     C     OTDUMA5       DIV(H)    TSPOT         SPCHB
     C* MISCELLANEOUS CHARGE
     C     OTDUMA6       DIV(H)    TSPOT         MSCHB
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C     OTOPDUM7      DIV(H)    TSPOT         CHCMB            11 0
     C                   END
     C                   END
     C*
     C                   ELSE
     C                   Z-ADD     OTDUMA1       TRCMB
     C                   Z-ADD     OTDUMA2       TXCHB
     C                   Z-ADD     OTDUMA3       CQCHB
     C                   Z-ADD     OTDUMA4       CSTAB
     C                   Z-ADD     OTDUMA5       SPCHB
     C                   Z-ADD     OTDUMA6       MSCHB
     C*
     C** FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     OTOPDUM7      CHCMB
     C                   END
     C                   END
     C*
     C     OTADDC        IFEQ      'A'
     C                   MOVE      OTSMCY        @CCCY
     C                   ELSE
     C                   MOVE      OTPCCY        @CCCY
     C                   END
     C*
     C* ONLY CONVERT IF NEW CHARGE CCY NOT BASE
     C*
     C     @CCCY         IFNE      BJCYCD
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      @CCCY         C#K101
     C     SDCURR        PARM      SDCURR        DSSDY
     C*
     C** Move new standing data field into field used in program
     C*
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             OTMDIN
     C                   ELSE
     C                   Z-ADD     0             OTMDIN
     C                   END
     C*
     C*
     C* N IS DIFFERENCE BETWEEN DECIMALS FOR BASE AND DECIMALS FOR
     C* CHARGE CURRENCY - FOLLOWING CALCS FIND TRUE RATE(TSPOT)TO
     C* CONVERT BASE CURRENCY BACK TO NEW CHARGE CCY
     C*
     C     A6NBDP        SUB       @BCDP         N                 1 0
     C     OTMDIN        IFEQ      1
     C     N             IFGT      0
     C     A6SPRT        DIV       POWERS(N)     TSPOT            15 9
     C                   ELSE
     C     N             IFLT      0
     C                   Z-SUB     N             N
     C     A6SPRT        MULT      POWERS(N)     TSPOT
     C                   ELSE
     C                   Z-ADD     A6SPRT        TSPOT
     C                   END
     C                   END
     C                   END
     C     OTMDIN        IFEQ      0
     C     N             IFGT      0
     C     A6SPRT        MULT      POWERS(N)     TSPOT
     C                   ELSE
     C     N             IFLT      0
     C                   Z-SUB     N             N
     C     A6SPRT        DIV       POWERS(N)     TSPOT
     C                   ELSE
     C                   Z-ADD     A6SPRT        TSPOT
     C                   END
     C                   END
     C                   END
     C*
     C* NOW USE RATE TO CALCULATE NEW CHARGE VALUES
     C*
     C     OTMDIN        IFEQ      1
     C* TRANSFER COMMISSION
     C     TRCMB         DIV(H)    TSPOT         OTTRCM
     C* TELEX CHARGE
     C     TXCHB         DIV(H)    TSPOT         OTTXCH
     C* CHEQUE CHARGE
     C     CQCHB         DIV(H)    TSPOT         OTCQCH
     C* COSTS ABROAD
     C     CSTAB         DIV(H)    TSPOT         OTCSTA
     C* SWIFT PRIORITY CHARGE
     C     SPCHB         DIV(H)    TSPOT         OTSPCH
     C* MISCELLANEOUS CHARGE
     C     MSCHB         DIV(H)    TSPOT         OTMSCH
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C     CHCMB         DIV(H)    TSPOT         OTOPCHCM
     C                   END
     C                   END
     C*
     C     OTMDIN        IFEQ      0
     C* TRANSFER COMMISSION
     C     TRCMB         MULT(H)   TSPOT         OTTRCM
     C* TELEX CHARGE
     C     TXCHB         MULT(H)   TSPOT         OTTXCH
     C* CHEQUE CHARGE
     C     CQCHB         MULT(H)   TSPOT         OTCQCH
     C* COSTS ABROAD
     C     CSTAB         MULT(H)   TSPOT         OTCSTA
     C* SWIFT PRIORITY CHARGE
     C     SPCHB         MULT(H)   TSPOT         OTSPCH
     C* MISCELLANEOUS CHARGE
     C     MSCHB         MULT(H)   TSPOT         OTMSCH
     C*
     C** For FX/Change Commission
     C*
     C     @01494        IFEQ      'Y'
     C     CHCMB         MULT(H)   TSPOT         OTOPCHCM
     C                   END
     C                   END
     C*
     C                   ELSE
     C                   Z-ADD     TRCMB         OTTRCM
     C                   Z-ADD     TXCHB         OTTXCH
     C                   Z-ADD     CQCHB         OTCQCH
     C                   Z-ADD     CSTAB         OTCSTA
     C                   Z-ADD     SPCHB         OTSPCH
     C                   Z-ADD     MSCHB         OTMSCH
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     CHCMB         OTOPCHCM
     C                   END
     C                   END
     C*
     C* FILE DAF FORMAT(NOT LIKE REAL DAF)
     C*
     C     @CCCY         IFNE      BJCYCD
     C                   Z-ADD     A6NBDP        @FCDP
     C                   ELSE
     C                   Z-ADD     @BCDP         @FCDP
     C                   END
     C*
     C* TRANSFER COMMISSION
     C     @FCDP         ADD       1             W                 1 0
     C     OTTRCM        DIV       FCTR(W)       OTTRCMD
     C* TELEX CHARGE
     C     @FCDP         ADD       1             W
     C     OTTXCH        DIV       FCTR(W)       OTTXCHD
     C* CHEQUE CHARGE
     C     @FCDP         ADD       1             W
     C     OTCQCH        DIV       FCTR(W)       OTCQCHD
     C* COSTS ABROAD
     C     @FCDP         ADD       1             W
     C     OTCSTA        DIV       FCTR(W)       OTCSTAD
     C* SWIFT PRIORITY CHARGE
     C     @FCDP         ADD       1             W
     C     OTSPCH        DIV       FCTR(W)       OTSPCHD
     C* MISCELLANEOUS CHARGE
     C     @FCDP         ADD       1             W
     C     OTMSCH        DIV       FCTR(W)       OTMSCHD
     C*
     C     BTCHCY        IFEQ      'C'
     C*
     C* OR,IF *F*T*C*C* BTCHCY IS SET TO 'B' FOR BASE CURRENCY,AND
     C* DEFAULT CHARGE CCY IS BASE
     C*
     C     BTCHCY        OREQ      'B'
     C     @CCCY         ANDEQ     BJCYCD
     C*
     C* OR,IF *F*T*C*C* BTCHCY IS SET TO 'L' FOR LOCAL CURRENCY
     C* AND LOCAL IS THE SAME CCY AS BASE,AND DEFAULT CCY IS BASE
     C*
     C     BTCHCY        OREQ      'L'
     C     BJCYCD        ANDEQ     BJLCCY
     C     @CCCY         ANDEQ     BJCYCD
     C*
     C* OR,IF *F*T*C*C* BTCHCY IS SET TO 'L' FOR LOCAL CURRENCY,AND
     C* DEFAULT CHARGE CURRENCY IS THE SAME AS LOCAL CCY
     C*
     C     BTCHCY        OREQ      'L'
     C     @CCCY         ANDEQ     BJLCCY
     C*
     C                   Z-ADD     OTTRCM        OTDUMA1
     C                   Z-ADD     OTTXCH        OTDUMA2
     C                   Z-ADD     OTCQCH        OTDUMA3
     C                   Z-ADD     OTCSTA        OTDUMA4
     C                   Z-ADD     OTSPCH        OTDUMA5
     C                   Z-ADD     OTMSCH        OTDUMA6
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     OTOPCHCM      OTOPDUM7
     C                   END
     C*
     C                   ELSE
     C*
     C* INPUT CAPABLE CHARGE FIELD MAY BE BASE
     C* WITH RIGHT HAND SIDE NOT BASE - HERE USE BASE COMMISSION
     C* CHARGE ALREADY CALCULATED
     C*
     C     BTCHCY        IFEQ      'B'
     C     @CCCY         ANDNE     BJCYCD
     C*
     C     BTCHCY        OREQ      'L'
     C     BJLCCY        ANDEQ     BJCYCD
     C*
     C                   Z-ADD     TRCMB         OTDUMA1
     C                   Z-ADD     TXCHB         OTDUMA2
     C                   Z-ADD     CQCHB         OTDUMA3
     C                   Z-ADD     CSTAB         OTDUMA4
     C                   Z-ADD     SPCHB         OTDUMA5
     C                   Z-ADD     MSCHB         OTDUMA6
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     CHCMB         OTOPDUM7
     C                   END
     C*
     C                   ELSE
     C*
     C                   Z-ADD     TRCMB         AMNTB            11 0
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA1
     C*
     C                   Z-ADD     TXCHB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA2
     C*
     C                   Z-ADD     CQCHB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA3
     C*
     C                   Z-ADD     CSTAB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA4
     C*
     C                   Z-ADD     SPCHB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA5
     C*
     C                   Z-ADD     MSCHB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTDUMA6
     C*
     C** For FX/Change commission
     C*
     C     @01494        IFEQ      'Y'
     C                   Z-ADD     CHCMB         AMNTB
     C                   EXSR      CHGLT
     C                   MOVE      AMNTE         OTOPDUM7
     C                   END
     C*
     C                   END
     C*
     C                   END
     C***********                                                                             CRE067
     C***If*S01499*is*active,*calculate*V.A.T.*charges****************                        CRE067
     C***********                                                                             CRE067
     C*****@01499        IFEQ      'Y'                                                        CRE067
      *                                                                                       CRE067
      ** Calculate V.A.T. charges if S01499 is ON and user did not                            CRE067
      ** enter a VAT                                                                          CRE067
      *                                                                                       CRE067
     C                   IF        (@01499 = 'Y' AND @TVAT <> 'Y')                            CRE067
                                                                                              CRE067
     C                   Z-ADD     @VATR         OTOPVATR
     C                   MOVE      *ZEROS        OTOPDUM8
     C                   MOVE      *ZEROS        OTOPVATT
     C**
     C** .... Transfer commission
     C*
     C     OTOPVAT1      IFEQ      'Y'
     C     OTDUMA1       MULT(H)   @VATR         WVATE            13 0
     C     OTTRCM        MULT(H)   @VATR         WVATC            13 0
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... Telex
     C*
     C     OTOPVAT2      IFEQ      'Y'
     C     OTDUMA2       MULT(H)   @VATR         WVATE
     C     OTTXCH        MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... Cheque
     C*
     C     OTOPVAT3      IFEQ      'Y'
     C     OTDUMA3       MULT(H)   @VATR         WVATE
     C     OTCQCH        MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... Costs
     C*
     C     OTOPVAT4      IFEQ      'Y'
     C     OTDUMA4       MULT(H)   @VATR         WVATE
     C     OTCSTA        MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... SWIFT
     C*
     C     OTOPVAT5      IFEQ      'Y'
     C     OTDUMA5       MULT(H)   @VATR         WVATE
     C     OTSPCH        MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... Miscellaneous
     C*
     C     OTOPVAT6      IFEQ      'Y'
     C     OTDUMA6       MULT(H)   @VATR         WVATE
     C     OTMSCH        MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C** .... FX/Change commission
     C*
     C     OTOPVAT7      IFEQ      'Y'
     C     @01494        ANDEQ     'Y'
     C     OTOPDUM7      MULT(H)   @VATR         WVATE
     C     OTOPCHCM      MULT(H)   @VATR         WVATC
     C                   ADD       WVATE         OTOPDUM8
     C                   ADD       WVATC         OTOPVATT
     C                   END
     C*
     C                   END
     C*
     C                   ENDSR
     C************************************************************
     C* END OF CHARGES SUBROUTINE
     C************************************************************
     C*/EJECT
     C************************************************************
     C*  CHGLT SUBROUTINE TO CONVERT FOR LOCY AMOUNTS
     C************************************************************
     C     CHGLT         BEGSR
     C*
     C                   CALL      'AOCURRR0'
     C                   PARM      '*DBERR '     C#RTCD
     C                   PARM      '*KEY   '     C#OPTN
     C                   PARM      BJLCCY        C#K101
     C*****SDCURR        PARM      SDCURR        DSFDY                                        220004
     C     SDCURR        PARM      SDCURR        DSSDY                                        220004
     C*
     C** Move new standing data field into field used in program
     C*
     C     A6MDIN        IFEQ      'M'
     C                   Z-ADD     1             OTMDIN
     C                   ELSE
     C                   Z-ADD     0             OTMDIN
     C                   END
     C*
     C*
     C                   Z-ADD     A6NBDP        LCDP              1 0
     C                   Z-ADD     OTMDIN        LMDIN             1 0
     C                   Z-ADD     A6SPRT        LSPOT            13 8
     C*
     C* M IS DIFFERENCE BETWEEN DECIMALS FOR BASE AND DECIMALS FOR
     C* LOCAL CURRENCY - FOLLOWING CALCS FIND TRUE RATE(LSPOT)TO
     C* CONVERT BASE CURRENCY TO LOCAL
     C*
     C     LCDP          SUB       @BCDP         M                 1 0
     C     LMDIN         IFEQ      1
     C     M             IFGT      0
     C     LSPOT         DIV       POWERS(M)     TSPOT            15 9
     C                   ELSE
     C     M             IFLT      0
     C                   Z-SUB     M             M
     C     LSPOT         MULT      POWERS(M)     TSPOT
     C                   ELSE
     C                   Z-ADD     LSPOT         TSPOT
     C                   END
     C                   END
     C                   END
     C     LMDIN         IFEQ      0
     C     M             IFGT      0
     C     LSPOT         MULT      POWERS(M)     TSPOT
     C                   ELSE
     C     M             IFLT      0
     C                   Z-SUB     M             M
     C     LSPOT         DIV       POWERS(M)     TSPOT
     C                   ELSE
     C                   Z-ADD     LSPOT         TSPOT
     C                   END
     C                   END
     C                   END
     C*
     C* NOW USE RATE TO CALCULATE DEFAULT VALUE IN LOCAL CURRENCY
     C*
     C     LMDIN         IFEQ      1
     C     AMNTB         DIV(H)    TSPOT         AMNTE            11 0
     C                   END
     C*
     C     LMDIN         IFEQ      0
     C     AMNTB         MULT(H)   TSPOT         AMNTE            11 0
     C                   END
     C*
     C                   ENDSR
     C*
     C************************************************************
     C/EJECT
      *****************************************************************
      *                                                               *
      *  SRUPD    : Update database with shadow positions             *
      *                                                               *
      *****************************************************************
     CSR   SRUPD         BEGSR
      *
      *  Call AOSPOSU0 to update database
     C*******************CALL      'AOSPOSU0'                           9090    185764
     C                   CALLB     'AOSPOSU0'                           9090    185764
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*UPDATE '    W0ACT             8
     C                   PARM      C#DTA         O#DTA           256
 
     C     *IN90         IFEQ      '1'
     C     C#RTCD        ORNE      *BLANKS
     C                   MOVEL     'AOSPOSU0'    DBKEY
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*CALL   '    DBFILE
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTOPAYDC07
      *
     CSR                 ENDSR
     C/EJECT
     C/COPY WNCPYSRC,FTH00490
     C********************************************************************
     C* SUBROUTINE TO ADD AN AMOUNT (ZZAMT) TO THE TOTAL (ZZTOTI,ZZTOTD)
     C*   IND '99' IS SET BY AN OVERFLOW ERROR
     C********************************************************************
     C*
     C     GLZADD        BEGSR                                                  *** GLZADD ****
     C*
     C                   Z-ADD     ZZAMT         ZZAMT            15 3    91    -DEFINE ZZAMT
     C   91              GOTO      ZZAEND                                       AMT = 0.BYPASS
     C*
     C* SPLIT ZZAMT INTO INTEGER AND DECIMAL FIELDS
     C                   Z-ADD     ZZAMT         ZZAMTI           15 0          INTEGER FIELD
     C                   MOVE      ZZAMT         ZZAMTD            3 0          DECIMAL FIELD
     C* BOTH ZZAMTI AND ZZAMTD CONTAIN A 'SIGN' ZONE NOW
     C*
     C                   EXSR      GLZSUM
     C     ZZAEND        ENDSR                                                  ** ZZAEND TAG *
     C********************************************************************
     C/EJECT
     C********************************************************************
     C* SUBROUTINE TO CARRY OUT THE ADDITION FOR SUBROUTINES -
     C*                        GLZADD, GLZSUB, GLZCMP.
     C*          PARAMETERS PASSED -
     C*                     I/P ZZAMTI ZZAMTD
     C*                     O/P ZZTOTI ZZTOTD ZZNEGD IND 96 IND 99.
     C********************************************************************
     C*
     C     GLZSUM        BEGSR                                                  *** GLZSUM ****
     C*
     C                   Z-ADD     ZZTOTI        ZZTOTI           15 0          DEFINE ZZTOTI
     C                   Z-ADD     ZZTOTD        ZZTOTD            3 0          DEFINE ZZTOTD
     C                   SETOFF                                       919293
     C                   SETOFF                                       949599
     C*
     C*    DETERMINE SIGN OF ZZAMTI & D,   92 IF NEG
     C     ZZAMTI        COMP      0                                    9293
     C   93ZZAMTD        COMP      0                                    9293
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*
     C*    DETERMINE SIGN OF ZZTOTI & D, 91 IF NEG.
     C     ZZTOTI        COMP      0                                    9193
     C   93ZZTOTD        COMP      0                                    9193
     C*
     C*    IF ZZTOTAL IS ZERO, RETURN ZZAMOUNT.
     C   93              Z-ADD     ZZAMTI        ZZTOTI
     C   93              Z-ADD     ZZAMTD        ZZTOTD
     C   93              GOTO      ZZSEND                                       ZERO BYPASS
     C*    IF SIGNS DIFFER BYPASS OVERFLOW CHECKS.
     C   91
     CANN92
     CORN91
     CAN 92              GOTO      ZZOFPS
     C*
     C     ZZAMTD        ADD       ZZTOTD        ZZWK2             4 0
     C     ZZWK2         COMP      999                                93        '93' = CARRY
     C  N93ZZWK2         COMP      -999                                 93        INTO INTEGER.
     C*
     C   93
     CANN92ZZAMTI        ADD       1             ZZWK3            15 0          ADD 'CARRY' +VE
     C   93
     CAN 92ZZAMTI        SUB       1             ZZWK3                          SUB 'CARRY' -VE
     C   93ZZTOTI        ADD       ZZWK3         ZZWK3
     C  N93ZZTOTI        ADD       ZZAMTI        ZZWK3
     C*
     C* IF THE MODULUS OF ZZWK3 IS LT MOD. ZZTOTI THEN O/F HAS OCCURED
     C  N92ZZWK3         COMP      ZZTOTI                               99      -92 MEANS NOS.
     C   92ZZWK3         COMP      ZZTOTI                             99         NEGATIVE
     C  N99              Z-ADD     ZZWK2         ZZTOTD
     C  N99              Z-ADD     ZZWK3         ZZTOTI
     C*
     C* IF O/F ZEROIZE ZZAMT , IND '99' SET AND ZZTOT FIELDS LEFT INTACT.
     C   99              Z-ADD     0             ZZAMT            15 3
     C                   GOTO      ZZSEND
     C*
     C* THE 'SIGNS' ARE DIFFERENT
     C     ZZOFPS        TAG                                                    ** ZZOFPS TAG**
     C* IF ZZAMT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZTOT
     C*
     C   92              Z-SUB     ZZAMTI        ZZAMTI           15 0
     C   92              Z-SUB     ZZAMTD        ZZAMTD            3 0
     C*
     C* IF ZZTOT WAS NEGATIVE, MAKE IT POS. TO COMP WITH ZZAMT.
     C*
     C   91              Z-SUB     ZZTOTI        ZZTOTI
     C   91              Z-SUB     ZZTOTD        ZZTOTD
     C* BOTH ZZAMT AND ZZTOT ARE NOW POSITIVE.
     C*
     C     ZZTOTI        COMP      ZZAMTI                             93  95
     C   95ZZTOTD        COMP      ZZAMTD                             93  95
     C*
     C* IF ZZTOT EQ. ZZAMT RETURN ZERO.
     C   95              Z-ADD     0             ZZTOTI
     C   95              Z-ADD     0             ZZTOTD
     C   95              GOTO      ZZSEND
     C*
     C* IF ZZTOT GT. ZZAMT.
     C   93ZZAMTD        COMP      ZZTOTD                             94
     C   93
     CAN 94ZZTOTI        SUB       1             ZZTOTI
     C   93
     CAN 94ZZTOTD        ADD       1000          ZZWK2
     C   93ZZTOTI        SUB       ZZAMTI        ZZTOTI
     C   93
     CAN 94ZZWK2         SUB       ZZAMTD        ZZTOTD
     C   93
     CANN94ZZTOTD        SUB       ZZAMTD        ZZTOTD
     C*
     C* IF ZZAMT GT. ZZTOT.
     C  N93ZZTOTD        COMP      ZZAMTD                             94
     C  N93
     CAN 94ZZAMTI        SUB       1             ZZWK3            15 0
     C  N93
     CAN 94ZZAMTD        ADD       1000          ZZWK2
     C  N93
     CAN 94ZZWK3         SUB       ZZTOTI        ZZTOTI
     C  N93
     CANN94ZZAMTI        SUB       ZZTOTI        ZZTOTI
     C  N93
     CAN 94ZZWK2         SUB       ZZTOTD        ZZTOTD
     C  N93
     CANN94ZZAMTD        SUB       ZZTOTD        ZZTOTD
     C*
     C* REVERSE SIGN OF ZZTOT IF LARGER I/P FIELDS WERE NEGATIVE
     C                   SETOFF                                       94
     C   93
     CAN 91
     CORN93
     CAN 92              SETON                                        94
     C   94              Z-SUB     ZZTOTI        ZZTOTI
     C   94              Z-SUB     ZZTOTD        ZZTOTD
     C**
     C**   RESTORE SIGN OF ZZAMTI & ZZAMTD IF IT WAS REVERSED.
     C   92              Z-SUB     ZZAMTI        ZZAMTI
     C   92              Z-SUB     ZZAMTD        ZZAMTD
     C     ZZSEND        TAG                                                    ** ZZSEND TAG *
     C**
     C**   IF ZZTOTD IS ZERO, AND ZZTOTI IS NEG. SET UP ZZNEGD.
     C                   SETOFF                                       96
     C     ZZTOTD        COMP      0                                      91
     C   91ZZTOTI        COMP      0                                    96
     C   96              MOVE      '.000-'       ZZNEGD            5
     C                   ENDSR                                                    ** ENDSR **
      *****************************************************************
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SrWatch - Perform Midas Watch List processing.                *                       CSD015
      *                                                               *                       CSD015
      * Called by: SR/INSERT, SR/AMEND                                *                       CSD015
      *                                                               *                       CSD015
      * Calls: None                                                   *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SrWatch       BEGSR                                                                CSD015
                                                                                              CSD015
     C                   CLEAR                   SDWLTD                                       CSD015
     C                   CLEAR                   PString                                      CSD015
     C                   EVAL      U = *Zeros                                                 CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
     C                   EVAL      PInCcy  = OTSMCY                                           CSD015
                                                                                              CSD015
      ** Destination                                                                          CSD015
     C                   IF        OTDST1 <> *Blanks  or  OTDST2 <> *Blanks  or               CSD015
     C                             OTDST3 <> *Blanks  or  OTDST4 <> *Blanks                   CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTDST1 <> CHDST1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDST2 <> CHDST2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDST3 <> CHDST3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDST4 <> CHDST4                        CSD015
     C                   EVAL      Fld1 = OTDST1                                              CSD015
     C                   EVAL      Fld2 = OTDST2                                              CSD015
     C                   EVAL      Fld3 = OTDST3                                              CSD015
     C                   EVAL      Fld4 = OTDST4                                              CSD015
     C                   EVAL      U = 1                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Ordering Bank                                                                        CSD015
     C***********        IF        OTORBK <> *Zeros                                    CSD015 CSD027
     C                   IF        OTORBK <> *BLANKS                                          CSD027
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTORBK <> CHORBK                        CSD015
     C                   MOVEL     OTORBK        Fld1                                         CSD015
     C                   EVAL      U = 3                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Ordering Customer                                                                    CSD015
     C*******************IF        OTORC1 <> *Blanks  or  OTORC2 <> *Blanks  or        221778 CSD015
     C*******************          OTORC3 <> *Blanks  or  OTORC4 <> *Blanks            221778 CSD015
      *******************                                                              221778 CSD015
     C*******************IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                   221778 CSD015
     C*******************          OTCHTP = 'A'  and  OTORC1 <> CHORC1  or             221778 CSD015
     C*******************          OTCHTP = 'A'  and  OTORC2 <> CHORC2  or             221778 CSD015
     C*******************          OTCHTP = 'A'  and  OTORC3 <> CHORC3  or             221778 CSD015
     C*******************          OTCHTP = 'A'  and  OTORC4 <> CHORC4                 221778 CSD015
     C*******************EVAL      Fld1 = OTORC1                                       221778 CSD015
     C*******************EVAL      Fld2 = OTORC2                                       221778 CSD015
     C*******************EVAL      Fld3 = OTORC3                                       221778 CSD015
     C*******************EVAL      Fld4 = OTORC4                                       221778 CSD015
     C*******************EVAL      U = 5                                               221778 CSD015
     C*******************EXSR      SRConvert                                           221778 CSD015
     C*******************ENDIF                                                         221778 CSD015
      *******************                                                              221778 CSD015
     C*******************ENDIF                                                         221778 CSD015
      *                                                                                221778 CSD015
     C                   EXSR      OrderCust                                                  221778
                                                                                              CSD015
      ** Receivers Correspondent                                                              CSD015
     C                   IF        OTRCO1 <> *Blanks  or  OTRCO2 <> *Blanks  or               CSD015
     C                             OTRCO3 <> *Blanks  or  OTRCO4 <> *BLanks  or               CSD015
     C                             OTRCO5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTRCO1 <> CHRCO1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTRCO2 <> CHRCO2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTRCO3 <> CHRCO3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTRCO4 <> CHRCO4  or                    CSD015
     C                             OTCHTP = 'A'  and  OTRCO5 <> CHRCO5                        CSD015
     C                   EVAL      Fld1 = OTRCO1                                              CSD015
     C                   EVAL      Fld2 = OTRCO2                                              CSD015
     C                   EVAL      Fld3 = OTRCO3                                              CSD015
     C                   EVAL      Fld4 = OTRCO4                                              CSD015
     C                   EVAL      Fld5 = OTRCO5                                              CSD015
     C                   EVAL      U = 7                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Account with Bank                                                                    CSD015
     C                   IF        OTACB1 <> *Blanks  or  OTACB2 <> *Blanks  or               CSD015
     C                             OTACB3 <> *Blanks  or  OTACB4 <> *BLanks  or               CSD015
     C                             OTACB5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTACB1 <> CHACB1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTACB2 <> CHACB2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTACB3 <> CHACB3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTACB4 <> CHACB4  or                    CSD015
     C                             OTCHTP = 'A'  and  OTACB5 <> CHACB5                        CSD015
     C                   EVAL      Fld1 = OTACB1                                              CSD015
     C                   EVAL      Fld2 = OTACB2                                              CSD015
     C                   EVAL      Fld3 = OTACB3                                              CSD015
     C                   EVAL      Fld4 = OTACB4                                              CSD015
     C                   EVAL      Fld5 = OTACB5                                              CSD015
     C                   EVAL      U = 9                                                      CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Beneficiary                                                                          CSD015
     C                   IF        OTBNC1 <> *Blanks  or  OTBNC2 <> *Blanks  or               CSD015
     C                             OTBNC3 <> *Blanks  or  OTBNC4 <> *BLanks  or               CSD015
     C                             OTBNC5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTBNC1 <> CHBNC1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTBNC2 <> CHBNC2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTBNC3 <> CHBNC3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTBNC4 <> CHBNC4  or                    CSD015
     C                             OTCHTP = 'A'  and  OTBNC5 <> CHBNC5                        CSD015
     C                   EVAL      Fld1 = OTBNC1                                              CSD015
     C                   EVAL      Fld2 = OTBNC2                                              CSD015
     C                   EVAL      Fld3 = OTBNC3                                              CSD015
     C                   EVAL      Fld4 = OTBNC4                                              CSD015
     C                   EVAL      Fld5 = OTBNC5                                              CSD015
     C                   EVAL      U = 11                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Details of Payment                                                                   CSD015
     C                   IF        OTDTP1 <> *Blanks  or  OTDTP2 <> *Blanks  or               CSD015
     C                             OTDTP3 <> *Blanks  or  OTDTP4 <> *BLanks                   CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTDTP1 <> CHDTP1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDTP2 <> CHDTP2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDTP3 <> CHDTP3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTDTP4 <> CHDTP4                        CSD015
     C                   EVAL      Fld1 = OTDTP1                                              CSD015
     C                   EVAL      Fld2 = OTDTP2                                              CSD015
     C                   EVAL      Fld3 = OTDTP3                                              CSD015
     C                   EVAL      Fld4 = OTDTP4                                              CSD015
     C                   EVAL      U = 13                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Intermediary Bank                                                                    CSD015
     C                   IF        OTINB1 <> *Blanks  or  OTINB2 <> *Blanks  or               CSD015
     C                             OTINB3 <> *Blanks  or  OTINB4 <> *BLanks  or               CSD015
     C                             OTINB5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTINB1 <> CHINB1  or                    CSD015
     C                             OTCHTP = 'A'  and  OTINB2 <> CHINB2  or                    CSD015
     C                             OTCHTP = 'A'  and  OTINB3 <> CHINB3  or                    CSD015
     C                             OTCHTP = 'A'  and  OTINB4 <> CHINB4  or                    CSD015
     C                             OTCHTP = 'A'  and  OTINB5 <> CHINB5                        CSD015
     C                   EVAL      Fld1 = OTINB1                                              CSD015
     C                   EVAL      Fld2 = OTINB2                                              CSD015
     C                   EVAL      Fld3 = OTINB3                                              CSD015
     C                   EVAL      Fld4 = OTINB4                                              CSD015
     C                   EVAL      Fld5 = OTINB5                                              CSD015
     C                   EVAL      U = 15                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** MT100 Ordering Customer                                                              CSD015
     C                   IF        OTODMT <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTODMT <> CHODMT                        CSD015
     C                   EVAL      Fld1 = OTODMT                                              CSD015
     C                   EVAL      U = 17                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Third Reimbursement Institution                                                      CSD015
     C                   IF        OPTRI1 <> *Blanks  or  OPTRI2 <> *Blanks  or               CSD015
     C                             OPTRI3 <> *Blanks  or  OPTRI4 <> *BLanks  or               CSD015
     C                             OPTRI5 <> *Blanks                                          CSD015
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OPTRI1 <> CHOPTRI1  or                  CSD015
     C                             OTCHTP = 'A'  and  OPTRI2 <> CHOPTRI2  or                  CSD015
     C                             OTCHTP = 'A'  and  OPTRI3 <> CHOPTRI3  or                  CSD015
     C                             OTCHTP = 'A'  and  OPTRI4 <> CHOPTRI4  or                  CSD015
     C                             OTCHTP = 'A'  and  OPTRI5 <> CHOPTRI5                      CSD015
     C                   EVAL      Fld1 = OPTRI1                                              CSD015
     C                   EVAL      Fld2 = OPTRI2                                              CSD015
     C                   EVAL      Fld3 = OPTRI3                                              CSD015
     C                   EVAL      Fld4 = OPTRI4                                              CSD015
     C                   EVAL      Fld5 = OPTRI5                                              CSD015
     C                   EVAL      U = 19                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
                                                                                              CSD015
      ** Sender's Correspondent                                                               CSD015
     C***********        IF        OTSNCO <> *Zeros                                    CSD015 CSD027
     C                   IF        OTSNCO <> *BLANKS                                          CSD027
                                                                                              CSD015
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          CSD015
     C                             OTCHTP = 'A'  and  OTSNCO <> CHSNCO                        CSD015
     C                   MOVEL     OTSNCO        Fld1                                         CSD015
     C                   EVAL      U = 21                                                     CSD015
     C                   EXSR      SRConvert                                                  CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        CSW209 = 'Y'                                               CSW209
      *                                                                                       CSW209
      ** Ordering Customer Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        OPCOC1 <> *Blanks  OR                                      CSW209
     C                             OPCOC2 <> *Blanks  OR                                      CSW209
     C                             OPCOC3 <> *Blanks  OR                                      CSW209
     C                             OPCOC4 <> *Blanks  OR                                      CSW209
     C                             OPCOC5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOC1 <> CHOPCOC1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOC2 <> CHOPCOC2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOC3 <> CHOPCOC3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOC4 <> CHOPCOC4  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOC5 <> CHOPCOC5                                         CSW209
     C                   EVAL      Fld1 = OPCOC1                                              CSW209
     C                   EVAL      Fld2 = OPCOC2                                              CSW209
     C                   EVAL      Fld3 = OPCOC3                                              CSW209
     C                   EVAL      Fld4 = OPCOC4                                              CSW209
     C                   EVAL      Fld5 = OPCOC5                                              CSW209
     C                   EVAL      U = 23                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Ordering Bank Cover                                                                  CSW209
      *                                                                                       CSW209
     C                   IF        OPCOB1 <> *Blanks  OR                                      CSW209
     C                             OPCOB2 <> *Blanks  OR                                      CSW209
     C                             OPCOB3 <> *Blanks  OR                                      CSW209
     C                             OPCOB4 <> *Blanks  OR                                      CSW209
     C                             OPCOB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOB1 <> CHOPCOB1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOB2 <> CHOPCOB2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOB3 <> CHOPCOB3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOB4 <> CHOPCOB4  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCOB5 <> CHOPCOB5                                         CSW209
     C                   EVAL      Fld1 = OPCOB1                                              CSW209
     C                   EVAL      Fld2 = OPCOB2                                              CSW209
     C                   EVAL      Fld3 = OPCOB3                                              CSW209
     C                   EVAL      Fld4 = OPCOB4                                              CSW209
     C                   EVAL      Fld5 = OPCOB5                                              CSW209
     C                   EVAL      U = 25                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Intermediary Bank Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        OPCIB1 <> *Blanks  OR                                      CSW209
     C                             OPCIB2 <> *Blanks  OR                                      CSW209
     C                             OPCIB3 <> *Blanks  OR                                      CSW209
     C                             OPCIB4 <> *Blanks  OR                                      CSW209
     C                             OPCIB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCIB1 <> CHOPCIB1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCIB2 <> CHOPCIB2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCIB3 <> CHOPCIB3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCIB4 <> CHOPCIB4  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCIB5 <> CHOPCIB5                                         CSW209
     C                   EVAL      Fld1 = OPCIB1                                              CSW209
     C                   EVAL      Fld2 = OPCIB2                                              CSW209
     C                   EVAL      Fld3 = OPCIB3                                              CSW209
     C                   EVAL      Fld4 = OPCIB4                                              CSW209
     C                   EVAL      Fld5 = OPCIB5                                              CSW209
     C                   EVAL      U = 27                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Account with Bank Cover                                                              CSW209
      *                                                                                       CSW209
     C                   IF        OPCAB1 <> *Blanks  OR                                      CSW209
     C                             OPCAB2 <> *Blanks  OR                                      CSW209
     C                             OPCAB3 <> *Blanks  OR                                      CSW209
     C                             OPCAB4 <> *Blanks  OR                                      CSW209
     C                             OPCAB5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCAB1 <> CHOPCAB1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCAB2 <> CHOPCAB2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCAB3 <> CHOPCAB3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCAB4 <> CHOPCAB4  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCAB5 <> CHOPCAB5                                         CSW209
     C                   EVAL      Fld1 = OPCAB1                                              CSW209
     C                   EVAL      Fld2 = OPCAB2                                              CSW209
     C                   EVAL      Fld3 = OPCAB3                                              CSW209
     C                   EVAL      Fld4 = OPCAB4                                              CSW209
     C                   EVAL      Fld5 = OPCAB5                                              CSW209
     C                   EVAL      U = 29                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Beneficiary Cover                                                                    CSW209
      *                                                                                       CSW209
     C                   IF        OPCBC1 <> *Blanks  OR                                      CSW209
     C                             OPCBC2 <> *Blanks  OR                                      CSW209
     C                             OPCBC3 <> *Blanks  OR                                      CSW209
     C                             OPCBC4 <> *Blanks  OR                                      CSW209
     C                             OPCBC5 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCBC1 <> CHOPCBC1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCBC2 <> CHOPCBC2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCBC3 <> CHOPCBC3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCBC4 <> CHOPCBC4  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCBC5 <> CHOPCBC5                                         CSW209
     C                   EVAL      Fld1 = OPCBC1                                              CSW209
     C                   EVAL      Fld2 = OPCBC2                                              CSW209
     C                   EVAL      Fld3 = OPCBC3                                              CSW209
     C                   EVAL      Fld4 = OPCBC4                                              CSW209
     C                   EVAL      Fld5 = OPCBC5                                              CSW209
     C                   EVAL      U = 31                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
      ** Details of Payment Cover                                                             CSW209
      *                                                                                       CSW209
     C                   IF        OPCDP1 <> *Blanks  OR                                      CSW209
     C                             OPCDP2 <> *Blanks  OR                                      CSW209
     C                             OPCDP3 <> *Blanks  OR                                      CSW209
     C                             OPCDP4 <> *Blanks                                          CSW209
      *                                                                                       CSW209
     C                   IF        OTCHTP = 'I' OR                                            CSW209
     C                             W3UNCF = 'Y' OR                                            CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCDP1 <> CHOPCDP1  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCDP2 <> CHOPCDP2  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCDP3 <> CHOPCDP3  OR                                     CSW209
     C                             OTCHTP = 'A'  AND                                          CSW209
     C                             OPCDP4 <> CHOPCDP4                                         CSW209
     C                   EVAL      Fld1 = OPCDP1                                              CSW209
     C                   EVAL      Fld2 = OPCDP2                                              CSW209
     C                   EVAL      Fld3 = OPCDP3                                              CSW209
     C                   EVAL      Fld4 = OPCDP4                                              CSW209
     C                   EVAL      U = 33                                                     CSW209
     C                   EXSR      SRConvert                                                  CSW209
     C                   ENDIF                                                                CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CSD015
      ** If second parameter is not blank, setup first parameter and                          CSD015
      ** send transaction details to Compliance Watch by calling SDCWLCHK                     CSD015
      *                                                                                       CSD015
     C                   IF        PString <> *Blanks                                         CSD015
                                                                                              CSD015
     C                   EXSR      SRSet1stParm                                               CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLCHK'                                                 CSD015
     C                   PARM                    SDWLTD                                       CSD015
     C                   PARM                    PString                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRSet1stParm - Setup first parameter of SDCWLCHK.             *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRSet1stParm  BEGSR                                                                CSD015
                                                                                              CSD015
      ** Item Type Code                                                                       CSD015
     C                   EVAL      W4ITEM = 'FTOPAY'                                          CSD015
                                                                                              CSD015
      ** Identifier                                                                           CSD015
     C                   EVAL      W4IDEN = OTPREF                                            CSD015
                                                                                              CSD015
      ** Branch                                                                               CSD015
     C                   EVAL      W4BRCH = OTBRCA                                            CSD015
                                                                                              CSD015
      ** System                                                                               CSD015
      ** If Midas 24x7 is installed, use Main system prefix otherwise use system prefix       CSD015
     C                   IF        @CSC011 = 'Y'                                              CSD015
     C                   EVAL      W4SYSM = S1MAIN                                            CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      W4SYSM = LIBR                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Function Type                                                                        CSD015
     C                   EVAL      W4FUNT = 'OTPAYDD'                                         CSD015
                                                                                              CSD015
      ** Counterparty Details                                                                 CSD015
      ** If MT100/MT103 customer is present use it. otherwise check                           CSD015
      ** ordering customer, else ordering bank.                                               CSD015
                                                                                              CSD015
     C                   IF        OTODMT <> *Blanks                                          CSD015
     C                   EVAL      Fld1 = OTODMT                                              CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        OTORC1 <> *Blanks  or  OTORC2 <> *Blanks  or               CSD015
     C                             OTORC3 <> *Blanks  or  OTORC4 <> *Blanks                   CSD015
     C                   EVAL      Fld1 = OTORC1                                              CSD015
     C                   EVAL      Fld2 = OTORC2                                              CSD015
     C                   EVAL      Fld3 = OTORC3                                              CSD015
     C                   EVAL      Fld4 = OTORC4                                              CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (OTORC1 = *Blanks and OTORC2 = *Blanks and                 CSD015
     C                             OTORC3 = *Blanks and  OTORC4 = *Blanks)                    CSD015
     C                             or OutFmt2 = '*FREE' or OutFmt2 = '*CPART'                 CSD015
     C                   IF        OTOPMSGR > 0                                               CSD015
     C                   EVAL      Fld1 = OTOPORB1                                            CSD015
     C                   EVAL      Fld2 = OTOPORB2                                            CSD015
     C                   EVAL      Fld3 = OTOPORB3                                            CSD015
     C                   EVAL      Fld4 = OTOPORB4                                            CSD015
     C                   EVAL      Fld5 = OTOPORB5                                            CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        (OTORC1 = *Blanks and OTORC2 = *Blanks and                 CSD015
     C                             OTORC3 = *Blanks  and OTORC4 = *Blanks and                 CSD015
     C                             OTOPMSGR = 0)                                              CSD015
     C                             or OutFmt2 = '*FREE' or OutFmt2 = '*CPART'                 CSD015
                                                                                              CSD015
     C                   MOVE      *BLANKS       OrderingBank                                 CSD015
     C                   SELECT                                                               CSD015
     C                   WHEN      OTORBT = 'N'                                               CSD015
     C                   MOVEL     OTORBK        ORBKNostro                                   CSD015
     C                   MOVEL     OrderingBank  Fld1                                         CSD015
     C                   WHEN      OTORBT = 'R'                                               CSD015
     C                   MOVEL     OTORBK        ORBKRetail                                   CSD015
     C                   MOVEL     OrderingBank  Fld1                                         CSD015
     C                   OTHER                                                                CSD015
     C                   MOVEL     OTORBK        Fld1                                         CSD015
     C                   ENDSL                                                                CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
                                                                                              CSD015
     C                   EXSR      SRGetCtrpDet                                               CSD015
     C                   ENDIF                                                                CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      W4CNUM = OutFmt2                                           CSD015
     C                   EVAL      W4CTYP = WCtrpTyp                                          CSD015
     C                   EVAL      W4CUST = WCtrpRpt                                          CSD015
                                                                                              CSD015
      ** Deal Date                                                                            CSD015
     C                   MOVE      '00000'       PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4DDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Value Date                                                                           CSD015
     C                   MOVE      OTSLDT        PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4VDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Maturity Date                                                                        CSD015
     C                   MOVE      OTPVDT        PZADayNo                                     CSD015
     C                   EXSR      SRDateToDDT                                                CSD015
     C                   EVAL      W4MDAT = WDDT                                              CSD015
                                                                                              CSD015
      ** Denomination Side 1                                                                  CSD015
     C                   EVAL      W4DEN1  = OTSMCY                                           CSD015
                                                                                              CSD015
      ** Denomination Side 2                                                                  CSD015
     C                   EVAL      W4DEN2  = OTPCCY                                           CSD015
                                                                                              CSD015
      ** Amount Side 1                                                                        CSD015
     C                   EVAL      PZACcy = OTSMCY                                            CSD015
     C                   MOVE      OTSMAM        PZAAmt                                       CSD015
     C                   EXSR      SRAmtToFPDT                                                CSD015
     C                   EVAL      W4AMT1 = WFPDT                                             CSD015
                                                                                              CSD015
      ** Amount Side 2                                                                        CSD015
     C                   EVAL      PZACcy = OTPCCY                                            CSD015
     C                   MOVE      OTPYAM        PZAAmt                                       CSD015
     C                   EXSR      SRAmtToFPDT                                                CSD015
     C                   EVAL      W4AMT2 = WFPDT                                             CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRDateToDDT - Converts a date into Date Data Type format.     *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRDateToDDT   BEGSR                                                                CSD015
                                                                                              CSD015
      ** Convert the derived Midas Day Number into Date Data Type.                            CSD015
                                                                                              CSD015
     C                   CALL      'ZACVTDATE'                                                CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM                    PZADayNo                                     CSD015
     C                   PARM                    PZADDT                                       CSD015
     C                   PARM                    PConvtDate                                   CSD015
                                                                                              CSD015
     C                   EVAL      WDDT = PZADDT                                              CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRAmtToFPDT - Converts an amount into Floating Point Data     *                       CSD015
      *               Type format.                                    *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRAmtToFPDT   BEGSR                                                                CSD015
      *                                                                                       CSD015
      ** Directly convert the given amount into Floating Point format.                        CSD015
      *                                                                                       CSD015
     C                   CALL      'ZACVTAMT'                                                 CSD015
     C                   PARM      *BLANKS       PZARtCd                                      CSD015
     C                   PARM                    PZACcy                                       CSD015
     C                   PARM                    PZAAmt                                       CSD015
     C                   PARM      0E0           PZOutAmt                                     CSD015
     C                   PARM                    PZCvtAmt                                     CSD015
      *                                                                                       CSD015
     C                   EVAL      WFPDT = PZOutAmt                                           CSD015
      *                                                                                       CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRGetCtrpDet - Gets the Counterparty Details given a Customer *                       CSD015
      *                Number.                                        *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRGetCtrpDet  BEGSR                                                                CSD015
                                                                                              CSD015
      ** Initialise the relevant variables.                                                   CSD015
                                                                                              CSD015
     C                   EVAL      PCustNo = *BLANKS                                          CSD015
     C                   EVAL      WCtrpRpt = *BLANKS                                         CSD015
     C                   EVAL      WCtrpTyp = *BLANKS                                         CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *Blanks       @Rtcd                                        CSD015
     C                   PARM      Fld1          PInput                                       CSD015
     C                   PARM      Fld2          PInput1                                      CSD015
     C                   PARM      Fld3          PInput2                                      CSD015
     C                   PARM      Fld4          PInput3                                      CSD015
     C                   PARM                    PInput4                                      CSD015
     C                   PARM                    PInput5                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    OutFmt                                       CSD015
     C                   PARM                    OutFmt2                                      CSD015
                                                                                              CSD015
     C                   IF        @Rtcd <> *Blanks  and                                      CSD015
     C                             @Rtcd <> '*NRF  '                                          CSD015
     C                   EVAL      DBKey = Fld1                                               CSD015
     C                   EVAL      DBFile = 'SDCWLFMT'                                        CSD015
     C                   EVAL      DBase = 13                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
     C                   EVAL      PCustNo = OutFmt2                                          CSD015
                                                                                              CSD015
      ** Get the Customer Detail.                                                             CSD015
                                                                                              CSD015
     C                   CALL      'AOCUSTR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM                    PCustNo                                      CSD015
     C                   PARM      *BLANKS       PErrInf                                      CSD015
     C     SDCUST        PARM      SDCUST        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *Blanks                                            CSD015
                                                                                              CSD015
      ** Assemble the Counterparty Report information.                                        CSD015
                                                                                              CSD015
     C     BBCRNM        CAT       BBCRTN        WCtrpRpt                                     CSD015
                                                                                              CSD015
      ** Determine the Counterparty Type.                                                     CSD015
                                                                                              CSD015
     C                   IF        @CCF001 = 'Y'                                              CSD015
                                                                                              CSD015
     C                   IF        BBCRPC = 'Y'                                               CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
     C                   IF        BBLICD <> *BLANKS AND                                      CSD015
     C                             BBLICD <> W1IND1  AND                                      CSD015
     C                             BBLICD <> W1IND2  AND                                      CSD015
     C                             BBLICD <> W1IND3  AND                                      CSD015
     C                             BBLICD <> W1IND4  AND                                      CSD015
     C                             BBLICD <> W1IND5                                           CSD015
     C                   EVAL      WCtrpTyp = 'C'                                             CSD015
     C                   ELSE                                                                 CSD015
     C                   EVAL      WCtrpTyp = 'I'                                             CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ELSE                                                                 CSD015
                                                                                              CSD015
      ** Handle Database Errors if any occur.                                                 CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCUSTPD'                                        CSD015
     C                   EVAL      DBase = 21                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       CSD015
      /EJECT                                                                                  CSD015
      *****************************************************************                       CSD015
      *                                                               *                       CSD015
      * SRConvert - Subroutine to convert accounts, customer no. to   *                       CSD015
      *             customer name and address.                        *                       CSD015
      * Called by: SRWatch                                            *                       CSD015
      *                                                               *                       CSD015
      * Calls: SDCWHLCHK                                              *                       CSD015
      *                                                               *                       CSD015
      *****************************************************************                       CSD015
     C     SRConvert     BEGSR                                                                CSD015
                                                                                              CSD015
     C                   EVAL      OutFmt = *Blanks                                           CSD015
     C                   EVAL      PInput = *Blanks                                           CSD015
     C                   EVAL      PInput1 = *Blanks                                          CSD015
     C                   EVAL      PInput2 = *Blanks                                          CSD015
     C                   EVAL      PInput3 = *Blanks                                          CSD015
     C                   EVAL      PInput4 = *Blanks                                          CSD015
                                                                                              CSD015
     C                   CALL      'SDCWLFMT'                                                 CSD015
     C                   PARM      *Blanks       @Rtcd                                        CSD015
     C                   PARM      Fld1          PInput                                       CSD015
     C                   PARM      Fld2          PInput1                                      CSD015
     C                   PARM      Fld3          PInput2                                      CSD015
     C                   PARM      Fld4          PInput3                                      CSD015
     C                   PARM      Fld5          PInput4                                      CSD015
     C                   PARM                    PInput5                                      CSD015
     C                   PARM                    PInCcy                                       CSD015
     C                   PARM                    OutFmt                                       CSD015
     C                   PARM                    OutFmt2                                      CSD015
                                                                                              CSD015
     C                   IF        @Rtcd <> *Blanks  and                                      CSD015
     C                             @Rtcd <> '*NRF  '                                          CSD015
     C                   EVAL      DBKey = Fld1                                               CSD015
     C                   EVAL      DBFile = 'SDCWLFMT'                                        CSD015
     C                   EVAL      DBase = 10                                                 CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   EVAL      Fld1 = *Blanks                                             CSD015
     C                   EVAL      Fld2 = *Blanks                                             CSD015
     C                   EVAL      Fld3 = *Blanks                                             CSD015
     C                   EVAL      Fld4 = *Blanks                                             CSD015
     C                   EVAL      Fld5 = *Blanks                                             CSD015
                                                                                              CSD015
     C     PString       CAT       WLARR(U):0    PString                                      CSD015
     C     PString       CAT       OUTFMT:0      PString                                      CSD015
     C                   EVAL      U = U+1                                                    CSD015
     C     PString       CAT       WLARR(U):0    PString                                      CSD015
                                                                                              CSD015
     C                   ENDSR                                                                CSD015
      *****************************************************************                       221778
      /EJECT                                                                                  221778
      *****************************************************************                       221778
      *                                                               *                       221778
      * OrderCust - Subroutine to convert Ordering Customer details   *                       221778
      *             if valid shortname or account number specified    *                       221778
      *             then add details to string to be Watch List       *                       221778
      *             Checked                                           *                       221778
      *                                                               *                       221778
      * Called by: SRWatch                                            *                       221778
      *                                                               *                       221778
      * Calls: SDCWLFMT                                               *                       221778
      *                                                               *                       221778
      *****************************************************************                       221778
     C     OrderCust     BEGSR                                                                221778
                                                                                              221778
     C                   EVAL      OutFmt = *Blanks                                           221778
                                                                                              221778
     C                   IF        OTORC1 <> *Blanks  or  OTORC2 <> *Blanks  or               221778
     C                             OTORC3 <> *Blanks  or  OTORC4 <> *Blanks                   221778
                                                                                              221778
     C                   IF        OTCHTP = 'I'  or  W3UNCF = 'Y' or                          221778
     C                             OTCHTP = 'A'  and  OTORC1 <> CHORC1  or                    221778
     C                             OTCHTP = 'A'  and  OTORC2 <> CHORC2  or                    221778
     C                             OTCHTP = 'A'  and  OTORC3 <> CHORC3  or                    221778
     C                             OTCHTP = 'A'  and  OTORC4 <> CHORC4                        221778
      *                                                                                       221778
      *                                                                                       221778
      *                                                                                       221778
      ** If field contains 10 characters or less attempt to expand customer details           221778
      *                                                                                       221778
     C                   EVAL      OTORCX = %SUBST(OTORC1:11:25)                              221778
     C                   IF        OTORCX = *Blanks                                           221778
      *                                                                                       221778
     C                   EVAL      PInput = *Blanks                                           221778
     C                   EVAL      PInput1 = *Blanks                                          221778
     C                   EVAL      PInput2 = *Blanks                                          221778
     C                   EVAL      PInput3 = *Blanks                                          221778
     C                   EVAL      PInput4 = *Blanks                                          221778
                                                                                              221778
     C                   CALL      'SDCWLFMT'                                                 221778
     C                   PARM      *Blanks       @Rtcd                                        221778
     C                   PARM      OTORC1        PInput                                       221778
     C                   PARM      OTORC2        PInput1                                      221778
     C                   PARM      OTORC3        PInput2                                      221778
     C                   PARM      OTORC4        PInput3                                      221778
     C                   PARM      Fld5          PInput4                                      221778
     C                   PARM                    PInput5                                      221778
     C                   PARM                    PInCcy                                       221778
     C                   PARM                    OutFmt                                       221778
     C                   PARM                    OutFmt2                                      221778
                                                                                              221778
     C                   IF        @Rtcd <> *Blanks  and                                      221778
     C                             @Rtcd <> '*NRF  '                                          221778
     C                   EVAL      DBKey = OTORC1                                             221778
     C                   EVAL      DBFile = 'SDCWLFMT'                                        221778
     C                   EVAL      DBase = 10                                                 221778
     C                   EXSR      *PSSR                                                      221778
     C                   ENDIF                                                                221778
                                                                                              221778
     C                   ENDIF                                                                221778
                                                                                              221778
      ** If field contains more than 10 characters or expansion failed because no such cust.  221778
     C                   IF        OTORCX <> *Blanks or @Rtcd = '*NRF  '                      221778
     C                   EVAL      OutFmt = OTORC1 + ' ' +                                    221778
     C                                      OTORC2 + ' ' +                                    221778
     C                                      OTORC3 + ' ' +                                    221778
     C                                      OTORC4                                            221778
     C                   ENDIF                                                                221778
                                                                                              221778
                                                                                              221778
     C     PString       CAT       WLARR(5):0    PString                                      221778
     C     PString       CAT       OutFmt:0      PString                                      221778
     C     PString       CAT       WLARR(6):0    PString                                      221778
      *                                                                                       221778
      *                                                                                       221778
      *                                                                                       221778
     C                   ENDIF                                                                221778
                                                                                              221778
     C                   ENDIF                                                                221778
                                                                                              221778
     C                   ENDSR                                                                221778
      *****************************************************************                       221778
      *****************************************************************                       CSD015
     C/EJECT
     C********************************************************************
      *                                                               *
      * *INZSR - Program Initialisation routine                       *
      *                                                               *
      * Called by: Main processing                                    *
      *                                                               *
      * Calls: None                                                   *
      *                                                               *
      *****************************************************************
     C     *INZSR        BEGSR
      *
      **  PROGRAM PARAMETERS
      *
     C     *ENTRY        PLIST
      *  Return Code
     C                   Parm                    RetCodeIn
 
      *  OK Flags
     C                   Parm                    FTEOPY1
     C                   Parm                    FTEOPY2
     C                   Parm                    FTEOPY3
     C                   Parm                    FTEOPY4                        CFT014
     C                   Parm                    FTEOPY5                        CFT014
 
      * New Valid payment layout
     C                   PARM                    ValidPmnt
     C                   PARM                    ValidPmntB                     CFT014
 
      *  Validation Work Fields
     C                   Parm                    Val@Fields
      *                                                                                       CAP211
     C                   PARM                    PAuth             1                          CAP211
     C                   PARM                    PUser            10                          CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPAYDC12
 
      * ACCESS BANK DETAILS
     C                   CALL      'AOBANKR0'
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*FIRST '     @OPTN             7
     C     SDBANK        PARM      SDBANK        DSFDY
      *
      * DATABASE ERROR
      *
     C     C#RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDBANKPD'    DBKEY
     C                   MOVEL     '901'         DBASE
     C                   MOVEL     @OPTN         DBFILE
     C                   EXSR      *PSSR
     C                   END
      *
      *  Access Module Details
     C                   CALL      'AOMMODR0'
     C                   PARM      *BLANKS       C#RTCD
     C                   PARM      '*FIRST '     @OPTN
     C     SDMMOD        PARM      SDMMOD        DSFDY
      *
      * DATABASE ERROR
      *
     C     C#RTCD        IFNE      *BLANKS
     C                   MOVEL     'SDMMODPD'    DBKEY
     C                   MOVEL     '904'         DBASE
     C                   MOVEL     '*FIRST '     DBFILE
     C                   EXSR      *PSSR
     C                   END
     C/COPY WNCPYSRC,FTH00111
      *
      * Access Funds Transfer details via access program
      *  (database error handling done in access program)
     C                   CALL      'AOFTFRR0'
     C                   Parm      '*DBERR'      C#RTCD
     C                   Parm      '*FIRST'      @OPTN
     C     SDFTFR        Parm      SDFTFR        DSFDY
                                                                                              CSC011
      ** Get support system prefix and current system prefix                                  CSC011
                                                                                              CSC011
     C                   IF        @CSC011 = 'Y'                                              CSC011
     C                   IN        SC24X7                                                     CSC011
     C**********         IN        SDSTAT                                              CSC011 CSD015
     C                   ENDIF                                                                CSC011
                                                                                              CSC011
      ** Check if Compliance Watch Enhancement (CSD015) is installed                          CSD015
                                                                                              CSD015
     C                   EVAL      @CSD015 = 'N'                                              CSD015
     C                   IN        SDSTAT                                                     CSD015
                                                                                              CSD015
     C                   CALLB     'AOSARDR0'                                                 CSD015
     C                   PARM      *Blank        @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CSD015'      @Sard                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        (@RtCd <> *BLANKS) and                                     CSD015
     C                             (@RtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'CSD015'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 7                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *Blank                                             CSD015
     C                   EVAL      @CSD015 = 'Y'                                              CSD015
                                                                                              CSD015
      ** Check if function code is being monitored by the compliance watch                    CSD015
                                                                                              CSD015
     C                   EVAL      W1EWLC = *Blanks                                           CSD015
     C                   CALLB     'AOWLCCR0'                                                 CSD015
     C                   PARM      *Blank        @RtCd                                        CSD015
     C                   PARM      '*KEY   '     @Optn                                        CSD015
     C                   PARM      'FTOPAY'      @Func                                        CSD015
     C     SDWLCC        PARM      SDWLCC        DSSDY                                        CSD015
                                                                                              CSD015
      ** If return code not blank, then issue database errror                                 CSD015
                                                                                              CSD015
     C                   IF        (@RtCd <> *Blank) and                                      CSD015
     C                             (@RtCd <> '*NRF   ')                                       CSD015
     C                   EVAL      DBKey = 'FTOPAY'                                           CSD015
     C                   EVAL      DBFile = 'SDWLCCPD'                                        CSD015
     C                   EVAL      DBase = 8                                                  CSD015
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access Compliance Watch Configuration Data if necessary.                            CSD015
                                                                                              CSD015
     C                   CALL      'AOCWCDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*FIRST'      @Optn                                        CSD015
     C     SDCWCD        PARM      SDCWCD        DSSDY                                        CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *Blanks                                           CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = @Optn                                              CSD015
     C                   EVAL      DBFile = 'SDCWCDPD'                                        CSD015
     C                   EVAL      DBase = 11                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      **  Access SAR details to see if CCF001 is switched on.                                 CSD015
                                                                                              CSD015
     C                   EVAL      @CCF001 = 'N'                                              CSD015
     C                   CALL      'AOSARDR0'                                                 CSD015
     C                   PARM      *BLANKS       @RtCd                                        CSD015
     C                   PARM      '*VERIFY'     @Optn                                        CSD015
     C                   PARM      'CCF001'      @SARD                                        CSD015
                                                                                              CSD015
      ** Database error                                                                       CSD015
                                                                                              CSD015
     C                   IF        @RtCd <> *Blanks  and                                      CSD015
     C                             @RtCd <> '*NRF'                                            CSD015
     C     *LOCK         IN        LDA                                                        CSD015
     C                   EVAL      DBKey = 'CCF001'                                           CSD015
     C                   EVAL      DBFile = 'SCSARDPD'                                        CSD015
     C                   EVAL      DBase = 12                                                 CSD015
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
     C                   IF        @RtCd = *BLANKS                                            CSD015
     C                   EVAL      @CCF001 = 'Y'                                              CSD015
     C                   ENDIF                                                                CSD015
                                                                                              CSD015
      ** Compliance Watch Hit List Key List                                                   CSD015
                                                                                              CSD015
     C     CWHTKY        KLIST                                                                CSD015
     C                   KFLD                    WFUNT             8                          CSD015
     C                   KFLD                    WIDEN            40                          CSD015
     C                   KFLD                    BRCA                                         CSD015
                                                                                              CSD015
      ** Check if Online Printing of Advices (GE7) is on.                                     CRE020
                                                                                              CRE020
     C                   EVAL      CRE020 = 'N'                                               CRE020
     C                   CALL      'AOSARDR0'                                                 CRE020
     C                   PARM      *BLANKS       PRTCD                                        CRE020
     C                   PARM      '*VERIFY'     POPTN                                        CRE020
     C                   PARM      'CRE020'      PSARD                                        CRE020
     C     SCSARD        PARM      SCSARD        DSFDY                                        CRE020
                                                                                              CRE020
     C                   IF        PRTCD <> *Blanks  and                                      CRE020
     C                             PRTCD <> '*NRF'                                            CRE020
     C     *LOCK         IN        LDA                                                        CRE020
     C                   EVAL      DBKey = 'CRE020'                                           CRE020
     C                   EVAL      DBFile = 'SCSARDPD'                                        CRE020
     C                   EVAL      DBase = 22                                                 CRE020
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
     C                   IF        PRTCD = *BLANKS                                            CRE020
     C                   EVAL      CRE020 = 'Y'                                               CRE020
     C                   ENDIF                                                                CRE020
                                                                                              CRE020
                                                                                              CAP205
     C/COPY WNCPYSRC,FTH00109
      ** Determine if SAR CAP205 is installed                                                 CAP205
                                                                                              CAP205
     C                   MOVEL     'N'           CAP205                                       CAP205
     C                   CALL      'AOSARDR0'                                                 CAP205
     C                   PARM      *BLANKS       PRTCD                                        CAP205
     C                   PARM      '*VERIFY'     POPTN                                        CAP205
     C                   PARM      'CAP205'      PSARD                                        CAP205
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP205
                                                                                              CAP205
     C                   IF        PRTCD <> *BLANKS  AND                                      CAP205
     C                             PRTCD <> '*NRF'                                            CAP205
     C     *LOCK         IN        LDA                                                        CAP205
     C                   EVAL      DBKEY = 'CAP205'                                           CAP205
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CAP205
     C                   EVAL      DBASE = 23                                                 CAP205
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   IF        PRTCD = *BLANKS                                            CAP205
     C                   EVAL      CAP205 = 'Y'                                               CAP205
     C                   ENDIF                                                                CAP205
                                                                                              CAP205
     C                   MOVE      'N'           CAP211            1                          CAP211
     C                   CALL      'AOSARDR0'                                                 CAP211
     C                   PARM      *Blanks       PRTCD                                        CAP211
     C                   PARM      '*VERIFY'     POPTN                                        CAP211
     C                   PARM      'CAP211'      PSARD                                        CAP211
     C     SCSARD        PARM      SCSARD        DSFDY                                        CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD <> *Blanks  AND                                      CAP211
     C                             PRTCD <> '*NRF'                                            CAP211
     C     *LOCK         IN        LDA                                                        CAP211
     C                   EVAL      DBKey = 'CAP211'                                           CAP211
     C                   EVAL      DBFile = 'SCSARDPD'                                        CAP211
     C                   EVAL      DBase = 24                                                 CAP211
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C                   IF        PRTCD = *Blanks                                            CAP211
     C                   EVAL      CAP211 = 'Y'                                               CAP211
     C                   ENDIF                                                                CAP211
      *                                                                                       CAP211
     C/COPY WNCPYSRC,FTOPAYDC08
 
     C                   CALLB     'AOSARDR0'                                                 CFT157
     C                   Parm      *BLANKS       @RTCD                                        CFT157
     C                   Parm      '*VERIFY'     @OPTN                                        CFT157
     C                   Parm      'CFT157'      @SARD                                        CFT157
     C     SCSARD        Parm      SCSARD        DSFDY                                        CFT157
                                                                                              CFT157
     C                   If        @RTCD <> *Blanks and                                       CFT157
     C                             @RTCD <> '*NRF   '                                         CFT157
     C     *LOCK         In        LDA                                                        CFT157
     C                   Movel     'SCSARDPD'    DBFILE                                       CFT157
     C                   Movel     '202'         DBASE                                        CFT157
     C                   Movel     'CFT157'      DBKEY                                        CFT157
     C                   Out       LDA                                                        CFT157
     C                   Exsr      *PSSR                                                      CFT157
     C                   End                                                                  CFT157
                                                                                              CFT157
     C                   If        @RTCD = *Blanks                                            CFT157
     C                   Movel     'Y'           @CFT157           1                          CFT157
     C                   Else                                                                 CFT157
     C                   Movel     'N'           @CFT157                                      CFT157
     C                   End                                                                  CFT157
      *                                                                                       CFT049
      *** Check if CFT049 is switched on                                                      CFT049
      *                                                                                       CFT049
     C                   MOVE      'N'           CFT049            1                          CFT049
     C                   CALL      'AOSARDR0'                                                 CFT049
     C                   PARM      *BLANKS       @RTCD                                        CFT049
     C                   PARM      '*VERIFY'     @OPTN                                        CFT049
     C                   PARM      'CFT049'      @SARD                                        CFT049
      *                                                                                       CFT049
     C     @RTCD         IFEQ      *BLANK                                                     CFT049
     C                   MOVE      'Y'           CFT049                                       CFT049
     C                   ENDIF                                                                CFT049
      *                                                                                       CSW220
      ** Determine if Swift 2020 is activated                                                 CSW220
      *                                                                                       CSW220
     C                   CALL      'SWIFTACTV'                                                CSW220
     C                   PARM      'CSW220'      PSWIFT                                       CSW220
     C                   PARM      *BLANKS       PRTNCD                                       CSW220
      *                                                                                       CSW220
     C     PRTNCD        IFEQ      'CSWACTV'                                                  CSW220
     C                   MOVE      'Y'           CSW220                                       CSW220
     C                   ELSE                                                                 CSW220
     C                   MOVE      'N'           CSW220                                       CSW220
     C                   ENDIF                                                                CSW220
 
     C                   ENDSR
      *****************************************************************                       CGL029
     C/EJECT                                                                                 BUG4449
     C*****************************************************************                      BUG4449
      *                                                               *                      BUG4449
      * INSSR - Program Initialisation routine                        *                      BUG4449
      *                                                               *                      BUG4449
      * Called by: Main processing                                    *                      BUG4449
      *                                                               *                      BUG4449
      * Calls: None                                                   *                      BUG4449
      *                                                               *                      BUG4449
      *****************************************************************                      BUG4449
     C     INSSR         BEGSR                                                               BUG4449
                                                                                             BUG4449
      **  Access SAR details to see if CSC011 is switched on.                                BUG4449
                                                                                             BUG4449
     C                   EVAL      @CSC011 = 'N'                                             BUG4449
     C                   CALL      'AOSARDR0'                                                BUG4449
     C                   PARM      *BLANKS       @RtCd                                       BUG4449
     C                   PARM      '*VERIFY'     @Optn                                       BUG4449
     C                   PARM      'CSC011'      @SARD                                       BUG4449
                                                                                             BUG4449
      ** Database error                                                                      BUG4449
                                                                                             BUG4449
     C                   IF        @RtCd <> *Blanks  and                                     BUG4449
     C                             @RtCd <> '*NRF'                                           BUG4449
     C     *LOCK         IN        LDA                                                       BUG4449
     C                   EVAL      DBKey = 'CSC011'                                          BUG4449
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4449
     C                   EVAL      DBase = 14                                                BUG4449
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
     C                   IF        @RtCd = *BLANKS                                           BUG4449
     C                   EVAL      @CSC011 = 'Y'                                             BUG4449
     C                   ENDIF                                                               BUG4449
      ** Get support system prefix and current system prefix                                 BUG4449
                                                                                             BUG4449
     C                   IF        @CSC011 = 'Y'                                             BUG4449
     C                   IN        SC24X7                                                    BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
      ** Check if Compliance Watch Enhancement (CSD015) is installed                         BUG4449
                                                                                             BUG4449
     C                   EVAL      @CSD015 = 'N'                                             BUG4449
     C                   IN        SDSTAT                                                    BUG4449
                                                                                             BUG4449
     C                   CALLB     'AOSARDR0'                                                BUG4449
     C                   PARM      *Blank        @RtCd                                       BUG4449
     C                   PARM      '*VERIFY'     @Optn                                       BUG4449
     C                   PARM      'CSD015'      @Sard                                       BUG4449
                                                                                             BUG4449
      ** Database error                                                                      BUG4449
                                                                                             BUG4449
     C                   IF        (@RtCd <> *BLANKS) and                                    BUG4449
     C                             (@RtCd <> '*NRF   ')                                      BUG4449
     C                   EVAL      DBKey = 'CSD015'                                          BUG4449
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4449
     C                   EVAL      DBase =15                                                 BUG4449
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
     C                   IF        @RtCd = *Blank                                            BUG4449
     C                   EVAL      @CSD015 = 'Y'                                             BUG4449
      ** Check if function code is being monitored by the compliance watch                   BUG4449
                                                                                             BUG4449
     C                   EVAL      W1EWLC = *Blanks                                          BUG4449
     C                   CALLB     'AOWLCCR0'                                                BUG4449
     C                   PARM      *Blank        @RtCd                                       BUG4449
     C                   PARM      '*KEY   '     @Optn                                       BUG4449
     C                   PARM      'FTOPAY'      @Func                                       BUG4449
     C     SDWLCC        PARM      SDWLCC        DSSDY                                       BUG4449
      ** If return code not blank, then issue database errror                                BUG4449
                                                                                             BUG4449
     C                   IF        (@RtCd <> *Blank) and                                     BUG4449
     C                             (@RtCd <> '*NRF   ')                                      BUG4449
     C                   EVAL      DBKey = 'FTOPAY'                                          BUG4449
     C                   EVAL      DBFile = 'SDWLCCPD'                                       BUG4449
     C                   EVAL      DBase = 16                                                BUG4449
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
      **  Access Compliance Watch Configuration Data if necessary.                           BUG4449
                                                                                             BUG4449
     C                   CALL      'AOCWCDR0'                                                BUG4449
     C                   PARM      *BLANKS       @RtCd                                       BUG4449
     C                   PARM      '*FIRST'      @Optn                                       BUG4449
     C     SDCWCD        PARM      SDCWCD        DSSDY                                       BUG4449
                                                                                             BUG4449
     C                   IF        @RtCd <> *Blanks                                          BUG4449
     C     *LOCK         IN        LDA                                                       BUG4449
     C                   EVAL      DBKey = @Optn                                             BUG4449
     C                   EVAL      DBFile = 'SDCWCDPD'                                       BUG4449
     C                   EVAL      DBase = 17                                                BUG4449
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
     C                   ENDIF                                                               BUG4449
      **  Access SAR details to see if CCF001 is switched on.                                BUG4449
                                                                                             BUG4449
     C                   EVAL      @CCF001 = 'N'                                             BUG4449
     C                   CALL      'AOSARDR0'                                                BUG4449
     C                   PARM      *BLANKS       @RtCd                                       BUG4449
     C                   PARM      '*VERIFY'     @Optn                                       BUG4449
     C                   PARM      'CCF001'      @SARD                                       BUG4449
                                                                                             BUG4449
      ** Database error                                                                      BUG4449
                                                                                             BUG4449
     C                   IF        @RtCd <> *Blanks  and                                     BUG4449
     C                             @RtCd <> '*NRF'                                           BUG4449
     C     *LOCK         IN        LDA                                                       BUG4449
     C                   EVAL      DBKey = 'CCF001'                                          BUG4449
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4449
     C                   EVAL      DBase = 18                                                BUG4449
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
     C                   IF        @RtCd = *BLANKS                                           BUG4449
     C                   EVAL      @CCF001 = 'Y'                                             BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
      ** Check if Online Printing of Advices (GE7) is on.                                    BUG4449
     C                   EVAL      CRE020 = 'N'                                              BUG4449
     C                   CALL      'AOSARDR0'                                                BUG4449
     C                   PARM      *BLANKS       PRTCD                                       BUG4449
     C                   PARM      '*VERIFY'     POPTN                                       BUG4449
     C                   PARM      'CRE020'      PSARD                                       BUG4449
     C     SCSARD        PARM      SCSARD        DSFDY                                       BUG4449
     C                   IF        PRTCD <> *Blanks  and                                     BUG4449
     C                             PRTCD <> '*NRF'                                           BUG4449
     C     *LOCK         IN        LDA                                                       BUG4449
     C                   EVAL      DBKey = 'CRE020'                                          BUG4449
     C                   EVAL      DBFile = 'SCSARDPD'                                       BUG4449
     C                   EVAL      DBase = 19                                                BUG4449
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                     BUG4449
     C                   ENDIF                                                               BUG4449
                                                                                             BUG4449
     C                   IF        PRTCD = *BLANKS                                           BUG4449
     C                   EVAL      CRE020 = 'Y'                                              BUG4449
     C                   ENDIF                                                               BUG4449
      ** Check if Watch List Element (CSD083) is on                                           CSD083
                                                                                              CSD083
     C                   CALL      'AOSARDR0'                                                 CSD083
     C                   PARM      *BLANKS       PRTCD                                        CSD083
     C                   PARM      '*VERIFY'     POPTN                                        CSD083
     C                   PARM      'CSD083'      PSARD                                        CSD083
     C     SCSARD        PARM      SCSARD        DSFDY                                        CSD083
                                                                                              CSD083
     C                   IF        PRTCD <> *BLANKS  AND                                      CSD083
     C                             PRTCD <> '*NRF'                                            CSD083
     C     *LOCK         IN        LDA                                                        CSD083
     C                   EVAL      DBKEY = 'CSD083'                                           CSD083
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CSD083
     C                   EVAL      DBASE = 45                                                 CSD083
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
     C                   IF        PRTCD = *BLANKS                                            CSD083
     C                   EVAL      @CSD015 = 'N'                                              CSD083
     C                   ENDIF                                                                CSD083
                                                                                              CSD083
      *                                                                                       CSW209
      ** Check if CSW209 is switch on                                                         CSW209
      *                                                                                       CSW209
     C                   EVAL      CSW209 = 'N'                                               CSW209
      *                                                                                       CSW209
     C                   CALL      'SWIF2009'                                                 CSW209
     C                   PARM                    PRTCD                                        CSW209
     C     PRTCD         IFEQ      'CSW2009'                                                  CSW209
     C                   EVAL      CSW209 = 'Y'                                               CSW209
     C                   ENDIF                                                                CSW209
      *                                                                                       CFT120
      ** Check if CFT120 is on                                                                CFT120
      *                                                                                       CFT120
     C                   CALL      'AOSARDR0'                                                 CFT120
     C                   PARM      *BLANKS       PRTCD                                        CFT120
     C                   PARM      '*VERIFY'     POPTN                                        CFT120
     C                   PARM      'CFT120'      PSARD                                        CFT120
     C     SCSARD        PARM      SCSARD        DSFDY                                        CFT120
                                                                                              CFT120
     C                   IF        PRTCD <> *BLANKS  AND                                      CFT120
     C                             PRTCD <> '*NRF'                                            CFT120
     C     *LOCK         IN        LDA                                                        CFT120
     C                   EVAL      DBKEY = 'CFT120'                                           CFT120
     C                   EVAL      DBFILE = 'SCSARDPD'                                        CFT120
     C                   EVAL      DBASE = 46                                                 CFT120
     C                   OUT       LDA                                                      MD029681
     C                   EXSR      *PSSR                                                      CFT120
     C                   ENDIF                                                                CFT120
                                                                                              CFT120
     C                   IF        PRTCD = *BLANKS                                            CFT120
     C                   EVAL      CFT120 = 'Y'                                               CFT120
     C                   ELSE                                                                 CFT120
     C                   EVAL      CFT120 = 'N'                                               CFT120
     C                   ENDIF                                                                CFT120
                                                                                             BUG4449
     C                   ENDSR                                                               BUG4449
      /EJECT                                                                                  CGL029
      *****************************************************************                       CGL029
      *                                                               *                       CGL029
      * SRFLGL - Sobroutine to assess full General Ledger.            *                       CGL029
      *                                                               *                       CGL029
      *****************************************************************                       CGL029
                                                                                              CGL029
     C     SRFLGL        BEGSR                                                                CGL029
                                                                                              CGL029
     C                   SELECT                                                              BUG3821
     C     C#ATYP        WHENEQ    'N'                                                       BUG3821
     C                   EVAL      C#NOSN = W#NOSN                                           BUG3821
     C     C#ATYP        WHENEQ    'F'                                                       BUG3821
     C                   EVAL      C#NOS  = W#NOS                                            BUG3821
     C     C#ATYP        WHENEQ    'R'                                                       BUG3821
     C                   EVAL      C#ACNO = W#ACNO                                           BUG3821
     C     C#ATYP        WHENEQ    'G'                                                       BUG3821
     C     C#ATYP        OREQ      'I'                                                      BUG23088
     C                   EVAL      C#CNU1 = W#CNU1                                            CGL029
     C                   EVAL      C#CCY1 = W#CCY1                                            CGL029
     C                   EVAL      C#ACO1 = W#ACO1                                            CGL029
     C                   EVAL      C#ACS1 = W#ACS1                                            CGL029
     C                   EVAL      C#BRC1 = W#BRC1                                            CGL029
     C*****C#ATYP        IFEQ      'I'                                            BUG23088 BUG23088A
     C**********         EVAL      C#ACS1 = W#ACSQ                                BUG23088 BUG23088A
     C**********         ENDIF                                                    BUG23088 BUG23088A
     C     C#ATYP        WHENEQ    'P'                                                       BUG3821
     C*******************EVAL      C#CNU1 = W#CNU1                                    BUG3821 240008
     C*******************EVAL      C#ACO1 = W#ACO1                                    BUG3821 240008
     C*******************EVAL      C#ACS1 = W#ACS1                                    BUG3821 240008
     C                   EVAL      C#CNUM = P#CNUM                                            240008
     C                   EVAL      C#ACSQ = P#ACSQ                                            240008
     C                   EVAL      C#BRCA = P#BRCA                                            240008
     C                   EVAL      C#ACOD = P#ACOD                                            240008
     C                   ENDSL                                                               BUG3821
      *
     C*******************EVAL      C#ACOD = W#ACOD                                    BUG3854 240008
     C*******************EVAL      C#ACSQ = W#ACSQ                                    BUG3854 240008
      *                                                                                      BUG3191
     C     C#ATYP        IFEQ      'R'                                                       BUG3191
     C                   MOVEL     C#ACCT        C#ACNO                                      BUG3191
     C                   END                                                                 BUG3191
                                                                                              CGL029
     C                   ENDSR                                                                CGL029
     C/COPY WNCPYSRC,FTH00424
                                                                                              CGL029
     C****************************************************************
      /EJECT
      *****************************************************************                       CFT157
     C*                                                              *                        CFT157
     C* Stop   - Stop a Trade                                        *                        CFT157
     C*                                                              *                        CFT157
     C****************************************************************                        CFT157
     C     Stop          BEGSR                                                                CFT157
                                                                                              CFT157
     C     OTPREF        CHAIN     OTPAYDDF                           99                      CFT157
     C   99              DO                                                                   CFT157
     C                   MOVE      'FTOPAYUPD'   DBPGM                                        CFT157
     C                   MOVE      'OTPAY'       DBFILE                                       CFT157
     C                   Z-ADD     255           DBASE                                        CFT157
     C                   MOVEL     OTPREF        DBKEY                                        CFT157
     C                   EXSR      *PSSR                                                      CFT157
     C                   END                                                                  CFT157
                                                                                              CFT157
     C                   If        (@CFT003 = 'Y') Or (@CFT014 = 'Y')                         CFT157
     C                             OR (@CFT009 = 'Y')                                         CFT157
     C     OTPREF        CHAIN     OTPAYXDF                           99                      CFT157
                                                                                              CFT157
      ** If CFT014 is installed, and the record is not found, dberr.                          CFT157
                                                                                              CFT157
     C                   If        @CFT014 = 'Y' And *IN99 = '1'                              CFT157
     C                   Movel     'OTPAYXL0'    DBFILE                                       CFT157
     C                   Movel     '437'         DBASE                                        CFT157
     C                   Movel     'OTPREF'      DBKEY                                        CFT157
     C                   ExSr      *PSSR                                                      CFT157
     C                   EndIf                                                                CFT157
     C                   EndIf                                                                CFT157
                                                                                              CFT157
     C                   Z-SUB     SMAM          ##SMAM                                       CFT157
     C                   Z-SUB     PYAM          ##PYAM                                       CFT157
     C                   If        (@CFT014 = 'Y') And (OPRCRM <> 0)                          CFT157
     C                   Eval      ##PYAM = ##PYAM - OPRCRM                                   CFT157
     C                   EndIf                                                                CFT157
     C                   EXSR      SRADDRev                                                   CFT157
      *                                                                                       CFT157
      * Calculate charge amount (always debit)                                                CFT157
      *                                                                                       CFT157
     C     TXCH          ADD       CQCH          ##CHGS                                       CFT157
     C                   ADD       CSTA          ##CHGS                                       CFT157
     C                   ADD       SPCH          ##CHGS                                       CFT157
     C                   ADD       MSCH          ##CHGS                                       CFT157
     C                   ADD       TRCM          ##CHGS                                       CFT157
     C*                                                                                       CFT157
     C     @01494        IFEQ      'Y'                                                        CFT157
     C                   ADD       OPCHCM        ##CHGS                                       CFT157
     C                   END                                                                  CFT157
     C*                                                                                       CFT157
     C     @01499        IFEQ      'Y'                                                        CFT157
     C     @CFT009       ANDEQ     'N'                                                        CFT157
     C     @CFT010       OREQ      'Y'                                                        CFT157
     C                   ADD       OPVATT        ##CHGS                                       CFT157
     C                   END                                                                  CFT157
                                                                                              CFT157
      * Extra charges                                                                         CFT157
                                                                                              CFT157
     C                   IF        @CFT009 = 'Y'                                              CFT157
     C                   ADD       MISC01        ##CHGS                                       CFT157
     C                   ADD       MISC02        ##CHGS                                       CFT157
     C                   ADD       MISC03        ##CHGS                                       CFT157
     C                   ADD       MISC04        ##CHGS                                       CFT157
     C                   ADD       MISC05        ##CHGS                                       CFT157
     C                   ADD       SWSCHG        ##CHGS                                       CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
      ** Include Receiver's Charges remitted, if present.                                     CFT157
                                                                                              CFT157
     C                   If        @CFT014 = 'Y'                                              CFT157
     C                   Select                                                               CFT157
     C                   When      CDRO <> *BLANKS                                            CFT157
     C                   Eval      ##CHGS = ##CHGS + OPRBCQ                                   CFT157
     C                   IF        CFT120 = 'Y'                                               CFT157
     C     UMCCY2        IfNe      BJCYCD                                                     CFT157
     C                   Eval      ##CHGS = ##CHGS - OPRBCQ                                   CFT157
      *                                                                                       CFT157
      ** Convert Receiver's charges remitted from pay ccy to charge ccy                       CFT157
     C                   Clear                   P#0010                                       CFT157
     C                   Z-Add     OTPVDT        P#FRDT                                       CFT157
     C                   Z-Add     OTSLDT        P#TODT                                       CFT157
     C                   Movel     OTPCCY        P#FRCY                                       CFT157
     C                   Z-Add     OPRCRM        P#FRAM                                       CFT157
     C                   Movel     UMCCY2        P#TOCY                                       CFT157
     C                   Z-Add     0             P#TOAM                                       CFT157
     C                   Z-Add     0             P#RATE                                       CFT157
     C                   Call      'FT0010'                                                   CFT157
     C                   Parm                    P#0010                                       CFT157
      *                                                                                       CFT157
     C     P#RTCD        IfNe      *Blank                                                     CFT157
     C                   Movel     'FT0010  '    DBFILE                                       CFT157
     C                   Movel     '*CALL  '     DBKEY                                        CFT157
     C                   Z-Add     491           DBASE                                        CFT157
     C                   ExSr      *PSSR                                                      CFT157
     C                   Else                                                                 CFT157
     C                   Z-Add     P#TOAM        UMRCRM                                       CFT157
      *                                                                                       CFT157
     C                   Endif                                                                CFT157
      *                                                                                       CFT157
     C                   Eval      ##CHGS = ##CHGS + UMRCRM                                   CFT157
     C                   Endif                                                                CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   When      ADDC = 'A'                                                 CFT157
     C                   Eval      ##CHGS = ##CHGS + OPRCSC                                   CFT157
     C                   EndSl                                                                CFT157
     C                   EndIf                                                                CFT157
      *                                                                                       CFT157
     C     ##CHGS        IFNE      0                                                          CFT157
     C                   Z-SUB     ##CHGS        ##CHGS                                       CFT157
      *                                                                                       CFT157
     C                   IF        CFT120 = 'Y'                                               CFT157
     C     OTCDRO        IFNE      *BLANKS                                                    CFT157
     C     OTCDRC        ANDNE     *BLANKS                                                    CFT157
     C                   MOVEL     OPCDRC        UM#CCY                                       CFT157
     C                   ENDIF                                                                CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   EXSR      SRSCHG                                                     CFT157
     C                   END                                                                  CFT157
      *                                                                                       CFT157
      * Save original Settle amount for trailer update                                        CFT157
     C                   Z-ADD     SMAM          OSMAM            13 0                        CFT157
      *                                                                                       CFT157
      * Update OTPAY record                                                                   CFT157
     C                   Move      ValidPmnt     NewPmnt                                      CFT157
      *                                                                                       CFT157
      ** Generate timestamp                                                                   CFT157
     C                   CALLB     'ZAGENTMSTM'                                               CFT157
     C                   PARM                    Timestamp                                    CFT157
                                                                                              CFT157
     C                   Eval      TMST = Timestamp                                           CFT157
     C                   Eval      RECI = 'C'                                                 CFT157
     C                   Z-ADD     BJRDNB        DATE                                         CFT157
      *                                                                                       CFT157
     C                   IF        CAP211 = 'Y' And PAuth = 'Y'                               CFT157
      *                                                                                       CFT157
     C                   IF        PUser = *Blanks                                            CFT157
     C                   EVAL      SAUS = SUSR                                                CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      SAUS = PUser                                               CFT157
     C                   ENDIF                                                                CFT157
     C                   EVAL      AUIN = 'Y'                                                 CFT157
      *                                                                                       CFT157
     C                   ELSE                                                                 CFT157
     C                   EVAL      AUIN = 'Y'                                                 CFT157
     C                   ENDIF                                                                CFT157
      *                                                                                       CFT157
     C                   UPDATE    OTPAYDDF                                                   CFT157
      *                                                                                       CFT157
      * Update Incoming Message FT Trans                                                      CFT157
      *                                                                                       CFT157
     C     OTOPMSGR      IFNE      0                                                          CFT157
     C                   MOVEL     'MIN0031'     W0FLAG                                       CFT157
     C                   MOVEL     'MIN0192'     W0LMSG                                       CFT157
     C                   END                                                                  CFT157
     C                   MOVEL     *BLANKS       PNWRK             6                          CFT157
     C                   EXSR      SRINFT                                                     CFT157
      *                                                                                       CFT157
     C                   ENDSR                                                                CFT157
      /EJECT                                                                                  CFT157
     C****************************************************************
     C/COPY ZACPYSRC,PSSR_ILE
      ********************************************************************
**  CPY@
(c) Finastra International Limited 2001
** FCTR
0001
0010
0100
1000
** POWERS
0000010
0000100
0001000
0010000
0100000
1000000
** WLARR - Watch List Fields                                                                  CSD015
<Destination>                      </Destination>                                             CSD015
<Ordering Bank>                    </Ordering Bank>                                           CSD015
<Ordering Customer>                </Ordering Customer>                                       CSD015
<Receivers Correspondent>          </Receivers Correspondent>                                 CSD015
<Account with Bank>                </Account with Bank>                                       CSD015
<Beneficiary>                      </Beneficiary>                                             CSD015
<Details of Payment>               </Details of Payment>                                      CSD015
<Intermediary Bank>                </Intermediary Bank>                                       CSD015
<MT100 Ordering Customer>          </MT100 Ordering Customer>                                 CSD015
<Third Reimbursement Institution>  </Third Reimbursement Institution>                         CSD015
<Senders Correspondent>            </Senders Correspondent>                                   CSD015
<Ordering Customer Cover>          </Ordering Customer Cover>                                 CSW209
<Ordering Bank Cover>              </Ordering Bank Cover>                                     CSW209
<Intermediary Bank Cover>          </Intermediary Bank Cover>                                 CSW209
<Account with Bank Cover>          </Account with Bank Cover>                                 CSW209
<Beneficiary Cover>                </Beneficiary Cover>                                       CSW209
<Details of Payment Cover>         </Details of Payment Cover>                                CSW209
